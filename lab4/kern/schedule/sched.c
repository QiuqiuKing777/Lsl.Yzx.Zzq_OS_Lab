#include <list.h>
#include <sync.h>
#include <proc.h>
#include <sched.h>
#include <assert.h>
//fifo strategy proc schedule
void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
    proc->state = PROC_RUNNABLE;
}
//状态为RUNNABLE的进程会被选中
void
schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);//after this,id intr_flag=1,means trap disabled 关中断保护临界区
    {
        current->need_resched = 0;//clear need reschedule flag,avoid resched again 将对应进程的need_resched标志置零，避免再次调度
        //if nowa idle:start search from head,else from next proc of temp
        //如果是idle进程，则从链表头开始寻找；否则从当前进程的下一个进程开始寻找
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {// 查找一个RUNNABLE状态的进程
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {//ve founded the one
                    break;
                }
            }
        } while (le != last);
        //如果最后没有找到RUNNABLE状态的进程，就用idle进程保底
        if (next == NULL || next->state != PROC_RUNNABLE) {
            next = idleproc;//not runnable found
        }
        //增加该进程运行次数
        next->runs ++;//count++
        if (next != current) {
            proc_run(next);//run the founded runnable proc
        }
    }
    local_intr_restore(intr_flag);
}
