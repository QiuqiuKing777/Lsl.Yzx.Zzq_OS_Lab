#ifndef __KERN_SYNC_SYNC_H__
#define __KERN_SYNC_SYNC_H__

#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}
 /* do...while(0) ensures that no matter what content our macro called,it is compatible with all kind of structure*/
 /* for xample,when our macro is called in an if-else,while we use a straight-forward grammar below*/
 /* #define .. x=__intr_save(); ......... and call it in such an content below: */
 /* if(condition) local_intr_restore(x);else ... ->it would be compiled as*/
 /* if() ...;; else,there will be two semi,which conflicts the grammar*/
 /* also,in some more complicated circumstances,when we have more than one sentence in a macro*/
 /* you'll see:*/
 /* if() ...; ...; ...; else....; only the first sentence will be judged in the if stmt*/
#define local_intr_save(x) \
    do {                   \
        x = __intr_save(); \
    } while (0)
#define local_intr_restore(x) __intr_restore(x);

#endif /* !__KERN_SYNC_SYNC_H__ */
