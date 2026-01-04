#include <defs.h>
#include <kmalloc.h>
#include <sem.h>
#include <vfs.h>
#include <dev.h>
#include <file.h>
#include <sfs.h>
#include <inode.h>
#include <assert.h>
//called when init_main proc start
void
fs_init(void) {
    vfs_init();//初始化VFS相关数据结构（例如信号量）
    dev_init();//初始化底层设备，例如磁盘、控制台等
    sfs_init();//调用sfs_mount函数挂载sfs文件系统到disk0上
}

void
fs_cleanup(void) {
    vfs_cleanup();
}

void
lock_files(struct files_struct *filesp) {
    down(&(filesp->files_sem));
}

void
unlock_files(struct files_struct *filesp) {
    up(&(filesp->files_sem));
}
//Called when a new proc init
struct files_struct *
files_create(void) {
    //cprintf("[files_create]\n");
    //static_assert((int)FILES_STRUCT_NENTRY > 128);
    struct files_struct *filesp;//分配files_struct结构体的内存空间，并初始化其成员变量
    if ((filesp = kmalloc(sizeof(struct files_struct) + FILES_STRUCT_BUFSIZE)) != NULL) {//如果分配成功，则初始化成员变量
        filesp->pwd = NULL;
        filesp->fd_array = (void *)(filesp + 1);
        filesp->files_count = 0;
        sem_init(&(filesp->files_sem), 1);//初始化信号量，初始值为1
        fd_array_init(filesp->fd_array);//初始化文件描述符数组
    }
    return filesp;
}
//Called when a proc exit
void
files_destroy(struct files_struct *filesp) {
//    cprintf("[files_destroy]\n");
    assert(filesp != NULL && files_count(filesp) == 0);
    if (filesp->pwd != NULL) {//释放当前工作目录的inode节点
        vop_ref_dec(filesp->pwd);//减少引用计数
    }
    int i;
    struct file *file = filesp->fd_array;//遍历文件描述符数组，关闭所有打开的文件项
    for (i = 0; i < FILES_STRUCT_NENTRY; i ++, file ++) {
        if (file->status == FD_OPENED) {
            fd_array_close(file);
        }
        assert(file->status == FD_NONE);
    }
    kfree(filesp);
}

void
files_closeall(struct files_struct *filesp) {//用于关闭当前进程打开的所有文件项
//    cprintf("[files_closeall]\n");
    assert(filesp != NULL && files_count(filesp) > 0);
    int i;
    struct file *file = filesp->fd_array;
    //skip the stdin & stdout
    for (i = 2, file += 2; i < FILES_STRUCT_NENTRY; i ++, file ++) {
        if (file->status == FD_OPENED) {
            fd_array_close(file);
        }
    }
}

int
dup_files(struct files_struct *to, struct files_struct *from) {//用于复制文件结构体from到to
//    cprintf("[dup_fs]\n");
    assert(to != NULL && from != NULL);
    assert(files_count(to) == 0 && files_count(from) > 0);
    if ((to->pwd = from->pwd) != NULL) {//复制当前工作目录的inode节点，并增加引用计数
        vop_ref_inc(to->pwd);//增加引用计数
    }
    int i;
    struct file *to_file = to->fd_array, *from_file = from->fd_array;//遍历文件描述符数组，复制所有打开的文件项
    for (i = 0; i < FILES_STRUCT_NENTRY; i ++, to_file ++, from_file ++) {//复制文件项
        if (from_file->status == FD_OPENED) {//如果源文件项的状态为FD_OPENED，则调用fd_array_dup函数复制该文件项到目标文件项
            /* alloc_fd first */
            to_file->status = FD_INIT;
            fd_array_dup(to_file, from_file);
        }
    }
    return 0;
}

