#include <ulib.h>
#include <stdio.h>

int main(void) {
    const char *s = "readonly-string";
    cprintf("[cow_ro] start pid=%d s=%s (addr=%p)\n", getpid(), s, s);

    int pid = fork();
    if (pid == 0) {
        cprintf("[cow_ro-child] pid=%d s=%s\n", getpid(), s);
        exit(0);
    }

    waitpid(pid,NULL);
    cprintf("[cow_ro-parent] pid=%d s=%s\n", getpid(), s);
    return 0;
}
/*
T3: 只读页不应 COW（不会触发 fault）
不产生 Store Page Fault

COW-copy 计数不变

父子均打印同样字符串
*/