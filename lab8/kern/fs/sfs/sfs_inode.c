#include <defs.h>
#include <string.h>
#include <stdlib.h>
#include <list.h>
#include <stat.h>
#include <kmalloc.h>
#include <vfs.h>
#include <dev.h>
#include <sfs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>

static const struct inode_ops sfs_node_dirops;  // dir operations 对目录操作
static const struct inode_ops sfs_node_fileops; // file operations 对文件操作

/*
 * lock_sin - lock the process of inode Rd/Wr
 */
//用于锁定sfs_inode结构体，防止并发访问
static void
lock_sin(struct sfs_inode *sin) {
    down(&(sin->sem));
}

/*
 * unlock_sin - unlock the process of inode Rd/Wr
 */
static void
unlock_sin(struct sfs_inode *sin) {
    up(&(sin->sem));
}

/*
 * sfs_get_ops - return function addr of fs_node_dirops/sfs_node_fileops
 */
//根据文件类型返回对应的inode操作函数指针
static const struct inode_ops *
sfs_get_ops(uint16_t type) {
    switch (type) {
    case SFS_TYPE_DIR:
        return &sfs_node_dirops;
    case SFS_TYPE_FILE:
        return &sfs_node_fileops;
    }
    panic("invalid file type %d.\n", type);
}

/*
 * sfs_hash_list - return inode entry in sfs->hash_list
 */
//返回哈希链表中对应ino的链表头指针
static list_entry_t *
sfs_hash_list(struct sfs_fs *sfs, uint32_t ino) {
    return sfs->hash_list + sin_hashfn(ino);
}

/*
 * sfs_set_links - link inode sin in sfs->linked-list AND sfs->hash_link
 */
//将inode节点添加到sfs文件系统的链表和哈希链表中
static void
sfs_set_links(struct sfs_fs *sfs, struct sfs_inode *sin) {
    list_add(&(sfs->inode_list), &(sin->inode_link));//在sfs文件系统的inode链表中添加该inode节点
    list_add(sfs_hash_list(sfs, sin->ino), &(sin->hash_link));
}

/*
 * sfs_remove_links - unlink inode sin in sfs->linked-list AND sfs->hash_link
 */
//将inode节点从sfs文件系统的链表和哈希链表中移除
static void
sfs_remove_links(struct sfs_inode *sin) {
    list_del(&(sin->inode_link));
    list_del(&(sin->hash_link));
}

/*
 * sfs_block_inuse - check the inode with NO. ino inuse info in bitmap
 */
//检查指定块号的磁盘块是否被使用
static bool
sfs_block_inuse(struct sfs_fs *sfs, uint32_t ino) {
    if (ino != 0 && ino < sfs->super.blocks) {
        return !bitmap_test(sfs->freemap, ino);
    }
    panic("sfs_block_inuse: called out of range (0, %u) %u.\n", sfs->super.blocks, ino);
}

/*
 * sfs_block_alloc -  check and get a free disk block
 */
//分配一个空闲的磁盘块，并更新超级块的未使用块计数和脏标志
static int
sfs_block_alloc(struct sfs_fs *sfs, uint32_t *ino_store) {
    int ret;
    if ((ret = bitmap_alloc(sfs->freemap, ino_store)) != 0) {
        return ret;
    }
    assert(sfs->super.unused_blocks > 0);
    sfs->super.unused_blocks --, sfs->super_dirty = 1;
    assert(sfs_block_inuse(sfs, *ino_store));
    return sfs_clear_block(sfs, *ino_store, 1);
}

/*
 * sfs_block_free - set related bits for ino block to 1(means free) in bitmap, add sfs->super.unused_blocks, set superblock dirty *
 */
//释放空闲块，
static void
sfs_block_free(struct sfs_fs *sfs, uint32_t ino) {
    assert(sfs_block_inuse(sfs, ino));
    bitmap_free(sfs->freemap, ino);
    sfs->super.unused_blocks ++, sfs->super_dirty = 1;
}

/*
 * sfs_create_inode - alloc a inode in memroy, and init din/ino/dirty/reclian_count/sem fields in sfs_inode in inode
 */
//分配并初始化一个新的inode节点
static int
sfs_create_inode(struct sfs_fs *sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store) {
    struct inode *node;
    if ((node = alloc_inode(sfs_inode)) != NULL) {
        vop_init(node, sfs_get_ops(din->type), info2fs(sfs, sfs));//初始化inode节点，设置操作函数和文件系统指针，分别调用了vop_init和info2fs函数
        struct sfs_inode *sin = vop_info(node, sfs_inode);
        sin->din = din, sin->ino = ino, sin->dirty = 0, sin->reclaim_count = 1;
        sem_init(&(sin->sem), 1);//初始化信号量，初始值为1，这里我们的信号量用于在inode节点的读写过程中进行加锁保护
        *node_store = node;//将新创建的inode节点存储到输出参数中
        return 0;
    }
    return -E_NO_MEM;
}

/*
 * lookup_sfs_nolock - according ino, find related inode
 *
 * NOTICE: le2sin, info2node MACRO
 */
