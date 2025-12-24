# Lab 8 扩展练习报告

## Challenge 1：完成基于“UNIX的PIPE机制”的设计方案

### 1. 概要设计

UNIX 管道（Pipe）是一种进程间通信机制，允许一个进程的输出作为另一个进程的输入。在 ucore 中实现管道，本质上是创建一个内核缓冲区，并将其抽象为文件（inode），使得进程可以通过文件描述符（fd）对其进行读写。

管道是单向的字节流。通常 `pipe()` 系统调用会返回两个文件描述符，一个用于读，一个用于写。

### 2. 数据结构设计

我们需要定义一个管道特有的信息结构体，它可以作为 `inode` 的 `in_info` 联合体的一部分，或者作为一个独立的结构体被 `inode` 引用。

```c
#define PIPE_SIZE 4096

/* 管道缓冲区及控制信息 */
struct pipe_info {
    char buffer[PIPE_SIZE];     // 环形缓冲区
    off_t read_pos;             // 读指针位置
    off_t write_pos;            // 写指针位置
    size_t cnt;                 // 当前缓冲区中的字节数
    
    semaphore_t mutex;          // 互斥锁，保护缓冲区操作
    semaphore_t wait_reader;    // 读者等待信号量（用于同步：缓冲区空时等待）
    semaphore_t wait_writer;    // 写者等待信号量（用于同步：缓冲区满时等待）
    
    int readers;                // 打开读端的进程数
    int writers;                // 打开写端的进程数
    bool is_closed;             // 管道是否已完全关闭
};

/* 扩展 inode 的 union，或者在创建 inode 时分配 private data */
// 在 ucore 的 inode 结构中，通常通过 device 或 sfs_inode 来区分。
// 对于 pipe，我们可以定义一个新的 inode type: inode_type_pipe_info
```

### 3. 接口及语义

#### 3.1 `int pipe(int fd[2])`
*   **语义**：创建一个管道，分配两个文件描述符。`fd[0]` 用于读，`fd[1]` 用于写。
*   **实现思路**：
    1.  分配一个新的 `struct pipe_info`。
    2.  初始化缓冲区、信号量（`mutex=1`, `wait_reader=0`, `wait_writer=PIPE_SIZE`）。
    3.  创建两个 `struct file` 对象，分别关联到同一个（或两个关联的）`inode`。
    4.  这两个 `file` 对象分别标记为只读和只写。
    5.  将 `file` 对象映射到当前进程的两个空闲 fd。

#### 3.2 `read(fd, buf, count)`
*   **语义**：从管道读取数据。
*   **实现思路**：
    1.  获取 `mutex`。
    2.  如果缓冲区为空：
        *   如果写端已关闭（`writers == 0`），返回 0 (EOF)。
        *   否则，释放 `mutex`，在 `wait_reader` 上等待（P操作），被唤醒后重新获取 `mutex`。
    3.  从 `buffer` 读取数据到用户 `buf`。
    4.  更新 `read_pos` 和 `cnt`。
    5.  唤醒等待的写者（V操作 `wait_writer`）。
    6.  释放 `mutex`。

#### 3.3 `write(fd, buf, count)`
*   **语义**：向管道写入数据。
*   **实现思路**：
    1.  获取 `mutex`。
    2.  如果读端已关闭（`readers == 0`），发送 `SIGPIPE` 信号给进程，返回错误。
    3.  如果缓冲区已满：
        *   释放 `mutex`，在 `wait_writer` 上等待（P操作），被唤醒后重新获取 `mutex`。
    4.  将数据从用户 `buf` 写入 `buffer`。
    5.  更新 `write_pos` 和 `cnt`。
    6.  唤醒等待的读者（V操作 `wait_reader`）。
    7.  释放 `mutex`。

#### 3.4 `close(fd)`
*   **语义**：关闭管道的一端。
*   **实现思路**：
    1.  获取 `mutex`。
    2.  如果是读端关闭，`readers--`；如果是写端关闭，`writers--`。
    3.  如果 `readers == 0` 且 `writers == 0`，释放 `pipe_info` 内存。
    4.  如果 `writers` 变为 0，唤醒所有等待的读者（让它们读到 EOF）。
    5.  如果 `readers` 变为 0，唤醒所有等待的写者（让它们收到错误）。
    6.  释放 `mutex`。

### 4. 同步互斥处理
*   **互斥**：使用 `mutex` 信号量保证对 `buffer`、`read_pos`、`write_pos` 等状态的原子访问。
*   **同步**：
    *   **读者等待**：当缓冲区空时，读者在 `wait_reader` 上等待。写者写入数据后执行 `up(&wait_reader)`。
    *   **写者等待**：当缓冲区满时，写者在 `wait_writer` 上等待。读者读出数据后执行 `up(&wait_writer)`。

