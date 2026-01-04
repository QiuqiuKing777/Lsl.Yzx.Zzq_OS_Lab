#include <defs.h>
#include <string.h>
#include <vfs.h>
#include <proc.h>
#include <file.h>
#include <unistd.h>
#include <iobuf.h>
#include <inode.h>
#include <stat.h>
#include <dirent.h>
#include <error.h>
#include <assert.h>

#define testfd(fd)                          ((fd) >= 0 && (fd) < FILES_STRUCT_NENTRY)

// get_fd_array - get current process's open files table
//用来获取当前进程的文件描述符数组，具体操作是通过current指针获取当前进程的files_struct结构体，然后返回其中的fd_array成员
static struct file *
get_fd_array(void) {
    struct files_struct *filesp = current->filesp;
    assert(filesp != NULL && files_count(filesp) > 0);
    return filesp->fd_array;
}

// fd_array_init - initialize the open files table
//用来初始化文件描述符数组，具体操作是将每个文件描述符的状态设为FD_NONE，表示未使用
void
fd_array_init(struct file *fd_array) {
    int fd;
    struct file *file = fd_array;
    for (fd = 0; fd < FILES_STRUCT_NENTRY; fd ++, file ++) {
        file->open_count = 0;
        file->status = FD_NONE, file->fd = fd;
    }
}

// fs_array_alloc - allocate a free file item (with FD_NONE status) in open files table
//用于在文件描述符数组中分配一个空闲的文件项，具体操作是遍历文件描述符数组，找到第一个状态为FD_NONE的文件项，并将其状态设为FD_INIT，表示已初始化
static int
fd_array_alloc(int fd, struct file **file_store) {
    //panic("debug");
    struct file *file = get_fd_array();
    if (fd == NO_FD) {//如果传入的fd为NO_FD，则表示需要分配一个新的文件描述符
        for (fd = 0; fd < FILES_STRUCT_NENTRY; fd ++, file ++) {//FILES_STRUCT_NENTRY表示文件描述符数组的大小
            if (file->status == FD_NONE) {//找到第一个状态为FD_NONE的文件项，FD_NONE表示该文件项未被使用
                goto found;
            }
        }
        return -E_MAX_OPEN;
    }
    else {//如果传入的fd不为NO_FD，则表示需要分配指定的文件描述符，我们先检查该fd是否合法，如果合法则检查对应的文件项是否为空闲状态，然后进行分配
        if (testfd(fd)) {
            file += fd;
            if (file->status == FD_NONE) {
                goto found;
            }
            return -E_BUSY;
        }
        return -E_INVAL;
    }
found:
    assert(fopen_count(file) == 0);
    file->status = FD_INIT, file->node = NULL;//初始化文件项的状态为FD_INIT，节点指针设为NULL
    *file_store = file;//将分配的文件项通过file_store参数返回
    return 0;
}

// fd_array_free - free a file item in open files table
//释放文件描述符数组中的一个文件项，具体操作是检查文件项的状态是否为FD_INIT或FD_CLOSED，并且打开计数为0，如果状态为FD_CLOSED，则调用vfs_close函数关闭对应的节点，最后将文件项的状态设为FD_NONE，表示未使用
static void
fd_array_free(struct file *file) {
    assert(file->status == FD_INIT || file->status == FD_CLOSED);
    assert(fopen_count(file) == 0);
    if (file->status == FD_CLOSED) {
        vfs_close(file->node);
    }
    file->status = FD_NONE;
}

//用于增加文件项的打开计数，确保文件项处于FD_OPENED状态
static void
fd_array_acquire(struct file *file) {
    assert(file->status == FD_OPENED);
    fopen_count_inc(file);
}