//在不加锁的情况下，根据ino查找对应的inode节点
static struct inode *
lookup_sfs_nolock(struct sfs_fs *sfs, uint32_t ino) {
    struct inode *node;
    list_entry_t *list = sfs_hash_list(sfs, ino), *le = list;
    while ((le = list_next(le)) != list) {//遍历哈希链表，查找对应ino的inode节点
        struct sfs_inode *sin = le2sin(le, hash_link);
        if (sin->ino == ino) {//找到了对应的inode节点
            node = info2node(sin, sfs_inode);//获取对应的inode结构体指针
            if (vop_ref_inc(node) == 1) {//增加引用计数，这里只在引用为1时增加reclaim_count，表示该inode节点正在被使用，当引用位大于1后，说明有多个引用，不需要再增加reclaim_count
                sin->reclaim_count ++;
            }
            return node;
        }
    }
    return NULL;
}

/*
 * sfs_load_inode - If the inode isn't existed, load inode related ino disk block data into a new created inode.
 *                  If the inode is in memory alreadily, then do nothing
 */
//用于加载指定ino的inode节点，如果该节点已经存在于内存中，则直接返回
int
sfs_load_inode(struct sfs_fs *sfs, struct inode **node_store, uint32_t ino) {
    lock_sfs_fs(sfs);
    struct inode *node;
    //首先在哈希链表中查找指定ino的inode节点
    if ((node = lookup_sfs_nolock(sfs, ino)) != NULL) {
        goto out_unlock;
    }
    
    //如果没有找到对应的inode节点，则需要从磁盘读取数据并创建一个新的inode节点
    int ret = -E_NO_MEM;
    struct sfs_disk_inode *din;
    if ((din = kmalloc(sizeof(struct sfs_disk_inode))) == NULL) {
        goto failed_unlock;
    }

    assert(sfs_block_inuse(sfs, ino));//确保对应的块没有被释放
    //从磁盘读取指定ino的inode数据到din缓冲区中并进行检查，如果读取失败，则进行相应的清理工作并返回错误码
    if ((ret = sfs_rbuf(sfs, din, sizeof(struct sfs_disk_inode), ino, 0)) != 0) {
        goto failed_cleanup_din;
    }

    assert(din->nlinks != 0);//确保该inode节点的链接数不为0
    //创建一个新的inode节点，并将读取到的din数据初始化到该节点中,如果创建失败，则进行相应的清理工作并返回错误码
    if ((ret = sfs_create_inode(sfs, din, ino, &node)) != 0) {
        goto failed_cleanup_din;
    }
    //将新创建的inode节点添加到sfs文件系统的链表和哈希链表中
    sfs_set_links(sfs, vop_info(node, sfs_inode));

out_unlock:
    //解锁，返回找到或创建的inode节点
    unlock_sfs_fs(sfs);
    *node_store = node;
    return 0;

failed_cleanup_din:
    kfree(din);
failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

/*
 * sfs_bmap_get_sub_nolock - according entry pointer entp and index, find the index of indrect disk block
 *                           return the index of indrect disk block to ino_store. no lock protect
 * @sfs:      sfs file system
 * @entp:     the pointer of index of entry disk block
 * @index:    the index of block in indrect block
 * @create:   BOOL, if the block isn't allocated, if create = 1 the alloc a block,  otherwise just do nothing
 * @ino_store: 0 OR the index of already inused block or new allocated block.
 */
//用于在不加锁的情况下，根据间接块的索引查找对应的磁盘块号（底层实现）
static int
sfs_bmap_get_sub_nolock(struct sfs_fs *sfs, uint32_t *entp, uint32_t index, bool create, uint32_t *ino_store) {
    assert(index < SFS_BLK_NENTRY);//确保索引在有效范围内
    int ret;
    uint32_t ent, ino = 0;//ent为entry block的块号，ino为要查找的磁盘块号
    off_t offset = index * sizeof(uint32_t);//计算索引对应的偏移量
	//如果entry block已经存在，则读取对应的磁盘块号
    if ((ent = *entp) != 0) {
        //调用sfs_rbuf函数从entry block中读取32位的磁盘块号到ino变量中
        if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        if (ino != 0 || !create) {
            goto out;
        }
    }
    else {
        if (!create) {
            goto out;
        }
		//如果entry block不存在且需要创建，则分配一个新的块
        if ((ret = sfs_block_alloc(sfs, &ent)) != 0) {
            return ret;
        }
    }
    
    if ((ret = sfs_block_alloc(sfs, &ino)) != 0) {
        goto failed_cleanup;
    }
    //sfs_wbuf函数将新分配的磁盘块号写入到entry block的对应偏移位置，并进行错误处理，如果写入失败，则释放之前分配的磁盘块并进行清理
    if ((ret = sfs_wbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        sfs_block_free(sfs, ino);
        goto failed_cleanup;
    }

out:
    if (ent != *entp) {
        *entp = ent;
    }
    *ino_store = ino;
    return 0;

failed_cleanup:
    if (ent != *entp) {
        sfs_block_free(sfs, ent);
    }
    return ret;
}

/*
 * sfs_bmap_get_nolock - according sfs_inode and index of block, find the NO. of disk block
 *                       no lock protect
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @index:    the index of block in inode
 * @create:   BOOL, if the block isn't allocated, if create = 1 the alloc a block,  otherwise just do nothing
 * @ino_store: 0 OR the index of already inused block or new allocated block.
 */
//在不加锁的情况下，根据inode节点和块的逻辑索引查找对应的磁盘块号（上层调用），参数分别为文件系统指针、inode节点指针、块的逻辑索引、是否创建新块的标志以及输出参数存储块号
static int
sfs_bmap_get_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, bool create, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;//获取对应的磁盘inode结构体
    int ret;
    uint32_t ent, ino;//ent为entry block的块号，ino为要查找的磁盘块号
	//磁盘块号在直接块范围内，则直接获取对应的块号
    if (index < SFS_NDIRECT) {
        //如果直接块号为0（还没分配）且需要创建新的块，则分配一个新的块并更新inode中的直接块号。
        if ((ino = din->direct[index]) == 0 && create) {
            if ((ret = sfs_block_alloc(sfs, &ino)) != 0) {
                //调用sfs_block_alloc函数分配一个新的磁盘块，并将块号存储在ino变量中
                return ret;
            }
            din->direct[index] = ino;//将结果记录到inode的direct数组中
            sin->dirty = 1;
        }
        goto out;
    }
    //磁盘块号在间接块范围内，则调用sfs_bmap_get_sub_nolock函数获取对应的块号
    index -= SFS_NDIRECT;
    if (index < SFS_BLK_NENTRY) {
        ent = din->indirect;//获取间接块号
        if ((ret = sfs_bmap_get_sub_nolock(sfs, &ent, index, create, &ino)) != 0) {
            return ret;
        }
        if (ent != din->indirect) {
            //如果间接块号发生变化，则更新inode中的间接块号并标记为脏。这里的ent与din->indirect如果不相等，说明是第一次分配间接块。
            assert(din->indirect == 0);//确保之前没有分配间接块
            din->indirect = ent;
            sin->dirty = 1;
        }
        goto out;
    } else {
		panic ("sfs_bmap_get_nolock - index out of range");
	}
out:
    assert(ino == 0 || sfs_block_inuse(sfs, ino));
    *ino_store = ino;
    return 0;
}

/*
 * sfs_bmap_free_sub_nolock - set the entry item to 0 (free) in the indirect block
 */
//用于在不加锁的情况下，释放间接块中的某个条目对应的磁盘块(底层实现)
static int
sfs_bmap_free_sub_nolock(struct sfs_fs *sfs, uint32_t ent, uint32_t index) {
    assert(sfs_block_inuse(sfs, ent) && index < SFS_BLK_NENTRY);
    int ret;
    uint32_t ino, zero = 0;
    off_t offset = index * sizeof(uint32_t);
    if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        return ret;
    }
    if (ino != 0) {
        if ((ret = sfs_wbuf(sfs, &zero, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        sfs_block_free(sfs, ino);
    }
    return 0;
}

/*
 * sfs_bmap_free_nolock - free a block with logical index in inode and reset the inode's fields
 */
//用于在不加锁的情况下，释放指定逻辑索引对应的磁盘块(上层调用)
static int
sfs_bmap_free_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index) {
    struct sfs_disk_inode *din = sin->din;//获取对应的磁盘inode结构体
    int ret;
    uint32_t ent, ino;//ent为entry block的块号，ino为要释放的磁盘块号
    if (index < SFS_NDIRECT) {//磁盘块号在直接块范围内
        if ((ino = din->direct[index]) != 0) {
			//如果直接块号不为0，则释放对应的磁盘块，并将直接块号设置为0，标记inode为脏
            sfs_block_free(sfs, ino);
            din->direct[index] = 0;
            sin->dirty = 1;
        }
        return 0;
    }
    //在间接块范围内，如果间接块号不为0，则调用sfs_bmap_free_sub_nolock函数释放对应的磁盘块
    index -= SFS_NDIRECT;
    if (index < SFS_BLK_NENTRY) {
        if ((ent = din->indirect) != 0) {
			//调用sfs_bmap_free_sub_nolock函数释放间接块中的对应条目
            if ((ret = sfs_bmap_free_sub_nolock(sfs, ent, index)) != 0) {
                return ret;
            }
        }
        return 0;
    }
    return 0;
}

/*
 * sfs_bmap_load_nolock - according to the DIR's inode and the logical index of block in inode, find the NO. of disk block.
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @index:    the logical index of disk block in inode
 * @ino_store:the NO. of disk block
 */
//用于在不加锁的情况下，根据inode节点和块的逻辑索引查找对应的磁盘块号，并在需要时进行分配
static int
sfs_bmap_load_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;
    assert(index <= din->blocks);
    int ret;
    uint32_t ino;
    bool create = (index == din->blocks);
    if ((ret = sfs_bmap_get_nolock(sfs, sin, index, create, &ino)) != 0) {
        return ret;
    }
    assert(sfs_block_inuse(sfs, ino));
    if (create) {
        din->blocks ++;
    }
    if (ino_store != NULL) {
        *ino_store = ino;
    }
    return 0;
}

/*
 * sfs_bmap_truncate_nolock - free the disk block at the end of file
 */
//用于在不加锁的情况下，释放文件末尾的一个磁盘块
static int
sfs_bmap_truncate_nolock(struct sfs_fs *sfs, struct sfs_inode *sin) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->blocks != 0);
    int ret;
    if ((ret = sfs_bmap_free_nolock(sfs, sin, din->blocks - 1)) != 0) {//调用sfs_bmap_free_nolock函数释放最后一个块
        return ret;
    }
    din->blocks --;
    sin->dirty = 1;
    return 0;
}

