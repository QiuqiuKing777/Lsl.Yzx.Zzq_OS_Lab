
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00005297          	auipc	t0,0x5
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0205000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00005297          	auipc	t0,0x5
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0205008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02042b7          	lui	t0,0xc0204
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0204137          	lui	sp,0xc0204

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	30c50513          	addi	a0,a0,780 # ffffffffc0201358 <etext+0x2>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	31650513          	addi	a0,a0,790 # ffffffffc0201378 <etext+0x22>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	2e858593          	addi	a1,a1,744 # ffffffffc0201356 <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	32250513          	addi	a0,a0,802 # ffffffffc0201398 <etext+0x42>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00005597          	auipc	a1,0x5
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0205018 <buddy_order>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	32e50513          	addi	a0,a0,814 # ffffffffc02013b8 <etext+0x62>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00025597          	auipc	a1,0x25
ffffffffc020009a:	15258593          	addi	a1,a1,338 # ffffffffc02251e8 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	33a50513          	addi	a0,a0,826 # ffffffffc02013d8 <etext+0x82>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00025597          	auipc	a1,0x25
ffffffffc02000ae:	53d58593          	addi	a1,a1,1341 # ffffffffc02255e7 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00001517          	auipc	a0,0x1
ffffffffc02000d0:	32c50513          	addi	a0,a0,812 # ffffffffc02013f8 <etext+0xa2>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00005517          	auipc	a0,0x5
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0205018 <buddy_order>
ffffffffc02000e0:	00025617          	auipc	a2,0x25
ffffffffc02000e4:	10860613          	addi	a2,a2,264 # ffffffffc02251e8 <end>
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	254010ef          	jal	ra,ffffffffc0201344 <memset>
    dtb_init();
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00001517          	auipc	a0,0x1
ffffffffc0200100:	32c50513          	addi	a0,a0,812 # ffffffffc0201428 <etext+0xd2>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010c:	3df000ef          	jal	ra,ffffffffc0200cea <pmm_init>

    /* do nothing */
    while (1)
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    (*cnt) ++;
ffffffffc020011e:	401c                	lw	a5,0(s0)
}
ffffffffc0200120:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
}
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200140:	5ef000ef          	jal	ra,ffffffffc0200f2e <vprintfmt>
    return cnt;
}
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0204028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200172:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200174:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	5b9000ef          	jal	ra,ffffffffc0200f2e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c2:	00025317          	auipc	t1,0x25
ffffffffc02001c6:	fd630313          	addi	t1,t1,-42 # ffffffffc0225198 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00001517          	auipc	a0,0x1
ffffffffc02001f6:	25650513          	addi	a0,a0,598 # ffffffffc0201448 <etext+0xf2>
    va_start(ap, fmt);
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
    cprintf("\n");
ffffffffc0200208:	00001517          	auipc	a0,0x1
ffffffffc020020c:	21850513          	addi	a0,a0,536 # ffffffffc0201420 <etext+0xca>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	0940106f          	j	ffffffffc02012b0 <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200220:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200222:	00001517          	auipc	a0,0x1
ffffffffc0200226:	24650513          	addi	a0,a0,582 # ffffffffc0201468 <etext+0x112>
void dtb_init(void) {
ffffffffc020022a:	fc86                	sd	ra,120(sp)
ffffffffc020022c:	f8a2                	sd	s0,112(sp)
ffffffffc020022e:	e8d2                	sd	s4,80(sp)
ffffffffc0200230:	f4a6                	sd	s1,104(sp)
ffffffffc0200232:	f0ca                	sd	s2,96(sp)
ffffffffc0200234:	ecce                	sd	s3,88(sp)
ffffffffc0200236:	e4d6                	sd	s5,72(sp)
ffffffffc0200238:	e0da                	sd	s6,64(sp)
ffffffffc020023a:	fc5e                	sd	s7,56(sp)
ffffffffc020023c:	f862                	sd	s8,48(sp)
ffffffffc020023e:	f466                	sd	s9,40(sp)
ffffffffc0200240:	f06a                	sd	s10,32(sp)
ffffffffc0200242:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200248:	00005597          	auipc	a1,0x5
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0205000 <boot_hartid>
ffffffffc0200250:	00001517          	auipc	a0,0x1
ffffffffc0200254:	22850513          	addi	a0,a0,552 # ffffffffc0201478 <etext+0x122>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020025c:	00005417          	auipc	s0,0x5
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0205008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	22250513          	addi	a0,a0,546 # ffffffffc0201488 <etext+0x132>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200276:	00001517          	auipc	a0,0x1
ffffffffc020027a:	22a50513          	addi	a0,a0,554 # ffffffffc02014a0 <etext+0x14a>
    if (boot_dtb == 0) {
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020028a:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200290:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002bc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfebad05>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02002ca:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002f4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200302:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020031c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200320:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200326:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200328:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020032e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200330:	00001917          	auipc	s2,0x1
ffffffffc0200334:	1c090913          	addi	s2,s2,448 # ffffffffc02014f0 <etext+0x19a>
ffffffffc0200338:	49bd                	li	s3,15
        switch (token) {
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020033e:	00001497          	auipc	s1,0x1
ffffffffc0200342:	1aa48493          	addi	s1,s1,426 # ffffffffc02014e8 <etext+0x192>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200392:	00001517          	auipc	a0,0x1
ffffffffc0200396:	1d650513          	addi	a0,a0,470 # ffffffffc0201568 <etext+0x212>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020039e:	00001517          	auipc	a0,0x1
ffffffffc02003a2:	20250513          	addi	a0,a0,514 # ffffffffc02015a0 <etext+0x24a>
}
ffffffffc02003a6:	7446                	ld	s0,112(sp)
ffffffffc02003a8:	70e6                	ld	ra,120(sp)
ffffffffc02003aa:	74a6                	ld	s1,104(sp)
ffffffffc02003ac:	7906                	ld	s2,96(sp)
ffffffffc02003ae:	69e6                	ld	s3,88(sp)
ffffffffc02003b0:	6a46                	ld	s4,80(sp)
ffffffffc02003b2:	6aa6                	ld	s5,72(sp)
ffffffffc02003b4:	6b06                	ld	s6,64(sp)
ffffffffc02003b6:	7be2                	ld	s7,56(sp)
ffffffffc02003b8:	7c42                	ld	s8,48(sp)
ffffffffc02003ba:	7ca2                	ld	s9,40(sp)
ffffffffc02003bc:	7d02                	ld	s10,32(sp)
ffffffffc02003be:	6de2                	ld	s11,24(sp)
ffffffffc02003c0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
}
ffffffffc02003c4:	7446                	ld	s0,112(sp)
ffffffffc02003c6:	70e6                	ld	ra,120(sp)
ffffffffc02003c8:	74a6                	ld	s1,104(sp)
ffffffffc02003ca:	7906                	ld	s2,96(sp)
ffffffffc02003cc:	69e6                	ld	s3,88(sp)
ffffffffc02003ce:	6a46                	ld	s4,80(sp)
ffffffffc02003d0:	6aa6                	ld	s5,72(sp)
ffffffffc02003d2:	6b06                	ld	s6,64(sp)
ffffffffc02003d4:	7be2                	ld	s7,56(sp)
ffffffffc02003d6:	7c42                	ld	s8,48(sp)
ffffffffc02003d8:	7ca2                	ld	s9,40(sp)
ffffffffc02003da:	7d02                	ld	s10,32(sp)
ffffffffc02003dc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003de:	00001517          	auipc	a0,0x1
ffffffffc02003e2:	0e250513          	addi	a0,a0,226 # ffffffffc02014c0 <etext+0x16a>
}
ffffffffc02003e6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
                int name_len = strlen(name);
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	6df000ef          	jal	ra,ffffffffc02012ca <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02003f8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003fa:	725000ef          	jal	ra,ffffffffc020131e <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200400:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020042e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	671000ef          	jal	ra,ffffffffc0201300 <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004a4:	00001517          	auipc	a0,0x1
ffffffffc02004a8:	05450513          	addi	a0,a0,84 # ffffffffc02014f8 <etext+0x1a2>
           fdt32_to_cpu(x >> 32);
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200532:	011b78b3          	and	a7,s6,a7
ffffffffc0200536:	005eeeb3          	or	t4,t4,t0
ffffffffc020053a:	00c6e733          	or	a4,a3,a2
ffffffffc020053e:	006c6c33          	or	s8,s8,t1
ffffffffc0200542:	010b76b3          	and	a3,s6,a6
ffffffffc0200546:	00bb7b33          	and	s6,s6,a1
ffffffffc020054a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020054e:	016c6b33          	or	s6,s8,s6
ffffffffc0200552:	01146433          	or	s0,s0,a7
ffffffffc0200556:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020055c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020055e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200560:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00001517          	auipc	a0,0x1
ffffffffc0200576:	fa650513          	addi	a0,a0,-90 # ffffffffc0201518 <etext+0x1c2>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00001517          	auipc	a0,0x1
ffffffffc0200588:	fac50513          	addi	a0,a0,-84 # ffffffffc0201530 <etext+0x1da>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00001517          	auipc	a0,0x1
ffffffffc020059a:	fba50513          	addi	a0,a0,-70 # ffffffffc0201550 <etext+0x1fa>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005a2:	00001517          	auipc	a0,0x1
ffffffffc02005a6:	ffe50513          	addi	a0,a0,-2 # ffffffffc02015a0 <etext+0x24a>
        memory_base = mem_base;
ffffffffc02005aa:	00025797          	auipc	a5,0x25
ffffffffc02005ae:	be87bb23          	sd	s0,-1034(a5) # ffffffffc02251a0 <memory_base>
        memory_size = mem_size;
ffffffffc02005b2:	00025797          	auipc	a5,0x25
ffffffffc02005b6:	bf67bb23          	sd	s6,-1034(a5) # ffffffffc02251a8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02005bc:	00025517          	auipc	a0,0x25
ffffffffc02005c0:	be453503          	ld	a0,-1052(a0) # ffffffffc02251a0 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc02005c6:	00025517          	auipc	a0,0x25
ffffffffc02005ca:	be253503          	ld	a0,-1054(a0) # ffffffffc02251a8 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_nr_free_pages>:

//获取空闲页面的总数
static size_t
buddy_nr_free_pages(void) {
    size_t total = 0;
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc02005d0:	00025797          	auipc	a5,0x25
ffffffffc02005d4:	a5878793          	addi	a5,a5,-1448 # ffffffffc0225028 <free_area+0x10>
ffffffffc02005d8:	00025697          	auipc	a3,0x25
ffffffffc02005dc:	bd068693          	addi	a3,a3,-1072 # ffffffffc02251a8 <memory_size>
    size_t total = 0;
ffffffffc02005e0:	4501                	li	a0,0
        total += free_area[i].nr_free;
ffffffffc02005e2:	0007e703          	lwu	a4,0(a5)
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc02005e6:	07e1                	addi	a5,a5,24
        total += free_area[i].nr_free;
ffffffffc02005e8:	953a                	add	a0,a0,a4
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc02005ea:	fed79ce3          	bne	a5,a3,ffffffffc02005e2 <buddy_nr_free_pages+0x12>
    }
    return total;
}
ffffffffc02005ee:	8082                	ret

ffffffffc02005f0 <buddy_free_pages>:
    //没有找到合适的块
    return NULL;
}