// fd_array_release - file's open_count--; if file's open_count-- == 0 , then call fd_array_free to free this file item
//用于释放文件项，具体操作是检查文件项的状态是否为FD_OPENED或FD_CLOSED，并且打开计数大于0，然后将打开计数减1，如果减1后计数为0，则调用fd_array_free函数释放该文件项
static void
fd_array_release(struct file *file) {
    assert(file->status == FD_OPENED || file->status == FD_CLOSED);
    assert(fopen_count(file) > 0);
    if (fopen_count_dec(file) == 0) {
        fd_array_free(file);
    }
}

// fd_array_open - file's open_count++, set status to FD_OPENED
//用于打开文件项，具体操作是检查文件项的状态是否为FD_INIT，并且节点指针不为NULL，然后将状态设为FD_OPENED，并将打开计数加1
void
fd_array_open(struct file *file) {
    assert(file->status == FD_INIT && file->node != NULL);
    file->status = FD_OPENED;
    fopen_count_inc(file);
}

// fd_array_close - file's open_count--; if file's open_count-- == 0 , then call fd_array_free to free this file item
//用于关闭文件项，具体操作是检查文件项的状态是否为FD_OPENED，并且打开计数大于0，然后将状态设为FD_CLOSED，并将打开计数减1，如果减1后计数为0，则调用fd_array_free函数释放该文件项
void
fd_array_close(struct file *file) {
    assert(file->status == FD_OPENED);
    assert(fopen_count(file) > 0);
    file->status = FD_CLOSED;
    if (fopen_count_dec(file) == 0) {
        fd_array_free(file);
    }
}

//fs_array_dup - duplicate file 'from'  to file 'to'
//用于复制文件项，具体操作是检查目标文件项的状态是否为FD_INIT，源文件项的状态是否为FD_OPENED，然后将目标文件项的各个属性（位置、可读性、可写性）设置为源文件项的对应属性，并增加节点的引用计数和打开计数，最后调用fd_array_open函数打开目标文件项
void
fd_array_dup(struct file *to, struct file *from) {
    //cprintf("[fd_array_dup]from fd=%d, to fd=%d\n",from->fd, to->fd);
    assert(to->status == FD_INIT && from->status == FD_OPENED);
    to->pos = from->pos;
    to->readable = from->readable;
    to->writable = from->writable;
    struct inode *node = from->node;
    vop_ref_inc(node), vop_open_inc(node);
    to->node = node;
    fd_array_open(to);
}

// fd2file - use fd as index of fd_array, return the array item (file)
//用于将文件描述符转换为对应的文件项，具体操作是检查文件描述符是否合法，然后获取对应的文件项，如果文件项的状态为FD_OPENED并且文件描述符匹配，则通过file_store参数返回该文件项，否则返回-E_INVAL错误码
static inline int
fd2file(int fd, struct file **file_store) {
    if (testfd(fd)) {
        struct file *file = get_fd_array() + fd;
        if (file->status == FD_OPENED && file->fd == fd) {
            *file_store = file;
            return 0;
        }
    }
    return -E_INVAL;
}

// file_testfd - test file is readble or writable?
//用于测试文件描述符对应的文件项是否具有指定的可读性和可写性，具体操作是通过fd2file函数获取文件项，然后根据传入的readable和writable参数检查文件项的可读性和可写性，如果满足条件则返回1，否则返回0
bool
file_testfd(int fd, bool readable, bool writable) {
    int ret;
    struct file *file;
    if ((ret = fd2file(fd, &file)) != 0) {
        return 0;
    }
    if (readable && !file->readable) {
        return 0;
    }
    if (writable && !file->writable) {
        return 0;
    }
    return 1;
}

