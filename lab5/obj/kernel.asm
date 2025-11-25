
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000cf517          	auipc	a0,0xcf
ffffffffc020004e:	e2650513          	addi	a0,a0,-474 # ffffffffc02cee70 <buf>
ffffffffc0200052:	000d3617          	auipc	a2,0xd3
ffffffffc0200056:	2ca60613          	addi	a2,a2,714 # ffffffffc02d331c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	09d050ef          	jal	ra,ffffffffc02058fe <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	8ba58593          	addi	a1,a1,-1862 # ffffffffc0205928 <etext>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	8d250513          	addi	a0,a0,-1838 # ffffffffc0205948 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	091020ef          	jal	ra,ffffffffc0202916 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	3a7030ef          	jal	ra,ffffffffc0203c38 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	7bb040ef          	jal	ra,ffffffffc0205050 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	146050ef          	jal	ra,ffffffffc02051e8 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	89450513          	addi	a0,a0,-1900 # ffffffffc0205950 <etext+0x28>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000cfb97          	auipc	s7,0xcf
ffffffffc02000d6:	d9eb8b93          	addi	s7,s7,-610 # ffffffffc02cee70 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000cf517          	auipc	a0,0xcf
ffffffffc0200132:	d4250513          	addi	a0,a0,-702 # ffffffffc02cee70 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	352050ef          	jal	ra,ffffffffc02054da <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	31c050ef          	jal	ra,ffffffffc02054da <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	73a50513          	addi	a0,a0,1850 # ffffffffc0205958 <etext+0x30>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	74450513          	addi	a0,a0,1860 # ffffffffc0205978 <etext+0x50>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	6e858593          	addi	a1,a1,1768 # ffffffffc0205928 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	75050513          	addi	a0,a0,1872 # ffffffffc0205998 <etext+0x70>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000cf597          	auipc	a1,0xcf
ffffffffc0200258:	c1c58593          	addi	a1,a1,-996 # ffffffffc02cee70 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	75c50513          	addi	a0,a0,1884 # ffffffffc02059b8 <etext+0x90>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000d3597          	auipc	a1,0xd3
ffffffffc020026c:	0b458593          	addi	a1,a1,180 # ffffffffc02d331c <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	76850513          	addi	a0,a0,1896 # ffffffffc02059d8 <etext+0xb0>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000d3597          	auipc	a1,0xd3
ffffffffc0200280:	49f58593          	addi	a1,a1,1183 # ffffffffc02d371b <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	75a50513          	addi	a0,a0,1882 # ffffffffc02059f8 <etext+0xd0>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	77c60613          	addi	a2,a2,1916 # ffffffffc0205a28 <etext+0x100>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	78850513          	addi	a0,a0,1928 # ffffffffc0205a40 <etext+0x118>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	79060613          	addi	a2,a2,1936 # ffffffffc0205a58 <etext+0x130>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	7a858593          	addi	a1,a1,1960 # ffffffffc0205a78 <etext+0x150>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	7a850513          	addi	a0,a0,1960 # ffffffffc0205a80 <etext+0x158>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	7aa60613          	addi	a2,a2,1962 # ffffffffc0205a90 <etext+0x168>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	7ca58593          	addi	a1,a1,1994 # ffffffffc0205ab8 <etext+0x190>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	78a50513          	addi	a0,a0,1930 # ffffffffc0205a80 <etext+0x158>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	7c660613          	addi	a2,a2,1990 # ffffffffc0205ac8 <etext+0x1a0>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	7de58593          	addi	a1,a1,2014 # ffffffffc0205ae8 <etext+0x1c0>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	76e50513          	addi	a0,a0,1902 # ffffffffc0205a80 <etext+0x158>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	7ac50513          	addi	a0,a0,1964 # ffffffffc0205af8 <etext+0x1d0>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	7b250513          	addi	a0,a0,1970 # ffffffffc0205b20 <etext+0x1f8>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00006c17          	auipc	s8,0x6
ffffffffc0200388:	80cc0c13          	addi	s8,s8,-2036 # ffffffffc0205b90 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	7bc90913          	addi	s2,s2,1980 # ffffffffc0205b48 <etext+0x220>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	7bc48493          	addi	s1,s1,1980 # ffffffffc0205b50 <etext+0x228>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	7bab0b13          	addi	s6,s6,1978 # ffffffffc0205b58 <etext+0x230>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	6d2a0a13          	addi	s4,s4,1746 # ffffffffc0205a78 <etext+0x150>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	7c8d0d13          	addi	s10,s10,1992 # ffffffffc0205b90 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	4ce050ef          	jal	ra,ffffffffc02058a4 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	4ba050ef          	jal	ra,ffffffffc02058a4 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	4c0050ef          	jal	ra,ffffffffc02058e8 <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	482050ef          	jal	ra,ffffffffc02058e8 <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	6f850513          	addi	a0,a0,1784 # ffffffffc0205b78 <etext+0x250>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000d3317          	auipc	t1,0xd3
ffffffffc0200492:	e0a30313          	addi	t1,t1,-502 # ffffffffc02d3298 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	71c50513          	addi	a0,a0,1820 # ffffffffc0205bd8 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00007517          	auipc	a0,0x7
ffffffffc02004d6:	82650513          	addi	a0,a0,-2010 # ffffffffc0206cf8 <default_pmm_manager+0x4f8>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	6f250513          	addi	a0,a0,1778 # ffffffffc0205bf8 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	7d250513          	addi	a0,a0,2002 # ffffffffc0206cf8 <default_pmm_manager+0x4f8>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd570>
ffffffffc0200540:	000d3717          	auipc	a4,0xd3
ffffffffc0200544:	d6f73423          	sd	a5,-664(a4) # ffffffffc02d32a8 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	6b850513          	addi	a0,a0,1720 # ffffffffc0205c18 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000d3797          	auipc	a5,0xd3
ffffffffc020056c:	d207bc23          	sd	zero,-712(a5) # ffffffffc02d32a0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000d3797          	auipc	a5,0xd3
ffffffffc020057a:	d327b783          	ld	a5,-718(a5) # ffffffffc02d32a8 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	63850513          	addi	a0,a0,1592 # ffffffffc0205c38 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	61a50513          	addi	a0,a0,1562 # ffffffffc0205c48 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	61450513          	addi	a0,a0,1556 # ffffffffc0205c58 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	61c50513          	addi	a0,a0,1564 # ffffffffc0205c70 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe0cbd1>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	5b290913          	addi	s2,s2,1458 # ffffffffc0205cc0 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	59c48493          	addi	s1,s1,1436 # ffffffffc0205cb8 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	5c850513          	addi	a0,a0,1480 # ffffffffc0205d38 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	5f450513          	addi	a0,a0,1524 # ffffffffc0205d70 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	4d450513          	addi	a0,a0,1236 # ffffffffc0205c90 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	092050ef          	jal	ra,ffffffffc020585c <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	0ea050ef          	jal	ra,ffffffffc02058c2 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	036050ef          	jal	ra,ffffffffc02058a4 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	44650513          	addi	a0,a0,1094 # ffffffffc0205cc8 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	39850513          	addi	a0,a0,920 # ffffffffc0205ce8 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	39e50513          	addi	a0,a0,926 # ffffffffc0205d00 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	3ac50513          	addi	a0,a0,940 # ffffffffc0205d20 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	3f050513          	addi	a0,a0,1008 # ffffffffc0205d70 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000d3797          	auipc	a5,0xd3
ffffffffc020098c:	9287b423          	sd	s0,-1752(a5) # ffffffffc02d32b0 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000d3797          	auipc	a5,0xd3
ffffffffc0200994:	9367b423          	sd	s6,-1752(a5) # ffffffffc02d32b8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000d3517          	auipc	a0,0xd3
ffffffffc020099e:	91653503          	ld	a0,-1770(a0) # ffffffffc02d32b0 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000d3517          	auipc	a0,0xd3
ffffffffc02009a8:	91453503          	ld	a0,-1772(a0) # ffffffffc02d32b8 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	68478793          	addi	a5,a5,1668 # ffffffffc0201044 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	3aa50513          	addi	a0,a0,938 # ffffffffc0205d88 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	3b250513          	addi	a0,a0,946 # ffffffffc0205da0 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	3bc50513          	addi	a0,a0,956 # ffffffffc0205db8 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	3c650513          	addi	a0,a0,966 # ffffffffc0205dd0 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	3d050513          	addi	a0,a0,976 # ffffffffc0205de8 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	3da50513          	addi	a0,a0,986 # ffffffffc0205e00 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	3e450513          	addi	a0,a0,996 # ffffffffc0205e18 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205e30 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	3f850513          	addi	a0,a0,1016 # ffffffffc0205e48 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	40250513          	addi	a0,a0,1026 # ffffffffc0205e60 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	40c50513          	addi	a0,a0,1036 # ffffffffc0205e78 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	41650513          	addi	a0,a0,1046 # ffffffffc0205e90 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	42050513          	addi	a0,a0,1056 # ffffffffc0205ea8 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	42a50513          	addi	a0,a0,1066 # ffffffffc0205ec0 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	43450513          	addi	a0,a0,1076 # ffffffffc0205ed8 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	43e50513          	addi	a0,a0,1086 # ffffffffc0205ef0 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	44850513          	addi	a0,a0,1096 # ffffffffc0205f08 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	45250513          	addi	a0,a0,1106 # ffffffffc0205f20 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	45c50513          	addi	a0,a0,1116 # ffffffffc0205f38 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	46650513          	addi	a0,a0,1126 # ffffffffc0205f50 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	47050513          	addi	a0,a0,1136 # ffffffffc0205f68 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	47a50513          	addi	a0,a0,1146 # ffffffffc0205f80 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	48450513          	addi	a0,a0,1156 # ffffffffc0205f98 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	48e50513          	addi	a0,a0,1166 # ffffffffc0205fb0 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	49850513          	addi	a0,a0,1176 # ffffffffc0205fc8 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	4a250513          	addi	a0,a0,1186 # ffffffffc0205fe0 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205ff8 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	4b650513          	addi	a0,a0,1206 # ffffffffc0206010 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	4c050513          	addi	a0,a0,1216 # ffffffffc0206028 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	4ca50513          	addi	a0,a0,1226 # ffffffffc0206040 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	4d450513          	addi	a0,a0,1236 # ffffffffc0206058 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	4da50513          	addi	a0,a0,1242 # ffffffffc0206070 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206088 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	4dc50513          	addi	a0,a0,1244 # ffffffffc02060a0 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	4e450513          	addi	a0,a0,1252 # ffffffffc02060b8 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	4ec50513          	addi	a0,a0,1260 # ffffffffc02060d0 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	4e850513          	addi	a0,a0,1256 # ffffffffc02060e0 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	06f76d63          	bltu	a4,a5,ffffffffc0200c8a <interrupt_handler+0x84>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	59470713          	addi	a4,a4,1428 # ffffffffc02061a8 <commands+0x618>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	53250513          	addi	a0,a0,1330 # ffffffffc0206158 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	50650513          	addi	a0,a0,1286 # ffffffffc0206138 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	4ba50513          	addi	a0,a0,1210 # ffffffffc02060f8 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	4ce50513          	addi	a0,a0,1230 # ffffffffc0206118 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        ticks++;
ffffffffc0200c5e:	000d2797          	auipc	a5,0xd2
ffffffffc0200c62:	64278793          	addi	a5,a5,1602 # ffffffffc02d32a0 <ticks>
ffffffffc0200c66:	6398                	ld	a4,0(a5)
ffffffffc0200c68:	0705                	addi	a4,a4,1
ffffffffc0200c6a:	e398                	sd	a4,0(a5)
        if(ticks%TICK_NUM==0){
ffffffffc0200c6c:	639c                	ld	a5,0(a5)
ffffffffc0200c6e:	06400713          	li	a4,100
ffffffffc0200c72:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c76:	cb99                	beqz	a5,ffffffffc0200c8c <interrupt_handler+0x86>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c78:	60a2                	ld	ra,8(sp)
ffffffffc0200c7a:	0141                	addi	sp,sp,16
ffffffffc0200c7c:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c7e:	00005517          	auipc	a0,0x5
ffffffffc0200c82:	50a50513          	addi	a0,a0,1290 # ffffffffc0206188 <commands+0x5f8>
ffffffffc0200c86:	d0eff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c8a:	bf29                	j	ffffffffc0200ba4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c8c:	06400593          	li	a1,100
ffffffffc0200c90:	00005517          	auipc	a0,0x5
ffffffffc0200c94:	4e850513          	addi	a0,a0,1256 # ffffffffc0206178 <commands+0x5e8>
ffffffffc0200c98:	cfcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            num++;
ffffffffc0200c9c:	000d2717          	auipc	a4,0xd2
ffffffffc0200ca0:	62470713          	addi	a4,a4,1572 # ffffffffc02d32c0 <num>
ffffffffc0200ca4:	631c                	ld	a5,0(a4)
            if(num>=10){
ffffffffc0200ca6:	46a5                	li	a3,9
            num++;
ffffffffc0200ca8:	0785                	addi	a5,a5,1
ffffffffc0200caa:	e31c                	sd	a5,0(a4)
            if(num>=10){
ffffffffc0200cac:	fcf6f6e3          	bgeu	a3,a5,ffffffffc0200c78 <interrupt_handler+0x72>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200cb0:	4501                	li	a0,0
ffffffffc0200cb2:	4581                	li	a1,0
ffffffffc0200cb4:	4601                	li	a2,0
ffffffffc0200cb6:	48a1                	li	a7,8
ffffffffc0200cb8:	00000073          	ecall
}
ffffffffc0200cbc:	bf75                	j	ffffffffc0200c78 <interrupt_handler+0x72>

ffffffffc0200cbe <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cbe:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cc2:	715d                	addi	sp,sp,-80
ffffffffc0200cc4:	e0a2                	sd	s0,64(sp)
ffffffffc0200cc6:	e486                	sd	ra,72(sp)
ffffffffc0200cc8:	fc26                	sd	s1,56(sp)
ffffffffc0200cca:	f84a                	sd	s2,48(sp)
ffffffffc0200ccc:	f44e                	sd	s3,40(sp)
ffffffffc0200cce:	f052                	sd	s4,32(sp)
ffffffffc0200cd0:	ec56                	sd	s5,24(sp)
ffffffffc0200cd2:	e85a                	sd	s6,16(sp)
ffffffffc0200cd4:	e45e                	sd	s7,8(sp)
ffffffffc0200cd6:	473d                	li	a4,15
ffffffffc0200cd8:	842a                	mv	s0,a0
ffffffffc0200cda:	1ef76363          	bltu	a4,a5,ffffffffc0200ec0 <exception_handler+0x202>
ffffffffc0200cde:	00005717          	auipc	a4,0x5
ffffffffc0200ce2:	72270713          	addi	a4,a4,1826 # ffffffffc0206400 <commands+0x870>
ffffffffc0200ce6:	078a                	slli	a5,a5,0x2
ffffffffc0200ce8:	97ba                	add	a5,a5,a4
ffffffffc0200cea:	439c                	lw	a5,0(a5)
ffffffffc0200cec:	97ba                	add	a5,a5,a4
ffffffffc0200cee:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cf0:	00005517          	auipc	a0,0x5
ffffffffc0200cf4:	5d050513          	addi	a0,a0,1488 # ffffffffc02062c0 <commands+0x730>
ffffffffc0200cf8:	c9cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cfc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d00:	60a6                	ld	ra,72(sp)
ffffffffc0200d02:	74e2                	ld	s1,56(sp)
        tf->epc += 4;
ffffffffc0200d04:	0791                	addi	a5,a5,4
ffffffffc0200d06:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d0a:	6406                	ld	s0,64(sp)
ffffffffc0200d0c:	7942                	ld	s2,48(sp)
ffffffffc0200d0e:	79a2                	ld	s3,40(sp)
ffffffffc0200d10:	7a02                	ld	s4,32(sp)
ffffffffc0200d12:	6ae2                	ld	s5,24(sp)
ffffffffc0200d14:	6b42                	ld	s6,16(sp)
ffffffffc0200d16:	6ba2                	ld	s7,8(sp)
ffffffffc0200d18:	6161                	addi	sp,sp,80
        syscall();
ffffffffc0200d1a:	6be0406f          	j	ffffffffc02053d8 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d1e:	00005517          	auipc	a0,0x5
ffffffffc0200d22:	5c250513          	addi	a0,a0,1474 # ffffffffc02062e0 <commands+0x750>
}
ffffffffc0200d26:	6406                	ld	s0,64(sp)
ffffffffc0200d28:	60a6                	ld	ra,72(sp)
ffffffffc0200d2a:	74e2                	ld	s1,56(sp)
ffffffffc0200d2c:	7942                	ld	s2,48(sp)
ffffffffc0200d2e:	79a2                	ld	s3,40(sp)
ffffffffc0200d30:	7a02                	ld	s4,32(sp)
ffffffffc0200d32:	6ae2                	ld	s5,24(sp)
ffffffffc0200d34:	6b42                	ld	s6,16(sp)
ffffffffc0200d36:	6ba2                	ld	s7,8(sp)
ffffffffc0200d38:	6161                	addi	sp,sp,80
        cprintf("Instruction access fault\n");
ffffffffc0200d3a:	c5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d3e:	00005517          	auipc	a0,0x5
ffffffffc0200d42:	5c250513          	addi	a0,a0,1474 # ffffffffc0206300 <commands+0x770>
ffffffffc0200d46:	b7c5                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Instruction page fault\n");
ffffffffc0200d48:	00005517          	auipc	a0,0x5
ffffffffc0200d4c:	5d850513          	addi	a0,a0,1496 # ffffffffc0206320 <commands+0x790>
ffffffffc0200d50:	bfd9                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Load page fault\n");
ffffffffc0200d52:	00005517          	auipc	a0,0x5
ffffffffc0200d56:	5e650513          	addi	a0,a0,1510 # ffffffffc0206338 <commands+0x7a8>
ffffffffc0200d5a:	b7f1                	j	ffffffffc0200d26 <exception_handler+0x68>
        uintptr_t badaddr = read_csr(stval);
ffffffffc0200d5c:	143024f3          	csrr	s1,stval
        if (current != NULL && current->mm != NULL) {
ffffffffc0200d60:	000d2917          	auipc	s2,0xd2
ffffffffc0200d64:	5a090913          	addi	s2,s2,1440 # ffffffffc02d3300 <current>
ffffffffc0200d68:	00093783          	ld	a5,0(s2)
ffffffffc0200d6c:	16078663          	beqz	a5,ffffffffc0200ed8 <exception_handler+0x21a>
ffffffffc0200d70:	779c                	ld	a5,40(a5)
ffffffffc0200d72:	16078363          	beqz	a5,ffffffffc0200ed8 <exception_handler+0x21a>
            pte_t *ptep = get_pte(current->mm->pgdir, badaddr, 0);
ffffffffc0200d76:	6f88                	ld	a0,24(a5)
ffffffffc0200d78:	4601                	li	a2,0
ffffffffc0200d7a:	85a6                	mv	a1,s1
ffffffffc0200d7c:	3b4010ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0200d80:	842a                	mv	s0,a0
            if (ptep != NULL && (*ptep & PTE_V) && (*ptep & PTE_COW)) {
ffffffffc0200d82:	14050b63          	beqz	a0,ffffffffc0200ed8 <exception_handler+0x21a>
ffffffffc0200d86:	611c                	ld	a5,0(a0)
ffffffffc0200d88:	10100713          	li	a4,257
ffffffffc0200d8c:	1017f693          	andi	a3,a5,257
ffffffffc0200d90:	14e69463          	bne	a3,a4,ffffffffc0200ed8 <exception_handler+0x21a>
}

static inline struct Page *
pte2page(pte_t pte)
{
    if (!(pte & PTE_V))
ffffffffc0200d94:	0017f713          	andi	a4,a5,1
ffffffffc0200d98:	20070563          	beqz	a4,ffffffffc0200fa2 <exception_handler+0x2e4>
    if (PPN(pa) >= npage)
ffffffffc0200d9c:	000d2b17          	auipc	s6,0xd2
ffffffffc0200da0:	544b0b13          	addi	s6,s6,1348 # ffffffffc02d32e0 <npage>
ffffffffc0200da4:	000b3683          	ld	a3,0(s6)
    {
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
ffffffffc0200da8:	00279713          	slli	a4,a5,0x2
ffffffffc0200dac:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0200dae:	1cd77e63          	bgeu	a4,a3,ffffffffc0200f8a <exception_handler+0x2cc>
    return &pages[PPN(pa) - nbase];
ffffffffc0200db2:	000d2b97          	auipc	s7,0xd2
ffffffffc0200db6:	536b8b93          	addi	s7,s7,1334 # ffffffffc02d32e8 <pages>
ffffffffc0200dba:	000bb983          	ld	s3,0(s7)
ffffffffc0200dbe:	00007a97          	auipc	s5,0x7
ffffffffc0200dc2:	cd2aba83          	ld	s5,-814(s5) # ffffffffc0207a90 <nbase>
ffffffffc0200dc6:	41570733          	sub	a4,a4,s5
ffffffffc0200dca:	071a                	slli	a4,a4,0x6
ffffffffc0200dcc:	99ba                	add	s3,s3,a4
                if (page_ref(page) > 1) {
ffffffffc0200dce:	0009a683          	lw	a3,0(s3)
        uintptr_t la = ROUNDDOWN(badaddr, PGSIZE);
ffffffffc0200dd2:	767d                	lui	a2,0xfffff
                if (page_ref(page) > 1) {
ffffffffc0200dd4:	4705                	li	a4,1
        uintptr_t la = ROUNDDOWN(badaddr, PGSIZE);
ffffffffc0200dd6:	8cf1                	and	s1,s1,a2
                if (page_ref(page) > 1) {
ffffffffc0200dd8:	14d75b63          	bge	a4,a3,ffffffffc0200f2e <exception_handler+0x270>
                    struct Page *npage = alloc_page();
ffffffffc0200ddc:	4505                	li	a0,1
ffffffffc0200dde:	29a010ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0200de2:	8a2a                	mv	s4,a0
                    if (npage == NULL) panic("COW: out of memory");
ffffffffc0200de4:	18050763          	beqz	a0,ffffffffc0200f72 <exception_handler+0x2b4>
    return page - pages + nbase;
ffffffffc0200de8:	000bb583          	ld	a1,0(s7)
    return KADDR(page2pa(page));
ffffffffc0200dec:	577d                	li	a4,-1
ffffffffc0200dee:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc0200df2:	40b507b3          	sub	a5,a0,a1
ffffffffc0200df6:	8799                	srai	a5,a5,0x6
ffffffffc0200df8:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0200dfa:	8331                	srli	a4,a4,0xc
ffffffffc0200dfc:	00e7f533          	and	a0,a5,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e00:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0200e04:	14c57b63          	bgeu	a0,a2,ffffffffc0200f5a <exception_handler+0x29c>
    return page - pages + nbase;
ffffffffc0200e08:	40b987b3          	sub	a5,s3,a1
ffffffffc0200e0c:	8799                	srai	a5,a5,0x6
ffffffffc0200e0e:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0200e10:	000d2597          	auipc	a1,0xd2
ffffffffc0200e14:	4e85b583          	ld	a1,1256(a1) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0200e18:	8f7d                	and	a4,a4,a5
ffffffffc0200e1a:	00b68533          	add	a0,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e1e:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0200e22:	12c77c63          	bgeu	a4,a2,ffffffffc0200f5a <exception_handler+0x29c>
                    memcpy(page2kva(npage), page2kva(page), PGSIZE);
ffffffffc0200e26:	95b6                	add	a1,a1,a3
ffffffffc0200e28:	6605                	lui	a2,0x1
ffffffffc0200e2a:	2e7040ef          	jal	ra,ffffffffc0205910 <memcpy>
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e2e:	00093783          	ld	a5,0(s2)
                    uint32_t perm = (*ptep & PTE_USER);
ffffffffc0200e32:	6014                	ld	a3,0(s0)
}
ffffffffc0200e34:	6406                	ld	s0,64(sp)
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e36:	779c                	ld	a5,40(a5)
}
ffffffffc0200e38:	60a6                	ld	ra,72(sp)
ffffffffc0200e3a:	7942                	ld	s2,48(sp)
ffffffffc0200e3c:	79a2                	ld	s3,40(sp)
ffffffffc0200e3e:	6ae2                	ld	s5,24(sp)
ffffffffc0200e40:	6b42                	ld	s6,16(sp)
ffffffffc0200e42:	6ba2                	ld	s7,8(sp)
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e44:	6f88                	ld	a0,24(a5)
ffffffffc0200e46:	8626                	mv	a2,s1
ffffffffc0200e48:	85d2                	mv	a1,s4
}
ffffffffc0200e4a:	74e2                	ld	s1,56(sp)
ffffffffc0200e4c:	7a02                	ld	s4,32(sp)
                    perm = (perm | PTE_W) & ~PTE_COW;
ffffffffc0200e4e:	8aed                	andi	a3,a3,27
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e50:	0046e693          	ori	a3,a3,4
}
ffffffffc0200e54:	6161                	addi	sp,sp,80
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e56:	1cb0106f          	j	ffffffffc0202820 <page_insert>
        cprintf("Instruction address misaligned\n");
ffffffffc0200e5a:	00005517          	auipc	a0,0x5
ffffffffc0200e5e:	37e50513          	addi	a0,a0,894 # ffffffffc02061d8 <commands+0x648>
ffffffffc0200e62:	b5d1                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Instruction access fault\n");
ffffffffc0200e64:	00005517          	auipc	a0,0x5
ffffffffc0200e68:	39450513          	addi	a0,a0,916 # ffffffffc02061f8 <commands+0x668>
ffffffffc0200e6c:	bd6d                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Illegal instruction\n");
ffffffffc0200e6e:	00005517          	auipc	a0,0x5
ffffffffc0200e72:	3aa50513          	addi	a0,a0,938 # ffffffffc0206218 <commands+0x688>
ffffffffc0200e76:	bd45                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Breakpoint\n");
ffffffffc0200e78:	00005517          	auipc	a0,0x5
ffffffffc0200e7c:	3b850513          	addi	a0,a0,952 # ffffffffc0206230 <commands+0x6a0>
ffffffffc0200e80:	b14ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200e84:	6458                	ld	a4,136(s0)
ffffffffc0200e86:	47a9                	li	a5,10
ffffffffc0200e88:	06f70963          	beq	a4,a5,ffffffffc0200efa <exception_handler+0x23c>
}
ffffffffc0200e8c:	60a6                	ld	ra,72(sp)
ffffffffc0200e8e:	6406                	ld	s0,64(sp)
ffffffffc0200e90:	74e2                	ld	s1,56(sp)
ffffffffc0200e92:	7942                	ld	s2,48(sp)
ffffffffc0200e94:	79a2                	ld	s3,40(sp)
ffffffffc0200e96:	7a02                	ld	s4,32(sp)
ffffffffc0200e98:	6ae2                	ld	s5,24(sp)
ffffffffc0200e9a:	6b42                	ld	s6,16(sp)
ffffffffc0200e9c:	6ba2                	ld	s7,8(sp)
ffffffffc0200e9e:	6161                	addi	sp,sp,80
ffffffffc0200ea0:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200ea2:	00005517          	auipc	a0,0x5
ffffffffc0200ea6:	39e50513          	addi	a0,a0,926 # ffffffffc0206240 <commands+0x6b0>
ffffffffc0200eaa:	bdb5                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Load access fault\n");
ffffffffc0200eac:	00005517          	auipc	a0,0x5
ffffffffc0200eb0:	3b450513          	addi	a0,a0,948 # ffffffffc0206260 <commands+0x6d0>
ffffffffc0200eb4:	bd8d                	j	ffffffffc0200d26 <exception_handler+0x68>
        cprintf("Store/AMO access fault\n");
ffffffffc0200eb6:	00005517          	auipc	a0,0x5
ffffffffc0200eba:	3f250513          	addi	a0,a0,1010 # ffffffffc02062a8 <commands+0x718>
ffffffffc0200ebe:	b5a5                	j	ffffffffc0200d26 <exception_handler+0x68>
        print_trapframe(tf);
ffffffffc0200ec0:	8522                	mv	a0,s0
}
ffffffffc0200ec2:	6406                	ld	s0,64(sp)
ffffffffc0200ec4:	60a6                	ld	ra,72(sp)
ffffffffc0200ec6:	74e2                	ld	s1,56(sp)
ffffffffc0200ec8:	7942                	ld	s2,48(sp)
ffffffffc0200eca:	79a2                	ld	s3,40(sp)
ffffffffc0200ecc:	7a02                	ld	s4,32(sp)
ffffffffc0200ece:	6ae2                	ld	s5,24(sp)
ffffffffc0200ed0:	6b42                	ld	s6,16(sp)
ffffffffc0200ed2:	6ba2                	ld	s7,8(sp)
ffffffffc0200ed4:	6161                	addi	sp,sp,80
        print_trapframe(tf);
ffffffffc0200ed6:	b1f9                	j	ffffffffc0200ba4 <print_trapframe>
        cprintf("Store/AMO page fault\n");
ffffffffc0200ed8:	00005517          	auipc	a0,0x5
ffffffffc0200edc:	51050513          	addi	a0,a0,1296 # ffffffffc02063e8 <commands+0x858>
ffffffffc0200ee0:	b599                	j	ffffffffc0200d26 <exception_handler+0x68>
        panic("AMO address misaligned\n");
ffffffffc0200ee2:	00005617          	auipc	a2,0x5
ffffffffc0200ee6:	39660613          	addi	a2,a2,918 # ffffffffc0206278 <commands+0x6e8>
ffffffffc0200eea:	0c600593          	li	a1,198
ffffffffc0200eee:	00005517          	auipc	a0,0x5
ffffffffc0200ef2:	3a250513          	addi	a0,a0,930 # ffffffffc0206290 <commands+0x700>
ffffffffc0200ef6:	d98ff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200efa:	10843783          	ld	a5,264(s0)
ffffffffc0200efe:	0791                	addi	a5,a5,4
ffffffffc0200f00:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200f04:	4d4040ef          	jal	ra,ffffffffc02053d8 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f08:	000d2797          	auipc	a5,0xd2
ffffffffc0200f0c:	3f87b783          	ld	a5,1016(a5) # ffffffffc02d3300 <current>
ffffffffc0200f10:	6b9c                	ld	a5,16(a5)
ffffffffc0200f12:	8522                	mv	a0,s0
}
ffffffffc0200f14:	6406                	ld	s0,64(sp)
ffffffffc0200f16:	60a6                	ld	ra,72(sp)
ffffffffc0200f18:	74e2                	ld	s1,56(sp)
ffffffffc0200f1a:	7942                	ld	s2,48(sp)
ffffffffc0200f1c:	79a2                	ld	s3,40(sp)
ffffffffc0200f1e:	7a02                	ld	s4,32(sp)
ffffffffc0200f20:	6ae2                	ld	s5,24(sp)
ffffffffc0200f22:	6b42                	ld	s6,16(sp)
ffffffffc0200f24:	6ba2                	ld	s7,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f26:	6589                	lui	a1,0x2
ffffffffc0200f28:	95be                	add	a1,a1,a5
}
ffffffffc0200f2a:	6161                	addi	sp,sp,80
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f2c:	a2dd                	j	ffffffffc0201112 <kernel_execve_ret>
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f2e:	00093703          	ld	a4,0(s2)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f32:	efb7f793          	andi	a5,a5,-261
}
ffffffffc0200f36:	6406                	ld	s0,64(sp)
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f38:	7718                	ld	a4,40(a4)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f3a:	0047e793          	ori	a5,a5,4
}
ffffffffc0200f3e:	60a6                	ld	ra,72(sp)
ffffffffc0200f40:	7942                	ld	s2,48(sp)
ffffffffc0200f42:	79a2                	ld	s3,40(sp)
ffffffffc0200f44:	7a02                	ld	s4,32(sp)
ffffffffc0200f46:	6ae2                	ld	s5,24(sp)
ffffffffc0200f48:	6b42                	ld	s6,16(sp)
ffffffffc0200f4a:	6ba2                	ld	s7,8(sp)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f4c:	e11c                	sd	a5,0(a0)
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f4e:	85a6                	mv	a1,s1
ffffffffc0200f50:	6f08                	ld	a0,24(a4)
}
ffffffffc0200f52:	74e2                	ld	s1,56(sp)
ffffffffc0200f54:	6161                	addi	sp,sp,80
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f56:	0a50206f          	j	ffffffffc02037fa <tlb_invalidate>
ffffffffc0200f5a:	00005617          	auipc	a2,0x5
ffffffffc0200f5e:	46660613          	addi	a2,a2,1126 # ffffffffc02063c0 <commands+0x830>
ffffffffc0200f62:	07100593          	li	a1,113
ffffffffc0200f66:	00005517          	auipc	a0,0x5
ffffffffc0200f6a:	41250513          	addi	a0,a0,1042 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0200f6e:	d20ff0ef          	jal	ra,ffffffffc020048e <__panic>
                    if (npage == NULL) panic("COW: out of memory");
ffffffffc0200f72:	00005617          	auipc	a2,0x5
ffffffffc0200f76:	43660613          	addi	a2,a2,1078 # ffffffffc02063a8 <commands+0x818>
ffffffffc0200f7a:	0ec00593          	li	a1,236
ffffffffc0200f7e:	00005517          	auipc	a0,0x5
ffffffffc0200f82:	31250513          	addi	a0,a0,786 # ffffffffc0206290 <commands+0x700>
ffffffffc0200f86:	d08ff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0200f8a:	00005617          	auipc	a2,0x5
ffffffffc0200f8e:	3fe60613          	addi	a2,a2,1022 # ffffffffc0206388 <commands+0x7f8>
ffffffffc0200f92:	06900593          	li	a1,105
ffffffffc0200f96:	00005517          	auipc	a0,0x5
ffffffffc0200f9a:	3e250513          	addi	a0,a0,994 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0200f9e:	cf0ff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0200fa2:	00005617          	auipc	a2,0x5
ffffffffc0200fa6:	3ae60613          	addi	a2,a2,942 # ffffffffc0206350 <commands+0x7c0>
ffffffffc0200faa:	07f00593          	li	a1,127
ffffffffc0200fae:	00005517          	auipc	a0,0x5
ffffffffc0200fb2:	3ca50513          	addi	a0,a0,970 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0200fb6:	cd8ff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0200fba <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200fba:	1101                	addi	sp,sp,-32
ffffffffc0200fbc:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200fbe:	000d2417          	auipc	s0,0xd2
ffffffffc0200fc2:	34240413          	addi	s0,s0,834 # ffffffffc02d3300 <current>
ffffffffc0200fc6:	6018                	ld	a4,0(s0)
{
ffffffffc0200fc8:	ec06                	sd	ra,24(sp)
ffffffffc0200fca:	e426                	sd	s1,8(sp)
ffffffffc0200fcc:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200fce:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200fd2:	cf1d                	beqz	a4,ffffffffc0201010 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200fd4:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200fd8:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200fdc:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200fde:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200fe2:	0206c463          	bltz	a3,ffffffffc020100a <trap+0x50>
        exception_handler(tf);
ffffffffc0200fe6:	cd9ff0ef          	jal	ra,ffffffffc0200cbe <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200fea:	601c                	ld	a5,0(s0)
ffffffffc0200fec:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200ff0:	e499                	bnez	s1,ffffffffc0200ffe <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200ff2:	0b07a703          	lw	a4,176(a5)
ffffffffc0200ff6:	8b05                	andi	a4,a4,1
ffffffffc0200ff8:	e329                	bnez	a4,ffffffffc020103a <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200ffa:	6f9c                	ld	a5,24(a5)
ffffffffc0200ffc:	eb85                	bnez	a5,ffffffffc020102c <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200ffe:	60e2                	ld	ra,24(sp)
ffffffffc0201000:	6442                	ld	s0,16(sp)
ffffffffc0201002:	64a2                	ld	s1,8(sp)
ffffffffc0201004:	6902                	ld	s2,0(sp)
ffffffffc0201006:	6105                	addi	sp,sp,32
ffffffffc0201008:	8082                	ret
        interrupt_handler(tf);
ffffffffc020100a:	bfdff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc020100e:	bff1                	j	ffffffffc0200fea <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0201010:	0006c863          	bltz	a3,ffffffffc0201020 <trap+0x66>
}
ffffffffc0201014:	6442                	ld	s0,16(sp)
ffffffffc0201016:	60e2                	ld	ra,24(sp)
ffffffffc0201018:	64a2                	ld	s1,8(sp)
ffffffffc020101a:	6902                	ld	s2,0(sp)
ffffffffc020101c:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc020101e:	b145                	j	ffffffffc0200cbe <exception_handler>
}
ffffffffc0201020:	6442                	ld	s0,16(sp)
ffffffffc0201022:	60e2                	ld	ra,24(sp)
ffffffffc0201024:	64a2                	ld	s1,8(sp)
ffffffffc0201026:	6902                	ld	s2,0(sp)
ffffffffc0201028:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc020102a:	bef1                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc020102c:	6442                	ld	s0,16(sp)
ffffffffc020102e:	60e2                	ld	ra,24(sp)
ffffffffc0201030:	64a2                	ld	s1,8(sp)
ffffffffc0201032:	6902                	ld	s2,0(sp)
ffffffffc0201034:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0201036:	2b60406f          	j	ffffffffc02052ec <schedule>
                do_exit(-E_KILLED);
ffffffffc020103a:	555d                	li	a0,-9
ffffffffc020103c:	5f6030ef          	jal	ra,ffffffffc0204632 <do_exit>
            if (current->need_resched)
ffffffffc0201040:	601c                	ld	a5,0(s0)
ffffffffc0201042:	bf65                	j	ffffffffc0200ffa <trap+0x40>

ffffffffc0201044 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0201044:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201048:	00011463          	bnez	sp,ffffffffc0201050 <__alltraps+0xc>
ffffffffc020104c:	14002173          	csrr	sp,sscratch
ffffffffc0201050:	712d                	addi	sp,sp,-288
ffffffffc0201052:	e002                	sd	zero,0(sp)
ffffffffc0201054:	e406                	sd	ra,8(sp)
ffffffffc0201056:	ec0e                	sd	gp,24(sp)
ffffffffc0201058:	f012                	sd	tp,32(sp)
ffffffffc020105a:	f416                	sd	t0,40(sp)
ffffffffc020105c:	f81a                	sd	t1,48(sp)
ffffffffc020105e:	fc1e                	sd	t2,56(sp)
ffffffffc0201060:	e0a2                	sd	s0,64(sp)
ffffffffc0201062:	e4a6                	sd	s1,72(sp)
ffffffffc0201064:	e8aa                	sd	a0,80(sp)
ffffffffc0201066:	ecae                	sd	a1,88(sp)
ffffffffc0201068:	f0b2                	sd	a2,96(sp)
ffffffffc020106a:	f4b6                	sd	a3,104(sp)
ffffffffc020106c:	f8ba                	sd	a4,112(sp)
ffffffffc020106e:	fcbe                	sd	a5,120(sp)
ffffffffc0201070:	e142                	sd	a6,128(sp)
ffffffffc0201072:	e546                	sd	a7,136(sp)
ffffffffc0201074:	e94a                	sd	s2,144(sp)
ffffffffc0201076:	ed4e                	sd	s3,152(sp)
ffffffffc0201078:	f152                	sd	s4,160(sp)
ffffffffc020107a:	f556                	sd	s5,168(sp)
ffffffffc020107c:	f95a                	sd	s6,176(sp)
ffffffffc020107e:	fd5e                	sd	s7,184(sp)
ffffffffc0201080:	e1e2                	sd	s8,192(sp)
ffffffffc0201082:	e5e6                	sd	s9,200(sp)
ffffffffc0201084:	e9ea                	sd	s10,208(sp)
ffffffffc0201086:	edee                	sd	s11,216(sp)
ffffffffc0201088:	f1f2                	sd	t3,224(sp)
ffffffffc020108a:	f5f6                	sd	t4,232(sp)
ffffffffc020108c:	f9fa                	sd	t5,240(sp)
ffffffffc020108e:	fdfe                	sd	t6,248(sp)
ffffffffc0201090:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201094:	100024f3          	csrr	s1,sstatus
ffffffffc0201098:	14102973          	csrr	s2,sepc
ffffffffc020109c:	143029f3          	csrr	s3,stval
ffffffffc02010a0:	14202a73          	csrr	s4,scause
ffffffffc02010a4:	e822                	sd	s0,16(sp)
ffffffffc02010a6:	e226                	sd	s1,256(sp)
ffffffffc02010a8:	e64a                	sd	s2,264(sp)
ffffffffc02010aa:	ea4e                	sd	s3,272(sp)
ffffffffc02010ac:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc02010ae:	850a                	mv	a0,sp
    jal trap
ffffffffc02010b0:	f0bff0ef          	jal	ra,ffffffffc0200fba <trap>

ffffffffc02010b4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc02010b4:	6492                	ld	s1,256(sp)
ffffffffc02010b6:	6932                	ld	s2,264(sp)
ffffffffc02010b8:	1004f413          	andi	s0,s1,256
ffffffffc02010bc:	e401                	bnez	s0,ffffffffc02010c4 <__trapret+0x10>
ffffffffc02010be:	1200                	addi	s0,sp,288
ffffffffc02010c0:	14041073          	csrw	sscratch,s0
ffffffffc02010c4:	10049073          	csrw	sstatus,s1
ffffffffc02010c8:	14191073          	csrw	sepc,s2
ffffffffc02010cc:	60a2                	ld	ra,8(sp)
ffffffffc02010ce:	61e2                	ld	gp,24(sp)
ffffffffc02010d0:	7202                	ld	tp,32(sp)
ffffffffc02010d2:	72a2                	ld	t0,40(sp)
ffffffffc02010d4:	7342                	ld	t1,48(sp)
ffffffffc02010d6:	73e2                	ld	t2,56(sp)
ffffffffc02010d8:	6406                	ld	s0,64(sp)
ffffffffc02010da:	64a6                	ld	s1,72(sp)
ffffffffc02010dc:	6546                	ld	a0,80(sp)
ffffffffc02010de:	65e6                	ld	a1,88(sp)
ffffffffc02010e0:	7606                	ld	a2,96(sp)
ffffffffc02010e2:	76a6                	ld	a3,104(sp)
ffffffffc02010e4:	7746                	ld	a4,112(sp)
ffffffffc02010e6:	77e6                	ld	a5,120(sp)
ffffffffc02010e8:	680a                	ld	a6,128(sp)
ffffffffc02010ea:	68aa                	ld	a7,136(sp)
ffffffffc02010ec:	694a                	ld	s2,144(sp)
ffffffffc02010ee:	69ea                	ld	s3,152(sp)
ffffffffc02010f0:	7a0a                	ld	s4,160(sp)
ffffffffc02010f2:	7aaa                	ld	s5,168(sp)
ffffffffc02010f4:	7b4a                	ld	s6,176(sp)
ffffffffc02010f6:	7bea                	ld	s7,184(sp)
ffffffffc02010f8:	6c0e                	ld	s8,192(sp)
ffffffffc02010fa:	6cae                	ld	s9,200(sp)
ffffffffc02010fc:	6d4e                	ld	s10,208(sp)
ffffffffc02010fe:	6dee                	ld	s11,216(sp)
ffffffffc0201100:	7e0e                	ld	t3,224(sp)
ffffffffc0201102:	7eae                	ld	t4,232(sp)
ffffffffc0201104:	7f4e                	ld	t5,240(sp)
ffffffffc0201106:	7fee                	ld	t6,248(sp)
ffffffffc0201108:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc020110a:	10200073          	sret

ffffffffc020110e <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc020110e:	812a                	mv	sp,a0
    j __trapret
ffffffffc0201110:	b755                	j	ffffffffc02010b4 <__trapret>

ffffffffc0201112 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0201112:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0201116:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc020111a:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc020111e:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0201122:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0201126:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc020112a:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc020112e:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0201132:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0201136:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0201138:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc020113a:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc020113c:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc020113e:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0201140:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0201142:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201144:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0201146:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0201148:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc020114a:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc020114c:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc020114e:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0201150:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0201152:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201154:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0201156:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201158:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc020115a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc020115c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc020115e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201160:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0201162:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201164:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0201166:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201168:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc020116a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc020116c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc020116e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201170:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0201172:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201174:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0201176:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201178:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc020117a:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc020117c:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc020117e:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201180:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0201182:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201184:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0201186:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201188:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc020118a:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc020118c:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc020118e:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201190:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0201192:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201194:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201196:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201198:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc020119a:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc020119c:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020119e:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc02011a0:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc02011a2:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc02011a4:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc02011a6:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc02011a8:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc02011aa:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc02011ac:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc02011ae:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc02011b0:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc02011b2:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc02011b4:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc02011b6:	812e                	mv	sp,a1
ffffffffc02011b8:	bdf5                	j	ffffffffc02010b4 <__trapret>

ffffffffc02011ba <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02011ba:	000ce797          	auipc	a5,0xce
ffffffffc02011be:	0b678793          	addi	a5,a5,182 # ffffffffc02cf270 <free_area>
ffffffffc02011c2:	e79c                	sd	a5,8(a5)
ffffffffc02011c4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc02011c6:	0007a823          	sw	zero,16(a5)
}
ffffffffc02011ca:	8082                	ret

ffffffffc02011cc <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc02011cc:	000ce517          	auipc	a0,0xce
ffffffffc02011d0:	0b456503          	lwu	a0,180(a0) # ffffffffc02cf280 <free_area+0x10>
ffffffffc02011d4:	8082                	ret

ffffffffc02011d6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc02011d6:	715d                	addi	sp,sp,-80
ffffffffc02011d8:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02011da:	000ce417          	auipc	s0,0xce
ffffffffc02011de:	09640413          	addi	s0,s0,150 # ffffffffc02cf270 <free_area>
ffffffffc02011e2:	641c                	ld	a5,8(s0)
ffffffffc02011e4:	e486                	sd	ra,72(sp)
ffffffffc02011e6:	fc26                	sd	s1,56(sp)
ffffffffc02011e8:	f84a                	sd	s2,48(sp)
ffffffffc02011ea:	f44e                	sd	s3,40(sp)
ffffffffc02011ec:	f052                	sd	s4,32(sp)
ffffffffc02011ee:	ec56                	sd	s5,24(sp)
ffffffffc02011f0:	e85a                	sd	s6,16(sp)
ffffffffc02011f2:	e45e                	sd	s7,8(sp)
ffffffffc02011f4:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02011f6:	2a878d63          	beq	a5,s0,ffffffffc02014b0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02011fa:	4481                	li	s1,0
ffffffffc02011fc:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02011fe:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201202:	8b09                	andi	a4,a4,2
ffffffffc0201204:	2a070a63          	beqz	a4,ffffffffc02014b8 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201208:	ff87a703          	lw	a4,-8(a5)
ffffffffc020120c:	679c                	ld	a5,8(a5)
ffffffffc020120e:	2905                	addiw	s2,s2,1
ffffffffc0201210:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201212:	fe8796e3          	bne	a5,s0,ffffffffc02011fe <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201216:	89a6                	mv	s3,s1
ffffffffc0201218:	6df000ef          	jal	ra,ffffffffc02020f6 <nr_free_pages>
ffffffffc020121c:	6f351e63          	bne	a0,s3,ffffffffc0201918 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201220:	4505                	li	a0,1
ffffffffc0201222:	657000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0201226:	8aaa                	mv	s5,a0
ffffffffc0201228:	42050863          	beqz	a0,ffffffffc0201658 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020122c:	4505                	li	a0,1
ffffffffc020122e:	64b000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0201232:	89aa                	mv	s3,a0
ffffffffc0201234:	70050263          	beqz	a0,ffffffffc0201938 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201238:	4505                	li	a0,1
ffffffffc020123a:	63f000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020123e:	8a2a                	mv	s4,a0
ffffffffc0201240:	48050c63          	beqz	a0,ffffffffc02016d8 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201244:	293a8a63          	beq	s5,s3,ffffffffc02014d8 <default_check+0x302>
ffffffffc0201248:	28aa8863          	beq	s5,a0,ffffffffc02014d8 <default_check+0x302>
ffffffffc020124c:	28a98663          	beq	s3,a0,ffffffffc02014d8 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201250:	000aa783          	lw	a5,0(s5)
ffffffffc0201254:	2a079263          	bnez	a5,ffffffffc02014f8 <default_check+0x322>
ffffffffc0201258:	0009a783          	lw	a5,0(s3)
ffffffffc020125c:	28079e63          	bnez	a5,ffffffffc02014f8 <default_check+0x322>
ffffffffc0201260:	411c                	lw	a5,0(a0)
ffffffffc0201262:	28079b63          	bnez	a5,ffffffffc02014f8 <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201266:	000d2797          	auipc	a5,0xd2
ffffffffc020126a:	0827b783          	ld	a5,130(a5) # ffffffffc02d32e8 <pages>
ffffffffc020126e:	40fa8733          	sub	a4,s5,a5
ffffffffc0201272:	00007617          	auipc	a2,0x7
ffffffffc0201276:	81e63603          	ld	a2,-2018(a2) # ffffffffc0207a90 <nbase>
ffffffffc020127a:	8719                	srai	a4,a4,0x6
ffffffffc020127c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020127e:	000d2697          	auipc	a3,0xd2
ffffffffc0201282:	0626b683          	ld	a3,98(a3) # ffffffffc02d32e0 <npage>
ffffffffc0201286:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201288:	0732                	slli	a4,a4,0xc
ffffffffc020128a:	28d77763          	bgeu	a4,a3,ffffffffc0201518 <default_check+0x342>
    return page - pages + nbase;
ffffffffc020128e:	40f98733          	sub	a4,s3,a5
ffffffffc0201292:	8719                	srai	a4,a4,0x6
ffffffffc0201294:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201296:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201298:	4cd77063          	bgeu	a4,a3,ffffffffc0201758 <default_check+0x582>
    return page - pages + nbase;
ffffffffc020129c:	40f507b3          	sub	a5,a0,a5
ffffffffc02012a0:	8799                	srai	a5,a5,0x6
ffffffffc02012a2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02012a4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02012a6:	30d7f963          	bgeu	a5,a3,ffffffffc02015b8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02012aa:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02012ac:	00043c03          	ld	s8,0(s0)
ffffffffc02012b0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02012b4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02012b8:	e400                	sd	s0,8(s0)
ffffffffc02012ba:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02012bc:	000ce797          	auipc	a5,0xce
ffffffffc02012c0:	fc07a223          	sw	zero,-60(a5) # ffffffffc02cf280 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02012c4:	5b5000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02012c8:	2c051863          	bnez	a0,ffffffffc0201598 <default_check+0x3c2>
    free_page(p0);
ffffffffc02012cc:	4585                	li	a1,1
ffffffffc02012ce:	8556                	mv	a0,s5
ffffffffc02012d0:	5e7000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_page(p1);
ffffffffc02012d4:	4585                	li	a1,1
ffffffffc02012d6:	854e                	mv	a0,s3
ffffffffc02012d8:	5df000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_page(p2);
ffffffffc02012dc:	4585                	li	a1,1
ffffffffc02012de:	8552                	mv	a0,s4
ffffffffc02012e0:	5d7000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    assert(nr_free == 3);
ffffffffc02012e4:	4818                	lw	a4,16(s0)
ffffffffc02012e6:	478d                	li	a5,3
ffffffffc02012e8:	28f71863          	bne	a4,a5,ffffffffc0201578 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012ec:	4505                	li	a0,1
ffffffffc02012ee:	58b000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02012f2:	89aa                	mv	s3,a0
ffffffffc02012f4:	26050263          	beqz	a0,ffffffffc0201558 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012f8:	4505                	li	a0,1
ffffffffc02012fa:	57f000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02012fe:	8aaa                	mv	s5,a0
ffffffffc0201300:	3a050c63          	beqz	a0,ffffffffc02016b8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201304:	4505                	li	a0,1
ffffffffc0201306:	573000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020130a:	8a2a                	mv	s4,a0
ffffffffc020130c:	38050663          	beqz	a0,ffffffffc0201698 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201310:	4505                	li	a0,1
ffffffffc0201312:	567000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0201316:	36051163          	bnez	a0,ffffffffc0201678 <default_check+0x4a2>
    free_page(p0);
ffffffffc020131a:	4585                	li	a1,1
ffffffffc020131c:	854e                	mv	a0,s3
ffffffffc020131e:	599000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201322:	641c                	ld	a5,8(s0)
ffffffffc0201324:	20878a63          	beq	a5,s0,ffffffffc0201538 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201328:	4505                	li	a0,1
ffffffffc020132a:	54f000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020132e:	30a99563          	bne	s3,a0,ffffffffc0201638 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201332:	4505                	li	a0,1
ffffffffc0201334:	545000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0201338:	2e051063          	bnez	a0,ffffffffc0201618 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020133c:	481c                	lw	a5,16(s0)
ffffffffc020133e:	2a079d63          	bnez	a5,ffffffffc02015f8 <default_check+0x422>
    free_page(p);
ffffffffc0201342:	854e                	mv	a0,s3
ffffffffc0201344:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201346:	01843023          	sd	s8,0(s0)
ffffffffc020134a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020134e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201352:	565000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_page(p1);
ffffffffc0201356:	4585                	li	a1,1
ffffffffc0201358:	8556                	mv	a0,s5
ffffffffc020135a:	55d000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_page(p2);
ffffffffc020135e:	4585                	li	a1,1
ffffffffc0201360:	8552                	mv	a0,s4
ffffffffc0201362:	555000ef          	jal	ra,ffffffffc02020b6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201366:	4515                	li	a0,5
ffffffffc0201368:	511000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020136c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020136e:	26050563          	beqz	a0,ffffffffc02015d8 <default_check+0x402>
ffffffffc0201372:	651c                	ld	a5,8(a0)
ffffffffc0201374:	8385                	srli	a5,a5,0x1
ffffffffc0201376:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201378:	54079063          	bnez	a5,ffffffffc02018b8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020137c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020137e:	00043b03          	ld	s6,0(s0)
ffffffffc0201382:	00843a83          	ld	s5,8(s0)
ffffffffc0201386:	e000                	sd	s0,0(s0)
ffffffffc0201388:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020138a:	4ef000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020138e:	50051563          	bnez	a0,ffffffffc0201898 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201392:	08098a13          	addi	s4,s3,128
ffffffffc0201396:	8552                	mv	a0,s4
ffffffffc0201398:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020139a:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020139e:	000ce797          	auipc	a5,0xce
ffffffffc02013a2:	ee07a123          	sw	zero,-286(a5) # ffffffffc02cf280 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02013a6:	511000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02013aa:	4511                	li	a0,4
ffffffffc02013ac:	4cd000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02013b0:	4c051463          	bnez	a0,ffffffffc0201878 <default_check+0x6a2>
ffffffffc02013b4:	0889b783          	ld	a5,136(s3)
ffffffffc02013b8:	8385                	srli	a5,a5,0x1
ffffffffc02013ba:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02013bc:	48078e63          	beqz	a5,ffffffffc0201858 <default_check+0x682>
ffffffffc02013c0:	0909a703          	lw	a4,144(s3)
ffffffffc02013c4:	478d                	li	a5,3
ffffffffc02013c6:	48f71963          	bne	a4,a5,ffffffffc0201858 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02013ca:	450d                	li	a0,3
ffffffffc02013cc:	4ad000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02013d0:	8c2a                	mv	s8,a0
ffffffffc02013d2:	46050363          	beqz	a0,ffffffffc0201838 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02013d6:	4505                	li	a0,1
ffffffffc02013d8:	4a1000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc02013dc:	42051e63          	bnez	a0,ffffffffc0201818 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02013e0:	418a1c63          	bne	s4,s8,ffffffffc02017f8 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02013e4:	4585                	li	a1,1
ffffffffc02013e6:	854e                	mv	a0,s3
ffffffffc02013e8:	4cf000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_pages(p1, 3);
ffffffffc02013ec:	458d                	li	a1,3
ffffffffc02013ee:	8552                	mv	a0,s4
ffffffffc02013f0:	4c7000ef          	jal	ra,ffffffffc02020b6 <free_pages>
ffffffffc02013f4:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02013f8:	04098c13          	addi	s8,s3,64
ffffffffc02013fc:	8385                	srli	a5,a5,0x1
ffffffffc02013fe:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201400:	3c078c63          	beqz	a5,ffffffffc02017d8 <default_check+0x602>
ffffffffc0201404:	0109a703          	lw	a4,16(s3)
ffffffffc0201408:	4785                	li	a5,1
ffffffffc020140a:	3cf71763          	bne	a4,a5,ffffffffc02017d8 <default_check+0x602>
ffffffffc020140e:	008a3783          	ld	a5,8(s4)
ffffffffc0201412:	8385                	srli	a5,a5,0x1
ffffffffc0201414:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201416:	3a078163          	beqz	a5,ffffffffc02017b8 <default_check+0x5e2>
ffffffffc020141a:	010a2703          	lw	a4,16(s4)
ffffffffc020141e:	478d                	li	a5,3
ffffffffc0201420:	38f71c63          	bne	a4,a5,ffffffffc02017b8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201424:	4505                	li	a0,1
ffffffffc0201426:	453000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020142a:	36a99763          	bne	s3,a0,ffffffffc0201798 <default_check+0x5c2>
    free_page(p0);
ffffffffc020142e:	4585                	li	a1,1
ffffffffc0201430:	487000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201434:	4509                	li	a0,2
ffffffffc0201436:	443000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020143a:	32aa1f63          	bne	s4,a0,ffffffffc0201778 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020143e:	4589                	li	a1,2
ffffffffc0201440:	477000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    free_page(p2);
ffffffffc0201444:	4585                	li	a1,1
ffffffffc0201446:	8562                	mv	a0,s8
ffffffffc0201448:	46f000ef          	jal	ra,ffffffffc02020b6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020144c:	4515                	li	a0,5
ffffffffc020144e:	42b000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0201452:	89aa                	mv	s3,a0
ffffffffc0201454:	48050263          	beqz	a0,ffffffffc02018d8 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201458:	4505                	li	a0,1
ffffffffc020145a:	41f000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020145e:	2c051d63          	bnez	a0,ffffffffc0201738 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201462:	481c                	lw	a5,16(s0)
ffffffffc0201464:	2a079a63          	bnez	a5,ffffffffc0201718 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201468:	4595                	li	a1,5
ffffffffc020146a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020146c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201470:	01643023          	sd	s6,0(s0)
ffffffffc0201474:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201478:	43f000ef          	jal	ra,ffffffffc02020b6 <free_pages>
    return listelm->next;
ffffffffc020147c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020147e:	00878963          	beq	a5,s0,ffffffffc0201490 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201482:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201486:	679c                	ld	a5,8(a5)
ffffffffc0201488:	397d                	addiw	s2,s2,-1
ffffffffc020148a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020148c:	fe879be3          	bne	a5,s0,ffffffffc0201482 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201490:	26091463          	bnez	s2,ffffffffc02016f8 <default_check+0x522>
    assert(total == 0);
ffffffffc0201494:	46049263          	bnez	s1,ffffffffc02018f8 <default_check+0x722>
}
ffffffffc0201498:	60a6                	ld	ra,72(sp)
ffffffffc020149a:	6406                	ld	s0,64(sp)
ffffffffc020149c:	74e2                	ld	s1,56(sp)
ffffffffc020149e:	7942                	ld	s2,48(sp)
ffffffffc02014a0:	79a2                	ld	s3,40(sp)
ffffffffc02014a2:	7a02                	ld	s4,32(sp)
ffffffffc02014a4:	6ae2                	ld	s5,24(sp)
ffffffffc02014a6:	6b42                	ld	s6,16(sp)
ffffffffc02014a8:	6ba2                	ld	s7,8(sp)
ffffffffc02014aa:	6c02                	ld	s8,0(sp)
ffffffffc02014ac:	6161                	addi	sp,sp,80
ffffffffc02014ae:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02014b0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02014b2:	4481                	li	s1,0
ffffffffc02014b4:	4901                	li	s2,0
ffffffffc02014b6:	b38d                	j	ffffffffc0201218 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02014b8:	00005697          	auipc	a3,0x5
ffffffffc02014bc:	f8868693          	addi	a3,a3,-120 # ffffffffc0206440 <commands+0x8b0>
ffffffffc02014c0:	00005617          	auipc	a2,0x5
ffffffffc02014c4:	f9060613          	addi	a2,a2,-112 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02014c8:	11000593          	li	a1,272
ffffffffc02014cc:	00005517          	auipc	a0,0x5
ffffffffc02014d0:	f9c50513          	addi	a0,a0,-100 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02014d4:	fbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02014d8:	00005697          	auipc	a3,0x5
ffffffffc02014dc:	02868693          	addi	a3,a3,40 # ffffffffc0206500 <commands+0x970>
ffffffffc02014e0:	00005617          	auipc	a2,0x5
ffffffffc02014e4:	f7060613          	addi	a2,a2,-144 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02014e8:	0db00593          	li	a1,219
ffffffffc02014ec:	00005517          	auipc	a0,0x5
ffffffffc02014f0:	f7c50513          	addi	a0,a0,-132 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02014f4:	f9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02014f8:	00005697          	auipc	a3,0x5
ffffffffc02014fc:	03068693          	addi	a3,a3,48 # ffffffffc0206528 <commands+0x998>
ffffffffc0201500:	00005617          	auipc	a2,0x5
ffffffffc0201504:	f5060613          	addi	a2,a2,-176 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201508:	0dc00593          	li	a1,220
ffffffffc020150c:	00005517          	auipc	a0,0x5
ffffffffc0201510:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201514:	f7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201518:	00005697          	auipc	a3,0x5
ffffffffc020151c:	05068693          	addi	a3,a3,80 # ffffffffc0206568 <commands+0x9d8>
ffffffffc0201520:	00005617          	auipc	a2,0x5
ffffffffc0201524:	f3060613          	addi	a2,a2,-208 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201528:	0de00593          	li	a1,222
ffffffffc020152c:	00005517          	auipc	a0,0x5
ffffffffc0201530:	f3c50513          	addi	a0,a0,-196 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201534:	f5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201538:	00005697          	auipc	a3,0x5
ffffffffc020153c:	0b868693          	addi	a3,a3,184 # ffffffffc02065f0 <commands+0xa60>
ffffffffc0201540:	00005617          	auipc	a2,0x5
ffffffffc0201544:	f1060613          	addi	a2,a2,-240 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201548:	0f700593          	li	a1,247
ffffffffc020154c:	00005517          	auipc	a0,0x5
ffffffffc0201550:	f1c50513          	addi	a0,a0,-228 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201554:	f3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201558:	00005697          	auipc	a3,0x5
ffffffffc020155c:	f4868693          	addi	a3,a3,-184 # ffffffffc02064a0 <commands+0x910>
ffffffffc0201560:	00005617          	auipc	a2,0x5
ffffffffc0201564:	ef060613          	addi	a2,a2,-272 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201568:	0f000593          	li	a1,240
ffffffffc020156c:	00005517          	auipc	a0,0x5
ffffffffc0201570:	efc50513          	addi	a0,a0,-260 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201574:	f1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201578:	00005697          	auipc	a3,0x5
ffffffffc020157c:	06868693          	addi	a3,a3,104 # ffffffffc02065e0 <commands+0xa50>
ffffffffc0201580:	00005617          	auipc	a2,0x5
ffffffffc0201584:	ed060613          	addi	a2,a2,-304 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201588:	0ee00593          	li	a1,238
ffffffffc020158c:	00005517          	auipc	a0,0x5
ffffffffc0201590:	edc50513          	addi	a0,a0,-292 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201594:	efbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201598:	00005697          	auipc	a3,0x5
ffffffffc020159c:	03068693          	addi	a3,a3,48 # ffffffffc02065c8 <commands+0xa38>
ffffffffc02015a0:	00005617          	auipc	a2,0x5
ffffffffc02015a4:	eb060613          	addi	a2,a2,-336 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02015a8:	0e900593          	li	a1,233
ffffffffc02015ac:	00005517          	auipc	a0,0x5
ffffffffc02015b0:	ebc50513          	addi	a0,a0,-324 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02015b4:	edbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02015b8:	00005697          	auipc	a3,0x5
ffffffffc02015bc:	ff068693          	addi	a3,a3,-16 # ffffffffc02065a8 <commands+0xa18>
ffffffffc02015c0:	00005617          	auipc	a2,0x5
ffffffffc02015c4:	e9060613          	addi	a2,a2,-368 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02015c8:	0e000593          	li	a1,224
ffffffffc02015cc:	00005517          	auipc	a0,0x5
ffffffffc02015d0:	e9c50513          	addi	a0,a0,-356 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02015d4:	ebbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02015d8:	00005697          	auipc	a3,0x5
ffffffffc02015dc:	06068693          	addi	a3,a3,96 # ffffffffc0206638 <commands+0xaa8>
ffffffffc02015e0:	00005617          	auipc	a2,0x5
ffffffffc02015e4:	e7060613          	addi	a2,a2,-400 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02015e8:	11800593          	li	a1,280
ffffffffc02015ec:	00005517          	auipc	a0,0x5
ffffffffc02015f0:	e7c50513          	addi	a0,a0,-388 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02015f4:	e9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02015f8:	00005697          	auipc	a3,0x5
ffffffffc02015fc:	03068693          	addi	a3,a3,48 # ffffffffc0206628 <commands+0xa98>
ffffffffc0201600:	00005617          	auipc	a2,0x5
ffffffffc0201604:	e5060613          	addi	a2,a2,-432 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201608:	0fd00593          	li	a1,253
ffffffffc020160c:	00005517          	auipc	a0,0x5
ffffffffc0201610:	e5c50513          	addi	a0,a0,-420 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201614:	e7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	fb068693          	addi	a3,a3,-80 # ffffffffc02065c8 <commands+0xa38>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	e3060613          	addi	a2,a2,-464 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201628:	0fb00593          	li	a1,251
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	e3c50513          	addi	a0,a0,-452 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201634:	e5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	fd068693          	addi	a3,a3,-48 # ffffffffc0206608 <commands+0xa78>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	e1060613          	addi	a2,a2,-496 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201648:	0fa00593          	li	a1,250
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	e1c50513          	addi	a0,a0,-484 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201654:	e3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	e4868693          	addi	a3,a3,-440 # ffffffffc02064a0 <commands+0x910>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	df060613          	addi	a2,a2,-528 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201668:	0d700593          	li	a1,215
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	dfc50513          	addi	a0,a0,-516 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201674:	e1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	f5068693          	addi	a3,a3,-176 # ffffffffc02065c8 <commands+0xa38>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	dd060613          	addi	a2,a2,-560 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201688:	0f400593          	li	a1,244
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	ddc50513          	addi	a0,a0,-548 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201694:	dfbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201698:	00005697          	auipc	a3,0x5
ffffffffc020169c:	e4868693          	addi	a3,a3,-440 # ffffffffc02064e0 <commands+0x950>
ffffffffc02016a0:	00005617          	auipc	a2,0x5
ffffffffc02016a4:	db060613          	addi	a2,a2,-592 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02016a8:	0f200593          	li	a1,242
ffffffffc02016ac:	00005517          	auipc	a0,0x5
ffffffffc02016b0:	dbc50513          	addi	a0,a0,-580 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02016b4:	ddbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02016b8:	00005697          	auipc	a3,0x5
ffffffffc02016bc:	e0868693          	addi	a3,a3,-504 # ffffffffc02064c0 <commands+0x930>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	d9060613          	addi	a2,a2,-624 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02016c8:	0f100593          	li	a1,241
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	d9c50513          	addi	a0,a0,-612 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02016d4:	dbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02016d8:	00005697          	auipc	a3,0x5
ffffffffc02016dc:	e0868693          	addi	a3,a3,-504 # ffffffffc02064e0 <commands+0x950>
ffffffffc02016e0:	00005617          	auipc	a2,0x5
ffffffffc02016e4:	d7060613          	addi	a2,a2,-656 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02016e8:	0d900593          	li	a1,217
ffffffffc02016ec:	00005517          	auipc	a0,0x5
ffffffffc02016f0:	d7c50513          	addi	a0,a0,-644 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02016f4:	d9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02016f8:	00005697          	auipc	a3,0x5
ffffffffc02016fc:	09068693          	addi	a3,a3,144 # ffffffffc0206788 <commands+0xbf8>
ffffffffc0201700:	00005617          	auipc	a2,0x5
ffffffffc0201704:	d5060613          	addi	a2,a2,-688 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201708:	14600593          	li	a1,326
ffffffffc020170c:	00005517          	auipc	a0,0x5
ffffffffc0201710:	d5c50513          	addi	a0,a0,-676 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201714:	d7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201718:	00005697          	auipc	a3,0x5
ffffffffc020171c:	f1068693          	addi	a3,a3,-240 # ffffffffc0206628 <commands+0xa98>
ffffffffc0201720:	00005617          	auipc	a2,0x5
ffffffffc0201724:	d3060613          	addi	a2,a2,-720 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201728:	13a00593          	li	a1,314
ffffffffc020172c:	00005517          	auipc	a0,0x5
ffffffffc0201730:	d3c50513          	addi	a0,a0,-708 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201734:	d5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201738:	00005697          	auipc	a3,0x5
ffffffffc020173c:	e9068693          	addi	a3,a3,-368 # ffffffffc02065c8 <commands+0xa38>
ffffffffc0201740:	00005617          	auipc	a2,0x5
ffffffffc0201744:	d1060613          	addi	a2,a2,-752 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201748:	13800593          	li	a1,312
ffffffffc020174c:	00005517          	auipc	a0,0x5
ffffffffc0201750:	d1c50513          	addi	a0,a0,-740 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201754:	d3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201758:	00005697          	auipc	a3,0x5
ffffffffc020175c:	e3068693          	addi	a3,a3,-464 # ffffffffc0206588 <commands+0x9f8>
ffffffffc0201760:	00005617          	auipc	a2,0x5
ffffffffc0201764:	cf060613          	addi	a2,a2,-784 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201768:	0df00593          	li	a1,223
ffffffffc020176c:	00005517          	auipc	a0,0x5
ffffffffc0201770:	cfc50513          	addi	a0,a0,-772 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201774:	d1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201778:	00005697          	auipc	a3,0x5
ffffffffc020177c:	fd068693          	addi	a3,a3,-48 # ffffffffc0206748 <commands+0xbb8>
ffffffffc0201780:	00005617          	auipc	a2,0x5
ffffffffc0201784:	cd060613          	addi	a2,a2,-816 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201788:	13200593          	li	a1,306
ffffffffc020178c:	00005517          	auipc	a0,0x5
ffffffffc0201790:	cdc50513          	addi	a0,a0,-804 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201794:	cfbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201798:	00005697          	auipc	a3,0x5
ffffffffc020179c:	f9068693          	addi	a3,a3,-112 # ffffffffc0206728 <commands+0xb98>
ffffffffc02017a0:	00005617          	auipc	a2,0x5
ffffffffc02017a4:	cb060613          	addi	a2,a2,-848 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02017a8:	13000593          	li	a1,304
ffffffffc02017ac:	00005517          	auipc	a0,0x5
ffffffffc02017b0:	cbc50513          	addi	a0,a0,-836 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02017b4:	cdbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02017b8:	00005697          	auipc	a3,0x5
ffffffffc02017bc:	f4868693          	addi	a3,a3,-184 # ffffffffc0206700 <commands+0xb70>
ffffffffc02017c0:	00005617          	auipc	a2,0x5
ffffffffc02017c4:	c9060613          	addi	a2,a2,-880 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02017c8:	12e00593          	li	a1,302
ffffffffc02017cc:	00005517          	auipc	a0,0x5
ffffffffc02017d0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02017d4:	cbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02017d8:	00005697          	auipc	a3,0x5
ffffffffc02017dc:	f0068693          	addi	a3,a3,-256 # ffffffffc02066d8 <commands+0xb48>
ffffffffc02017e0:	00005617          	auipc	a2,0x5
ffffffffc02017e4:	c7060613          	addi	a2,a2,-912 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02017e8:	12d00593          	li	a1,301
ffffffffc02017ec:	00005517          	auipc	a0,0x5
ffffffffc02017f0:	c7c50513          	addi	a0,a0,-900 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02017f4:	c9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02017f8:	00005697          	auipc	a3,0x5
ffffffffc02017fc:	ed068693          	addi	a3,a3,-304 # ffffffffc02066c8 <commands+0xb38>
ffffffffc0201800:	00005617          	auipc	a2,0x5
ffffffffc0201804:	c5060613          	addi	a2,a2,-944 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201808:	12800593          	li	a1,296
ffffffffc020180c:	00005517          	auipc	a0,0x5
ffffffffc0201810:	c5c50513          	addi	a0,a0,-932 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201814:	c7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201818:	00005697          	auipc	a3,0x5
ffffffffc020181c:	db068693          	addi	a3,a3,-592 # ffffffffc02065c8 <commands+0xa38>
ffffffffc0201820:	00005617          	auipc	a2,0x5
ffffffffc0201824:	c3060613          	addi	a2,a2,-976 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201828:	12700593          	li	a1,295
ffffffffc020182c:	00005517          	auipc	a0,0x5
ffffffffc0201830:	c3c50513          	addi	a0,a0,-964 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201834:	c5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201838:	00005697          	auipc	a3,0x5
ffffffffc020183c:	e7068693          	addi	a3,a3,-400 # ffffffffc02066a8 <commands+0xb18>
ffffffffc0201840:	00005617          	auipc	a2,0x5
ffffffffc0201844:	c1060613          	addi	a2,a2,-1008 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201848:	12600593          	li	a1,294
ffffffffc020184c:	00005517          	auipc	a0,0x5
ffffffffc0201850:	c1c50513          	addi	a0,a0,-996 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201854:	c3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201858:	00005697          	auipc	a3,0x5
ffffffffc020185c:	e2068693          	addi	a3,a3,-480 # ffffffffc0206678 <commands+0xae8>
ffffffffc0201860:	00005617          	auipc	a2,0x5
ffffffffc0201864:	bf060613          	addi	a2,a2,-1040 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201868:	12500593          	li	a1,293
ffffffffc020186c:	00005517          	auipc	a0,0x5
ffffffffc0201870:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201874:	c1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201878:	00005697          	auipc	a3,0x5
ffffffffc020187c:	de868693          	addi	a3,a3,-536 # ffffffffc0206660 <commands+0xad0>
ffffffffc0201880:	00005617          	auipc	a2,0x5
ffffffffc0201884:	bd060613          	addi	a2,a2,-1072 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201888:	12400593          	li	a1,292
ffffffffc020188c:	00005517          	auipc	a0,0x5
ffffffffc0201890:	bdc50513          	addi	a0,a0,-1060 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201894:	bfbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201898:	00005697          	auipc	a3,0x5
ffffffffc020189c:	d3068693          	addi	a3,a3,-720 # ffffffffc02065c8 <commands+0xa38>
ffffffffc02018a0:	00005617          	auipc	a2,0x5
ffffffffc02018a4:	bb060613          	addi	a2,a2,-1104 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02018a8:	11e00593          	li	a1,286
ffffffffc02018ac:	00005517          	auipc	a0,0x5
ffffffffc02018b0:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02018b4:	bdbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02018b8:	00005697          	auipc	a3,0x5
ffffffffc02018bc:	d9068693          	addi	a3,a3,-624 # ffffffffc0206648 <commands+0xab8>
ffffffffc02018c0:	00005617          	auipc	a2,0x5
ffffffffc02018c4:	b9060613          	addi	a2,a2,-1136 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02018c8:	11900593          	li	a1,281
ffffffffc02018cc:	00005517          	auipc	a0,0x5
ffffffffc02018d0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02018d4:	bbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02018d8:	00005697          	auipc	a3,0x5
ffffffffc02018dc:	e9068693          	addi	a3,a3,-368 # ffffffffc0206768 <commands+0xbd8>
ffffffffc02018e0:	00005617          	auipc	a2,0x5
ffffffffc02018e4:	b7060613          	addi	a2,a2,-1168 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02018e8:	13700593          	li	a1,311
ffffffffc02018ec:	00005517          	auipc	a0,0x5
ffffffffc02018f0:	b7c50513          	addi	a0,a0,-1156 # ffffffffc0206468 <commands+0x8d8>
ffffffffc02018f4:	b9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc02018f8:	00005697          	auipc	a3,0x5
ffffffffc02018fc:	ea068693          	addi	a3,a3,-352 # ffffffffc0206798 <commands+0xc08>
ffffffffc0201900:	00005617          	auipc	a2,0x5
ffffffffc0201904:	b5060613          	addi	a2,a2,-1200 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201908:	14700593          	li	a1,327
ffffffffc020190c:	00005517          	auipc	a0,0x5
ffffffffc0201910:	b5c50513          	addi	a0,a0,-1188 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201914:	b7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201918:	00005697          	auipc	a3,0x5
ffffffffc020191c:	b6868693          	addi	a3,a3,-1176 # ffffffffc0206480 <commands+0x8f0>
ffffffffc0201920:	00005617          	auipc	a2,0x5
ffffffffc0201924:	b3060613          	addi	a2,a2,-1232 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201928:	11300593          	li	a1,275
ffffffffc020192c:	00005517          	auipc	a0,0x5
ffffffffc0201930:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201934:	b5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201938:	00005697          	auipc	a3,0x5
ffffffffc020193c:	b8868693          	addi	a3,a3,-1144 # ffffffffc02064c0 <commands+0x930>
ffffffffc0201940:	00005617          	auipc	a2,0x5
ffffffffc0201944:	b1060613          	addi	a2,a2,-1264 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201948:	0d800593          	li	a1,216
ffffffffc020194c:	00005517          	auipc	a0,0x5
ffffffffc0201950:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201954:	b3bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201958 <default_free_pages>:
{
ffffffffc0201958:	1141                	addi	sp,sp,-16
ffffffffc020195a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020195c:	14058463          	beqz	a1,ffffffffc0201aa4 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201960:	00659693          	slli	a3,a1,0x6
ffffffffc0201964:	96aa                	add	a3,a3,a0
ffffffffc0201966:	87aa                	mv	a5,a0
ffffffffc0201968:	02d50263          	beq	a0,a3,ffffffffc020198c <default_free_pages+0x34>
ffffffffc020196c:	6798                	ld	a4,8(a5)
ffffffffc020196e:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201970:	10071a63          	bnez	a4,ffffffffc0201a84 <default_free_pages+0x12c>
ffffffffc0201974:	6798                	ld	a4,8(a5)
ffffffffc0201976:	8b09                	andi	a4,a4,2
ffffffffc0201978:	10071663          	bnez	a4,ffffffffc0201a84 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020197c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201980:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201984:	04078793          	addi	a5,a5,64
ffffffffc0201988:	fed792e3          	bne	a5,a3,ffffffffc020196c <default_free_pages+0x14>
    base->property = n;
ffffffffc020198c:	2581                	sext.w	a1,a1
ffffffffc020198e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201990:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201994:	4789                	li	a5,2
ffffffffc0201996:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020199a:	000ce697          	auipc	a3,0xce
ffffffffc020199e:	8d668693          	addi	a3,a3,-1834 # ffffffffc02cf270 <free_area>
ffffffffc02019a2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019a4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019a6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019aa:	9db9                	addw	a1,a1,a4
ffffffffc02019ac:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019ae:	0ad78463          	beq	a5,a3,ffffffffc0201a56 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02019b2:	fe878713          	addi	a4,a5,-24
ffffffffc02019b6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019ba:	4581                	li	a1,0
            if (base < page)
ffffffffc02019bc:	00e56a63          	bltu	a0,a4,ffffffffc02019d0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02019c0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019c2:	04d70c63          	beq	a4,a3,ffffffffc0201a1a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02019c6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019c8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019cc:	fee57ae3          	bgeu	a0,a4,ffffffffc02019c0 <default_free_pages+0x68>
ffffffffc02019d0:	c199                	beqz	a1,ffffffffc02019d6 <default_free_pages+0x7e>
ffffffffc02019d2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02019d6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02019d8:	e390                	sd	a2,0(a5)
ffffffffc02019da:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02019dc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019de:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02019e0:	00d70d63          	beq	a4,a3,ffffffffc02019fa <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02019e4:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02019e8:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02019ec:	02059813          	slli	a6,a1,0x20
ffffffffc02019f0:	01a85793          	srli	a5,a6,0x1a
ffffffffc02019f4:	97b2                	add	a5,a5,a2
ffffffffc02019f6:	02f50c63          	beq	a0,a5,ffffffffc0201a2e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02019fa:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02019fc:	00d78c63          	beq	a5,a3,ffffffffc0201a14 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201a00:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201a02:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201a06:	02061593          	slli	a1,a2,0x20
ffffffffc0201a0a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201a0e:	972a                	add	a4,a4,a0
ffffffffc0201a10:	04e68a63          	beq	a3,a4,ffffffffc0201a64 <default_free_pages+0x10c>
}
ffffffffc0201a14:	60a2                	ld	ra,8(sp)
ffffffffc0201a16:	0141                	addi	sp,sp,16
ffffffffc0201a18:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a1a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a1c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a1e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a20:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a22:	02d70763          	beq	a4,a3,ffffffffc0201a50 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201a26:	8832                	mv	a6,a2
ffffffffc0201a28:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a2a:	87ba                	mv	a5,a4
ffffffffc0201a2c:	bf71                	j	ffffffffc02019c8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201a2e:	491c                	lw	a5,16(a0)
ffffffffc0201a30:	9dbd                	addw	a1,a1,a5
ffffffffc0201a32:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201a36:	57f5                	li	a5,-3
ffffffffc0201a38:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201a3c:	01853803          	ld	a6,24(a0)
ffffffffc0201a40:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201a42:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201a44:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201a48:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201a4a:	0105b023          	sd	a6,0(a1)
ffffffffc0201a4e:	b77d                	j	ffffffffc02019fc <default_free_pages+0xa4>
ffffffffc0201a50:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a52:	873e                	mv	a4,a5
ffffffffc0201a54:	bf41                	j	ffffffffc02019e4 <default_free_pages+0x8c>
}
ffffffffc0201a56:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a58:	e390                	sd	a2,0(a5)
ffffffffc0201a5a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a5c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a5e:	ed1c                	sd	a5,24(a0)
ffffffffc0201a60:	0141                	addi	sp,sp,16
ffffffffc0201a62:	8082                	ret
            base->property += p->property;
ffffffffc0201a64:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201a68:	ff078693          	addi	a3,a5,-16
ffffffffc0201a6c:	9e39                	addw	a2,a2,a4
ffffffffc0201a6e:	c910                	sw	a2,16(a0)
ffffffffc0201a70:	5775                	li	a4,-3
ffffffffc0201a72:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201a76:	6398                	ld	a4,0(a5)
ffffffffc0201a78:	679c                	ld	a5,8(a5)
}
ffffffffc0201a7a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201a7c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201a7e:	e398                	sd	a4,0(a5)
ffffffffc0201a80:	0141                	addi	sp,sp,16
ffffffffc0201a82:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201a84:	00005697          	auipc	a3,0x5
ffffffffc0201a88:	d2c68693          	addi	a3,a3,-724 # ffffffffc02067b0 <commands+0xc20>
ffffffffc0201a8c:	00005617          	auipc	a2,0x5
ffffffffc0201a90:	9c460613          	addi	a2,a2,-1596 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201a94:	09400593          	li	a1,148
ffffffffc0201a98:	00005517          	auipc	a0,0x5
ffffffffc0201a9c:	9d050513          	addi	a0,a0,-1584 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201aa0:	9effe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201aa4:	00005697          	auipc	a3,0x5
ffffffffc0201aa8:	d0468693          	addi	a3,a3,-764 # ffffffffc02067a8 <commands+0xc18>
ffffffffc0201aac:	00005617          	auipc	a2,0x5
ffffffffc0201ab0:	9a460613          	addi	a2,a2,-1628 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201ab4:	09000593          	li	a1,144
ffffffffc0201ab8:	00005517          	auipc	a0,0x5
ffffffffc0201abc:	9b050513          	addi	a0,a0,-1616 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201ac0:	9cffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ac4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201ac4:	c941                	beqz	a0,ffffffffc0201b54 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201ac6:	000cd597          	auipc	a1,0xcd
ffffffffc0201aca:	7aa58593          	addi	a1,a1,1962 # ffffffffc02cf270 <free_area>
ffffffffc0201ace:	0105a803          	lw	a6,16(a1)
ffffffffc0201ad2:	872a                	mv	a4,a0
ffffffffc0201ad4:	02081793          	slli	a5,a6,0x20
ffffffffc0201ad8:	9381                	srli	a5,a5,0x20
ffffffffc0201ada:	00a7ee63          	bltu	a5,a0,ffffffffc0201af6 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201ade:	87ae                	mv	a5,a1
ffffffffc0201ae0:	a801                	j	ffffffffc0201af0 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201ae2:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201ae6:	02069613          	slli	a2,a3,0x20
ffffffffc0201aea:	9201                	srli	a2,a2,0x20
ffffffffc0201aec:	00e67763          	bgeu	a2,a4,ffffffffc0201afa <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201af0:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201af2:	feb798e3          	bne	a5,a1,ffffffffc0201ae2 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201af6:	4501                	li	a0,0
}
ffffffffc0201af8:	8082                	ret
    return listelm->prev;
ffffffffc0201afa:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201afe:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201b02:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201b06:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201b0a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201b0e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201b12:	02c77863          	bgeu	a4,a2,ffffffffc0201b42 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201b16:	071a                	slli	a4,a4,0x6
ffffffffc0201b18:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201b1a:	41c686bb          	subw	a3,a3,t3
ffffffffc0201b1e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201b20:	00870613          	addi	a2,a4,8
ffffffffc0201b24:	4689                	li	a3,2
ffffffffc0201b26:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201b2a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201b2e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201b32:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201b36:	e290                	sd	a2,0(a3)
ffffffffc0201b38:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201b3c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201b3e:	01173c23          	sd	a7,24(a4)
ffffffffc0201b42:	41c8083b          	subw	a6,a6,t3
ffffffffc0201b46:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201b4a:	5775                	li	a4,-3
ffffffffc0201b4c:	17c1                	addi	a5,a5,-16
ffffffffc0201b4e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201b52:	8082                	ret
{
ffffffffc0201b54:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201b56:	00005697          	auipc	a3,0x5
ffffffffc0201b5a:	c5268693          	addi	a3,a3,-942 # ffffffffc02067a8 <commands+0xc18>
ffffffffc0201b5e:	00005617          	auipc	a2,0x5
ffffffffc0201b62:	8f260613          	addi	a2,a2,-1806 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201b66:	06c00593          	li	a1,108
ffffffffc0201b6a:	00005517          	auipc	a0,0x5
ffffffffc0201b6e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0206468 <commands+0x8d8>
{
ffffffffc0201b72:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201b74:	91bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b78 <default_init_memmap>:
{
ffffffffc0201b78:	1141                	addi	sp,sp,-16
ffffffffc0201b7a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201b7c:	c5f1                	beqz	a1,ffffffffc0201c48 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201b7e:	00659693          	slli	a3,a1,0x6
ffffffffc0201b82:	96aa                	add	a3,a3,a0
ffffffffc0201b84:	87aa                	mv	a5,a0
ffffffffc0201b86:	00d50f63          	beq	a0,a3,ffffffffc0201ba4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201b8a:	6798                	ld	a4,8(a5)
ffffffffc0201b8c:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201b8e:	cf49                	beqz	a4,ffffffffc0201c28 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201b90:	0007a823          	sw	zero,16(a5)
ffffffffc0201b94:	0007b423          	sd	zero,8(a5)
ffffffffc0201b98:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201b9c:	04078793          	addi	a5,a5,64
ffffffffc0201ba0:	fed795e3          	bne	a5,a3,ffffffffc0201b8a <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201ba4:	2581                	sext.w	a1,a1
ffffffffc0201ba6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201ba8:	4789                	li	a5,2
ffffffffc0201baa:	00850713          	addi	a4,a0,8
ffffffffc0201bae:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201bb2:	000cd697          	auipc	a3,0xcd
ffffffffc0201bb6:	6be68693          	addi	a3,a3,1726 # ffffffffc02cf270 <free_area>
ffffffffc0201bba:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201bbc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201bbe:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201bc2:	9db9                	addw	a1,a1,a4
ffffffffc0201bc4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201bc6:	04d78a63          	beq	a5,a3,ffffffffc0201c1a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201bca:	fe878713          	addi	a4,a5,-24
ffffffffc0201bce:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201bd2:	4581                	li	a1,0
            if (base < page)
ffffffffc0201bd4:	00e56a63          	bltu	a0,a4,ffffffffc0201be8 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201bd8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201bda:	02d70263          	beq	a4,a3,ffffffffc0201bfe <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201bde:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201be0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201be4:	fee57ae3          	bgeu	a0,a4,ffffffffc0201bd8 <default_init_memmap+0x60>
ffffffffc0201be8:	c199                	beqz	a1,ffffffffc0201bee <default_init_memmap+0x76>
ffffffffc0201bea:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201bee:	6398                	ld	a4,0(a5)
}
ffffffffc0201bf0:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201bf2:	e390                	sd	a2,0(a5)
ffffffffc0201bf4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201bf6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201bf8:	ed18                	sd	a4,24(a0)
ffffffffc0201bfa:	0141                	addi	sp,sp,16
ffffffffc0201bfc:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201bfe:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201c00:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201c02:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201c04:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201c06:	00d70663          	beq	a4,a3,ffffffffc0201c12 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201c0a:	8832                	mv	a6,a2
ffffffffc0201c0c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201c0e:	87ba                	mv	a5,a4
ffffffffc0201c10:	bfc1                	j	ffffffffc0201be0 <default_init_memmap+0x68>
}
ffffffffc0201c12:	60a2                	ld	ra,8(sp)
ffffffffc0201c14:	e290                	sd	a2,0(a3)
ffffffffc0201c16:	0141                	addi	sp,sp,16
ffffffffc0201c18:	8082                	ret
ffffffffc0201c1a:	60a2                	ld	ra,8(sp)
ffffffffc0201c1c:	e390                	sd	a2,0(a5)
ffffffffc0201c1e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201c20:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201c22:	ed1c                	sd	a5,24(a0)
ffffffffc0201c24:	0141                	addi	sp,sp,16
ffffffffc0201c26:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201c28:	00005697          	auipc	a3,0x5
ffffffffc0201c2c:	bb068693          	addi	a3,a3,-1104 # ffffffffc02067d8 <commands+0xc48>
ffffffffc0201c30:	00005617          	auipc	a2,0x5
ffffffffc0201c34:	82060613          	addi	a2,a2,-2016 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201c38:	04b00593          	li	a1,75
ffffffffc0201c3c:	00005517          	auipc	a0,0x5
ffffffffc0201c40:	82c50513          	addi	a0,a0,-2004 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201c44:	84bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201c48:	00005697          	auipc	a3,0x5
ffffffffc0201c4c:	b6068693          	addi	a3,a3,-1184 # ffffffffc02067a8 <commands+0xc18>
ffffffffc0201c50:	00005617          	auipc	a2,0x5
ffffffffc0201c54:	80060613          	addi	a2,a2,-2048 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201c58:	04700593          	li	a1,71
ffffffffc0201c5c:	00005517          	auipc	a0,0x5
ffffffffc0201c60:	80c50513          	addi	a0,a0,-2036 # ffffffffc0206468 <commands+0x8d8>
ffffffffc0201c64:	82bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c68 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201c68:	c94d                	beqz	a0,ffffffffc0201d1a <slob_free+0xb2>
{
ffffffffc0201c6a:	1141                	addi	sp,sp,-16
ffffffffc0201c6c:	e022                	sd	s0,0(sp)
ffffffffc0201c6e:	e406                	sd	ra,8(sp)
ffffffffc0201c70:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201c72:	e9c1                	bnez	a1,ffffffffc0201d02 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c74:	100027f3          	csrr	a5,sstatus
ffffffffc0201c78:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201c7a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c7c:	ebd9                	bnez	a5,ffffffffc0201d12 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201c7e:	000cd617          	auipc	a2,0xcd
ffffffffc0201c82:	1e260613          	addi	a2,a2,482 # ffffffffc02cee60 <slobfree>
ffffffffc0201c86:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c88:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201c8a:	679c                	ld	a5,8(a5)
ffffffffc0201c8c:	02877a63          	bgeu	a4,s0,ffffffffc0201cc0 <slob_free+0x58>
ffffffffc0201c90:	00f46463          	bltu	s0,a5,ffffffffc0201c98 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c94:	fef76ae3          	bltu	a4,a5,ffffffffc0201c88 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201c98:	400c                	lw	a1,0(s0)
ffffffffc0201c9a:	00459693          	slli	a3,a1,0x4
ffffffffc0201c9e:	96a2                	add	a3,a3,s0
ffffffffc0201ca0:	02d78a63          	beq	a5,a3,ffffffffc0201cd4 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ca4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201ca6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ca8:	00469793          	slli	a5,a3,0x4
ffffffffc0201cac:	97ba                	add	a5,a5,a4
ffffffffc0201cae:	02f40e63          	beq	s0,a5,ffffffffc0201cea <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201cb2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201cb4:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201cb6:	e129                	bnez	a0,ffffffffc0201cf8 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201cb8:	60a2                	ld	ra,8(sp)
ffffffffc0201cba:	6402                	ld	s0,0(sp)
ffffffffc0201cbc:	0141                	addi	sp,sp,16
ffffffffc0201cbe:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201cc0:	fcf764e3          	bltu	a4,a5,ffffffffc0201c88 <slob_free+0x20>
ffffffffc0201cc4:	fcf472e3          	bgeu	s0,a5,ffffffffc0201c88 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201cc8:	400c                	lw	a1,0(s0)
ffffffffc0201cca:	00459693          	slli	a3,a1,0x4
ffffffffc0201cce:	96a2                	add	a3,a3,s0
ffffffffc0201cd0:	fcd79ae3          	bne	a5,a3,ffffffffc0201ca4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201cd4:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201cd6:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201cd8:	9db5                	addw	a1,a1,a3
ffffffffc0201cda:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201cdc:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201cde:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ce0:	00469793          	slli	a5,a3,0x4
ffffffffc0201ce4:	97ba                	add	a5,a5,a4
ffffffffc0201ce6:	fcf416e3          	bne	s0,a5,ffffffffc0201cb2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201cea:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201cec:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201cee:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201cf0:	9ebd                	addw	a3,a3,a5
ffffffffc0201cf2:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201cf4:	e70c                	sd	a1,8(a4)
ffffffffc0201cf6:	d169                	beqz	a0,ffffffffc0201cb8 <slob_free+0x50>
}
ffffffffc0201cf8:	6402                	ld	s0,0(sp)
ffffffffc0201cfa:	60a2                	ld	ra,8(sp)
ffffffffc0201cfc:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201cfe:	cb1fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201d02:	25bd                	addiw	a1,a1,15
ffffffffc0201d04:	8191                	srli	a1,a1,0x4
ffffffffc0201d06:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d08:	100027f3          	csrr	a5,sstatus
ffffffffc0201d0c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201d0e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d10:	d7bd                	beqz	a5,ffffffffc0201c7e <slob_free+0x16>
        intr_disable();
ffffffffc0201d12:	ca3fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201d16:	4505                	li	a0,1
ffffffffc0201d18:	b79d                	j	ffffffffc0201c7e <slob_free+0x16>
ffffffffc0201d1a:	8082                	ret

ffffffffc0201d1c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201d1c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201d1e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201d20:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201d24:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201d26:	352000ef          	jal	ra,ffffffffc0202078 <alloc_pages>
	if (!page)
ffffffffc0201d2a:	c91d                	beqz	a0,ffffffffc0201d60 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201d2c:	000d1697          	auipc	a3,0xd1
ffffffffc0201d30:	5bc6b683          	ld	a3,1468(a3) # ffffffffc02d32e8 <pages>
ffffffffc0201d34:	8d15                	sub	a0,a0,a3
ffffffffc0201d36:	8519                	srai	a0,a0,0x6
ffffffffc0201d38:	00006697          	auipc	a3,0x6
ffffffffc0201d3c:	d586b683          	ld	a3,-680(a3) # ffffffffc0207a90 <nbase>
ffffffffc0201d40:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201d42:	00c51793          	slli	a5,a0,0xc
ffffffffc0201d46:	83b1                	srli	a5,a5,0xc
ffffffffc0201d48:	000d1717          	auipc	a4,0xd1
ffffffffc0201d4c:	59873703          	ld	a4,1432(a4) # ffffffffc02d32e0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201d50:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201d52:	00e7fa63          	bgeu	a5,a4,ffffffffc0201d66 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201d56:	000d1697          	auipc	a3,0xd1
ffffffffc0201d5a:	5a26b683          	ld	a3,1442(a3) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0201d5e:	9536                	add	a0,a0,a3
}
ffffffffc0201d60:	60a2                	ld	ra,8(sp)
ffffffffc0201d62:	0141                	addi	sp,sp,16
ffffffffc0201d64:	8082                	ret
ffffffffc0201d66:	86aa                	mv	a3,a0
ffffffffc0201d68:	00004617          	auipc	a2,0x4
ffffffffc0201d6c:	65860613          	addi	a2,a2,1624 # ffffffffc02063c0 <commands+0x830>
ffffffffc0201d70:	07100593          	li	a1,113
ffffffffc0201d74:	00004517          	auipc	a0,0x4
ffffffffc0201d78:	60450513          	addi	a0,a0,1540 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0201d7c:	f12fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d80 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201d80:	1101                	addi	sp,sp,-32
ffffffffc0201d82:	ec06                	sd	ra,24(sp)
ffffffffc0201d84:	e822                	sd	s0,16(sp)
ffffffffc0201d86:	e426                	sd	s1,8(sp)
ffffffffc0201d88:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d8a:	01050713          	addi	a4,a0,16
ffffffffc0201d8e:	6785                	lui	a5,0x1
ffffffffc0201d90:	0cf77363          	bgeu	a4,a5,ffffffffc0201e56 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201d94:	00f50493          	addi	s1,a0,15
ffffffffc0201d98:	8091                	srli	s1,s1,0x4
ffffffffc0201d9a:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d9c:	10002673          	csrr	a2,sstatus
ffffffffc0201da0:	8a09                	andi	a2,a2,2
ffffffffc0201da2:	e25d                	bnez	a2,ffffffffc0201e48 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201da4:	000cd917          	auipc	s2,0xcd
ffffffffc0201da8:	0bc90913          	addi	s2,s2,188 # ffffffffc02cee60 <slobfree>
ffffffffc0201dac:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201db0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201db2:	4398                	lw	a4,0(a5)
ffffffffc0201db4:	08975e63          	bge	a4,s1,ffffffffc0201e50 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201db8:	00f68b63          	beq	a3,a5,ffffffffc0201dce <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201dbc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201dbe:	4018                	lw	a4,0(s0)
ffffffffc0201dc0:	02975a63          	bge	a4,s1,ffffffffc0201df4 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201dc4:	00093683          	ld	a3,0(s2)
ffffffffc0201dc8:	87a2                	mv	a5,s0
ffffffffc0201dca:	fef699e3          	bne	a3,a5,ffffffffc0201dbc <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201dce:	ee31                	bnez	a2,ffffffffc0201e2a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201dd0:	4501                	li	a0,0
ffffffffc0201dd2:	f4bff0ef          	jal	ra,ffffffffc0201d1c <__slob_get_free_pages.constprop.0>
ffffffffc0201dd6:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201dd8:	cd05                	beqz	a0,ffffffffc0201e10 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201dda:	6585                	lui	a1,0x1
ffffffffc0201ddc:	e8dff0ef          	jal	ra,ffffffffc0201c68 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201de0:	10002673          	csrr	a2,sstatus
ffffffffc0201de4:	8a09                	andi	a2,a2,2
ffffffffc0201de6:	ee05                	bnez	a2,ffffffffc0201e1e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201de8:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201dec:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201dee:	4018                	lw	a4,0(s0)
ffffffffc0201df0:	fc974ae3          	blt	a4,s1,ffffffffc0201dc4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201df4:	04e48763          	beq	s1,a4,ffffffffc0201e42 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201df8:	00449693          	slli	a3,s1,0x4
ffffffffc0201dfc:	96a2                	add	a3,a3,s0
ffffffffc0201dfe:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201e00:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201e02:	9f05                	subw	a4,a4,s1
ffffffffc0201e04:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201e06:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201e08:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201e0a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201e0e:	e20d                	bnez	a2,ffffffffc0201e30 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201e10:	60e2                	ld	ra,24(sp)
ffffffffc0201e12:	8522                	mv	a0,s0
ffffffffc0201e14:	6442                	ld	s0,16(sp)
ffffffffc0201e16:	64a2                	ld	s1,8(sp)
ffffffffc0201e18:	6902                	ld	s2,0(sp)
ffffffffc0201e1a:	6105                	addi	sp,sp,32
ffffffffc0201e1c:	8082                	ret
        intr_disable();
ffffffffc0201e1e:	b97fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201e22:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201e26:	4605                	li	a2,1
ffffffffc0201e28:	b7d1                	j	ffffffffc0201dec <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201e2a:	b85fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e2e:	b74d                	j	ffffffffc0201dd0 <slob_alloc.constprop.0+0x50>
ffffffffc0201e30:	b7ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201e34:	60e2                	ld	ra,24(sp)
ffffffffc0201e36:	8522                	mv	a0,s0
ffffffffc0201e38:	6442                	ld	s0,16(sp)
ffffffffc0201e3a:	64a2                	ld	s1,8(sp)
ffffffffc0201e3c:	6902                	ld	s2,0(sp)
ffffffffc0201e3e:	6105                	addi	sp,sp,32
ffffffffc0201e40:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201e42:	6418                	ld	a4,8(s0)
ffffffffc0201e44:	e798                	sd	a4,8(a5)
ffffffffc0201e46:	b7d1                	j	ffffffffc0201e0a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201e48:	b6dfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201e4c:	4605                	li	a2,1
ffffffffc0201e4e:	bf99                	j	ffffffffc0201da4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201e50:	843e                	mv	s0,a5
ffffffffc0201e52:	87b6                	mv	a5,a3
ffffffffc0201e54:	b745                	j	ffffffffc0201df4 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201e56:	00005697          	auipc	a3,0x5
ffffffffc0201e5a:	9e268693          	addi	a3,a3,-1566 # ffffffffc0206838 <default_pmm_manager+0x38>
ffffffffc0201e5e:	00004617          	auipc	a2,0x4
ffffffffc0201e62:	5f260613          	addi	a2,a2,1522 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0201e66:	06300593          	li	a1,99
ffffffffc0201e6a:	00005517          	auipc	a0,0x5
ffffffffc0201e6e:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0206858 <default_pmm_manager+0x58>
ffffffffc0201e72:	e1cfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e76 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201e76:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201e78:	00005517          	auipc	a0,0x5
ffffffffc0201e7c:	9f850513          	addi	a0,a0,-1544 # ffffffffc0206870 <default_pmm_manager+0x70>
{
ffffffffc0201e80:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201e82:	b12fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201e86:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201e88:	00005517          	auipc	a0,0x5
ffffffffc0201e8c:	a0050513          	addi	a0,a0,-1536 # ffffffffc0206888 <default_pmm_manager+0x88>
}
ffffffffc0201e90:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201e92:	b02fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201e96 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201e96:	4501                	li	a0,0
ffffffffc0201e98:	8082                	ret

ffffffffc0201e9a <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201e9a:	1101                	addi	sp,sp,-32
ffffffffc0201e9c:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201e9e:	6905                	lui	s2,0x1
{
ffffffffc0201ea0:	e822                	sd	s0,16(sp)
ffffffffc0201ea2:	ec06                	sd	ra,24(sp)
ffffffffc0201ea4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ea6:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc9>
{
ffffffffc0201eaa:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201eac:	04a7f963          	bgeu	a5,a0,ffffffffc0201efe <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201eb0:	4561                	li	a0,24
ffffffffc0201eb2:	ecfff0ef          	jal	ra,ffffffffc0201d80 <slob_alloc.constprop.0>
ffffffffc0201eb6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201eb8:	c929                	beqz	a0,ffffffffc0201f0a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201eba:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201ebe:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201ec0:	00f95763          	bge	s2,a5,ffffffffc0201ece <kmalloc+0x34>
ffffffffc0201ec4:	6705                	lui	a4,0x1
ffffffffc0201ec6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201ec8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201eca:	fef74ee3          	blt	a4,a5,ffffffffc0201ec6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201ece:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201ed0:	e4dff0ef          	jal	ra,ffffffffc0201d1c <__slob_get_free_pages.constprop.0>
ffffffffc0201ed4:	e488                	sd	a0,8(s1)
ffffffffc0201ed6:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201ed8:	c525                	beqz	a0,ffffffffc0201f40 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eda:	100027f3          	csrr	a5,sstatus
ffffffffc0201ede:	8b89                	andi	a5,a5,2
ffffffffc0201ee0:	ef8d                	bnez	a5,ffffffffc0201f1a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201ee2:	000d1797          	auipc	a5,0xd1
ffffffffc0201ee6:	3e678793          	addi	a5,a5,998 # ffffffffc02d32c8 <bigblocks>
ffffffffc0201eea:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201eec:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201eee:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201ef0:	60e2                	ld	ra,24(sp)
ffffffffc0201ef2:	8522                	mv	a0,s0
ffffffffc0201ef4:	6442                	ld	s0,16(sp)
ffffffffc0201ef6:	64a2                	ld	s1,8(sp)
ffffffffc0201ef8:	6902                	ld	s2,0(sp)
ffffffffc0201efa:	6105                	addi	sp,sp,32
ffffffffc0201efc:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201efe:	0541                	addi	a0,a0,16
ffffffffc0201f00:	e81ff0ef          	jal	ra,ffffffffc0201d80 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201f04:	01050413          	addi	s0,a0,16
ffffffffc0201f08:	f565                	bnez	a0,ffffffffc0201ef0 <kmalloc+0x56>
ffffffffc0201f0a:	4401                	li	s0,0
}
ffffffffc0201f0c:	60e2                	ld	ra,24(sp)
ffffffffc0201f0e:	8522                	mv	a0,s0
ffffffffc0201f10:	6442                	ld	s0,16(sp)
ffffffffc0201f12:	64a2                	ld	s1,8(sp)
ffffffffc0201f14:	6902                	ld	s2,0(sp)
ffffffffc0201f16:	6105                	addi	sp,sp,32
ffffffffc0201f18:	8082                	ret
        intr_disable();
ffffffffc0201f1a:	a9bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201f1e:	000d1797          	auipc	a5,0xd1
ffffffffc0201f22:	3aa78793          	addi	a5,a5,938 # ffffffffc02d32c8 <bigblocks>
ffffffffc0201f26:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201f28:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201f2a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201f2c:	a83fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201f30:	6480                	ld	s0,8(s1)
}
ffffffffc0201f32:	60e2                	ld	ra,24(sp)
ffffffffc0201f34:	64a2                	ld	s1,8(sp)
ffffffffc0201f36:	8522                	mv	a0,s0
ffffffffc0201f38:	6442                	ld	s0,16(sp)
ffffffffc0201f3a:	6902                	ld	s2,0(sp)
ffffffffc0201f3c:	6105                	addi	sp,sp,32
ffffffffc0201f3e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201f40:	45e1                	li	a1,24
ffffffffc0201f42:	8526                	mv	a0,s1
ffffffffc0201f44:	d25ff0ef          	jal	ra,ffffffffc0201c68 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201f48:	b765                	j	ffffffffc0201ef0 <kmalloc+0x56>

ffffffffc0201f4a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201f4a:	c169                	beqz	a0,ffffffffc020200c <kfree+0xc2>
{
ffffffffc0201f4c:	1101                	addi	sp,sp,-32
ffffffffc0201f4e:	e822                	sd	s0,16(sp)
ffffffffc0201f50:	ec06                	sd	ra,24(sp)
ffffffffc0201f52:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201f54:	03451793          	slli	a5,a0,0x34
ffffffffc0201f58:	842a                	mv	s0,a0
ffffffffc0201f5a:	e3d9                	bnez	a5,ffffffffc0201fe0 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f5c:	100027f3          	csrr	a5,sstatus
ffffffffc0201f60:	8b89                	andi	a5,a5,2
ffffffffc0201f62:	e7d9                	bnez	a5,ffffffffc0201ff0 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201f64:	000d1797          	auipc	a5,0xd1
ffffffffc0201f68:	3647b783          	ld	a5,868(a5) # ffffffffc02d32c8 <bigblocks>
    return 0;
ffffffffc0201f6c:	4601                	li	a2,0
ffffffffc0201f6e:	cbad                	beqz	a5,ffffffffc0201fe0 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201f70:	000d1697          	auipc	a3,0xd1
ffffffffc0201f74:	35868693          	addi	a3,a3,856 # ffffffffc02d32c8 <bigblocks>
ffffffffc0201f78:	a021                	j	ffffffffc0201f80 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201f7a:	01048693          	addi	a3,s1,16
ffffffffc0201f7e:	c3a5                	beqz	a5,ffffffffc0201fde <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201f80:	6798                	ld	a4,8(a5)
ffffffffc0201f82:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201f84:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201f86:	fe871ae3          	bne	a4,s0,ffffffffc0201f7a <kfree+0x30>
				*last = bb->next;
ffffffffc0201f8a:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201f8c:	ee2d                	bnez	a2,ffffffffc0202006 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201f8e:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201f92:	4098                	lw	a4,0(s1)
ffffffffc0201f94:	08f46963          	bltu	s0,a5,ffffffffc0202026 <kfree+0xdc>
ffffffffc0201f98:	000d1697          	auipc	a3,0xd1
ffffffffc0201f9c:	3606b683          	ld	a3,864(a3) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0201fa0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201fa2:	8031                	srli	s0,s0,0xc
ffffffffc0201fa4:	000d1797          	auipc	a5,0xd1
ffffffffc0201fa8:	33c7b783          	ld	a5,828(a5) # ffffffffc02d32e0 <npage>
ffffffffc0201fac:	06f47163          	bgeu	s0,a5,ffffffffc020200e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201fb0:	00006517          	auipc	a0,0x6
ffffffffc0201fb4:	ae053503          	ld	a0,-1312(a0) # ffffffffc0207a90 <nbase>
ffffffffc0201fb8:	8c09                	sub	s0,s0,a0
ffffffffc0201fba:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201fbc:	000d1517          	auipc	a0,0xd1
ffffffffc0201fc0:	32c53503          	ld	a0,812(a0) # ffffffffc02d32e8 <pages>
ffffffffc0201fc4:	4585                	li	a1,1
ffffffffc0201fc6:	9522                	add	a0,a0,s0
ffffffffc0201fc8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201fcc:	0ea000ef          	jal	ra,ffffffffc02020b6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201fd0:	6442                	ld	s0,16(sp)
ffffffffc0201fd2:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201fd4:	8526                	mv	a0,s1
}
ffffffffc0201fd6:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201fd8:	45e1                	li	a1,24
}
ffffffffc0201fda:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fdc:	b171                	j	ffffffffc0201c68 <slob_free>
ffffffffc0201fde:	e20d                	bnez	a2,ffffffffc0202000 <kfree+0xb6>
ffffffffc0201fe0:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201fe4:	6442                	ld	s0,16(sp)
ffffffffc0201fe6:	60e2                	ld	ra,24(sp)
ffffffffc0201fe8:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fea:	4581                	li	a1,0
}
ffffffffc0201fec:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fee:	b9ad                	j	ffffffffc0201c68 <slob_free>
        intr_disable();
ffffffffc0201ff0:	9c5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201ff4:	000d1797          	auipc	a5,0xd1
ffffffffc0201ff8:	2d47b783          	ld	a5,724(a5) # ffffffffc02d32c8 <bigblocks>
        return 1;
ffffffffc0201ffc:	4605                	li	a2,1
ffffffffc0201ffe:	fbad                	bnez	a5,ffffffffc0201f70 <kfree+0x26>
        intr_enable();
ffffffffc0202000:	9affe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202004:	bff1                	j	ffffffffc0201fe0 <kfree+0x96>
ffffffffc0202006:	9a9fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020200a:	b751                	j	ffffffffc0201f8e <kfree+0x44>
ffffffffc020200c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc020200e:	00004617          	auipc	a2,0x4
ffffffffc0202012:	37a60613          	addi	a2,a2,890 # ffffffffc0206388 <commands+0x7f8>
ffffffffc0202016:	06900593          	li	a1,105
ffffffffc020201a:	00004517          	auipc	a0,0x4
ffffffffc020201e:	35e50513          	addi	a0,a0,862 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0202022:	c6cfe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0202026:	86a2                	mv	a3,s0
ffffffffc0202028:	00005617          	auipc	a2,0x5
ffffffffc020202c:	88060613          	addi	a2,a2,-1920 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc0202030:	07700593          	li	a1,119
ffffffffc0202034:	00004517          	auipc	a0,0x4
ffffffffc0202038:	34450513          	addi	a0,a0,836 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020203c:	c52fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202040 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0202040:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202042:	00004617          	auipc	a2,0x4
ffffffffc0202046:	34660613          	addi	a2,a2,838 # ffffffffc0206388 <commands+0x7f8>
ffffffffc020204a:	06900593          	li	a1,105
ffffffffc020204e:	00004517          	auipc	a0,0x4
ffffffffc0202052:	32a50513          	addi	a0,a0,810 # ffffffffc0206378 <commands+0x7e8>
pa2page(uintptr_t pa)
ffffffffc0202056:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202058:	c36fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020205c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc020205c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc020205e:	00004617          	auipc	a2,0x4
ffffffffc0202062:	2f260613          	addi	a2,a2,754 # ffffffffc0206350 <commands+0x7c0>
ffffffffc0202066:	07f00593          	li	a1,127
ffffffffc020206a:	00004517          	auipc	a0,0x4
ffffffffc020206e:	30e50513          	addi	a0,a0,782 # ffffffffc0206378 <commands+0x7e8>
pte2page(pte_t pte)
ffffffffc0202072:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202074:	c1afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202078 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202078:	100027f3          	csrr	a5,sstatus
ffffffffc020207c:	8b89                	andi	a5,a5,2
ffffffffc020207e:	e799                	bnez	a5,ffffffffc020208c <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0202080:	000d1797          	auipc	a5,0xd1
ffffffffc0202084:	2707b783          	ld	a5,624(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc0202088:	6f9c                	ld	a5,24(a5)
ffffffffc020208a:	8782                	jr	a5
{
ffffffffc020208c:	1141                	addi	sp,sp,-16
ffffffffc020208e:	e406                	sd	ra,8(sp)
ffffffffc0202090:	e022                	sd	s0,0(sp)
ffffffffc0202092:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202094:	921fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202098:	000d1797          	auipc	a5,0xd1
ffffffffc020209c:	2587b783          	ld	a5,600(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02020a0:	6f9c                	ld	a5,24(a5)
ffffffffc02020a2:	8522                	mv	a0,s0
ffffffffc02020a4:	9782                	jalr	a5
ffffffffc02020a6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02020a8:	907fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02020ac:	60a2                	ld	ra,8(sp)
ffffffffc02020ae:	8522                	mv	a0,s0
ffffffffc02020b0:	6402                	ld	s0,0(sp)
ffffffffc02020b2:	0141                	addi	sp,sp,16
ffffffffc02020b4:	8082                	ret

ffffffffc02020b6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02020b6:	100027f3          	csrr	a5,sstatus
ffffffffc02020ba:	8b89                	andi	a5,a5,2
ffffffffc02020bc:	e799                	bnez	a5,ffffffffc02020ca <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02020be:	000d1797          	auipc	a5,0xd1
ffffffffc02020c2:	2327b783          	ld	a5,562(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02020c6:	739c                	ld	a5,32(a5)
ffffffffc02020c8:	8782                	jr	a5
{
ffffffffc02020ca:	1101                	addi	sp,sp,-32
ffffffffc02020cc:	ec06                	sd	ra,24(sp)
ffffffffc02020ce:	e822                	sd	s0,16(sp)
ffffffffc02020d0:	e426                	sd	s1,8(sp)
ffffffffc02020d2:	842a                	mv	s0,a0
ffffffffc02020d4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02020d6:	8dffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02020da:	000d1797          	auipc	a5,0xd1
ffffffffc02020de:	2167b783          	ld	a5,534(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02020e2:	739c                	ld	a5,32(a5)
ffffffffc02020e4:	85a6                	mv	a1,s1
ffffffffc02020e6:	8522                	mv	a0,s0
ffffffffc02020e8:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02020ea:	6442                	ld	s0,16(sp)
ffffffffc02020ec:	60e2                	ld	ra,24(sp)
ffffffffc02020ee:	64a2                	ld	s1,8(sp)
ffffffffc02020f0:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02020f2:	8bdfe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc02020f6 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02020f6:	100027f3          	csrr	a5,sstatus
ffffffffc02020fa:	8b89                	andi	a5,a5,2
ffffffffc02020fc:	e799                	bnez	a5,ffffffffc020210a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02020fe:	000d1797          	auipc	a5,0xd1
ffffffffc0202102:	1f27b783          	ld	a5,498(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc0202106:	779c                	ld	a5,40(a5)
ffffffffc0202108:	8782                	jr	a5
{
ffffffffc020210a:	1141                	addi	sp,sp,-16
ffffffffc020210c:	e406                	sd	ra,8(sp)
ffffffffc020210e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202110:	8a5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202114:	000d1797          	auipc	a5,0xd1
ffffffffc0202118:	1dc7b783          	ld	a5,476(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc020211c:	779c                	ld	a5,40(a5)
ffffffffc020211e:	9782                	jalr	a5
ffffffffc0202120:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202122:	88dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202126:	60a2                	ld	ra,8(sp)
ffffffffc0202128:	8522                	mv	a0,s0
ffffffffc020212a:	6402                	ld	s0,0(sp)
ffffffffc020212c:	0141                	addi	sp,sp,16
ffffffffc020212e:	8082                	ret

ffffffffc0202130 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202130:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202134:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0202138:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020213a:	078e                	slli	a5,a5,0x3
{
ffffffffc020213c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020213e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0202142:	6094                	ld	a3,0(s1)
{
ffffffffc0202144:	f04a                	sd	s2,32(sp)
ffffffffc0202146:	ec4e                	sd	s3,24(sp)
ffffffffc0202148:	e852                	sd	s4,16(sp)
ffffffffc020214a:	fc06                	sd	ra,56(sp)
ffffffffc020214c:	f822                	sd	s0,48(sp)
ffffffffc020214e:	e456                	sd	s5,8(sp)
ffffffffc0202150:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202152:	0016f793          	andi	a5,a3,1
{
ffffffffc0202156:	892e                	mv	s2,a1
ffffffffc0202158:	8a32                	mv	s4,a2
ffffffffc020215a:	000d1997          	auipc	s3,0xd1
ffffffffc020215e:	18698993          	addi	s3,s3,390 # ffffffffc02d32e0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0202162:	efbd                	bnez	a5,ffffffffc02021e0 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202164:	14060c63          	beqz	a2,ffffffffc02022bc <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202168:	100027f3          	csrr	a5,sstatus
ffffffffc020216c:	8b89                	andi	a5,a5,2
ffffffffc020216e:	14079963          	bnez	a5,ffffffffc02022c0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202172:	000d1797          	auipc	a5,0xd1
ffffffffc0202176:	17e7b783          	ld	a5,382(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc020217a:	6f9c                	ld	a5,24(a5)
ffffffffc020217c:	4505                	li	a0,1
ffffffffc020217e:	9782                	jalr	a5
ffffffffc0202180:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202182:	12040d63          	beqz	s0,ffffffffc02022bc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202186:	000d1b17          	auipc	s6,0xd1
ffffffffc020218a:	162b0b13          	addi	s6,s6,354 # ffffffffc02d32e8 <pages>
ffffffffc020218e:	000b3503          	ld	a0,0(s6)
ffffffffc0202192:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202196:	000d1997          	auipc	s3,0xd1
ffffffffc020219a:	14a98993          	addi	s3,s3,330 # ffffffffc02d32e0 <npage>
ffffffffc020219e:	40a40533          	sub	a0,s0,a0
ffffffffc02021a2:	8519                	srai	a0,a0,0x6
ffffffffc02021a4:	9556                	add	a0,a0,s5
ffffffffc02021a6:	0009b703          	ld	a4,0(s3)
ffffffffc02021aa:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02021ae:	4685                	li	a3,1
ffffffffc02021b0:	c014                	sw	a3,0(s0)
ffffffffc02021b2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02021b4:	0532                	slli	a0,a0,0xc
ffffffffc02021b6:	16e7f763          	bgeu	a5,a4,ffffffffc0202324 <get_pte+0x1f4>
ffffffffc02021ba:	000d1797          	auipc	a5,0xd1
ffffffffc02021be:	13e7b783          	ld	a5,318(a5) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc02021c2:	6605                	lui	a2,0x1
ffffffffc02021c4:	4581                	li	a1,0
ffffffffc02021c6:	953e                	add	a0,a0,a5
ffffffffc02021c8:	736030ef          	jal	ra,ffffffffc02058fe <memset>
    return page - pages + nbase;
ffffffffc02021cc:	000b3683          	ld	a3,0(s6)
ffffffffc02021d0:	40d406b3          	sub	a3,s0,a3
ffffffffc02021d4:	8699                	srai	a3,a3,0x6
ffffffffc02021d6:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02021d8:	06aa                	slli	a3,a3,0xa
ffffffffc02021da:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02021de:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021e0:	77fd                	lui	a5,0xfffff
ffffffffc02021e2:	068a                	slli	a3,a3,0x2
ffffffffc02021e4:	0009b703          	ld	a4,0(s3)
ffffffffc02021e8:	8efd                	and	a3,a3,a5
ffffffffc02021ea:	00c6d793          	srli	a5,a3,0xc
ffffffffc02021ee:	10e7ff63          	bgeu	a5,a4,ffffffffc020230c <get_pte+0x1dc>
ffffffffc02021f2:	000d1a97          	auipc	s5,0xd1
ffffffffc02021f6:	106a8a93          	addi	s5,s5,262 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc02021fa:	000ab403          	ld	s0,0(s5)
ffffffffc02021fe:	01595793          	srli	a5,s2,0x15
ffffffffc0202202:	1ff7f793          	andi	a5,a5,511
ffffffffc0202206:	96a2                	add	a3,a3,s0
ffffffffc0202208:	00379413          	slli	s0,a5,0x3
ffffffffc020220c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020220e:	6014                	ld	a3,0(s0)
ffffffffc0202210:	0016f793          	andi	a5,a3,1
ffffffffc0202214:	ebad                	bnez	a5,ffffffffc0202286 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202216:	0a0a0363          	beqz	s4,ffffffffc02022bc <get_pte+0x18c>
ffffffffc020221a:	100027f3          	csrr	a5,sstatus
ffffffffc020221e:	8b89                	andi	a5,a5,2
ffffffffc0202220:	efcd                	bnez	a5,ffffffffc02022da <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202222:	000d1797          	auipc	a5,0xd1
ffffffffc0202226:	0ce7b783          	ld	a5,206(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc020222a:	6f9c                	ld	a5,24(a5)
ffffffffc020222c:	4505                	li	a0,1
ffffffffc020222e:	9782                	jalr	a5
ffffffffc0202230:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202232:	c4c9                	beqz	s1,ffffffffc02022bc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202234:	000d1b17          	auipc	s6,0xd1
ffffffffc0202238:	0b4b0b13          	addi	s6,s6,180 # ffffffffc02d32e8 <pages>
ffffffffc020223c:	000b3503          	ld	a0,0(s6)
ffffffffc0202240:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202244:	0009b703          	ld	a4,0(s3)
ffffffffc0202248:	40a48533          	sub	a0,s1,a0
ffffffffc020224c:	8519                	srai	a0,a0,0x6
ffffffffc020224e:	9552                	add	a0,a0,s4
ffffffffc0202250:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202254:	4685                	li	a3,1
ffffffffc0202256:	c094                	sw	a3,0(s1)
ffffffffc0202258:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020225a:	0532                	slli	a0,a0,0xc
ffffffffc020225c:	0ee7f163          	bgeu	a5,a4,ffffffffc020233e <get_pte+0x20e>
ffffffffc0202260:	000ab783          	ld	a5,0(s5)
ffffffffc0202264:	6605                	lui	a2,0x1
ffffffffc0202266:	4581                	li	a1,0
ffffffffc0202268:	953e                	add	a0,a0,a5
ffffffffc020226a:	694030ef          	jal	ra,ffffffffc02058fe <memset>
    return page - pages + nbase;
ffffffffc020226e:	000b3683          	ld	a3,0(s6)
ffffffffc0202272:	40d486b3          	sub	a3,s1,a3
ffffffffc0202276:	8699                	srai	a3,a3,0x6
ffffffffc0202278:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020227a:	06aa                	slli	a3,a3,0xa
ffffffffc020227c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202280:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202282:	0009b703          	ld	a4,0(s3)
ffffffffc0202286:	068a                	slli	a3,a3,0x2
ffffffffc0202288:	757d                	lui	a0,0xfffff
ffffffffc020228a:	8ee9                	and	a3,a3,a0
ffffffffc020228c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202290:	06e7f263          	bgeu	a5,a4,ffffffffc02022f4 <get_pte+0x1c4>
ffffffffc0202294:	000ab503          	ld	a0,0(s5)
ffffffffc0202298:	00c95913          	srli	s2,s2,0xc
ffffffffc020229c:	1ff97913          	andi	s2,s2,511
ffffffffc02022a0:	96aa                	add	a3,a3,a0
ffffffffc02022a2:	00391513          	slli	a0,s2,0x3
ffffffffc02022a6:	9536                	add	a0,a0,a3
}
ffffffffc02022a8:	70e2                	ld	ra,56(sp)
ffffffffc02022aa:	7442                	ld	s0,48(sp)
ffffffffc02022ac:	74a2                	ld	s1,40(sp)
ffffffffc02022ae:	7902                	ld	s2,32(sp)
ffffffffc02022b0:	69e2                	ld	s3,24(sp)
ffffffffc02022b2:	6a42                	ld	s4,16(sp)
ffffffffc02022b4:	6aa2                	ld	s5,8(sp)
ffffffffc02022b6:	6b02                	ld	s6,0(sp)
ffffffffc02022b8:	6121                	addi	sp,sp,64
ffffffffc02022ba:	8082                	ret
            return NULL;
ffffffffc02022bc:	4501                	li	a0,0
ffffffffc02022be:	b7ed                	j	ffffffffc02022a8 <get_pte+0x178>
        intr_disable();
ffffffffc02022c0:	ef4fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022c4:	000d1797          	auipc	a5,0xd1
ffffffffc02022c8:	02c7b783          	ld	a5,44(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02022cc:	6f9c                	ld	a5,24(a5)
ffffffffc02022ce:	4505                	li	a0,1
ffffffffc02022d0:	9782                	jalr	a5
ffffffffc02022d2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02022d4:	edafe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022d8:	b56d                	j	ffffffffc0202182 <get_pte+0x52>
        intr_disable();
ffffffffc02022da:	edafe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022de:	000d1797          	auipc	a5,0xd1
ffffffffc02022e2:	0127b783          	ld	a5,18(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02022e6:	6f9c                	ld	a5,24(a5)
ffffffffc02022e8:	4505                	li	a0,1
ffffffffc02022ea:	9782                	jalr	a5
ffffffffc02022ec:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02022ee:	ec0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022f2:	b781                	j	ffffffffc0202232 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02022f4:	00004617          	auipc	a2,0x4
ffffffffc02022f8:	0cc60613          	addi	a2,a2,204 # ffffffffc02063c0 <commands+0x830>
ffffffffc02022fc:	0fa00593          	li	a1,250
ffffffffc0202300:	00004517          	auipc	a0,0x4
ffffffffc0202304:	5d050513          	addi	a0,a0,1488 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0202308:	986fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020230c:	00004617          	auipc	a2,0x4
ffffffffc0202310:	0b460613          	addi	a2,a2,180 # ffffffffc02063c0 <commands+0x830>
ffffffffc0202314:	0ed00593          	li	a1,237
ffffffffc0202318:	00004517          	auipc	a0,0x4
ffffffffc020231c:	5b850513          	addi	a0,a0,1464 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0202320:	96efe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202324:	86aa                	mv	a3,a0
ffffffffc0202326:	00004617          	auipc	a2,0x4
ffffffffc020232a:	09a60613          	addi	a2,a2,154 # ffffffffc02063c0 <commands+0x830>
ffffffffc020232e:	0e900593          	li	a1,233
ffffffffc0202332:	00004517          	auipc	a0,0x4
ffffffffc0202336:	59e50513          	addi	a0,a0,1438 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc020233a:	954fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020233e:	86aa                	mv	a3,a0
ffffffffc0202340:	00004617          	auipc	a2,0x4
ffffffffc0202344:	08060613          	addi	a2,a2,128 # ffffffffc02063c0 <commands+0x830>
ffffffffc0202348:	0f700593          	li	a1,247
ffffffffc020234c:	00004517          	auipc	a0,0x4
ffffffffc0202350:	58450513          	addi	a0,a0,1412 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0202354:	93afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202358 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202358:	1141                	addi	sp,sp,-16
ffffffffc020235a:	e022                	sd	s0,0(sp)
ffffffffc020235c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020235e:	4601                	li	a2,0
{
ffffffffc0202360:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202362:	dcfff0ef          	jal	ra,ffffffffc0202130 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202366:	c011                	beqz	s0,ffffffffc020236a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202368:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020236a:	c511                	beqz	a0,ffffffffc0202376 <get_page+0x1e>
ffffffffc020236c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020236e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202370:	0017f713          	andi	a4,a5,1
ffffffffc0202374:	e709                	bnez	a4,ffffffffc020237e <get_page+0x26>
}
ffffffffc0202376:	60a2                	ld	ra,8(sp)
ffffffffc0202378:	6402                	ld	s0,0(sp)
ffffffffc020237a:	0141                	addi	sp,sp,16
ffffffffc020237c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020237e:	078a                	slli	a5,a5,0x2
ffffffffc0202380:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202382:	000d1717          	auipc	a4,0xd1
ffffffffc0202386:	f5e73703          	ld	a4,-162(a4) # ffffffffc02d32e0 <npage>
ffffffffc020238a:	00e7ff63          	bgeu	a5,a4,ffffffffc02023a8 <get_page+0x50>
ffffffffc020238e:	60a2                	ld	ra,8(sp)
ffffffffc0202390:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202392:	fff80537          	lui	a0,0xfff80
ffffffffc0202396:	97aa                	add	a5,a5,a0
ffffffffc0202398:	079a                	slli	a5,a5,0x6
ffffffffc020239a:	000d1517          	auipc	a0,0xd1
ffffffffc020239e:	f4e53503          	ld	a0,-178(a0) # ffffffffc02d32e8 <pages>
ffffffffc02023a2:	953e                	add	a0,a0,a5
ffffffffc02023a4:	0141                	addi	sp,sp,16
ffffffffc02023a6:	8082                	ret
ffffffffc02023a8:	c99ff0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>

ffffffffc02023ac <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02023ac:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023ae:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02023b2:	f486                	sd	ra,104(sp)
ffffffffc02023b4:	f0a2                	sd	s0,96(sp)
ffffffffc02023b6:	eca6                	sd	s1,88(sp)
ffffffffc02023b8:	e8ca                	sd	s2,80(sp)
ffffffffc02023ba:	e4ce                	sd	s3,72(sp)
ffffffffc02023bc:	e0d2                	sd	s4,64(sp)
ffffffffc02023be:	fc56                	sd	s5,56(sp)
ffffffffc02023c0:	f85a                	sd	s6,48(sp)
ffffffffc02023c2:	f45e                	sd	s7,40(sp)
ffffffffc02023c4:	f062                	sd	s8,32(sp)
ffffffffc02023c6:	ec66                	sd	s9,24(sp)
ffffffffc02023c8:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023ca:	17d2                	slli	a5,a5,0x34
ffffffffc02023cc:	e3ed                	bnez	a5,ffffffffc02024ae <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02023ce:	002007b7          	lui	a5,0x200
ffffffffc02023d2:	842e                	mv	s0,a1
ffffffffc02023d4:	0ef5ed63          	bltu	a1,a5,ffffffffc02024ce <unmap_range+0x122>
ffffffffc02023d8:	8932                	mv	s2,a2
ffffffffc02023da:	0ec5fa63          	bgeu	a1,a2,ffffffffc02024ce <unmap_range+0x122>
ffffffffc02023de:	4785                	li	a5,1
ffffffffc02023e0:	07fe                	slli	a5,a5,0x1f
ffffffffc02023e2:	0ec7e663          	bltu	a5,a2,ffffffffc02024ce <unmap_range+0x122>
ffffffffc02023e6:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02023e8:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02023ea:	000d1c97          	auipc	s9,0xd1
ffffffffc02023ee:	ef6c8c93          	addi	s9,s9,-266 # ffffffffc02d32e0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02023f2:	000d1c17          	auipc	s8,0xd1
ffffffffc02023f6:	ef6c0c13          	addi	s8,s8,-266 # ffffffffc02d32e8 <pages>
ffffffffc02023fa:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02023fe:	000d1d17          	auipc	s10,0xd1
ffffffffc0202402:	ef2d0d13          	addi	s10,s10,-270 # ffffffffc02d32f0 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202406:	00200b37          	lui	s6,0x200
ffffffffc020240a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020240e:	4601                	li	a2,0
ffffffffc0202410:	85a2                	mv	a1,s0
ffffffffc0202412:	854e                	mv	a0,s3
ffffffffc0202414:	d1dff0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0202418:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020241a:	cd29                	beqz	a0,ffffffffc0202474 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020241c:	611c                	ld	a5,0(a0)
ffffffffc020241e:	e395                	bnez	a5,ffffffffc0202442 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202420:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202422:	ff2466e3          	bltu	s0,s2,ffffffffc020240e <unmap_range+0x62>
}
ffffffffc0202426:	70a6                	ld	ra,104(sp)
ffffffffc0202428:	7406                	ld	s0,96(sp)
ffffffffc020242a:	64e6                	ld	s1,88(sp)
ffffffffc020242c:	6946                	ld	s2,80(sp)
ffffffffc020242e:	69a6                	ld	s3,72(sp)
ffffffffc0202430:	6a06                	ld	s4,64(sp)
ffffffffc0202432:	7ae2                	ld	s5,56(sp)
ffffffffc0202434:	7b42                	ld	s6,48(sp)
ffffffffc0202436:	7ba2                	ld	s7,40(sp)
ffffffffc0202438:	7c02                	ld	s8,32(sp)
ffffffffc020243a:	6ce2                	ld	s9,24(sp)
ffffffffc020243c:	6d42                	ld	s10,16(sp)
ffffffffc020243e:	6165                	addi	sp,sp,112
ffffffffc0202440:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202442:	0017f713          	andi	a4,a5,1
ffffffffc0202446:	df69                	beqz	a4,ffffffffc0202420 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202448:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020244c:	078a                	slli	a5,a5,0x2
ffffffffc020244e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202450:	08e7ff63          	bgeu	a5,a4,ffffffffc02024ee <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202454:	000c3503          	ld	a0,0(s8)
ffffffffc0202458:	97de                	add	a5,a5,s7
ffffffffc020245a:	079a                	slli	a5,a5,0x6
ffffffffc020245c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020245e:	411c                	lw	a5,0(a0)
ffffffffc0202460:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202464:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202466:	cf11                	beqz	a4,ffffffffc0202482 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202468:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020246c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202470:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202472:	bf45                	j	ffffffffc0202422 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202474:	945a                	add	s0,s0,s6
ffffffffc0202476:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020247a:	d455                	beqz	s0,ffffffffc0202426 <unmap_range+0x7a>
ffffffffc020247c:	f92469e3          	bltu	s0,s2,ffffffffc020240e <unmap_range+0x62>
ffffffffc0202480:	b75d                	j	ffffffffc0202426 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202482:	100027f3          	csrr	a5,sstatus
ffffffffc0202486:	8b89                	andi	a5,a5,2
ffffffffc0202488:	e799                	bnez	a5,ffffffffc0202496 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc020248a:	000d3783          	ld	a5,0(s10)
ffffffffc020248e:	4585                	li	a1,1
ffffffffc0202490:	739c                	ld	a5,32(a5)
ffffffffc0202492:	9782                	jalr	a5
    if (flag)
ffffffffc0202494:	bfd1                	j	ffffffffc0202468 <unmap_range+0xbc>
ffffffffc0202496:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202498:	d1cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020249c:	000d3783          	ld	a5,0(s10)
ffffffffc02024a0:	6522                	ld	a0,8(sp)
ffffffffc02024a2:	4585                	li	a1,1
ffffffffc02024a4:	739c                	ld	a5,32(a5)
ffffffffc02024a6:	9782                	jalr	a5
        intr_enable();
ffffffffc02024a8:	d06fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02024ac:	bf75                	j	ffffffffc0202468 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024ae:	00004697          	auipc	a3,0x4
ffffffffc02024b2:	43268693          	addi	a3,a3,1074 # ffffffffc02068e0 <default_pmm_manager+0xe0>
ffffffffc02024b6:	00004617          	auipc	a2,0x4
ffffffffc02024ba:	f9a60613          	addi	a2,a2,-102 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02024be:	12000593          	li	a1,288
ffffffffc02024c2:	00004517          	auipc	a0,0x4
ffffffffc02024c6:	40e50513          	addi	a0,a0,1038 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02024ca:	fc5fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02024ce:	00004697          	auipc	a3,0x4
ffffffffc02024d2:	44268693          	addi	a3,a3,1090 # ffffffffc0206910 <default_pmm_manager+0x110>
ffffffffc02024d6:	00004617          	auipc	a2,0x4
ffffffffc02024da:	f7a60613          	addi	a2,a2,-134 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02024de:	12100593          	li	a1,289
ffffffffc02024e2:	00004517          	auipc	a0,0x4
ffffffffc02024e6:	3ee50513          	addi	a0,a0,1006 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02024ea:	fa5fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02024ee:	b53ff0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>

ffffffffc02024f2 <exit_range>:
{
ffffffffc02024f2:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024f4:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02024f8:	fc86                	sd	ra,120(sp)
ffffffffc02024fa:	f8a2                	sd	s0,112(sp)
ffffffffc02024fc:	f4a6                	sd	s1,104(sp)
ffffffffc02024fe:	f0ca                	sd	s2,96(sp)
ffffffffc0202500:	ecce                	sd	s3,88(sp)
ffffffffc0202502:	e8d2                	sd	s4,80(sp)
ffffffffc0202504:	e4d6                	sd	s5,72(sp)
ffffffffc0202506:	e0da                	sd	s6,64(sp)
ffffffffc0202508:	fc5e                	sd	s7,56(sp)
ffffffffc020250a:	f862                	sd	s8,48(sp)
ffffffffc020250c:	f466                	sd	s9,40(sp)
ffffffffc020250e:	f06a                	sd	s10,32(sp)
ffffffffc0202510:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202512:	17d2                	slli	a5,a5,0x34
ffffffffc0202514:	20079a63          	bnez	a5,ffffffffc0202728 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202518:	002007b7          	lui	a5,0x200
ffffffffc020251c:	24f5e463          	bltu	a1,a5,ffffffffc0202764 <exit_range+0x272>
ffffffffc0202520:	8ab2                	mv	s5,a2
ffffffffc0202522:	24c5f163          	bgeu	a1,a2,ffffffffc0202764 <exit_range+0x272>
ffffffffc0202526:	4785                	li	a5,1
ffffffffc0202528:	07fe                	slli	a5,a5,0x1f
ffffffffc020252a:	22c7ed63          	bltu	a5,a2,ffffffffc0202764 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020252e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202532:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202536:	ffe00937          	lui	s2,0xffe00
ffffffffc020253a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020253e:	5cfd                	li	s9,-1
ffffffffc0202540:	8c2a                	mv	s8,a0
ffffffffc0202542:	0125f933          	and	s2,a1,s2
ffffffffc0202546:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202548:	000d1d17          	auipc	s10,0xd1
ffffffffc020254c:	d98d0d13          	addi	s10,s10,-616 # ffffffffc02d32e0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202550:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202554:	000d1717          	auipc	a4,0xd1
ffffffffc0202558:	d9470713          	addi	a4,a4,-620 # ffffffffc02d32e8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc020255c:	000d1d97          	auipc	s11,0xd1
ffffffffc0202560:	d94d8d93          	addi	s11,s11,-620 # ffffffffc02d32f0 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202564:	c0000437          	lui	s0,0xc0000
ffffffffc0202568:	944e                	add	s0,s0,s3
ffffffffc020256a:	8079                	srli	s0,s0,0x1e
ffffffffc020256c:	1ff47413          	andi	s0,s0,511
ffffffffc0202570:	040e                	slli	s0,s0,0x3
ffffffffc0202572:	9462                	add	s0,s0,s8
ffffffffc0202574:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
        if (pde1 & PTE_V)
ffffffffc0202578:	001a7793          	andi	a5,s4,1
ffffffffc020257c:	eb99                	bnez	a5,ffffffffc0202592 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020257e:	12098463          	beqz	s3,ffffffffc02026a6 <exit_range+0x1b4>
ffffffffc0202582:	400007b7          	lui	a5,0x40000
ffffffffc0202586:	97ce                	add	a5,a5,s3
ffffffffc0202588:	894e                	mv	s2,s3
ffffffffc020258a:	1159fe63          	bgeu	s3,s5,ffffffffc02026a6 <exit_range+0x1b4>
ffffffffc020258e:	89be                	mv	s3,a5
ffffffffc0202590:	bfd1                	j	ffffffffc0202564 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202592:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202596:	0a0a                	slli	s4,s4,0x2
ffffffffc0202598:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc020259c:	1cfa7263          	bgeu	s4,a5,ffffffffc0202760 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02025a0:	fff80637          	lui	a2,0xfff80
ffffffffc02025a4:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02025a6:	000806b7          	lui	a3,0x80
ffffffffc02025aa:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02025ac:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02025b0:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02025b2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02025b4:	18f5fa63          	bgeu	a1,a5,ffffffffc0202748 <exit_range+0x256>
ffffffffc02025b8:	000d1817          	auipc	a6,0xd1
ffffffffc02025bc:	d4080813          	addi	a6,a6,-704 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc02025c0:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02025c4:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02025c6:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02025ca:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02025cc:	00080337          	lui	t1,0x80
ffffffffc02025d0:	6885                	lui	a7,0x1
ffffffffc02025d2:	a819                	j	ffffffffc02025e8 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02025d4:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02025d6:	002007b7          	lui	a5,0x200
ffffffffc02025da:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02025dc:	08090c63          	beqz	s2,ffffffffc0202674 <exit_range+0x182>
ffffffffc02025e0:	09397a63          	bgeu	s2,s3,ffffffffc0202674 <exit_range+0x182>
ffffffffc02025e4:	0f597063          	bgeu	s2,s5,ffffffffc02026c4 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02025e8:	01595493          	srli	s1,s2,0x15
ffffffffc02025ec:	1ff4f493          	andi	s1,s1,511
ffffffffc02025f0:	048e                	slli	s1,s1,0x3
ffffffffc02025f2:	94da                	add	s1,s1,s6
ffffffffc02025f4:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02025f6:	0017f693          	andi	a3,a5,1
ffffffffc02025fa:	dee9                	beqz	a3,ffffffffc02025d4 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02025fc:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202600:	078a                	slli	a5,a5,0x2
ffffffffc0202602:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202604:	14b7fe63          	bgeu	a5,a1,ffffffffc0202760 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202608:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020260a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020260e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202612:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202616:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202618:	12bef863          	bgeu	t4,a1,ffffffffc0202748 <exit_range+0x256>
ffffffffc020261c:	00083783          	ld	a5,0(a6)
ffffffffc0202620:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202622:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202626:	629c                	ld	a5,0(a3)
ffffffffc0202628:	8b85                	andi	a5,a5,1
ffffffffc020262a:	f7d5                	bnez	a5,ffffffffc02025d6 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020262c:	06a1                	addi	a3,a3,8
ffffffffc020262e:	fed59ce3          	bne	a1,a3,ffffffffc0202626 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202632:	631c                	ld	a5,0(a4)
ffffffffc0202634:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202636:	100027f3          	csrr	a5,sstatus
ffffffffc020263a:	8b89                	andi	a5,a5,2
ffffffffc020263c:	e7d9                	bnez	a5,ffffffffc02026ca <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020263e:	000db783          	ld	a5,0(s11)
ffffffffc0202642:	4585                	li	a1,1
ffffffffc0202644:	e032                	sd	a2,0(sp)
ffffffffc0202646:	739c                	ld	a5,32(a5)
ffffffffc0202648:	9782                	jalr	a5
    if (flag)
ffffffffc020264a:	6602                	ld	a2,0(sp)
ffffffffc020264c:	000d1817          	auipc	a6,0xd1
ffffffffc0202650:	cac80813          	addi	a6,a6,-852 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0202654:	fff80e37          	lui	t3,0xfff80
ffffffffc0202658:	00080337          	lui	t1,0x80
ffffffffc020265c:	6885                	lui	a7,0x1
ffffffffc020265e:	000d1717          	auipc	a4,0xd1
ffffffffc0202662:	c8a70713          	addi	a4,a4,-886 # ffffffffc02d32e8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202666:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020266a:	002007b7          	lui	a5,0x200
ffffffffc020266e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202670:	f60918e3          	bnez	s2,ffffffffc02025e0 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202674:	f00b85e3          	beqz	s7,ffffffffc020257e <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202678:	000d3783          	ld	a5,0(s10)
ffffffffc020267c:	0efa7263          	bgeu	s4,a5,ffffffffc0202760 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202680:	6308                	ld	a0,0(a4)
ffffffffc0202682:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202684:	100027f3          	csrr	a5,sstatus
ffffffffc0202688:	8b89                	andi	a5,a5,2
ffffffffc020268a:	efad                	bnez	a5,ffffffffc0202704 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc020268c:	000db783          	ld	a5,0(s11)
ffffffffc0202690:	4585                	li	a1,1
ffffffffc0202692:	739c                	ld	a5,32(a5)
ffffffffc0202694:	9782                	jalr	a5
ffffffffc0202696:	000d1717          	auipc	a4,0xd1
ffffffffc020269a:	c5270713          	addi	a4,a4,-942 # ffffffffc02d32e8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020269e:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02026a2:	ee0990e3          	bnez	s3,ffffffffc0202582 <exit_range+0x90>
}
ffffffffc02026a6:	70e6                	ld	ra,120(sp)
ffffffffc02026a8:	7446                	ld	s0,112(sp)
ffffffffc02026aa:	74a6                	ld	s1,104(sp)
ffffffffc02026ac:	7906                	ld	s2,96(sp)
ffffffffc02026ae:	69e6                	ld	s3,88(sp)
ffffffffc02026b0:	6a46                	ld	s4,80(sp)
ffffffffc02026b2:	6aa6                	ld	s5,72(sp)
ffffffffc02026b4:	6b06                	ld	s6,64(sp)
ffffffffc02026b6:	7be2                	ld	s7,56(sp)
ffffffffc02026b8:	7c42                	ld	s8,48(sp)
ffffffffc02026ba:	7ca2                	ld	s9,40(sp)
ffffffffc02026bc:	7d02                	ld	s10,32(sp)
ffffffffc02026be:	6de2                	ld	s11,24(sp)
ffffffffc02026c0:	6109                	addi	sp,sp,128
ffffffffc02026c2:	8082                	ret
            if (free_pd0)
ffffffffc02026c4:	ea0b8fe3          	beqz	s7,ffffffffc0202582 <exit_range+0x90>
ffffffffc02026c8:	bf45                	j	ffffffffc0202678 <exit_range+0x186>
ffffffffc02026ca:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02026cc:	e42a                	sd	a0,8(sp)
ffffffffc02026ce:	ae6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02026d2:	000db783          	ld	a5,0(s11)
ffffffffc02026d6:	6522                	ld	a0,8(sp)
ffffffffc02026d8:	4585                	li	a1,1
ffffffffc02026da:	739c                	ld	a5,32(a5)
ffffffffc02026dc:	9782                	jalr	a5
        intr_enable();
ffffffffc02026de:	ad0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02026e2:	6602                	ld	a2,0(sp)
ffffffffc02026e4:	000d1717          	auipc	a4,0xd1
ffffffffc02026e8:	c0470713          	addi	a4,a4,-1020 # ffffffffc02d32e8 <pages>
ffffffffc02026ec:	6885                	lui	a7,0x1
ffffffffc02026ee:	00080337          	lui	t1,0x80
ffffffffc02026f2:	fff80e37          	lui	t3,0xfff80
ffffffffc02026f6:	000d1817          	auipc	a6,0xd1
ffffffffc02026fa:	c0280813          	addi	a6,a6,-1022 # ffffffffc02d32f8 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02026fe:	0004b023          	sd	zero,0(s1)
ffffffffc0202702:	b7a5                	j	ffffffffc020266a <exit_range+0x178>
ffffffffc0202704:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202706:	aaefe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020270a:	000db783          	ld	a5,0(s11)
ffffffffc020270e:	6502                	ld	a0,0(sp)
ffffffffc0202710:	4585                	li	a1,1
ffffffffc0202712:	739c                	ld	a5,32(a5)
ffffffffc0202714:	9782                	jalr	a5
        intr_enable();
ffffffffc0202716:	a98fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020271a:	000d1717          	auipc	a4,0xd1
ffffffffc020271e:	bce70713          	addi	a4,a4,-1074 # ffffffffc02d32e8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202722:	00043023          	sd	zero,0(s0)
ffffffffc0202726:	bfb5                	j	ffffffffc02026a2 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202728:	00004697          	auipc	a3,0x4
ffffffffc020272c:	1b868693          	addi	a3,a3,440 # ffffffffc02068e0 <default_pmm_manager+0xe0>
ffffffffc0202730:	00004617          	auipc	a2,0x4
ffffffffc0202734:	d2060613          	addi	a2,a2,-736 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0202738:	13500593          	li	a1,309
ffffffffc020273c:	00004517          	auipc	a0,0x4
ffffffffc0202740:	19450513          	addi	a0,a0,404 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0202744:	d4bfd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202748:	00004617          	auipc	a2,0x4
ffffffffc020274c:	c7860613          	addi	a2,a2,-904 # ffffffffc02063c0 <commands+0x830>
ffffffffc0202750:	07100593          	li	a1,113
ffffffffc0202754:	00004517          	auipc	a0,0x4
ffffffffc0202758:	c2450513          	addi	a0,a0,-988 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020275c:	d33fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202760:	8e1ff0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202764:	00004697          	auipc	a3,0x4
ffffffffc0202768:	1ac68693          	addi	a3,a3,428 # ffffffffc0206910 <default_pmm_manager+0x110>
ffffffffc020276c:	00004617          	auipc	a2,0x4
ffffffffc0202770:	ce460613          	addi	a2,a2,-796 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0202774:	13600593          	li	a1,310
ffffffffc0202778:	00004517          	auipc	a0,0x4
ffffffffc020277c:	15850513          	addi	a0,a0,344 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0202780:	d0ffd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202784 <page_remove>:
{
ffffffffc0202784:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202786:	4601                	li	a2,0
{
ffffffffc0202788:	ec26                	sd	s1,24(sp)
ffffffffc020278a:	f406                	sd	ra,40(sp)
ffffffffc020278c:	f022                	sd	s0,32(sp)
ffffffffc020278e:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202790:	9a1ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
    if (ptep != NULL)
ffffffffc0202794:	c511                	beqz	a0,ffffffffc02027a0 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202796:	611c                	ld	a5,0(a0)
ffffffffc0202798:	842a                	mv	s0,a0
ffffffffc020279a:	0017f713          	andi	a4,a5,1
ffffffffc020279e:	e711                	bnez	a4,ffffffffc02027aa <page_remove+0x26>
}
ffffffffc02027a0:	70a2                	ld	ra,40(sp)
ffffffffc02027a2:	7402                	ld	s0,32(sp)
ffffffffc02027a4:	64e2                	ld	s1,24(sp)
ffffffffc02027a6:	6145                	addi	sp,sp,48
ffffffffc02027a8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02027aa:	078a                	slli	a5,a5,0x2
ffffffffc02027ac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027ae:	000d1717          	auipc	a4,0xd1
ffffffffc02027b2:	b3273703          	ld	a4,-1230(a4) # ffffffffc02d32e0 <npage>
ffffffffc02027b6:	06e7f363          	bgeu	a5,a4,ffffffffc020281c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02027ba:	fff80537          	lui	a0,0xfff80
ffffffffc02027be:	97aa                	add	a5,a5,a0
ffffffffc02027c0:	079a                	slli	a5,a5,0x6
ffffffffc02027c2:	000d1517          	auipc	a0,0xd1
ffffffffc02027c6:	b2653503          	ld	a0,-1242(a0) # ffffffffc02d32e8 <pages>
ffffffffc02027ca:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02027cc:	411c                	lw	a5,0(a0)
ffffffffc02027ce:	fff7871b          	addiw	a4,a5,-1
ffffffffc02027d2:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02027d4:	cb11                	beqz	a4,ffffffffc02027e8 <page_remove+0x64>
        *ptep = 0;
ffffffffc02027d6:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027da:	12048073          	sfence.vma	s1
}
ffffffffc02027de:	70a2                	ld	ra,40(sp)
ffffffffc02027e0:	7402                	ld	s0,32(sp)
ffffffffc02027e2:	64e2                	ld	s1,24(sp)
ffffffffc02027e4:	6145                	addi	sp,sp,48
ffffffffc02027e6:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02027e8:	100027f3          	csrr	a5,sstatus
ffffffffc02027ec:	8b89                	andi	a5,a5,2
ffffffffc02027ee:	eb89                	bnez	a5,ffffffffc0202800 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02027f0:	000d1797          	auipc	a5,0xd1
ffffffffc02027f4:	b007b783          	ld	a5,-1280(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02027f8:	739c                	ld	a5,32(a5)
ffffffffc02027fa:	4585                	li	a1,1
ffffffffc02027fc:	9782                	jalr	a5
    if (flag)
ffffffffc02027fe:	bfe1                	j	ffffffffc02027d6 <page_remove+0x52>
        intr_disable();
ffffffffc0202800:	e42a                	sd	a0,8(sp)
ffffffffc0202802:	9b2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202806:	000d1797          	auipc	a5,0xd1
ffffffffc020280a:	aea7b783          	ld	a5,-1302(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc020280e:	739c                	ld	a5,32(a5)
ffffffffc0202810:	6522                	ld	a0,8(sp)
ffffffffc0202812:	4585                	li	a1,1
ffffffffc0202814:	9782                	jalr	a5
        intr_enable();
ffffffffc0202816:	998fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020281a:	bf75                	j	ffffffffc02027d6 <page_remove+0x52>
ffffffffc020281c:	825ff0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>

ffffffffc0202820 <page_insert>:
{
ffffffffc0202820:	7139                	addi	sp,sp,-64
ffffffffc0202822:	e852                	sd	s4,16(sp)
ffffffffc0202824:	8a32                	mv	s4,a2
ffffffffc0202826:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202828:	4605                	li	a2,1
{
ffffffffc020282a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020282c:	85d2                	mv	a1,s4
{
ffffffffc020282e:	f426                	sd	s1,40(sp)
ffffffffc0202830:	fc06                	sd	ra,56(sp)
ffffffffc0202832:	f04a                	sd	s2,32(sp)
ffffffffc0202834:	ec4e                	sd	s3,24(sp)
ffffffffc0202836:	e456                	sd	s5,8(sp)
ffffffffc0202838:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020283a:	8f7ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
    if (ptep == NULL)
ffffffffc020283e:	c961                	beqz	a0,ffffffffc020290e <page_insert+0xee>
    page->ref += 1;
ffffffffc0202840:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202842:	611c                	ld	a5,0(a0)
ffffffffc0202844:	89aa                	mv	s3,a0
ffffffffc0202846:	0016871b          	addiw	a4,a3,1
ffffffffc020284a:	c018                	sw	a4,0(s0)
ffffffffc020284c:	0017f713          	andi	a4,a5,1
ffffffffc0202850:	ef05                	bnez	a4,ffffffffc0202888 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202852:	000d1717          	auipc	a4,0xd1
ffffffffc0202856:	a9673703          	ld	a4,-1386(a4) # ffffffffc02d32e8 <pages>
ffffffffc020285a:	8c19                	sub	s0,s0,a4
ffffffffc020285c:	000807b7          	lui	a5,0x80
ffffffffc0202860:	8419                	srai	s0,s0,0x6
ffffffffc0202862:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202864:	042a                	slli	s0,s0,0xa
ffffffffc0202866:	8cc1                	or	s1,s1,s0
ffffffffc0202868:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020286c:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202870:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202874:	4501                	li	a0,0
}
ffffffffc0202876:	70e2                	ld	ra,56(sp)
ffffffffc0202878:	7442                	ld	s0,48(sp)
ffffffffc020287a:	74a2                	ld	s1,40(sp)
ffffffffc020287c:	7902                	ld	s2,32(sp)
ffffffffc020287e:	69e2                	ld	s3,24(sp)
ffffffffc0202880:	6a42                	ld	s4,16(sp)
ffffffffc0202882:	6aa2                	ld	s5,8(sp)
ffffffffc0202884:	6121                	addi	sp,sp,64
ffffffffc0202886:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202888:	078a                	slli	a5,a5,0x2
ffffffffc020288a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020288c:	000d1717          	auipc	a4,0xd1
ffffffffc0202890:	a5473703          	ld	a4,-1452(a4) # ffffffffc02d32e0 <npage>
ffffffffc0202894:	06e7ff63          	bgeu	a5,a4,ffffffffc0202912 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202898:	000d1a97          	auipc	s5,0xd1
ffffffffc020289c:	a50a8a93          	addi	s5,s5,-1456 # ffffffffc02d32e8 <pages>
ffffffffc02028a0:	000ab703          	ld	a4,0(s5)
ffffffffc02028a4:	fff80937          	lui	s2,0xfff80
ffffffffc02028a8:	993e                	add	s2,s2,a5
ffffffffc02028aa:	091a                	slli	s2,s2,0x6
ffffffffc02028ac:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02028ae:	01240c63          	beq	s0,s2,ffffffffc02028c6 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02028b2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcacce4>
ffffffffc02028b6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02028ba:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02028be:	c691                	beqz	a3,ffffffffc02028ca <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028c0:	120a0073          	sfence.vma	s4
}
ffffffffc02028c4:	bf59                	j	ffffffffc020285a <page_insert+0x3a>
ffffffffc02028c6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02028c8:	bf49                	j	ffffffffc020285a <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028ca:	100027f3          	csrr	a5,sstatus
ffffffffc02028ce:	8b89                	andi	a5,a5,2
ffffffffc02028d0:	ef91                	bnez	a5,ffffffffc02028ec <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02028d2:	000d1797          	auipc	a5,0xd1
ffffffffc02028d6:	a1e7b783          	ld	a5,-1506(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02028da:	739c                	ld	a5,32(a5)
ffffffffc02028dc:	4585                	li	a1,1
ffffffffc02028de:	854a                	mv	a0,s2
ffffffffc02028e0:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02028e2:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028e6:	120a0073          	sfence.vma	s4
ffffffffc02028ea:	bf85                	j	ffffffffc020285a <page_insert+0x3a>
        intr_disable();
ffffffffc02028ec:	8c8fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028f0:	000d1797          	auipc	a5,0xd1
ffffffffc02028f4:	a007b783          	ld	a5,-1536(a5) # ffffffffc02d32f0 <pmm_manager>
ffffffffc02028f8:	739c                	ld	a5,32(a5)
ffffffffc02028fa:	4585                	li	a1,1
ffffffffc02028fc:	854a                	mv	a0,s2
ffffffffc02028fe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202900:	8aefe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202904:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202908:	120a0073          	sfence.vma	s4
ffffffffc020290c:	b7b9                	j	ffffffffc020285a <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020290e:	5571                	li	a0,-4
ffffffffc0202910:	b79d                	j	ffffffffc0202876 <page_insert+0x56>
ffffffffc0202912:	f2eff0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>

ffffffffc0202916 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202916:	00004797          	auipc	a5,0x4
ffffffffc020291a:	eea78793          	addi	a5,a5,-278 # ffffffffc0206800 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020291e:	638c                	ld	a1,0(a5)
{
ffffffffc0202920:	7159                	addi	sp,sp,-112
ffffffffc0202922:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202924:	00004517          	auipc	a0,0x4
ffffffffc0202928:	00450513          	addi	a0,a0,4 # ffffffffc0206928 <default_pmm_manager+0x128>
    pmm_manager = &default_pmm_manager;
ffffffffc020292c:	000d1b17          	auipc	s6,0xd1
ffffffffc0202930:	9c4b0b13          	addi	s6,s6,-1596 # ffffffffc02d32f0 <pmm_manager>
{
ffffffffc0202934:	f486                	sd	ra,104(sp)
ffffffffc0202936:	e8ca                	sd	s2,80(sp)
ffffffffc0202938:	e4ce                	sd	s3,72(sp)
ffffffffc020293a:	f0a2                	sd	s0,96(sp)
ffffffffc020293c:	eca6                	sd	s1,88(sp)
ffffffffc020293e:	e0d2                	sd	s4,64(sp)
ffffffffc0202940:	fc56                	sd	s5,56(sp)
ffffffffc0202942:	f45e                	sd	s7,40(sp)
ffffffffc0202944:	f062                	sd	s8,32(sp)
ffffffffc0202946:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202948:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020294c:	849fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202950:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202954:	000d1997          	auipc	s3,0xd1
ffffffffc0202958:	9a498993          	addi	s3,s3,-1628 # ffffffffc02d32f8 <va_pa_offset>
    pmm_manager->init();
ffffffffc020295c:	679c                	ld	a5,8(a5)
ffffffffc020295e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202960:	57f5                	li	a5,-3
ffffffffc0202962:	07fa                	slli	a5,a5,0x1e
ffffffffc0202964:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202968:	832fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc020296c:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020296e:	836fe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202972:	200505e3          	beqz	a0,ffffffffc020337c <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202976:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202978:	00004517          	auipc	a0,0x4
ffffffffc020297c:	fe850513          	addi	a0,a0,-24 # ffffffffc0206960 <default_pmm_manager+0x160>
ffffffffc0202980:	815fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202984:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202988:	fff40693          	addi	a3,s0,-1
ffffffffc020298c:	864a                	mv	a2,s2
ffffffffc020298e:	85a6                	mv	a1,s1
ffffffffc0202990:	00004517          	auipc	a0,0x4
ffffffffc0202994:	fe850513          	addi	a0,a0,-24 # ffffffffc0206978 <default_pmm_manager+0x178>
ffffffffc0202998:	ffcfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc020299c:	c8000737          	lui	a4,0xc8000
ffffffffc02029a0:	87a2                	mv	a5,s0
ffffffffc02029a2:	54876163          	bltu	a4,s0,ffffffffc0202ee4 <pmm_init+0x5ce>
ffffffffc02029a6:	757d                	lui	a0,0xfffff
ffffffffc02029a8:	000d2617          	auipc	a2,0xd2
ffffffffc02029ac:	97360613          	addi	a2,a2,-1677 # ffffffffc02d431b <end+0xfff>
ffffffffc02029b0:	8e69                	and	a2,a2,a0
ffffffffc02029b2:	000d1497          	auipc	s1,0xd1
ffffffffc02029b6:	92e48493          	addi	s1,s1,-1746 # ffffffffc02d32e0 <npage>
ffffffffc02029ba:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02029be:	000d1b97          	auipc	s7,0xd1
ffffffffc02029c2:	92ab8b93          	addi	s7,s7,-1750 # ffffffffc02d32e8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02029c6:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02029c8:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029cc:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02029d0:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029d2:	02f50863          	beq	a0,a5,ffffffffc0202a02 <pmm_init+0xec>
ffffffffc02029d6:	4781                	li	a5,0
ffffffffc02029d8:	4585                	li	a1,1
ffffffffc02029da:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02029de:	00679513          	slli	a0,a5,0x6
ffffffffc02029e2:	9532                	add	a0,a0,a2
ffffffffc02029e4:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd2bcec>
ffffffffc02029e8:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029ec:	6088                	ld	a0,0(s1)
ffffffffc02029ee:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc02029f0:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029f4:	00d50733          	add	a4,a0,a3
ffffffffc02029f8:	fee7e3e3          	bltu	a5,a4,ffffffffc02029de <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02029fc:	071a                	slli	a4,a4,0x6
ffffffffc02029fe:	00e606b3          	add	a3,a2,a4
ffffffffc0202a02:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a06:	2ef6ece3          	bltu	a3,a5,ffffffffc02034fe <pmm_init+0xbe8>
ffffffffc0202a0a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202a0e:	77fd                	lui	a5,0xfffff
ffffffffc0202a10:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202a12:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202a14:	5086eb63          	bltu	a3,s0,ffffffffc0202f2a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202a18:	00004517          	auipc	a0,0x4
ffffffffc0202a1c:	f8850513          	addi	a0,a0,-120 # ffffffffc02069a0 <default_pmm_manager+0x1a0>
ffffffffc0202a20:	f74fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202a24:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a28:	000d1917          	auipc	s2,0xd1
ffffffffc0202a2c:	8b090913          	addi	s2,s2,-1872 # ffffffffc02d32d8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202a30:	7b9c                	ld	a5,48(a5)
ffffffffc0202a32:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202a34:	00004517          	auipc	a0,0x4
ffffffffc0202a38:	f8450513          	addi	a0,a0,-124 # ffffffffc02069b8 <default_pmm_manager+0x1b8>
ffffffffc0202a3c:	f58fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a40:	00007697          	auipc	a3,0x7
ffffffffc0202a44:	5c068693          	addi	a3,a3,1472 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202a48:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202a4c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a50:	28f6ebe3          	bltu	a3,a5,ffffffffc02034e6 <pmm_init+0xbd0>
ffffffffc0202a54:	0009b783          	ld	a5,0(s3)
ffffffffc0202a58:	8e9d                	sub	a3,a3,a5
ffffffffc0202a5a:	000d1797          	auipc	a5,0xd1
ffffffffc0202a5e:	86d7bb23          	sd	a3,-1930(a5) # ffffffffc02d32d0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202a62:	100027f3          	csrr	a5,sstatus
ffffffffc0202a66:	8b89                	andi	a5,a5,2
ffffffffc0202a68:	4a079763          	bnez	a5,ffffffffc0202f16 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a6c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a70:	779c                	ld	a5,40(a5)
ffffffffc0202a72:	9782                	jalr	a5
ffffffffc0202a74:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202a76:	6098                	ld	a4,0(s1)
ffffffffc0202a78:	c80007b7          	lui	a5,0xc8000
ffffffffc0202a7c:	83b1                	srli	a5,a5,0xc
ffffffffc0202a7e:	66e7e363          	bltu	a5,a4,ffffffffc02030e4 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202a82:	00093503          	ld	a0,0(s2)
ffffffffc0202a86:	62050f63          	beqz	a0,ffffffffc02030c4 <pmm_init+0x7ae>
ffffffffc0202a8a:	03451793          	slli	a5,a0,0x34
ffffffffc0202a8e:	62079b63          	bnez	a5,ffffffffc02030c4 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202a92:	4601                	li	a2,0
ffffffffc0202a94:	4581                	li	a1,0
ffffffffc0202a96:	8c3ff0ef          	jal	ra,ffffffffc0202358 <get_page>
ffffffffc0202a9a:	60051563          	bnez	a0,ffffffffc02030a4 <pmm_init+0x78e>
ffffffffc0202a9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202aa2:	8b89                	andi	a5,a5,2
ffffffffc0202aa4:	44079e63          	bnez	a5,ffffffffc0202f00 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202aa8:	000b3783          	ld	a5,0(s6)
ffffffffc0202aac:	4505                	li	a0,1
ffffffffc0202aae:	6f9c                	ld	a5,24(a5)
ffffffffc0202ab0:	9782                	jalr	a5
ffffffffc0202ab2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202ab4:	00093503          	ld	a0,0(s2)
ffffffffc0202ab8:	4681                	li	a3,0
ffffffffc0202aba:	4601                	li	a2,0
ffffffffc0202abc:	85d2                	mv	a1,s4
ffffffffc0202abe:	d63ff0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc0202ac2:	26051ae3          	bnez	a0,ffffffffc0203536 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202ac6:	00093503          	ld	a0,0(s2)
ffffffffc0202aca:	4601                	li	a2,0
ffffffffc0202acc:	4581                	li	a1,0
ffffffffc0202ace:	e62ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0202ad2:	240502e3          	beqz	a0,ffffffffc0203516 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202ad6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202ad8:	0017f713          	andi	a4,a5,1
ffffffffc0202adc:	5a070263          	beqz	a4,ffffffffc0203080 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202ae0:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ae2:	078a                	slli	a5,a5,0x2
ffffffffc0202ae4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ae6:	58e7fb63          	bgeu	a5,a4,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aea:	000bb683          	ld	a3,0(s7)
ffffffffc0202aee:	fff80637          	lui	a2,0xfff80
ffffffffc0202af2:	97b2                	add	a5,a5,a2
ffffffffc0202af4:	079a                	slli	a5,a5,0x6
ffffffffc0202af6:	97b6                	add	a5,a5,a3
ffffffffc0202af8:	14fa17e3          	bne	s4,a5,ffffffffc0203446 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202afc:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202b00:	4785                	li	a5,1
ffffffffc0202b02:	12f692e3          	bne	a3,a5,ffffffffc0203426 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202b06:	00093503          	ld	a0,0(s2)
ffffffffc0202b0a:	77fd                	lui	a5,0xfffff
ffffffffc0202b0c:	6114                	ld	a3,0(a0)
ffffffffc0202b0e:	068a                	slli	a3,a3,0x2
ffffffffc0202b10:	8efd                	and	a3,a3,a5
ffffffffc0202b12:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202b16:	0ee67ce3          	bgeu	a2,a4,ffffffffc020340e <pmm_init+0xaf8>
ffffffffc0202b1a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b1e:	96e2                	add	a3,a3,s8
ffffffffc0202b20:	0006ba83          	ld	s5,0(a3)
ffffffffc0202b24:	0a8a                	slli	s5,s5,0x2
ffffffffc0202b26:	00fafab3          	and	s5,s5,a5
ffffffffc0202b2a:	00cad793          	srli	a5,s5,0xc
ffffffffc0202b2e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02033f4 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b32:	4601                	li	a2,0
ffffffffc0202b34:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b36:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b38:	df8ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b3c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b3e:	55551363          	bne	a0,s5,ffffffffc0203084 <pmm_init+0x76e>
ffffffffc0202b42:	100027f3          	csrr	a5,sstatus
ffffffffc0202b46:	8b89                	andi	a5,a5,2
ffffffffc0202b48:	3a079163          	bnez	a5,ffffffffc0202eea <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b4c:	000b3783          	ld	a5,0(s6)
ffffffffc0202b50:	4505                	li	a0,1
ffffffffc0202b52:	6f9c                	ld	a5,24(a5)
ffffffffc0202b54:	9782                	jalr	a5
ffffffffc0202b56:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202b58:	00093503          	ld	a0,0(s2)
ffffffffc0202b5c:	46d1                	li	a3,20
ffffffffc0202b5e:	6605                	lui	a2,0x1
ffffffffc0202b60:	85e2                	mv	a1,s8
ffffffffc0202b62:	cbfff0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc0202b66:	060517e3          	bnez	a0,ffffffffc02033d4 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b6a:	00093503          	ld	a0,0(s2)
ffffffffc0202b6e:	4601                	li	a2,0
ffffffffc0202b70:	6585                	lui	a1,0x1
ffffffffc0202b72:	dbeff0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0202b76:	02050fe3          	beqz	a0,ffffffffc02033b4 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202b7a:	611c                	ld	a5,0(a0)
ffffffffc0202b7c:	0107f713          	andi	a4,a5,16
ffffffffc0202b80:	7c070e63          	beqz	a4,ffffffffc020335c <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202b84:	8b91                	andi	a5,a5,4
ffffffffc0202b86:	7a078b63          	beqz	a5,ffffffffc020333c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b8a:	00093503          	ld	a0,0(s2)
ffffffffc0202b8e:	611c                	ld	a5,0(a0)
ffffffffc0202b90:	8bc1                	andi	a5,a5,16
ffffffffc0202b92:	78078563          	beqz	a5,ffffffffc020331c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202b96:	000c2703          	lw	a4,0(s8)
ffffffffc0202b9a:	4785                	li	a5,1
ffffffffc0202b9c:	76f71063          	bne	a4,a5,ffffffffc02032fc <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202ba0:	4681                	li	a3,0
ffffffffc0202ba2:	6605                	lui	a2,0x1
ffffffffc0202ba4:	85d2                	mv	a1,s4
ffffffffc0202ba6:	c7bff0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc0202baa:	72051963          	bnez	a0,ffffffffc02032dc <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202bae:	000a2703          	lw	a4,0(s4)
ffffffffc0202bb2:	4789                	li	a5,2
ffffffffc0202bb4:	70f71463          	bne	a4,a5,ffffffffc02032bc <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202bb8:	000c2783          	lw	a5,0(s8)
ffffffffc0202bbc:	6e079063          	bnez	a5,ffffffffc020329c <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bc0:	00093503          	ld	a0,0(s2)
ffffffffc0202bc4:	4601                	li	a2,0
ffffffffc0202bc6:	6585                	lui	a1,0x1
ffffffffc0202bc8:	d68ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0202bcc:	6a050863          	beqz	a0,ffffffffc020327c <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202bd0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202bd2:	00177793          	andi	a5,a4,1
ffffffffc0202bd6:	4a078563          	beqz	a5,ffffffffc0203080 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202bda:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202bdc:	00271793          	slli	a5,a4,0x2
ffffffffc0202be0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202be2:	48d7fd63          	bgeu	a5,a3,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202be6:	000bb683          	ld	a3,0(s7)
ffffffffc0202bea:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202bee:	97d6                	add	a5,a5,s5
ffffffffc0202bf0:	079a                	slli	a5,a5,0x6
ffffffffc0202bf2:	97b6                	add	a5,a5,a3
ffffffffc0202bf4:	66fa1463          	bne	s4,a5,ffffffffc020325c <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202bf8:	8b41                	andi	a4,a4,16
ffffffffc0202bfa:	64071163          	bnez	a4,ffffffffc020323c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202bfe:	00093503          	ld	a0,0(s2)
ffffffffc0202c02:	4581                	li	a1,0
ffffffffc0202c04:	b81ff0ef          	jal	ra,ffffffffc0202784 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202c08:	000a2c83          	lw	s9,0(s4)
ffffffffc0202c0c:	4785                	li	a5,1
ffffffffc0202c0e:	60fc9763          	bne	s9,a5,ffffffffc020321c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202c12:	000c2783          	lw	a5,0(s8)
ffffffffc0202c16:	5e079363          	bnez	a5,ffffffffc02031fc <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202c1a:	00093503          	ld	a0,0(s2)
ffffffffc0202c1e:	6585                	lui	a1,0x1
ffffffffc0202c20:	b65ff0ef          	jal	ra,ffffffffc0202784 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202c24:	000a2783          	lw	a5,0(s4)
ffffffffc0202c28:	52079a63          	bnez	a5,ffffffffc020315c <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202c2c:	000c2783          	lw	a5,0(s8)
ffffffffc0202c30:	50079663          	bnez	a5,ffffffffc020313c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202c34:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c38:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c3a:	000a3683          	ld	a3,0(s4)
ffffffffc0202c3e:	068a                	slli	a3,a3,0x2
ffffffffc0202c40:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c42:	42b6fd63          	bgeu	a3,a1,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c46:	000bb503          	ld	a0,0(s7)
ffffffffc0202c4a:	96d6                	add	a3,a3,s5
ffffffffc0202c4c:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202c4e:	00d507b3          	add	a5,a0,a3
ffffffffc0202c52:	439c                	lw	a5,0(a5)
ffffffffc0202c54:	4d979463          	bne	a5,s9,ffffffffc020311c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202c58:	8699                	srai	a3,a3,0x6
ffffffffc0202c5a:	00080637          	lui	a2,0x80
ffffffffc0202c5e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202c60:	00c69713          	slli	a4,a3,0xc
ffffffffc0202c64:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c66:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c68:	48b77e63          	bgeu	a4,a1,ffffffffc0203104 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202c6c:	0009b703          	ld	a4,0(s3)
ffffffffc0202c70:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c72:	629c                	ld	a5,0(a3)
ffffffffc0202c74:	078a                	slli	a5,a5,0x2
ffffffffc0202c76:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c78:	40b7f263          	bgeu	a5,a1,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c7c:	8f91                	sub	a5,a5,a2
ffffffffc0202c7e:	079a                	slli	a5,a5,0x6
ffffffffc0202c80:	953e                	add	a0,a0,a5
ffffffffc0202c82:	100027f3          	csrr	a5,sstatus
ffffffffc0202c86:	8b89                	andi	a5,a5,2
ffffffffc0202c88:	30079963          	bnez	a5,ffffffffc0202f9a <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202c8c:	000b3783          	ld	a5,0(s6)
ffffffffc0202c90:	4585                	li	a1,1
ffffffffc0202c92:	739c                	ld	a5,32(a5)
ffffffffc0202c94:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c96:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202c9a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c9c:	078a                	slli	a5,a5,0x2
ffffffffc0202c9e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ca0:	3ce7fe63          	bgeu	a5,a4,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ca4:	000bb503          	ld	a0,0(s7)
ffffffffc0202ca8:	fff80737          	lui	a4,0xfff80
ffffffffc0202cac:	97ba                	add	a5,a5,a4
ffffffffc0202cae:	079a                	slli	a5,a5,0x6
ffffffffc0202cb0:	953e                	add	a0,a0,a5
ffffffffc0202cb2:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb6:	8b89                	andi	a5,a5,2
ffffffffc0202cb8:	2c079563          	bnez	a5,ffffffffc0202f82 <pmm_init+0x66c>
ffffffffc0202cbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202cc0:	4585                	li	a1,1
ffffffffc0202cc2:	739c                	ld	a5,32(a5)
ffffffffc0202cc4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202cc6:	00093783          	ld	a5,0(s2)
ffffffffc0202cca:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd2bce4>
    asm volatile("sfence.vma");
ffffffffc0202cce:	12000073          	sfence.vma
ffffffffc0202cd2:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd6:	8b89                	andi	a5,a5,2
ffffffffc0202cd8:	28079b63          	bnez	a5,ffffffffc0202f6e <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce0:	779c                	ld	a5,40(a5)
ffffffffc0202ce2:	9782                	jalr	a5
ffffffffc0202ce4:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ce6:	4b441b63          	bne	s0,s4,ffffffffc020319c <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202cea:	00004517          	auipc	a0,0x4
ffffffffc0202cee:	ff650513          	addi	a0,a0,-10 # ffffffffc0206ce0 <default_pmm_manager+0x4e0>
ffffffffc0202cf2:	ca2fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202cf6:	100027f3          	csrr	a5,sstatus
ffffffffc0202cfa:	8b89                	andi	a5,a5,2
ffffffffc0202cfc:	24079f63          	bnez	a5,ffffffffc0202f5a <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d00:	000b3783          	ld	a5,0(s6)
ffffffffc0202d04:	779c                	ld	a5,40(a5)
ffffffffc0202d06:	9782                	jalr	a5
ffffffffc0202d08:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d0a:	6098                	ld	a4,0(s1)
ffffffffc0202d0c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d10:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d12:	00c71793          	slli	a5,a4,0xc
ffffffffc0202d16:	6a05                	lui	s4,0x1
ffffffffc0202d18:	02f47c63          	bgeu	s0,a5,ffffffffc0202d50 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d1c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202d20:	00093503          	ld	a0,0(s2)
ffffffffc0202d24:	2ee7ff63          	bgeu	a5,a4,ffffffffc0203022 <pmm_init+0x70c>
ffffffffc0202d28:	0009b583          	ld	a1,0(s3)
ffffffffc0202d2c:	4601                	li	a2,0
ffffffffc0202d2e:	95a2                	add	a1,a1,s0
ffffffffc0202d30:	c00ff0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc0202d34:	32050463          	beqz	a0,ffffffffc020305c <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d38:	611c                	ld	a5,0(a0)
ffffffffc0202d3a:	078a                	slli	a5,a5,0x2
ffffffffc0202d3c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202d40:	2e879e63          	bne	a5,s0,ffffffffc020303c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d44:	6098                	ld	a4,0(s1)
ffffffffc0202d46:	9452                	add	s0,s0,s4
ffffffffc0202d48:	00c71793          	slli	a5,a4,0xc
ffffffffc0202d4c:	fcf468e3          	bltu	s0,a5,ffffffffc0202d1c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202d50:	00093783          	ld	a5,0(s2)
ffffffffc0202d54:	639c                	ld	a5,0(a5)
ffffffffc0202d56:	42079363          	bnez	a5,ffffffffc020317c <pmm_init+0x866>
ffffffffc0202d5a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d5e:	8b89                	andi	a5,a5,2
ffffffffc0202d60:	24079963          	bnez	a5,ffffffffc0202fb2 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d64:	000b3783          	ld	a5,0(s6)
ffffffffc0202d68:	4505                	li	a0,1
ffffffffc0202d6a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d6c:	9782                	jalr	a5
ffffffffc0202d6e:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202d70:	00093503          	ld	a0,0(s2)
ffffffffc0202d74:	4699                	li	a3,6
ffffffffc0202d76:	10000613          	li	a2,256
ffffffffc0202d7a:	85d2                	mv	a1,s4
ffffffffc0202d7c:	aa5ff0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc0202d80:	44051e63          	bnez	a0,ffffffffc02031dc <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202d84:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202d88:	4785                	li	a5,1
ffffffffc0202d8a:	42f71963          	bne	a4,a5,ffffffffc02031bc <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d8e:	00093503          	ld	a0,0(s2)
ffffffffc0202d92:	6405                	lui	s0,0x1
ffffffffc0202d94:	4699                	li	a3,6
ffffffffc0202d96:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab8>
ffffffffc0202d9a:	85d2                	mv	a1,s4
ffffffffc0202d9c:	a85ff0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc0202da0:	72051363          	bnez	a0,ffffffffc02034c6 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202da4:	000a2703          	lw	a4,0(s4)
ffffffffc0202da8:	4789                	li	a5,2
ffffffffc0202daa:	6ef71e63          	bne	a4,a5,ffffffffc02034a6 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202dae:	00004597          	auipc	a1,0x4
ffffffffc0202db2:	07a58593          	addi	a1,a1,122 # ffffffffc0206e28 <default_pmm_manager+0x628>
ffffffffc0202db6:	10000513          	li	a0,256
ffffffffc0202dba:	2d9020ef          	jal	ra,ffffffffc0205892 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202dbe:	10040593          	addi	a1,s0,256
ffffffffc0202dc2:	10000513          	li	a0,256
ffffffffc0202dc6:	2df020ef          	jal	ra,ffffffffc02058a4 <strcmp>
ffffffffc0202dca:	6a051e63          	bnez	a0,ffffffffc0203486 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202dce:	000bb683          	ld	a3,0(s7)
ffffffffc0202dd2:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202dd6:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202dd8:	40da06b3          	sub	a3,s4,a3
ffffffffc0202ddc:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202dde:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202de0:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202de2:	8031                	srli	s0,s0,0xc
ffffffffc0202de4:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202de8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202dea:	30f77d63          	bgeu	a4,a5,ffffffffc0203104 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202dee:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202df2:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202df6:	96be                	add	a3,a3,a5
ffffffffc0202df8:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202dfc:	261020ef          	jal	ra,ffffffffc020585c <strlen>
ffffffffc0202e00:	66051363          	bnez	a0,ffffffffc0203466 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202e04:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202e08:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e0a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd2bce4>
ffffffffc0202e0e:	068a                	slli	a3,a3,0x2
ffffffffc0202e10:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e12:	26f6f563          	bgeu	a3,a5,ffffffffc020307c <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202e16:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e18:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202e1a:	2ef47563          	bgeu	s0,a5,ffffffffc0203104 <pmm_init+0x7ee>
ffffffffc0202e1e:	0009b403          	ld	s0,0(s3)
ffffffffc0202e22:	9436                	add	s0,s0,a3
ffffffffc0202e24:	100027f3          	csrr	a5,sstatus
ffffffffc0202e28:	8b89                	andi	a5,a5,2
ffffffffc0202e2a:	1e079163          	bnez	a5,ffffffffc020300c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202e2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e32:	4585                	li	a1,1
ffffffffc0202e34:	8552                	mv	a0,s4
ffffffffc0202e36:	739c                	ld	a5,32(a5)
ffffffffc0202e38:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e3a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202e3c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e3e:	078a                	slli	a5,a5,0x2
ffffffffc0202e40:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e42:	22e7fd63          	bgeu	a5,a4,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e46:	000bb503          	ld	a0,0(s7)
ffffffffc0202e4a:	fff80737          	lui	a4,0xfff80
ffffffffc0202e4e:	97ba                	add	a5,a5,a4
ffffffffc0202e50:	079a                	slli	a5,a5,0x6
ffffffffc0202e52:	953e                	add	a0,a0,a5
ffffffffc0202e54:	100027f3          	csrr	a5,sstatus
ffffffffc0202e58:	8b89                	andi	a5,a5,2
ffffffffc0202e5a:	18079d63          	bnez	a5,ffffffffc0202ff4 <pmm_init+0x6de>
ffffffffc0202e5e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e62:	4585                	li	a1,1
ffffffffc0202e64:	739c                	ld	a5,32(a5)
ffffffffc0202e66:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e68:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202e6c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e6e:	078a                	slli	a5,a5,0x2
ffffffffc0202e70:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e72:	20e7f563          	bgeu	a5,a4,ffffffffc020307c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e76:	000bb503          	ld	a0,0(s7)
ffffffffc0202e7a:	fff80737          	lui	a4,0xfff80
ffffffffc0202e7e:	97ba                	add	a5,a5,a4
ffffffffc0202e80:	079a                	slli	a5,a5,0x6
ffffffffc0202e82:	953e                	add	a0,a0,a5
ffffffffc0202e84:	100027f3          	csrr	a5,sstatus
ffffffffc0202e88:	8b89                	andi	a5,a5,2
ffffffffc0202e8a:	14079963          	bnez	a5,ffffffffc0202fdc <pmm_init+0x6c6>
ffffffffc0202e8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e92:	4585                	li	a1,1
ffffffffc0202e94:	739c                	ld	a5,32(a5)
ffffffffc0202e96:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202e98:	00093783          	ld	a5,0(s2)
ffffffffc0202e9c:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202ea0:	12000073          	sfence.vma
ffffffffc0202ea4:	100027f3          	csrr	a5,sstatus
ffffffffc0202ea8:	8b89                	andi	a5,a5,2
ffffffffc0202eaa:	10079f63          	bnez	a5,ffffffffc0202fc8 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202eae:	000b3783          	ld	a5,0(s6)
ffffffffc0202eb2:	779c                	ld	a5,40(a5)
ffffffffc0202eb4:	9782                	jalr	a5
ffffffffc0202eb6:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202eb8:	4c8c1e63          	bne	s8,s0,ffffffffc0203394 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ebc:	00004517          	auipc	a0,0x4
ffffffffc0202ec0:	fe450513          	addi	a0,a0,-28 # ffffffffc0206ea0 <default_pmm_manager+0x6a0>
ffffffffc0202ec4:	ad0fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202ec8:	7406                	ld	s0,96(sp)
ffffffffc0202eca:	70a6                	ld	ra,104(sp)
ffffffffc0202ecc:	64e6                	ld	s1,88(sp)
ffffffffc0202ece:	6946                	ld	s2,80(sp)
ffffffffc0202ed0:	69a6                	ld	s3,72(sp)
ffffffffc0202ed2:	6a06                	ld	s4,64(sp)
ffffffffc0202ed4:	7ae2                	ld	s5,56(sp)
ffffffffc0202ed6:	7b42                	ld	s6,48(sp)
ffffffffc0202ed8:	7ba2                	ld	s7,40(sp)
ffffffffc0202eda:	7c02                	ld	s8,32(sp)
ffffffffc0202edc:	6ce2                	ld	s9,24(sp)
ffffffffc0202ede:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202ee0:	f97fe06f          	j	ffffffffc0201e76 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202ee4:	c80007b7          	lui	a5,0xc8000
ffffffffc0202ee8:	bc7d                	j	ffffffffc02029a6 <pmm_init+0x90>
        intr_disable();
ffffffffc0202eea:	acbfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202eee:	000b3783          	ld	a5,0(s6)
ffffffffc0202ef2:	4505                	li	a0,1
ffffffffc0202ef4:	6f9c                	ld	a5,24(a5)
ffffffffc0202ef6:	9782                	jalr	a5
ffffffffc0202ef8:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202efa:	ab5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202efe:	b9a9                	j	ffffffffc0202b58 <pmm_init+0x242>
        intr_disable();
ffffffffc0202f00:	ab5fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202f04:	000b3783          	ld	a5,0(s6)
ffffffffc0202f08:	4505                	li	a0,1
ffffffffc0202f0a:	6f9c                	ld	a5,24(a5)
ffffffffc0202f0c:	9782                	jalr	a5
ffffffffc0202f0e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f10:	a9ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f14:	b645                	j	ffffffffc0202ab4 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202f16:	a9ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f1e:	779c                	ld	a5,40(a5)
ffffffffc0202f20:	9782                	jalr	a5
ffffffffc0202f22:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f24:	a8bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f28:	b6b9                	j	ffffffffc0202a76 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202f2a:	6705                	lui	a4,0x1
ffffffffc0202f2c:	177d                	addi	a4,a4,-1
ffffffffc0202f2e:	96ba                	add	a3,a3,a4
ffffffffc0202f30:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202f32:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202f36:	14a77363          	bgeu	a4,a0,ffffffffc020307c <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202f3a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202f3e:	fff80537          	lui	a0,0xfff80
ffffffffc0202f42:	972a                	add	a4,a4,a0
ffffffffc0202f44:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202f46:	8c1d                	sub	s0,s0,a5
ffffffffc0202f48:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202f4c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202f50:	9532                	add	a0,a0,a2
ffffffffc0202f52:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202f54:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202f58:	b4c1                	j	ffffffffc0202a18 <pmm_init+0x102>
        intr_disable();
ffffffffc0202f5a:	a5bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f5e:	000b3783          	ld	a5,0(s6)
ffffffffc0202f62:	779c                	ld	a5,40(a5)
ffffffffc0202f64:	9782                	jalr	a5
ffffffffc0202f66:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202f68:	a47fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f6c:	bb79                	j	ffffffffc0202d0a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202f6e:	a47fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202f72:	000b3783          	ld	a5,0(s6)
ffffffffc0202f76:	779c                	ld	a5,40(a5)
ffffffffc0202f78:	9782                	jalr	a5
ffffffffc0202f7a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f7c:	a33fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f80:	b39d                	j	ffffffffc0202ce6 <pmm_init+0x3d0>
ffffffffc0202f82:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f84:	a31fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f88:	000b3783          	ld	a5,0(s6)
ffffffffc0202f8c:	6522                	ld	a0,8(sp)
ffffffffc0202f8e:	4585                	li	a1,1
ffffffffc0202f90:	739c                	ld	a5,32(a5)
ffffffffc0202f92:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f94:	a1bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f98:	b33d                	j	ffffffffc0202cc6 <pmm_init+0x3b0>
ffffffffc0202f9a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f9c:	a19fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202fa0:	000b3783          	ld	a5,0(s6)
ffffffffc0202fa4:	6522                	ld	a0,8(sp)
ffffffffc0202fa6:	4585                	li	a1,1
ffffffffc0202fa8:	739c                	ld	a5,32(a5)
ffffffffc0202faa:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fac:	a03fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fb0:	b1dd                	j	ffffffffc0202c96 <pmm_init+0x380>
        intr_disable();
ffffffffc0202fb2:	a03fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202fb6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fba:	4505                	li	a0,1
ffffffffc0202fbc:	6f9c                	ld	a5,24(a5)
ffffffffc0202fbe:	9782                	jalr	a5
ffffffffc0202fc0:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202fc2:	9edfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fc6:	b36d                	j	ffffffffc0202d70 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202fc8:	9edfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fcc:	000b3783          	ld	a5,0(s6)
ffffffffc0202fd0:	779c                	ld	a5,40(a5)
ffffffffc0202fd2:	9782                	jalr	a5
ffffffffc0202fd4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202fd6:	9d9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fda:	bdf9                	j	ffffffffc0202eb8 <pmm_init+0x5a2>
ffffffffc0202fdc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202fde:	9d7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202fe2:	000b3783          	ld	a5,0(s6)
ffffffffc0202fe6:	6522                	ld	a0,8(sp)
ffffffffc0202fe8:	4585                	li	a1,1
ffffffffc0202fea:	739c                	ld	a5,32(a5)
ffffffffc0202fec:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fee:	9c1fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ff2:	b55d                	j	ffffffffc0202e98 <pmm_init+0x582>
ffffffffc0202ff4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ff6:	9bffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202ffa:	000b3783          	ld	a5,0(s6)
ffffffffc0202ffe:	6522                	ld	a0,8(sp)
ffffffffc0203000:	4585                	li	a1,1
ffffffffc0203002:	739c                	ld	a5,32(a5)
ffffffffc0203004:	9782                	jalr	a5
        intr_enable();
ffffffffc0203006:	9a9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020300a:	bdb9                	j	ffffffffc0202e68 <pmm_init+0x552>
        intr_disable();
ffffffffc020300c:	9a9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203010:	000b3783          	ld	a5,0(s6)
ffffffffc0203014:	4585                	li	a1,1
ffffffffc0203016:	8552                	mv	a0,s4
ffffffffc0203018:	739c                	ld	a5,32(a5)
ffffffffc020301a:	9782                	jalr	a5
        intr_enable();
ffffffffc020301c:	993fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203020:	bd29                	j	ffffffffc0202e3a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203022:	86a2                	mv	a3,s0
ffffffffc0203024:	00003617          	auipc	a2,0x3
ffffffffc0203028:	39c60613          	addi	a2,a2,924 # ffffffffc02063c0 <commands+0x830>
ffffffffc020302c:	25900593          	li	a1,601
ffffffffc0203030:	00004517          	auipc	a0,0x4
ffffffffc0203034:	8a050513          	addi	a0,a0,-1888 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203038:	c56fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020303c:	00004697          	auipc	a3,0x4
ffffffffc0203040:	d0468693          	addi	a3,a3,-764 # ffffffffc0206d40 <default_pmm_manager+0x540>
ffffffffc0203044:	00003617          	auipc	a2,0x3
ffffffffc0203048:	40c60613          	addi	a2,a2,1036 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020304c:	25a00593          	li	a1,602
ffffffffc0203050:	00004517          	auipc	a0,0x4
ffffffffc0203054:	88050513          	addi	a0,a0,-1920 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203058:	c36fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020305c:	00004697          	auipc	a3,0x4
ffffffffc0203060:	ca468693          	addi	a3,a3,-860 # ffffffffc0206d00 <default_pmm_manager+0x500>
ffffffffc0203064:	00003617          	auipc	a2,0x3
ffffffffc0203068:	3ec60613          	addi	a2,a2,1004 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020306c:	25900593          	li	a1,601
ffffffffc0203070:	00004517          	auipc	a0,0x4
ffffffffc0203074:	86050513          	addi	a0,a0,-1952 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203078:	c16fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020307c:	fc5fe0ef          	jal	ra,ffffffffc0202040 <pa2page.part.0>
ffffffffc0203080:	fddfe0ef          	jal	ra,ffffffffc020205c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203084:	00004697          	auipc	a3,0x4
ffffffffc0203088:	a7468693          	addi	a3,a3,-1420 # ffffffffc0206af8 <default_pmm_manager+0x2f8>
ffffffffc020308c:	00003617          	auipc	a2,0x3
ffffffffc0203090:	3c460613          	addi	a2,a2,964 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203094:	22900593          	li	a1,553
ffffffffc0203098:	00004517          	auipc	a0,0x4
ffffffffc020309c:	83850513          	addi	a0,a0,-1992 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02030a0:	beefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02030a4:	00004697          	auipc	a3,0x4
ffffffffc02030a8:	99468693          	addi	a3,a3,-1644 # ffffffffc0206a38 <default_pmm_manager+0x238>
ffffffffc02030ac:	00003617          	auipc	a2,0x3
ffffffffc02030b0:	3a460613          	addi	a2,a2,932 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02030b4:	21c00593          	li	a1,540
ffffffffc02030b8:	00004517          	auipc	a0,0x4
ffffffffc02030bc:	81850513          	addi	a0,a0,-2024 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02030c0:	bcefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02030c4:	00004697          	auipc	a3,0x4
ffffffffc02030c8:	93468693          	addi	a3,a3,-1740 # ffffffffc02069f8 <default_pmm_manager+0x1f8>
ffffffffc02030cc:	00003617          	auipc	a2,0x3
ffffffffc02030d0:	38460613          	addi	a2,a2,900 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02030d4:	21b00593          	li	a1,539
ffffffffc02030d8:	00003517          	auipc	a0,0x3
ffffffffc02030dc:	7f850513          	addi	a0,a0,2040 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02030e0:	baefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02030e4:	00004697          	auipc	a3,0x4
ffffffffc02030e8:	8f468693          	addi	a3,a3,-1804 # ffffffffc02069d8 <default_pmm_manager+0x1d8>
ffffffffc02030ec:	00003617          	auipc	a2,0x3
ffffffffc02030f0:	36460613          	addi	a2,a2,868 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02030f4:	21a00593          	li	a1,538
ffffffffc02030f8:	00003517          	auipc	a0,0x3
ffffffffc02030fc:	7d850513          	addi	a0,a0,2008 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203100:	b8efd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0203104:	00003617          	auipc	a2,0x3
ffffffffc0203108:	2bc60613          	addi	a2,a2,700 # ffffffffc02063c0 <commands+0x830>
ffffffffc020310c:	07100593          	li	a1,113
ffffffffc0203110:	00003517          	auipc	a0,0x3
ffffffffc0203114:	26850513          	addi	a0,a0,616 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0203118:	b76fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc020311c:	00004697          	auipc	a3,0x4
ffffffffc0203120:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0206c88 <default_pmm_manager+0x488>
ffffffffc0203124:	00003617          	auipc	a2,0x3
ffffffffc0203128:	32c60613          	addi	a2,a2,812 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020312c:	24200593          	li	a1,578
ffffffffc0203130:	00003517          	auipc	a0,0x3
ffffffffc0203134:	7a050513          	addi	a0,a0,1952 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203138:	b56fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020313c:	00004697          	auipc	a3,0x4
ffffffffc0203140:	b0468693          	addi	a3,a3,-1276 # ffffffffc0206c40 <default_pmm_manager+0x440>
ffffffffc0203144:	00003617          	auipc	a2,0x3
ffffffffc0203148:	30c60613          	addi	a2,a2,780 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020314c:	24000593          	li	a1,576
ffffffffc0203150:	00003517          	auipc	a0,0x3
ffffffffc0203154:	78050513          	addi	a0,a0,1920 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203158:	b36fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc020315c:	00004697          	auipc	a3,0x4
ffffffffc0203160:	b1468693          	addi	a3,a3,-1260 # ffffffffc0206c70 <default_pmm_manager+0x470>
ffffffffc0203164:	00003617          	auipc	a2,0x3
ffffffffc0203168:	2ec60613          	addi	a2,a2,748 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020316c:	23f00593          	li	a1,575
ffffffffc0203170:	00003517          	auipc	a0,0x3
ffffffffc0203174:	76050513          	addi	a0,a0,1888 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203178:	b16fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc020317c:	00004697          	auipc	a3,0x4
ffffffffc0203180:	bdc68693          	addi	a3,a3,-1060 # ffffffffc0206d58 <default_pmm_manager+0x558>
ffffffffc0203184:	00003617          	auipc	a2,0x3
ffffffffc0203188:	2cc60613          	addi	a2,a2,716 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020318c:	25d00593          	li	a1,605
ffffffffc0203190:	00003517          	auipc	a0,0x3
ffffffffc0203194:	74050513          	addi	a0,a0,1856 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203198:	af6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020319c:	00004697          	auipc	a3,0x4
ffffffffc02031a0:	b1c68693          	addi	a3,a3,-1252 # ffffffffc0206cb8 <default_pmm_manager+0x4b8>
ffffffffc02031a4:	00003617          	auipc	a2,0x3
ffffffffc02031a8:	2ac60613          	addi	a2,a2,684 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02031ac:	24a00593          	li	a1,586
ffffffffc02031b0:	00003517          	auipc	a0,0x3
ffffffffc02031b4:	72050513          	addi	a0,a0,1824 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02031b8:	ad6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc02031bc:	00004697          	auipc	a3,0x4
ffffffffc02031c0:	bf468693          	addi	a3,a3,-1036 # ffffffffc0206db0 <default_pmm_manager+0x5b0>
ffffffffc02031c4:	00003617          	auipc	a2,0x3
ffffffffc02031c8:	28c60613          	addi	a2,a2,652 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02031cc:	26200593          	li	a1,610
ffffffffc02031d0:	00003517          	auipc	a0,0x3
ffffffffc02031d4:	70050513          	addi	a0,a0,1792 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02031d8:	ab6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02031dc:	00004697          	auipc	a3,0x4
ffffffffc02031e0:	b9468693          	addi	a3,a3,-1132 # ffffffffc0206d70 <default_pmm_manager+0x570>
ffffffffc02031e4:	00003617          	auipc	a2,0x3
ffffffffc02031e8:	26c60613          	addi	a2,a2,620 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02031ec:	26100593          	li	a1,609
ffffffffc02031f0:	00003517          	auipc	a0,0x3
ffffffffc02031f4:	6e050513          	addi	a0,a0,1760 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02031f8:	a96fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02031fc:	00004697          	auipc	a3,0x4
ffffffffc0203200:	a4468693          	addi	a3,a3,-1468 # ffffffffc0206c40 <default_pmm_manager+0x440>
ffffffffc0203204:	00003617          	auipc	a2,0x3
ffffffffc0203208:	24c60613          	addi	a2,a2,588 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020320c:	23c00593          	li	a1,572
ffffffffc0203210:	00003517          	auipc	a0,0x3
ffffffffc0203214:	6c050513          	addi	a0,a0,1728 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203218:	a76fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020321c:	00004697          	auipc	a3,0x4
ffffffffc0203220:	8c468693          	addi	a3,a3,-1852 # ffffffffc0206ae0 <default_pmm_manager+0x2e0>
ffffffffc0203224:	00003617          	auipc	a2,0x3
ffffffffc0203228:	22c60613          	addi	a2,a2,556 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020322c:	23b00593          	li	a1,571
ffffffffc0203230:	00003517          	auipc	a0,0x3
ffffffffc0203234:	6a050513          	addi	a0,a0,1696 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203238:	a56fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020323c:	00004697          	auipc	a3,0x4
ffffffffc0203240:	a1c68693          	addi	a3,a3,-1508 # ffffffffc0206c58 <default_pmm_manager+0x458>
ffffffffc0203244:	00003617          	auipc	a2,0x3
ffffffffc0203248:	20c60613          	addi	a2,a2,524 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020324c:	23800593          	li	a1,568
ffffffffc0203250:	00003517          	auipc	a0,0x3
ffffffffc0203254:	68050513          	addi	a0,a0,1664 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203258:	a36fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020325c:	00004697          	auipc	a3,0x4
ffffffffc0203260:	86c68693          	addi	a3,a3,-1940 # ffffffffc0206ac8 <default_pmm_manager+0x2c8>
ffffffffc0203264:	00003617          	auipc	a2,0x3
ffffffffc0203268:	1ec60613          	addi	a2,a2,492 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020326c:	23700593          	li	a1,567
ffffffffc0203270:	00003517          	auipc	a0,0x3
ffffffffc0203274:	66050513          	addi	a0,a0,1632 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203278:	a16fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020327c:	00004697          	auipc	a3,0x4
ffffffffc0203280:	8ec68693          	addi	a3,a3,-1812 # ffffffffc0206b68 <default_pmm_manager+0x368>
ffffffffc0203284:	00003617          	auipc	a2,0x3
ffffffffc0203288:	1cc60613          	addi	a2,a2,460 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020328c:	23600593          	li	a1,566
ffffffffc0203290:	00003517          	auipc	a0,0x3
ffffffffc0203294:	64050513          	addi	a0,a0,1600 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203298:	9f6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020329c:	00004697          	auipc	a3,0x4
ffffffffc02032a0:	9a468693          	addi	a3,a3,-1628 # ffffffffc0206c40 <default_pmm_manager+0x440>
ffffffffc02032a4:	00003617          	auipc	a2,0x3
ffffffffc02032a8:	1ac60613          	addi	a2,a2,428 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02032ac:	23500593          	li	a1,565
ffffffffc02032b0:	00003517          	auipc	a0,0x3
ffffffffc02032b4:	62050513          	addi	a0,a0,1568 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02032b8:	9d6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02032bc:	00004697          	auipc	a3,0x4
ffffffffc02032c0:	96c68693          	addi	a3,a3,-1684 # ffffffffc0206c28 <default_pmm_manager+0x428>
ffffffffc02032c4:	00003617          	auipc	a2,0x3
ffffffffc02032c8:	18c60613          	addi	a2,a2,396 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02032cc:	23400593          	li	a1,564
ffffffffc02032d0:	00003517          	auipc	a0,0x3
ffffffffc02032d4:	60050513          	addi	a0,a0,1536 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02032d8:	9b6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02032dc:	00004697          	auipc	a3,0x4
ffffffffc02032e0:	91c68693          	addi	a3,a3,-1764 # ffffffffc0206bf8 <default_pmm_manager+0x3f8>
ffffffffc02032e4:	00003617          	auipc	a2,0x3
ffffffffc02032e8:	16c60613          	addi	a2,a2,364 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02032ec:	23300593          	li	a1,563
ffffffffc02032f0:	00003517          	auipc	a0,0x3
ffffffffc02032f4:	5e050513          	addi	a0,a0,1504 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02032f8:	996fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02032fc:	00004697          	auipc	a3,0x4
ffffffffc0203300:	8e468693          	addi	a3,a3,-1820 # ffffffffc0206be0 <default_pmm_manager+0x3e0>
ffffffffc0203304:	00003617          	auipc	a2,0x3
ffffffffc0203308:	14c60613          	addi	a2,a2,332 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020330c:	23100593          	li	a1,561
ffffffffc0203310:	00003517          	auipc	a0,0x3
ffffffffc0203314:	5c050513          	addi	a0,a0,1472 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203318:	976fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020331c:	00004697          	auipc	a3,0x4
ffffffffc0203320:	8a468693          	addi	a3,a3,-1884 # ffffffffc0206bc0 <default_pmm_manager+0x3c0>
ffffffffc0203324:	00003617          	auipc	a2,0x3
ffffffffc0203328:	12c60613          	addi	a2,a2,300 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020332c:	23000593          	li	a1,560
ffffffffc0203330:	00003517          	auipc	a0,0x3
ffffffffc0203334:	5a050513          	addi	a0,a0,1440 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203338:	956fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc020333c:	00004697          	auipc	a3,0x4
ffffffffc0203340:	87468693          	addi	a3,a3,-1932 # ffffffffc0206bb0 <default_pmm_manager+0x3b0>
ffffffffc0203344:	00003617          	auipc	a2,0x3
ffffffffc0203348:	10c60613          	addi	a2,a2,268 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020334c:	22f00593          	li	a1,559
ffffffffc0203350:	00003517          	auipc	a0,0x3
ffffffffc0203354:	58050513          	addi	a0,a0,1408 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203358:	936fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc020335c:	00004697          	auipc	a3,0x4
ffffffffc0203360:	84468693          	addi	a3,a3,-1980 # ffffffffc0206ba0 <default_pmm_manager+0x3a0>
ffffffffc0203364:	00003617          	auipc	a2,0x3
ffffffffc0203368:	0ec60613          	addi	a2,a2,236 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020336c:	22e00593          	li	a1,558
ffffffffc0203370:	00003517          	auipc	a0,0x3
ffffffffc0203374:	56050513          	addi	a0,a0,1376 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203378:	916fd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc020337c:	00003617          	auipc	a2,0x3
ffffffffc0203380:	5c460613          	addi	a2,a2,1476 # ffffffffc0206940 <default_pmm_manager+0x140>
ffffffffc0203384:	06500593          	li	a1,101
ffffffffc0203388:	00003517          	auipc	a0,0x3
ffffffffc020338c:	54850513          	addi	a0,a0,1352 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203390:	8fefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203394:	00004697          	auipc	a3,0x4
ffffffffc0203398:	92468693          	addi	a3,a3,-1756 # ffffffffc0206cb8 <default_pmm_manager+0x4b8>
ffffffffc020339c:	00003617          	auipc	a2,0x3
ffffffffc02033a0:	0b460613          	addi	a2,a2,180 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02033a4:	27400593          	li	a1,628
ffffffffc02033a8:	00003517          	auipc	a0,0x3
ffffffffc02033ac:	52850513          	addi	a0,a0,1320 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02033b0:	8defd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02033b4:	00003697          	auipc	a3,0x3
ffffffffc02033b8:	7b468693          	addi	a3,a3,1972 # ffffffffc0206b68 <default_pmm_manager+0x368>
ffffffffc02033bc:	00003617          	auipc	a2,0x3
ffffffffc02033c0:	09460613          	addi	a2,a2,148 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02033c4:	22d00593          	li	a1,557
ffffffffc02033c8:	00003517          	auipc	a0,0x3
ffffffffc02033cc:	50850513          	addi	a0,a0,1288 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02033d0:	8befd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02033d4:	00003697          	auipc	a3,0x3
ffffffffc02033d8:	75468693          	addi	a3,a3,1876 # ffffffffc0206b28 <default_pmm_manager+0x328>
ffffffffc02033dc:	00003617          	auipc	a2,0x3
ffffffffc02033e0:	07460613          	addi	a2,a2,116 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02033e4:	22c00593          	li	a1,556
ffffffffc02033e8:	00003517          	auipc	a0,0x3
ffffffffc02033ec:	4e850513          	addi	a0,a0,1256 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02033f0:	89efd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02033f4:	86d6                	mv	a3,s5
ffffffffc02033f6:	00003617          	auipc	a2,0x3
ffffffffc02033fa:	fca60613          	addi	a2,a2,-54 # ffffffffc02063c0 <commands+0x830>
ffffffffc02033fe:	22800593          	li	a1,552
ffffffffc0203402:	00003517          	auipc	a0,0x3
ffffffffc0203406:	4ce50513          	addi	a0,a0,1230 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc020340a:	884fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020340e:	00003617          	auipc	a2,0x3
ffffffffc0203412:	fb260613          	addi	a2,a2,-78 # ffffffffc02063c0 <commands+0x830>
ffffffffc0203416:	22700593          	li	a1,551
ffffffffc020341a:	00003517          	auipc	a0,0x3
ffffffffc020341e:	4b650513          	addi	a0,a0,1206 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203422:	86cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203426:	00003697          	auipc	a3,0x3
ffffffffc020342a:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206ae0 <default_pmm_manager+0x2e0>
ffffffffc020342e:	00003617          	auipc	a2,0x3
ffffffffc0203432:	02260613          	addi	a2,a2,34 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203436:	22500593          	li	a1,549
ffffffffc020343a:	00003517          	auipc	a0,0x3
ffffffffc020343e:	49650513          	addi	a0,a0,1174 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203442:	84cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203446:	00003697          	auipc	a3,0x3
ffffffffc020344a:	68268693          	addi	a3,a3,1666 # ffffffffc0206ac8 <default_pmm_manager+0x2c8>
ffffffffc020344e:	00003617          	auipc	a2,0x3
ffffffffc0203452:	00260613          	addi	a2,a2,2 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203456:	22400593          	li	a1,548
ffffffffc020345a:	00003517          	auipc	a0,0x3
ffffffffc020345e:	47650513          	addi	a0,a0,1142 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203462:	82cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203466:	00004697          	auipc	a3,0x4
ffffffffc020346a:	a1268693          	addi	a3,a3,-1518 # ffffffffc0206e78 <default_pmm_manager+0x678>
ffffffffc020346e:	00003617          	auipc	a2,0x3
ffffffffc0203472:	fe260613          	addi	a2,a2,-30 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203476:	26b00593          	li	a1,619
ffffffffc020347a:	00003517          	auipc	a0,0x3
ffffffffc020347e:	45650513          	addi	a0,a0,1110 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203482:	80cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203486:	00004697          	auipc	a3,0x4
ffffffffc020348a:	9ba68693          	addi	a3,a3,-1606 # ffffffffc0206e40 <default_pmm_manager+0x640>
ffffffffc020348e:	00003617          	auipc	a2,0x3
ffffffffc0203492:	fc260613          	addi	a2,a2,-62 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203496:	26800593          	li	a1,616
ffffffffc020349a:	00003517          	auipc	a0,0x3
ffffffffc020349e:	43650513          	addi	a0,a0,1078 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02034a2:	fedfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02034a6:	00004697          	auipc	a3,0x4
ffffffffc02034aa:	96a68693          	addi	a3,a3,-1686 # ffffffffc0206e10 <default_pmm_manager+0x610>
ffffffffc02034ae:	00003617          	auipc	a2,0x3
ffffffffc02034b2:	fa260613          	addi	a2,a2,-94 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02034b6:	26400593          	li	a1,612
ffffffffc02034ba:	00003517          	auipc	a0,0x3
ffffffffc02034be:	41650513          	addi	a0,a0,1046 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02034c2:	fcdfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02034c6:	00004697          	auipc	a3,0x4
ffffffffc02034ca:	90268693          	addi	a3,a3,-1790 # ffffffffc0206dc8 <default_pmm_manager+0x5c8>
ffffffffc02034ce:	00003617          	auipc	a2,0x3
ffffffffc02034d2:	f8260613          	addi	a2,a2,-126 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02034d6:	26300593          	li	a1,611
ffffffffc02034da:	00003517          	auipc	a0,0x3
ffffffffc02034de:	3f650513          	addi	a0,a0,1014 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02034e2:	fadfc0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02034e6:	00003617          	auipc	a2,0x3
ffffffffc02034ea:	3c260613          	addi	a2,a2,962 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc02034ee:	0c900593          	li	a1,201
ffffffffc02034f2:	00003517          	auipc	a0,0x3
ffffffffc02034f6:	3de50513          	addi	a0,a0,990 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02034fa:	f95fc0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02034fe:	00003617          	auipc	a2,0x3
ffffffffc0203502:	3aa60613          	addi	a2,a2,938 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc0203506:	08100593          	li	a1,129
ffffffffc020350a:	00003517          	auipc	a0,0x3
ffffffffc020350e:	3c650513          	addi	a0,a0,966 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203512:	f7dfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203516:	00003697          	auipc	a3,0x3
ffffffffc020351a:	58268693          	addi	a3,a3,1410 # ffffffffc0206a98 <default_pmm_manager+0x298>
ffffffffc020351e:	00003617          	auipc	a2,0x3
ffffffffc0203522:	f3260613          	addi	a2,a2,-206 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203526:	22300593          	li	a1,547
ffffffffc020352a:	00003517          	auipc	a0,0x3
ffffffffc020352e:	3a650513          	addi	a0,a0,934 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203532:	f5dfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203536:	00003697          	auipc	a3,0x3
ffffffffc020353a:	53268693          	addi	a3,a3,1330 # ffffffffc0206a68 <default_pmm_manager+0x268>
ffffffffc020353e:	00003617          	auipc	a2,0x3
ffffffffc0203542:	f1260613          	addi	a2,a2,-238 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203546:	22000593          	li	a1,544
ffffffffc020354a:	00003517          	auipc	a0,0x3
ffffffffc020354e:	38650513          	addi	a0,a0,902 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc0203552:	f3dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203556 <copy_range>:
{
ffffffffc0203556:	7175                	addi	sp,sp,-144
ffffffffc0203558:	e122                	sd	s0,128(sp)
ffffffffc020355a:	8436                	mv	s0,a3
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020355c:	8ed1                	or	a3,a3,a2
{
ffffffffc020355e:	e506                	sd	ra,136(sp)
ffffffffc0203560:	fca6                	sd	s1,120(sp)
ffffffffc0203562:	f8ca                	sd	s2,112(sp)
ffffffffc0203564:	f4ce                	sd	s3,104(sp)
ffffffffc0203566:	f0d2                	sd	s4,96(sp)
ffffffffc0203568:	ecd6                	sd	s5,88(sp)
ffffffffc020356a:	e8da                	sd	s6,80(sp)
ffffffffc020356c:	e4de                	sd	s7,72(sp)
ffffffffc020356e:	e0e2                	sd	s8,64(sp)
ffffffffc0203570:	fc66                	sd	s9,56(sp)
ffffffffc0203572:	f86a                	sd	s10,48(sp)
ffffffffc0203574:	f46e                	sd	s11,40(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203576:	16d2                	slli	a3,a3,0x34
{
ffffffffc0203578:	e83a                	sd	a4,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020357a:	26069063          	bnez	a3,ffffffffc02037da <copy_range+0x284>
    assert(USER_ACCESS(start, end));
ffffffffc020357e:	00200737          	lui	a4,0x200
ffffffffc0203582:	8db2                	mv	s11,a2
ffffffffc0203584:	1ae66563          	bltu	a2,a4,ffffffffc020372e <copy_range+0x1d8>
ffffffffc0203588:	1a867363          	bgeu	a2,s0,ffffffffc020372e <copy_range+0x1d8>
ffffffffc020358c:	4705                	li	a4,1
ffffffffc020358e:	077e                	slli	a4,a4,0x1f
ffffffffc0203590:	18876f63          	bltu	a4,s0,ffffffffc020372e <copy_range+0x1d8>
ffffffffc0203594:	5cfd                	li	s9,-1
ffffffffc0203596:	00ccd793          	srli	a5,s9,0xc
ffffffffc020359a:	8a2a                	mv	s4,a0
ffffffffc020359c:	84ae                	mv	s1,a1
        start += PGSIZE;
ffffffffc020359e:	6905                	lui	s2,0x1
    if (PPN(pa) >= npage)
ffffffffc02035a0:	000d0b97          	auipc	s7,0xd0
ffffffffc02035a4:	d40b8b93          	addi	s7,s7,-704 # ffffffffc02d32e0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02035a8:	000d0b17          	auipc	s6,0xd0
ffffffffc02035ac:	d40b0b13          	addi	s6,s6,-704 # ffffffffc02d32e8 <pages>
    return KADDR(page2pa(page));
ffffffffc02035b0:	ec3e                	sd	a5,24(sp)
        page = pmm_manager->alloc_pages(n);
ffffffffc02035b2:	000d0c17          	auipc	s8,0xd0
ffffffffc02035b6:	d3ec0c13          	addi	s8,s8,-706 # ffffffffc02d32f0 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02035ba:	4601                	li	a2,0
ffffffffc02035bc:	85ee                	mv	a1,s11
ffffffffc02035be:	8526                	mv	a0,s1
ffffffffc02035c0:	b71fe0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc02035c4:	89aa                	mv	s3,a0
        if (ptep == NULL)
ffffffffc02035c6:	c169                	beqz	a0,ffffffffc0203688 <copy_range+0x132>
        if (*ptep & PTE_V)
ffffffffc02035c8:	6114                	ld	a3,0(a0)
ffffffffc02035ca:	8a85                	andi	a3,a3,1
ffffffffc02035cc:	e685                	bnez	a3,ffffffffc02035f4 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02035ce:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc02035d0:	fe8de5e3          	bltu	s11,s0,ffffffffc02035ba <copy_range+0x64>
    return 0;
ffffffffc02035d4:	4501                	li	a0,0
}
ffffffffc02035d6:	60aa                	ld	ra,136(sp)
ffffffffc02035d8:	640a                	ld	s0,128(sp)
ffffffffc02035da:	74e6                	ld	s1,120(sp)
ffffffffc02035dc:	7946                	ld	s2,112(sp)
ffffffffc02035de:	79a6                	ld	s3,104(sp)
ffffffffc02035e0:	7a06                	ld	s4,96(sp)
ffffffffc02035e2:	6ae6                	ld	s5,88(sp)
ffffffffc02035e4:	6b46                	ld	s6,80(sp)
ffffffffc02035e6:	6ba6                	ld	s7,72(sp)
ffffffffc02035e8:	6c06                	ld	s8,64(sp)
ffffffffc02035ea:	7ce2                	ld	s9,56(sp)
ffffffffc02035ec:	7d42                	ld	s10,48(sp)
ffffffffc02035ee:	7da2                	ld	s11,40(sp)
ffffffffc02035f0:	6149                	addi	sp,sp,144
ffffffffc02035f2:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02035f4:	4605                	li	a2,1
ffffffffc02035f6:	85ee                	mv	a1,s11
ffffffffc02035f8:	8552                	mv	a0,s4
ffffffffc02035fa:	b37fe0ef          	jal	ra,ffffffffc0202130 <get_pte>
ffffffffc02035fe:	10050a63          	beqz	a0,ffffffffc0203712 <copy_range+0x1bc>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203602:	0009b603          	ld	a2,0(s3)
ffffffffc0203606:	0006079b          	sext.w	a5,a2
    if (!(pte & PTE_V))
ffffffffc020360a:	00167593          	andi	a1,a2,1
ffffffffc020360e:	e43e                	sd	a5,8(sp)
ffffffffc0203610:	01f67a93          	andi	s5,a2,31
ffffffffc0203614:	10058163          	beqz	a1,ffffffffc0203716 <copy_range+0x1c0>
    if (PPN(pa) >= npage)
ffffffffc0203618:	000bb583          	ld	a1,0(s7)
    return pa2page(PTE_ADDR(pte));
ffffffffc020361c:	060a                	slli	a2,a2,0x2
ffffffffc020361e:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc0203620:	16b67763          	bgeu	a2,a1,ffffffffc020378e <copy_range+0x238>
    return &pages[PPN(pa) - nbase];
ffffffffc0203624:	000b3583          	ld	a1,0(s6)
ffffffffc0203628:	fff807b7          	lui	a5,0xfff80
ffffffffc020362c:	963e                	add	a2,a2,a5
ffffffffc020362e:	061a                	slli	a2,a2,0x6
ffffffffc0203630:	00c58d33          	add	s10,a1,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203634:	10002673          	csrr	a2,sstatus
ffffffffc0203638:	8a09                	andi	a2,a2,2
ffffffffc020363a:	e625                	bnez	a2,ffffffffc02036a2 <copy_range+0x14c>
        page = pmm_manager->alloc_pages(n);
ffffffffc020363c:	000c3603          	ld	a2,0(s8)
ffffffffc0203640:	4505                	li	a0,1
ffffffffc0203642:	6e10                	ld	a2,24(a2)
ffffffffc0203644:	9602                	jalr	a2
ffffffffc0203646:	8caa                	mv	s9,a0
            assert(page != NULL);
ffffffffc0203648:	120d0363          	beqz	s10,ffffffffc020376e <copy_range+0x218>
            assert(npage != NULL);
ffffffffc020364c:	100c8163          	beqz	s9,ffffffffc020374e <copy_range+0x1f8>
            if (share) {
ffffffffc0203650:	67c2                	ld	a5,16(sp)
ffffffffc0203652:	c3bd                	beqz	a5,ffffffffc02036b8 <copy_range+0x162>
                if (perm & PTE_W) {
ffffffffc0203654:	67a2                	ld	a5,8(sp)
ffffffffc0203656:	0047f613          	andi	a2,a5,4
ffffffffc020365a:	ce19                	beqz	a2,ffffffffc0203678 <copy_range+0x122>
                    *ptep = (*ptep & ~PTE_W) | PTE_COW;
ffffffffc020365c:	0009b603          	ld	a2,0(s3)
                    perm = (perm & ~PTE_W) | PTE_COW;
ffffffffc0203660:	01b7f693          	andi	a3,a5,27
ffffffffc0203664:	1006ea93          	ori	s5,a3,256
                    *ptep = (*ptep & ~PTE_W) | PTE_COW;
ffffffffc0203668:	efb67613          	andi	a2,a2,-261
ffffffffc020366c:	10066613          	ori	a2,a2,256
ffffffffc0203670:	00c9b023          	sd	a2,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203674:	120d8073          	sfence.vma	s11
                ret = page_insert(to, page, start, perm);
ffffffffc0203678:	866e                	mv	a2,s11
ffffffffc020367a:	86d6                	mv	a3,s5
ffffffffc020367c:	85ea                	mv	a1,s10
ffffffffc020367e:	8552                	mv	a0,s4
ffffffffc0203680:	9a0ff0ef          	jal	ra,ffffffffc0202820 <page_insert>
        start += PGSIZE;
ffffffffc0203684:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc0203686:	b7a9                	j	ffffffffc02035d0 <copy_range+0x7a>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203688:	00200637          	lui	a2,0x200
ffffffffc020368c:	00cd87b3          	add	a5,s11,a2
ffffffffc0203690:	ffe00637          	lui	a2,0xffe00
ffffffffc0203694:	00c7fdb3          	and	s11,a5,a2
    } while (start != 0 && start < end);
ffffffffc0203698:	f20d8ee3          	beqz	s11,ffffffffc02035d4 <copy_range+0x7e>
ffffffffc020369c:	f08defe3          	bltu	s11,s0,ffffffffc02035ba <copy_range+0x64>
ffffffffc02036a0:	bf15                	j	ffffffffc02035d4 <copy_range+0x7e>
        intr_disable();
ffffffffc02036a2:	b12fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02036a6:	000c3603          	ld	a2,0(s8)
ffffffffc02036aa:	4505                	li	a0,1
ffffffffc02036ac:	6e10                	ld	a2,24(a2)
ffffffffc02036ae:	9602                	jalr	a2
ffffffffc02036b0:	8caa                	mv	s9,a0
        intr_enable();
ffffffffc02036b2:	afcfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02036b6:	bf49                	j	ffffffffc0203648 <copy_range+0xf2>
    return page - pages + nbase;
ffffffffc02036b8:	000b3703          	ld	a4,0(s6)
    return KADDR(page2pa(page));
ffffffffc02036bc:	67e2                	ld	a5,24(sp)
    return page - pages + nbase;
ffffffffc02036be:	00080337          	lui	t1,0x80
ffffffffc02036c2:	40ed0633          	sub	a2,s10,a4
ffffffffc02036c6:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc02036c8:	000bb883          	ld	a7,0(s7)
    return page - pages + nbase;
ffffffffc02036cc:	961a                	add	a2,a2,t1
    return KADDR(page2pa(page));
ffffffffc02036ce:	00f675b3          	and	a1,a2,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02036d2:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc02036d4:	0f15f663          	bgeu	a1,a7,ffffffffc02037c0 <copy_range+0x26a>
ffffffffc02036d8:	000d0797          	auipc	a5,0xd0
ffffffffc02036dc:	c2078793          	addi	a5,a5,-992 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc02036e0:	6388                	ld	a0,0(a5)
    return page - pages + nbase;
ffffffffc02036e2:	40ec8733          	sub	a4,s9,a4
    return KADDR(page2pa(page));
ffffffffc02036e6:	67e2                	ld	a5,24(sp)
    return page - pages + nbase;
ffffffffc02036e8:	8719                	srai	a4,a4,0x6
ffffffffc02036ea:	971a                	add	a4,a4,t1
    return KADDR(page2pa(page));
ffffffffc02036ec:	00f77333          	and	t1,a4,a5
ffffffffc02036f0:	00a605b3          	add	a1,a2,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02036f4:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc02036f6:	0b137863          	bgeu	t1,a7,ffffffffc02037a6 <copy_range+0x250>
                memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02036fa:	6605                	lui	a2,0x1
ffffffffc02036fc:	953a                	add	a0,a0,a4
ffffffffc02036fe:	212020ef          	jal	ra,ffffffffc0205910 <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc0203702:	866e                	mv	a2,s11
ffffffffc0203704:	86d6                	mv	a3,s5
ffffffffc0203706:	85e6                	mv	a1,s9
ffffffffc0203708:	8552                	mv	a0,s4
ffffffffc020370a:	916ff0ef          	jal	ra,ffffffffc0202820 <page_insert>
        start += PGSIZE;
ffffffffc020370e:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc0203710:	b5c1                	j	ffffffffc02035d0 <copy_range+0x7a>
                return -E_NO_MEM;
ffffffffc0203712:	5571                	li	a0,-4
ffffffffc0203714:	b5c9                	j	ffffffffc02035d6 <copy_range+0x80>
        panic("pte2page called with invalid pte");
ffffffffc0203716:	00003617          	auipc	a2,0x3
ffffffffc020371a:	c3a60613          	addi	a2,a2,-966 # ffffffffc0206350 <commands+0x7c0>
ffffffffc020371e:	07f00593          	li	a1,127
ffffffffc0203722:	00003517          	auipc	a0,0x3
ffffffffc0203726:	c5650513          	addi	a0,a0,-938 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020372a:	d65fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020372e:	00003697          	auipc	a3,0x3
ffffffffc0203732:	1e268693          	addi	a3,a3,482 # ffffffffc0206910 <default_pmm_manager+0x110>
ffffffffc0203736:	00003617          	auipc	a2,0x3
ffffffffc020373a:	d1a60613          	addi	a2,a2,-742 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020373e:	17c00593          	li	a1,380
ffffffffc0203742:	00003517          	auipc	a0,0x3
ffffffffc0203746:	18e50513          	addi	a0,a0,398 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc020374a:	d45fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc020374e:	00003697          	auipc	a3,0x3
ffffffffc0203752:	78268693          	addi	a3,a3,1922 # ffffffffc0206ed0 <default_pmm_manager+0x6d0>
ffffffffc0203756:	00003617          	auipc	a2,0x3
ffffffffc020375a:	cfa60613          	addi	a2,a2,-774 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020375e:	19500593          	li	a1,405
ffffffffc0203762:	00003517          	auipc	a0,0x3
ffffffffc0203766:	16e50513          	addi	a0,a0,366 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc020376a:	d25fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc020376e:	00003697          	auipc	a3,0x3
ffffffffc0203772:	75268693          	addi	a3,a3,1874 # ffffffffc0206ec0 <default_pmm_manager+0x6c0>
ffffffffc0203776:	00003617          	auipc	a2,0x3
ffffffffc020377a:	cda60613          	addi	a2,a2,-806 # ffffffffc0206450 <commands+0x8c0>
ffffffffc020377e:	19400593          	li	a1,404
ffffffffc0203782:	00003517          	auipc	a0,0x3
ffffffffc0203786:	14e50513          	addi	a0,a0,334 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc020378a:	d05fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020378e:	00003617          	auipc	a2,0x3
ffffffffc0203792:	bfa60613          	addi	a2,a2,-1030 # ffffffffc0206388 <commands+0x7f8>
ffffffffc0203796:	06900593          	li	a1,105
ffffffffc020379a:	00003517          	auipc	a0,0x3
ffffffffc020379e:	bde50513          	addi	a0,a0,-1058 # ffffffffc0206378 <commands+0x7e8>
ffffffffc02037a2:	cedfc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02037a6:	86ba                	mv	a3,a4
ffffffffc02037a8:	00003617          	auipc	a2,0x3
ffffffffc02037ac:	c1860613          	addi	a2,a2,-1000 # ffffffffc02063c0 <commands+0x830>
ffffffffc02037b0:	07100593          	li	a1,113
ffffffffc02037b4:	00003517          	auipc	a0,0x3
ffffffffc02037b8:	bc450513          	addi	a0,a0,-1084 # ffffffffc0206378 <commands+0x7e8>
ffffffffc02037bc:	cd3fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02037c0:	86b2                	mv	a3,a2
ffffffffc02037c2:	07100593          	li	a1,113
ffffffffc02037c6:	00003617          	auipc	a2,0x3
ffffffffc02037ca:	bfa60613          	addi	a2,a2,-1030 # ffffffffc02063c0 <commands+0x830>
ffffffffc02037ce:	00003517          	auipc	a0,0x3
ffffffffc02037d2:	baa50513          	addi	a0,a0,-1110 # ffffffffc0206378 <commands+0x7e8>
ffffffffc02037d6:	cb9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02037da:	00003697          	auipc	a3,0x3
ffffffffc02037de:	10668693          	addi	a3,a3,262 # ffffffffc02068e0 <default_pmm_manager+0xe0>
ffffffffc02037e2:	00003617          	auipc	a2,0x3
ffffffffc02037e6:	c6e60613          	addi	a2,a2,-914 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02037ea:	17b00593          	li	a1,379
ffffffffc02037ee:	00003517          	auipc	a0,0x3
ffffffffc02037f2:	0e250513          	addi	a0,a0,226 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02037f6:	c99fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02037fa <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02037fa:	12058073          	sfence.vma	a1
}
ffffffffc02037fe:	8082                	ret

ffffffffc0203800 <pgdir_alloc_page>:
{
ffffffffc0203800:	7179                	addi	sp,sp,-48
ffffffffc0203802:	ec26                	sd	s1,24(sp)
ffffffffc0203804:	e84a                	sd	s2,16(sp)
ffffffffc0203806:	e052                	sd	s4,0(sp)
ffffffffc0203808:	f406                	sd	ra,40(sp)
ffffffffc020380a:	f022                	sd	s0,32(sp)
ffffffffc020380c:	e44e                	sd	s3,8(sp)
ffffffffc020380e:	8a2a                	mv	s4,a0
ffffffffc0203810:	84ae                	mv	s1,a1
ffffffffc0203812:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203814:	100027f3          	csrr	a5,sstatus
ffffffffc0203818:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc020381a:	000d0997          	auipc	s3,0xd0
ffffffffc020381e:	ad698993          	addi	s3,s3,-1322 # ffffffffc02d32f0 <pmm_manager>
ffffffffc0203822:	ef8d                	bnez	a5,ffffffffc020385c <pgdir_alloc_page+0x5c>
ffffffffc0203824:	0009b783          	ld	a5,0(s3)
ffffffffc0203828:	4505                	li	a0,1
ffffffffc020382a:	6f9c                	ld	a5,24(a5)
ffffffffc020382c:	9782                	jalr	a5
ffffffffc020382e:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203830:	cc09                	beqz	s0,ffffffffc020384a <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203832:	86ca                	mv	a3,s2
ffffffffc0203834:	8626                	mv	a2,s1
ffffffffc0203836:	85a2                	mv	a1,s0
ffffffffc0203838:	8552                	mv	a0,s4
ffffffffc020383a:	fe7fe0ef          	jal	ra,ffffffffc0202820 <page_insert>
ffffffffc020383e:	e915                	bnez	a0,ffffffffc0203872 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203840:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203842:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203844:	4785                	li	a5,1
ffffffffc0203846:	04f71e63          	bne	a4,a5,ffffffffc02038a2 <pgdir_alloc_page+0xa2>
}
ffffffffc020384a:	70a2                	ld	ra,40(sp)
ffffffffc020384c:	8522                	mv	a0,s0
ffffffffc020384e:	7402                	ld	s0,32(sp)
ffffffffc0203850:	64e2                	ld	s1,24(sp)
ffffffffc0203852:	6942                	ld	s2,16(sp)
ffffffffc0203854:	69a2                	ld	s3,8(sp)
ffffffffc0203856:	6a02                	ld	s4,0(sp)
ffffffffc0203858:	6145                	addi	sp,sp,48
ffffffffc020385a:	8082                	ret
        intr_disable();
ffffffffc020385c:	958fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203860:	0009b783          	ld	a5,0(s3)
ffffffffc0203864:	4505                	li	a0,1
ffffffffc0203866:	6f9c                	ld	a5,24(a5)
ffffffffc0203868:	9782                	jalr	a5
ffffffffc020386a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020386c:	942fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203870:	b7c1                	j	ffffffffc0203830 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203872:	100027f3          	csrr	a5,sstatus
ffffffffc0203876:	8b89                	andi	a5,a5,2
ffffffffc0203878:	eb89                	bnez	a5,ffffffffc020388a <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc020387a:	0009b783          	ld	a5,0(s3)
ffffffffc020387e:	8522                	mv	a0,s0
ffffffffc0203880:	4585                	li	a1,1
ffffffffc0203882:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203884:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203886:	9782                	jalr	a5
    if (flag)
ffffffffc0203888:	b7c9                	j	ffffffffc020384a <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc020388a:	92afd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020388e:	0009b783          	ld	a5,0(s3)
ffffffffc0203892:	8522                	mv	a0,s0
ffffffffc0203894:	4585                	li	a1,1
ffffffffc0203896:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203898:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020389a:	9782                	jalr	a5
        intr_enable();
ffffffffc020389c:	912fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02038a0:	b76d                	j	ffffffffc020384a <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02038a2:	00003697          	auipc	a3,0x3
ffffffffc02038a6:	63e68693          	addi	a3,a3,1598 # ffffffffc0206ee0 <default_pmm_manager+0x6e0>
ffffffffc02038aa:	00003617          	auipc	a2,0x3
ffffffffc02038ae:	ba660613          	addi	a2,a2,-1114 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02038b2:	20100593          	li	a1,513
ffffffffc02038b6:	00003517          	auipc	a0,0x3
ffffffffc02038ba:	01a50513          	addi	a0,a0,26 # ffffffffc02068d0 <default_pmm_manager+0xd0>
ffffffffc02038be:	bd1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038c2 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02038c2:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02038c4:	00003697          	auipc	a3,0x3
ffffffffc02038c8:	63468693          	addi	a3,a3,1588 # ffffffffc0206ef8 <default_pmm_manager+0x6f8>
ffffffffc02038cc:	00003617          	auipc	a2,0x3
ffffffffc02038d0:	b8460613          	addi	a2,a2,-1148 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02038d4:	07400593          	li	a1,116
ffffffffc02038d8:	00003517          	auipc	a0,0x3
ffffffffc02038dc:	64050513          	addi	a0,a0,1600 # ffffffffc0206f18 <default_pmm_manager+0x718>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02038e0:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02038e2:	badfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038e6 <mm_create>:
{
ffffffffc02038e6:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038e8:	04000513          	li	a0,64
{
ffffffffc02038ec:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038ee:	dacfe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
    if (mm != NULL)
ffffffffc02038f2:	cd19                	beqz	a0,ffffffffc0203910 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02038f4:	e508                	sd	a0,8(a0)
ffffffffc02038f6:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02038f8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02038fc:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203900:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203904:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203908:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc020390c:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203910:	60a2                	ld	ra,8(sp)
ffffffffc0203912:	0141                	addi	sp,sp,16
ffffffffc0203914:	8082                	ret

ffffffffc0203916 <find_vma>:
{
ffffffffc0203916:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203918:	c505                	beqz	a0,ffffffffc0203940 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc020391a:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020391c:	c501                	beqz	a0,ffffffffc0203924 <find_vma+0xe>
ffffffffc020391e:	651c                	ld	a5,8(a0)
ffffffffc0203920:	02f5f263          	bgeu	a1,a5,ffffffffc0203944 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203924:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203926:	00f68d63          	beq	a3,a5,ffffffffc0203940 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020392a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020392e:	00e5e663          	bltu	a1,a4,ffffffffc020393a <find_vma+0x24>
ffffffffc0203932:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203936:	00e5ec63          	bltu	a1,a4,ffffffffc020394e <find_vma+0x38>
ffffffffc020393a:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020393c:	fef697e3          	bne	a3,a5,ffffffffc020392a <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203940:	4501                	li	a0,0
}
ffffffffc0203942:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203944:	691c                	ld	a5,16(a0)
ffffffffc0203946:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203924 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020394a:	ea88                	sd	a0,16(a3)
ffffffffc020394c:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020394e:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203952:	ea88                	sd	a0,16(a3)
ffffffffc0203954:	8082                	ret

ffffffffc0203956 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203956:	6590                	ld	a2,8(a1)
ffffffffc0203958:	0105b803          	ld	a6,16(a1)
{
ffffffffc020395c:	1141                	addi	sp,sp,-16
ffffffffc020395e:	e406                	sd	ra,8(sp)
ffffffffc0203960:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203962:	01066763          	bltu	a2,a6,ffffffffc0203970 <insert_vma_struct+0x1a>
ffffffffc0203966:	a085                	j	ffffffffc02039c6 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203968:	fe87b703          	ld	a4,-24(a5)
ffffffffc020396c:	04e66863          	bltu	a2,a4,ffffffffc02039bc <insert_vma_struct+0x66>
ffffffffc0203970:	86be                	mv	a3,a5
ffffffffc0203972:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203974:	fef51ae3          	bne	a0,a5,ffffffffc0203968 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203978:	02a68463          	beq	a3,a0,ffffffffc02039a0 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020397c:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203980:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203984:	08e8f163          	bgeu	a7,a4,ffffffffc0203a06 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203988:	04e66f63          	bltu	a2,a4,ffffffffc02039e6 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020398c:	00f50a63          	beq	a0,a5,ffffffffc02039a0 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203990:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203994:	05076963          	bltu	a4,a6,ffffffffc02039e6 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203998:	ff07b603          	ld	a2,-16(a5)
ffffffffc020399c:	02c77363          	bgeu	a4,a2,ffffffffc02039c2 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02039a0:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02039a2:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02039a4:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02039a8:	e390                	sd	a2,0(a5)
ffffffffc02039aa:	e690                	sd	a2,8(a3)
}
ffffffffc02039ac:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02039ae:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02039b0:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02039b2:	0017079b          	addiw	a5,a4,1
ffffffffc02039b6:	d11c                	sw	a5,32(a0)
}
ffffffffc02039b8:	0141                	addi	sp,sp,16
ffffffffc02039ba:	8082                	ret
    if (le_prev != list)
ffffffffc02039bc:	fca690e3          	bne	a3,a0,ffffffffc020397c <insert_vma_struct+0x26>
ffffffffc02039c0:	bfd1                	j	ffffffffc0203994 <insert_vma_struct+0x3e>
ffffffffc02039c2:	f01ff0ef          	jal	ra,ffffffffc02038c2 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02039c6:	00003697          	auipc	a3,0x3
ffffffffc02039ca:	56268693          	addi	a3,a3,1378 # ffffffffc0206f28 <default_pmm_manager+0x728>
ffffffffc02039ce:	00003617          	auipc	a2,0x3
ffffffffc02039d2:	a8260613          	addi	a2,a2,-1406 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02039d6:	07a00593          	li	a1,122
ffffffffc02039da:	00003517          	auipc	a0,0x3
ffffffffc02039de:	53e50513          	addi	a0,a0,1342 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc02039e2:	aadfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039e6:	00003697          	auipc	a3,0x3
ffffffffc02039ea:	58268693          	addi	a3,a3,1410 # ffffffffc0206f68 <default_pmm_manager+0x768>
ffffffffc02039ee:	00003617          	auipc	a2,0x3
ffffffffc02039f2:	a6260613          	addi	a2,a2,-1438 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02039f6:	07300593          	li	a1,115
ffffffffc02039fa:	00003517          	auipc	a0,0x3
ffffffffc02039fe:	51e50513          	addi	a0,a0,1310 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203a02:	a8dfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203a06:	00003697          	auipc	a3,0x3
ffffffffc0203a0a:	54268693          	addi	a3,a3,1346 # ffffffffc0206f48 <default_pmm_manager+0x748>
ffffffffc0203a0e:	00003617          	auipc	a2,0x3
ffffffffc0203a12:	a4260613          	addi	a2,a2,-1470 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203a16:	07200593          	li	a1,114
ffffffffc0203a1a:	00003517          	auipc	a0,0x3
ffffffffc0203a1e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203a22:	a6dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a26 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203a26:	591c                	lw	a5,48(a0)
{
ffffffffc0203a28:	1141                	addi	sp,sp,-16
ffffffffc0203a2a:	e406                	sd	ra,8(sp)
ffffffffc0203a2c:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203a2e:	e78d                	bnez	a5,ffffffffc0203a58 <mm_destroy+0x32>
ffffffffc0203a30:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203a32:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203a34:	00a40c63          	beq	s0,a0,ffffffffc0203a4c <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203a38:	6118                	ld	a4,0(a0)
ffffffffc0203a3a:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203a3c:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203a3e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203a40:	e398                	sd	a4,0(a5)
ffffffffc0203a42:	d08fe0ef          	jal	ra,ffffffffc0201f4a <kfree>
    return listelm->next;
ffffffffc0203a46:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203a48:	fea418e3          	bne	s0,a0,ffffffffc0203a38 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203a4c:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203a4e:	6402                	ld	s0,0(sp)
ffffffffc0203a50:	60a2                	ld	ra,8(sp)
ffffffffc0203a52:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203a54:	cf6fe06f          	j	ffffffffc0201f4a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203a58:	00003697          	auipc	a3,0x3
ffffffffc0203a5c:	53068693          	addi	a3,a3,1328 # ffffffffc0206f88 <default_pmm_manager+0x788>
ffffffffc0203a60:	00003617          	auipc	a2,0x3
ffffffffc0203a64:	9f060613          	addi	a2,a2,-1552 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203a68:	09e00593          	li	a1,158
ffffffffc0203a6c:	00003517          	auipc	a0,0x3
ffffffffc0203a70:	4ac50513          	addi	a0,a0,1196 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203a74:	a1bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a78 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203a78:	7139                	addi	sp,sp,-64
ffffffffc0203a7a:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a7c:	6405                	lui	s0,0x1
ffffffffc0203a7e:	147d                	addi	s0,s0,-1
ffffffffc0203a80:	77fd                	lui	a5,0xfffff
ffffffffc0203a82:	9622                	add	a2,a2,s0
ffffffffc0203a84:	962e                	add	a2,a2,a1
{
ffffffffc0203a86:	f426                	sd	s1,40(sp)
ffffffffc0203a88:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a8a:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203a8e:	f04a                	sd	s2,32(sp)
ffffffffc0203a90:	ec4e                	sd	s3,24(sp)
ffffffffc0203a92:	e852                	sd	s4,16(sp)
ffffffffc0203a94:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203a96:	002005b7          	lui	a1,0x200
ffffffffc0203a9a:	00f67433          	and	s0,a2,a5
ffffffffc0203a9e:	06b4e363          	bltu	s1,a1,ffffffffc0203b04 <mm_map+0x8c>
ffffffffc0203aa2:	0684f163          	bgeu	s1,s0,ffffffffc0203b04 <mm_map+0x8c>
ffffffffc0203aa6:	4785                	li	a5,1
ffffffffc0203aa8:	07fe                	slli	a5,a5,0x1f
ffffffffc0203aaa:	0487ed63          	bltu	a5,s0,ffffffffc0203b04 <mm_map+0x8c>
ffffffffc0203aae:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203ab0:	cd21                	beqz	a0,ffffffffc0203b08 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203ab2:	85a6                	mv	a1,s1
ffffffffc0203ab4:	8ab6                	mv	s5,a3
ffffffffc0203ab6:	8a3a                	mv	s4,a4
ffffffffc0203ab8:	e5fff0ef          	jal	ra,ffffffffc0203916 <find_vma>
ffffffffc0203abc:	c501                	beqz	a0,ffffffffc0203ac4 <mm_map+0x4c>
ffffffffc0203abe:	651c                	ld	a5,8(a0)
ffffffffc0203ac0:	0487e263          	bltu	a5,s0,ffffffffc0203b04 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ac4:	03000513          	li	a0,48
ffffffffc0203ac8:	bd2fe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
ffffffffc0203acc:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203ace:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203ad0:	02090163          	beqz	s2,ffffffffc0203af2 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203ad4:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203ad6:	00993423          	sd	s1,8(s2) # 1008 <_binary_obj___user_faultread_out_size-0x8bb0>
        vma->vm_end = vm_end;
ffffffffc0203ada:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203ade:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203ae2:	85ca                	mv	a1,s2
ffffffffc0203ae4:	e73ff0ef          	jal	ra,ffffffffc0203956 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203ae8:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203aea:	000a0463          	beqz	s4,ffffffffc0203af2 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203aee:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0203af2:	70e2                	ld	ra,56(sp)
ffffffffc0203af4:	7442                	ld	s0,48(sp)
ffffffffc0203af6:	74a2                	ld	s1,40(sp)
ffffffffc0203af8:	7902                	ld	s2,32(sp)
ffffffffc0203afa:	69e2                	ld	s3,24(sp)
ffffffffc0203afc:	6a42                	ld	s4,16(sp)
ffffffffc0203afe:	6aa2                	ld	s5,8(sp)
ffffffffc0203b00:	6121                	addi	sp,sp,64
ffffffffc0203b02:	8082                	ret
        return -E_INVAL;
ffffffffc0203b04:	5575                	li	a0,-3
ffffffffc0203b06:	b7f5                	j	ffffffffc0203af2 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203b08:	00003697          	auipc	a3,0x3
ffffffffc0203b0c:	49868693          	addi	a3,a3,1176 # ffffffffc0206fa0 <default_pmm_manager+0x7a0>
ffffffffc0203b10:	00003617          	auipc	a2,0x3
ffffffffc0203b14:	94060613          	addi	a2,a2,-1728 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203b18:	0b300593          	li	a1,179
ffffffffc0203b1c:	00003517          	auipc	a0,0x3
ffffffffc0203b20:	3fc50513          	addi	a0,a0,1020 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203b24:	96bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b28 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203b28:	7139                	addi	sp,sp,-64
ffffffffc0203b2a:	fc06                	sd	ra,56(sp)
ffffffffc0203b2c:	f822                	sd	s0,48(sp)
ffffffffc0203b2e:	f426                	sd	s1,40(sp)
ffffffffc0203b30:	f04a                	sd	s2,32(sp)
ffffffffc0203b32:	ec4e                	sd	s3,24(sp)
ffffffffc0203b34:	e852                	sd	s4,16(sp)
ffffffffc0203b36:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203b38:	c52d                	beqz	a0,ffffffffc0203ba2 <dup_mmap+0x7a>
ffffffffc0203b3a:	892a                	mv	s2,a0
ffffffffc0203b3c:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203b3e:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203b40:	e595                	bnez	a1,ffffffffc0203b6c <dup_mmap+0x44>
ffffffffc0203b42:	a085                	j	ffffffffc0203ba2 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203b44:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203b46:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ed8>
        vma->vm_end = vm_end;
ffffffffc0203b4a:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203b4e:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203b52:	e05ff0ef          	jal	ra,ffffffffc0203956 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203b56:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc8>
ffffffffc0203b5a:	fe843603          	ld	a2,-24(s0)
ffffffffc0203b5e:	6c8c                	ld	a1,24(s1)
ffffffffc0203b60:	01893503          	ld	a0,24(s2)
ffffffffc0203b64:	4701                	li	a4,0
ffffffffc0203b66:	9f1ff0ef          	jal	ra,ffffffffc0203556 <copy_range>
ffffffffc0203b6a:	e105                	bnez	a0,ffffffffc0203b8a <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203b6c:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203b6e:	02848863          	beq	s1,s0,ffffffffc0203b9e <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b72:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203b76:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203b7a:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203b7e:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b82:	b18fe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
ffffffffc0203b86:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203b88:	fd55                	bnez	a0,ffffffffc0203b44 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203b8a:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203b8c:	70e2                	ld	ra,56(sp)
ffffffffc0203b8e:	7442                	ld	s0,48(sp)
ffffffffc0203b90:	74a2                	ld	s1,40(sp)
ffffffffc0203b92:	7902                	ld	s2,32(sp)
ffffffffc0203b94:	69e2                	ld	s3,24(sp)
ffffffffc0203b96:	6a42                	ld	s4,16(sp)
ffffffffc0203b98:	6aa2                	ld	s5,8(sp)
ffffffffc0203b9a:	6121                	addi	sp,sp,64
ffffffffc0203b9c:	8082                	ret
    return 0;
ffffffffc0203b9e:	4501                	li	a0,0
ffffffffc0203ba0:	b7f5                	j	ffffffffc0203b8c <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203ba2:	00003697          	auipc	a3,0x3
ffffffffc0203ba6:	40e68693          	addi	a3,a3,1038 # ffffffffc0206fb0 <default_pmm_manager+0x7b0>
ffffffffc0203baa:	00003617          	auipc	a2,0x3
ffffffffc0203bae:	8a660613          	addi	a2,a2,-1882 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203bb2:	0cf00593          	li	a1,207
ffffffffc0203bb6:	00003517          	auipc	a0,0x3
ffffffffc0203bba:	36250513          	addi	a0,a0,866 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203bbe:	8d1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203bc2 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203bc2:	1101                	addi	sp,sp,-32
ffffffffc0203bc4:	ec06                	sd	ra,24(sp)
ffffffffc0203bc6:	e822                	sd	s0,16(sp)
ffffffffc0203bc8:	e426                	sd	s1,8(sp)
ffffffffc0203bca:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203bcc:	c531                	beqz	a0,ffffffffc0203c18 <exit_mmap+0x56>
ffffffffc0203bce:	591c                	lw	a5,48(a0)
ffffffffc0203bd0:	84aa                	mv	s1,a0
ffffffffc0203bd2:	e3b9                	bnez	a5,ffffffffc0203c18 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203bd4:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203bd6:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203bda:	02850663          	beq	a0,s0,ffffffffc0203c06 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bde:	ff043603          	ld	a2,-16(s0)
ffffffffc0203be2:	fe843583          	ld	a1,-24(s0)
ffffffffc0203be6:	854a                	mv	a0,s2
ffffffffc0203be8:	fc4fe0ef          	jal	ra,ffffffffc02023ac <unmap_range>
ffffffffc0203bec:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203bee:	fe8498e3          	bne	s1,s0,ffffffffc0203bde <exit_mmap+0x1c>
ffffffffc0203bf2:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203bf4:	00848c63          	beq	s1,s0,ffffffffc0203c0c <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bf8:	ff043603          	ld	a2,-16(s0)
ffffffffc0203bfc:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c00:	854a                	mv	a0,s2
ffffffffc0203c02:	8f1fe0ef          	jal	ra,ffffffffc02024f2 <exit_range>
ffffffffc0203c06:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203c08:	fe8498e3          	bne	s1,s0,ffffffffc0203bf8 <exit_mmap+0x36>
    }
}
ffffffffc0203c0c:	60e2                	ld	ra,24(sp)
ffffffffc0203c0e:	6442                	ld	s0,16(sp)
ffffffffc0203c10:	64a2                	ld	s1,8(sp)
ffffffffc0203c12:	6902                	ld	s2,0(sp)
ffffffffc0203c14:	6105                	addi	sp,sp,32
ffffffffc0203c16:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203c18:	00003697          	auipc	a3,0x3
ffffffffc0203c1c:	3b868693          	addi	a3,a3,952 # ffffffffc0206fd0 <default_pmm_manager+0x7d0>
ffffffffc0203c20:	00003617          	auipc	a2,0x3
ffffffffc0203c24:	83060613          	addi	a2,a2,-2000 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203c28:	0e800593          	li	a1,232
ffffffffc0203c2c:	00003517          	auipc	a0,0x3
ffffffffc0203c30:	2ec50513          	addi	a0,a0,748 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203c34:	85bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c38 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203c38:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c3a:	04000513          	li	a0,64
{
ffffffffc0203c3e:	fc06                	sd	ra,56(sp)
ffffffffc0203c40:	f822                	sd	s0,48(sp)
ffffffffc0203c42:	f426                	sd	s1,40(sp)
ffffffffc0203c44:	f04a                	sd	s2,32(sp)
ffffffffc0203c46:	ec4e                	sd	s3,24(sp)
ffffffffc0203c48:	e852                	sd	s4,16(sp)
ffffffffc0203c4a:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c4c:	a4efe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
    if (mm != NULL)
ffffffffc0203c50:	2e050663          	beqz	a0,ffffffffc0203f3c <vmm_init+0x304>
ffffffffc0203c54:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203c56:	e508                	sd	a0,8(a0)
ffffffffc0203c58:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203c5a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203c5e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203c62:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203c66:	02053423          	sd	zero,40(a0)
ffffffffc0203c6a:	02052823          	sw	zero,48(a0)
ffffffffc0203c6e:	02053c23          	sd	zero,56(a0)
ffffffffc0203c72:	03200413          	li	s0,50
ffffffffc0203c76:	a811                	j	ffffffffc0203c8a <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203c78:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203c7a:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203c7c:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203c80:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203c82:	8526                	mv	a0,s1
ffffffffc0203c84:	cd3ff0ef          	jal	ra,ffffffffc0203956 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203c88:	c80d                	beqz	s0,ffffffffc0203cba <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c8a:	03000513          	li	a0,48
ffffffffc0203c8e:	a0cfe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
ffffffffc0203c92:	85aa                	mv	a1,a0
ffffffffc0203c94:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203c98:	f165                	bnez	a0,ffffffffc0203c78 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203c9a:	00003697          	auipc	a3,0x3
ffffffffc0203c9e:	4ce68693          	addi	a3,a3,1230 # ffffffffc0207168 <default_pmm_manager+0x968>
ffffffffc0203ca2:	00002617          	auipc	a2,0x2
ffffffffc0203ca6:	7ae60613          	addi	a2,a2,1966 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203caa:	12c00593          	li	a1,300
ffffffffc0203cae:	00003517          	auipc	a0,0x3
ffffffffc0203cb2:	26a50513          	addi	a0,a0,618 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203cb6:	fd8fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203cba:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cbe:	1f900913          	li	s2,505
ffffffffc0203cc2:	a819                	j	ffffffffc0203cd8 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203cc4:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203cc6:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203cc8:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ccc:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203cce:	8526                	mv	a0,s1
ffffffffc0203cd0:	c87ff0ef          	jal	ra,ffffffffc0203956 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cd4:	03240a63          	beq	s0,s2,ffffffffc0203d08 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203cd8:	03000513          	li	a0,48
ffffffffc0203cdc:	9befe0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
ffffffffc0203ce0:	85aa                	mv	a1,a0
ffffffffc0203ce2:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203ce6:	fd79                	bnez	a0,ffffffffc0203cc4 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203ce8:	00003697          	auipc	a3,0x3
ffffffffc0203cec:	48068693          	addi	a3,a3,1152 # ffffffffc0207168 <default_pmm_manager+0x968>
ffffffffc0203cf0:	00002617          	auipc	a2,0x2
ffffffffc0203cf4:	76060613          	addi	a2,a2,1888 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203cf8:	13300593          	li	a1,307
ffffffffc0203cfc:	00003517          	auipc	a0,0x3
ffffffffc0203d00:	21c50513          	addi	a0,a0,540 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203d04:	f8afc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203d08:	649c                	ld	a5,8(s1)
ffffffffc0203d0a:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203d0c:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203d10:	16f48663          	beq	s1,a5,ffffffffc0203e7c <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203d14:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd2bccc>
ffffffffc0203d18:	ffe70693          	addi	a3,a4,-2 # 1ffffe <_binary_obj___user_exit_out_size+0x1f4ece>
ffffffffc0203d1c:	10d61063          	bne	a2,a3,ffffffffc0203e1c <vmm_init+0x1e4>
ffffffffc0203d20:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203d24:	0ed71c63          	bne	a4,a3,ffffffffc0203e1c <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203d28:	0715                	addi	a4,a4,5
ffffffffc0203d2a:	679c                	ld	a5,8(a5)
ffffffffc0203d2c:	feb712e3          	bne	a4,a1,ffffffffc0203d10 <vmm_init+0xd8>
ffffffffc0203d30:	4a1d                	li	s4,7
ffffffffc0203d32:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d34:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203d38:	85a2                	mv	a1,s0
ffffffffc0203d3a:	8526                	mv	a0,s1
ffffffffc0203d3c:	bdbff0ef          	jal	ra,ffffffffc0203916 <find_vma>
ffffffffc0203d40:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203d42:	16050d63          	beqz	a0,ffffffffc0203ebc <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203d46:	00140593          	addi	a1,s0,1
ffffffffc0203d4a:	8526                	mv	a0,s1
ffffffffc0203d4c:	bcbff0ef          	jal	ra,ffffffffc0203916 <find_vma>
ffffffffc0203d50:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203d52:	14050563          	beqz	a0,ffffffffc0203e9c <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203d56:	85d2                	mv	a1,s4
ffffffffc0203d58:	8526                	mv	a0,s1
ffffffffc0203d5a:	bbdff0ef          	jal	ra,ffffffffc0203916 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203d5e:	16051f63          	bnez	a0,ffffffffc0203edc <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203d62:	00340593          	addi	a1,s0,3
ffffffffc0203d66:	8526                	mv	a0,s1
ffffffffc0203d68:	bafff0ef          	jal	ra,ffffffffc0203916 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203d6c:	1a051863          	bnez	a0,ffffffffc0203f1c <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203d70:	00440593          	addi	a1,s0,4
ffffffffc0203d74:	8526                	mv	a0,s1
ffffffffc0203d76:	ba1ff0ef          	jal	ra,ffffffffc0203916 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203d7a:	18051163          	bnez	a0,ffffffffc0203efc <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d7e:	00893783          	ld	a5,8(s2)
ffffffffc0203d82:	0a879d63          	bne	a5,s0,ffffffffc0203e3c <vmm_init+0x204>
ffffffffc0203d86:	01093783          	ld	a5,16(s2)
ffffffffc0203d8a:	0b479963          	bne	a5,s4,ffffffffc0203e3c <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203d8e:	0089b783          	ld	a5,8(s3)
ffffffffc0203d92:	0c879563          	bne	a5,s0,ffffffffc0203e5c <vmm_init+0x224>
ffffffffc0203d96:	0109b783          	ld	a5,16(s3)
ffffffffc0203d9a:	0d479163          	bne	a5,s4,ffffffffc0203e5c <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d9e:	0415                	addi	s0,s0,5
ffffffffc0203da0:	0a15                	addi	s4,s4,5
ffffffffc0203da2:	f9541be3          	bne	s0,s5,ffffffffc0203d38 <vmm_init+0x100>
ffffffffc0203da6:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203da8:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203daa:	85a2                	mv	a1,s0
ffffffffc0203dac:	8526                	mv	a0,s1
ffffffffc0203dae:	b69ff0ef          	jal	ra,ffffffffc0203916 <find_vma>
ffffffffc0203db2:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203db6:	c90d                	beqz	a0,ffffffffc0203de8 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203db8:	6914                	ld	a3,16(a0)
ffffffffc0203dba:	6510                	ld	a2,8(a0)
ffffffffc0203dbc:	00003517          	auipc	a0,0x3
ffffffffc0203dc0:	33450513          	addi	a0,a0,820 # ffffffffc02070f0 <default_pmm_manager+0x8f0>
ffffffffc0203dc4:	bd0fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203dc8:	00003697          	auipc	a3,0x3
ffffffffc0203dcc:	35068693          	addi	a3,a3,848 # ffffffffc0207118 <default_pmm_manager+0x918>
ffffffffc0203dd0:	00002617          	auipc	a2,0x2
ffffffffc0203dd4:	68060613          	addi	a2,a2,1664 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203dd8:	15900593          	li	a1,345
ffffffffc0203ddc:	00003517          	auipc	a0,0x3
ffffffffc0203de0:	13c50513          	addi	a0,a0,316 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203de4:	eaafc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203de8:	147d                	addi	s0,s0,-1
ffffffffc0203dea:	fd2410e3          	bne	s0,s2,ffffffffc0203daa <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203dee:	8526                	mv	a0,s1
ffffffffc0203df0:	c37ff0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203df4:	00003517          	auipc	a0,0x3
ffffffffc0203df8:	33c50513          	addi	a0,a0,828 # ffffffffc0207130 <default_pmm_manager+0x930>
ffffffffc0203dfc:	b98fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203e00:	7442                	ld	s0,48(sp)
ffffffffc0203e02:	70e2                	ld	ra,56(sp)
ffffffffc0203e04:	74a2                	ld	s1,40(sp)
ffffffffc0203e06:	7902                	ld	s2,32(sp)
ffffffffc0203e08:	69e2                	ld	s3,24(sp)
ffffffffc0203e0a:	6a42                	ld	s4,16(sp)
ffffffffc0203e0c:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e0e:	00003517          	auipc	a0,0x3
ffffffffc0203e12:	34250513          	addi	a0,a0,834 # ffffffffc0207150 <default_pmm_manager+0x950>
}
ffffffffc0203e16:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e18:	b7cfc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203e1c:	00003697          	auipc	a3,0x3
ffffffffc0203e20:	1ec68693          	addi	a3,a3,492 # ffffffffc0207008 <default_pmm_manager+0x808>
ffffffffc0203e24:	00002617          	auipc	a2,0x2
ffffffffc0203e28:	62c60613          	addi	a2,a2,1580 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203e2c:	13d00593          	li	a1,317
ffffffffc0203e30:	00003517          	auipc	a0,0x3
ffffffffc0203e34:	0e850513          	addi	a0,a0,232 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203e38:	e56fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203e3c:	00003697          	auipc	a3,0x3
ffffffffc0203e40:	25468693          	addi	a3,a3,596 # ffffffffc0207090 <default_pmm_manager+0x890>
ffffffffc0203e44:	00002617          	auipc	a2,0x2
ffffffffc0203e48:	60c60613          	addi	a2,a2,1548 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203e4c:	14e00593          	li	a1,334
ffffffffc0203e50:	00003517          	auipc	a0,0x3
ffffffffc0203e54:	0c850513          	addi	a0,a0,200 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203e58:	e36fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203e5c:	00003697          	auipc	a3,0x3
ffffffffc0203e60:	26468693          	addi	a3,a3,612 # ffffffffc02070c0 <default_pmm_manager+0x8c0>
ffffffffc0203e64:	00002617          	auipc	a2,0x2
ffffffffc0203e68:	5ec60613          	addi	a2,a2,1516 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203e6c:	14f00593          	li	a1,335
ffffffffc0203e70:	00003517          	auipc	a0,0x3
ffffffffc0203e74:	0a850513          	addi	a0,a0,168 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203e78:	e16fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203e7c:	00003697          	auipc	a3,0x3
ffffffffc0203e80:	17468693          	addi	a3,a3,372 # ffffffffc0206ff0 <default_pmm_manager+0x7f0>
ffffffffc0203e84:	00002617          	auipc	a2,0x2
ffffffffc0203e88:	5cc60613          	addi	a2,a2,1484 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203e8c:	13b00593          	li	a1,315
ffffffffc0203e90:	00003517          	auipc	a0,0x3
ffffffffc0203e94:	08850513          	addi	a0,a0,136 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203e98:	df6fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203e9c:	00003697          	auipc	a3,0x3
ffffffffc0203ea0:	1b468693          	addi	a3,a3,436 # ffffffffc0207050 <default_pmm_manager+0x850>
ffffffffc0203ea4:	00002617          	auipc	a2,0x2
ffffffffc0203ea8:	5ac60613          	addi	a2,a2,1452 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203eac:	14600593          	li	a1,326
ffffffffc0203eb0:	00003517          	auipc	a0,0x3
ffffffffc0203eb4:	06850513          	addi	a0,a0,104 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203eb8:	dd6fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203ebc:	00003697          	auipc	a3,0x3
ffffffffc0203ec0:	18468693          	addi	a3,a3,388 # ffffffffc0207040 <default_pmm_manager+0x840>
ffffffffc0203ec4:	00002617          	auipc	a2,0x2
ffffffffc0203ec8:	58c60613          	addi	a2,a2,1420 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203ecc:	14400593          	li	a1,324
ffffffffc0203ed0:	00003517          	auipc	a0,0x3
ffffffffc0203ed4:	04850513          	addi	a0,a0,72 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203ed8:	db6fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203edc:	00003697          	auipc	a3,0x3
ffffffffc0203ee0:	18468693          	addi	a3,a3,388 # ffffffffc0207060 <default_pmm_manager+0x860>
ffffffffc0203ee4:	00002617          	auipc	a2,0x2
ffffffffc0203ee8:	56c60613          	addi	a2,a2,1388 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203eec:	14800593          	li	a1,328
ffffffffc0203ef0:	00003517          	auipc	a0,0x3
ffffffffc0203ef4:	02850513          	addi	a0,a0,40 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203ef8:	d96fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203efc:	00003697          	auipc	a3,0x3
ffffffffc0203f00:	18468693          	addi	a3,a3,388 # ffffffffc0207080 <default_pmm_manager+0x880>
ffffffffc0203f04:	00002617          	auipc	a2,0x2
ffffffffc0203f08:	54c60613          	addi	a2,a2,1356 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203f0c:	14c00593          	li	a1,332
ffffffffc0203f10:	00003517          	auipc	a0,0x3
ffffffffc0203f14:	00850513          	addi	a0,a0,8 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203f18:	d76fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203f1c:	00003697          	auipc	a3,0x3
ffffffffc0203f20:	15468693          	addi	a3,a3,340 # ffffffffc0207070 <default_pmm_manager+0x870>
ffffffffc0203f24:	00002617          	auipc	a2,0x2
ffffffffc0203f28:	52c60613          	addi	a2,a2,1324 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203f2c:	14a00593          	li	a1,330
ffffffffc0203f30:	00003517          	auipc	a0,0x3
ffffffffc0203f34:	fe850513          	addi	a0,a0,-24 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203f38:	d56fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203f3c:	00003697          	auipc	a3,0x3
ffffffffc0203f40:	06468693          	addi	a3,a3,100 # ffffffffc0206fa0 <default_pmm_manager+0x7a0>
ffffffffc0203f44:	00002617          	auipc	a2,0x2
ffffffffc0203f48:	50c60613          	addi	a2,a2,1292 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0203f4c:	12400593          	li	a1,292
ffffffffc0203f50:	00003517          	auipc	a0,0x3
ffffffffc0203f54:	fc850513          	addi	a0,a0,-56 # ffffffffc0206f18 <default_pmm_manager+0x718>
ffffffffc0203f58:	d36fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f5c <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203f5c:	7179                	addi	sp,sp,-48
ffffffffc0203f5e:	f022                	sd	s0,32(sp)
ffffffffc0203f60:	f406                	sd	ra,40(sp)
ffffffffc0203f62:	ec26                	sd	s1,24(sp)
ffffffffc0203f64:	e84a                	sd	s2,16(sp)
ffffffffc0203f66:	e44e                	sd	s3,8(sp)
ffffffffc0203f68:	e052                	sd	s4,0(sp)
ffffffffc0203f6a:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203f6c:	c135                	beqz	a0,ffffffffc0203fd0 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203f6e:	002007b7          	lui	a5,0x200
ffffffffc0203f72:	04f5e663          	bltu	a1,a5,ffffffffc0203fbe <user_mem_check+0x62>
ffffffffc0203f76:	00c584b3          	add	s1,a1,a2
ffffffffc0203f7a:	0495f263          	bgeu	a1,s1,ffffffffc0203fbe <user_mem_check+0x62>
ffffffffc0203f7e:	4785                	li	a5,1
ffffffffc0203f80:	07fe                	slli	a5,a5,0x1f
ffffffffc0203f82:	0297ee63          	bltu	a5,s1,ffffffffc0203fbe <user_mem_check+0x62>
ffffffffc0203f86:	892a                	mv	s2,a0
ffffffffc0203f88:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f8a:	6a05                	lui	s4,0x1
ffffffffc0203f8c:	a821                	j	ffffffffc0203fa4 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f8e:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f92:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203f94:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f96:	c685                	beqz	a3,ffffffffc0203fbe <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203f98:	c399                	beqz	a5,ffffffffc0203f9e <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f9a:	02e46263          	bltu	s0,a4,ffffffffc0203fbe <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203f9e:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203fa0:	04947663          	bgeu	s0,s1,ffffffffc0203fec <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203fa4:	85a2                	mv	a1,s0
ffffffffc0203fa6:	854a                	mv	a0,s2
ffffffffc0203fa8:	96fff0ef          	jal	ra,ffffffffc0203916 <find_vma>
ffffffffc0203fac:	c909                	beqz	a0,ffffffffc0203fbe <user_mem_check+0x62>
ffffffffc0203fae:	6518                	ld	a4,8(a0)
ffffffffc0203fb0:	00e46763          	bltu	s0,a4,ffffffffc0203fbe <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203fb4:	4d1c                	lw	a5,24(a0)
ffffffffc0203fb6:	fc099ce3          	bnez	s3,ffffffffc0203f8e <user_mem_check+0x32>
ffffffffc0203fba:	8b85                	andi	a5,a5,1
ffffffffc0203fbc:	f3ed                	bnez	a5,ffffffffc0203f9e <user_mem_check+0x42>
            return 0;
ffffffffc0203fbe:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fc0:	70a2                	ld	ra,40(sp)
ffffffffc0203fc2:	7402                	ld	s0,32(sp)
ffffffffc0203fc4:	64e2                	ld	s1,24(sp)
ffffffffc0203fc6:	6942                	ld	s2,16(sp)
ffffffffc0203fc8:	69a2                	ld	s3,8(sp)
ffffffffc0203fca:	6a02                	ld	s4,0(sp)
ffffffffc0203fcc:	6145                	addi	sp,sp,48
ffffffffc0203fce:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fd0:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fd4:	4501                	li	a0,0
ffffffffc0203fd6:	fef5e5e3          	bltu	a1,a5,ffffffffc0203fc0 <user_mem_check+0x64>
ffffffffc0203fda:	962e                	add	a2,a2,a1
ffffffffc0203fdc:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203fc0 <user_mem_check+0x64>
ffffffffc0203fe0:	c8000537          	lui	a0,0xc8000
ffffffffc0203fe4:	0505                	addi	a0,a0,1
ffffffffc0203fe6:	00a63533          	sltu	a0,a2,a0
ffffffffc0203fea:	bfd9                	j	ffffffffc0203fc0 <user_mem_check+0x64>
        return 1;
ffffffffc0203fec:	4505                	li	a0,1
ffffffffc0203fee:	bfc9                	j	ffffffffc0203fc0 <user_mem_check+0x64>

ffffffffc0203ff0 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203ff0:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203ff2:	9402                	jalr	s0

	jal do_exit
ffffffffc0203ff4:	63e000ef          	jal	ra,ffffffffc0204632 <do_exit>

ffffffffc0203ff8 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203ff8:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ffa:	10800513          	li	a0,264
{
ffffffffc0203ffe:	e022                	sd	s0,0(sp)
ffffffffc0204000:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204002:	e99fd0ef          	jal	ra,ffffffffc0201e9a <kmalloc>
ffffffffc0204006:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204008:	c929                	beqz	a0,ffffffffc020405a <alloc_proc+0x62>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 初始化进程状态为未初始化
        proc->state = PROC_UNINIT;
ffffffffc020400a:	57fd                	li	a5,-1
ffffffffc020400c:	1782                	slli	a5,a5,0x20
ffffffffc020400e:	e11c                	sd	a5,0(a0)
        // 初始化父进程指针为NULL
        proc->parent = NULL;
        // 初始化内存管理结构为NULL
        proc->mm = NULL;
        // 初始化上下文结构（全部设为0）
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0204010:	07000613          	li	a2,112
ffffffffc0204014:	4581                	li	a1,0
        proc->pgdir = 0;//turned into uninit status     
ffffffffc0204016:	0a053423          	sd	zero,168(a0) # ffffffffc80000a8 <end+0x7d2cd8c>
        proc->runs = 0;
ffffffffc020401a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020401e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0204022:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0204026:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc020402a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020402e:	03050513          	addi	a0,a0,48
ffffffffc0204032:	0cd010ef          	jal	ra,ffffffffc02058fe <memset>
        // 初始化陷阱帧指针为NULL
        proc->tf = NULL;
        // 初始化进程标志为0
        proc->flags = 0;
        // 初始化进程名称为空字符串
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0204036:	4641                	li	a2,16
        proc->tf = NULL;
ffffffffc0204038:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc020403c:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0204040:	4581                	li	a1,0
ffffffffc0204042:	0b440513          	addi	a0,s0,180
ffffffffc0204046:	0b9010ef          	jal	ra,ffffffffc02058fe <memset>
        // 初始化等待状态为0
        proc->wait_state = 0;
ffffffffc020404a:	0e042623          	sw	zero,236(s0)
        // 初始化进程关系指针为NULL
        proc->cptr = NULL;
ffffffffc020404e:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc0204052:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0204056:	0e043c23          	sd	zero,248(s0)
    }
    return proc;
}
ffffffffc020405a:	60a2                	ld	ra,8(sp)
ffffffffc020405c:	8522                	mv	a0,s0
ffffffffc020405e:	6402                	ld	s0,0(sp)
ffffffffc0204060:	0141                	addi	sp,sp,16
ffffffffc0204062:	8082                	ret

ffffffffc0204064 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204064:	000cf797          	auipc	a5,0xcf
ffffffffc0204068:	29c7b783          	ld	a5,668(a5) # ffffffffc02d3300 <current>
ffffffffc020406c:	73c8                	ld	a0,160(a5)
ffffffffc020406e:	8a0fd06f          	j	ffffffffc020110e <forkrets>

ffffffffc0204072 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204072:	000cf797          	auipc	a5,0xcf
ffffffffc0204076:	28e7b783          	ld	a5,654(a5) # ffffffffc02d3300 <current>
ffffffffc020407a:	43cc                	lw	a1,4(a5)
{
ffffffffc020407c:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020407e:	00003617          	auipc	a2,0x3
ffffffffc0204082:	0fa60613          	addi	a2,a2,250 # ffffffffc0207178 <default_pmm_manager+0x978>
ffffffffc0204086:	00003517          	auipc	a0,0x3
ffffffffc020408a:	10250513          	addi	a0,a0,258 # ffffffffc0207188 <default_pmm_manager+0x988>
{
ffffffffc020408e:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204090:	904fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0204094:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0204098:	1d478793          	addi	a5,a5,468 # a268 <_binary_obj___user_cow_multi_out_size>
ffffffffc020409c:	e43e                	sd	a5,8(sp)
ffffffffc020409e:	00003517          	auipc	a0,0x3
ffffffffc02040a2:	0da50513          	addi	a0,a0,218 # ffffffffc0207178 <default_pmm_manager+0x978>
ffffffffc02040a6:	00026797          	auipc	a5,0x26
ffffffffc02040aa:	68278793          	addi	a5,a5,1666 # ffffffffc022a728 <_binary_obj___user_cow_multi_out_start>
ffffffffc02040ae:	f03e                	sd	a5,32(sp)
ffffffffc02040b0:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc02040b2:	e802                	sd	zero,16(sp)
ffffffffc02040b4:	7a8010ef          	jal	ra,ffffffffc020585c <strlen>
ffffffffc02040b8:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02040ba:	4511                	li	a0,4
ffffffffc02040bc:	55a2                	lw	a1,40(sp)
ffffffffc02040be:	4662                	lw	a2,24(sp)
ffffffffc02040c0:	5682                	lw	a3,32(sp)
ffffffffc02040c2:	4722                	lw	a4,8(sp)
ffffffffc02040c4:	48a9                	li	a7,10
ffffffffc02040c6:	9002                	ebreak
ffffffffc02040c8:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02040ca:	65c2                	ld	a1,16(sp)
ffffffffc02040cc:	00003517          	auipc	a0,0x3
ffffffffc02040d0:	0e450513          	addi	a0,a0,228 # ffffffffc02071b0 <default_pmm_manager+0x9b0>
ffffffffc02040d4:	8c0fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc02040d8:	00003617          	auipc	a2,0x3
ffffffffc02040dc:	0e860613          	addi	a2,a2,232 # ffffffffc02071c0 <default_pmm_manager+0x9c0>
ffffffffc02040e0:	3ce00593          	li	a1,974
ffffffffc02040e4:	00003517          	auipc	a0,0x3
ffffffffc02040e8:	0fc50513          	addi	a0,a0,252 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02040ec:	ba2fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02040f0 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02040f0:	6d14                	ld	a3,24(a0)
{
ffffffffc02040f2:	1141                	addi	sp,sp,-16
ffffffffc02040f4:	e406                	sd	ra,8(sp)
ffffffffc02040f6:	c02007b7          	lui	a5,0xc0200
ffffffffc02040fa:	02f6ee63          	bltu	a3,a5,ffffffffc0204136 <put_pgdir+0x46>
ffffffffc02040fe:	000cf517          	auipc	a0,0xcf
ffffffffc0204102:	1fa53503          	ld	a0,506(a0) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0204106:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0204108:	82b1                	srli	a3,a3,0xc
ffffffffc020410a:	000cf797          	auipc	a5,0xcf
ffffffffc020410e:	1d67b783          	ld	a5,470(a5) # ffffffffc02d32e0 <npage>
ffffffffc0204112:	02f6fe63          	bgeu	a3,a5,ffffffffc020414e <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204116:	00004517          	auipc	a0,0x4
ffffffffc020411a:	97a53503          	ld	a0,-1670(a0) # ffffffffc0207a90 <nbase>
}
ffffffffc020411e:	60a2                	ld	ra,8(sp)
ffffffffc0204120:	8e89                	sub	a3,a3,a0
ffffffffc0204122:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204124:	000cf517          	auipc	a0,0xcf
ffffffffc0204128:	1c453503          	ld	a0,452(a0) # ffffffffc02d32e8 <pages>
ffffffffc020412c:	4585                	li	a1,1
ffffffffc020412e:	9536                	add	a0,a0,a3
}
ffffffffc0204130:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204132:	f85fd06f          	j	ffffffffc02020b6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204136:	00002617          	auipc	a2,0x2
ffffffffc020413a:	77260613          	addi	a2,a2,1906 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc020413e:	07700593          	li	a1,119
ffffffffc0204142:	00002517          	auipc	a0,0x2
ffffffffc0204146:	23650513          	addi	a0,a0,566 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020414a:	b44fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020414e:	00002617          	auipc	a2,0x2
ffffffffc0204152:	23a60613          	addi	a2,a2,570 # ffffffffc0206388 <commands+0x7f8>
ffffffffc0204156:	06900593          	li	a1,105
ffffffffc020415a:	00002517          	auipc	a0,0x2
ffffffffc020415e:	21e50513          	addi	a0,a0,542 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0204162:	b2cfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204166 <proc_run>:
{
ffffffffc0204166:	7179                	addi	sp,sp,-48
ffffffffc0204168:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc020416a:	000cf917          	auipc	s2,0xcf
ffffffffc020416e:	19690913          	addi	s2,s2,406 # ffffffffc02d3300 <current>
{
ffffffffc0204172:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0204174:	00093483          	ld	s1,0(s2)
{
ffffffffc0204178:	f406                	sd	ra,40(sp)
ffffffffc020417a:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc020417c:	02a48963          	beq	s1,a0,ffffffffc02041ae <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204180:	100027f3          	csrr	a5,sstatus
ffffffffc0204184:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204186:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204188:	e7a9                	bnez	a5,ffffffffc02041d2 <proc_run+0x6c>
        if (proc->pgdir != 0) {
ffffffffc020418a:	755c                	ld	a5,168(a0)
        current = proc;
ffffffffc020418c:	00a93023          	sd	a0,0(s2)
        if (proc->pgdir != 0) {
ffffffffc0204190:	c78d                	beqz	a5,ffffffffc02041ba <proc_run+0x54>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204192:	577d                	li	a4,-1
ffffffffc0204194:	177e                	slli	a4,a4,0x3f
ffffffffc0204196:	83b1                	srli	a5,a5,0xc
ffffffffc0204198:	8fd9                	or	a5,a5,a4
ffffffffc020419a:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));//in switch.S,store and load some reg
ffffffffc020419e:	03050593          	addi	a1,a0,48
ffffffffc02041a2:	03048513          	addi	a0,s1,48
ffffffffc02041a6:	05c010ef          	jal	ra,ffffffffc0205202 <switch_to>
    if (flag)
ffffffffc02041aa:	00099d63          	bnez	s3,ffffffffc02041c4 <proc_run+0x5e>
}
ffffffffc02041ae:	70a2                	ld	ra,40(sp)
ffffffffc02041b0:	7482                	ld	s1,32(sp)
ffffffffc02041b2:	6962                	ld	s2,24(sp)
ffffffffc02041b4:	69c2                	ld	s3,16(sp)
ffffffffc02041b6:	6145                	addi	sp,sp,48
ffffffffc02041b8:	8082                	ret
ffffffffc02041ba:	000cf797          	auipc	a5,0xcf
ffffffffc02041be:	1167b783          	ld	a5,278(a5) # ffffffffc02d32d0 <boot_pgdir_pa>
ffffffffc02041c2:	bfc1                	j	ffffffffc0204192 <proc_run+0x2c>
ffffffffc02041c4:	70a2                	ld	ra,40(sp)
ffffffffc02041c6:	7482                	ld	s1,32(sp)
ffffffffc02041c8:	6962                	ld	s2,24(sp)
ffffffffc02041ca:	69c2                	ld	s3,16(sp)
ffffffffc02041cc:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02041ce:	fe0fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02041d2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02041d4:	fe0fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02041d8:	6522                	ld	a0,8(sp)
ffffffffc02041da:	4985                	li	s3,1
ffffffffc02041dc:	b77d                	j	ffffffffc020418a <proc_run+0x24>

ffffffffc02041de <do_fork>:
{
ffffffffc02041de:	7119                	addi	sp,sp,-128
ffffffffc02041e0:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02041e2:	000cf917          	auipc	s2,0xcf
ffffffffc02041e6:	13690913          	addi	s2,s2,310 # ffffffffc02d3318 <nr_process>
ffffffffc02041ea:	00092703          	lw	a4,0(s2)
{
ffffffffc02041ee:	fc86                	sd	ra,120(sp)
ffffffffc02041f0:	f8a2                	sd	s0,112(sp)
ffffffffc02041f2:	f4a6                	sd	s1,104(sp)
ffffffffc02041f4:	ecce                	sd	s3,88(sp)
ffffffffc02041f6:	e8d2                	sd	s4,80(sp)
ffffffffc02041f8:	e4d6                	sd	s5,72(sp)
ffffffffc02041fa:	e0da                	sd	s6,64(sp)
ffffffffc02041fc:	fc5e                	sd	s7,56(sp)
ffffffffc02041fe:	f862                	sd	s8,48(sp)
ffffffffc0204200:	f466                	sd	s9,40(sp)
ffffffffc0204202:	f06a                	sd	s10,32(sp)
ffffffffc0204204:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204206:	6785                	lui	a5,0x1
ffffffffc0204208:	32f75b63          	bge	a4,a5,ffffffffc020453e <do_fork+0x360>
ffffffffc020420c:	8a2a                	mv	s4,a0
ffffffffc020420e:	89ae                	mv	s3,a1
ffffffffc0204210:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0204212:	de7ff0ef          	jal	ra,ffffffffc0203ff8 <alloc_proc>
ffffffffc0204216:	84aa                	mv	s1,a0
ffffffffc0204218:	30050463          	beqz	a0,ffffffffc0204520 <do_fork+0x342>
    proc->parent=current;
ffffffffc020421c:	000cfc17          	auipc	s8,0xcf
ffffffffc0204220:	0e4c0c13          	addi	s8,s8,228 # ffffffffc02d3300 <current>
ffffffffc0204224:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state==0);
ffffffffc0204228:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8acc>
    proc->parent=current;
ffffffffc020422c:	f11c                	sd	a5,32(a0)
    assert(current->wait_state==0);
ffffffffc020422e:	30071d63          	bnez	a4,ffffffffc0204548 <do_fork+0x36a>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204232:	4509                	li	a0,2
ffffffffc0204234:	e45fd0ef          	jal	ra,ffffffffc0202078 <alloc_pages>
    if (page != NULL)
ffffffffc0204238:	2e050163          	beqz	a0,ffffffffc020451a <do_fork+0x33c>
    return page - pages + nbase;
ffffffffc020423c:	000cfa97          	auipc	s5,0xcf
ffffffffc0204240:	0aca8a93          	addi	s5,s5,172 # ffffffffc02d32e8 <pages>
ffffffffc0204244:	000ab683          	ld	a3,0(s5)
ffffffffc0204248:	00004b17          	auipc	s6,0x4
ffffffffc020424c:	848b0b13          	addi	s6,s6,-1976 # ffffffffc0207a90 <nbase>
ffffffffc0204250:	000b3783          	ld	a5,0(s6)
ffffffffc0204254:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204258:	000cfb97          	auipc	s7,0xcf
ffffffffc020425c:	088b8b93          	addi	s7,s7,136 # ffffffffc02d32e0 <npage>
    return page - pages + nbase;
ffffffffc0204260:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204262:	5dfd                	li	s11,-1
ffffffffc0204264:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204268:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020426a:	00cddd93          	srli	s11,s11,0xc
ffffffffc020426e:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204272:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204274:	2ee67a63          	bgeu	a2,a4,ffffffffc0204568 <do_fork+0x38a>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204278:	000c3603          	ld	a2,0(s8)
ffffffffc020427c:	000cfc17          	auipc	s8,0xcf
ffffffffc0204280:	07cc0c13          	addi	s8,s8,124 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0204284:	000c3703          	ld	a4,0(s8)
ffffffffc0204288:	02863d03          	ld	s10,40(a2)
ffffffffc020428c:	e43e                	sd	a5,8(sp)
ffffffffc020428e:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204290:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204292:	020d0863          	beqz	s10,ffffffffc02042c2 <do_fork+0xe4>
    if (clone_flags & CLONE_VM)
ffffffffc0204296:	100a7a13          	andi	s4,s4,256
ffffffffc020429a:	1c0a0163          	beqz	s4,ffffffffc020445c <do_fork+0x27e>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020429e:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042a2:	018d3783          	ld	a5,24(s10)
ffffffffc02042a6:	c02006b7          	lui	a3,0xc0200
ffffffffc02042aa:	2705                	addiw	a4,a4,1
ffffffffc02042ac:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02042b0:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042b4:	2ed7e263          	bltu	a5,a3,ffffffffc0204598 <do_fork+0x3ba>
ffffffffc02042b8:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042bc:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042be:	8f99                	sub	a5,a5,a4
ffffffffc02042c0:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042c2:	6789                	lui	a5,0x2
ffffffffc02042c4:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>
ffffffffc02042c8:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02042ca:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042cc:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02042ce:	87b6                	mv	a5,a3
ffffffffc02042d0:	12040893          	addi	a7,s0,288
ffffffffc02042d4:	00063803          	ld	a6,0(a2)
ffffffffc02042d8:	6608                	ld	a0,8(a2)
ffffffffc02042da:	6a0c                	ld	a1,16(a2)
ffffffffc02042dc:	6e18                	ld	a4,24(a2)
ffffffffc02042de:	0107b023          	sd	a6,0(a5)
ffffffffc02042e2:	e788                	sd	a0,8(a5)
ffffffffc02042e4:	eb8c                	sd	a1,16(a5)
ffffffffc02042e6:	ef98                	sd	a4,24(a5)
ffffffffc02042e8:	02060613          	addi	a2,a2,32
ffffffffc02042ec:	02078793          	addi	a5,a5,32
ffffffffc02042f0:	ff1612e3          	bne	a2,a7,ffffffffc02042d4 <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc02042f4:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02042f8:	12098f63          	beqz	s3,ffffffffc0204436 <do_fork+0x258>
ffffffffc02042fc:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204300:	00000797          	auipc	a5,0x0
ffffffffc0204304:	d6478793          	addi	a5,a5,-668 # ffffffffc0204064 <forkret>
ffffffffc0204308:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020430a:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020430c:	100027f3          	csrr	a5,sstatus
ffffffffc0204310:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204312:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204314:	14079063          	bnez	a5,ffffffffc0204454 <do_fork+0x276>
    if (++last_pid >= MAX_PID)
ffffffffc0204318:	000cb817          	auipc	a6,0xcb
ffffffffc020431c:	b5080813          	addi	a6,a6,-1200 # ffffffffc02cee68 <last_pid.1>
ffffffffc0204320:	00082783          	lw	a5,0(a6)
ffffffffc0204324:	6709                	lui	a4,0x2
ffffffffc0204326:	0017851b          	addiw	a0,a5,1
ffffffffc020432a:	00a82023          	sw	a0,0(a6)
ffffffffc020432e:	08e55d63          	bge	a0,a4,ffffffffc02043c8 <do_fork+0x1ea>
    if (last_pid >= next_safe)
ffffffffc0204332:	000cb317          	auipc	t1,0xcb
ffffffffc0204336:	b3a30313          	addi	t1,t1,-1222 # ffffffffc02cee6c <next_safe.0>
ffffffffc020433a:	00032783          	lw	a5,0(t1)
ffffffffc020433e:	000cf417          	auipc	s0,0xcf
ffffffffc0204342:	f4a40413          	addi	s0,s0,-182 # ffffffffc02d3288 <proc_list>
ffffffffc0204346:	08f55963          	bge	a0,a5,ffffffffc02043d8 <do_fork+0x1fa>
    proc->pid = get_pid();
ffffffffc020434a:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020434c:	45a9                	li	a1,10
ffffffffc020434e:	2501                	sext.w	a0,a0
ffffffffc0204350:	108010ef          	jal	ra,ffffffffc0205458 <hash32>
ffffffffc0204354:	02051793          	slli	a5,a0,0x20
ffffffffc0204358:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020435c:	000cb797          	auipc	a5,0xcb
ffffffffc0204360:	f2c78793          	addi	a5,a5,-212 # ffffffffc02cf288 <hash_list>
ffffffffc0204364:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204366:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204368:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020436a:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020436e:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204370:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0204372:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204374:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204376:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc020437a:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc020437c:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020437e:	e21c                	sd	a5,0(a2)
ffffffffc0204380:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204382:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204384:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204386:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020438a:	10e4b023          	sd	a4,256(s1)
ffffffffc020438e:	c311                	beqz	a4,ffffffffc0204392 <do_fork+0x1b4>
        proc->optr->yptr = proc;
ffffffffc0204390:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204392:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0204396:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204398:	2785                	addiw	a5,a5,1
ffffffffc020439a:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc020439e:	18099363          	bnez	s3,ffffffffc0204524 <do_fork+0x346>
    wakeup_proc(proc);
ffffffffc02043a2:	8526                	mv	a0,s1
ffffffffc02043a4:	6c9000ef          	jal	ra,ffffffffc020526c <wakeup_proc>
    ret = proc->pid;
ffffffffc02043a8:	40c8                	lw	a0,4(s1)
}
ffffffffc02043aa:	70e6                	ld	ra,120(sp)
ffffffffc02043ac:	7446                	ld	s0,112(sp)
ffffffffc02043ae:	74a6                	ld	s1,104(sp)
ffffffffc02043b0:	7906                	ld	s2,96(sp)
ffffffffc02043b2:	69e6                	ld	s3,88(sp)
ffffffffc02043b4:	6a46                	ld	s4,80(sp)
ffffffffc02043b6:	6aa6                	ld	s5,72(sp)
ffffffffc02043b8:	6b06                	ld	s6,64(sp)
ffffffffc02043ba:	7be2                	ld	s7,56(sp)
ffffffffc02043bc:	7c42                	ld	s8,48(sp)
ffffffffc02043be:	7ca2                	ld	s9,40(sp)
ffffffffc02043c0:	7d02                	ld	s10,32(sp)
ffffffffc02043c2:	6de2                	ld	s11,24(sp)
ffffffffc02043c4:	6109                	addi	sp,sp,128
ffffffffc02043c6:	8082                	ret
        last_pid = 1;
ffffffffc02043c8:	4785                	li	a5,1
ffffffffc02043ca:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02043ce:	4505                	li	a0,1
ffffffffc02043d0:	000cb317          	auipc	t1,0xcb
ffffffffc02043d4:	a9c30313          	addi	t1,t1,-1380 # ffffffffc02cee6c <next_safe.0>
    return listelm->next;
ffffffffc02043d8:	000cf417          	auipc	s0,0xcf
ffffffffc02043dc:	eb040413          	addi	s0,s0,-336 # ffffffffc02d3288 <proc_list>
ffffffffc02043e0:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02043e4:	6789                	lui	a5,0x2
ffffffffc02043e6:	00f32023          	sw	a5,0(t1)
ffffffffc02043ea:	86aa                	mv	a3,a0
ffffffffc02043ec:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02043ee:	6e89                	lui	t4,0x2
ffffffffc02043f0:	148e0263          	beq	t3,s0,ffffffffc0204534 <do_fork+0x356>
ffffffffc02043f4:	88ae                	mv	a7,a1
ffffffffc02043f6:	87f2                	mv	a5,t3
ffffffffc02043f8:	6609                	lui	a2,0x2
ffffffffc02043fa:	a811                	j	ffffffffc020440e <do_fork+0x230>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02043fc:	00e6d663          	bge	a3,a4,ffffffffc0204408 <do_fork+0x22a>
ffffffffc0204400:	00c75463          	bge	a4,a2,ffffffffc0204408 <do_fork+0x22a>
ffffffffc0204404:	863a                	mv	a2,a4
ffffffffc0204406:	4885                	li	a7,1
ffffffffc0204408:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020440a:	00878d63          	beq	a5,s0,ffffffffc0204424 <do_fork+0x246>
            if (proc->pid == last_pid)
ffffffffc020440e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc0204412:	fed715e3          	bne	a4,a3,ffffffffc02043fc <do_fork+0x21e>
                if (++last_pid >= next_safe)
ffffffffc0204416:	2685                	addiw	a3,a3,1
ffffffffc0204418:	10c6d963          	bge	a3,a2,ffffffffc020452a <do_fork+0x34c>
ffffffffc020441c:	679c                	ld	a5,8(a5)
ffffffffc020441e:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204420:	fe8797e3          	bne	a5,s0,ffffffffc020440e <do_fork+0x230>
ffffffffc0204424:	c581                	beqz	a1,ffffffffc020442c <do_fork+0x24e>
ffffffffc0204426:	00d82023          	sw	a3,0(a6)
ffffffffc020442a:	8536                	mv	a0,a3
ffffffffc020442c:	f0088fe3          	beqz	a7,ffffffffc020434a <do_fork+0x16c>
ffffffffc0204430:	00c32023          	sw	a2,0(t1)
ffffffffc0204434:	bf19                	j	ffffffffc020434a <do_fork+0x16c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204436:	89b6                	mv	s3,a3
ffffffffc0204438:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020443c:	00000797          	auipc	a5,0x0
ffffffffc0204440:	c2878793          	addi	a5,a5,-984 # ffffffffc0204064 <forkret>
ffffffffc0204444:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204446:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204448:	100027f3          	csrr	a5,sstatus
ffffffffc020444c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020444e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204450:	ec0784e3          	beqz	a5,ffffffffc0204318 <do_fork+0x13a>
        intr_disable();
ffffffffc0204454:	d60fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204458:	4985                	li	s3,1
ffffffffc020445a:	bd7d                	j	ffffffffc0204318 <do_fork+0x13a>
    if ((mm = mm_create()) == NULL)
ffffffffc020445c:	c8aff0ef          	jal	ra,ffffffffc02038e6 <mm_create>
ffffffffc0204460:	8caa                	mv	s9,a0
ffffffffc0204462:	c541                	beqz	a0,ffffffffc02044ea <do_fork+0x30c>
    if ((page = alloc_page()) == NULL)
ffffffffc0204464:	4505                	li	a0,1
ffffffffc0204466:	c13fd0ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc020446a:	cd2d                	beqz	a0,ffffffffc02044e4 <do_fork+0x306>
    return page - pages + nbase;
ffffffffc020446c:	000ab683          	ld	a3,0(s5)
ffffffffc0204470:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204472:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204476:	40d506b3          	sub	a3,a0,a3
ffffffffc020447a:	8699                	srai	a3,a3,0x6
ffffffffc020447c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020447e:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204482:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204484:	0eedf263          	bgeu	s11,a4,ffffffffc0204568 <do_fork+0x38a>
ffffffffc0204488:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020448c:	6605                	lui	a2,0x1
ffffffffc020448e:	000cf597          	auipc	a1,0xcf
ffffffffc0204492:	e4a5b583          	ld	a1,-438(a1) # ffffffffc02d32d8 <boot_pgdir_va>
ffffffffc0204496:	9a36                	add	s4,s4,a3
ffffffffc0204498:	8552                	mv	a0,s4
ffffffffc020449a:	476010ef          	jal	ra,ffffffffc0205910 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020449e:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02044a2:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02044a6:	4785                	li	a5,1
ffffffffc02044a8:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02044ac:	8b85                	andi	a5,a5,1
ffffffffc02044ae:	4a05                	li	s4,1
ffffffffc02044b0:	c799                	beqz	a5,ffffffffc02044be <do_fork+0x2e0>
    {
        schedule();
ffffffffc02044b2:	63b000ef          	jal	ra,ffffffffc02052ec <schedule>
ffffffffc02044b6:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02044ba:	8b85                	andi	a5,a5,1
ffffffffc02044bc:	fbfd                	bnez	a5,ffffffffc02044b2 <do_fork+0x2d4>
        ret = dup_mmap(mm, oldmm);
ffffffffc02044be:	85ea                	mv	a1,s10
ffffffffc02044c0:	8566                	mv	a0,s9
ffffffffc02044c2:	e66ff0ef          	jal	ra,ffffffffc0203b28 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02044c6:	57f9                	li	a5,-2
ffffffffc02044c8:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02044cc:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02044ce:	0e078e63          	beqz	a5,ffffffffc02045ca <do_fork+0x3ec>
good_mm:
ffffffffc02044d2:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02044d4:	dc0505e3          	beqz	a0,ffffffffc020429e <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc02044d8:	8566                	mv	a0,s9
ffffffffc02044da:	ee8ff0ef          	jal	ra,ffffffffc0203bc2 <exit_mmap>
    put_pgdir(mm);
ffffffffc02044de:	8566                	mv	a0,s9
ffffffffc02044e0:	c11ff0ef          	jal	ra,ffffffffc02040f0 <put_pgdir>
    mm_destroy(mm);
ffffffffc02044e4:	8566                	mv	a0,s9
ffffffffc02044e6:	d40ff0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044ea:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02044ec:	c02007b7          	lui	a5,0xc0200
ffffffffc02044f0:	0cf6e163          	bltu	a3,a5,ffffffffc02045b2 <do_fork+0x3d4>
ffffffffc02044f4:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02044f8:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02044fc:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204500:	83b1                	srli	a5,a5,0xc
ffffffffc0204502:	06e7ff63          	bgeu	a5,a4,ffffffffc0204580 <do_fork+0x3a2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204506:	000b3703          	ld	a4,0(s6)
ffffffffc020450a:	000ab503          	ld	a0,0(s5)
ffffffffc020450e:	4589                	li	a1,2
ffffffffc0204510:	8f99                	sub	a5,a5,a4
ffffffffc0204512:	079a                	slli	a5,a5,0x6
ffffffffc0204514:	953e                	add	a0,a0,a5
ffffffffc0204516:	ba1fd0ef          	jal	ra,ffffffffc02020b6 <free_pages>
    kfree(proc);
ffffffffc020451a:	8526                	mv	a0,s1
ffffffffc020451c:	a2ffd0ef          	jal	ra,ffffffffc0201f4a <kfree>
    ret = -E_NO_MEM;
ffffffffc0204520:	5571                	li	a0,-4
    return ret;
ffffffffc0204522:	b561                	j	ffffffffc02043aa <do_fork+0x1cc>
        intr_enable();
ffffffffc0204524:	c8afc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204528:	bdad                	j	ffffffffc02043a2 <do_fork+0x1c4>
                    if (last_pid >= MAX_PID)
ffffffffc020452a:	01d6c363          	blt	a3,t4,ffffffffc0204530 <do_fork+0x352>
                        last_pid = 1;
ffffffffc020452e:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204530:	4585                	li	a1,1
ffffffffc0204532:	bd7d                	j	ffffffffc02043f0 <do_fork+0x212>
ffffffffc0204534:	c599                	beqz	a1,ffffffffc0204542 <do_fork+0x364>
ffffffffc0204536:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020453a:	8536                	mv	a0,a3
ffffffffc020453c:	b539                	j	ffffffffc020434a <do_fork+0x16c>
    int ret = -E_NO_FREE_PROC;
ffffffffc020453e:	556d                	li	a0,-5
ffffffffc0204540:	b5ad                	j	ffffffffc02043aa <do_fork+0x1cc>
    return last_pid;
ffffffffc0204542:	00082503          	lw	a0,0(a6)
ffffffffc0204546:	b511                	j	ffffffffc020434a <do_fork+0x16c>
    assert(current->wait_state==0);
ffffffffc0204548:	00003697          	auipc	a3,0x3
ffffffffc020454c:	cb068693          	addi	a3,a3,-848 # ffffffffc02071f8 <default_pmm_manager+0x9f8>
ffffffffc0204550:	00002617          	auipc	a2,0x2
ffffffffc0204554:	f0060613          	addi	a2,a2,-256 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204558:	1e400593          	li	a1,484
ffffffffc020455c:	00003517          	auipc	a0,0x3
ffffffffc0204560:	c8450513          	addi	a0,a0,-892 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204564:	f2bfb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204568:	00002617          	auipc	a2,0x2
ffffffffc020456c:	e5860613          	addi	a2,a2,-424 # ffffffffc02063c0 <commands+0x830>
ffffffffc0204570:	07100593          	li	a1,113
ffffffffc0204574:	00002517          	auipc	a0,0x2
ffffffffc0204578:	e0450513          	addi	a0,a0,-508 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020457c:	f13fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204580:	00002617          	auipc	a2,0x2
ffffffffc0204584:	e0860613          	addi	a2,a2,-504 # ffffffffc0206388 <commands+0x7f8>
ffffffffc0204588:	06900593          	li	a1,105
ffffffffc020458c:	00002517          	auipc	a0,0x2
ffffffffc0204590:	dec50513          	addi	a0,a0,-532 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0204594:	efbfb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204598:	86be                	mv	a3,a5
ffffffffc020459a:	00002617          	auipc	a2,0x2
ffffffffc020459e:	30e60613          	addi	a2,a2,782 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc02045a2:	1a300593          	li	a1,419
ffffffffc02045a6:	00003517          	auipc	a0,0x3
ffffffffc02045aa:	c3a50513          	addi	a0,a0,-966 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02045ae:	ee1fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc02045b2:	00002617          	auipc	a2,0x2
ffffffffc02045b6:	2f660613          	addi	a2,a2,758 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc02045ba:	07700593          	li	a1,119
ffffffffc02045be:	00002517          	auipc	a0,0x2
ffffffffc02045c2:	dba50513          	addi	a0,a0,-582 # ffffffffc0206378 <commands+0x7e8>
ffffffffc02045c6:	ec9fb0ef          	jal	ra,ffffffffc020048e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02045ca:	00003617          	auipc	a2,0x3
ffffffffc02045ce:	c4660613          	addi	a2,a2,-954 # ffffffffc0207210 <default_pmm_manager+0xa10>
ffffffffc02045d2:	03f00593          	li	a1,63
ffffffffc02045d6:	00003517          	auipc	a0,0x3
ffffffffc02045da:	c4a50513          	addi	a0,a0,-950 # ffffffffc0207220 <default_pmm_manager+0xa20>
ffffffffc02045de:	eb1fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02045e2 <kernel_thread>:
{
ffffffffc02045e2:	7129                	addi	sp,sp,-320
ffffffffc02045e4:	fa22                	sd	s0,304(sp)
ffffffffc02045e6:	f626                	sd	s1,296(sp)
ffffffffc02045e8:	f24a                	sd	s2,288(sp)
ffffffffc02045ea:	84ae                	mv	s1,a1
ffffffffc02045ec:	892a                	mv	s2,a0
ffffffffc02045ee:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045f0:	4581                	li	a1,0
ffffffffc02045f2:	12000613          	li	a2,288
ffffffffc02045f6:	850a                	mv	a0,sp
{
ffffffffc02045f8:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045fa:	304010ef          	jal	ra,ffffffffc02058fe <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02045fe:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204600:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204602:	100027f3          	csrr	a5,sstatus
ffffffffc0204606:	edd7f793          	andi	a5,a5,-291
ffffffffc020460a:	1207e793          	ori	a5,a5,288
ffffffffc020460e:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204610:	860a                	mv	a2,sp
ffffffffc0204612:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204616:	00000797          	auipc	a5,0x0
ffffffffc020461a:	9da78793          	addi	a5,a5,-1574 # ffffffffc0203ff0 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020461e:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204620:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204622:	bbdff0ef          	jal	ra,ffffffffc02041de <do_fork>
}
ffffffffc0204626:	70f2                	ld	ra,312(sp)
ffffffffc0204628:	7452                	ld	s0,304(sp)
ffffffffc020462a:	74b2                	ld	s1,296(sp)
ffffffffc020462c:	7912                	ld	s2,288(sp)
ffffffffc020462e:	6131                	addi	sp,sp,320
ffffffffc0204630:	8082                	ret

ffffffffc0204632 <do_exit>:
{
ffffffffc0204632:	7179                	addi	sp,sp,-48
ffffffffc0204634:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204636:	000cf417          	auipc	s0,0xcf
ffffffffc020463a:	cca40413          	addi	s0,s0,-822 # ffffffffc02d3300 <current>
ffffffffc020463e:	601c                	ld	a5,0(s0)
{
ffffffffc0204640:	f406                	sd	ra,40(sp)
ffffffffc0204642:	ec26                	sd	s1,24(sp)
ffffffffc0204644:	e84a                	sd	s2,16(sp)
ffffffffc0204646:	e44e                	sd	s3,8(sp)
ffffffffc0204648:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020464a:	000cf717          	auipc	a4,0xcf
ffffffffc020464e:	cbe73703          	ld	a4,-834(a4) # ffffffffc02d3308 <idleproc>
ffffffffc0204652:	0ce78c63          	beq	a5,a4,ffffffffc020472a <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204656:	000cf497          	auipc	s1,0xcf
ffffffffc020465a:	cba48493          	addi	s1,s1,-838 # ffffffffc02d3310 <initproc>
ffffffffc020465e:	6098                	ld	a4,0(s1)
ffffffffc0204660:	0ee78b63          	beq	a5,a4,ffffffffc0204756 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204664:	0287b983          	ld	s3,40(a5)
ffffffffc0204668:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020466a:	02098663          	beqz	s3,ffffffffc0204696 <do_exit+0x64>
ffffffffc020466e:	000cf797          	auipc	a5,0xcf
ffffffffc0204672:	c627b783          	ld	a5,-926(a5) # ffffffffc02d32d0 <boot_pgdir_pa>
ffffffffc0204676:	577d                	li	a4,-1
ffffffffc0204678:	177e                	slli	a4,a4,0x3f
ffffffffc020467a:	83b1                	srli	a5,a5,0xc
ffffffffc020467c:	8fd9                	or	a5,a5,a4
ffffffffc020467e:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204682:	0309a783          	lw	a5,48(s3)
ffffffffc0204686:	fff7871b          	addiw	a4,a5,-1
ffffffffc020468a:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020468e:	cb55                	beqz	a4,ffffffffc0204742 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204690:	601c                	ld	a5,0(s0)
ffffffffc0204692:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204696:	601c                	ld	a5,0(s0)
ffffffffc0204698:	470d                	li	a4,3
ffffffffc020469a:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020469c:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046a0:	100027f3          	csrr	a5,sstatus
ffffffffc02046a4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046a6:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046a8:	e3f9                	bnez	a5,ffffffffc020476e <do_exit+0x13c>
        proc = current->parent;
ffffffffc02046aa:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02046ac:	800007b7          	lui	a5,0x80000
ffffffffc02046b0:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02046b2:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02046b4:	0ec52703          	lw	a4,236(a0)
ffffffffc02046b8:	0af70f63          	beq	a4,a5,ffffffffc0204776 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc02046bc:	6018                	ld	a4,0(s0)
ffffffffc02046be:	7b7c                	ld	a5,240(a4)
ffffffffc02046c0:	c3a1                	beqz	a5,ffffffffc0204700 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046c2:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046c6:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046c8:	0985                	addi	s3,s3,1
ffffffffc02046ca:	a021                	j	ffffffffc02046d2 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02046cc:	6018                	ld	a4,0(s0)
ffffffffc02046ce:	7b7c                	ld	a5,240(a4)
ffffffffc02046d0:	cb85                	beqz	a5,ffffffffc0204700 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02046d2:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fd0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046d6:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02046d8:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046da:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02046dc:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046e0:	10e7b023          	sd	a4,256(a5)
ffffffffc02046e4:	c311                	beqz	a4,ffffffffc02046e8 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02046e6:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046e8:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02046ea:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02046ec:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046ee:	fd271fe3          	bne	a4,s2,ffffffffc02046cc <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046f2:	0ec52783          	lw	a5,236(a0)
ffffffffc02046f6:	fd379be3          	bne	a5,s3,ffffffffc02046cc <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02046fa:	373000ef          	jal	ra,ffffffffc020526c <wakeup_proc>
ffffffffc02046fe:	b7f9                	j	ffffffffc02046cc <do_exit+0x9a>
    if (flag)
ffffffffc0204700:	020a1263          	bnez	s4,ffffffffc0204724 <do_exit+0xf2>
    schedule();
ffffffffc0204704:	3e9000ef          	jal	ra,ffffffffc02052ec <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204708:	601c                	ld	a5,0(s0)
ffffffffc020470a:	00003617          	auipc	a2,0x3
ffffffffc020470e:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0207258 <default_pmm_manager+0xa58>
ffffffffc0204712:	24e00593          	li	a1,590
ffffffffc0204716:	43d4                	lw	a3,4(a5)
ffffffffc0204718:	00003517          	auipc	a0,0x3
ffffffffc020471c:	ac850513          	addi	a0,a0,-1336 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204720:	d6ffb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204724:	a8afc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204728:	bff1                	j	ffffffffc0204704 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc020472a:	00003617          	auipc	a2,0x3
ffffffffc020472e:	b0e60613          	addi	a2,a2,-1266 # ffffffffc0207238 <default_pmm_manager+0xa38>
ffffffffc0204732:	21a00593          	li	a1,538
ffffffffc0204736:	00003517          	auipc	a0,0x3
ffffffffc020473a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc020473e:	d51fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204742:	854e                	mv	a0,s3
ffffffffc0204744:	c7eff0ef          	jal	ra,ffffffffc0203bc2 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204748:	854e                	mv	a0,s3
ffffffffc020474a:	9a7ff0ef          	jal	ra,ffffffffc02040f0 <put_pgdir>
            mm_destroy(mm);
ffffffffc020474e:	854e                	mv	a0,s3
ffffffffc0204750:	ad6ff0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>
ffffffffc0204754:	bf35                	j	ffffffffc0204690 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204756:	00003617          	auipc	a2,0x3
ffffffffc020475a:	af260613          	addi	a2,a2,-1294 # ffffffffc0207248 <default_pmm_manager+0xa48>
ffffffffc020475e:	21e00593          	li	a1,542
ffffffffc0204762:	00003517          	auipc	a0,0x3
ffffffffc0204766:	a7e50513          	addi	a0,a0,-1410 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc020476a:	d25fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc020476e:	a46fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204772:	4a05                	li	s4,1
ffffffffc0204774:	bf1d                	j	ffffffffc02046aa <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204776:	2f7000ef          	jal	ra,ffffffffc020526c <wakeup_proc>
ffffffffc020477a:	b789                	j	ffffffffc02046bc <do_exit+0x8a>

ffffffffc020477c <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020477c:	715d                	addi	sp,sp,-80
ffffffffc020477e:	f84a                	sd	s2,48(sp)
ffffffffc0204780:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204782:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204786:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204788:	fc26                	sd	s1,56(sp)
ffffffffc020478a:	f052                	sd	s4,32(sp)
ffffffffc020478c:	ec56                	sd	s5,24(sp)
ffffffffc020478e:	e85a                	sd	s6,16(sp)
ffffffffc0204790:	e45e                	sd	s7,8(sp)
ffffffffc0204792:	e486                	sd	ra,72(sp)
ffffffffc0204794:	e0a2                	sd	s0,64(sp)
ffffffffc0204796:	84aa                	mv	s1,a0
ffffffffc0204798:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020479a:	000cfb97          	auipc	s7,0xcf
ffffffffc020479e:	b66b8b93          	addi	s7,s7,-1178 # ffffffffc02d3300 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02047a2:	00050b1b          	sext.w	s6,a0
ffffffffc02047a6:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02047aa:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02047ac:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02047ae:	ccbd                	beqz	s1,ffffffffc020482c <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02047b0:	0359e863          	bltu	s3,s5,ffffffffc02047e0 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02047b4:	45a9                	li	a1,10
ffffffffc02047b6:	855a                	mv	a0,s6
ffffffffc02047b8:	4a1000ef          	jal	ra,ffffffffc0205458 <hash32>
ffffffffc02047bc:	02051793          	slli	a5,a0,0x20
ffffffffc02047c0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02047c4:	000cb797          	auipc	a5,0xcb
ffffffffc02047c8:	ac478793          	addi	a5,a5,-1340 # ffffffffc02cf288 <hash_list>
ffffffffc02047cc:	953e                	add	a0,a0,a5
ffffffffc02047ce:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02047d0:	a029                	j	ffffffffc02047da <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02047d2:	f2c42783          	lw	a5,-212(s0)
ffffffffc02047d6:	02978163          	beq	a5,s1,ffffffffc02047f8 <do_wait.part.0+0x7c>
ffffffffc02047da:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02047dc:	fe851be3          	bne	a0,s0,ffffffffc02047d2 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02047e0:	5579                	li	a0,-2
}
ffffffffc02047e2:	60a6                	ld	ra,72(sp)
ffffffffc02047e4:	6406                	ld	s0,64(sp)
ffffffffc02047e6:	74e2                	ld	s1,56(sp)
ffffffffc02047e8:	7942                	ld	s2,48(sp)
ffffffffc02047ea:	79a2                	ld	s3,40(sp)
ffffffffc02047ec:	7a02                	ld	s4,32(sp)
ffffffffc02047ee:	6ae2                	ld	s5,24(sp)
ffffffffc02047f0:	6b42                	ld	s6,16(sp)
ffffffffc02047f2:	6ba2                	ld	s7,8(sp)
ffffffffc02047f4:	6161                	addi	sp,sp,80
ffffffffc02047f6:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02047f8:	000bb683          	ld	a3,0(s7)
ffffffffc02047fc:	f4843783          	ld	a5,-184(s0)
ffffffffc0204800:	fed790e3          	bne	a5,a3,ffffffffc02047e0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204804:	f2842703          	lw	a4,-216(s0)
ffffffffc0204808:	478d                	li	a5,3
ffffffffc020480a:	0ef70b63          	beq	a4,a5,ffffffffc0204900 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc020480e:	4785                	li	a5,1
ffffffffc0204810:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204812:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204816:	2d7000ef          	jal	ra,ffffffffc02052ec <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020481a:	000bb783          	ld	a5,0(s7)
ffffffffc020481e:	0b07a783          	lw	a5,176(a5)
ffffffffc0204822:	8b85                	andi	a5,a5,1
ffffffffc0204824:	d7c9                	beqz	a5,ffffffffc02047ae <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204826:	555d                	li	a0,-9
ffffffffc0204828:	e0bff0ef          	jal	ra,ffffffffc0204632 <do_exit>
        proc = current->cptr;
ffffffffc020482c:	000bb683          	ld	a3,0(s7)
ffffffffc0204830:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204832:	d45d                	beqz	s0,ffffffffc02047e0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204834:	470d                	li	a4,3
ffffffffc0204836:	a021                	j	ffffffffc020483e <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204838:	10043403          	ld	s0,256(s0)
ffffffffc020483c:	d869                	beqz	s0,ffffffffc020480e <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020483e:	401c                	lw	a5,0(s0)
ffffffffc0204840:	fee79ce3          	bne	a5,a4,ffffffffc0204838 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204844:	000cf797          	auipc	a5,0xcf
ffffffffc0204848:	ac47b783          	ld	a5,-1340(a5) # ffffffffc02d3308 <idleproc>
ffffffffc020484c:	0c878963          	beq	a5,s0,ffffffffc020491e <do_wait.part.0+0x1a2>
ffffffffc0204850:	000cf797          	auipc	a5,0xcf
ffffffffc0204854:	ac07b783          	ld	a5,-1344(a5) # ffffffffc02d3310 <initproc>
ffffffffc0204858:	0cf40363          	beq	s0,a5,ffffffffc020491e <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020485c:	000a0663          	beqz	s4,ffffffffc0204868 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204860:	0e842783          	lw	a5,232(s0)
ffffffffc0204864:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204868:	100027f3          	csrr	a5,sstatus
ffffffffc020486c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020486e:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204870:	e7c1                	bnez	a5,ffffffffc02048f8 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204872:	6c70                	ld	a2,216(s0)
ffffffffc0204874:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204876:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020487a:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020487c:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020487e:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204880:	6470                	ld	a2,200(s0)
ffffffffc0204882:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204884:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204886:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204888:	c319                	beqz	a4,ffffffffc020488e <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020488a:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020488c:	7c7c                	ld	a5,248(s0)
ffffffffc020488e:	c3b5                	beqz	a5,ffffffffc02048f2 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204890:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204894:	000cf717          	auipc	a4,0xcf
ffffffffc0204898:	a8470713          	addi	a4,a4,-1404 # ffffffffc02d3318 <nr_process>
ffffffffc020489c:	431c                	lw	a5,0(a4)
ffffffffc020489e:	37fd                	addiw	a5,a5,-1
ffffffffc02048a0:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02048a2:	e5a9                	bnez	a1,ffffffffc02048ec <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02048a4:	6814                	ld	a3,16(s0)
ffffffffc02048a6:	c02007b7          	lui	a5,0xc0200
ffffffffc02048aa:	04f6ee63          	bltu	a3,a5,ffffffffc0204906 <do_wait.part.0+0x18a>
ffffffffc02048ae:	000cf797          	auipc	a5,0xcf
ffffffffc02048b2:	a4a7b783          	ld	a5,-1462(a5) # ffffffffc02d32f8 <va_pa_offset>
ffffffffc02048b6:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02048b8:	82b1                	srli	a3,a3,0xc
ffffffffc02048ba:	000cf797          	auipc	a5,0xcf
ffffffffc02048be:	a267b783          	ld	a5,-1498(a5) # ffffffffc02d32e0 <npage>
ffffffffc02048c2:	06f6fa63          	bgeu	a3,a5,ffffffffc0204936 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02048c6:	00003517          	auipc	a0,0x3
ffffffffc02048ca:	1ca53503          	ld	a0,458(a0) # ffffffffc0207a90 <nbase>
ffffffffc02048ce:	8e89                	sub	a3,a3,a0
ffffffffc02048d0:	069a                	slli	a3,a3,0x6
ffffffffc02048d2:	000cf517          	auipc	a0,0xcf
ffffffffc02048d6:	a1653503          	ld	a0,-1514(a0) # ffffffffc02d32e8 <pages>
ffffffffc02048da:	9536                	add	a0,a0,a3
ffffffffc02048dc:	4589                	li	a1,2
ffffffffc02048de:	fd8fd0ef          	jal	ra,ffffffffc02020b6 <free_pages>
    kfree(proc);
ffffffffc02048e2:	8522                	mv	a0,s0
ffffffffc02048e4:	e66fd0ef          	jal	ra,ffffffffc0201f4a <kfree>
    return 0;
ffffffffc02048e8:	4501                	li	a0,0
ffffffffc02048ea:	bde5                	j	ffffffffc02047e2 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02048ec:	8c2fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02048f0:	bf55                	j	ffffffffc02048a4 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02048f2:	701c                	ld	a5,32(s0)
ffffffffc02048f4:	fbf8                	sd	a4,240(a5)
ffffffffc02048f6:	bf79                	j	ffffffffc0204894 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02048f8:	8bcfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02048fc:	4585                	li	a1,1
ffffffffc02048fe:	bf95                	j	ffffffffc0204872 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204900:	f2840413          	addi	s0,s0,-216
ffffffffc0204904:	b781                	j	ffffffffc0204844 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0204906:	00002617          	auipc	a2,0x2
ffffffffc020490a:	fa260613          	addi	a2,a2,-94 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc020490e:	07700593          	li	a1,119
ffffffffc0204912:	00002517          	auipc	a0,0x2
ffffffffc0204916:	a6650513          	addi	a0,a0,-1434 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020491a:	b75fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020491e:	00003617          	auipc	a2,0x3
ffffffffc0204922:	95a60613          	addi	a2,a2,-1702 # ffffffffc0207278 <default_pmm_manager+0xa78>
ffffffffc0204926:	37600593          	li	a1,886
ffffffffc020492a:	00003517          	auipc	a0,0x3
ffffffffc020492e:	8b650513          	addi	a0,a0,-1866 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204932:	b5dfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204936:	00002617          	auipc	a2,0x2
ffffffffc020493a:	a5260613          	addi	a2,a2,-1454 # ffffffffc0206388 <commands+0x7f8>
ffffffffc020493e:	06900593          	li	a1,105
ffffffffc0204942:	00002517          	auipc	a0,0x2
ffffffffc0204946:	a3650513          	addi	a0,a0,-1482 # ffffffffc0206378 <commands+0x7e8>
ffffffffc020494a:	b45fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020494e <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020494e:	1141                	addi	sp,sp,-16
ffffffffc0204950:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204952:	fa4fd0ef          	jal	ra,ffffffffc02020f6 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204956:	d40fd0ef          	jal	ra,ffffffffc0201e96 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020495a:	4601                	li	a2,0
ffffffffc020495c:	4581                	li	a1,0
ffffffffc020495e:	fffff517          	auipc	a0,0xfffff
ffffffffc0204962:	71450513          	addi	a0,a0,1812 # ffffffffc0204072 <user_main>
ffffffffc0204966:	c7dff0ef          	jal	ra,ffffffffc02045e2 <kernel_thread>
    if (pid <= 0)
ffffffffc020496a:	00a04563          	bgtz	a0,ffffffffc0204974 <init_main+0x26>
ffffffffc020496e:	a071                	j	ffffffffc02049fa <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204970:	17d000ef          	jal	ra,ffffffffc02052ec <schedule>
    if (code_store != NULL)
ffffffffc0204974:	4581                	li	a1,0
ffffffffc0204976:	4501                	li	a0,0
ffffffffc0204978:	e05ff0ef          	jal	ra,ffffffffc020477c <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020497c:	d975                	beqz	a0,ffffffffc0204970 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020497e:	00003517          	auipc	a0,0x3
ffffffffc0204982:	93a50513          	addi	a0,a0,-1734 # ffffffffc02072b8 <default_pmm_manager+0xab8>
ffffffffc0204986:	80ffb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020498a:	000cf797          	auipc	a5,0xcf
ffffffffc020498e:	9867b783          	ld	a5,-1658(a5) # ffffffffc02d3310 <initproc>
ffffffffc0204992:	7bf8                	ld	a4,240(a5)
ffffffffc0204994:	e339                	bnez	a4,ffffffffc02049da <init_main+0x8c>
ffffffffc0204996:	7ff8                	ld	a4,248(a5)
ffffffffc0204998:	e329                	bnez	a4,ffffffffc02049da <init_main+0x8c>
ffffffffc020499a:	1007b703          	ld	a4,256(a5)
ffffffffc020499e:	ef15                	bnez	a4,ffffffffc02049da <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02049a0:	000cf697          	auipc	a3,0xcf
ffffffffc02049a4:	9786a683          	lw	a3,-1672(a3) # ffffffffc02d3318 <nr_process>
ffffffffc02049a8:	4709                	li	a4,2
ffffffffc02049aa:	0ae69463          	bne	a3,a4,ffffffffc0204a52 <init_main+0x104>
    return listelm->next;
ffffffffc02049ae:	000cf697          	auipc	a3,0xcf
ffffffffc02049b2:	8da68693          	addi	a3,a3,-1830 # ffffffffc02d3288 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02049b6:	6698                	ld	a4,8(a3)
ffffffffc02049b8:	0c878793          	addi	a5,a5,200
ffffffffc02049bc:	06f71b63          	bne	a4,a5,ffffffffc0204a32 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02049c0:	629c                	ld	a5,0(a3)
ffffffffc02049c2:	04f71863          	bne	a4,a5,ffffffffc0204a12 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02049c6:	00003517          	auipc	a0,0x3
ffffffffc02049ca:	9da50513          	addi	a0,a0,-1574 # ffffffffc02073a0 <default_pmm_manager+0xba0>
ffffffffc02049ce:	fc6fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02049d2:	60a2                	ld	ra,8(sp)
ffffffffc02049d4:	4501                	li	a0,0
ffffffffc02049d6:	0141                	addi	sp,sp,16
ffffffffc02049d8:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02049da:	00003697          	auipc	a3,0x3
ffffffffc02049de:	90668693          	addi	a3,a3,-1786 # ffffffffc02072e0 <default_pmm_manager+0xae0>
ffffffffc02049e2:	00002617          	auipc	a2,0x2
ffffffffc02049e6:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02049ea:	3e400593          	li	a1,996
ffffffffc02049ee:	00002517          	auipc	a0,0x2
ffffffffc02049f2:	7f250513          	addi	a0,a0,2034 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02049f6:	a99fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02049fa:	00003617          	auipc	a2,0x3
ffffffffc02049fe:	89e60613          	addi	a2,a2,-1890 # ffffffffc0207298 <default_pmm_manager+0xa98>
ffffffffc0204a02:	3db00593          	li	a1,987
ffffffffc0204a06:	00002517          	auipc	a0,0x2
ffffffffc0204a0a:	7da50513          	addi	a0,a0,2010 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204a0e:	a81fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a12:	00003697          	auipc	a3,0x3
ffffffffc0204a16:	95e68693          	addi	a3,a3,-1698 # ffffffffc0207370 <default_pmm_manager+0xb70>
ffffffffc0204a1a:	00002617          	auipc	a2,0x2
ffffffffc0204a1e:	a3660613          	addi	a2,a2,-1482 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204a22:	3e700593          	li	a1,999
ffffffffc0204a26:	00002517          	auipc	a0,0x2
ffffffffc0204a2a:	7ba50513          	addi	a0,a0,1978 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204a2e:	a61fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a32:	00003697          	auipc	a3,0x3
ffffffffc0204a36:	90e68693          	addi	a3,a3,-1778 # ffffffffc0207340 <default_pmm_manager+0xb40>
ffffffffc0204a3a:	00002617          	auipc	a2,0x2
ffffffffc0204a3e:	a1660613          	addi	a2,a2,-1514 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204a42:	3e600593          	li	a1,998
ffffffffc0204a46:	00002517          	auipc	a0,0x2
ffffffffc0204a4a:	79a50513          	addi	a0,a0,1946 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204a4e:	a41fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204a52:	00003697          	auipc	a3,0x3
ffffffffc0204a56:	8de68693          	addi	a3,a3,-1826 # ffffffffc0207330 <default_pmm_manager+0xb30>
ffffffffc0204a5a:	00002617          	auipc	a2,0x2
ffffffffc0204a5e:	9f660613          	addi	a2,a2,-1546 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204a62:	3e500593          	li	a1,997
ffffffffc0204a66:	00002517          	auipc	a0,0x2
ffffffffc0204a6a:	77a50513          	addi	a0,a0,1914 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204a6e:	a21fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a72 <do_execve>:
{
ffffffffc0204a72:	7171                	addi	sp,sp,-176
ffffffffc0204a74:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a76:	000cfd97          	auipc	s11,0xcf
ffffffffc0204a7a:	88ad8d93          	addi	s11,s11,-1910 # ffffffffc02d3300 <current>
ffffffffc0204a7e:	000db783          	ld	a5,0(s11)
{
ffffffffc0204a82:	e54e                	sd	s3,136(sp)
ffffffffc0204a84:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a86:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204a8a:	e94a                	sd	s2,144(sp)
ffffffffc0204a8c:	f4de                	sd	s7,104(sp)
ffffffffc0204a8e:	892a                	mv	s2,a0
ffffffffc0204a90:	8bb2                	mv	s7,a2
ffffffffc0204a92:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a94:	862e                	mv	a2,a1
ffffffffc0204a96:	4681                	li	a3,0
ffffffffc0204a98:	85aa                	mv	a1,a0
ffffffffc0204a9a:	854e                	mv	a0,s3
{
ffffffffc0204a9c:	f506                	sd	ra,168(sp)
ffffffffc0204a9e:	f122                	sd	s0,160(sp)
ffffffffc0204aa0:	e152                	sd	s4,128(sp)
ffffffffc0204aa2:	fcd6                	sd	s5,120(sp)
ffffffffc0204aa4:	f8da                	sd	s6,112(sp)
ffffffffc0204aa6:	f0e2                	sd	s8,96(sp)
ffffffffc0204aa8:	ece6                	sd	s9,88(sp)
ffffffffc0204aaa:	e8ea                	sd	s10,80(sp)
ffffffffc0204aac:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204aae:	caeff0ef          	jal	ra,ffffffffc0203f5c <user_mem_check>
ffffffffc0204ab2:	40050a63          	beqz	a0,ffffffffc0204ec6 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204ab6:	4641                	li	a2,16
ffffffffc0204ab8:	4581                	li	a1,0
ffffffffc0204aba:	1808                	addi	a0,sp,48
ffffffffc0204abc:	643000ef          	jal	ra,ffffffffc02058fe <memset>
    memcpy(local_name, name, len);
ffffffffc0204ac0:	47bd                	li	a5,15
ffffffffc0204ac2:	8626                	mv	a2,s1
ffffffffc0204ac4:	1e97e263          	bltu	a5,s1,ffffffffc0204ca8 <do_execve+0x236>
ffffffffc0204ac8:	85ca                	mv	a1,s2
ffffffffc0204aca:	1808                	addi	a0,sp,48
ffffffffc0204acc:	645000ef          	jal	ra,ffffffffc0205910 <memcpy>
    if (mm != NULL)
ffffffffc0204ad0:	1e098363          	beqz	s3,ffffffffc0204cb6 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204ad4:	00002517          	auipc	a0,0x2
ffffffffc0204ad8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0206fa0 <default_pmm_manager+0x7a0>
ffffffffc0204adc:	ef0fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204ae0:	000ce797          	auipc	a5,0xce
ffffffffc0204ae4:	7f07b783          	ld	a5,2032(a5) # ffffffffc02d32d0 <boot_pgdir_pa>
ffffffffc0204ae8:	577d                	li	a4,-1
ffffffffc0204aea:	177e                	slli	a4,a4,0x3f
ffffffffc0204aec:	83b1                	srli	a5,a5,0xc
ffffffffc0204aee:	8fd9                	or	a5,a5,a4
ffffffffc0204af0:	18079073          	csrw	satp,a5
ffffffffc0204af4:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b88>
ffffffffc0204af8:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204afc:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204b00:	2c070463          	beqz	a4,ffffffffc0204dc8 <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204b04:	000db783          	ld	a5,0(s11)
ffffffffc0204b08:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204b0c:	ddbfe0ef          	jal	ra,ffffffffc02038e6 <mm_create>
ffffffffc0204b10:	84aa                	mv	s1,a0
ffffffffc0204b12:	1c050d63          	beqz	a0,ffffffffc0204cec <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204b16:	4505                	li	a0,1
ffffffffc0204b18:	d60fd0ef          	jal	ra,ffffffffc0202078 <alloc_pages>
ffffffffc0204b1c:	3a050963          	beqz	a0,ffffffffc0204ece <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204b20:	000cec97          	auipc	s9,0xce
ffffffffc0204b24:	7c8c8c93          	addi	s9,s9,1992 # ffffffffc02d32e8 <pages>
ffffffffc0204b28:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204b2c:	000cec17          	auipc	s8,0xce
ffffffffc0204b30:	7b4c0c13          	addi	s8,s8,1972 # ffffffffc02d32e0 <npage>
    return page - pages + nbase;
ffffffffc0204b34:	00003717          	auipc	a4,0x3
ffffffffc0204b38:	f5c73703          	ld	a4,-164(a4) # ffffffffc0207a90 <nbase>
ffffffffc0204b3c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204b40:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204b42:	5afd                	li	s5,-1
ffffffffc0204b44:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204b48:	96ba                	add	a3,a3,a4
ffffffffc0204b4a:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b4c:	00cad713          	srli	a4,s5,0xc
ffffffffc0204b50:	ec3a                	sd	a4,24(sp)
ffffffffc0204b52:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b54:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b56:	38f77063          	bgeu	a4,a5,ffffffffc0204ed6 <do_execve+0x464>
ffffffffc0204b5a:	000ceb17          	auipc	s6,0xce
ffffffffc0204b5e:	79eb0b13          	addi	s6,s6,1950 # ffffffffc02d32f8 <va_pa_offset>
ffffffffc0204b62:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204b66:	6605                	lui	a2,0x1
ffffffffc0204b68:	000ce597          	auipc	a1,0xce
ffffffffc0204b6c:	7705b583          	ld	a1,1904(a1) # ffffffffc02d32d8 <boot_pgdir_va>
ffffffffc0204b70:	9936                	add	s2,s2,a3
ffffffffc0204b72:	854a                	mv	a0,s2
ffffffffc0204b74:	59d000ef          	jal	ra,ffffffffc0205910 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b78:	7782                	ld	a5,32(sp)
ffffffffc0204b7a:	4398                	lw	a4,0(a5)
ffffffffc0204b7c:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204b80:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b84:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b944f>
ffffffffc0204b88:	14f71863          	bne	a4,a5,ffffffffc0204cd8 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b8c:	7682                	ld	a3,32(sp)
ffffffffc0204b8e:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b92:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b96:	00371793          	slli	a5,a4,0x3
ffffffffc0204b9a:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b9c:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b9e:	078e                	slli	a5,a5,0x3
ffffffffc0204ba0:	97ce                	add	a5,a5,s3
ffffffffc0204ba2:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204ba4:	00f9fc63          	bgeu	s3,a5,ffffffffc0204bbc <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204ba8:	0009a783          	lw	a5,0(s3)
ffffffffc0204bac:	4705                	li	a4,1
ffffffffc0204bae:	14e78163          	beq	a5,a4,ffffffffc0204cf0 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204bb2:	77a2                	ld	a5,40(sp)
ffffffffc0204bb4:	03898993          	addi	s3,s3,56
ffffffffc0204bb8:	fef9e8e3          	bltu	s3,a5,ffffffffc0204ba8 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204bbc:	4701                	li	a4,0
ffffffffc0204bbe:	46ad                	li	a3,11
ffffffffc0204bc0:	00100637          	lui	a2,0x100
ffffffffc0204bc4:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204bc8:	8526                	mv	a0,s1
ffffffffc0204bca:	eaffe0ef          	jal	ra,ffffffffc0203a78 <mm_map>
ffffffffc0204bce:	8a2a                	mv	s4,a0
ffffffffc0204bd0:	1e051263          	bnez	a0,ffffffffc0204db4 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204bd4:	6c88                	ld	a0,24(s1)
ffffffffc0204bd6:	467d                	li	a2,31
ffffffffc0204bd8:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204bdc:	c25fe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204be0:	38050363          	beqz	a0,ffffffffc0204f66 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204be4:	6c88                	ld	a0,24(s1)
ffffffffc0204be6:	467d                	li	a2,31
ffffffffc0204be8:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204bec:	c15fe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204bf0:	34050b63          	beqz	a0,ffffffffc0204f46 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bf4:	6c88                	ld	a0,24(s1)
ffffffffc0204bf6:	467d                	li	a2,31
ffffffffc0204bf8:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204bfc:	c05fe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204c00:	32050363          	beqz	a0,ffffffffc0204f26 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c04:	6c88                	ld	a0,24(s1)
ffffffffc0204c06:	467d                	li	a2,31
ffffffffc0204c08:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204c0c:	bf5fe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204c10:	2e050b63          	beqz	a0,ffffffffc0204f06 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204c14:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204c16:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c1a:	6c94                	ld	a3,24(s1)
ffffffffc0204c1c:	2785                	addiw	a5,a5,1
ffffffffc0204c1e:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204c20:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c22:	c02007b7          	lui	a5,0xc0200
ffffffffc0204c26:	2cf6e463          	bltu	a3,a5,ffffffffc0204eee <do_execve+0x47c>
ffffffffc0204c2a:	000b3783          	ld	a5,0(s6)
ffffffffc0204c2e:	577d                	li	a4,-1
ffffffffc0204c30:	177e                	slli	a4,a4,0x3f
ffffffffc0204c32:	8e9d                	sub	a3,a3,a5
ffffffffc0204c34:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204c38:	f654                	sd	a3,168(a2)
ffffffffc0204c3a:	8fd9                	or	a5,a5,a4
ffffffffc0204c3c:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204c40:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c42:	4581                	li	a1,0
ffffffffc0204c44:	12000613          	li	a2,288
ffffffffc0204c48:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204c4a:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c4e:	4b1000ef          	jal	ra,ffffffffc02058fe <memset>
    tf->epc = elf->e_entry;
ffffffffc0204c52:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c54:	000db903          	ld	s2,0(s11)
    sstatus &= ~SSTATUS_SPP;   // 清 SPP
ffffffffc0204c58:	eff4f493          	andi	s1,s1,-257
    tf->epc = elf->e_entry;
ffffffffc0204c5c:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c5e:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c60:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f84>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c64:	07fe                	slli	a5,a5,0x1f
    sstatus |= SSTATUS_SPIE;   // 置 SPIE
ffffffffc0204c66:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c6a:	4641                	li	a2,16
ffffffffc0204c6c:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c6e:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204c70:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus;
ffffffffc0204c74:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c78:	854a                	mv	a0,s2
ffffffffc0204c7a:	485000ef          	jal	ra,ffffffffc02058fe <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204c7e:	463d                	li	a2,15
ffffffffc0204c80:	180c                	addi	a1,sp,48
ffffffffc0204c82:	854a                	mv	a0,s2
ffffffffc0204c84:	48d000ef          	jal	ra,ffffffffc0205910 <memcpy>
}
ffffffffc0204c88:	70aa                	ld	ra,168(sp)
ffffffffc0204c8a:	740a                	ld	s0,160(sp)
ffffffffc0204c8c:	64ea                	ld	s1,152(sp)
ffffffffc0204c8e:	694a                	ld	s2,144(sp)
ffffffffc0204c90:	69aa                	ld	s3,136(sp)
ffffffffc0204c92:	7ae6                	ld	s5,120(sp)
ffffffffc0204c94:	7b46                	ld	s6,112(sp)
ffffffffc0204c96:	7ba6                	ld	s7,104(sp)
ffffffffc0204c98:	7c06                	ld	s8,96(sp)
ffffffffc0204c9a:	6ce6                	ld	s9,88(sp)
ffffffffc0204c9c:	6d46                	ld	s10,80(sp)
ffffffffc0204c9e:	6da6                	ld	s11,72(sp)
ffffffffc0204ca0:	8552                	mv	a0,s4
ffffffffc0204ca2:	6a0a                	ld	s4,128(sp)
ffffffffc0204ca4:	614d                	addi	sp,sp,176
ffffffffc0204ca6:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204ca8:	463d                	li	a2,15
ffffffffc0204caa:	85ca                	mv	a1,s2
ffffffffc0204cac:	1808                	addi	a0,sp,48
ffffffffc0204cae:	463000ef          	jal	ra,ffffffffc0205910 <memcpy>
    if (mm != NULL)
ffffffffc0204cb2:	e20991e3          	bnez	s3,ffffffffc0204ad4 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204cb6:	000db783          	ld	a5,0(s11)
ffffffffc0204cba:	779c                	ld	a5,40(a5)
ffffffffc0204cbc:	e40788e3          	beqz	a5,ffffffffc0204b0c <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204cc0:	00002617          	auipc	a2,0x2
ffffffffc0204cc4:	70060613          	addi	a2,a2,1792 # ffffffffc02073c0 <default_pmm_manager+0xbc0>
ffffffffc0204cc8:	25a00593          	li	a1,602
ffffffffc0204ccc:	00002517          	auipc	a0,0x2
ffffffffc0204cd0:	51450513          	addi	a0,a0,1300 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204cd4:	fbafb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204cd8:	8526                	mv	a0,s1
ffffffffc0204cda:	c16ff0ef          	jal	ra,ffffffffc02040f0 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204cde:	8526                	mv	a0,s1
ffffffffc0204ce0:	d47fe0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204ce4:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204ce6:	8552                	mv	a0,s4
ffffffffc0204ce8:	94bff0ef          	jal	ra,ffffffffc0204632 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204cec:	5a71                	li	s4,-4
ffffffffc0204cee:	bfe5                	j	ffffffffc0204ce6 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204cf0:	0289b603          	ld	a2,40(s3)
ffffffffc0204cf4:	0209b783          	ld	a5,32(s3)
ffffffffc0204cf8:	1cf66d63          	bltu	a2,a5,ffffffffc0204ed2 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204cfc:	0049a783          	lw	a5,4(s3)
ffffffffc0204d00:	0017f693          	andi	a3,a5,1
ffffffffc0204d04:	c291                	beqz	a3,ffffffffc0204d08 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204d06:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204d08:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d0c:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204d0e:	e779                	bnez	a4,ffffffffc0204ddc <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204d10:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d12:	c781                	beqz	a5,ffffffffc0204d1a <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204d14:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204d18:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204d1a:	0026f793          	andi	a5,a3,2
ffffffffc0204d1e:	e3f1                	bnez	a5,ffffffffc0204de2 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204d20:	0046f793          	andi	a5,a3,4
ffffffffc0204d24:	c399                	beqz	a5,ffffffffc0204d2a <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204d26:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204d2a:	0109b583          	ld	a1,16(s3)
ffffffffc0204d2e:	4701                	li	a4,0
ffffffffc0204d30:	8526                	mv	a0,s1
ffffffffc0204d32:	d47fe0ef          	jal	ra,ffffffffc0203a78 <mm_map>
ffffffffc0204d36:	8a2a                	mv	s4,a0
ffffffffc0204d38:	ed35                	bnez	a0,ffffffffc0204db4 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d3a:	0109bb83          	ld	s7,16(s3)
ffffffffc0204d3e:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d40:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d44:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d48:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d4c:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d4e:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d50:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204d52:	054be963          	bltu	s7,s4,ffffffffc0204da4 <do_execve+0x332>
ffffffffc0204d56:	aa95                	j	ffffffffc0204eca <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d58:	6785                	lui	a5,0x1
ffffffffc0204d5a:	415b8533          	sub	a0,s7,s5
ffffffffc0204d5e:	9abe                	add	s5,s5,a5
ffffffffc0204d60:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204d64:	015a7463          	bgeu	s4,s5,ffffffffc0204d6c <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204d68:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204d6c:	000cb683          	ld	a3,0(s9)
ffffffffc0204d70:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d72:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204d76:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d7a:	8699                	srai	a3,a3,0x6
ffffffffc0204d7c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204d7e:	67e2                	ld	a5,24(sp)
ffffffffc0204d80:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d84:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d86:	14b87863          	bgeu	a6,a1,ffffffffc0204ed6 <do_execve+0x464>
ffffffffc0204d8a:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d8e:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204d90:	9bb2                	add	s7,s7,a2
ffffffffc0204d92:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d94:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204d96:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d98:	379000ef          	jal	ra,ffffffffc0205910 <memcpy>
            start += size, from += size;
ffffffffc0204d9c:	6622                	ld	a2,8(sp)
ffffffffc0204d9e:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204da0:	054bf363          	bgeu	s7,s4,ffffffffc0204de6 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204da4:	6c88                	ld	a0,24(s1)
ffffffffc0204da6:	866a                	mv	a2,s10
ffffffffc0204da8:	85d6                	mv	a1,s5
ffffffffc0204daa:	a57fe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204dae:	842a                	mv	s0,a0
ffffffffc0204db0:	f545                	bnez	a0,ffffffffc0204d58 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204db2:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204db4:	8526                	mv	a0,s1
ffffffffc0204db6:	e0dfe0ef          	jal	ra,ffffffffc0203bc2 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204dba:	8526                	mv	a0,s1
ffffffffc0204dbc:	b34ff0ef          	jal	ra,ffffffffc02040f0 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204dc0:	8526                	mv	a0,s1
ffffffffc0204dc2:	c65fe0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>
    return ret;
ffffffffc0204dc6:	b705                	j	ffffffffc0204ce6 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204dc8:	854e                	mv	a0,s3
ffffffffc0204dca:	df9fe0ef          	jal	ra,ffffffffc0203bc2 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204dce:	854e                	mv	a0,s3
ffffffffc0204dd0:	b20ff0ef          	jal	ra,ffffffffc02040f0 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204dd4:	854e                	mv	a0,s3
ffffffffc0204dd6:	c51fe0ef          	jal	ra,ffffffffc0203a26 <mm_destroy>
ffffffffc0204dda:	b32d                	j	ffffffffc0204b04 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204ddc:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204de0:	fb95                	bnez	a5,ffffffffc0204d14 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204de2:	4d5d                	li	s10,23
ffffffffc0204de4:	bf35                	j	ffffffffc0204d20 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204de6:	0109b683          	ld	a3,16(s3)
ffffffffc0204dea:	0289b903          	ld	s2,40(s3)
ffffffffc0204dee:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204df0:	075bfd63          	bgeu	s7,s5,ffffffffc0204e6a <do_execve+0x3f8>
            if (start == end)
ffffffffc0204df4:	db790fe3          	beq	s2,s7,ffffffffc0204bb2 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204df8:	6785                	lui	a5,0x1
ffffffffc0204dfa:	00fb8533          	add	a0,s7,a5
ffffffffc0204dfe:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204e02:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204e06:	0b597d63          	bgeu	s2,s5,ffffffffc0204ec0 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204e0a:	000cb683          	ld	a3,0(s9)
ffffffffc0204e0e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e10:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204e14:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e18:	8699                	srai	a3,a3,0x6
ffffffffc0204e1a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e1c:	67e2                	ld	a5,24(sp)
ffffffffc0204e1e:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e22:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e24:	0ac5f963          	bgeu	a1,a2,ffffffffc0204ed6 <do_execve+0x464>
ffffffffc0204e28:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e2c:	8652                	mv	a2,s4
ffffffffc0204e2e:	4581                	li	a1,0
ffffffffc0204e30:	96c2                	add	a3,a3,a6
ffffffffc0204e32:	9536                	add	a0,a0,a3
ffffffffc0204e34:	2cb000ef          	jal	ra,ffffffffc02058fe <memset>
            start += size;
ffffffffc0204e38:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204e3c:	03597463          	bgeu	s2,s5,ffffffffc0204e64 <do_execve+0x3f2>
ffffffffc0204e40:	d6e909e3          	beq	s2,a4,ffffffffc0204bb2 <do_execve+0x140>
ffffffffc0204e44:	00002697          	auipc	a3,0x2
ffffffffc0204e48:	5a468693          	addi	a3,a3,1444 # ffffffffc02073e8 <default_pmm_manager+0xbe8>
ffffffffc0204e4c:	00001617          	auipc	a2,0x1
ffffffffc0204e50:	60460613          	addi	a2,a2,1540 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204e54:	2c300593          	li	a1,707
ffffffffc0204e58:	00002517          	auipc	a0,0x2
ffffffffc0204e5c:	38850513          	addi	a0,a0,904 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204e60:	e2efb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204e64:	ff5710e3          	bne	a4,s5,ffffffffc0204e44 <do_execve+0x3d2>
ffffffffc0204e68:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204e6a:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204bb2 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e6e:	6c88                	ld	a0,24(s1)
ffffffffc0204e70:	866a                	mv	a2,s10
ffffffffc0204e72:	85d6                	mv	a1,s5
ffffffffc0204e74:	98dfe0ef          	jal	ra,ffffffffc0203800 <pgdir_alloc_page>
ffffffffc0204e78:	842a                	mv	s0,a0
ffffffffc0204e7a:	dd05                	beqz	a0,ffffffffc0204db2 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e7c:	6785                	lui	a5,0x1
ffffffffc0204e7e:	415b8533          	sub	a0,s7,s5
ffffffffc0204e82:	9abe                	add	s5,s5,a5
ffffffffc0204e84:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204e88:	01597463          	bgeu	s2,s5,ffffffffc0204e90 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204e8c:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204e90:	000cb683          	ld	a3,0(s9)
ffffffffc0204e94:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e96:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204e9a:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e9e:	8699                	srai	a3,a3,0x6
ffffffffc0204ea0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ea2:	67e2                	ld	a5,24(sp)
ffffffffc0204ea4:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ea8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204eaa:	02b87663          	bgeu	a6,a1,ffffffffc0204ed6 <do_execve+0x464>
ffffffffc0204eae:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204eb2:	4581                	li	a1,0
            start += size;
ffffffffc0204eb4:	9bb2                	add	s7,s7,a2
ffffffffc0204eb6:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204eb8:	9536                	add	a0,a0,a3
ffffffffc0204eba:	245000ef          	jal	ra,ffffffffc02058fe <memset>
ffffffffc0204ebe:	b775                	j	ffffffffc0204e6a <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204ec0:	417a8a33          	sub	s4,s5,s7
ffffffffc0204ec4:	b799                	j	ffffffffc0204e0a <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204ec6:	5a75                	li	s4,-3
ffffffffc0204ec8:	b3c1                	j	ffffffffc0204c88 <do_execve+0x216>
        while (start < end)
ffffffffc0204eca:	86de                	mv	a3,s7
ffffffffc0204ecc:	bf39                	j	ffffffffc0204dea <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204ece:	5a71                	li	s4,-4
ffffffffc0204ed0:	bdc5                	j	ffffffffc0204dc0 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204ed2:	5a61                	li	s4,-8
ffffffffc0204ed4:	b5c5                	j	ffffffffc0204db4 <do_execve+0x342>
ffffffffc0204ed6:	00001617          	auipc	a2,0x1
ffffffffc0204eda:	4ea60613          	addi	a2,a2,1258 # ffffffffc02063c0 <commands+0x830>
ffffffffc0204ede:	07100593          	li	a1,113
ffffffffc0204ee2:	00001517          	auipc	a0,0x1
ffffffffc0204ee6:	49650513          	addi	a0,a0,1174 # ffffffffc0206378 <commands+0x7e8>
ffffffffc0204eea:	da4fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204eee:	00002617          	auipc	a2,0x2
ffffffffc0204ef2:	9ba60613          	addi	a2,a2,-1606 # ffffffffc02068a8 <default_pmm_manager+0xa8>
ffffffffc0204ef6:	2e200593          	li	a1,738
ffffffffc0204efa:	00002517          	auipc	a0,0x2
ffffffffc0204efe:	2e650513          	addi	a0,a0,742 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204f02:	d8cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f06:	00002697          	auipc	a3,0x2
ffffffffc0204f0a:	5fa68693          	addi	a3,a3,1530 # ffffffffc0207500 <default_pmm_manager+0xd00>
ffffffffc0204f0e:	00001617          	auipc	a2,0x1
ffffffffc0204f12:	54260613          	addi	a2,a2,1346 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204f16:	2dd00593          	li	a1,733
ffffffffc0204f1a:	00002517          	auipc	a0,0x2
ffffffffc0204f1e:	2c650513          	addi	a0,a0,710 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204f22:	d6cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f26:	00002697          	auipc	a3,0x2
ffffffffc0204f2a:	59268693          	addi	a3,a3,1426 # ffffffffc02074b8 <default_pmm_manager+0xcb8>
ffffffffc0204f2e:	00001617          	auipc	a2,0x1
ffffffffc0204f32:	52260613          	addi	a2,a2,1314 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204f36:	2dc00593          	li	a1,732
ffffffffc0204f3a:	00002517          	auipc	a0,0x2
ffffffffc0204f3e:	2a650513          	addi	a0,a0,678 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204f42:	d4cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f46:	00002697          	auipc	a3,0x2
ffffffffc0204f4a:	52a68693          	addi	a3,a3,1322 # ffffffffc0207470 <default_pmm_manager+0xc70>
ffffffffc0204f4e:	00001617          	auipc	a2,0x1
ffffffffc0204f52:	50260613          	addi	a2,a2,1282 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204f56:	2db00593          	li	a1,731
ffffffffc0204f5a:	00002517          	auipc	a0,0x2
ffffffffc0204f5e:	28650513          	addi	a0,a0,646 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204f62:	d2cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204f66:	00002697          	auipc	a3,0x2
ffffffffc0204f6a:	4c268693          	addi	a3,a3,1218 # ffffffffc0207428 <default_pmm_manager+0xc28>
ffffffffc0204f6e:	00001617          	auipc	a2,0x1
ffffffffc0204f72:	4e260613          	addi	a2,a2,1250 # ffffffffc0206450 <commands+0x8c0>
ffffffffc0204f76:	2da00593          	li	a1,730
ffffffffc0204f7a:	00002517          	auipc	a0,0x2
ffffffffc0204f7e:	26650513          	addi	a0,a0,614 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc0204f82:	d0cfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f86 <do_yield>:
    current->need_resched = 1;
ffffffffc0204f86:	000ce797          	auipc	a5,0xce
ffffffffc0204f8a:	37a7b783          	ld	a5,890(a5) # ffffffffc02d3300 <current>
ffffffffc0204f8e:	4705                	li	a4,1
ffffffffc0204f90:	ef98                	sd	a4,24(a5)
}
ffffffffc0204f92:	4501                	li	a0,0
ffffffffc0204f94:	8082                	ret

ffffffffc0204f96 <do_wait>:
{
ffffffffc0204f96:	1101                	addi	sp,sp,-32
ffffffffc0204f98:	e822                	sd	s0,16(sp)
ffffffffc0204f9a:	e426                	sd	s1,8(sp)
ffffffffc0204f9c:	ec06                	sd	ra,24(sp)
ffffffffc0204f9e:	842e                	mv	s0,a1
ffffffffc0204fa0:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204fa2:	c999                	beqz	a1,ffffffffc0204fb8 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204fa4:	000ce797          	auipc	a5,0xce
ffffffffc0204fa8:	35c7b783          	ld	a5,860(a5) # ffffffffc02d3300 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204fac:	7788                	ld	a0,40(a5)
ffffffffc0204fae:	4685                	li	a3,1
ffffffffc0204fb0:	4611                	li	a2,4
ffffffffc0204fb2:	fabfe0ef          	jal	ra,ffffffffc0203f5c <user_mem_check>
ffffffffc0204fb6:	c909                	beqz	a0,ffffffffc0204fc8 <do_wait+0x32>
ffffffffc0204fb8:	85a2                	mv	a1,s0
}
ffffffffc0204fba:	6442                	ld	s0,16(sp)
ffffffffc0204fbc:	60e2                	ld	ra,24(sp)
ffffffffc0204fbe:	8526                	mv	a0,s1
ffffffffc0204fc0:	64a2                	ld	s1,8(sp)
ffffffffc0204fc2:	6105                	addi	sp,sp,32
ffffffffc0204fc4:	fb8ff06f          	j	ffffffffc020477c <do_wait.part.0>
ffffffffc0204fc8:	60e2                	ld	ra,24(sp)
ffffffffc0204fca:	6442                	ld	s0,16(sp)
ffffffffc0204fcc:	64a2                	ld	s1,8(sp)
ffffffffc0204fce:	5575                	li	a0,-3
ffffffffc0204fd0:	6105                	addi	sp,sp,32
ffffffffc0204fd2:	8082                	ret

ffffffffc0204fd4 <do_kill>:
{
ffffffffc0204fd4:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fd6:	6789                	lui	a5,0x2
{
ffffffffc0204fd8:	e406                	sd	ra,8(sp)
ffffffffc0204fda:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fdc:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204fe0:	17f9                	addi	a5,a5,-2
ffffffffc0204fe2:	02e7e963          	bltu	a5,a4,ffffffffc0205014 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fe6:	842a                	mv	s0,a0
ffffffffc0204fe8:	45a9                	li	a1,10
ffffffffc0204fea:	2501                	sext.w	a0,a0
ffffffffc0204fec:	46c000ef          	jal	ra,ffffffffc0205458 <hash32>
ffffffffc0204ff0:	02051793          	slli	a5,a0,0x20
ffffffffc0204ff4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204ff8:	000ca797          	auipc	a5,0xca
ffffffffc0204ffc:	29078793          	addi	a5,a5,656 # ffffffffc02cf288 <hash_list>
ffffffffc0205000:	953e                	add	a0,a0,a5
ffffffffc0205002:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0205004:	a029                	j	ffffffffc020500e <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0205006:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020500a:	00870b63          	beq	a4,s0,ffffffffc0205020 <do_kill+0x4c>
ffffffffc020500e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205010:	fef51be3          	bne	a0,a5,ffffffffc0205006 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0205014:	5475                	li	s0,-3
}
ffffffffc0205016:	60a2                	ld	ra,8(sp)
ffffffffc0205018:	8522                	mv	a0,s0
ffffffffc020501a:	6402                	ld	s0,0(sp)
ffffffffc020501c:	0141                	addi	sp,sp,16
ffffffffc020501e:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0205020:	fd87a703          	lw	a4,-40(a5)
ffffffffc0205024:	00177693          	andi	a3,a4,1
ffffffffc0205028:	e295                	bnez	a3,ffffffffc020504c <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020502a:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc020502c:	00176713          	ori	a4,a4,1
ffffffffc0205030:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0205034:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205036:	fe06d0e3          	bgez	a3,ffffffffc0205016 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc020503a:	f2878513          	addi	a0,a5,-216
ffffffffc020503e:	22e000ef          	jal	ra,ffffffffc020526c <wakeup_proc>
}
ffffffffc0205042:	60a2                	ld	ra,8(sp)
ffffffffc0205044:	8522                	mv	a0,s0
ffffffffc0205046:	6402                	ld	s0,0(sp)
ffffffffc0205048:	0141                	addi	sp,sp,16
ffffffffc020504a:	8082                	ret
        return -E_KILLED;
ffffffffc020504c:	545d                	li	s0,-9
ffffffffc020504e:	b7e1                	j	ffffffffc0205016 <do_kill+0x42>

ffffffffc0205050 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205050:	1101                	addi	sp,sp,-32
ffffffffc0205052:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205054:	000ce797          	auipc	a5,0xce
ffffffffc0205058:	23478793          	addi	a5,a5,564 # ffffffffc02d3288 <proc_list>
ffffffffc020505c:	ec06                	sd	ra,24(sp)
ffffffffc020505e:	e822                	sd	s0,16(sp)
ffffffffc0205060:	e04a                	sd	s2,0(sp)
ffffffffc0205062:	000ca497          	auipc	s1,0xca
ffffffffc0205066:	22648493          	addi	s1,s1,550 # ffffffffc02cf288 <hash_list>
ffffffffc020506a:	e79c                	sd	a5,8(a5)
ffffffffc020506c:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020506e:	000ce717          	auipc	a4,0xce
ffffffffc0205072:	21a70713          	addi	a4,a4,538 # ffffffffc02d3288 <proc_list>
ffffffffc0205076:	87a6                	mv	a5,s1
ffffffffc0205078:	e79c                	sd	a5,8(a5)
ffffffffc020507a:	e39c                	sd	a5,0(a5)
ffffffffc020507c:	07c1                	addi	a5,a5,16
ffffffffc020507e:	fef71de3          	bne	a4,a5,ffffffffc0205078 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205082:	f77fe0ef          	jal	ra,ffffffffc0203ff8 <alloc_proc>
ffffffffc0205086:	000ce917          	auipc	s2,0xce
ffffffffc020508a:	28290913          	addi	s2,s2,642 # ffffffffc02d3308 <idleproc>
ffffffffc020508e:	00a93023          	sd	a0,0(s2)
ffffffffc0205092:	0e050f63          	beqz	a0,ffffffffc0205190 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205096:	4789                	li	a5,2
ffffffffc0205098:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020509a:	00003797          	auipc	a5,0x3
ffffffffc020509e:	f6678793          	addi	a5,a5,-154 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050a2:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02050a6:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc02050a8:	4785                	li	a5,1
ffffffffc02050aa:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050ac:	4641                	li	a2,16
ffffffffc02050ae:	4581                	li	a1,0
ffffffffc02050b0:	8522                	mv	a0,s0
ffffffffc02050b2:	04d000ef          	jal	ra,ffffffffc02058fe <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02050b6:	463d                	li	a2,15
ffffffffc02050b8:	00002597          	auipc	a1,0x2
ffffffffc02050bc:	4a858593          	addi	a1,a1,1192 # ffffffffc0207560 <default_pmm_manager+0xd60>
ffffffffc02050c0:	8522                	mv	a0,s0
ffffffffc02050c2:	04f000ef          	jal	ra,ffffffffc0205910 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02050c6:	000ce717          	auipc	a4,0xce
ffffffffc02050ca:	25270713          	addi	a4,a4,594 # ffffffffc02d3318 <nr_process>
ffffffffc02050ce:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02050d0:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050d4:	4601                	li	a2,0
    nr_process++;
ffffffffc02050d6:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050d8:	4581                	li	a1,0
ffffffffc02050da:	00000517          	auipc	a0,0x0
ffffffffc02050de:	87450513          	addi	a0,a0,-1932 # ffffffffc020494e <init_main>
    nr_process++;
ffffffffc02050e2:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02050e4:	000ce797          	auipc	a5,0xce
ffffffffc02050e8:	20d7be23          	sd	a3,540(a5) # ffffffffc02d3300 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050ec:	cf6ff0ef          	jal	ra,ffffffffc02045e2 <kernel_thread>
ffffffffc02050f0:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02050f2:	08a05363          	blez	a0,ffffffffc0205178 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02050f6:	6789                	lui	a5,0x2
ffffffffc02050f8:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050fc:	17f9                	addi	a5,a5,-2
ffffffffc02050fe:	2501                	sext.w	a0,a0
ffffffffc0205100:	02e7e363          	bltu	a5,a4,ffffffffc0205126 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205104:	45a9                	li	a1,10
ffffffffc0205106:	352000ef          	jal	ra,ffffffffc0205458 <hash32>
ffffffffc020510a:	02051793          	slli	a5,a0,0x20
ffffffffc020510e:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0205112:	96a6                	add	a3,a3,s1
ffffffffc0205114:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205116:	a029                	j	ffffffffc0205120 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0205118:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c8c>
ffffffffc020511c:	04870b63          	beq	a4,s0,ffffffffc0205172 <proc_init+0x122>
    return listelm->next;
ffffffffc0205120:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205122:	fef69be3          	bne	a3,a5,ffffffffc0205118 <proc_init+0xc8>
    return NULL;
ffffffffc0205126:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205128:	0b478493          	addi	s1,a5,180
ffffffffc020512c:	4641                	li	a2,16
ffffffffc020512e:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205130:	000ce417          	auipc	s0,0xce
ffffffffc0205134:	1e040413          	addi	s0,s0,480 # ffffffffc02d3310 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205138:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc020513a:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020513c:	7c2000ef          	jal	ra,ffffffffc02058fe <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205140:	463d                	li	a2,15
ffffffffc0205142:	00002597          	auipc	a1,0x2
ffffffffc0205146:	44658593          	addi	a1,a1,1094 # ffffffffc0207588 <default_pmm_manager+0xd88>
ffffffffc020514a:	8526                	mv	a0,s1
ffffffffc020514c:	7c4000ef          	jal	ra,ffffffffc0205910 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205150:	00093783          	ld	a5,0(s2)
ffffffffc0205154:	cbb5                	beqz	a5,ffffffffc02051c8 <proc_init+0x178>
ffffffffc0205156:	43dc                	lw	a5,4(a5)
ffffffffc0205158:	eba5                	bnez	a5,ffffffffc02051c8 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020515a:	601c                	ld	a5,0(s0)
ffffffffc020515c:	c7b1                	beqz	a5,ffffffffc02051a8 <proc_init+0x158>
ffffffffc020515e:	43d8                	lw	a4,4(a5)
ffffffffc0205160:	4785                	li	a5,1
ffffffffc0205162:	04f71363          	bne	a4,a5,ffffffffc02051a8 <proc_init+0x158>
}
ffffffffc0205166:	60e2                	ld	ra,24(sp)
ffffffffc0205168:	6442                	ld	s0,16(sp)
ffffffffc020516a:	64a2                	ld	s1,8(sp)
ffffffffc020516c:	6902                	ld	s2,0(sp)
ffffffffc020516e:	6105                	addi	sp,sp,32
ffffffffc0205170:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205172:	f2878793          	addi	a5,a5,-216
ffffffffc0205176:	bf4d                	j	ffffffffc0205128 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0205178:	00002617          	auipc	a2,0x2
ffffffffc020517c:	3f060613          	addi	a2,a2,1008 # ffffffffc0207568 <default_pmm_manager+0xd68>
ffffffffc0205180:	40a00593          	li	a1,1034
ffffffffc0205184:	00002517          	auipc	a0,0x2
ffffffffc0205188:	05c50513          	addi	a0,a0,92 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc020518c:	b02fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205190:	00002617          	auipc	a2,0x2
ffffffffc0205194:	3b860613          	addi	a2,a2,952 # ffffffffc0207548 <default_pmm_manager+0xd48>
ffffffffc0205198:	3fb00593          	li	a1,1019
ffffffffc020519c:	00002517          	auipc	a0,0x2
ffffffffc02051a0:	04450513          	addi	a0,a0,68 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02051a4:	aeafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02051a8:	00002697          	auipc	a3,0x2
ffffffffc02051ac:	41068693          	addi	a3,a3,1040 # ffffffffc02075b8 <default_pmm_manager+0xdb8>
ffffffffc02051b0:	00001617          	auipc	a2,0x1
ffffffffc02051b4:	2a060613          	addi	a2,a2,672 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02051b8:	41100593          	li	a1,1041
ffffffffc02051bc:	00002517          	auipc	a0,0x2
ffffffffc02051c0:	02450513          	addi	a0,a0,36 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02051c4:	acafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02051c8:	00002697          	auipc	a3,0x2
ffffffffc02051cc:	3c868693          	addi	a3,a3,968 # ffffffffc0207590 <default_pmm_manager+0xd90>
ffffffffc02051d0:	00001617          	auipc	a2,0x1
ffffffffc02051d4:	28060613          	addi	a2,a2,640 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02051d8:	41000593          	li	a1,1040
ffffffffc02051dc:	00002517          	auipc	a0,0x2
ffffffffc02051e0:	00450513          	addi	a0,a0,4 # ffffffffc02071e0 <default_pmm_manager+0x9e0>
ffffffffc02051e4:	aaafb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02051e8 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02051e8:	1141                	addi	sp,sp,-16
ffffffffc02051ea:	e022                	sd	s0,0(sp)
ffffffffc02051ec:	e406                	sd	ra,8(sp)
ffffffffc02051ee:	000ce417          	auipc	s0,0xce
ffffffffc02051f2:	11240413          	addi	s0,s0,274 # ffffffffc02d3300 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02051f6:	6018                	ld	a4,0(s0)
ffffffffc02051f8:	6f1c                	ld	a5,24(a4)
ffffffffc02051fa:	dffd                	beqz	a5,ffffffffc02051f8 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02051fc:	0f0000ef          	jal	ra,ffffffffc02052ec <schedule>
ffffffffc0205200:	bfdd                	j	ffffffffc02051f6 <cpu_idle+0xe>

ffffffffc0205202 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205202:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205206:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc020520a:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020520c:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020520e:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205212:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205216:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020521a:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020521e:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205222:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205226:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020522a:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020522e:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205232:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205236:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020523a:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020523e:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205240:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205242:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205246:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020524a:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020524e:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205252:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205256:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020525a:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020525e:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205262:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205266:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020526a:	8082                	ret

ffffffffc020526c <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020526c:	4118                	lw	a4,0(a0)
{
ffffffffc020526e:	1101                	addi	sp,sp,-32
ffffffffc0205270:	ec06                	sd	ra,24(sp)
ffffffffc0205272:	e822                	sd	s0,16(sp)
ffffffffc0205274:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205276:	478d                	li	a5,3
ffffffffc0205278:	04f70b63          	beq	a4,a5,ffffffffc02052ce <wakeup_proc+0x62>
ffffffffc020527c:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020527e:	100027f3          	csrr	a5,sstatus
ffffffffc0205282:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205284:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205286:	ef9d                	bnez	a5,ffffffffc02052c4 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205288:	4789                	li	a5,2
ffffffffc020528a:	02f70163          	beq	a4,a5,ffffffffc02052ac <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc020528e:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205290:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205294:	e491                	bnez	s1,ffffffffc02052a0 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205296:	60e2                	ld	ra,24(sp)
ffffffffc0205298:	6442                	ld	s0,16(sp)
ffffffffc020529a:	64a2                	ld	s1,8(sp)
ffffffffc020529c:	6105                	addi	sp,sp,32
ffffffffc020529e:	8082                	ret
ffffffffc02052a0:	6442                	ld	s0,16(sp)
ffffffffc02052a2:	60e2                	ld	ra,24(sp)
ffffffffc02052a4:	64a2                	ld	s1,8(sp)
ffffffffc02052a6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02052a8:	f06fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc02052ac:	00002617          	auipc	a2,0x2
ffffffffc02052b0:	36c60613          	addi	a2,a2,876 # ffffffffc0207618 <default_pmm_manager+0xe18>
ffffffffc02052b4:	45d1                	li	a1,20
ffffffffc02052b6:	00002517          	auipc	a0,0x2
ffffffffc02052ba:	34a50513          	addi	a0,a0,842 # ffffffffc0207600 <default_pmm_manager+0xe00>
ffffffffc02052be:	a38fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc02052c2:	bfc9                	j	ffffffffc0205294 <wakeup_proc+0x28>
        intr_disable();
ffffffffc02052c4:	ef0fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02052c8:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc02052ca:	4485                	li	s1,1
ffffffffc02052cc:	bf75                	j	ffffffffc0205288 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02052ce:	00002697          	auipc	a3,0x2
ffffffffc02052d2:	31268693          	addi	a3,a3,786 # ffffffffc02075e0 <default_pmm_manager+0xde0>
ffffffffc02052d6:	00001617          	auipc	a2,0x1
ffffffffc02052da:	17a60613          	addi	a2,a2,378 # ffffffffc0206450 <commands+0x8c0>
ffffffffc02052de:	45a5                	li	a1,9
ffffffffc02052e0:	00002517          	auipc	a0,0x2
ffffffffc02052e4:	32050513          	addi	a0,a0,800 # ffffffffc0207600 <default_pmm_manager+0xe00>
ffffffffc02052e8:	9a6fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02052ec <schedule>:

void schedule(void)
{
ffffffffc02052ec:	1141                	addi	sp,sp,-16
ffffffffc02052ee:	e406                	sd	ra,8(sp)
ffffffffc02052f0:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02052f2:	100027f3          	csrr	a5,sstatus
ffffffffc02052f6:	8b89                	andi	a5,a5,2
ffffffffc02052f8:	4401                	li	s0,0
ffffffffc02052fa:	efbd                	bnez	a5,ffffffffc0205378 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02052fc:	000ce897          	auipc	a7,0xce
ffffffffc0205300:	0048b883          	ld	a7,4(a7) # ffffffffc02d3300 <current>
ffffffffc0205304:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205308:	000ce517          	auipc	a0,0xce
ffffffffc020530c:	00053503          	ld	a0,0(a0) # ffffffffc02d3308 <idleproc>
ffffffffc0205310:	04a88e63          	beq	a7,a0,ffffffffc020536c <schedule+0x80>
ffffffffc0205314:	0c888693          	addi	a3,a7,200
ffffffffc0205318:	000ce617          	auipc	a2,0xce
ffffffffc020531c:	f7060613          	addi	a2,a2,-144 # ffffffffc02d3288 <proc_list>
        le = last;
ffffffffc0205320:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205322:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205324:	4809                	li	a6,2
ffffffffc0205326:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205328:	00c78863          	beq	a5,a2,ffffffffc0205338 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc020532c:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205330:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205334:	03070163          	beq	a4,a6,ffffffffc0205356 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205338:	fef697e3          	bne	a3,a5,ffffffffc0205326 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020533c:	ed89                	bnez	a1,ffffffffc0205356 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020533e:	451c                	lw	a5,8(a0)
ffffffffc0205340:	2785                	addiw	a5,a5,1
ffffffffc0205342:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205344:	00a88463          	beq	a7,a0,ffffffffc020534c <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205348:	e1ffe0ef          	jal	ra,ffffffffc0204166 <proc_run>
    if (flag)
ffffffffc020534c:	e819                	bnez	s0,ffffffffc0205362 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020534e:	60a2                	ld	ra,8(sp)
ffffffffc0205350:	6402                	ld	s0,0(sp)
ffffffffc0205352:	0141                	addi	sp,sp,16
ffffffffc0205354:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205356:	4198                	lw	a4,0(a1)
ffffffffc0205358:	4789                	li	a5,2
ffffffffc020535a:	fef712e3          	bne	a4,a5,ffffffffc020533e <schedule+0x52>
ffffffffc020535e:	852e                	mv	a0,a1
ffffffffc0205360:	bff9                	j	ffffffffc020533e <schedule+0x52>
}
ffffffffc0205362:	6402                	ld	s0,0(sp)
ffffffffc0205364:	60a2                	ld	ra,8(sp)
ffffffffc0205366:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205368:	e46fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020536c:	000ce617          	auipc	a2,0xce
ffffffffc0205370:	f1c60613          	addi	a2,a2,-228 # ffffffffc02d3288 <proc_list>
ffffffffc0205374:	86b2                	mv	a3,a2
ffffffffc0205376:	b76d                	j	ffffffffc0205320 <schedule+0x34>
        intr_disable();
ffffffffc0205378:	e3cfb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020537c:	4405                	li	s0,1
ffffffffc020537e:	bfbd                	j	ffffffffc02052fc <schedule+0x10>

ffffffffc0205380 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205380:	000ce797          	auipc	a5,0xce
ffffffffc0205384:	f807b783          	ld	a5,-128(a5) # ffffffffc02d3300 <current>
}
ffffffffc0205388:	43c8                	lw	a0,4(a5)
ffffffffc020538a:	8082                	ret

ffffffffc020538c <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020538c:	4501                	li	a0,0
ffffffffc020538e:	8082                	ret

ffffffffc0205390 <sys_putc>:
    cputchar(c);
ffffffffc0205390:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205392:	1141                	addi	sp,sp,-16
ffffffffc0205394:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205396:	e35fa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc020539a:	60a2                	ld	ra,8(sp)
ffffffffc020539c:	4501                	li	a0,0
ffffffffc020539e:	0141                	addi	sp,sp,16
ffffffffc02053a0:	8082                	ret

ffffffffc02053a2 <sys_kill>:
    return do_kill(pid);
ffffffffc02053a2:	4108                	lw	a0,0(a0)
ffffffffc02053a4:	c31ff06f          	j	ffffffffc0204fd4 <do_kill>

ffffffffc02053a8 <sys_yield>:
    return do_yield();
ffffffffc02053a8:	bdfff06f          	j	ffffffffc0204f86 <do_yield>

ffffffffc02053ac <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02053ac:	6d14                	ld	a3,24(a0)
ffffffffc02053ae:	6910                	ld	a2,16(a0)
ffffffffc02053b0:	650c                	ld	a1,8(a0)
ffffffffc02053b2:	6108                	ld	a0,0(a0)
ffffffffc02053b4:	ebeff06f          	j	ffffffffc0204a72 <do_execve>

ffffffffc02053b8 <sys_wait>:
    return do_wait(pid, store);
ffffffffc02053b8:	650c                	ld	a1,8(a0)
ffffffffc02053ba:	4108                	lw	a0,0(a0)
ffffffffc02053bc:	bdbff06f          	j	ffffffffc0204f96 <do_wait>

ffffffffc02053c0 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02053c0:	000ce797          	auipc	a5,0xce
ffffffffc02053c4:	f407b783          	ld	a5,-192(a5) # ffffffffc02d3300 <current>
ffffffffc02053c8:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02053ca:	4501                	li	a0,0
ffffffffc02053cc:	6a0c                	ld	a1,16(a2)
ffffffffc02053ce:	e11fe06f          	j	ffffffffc02041de <do_fork>

ffffffffc02053d2 <sys_exit>:
    return do_exit(error_code);
ffffffffc02053d2:	4108                	lw	a0,0(a0)
ffffffffc02053d4:	a5eff06f          	j	ffffffffc0204632 <do_exit>

ffffffffc02053d8 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02053d8:	715d                	addi	sp,sp,-80
ffffffffc02053da:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053dc:	000ce497          	auipc	s1,0xce
ffffffffc02053e0:	f2448493          	addi	s1,s1,-220 # ffffffffc02d3300 <current>
ffffffffc02053e4:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02053e6:	e0a2                	sd	s0,64(sp)
ffffffffc02053e8:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053ea:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02053ec:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053ee:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02053f0:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053f4:	0327ee63          	bltu	a5,s2,ffffffffc0205430 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02053f8:	00391713          	slli	a4,s2,0x3
ffffffffc02053fc:	00002797          	auipc	a5,0x2
ffffffffc0205400:	28478793          	addi	a5,a5,644 # ffffffffc0207680 <syscalls>
ffffffffc0205404:	97ba                	add	a5,a5,a4
ffffffffc0205406:	639c                	ld	a5,0(a5)
ffffffffc0205408:	c785                	beqz	a5,ffffffffc0205430 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc020540a:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc020540c:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc020540e:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc0205410:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc0205412:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205414:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc0205416:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc0205418:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc020541a:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc020541c:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020541e:	0028                	addi	a0,sp,8
ffffffffc0205420:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205422:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205424:	e828                	sd	a0,80(s0)
}
ffffffffc0205426:	6406                	ld	s0,64(sp)
ffffffffc0205428:	74e2                	ld	s1,56(sp)
ffffffffc020542a:	7942                	ld	s2,48(sp)
ffffffffc020542c:	6161                	addi	sp,sp,80
ffffffffc020542e:	8082                	ret
    print_trapframe(tf);
ffffffffc0205430:	8522                	mv	a0,s0
ffffffffc0205432:	f72fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205436:	609c                	ld	a5,0(s1)
ffffffffc0205438:	86ca                	mv	a3,s2
ffffffffc020543a:	00002617          	auipc	a2,0x2
ffffffffc020543e:	1fe60613          	addi	a2,a2,510 # ffffffffc0207638 <default_pmm_manager+0xe38>
ffffffffc0205442:	43d8                	lw	a4,4(a5)
ffffffffc0205444:	06200593          	li	a1,98
ffffffffc0205448:	0b478793          	addi	a5,a5,180
ffffffffc020544c:	00002517          	auipc	a0,0x2
ffffffffc0205450:	21c50513          	addi	a0,a0,540 # ffffffffc0207668 <default_pmm_manager+0xe68>
ffffffffc0205454:	83afb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205458 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205458:	9e3707b7          	lui	a5,0x9e370
ffffffffc020545c:	2785                	addiw	a5,a5,1
ffffffffc020545e:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205462:	02000793          	li	a5,32
ffffffffc0205466:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205468:	00f5553b          	srlw	a0,a0,a5
ffffffffc020546c:	8082                	ret

ffffffffc020546e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020546e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205472:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205474:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205478:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020547a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020547e:	f022                	sd	s0,32(sp)
ffffffffc0205480:	ec26                	sd	s1,24(sp)
ffffffffc0205482:	e84a                	sd	s2,16(sp)
ffffffffc0205484:	f406                	sd	ra,40(sp)
ffffffffc0205486:	e44e                	sd	s3,8(sp)
ffffffffc0205488:	84aa                	mv	s1,a0
ffffffffc020548a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020548c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205490:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205492:	03067e63          	bgeu	a2,a6,ffffffffc02054ce <printnum+0x60>
ffffffffc0205496:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205498:	00805763          	blez	s0,ffffffffc02054a6 <printnum+0x38>
ffffffffc020549c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020549e:	85ca                	mv	a1,s2
ffffffffc02054a0:	854e                	mv	a0,s3
ffffffffc02054a2:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02054a4:	fc65                	bnez	s0,ffffffffc020549c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054a6:	1a02                	slli	s4,s4,0x20
ffffffffc02054a8:	00002797          	auipc	a5,0x2
ffffffffc02054ac:	2d878793          	addi	a5,a5,728 # ffffffffc0207780 <syscalls+0x100>
ffffffffc02054b0:	020a5a13          	srli	s4,s4,0x20
ffffffffc02054b4:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02054b6:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054b8:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02054bc:	70a2                	ld	ra,40(sp)
ffffffffc02054be:	69a2                	ld	s3,8(sp)
ffffffffc02054c0:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054c2:	85ca                	mv	a1,s2
ffffffffc02054c4:	87a6                	mv	a5,s1
}
ffffffffc02054c6:	6942                	ld	s2,16(sp)
ffffffffc02054c8:	64e2                	ld	s1,24(sp)
ffffffffc02054ca:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054cc:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02054ce:	03065633          	divu	a2,a2,a6
ffffffffc02054d2:	8722                	mv	a4,s0
ffffffffc02054d4:	f9bff0ef          	jal	ra,ffffffffc020546e <printnum>
ffffffffc02054d8:	b7f9                	j	ffffffffc02054a6 <printnum+0x38>

ffffffffc02054da <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02054da:	7119                	addi	sp,sp,-128
ffffffffc02054dc:	f4a6                	sd	s1,104(sp)
ffffffffc02054de:	f0ca                	sd	s2,96(sp)
ffffffffc02054e0:	ecce                	sd	s3,88(sp)
ffffffffc02054e2:	e8d2                	sd	s4,80(sp)
ffffffffc02054e4:	e4d6                	sd	s5,72(sp)
ffffffffc02054e6:	e0da                	sd	s6,64(sp)
ffffffffc02054e8:	fc5e                	sd	s7,56(sp)
ffffffffc02054ea:	f06a                	sd	s10,32(sp)
ffffffffc02054ec:	fc86                	sd	ra,120(sp)
ffffffffc02054ee:	f8a2                	sd	s0,112(sp)
ffffffffc02054f0:	f862                	sd	s8,48(sp)
ffffffffc02054f2:	f466                	sd	s9,40(sp)
ffffffffc02054f4:	ec6e                	sd	s11,24(sp)
ffffffffc02054f6:	892a                	mv	s2,a0
ffffffffc02054f8:	84ae                	mv	s1,a1
ffffffffc02054fa:	8d32                	mv	s10,a2
ffffffffc02054fc:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054fe:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0205502:	5b7d                	li	s6,-1
ffffffffc0205504:	00002a97          	auipc	s5,0x2
ffffffffc0205508:	2a8a8a93          	addi	s5,s5,680 # ffffffffc02077ac <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020550c:	00002b97          	auipc	s7,0x2
ffffffffc0205510:	4bcb8b93          	addi	s7,s7,1212 # ffffffffc02079c8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205514:	000d4503          	lbu	a0,0(s10)
ffffffffc0205518:	001d0413          	addi	s0,s10,1
ffffffffc020551c:	01350a63          	beq	a0,s3,ffffffffc0205530 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205520:	c121                	beqz	a0,ffffffffc0205560 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205522:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205524:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205526:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205528:	fff44503          	lbu	a0,-1(s0)
ffffffffc020552c:	ff351ae3          	bne	a0,s3,ffffffffc0205520 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205530:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205534:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205538:	4c81                	li	s9,0
ffffffffc020553a:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020553c:	5c7d                	li	s8,-1
ffffffffc020553e:	5dfd                	li	s11,-1
ffffffffc0205540:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205544:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205546:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020554a:	0ff5f593          	zext.b	a1,a1
ffffffffc020554e:	00140d13          	addi	s10,s0,1
ffffffffc0205552:	04b56263          	bltu	a0,a1,ffffffffc0205596 <vprintfmt+0xbc>
ffffffffc0205556:	058a                	slli	a1,a1,0x2
ffffffffc0205558:	95d6                	add	a1,a1,s5
ffffffffc020555a:	4194                	lw	a3,0(a1)
ffffffffc020555c:	96d6                	add	a3,a3,s5
ffffffffc020555e:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205560:	70e6                	ld	ra,120(sp)
ffffffffc0205562:	7446                	ld	s0,112(sp)
ffffffffc0205564:	74a6                	ld	s1,104(sp)
ffffffffc0205566:	7906                	ld	s2,96(sp)
ffffffffc0205568:	69e6                	ld	s3,88(sp)
ffffffffc020556a:	6a46                	ld	s4,80(sp)
ffffffffc020556c:	6aa6                	ld	s5,72(sp)
ffffffffc020556e:	6b06                	ld	s6,64(sp)
ffffffffc0205570:	7be2                	ld	s7,56(sp)
ffffffffc0205572:	7c42                	ld	s8,48(sp)
ffffffffc0205574:	7ca2                	ld	s9,40(sp)
ffffffffc0205576:	7d02                	ld	s10,32(sp)
ffffffffc0205578:	6de2                	ld	s11,24(sp)
ffffffffc020557a:	6109                	addi	sp,sp,128
ffffffffc020557c:	8082                	ret
            padc = '0';
ffffffffc020557e:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205580:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205584:	846a                	mv	s0,s10
ffffffffc0205586:	00140d13          	addi	s10,s0,1
ffffffffc020558a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020558e:	0ff5f593          	zext.b	a1,a1
ffffffffc0205592:	fcb572e3          	bgeu	a0,a1,ffffffffc0205556 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205596:	85a6                	mv	a1,s1
ffffffffc0205598:	02500513          	li	a0,37
ffffffffc020559c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020559e:	fff44783          	lbu	a5,-1(s0)
ffffffffc02055a2:	8d22                	mv	s10,s0
ffffffffc02055a4:	f73788e3          	beq	a5,s3,ffffffffc0205514 <vprintfmt+0x3a>
ffffffffc02055a8:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02055ac:	1d7d                	addi	s10,s10,-1
ffffffffc02055ae:	ff379de3          	bne	a5,s3,ffffffffc02055a8 <vprintfmt+0xce>
ffffffffc02055b2:	b78d                	j	ffffffffc0205514 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02055b4:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02055b8:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055bc:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02055be:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02055c2:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02055c6:	02d86463          	bltu	a6,a3,ffffffffc02055ee <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02055ca:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02055ce:	002c169b          	slliw	a3,s8,0x2
ffffffffc02055d2:	0186873b          	addw	a4,a3,s8
ffffffffc02055d6:	0017171b          	slliw	a4,a4,0x1
ffffffffc02055da:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02055dc:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02055e0:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02055e2:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02055e6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02055ea:	fed870e3          	bgeu	a6,a3,ffffffffc02055ca <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02055ee:	f40ddce3          	bgez	s11,ffffffffc0205546 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02055f2:	8de2                	mv	s11,s8
ffffffffc02055f4:	5c7d                	li	s8,-1
ffffffffc02055f6:	bf81                	j	ffffffffc0205546 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02055f8:	fffdc693          	not	a3,s11
ffffffffc02055fc:	96fd                	srai	a3,a3,0x3f
ffffffffc02055fe:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205602:	00144603          	lbu	a2,1(s0)
ffffffffc0205606:	2d81                	sext.w	s11,s11
ffffffffc0205608:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020560a:	bf35                	j	ffffffffc0205546 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc020560c:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205610:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205614:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205616:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0205618:	bfd9                	j	ffffffffc02055ee <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020561a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020561c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205620:	01174463          	blt	a4,a7,ffffffffc0205628 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205624:	1a088e63          	beqz	a7,ffffffffc02057e0 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205628:	000a3603          	ld	a2,0(s4)
ffffffffc020562c:	46c1                	li	a3,16
ffffffffc020562e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205630:	2781                	sext.w	a5,a5
ffffffffc0205632:	876e                	mv	a4,s11
ffffffffc0205634:	85a6                	mv	a1,s1
ffffffffc0205636:	854a                	mv	a0,s2
ffffffffc0205638:	e37ff0ef          	jal	ra,ffffffffc020546e <printnum>
            break;
ffffffffc020563c:	bde1                	j	ffffffffc0205514 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020563e:	000a2503          	lw	a0,0(s4)
ffffffffc0205642:	85a6                	mv	a1,s1
ffffffffc0205644:	0a21                	addi	s4,s4,8
ffffffffc0205646:	9902                	jalr	s2
            break;
ffffffffc0205648:	b5f1                	j	ffffffffc0205514 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020564a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020564c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205650:	01174463          	blt	a4,a7,ffffffffc0205658 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205654:	18088163          	beqz	a7,ffffffffc02057d6 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205658:	000a3603          	ld	a2,0(s4)
ffffffffc020565c:	46a9                	li	a3,10
ffffffffc020565e:	8a2e                	mv	s4,a1
ffffffffc0205660:	bfc1                	j	ffffffffc0205630 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205662:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205666:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205668:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020566a:	bdf1                	j	ffffffffc0205546 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020566c:	85a6                	mv	a1,s1
ffffffffc020566e:	02500513          	li	a0,37
ffffffffc0205672:	9902                	jalr	s2
            break;
ffffffffc0205674:	b545                	j	ffffffffc0205514 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205676:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020567a:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020567c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020567e:	b5e1                	j	ffffffffc0205546 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205680:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205682:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205686:	01174463          	blt	a4,a7,ffffffffc020568e <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020568a:	14088163          	beqz	a7,ffffffffc02057cc <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020568e:	000a3603          	ld	a2,0(s4)
ffffffffc0205692:	46a1                	li	a3,8
ffffffffc0205694:	8a2e                	mv	s4,a1
ffffffffc0205696:	bf69                	j	ffffffffc0205630 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205698:	03000513          	li	a0,48
ffffffffc020569c:	85a6                	mv	a1,s1
ffffffffc020569e:	e03e                	sd	a5,0(sp)
ffffffffc02056a0:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02056a2:	85a6                	mv	a1,s1
ffffffffc02056a4:	07800513          	li	a0,120
ffffffffc02056a8:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056aa:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02056ac:	6782                	ld	a5,0(sp)
ffffffffc02056ae:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056b0:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02056b4:	bfb5                	j	ffffffffc0205630 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02056b6:	000a3403          	ld	s0,0(s4)
ffffffffc02056ba:	008a0713          	addi	a4,s4,8
ffffffffc02056be:	e03a                	sd	a4,0(sp)
ffffffffc02056c0:	14040263          	beqz	s0,ffffffffc0205804 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02056c4:	0fb05763          	blez	s11,ffffffffc02057b2 <vprintfmt+0x2d8>
ffffffffc02056c8:	02d00693          	li	a3,45
ffffffffc02056cc:	0cd79163          	bne	a5,a3,ffffffffc020578e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056d0:	00044783          	lbu	a5,0(s0)
ffffffffc02056d4:	0007851b          	sext.w	a0,a5
ffffffffc02056d8:	cf85                	beqz	a5,ffffffffc0205710 <vprintfmt+0x236>
ffffffffc02056da:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056de:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056e2:	000c4563          	bltz	s8,ffffffffc02056ec <vprintfmt+0x212>
ffffffffc02056e6:	3c7d                	addiw	s8,s8,-1
ffffffffc02056e8:	036c0263          	beq	s8,s6,ffffffffc020570c <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02056ec:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056ee:	0e0c8e63          	beqz	s9,ffffffffc02057ea <vprintfmt+0x310>
ffffffffc02056f2:	3781                	addiw	a5,a5,-32
ffffffffc02056f4:	0ef47b63          	bgeu	s0,a5,ffffffffc02057ea <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02056f8:	03f00513          	li	a0,63
ffffffffc02056fc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056fe:	000a4783          	lbu	a5,0(s4)
ffffffffc0205702:	3dfd                	addiw	s11,s11,-1
ffffffffc0205704:	0a05                	addi	s4,s4,1
ffffffffc0205706:	0007851b          	sext.w	a0,a5
ffffffffc020570a:	ffe1                	bnez	a5,ffffffffc02056e2 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc020570c:	01b05963          	blez	s11,ffffffffc020571e <vprintfmt+0x244>
ffffffffc0205710:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0205712:	85a6                	mv	a1,s1
ffffffffc0205714:	02000513          	li	a0,32
ffffffffc0205718:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020571a:	fe0d9be3          	bnez	s11,ffffffffc0205710 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020571e:	6a02                	ld	s4,0(sp)
ffffffffc0205720:	bbd5                	j	ffffffffc0205514 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205722:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205724:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205728:	01174463          	blt	a4,a7,ffffffffc0205730 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020572c:	08088d63          	beqz	a7,ffffffffc02057c6 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205730:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205734:	0a044d63          	bltz	s0,ffffffffc02057ee <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205738:	8622                	mv	a2,s0
ffffffffc020573a:	8a66                	mv	s4,s9
ffffffffc020573c:	46a9                	li	a3,10
ffffffffc020573e:	bdcd                	j	ffffffffc0205630 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205740:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205744:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205746:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205748:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020574c:	8fb5                	xor	a5,a5,a3
ffffffffc020574e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205752:	02d74163          	blt	a4,a3,ffffffffc0205774 <vprintfmt+0x29a>
ffffffffc0205756:	00369793          	slli	a5,a3,0x3
ffffffffc020575a:	97de                	add	a5,a5,s7
ffffffffc020575c:	639c                	ld	a5,0(a5)
ffffffffc020575e:	cb99                	beqz	a5,ffffffffc0205774 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205760:	86be                	mv	a3,a5
ffffffffc0205762:	00000617          	auipc	a2,0x0
ffffffffc0205766:	1ee60613          	addi	a2,a2,494 # ffffffffc0205950 <etext+0x28>
ffffffffc020576a:	85a6                	mv	a1,s1
ffffffffc020576c:	854a                	mv	a0,s2
ffffffffc020576e:	0ce000ef          	jal	ra,ffffffffc020583c <printfmt>
ffffffffc0205772:	b34d                	j	ffffffffc0205514 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205774:	00002617          	auipc	a2,0x2
ffffffffc0205778:	02c60613          	addi	a2,a2,44 # ffffffffc02077a0 <syscalls+0x120>
ffffffffc020577c:	85a6                	mv	a1,s1
ffffffffc020577e:	854a                	mv	a0,s2
ffffffffc0205780:	0bc000ef          	jal	ra,ffffffffc020583c <printfmt>
ffffffffc0205784:	bb41                	j	ffffffffc0205514 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205786:	00002417          	auipc	s0,0x2
ffffffffc020578a:	01240413          	addi	s0,s0,18 # ffffffffc0207798 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020578e:	85e2                	mv	a1,s8
ffffffffc0205790:	8522                	mv	a0,s0
ffffffffc0205792:	e43e                	sd	a5,8(sp)
ffffffffc0205794:	0e2000ef          	jal	ra,ffffffffc0205876 <strnlen>
ffffffffc0205798:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020579c:	01b05b63          	blez	s11,ffffffffc02057b2 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02057a0:	67a2                	ld	a5,8(sp)
ffffffffc02057a2:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057a6:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02057a8:	85a6                	mv	a1,s1
ffffffffc02057aa:	8552                	mv	a0,s4
ffffffffc02057ac:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057ae:	fe0d9ce3          	bnez	s11,ffffffffc02057a6 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057b2:	00044783          	lbu	a5,0(s0)
ffffffffc02057b6:	00140a13          	addi	s4,s0,1
ffffffffc02057ba:	0007851b          	sext.w	a0,a5
ffffffffc02057be:	d3a5                	beqz	a5,ffffffffc020571e <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057c0:	05e00413          	li	s0,94
ffffffffc02057c4:	bf39                	j	ffffffffc02056e2 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02057c6:	000a2403          	lw	s0,0(s4)
ffffffffc02057ca:	b7ad                	j	ffffffffc0205734 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02057cc:	000a6603          	lwu	a2,0(s4)
ffffffffc02057d0:	46a1                	li	a3,8
ffffffffc02057d2:	8a2e                	mv	s4,a1
ffffffffc02057d4:	bdb1                	j	ffffffffc0205630 <vprintfmt+0x156>
ffffffffc02057d6:	000a6603          	lwu	a2,0(s4)
ffffffffc02057da:	46a9                	li	a3,10
ffffffffc02057dc:	8a2e                	mv	s4,a1
ffffffffc02057de:	bd89                	j	ffffffffc0205630 <vprintfmt+0x156>
ffffffffc02057e0:	000a6603          	lwu	a2,0(s4)
ffffffffc02057e4:	46c1                	li	a3,16
ffffffffc02057e6:	8a2e                	mv	s4,a1
ffffffffc02057e8:	b5a1                	j	ffffffffc0205630 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02057ea:	9902                	jalr	s2
ffffffffc02057ec:	bf09                	j	ffffffffc02056fe <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02057ee:	85a6                	mv	a1,s1
ffffffffc02057f0:	02d00513          	li	a0,45
ffffffffc02057f4:	e03e                	sd	a5,0(sp)
ffffffffc02057f6:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02057f8:	6782                	ld	a5,0(sp)
ffffffffc02057fa:	8a66                	mv	s4,s9
ffffffffc02057fc:	40800633          	neg	a2,s0
ffffffffc0205800:	46a9                	li	a3,10
ffffffffc0205802:	b53d                	j	ffffffffc0205630 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0205804:	03b05163          	blez	s11,ffffffffc0205826 <vprintfmt+0x34c>
ffffffffc0205808:	02d00693          	li	a3,45
ffffffffc020580c:	f6d79de3          	bne	a5,a3,ffffffffc0205786 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205810:	00002417          	auipc	s0,0x2
ffffffffc0205814:	f8840413          	addi	s0,s0,-120 # ffffffffc0207798 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205818:	02800793          	li	a5,40
ffffffffc020581c:	02800513          	li	a0,40
ffffffffc0205820:	00140a13          	addi	s4,s0,1
ffffffffc0205824:	bd6d                	j	ffffffffc02056de <vprintfmt+0x204>
ffffffffc0205826:	00002a17          	auipc	s4,0x2
ffffffffc020582a:	f73a0a13          	addi	s4,s4,-141 # ffffffffc0207799 <syscalls+0x119>
ffffffffc020582e:	02800513          	li	a0,40
ffffffffc0205832:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205836:	05e00413          	li	s0,94
ffffffffc020583a:	b565                	j	ffffffffc02056e2 <vprintfmt+0x208>

ffffffffc020583c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020583c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020583e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205842:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205844:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205846:	ec06                	sd	ra,24(sp)
ffffffffc0205848:	f83a                	sd	a4,48(sp)
ffffffffc020584a:	fc3e                	sd	a5,56(sp)
ffffffffc020584c:	e0c2                	sd	a6,64(sp)
ffffffffc020584e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205850:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205852:	c89ff0ef          	jal	ra,ffffffffc02054da <vprintfmt>
}
ffffffffc0205856:	60e2                	ld	ra,24(sp)
ffffffffc0205858:	6161                	addi	sp,sp,80
ffffffffc020585a:	8082                	ret

ffffffffc020585c <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020585c:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205860:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205862:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205864:	cb81                	beqz	a5,ffffffffc0205874 <strlen+0x18>
        cnt ++;
ffffffffc0205866:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205868:	00a707b3          	add	a5,a4,a0
ffffffffc020586c:	0007c783          	lbu	a5,0(a5)
ffffffffc0205870:	fbfd                	bnez	a5,ffffffffc0205866 <strlen+0xa>
ffffffffc0205872:	8082                	ret
    }
    return cnt;
}
ffffffffc0205874:	8082                	ret

ffffffffc0205876 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205876:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205878:	e589                	bnez	a1,ffffffffc0205882 <strnlen+0xc>
ffffffffc020587a:	a811                	j	ffffffffc020588e <strnlen+0x18>
        cnt ++;
ffffffffc020587c:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020587e:	00f58863          	beq	a1,a5,ffffffffc020588e <strnlen+0x18>
ffffffffc0205882:	00f50733          	add	a4,a0,a5
ffffffffc0205886:	00074703          	lbu	a4,0(a4)
ffffffffc020588a:	fb6d                	bnez	a4,ffffffffc020587c <strnlen+0x6>
ffffffffc020588c:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020588e:	852e                	mv	a0,a1
ffffffffc0205890:	8082                	ret

ffffffffc0205892 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205892:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205894:	0005c703          	lbu	a4,0(a1)
ffffffffc0205898:	0785                	addi	a5,a5,1
ffffffffc020589a:	0585                	addi	a1,a1,1
ffffffffc020589c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02058a0:	fb75                	bnez	a4,ffffffffc0205894 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02058a2:	8082                	ret

ffffffffc02058a4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02058a4:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058a8:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02058ac:	cb89                	beqz	a5,ffffffffc02058be <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02058ae:	0505                	addi	a0,a0,1
ffffffffc02058b0:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02058b2:	fee789e3          	beq	a5,a4,ffffffffc02058a4 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058b6:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02058ba:	9d19                	subw	a0,a0,a4
ffffffffc02058bc:	8082                	ret
ffffffffc02058be:	4501                	li	a0,0
ffffffffc02058c0:	bfed                	j	ffffffffc02058ba <strcmp+0x16>

ffffffffc02058c2 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058c2:	c20d                	beqz	a2,ffffffffc02058e4 <strncmp+0x22>
ffffffffc02058c4:	962e                	add	a2,a2,a1
ffffffffc02058c6:	a031                	j	ffffffffc02058d2 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02058c8:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058ca:	00e79a63          	bne	a5,a4,ffffffffc02058de <strncmp+0x1c>
ffffffffc02058ce:	00b60b63          	beq	a2,a1,ffffffffc02058e4 <strncmp+0x22>
ffffffffc02058d2:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02058d6:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058d8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02058dc:	f7f5                	bnez	a5,ffffffffc02058c8 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058de:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02058e2:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058e4:	4501                	li	a0,0
ffffffffc02058e6:	8082                	ret

ffffffffc02058e8 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02058e8:	00054783          	lbu	a5,0(a0)
ffffffffc02058ec:	c799                	beqz	a5,ffffffffc02058fa <strchr+0x12>
        if (*s == c) {
ffffffffc02058ee:	00f58763          	beq	a1,a5,ffffffffc02058fc <strchr+0x14>
    while (*s != '\0') {
ffffffffc02058f2:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02058f6:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02058f8:	fbfd                	bnez	a5,ffffffffc02058ee <strchr+0x6>
    }
    return NULL;
ffffffffc02058fa:	4501                	li	a0,0
}
ffffffffc02058fc:	8082                	ret

ffffffffc02058fe <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02058fe:	ca01                	beqz	a2,ffffffffc020590e <memset+0x10>
ffffffffc0205900:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205902:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205904:	0785                	addi	a5,a5,1
ffffffffc0205906:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020590a:	fec79de3          	bne	a5,a2,ffffffffc0205904 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020590e:	8082                	ret

ffffffffc0205910 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205910:	ca19                	beqz	a2,ffffffffc0205926 <memcpy+0x16>
ffffffffc0205912:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205914:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205916:	0005c703          	lbu	a4,0(a1)
ffffffffc020591a:	0585                	addi	a1,a1,1
ffffffffc020591c:	0785                	addi	a5,a5,1
ffffffffc020591e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205922:	fec59ae3          	bne	a1,a2,ffffffffc0205916 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205926:	8082                	ret
