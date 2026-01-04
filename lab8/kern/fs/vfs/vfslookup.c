#include <defs.h>
#include <string.h>
#include <vfs.h>
#include <inode.h>
#include <error.h>
#include <assert.h>

/*
 * get_device- Common code to pull the device name, if any, off the front of a
 *             path and choose the inode to begin the name lookup relative to.
 */
//用于解析路径中的设备名称，并获取对应的起始inode节点。
static int
get_device(char *path, char **subpath, struct inode **node_store) {
    int i, slash = -1, colon = -1;
    for (i = 0; path[i] != '\0'; i ++) {
        if (path[i] == ':') { colon = i; break; }//查找冒号位置
        if (path[i] == '/') { slash = i; break; }//查找斜杠位置
    }
    if (colon < 0 && slash != 0) {//如果路径中没有冒号且第一个字符不是斜杠，则表示这是一个相对路径或裸文件名，我们需要获取当前目录的inode节点作为起始节点，然后将subpath指向原始路径
        
        *subpath = path;
        return vfs_get_curdir(node_store);//获取当前目录的inode节点
    }
    if (colon > 0) {//如果路径中包含冒号且冒号不在第一个位置，则表示路径以设备名称开头，我们需要将冒号前的部分作为设备名称，调用vfs_get_root函数获取该设备的文件系统根节点作为起始节点，然后将subpath指向冒号后的路径部分
        path[colon] = '\0';

        while (path[++ colon] == '/');//跳过冒号后的斜杠
        *subpath = path + colon;//将subpath指向冒号后的路径部分,subpath指向真正的路径部分
        return vfs_get_root(path, node_store);//获取设备的文件系统根节点
    }

    //处理以根目录开头的路径
    int ret;
    if (*path == '/') {//例如"/..."，表示从根目录开始查找
        if ((ret = vfs_get_bootfs(node_store)) != 0) {//获取根文件系统的根节点
            return ret;
        }
    }
    else {//如果路径以冒号开头，例如":/..."，表示从当前目录开始查找
        assert(*path == ':');
        struct inode *node;
        if ((ret = vfs_get_curdir(&node)) != 0) {//获取当前目录的inode节点
            return ret;
        }
        //当前目录可能不是一个设备，这是因为当前目录所在的文件系统可能是挂载在某个设备上的，我们需要获取该文件系统的根节点作为起始节点，因此它必须有一个文件系统
        assert(node->in_fs != NULL);
        *node_store = fsop_get_root(node->in_fs);//获取当前文件系统的根节点
        vop_ref_dec(node);
    }

    /* ///... or :/... */
    //如果路径以斜杠开头，例如"/..."或":/..."，我们需要跳过开头的斜杠，找到真正的路径部分
    while (*(++ path) == '/');
    *subpath = path;
    return 0;
}

/*
 * vfs_lookup - get the inode according to the path filename
 */
//用于根据路径获取对应的inode节点。具体操作是调用get_device函数解析路径中的设备名称并获取起始inode节点，然后检查路径是否为空，如果不为空则调用vop_lookup函数在起始节点下查找指定路径的inode节点，最后返回结果
int
vfs_lookup(char *path, struct inode **node_store) {
    int ret;
    struct inode *node;
    if ((ret = get_device(path, &path, &node)) != 0) {
        return ret;
    }
    if (*path != '\0') {
        ret = vop_lookup(node, path, node_store);//用于在指定的inode节点下查找路径对应的子节点，并将找到的子节点存储在node_store中
        vop_ref_dec(node);
        return ret;
    }
    *node_store = node;
    return 0;
}

/*
 * vfs_lookup_parent - Name-to-vnode translation.
 *  (In BSD, both of these are subsumed by namei().)
 */
//用于获取路径的父目录inode节点。具体操作是调用get_device函数解析路径中的设备名称并获取起始inode节点，然后将endp指向路径的当前位置，并通过node_store参数返回起始节点
int
vfs_lookup_parent(char *path, struct inode **node_store, char **endp){
    int ret;
    struct inode *node;
    if ((ret = get_device(path, &path, &node)) != 0) {
        return ret;
    }
    *endp = path;//将endp指向路径的当前位置，endp是用于返回父目录路径的指针
    *node_store = node;//通过node_store参数返回起始节点
    return 0;
}
