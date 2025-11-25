#include <ulib.h>
#include <stdio.h>

int main(void) {
    int x = 2;
    cprintf("[cow_parent_write] start pid=%d x=%d (addr=%p)\n", getpid(), x, &x);

    int pid = fork();
    if (pid == 0) {
        // child: wait a bit so parent writes first
        for (volatile int i = 0; i < 100000; i++);
        cprintf("[parent_write-child] pid=%d sees x=%d\n", getpid(), x);
        exit(0);
    }

    // parent writes
    x = 200;
    cprintf("[parent_write-parent] pid=%d wrote x=%d\n", getpid(), x);

    waitpid(pid,NULL);
    return 0;
}
/*
T2: 父写也能触发复制（对称性）

parent 写 y 触发 COW；parent y=20

child 最终仍看到 y=10

COW-copy 计数 +1
*/