/*
 * sfs_dirent_read_nolock - read the file entry from disk block which contains this entry
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @slot:     the index of file entry
 * @entry:    file entry 用于存储读取到的文件条目
 */
//用于在不加锁的情况下，读取目录中指定槽位的文件条目
static int
sfs_dirent_read_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    assert(sin->din->type == SFS_TYPE_DIR && (slot >= 0 && slot < sin->din->blocks));
    int ret;
    uint32_t ino;
	//根据槽位号获取对应的磁盘块号
    if ((ret = sfs_bmap_load_nolock(sfs, sin, slot, &ino)) != 0) {
        return ret;
    }
    assert(sfs_block_inuse(sfs, ino));
	//读取对应磁盘块中的文件条目数据到entry结构体中
    if ((ret = sfs_rbuf(sfs, entry, sizeof(struct sfs_disk_entry), ino, 0)) != 0) {
        return ret;
    }
    //将文件名字符串确保以null结尾
    entry->name[SFS_MAX_FNAME_LEN] = '\0';
    return 0;
}
//用于在不加锁的情况下，将文件条目写入目录中指定槽位的磁盘块
#define sfs_dirent_link_nolock_check(sfs, sin, slot, lnksin, name)                  \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_link_nolock(sfs, sin, slot, lnksin, name)) != 0) {    \
            warn("sfs_dirent_link error: %e.\n", err);                              \
        }                                                                           \
    } while (0)