---

## Challenge 2：完成基于“UNIX的软连接和硬连接机制”的设计方案

### 1. 概要设计

*   **硬链接（Hard Link）**：在文件系统中，多个目录项（Directory Entry）指向同一个 inode。删除一个硬链接只是减少 inode 的引用计数，只有当引用计数为 0 且文件未被打开时，才真正删除文件数据。
*   **软链接（Soft Link / Symbolic Link）**：一种特殊类型的文件，其内容是指向另一个文件的路径字符串。

### 2. 数据结构设计

#### 2.1 硬链接
SFS 的磁盘 inode 结构 `struct sfs_disk_inode` 已经包含 `nlinks` 字段，我们需要在内存 inode `struct sfs_inode` 中也维护这个计数，并确保同步。

```c
/* kern/fs/sfs/sfs.h */
struct sfs_disk_inode {
    // ...
    uint16_t nlinks;    /* 硬链接计数 */
    // ...
};
```

#### 2.2 软链接
需要定义一种新的文件类型 `SFS_TYPE_LINK`。

```c
/* kern/fs/sfs/sfs.h */
#define SFS_TYPE_LINK   3

/* 软链接的 inode 内容与普通文件类似，但其数据块存储的是路径字符串 */
```

### 3. 接口及语义

#### 3.1 硬链接接口

**`int link(const char *oldpath, const char *newpath)`**
*   **语义**：为 `oldpath` 指定的文件创建一个名为 `newpath` 的新硬链接。
*   **实现思路**：
    1.  查找 `oldpath` 对应的 inode (`old_inode`)。
    2.  检查 `old_inode` 是否为目录（通常不允许对目录创建硬链接以避免环）。
    3.  在 `newpath` 的父目录下创建一个新的目录项（entry），指向 `old_inode` 的 inode 编号 (`ino`)。
    4.  `old_inode->nlinks++`。
    5.  将 `old_inode` 的更新写回磁盘。

**`int unlink(const char *path)`**
*   **语义**：删除 `path` 对应的目录项。
*   **实现思路**：
    1.  查找 `path` 对应的 inode (`target_inode`) 和其父目录 inode。
    2.  从父目录中删除对应的目录项。
    3.  `target_inode->nlinks--`。
    4.  如果 `target_inode->nlinks == 0` 且 `open_count == 0`：
        *   释放 `target_inode` 占用的所有数据块。
        *   释放 `target_inode` 本身。
    5.  否则，仅将 `nlinks` 的变化写回磁盘。

#### 3.2 软链接接口

**`int symlink(const char *target, const char *linkpath)`**
*   **语义**：创建一个名为 `linkpath` 的软链接，指向 `target`。
*   **实现思路**：
    1.  在 `linkpath` 的父目录下创建一个新文件。
    2.  设置新文件的 inode 类型为 `SFS_TYPE_LINK`。
    3.  将 `target` 字符串写入新文件的数据块中。

**`int readlink(const char *path, char *buf, size_t bufsiz)`**
*   **语义**：读取软链接本身的内容（即目标路径）。
*   **实现思路**：
    1.  打开 `path` 对应的 inode。
    2.  检查 inode 类型是否为 `SFS_TYPE_LINK`。
    3.  读取 inode 的数据块内容到 `buf`。

**`open()` 的修改**
*   **语义**：当打开文件时，如果遇到软链接，需要根据策略决定是否跟随。
*   **实现思路**：
    1.  在 `vop_lookup` 或 `vfs_lookup` 过程中，如果解析到的 inode 是 `SFS_TYPE_LINK`：
    2.  读取其内容（目标路径）。
    3.  递归调用 lookup 解析目标路径。
    4.  需要设置最大递归深度（如 5 或 8）以防止死循环。

### 4. 同步互斥处理

*   **硬链接**：
    *   `nlinks` 的修改需要原子操作或锁保护。SFS 中已有 `mutex_sem` 用于 link/unlink 操作。
    *   在 `unlink` 时，需要检查 `open_count`。这需要 VFS 层和 SFS 层的配合。如果文件被打开，`unlink` 只减少 `nlinks`，文件删除推迟到 `vop_reclaim`（即最后一个 `close`）时进行。

*   **软链接**：
    *   创建软链接涉及分配 inode 和数据块，需要使用 SFS 的位图锁。
    *   读取软链接内容是只读操作，可以使用读写锁或普通的 inode 锁。