static void
buddy_free_pages(struct Page *base, size_t n) {
ffffffffc02005f0:	1141                	addi	sp,sp,-16
ffffffffc02005f2:	e406                	sd	ra,8(sp)
ffffffffc02005f4:	e022                	sd	s0,0(sp)
    assert(n > 0);
ffffffffc02005f6:	16058863          	beqz	a1,ffffffffc0200766 <buddy_free_pages+0x176>
    //计算页面索引和阶数
    int idx = base - buddy_base;
    int order = get_order(n);
    
    //标记为未分配（空闲）
    SetPageProperty(base);
ffffffffc02005fa:	651c                	ld	a5,8(a0)
    int idx = base - buddy_base;
ffffffffc02005fc:	00025e97          	auipc	t4,0x25
ffffffffc0200600:	bb4ebe83          	ld	t4,-1100(t4) # ffffffffc02251b0 <buddy_base>
ffffffffc0200604:	41d50833          	sub	a6,a0,t4
ffffffffc0200608:	00001717          	auipc	a4,0x1
ffffffffc020060c:	5c873703          	ld	a4,1480(a4) # ffffffffc0201bd0 <error_string+0x38>
ffffffffc0200610:	40385813          	srai	a6,a6,0x3
    while (size < n) {
ffffffffc0200614:	4685                	li	a3,1
    int idx = base - buddy_base;
ffffffffc0200616:	02e8083b          	mulw	a6,a6,a4
    SetPageProperty(base);
ffffffffc020061a:	0027e713          	ori	a4,a5,2
    while (size < n) {
ffffffffc020061e:	12d58863          	beq	a1,a3,ffffffffc020074e <buddy_free_pages+0x15e>
    size_t size = 1;
ffffffffc0200622:	4785                	li	a5,1
    int order = 0;
ffffffffc0200624:	4681                	li	a3,0
        size <<= 1;
ffffffffc0200626:	0786                	slli	a5,a5,0x1
        order++;
ffffffffc0200628:	2685                	addiw	a3,a3,1
    while (size < n) {
ffffffffc020062a:	feb7eee3          	bltu	a5,a1,ffffffffc0200626 <buddy_free_pages+0x36>
    base->property = (1 << order);//记录块大小 
ffffffffc020062e:	4785                	li	a5,1
ffffffffc0200630:	00d7963b          	sllw	a2,a5,a3
    SetPageProperty(base);
ffffffffc0200634:	e518                	sd	a4,8(a0)
    base->property = (1 << order);//记录块大小 
ffffffffc0200636:	c910                	sw	a2,16(a0)
    
    //设置释放块中所有页面的阶数
    for (int i = 0; i < (1 << order); i++) {
ffffffffc0200638:	00c05f63          	blez	a2,ffffffffc0200656 <buddy_free_pages+0x66>
ffffffffc020063c:	00005717          	auipc	a4,0x5
ffffffffc0200640:	9dc70713          	addi	a4,a4,-1572 # ffffffffc0205018 <buddy_order>
ffffffffc0200644:	00281793          	slli	a5,a6,0x2
ffffffffc0200648:	97ba                	add	a5,a5,a4
ffffffffc020064a:	4701                	li	a4,0
        buddy_order[idx + i] = order;
ffffffffc020064c:	c394                	sw	a3,0(a5)
    for (int i = 0; i < (1 << order); i++) {
ffffffffc020064e:	2705                	addiw	a4,a4,1
ffffffffc0200650:	0791                	addi	a5,a5,4
ffffffffc0200652:	fec74de3          	blt	a4,a2,ffffffffc020064c <buddy_free_pages+0x5c>
    }
    
    //尝试合并伙伴块，从当前阶数向上合并
    while (order < BUDDY_MAX_ORDER) {
ffffffffc0200656:	47b9                	li	a5,14
ffffffffc0200658:	10d7c063          	blt	a5,a3,ffffffffc0200758 <buddy_free_pages+0x168>
        //计算伙伴块的索引（异或操作可以找到伙伴）
        int buddy_idx = idx ^ (1 << order);
ffffffffc020065c:	00c84733          	xor	a4,a6,a2
ffffffffc0200660:	2701                	sext.w	a4,a4
        /*
        仅翻转idx的第order位，其余位不变，这与伙伴块的索引特征相同，即仅第 order 位不同，其余位相同
        */
        struct Page *buddy = buddy_base + buddy_idx;
ffffffffc0200662:	00271593          	slli	a1,a4,0x2
ffffffffc0200666:	00e587b3          	add	a5,a1,a4
ffffffffc020066a:	078e                	slli	a5,a5,0x3
ffffffffc020066c:	97f6                	add	a5,a5,t4
        
        //检查伙伴是否存在、空闲且大小相同
        if (buddy_idx >= 0 && PageProperty(buddy) && buddy_order[buddy_idx] == order) {
ffffffffc020066e:	0e074563          	bltz	a4,ffffffffc0200758 <buddy_free_pages+0x168>
ffffffffc0200672:	00169893          	slli	a7,a3,0x1
ffffffffc0200676:	98b6                	add	a7,a7,a3
ffffffffc0200678:	00025297          	auipc	t0,0x25
ffffffffc020067c:	9a028293          	addi	t0,t0,-1632 # ffffffffc0225018 <free_area>
ffffffffc0200680:	088e                	slli	a7,a7,0x3
ffffffffc0200682:	9896                	add	a7,a7,t0
ffffffffc0200684:	00005e17          	auipc	t3,0x5
ffffffffc0200688:	994e0e13          	addi	t3,t3,-1644 # ffffffffc0205018 <buddy_order>
                idx = buddy_idx;
                base = buddy;
            }
            //阶数加1，块大小翻倍
            order++;
            base->property = (1 << order);
ffffffffc020068c:	4f85                	li	t6,1
ffffffffc020068e:	00005397          	auipc	t2,0x5
ffffffffc0200692:	98e38393          	addi	t2,t2,-1650 # ffffffffc020501c <buddy_order+0x4>
    while (order < BUDDY_MAX_ORDER) {
ffffffffc0200696:	4f3d                	li	t5,15
        if (buddy_idx >= 0 && PageProperty(buddy) && buddy_order[buddy_idx] == order) {
ffffffffc0200698:	0087b303          	ld	t1,8(a5)
ffffffffc020069c:	00237313          	andi	t1,t1,2
ffffffffc02006a0:	0a030363          	beqz	t1,ffffffffc0200746 <buddy_free_pages+0x156>
ffffffffc02006a4:	95f2                	add	a1,a1,t3
ffffffffc02006a6:	418c                	lw	a1,0(a1)
ffffffffc02006a8:	08d59f63          	bne	a1,a3,ffffffffc0200746 <buddy_free_pages+0x156>
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
ffffffffc02006ac:	6f80                	ld	s0,24(a5)
ffffffffc02006ae:	0207b303          	ld	t1,32(a5)
            free_area[order].nr_free -= (1 << order);
ffffffffc02006b2:	0108a583          	lw	a1,16(a7)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02006b6:	00643423          	sd	t1,8(s0)
    next->prev = prev;
ffffffffc02006ba:	00833023          	sd	s0,0(t1)
ffffffffc02006be:	40c5863b          	subw	a2,a1,a2
ffffffffc02006c2:	00c8a823          	sw	a2,16(a7)
            if (idx > buddy_idx) {
ffffffffc02006c6:	01075463          	bge	a4,a6,ffffffffc02006ce <buddy_free_pages+0xde>
ffffffffc02006ca:	883a                	mv	a6,a4
ffffffffc02006cc:	853e                	mv	a0,a5
            order++;
ffffffffc02006ce:	2685                	addiw	a3,a3,1
            base->property = (1 << order);
ffffffffc02006d0:	00df963b          	sllw	a2,t6,a3
ffffffffc02006d4:	c910                	sw	a2,16(a0)
ffffffffc02006d6:	8332                	mv	t1,a2
            
            //更新合并后块中所有页面的阶数
            for (int i = 0; i < (1 << order); i++) {
ffffffffc02006d8:	02c05063          	blez	a2,ffffffffc02006f8 <buddy_free_pages+0x108>
ffffffffc02006dc:	fff6071b          	addiw	a4,a2,-1
ffffffffc02006e0:	1702                	slli	a4,a4,0x20
ffffffffc02006e2:	9301                	srli	a4,a4,0x20
ffffffffc02006e4:	9742                	add	a4,a4,a6
ffffffffc02006e6:	00281793          	slli	a5,a6,0x2
ffffffffc02006ea:	070a                	slli	a4,a4,0x2
ffffffffc02006ec:	97f2                	add	a5,a5,t3
ffffffffc02006ee:	971e                	add	a4,a4,t2
                buddy_order[idx + i] = order;
ffffffffc02006f0:	c394                	sw	a3,0(a5)
            for (int i = 0; i < (1 << order); i++) {
ffffffffc02006f2:	0791                	addi	a5,a5,4
ffffffffc02006f4:	fee79ee3          	bne	a5,a4,ffffffffc02006f0 <buddy_free_pages+0x100>
    while (order < BUDDY_MAX_ORDER) {
ffffffffc02006f8:	01e68e63          	beq	a3,t5,ffffffffc0200714 <buddy_free_pages+0x124>
        int buddy_idx = idx ^ (1 << order);
ffffffffc02006fc:	01064733          	xor	a4,a2,a6
ffffffffc0200700:	2701                	sext.w	a4,a4
        struct Page *buddy = buddy_base + buddy_idx;
ffffffffc0200702:	00271593          	slli	a1,a4,0x2
ffffffffc0200706:	00e587b3          	add	a5,a1,a4
ffffffffc020070a:	078e                	slli	a5,a5,0x3
ffffffffc020070c:	97f6                	add	a5,a5,t4
        if (buddy_idx >= 0 && PageProperty(buddy) && buddy_order[buddy_idx] == order) {
ffffffffc020070e:	08e1                	addi	a7,a7,24
ffffffffc0200710:	f80754e3          	bgez	a4,ffffffffc0200698 <buddy_free_pages+0xa8>
    __list_add(elm, listelm, listelm->next);
ffffffffc0200714:	00169793          	slli	a5,a3,0x1
ffffffffc0200718:	97b6                	add	a5,a5,a3
ffffffffc020071a:	078e                	slli	a5,a5,0x3
ffffffffc020071c:	92be                	add	t0,t0,a5
ffffffffc020071e:	0082b703          	ld	a4,8(t0)
        }
    }
    
    // 将合并后的块加入链表
    list_add(&free_area[order].free_list, &(base->page_link));
    free_area[order].nr_free += (1 << order);
ffffffffc0200722:	0102a783          	lw	a5,16(t0)
    list_add(&free_area[order].free_list, &(base->page_link));
ffffffffc0200726:	01850693          	addi	a3,a0,24
    prev->next = next->prev = elm;
ffffffffc020072a:	e314                	sd	a3,0(a4)
ffffffffc020072c:	00d2b423          	sd	a3,8(t0)
}
ffffffffc0200730:	60a2                	ld	ra,8(sp)
ffffffffc0200732:	6402                	ld	s0,0(sp)
    elm->next = next;
ffffffffc0200734:	f118                	sd	a4,32(a0)
    elm->prev = prev;
ffffffffc0200736:	00553c23          	sd	t0,24(a0)
    free_area[order].nr_free += (1 << order);
ffffffffc020073a:	0067833b          	addw	t1,a5,t1
ffffffffc020073e:	0062a823          	sw	t1,16(t0)
}
ffffffffc0200742:	0141                	addi	sp,sp,16
ffffffffc0200744:	8082                	ret
    free_area[order].nr_free += (1 << order);
ffffffffc0200746:	4305                	li	t1,1
ffffffffc0200748:	00d3133b          	sllw	t1,t1,a3
ffffffffc020074c:	b7e1                	j	ffffffffc0200714 <buddy_free_pages+0x124>
    SetPageProperty(base);
ffffffffc020074e:	e518                	sd	a4,8(a0)
    base->property = (1 << order);//记录块大小 
ffffffffc0200750:	c90c                	sw	a1,16(a0)
    int order = 0;
ffffffffc0200752:	4681                	li	a3,0
    base->property = (1 << order);//记录块大小 
ffffffffc0200754:	4605                	li	a2,1
ffffffffc0200756:	b5dd                	j	ffffffffc020063c <buddy_free_pages+0x4c>
    free_area[order].nr_free += (1 << order);
ffffffffc0200758:	0006031b          	sext.w	t1,a2
ffffffffc020075c:	00025297          	auipc	t0,0x25
ffffffffc0200760:	8bc28293          	addi	t0,t0,-1860 # ffffffffc0225018 <free_area>
ffffffffc0200764:	bf45                	j	ffffffffc0200714 <buddy_free_pages+0x124>
    assert(n > 0);
ffffffffc0200766:	00001697          	auipc	a3,0x1
ffffffffc020076a:	e5268693          	addi	a3,a3,-430 # ffffffffc02015b8 <etext+0x262>
ffffffffc020076e:	00001617          	auipc	a2,0x1
ffffffffc0200772:	e5260613          	addi	a2,a2,-430 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200776:	0b600593          	li	a1,182
ffffffffc020077a:	00001517          	auipc	a0,0x1
ffffffffc020077e:	e5e50513          	addi	a0,a0,-418 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200782:	a41ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200786 <buddy_init>:
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200786:	00025797          	auipc	a5,0x25
ffffffffc020078a:	89278793          	addi	a5,a5,-1902 # ffffffffc0225018 <free_area>
ffffffffc020078e:	00025717          	auipc	a4,0x25
ffffffffc0200792:	a0a70713          	addi	a4,a4,-1526 # ffffffffc0225198 <is_panic>
    elm->prev = elm->next = elm;
ffffffffc0200796:	e79c                	sd	a5,8(a5)
ffffffffc0200798:	e39c                	sd	a5,0(a5)
        free_area[i].nr_free = 0;//初始化空闲页数为0
ffffffffc020079a:	0007a823          	sw	zero,16(a5)
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc020079e:	07e1                	addi	a5,a5,24
ffffffffc02007a0:	fee79be3          	bne	a5,a4,ffffffffc0200796 <buddy_init+0x10>
    memset(buddy_order, 0, sizeof(buddy_order));//初始化阶数数组
ffffffffc02007a4:	00020637          	lui	a2,0x20
ffffffffc02007a8:	4581                	li	a1,0
ffffffffc02007aa:	00005517          	auipc	a0,0x5
ffffffffc02007ae:	86e50513          	addi	a0,a0,-1938 # ffffffffc0205018 <buddy_order>
ffffffffc02007b2:	3930006f          	j	ffffffffc0201344 <memset>

ffffffffc02007b6 <buddy_alloc_pages.part.0>:
    while (size < n) {
ffffffffc02007b6:	4785                	li	a5,1
buddy_alloc_pages(size_t n) {
ffffffffc02007b8:	8eaa                	mv	t4,a0
    int order = 0;
ffffffffc02007ba:	4801                	li	a6,0
    while (size < n) {
ffffffffc02007bc:	00a7f963          	bgeu	a5,a0,ffffffffc02007ce <buddy_alloc_pages.part.0+0x18>
        size <<= 1;
ffffffffc02007c0:	0786                	slli	a5,a5,0x1
        order++;
ffffffffc02007c2:	2805                	addiw	a6,a6,1
    while (size < n) {
ffffffffc02007c4:	ffd7eee3          	bltu	a5,t4,ffffffffc02007c0 <buddy_alloc_pages.part.0+0xa>
    while (current_order <= BUDDY_MAX_ORDER) {
ffffffffc02007c8:	47bd                	li	a5,15
ffffffffc02007ca:	1107c063          	blt	a5,a6,ffffffffc02008ca <buddy_alloc_pages.part.0+0x114>
ffffffffc02007ce:	00181793          	slli	a5,a6,0x1
ffffffffc02007d2:	97c2                	add	a5,a5,a6
ffffffffc02007d4:	00025597          	auipc	a1,0x25
ffffffffc02007d8:	84458593          	addi	a1,a1,-1980 # ffffffffc0225018 <free_area>
ffffffffc02007dc:	078e                	slli	a5,a5,0x3
ffffffffc02007de:	97ae                	add	a5,a5,a1
    int order = 0;
ffffffffc02007e0:	8742                	mv	a4,a6
    while (current_order <= BUDDY_MAX_ORDER) {
ffffffffc02007e2:	46c1                	li	a3,16
ffffffffc02007e4:	a029                	j	ffffffffc02007ee <buddy_alloc_pages.part.0+0x38>
        current_order++;//尝试更大的阶数
ffffffffc02007e6:	2705                	addiw	a4,a4,1
    while (current_order <= BUDDY_MAX_ORDER) {
ffffffffc02007e8:	07e1                	addi	a5,a5,24
ffffffffc02007ea:	0ed70063          	beq	a4,a3,ffffffffc02008ca <buddy_alloc_pages.part.0+0x114>
    return list->next == list;
ffffffffc02007ee:	0087b303          	ld	t1,8(a5)
        if (!list_empty(&free_area[current_order].free_list)) {
ffffffffc02007f2:	fef30ae3          	beq	t1,a5,ffffffffc02007e6 <buddy_alloc_pages.part.0+0x30>
            free_area[current_order].nr_free -= (1 << current_order);
ffffffffc02007f6:	00171793          	slli	a5,a4,0x1
ffffffffc02007fa:	97ba                	add	a5,a5,a4
ffffffffc02007fc:	078e                	slli	a5,a5,0x3
    __list_del(listelm->prev, listelm->next);
ffffffffc02007fe:	00033e03          	ld	t3,0(t1)
ffffffffc0200802:	00833883          	ld	a7,8(t1)
ffffffffc0200806:	00f58533          	add	a0,a1,a5
ffffffffc020080a:	4914                	lw	a3,16(a0)
ffffffffc020080c:	4605                	li	a2,1
    prev->next = next;
ffffffffc020080e:	011e3423          	sd	a7,8(t3)
ffffffffc0200812:	00e6163b          	sllw	a2,a2,a4
    next->prev = prev;
ffffffffc0200816:	01c8b023          	sd	t3,0(a7)
ffffffffc020081a:	9e91                	subw	a3,a3,a2
ffffffffc020081c:	c914                	sw	a3,16(a0)
            struct Page *page = le2page(le, page_link);
ffffffffc020081e:	fe830513          	addi	a0,t1,-24
            while (current_order > req_order) {
ffffffffc0200822:	08e85c63          	bge	a6,a4,ffffffffc02008ba <buddy_alloc_pages.part.0+0x104>
                int page_idx = page - buddy_base;
ffffffffc0200826:	00025f17          	auipc	t5,0x25
ffffffffc020082a:	98af3f03          	ld	t5,-1654(t5) # ffffffffc02251b0 <buddy_base>
ffffffffc020082e:	41e50f33          	sub	t5,a0,t5
ffffffffc0200832:	403f5f13          	srai	t5,t5,0x3
ffffffffc0200836:	00001697          	auipc	a3,0x1
ffffffffc020083a:	39a6b683          	ld	a3,922(a3) # ffffffffc0201bd0 <error_string+0x38>
ffffffffc020083e:	02df0f3b          	mulw	t5,t5,a3
ffffffffc0200842:	17a1                	addi	a5,a5,-24
ffffffffc0200844:	95be                	add	a1,a1,a5
ffffffffc0200846:	00004397          	auipc	t2,0x4
ffffffffc020084a:	7d238393          	addi	t2,t2,2002 # ffffffffc0205018 <buddy_order>
ffffffffc020084e:	00004297          	auipc	t0,0x4
ffffffffc0200852:	7ce28293          	addi	t0,t0,1998 # ffffffffc020501c <buddy_order+0x4>
                int split_size = (1 << current_order);
ffffffffc0200856:	4f85                	li	t6,1
                current_order--;
ffffffffc0200858:	377d                	addiw	a4,a4,-1
                int split_size = (1 << current_order);
ffffffffc020085a:	00ef97bb          	sllw	a5,t6,a4
                struct Page *buddy = page + split_size;
ffffffffc020085e:	00279613          	slli	a2,a5,0x2
ffffffffc0200862:	963e                	add	a2,a2,a5
ffffffffc0200864:	060e                	slli	a2,a2,0x3
ffffffffc0200866:	962a                	add	a2,a2,a0
ffffffffc0200868:	fff7869b          	addiw	a3,a5,-1
                SetPageProperty(buddy);
ffffffffc020086c:	00863e03          	ld	t3,8(a2) # 20008 <kern_entry-0xffffffffc01dfff8>
ffffffffc0200870:	1682                	slli	a3,a3,0x20
                int split_size = (1 << current_order);
ffffffffc0200872:	88be                	mv	a7,a5
                buddy->property = split_size;
ffffffffc0200874:	9281                	srli	a3,a3,0x20
ffffffffc0200876:	01e787bb          	addw	a5,a5,t5
ffffffffc020087a:	96be                	add	a3,a3,a5
                SetPageProperty(buddy);
ffffffffc020087c:	002e6e13          	ori	t3,t3,2
ffffffffc0200880:	078a                	slli	a5,a5,0x2
ffffffffc0200882:	068a                	slli	a3,a3,0x2
                buddy->property = split_size;
ffffffffc0200884:	01162823          	sw	a7,16(a2)
                SetPageProperty(buddy);
ffffffffc0200888:	01c63423          	sd	t3,8(a2)
                for (int i = 0; i < split_size; i++) {
ffffffffc020088c:	979e                	add	a5,a5,t2
ffffffffc020088e:	9696                	add	a3,a3,t0
                    buddy_order[page_idx + split_size + i] = current_order;
ffffffffc0200890:	c398                	sw	a4,0(a5)
                for (int i = 0; i < split_size; i++) {
ffffffffc0200892:	0791                	addi	a5,a5,4
ffffffffc0200894:	fef69ee3          	bne	a3,a5,ffffffffc0200890 <buddy_alloc_pages.part.0+0xda>
    __list_add(elm, listelm, listelm->next);
ffffffffc0200898:	6594                	ld	a3,8(a1)
                free_area[current_order].nr_free += split_size;
ffffffffc020089a:	499c                	lw	a5,16(a1)
                list_add(&free_area[current_order].free_list, &(buddy->page_link));
ffffffffc020089c:	01860e13          	addi	t3,a2,24
    prev->next = next->prev = elm;
ffffffffc02008a0:	01c6b023          	sd	t3,0(a3)
ffffffffc02008a4:	01c5b423          	sd	t3,8(a1)
    elm->prev = prev;
ffffffffc02008a8:	ee0c                	sd	a1,24(a2)
    elm->next = next;
ffffffffc02008aa:	f214                	sd	a3,32(a2)
                free_area[current_order].nr_free += split_size;
ffffffffc02008ac:	011788bb          	addw	a7,a5,a7
ffffffffc02008b0:	0115a823          	sw	a7,16(a1)
            while (current_order > req_order) {
ffffffffc02008b4:	15a1                	addi	a1,a1,-24
ffffffffc02008b6:	fae811e3          	bne	a6,a4,ffffffffc0200858 <buddy_alloc_pages.part.0+0xa2>
            ClearPageProperty(page);
ffffffffc02008ba:	ff033783          	ld	a5,-16(t1)
            page->property = n; 
ffffffffc02008be:	ffd32c23          	sw	t4,-8(t1)
            ClearPageProperty(page);
ffffffffc02008c2:	9bf5                	andi	a5,a5,-3
ffffffffc02008c4:	fef33823          	sd	a5,-16(t1)
            return page;
ffffffffc02008c8:	8082                	ret
    return NULL;
ffffffffc02008ca:	4501                	li	a0,0
}
ffffffffc02008cc:	8082                	ret

ffffffffc02008ce <buddy_alloc_pages>:
    assert(n > 0);
ffffffffc02008ce:	c519                	beqz	a0,ffffffffc02008dc <buddy_alloc_pages+0xe>
    if (n > MAX_BUDDY_PAGES) {
ffffffffc02008d0:	6721                	lui	a4,0x8
ffffffffc02008d2:	00a76363          	bltu	a4,a0,ffffffffc02008d8 <buddy_alloc_pages+0xa>
ffffffffc02008d6:	b5c5                	j	ffffffffc02007b6 <buddy_alloc_pages.part.0>
}
ffffffffc02008d8:	4501                	li	a0,0
ffffffffc02008da:	8082                	ret
buddy_alloc_pages(size_t n) {
ffffffffc02008dc:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02008de:	00001697          	auipc	a3,0x1
ffffffffc02008e2:	cda68693          	addi	a3,a3,-806 # ffffffffc02015b8 <etext+0x262>
ffffffffc02008e6:	00001617          	auipc	a2,0x1
ffffffffc02008ea:	cda60613          	addi	a2,a2,-806 # ffffffffc02015c0 <etext+0x26a>
ffffffffc02008ee:	07900593          	li	a1,121
ffffffffc02008f2:	00001517          	auipc	a0,0x1
ffffffffc02008f6:	ce650513          	addi	a0,a0,-794 # ffffffffc02015d8 <etext+0x282>
buddy_alloc_pages(size_t n) {
ffffffffc02008fa:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02008fc:	8c7ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200900 <buddy_check>:


static void
buddy_check(void) {
ffffffffc0200900:	7139                	addi	sp,sp,-64
    cprintf("伙伴系统物理内存分配测试：\n");
ffffffffc0200902:	00001517          	auipc	a0,0x1
ffffffffc0200906:	cee50513          	addi	a0,a0,-786 # ffffffffc02015f0 <etext+0x29a>
buddy_check(void) {
ffffffffc020090a:	f822                	sd	s0,48(sp)
ffffffffc020090c:	f426                	sd	s1,40(sp)
ffffffffc020090e:	f04a                	sd	s2,32(sp)
ffffffffc0200910:	fc06                	sd	ra,56(sp)
ffffffffc0200912:	ec4e                	sd	s3,24(sp)
ffffffffc0200914:	e852                	sd	s4,16(sp)
ffffffffc0200916:	e456                	sd	s5,8(sp)
ffffffffc0200918:	00024417          	auipc	s0,0x24
ffffffffc020091c:	71040413          	addi	s0,s0,1808 # ffffffffc0225028 <free_area+0x10>
    cprintf("伙伴系统物理内存分配测试：\n");
ffffffffc0200920:	82dff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200924:	00025497          	auipc	s1,0x25
ffffffffc0200928:	88448493          	addi	s1,s1,-1916 # ffffffffc02251a8 <memory_size>
    cprintf("伙伴系统物理内存分配测试：\n");
ffffffffc020092c:	87a2                	mv	a5,s0
    size_t total = 0;
ffffffffc020092e:	4901                	li	s2,0
        total += free_area[i].nr_free;
ffffffffc0200930:	0007e703          	lwu	a4,0(a5)
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200934:	07e1                	addi	a5,a5,24
        total += free_area[i].nr_free;
ffffffffc0200936:	993a                	add	s2,s2,a4
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200938:	fe979ce3          	bne	a5,s1,ffffffffc0200930 <buddy_check+0x30>
    
    size_t initial_free = buddy_nr_free_pages();
    
    // 测试1: 基本分配释放
    cprintf("基本分配释放\n");
ffffffffc020093c:	00001517          	auipc	a0,0x1
ffffffffc0200940:	ce450513          	addi	a0,a0,-796 # ffffffffc0201620 <etext+0x2ca>
ffffffffc0200944:	809ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (n > MAX_BUDDY_PAGES) {
ffffffffc0200948:	4505                	li	a0,1
ffffffffc020094a:	e6dff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc020094e:	8aaa                	mv	s5,a0
ffffffffc0200950:	4509                	li	a0,2
ffffffffc0200952:	e65ff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc0200956:	8a2a                	mv	s4,a0
ffffffffc0200958:	4511                	li	a0,4
ffffffffc020095a:	e5dff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc020095e:	89aa                	mv	s3,a0
    struct Page *p1 = buddy_alloc_pages(1);
    struct Page *p2 = buddy_alloc_pages(2);
    struct Page *p3 = buddy_alloc_pages(4);
    cprintf("  alloc 1p: %p\n", p1);
ffffffffc0200960:	85d6                	mv	a1,s5
ffffffffc0200962:	00001517          	auipc	a0,0x1
ffffffffc0200966:	cd650513          	addi	a0,a0,-810 # ffffffffc0201638 <etext+0x2e2>
ffffffffc020096a:	fe2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  alloc 2p: %p\n", p2);
ffffffffc020096e:	85d2                	mv	a1,s4
ffffffffc0200970:	00001517          	auipc	a0,0x1
ffffffffc0200974:	cd850513          	addi	a0,a0,-808 # ffffffffc0201648 <etext+0x2f2>
ffffffffc0200978:	fd4ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  alloc 4p: %p\n", p3);
ffffffffc020097c:	85ce                	mv	a1,s3
ffffffffc020097e:	00001517          	auipc	a0,0x1
ffffffffc0200982:	cda50513          	addi	a0,a0,-806 # ffffffffc0201658 <etext+0x302>
ffffffffc0200986:	fc6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    assert(p1 && p2 && p3);
ffffffffc020098a:	160a8663          	beqz	s5,ffffffffc0200af6 <buddy_check+0x1f6>
ffffffffc020098e:	160a0463          	beqz	s4,ffffffffc0200af6 <buddy_check+0x1f6>
ffffffffc0200992:	16098263          	beqz	s3,ffffffffc0200af6 <buddy_check+0x1f6>
    
    buddy_free_pages(p1, 1);
ffffffffc0200996:	4585                	li	a1,1
ffffffffc0200998:	8556                	mv	a0,s5
ffffffffc020099a:	c57ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    buddy_free_pages(p2, 2);
ffffffffc020099e:	4589                	li	a1,2
ffffffffc02009a0:	8552                	mv	a0,s4
ffffffffc02009a2:	c4fff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    buddy_free_pages(p3, 4);
ffffffffc02009a6:	4591                	li	a1,4
ffffffffc02009a8:	854e                	mv	a0,s3
ffffffffc02009aa:	c47ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
ffffffffc02009ae:	00024797          	auipc	a5,0x24
ffffffffc02009b2:	67a78793          	addi	a5,a5,1658 # ffffffffc0225028 <free_area+0x10>
    size_t total = 0;
ffffffffc02009b6:	4701                	li	a4,0
        total += free_area[i].nr_free;
ffffffffc02009b8:	0007e683          	lwu	a3,0(a5)
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc02009bc:	07e1                	addi	a5,a5,24
        total += free_area[i].nr_free;
ffffffffc02009be:	9736                	add	a4,a4,a3
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc02009c0:	fe979ce3          	bne	a5,s1,ffffffffc02009b8 <buddy_check+0xb8>
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc02009c4:	1ae91963          	bne	s2,a4,ffffffffc0200b76 <buddy_check+0x276>
    cprintf("  passed\n");
ffffffffc02009c8:	00001517          	auipc	a0,0x1
ffffffffc02009cc:	cd850513          	addi	a0,a0,-808 # ffffffffc02016a0 <etext+0x34a>
ffffffffc02009d0:	f7cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    // 测试2: 伙伴合并
    cprintf("伙伴合并：\n");
ffffffffc02009d4:	00001517          	auipc	a0,0x1
ffffffffc02009d8:	cdc50513          	addi	a0,a0,-804 # ffffffffc02016b0 <etext+0x35a>
ffffffffc02009dc:	f70ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (n > MAX_BUDDY_PAGES) {
ffffffffc02009e0:	4505                	li	a0,1
ffffffffc02009e2:	dd5ff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc02009e6:	8a2a                	mv	s4,a0
ffffffffc02009e8:	4505                	li	a0,1
ffffffffc02009ea:	dcdff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc02009ee:	89aa                	mv	s3,a0
    struct Page *a1 = buddy_alloc_pages(1);
    struct Page *a2 = buddy_alloc_pages(1);
    cprintf("  alloc 1p: %p\n", a1);
ffffffffc02009f0:	85d2                	mv	a1,s4
ffffffffc02009f2:	00001517          	auipc	a0,0x1
ffffffffc02009f6:	c4650513          	addi	a0,a0,-954 # ffffffffc0201638 <etext+0x2e2>
ffffffffc02009fa:	f52ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  alloc 1p: %p\n", a2);
ffffffffc02009fe:	85ce                	mv	a1,s3
ffffffffc0200a00:	00001517          	auipc	a0,0x1
ffffffffc0200a04:	c3850513          	addi	a0,a0,-968 # ffffffffc0201638 <etext+0x2e2>
ffffffffc0200a08:	f44ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    buddy_free_pages(a1, 1);
ffffffffc0200a0c:	4585                	li	a1,1
ffffffffc0200a0e:	8552                	mv	a0,s4
ffffffffc0200a10:	be1ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    buddy_free_pages(a2, 1);
ffffffffc0200a14:	4585                	li	a1,1
ffffffffc0200a16:	854e                	mv	a0,s3
ffffffffc0200a18:	bd9ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    if (n > MAX_BUDDY_PAGES) {
ffffffffc0200a1c:	4509                	li	a0,2
ffffffffc0200a1e:	d99ff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc0200a22:	89aa                	mv	s3,a0
    
    struct Page *merged = buddy_alloc_pages(2);
    cprintf("  merged 2p: %p\n", merged);
ffffffffc0200a24:	85aa                	mv	a1,a0
ffffffffc0200a26:	00001517          	auipc	a0,0x1
ffffffffc0200a2a:	ca250513          	addi	a0,a0,-862 # ffffffffc02016c8 <etext+0x372>
ffffffffc0200a2e:	f1eff0ef          	jal	ra,ffffffffc020014c <cprintf>
    assert(merged != NULL);
ffffffffc0200a32:	12098263          	beqz	s3,ffffffffc0200b56 <buddy_check+0x256>
    buddy_free_pages(merged, 2);
ffffffffc0200a36:	4589                	li	a1,2
ffffffffc0200a38:	854e                	mv	a0,s3
ffffffffc0200a3a:	bb7ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    cprintf("  passed\n");
ffffffffc0200a3e:	00001517          	auipc	a0,0x1
ffffffffc0200a42:	c6250513          	addi	a0,a0,-926 # ffffffffc02016a0 <etext+0x34a>
ffffffffc0200a46:	f06ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    // 测试3: 混合分配
    cprintf("混合分配：\n");
ffffffffc0200a4a:	00001517          	auipc	a0,0x1
ffffffffc0200a4e:	ca650513          	addi	a0,a0,-858 # ffffffffc02016f0 <etext+0x39a>
ffffffffc0200a52:	efaff0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (n > MAX_BUDDY_PAGES) {
ffffffffc0200a56:	4505                	li	a0,1
ffffffffc0200a58:	d5fff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc0200a5c:	8aaa                	mv	s5,a0
ffffffffc0200a5e:	450d                	li	a0,3
ffffffffc0200a60:	d57ff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc0200a64:	8a2a                	mv	s4,a0
ffffffffc0200a66:	4521                	li	a0,8
ffffffffc0200a68:	d4fff0ef          	jal	ra,ffffffffc02007b6 <buddy_alloc_pages.part.0>
ffffffffc0200a6c:	89aa                	mv	s3,a0
    struct Page *m1 = buddy_alloc_pages(1);
    struct Page *m2 = buddy_alloc_pages(3); // 实际分配4页
    struct Page *m3 = buddy_alloc_pages(8);
    cprintf("  alloc 1p: %p\n", m1);
ffffffffc0200a6e:	85d6                	mv	a1,s5
ffffffffc0200a70:	00001517          	auipc	a0,0x1
ffffffffc0200a74:	bc850513          	addi	a0,a0,-1080 # ffffffffc0201638 <etext+0x2e2>
ffffffffc0200a78:	ed4ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  alloc 3p: %p\n", m2);
ffffffffc0200a7c:	85d2                	mv	a1,s4
ffffffffc0200a7e:	00001517          	auipc	a0,0x1
ffffffffc0200a82:	c8a50513          	addi	a0,a0,-886 # ffffffffc0201708 <etext+0x3b2>
ffffffffc0200a86:	ec6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  alloc 8p: %p\n", m3);
ffffffffc0200a8a:	85ce                	mv	a1,s3
ffffffffc0200a8c:	00001517          	auipc	a0,0x1
ffffffffc0200a90:	c8c50513          	addi	a0,a0,-884 # ffffffffc0201718 <etext+0x3c2>
ffffffffc0200a94:	eb8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    assert(m1 && m2 && m3);
ffffffffc0200a98:	060a8f63          	beqz	s5,ffffffffc0200b16 <buddy_check+0x216>
ffffffffc0200a9c:	060a0d63          	beqz	s4,ffffffffc0200b16 <buddy_check+0x216>
ffffffffc0200aa0:	06098b63          	beqz	s3,ffffffffc0200b16 <buddy_check+0x216>
    
    buddy_free_pages(m1, 1);
ffffffffc0200aa4:	4585                	li	a1,1
ffffffffc0200aa6:	8556                	mv	a0,s5
ffffffffc0200aa8:	b49ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    buddy_free_pages(m2, 3);
ffffffffc0200aac:	458d                	li	a1,3
ffffffffc0200aae:	8552                	mv	a0,s4
ffffffffc0200ab0:	b41ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    buddy_free_pages(m3, 8);
ffffffffc0200ab4:	45a1                	li	a1,8
ffffffffc0200ab6:	854e                	mv	a0,s3
ffffffffc0200ab8:	b39ff0ef          	jal	ra,ffffffffc02005f0 <buddy_free_pages>
    size_t total = 0;
ffffffffc0200abc:	4781                	li	a5,0
        total += free_area[i].nr_free;
ffffffffc0200abe:	00046703          	lwu	a4,0(s0)
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200ac2:	0461                	addi	s0,s0,24
        total += free_area[i].nr_free;
ffffffffc0200ac4:	97ba                	add	a5,a5,a4
    for (int i = 0; i <= BUDDY_MAX_ORDER; i++) {
ffffffffc0200ac6:	fe941ce3          	bne	s0,s1,ffffffffc0200abe <buddy_check+0x1be>
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc0200aca:	06f91663          	bne	s2,a5,ffffffffc0200b36 <buddy_check+0x236>
    cprintf("  passed\n");
ffffffffc0200ace:	00001517          	auipc	a0,0x1
ffffffffc0200ad2:	bd250513          	addi	a0,a0,-1070 # ffffffffc02016a0 <etext+0x34a>
ffffffffc0200ad6:	e76ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    cprintf("All tests passed!\n");
}
ffffffffc0200ada:	7442                	ld	s0,48(sp)
ffffffffc0200adc:	70e2                	ld	ra,56(sp)
ffffffffc0200ade:	74a2                	ld	s1,40(sp)
ffffffffc0200ae0:	7902                	ld	s2,32(sp)
ffffffffc0200ae2:	69e2                	ld	s3,24(sp)
ffffffffc0200ae4:	6a42                	ld	s4,16(sp)
ffffffffc0200ae6:	6aa2                	ld	s5,8(sp)
    cprintf("All tests passed!\n");
ffffffffc0200ae8:	00001517          	auipc	a0,0x1
ffffffffc0200aec:	c5050513          	addi	a0,a0,-944 # ffffffffc0201738 <etext+0x3e2>
}
ffffffffc0200af0:	6121                	addi	sp,sp,64
    cprintf("All tests passed!\n");
ffffffffc0200af2:	e5aff06f          	j	ffffffffc020014c <cprintf>
    assert(p1 && p2 && p3);
ffffffffc0200af6:	00001697          	auipc	a3,0x1
ffffffffc0200afa:	b7268693          	addi	a3,a3,-1166 # ffffffffc0201668 <etext+0x312>
ffffffffc0200afe:	00001617          	auipc	a2,0x1
ffffffffc0200b02:	ac260613          	addi	a2,a2,-1342 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200b06:	0f900593          	li	a1,249
ffffffffc0200b0a:	00001517          	auipc	a0,0x1
ffffffffc0200b0e:	ace50513          	addi	a0,a0,-1330 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200b12:	eb0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(m1 && m2 && m3);
ffffffffc0200b16:	00001697          	auipc	a3,0x1
ffffffffc0200b1a:	c1268693          	addi	a3,a3,-1006 # ffffffffc0201728 <etext+0x3d2>
ffffffffc0200b1e:	00001617          	auipc	a2,0x1
ffffffffc0200b22:	aa260613          	addi	a2,a2,-1374 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200b26:	11900593          	li	a1,281
ffffffffc0200b2a:	00001517          	auipc	a0,0x1
ffffffffc0200b2e:	aae50513          	addi	a0,a0,-1362 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200b32:	e90ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc0200b36:	00001697          	auipc	a3,0x1
ffffffffc0200b3a:	b4268693          	addi	a3,a3,-1214 # ffffffffc0201678 <etext+0x322>
ffffffffc0200b3e:	00001617          	auipc	a2,0x1
ffffffffc0200b42:	a8260613          	addi	a2,a2,-1406 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200b46:	11e00593          	li	a1,286
ffffffffc0200b4a:	00001517          	auipc	a0,0x1
ffffffffc0200b4e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200b52:	e70ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(merged != NULL);
ffffffffc0200b56:	00001697          	auipc	a3,0x1
ffffffffc0200b5a:	b8a68693          	addi	a3,a3,-1142 # ffffffffc02016e0 <etext+0x38a>
ffffffffc0200b5e:	00001617          	auipc	a2,0x1
ffffffffc0200b62:	a6260613          	addi	a2,a2,-1438 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200b66:	10d00593          	li	a1,269
ffffffffc0200b6a:	00001517          	auipc	a0,0x1
ffffffffc0200b6e:	a6e50513          	addi	a0,a0,-1426 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200b72:	e50ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc0200b76:	00001697          	auipc	a3,0x1
ffffffffc0200b7a:	b0268693          	addi	a3,a3,-1278 # ffffffffc0201678 <etext+0x322>
ffffffffc0200b7e:	00001617          	auipc	a2,0x1
ffffffffc0200b82:	a4260613          	addi	a2,a2,-1470 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200b86:	0fe00593          	li	a1,254
ffffffffc0200b8a:	00001517          	auipc	a0,0x1
ffffffffc0200b8e:	a4e50513          	addi	a0,a0,-1458 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200b92:	e30ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200b96 <buddy_init_memmap>:
buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc0200b96:	1101                	addi	sp,sp,-32
ffffffffc0200b98:	ec06                	sd	ra,24(sp)
ffffffffc0200b9a:	e822                	sd	s0,16(sp)
ffffffffc0200b9c:	e426                	sd	s1,8(sp)
ffffffffc0200b9e:	e04a                	sd	s2,0(sp)
    assert(n > 0);
ffffffffc0200ba0:	12058563          	beqz	a1,ffffffffc0200cca <buddy_init_memmap+0x134>
    cprintf("buddy_init_memmap: base=%p, n=%d\n", base, n);
ffffffffc0200ba4:	84aa                	mv	s1,a0
ffffffffc0200ba6:	842e                	mv	s0,a1
ffffffffc0200ba8:	862e                	mv	a2,a1
ffffffffc0200baa:	85aa                	mv	a1,a0
ffffffffc0200bac:	00001517          	auipc	a0,0x1
ffffffffc0200bb0:	ba450513          	addi	a0,a0,-1116 # ffffffffc0201750 <etext+0x3fa>
ffffffffc0200bb4:	d98ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (; p != base + n; p++) {
ffffffffc0200bb8:	00241693          	slli	a3,s0,0x2
ffffffffc0200bbc:	96a2                	add	a3,a3,s0
ffffffffc0200bbe:	068e                	slli	a3,a3,0x3
    buddy_base = base;//记录内存基址
ffffffffc0200bc0:	00024797          	auipc	a5,0x24
ffffffffc0200bc4:	5e97b823          	sd	s1,1520(a5) # ffffffffc02251b0 <buddy_base>
    for (; p != base + n; p++) {
ffffffffc0200bc8:	96a6                	add	a3,a3,s1
ffffffffc0200bca:	87a6                	mv	a5,s1
        SetPageProperty(p);//将原本处于保留状态的物理页标记为可被伙伴系统管理的空闲页，使其能够参与后续的内存分配与释放过程。
ffffffffc0200bcc:	4609                	li	a2,2
    for (; p != base + n; p++) {
ffffffffc0200bce:	00d48c63          	beq	s1,a3,ffffffffc0200be6 <buddy_init_memmap+0x50>
        assert(PageReserved(p));//确保当前正在初始化的物理页p在进行管理前处于保留状态
ffffffffc0200bd2:	6798                	ld	a4,8(a5)
ffffffffc0200bd4:	8b05                	andi	a4,a4,1
ffffffffc0200bd6:	cb71                	beqz	a4,ffffffffc0200caa <buddy_init_memmap+0x114>
        SetPageProperty(p);//将原本处于保留状态的物理页标记为可被伙伴系统管理的空闲页，使其能够参与后续的内存分配与释放过程。
ffffffffc0200bd8:	e790                	sd	a2,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200bda:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc0200bde:	02878793          	addi	a5,a5,40
ffffffffc0200be2:	fed798e3          	bne	a5,a3,ffffffffc0200bd2 <buddy_init_memmap+0x3c>
    int max_order = BUDDY_MAX_ORDER;
ffffffffc0200be6:	463d                	li	a2,15
        int block_size = (1 << max_order);//1左移max_order位，即2^max_order个页面
ffffffffc0200be8:	4785                	li	a5,1
    while (max_order >= 0) {
ffffffffc0200bea:	577d                	li	a4,-1
        int block_size = (1 << max_order);//1左移max_order位，即2^max_order个页面
ffffffffc0200bec:	00c795bb          	sllw	a1,a5,a2
        if (block_size <= n) {
ffffffffc0200bf0:	892e                	mv	s2,a1
ffffffffc0200bf2:	08b47263          	bgeu	s0,a1,ffffffffc0200c76 <buddy_init_memmap+0xe0>
        max_order--;
ffffffffc0200bf6:	367d                	addiw	a2,a2,-1
    while (max_order >= 0) {
ffffffffc0200bf8:	fee61ae3          	bne	a2,a4,ffffffffc0200bec <buddy_init_memmap+0x56>
ffffffffc0200bfc:	00024697          	auipc	a3,0x24
ffffffffc0200c00:	41c68693          	addi	a3,a3,1052 # ffffffffc0225018 <free_area>
ffffffffc0200c04:	4905                	li	s2,1
ffffffffc0200c06:	8836                	mv	a6,a3
ffffffffc0200c08:	4885                	li	a7,1
ffffffffc0200c0a:	4585                	li	a1,1
        max_order = 0;
ffffffffc0200c0c:	4601                	li	a2,0
ffffffffc0200c0e:	4501                	li	a0,0
    base->property = block_size;/*base是当前初始化的内存块的起始页指针，将前面计算得到的块大小存储到块的起始页的 property字段中。*/
ffffffffc0200c10:	fff5871b          	addiw	a4,a1,-1
ffffffffc0200c14:	02071793          	slli	a5,a4,0x20
ffffffffc0200c18:	01e7d713          	srli	a4,a5,0x1e
ffffffffc0200c1c:	00004317          	auipc	t1,0x4
ffffffffc0200c20:	40030313          	addi	t1,t1,1024 # ffffffffc020501c <buddy_order+0x4>
ffffffffc0200c24:	0114a823          	sw	a7,16(s1)
    for (int i = 0; i < block_size; i++) {
ffffffffc0200c28:	00004797          	auipc	a5,0x4
ffffffffc0200c2c:	3f078793          	addi	a5,a5,1008 # ffffffffc0205018 <buddy_order>
ffffffffc0200c30:	971a                	add	a4,a4,t1
        buddy_order[i] = max_order;/*将当前内存块中所有页面的阶数统一设置为max_order，这样buddy_order[0]-buddy_order[2^max_order]里就全设置为了max_order,表名这2^max_order个页面属于同一个2^max_order大小的块。*/
ffffffffc0200c32:	c390                	sw	a2,0(a5)
    for (int i = 0; i < block_size; i++) {
ffffffffc0200c34:	0791                	addi	a5,a5,4
ffffffffc0200c36:	fef71ee3          	bne	a4,a5,ffffffffc0200c32 <buddy_init_memmap+0x9c>
    __list_add(elm, listelm, listelm->next);
ffffffffc0200c3a:	00c507b3          	add	a5,a0,a2
ffffffffc0200c3e:	078e                	slli	a5,a5,0x3
ffffffffc0200c40:	97b6                	add	a5,a5,a3
ffffffffc0200c42:	6794                	ld	a3,8(a5)
    free_area[max_order].nr_free += block_size;
ffffffffc0200c44:	4b98                	lw	a4,16(a5)
    list_add(&free_area[max_order].free_list, &(base->page_link));
ffffffffc0200c46:	01848513          	addi	a0,s1,24
    prev->next = next->prev = elm;
ffffffffc0200c4a:	e288                	sd	a0,0(a3)
ffffffffc0200c4c:	e788                	sd	a0,8(a5)
    elm->next = next;
ffffffffc0200c4e:	f094                	sd	a3,32(s1)
    elm->prev = prev;
ffffffffc0200c50:	0104bc23          	sd	a6,24(s1)
    free_area[max_order].nr_free += block_size;
ffffffffc0200c54:	0117073b          	addw	a4,a4,a7
    cprintf("Initialized buddy with single block: size=%d, order=%d\n", block_size, max_order);
ffffffffc0200c58:	00001517          	auipc	a0,0x1
ffffffffc0200c5c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0201788 <etext+0x432>
    free_area[max_order].nr_free += block_size;
ffffffffc0200c60:	cb98                	sw	a4,16(a5)
    cprintf("Initialized buddy with single block: size=%d, order=%d\n", block_size, max_order);
ffffffffc0200c62:	ceaff0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (block_size < n) {
ffffffffc0200c66:	02896563          	bltu	s2,s0,ffffffffc0200c90 <buddy_init_memmap+0xfa>
}
ffffffffc0200c6a:	60e2                	ld	ra,24(sp)
ffffffffc0200c6c:	6442                	ld	s0,16(sp)
ffffffffc0200c6e:	64a2                	ld	s1,8(sp)
ffffffffc0200c70:	6902                	ld	s2,0(sp)
ffffffffc0200c72:	6105                	addi	sp,sp,32
ffffffffc0200c74:	8082                	ret
    list_add(&free_area[max_order].free_list, &(base->page_link));
ffffffffc0200c76:	00161513          	slli	a0,a2,0x1
ffffffffc0200c7a:	00c50833          	add	a6,a0,a2
ffffffffc0200c7e:	00024697          	auipc	a3,0x24
ffffffffc0200c82:	39a68693          	addi	a3,a3,922 # ffffffffc0225018 <free_area>
ffffffffc0200c86:	080e                	slli	a6,a6,0x3
    base->property = block_size;/*base是当前初始化的内存块的起始页指针，将前面计算得到的块大小存储到块的起始页的 property字段中。*/
ffffffffc0200c88:	0005889b          	sext.w	a7,a1
    list_add(&free_area[max_order].free_list, &(base->page_link));
ffffffffc0200c8c:	9836                	add	a6,a6,a3
ffffffffc0200c8e:	b749                	j	ffffffffc0200c10 <buddy_init_memmap+0x7a>
        cprintf("Remaining pages: %d, will be handled later\n", n - block_size);
ffffffffc0200c90:	412405b3          	sub	a1,s0,s2
}
ffffffffc0200c94:	6442                	ld	s0,16(sp)
ffffffffc0200c96:	60e2                	ld	ra,24(sp)
ffffffffc0200c98:	64a2                	ld	s1,8(sp)
ffffffffc0200c9a:	6902                	ld	s2,0(sp)
        cprintf("Remaining pages: %d, will be handled later\n", n - block_size);
ffffffffc0200c9c:	00001517          	auipc	a0,0x1
ffffffffc0200ca0:	b2450513          	addi	a0,a0,-1244 # ffffffffc02017c0 <etext+0x46a>
}
ffffffffc0200ca4:	6105                	addi	sp,sp,32
        cprintf("Remaining pages: %d, will be handled later\n", n - block_size);
ffffffffc0200ca6:	ca6ff06f          	j	ffffffffc020014c <cprintf>
        assert(PageReserved(p));//确保当前正在初始化的物理页p在进行管理前处于保留状态
ffffffffc0200caa:	00001697          	auipc	a3,0x1
ffffffffc0200cae:	ace68693          	addi	a3,a3,-1330 # ffffffffc0201778 <etext+0x422>
ffffffffc0200cb2:	00001617          	auipc	a2,0x1
ffffffffc0200cb6:	90e60613          	addi	a2,a2,-1778 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200cba:	04c00593          	li	a1,76
ffffffffc0200cbe:	00001517          	auipc	a0,0x1
ffffffffc0200cc2:	91a50513          	addi	a0,a0,-1766 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200cc6:	cfcff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(n > 0);
ffffffffc0200cca:	00001697          	auipc	a3,0x1
ffffffffc0200cce:	8ee68693          	addi	a3,a3,-1810 # ffffffffc02015b8 <etext+0x262>
ffffffffc0200cd2:	00001617          	auipc	a2,0x1
ffffffffc0200cd6:	8ee60613          	addi	a2,a2,-1810 # ffffffffc02015c0 <etext+0x26a>
ffffffffc0200cda:	04400593          	li	a1,68
ffffffffc0200cde:	00001517          	auipc	a0,0x1
ffffffffc0200ce2:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02015d8 <etext+0x282>
ffffffffc0200ce6:	cdcff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200cea <pmm_init>:
static void check_alloc_page(void);

// init_pmm_manager - initialize a pmm_manager instance
static void init_pmm_manager(void) {
    //pmm_manager = &best_fit_pmm_manager;//xiu gai qian
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200cea:	00001797          	auipc	a5,0x1
ffffffffc0200cee:	b1e78793          	addi	a5,a5,-1250 # ffffffffc0201808 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200cf2:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200cf4:	7179                	addi	sp,sp,-48
ffffffffc0200cf6:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200cf8:	00001517          	auipc	a0,0x1
ffffffffc0200cfc:	b4850513          	addi	a0,a0,-1208 # ffffffffc0201840 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200d00:	00024417          	auipc	s0,0x24
ffffffffc0200d04:	4c840413          	addi	s0,s0,1224 # ffffffffc02251c8 <pmm_manager>
void pmm_init(void) {
ffffffffc0200d08:	f406                	sd	ra,40(sp)
ffffffffc0200d0a:	ec26                	sd	s1,24(sp)
ffffffffc0200d0c:	e44e                	sd	s3,8(sp)
ffffffffc0200d0e:	e84a                	sd	s2,16(sp)
ffffffffc0200d10:	e052                	sd	s4,0(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200d12:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200d14:	c38ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    pmm_manager->init();
ffffffffc0200d18:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200d1a:	00024497          	auipc	s1,0x24
ffffffffc0200d1e:	4c648493          	addi	s1,s1,1222 # ffffffffc02251e0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200d22:	679c                	ld	a5,8(a5)
ffffffffc0200d24:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200d26:	57f5                	li	a5,-3
ffffffffc0200d28:	07fa                	slli	a5,a5,0x1e
ffffffffc0200d2a:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0200d2c:	891ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc0200d30:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0200d32:	895ff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0200d36:	14050d63          	beqz	a0,ffffffffc0200e90 <pmm_init+0x1a6>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200d3a:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc0200d3c:	00001517          	auipc	a0,0x1
ffffffffc0200d40:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0201888 <buddy_pmm_manager+0x80>
ffffffffc0200d44:	c08ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200d48:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200d4c:	864e                	mv	a2,s3
ffffffffc0200d4e:	fffa0693          	addi	a3,s4,-1
ffffffffc0200d52:	85ca                	mv	a1,s2
ffffffffc0200d54:	00001517          	auipc	a0,0x1
ffffffffc0200d58:	b4c50513          	addi	a0,a0,-1204 # ffffffffc02018a0 <buddy_pmm_manager+0x98>
ffffffffc0200d5c:	bf0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200d60:	c80007b7          	lui	a5,0xc8000
ffffffffc0200d64:	8652                	mv	a2,s4
ffffffffc0200d66:	0d47e463          	bltu	a5,s4,ffffffffc0200e2e <pmm_init+0x144>
ffffffffc0200d6a:	00025797          	auipc	a5,0x25
ffffffffc0200d6e:	47d78793          	addi	a5,a5,1149 # ffffffffc02261e7 <end+0xfff>
ffffffffc0200d72:	757d                	lui	a0,0xfffff
ffffffffc0200d74:	8d7d                	and	a0,a0,a5
ffffffffc0200d76:	8231                	srli	a2,a2,0xc
ffffffffc0200d78:	00024797          	auipc	a5,0x24
ffffffffc0200d7c:	44c7b023          	sd	a2,1088(a5) # ffffffffc02251b8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200d80:	00024797          	auipc	a5,0x24
ffffffffc0200d84:	44a7b023          	sd	a0,1088(a5) # ffffffffc02251c0 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200d88:	000807b7          	lui	a5,0x80
ffffffffc0200d8c:	002005b7          	lui	a1,0x200
ffffffffc0200d90:	02f60563          	beq	a2,a5,ffffffffc0200dba <pmm_init+0xd0>
ffffffffc0200d94:	00261593          	slli	a1,a2,0x2
ffffffffc0200d98:	00c586b3          	add	a3,a1,a2
ffffffffc0200d9c:	fec007b7          	lui	a5,0xfec00
ffffffffc0200da0:	97aa                	add	a5,a5,a0
ffffffffc0200da2:	068e                	slli	a3,a3,0x3
ffffffffc0200da4:	96be                	add	a3,a3,a5
ffffffffc0200da6:	87aa                	mv	a5,a0
        SetPageReserved(pages + i);
ffffffffc0200da8:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200daa:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9dae40>
        SetPageReserved(pages + i);
ffffffffc0200dae:	00176713          	ori	a4,a4,1
ffffffffc0200db2:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200db6:	fef699e3          	bne	a3,a5,ffffffffc0200da8 <pmm_init+0xbe>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200dba:	95b2                	add	a1,a1,a2
ffffffffc0200dbc:	fec006b7          	lui	a3,0xfec00
ffffffffc0200dc0:	96aa                	add	a3,a3,a0
ffffffffc0200dc2:	058e                	slli	a1,a1,0x3
ffffffffc0200dc4:	96ae                	add	a3,a3,a1
ffffffffc0200dc6:	c02007b7          	lui	a5,0xc0200
ffffffffc0200dca:	0af6e763          	bltu	a3,a5,ffffffffc0200e78 <pmm_init+0x18e>
ffffffffc0200dce:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0200dd0:	77fd                	lui	a5,0xfffff
ffffffffc0200dd2:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200dd6:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200dd8:	04b6ee63          	bltu	a3,a1,ffffffffc0200e34 <pmm_init+0x14a>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200ddc:	601c                	ld	a5,0(s0)
ffffffffc0200dde:	7b9c                	ld	a5,48(a5)
ffffffffc0200de0:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200de2:	00001517          	auipc	a0,0x1
ffffffffc0200de6:	b4650513          	addi	a0,a0,-1210 # ffffffffc0201928 <buddy_pmm_manager+0x120>
ffffffffc0200dea:	b62ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200dee:	00003597          	auipc	a1,0x3
ffffffffc0200df2:	21258593          	addi	a1,a1,530 # ffffffffc0204000 <boot_page_table_sv39>
ffffffffc0200df6:	00024797          	auipc	a5,0x24
ffffffffc0200dfa:	3eb7b123          	sd	a1,994(a5) # ffffffffc02251d8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200dfe:	c02007b7          	lui	a5,0xc0200
ffffffffc0200e02:	0af5e363          	bltu	a1,a5,ffffffffc0200ea8 <pmm_init+0x1be>
ffffffffc0200e06:	6090                	ld	a2,0(s1)
}
ffffffffc0200e08:	7402                	ld	s0,32(sp)
ffffffffc0200e0a:	70a2                	ld	ra,40(sp)
ffffffffc0200e0c:	64e2                	ld	s1,24(sp)
ffffffffc0200e0e:	6942                	ld	s2,16(sp)
ffffffffc0200e10:	69a2                	ld	s3,8(sp)
ffffffffc0200e12:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200e14:	40c58633          	sub	a2,a1,a2
ffffffffc0200e18:	00024797          	auipc	a5,0x24
ffffffffc0200e1c:	3ac7bc23          	sd	a2,952(a5) # ffffffffc02251d0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200e20:	00001517          	auipc	a0,0x1
ffffffffc0200e24:	b2850513          	addi	a0,a0,-1240 # ffffffffc0201948 <buddy_pmm_manager+0x140>
}
ffffffffc0200e28:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200e2a:	b22ff06f          	j	ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200e2e:	c8000637          	lui	a2,0xc8000
ffffffffc0200e32:	bf25                	j	ffffffffc0200d6a <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200e34:	6705                	lui	a4,0x1
ffffffffc0200e36:	177d                	addi	a4,a4,-1
ffffffffc0200e38:	96ba                	add	a3,a3,a4
ffffffffc0200e3a:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200e3c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200e40:	02c7f063          	bgeu	a5,a2,ffffffffc0200e60 <pmm_init+0x176>
    pmm_manager->init_memmap(base, n);
ffffffffc0200e44:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200e46:	fff80737          	lui	a4,0xfff80
ffffffffc0200e4a:	973e                	add	a4,a4,a5
ffffffffc0200e4c:	00271793          	slli	a5,a4,0x2
ffffffffc0200e50:	97ba                	add	a5,a5,a4
ffffffffc0200e52:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200e54:	8d95                	sub	a1,a1,a3
ffffffffc0200e56:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200e58:	81b1                	srli	a1,a1,0xc
ffffffffc0200e5a:	953e                	add	a0,a0,a5
ffffffffc0200e5c:	9702                	jalr	a4
}
ffffffffc0200e5e:	bfbd                	j	ffffffffc0200ddc <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0200e60:	00001617          	auipc	a2,0x1
ffffffffc0200e64:	a9860613          	addi	a2,a2,-1384 # ffffffffc02018f8 <buddy_pmm_manager+0xf0>
ffffffffc0200e68:	06a00593          	li	a1,106
ffffffffc0200e6c:	00001517          	auipc	a0,0x1
ffffffffc0200e70:	aac50513          	addi	a0,a0,-1364 # ffffffffc0201918 <buddy_pmm_manager+0x110>
ffffffffc0200e74:	b4eff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200e78:	00001617          	auipc	a2,0x1
ffffffffc0200e7c:	a5860613          	addi	a2,a2,-1448 # ffffffffc02018d0 <buddy_pmm_manager+0xc8>
ffffffffc0200e80:	06000593          	li	a1,96
ffffffffc0200e84:	00001517          	auipc	a0,0x1
ffffffffc0200e88:	9f450513          	addi	a0,a0,-1548 # ffffffffc0201878 <buddy_pmm_manager+0x70>
ffffffffc0200e8c:	b36ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("DTB memory info not available");
ffffffffc0200e90:	00001617          	auipc	a2,0x1
ffffffffc0200e94:	9c860613          	addi	a2,a2,-1592 # ffffffffc0201858 <buddy_pmm_manager+0x50>
ffffffffc0200e98:	04800593          	li	a1,72
ffffffffc0200e9c:	00001517          	auipc	a0,0x1
ffffffffc0200ea0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0201878 <buddy_pmm_manager+0x70>
ffffffffc0200ea4:	b1eff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200ea8:	86ae                	mv	a3,a1
ffffffffc0200eaa:	00001617          	auipc	a2,0x1
ffffffffc0200eae:	a2660613          	addi	a2,a2,-1498 # ffffffffc02018d0 <buddy_pmm_manager+0xc8>
ffffffffc0200eb2:	07b00593          	li	a1,123
ffffffffc0200eb6:	00001517          	auipc	a0,0x1
ffffffffc0200eba:	9c250513          	addi	a0,a0,-1598 # ffffffffc0201878 <buddy_pmm_manager+0x70>
ffffffffc0200ebe:	b04ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200ec2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0200ec2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200ec6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0200ec8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200ecc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0200ece:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200ed2:	f022                	sd	s0,32(sp)
ffffffffc0200ed4:	ec26                	sd	s1,24(sp)
ffffffffc0200ed6:	e84a                	sd	s2,16(sp)
ffffffffc0200ed8:	f406                	sd	ra,40(sp)
ffffffffc0200eda:	e44e                	sd	s3,8(sp)
ffffffffc0200edc:	84aa                	mv	s1,a0
ffffffffc0200ede:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0200ee0:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0200ee4:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0200ee6:	03067e63          	bgeu	a2,a6,ffffffffc0200f22 <printnum+0x60>
ffffffffc0200eea:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0200eec:	00805763          	blez	s0,ffffffffc0200efa <printnum+0x38>
ffffffffc0200ef0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0200ef2:	85ca                	mv	a1,s2
ffffffffc0200ef4:	854e                	mv	a0,s3
ffffffffc0200ef6:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0200ef8:	fc65                	bnez	s0,ffffffffc0200ef0 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200efa:	1a02                	slli	s4,s4,0x20
ffffffffc0200efc:	00001797          	auipc	a5,0x1
ffffffffc0200f00:	a8c78793          	addi	a5,a5,-1396 # ffffffffc0201988 <buddy_pmm_manager+0x180>
ffffffffc0200f04:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200f08:	9a3e                	add	s4,s4,a5
}
ffffffffc0200f0a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200f0c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0200f10:	70a2                	ld	ra,40(sp)
ffffffffc0200f12:	69a2                	ld	s3,8(sp)
ffffffffc0200f14:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200f16:	85ca                	mv	a1,s2
ffffffffc0200f18:	87a6                	mv	a5,s1
}
ffffffffc0200f1a:	6942                	ld	s2,16(sp)
ffffffffc0200f1c:	64e2                	ld	s1,24(sp)
ffffffffc0200f1e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200f20:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0200f22:	03065633          	divu	a2,a2,a6
ffffffffc0200f26:	8722                	mv	a4,s0
ffffffffc0200f28:	f9bff0ef          	jal	ra,ffffffffc0200ec2 <printnum>
ffffffffc0200f2c:	b7f9                	j	ffffffffc0200efa <printnum+0x38>

ffffffffc0200f2e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0200f2e:	7119                	addi	sp,sp,-128
ffffffffc0200f30:	f4a6                	sd	s1,104(sp)
ffffffffc0200f32:	f0ca                	sd	s2,96(sp)
ffffffffc0200f34:	ecce                	sd	s3,88(sp)
ffffffffc0200f36:	e8d2                	sd	s4,80(sp)
ffffffffc0200f38:	e4d6                	sd	s5,72(sp)
ffffffffc0200f3a:	e0da                	sd	s6,64(sp)
ffffffffc0200f3c:	fc5e                	sd	s7,56(sp)
ffffffffc0200f3e:	f06a                	sd	s10,32(sp)
ffffffffc0200f40:	fc86                	sd	ra,120(sp)
ffffffffc0200f42:	f8a2                	sd	s0,112(sp)
ffffffffc0200f44:	f862                	sd	s8,48(sp)
ffffffffc0200f46:	f466                	sd	s9,40(sp)
ffffffffc0200f48:	ec6e                	sd	s11,24(sp)
ffffffffc0200f4a:	892a                	mv	s2,a0
ffffffffc0200f4c:	84ae                	mv	s1,a1
ffffffffc0200f4e:	8d32                	mv	s10,a2
ffffffffc0200f50:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f52:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0200f56:	5b7d                	li	s6,-1
ffffffffc0200f58:	00001a97          	auipc	s5,0x1
ffffffffc0200f5c:	a64a8a93          	addi	s5,s5,-1436 # ffffffffc02019bc <buddy_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0200f60:	00001b97          	auipc	s7,0x1
ffffffffc0200f64:	c38b8b93          	addi	s7,s7,-968 # ffffffffc0201b98 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f68:	000d4503          	lbu	a0,0(s10)
ffffffffc0200f6c:	001d0413          	addi	s0,s10,1
ffffffffc0200f70:	01350a63          	beq	a0,s3,ffffffffc0200f84 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0200f74:	c121                	beqz	a0,ffffffffc0200fb4 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0200f76:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f78:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0200f7a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f7c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0200f80:	ff351ae3          	bne	a0,s3,ffffffffc0200f74 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f84:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0200f88:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0200f8c:	4c81                	li	s9,0
ffffffffc0200f8e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0200f90:	5c7d                	li	s8,-1
ffffffffc0200f92:	5dfd                	li	s11,-1
ffffffffc0200f94:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0200f98:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f9a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0200f9e:	0ff5f593          	zext.b	a1,a1
ffffffffc0200fa2:	00140d13          	addi	s10,s0,1
ffffffffc0200fa6:	04b56263          	bltu	a0,a1,ffffffffc0200fea <vprintfmt+0xbc>
ffffffffc0200faa:	058a                	slli	a1,a1,0x2
ffffffffc0200fac:	95d6                	add	a1,a1,s5
ffffffffc0200fae:	4194                	lw	a3,0(a1)
ffffffffc0200fb0:	96d6                	add	a3,a3,s5
ffffffffc0200fb2:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0200fb4:	70e6                	ld	ra,120(sp)
ffffffffc0200fb6:	7446                	ld	s0,112(sp)
ffffffffc0200fb8:	74a6                	ld	s1,104(sp)
ffffffffc0200fba:	7906                	ld	s2,96(sp)
ffffffffc0200fbc:	69e6                	ld	s3,88(sp)
ffffffffc0200fbe:	6a46                	ld	s4,80(sp)
ffffffffc0200fc0:	6aa6                	ld	s5,72(sp)
ffffffffc0200fc2:	6b06                	ld	s6,64(sp)
ffffffffc0200fc4:	7be2                	ld	s7,56(sp)
ffffffffc0200fc6:	7c42                	ld	s8,48(sp)
ffffffffc0200fc8:	7ca2                	ld	s9,40(sp)
ffffffffc0200fca:	7d02                	ld	s10,32(sp)
ffffffffc0200fcc:	6de2                	ld	s11,24(sp)
ffffffffc0200fce:	6109                	addi	sp,sp,128
ffffffffc0200fd0:	8082                	ret
            padc = '0';
ffffffffc0200fd2:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0200fd4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200fd8:	846a                	mv	s0,s10
ffffffffc0200fda:	00140d13          	addi	s10,s0,1
ffffffffc0200fde:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0200fe2:	0ff5f593          	zext.b	a1,a1
ffffffffc0200fe6:	fcb572e3          	bgeu	a0,a1,ffffffffc0200faa <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0200fea:	85a6                	mv	a1,s1
ffffffffc0200fec:	02500513          	li	a0,37
ffffffffc0200ff0:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0200ff2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0200ff6:	8d22                	mv	s10,s0
ffffffffc0200ff8:	f73788e3          	beq	a5,s3,ffffffffc0200f68 <vprintfmt+0x3a>
ffffffffc0200ffc:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201000:	1d7d                	addi	s10,s10,-1
ffffffffc0201002:	ff379de3          	bne	a5,s3,ffffffffc0200ffc <vprintfmt+0xce>
ffffffffc0201006:	b78d                	j	ffffffffc0200f68 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201008:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020100c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201010:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201012:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201016:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020101a:	02d86463          	bltu	a6,a3,ffffffffc0201042 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020101e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201022:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201026:	0186873b          	addw	a4,a3,s8
ffffffffc020102a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020102e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201030:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201034:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201036:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020103a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020103e:	fed870e3          	bgeu	a6,a3,ffffffffc020101e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201042:	f40ddce3          	bgez	s11,ffffffffc0200f9a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201046:	8de2                	mv	s11,s8
ffffffffc0201048:	5c7d                	li	s8,-1
ffffffffc020104a:	bf81                	j	ffffffffc0200f9a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020104c:	fffdc693          	not	a3,s11
ffffffffc0201050:	96fd                	srai	a3,a3,0x3f
ffffffffc0201052:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201056:	00144603          	lbu	a2,1(s0)
ffffffffc020105a:	2d81                	sext.w	s11,s11
ffffffffc020105c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020105e:	bf35                	j	ffffffffc0200f9a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201060:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201064:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201068:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020106a:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020106c:	bfd9                	j	ffffffffc0201042 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020106e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201070:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201074:	01174463          	blt	a4,a7,ffffffffc020107c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201078:	1a088e63          	beqz	a7,ffffffffc0201234 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020107c:	000a3603          	ld	a2,0(s4)
ffffffffc0201080:	46c1                	li	a3,16
ffffffffc0201082:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201084:	2781                	sext.w	a5,a5
ffffffffc0201086:	876e                	mv	a4,s11
ffffffffc0201088:	85a6                	mv	a1,s1
ffffffffc020108a:	854a                	mv	a0,s2
ffffffffc020108c:	e37ff0ef          	jal	ra,ffffffffc0200ec2 <printnum>
            break;
ffffffffc0201090:	bde1                	j	ffffffffc0200f68 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201092:	000a2503          	lw	a0,0(s4)
ffffffffc0201096:	85a6                	mv	a1,s1
ffffffffc0201098:	0a21                	addi	s4,s4,8
ffffffffc020109a:	9902                	jalr	s2
            break;
ffffffffc020109c:	b5f1                	j	ffffffffc0200f68 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020109e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02010a0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02010a4:	01174463          	blt	a4,a7,ffffffffc02010ac <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02010a8:	18088163          	beqz	a7,ffffffffc020122a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02010ac:	000a3603          	ld	a2,0(s4)
ffffffffc02010b0:	46a9                	li	a3,10
ffffffffc02010b2:	8a2e                	mv	s4,a1
ffffffffc02010b4:	bfc1                	j	ffffffffc0201084 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02010b6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02010ba:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02010bc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02010be:	bdf1                	j	ffffffffc0200f9a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02010c0:	85a6                	mv	a1,s1
ffffffffc02010c2:	02500513          	li	a0,37
ffffffffc02010c6:	9902                	jalr	s2
            break;
ffffffffc02010c8:	b545                	j	ffffffffc0200f68 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02010ca:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02010ce:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02010d0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02010d2:	b5e1                	j	ffffffffc0200f9a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02010d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02010d6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02010da:	01174463          	blt	a4,a7,ffffffffc02010e2 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02010de:	14088163          	beqz	a7,ffffffffc0201220 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02010e2:	000a3603          	ld	a2,0(s4)
ffffffffc02010e6:	46a1                	li	a3,8
ffffffffc02010e8:	8a2e                	mv	s4,a1
ffffffffc02010ea:	bf69                	j	ffffffffc0201084 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02010ec:	03000513          	li	a0,48
ffffffffc02010f0:	85a6                	mv	a1,s1
ffffffffc02010f2:	e03e                	sd	a5,0(sp)
ffffffffc02010f4:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02010f6:	85a6                	mv	a1,s1
ffffffffc02010f8:	07800513          	li	a0,120
ffffffffc02010fc:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02010fe:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201100:	6782                	ld	a5,0(sp)
ffffffffc0201102:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201104:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201108:	bfb5                	j	ffffffffc0201084 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020110a:	000a3403          	ld	s0,0(s4)
ffffffffc020110e:	008a0713          	addi	a4,s4,8
ffffffffc0201112:	e03a                	sd	a4,0(sp)
ffffffffc0201114:	14040263          	beqz	s0,ffffffffc0201258 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201118:	0fb05763          	blez	s11,ffffffffc0201206 <vprintfmt+0x2d8>
ffffffffc020111c:	02d00693          	li	a3,45
ffffffffc0201120:	0cd79163          	bne	a5,a3,ffffffffc02011e2 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201124:	00044783          	lbu	a5,0(s0)
ffffffffc0201128:	0007851b          	sext.w	a0,a5
ffffffffc020112c:	cf85                	beqz	a5,ffffffffc0201164 <vprintfmt+0x236>
ffffffffc020112e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201132:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201136:	000c4563          	bltz	s8,ffffffffc0201140 <vprintfmt+0x212>
ffffffffc020113a:	3c7d                	addiw	s8,s8,-1
ffffffffc020113c:	036c0263          	beq	s8,s6,ffffffffc0201160 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201140:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201142:	0e0c8e63          	beqz	s9,ffffffffc020123e <vprintfmt+0x310>
ffffffffc0201146:	3781                	addiw	a5,a5,-32
ffffffffc0201148:	0ef47b63          	bgeu	s0,a5,ffffffffc020123e <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020114c:	03f00513          	li	a0,63
ffffffffc0201150:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201152:	000a4783          	lbu	a5,0(s4)
ffffffffc0201156:	3dfd                	addiw	s11,s11,-1
ffffffffc0201158:	0a05                	addi	s4,s4,1
ffffffffc020115a:	0007851b          	sext.w	a0,a5
ffffffffc020115e:	ffe1                	bnez	a5,ffffffffc0201136 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201160:	01b05963          	blez	s11,ffffffffc0201172 <vprintfmt+0x244>
ffffffffc0201164:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201166:	85a6                	mv	a1,s1
ffffffffc0201168:	02000513          	li	a0,32
ffffffffc020116c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020116e:	fe0d9be3          	bnez	s11,ffffffffc0201164 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201172:	6a02                	ld	s4,0(sp)
ffffffffc0201174:	bbd5                	j	ffffffffc0200f68 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201176:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201178:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020117c:	01174463          	blt	a4,a7,ffffffffc0201184 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201180:	08088d63          	beqz	a7,ffffffffc020121a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201184:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201188:	0a044d63          	bltz	s0,ffffffffc0201242 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020118c:	8622                	mv	a2,s0
ffffffffc020118e:	8a66                	mv	s4,s9
ffffffffc0201190:	46a9                	li	a3,10
ffffffffc0201192:	bdcd                	j	ffffffffc0201084 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201194:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201198:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc020119a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020119c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02011a0:	8fb5                	xor	a5,a5,a3
ffffffffc02011a2:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02011a6:	02d74163          	blt	a4,a3,ffffffffc02011c8 <vprintfmt+0x29a>
ffffffffc02011aa:	00369793          	slli	a5,a3,0x3
ffffffffc02011ae:	97de                	add	a5,a5,s7
ffffffffc02011b0:	639c                	ld	a5,0(a5)
ffffffffc02011b2:	cb99                	beqz	a5,ffffffffc02011c8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02011b4:	86be                	mv	a3,a5
ffffffffc02011b6:	00001617          	auipc	a2,0x1
ffffffffc02011ba:	80260613          	addi	a2,a2,-2046 # ffffffffc02019b8 <buddy_pmm_manager+0x1b0>
ffffffffc02011be:	85a6                	mv	a1,s1
ffffffffc02011c0:	854a                	mv	a0,s2
ffffffffc02011c2:	0ce000ef          	jal	ra,ffffffffc0201290 <printfmt>
ffffffffc02011c6:	b34d                	j	ffffffffc0200f68 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02011c8:	00000617          	auipc	a2,0x0
ffffffffc02011cc:	7e060613          	addi	a2,a2,2016 # ffffffffc02019a8 <buddy_pmm_manager+0x1a0>
ffffffffc02011d0:	85a6                	mv	a1,s1
ffffffffc02011d2:	854a                	mv	a0,s2
ffffffffc02011d4:	0bc000ef          	jal	ra,ffffffffc0201290 <printfmt>
ffffffffc02011d8:	bb41                	j	ffffffffc0200f68 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02011da:	00000417          	auipc	s0,0x0
ffffffffc02011de:	7c640413          	addi	s0,s0,1990 # ffffffffc02019a0 <buddy_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02011e2:	85e2                	mv	a1,s8
ffffffffc02011e4:	8522                	mv	a0,s0
ffffffffc02011e6:	e43e                	sd	a5,8(sp)
ffffffffc02011e8:	0fc000ef          	jal	ra,ffffffffc02012e4 <strnlen>
ffffffffc02011ec:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02011f0:	01b05b63          	blez	s11,ffffffffc0201206 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02011f4:	67a2                	ld	a5,8(sp)
ffffffffc02011f6:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02011fa:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02011fc:	85a6                	mv	a1,s1
ffffffffc02011fe:	8552                	mv	a0,s4
ffffffffc0201200:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201202:	fe0d9ce3          	bnez	s11,ffffffffc02011fa <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201206:	00044783          	lbu	a5,0(s0)
ffffffffc020120a:	00140a13          	addi	s4,s0,1
ffffffffc020120e:	0007851b          	sext.w	a0,a5
ffffffffc0201212:	d3a5                	beqz	a5,ffffffffc0201172 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201214:	05e00413          	li	s0,94
ffffffffc0201218:	bf39                	j	ffffffffc0201136 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020121a:	000a2403          	lw	s0,0(s4)
ffffffffc020121e:	b7ad                	j	ffffffffc0201188 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201220:	000a6603          	lwu	a2,0(s4)
ffffffffc0201224:	46a1                	li	a3,8
ffffffffc0201226:	8a2e                	mv	s4,a1
ffffffffc0201228:	bdb1                	j	ffffffffc0201084 <vprintfmt+0x156>
ffffffffc020122a:	000a6603          	lwu	a2,0(s4)
ffffffffc020122e:	46a9                	li	a3,10
ffffffffc0201230:	8a2e                	mv	s4,a1
ffffffffc0201232:	bd89                	j	ffffffffc0201084 <vprintfmt+0x156>
ffffffffc0201234:	000a6603          	lwu	a2,0(s4)
ffffffffc0201238:	46c1                	li	a3,16
ffffffffc020123a:	8a2e                	mv	s4,a1
ffffffffc020123c:	b5a1                	j	ffffffffc0201084 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020123e:	9902                	jalr	s2
ffffffffc0201240:	bf09                	j	ffffffffc0201152 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201242:	85a6                	mv	a1,s1
ffffffffc0201244:	02d00513          	li	a0,45
ffffffffc0201248:	e03e                	sd	a5,0(sp)
ffffffffc020124a:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020124c:	6782                	ld	a5,0(sp)
ffffffffc020124e:	8a66                	mv	s4,s9
ffffffffc0201250:	40800633          	neg	a2,s0
ffffffffc0201254:	46a9                	li	a3,10
ffffffffc0201256:	b53d                	j	ffffffffc0201084 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201258:	03b05163          	blez	s11,ffffffffc020127a <vprintfmt+0x34c>
ffffffffc020125c:	02d00693          	li	a3,45
ffffffffc0201260:	f6d79de3          	bne	a5,a3,ffffffffc02011da <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201264:	00000417          	auipc	s0,0x0
ffffffffc0201268:	73c40413          	addi	s0,s0,1852 # ffffffffc02019a0 <buddy_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020126c:	02800793          	li	a5,40
ffffffffc0201270:	02800513          	li	a0,40
ffffffffc0201274:	00140a13          	addi	s4,s0,1
ffffffffc0201278:	bd6d                	j	ffffffffc0201132 <vprintfmt+0x204>
ffffffffc020127a:	00000a17          	auipc	s4,0x0
ffffffffc020127e:	727a0a13          	addi	s4,s4,1831 # ffffffffc02019a1 <buddy_pmm_manager+0x199>
ffffffffc0201282:	02800513          	li	a0,40
ffffffffc0201286:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020128a:	05e00413          	li	s0,94
ffffffffc020128e:	b565                	j	ffffffffc0201136 <vprintfmt+0x208>

ffffffffc0201290 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201290:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201292:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201296:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201298:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020129a:	ec06                	sd	ra,24(sp)
ffffffffc020129c:	f83a                	sd	a4,48(sp)
ffffffffc020129e:	fc3e                	sd	a5,56(sp)
ffffffffc02012a0:	e0c2                	sd	a6,64(sp)
ffffffffc02012a2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02012a4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02012a6:	c89ff0ef          	jal	ra,ffffffffc0200f2e <vprintfmt>
}
ffffffffc02012aa:	60e2                	ld	ra,24(sp)
ffffffffc02012ac:	6161                	addi	sp,sp,80
ffffffffc02012ae:	8082                	ret

ffffffffc02012b0 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02012b0:	4781                	li	a5,0
ffffffffc02012b2:	00004717          	auipc	a4,0x4
ffffffffc02012b6:	d5e73703          	ld	a4,-674(a4) # ffffffffc0205010 <SBI_CONSOLE_PUTCHAR>
ffffffffc02012ba:	88ba                	mv	a7,a4
ffffffffc02012bc:	852a                	mv	a0,a0
ffffffffc02012be:	85be                	mv	a1,a5
ffffffffc02012c0:	863e                	mv	a2,a5
ffffffffc02012c2:	00000073          	ecall
ffffffffc02012c6:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02012c8:	8082                	ret

ffffffffc02012ca <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02012ca:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02012ce:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02012d0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02012d2:	cb81                	beqz	a5,ffffffffc02012e2 <strlen+0x18>
        cnt ++;
ffffffffc02012d4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02012d6:	00a707b3          	add	a5,a4,a0
ffffffffc02012da:	0007c783          	lbu	a5,0(a5)
ffffffffc02012de:	fbfd                	bnez	a5,ffffffffc02012d4 <strlen+0xa>
ffffffffc02012e0:	8082                	ret
    }
    return cnt;
}
ffffffffc02012e2:	8082                	ret

ffffffffc02012e4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02012e4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02012e6:	e589                	bnez	a1,ffffffffc02012f0 <strnlen+0xc>
ffffffffc02012e8:	a811                	j	ffffffffc02012fc <strnlen+0x18>
        cnt ++;
ffffffffc02012ea:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02012ec:	00f58863          	beq	a1,a5,ffffffffc02012fc <strnlen+0x18>
ffffffffc02012f0:	00f50733          	add	a4,a0,a5
ffffffffc02012f4:	00074703          	lbu	a4,0(a4)
ffffffffc02012f8:	fb6d                	bnez	a4,ffffffffc02012ea <strnlen+0x6>
ffffffffc02012fa:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02012fc:	852e                	mv	a0,a1
ffffffffc02012fe:	8082                	ret

ffffffffc0201300 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201300:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201304:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201308:	cb89                	beqz	a5,ffffffffc020131a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020130a:	0505                	addi	a0,a0,1
ffffffffc020130c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020130e:	fee789e3          	beq	a5,a4,ffffffffc0201300 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201312:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201316:	9d19                	subw	a0,a0,a4
ffffffffc0201318:	8082                	ret
ffffffffc020131a:	4501                	li	a0,0
ffffffffc020131c:	bfed                	j	ffffffffc0201316 <strcmp+0x16>

ffffffffc020131e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020131e:	c20d                	beqz	a2,ffffffffc0201340 <strncmp+0x22>
ffffffffc0201320:	962e                	add	a2,a2,a1
ffffffffc0201322:	a031                	j	ffffffffc020132e <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201324:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201326:	00e79a63          	bne	a5,a4,ffffffffc020133a <strncmp+0x1c>
ffffffffc020132a:	00b60b63          	beq	a2,a1,ffffffffc0201340 <strncmp+0x22>
ffffffffc020132e:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201332:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201334:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201338:	f7f5                	bnez	a5,ffffffffc0201324 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020133a:	40e7853b          	subw	a0,a5,a4
}
ffffffffc020133e:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201340:	4501                	li	a0,0
ffffffffc0201342:	8082                	ret

ffffffffc0201344 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201344:	ca01                	beqz	a2,ffffffffc0201354 <memset+0x10>
ffffffffc0201346:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201348:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020134a:	0785                	addi	a5,a5,1
ffffffffc020134c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201350:	fec79de3          	bne	a5,a2,ffffffffc020134a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201354:	8082                	ret
