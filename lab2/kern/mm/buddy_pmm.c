#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <buddy_pmm.h>

/* 简化版的 Buddy System 实现 */

#define BUDDY_MAX_ORDER       15
#define MAX_BUDDY_PAGES       (1 << BUDDY_MAX_ORDER)

// 空闲区域数组，每个元素对应一种阶数的空闲块链表
static free_area_t free_area[BUDDY_MAX_ORDER + 1];

// 记录每个物理页的阶数
static int buddy_order[MAX_BUDDY_PAGES];
// 记录伙伴系统的内存基址，即第一个物理页的地址
static struct Page *buddy_base;

static inline int
is_power_of_2(size_t n) {
    return (n & (n - 1)) == 0;//2的幂次方在二进制中只有一位为1，减1后所有低位为1，按位与结果为0
}

//将一个数向上取整为最近的2的幂次方
static inline size_t
round_up_power_of_2(size_t n) {
    size_t ret = 1;
    while (ret < n) {
        ret <<= 1;
    }
    return ret;
}

//计算满足大小为n的内存块所需的阶数,既满足2^order>=n
static int
get_order(size_t n) {
    int order = 0;
    size_t size = 1;
    while (size < n) {
        order++;
        size <<= 1;
    }
    return order;
}

//获取空闲页面的总数
static size_t
buddy_nr_free_pages(void) {
    size_t total = 0;
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
        total += free_area[i].nr_free;
    }
    return total;
}

static void
buddy_init(void) {
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
        list_init(&free_area[i].free_list);//初始化链表
        free_area[i].nr_free = 0;//初始化空闲页数为0
    }
    memset(buddy_order, 0, sizeof(buddy_order));//初始化阶数数组
}

static void
buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    cprintf("buddy_init_memmap: base=%p, n=%d\n", base, n);
    
    buddy_base = base;//记录内存基址
    
    //初始化所有页面属性
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(PageReserved(p));//确保当前正在初始化的物理页p在进行管理前处于保留状态
        p->flags = 0;//清除标志位
        SetPageProperty(p);//将原本处于保留状态的物理页标记为可被伙伴系统管理的空闲页，使其能够参与后续的内存分配与释放过程。
        set_page_ref(p, 0);//引用计数设为0
    }
    
    //找到最大的2的幂次块，能够容纳n个页面
    int max_order = BUDDY_MAX_ORDER;
    while (max_order >= 0) {
        int block_size = (1 << max_order);//1左移max_order位，即2^max_order个页面
        if (block_size <= n) {
            break;
        }
        max_order--;
    }
    
    if (max_order < 0) {
        ////如果n太小，使用最小块（1页）
        max_order = 0;
    }
    
    int block_size = (1 << max_order);
    base->property = block_size;/*base是当前初始化的内存块的起始页指针，将前面计算得到的块大小存储到块的起始页的 property字段中。*/
    
    //设置块中所有页面的阶数
    for (int i = 0; i < block_size; i++) {
        buddy_order[i] = max_order;/*将当前内存块中所有页面的阶数统一设置为max_order，这样buddy_order[0]-buddy_order[2^max_order]里就全设置为了max_order,表名这2^max_order个页面属于同一个2^max_order大小的块。*/
    }
    
    // 添加到空闲链表
    list_add(&free_area[max_order].free_list, &(base->page_link));
    /*
    第一个参数 &free_area[max_order].free_list,表示目标链表的头节点，即阶数为max_order的空闲块链表（伙伴系统中每种阶数都有独立的空闲链表）。第二个参数 &(base->page_link),表示要添加的节点，即当前初始化的内存块起始页base中的链表节点（page_link是struct Page 结构体中用于链表连接的成员）
    */
    free_area[max_order].nr_free += block_size;
    
    cprintf("Initialized buddy with single block: size=%d, order=%d\n", block_size, max_order);
    
    //如果有剩余页面，在这里简化处理
    if (block_size < n) {
        cprintf("Remaining pages: %d, will be handled later\n", n - block_size);
    }
}
static struct Page *
buddy_alloc_pages(size_t n) {
    assert(n > 0);
    //检查请求是否超过最大支持页数
    if (n > MAX_BUDDY_PAGES) {
        return NULL;
    }
    
    //计算需要的阶数
    int req_order = get_order(n);
    
    //从req_order开始查找可用的块
    int current_order = req_order;
    while (current_order <= BUDDY_MAX_ORDER) {
        if (!list_empty(&free_area[current_order].free_list)) {
            //找到可用的块，获取链表中的第一个块
            list_entry_t *le = list_next(&free_area[current_order].free_list);
            struct Page *page = le2page(le, page_link);
            
            //从空闲链表中移除该块
            list_del(le);
            free_area[current_order].nr_free -= (1 << current_order);
            
            //如果块太大，需要分裂成更小的块
            while (current_order > req_order) {
                current_order--;
                int split_size = (1 << current_order);
                
                //计算伙伴块的位置（当前块地址 + split_size）
                struct Page *buddy = page + split_size;
                buddy->property = split_size;
                SetPageProperty(buddy);
                
                //设置伙伴块中所有页面的阶数
                int page_idx = page - buddy_base;
                for (int i = 0; i < split_size; i++) {
                    buddy_order[page_idx + split_size + i] = current_order;
                    /*在将一个高阶块分裂为两个低阶子块后，为新产生的伙伴块中的所有页面设置正确的阶数，这里的是为后面那一块设置阶数。*/
                }
                
                //将伙伴块加入对应阶数的空闲链表
                list_add(&free_area[current_order].free_list, &(buddy->page_link));
                free_area[current_order].nr_free += split_size;
            }
            
            //标记为已分配
            ClearPageProperty(page);
            int page_idx = page - buddy_base;//计算当前物理页在整个伙伴系统管理范围内的索引位置
            for (int i = 0; i < (1 << req_order); i++) {
                // 这里可以设置分配标记，但ucore没有现成的字段，我们通过property=0来表示已分配
            }
            //记录实际分配的大小，用于释放
            page->property = n; 
            return page;
        }
        current_order++;//尝试更大的阶数
    }
    //没有找到合适的块
    return NULL;
}

