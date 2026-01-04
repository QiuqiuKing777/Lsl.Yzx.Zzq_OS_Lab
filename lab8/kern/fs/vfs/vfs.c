#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <vfs.h>
#include <inode.h>
#include <sem.h>
#include <kmalloc.h>
#include <error.h>
#include <proc.h>
static semaphore_t bootfs_sem;
static struct inode *bootfs_node = NULL;

extern void vfs_devlist_init(void);

// __alloc_fs - allocate memory for fs, and set fs type
//用于分配并初始化一个文件系统结构体
struct fs *
__alloc_fs(int type) {
    struct fs *fs;
    if ((fs = kmalloc(sizeof(struct fs))) != NULL) {
        fs->fs_type = type;
    }
    return fs;
}

// vfs_init -  vfs initialize
//用于初始化VFS相关数据结构
void
vfs_init(void) {
    sem_init(&bootfs_sem, 1);
    vfs_devlist_init();
}

// lock_bootfs - lock  for bootfs
//用于锁定bootfs相关操作,bootfs是系统启动时使用的根文件系统
static void
lock_bootfs(void) {
    down(&bootfs_sem);
}
// ulock_bootfs - ulock for bootfs
static void
unlock_bootfs(void) {
    up(&bootfs_sem);
}

// change_bootfs - set the new fs inode 
//用于更改bootfs的根目录inode节点
static void
change_bootfs(struct inode *node) {
    struct inode *old;
    lock_bootfs();
    {
        old = bootfs_node, bootfs_node = node;//保存旧的bootfs节点，并更新为新的节点
    }
    unlock_bootfs();
    if (old != NULL) {
        vop_ref_dec(old);
    }
}

// vfs_set_bootfs - change the dir of file system
//用于设置bootfs的根目录inode节点，参数为路径字符串
int
vfs_set_bootfs(char *fsname) {
    struct inode *node = NULL;
    if (fsname != NULL) {
        char *s;
        if ((s = strchr(fsname, ':')) == NULL || s[1] != '\0') {
            return -E_INVAL;
        }
        int ret;
        if ((ret = vfs_chdir(fsname)) != 0) {
            return ret;
        }
        if ((ret = vfs_get_curdir(&node)) != 0) {
            return ret;
        }
    }
    change_bootfs(node);
    return 0;
}

// vfs_get_bootfs - get the inode of bootfs
//用于获取bootfs的根目录inode节点
int
vfs_get_bootfs(struct inode **node_store) {
    struct inode *node = NULL;
    if (bootfs_node != NULL) {
        lock_bootfs();
        {
            if ((node = bootfs_node) != NULL) {
                vop_ref_inc(bootfs_node);
            }
        }
        unlock_bootfs();
    }
    if (node == NULL) {
        return -E_NOENT;
    }
    *node_store = node;
    return 0;
}

