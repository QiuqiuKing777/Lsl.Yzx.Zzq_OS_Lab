#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <kmalloc.h>
#include <list.h>
#include <fs.h>
#include <vfs.h>
#include <dev.h>
#include <sfs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>
#include <proc.h>
/*
 * sfs_sync - sync sfs's superblock and freemap in memroy into disk
 */
//用于将内存中的超级块和空闲块映射同步到磁盘
static int
sfs_sync(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    lock_sfs_fs(sfs);//加锁，防止并发访问sfs文件系统结构体
    {   //同步所有已加载的inode节点到磁盘
        list_entry_t *list = &(sfs->inode_list), *le = list;
        //遍历inode链表，将每个inode节点的数据同步到磁盘
        while ((le = list_next(le)) != list) {
            struct sfs_inode *sin = le2sin(le, inode_link);//获取inode节点指针
            vop_fsync(info2node(sin, sfs_inode));//同步inode节点数据到磁盘
        }
    }
    unlock_sfs_fs(sfs);

    int ret;
    if (sfs->super_dirty) {//如果超级块被修改过，则需要同步到磁盘
        sfs->super_dirty = 0;//重置超级块脏标志
        if ((ret = sfs_sync_super(sfs)) != 0) {//同步超级块到磁盘
            sfs->super_dirty = 1;//如果同步失败，重新设置脏标志
            return ret;
        }
        if ((ret = sfs_sync_freemap(sfs)) != 0) {//同步空闲块映射到磁盘
            sfs->super_dirty = 1;//如果同步失败，重新设置脏标志
            return ret;
        }
    }
    return 0;
}

/*
 * sfs_get_root - get the root directory inode  from disk (SFS_BLKN_ROOT,1)
 */
//用于获取根目录的inode节点，inode节点是存储在磁盘块SFS_BLKN_ROOT中的
static struct inode *
sfs_get_root(struct fs *fs) {
    struct inode *node;
    int ret;
    //如果加载根目录inode失败，则触发panic，终止系统运行
    if ((ret = sfs_load_inode(fsop_info(fs, sfs), &node, SFS_BLKN_ROOT)) != 0) {
        panic("load sfs root failed: %e", ret);
    }
    return node;
}

/*
 * sfs_unmount - unmount sfs, and free the memorys contain sfs->freemap/sfs_buffer/hash_liskt and sfs itself.
 */
//用于卸载sfs文件系统，并释放与sfs相关的内存资源，包括freemap、sfs_buffer、hash_list以及sfs本身
static int
sfs_unmount(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);//获取sfs文件系统结构体指针
    //如果还有inode没有被释放，说明文件系统仍在使用中，不能卸载
    if (!list_empty(&(sfs->inode_list))) {
        return -E_BUSY;
    }
    assert(!sfs->super_dirty);//确保在卸载之前已经同步了超级块
    bitmap_destroy(sfs->freemap);//释放freemap内存
    kfree(sfs->sfs_buffer);//释放sfs_buffer内存
    kfree(sfs->hash_list);//释放hash_list内存
    kfree(sfs);//释放sfs本身的内存
    return 0;
}

/*
 * sfs_cleanup - when sfs failed, then should call this function to sync sfs by calling sfs_sync
 *
 * NOTICE: nouse now.
 */
//用于在sfs文件系统出现故障时调用，通过调用fsop_sync函数多次尝试同步sfs文件系统
static void
sfs_cleanup(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);//一样，获取sfs文件系统结构体指针
    uint32_t blocks = sfs->super.blocks, unused_blocks = sfs->super.unused_blocks;//获取总块数和未使用块数
    cprintf("sfs: cleanup: '%s' (%d/%d/%d)\n", sfs->super.info,
            blocks - unused_blocks, unused_blocks, blocks);
    int i, ret;
    //尝试多次同步sfs文件系统，最多32次，如果成功则跳出循环，否则则打印错误信息
    for (i = 0; i < 32; i ++) {
        if ((ret = fsop_sync(fs)) == 0) {
            break;
        }
    }
    if (ret != 0) {
        warn("sfs: sync error: '%s': %e.\n", sfs->super.info, ret);
    }
}

