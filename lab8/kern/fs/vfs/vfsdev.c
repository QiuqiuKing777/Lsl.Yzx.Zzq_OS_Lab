#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <vfs.h>
#include <dev.h>
#include <inode.h>
#include <sem.h>
#include <list.h>
#include <kmalloc.h>
#include <unistd.h>
#include <error.h>
#include <assert.h>
#include <proc.h>
// device info entry in vdev_list 
typedef struct {
    const char *devname;
    struct inode *devnode;
    struct fs *fs;
    bool mountable;
    list_entry_t vdev_link;
} vfs_dev_t;

#define le2vdev(le, member)                         \
    to_struct((le), vfs_dev_t, member)

static list_entry_t vdev_list;     // device info list in vfs layer
static semaphore_t vdev_list_sem;

static void
lock_vdev_list(void) {
    down(&vdev_list_sem);
}

static void
unlock_vdev_list(void) {
    up(&vdev_list_sem);
}

void
vfs_devlist_init(void) {
    list_init(&vdev_list);
    sem_init(&vdev_list_sem, 1);
}

// vfs_cleanup - finally clean (or sync) fs
//用于卸载所有文件系统并清理VFS层的数据结构，具体而言就是调用每个挂载的文件系统的清理函数fsop_cleanup
void
vfs_cleanup(void) {
    if (!list_empty(&vdev_list)) {
        lock_vdev_list();
        {
            list_entry_t *list = &vdev_list, *le = list;
            while ((le = list_next(le)) != list) {
                vfs_dev_t *vdev = le2vdev(le, vdev_link);
                if (vdev->fs != NULL) {
                    fsop_cleanup(vdev->fs);
                }
            }
        }
        unlock_vdev_list();
    }
}

/*
 * vfs_get_root - Given a device name (stdin, stdout, etc.), hand
 *                back an appropriate inode.
 */
//用于根据设备名称查找对应的设备节点的根inode，具体而言是遍历vdev_list列表，找到与给定设备名称匹配的设备，并返回其根inode
int
vfs_get_root(const char *devname, struct inode **node_store) {
    assert(devname != NULL);
    int ret = -E_NO_DEV;
    if (!list_empty(&vdev_list)) {
        lock_vdev_list();
        {
            list_entry_t *list = &vdev_list, *le = list;
            while ((le = list_next(le)) != list) {
                vfs_dev_t *vdev = le2vdev(le, vdev_link);
                if (strcmp(devname, vdev->devname) == 0) {
                    struct inode *found = NULL;
                    if (vdev->fs != NULL) {//如果设备已经挂载了文件系统，则获取该文件系统的根节点
                        found = fsop_get_root(vdev->fs);
                    }
                    else if (!vdev->mountable) {//如果设备没有挂载文件系统且不是可挂载设备，则直接使用设备节点作为根节点
                        vop_ref_inc(vdev->devnode);
                        found = vdev->devnode;
                    }
                    if (found != NULL) {//找到了对应的根节点
                        ret = 0, *node_store = found;
                    }
                    else {
                        ret = -E_NA_DEV;
                    }
                    break;
                }
            }
        }
        unlock_vdev_list();
    }
    return ret;
}

/*
 * vfs_get_devname - Given a filesystem, hand back the name of the device it's mounted on.
 */
//用于根据给定的文件系统查找其挂载的设备名称，具体而言是遍历vdev_list列表，找到与给定文件系统匹配的设备，并返回其名称
const char *
vfs_get_devname(struct fs *fs) {
    assert(fs != NULL);
    list_entry_t *list = &vdev_list, *le = list;
    while ((le = list_next(le)) != list) {
        vfs_dev_t *vdev = le2vdev(le, vdev_link);
        if (vdev->fs == fs) {
            return vdev->devname;//返回找到的设备名称
        }
    }
    return NULL;
}

/*
 * check_devname_confilct - Is there alreadily device which has the same name?
 */
