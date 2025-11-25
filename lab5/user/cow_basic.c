#include <ulib.h>
#include <stdio.h>
#include <unistd.h>


static volatile int x = 1;

int main(void) {
    cprintf("[cow_basic] start pid=%d x=%d (addr=%p)\n", getpid(), x, &x);

    int pid = fork();
    if (pid == 0) {
        // child
        cprintf("[cow_basic-child] pid=%d before write x=%d\n", getpid(), x);
        x = 2;  // should trigger COW
        cprintf("[cow_basic-child] pid=%d after  write x=%d\n", getpid(), x);
        exit(0);
    } else {
        // parent
        waitpid(pid, NULL);
        cprintf("[cow_basic-parent] pid=%d after child exit x=%d\n", getpid(), x);
    }
    return 0;
}
/*
T1: fork 后共享页、写触发复制
fork 之后，child 第一次写 x 时触发 Store Page Fault，内核走 COW 分配新页。

child 输出 x=2，parent 最终仍输出 x=1。

若在 COW handler 里打印了 COW-copy 计数，此处计数 应 +1。
*/