// open file
//用于打开文件，具体操作是根据传入的路径和打开标志，确定文件的可读性和可写性，然后调用fd_array_alloc函数分配一个文件项，如果分配失败则返回错误码；接着调用vfs_open函数打开指定路径的文件节点，如果打开失败则释放分配的文件项并返回错误码；然后初始化文件项的位置，如果打开标志包含O_APPEND，则获取文件的状态信息并将位置设为文件大小；最后设置文件项的各个属性，并调用fd_array_open函数打开文件项，最后返回文件描述符
int
file_open(char *path, uint32_t open_flags) {
    bool readable = 0, writable = 0;
    //首先根据open_flags参数确定文件的可读性和可写性
    switch (open_flags & O_ACCMODE) {
        case O_RDONLY: readable = 1; break;
        case O_WRONLY: writable = 1; break;
        case O_RDWR:
            readable = writable = 1;
            break;
        default:
            return -E_INVAL;//如果访问模式不合法，则返回-E_INVAL错误码
    }
    int ret;
    struct file *file;
    if ((ret = fd_array_alloc(NO_FD, &file)) != 0) {//分配文件项
        return ret;
    }
    struct inode *node;
    if ((ret = vfs_open(path, open_flags, &node)) != 0) {//打开文件节点
        fd_array_free(file);//如果打开失败则释放文件项
        return ret;
    }
    file->pos = 0;//初始化文件位置
    if (open_flags & O_APPEND) {//如果包含O_APPEND标志，则将位置设为文件大小，说明是在文件末尾追加内容
        struct stat __stat, *stat = &__stat;//获取文件状态信息
        if ((ret = vop_fstat(node, stat)) != 0) {//获取文件状态失败
            vfs_close(node);//关闭文件节点
            fd_array_free(file);//释放文件项
            return ret;
        }
        file->pos = stat->st_size;//将位置设为文件大小，这里是因为我们要在文件末尾追加内容“写”
    }
    file->node = node;
    file->readable = readable;
    file->writable = writable;
    fd_array_open(file);//打开文件项
    return file->fd;
}

// close file
int
file_close(int fd) {
    int ret;
    struct file *file;
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    fd_array_close(file);
    return 0;
}

// read file
int
file_read(int fd, void *base, size_t len, size_t *copied_store) {
    // read file
    //用于读取文件
    int ret;
    struct file *file;
    *copied_store = 0;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后检查文件项是否可读，如果不可读则返回-E_INVAL错误码
    if (!file->readable) {
        return -E_INVAL;
    }
    //接着调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);

    //然后初始化一个iobuf结构体，用于存储读取的数据
    struct iobuf __iob, *iob = iobuf_init(&__iob, base, len, file->pos);
    //并调用vop_read函数从文件节点读取数据到iobuf中
    ret = vop_read(file->node, iob);//这里的vop_read实际上是调用了函数sfs_read或者dev_read，具体取决于文件节点对应的文件系统类型。对于这个文件的话，我们调用的是sfs_read函数，然后进一步调用了sfs_io函数，最终调用了sfs_io_nolock函数来实现具体的读操作。

    //读取完成后，获取实际读取的字节数
    size_t copied = iobuf_used(iob);
    //如果文件项的状态为FD_OPENED，则更新文件位置，将位置加上实际读取的字节数
    if (file->status == FD_OPENED) {
        file->pos += copied;
    }
    //最后通过copied_store参数返回实际读取的字节数，并调用fd_array_release函数释放文件项
    *copied_store = copied;
    fd_array_release(file);
    return ret;
}
int
file_write(int fd, void *base, size_t len, size_t *copied_store) {
    // write file
    //用于写入文件
    int ret;
    struct file *file;
    *copied_store = 0;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后检查文件项是否可写，如果不可写则返回-E_INVAL错误码
    if (!file->writable) {
        return -E_INVAL;
    }
    //接着调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);

    //然后初始化一个iobuf结构体，用于存储要写入的数据
    struct iobuf __iob, *iob = iobuf_init(&__iob, base, len, file->pos);
    //并调用vop_write函数将数据从iobuf写入到文件节点
    ret = vop_write(file->node, iob);

    //写入完成后，获取实际写入的字节数
    size_t copied = iobuf_used(iob);
    //如果文件项的状态为FD_OPENED，则更新文件位置
    if (file->status == FD_OPENED) {
        file->pos += copied;
    }
    //最后通过copied_store参数返回实际写入的字节数，并调用fd_array_release函数释放文件项
    *copied_store = copied;
    fd_array_release(file);
    return ret;
}