//用于检查给定的设备名称是否已经存在于vdev_list列表中，具体而言是遍历列表，比较每个设备的名称与给定名称是否相同
static bool
check_devname_conflict(const char *devname) {
    list_entry_t *list = &vdev_list, *le = list;
    while ((le = list_next(le)) != list) {
        vfs_dev_t *vdev = le2vdev(le, vdev_link);
        if (strcmp(vdev->devname, devname) == 0) {
            return 0;
        }
    }
    return 1;
}


/*
* vfs_do_add - Add a new device to the VFS layer's device table.
*
* If "mountable" is set, the device will be treated as one that expects
* to have a filesystem mounted on it, and a raw device will be created
* for direct access.
*/
//用于向VFS层的设备表中添加一个新的设备或文件系统，具体而言是创建一个vfs_dev_t结构体来存储设备信息，并将其添加到vdev_list列表中
static int
vfs_do_add(const char *devname, struct inode *devnode, struct fs *fs, bool mountable) {
    assert(devname != NULL);
    assert((devnode == NULL && !mountable) || (devnode != NULL && check_inode_type(devnode, device)));
    if (strlen(devname) > FS_MAX_DNAME_LEN) {
        return -E_TOO_BIG;
    }

    int ret = -E_NO_MEM;
    char *s_devname;
    if ((s_devname = strdup(devname)) == NULL) {
        return ret;
    }

    vfs_dev_t *vdev;
    if ((vdev = kmalloc(sizeof(vfs_dev_t))) == NULL) {
        goto failed_cleanup_name;
    }

    ret = -E_EXISTS;
    lock_vdev_list();
    if (!check_devname_conflict(s_devname)) {//检查设备名称是否冲突
        unlock_vdev_list();
        goto failed_cleanup_vdev;
    }
    //初始化vdev结构体的各个字段
    vdev->devname = s_devname;
    vdev->devnode = devnode;
    vdev->mountable = mountable;
    vdev->fs = fs;

    list_add(&vdev_list, &(vdev->vdev_link));
    unlock_vdev_list();
    return 0;

failed_cleanup_vdev:
    kfree(vdev);
failed_cleanup_name:
    kfree(s_devname);
    return ret;
}

/*
 * vfs_add_fs - Add a new fs,  by name. See  vfs_do_add information for the description of
 *              mountable.
 */
int
vfs_add_fs(const char *devname, struct fs *fs) {//一层封装
    return vfs_do_add(devname, NULL, fs, 0);
}

/*
 * vfs_add_dev - Add a new device, by name. See  vfs_do_add information for the description of
 *               mountable.
 */
int
vfs_add_dev(const char *devname, struct inode *devnode, bool mountable) {//一层封装
    return vfs_do_add(devname, devnode, NULL, mountable);
}

/*
 * find_mount - Look for a mountable device named DEVNAME.
 *              Should already hold vdev_list lock.
 */
//用于在vdev_list列表中查找一个可挂载的设备，该设备的名称与给定的devname匹配。如果找到则将其存储在vdev_store指针所指向的位置
static int
find_mount(const char *devname, vfs_dev_t **vdev_store) {
    assert(devname != NULL);
    list_entry_t *list = &vdev_list, *le = list;
    while ((le = list_next(le)) != list) {
        vfs_dev_t *vdev = le2vdev(le, vdev_link);
        if (vdev->mountable && strcmp(vdev->devname, devname) == 0) {
            *vdev_store = vdev;//将找到的设备存储在vdev_store指针所指向的位置
            return 0;
        }
    }
    return -E_NO_DEV;
}

/*
 * vfs_mount - Mount a filesystem. Once we've found the device, call MOUNTFUNC to
 *             set up the filesystem and hand back a struct fs.
 *
 * The DATA argument is passed through unchanged to MOUNTFUNC.
 */