//用于在不加锁的情况下，从目录中删除指定槽位的文件条目
#define sfs_dirent_unlink_nolock_check(sfs, sin, slot, lnksin)                      \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_unlink_nolock(sfs, sin, slot, lnksin)) != 0) {        \
            warn("sfs_dirent_unlink error: %e.\n", err);                            \
        }                                                                           \
    } while (0)

/*
 * sfs_dirent_search_nolock - read every file entry in the DIR, compare file name with each entry->name
 *                            If equal, then return slot and NO. of disk of this file's inode
 * @sfs:        sfs file system
 * @sin:        sfs inode in memory
 * @name:       the filename
 * @ino_store:  NO. of disk of this file (with the filename)'s inode
 * @slot:       logical index of file entry (NOTICE: each file entry ocupied one  disk block)
 * @empty_slot: the empty logical index of file entry.
 */
//用于在不加锁的情况下，搜索目录中指定文件名的文件条目
static int
sfs_dirent_search_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, uint32_t *ino_store, int *slot, int *empty_slot) {
    assert(strlen(name) <= SFS_MAX_FNAME_LEN);
    struct sfs_disk_entry *entry;//用于存储读取到的文件条目
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }
//定义一个宏，用于设置输出参数的值，即将v的值赋给x所指向的变量
#define set_pvalue(x, v)            do { if ((x) != NULL) { *(x) = (v); } } while (0)//这里使用do-while结构是为了确保宏的安全性，避免在使用时出现语法错误
    //遍历目录中的所有文件条目，查找与指定文件名匹配的条目
    int ret, i, nslots = sin->din->blocks;
    set_pvalue(empty_slot, nslots);//初始化empty_slot为nslots，表示没有找到空槽位
    for (i = 0; i < nslots; i ++) {//遍历目录中的每个文件条目
        //读取失败
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            goto out;
        }
        //找到一个空槽位，则记录到empty_slot中，继续查找，以便找到匹配的文件名
        if (entry->ino == 0) {
            set_pvalue(empty_slot, i);
            continue ;
        }
        //如果文件名匹配，则将槽位号和对应的inode块号存储到输出参数中，并跳出循环
        if (strcmp(name, entry->name) == 0) {
            set_pvalue(slot, i);
            set_pvalue(ino_store, entry->ino);
            goto out;
        }
    }
#undef set_pvalue
    ret = -E_NOENT;
out:
    kfree(entry);
    return ret;
}

/*
 * sfs_dirent_findino_nolock - read all file entries in DIR's inode and find a entry->ino == ino
 */
//用于在不加锁的情况下，查找目录中指定ino的文件条目，具体流程为读取目录中的每个文件条目，比较其ino值是否与指定的ino匹配，如果匹配，则返回该条目
static int
sfs_dirent_findino_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t ino, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            return ret;
        }
        if (entry->ino == ino) {
            return 0;
        }
    }
    return -E_NOENT;
}

