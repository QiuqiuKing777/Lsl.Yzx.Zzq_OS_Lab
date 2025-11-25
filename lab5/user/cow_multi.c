#include <ulib.h>
#include <stdio.h>

int main(void) {
    int x = 3;
    cprintf("[cow_multi] parent pid=%d initial x=%d (addr=%p)\n", getpid(), x, &x);

    for (int k = 0; k < 3; k++) {
        int pid = fork();
        if (pid == 0) {
            // child k
            cprintf("[cow_multi-child%d] pid=%d before write x=%d\n", k, getpid(), x);
            x = 300 + k;
            cprintf("[cow_multi-child%d] pid=%d after  write x=%d\n", k, getpid(), x);
            exit(0);
        }
        waitpid(pid,NULL);
        cprintf("[cow_multi-parent] after child%d x=%d\n", k, x);
    }

    cprintf("[cow_multi] parent done pid=%d final x=%d\n", getpid(), x);
    return 0;
}

/*
T4: 多子进程共享同一页：ref>2 的正确复制链
child1 写 => 触发复制一次

child2 写 => 也应触发复制一次（因为 parent 仍持有旧页 ref>1）

parent 仍 z=100

child1 z=101；child2 z=102

COW-copy 计数应 +2
*/