//用于挂载一个文件系统，具体而言是根据给定的设备名称查找对应的设备，并调用提供的挂载函数将文件系统挂载到该设备上
int
vfs_mount(const char *devname, int (*mountfunc)(struct device *dev, struct fs **fs_store)) {
    int ret;
    lock_vdev_list();
    vfs_dev_t *vdev;//这个是要挂载的设备，devname是设备名，我们需要将devname对应的设备挂载上去
    if ((ret = find_mount(devname, &vdev)) != 0) {//如果找不到设备名对应的设备，则返回错误码
        goto out;
    }
    if (vdev->fs != NULL) {
        ret = -E_BUSY;
        goto out;
    }
    assert(vdev->devname != NULL && vdev->mountable);
    //调用挂载函数将文件系统挂载到设备上
    struct device *dev = vop_info(vdev->devnode, device);//获取设备节点对应的底层设备结构体
    if ((ret = mountfunc(dev, &(vdev->fs))) == 0) {//这里的mountfunc是具体的挂载函数，例如sfs_mount，我们根据不同的文件系统类型传入不同的挂载函数
        assert(vdev->fs != NULL);
        cprintf("vfs: mount %s.\n", vdev->devname);
    }

out:
    unlock_vdev_list();
    return ret;
}

/*
 * vfs_unmount - Unmount a filesystem/device by name.
 *               First calls FSOP_SYNC on the filesystem; then calls FSOP_UNMOUNT.
 */
//用于卸载一个文件系统，具体而言是根据给定的设备名称查找对应的设备，调用文件系统的同步函数fsop_sync将所有脏数据写回磁盘，然后调用卸载函数fsop_unmount将文件系统卸载
int
vfs_unmount(const char *devname) {
    int ret;
    lock_vdev_list();
    vfs_dev_t *vdev;
    if ((ret = find_mount(devname, &vdev)) != 0) {//找不到设备名对应的设备
        goto out;
    }
    if (vdev->fs == NULL) {
        ret = -E_INVAL;
        goto out;
    }
    assert(vdev->devname != NULL && vdev->mountable);

    if ((ret = fsop_sync(vdev->fs)) != 0) {//先调用fsop_sync同步文件系统，将所有脏数据写回磁盘
        goto out;
    }
    if ((ret = fsop_unmount(vdev->fs)) == 0) {//再调用fsop_unmount卸载文件系统
        vdev->fs = NULL;
        cprintf("vfs: unmount %s.\n", vdev->devname);
    }

out:
    unlock_vdev_list();
    return ret;
}

/*
 * vfs_unmount_all - Global unmount function.
 */
//用于卸载所有挂载的文件系统。具体而言是遍历vdev_list列表，对于每个可挂载且已经挂载了文件系统的设备，调用其文件系统的同步函数fsop_sync和卸载函数fsop_unmount将其卸载
int
vfs_unmount_all(void) {
    if (!list_empty(&vdev_list)) {
        lock_vdev_list();
        {
            list_entry_t *list = &vdev_list, *le = list;
            while ((le = list_next(le)) != list) {
                vfs_dev_t *vdev = le2vdev(le, vdev_link);
                if (vdev->mountable && vdev->fs != NULL) {
                    int ret;
                    if ((ret = fsop_sync(vdev->fs)) != 0) {//先调用fsop_sync同步文件系统，将所有脏数据写回磁盘，正常会返回0。
                        cprintf("vfs: warning: sync failed for %s: %e.\n", vdev->devname, ret);
                        continue ;
                    }
                    if ((ret = fsop_unmount(vdev->fs)) != 0) {//再调用fsop_unmount卸载文件系统，正常会返回0。
                        cprintf("vfs: warning: unmount failed for %s: %e.\n", vdev->devname, ret);
                        continue ;
                    }
                    vdev->fs = NULL;
                    cprintf("vfs: unmount %s.\n", vdev->devname);
                }
            }
        }
        unlock_vdev_list();
    }
    return 0;
}