/*
 * sfs_init_read - used in sfs_do_mount to read disk block(blkno, 1) directly.
 *
 * @dev:        the block device
 * @blkno:      the NO. of disk block
 * @blk_buffer: the buffer used for read
 *
 *      (1) init iobuf
 *      (2) read dev into iobuf
 */

//用于在挂载sfs文件系统时，直接从块设备读取指定块号的磁盘块到缓冲区
//首先初始化一个iobuf结构体，然后通过dop_io函数从设备读取数据到iobuf中
static int
sfs_init_read(struct device *dev, uint32_t blkno, void *blk_buffer) {
    struct iobuf __iob, *iob = iobuf_init(&__iob, blk_buffer, SFS_BLKSIZE, blkno * SFS_BLKSIZE);
    return dop_io(dev, iob, 0);//最后其实是调用d_io函数，而这个函数的第三个参数为write，0表示读操作
}

/*
 * sfs_init_freemap - used in sfs_do_mount to read freemap data info in disk block(blkno, nblks) directly.
 *
 * @dev:        the block device
 * @bitmap:     the bitmap in memroy
 * @blkno:      the NO. of disk block
 * @nblks:      Read number of disk block 磁盘要读取的块数
 * @blk_buffer: the buffer used for read
 *
 *      (1) get data addr in bitmap
 *      (2) read dev into iobuf
 */

//用于在挂载sfs文件系统时，直接从块设备读取指定块号和块数的空闲块映射数据到内存中的bitmap结构体中
//首先获取bitmap的数据地址，然后通过循环调用sfs_init_read函数从设备读取数据到bitmap中
static int
sfs_init_freemap(struct device *dev, struct bitmap *freemap, uint32_t blkno, uint32_t nblks, void *blk_buffer) {
    size_t len;
    void *data = bitmap_getdata(freemap, &len);//获取bitmap的数据地址data和长度len
    assert(data != NULL && len == nblks * SFS_BLKSIZE);
    while (nblks != 0) {
        int ret;
        if ((ret = sfs_init_read(dev, blkno, data)) != 0) {
            //这里的三个参数分别对应设备指针、块号和数据缓冲区地址
            return ret;
        }
        blkno ++, nblks --, data += SFS_BLKSIZE;//每次data地址增加一个块大小，最后的数据都读到了bitmap中。bitmap是位图结构，这样我们就能记录哪些块是空闲的，哪些块是已使用的
    }
    return 0;
}

/*
 * sfs_do_mount - mount sfs file system.
 *
 * @dev:        the block device contains sfs file system
 * @fs_store:   the fs struct in memroy
 */