/*
 * sfs_lookup_once - find inode corresponding the file name in DIR's sin inode 
 * @sfs:        sfs file system
 * @sin:        DIR sfs inode in memory
 * @name:       the file name in DIR
 * @node_store: the inode corresponding the file name in DIR
 * @slot:       the logical index of file entry
 */
//用于在目录inode中查找指定文件名对应的inode节点
static int
sfs_lookup_once(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, struct inode **node_store, int *slot) {
    int ret;
    uint32_t ino;
    lock_sin(sin);
    {   //找到对应文件名的文件条目，并获取对应的磁盘块号
        ret = sfs_dirent_search_nolock(sfs, sin, name, &ino, slot, NULL);
    }
    unlock_sin(sin);
    if (ret == 0) {
		//加载对应的inode节点到内存中
        ret = sfs_load_inode(sfs, node_store, ino);
    }
    return ret;
}

//用于打开目录，检查打开标志的合法性
static int
sfs_opendir(struct inode *node, uint32_t open_flags) {
    switch (open_flags & O_ACCMODE) {
    case O_RDONLY:
        break;
    case O_WRONLY:
    case O_RDWR:
    default:
        return -E_ISDIR;
    }
    if (open_flags & O_APPEND) {
        return -E_ISDIR;
    }
    return 0;
}

// sfs_openfile - open file (no use)
static int
sfs_openfile(struct inode *node, uint32_t open_flags) {
    return 0;
}

// sfs_close - close file
static int
sfs_close(struct inode *node) {
    return vop_fsync(node);
}

/*  
 * sfs_io_nolock - Rd/Wr a file contentfrom offset position to offset+ length  disk blocks<-->buffer (in memroy)
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @buf:      the buffer Rd/Wr
 * @offset:   the offset of file
 * @alenp:    the length need to read (is a pointer). and will RETURN the really Rd/Wr lenght
 * @write:    BOOL, 0 read, 1 write
 */
//用于在不加锁的情况下，进行文件内容的读写操作
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->type != SFS_TYPE_DIR);
    off_t endpos = offset + *alenp, blkoff;
    *alenp = 0;
	//计算读写操作的实际范围，并进行边界检查
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    if (offset == endpos) {//没有数据需要读写，直接返回0
        return 0;
    }
    //超过文件系统允许的最大文件大小，则调整endpos为最大值
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    //如果是读操作，且偏移量超出文件大小，则直接返回0
    if (!write) {
        if (offset >= din->size) {
            return 0;
        }
        if (endpos > din->size) {
            endpos = din->size;
        }
    }
    //定义函数指针，根据读写操作选择对应的函数
    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);//指向读写缓冲区的函数
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);//指向读写块的函数
    //根据读写标志选择对应的函数
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    int ret = 0;
    size_t size, alen = 0;//size为每次读写的大小，alen为累计读写的总大小
    uint32_t ino;//物理块号
    uint32_t blkno = offset / SFS_BLKSIZE;          //起始块号
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  //读写的块数，即完整块的数量

    //LAB8:EXERCISE1 2312323:
    //检查offset是否与块对齐，如果不对齐，先计算出第一块中需要处理的数据大小，获取对应的块号，然后进行读写操作
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        //获取逻辑块号对应的物理块号。这里我们使用sfs_bmap_load_nolock函数，来进行块号的映射和分配
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        //进行读写操作，这里使用我们刚刚定义的函数指针sfs_buf_op，根据读写操作选择对应的函数
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        alen += size;
        //如果已经处理完所有块，直接跳转到out
        if (nblks == 0) {
            goto out;
        }
        //更新缓冲区指针、块号和剩余块数
        buf = (char *)buf + size;
        blkno ++;
        nblks --;
    }
    //处理对齐的块
    size = SFS_BLKSIZE;
    //循环处理每个完整的块
    while (nblks != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            //使用sfs_bmap_load_nolock函数获取物理块号，参数分别为文件系统指针、inode节点指针、逻辑块号和物理块号指针
            goto out;
        }
        if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
            //使用sfs_block_op函数进行读写操作，参数分别为文件系统指针、缓冲区指针、物理块号和块数
            goto out;
        }
        alen += size;
        buf = (char *)buf + size;//更新缓冲区指针
        blkno ++;
        nblks --;
    }
    //检查endpos是否与块对齐，如果不对齐，计算出最后一块中需要处理的数据大小，获取对应的块号，然后进行读写操作，如果对齐，则跳过该步骤。
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
    }

out:
    //返回实际读写的长度，并在写操作时更新文件大小和脏标志
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;
        sin->dirty = 1;
    }
    return ret;
}

/*
 * sfs_io - Rd/Wr file. the wrapper of sfs_io_nolock
            with lock protect
 */