static void
buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    //计算页面索引和阶数
    int idx = base - buddy_base;
    int order = get_order(n);
    
    //标记为未分配（空闲）
    SetPageProperty(base);
    base->property = (1 << order);//记录块大小 
    
    //设置释放块中所有页面的阶数
    for (int i = 0; i < (1 << order); i++) {
        buddy_order[idx + i] = order;
    }
    
    //尝试合并伙伴块，从当前阶数向上合并
    while (order < BUDDY_MAX_ORDER) {
        //计算伙伴块的索引（异或操作可以找到伙伴）
        int buddy_idx = idx ^ (1 << order);
        /*
        仅翻转idx的第order位，其余位不变，这与伙伴块的索引特征相同，即仅第 order 位不同，其余位相同
        */
        struct Page *buddy = buddy_base + buddy_idx;
        
        //检查伙伴是否存在、空闲且大小相同
        if (buddy_idx >= 0 && PageProperty(buddy) && buddy_order[buddy_idx] == order) {
            //从链表中移除伙伴
            list_del(&(buddy->page_link));
            free_area[order].nr_free -= (1 << order);
            //选择索引较小的作为新块进行合并
            if (idx > buddy_idx) {
                idx = buddy_idx;
                base = buddy;
            }
            //阶数加1，块大小翻倍
            order++;
            base->property = (1 << order);
            
            //更新合并后块中所有页面的阶数
            for (int i = 0; i < (1 << order); i++) {
                buddy_order[idx + i] = order;
            }
        } else {
            //无法继续合并，则退出循环
            break;
        }
    }
    
    // 将合并后的块加入链表
    list_add(&free_area[order].free_list, &(base->page_link));
    free_area[order].nr_free += (1 << order);
}


static void
buddy_check(void) {
    cprintf("伙伴系统物理内存分配测试：\n");
    
    size_t initial_free = buddy_nr_free_pages();
    
    // 测试1: 基本分配释放
    cprintf("基本分配释放\n");
    struct Page *p1 = buddy_alloc_pages(1);
    struct Page *p2 = buddy_alloc_pages(2);
    struct Page *p3 = buddy_alloc_pages(4);
    cprintf("  alloc 1p: %p\n", p1);
    cprintf("  alloc 2p: %p\n", p2);
    cprintf("  alloc 4p: %p\n", p3);
    assert(p1 && p2 && p3);
    
    buddy_free_pages(p1, 1);
    buddy_free_pages(p2, 2);
    buddy_free_pages(p3, 4);
    assert(buddy_nr_free_pages() == initial_free);
    cprintf("  passed\n");
    
    // 测试2: 伙伴合并
    cprintf("伙伴合并：\n");
    struct Page *a1 = buddy_alloc_pages(1);
    struct Page *a2 = buddy_alloc_pages(1);
    cprintf("  alloc 1p: %p\n", a1);
    cprintf("  alloc 1p: %p\n", a2);
    
    buddy_free_pages(a1, 1);
    buddy_free_pages(a2, 1);
    
    struct Page *merged = buddy_alloc_pages(2);
    cprintf("  merged 2p: %p\n", merged);
    assert(merged != NULL);
    buddy_free_pages(merged, 2);
    cprintf("  passed\n");
    
    // 测试3: 混合分配
    cprintf("混合分配：\n");
    struct Page *m1 = buddy_alloc_pages(1);
    struct Page *m2 = buddy_alloc_pages(3); // 实际分配4页
    struct Page *m3 = buddy_alloc_pages(8);
    cprintf("  alloc 1p: %p\n", m1);
    cprintf("  alloc 3p: %p\n", m2);
    cprintf("  alloc 8p: %p\n", m3);
    assert(m1 && m2 && m3);
    
    buddy_free_pages(m1, 1);
    buddy_free_pages(m2, 3);
    buddy_free_pages(m3, 8);
    assert(buddy_nr_free_pages() == initial_free);
    cprintf("  passed\n");
    
    cprintf("All tests passed!\n");
}


const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
