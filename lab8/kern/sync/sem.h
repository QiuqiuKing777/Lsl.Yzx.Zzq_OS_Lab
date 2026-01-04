#ifndef __KERN_SYNC_SEM_H__
#define __KERN_SYNC_SEM_H__

#include <defs.h>
#include <atomic.h>
#include <wait.h>

typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;

void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);//给信号量加一
void down(semaphore_t *sem);//给信号量减一，若value小于0则阻塞
bool try_down(semaphore_t *sem);

#endif /* !__KERN_SYNC_SEM_H__ */