//用于进行文件内容的读写操作，并添加锁保护
static inline int
sfs_io(struct inode *node, struct iobuf *iob, bool write) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);//调用vop_info函数获取对应的sfs_inode结构体指针
    int ret;
    lock_sin(sin);
    {   //这里我们调用了sfs_io_nolock函数来进行实际的读写操作，参数分别为文件系统指针、inode节点指针、缓冲区指针、偏移量指针、长度指针和读写标志
        size_t alen = iob->io_resid;
        ret = sfs_io_nolock(sfs, sin, iob->io_base, iob->io_offset, &alen, write);
        if (alen != 0) {
            iobuf_skip(iob, alen);//如果实际读写的长度不为0，则调用iobuf_skip函数更新iobuf结构体中的偏移量和剩余长度
        }
    }
    unlock_sin(sin);
    return ret;
}

// sfs_read - read file
static int
sfs_read(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 0);
}

// sfs_write - write file
static int
sfs_write(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 1);
}

/*
 * sfs_fstat - Return nlinks/block/size, etc. info about a file. The pointer is a pointer to struct stat;
 */
//用于获取文件的状态信息，首先初始化stat结构体，然后调用vop_gettype函数获取文件类型，并从磁盘inode结构体中获取链接数、块数和文件大小等信息
static int
sfs_fstat(struct inode *node, struct stat *stat) {
    int ret;
    memset(stat, 0, sizeof(struct stat));
    if ((ret = vop_gettype(node, &(stat->st_mode))) != 0) {
        return ret;
    }
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    stat->st_nlinks = din->nlinks;
    stat->st_blocks = din->blocks;
    stat->st_size = din->size;
    return 0;
}

/*
 * sfs_fsync - Force any dirty inode info associated with this file to stable storage.
 */
//用于将脏的inode信息写回到磁盘，首先检查inode是否被标记为脏，如果是，则获取文件系统和inode结构体的指针，并加锁inode进行写回操作
static int
sfs_fsync(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret = 0;
    if (sin->dirty) {//如果是脏的inode（赃位吧就是）
        lock_sin(sin);
        {
            if (sin->dirty) {//再次检查脏标志，防止在加锁前已经被其他线程修改，例如程序在加锁前另一个线程已经将其写回磁盘。
                sin->dirty = 0;
                if ((ret = sfs_wbuf(sfs, sin->din, sizeof(struct sfs_disk_inode), sin->ino, 0)) != 0) {
                    //这里调用了sfs文件系统的写缓冲区函数sfs_wbuf，将内存中的磁盘inode结构体写回到对应的磁盘块中，如果写回失败，则将脏标志重新设置为1，表示仍然需要写回
                    sin->dirty = 1;
                }
            }
        }
        unlock_sin(sin);
    }
    return ret;
}

/*
 *sfs_namefile -Compute pathname relative to filesystem root of the file and copy to the specified io buffer.
 *  
 */
//用于计算文件相对于文件系统根目录的路径名，并将其复制到指定的iobuf结构体中
static int
sfs_namefile(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;//找到文件入口
    if (iob->io_resid <= 2 || (entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        //这里的情况是iobuf的剩余长度不足以存放路径名，或者内存分配失败。小于等于2是因为路径名至少需要包含一个斜杠和一个null终止符
        return -E_NO_MEM;
    }
    //获取文件系统指针与inode指针
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret;
    char *ptr = iob->io_base + iob->io_resid;//该指针指向iobuf的末尾，用于从后向前构建路径名，这是因为路径名是从文件开始逐级向上构建的。例如"/dir1/dir2/file"，我们需要先找到"file"，然后是"dir2"，最后是"dir1"。
    size_t alen, resid = iob->io_resid - 2;//预留两个字节用于斜杠和null终止符,alen用于存放当前文件名的长度（从一开始到当前的文件），resid用于跟踪剩余空间。
    vop_ref_inc(node);//调用vop_ref_inc函数增加inode节点的引用计数，防止在路径名构建过程中inode被释放
    while (1) {
        struct inode *parent;//找到他的父目录
        if ((ret = sfs_lookup_once(sfs, sin, "..", &parent, NULL)) != 0) {
            goto failed;
        }

        uint32_t ino = sin->ino;//这里是寻找当前文件的ino
        vop_ref_dec(node);//这里我们需要将当前节点的引用计数减1，这里释放的是上一轮循环或函数入口的node引用
        if (node == parent) {//如果当前节点就是根目录，则路径名构建完成，跳出循环
            vop_ref_dec(node);//这里释放的是本轮循环的parent引用
            break;
        }

        node = parent, sin = vop_info(node, sfs_inode);//更新当前节点和inode指针为父目录
        assert(ino != sin->ino && sin->din->type == SFS_TYPE_DIR);//确保当前节点不是父目录，并且父目录的类型是目录
        //这里是我们在循环中的核心操作
        lock_sin(sin);
        {
            ret = sfs_dirent_findino_nolock(sfs, sin, ino, entry);//在父目录中查找当前节点对应的文件条目
        }
        unlock_sin(sin);

        if (ret != 0) {
            goto failed;
        }

        if ((alen = strlen(entry->name) + 1) > resid) {//检查剩余空间是否足够存放当前文件名及斜杠
            goto failed_nomem;
        }
        resid -= alen, ptr -= alen;//resid用于跟踪剩余空间，ptr用于更新路径名的起始位置,retsid减去当前文件名的长度，ptr向前移动相应的长度
        memcpy(ptr, entry->name, alen - 1);
        ptr[alen - 1] = '/';
    }
    alen = iob->io_resid - resid - 2;//路径名总长度-2，减去预留的斜杠和null终止符
    ptr = memmove(iob->io_base + 1, ptr, alen);//将路径名移动到iobuf的起始位置，预留第一个字节用于斜杠
    ptr[-1] = '/', ptr[alen] = '\0';
    iobuf_skip(iob, alen);//这里调用iobuf_skip函数更新iobuf结构体中的偏移量和剩余长度
    kfree(entry);//释放entry
    return 0;

failed_nomem:
    ret = -E_NO_MEM;//内存不足错误处理
failed:
    //错误处理
    vop_ref_dec(node);
    kfree(entry);
    return ret;
}

/*
 * sfs_getdirentry_sub_noblock - get the content of file entry in DIR
 */
//用于在不加锁的情况下，获取目录中指定槽位的文件条目内容（是从磁盘中获得的，这是因为我们调用了sfs_dirent_read_nolock函数，而这个函数中有sfs_rbuf函数的调用，这个函数用于从磁盘读取数据）
static int
sfs_getdirentry_sub_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;//nslots为目录中的文件条目数量
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {//读取指定槽位的文件条目内容到entry结构体中
            return ret;
        }
        if (entry->ino != 0) {//如果该槽位的文件条目有效（即ino不为0），则检查是否是目标槽位
            if (slot == 0) {//找到了目标槽位，返回成功
                return 0;
            }
            slot --;//否则继续查找下一个有效的文件条目
        }
    }
    return -E_NOENT;
}

