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

void
schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);//after this,id intr_flag=1,means trap disabled
    {
        current->need_resched = 0;//clear need reschedule flag,avoid resched again
        //if nowa idle:start search from head,else from next proc of temp
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {//ve founded the one
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
            next = idleproc;//not runnable found
        }
        next->runs ++;//count++
        if (next != current) {
            proc_run(next);//run the founded runnable proc
        }
    }
    local_intr_restore(intr_flag);
}
