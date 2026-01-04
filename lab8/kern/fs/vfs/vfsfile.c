#include <defs.h>
#include <string.h>
#include <vfs.h>
#include <inode.h>
#include <unistd.h>
#include <error.h>
#include <assert.h>


// open file in vfs, get/create inode for file with filename path.
//在VFS层打开一个文件，具体而言是根据给定的路径和打开标志查找或创建对应的inode节点，并进行相应的初始化操作
int
vfs_open(char *path, uint32_t open_flags, struct inode **node_store) {
    bool can_write = 0;
    switch (open_flags & O_ACCMODE) {//根据不同的访问模式设置can_write标志
        case O_RDONLY:
            break;
        case O_WRONLY:
        case O_RDWR:
            can_write = 1;
            break;
        default:
            return -E_INVAL;
    }

    if (open_flags & O_TRUNC) {//如果打开标志中包含O_TRUNC，则文件必须是可写的。因为O_TRUNC表示在打开文件时将其截断为长度为0，这需要写权限
        if (!can_write) {
            return -E_INVAL;
        }
    }

    int ret; 
    struct inode *node;
    bool excl = (open_flags & O_EXCL) != 0;//如果打开标志中包含O_EXCL，则表示在创建文件时如果文件已经存在则返回错误。
    bool create = (open_flags & O_CREAT) != 0;//如果打开标志中包含O_CREAT，则表示如果文件不存在则创建该文件
    ret = vfs_lookup(path, &node);//根据路径查找对应的inode节点，正常返回为0

    if (ret != 0) {
        if (ret == -16 && (create)) {//这里我们遇到了文件不存在的情况（ret==-16，而这个-16是-E_NO_ENT），并且打开标志中包含O_CREAT，则需要创建新文件
            char *name;
            struct inode *dir;
            if ((ret = vfs_lookup_parent(path, &dir, &name)) != 0) {//查找父目录的inode节点
                return ret;
            }
            ret = vop_create(dir, name, excl, &node);//在父目录中创建新文件
        } else return ret;
    } else if (excl && create) {//如果文件已经存在，并且打开标志中同时包含O_EXCL和O_CREAT，则返回错误（防止覆盖已存在的文件）
        return -E_EXISTS;
    }
    assert(node != NULL);
    
    if ((ret = vop_open(node, open_flags)) != 0) {//如果打开文件失败，则减少inode节点的引用计数并返回错误码
        vop_ref_dec(node);
        return ret;
    }

    vop_open_inc(node);
    if (open_flags & O_TRUNC || create) {//如果打开标志中包含O_TRUNC或者文件是新创建的，则将文件截断为长度为0
        if ((ret = vop_truncate(node, 0)) != 0) {//截断文件失败，则关闭文件并减少inode节点的引用计数
            vop_open_dec(node);
            vop_ref_dec(node);
            return ret;
        }
    }
    *node_store = node;//存储找到或创建的inode节点
    return 0;
}

// close file in vfs
//关闭一个文件，具体而言是减少该文件对应的inode节点的打开计数和引用计数
int
vfs_close(struct inode *node) {
    vop_open_dec(node);
    vop_ref_dec(node);
    return 0;
}

// unimplement
int
vfs_unlink(char *path) {
    return -E_UNIMP;
}

// unimplement
int
vfs_rename(char *old_path, char *new_path) {
    return -E_UNIMP;
}

// unimplement
int
vfs_link(char *old_path, char *new_path) {
    return -E_UNIMP;
}

// unimplement
int
vfs_symlink(char *old_path, char *new_path) {
    return -E_UNIMP;
}

// unimplement
int
vfs_readlink(char *path, struct iobuf *iob) {
    return -E_UNIMP;
}

// unimplement
int
vfs_mkdir(char *path){
    return -E_UNIMP;
}