/*
 * sfs_getdirentry - according to the iob->io_offset, calculate the dir entry's slot in disk block,
                     get dir entry content from the disk 
 */
//用于根据iobuf结构体中的偏移量计算目录条目的槽位，并从磁盘中获取对应的文件条目内容
static int
sfs_getdirentry(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret, slot;//slot为目录条目的槽位
    off_t offset = iob->io_offset;//获取iobuf结构体中的偏移量
    if (offset < 0 || offset % sfs_dentry_size != 0) {//检查偏移量是否合法，必须是非负且对目录条目大小对齐
        kfree(entry);
        return -E_INVAL;
    }
    if ((slot = offset / sfs_dentry_size) > sin->din->blocks) {//计算槽位号，并检查是否超出目录中的文件条目数量
        kfree(entry);
        return -E_NOENT;
    }
    //都没问题的话，就去获取对应槽位的文件条目内容，调用我们上面那个函数
    lock_sin(sin);
    if ((ret = sfs_getdirentry_sub_nolock(sfs, sin, slot, entry)) != 0) {
        unlock_sin(sin);
        goto out;
    }
    unlock_sin(sin);
    ret = iobuf_move(iob, entry->name, sfs_dentry_size, 1, NULL);//最后调用iobuf_move函数将文件名复制到iobuf结构体中，并更新偏移量和剩余长度
out:
    kfree(entry);
    return ret;
}

/*
 * sfs_reclaim - Free all resources inode occupied . Called when inode is no longer in use. 
 */