//用于挂载sfs文件系统到指定的块设备上
//首先检查设备的块大小是否符合sfs文件系统的要求，然后分配fs结构体和sfs_fs结构体
//接着加载超级块并进行检查，分配并初始化哈希链表和空闲块映射
//最后将相关函数指针链接到fs结构体中，并返回挂载成功的fs结构体指针
//如果在任何步骤中出现错误，则进行相应的清理工作并返回错误码
static int
sfs_do_mount(struct device *dev, struct fs **fs_store) {
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_super));//确保块大小足够存储超级块
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_inode));//确保块大小足够存储磁盘inode结构体
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_entry));//确保块大小足够存储磁盘目录项结构体
    //我们要确保设备的块大小与sfs文件系统的块大小一致，否则无法正确读取和写入数据
    if (dev->d_blocksize != SFS_BLKSIZE) {
        return -E_NA_DEV;
    }

    /* allocate fs structure */
    //分配fs结构体和sfs_fs结构体，定义dev指针和fs指针
    struct fs *fs;
    if ((fs = alloc_fs(sfs)) == NULL) {
        return -E_NO_MEM;
    }
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    sfs->dev = dev;

    int ret = -E_NO_MEM;

    void *sfs_buffer;
    if ((sfs->sfs_buffer = sfs_buffer = kmalloc(SFS_BLKSIZE)) == NULL) {
        goto failed_cleanup_fs;
    }

    /* load and check superblock */
    //加载并检查超级块，如果超级块的MagicNumber不正确或者文件系统的块数超过设备的块数，则返回错误
    if ((ret = sfs_init_read(dev, SFS_BLKN_SUPER, sfs_buffer)) != 0) {
        goto failed_cleanup_sfs_buffer;
    }

    ret = -E_INVAL;

    struct sfs_super *super = sfs_buffer;
    if (super->magic != SFS_MAGIC) {//检查超级块的MagicNumber是否正确
        cprintf("sfs: wrong magic in superblock. (%08x should be %08x).\n",
                super->magic, SFS_MAGIC);
        goto failed_cleanup_sfs_buffer;
    }
    if (super->blocks > dev->d_blocks) {//检查文件系统的块数是否超过设备的块数
        cprintf("sfs: fs has %u blocks, device has %u blocks.\n",
                super->blocks, dev->d_blocks);
        goto failed_cleanup_sfs_buffer;
    }
    super->info[SFS_MAX_INFO_LEN] = '\0';
    sfs->super = *super;

    ret = -E_NO_MEM;

    uint32_t i;

    /* alloc and initialize hash list */
    //分配并初始化哈希链表，用于快速查找inode节点
    list_entry_t *hash_list;
    //如果分配哈希链表失败，则进行相应的清理工作并返回错误码
    if ((sfs->hash_list = hash_list = kmalloc(sizeof(list_entry_t) * SFS_HLIST_SIZE)) == NULL) {
        goto failed_cleanup_sfs_buffer;
    }
    //初始化哈希链表中的每个链表头,SFS_HLIST_SIZE是哈希链表的大小
    for (i = 0; i < SFS_HLIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    /* load and check freemap */
    //分配并初始化空闲块映射，用于记录文件系统中哪些块是空闲的，哪些块是已使用的
    struct bitmap *freemap;
    uint32_t freemap_size_nbits = sfs_freemap_bits(super);
    if ((sfs->freemap = freemap = bitmap_create(freemap_size_nbits)) == NULL) {//如果分配空闲块映射失败，则进行相应的清理工作并返回错误码
        goto failed_cleanup_hash_list;
    }
    uint32_t freemap_size_nblks = sfs_freemap_blocks(super);
    if ((ret = sfs_init_freemap(dev, freemap, SFS_BLKN_FREEMAP, freemap_size_nblks, sfs_buffer)) != 0) {//如果加载空闲块映射失败，则进行相应的清理工作并返回错误码
        goto failed_cleanup_freemap;
    }
    
    uint32_t blocks = sfs->super.blocks, unused_blocks = 0;
    for (i = 0; i < freemap_size_nbits; i ++) {//计算未使用的块数，并与超级块中的记录进行比较，确保一致性
        if (bitmap_test(freemap, i)) {//如果该块是未使用的，则增加未使用块计数
            unused_blocks ++;
        }
    }
    assert(unused_blocks == sfs->super.unused_blocks);//确保计算得到的未使用块数与超级块中的记录一致

    /* and other fields */
    //初始化其他字段，包括超级块脏标志和信号量
    sfs->super_dirty = 0;
    sem_init(&(sfs->fs_sem), 1);
    sem_init(&(sfs->io_sem), 1);
    sem_init(&(sfs->mutex_sem), 1);
    list_init(&(sfs->inode_list));
    cprintf("sfs: mount: '%s' (%d/%d/%d)\n", sfs->super.info,
            blocks - unused_blocks, unused_blocks, blocks);

    /* link addr of sync/get_root/unmount/cleanup funciton  fs's function pointers*/
    //将sfs相关的函数指针链接到fs结构体中
    fs->fs_sync = sfs_sync;//同步函数指针
    fs->fs_get_root = sfs_get_root;//获取根目录函数指针
    fs->fs_unmount = sfs_unmount;//卸载函数指针
    fs->fs_cleanup = sfs_cleanup;//清理函数指针
    *fs_store = fs;//通过fs_store参数返回挂载成功的fs结构体指针
    return 0;

failed_cleanup_freemap:
    bitmap_destroy(freemap);
failed_cleanup_hash_list:
    kfree(hash_list);
failed_cleanup_sfs_buffer:
    kfree(sfs_buffer);
failed_cleanup_fs:
    kfree(fs);
    return ret;
}

int
sfs_mount(const char *devname) {
    return vfs_mount(devname, sfs_do_mount);
}