int
file_seek(int fd, off_t pos, int whence) {
    // seek file
    //用于查找文件位置
    struct stat __stat, *stat = &__stat;
    int ret;
    struct file *file;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);

    //根据传入的whence参数，计算新的文件位置
    switch (whence) {
        case LSEEK_SET: break;//如果whence为LSEEK_SET，则位置设为pos
        case LSEEK_CUR: pos += file->pos; break;//如果whence为LSEEK_CUR，则位置设为当前文件位置加pos
        case LSEEK_END://如果whence为LSEEK_END，则获取文件的状态信息并将位置设为文件大小加pos
            if ((ret = vop_fstat(file->node, stat)) == 0) {
                pos += stat->st_size;
            }
            break;
        default: ret = -E_INVAL;//如果whence不合法，则返回-E_INVAL错误码
    }

    if (ret == 0) {
        //接着调用vop_tryseek函数尝试设置新的文件位置
        if ((ret = vop_tryseek(file->node, pos)) == 0) {
            //如果成功则更新文件项的位置
            file->pos = pos;
        }
//    cprintf("file_seek, pos=%d, whence=%d, ret=%d\n", pos, whence, ret);
    }
    //最后调用fd_array_release函数释放文件项，并返回结果
    fd_array_release(file);
    return ret;
}

int
file_fstat(int fd, struct stat *stat) {
    // stat file
    //用于获取文件状态信息
    int ret;
    struct file *file;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);
    //接着调用vop_fstat函数获取文件节点的状态信息，并通过stat参数返回
    ret = vop_fstat(file->node, stat);
    //最后调用fd_array_release函数释放文件项，并返回结果
    fd_array_release(file);
    return ret;
}

int
file_fsync(int fd) {
    // sync file
    //用于同步文件内容到存储设备
    int ret;
    struct file *file;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);
    //接着调用vop_fsync函数将文件节点的内容同步到存储设备
    ret = vop_fsync(file->node);
    //最后调用fd_array_release函数释放文件项，并返回结果
    fd_array_release(file);
    return ret;
}

int
file_getdirentry(int fd, struct dirent *direntp) {
    // get file entry in DIR
    //用于获取目录中的文件项
    int ret;
    struct file *file;
    //具体操作是通过fd2file函数获取文件项
    if ((ret = fd2file(fd, &file)) != 0) {
        return ret;
    }
    //然后调用fd_array_acquire函数增加文件项的打开计数
    fd_array_acquire(file);

    //接着初始化一个iobuf结构体，用于存储目录项的数据
    struct iobuf __iob, *iob = iobuf_init(&__iob, direntp->name, sizeof(direntp->name), direntp->offset);
    //并调用vop_getdirentry函数从文件节点获取目录项数据到iobuf中
    if ((ret = vop_getdirentry(file->node, iob)) == 0) {
        //获取完成后，更新direntp结构体中的偏移量
        direntp->offset += iobuf_used(iob);
    }
    //最后调用fd_array_release函数释放文件项，并返回结果
    fd_array_release(file);
    return ret;
}

int
file_dup(int fd1, int fd2) {
    // duplicate file
    //用于复制文件描述符
    int ret;
    struct file *file1, *file2;
    //具体操作是通过fd2file函数获取源文件项
    if ((ret = fd2file(fd1, &file1)) != 0) {
        return ret;
    }
    //然后调用fd_array_alloc函数分配目标文件项；如果分配失败则返回错误码
    if ((ret = fd_array_alloc(fd2, &file2)) != 0) {
        return ret;
    }
    //接着调用fd_array_dup函数将源文件项复制到目标文件项
    fd_array_dup(file2, file1);
    //最后返回目标文件项的文件描述符
    return file2->fd;
}