//用于释放inode节点占用的所有资源，当inode不再使用时调用
static int
sfs_reclaim(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int  ret = -E_BUSY;
    uint32_t ent;
    lock_sfs_fs(sfs);
    assert(sin->reclaim_count > 0);
    if ((-- sin->reclaim_count) != 0 || inode_ref_count(node) != 0) {
        goto failed_unlock;
    }
    if (sin->din->nlinks == 0) {
        if ((ret = vop_truncate(node, 0)) != 0) {
            goto failed_unlock;
        }
    }
    if (sin->dirty) {
        if ((ret = vop_fsync(node)) != 0) {
            goto failed_unlock;
        }
    }
    sfs_remove_links(sin);//从文件系统的inode链表中移除该inode节点
    unlock_sfs_fs(sfs);

    if (sin->din->nlinks == 0) {//如果链接数为0，表示该文件已经被删除，需要释放其占用的磁盘块
        sfs_block_free(sfs, sin->ino);
        if ((ent = sin->din->indirect) != 0) {
            sfs_block_free(sfs, ent);//如果存在间接块，也需要释放
        }
    }
    kfree(sin->din);
    vop_kill(node);//使用VFS提供的vop_kill函数释放inode节点
    return 0;

failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

/*
 * sfs_gettype - Return type of file. The values for file types are in sfs.h.
 */
//用于获取文件的类型，根据磁盘inode结构体中的type字段，映射到对应的文件类型常量
static int
sfs_gettype(struct inode *node, uint32_t *type_store) {
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    switch (din->type) {//分别对应目录、普通文件和符号链接三种类型
    case SFS_TYPE_DIR:
        *type_store = S_IFDIR;
        return 0;
    case SFS_TYPE_FILE:
        *type_store = S_IFREG;
        return 0;
    case SFS_TYPE_LINK:
        *type_store = S_IFLNK;
        return 0;
    }
    panic("invalid file type %d.\n", din->type);
}

/* 
 * sfs_tryseek - Check if seeking to the specified position within the file is legal.
 */
//用于检查是否可以合法地将文件指针移动到指定位置
static int
sfs_tryseek(struct inode *node, off_t pos) {
    if (pos < 0 || pos >= SFS_MAX_FILE_SIZE) {//检查位置是否合法，必须是非负且不超过文件系统允许的最大文件大小
        return -E_INVAL;
    }
    struct sfs_inode *sin = vop_info(node, sfs_inode);//获取inode节点指针
    if (pos > sin->din->size) {
        return vop_truncate(node, pos);//如果位置超过当前文件大小，则调用vop_truncate函数调整文件大小
    }
    return 0;
}

/*
 * sfs_truncfile : reszie the file with new length
 */
//用于调整文件大小到指定长度
static int
sfs_truncfile(struct inode *node, off_t len) {
    if (len < 0 || len > SFS_MAX_FILE_SIZE) {
        return -E_INVAL;
    }
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    struct sfs_disk_inode *din = sin->din;

    int ret = 0;
	
    uint32_t nblks, tblks = ROUNDUP_DIV(len, SFS_BLKSIZE);//目标文件大小所需的磁盘块数，nblks和tblks分别表示当前文件大小所占的磁盘块数和目标文件大小所需的磁盘块数
    if (din->size == len) {//如果当前文件大小已经等于目标大小，则直接返回成功，且需要保证当前文件大小所占的磁盘块数等于目标文件大小所需的磁盘块数
        assert(tblks == din->blocks);
        return 0;
    }

    lock_sin(sin);
	
    nblks = din->blocks;//获取当前文件大小所占的磁盘块数，下面我们会根据当前文件所占的块数与目标文件所占的块数来进行或增加或减少文件块数的操作
    if (nblks < tblks) {
		//尝试通过增加文件块数来扩展文件大小
        while (nblks != tblks) {
            if ((ret = sfs_bmap_load_nolock(sfs, sin, nblks, NULL)) != 0) {
                goto out_unlock;
            }
            nblks ++;
        }
    }
    else if (tblks < nblks) {
		//尝试通过减少文件块数来缩小文件大小
        while (tblks != nblks) {
            if ((ret = sfs_bmap_truncate_nolock(sfs, sin)) != 0) {
                goto out_unlock;
            }
            nblks --;
        }
    }
    assert(din->blocks == tblks);
    din->size = len;
    sin->dirty = 1;

out_unlock:
    unlock_sin(sin);
    return ret;
}

/*
 * sfs_lookup - Parse path relative to the passed directory
 *              DIR, and hand back the inode for the file it
 *              refers to.
 */
//用于在指定目录inode中查找指定路径对应的inode节点，三个参数分别为目录inode节点、路径字符串和用于存储结果inode节点的指针
static int
sfs_lookup(struct inode *node, char *path, struct inode **node_store) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);//首先通过vop_fs函数获取文件系统指针，然后通过fsop_info函数获取sfs文件系统指针
    assert(*path != '\0' && *path != '/');
    vop_ref_inc(node);
    struct sfs_inode *sin = vop_info(node, sfs_inode);//获取目录inode节点对应的sfs_inode结构体指针。具体而言会被展开为访问node->in_info.__sfs_inode_info的地址，从而获取到对应的sfs_inode结构体指针。用于存储父目录的inode信息
    if (sin->din->type != SFS_TYPE_DIR) {
        vop_ref_dec(node);
        return -E_NOTDIR;
    }
    struct inode *subnode;//用于存储查找到的子节点inode
    int ret = sfs_lookup_once(sfs, sin, path, &subnode, NULL);//获取指定路径对应的inode节点，调用了上面的sfs_lookup_once函数

    vop_ref_dec(node);//不再使用父目录节点，减少引用计数
    if (ret != 0) {
        return ret;
    }
    *node_store = subnode;//将结果inode节点存储到输出参数中
    return 0;
}

//这里是sfs特定的目录操作对应于inode上的抽象操作，左值为目录操作结构体，右值为具体的函数实现，我们调用左边的函数名就能实现右边的功能
static const struct inode_ops sfs_node_dirops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_opendir,
    .vop_close                      = sfs_close,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_namefile                   = sfs_namefile,
    .vop_getdirentry                = sfs_getdirentry,
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_lookup                     = sfs_lookup,
};
//这里是sfs特定的文件操作对应于inode上的抽象操作，左值为文件操作结构体，右值为具体的函数实现
static const struct inode_ops sfs_node_fileops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_openfile,
    .vop_close                      = sfs_close,
    .vop_read                       = sfs_read,
    .vop_write                      = sfs_write,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_tryseek                    = sfs_tryseek,
    .vop_truncate                   = sfs_truncfile,
};

