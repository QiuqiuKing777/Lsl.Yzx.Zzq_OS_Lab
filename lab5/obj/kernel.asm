
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
ffffffffc020004e:	ebe50513          	addi	a0,a0,-322 # ffffffffc02cef08 <buf>
ffffffffc0200052:	000d3617          	auipc	a2,0xd3
ffffffffc0200056:	35a60613          	addi	a2,a2,858 # ffffffffc02d33ac <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	079050ef          	jal	ra,ffffffffc02058da <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	89a58593          	addi	a1,a1,-1894 # ffffffffc0205908 <etext+0x4>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	8b250513          	addi	a0,a0,-1870 # ffffffffc0205928 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	06d020ef          	jal	ra,ffffffffc02028f2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	383030ef          	jal	ra,ffffffffc0203c14 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	797040ef          	jal	ra,ffffffffc020502c <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	122050ef          	jal	ra,ffffffffc02051c4 <cpu_idle>

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
ffffffffc02000c0:	87450513          	addi	a0,a0,-1932 # ffffffffc0205930 <etext+0x2c>
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
ffffffffc02000d6:	e36b8b93          	addi	s7,s7,-458 # ffffffffc02cef08 <buf>
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
ffffffffc0200132:	dda50513          	addi	a0,a0,-550 # ffffffffc02cef08 <buf>
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
ffffffffc0200188:	32e050ef          	jal	ra,ffffffffc02054b6 <vprintfmt>
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
ffffffffc02001be:	2f8050ef          	jal	ra,ffffffffc02054b6 <vprintfmt>
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
ffffffffc0200222:	71a50513          	addi	a0,a0,1818 # ffffffffc0205938 <etext+0x34>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	72450513          	addi	a0,a0,1828 # ffffffffc0205958 <etext+0x54>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	6c458593          	addi	a1,a1,1732 # ffffffffc0205904 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	73050513          	addi	a0,a0,1840 # ffffffffc0205978 <etext+0x74>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000cf597          	auipc	a1,0xcf
ffffffffc0200258:	cb458593          	addi	a1,a1,-844 # ffffffffc02cef08 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	73c50513          	addi	a0,a0,1852 # ffffffffc0205998 <etext+0x94>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000d3597          	auipc	a1,0xd3
ffffffffc020026c:	14458593          	addi	a1,a1,324 # ffffffffc02d33ac <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	74850513          	addi	a0,a0,1864 # ffffffffc02059b8 <etext+0xb4>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000d3597          	auipc	a1,0xd3
ffffffffc0200280:	52f58593          	addi	a1,a1,1327 # ffffffffc02d37ab <end+0x3ff>
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
ffffffffc02002a2:	73a50513          	addi	a0,a0,1850 # ffffffffc02059d8 <etext+0xd4>
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
ffffffffc02002b0:	75c60613          	addi	a2,a2,1884 # ffffffffc0205a08 <etext+0x104>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	76850513          	addi	a0,a0,1896 # ffffffffc0205a20 <etext+0x11c>
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
ffffffffc02002cc:	77060613          	addi	a2,a2,1904 # ffffffffc0205a38 <etext+0x134>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	78858593          	addi	a1,a1,1928 # ffffffffc0205a58 <etext+0x154>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	78850513          	addi	a0,a0,1928 # ffffffffc0205a60 <etext+0x15c>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	78a60613          	addi	a2,a2,1930 # ffffffffc0205a70 <etext+0x16c>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	7aa58593          	addi	a1,a1,1962 # ffffffffc0205a98 <etext+0x194>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	76a50513          	addi	a0,a0,1898 # ffffffffc0205a60 <etext+0x15c>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	7a660613          	addi	a2,a2,1958 # ffffffffc0205aa8 <etext+0x1a4>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	7be58593          	addi	a1,a1,1982 # ffffffffc0205ac8 <etext+0x1c4>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	74e50513          	addi	a0,a0,1870 # ffffffffc0205a60 <etext+0x15c>
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
ffffffffc0200350:	78c50513          	addi	a0,a0,1932 # ffffffffc0205ad8 <etext+0x1d4>
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
ffffffffc0200372:	79250513          	addi	a0,a0,1938 # ffffffffc0205b00 <etext+0x1fc>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	7ecc0c13          	addi	s8,s8,2028 # ffffffffc0205b70 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	79c90913          	addi	s2,s2,1948 # ffffffffc0205b28 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	79c48493          	addi	s1,s1,1948 # ffffffffc0205b30 <etext+0x22c>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	79ab0b13          	addi	s6,s6,1946 # ffffffffc0205b38 <etext+0x234>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	6b2a0a13          	addi	s4,s4,1714 # ffffffffc0205a58 <etext+0x154>
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
ffffffffc02003cc:	7a8d0d13          	addi	s10,s10,1960 # ffffffffc0205b70 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	4aa050ef          	jal	ra,ffffffffc0205880 <strcmp>
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
ffffffffc02003ea:	496050ef          	jal	ra,ffffffffc0205880 <strcmp>
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
ffffffffc0200428:	49c050ef          	jal	ra,ffffffffc02058c4 <strchr>
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
ffffffffc0200466:	45e050ef          	jal	ra,ffffffffc02058c4 <strchr>
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
ffffffffc0200484:	6d850513          	addi	a0,a0,1752 # ffffffffc0205b58 <etext+0x254>
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
ffffffffc0200492:	ea230313          	addi	t1,t1,-350 # ffffffffc02d3330 <is_panic>
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
ffffffffc02004c0:	6fc50513          	addi	a0,a0,1788 # ffffffffc0205bb8 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	7f650513          	addi	a0,a0,2038 # ffffffffc0206cc8 <default_pmm_manager+0x4f8>
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
ffffffffc020050a:	6d250513          	addi	a0,a0,1746 # ffffffffc0205bd8 <commands+0x68>
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
ffffffffc020052a:	7a250513          	addi	a0,a0,1954 # ffffffffc0206cc8 <default_pmm_manager+0x4f8>
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
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd568>
ffffffffc0200540:	000d3717          	auipc	a4,0xd3
ffffffffc0200544:	e0f73023          	sd	a5,-512(a4) # ffffffffc02d3340 <timebase>
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
ffffffffc0200564:	69850513          	addi	a0,a0,1688 # ffffffffc0205bf8 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000d3797          	auipc	a5,0xd3
ffffffffc020056c:	dc07b823          	sd	zero,-560(a5) # ffffffffc02d3338 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000d3797          	auipc	a5,0xd3
ffffffffc020057a:	dca7b783          	ld	a5,-566(a5) # ffffffffc02d3340 <timebase>
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
ffffffffc0200604:	61850513          	addi	a0,a0,1560 # ffffffffc0205c18 <commands+0xa8>
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
ffffffffc0200632:	5fa50513          	addi	a0,a0,1530 # ffffffffc0205c28 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	5f450513          	addi	a0,a0,1524 # ffffffffc0205c38 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	5fc50513          	addi	a0,a0,1532 # ffffffffc0205c50 <commands+0xe0>
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
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe0cb41>
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
ffffffffc0200712:	59290913          	addi	s2,s2,1426 # ffffffffc0205ca0 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	57c48493          	addi	s1,s1,1404 # ffffffffc0205c98 <commands+0x128>
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
ffffffffc0200774:	5a850513          	addi	a0,a0,1448 # ffffffffc0205d18 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	5d450513          	addi	a0,a0,1492 # ffffffffc0205d50 <commands+0x1e0>
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
ffffffffc02007c0:	4b450513          	addi	a0,a0,1204 # ffffffffc0205c70 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	06e050ef          	jal	ra,ffffffffc0205838 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	0c6050ef          	jal	ra,ffffffffc020589e <strncmp>
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
ffffffffc020086e:	012050ef          	jal	ra,ffffffffc0205880 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	42650513          	addi	a0,a0,1062 # ffffffffc0205ca8 <commands+0x138>
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
ffffffffc0200954:	37850513          	addi	a0,a0,888 # ffffffffc0205cc8 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	37e50513          	addi	a0,a0,894 # ffffffffc0205ce0 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	38c50513          	addi	a0,a0,908 # ffffffffc0205d00 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	3d050513          	addi	a0,a0,976 # ffffffffc0205d50 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000d3797          	auipc	a5,0xd3
ffffffffc020098c:	9c87b023          	sd	s0,-1600(a5) # ffffffffc02d3348 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000d3797          	auipc	a5,0xd3
ffffffffc0200994:	9d67b023          	sd	s6,-1600(a5) # ffffffffc02d3350 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000d3517          	auipc	a0,0xd3
ffffffffc020099e:	9ae53503          	ld	a0,-1618(a0) # ffffffffc02d3348 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000d3517          	auipc	a0,0xd3
ffffffffc02009a8:	9ac53503          	ld	a0,-1620(a0) # ffffffffc02d3350 <memory_size>
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
ffffffffc02009c4:	66078793          	addi	a5,a5,1632 # ffffffffc0201020 <__alltraps>
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
ffffffffc02009e2:	38a50513          	addi	a0,a0,906 # ffffffffc0205d68 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	39250513          	addi	a0,a0,914 # ffffffffc0205d80 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	39c50513          	addi	a0,a0,924 # ffffffffc0205d98 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	3a650513          	addi	a0,a0,934 # ffffffffc0205db0 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	3b050513          	addi	a0,a0,944 # ffffffffc0205dc8 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	3ba50513          	addi	a0,a0,954 # ffffffffc0205de0 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	3c450513          	addi	a0,a0,964 # ffffffffc0205df8 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	3ce50513          	addi	a0,a0,974 # ffffffffc0205e10 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	3d850513          	addi	a0,a0,984 # ffffffffc0205e28 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	3e250513          	addi	a0,a0,994 # ffffffffc0205e40 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205e58 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	3f650513          	addi	a0,a0,1014 # ffffffffc0205e70 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	40050513          	addi	a0,a0,1024 # ffffffffc0205e88 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	40a50513          	addi	a0,a0,1034 # ffffffffc0205ea0 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	41450513          	addi	a0,a0,1044 # ffffffffc0205eb8 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	41e50513          	addi	a0,a0,1054 # ffffffffc0205ed0 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	42850513          	addi	a0,a0,1064 # ffffffffc0205ee8 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	43250513          	addi	a0,a0,1074 # ffffffffc0205f00 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	43c50513          	addi	a0,a0,1084 # ffffffffc0205f18 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	44650513          	addi	a0,a0,1094 # ffffffffc0205f30 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	45050513          	addi	a0,a0,1104 # ffffffffc0205f48 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	45a50513          	addi	a0,a0,1114 # ffffffffc0205f60 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	46450513          	addi	a0,a0,1124 # ffffffffc0205f78 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	46e50513          	addi	a0,a0,1134 # ffffffffc0205f90 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	47850513          	addi	a0,a0,1144 # ffffffffc0205fa8 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	48250513          	addi	a0,a0,1154 # ffffffffc0205fc0 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	48c50513          	addi	a0,a0,1164 # ffffffffc0205fd8 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	49650513          	addi	a0,a0,1174 # ffffffffc0205ff0 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	4a050513          	addi	a0,a0,1184 # ffffffffc0206008 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	4aa50513          	addi	a0,a0,1194 # ffffffffc0206020 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	4b450513          	addi	a0,a0,1204 # ffffffffc0206038 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	4ba50513          	addi	a0,a0,1210 # ffffffffc0206050 <commands+0x4e0>
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
ffffffffc0200bb0:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206068 <commands+0x4f8>
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
ffffffffc0200bc8:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206080 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	4c450513          	addi	a0,a0,1220 # ffffffffc0206098 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	4cc50513          	addi	a0,a0,1228 # ffffffffc02060b0 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	4c850513          	addi	a0,a0,1224 # ffffffffc02060c0 <commands+0x550>
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
ffffffffc0200c10:	08f76463          	bltu	a4,a5,ffffffffc0200c98 <interrupt_handler+0x92>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	56470713          	addi	a4,a4,1380 # ffffffffc0206178 <commands+0x608>
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
ffffffffc0200c2a:	51250513          	addi	a0,a0,1298 # ffffffffc0206138 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	4e650513          	addi	a0,a0,1254 # ffffffffc0206118 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	49a50513          	addi	a0,a0,1178 # ffffffffc02060d8 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	4ae50513          	addi	a0,a0,1198 # ffffffffc02060f8 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
        break;
    case IRQ_U_TIMER:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_TIMER:
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        ticks++;
ffffffffc0200c5e:	000d2797          	auipc	a5,0xd2
ffffffffc0200c62:	6da78793          	addi	a5,a5,1754 # ffffffffc02d3338 <ticks>
ffffffffc0200c66:	6398                	ld	a4,0(a5)
ffffffffc0200c68:	0705                	addi	a4,a4,1
ffffffffc0200c6a:	e398                	sd	a4,0(a5)
        if(ticks%TICK_NUM==0&&current){
ffffffffc0200c6c:	639c                	ld	a5,0(a5)
ffffffffc0200c6e:	06400713          	li	a4,100
ffffffffc0200c72:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c76:	eb81                	bnez	a5,ffffffffc0200c86 <interrupt_handler+0x80>
ffffffffc0200c78:	000d2797          	auipc	a5,0xd2
ffffffffc0200c7c:	7187b783          	ld	a5,1816(a5) # ffffffffc02d3390 <current>
ffffffffc0200c80:	c399                	beqz	a5,ffffffffc0200c86 <interrupt_handler+0x80>
           current->need_resched=1;
ffffffffc0200c82:	4705                	li	a4,1
ffffffffc0200c84:	ef98                	sd	a4,24(a5)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c86:	60a2                	ld	ra,8(sp)
ffffffffc0200c88:	0141                	addi	sp,sp,16
ffffffffc0200c8a:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c8c:	00005517          	auipc	a0,0x5
ffffffffc0200c90:	4cc50513          	addi	a0,a0,1228 # ffffffffc0206158 <commands+0x5e8>
ffffffffc0200c94:	d00ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c98:	b731                	j	ffffffffc0200ba4 <print_trapframe>

ffffffffc0200c9a <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c9a:	11853783          	ld	a5,280(a0)
{
ffffffffc0200c9e:	715d                	addi	sp,sp,-80
ffffffffc0200ca0:	e0a2                	sd	s0,64(sp)
ffffffffc0200ca2:	e486                	sd	ra,72(sp)
ffffffffc0200ca4:	fc26                	sd	s1,56(sp)
ffffffffc0200ca6:	f84a                	sd	s2,48(sp)
ffffffffc0200ca8:	f44e                	sd	s3,40(sp)
ffffffffc0200caa:	f052                	sd	s4,32(sp)
ffffffffc0200cac:	ec56                	sd	s5,24(sp)
ffffffffc0200cae:	e85a                	sd	s6,16(sp)
ffffffffc0200cb0:	e45e                	sd	s7,8(sp)
ffffffffc0200cb2:	473d                	li	a4,15
ffffffffc0200cb4:	842a                	mv	s0,a0
ffffffffc0200cb6:	1ef76363          	bltu	a4,a5,ffffffffc0200e9c <exception_handler+0x202>
ffffffffc0200cba:	00005717          	auipc	a4,0x5
ffffffffc0200cbe:	71670713          	addi	a4,a4,1814 # ffffffffc02063d0 <commands+0x860>
ffffffffc0200cc2:	078a                	slli	a5,a5,0x2
ffffffffc0200cc4:	97ba                	add	a5,a5,a4
ffffffffc0200cc6:	439c                	lw	a5,0(a5)
ffffffffc0200cc8:	97ba                	add	a5,a5,a4
ffffffffc0200cca:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200ccc:	00005517          	auipc	a0,0x5
ffffffffc0200cd0:	5c450513          	addi	a0,a0,1476 # ffffffffc0206290 <commands+0x720>
ffffffffc0200cd4:	cc0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cd8:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cdc:	60a6                	ld	ra,72(sp)
ffffffffc0200cde:	74e2                	ld	s1,56(sp)
        tf->epc += 4;
ffffffffc0200ce0:	0791                	addi	a5,a5,4
ffffffffc0200ce2:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200ce6:	6406                	ld	s0,64(sp)
ffffffffc0200ce8:	7942                	ld	s2,48(sp)
ffffffffc0200cea:	79a2                	ld	s3,40(sp)
ffffffffc0200cec:	7a02                	ld	s4,32(sp)
ffffffffc0200cee:	6ae2                	ld	s5,24(sp)
ffffffffc0200cf0:	6b42                	ld	s6,16(sp)
ffffffffc0200cf2:	6ba2                	ld	s7,8(sp)
ffffffffc0200cf4:	6161                	addi	sp,sp,80
        syscall();
ffffffffc0200cf6:	6be0406f          	j	ffffffffc02053b4 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cfa:	00005517          	auipc	a0,0x5
ffffffffc0200cfe:	5b650513          	addi	a0,a0,1462 # ffffffffc02062b0 <commands+0x740>
}
ffffffffc0200d02:	6406                	ld	s0,64(sp)
ffffffffc0200d04:	60a6                	ld	ra,72(sp)
ffffffffc0200d06:	74e2                	ld	s1,56(sp)
ffffffffc0200d08:	7942                	ld	s2,48(sp)
ffffffffc0200d0a:	79a2                	ld	s3,40(sp)
ffffffffc0200d0c:	7a02                	ld	s4,32(sp)
ffffffffc0200d0e:	6ae2                	ld	s5,24(sp)
ffffffffc0200d10:	6b42                	ld	s6,16(sp)
ffffffffc0200d12:	6ba2                	ld	s7,8(sp)
ffffffffc0200d14:	6161                	addi	sp,sp,80
        cprintf("Instruction access fault\n");
ffffffffc0200d16:	c7eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d1a:	00005517          	auipc	a0,0x5
ffffffffc0200d1e:	5b650513          	addi	a0,a0,1462 # ffffffffc02062d0 <commands+0x760>
ffffffffc0200d22:	b7c5                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Instruction page fault\n");
ffffffffc0200d24:	00005517          	auipc	a0,0x5
ffffffffc0200d28:	5cc50513          	addi	a0,a0,1484 # ffffffffc02062f0 <commands+0x780>
ffffffffc0200d2c:	bfd9                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Load page fault\n");
ffffffffc0200d2e:	00005517          	auipc	a0,0x5
ffffffffc0200d32:	5da50513          	addi	a0,a0,1498 # ffffffffc0206308 <commands+0x798>
ffffffffc0200d36:	b7f1                	j	ffffffffc0200d02 <exception_handler+0x68>
        uintptr_t badaddr = read_csr(stval);
ffffffffc0200d38:	143024f3          	csrr	s1,stval
        if (current != NULL && current->mm != NULL) {
ffffffffc0200d3c:	000d2917          	auipc	s2,0xd2
ffffffffc0200d40:	65490913          	addi	s2,s2,1620 # ffffffffc02d3390 <current>
ffffffffc0200d44:	00093783          	ld	a5,0(s2)
ffffffffc0200d48:	16078663          	beqz	a5,ffffffffc0200eb4 <exception_handler+0x21a>
ffffffffc0200d4c:	779c                	ld	a5,40(a5)
ffffffffc0200d4e:	16078363          	beqz	a5,ffffffffc0200eb4 <exception_handler+0x21a>
            pte_t *ptep = get_pte(current->mm->pgdir, badaddr, 0);
ffffffffc0200d52:	6f88                	ld	a0,24(a5)
ffffffffc0200d54:	4601                	li	a2,0
ffffffffc0200d56:	85a6                	mv	a1,s1
ffffffffc0200d58:	3b4010ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc0200d5c:	842a                	mv	s0,a0
            if (ptep != NULL && (*ptep & PTE_V) && (*ptep & PTE_COW)) {
ffffffffc0200d5e:	14050b63          	beqz	a0,ffffffffc0200eb4 <exception_handler+0x21a>
ffffffffc0200d62:	611c                	ld	a5,0(a0)
ffffffffc0200d64:	10100713          	li	a4,257
ffffffffc0200d68:	1017f693          	andi	a3,a5,257
ffffffffc0200d6c:	14e69463          	bne	a3,a4,ffffffffc0200eb4 <exception_handler+0x21a>
}

static inline struct Page *
pte2page(pte_t pte)
{
    if (!(pte & PTE_V))
ffffffffc0200d70:	0017f713          	andi	a4,a5,1
ffffffffc0200d74:	20070563          	beqz	a4,ffffffffc0200f7e <exception_handler+0x2e4>
    if (PPN(pa) >= npage)
ffffffffc0200d78:	000d2b17          	auipc	s6,0xd2
ffffffffc0200d7c:	5f8b0b13          	addi	s6,s6,1528 # ffffffffc02d3370 <npage>
ffffffffc0200d80:	000b3683          	ld	a3,0(s6)
    {
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
ffffffffc0200d84:	00279713          	slli	a4,a5,0x2
ffffffffc0200d88:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0200d8a:	1cd77e63          	bgeu	a4,a3,ffffffffc0200f66 <exception_handler+0x2cc>
    return &pages[PPN(pa) - nbase];
ffffffffc0200d8e:	000d2b97          	auipc	s7,0xd2
ffffffffc0200d92:	5eab8b93          	addi	s7,s7,1514 # ffffffffc02d3378 <pages>
ffffffffc0200d96:	000bb983          	ld	s3,0(s7)
ffffffffc0200d9a:	00007a97          	auipc	s5,0x7
ffffffffc0200d9e:	cc6aba83          	ld	s5,-826(s5) # ffffffffc0207a60 <nbase>
ffffffffc0200da2:	41570733          	sub	a4,a4,s5
ffffffffc0200da6:	071a                	slli	a4,a4,0x6
ffffffffc0200da8:	99ba                	add	s3,s3,a4
                if (page_ref(page) > 1) {
ffffffffc0200daa:	0009a683          	lw	a3,0(s3)
        uintptr_t la = ROUNDDOWN(badaddr, PGSIZE);
ffffffffc0200dae:	767d                	lui	a2,0xfffff
                if (page_ref(page) > 1) {
ffffffffc0200db0:	4705                	li	a4,1
        uintptr_t la = ROUNDDOWN(badaddr, PGSIZE);
ffffffffc0200db2:	8cf1                	and	s1,s1,a2
                if (page_ref(page) > 1) {
ffffffffc0200db4:	14d75b63          	bge	a4,a3,ffffffffc0200f0a <exception_handler+0x270>
                    struct Page *npage = alloc_page();
ffffffffc0200db8:	4505                	li	a0,1
ffffffffc0200dba:	29a010ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0200dbe:	8a2a                	mv	s4,a0
                    if (npage == NULL) panic("COW: out of memory");
ffffffffc0200dc0:	18050763          	beqz	a0,ffffffffc0200f4e <exception_handler+0x2b4>
    return page - pages + nbase;
ffffffffc0200dc4:	000bb583          	ld	a1,0(s7)
    return KADDR(page2pa(page));
ffffffffc0200dc8:	577d                	li	a4,-1
ffffffffc0200dca:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc0200dce:	40b507b3          	sub	a5,a0,a1
ffffffffc0200dd2:	8799                	srai	a5,a5,0x6
ffffffffc0200dd4:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0200dd6:	8331                	srli	a4,a4,0xc
ffffffffc0200dd8:	00e7f533          	and	a0,a5,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ddc:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0200de0:	14c57b63          	bgeu	a0,a2,ffffffffc0200f36 <exception_handler+0x29c>
    return page - pages + nbase;
ffffffffc0200de4:	40b987b3          	sub	a5,s3,a1
ffffffffc0200de8:	8799                	srai	a5,a5,0x6
ffffffffc0200dea:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0200dec:	000d2597          	auipc	a1,0xd2
ffffffffc0200df0:	59c5b583          	ld	a1,1436(a1) # ffffffffc02d3388 <va_pa_offset>
ffffffffc0200df4:	8f7d                	and	a4,a4,a5
ffffffffc0200df6:	00b68533          	add	a0,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dfa:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0200dfe:	12c77c63          	bgeu	a4,a2,ffffffffc0200f36 <exception_handler+0x29c>
                    memcpy(page2kva(npage), page2kva(page), PGSIZE);
ffffffffc0200e02:	95b6                	add	a1,a1,a3
ffffffffc0200e04:	6605                	lui	a2,0x1
ffffffffc0200e06:	2e7040ef          	jal	ra,ffffffffc02058ec <memcpy>
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e0a:	00093783          	ld	a5,0(s2)
                    uint32_t perm = (*ptep & PTE_USER);
ffffffffc0200e0e:	6014                	ld	a3,0(s0)
}
ffffffffc0200e10:	6406                	ld	s0,64(sp)
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e12:	779c                	ld	a5,40(a5)
}
ffffffffc0200e14:	60a6                	ld	ra,72(sp)
ffffffffc0200e16:	7942                	ld	s2,48(sp)
ffffffffc0200e18:	79a2                	ld	s3,40(sp)
ffffffffc0200e1a:	6ae2                	ld	s5,24(sp)
ffffffffc0200e1c:	6b42                	ld	s6,16(sp)
ffffffffc0200e1e:	6ba2                	ld	s7,8(sp)
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e20:	6f88                	ld	a0,24(a5)
ffffffffc0200e22:	8626                	mv	a2,s1
ffffffffc0200e24:	85d2                	mv	a1,s4
}
ffffffffc0200e26:	74e2                	ld	s1,56(sp)
ffffffffc0200e28:	7a02                	ld	s4,32(sp)
                    perm = (perm | PTE_W) & ~PTE_COW;
ffffffffc0200e2a:	8aed                	andi	a3,a3,27
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e2c:	0046e693          	ori	a3,a3,4
}
ffffffffc0200e30:	6161                	addi	sp,sp,80
                    page_insert(current->mm->pgdir, npage, la, perm);
ffffffffc0200e32:	1cb0106f          	j	ffffffffc02027fc <page_insert>
        cprintf("Instruction address misaligned\n");
ffffffffc0200e36:	00005517          	auipc	a0,0x5
ffffffffc0200e3a:	37250513          	addi	a0,a0,882 # ffffffffc02061a8 <commands+0x638>
ffffffffc0200e3e:	b5d1                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Instruction access fault\n");
ffffffffc0200e40:	00005517          	auipc	a0,0x5
ffffffffc0200e44:	38850513          	addi	a0,a0,904 # ffffffffc02061c8 <commands+0x658>
ffffffffc0200e48:	bd6d                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Illegal instruction\n");
ffffffffc0200e4a:	00005517          	auipc	a0,0x5
ffffffffc0200e4e:	39e50513          	addi	a0,a0,926 # ffffffffc02061e8 <commands+0x678>
ffffffffc0200e52:	bd45                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Breakpoint\n");
ffffffffc0200e54:	00005517          	auipc	a0,0x5
ffffffffc0200e58:	3ac50513          	addi	a0,a0,940 # ffffffffc0206200 <commands+0x690>
ffffffffc0200e5c:	b38ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200e60:	6458                	ld	a4,136(s0)
ffffffffc0200e62:	47a9                	li	a5,10
ffffffffc0200e64:	06f70963          	beq	a4,a5,ffffffffc0200ed6 <exception_handler+0x23c>
}
ffffffffc0200e68:	60a6                	ld	ra,72(sp)
ffffffffc0200e6a:	6406                	ld	s0,64(sp)
ffffffffc0200e6c:	74e2                	ld	s1,56(sp)
ffffffffc0200e6e:	7942                	ld	s2,48(sp)
ffffffffc0200e70:	79a2                	ld	s3,40(sp)
ffffffffc0200e72:	7a02                	ld	s4,32(sp)
ffffffffc0200e74:	6ae2                	ld	s5,24(sp)
ffffffffc0200e76:	6b42                	ld	s6,16(sp)
ffffffffc0200e78:	6ba2                	ld	s7,8(sp)
ffffffffc0200e7a:	6161                	addi	sp,sp,80
ffffffffc0200e7c:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200e7e:	00005517          	auipc	a0,0x5
ffffffffc0200e82:	39250513          	addi	a0,a0,914 # ffffffffc0206210 <commands+0x6a0>
ffffffffc0200e86:	bdb5                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Load access fault\n");
ffffffffc0200e88:	00005517          	auipc	a0,0x5
ffffffffc0200e8c:	3a850513          	addi	a0,a0,936 # ffffffffc0206230 <commands+0x6c0>
ffffffffc0200e90:	bd8d                	j	ffffffffc0200d02 <exception_handler+0x68>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e92:	00005517          	auipc	a0,0x5
ffffffffc0200e96:	3e650513          	addi	a0,a0,998 # ffffffffc0206278 <commands+0x708>
ffffffffc0200e9a:	b5a5                	j	ffffffffc0200d02 <exception_handler+0x68>
        print_trapframe(tf);
ffffffffc0200e9c:	8522                	mv	a0,s0
}
ffffffffc0200e9e:	6406                	ld	s0,64(sp)
ffffffffc0200ea0:	60a6                	ld	ra,72(sp)
ffffffffc0200ea2:	74e2                	ld	s1,56(sp)
ffffffffc0200ea4:	7942                	ld	s2,48(sp)
ffffffffc0200ea6:	79a2                	ld	s3,40(sp)
ffffffffc0200ea8:	7a02                	ld	s4,32(sp)
ffffffffc0200eaa:	6ae2                	ld	s5,24(sp)
ffffffffc0200eac:	6b42                	ld	s6,16(sp)
ffffffffc0200eae:	6ba2                	ld	s7,8(sp)
ffffffffc0200eb0:	6161                	addi	sp,sp,80
        print_trapframe(tf);
ffffffffc0200eb2:	b9cd                	j	ffffffffc0200ba4 <print_trapframe>
        cprintf("Store/AMO page fault\n");
ffffffffc0200eb4:	00005517          	auipc	a0,0x5
ffffffffc0200eb8:	50450513          	addi	a0,a0,1284 # ffffffffc02063b8 <commands+0x848>
ffffffffc0200ebc:	b599                	j	ffffffffc0200d02 <exception_handler+0x68>
        panic("AMO address misaligned\n");
ffffffffc0200ebe:	00005617          	auipc	a2,0x5
ffffffffc0200ec2:	38a60613          	addi	a2,a2,906 # ffffffffc0206248 <commands+0x6d8>
ffffffffc0200ec6:	0b700593          	li	a1,183
ffffffffc0200eca:	00005517          	auipc	a0,0x5
ffffffffc0200ece:	39650513          	addi	a0,a0,918 # ffffffffc0206260 <commands+0x6f0>
ffffffffc0200ed2:	dbcff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200ed6:	10843783          	ld	a5,264(s0)
ffffffffc0200eda:	0791                	addi	a5,a5,4
ffffffffc0200edc:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200ee0:	4d4040ef          	jal	ra,ffffffffc02053b4 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200ee4:	000d2797          	auipc	a5,0xd2
ffffffffc0200ee8:	4ac7b783          	ld	a5,1196(a5) # ffffffffc02d3390 <current>
ffffffffc0200eec:	6b9c                	ld	a5,16(a5)
ffffffffc0200eee:	8522                	mv	a0,s0
}
ffffffffc0200ef0:	6406                	ld	s0,64(sp)
ffffffffc0200ef2:	60a6                	ld	ra,72(sp)
ffffffffc0200ef4:	74e2                	ld	s1,56(sp)
ffffffffc0200ef6:	7942                	ld	s2,48(sp)
ffffffffc0200ef8:	79a2                	ld	s3,40(sp)
ffffffffc0200efa:	7a02                	ld	s4,32(sp)
ffffffffc0200efc:	6ae2                	ld	s5,24(sp)
ffffffffc0200efe:	6b42                	ld	s6,16(sp)
ffffffffc0200f00:	6ba2                	ld	s7,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f02:	6589                	lui	a1,0x2
ffffffffc0200f04:	95be                	add	a1,a1,a5
}
ffffffffc0200f06:	6161                	addi	sp,sp,80
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f08:	a2dd                	j	ffffffffc02010ee <kernel_execve_ret>
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f0a:	00093703          	ld	a4,0(s2)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f0e:	efb7f793          	andi	a5,a5,-261
}
ffffffffc0200f12:	6406                	ld	s0,64(sp)
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f14:	7718                	ld	a4,40(a4)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f16:	0047e793          	ori	a5,a5,4
}
ffffffffc0200f1a:	60a6                	ld	ra,72(sp)
ffffffffc0200f1c:	7942                	ld	s2,48(sp)
ffffffffc0200f1e:	79a2                	ld	s3,40(sp)
ffffffffc0200f20:	7a02                	ld	s4,32(sp)
ffffffffc0200f22:	6ae2                	ld	s5,24(sp)
ffffffffc0200f24:	6b42                	ld	s6,16(sp)
ffffffffc0200f26:	6ba2                	ld	s7,8(sp)
                    *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc0200f28:	e11c                	sd	a5,0(a0)
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f2a:	85a6                	mv	a1,s1
ffffffffc0200f2c:	6f08                	ld	a0,24(a4)
}
ffffffffc0200f2e:	74e2                	ld	s1,56(sp)
ffffffffc0200f30:	6161                	addi	sp,sp,80
                    tlb_invalidate(current->mm->pgdir, la);
ffffffffc0200f32:	0a50206f          	j	ffffffffc02037d6 <tlb_invalidate>
ffffffffc0200f36:	00005617          	auipc	a2,0x5
ffffffffc0200f3a:	45a60613          	addi	a2,a2,1114 # ffffffffc0206390 <commands+0x820>
ffffffffc0200f3e:	07100593          	li	a1,113
ffffffffc0200f42:	00005517          	auipc	a0,0x5
ffffffffc0200f46:	40650513          	addi	a0,a0,1030 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0200f4a:	d44ff0ef          	jal	ra,ffffffffc020048e <__panic>
                    if (npage == NULL) panic("COW: out of memory");
ffffffffc0200f4e:	00005617          	auipc	a2,0x5
ffffffffc0200f52:	42a60613          	addi	a2,a2,1066 # ffffffffc0206378 <commands+0x808>
ffffffffc0200f56:	0dd00593          	li	a1,221
ffffffffc0200f5a:	00005517          	auipc	a0,0x5
ffffffffc0200f5e:	30650513          	addi	a0,a0,774 # ffffffffc0206260 <commands+0x6f0>
ffffffffc0200f62:	d2cff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0200f66:	00005617          	auipc	a2,0x5
ffffffffc0200f6a:	3f260613          	addi	a2,a2,1010 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0200f6e:	06900593          	li	a1,105
ffffffffc0200f72:	00005517          	auipc	a0,0x5
ffffffffc0200f76:	3d650513          	addi	a0,a0,982 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0200f7a:	d14ff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0200f7e:	00005617          	auipc	a2,0x5
ffffffffc0200f82:	3a260613          	addi	a2,a2,930 # ffffffffc0206320 <commands+0x7b0>
ffffffffc0200f86:	07f00593          	li	a1,127
ffffffffc0200f8a:	00005517          	auipc	a0,0x5
ffffffffc0200f8e:	3be50513          	addi	a0,a0,958 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0200f92:	cfcff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0200f96 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200f96:	1101                	addi	sp,sp,-32
ffffffffc0200f98:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200f9a:	000d2417          	auipc	s0,0xd2
ffffffffc0200f9e:	3f640413          	addi	s0,s0,1014 # ffffffffc02d3390 <current>
ffffffffc0200fa2:	6018                	ld	a4,0(s0)
{
ffffffffc0200fa4:	ec06                	sd	ra,24(sp)
ffffffffc0200fa6:	e426                	sd	s1,8(sp)
ffffffffc0200fa8:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200faa:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200fae:	cf1d                	beqz	a4,ffffffffc0200fec <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200fb0:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200fb4:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200fb8:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200fba:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200fbe:	0206c463          	bltz	a3,ffffffffc0200fe6 <trap+0x50>
        exception_handler(tf);
ffffffffc0200fc2:	cd9ff0ef          	jal	ra,ffffffffc0200c9a <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200fc6:	601c                	ld	a5,0(s0)
ffffffffc0200fc8:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200fcc:	e499                	bnez	s1,ffffffffc0200fda <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200fce:	0b07a703          	lw	a4,176(a5)
ffffffffc0200fd2:	8b05                	andi	a4,a4,1
ffffffffc0200fd4:	e329                	bnez	a4,ffffffffc0201016 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200fd6:	6f9c                	ld	a5,24(a5)
ffffffffc0200fd8:	eb85                	bnez	a5,ffffffffc0201008 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200fda:	60e2                	ld	ra,24(sp)
ffffffffc0200fdc:	6442                	ld	s0,16(sp)
ffffffffc0200fde:	64a2                	ld	s1,8(sp)
ffffffffc0200fe0:	6902                	ld	s2,0(sp)
ffffffffc0200fe2:	6105                	addi	sp,sp,32
ffffffffc0200fe4:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200fe6:	c21ff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200fea:	bff1                	j	ffffffffc0200fc6 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200fec:	0006c863          	bltz	a3,ffffffffc0200ffc <trap+0x66>
}
ffffffffc0200ff0:	6442                	ld	s0,16(sp)
ffffffffc0200ff2:	60e2                	ld	ra,24(sp)
ffffffffc0200ff4:	64a2                	ld	s1,8(sp)
ffffffffc0200ff6:	6902                	ld	s2,0(sp)
ffffffffc0200ff8:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200ffa:	b145                	j	ffffffffc0200c9a <exception_handler>
}
ffffffffc0200ffc:	6442                	ld	s0,16(sp)
ffffffffc0200ffe:	60e2                	ld	ra,24(sp)
ffffffffc0201000:	64a2                	ld	s1,8(sp)
ffffffffc0201002:	6902                	ld	s2,0(sp)
ffffffffc0201004:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0201006:	b101                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0201008:	6442                	ld	s0,16(sp)
ffffffffc020100a:	60e2                	ld	ra,24(sp)
ffffffffc020100c:	64a2                	ld	s1,8(sp)
ffffffffc020100e:	6902                	ld	s2,0(sp)
ffffffffc0201010:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0201012:	2b60406f          	j	ffffffffc02052c8 <schedule>
                do_exit(-E_KILLED);
ffffffffc0201016:	555d                	li	a0,-9
ffffffffc0201018:	5f6030ef          	jal	ra,ffffffffc020460e <do_exit>
            if (current->need_resched)
ffffffffc020101c:	601c                	ld	a5,0(s0)
ffffffffc020101e:	bf65                	j	ffffffffc0200fd6 <trap+0x40>

ffffffffc0201020 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0201020:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201024:	00011463          	bnez	sp,ffffffffc020102c <__alltraps+0xc>
ffffffffc0201028:	14002173          	csrr	sp,sscratch
ffffffffc020102c:	712d                	addi	sp,sp,-288
ffffffffc020102e:	e002                	sd	zero,0(sp)
ffffffffc0201030:	e406                	sd	ra,8(sp)
ffffffffc0201032:	ec0e                	sd	gp,24(sp)
ffffffffc0201034:	f012                	sd	tp,32(sp)
ffffffffc0201036:	f416                	sd	t0,40(sp)
ffffffffc0201038:	f81a                	sd	t1,48(sp)
ffffffffc020103a:	fc1e                	sd	t2,56(sp)
ffffffffc020103c:	e0a2                	sd	s0,64(sp)
ffffffffc020103e:	e4a6                	sd	s1,72(sp)
ffffffffc0201040:	e8aa                	sd	a0,80(sp)
ffffffffc0201042:	ecae                	sd	a1,88(sp)
ffffffffc0201044:	f0b2                	sd	a2,96(sp)
ffffffffc0201046:	f4b6                	sd	a3,104(sp)
ffffffffc0201048:	f8ba                	sd	a4,112(sp)
ffffffffc020104a:	fcbe                	sd	a5,120(sp)
ffffffffc020104c:	e142                	sd	a6,128(sp)
ffffffffc020104e:	e546                	sd	a7,136(sp)
ffffffffc0201050:	e94a                	sd	s2,144(sp)
ffffffffc0201052:	ed4e                	sd	s3,152(sp)
ffffffffc0201054:	f152                	sd	s4,160(sp)
ffffffffc0201056:	f556                	sd	s5,168(sp)
ffffffffc0201058:	f95a                	sd	s6,176(sp)
ffffffffc020105a:	fd5e                	sd	s7,184(sp)
ffffffffc020105c:	e1e2                	sd	s8,192(sp)
ffffffffc020105e:	e5e6                	sd	s9,200(sp)
ffffffffc0201060:	e9ea                	sd	s10,208(sp)
ffffffffc0201062:	edee                	sd	s11,216(sp)
ffffffffc0201064:	f1f2                	sd	t3,224(sp)
ffffffffc0201066:	f5f6                	sd	t4,232(sp)
ffffffffc0201068:	f9fa                	sd	t5,240(sp)
ffffffffc020106a:	fdfe                	sd	t6,248(sp)
ffffffffc020106c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201070:	100024f3          	csrr	s1,sstatus
ffffffffc0201074:	14102973          	csrr	s2,sepc
ffffffffc0201078:	143029f3          	csrr	s3,stval
ffffffffc020107c:	14202a73          	csrr	s4,scause
ffffffffc0201080:	e822                	sd	s0,16(sp)
ffffffffc0201082:	e226                	sd	s1,256(sp)
ffffffffc0201084:	e64a                	sd	s2,264(sp)
ffffffffc0201086:	ea4e                	sd	s3,272(sp)
ffffffffc0201088:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc020108a:	850a                	mv	a0,sp
    jal trap
ffffffffc020108c:	f0bff0ef          	jal	ra,ffffffffc0200f96 <trap>

ffffffffc0201090 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0201090:	6492                	ld	s1,256(sp)
ffffffffc0201092:	6932                	ld	s2,264(sp)
ffffffffc0201094:	1004f413          	andi	s0,s1,256
ffffffffc0201098:	e401                	bnez	s0,ffffffffc02010a0 <__trapret+0x10>
ffffffffc020109a:	1200                	addi	s0,sp,288
ffffffffc020109c:	14041073          	csrw	sscratch,s0
ffffffffc02010a0:	10049073          	csrw	sstatus,s1
ffffffffc02010a4:	14191073          	csrw	sepc,s2
ffffffffc02010a8:	60a2                	ld	ra,8(sp)
ffffffffc02010aa:	61e2                	ld	gp,24(sp)
ffffffffc02010ac:	7202                	ld	tp,32(sp)
ffffffffc02010ae:	72a2                	ld	t0,40(sp)
ffffffffc02010b0:	7342                	ld	t1,48(sp)
ffffffffc02010b2:	73e2                	ld	t2,56(sp)
ffffffffc02010b4:	6406                	ld	s0,64(sp)
ffffffffc02010b6:	64a6                	ld	s1,72(sp)
ffffffffc02010b8:	6546                	ld	a0,80(sp)
ffffffffc02010ba:	65e6                	ld	a1,88(sp)
ffffffffc02010bc:	7606                	ld	a2,96(sp)
ffffffffc02010be:	76a6                	ld	a3,104(sp)
ffffffffc02010c0:	7746                	ld	a4,112(sp)
ffffffffc02010c2:	77e6                	ld	a5,120(sp)
ffffffffc02010c4:	680a                	ld	a6,128(sp)
ffffffffc02010c6:	68aa                	ld	a7,136(sp)
ffffffffc02010c8:	694a                	ld	s2,144(sp)
ffffffffc02010ca:	69ea                	ld	s3,152(sp)
ffffffffc02010cc:	7a0a                	ld	s4,160(sp)
ffffffffc02010ce:	7aaa                	ld	s5,168(sp)
ffffffffc02010d0:	7b4a                	ld	s6,176(sp)
ffffffffc02010d2:	7bea                	ld	s7,184(sp)
ffffffffc02010d4:	6c0e                	ld	s8,192(sp)
ffffffffc02010d6:	6cae                	ld	s9,200(sp)
ffffffffc02010d8:	6d4e                	ld	s10,208(sp)
ffffffffc02010da:	6dee                	ld	s11,216(sp)
ffffffffc02010dc:	7e0e                	ld	t3,224(sp)
ffffffffc02010de:	7eae                	ld	t4,232(sp)
ffffffffc02010e0:	7f4e                	ld	t5,240(sp)
ffffffffc02010e2:	7fee                	ld	t6,248(sp)
ffffffffc02010e4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02010e6:	10200073          	sret

ffffffffc02010ea <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc02010ea:	812a                	mv	sp,a0
    j __trapret
ffffffffc02010ec:	b755                	j	ffffffffc0201090 <__trapret>

ffffffffc02010ee <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc02010ee:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7ce0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc02010f2:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc02010f6:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc02010fa:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc02010fe:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0201102:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0201106:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc020110a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc020110e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0201112:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0201114:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0201116:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0201118:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc020111a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc020111c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc020111e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201120:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0201122:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0201124:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0201126:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201128:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc020112a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc020112c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc020112e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201130:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0201132:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201134:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0201136:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201138:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc020113a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc020113c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc020113e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201140:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0201142:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201144:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0201146:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201148:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc020114a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc020114c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc020114e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201150:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0201152:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201154:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0201156:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201158:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc020115a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc020115c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc020115e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201160:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0201162:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201164:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0201166:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201168:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc020116a:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc020116c:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc020116e:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201170:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201172:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201174:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0201176:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201178:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020117a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc020117c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc020117e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201180:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0201182:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201184:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0201186:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201188:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc020118a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc020118c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc020118e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201190:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0201192:	812e                	mv	sp,a1
ffffffffc0201194:	bdf5                	j	ffffffffc0201090 <__trapret>

ffffffffc0201196 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201196:	000ce797          	auipc	a5,0xce
ffffffffc020119a:	17278793          	addi	a5,a5,370 # ffffffffc02cf308 <free_area>
ffffffffc020119e:	e79c                	sd	a5,8(a5)
ffffffffc02011a0:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc02011a2:	0007a823          	sw	zero,16(a5)
}
ffffffffc02011a6:	8082                	ret

ffffffffc02011a8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc02011a8:	000ce517          	auipc	a0,0xce
ffffffffc02011ac:	17056503          	lwu	a0,368(a0) # ffffffffc02cf318 <free_area+0x10>
ffffffffc02011b0:	8082                	ret

ffffffffc02011b2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc02011b2:	715d                	addi	sp,sp,-80
ffffffffc02011b4:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02011b6:	000ce417          	auipc	s0,0xce
ffffffffc02011ba:	15240413          	addi	s0,s0,338 # ffffffffc02cf308 <free_area>
ffffffffc02011be:	641c                	ld	a5,8(s0)
ffffffffc02011c0:	e486                	sd	ra,72(sp)
ffffffffc02011c2:	fc26                	sd	s1,56(sp)
ffffffffc02011c4:	f84a                	sd	s2,48(sp)
ffffffffc02011c6:	f44e                	sd	s3,40(sp)
ffffffffc02011c8:	f052                	sd	s4,32(sp)
ffffffffc02011ca:	ec56                	sd	s5,24(sp)
ffffffffc02011cc:	e85a                	sd	s6,16(sp)
ffffffffc02011ce:	e45e                	sd	s7,8(sp)
ffffffffc02011d0:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02011d2:	2a878d63          	beq	a5,s0,ffffffffc020148c <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02011d6:	4481                	li	s1,0
ffffffffc02011d8:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02011da:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02011de:	8b09                	andi	a4,a4,2
ffffffffc02011e0:	2a070a63          	beqz	a4,ffffffffc0201494 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc02011e4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02011e8:	679c                	ld	a5,8(a5)
ffffffffc02011ea:	2905                	addiw	s2,s2,1
ffffffffc02011ec:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02011ee:	fe8796e3          	bne	a5,s0,ffffffffc02011da <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02011f2:	89a6                	mv	s3,s1
ffffffffc02011f4:	6df000ef          	jal	ra,ffffffffc02020d2 <nr_free_pages>
ffffffffc02011f8:	6f351e63          	bne	a0,s3,ffffffffc02018f4 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011fc:	4505                	li	a0,1
ffffffffc02011fe:	657000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0201202:	8aaa                	mv	s5,a0
ffffffffc0201204:	42050863          	beqz	a0,ffffffffc0201634 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201208:	4505                	li	a0,1
ffffffffc020120a:	64b000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020120e:	89aa                	mv	s3,a0
ffffffffc0201210:	70050263          	beqz	a0,ffffffffc0201914 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201214:	4505                	li	a0,1
ffffffffc0201216:	63f000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020121a:	8a2a                	mv	s4,a0
ffffffffc020121c:	48050c63          	beqz	a0,ffffffffc02016b4 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201220:	293a8a63          	beq	s5,s3,ffffffffc02014b4 <default_check+0x302>
ffffffffc0201224:	28aa8863          	beq	s5,a0,ffffffffc02014b4 <default_check+0x302>
ffffffffc0201228:	28a98663          	beq	s3,a0,ffffffffc02014b4 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020122c:	000aa783          	lw	a5,0(s5)
ffffffffc0201230:	2a079263          	bnez	a5,ffffffffc02014d4 <default_check+0x322>
ffffffffc0201234:	0009a783          	lw	a5,0(s3)
ffffffffc0201238:	28079e63          	bnez	a5,ffffffffc02014d4 <default_check+0x322>
ffffffffc020123c:	411c                	lw	a5,0(a0)
ffffffffc020123e:	28079b63          	bnez	a5,ffffffffc02014d4 <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201242:	000d2797          	auipc	a5,0xd2
ffffffffc0201246:	1367b783          	ld	a5,310(a5) # ffffffffc02d3378 <pages>
ffffffffc020124a:	40fa8733          	sub	a4,s5,a5
ffffffffc020124e:	00007617          	auipc	a2,0x7
ffffffffc0201252:	81263603          	ld	a2,-2030(a2) # ffffffffc0207a60 <nbase>
ffffffffc0201256:	8719                	srai	a4,a4,0x6
ffffffffc0201258:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020125a:	000d2697          	auipc	a3,0xd2
ffffffffc020125e:	1166b683          	ld	a3,278(a3) # ffffffffc02d3370 <npage>
ffffffffc0201262:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201264:	0732                	slli	a4,a4,0xc
ffffffffc0201266:	28d77763          	bgeu	a4,a3,ffffffffc02014f4 <default_check+0x342>
    return page - pages + nbase;
ffffffffc020126a:	40f98733          	sub	a4,s3,a5
ffffffffc020126e:	8719                	srai	a4,a4,0x6
ffffffffc0201270:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201272:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201274:	4cd77063          	bgeu	a4,a3,ffffffffc0201734 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201278:	40f507b3          	sub	a5,a0,a5
ffffffffc020127c:	8799                	srai	a5,a5,0x6
ffffffffc020127e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201280:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201282:	30d7f963          	bgeu	a5,a3,ffffffffc0201594 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201286:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201288:	00043c03          	ld	s8,0(s0)
ffffffffc020128c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201290:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201294:	e400                	sd	s0,8(s0)
ffffffffc0201296:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201298:	000ce797          	auipc	a5,0xce
ffffffffc020129c:	0807a023          	sw	zero,128(a5) # ffffffffc02cf318 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02012a0:	5b5000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02012a4:	2c051863          	bnez	a0,ffffffffc0201574 <default_check+0x3c2>
    free_page(p0);
ffffffffc02012a8:	4585                	li	a1,1
ffffffffc02012aa:	8556                	mv	a0,s5
ffffffffc02012ac:	5e7000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_page(p1);
ffffffffc02012b0:	4585                	li	a1,1
ffffffffc02012b2:	854e                	mv	a0,s3
ffffffffc02012b4:	5df000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_page(p2);
ffffffffc02012b8:	4585                	li	a1,1
ffffffffc02012ba:	8552                	mv	a0,s4
ffffffffc02012bc:	5d7000ef          	jal	ra,ffffffffc0202092 <free_pages>
    assert(nr_free == 3);
ffffffffc02012c0:	4818                	lw	a4,16(s0)
ffffffffc02012c2:	478d                	li	a5,3
ffffffffc02012c4:	28f71863          	bne	a4,a5,ffffffffc0201554 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012c8:	4505                	li	a0,1
ffffffffc02012ca:	58b000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02012ce:	89aa                	mv	s3,a0
ffffffffc02012d0:	26050263          	beqz	a0,ffffffffc0201534 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012d4:	4505                	li	a0,1
ffffffffc02012d6:	57f000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02012da:	8aaa                	mv	s5,a0
ffffffffc02012dc:	3a050c63          	beqz	a0,ffffffffc0201694 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012e0:	4505                	li	a0,1
ffffffffc02012e2:	573000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02012e6:	8a2a                	mv	s4,a0
ffffffffc02012e8:	38050663          	beqz	a0,ffffffffc0201674 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02012ec:	4505                	li	a0,1
ffffffffc02012ee:	567000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02012f2:	36051163          	bnez	a0,ffffffffc0201654 <default_check+0x4a2>
    free_page(p0);
ffffffffc02012f6:	4585                	li	a1,1
ffffffffc02012f8:	854e                	mv	a0,s3
ffffffffc02012fa:	599000ef          	jal	ra,ffffffffc0202092 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02012fe:	641c                	ld	a5,8(s0)
ffffffffc0201300:	20878a63          	beq	a5,s0,ffffffffc0201514 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201304:	4505                	li	a0,1
ffffffffc0201306:	54f000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020130a:	30a99563          	bne	s3,a0,ffffffffc0201614 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc020130e:	4505                	li	a0,1
ffffffffc0201310:	545000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0201314:	2e051063          	bnez	a0,ffffffffc02015f4 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201318:	481c                	lw	a5,16(s0)
ffffffffc020131a:	2a079d63          	bnez	a5,ffffffffc02015d4 <default_check+0x422>
    free_page(p);
ffffffffc020131e:	854e                	mv	a0,s3
ffffffffc0201320:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201322:	01843023          	sd	s8,0(s0)
ffffffffc0201326:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020132a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020132e:	565000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_page(p1);
ffffffffc0201332:	4585                	li	a1,1
ffffffffc0201334:	8556                	mv	a0,s5
ffffffffc0201336:	55d000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_page(p2);
ffffffffc020133a:	4585                	li	a1,1
ffffffffc020133c:	8552                	mv	a0,s4
ffffffffc020133e:	555000ef          	jal	ra,ffffffffc0202092 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201342:	4515                	li	a0,5
ffffffffc0201344:	511000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0201348:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020134a:	26050563          	beqz	a0,ffffffffc02015b4 <default_check+0x402>
ffffffffc020134e:	651c                	ld	a5,8(a0)
ffffffffc0201350:	8385                	srli	a5,a5,0x1
ffffffffc0201352:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201354:	54079063          	bnez	a5,ffffffffc0201894 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201358:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020135a:	00043b03          	ld	s6,0(s0)
ffffffffc020135e:	00843a83          	ld	s5,8(s0)
ffffffffc0201362:	e000                	sd	s0,0(s0)
ffffffffc0201364:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201366:	4ef000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020136a:	50051563          	bnez	a0,ffffffffc0201874 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020136e:	08098a13          	addi	s4,s3,128
ffffffffc0201372:	8552                	mv	a0,s4
ffffffffc0201374:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201376:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020137a:	000ce797          	auipc	a5,0xce
ffffffffc020137e:	f807af23          	sw	zero,-98(a5) # ffffffffc02cf318 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201382:	511000ef          	jal	ra,ffffffffc0202092 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201386:	4511                	li	a0,4
ffffffffc0201388:	4cd000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020138c:	4c051463          	bnez	a0,ffffffffc0201854 <default_check+0x6a2>
ffffffffc0201390:	0889b783          	ld	a5,136(s3)
ffffffffc0201394:	8385                	srli	a5,a5,0x1
ffffffffc0201396:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201398:	48078e63          	beqz	a5,ffffffffc0201834 <default_check+0x682>
ffffffffc020139c:	0909a703          	lw	a4,144(s3)
ffffffffc02013a0:	478d                	li	a5,3
ffffffffc02013a2:	48f71963          	bne	a4,a5,ffffffffc0201834 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02013a6:	450d                	li	a0,3
ffffffffc02013a8:	4ad000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02013ac:	8c2a                	mv	s8,a0
ffffffffc02013ae:	46050363          	beqz	a0,ffffffffc0201814 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02013b2:	4505                	li	a0,1
ffffffffc02013b4:	4a1000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc02013b8:	42051e63          	bnez	a0,ffffffffc02017f4 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02013bc:	418a1c63          	bne	s4,s8,ffffffffc02017d4 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02013c0:	4585                	li	a1,1
ffffffffc02013c2:	854e                	mv	a0,s3
ffffffffc02013c4:	4cf000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_pages(p1, 3);
ffffffffc02013c8:	458d                	li	a1,3
ffffffffc02013ca:	8552                	mv	a0,s4
ffffffffc02013cc:	4c7000ef          	jal	ra,ffffffffc0202092 <free_pages>
ffffffffc02013d0:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02013d4:	04098c13          	addi	s8,s3,64
ffffffffc02013d8:	8385                	srli	a5,a5,0x1
ffffffffc02013da:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02013dc:	3c078c63          	beqz	a5,ffffffffc02017b4 <default_check+0x602>
ffffffffc02013e0:	0109a703          	lw	a4,16(s3)
ffffffffc02013e4:	4785                	li	a5,1
ffffffffc02013e6:	3cf71763          	bne	a4,a5,ffffffffc02017b4 <default_check+0x602>
ffffffffc02013ea:	008a3783          	ld	a5,8(s4)
ffffffffc02013ee:	8385                	srli	a5,a5,0x1
ffffffffc02013f0:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02013f2:	3a078163          	beqz	a5,ffffffffc0201794 <default_check+0x5e2>
ffffffffc02013f6:	010a2703          	lw	a4,16(s4)
ffffffffc02013fa:	478d                	li	a5,3
ffffffffc02013fc:	38f71c63          	bne	a4,a5,ffffffffc0201794 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201400:	4505                	li	a0,1
ffffffffc0201402:	453000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0201406:	36a99763          	bne	s3,a0,ffffffffc0201774 <default_check+0x5c2>
    free_page(p0);
ffffffffc020140a:	4585                	li	a1,1
ffffffffc020140c:	487000ef          	jal	ra,ffffffffc0202092 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201410:	4509                	li	a0,2
ffffffffc0201412:	443000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0201416:	32aa1f63          	bne	s4,a0,ffffffffc0201754 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020141a:	4589                	li	a1,2
ffffffffc020141c:	477000ef          	jal	ra,ffffffffc0202092 <free_pages>
    free_page(p2);
ffffffffc0201420:	4585                	li	a1,1
ffffffffc0201422:	8562                	mv	a0,s8
ffffffffc0201424:	46f000ef          	jal	ra,ffffffffc0202092 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201428:	4515                	li	a0,5
ffffffffc020142a:	42b000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020142e:	89aa                	mv	s3,a0
ffffffffc0201430:	48050263          	beqz	a0,ffffffffc02018b4 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201434:	4505                	li	a0,1
ffffffffc0201436:	41f000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc020143a:	2c051d63          	bnez	a0,ffffffffc0201714 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc020143e:	481c                	lw	a5,16(s0)
ffffffffc0201440:	2a079a63          	bnez	a5,ffffffffc02016f4 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201444:	4595                	li	a1,5
ffffffffc0201446:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201448:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc020144c:	01643023          	sd	s6,0(s0)
ffffffffc0201450:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201454:	43f000ef          	jal	ra,ffffffffc0202092 <free_pages>
    return listelm->next;
ffffffffc0201458:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020145a:	00878963          	beq	a5,s0,ffffffffc020146c <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc020145e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201462:	679c                	ld	a5,8(a5)
ffffffffc0201464:	397d                	addiw	s2,s2,-1
ffffffffc0201466:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201468:	fe879be3          	bne	a5,s0,ffffffffc020145e <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc020146c:	26091463          	bnez	s2,ffffffffc02016d4 <default_check+0x522>
    assert(total == 0);
ffffffffc0201470:	46049263          	bnez	s1,ffffffffc02018d4 <default_check+0x722>
}
ffffffffc0201474:	60a6                	ld	ra,72(sp)
ffffffffc0201476:	6406                	ld	s0,64(sp)
ffffffffc0201478:	74e2                	ld	s1,56(sp)
ffffffffc020147a:	7942                	ld	s2,48(sp)
ffffffffc020147c:	79a2                	ld	s3,40(sp)
ffffffffc020147e:	7a02                	ld	s4,32(sp)
ffffffffc0201480:	6ae2                	ld	s5,24(sp)
ffffffffc0201482:	6b42                	ld	s6,16(sp)
ffffffffc0201484:	6ba2                	ld	s7,8(sp)
ffffffffc0201486:	6c02                	ld	s8,0(sp)
ffffffffc0201488:	6161                	addi	sp,sp,80
ffffffffc020148a:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc020148c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020148e:	4481                	li	s1,0
ffffffffc0201490:	4901                	li	s2,0
ffffffffc0201492:	b38d                	j	ffffffffc02011f4 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201494:	00005697          	auipc	a3,0x5
ffffffffc0201498:	f7c68693          	addi	a3,a3,-132 # ffffffffc0206410 <commands+0x8a0>
ffffffffc020149c:	00005617          	auipc	a2,0x5
ffffffffc02014a0:	f8460613          	addi	a2,a2,-124 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02014a4:	11000593          	li	a1,272
ffffffffc02014a8:	00005517          	auipc	a0,0x5
ffffffffc02014ac:	f9050513          	addi	a0,a0,-112 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02014b0:	fdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02014b4:	00005697          	auipc	a3,0x5
ffffffffc02014b8:	01c68693          	addi	a3,a3,28 # ffffffffc02064d0 <commands+0x960>
ffffffffc02014bc:	00005617          	auipc	a2,0x5
ffffffffc02014c0:	f6460613          	addi	a2,a2,-156 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02014c4:	0db00593          	li	a1,219
ffffffffc02014c8:	00005517          	auipc	a0,0x5
ffffffffc02014cc:	f7050513          	addi	a0,a0,-144 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02014d0:	fbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02014d4:	00005697          	auipc	a3,0x5
ffffffffc02014d8:	02468693          	addi	a3,a3,36 # ffffffffc02064f8 <commands+0x988>
ffffffffc02014dc:	00005617          	auipc	a2,0x5
ffffffffc02014e0:	f4460613          	addi	a2,a2,-188 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02014e4:	0dc00593          	li	a1,220
ffffffffc02014e8:	00005517          	auipc	a0,0x5
ffffffffc02014ec:	f5050513          	addi	a0,a0,-176 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02014f0:	f9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02014f4:	00005697          	auipc	a3,0x5
ffffffffc02014f8:	04468693          	addi	a3,a3,68 # ffffffffc0206538 <commands+0x9c8>
ffffffffc02014fc:	00005617          	auipc	a2,0x5
ffffffffc0201500:	f2460613          	addi	a2,a2,-220 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201504:	0de00593          	li	a1,222
ffffffffc0201508:	00005517          	auipc	a0,0x5
ffffffffc020150c:	f3050513          	addi	a0,a0,-208 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201510:	f7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201514:	00005697          	auipc	a3,0x5
ffffffffc0201518:	0ac68693          	addi	a3,a3,172 # ffffffffc02065c0 <commands+0xa50>
ffffffffc020151c:	00005617          	auipc	a2,0x5
ffffffffc0201520:	f0460613          	addi	a2,a2,-252 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201524:	0f700593          	li	a1,247
ffffffffc0201528:	00005517          	auipc	a0,0x5
ffffffffc020152c:	f1050513          	addi	a0,a0,-240 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201530:	f5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201534:	00005697          	auipc	a3,0x5
ffffffffc0201538:	f3c68693          	addi	a3,a3,-196 # ffffffffc0206470 <commands+0x900>
ffffffffc020153c:	00005617          	auipc	a2,0x5
ffffffffc0201540:	ee460613          	addi	a2,a2,-284 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201544:	0f000593          	li	a1,240
ffffffffc0201548:	00005517          	auipc	a0,0x5
ffffffffc020154c:	ef050513          	addi	a0,a0,-272 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201550:	f3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201554:	00005697          	auipc	a3,0x5
ffffffffc0201558:	05c68693          	addi	a3,a3,92 # ffffffffc02065b0 <commands+0xa40>
ffffffffc020155c:	00005617          	auipc	a2,0x5
ffffffffc0201560:	ec460613          	addi	a2,a2,-316 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201564:	0ee00593          	li	a1,238
ffffffffc0201568:	00005517          	auipc	a0,0x5
ffffffffc020156c:	ed050513          	addi	a0,a0,-304 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201570:	f1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201574:	00005697          	auipc	a3,0x5
ffffffffc0201578:	02468693          	addi	a3,a3,36 # ffffffffc0206598 <commands+0xa28>
ffffffffc020157c:	00005617          	auipc	a2,0x5
ffffffffc0201580:	ea460613          	addi	a2,a2,-348 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201584:	0e900593          	li	a1,233
ffffffffc0201588:	00005517          	auipc	a0,0x5
ffffffffc020158c:	eb050513          	addi	a0,a0,-336 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201590:	efffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201594:	00005697          	auipc	a3,0x5
ffffffffc0201598:	fe468693          	addi	a3,a3,-28 # ffffffffc0206578 <commands+0xa08>
ffffffffc020159c:	00005617          	auipc	a2,0x5
ffffffffc02015a0:	e8460613          	addi	a2,a2,-380 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02015a4:	0e000593          	li	a1,224
ffffffffc02015a8:	00005517          	auipc	a0,0x5
ffffffffc02015ac:	e9050513          	addi	a0,a0,-368 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02015b0:	edffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02015b4:	00005697          	auipc	a3,0x5
ffffffffc02015b8:	05468693          	addi	a3,a3,84 # ffffffffc0206608 <commands+0xa98>
ffffffffc02015bc:	00005617          	auipc	a2,0x5
ffffffffc02015c0:	e6460613          	addi	a2,a2,-412 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02015c4:	11800593          	li	a1,280
ffffffffc02015c8:	00005517          	auipc	a0,0x5
ffffffffc02015cc:	e7050513          	addi	a0,a0,-400 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02015d0:	ebffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02015d4:	00005697          	auipc	a3,0x5
ffffffffc02015d8:	02468693          	addi	a3,a3,36 # ffffffffc02065f8 <commands+0xa88>
ffffffffc02015dc:	00005617          	auipc	a2,0x5
ffffffffc02015e0:	e4460613          	addi	a2,a2,-444 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02015e4:	0fd00593          	li	a1,253
ffffffffc02015e8:	00005517          	auipc	a0,0x5
ffffffffc02015ec:	e5050513          	addi	a0,a0,-432 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02015f0:	e9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015f4:	00005697          	auipc	a3,0x5
ffffffffc02015f8:	fa468693          	addi	a3,a3,-92 # ffffffffc0206598 <commands+0xa28>
ffffffffc02015fc:	00005617          	auipc	a2,0x5
ffffffffc0201600:	e2460613          	addi	a2,a2,-476 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201604:	0fb00593          	li	a1,251
ffffffffc0201608:	00005517          	auipc	a0,0x5
ffffffffc020160c:	e3050513          	addi	a0,a0,-464 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201610:	e7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201614:	00005697          	auipc	a3,0x5
ffffffffc0201618:	fc468693          	addi	a3,a3,-60 # ffffffffc02065d8 <commands+0xa68>
ffffffffc020161c:	00005617          	auipc	a2,0x5
ffffffffc0201620:	e0460613          	addi	a2,a2,-508 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201624:	0fa00593          	li	a1,250
ffffffffc0201628:	00005517          	auipc	a0,0x5
ffffffffc020162c:	e1050513          	addi	a0,a0,-496 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201630:	e5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201634:	00005697          	auipc	a3,0x5
ffffffffc0201638:	e3c68693          	addi	a3,a3,-452 # ffffffffc0206470 <commands+0x900>
ffffffffc020163c:	00005617          	auipc	a2,0x5
ffffffffc0201640:	de460613          	addi	a2,a2,-540 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201644:	0d700593          	li	a1,215
ffffffffc0201648:	00005517          	auipc	a0,0x5
ffffffffc020164c:	df050513          	addi	a0,a0,-528 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201650:	e3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201654:	00005697          	auipc	a3,0x5
ffffffffc0201658:	f4468693          	addi	a3,a3,-188 # ffffffffc0206598 <commands+0xa28>
ffffffffc020165c:	00005617          	auipc	a2,0x5
ffffffffc0201660:	dc460613          	addi	a2,a2,-572 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201664:	0f400593          	li	a1,244
ffffffffc0201668:	00005517          	auipc	a0,0x5
ffffffffc020166c:	dd050513          	addi	a0,a0,-560 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201670:	e1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201674:	00005697          	auipc	a3,0x5
ffffffffc0201678:	e3c68693          	addi	a3,a3,-452 # ffffffffc02064b0 <commands+0x940>
ffffffffc020167c:	00005617          	auipc	a2,0x5
ffffffffc0201680:	da460613          	addi	a2,a2,-604 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201684:	0f200593          	li	a1,242
ffffffffc0201688:	00005517          	auipc	a0,0x5
ffffffffc020168c:	db050513          	addi	a0,a0,-592 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201690:	dfffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201694:	00005697          	auipc	a3,0x5
ffffffffc0201698:	dfc68693          	addi	a3,a3,-516 # ffffffffc0206490 <commands+0x920>
ffffffffc020169c:	00005617          	auipc	a2,0x5
ffffffffc02016a0:	d8460613          	addi	a2,a2,-636 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02016a4:	0f100593          	li	a1,241
ffffffffc02016a8:	00005517          	auipc	a0,0x5
ffffffffc02016ac:	d9050513          	addi	a0,a0,-624 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02016b0:	ddffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02016b4:	00005697          	auipc	a3,0x5
ffffffffc02016b8:	dfc68693          	addi	a3,a3,-516 # ffffffffc02064b0 <commands+0x940>
ffffffffc02016bc:	00005617          	auipc	a2,0x5
ffffffffc02016c0:	d6460613          	addi	a2,a2,-668 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02016c4:	0d900593          	li	a1,217
ffffffffc02016c8:	00005517          	auipc	a0,0x5
ffffffffc02016cc:	d7050513          	addi	a0,a0,-656 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02016d0:	dbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02016d4:	00005697          	auipc	a3,0x5
ffffffffc02016d8:	08468693          	addi	a3,a3,132 # ffffffffc0206758 <commands+0xbe8>
ffffffffc02016dc:	00005617          	auipc	a2,0x5
ffffffffc02016e0:	d4460613          	addi	a2,a2,-700 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02016e4:	14600593          	li	a1,326
ffffffffc02016e8:	00005517          	auipc	a0,0x5
ffffffffc02016ec:	d5050513          	addi	a0,a0,-688 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02016f0:	d9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02016f4:	00005697          	auipc	a3,0x5
ffffffffc02016f8:	f0468693          	addi	a3,a3,-252 # ffffffffc02065f8 <commands+0xa88>
ffffffffc02016fc:	00005617          	auipc	a2,0x5
ffffffffc0201700:	d2460613          	addi	a2,a2,-732 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201704:	13a00593          	li	a1,314
ffffffffc0201708:	00005517          	auipc	a0,0x5
ffffffffc020170c:	d3050513          	addi	a0,a0,-720 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201710:	d7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201714:	00005697          	auipc	a3,0x5
ffffffffc0201718:	e8468693          	addi	a3,a3,-380 # ffffffffc0206598 <commands+0xa28>
ffffffffc020171c:	00005617          	auipc	a2,0x5
ffffffffc0201720:	d0460613          	addi	a2,a2,-764 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201724:	13800593          	li	a1,312
ffffffffc0201728:	00005517          	auipc	a0,0x5
ffffffffc020172c:	d1050513          	addi	a0,a0,-752 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201730:	d5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201734:	00005697          	auipc	a3,0x5
ffffffffc0201738:	e2468693          	addi	a3,a3,-476 # ffffffffc0206558 <commands+0x9e8>
ffffffffc020173c:	00005617          	auipc	a2,0x5
ffffffffc0201740:	ce460613          	addi	a2,a2,-796 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201744:	0df00593          	li	a1,223
ffffffffc0201748:	00005517          	auipc	a0,0x5
ffffffffc020174c:	cf050513          	addi	a0,a0,-784 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201750:	d3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201754:	00005697          	auipc	a3,0x5
ffffffffc0201758:	fc468693          	addi	a3,a3,-60 # ffffffffc0206718 <commands+0xba8>
ffffffffc020175c:	00005617          	auipc	a2,0x5
ffffffffc0201760:	cc460613          	addi	a2,a2,-828 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201764:	13200593          	li	a1,306
ffffffffc0201768:	00005517          	auipc	a0,0x5
ffffffffc020176c:	cd050513          	addi	a0,a0,-816 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201770:	d1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201774:	00005697          	auipc	a3,0x5
ffffffffc0201778:	f8468693          	addi	a3,a3,-124 # ffffffffc02066f8 <commands+0xb88>
ffffffffc020177c:	00005617          	auipc	a2,0x5
ffffffffc0201780:	ca460613          	addi	a2,a2,-860 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201784:	13000593          	li	a1,304
ffffffffc0201788:	00005517          	auipc	a0,0x5
ffffffffc020178c:	cb050513          	addi	a0,a0,-848 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201790:	cfffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201794:	00005697          	auipc	a3,0x5
ffffffffc0201798:	f3c68693          	addi	a3,a3,-196 # ffffffffc02066d0 <commands+0xb60>
ffffffffc020179c:	00005617          	auipc	a2,0x5
ffffffffc02017a0:	c8460613          	addi	a2,a2,-892 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02017a4:	12e00593          	li	a1,302
ffffffffc02017a8:	00005517          	auipc	a0,0x5
ffffffffc02017ac:	c9050513          	addi	a0,a0,-880 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02017b0:	cdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02017b4:	00005697          	auipc	a3,0x5
ffffffffc02017b8:	ef468693          	addi	a3,a3,-268 # ffffffffc02066a8 <commands+0xb38>
ffffffffc02017bc:	00005617          	auipc	a2,0x5
ffffffffc02017c0:	c6460613          	addi	a2,a2,-924 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02017c4:	12d00593          	li	a1,301
ffffffffc02017c8:	00005517          	auipc	a0,0x5
ffffffffc02017cc:	c7050513          	addi	a0,a0,-912 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02017d0:	cbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02017d4:	00005697          	auipc	a3,0x5
ffffffffc02017d8:	ec468693          	addi	a3,a3,-316 # ffffffffc0206698 <commands+0xb28>
ffffffffc02017dc:	00005617          	auipc	a2,0x5
ffffffffc02017e0:	c4460613          	addi	a2,a2,-956 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02017e4:	12800593          	li	a1,296
ffffffffc02017e8:	00005517          	auipc	a0,0x5
ffffffffc02017ec:	c5050513          	addi	a0,a0,-944 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02017f0:	c9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02017f4:	00005697          	auipc	a3,0x5
ffffffffc02017f8:	da468693          	addi	a3,a3,-604 # ffffffffc0206598 <commands+0xa28>
ffffffffc02017fc:	00005617          	auipc	a2,0x5
ffffffffc0201800:	c2460613          	addi	a2,a2,-988 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201804:	12700593          	li	a1,295
ffffffffc0201808:	00005517          	auipc	a0,0x5
ffffffffc020180c:	c3050513          	addi	a0,a0,-976 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201810:	c7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201814:	00005697          	auipc	a3,0x5
ffffffffc0201818:	e6468693          	addi	a3,a3,-412 # ffffffffc0206678 <commands+0xb08>
ffffffffc020181c:	00005617          	auipc	a2,0x5
ffffffffc0201820:	c0460613          	addi	a2,a2,-1020 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201824:	12600593          	li	a1,294
ffffffffc0201828:	00005517          	auipc	a0,0x5
ffffffffc020182c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201830:	c5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201834:	00005697          	auipc	a3,0x5
ffffffffc0201838:	e1468693          	addi	a3,a3,-492 # ffffffffc0206648 <commands+0xad8>
ffffffffc020183c:	00005617          	auipc	a2,0x5
ffffffffc0201840:	be460613          	addi	a2,a2,-1052 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201844:	12500593          	li	a1,293
ffffffffc0201848:	00005517          	auipc	a0,0x5
ffffffffc020184c:	bf050513          	addi	a0,a0,-1040 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201850:	c3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201854:	00005697          	auipc	a3,0x5
ffffffffc0201858:	ddc68693          	addi	a3,a3,-548 # ffffffffc0206630 <commands+0xac0>
ffffffffc020185c:	00005617          	auipc	a2,0x5
ffffffffc0201860:	bc460613          	addi	a2,a2,-1084 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201864:	12400593          	li	a1,292
ffffffffc0201868:	00005517          	auipc	a0,0x5
ffffffffc020186c:	bd050513          	addi	a0,a0,-1072 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201870:	c1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201874:	00005697          	auipc	a3,0x5
ffffffffc0201878:	d2468693          	addi	a3,a3,-732 # ffffffffc0206598 <commands+0xa28>
ffffffffc020187c:	00005617          	auipc	a2,0x5
ffffffffc0201880:	ba460613          	addi	a2,a2,-1116 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201884:	11e00593          	li	a1,286
ffffffffc0201888:	00005517          	auipc	a0,0x5
ffffffffc020188c:	bb050513          	addi	a0,a0,-1104 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201890:	bfffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc0201894:	00005697          	auipc	a3,0x5
ffffffffc0201898:	d8468693          	addi	a3,a3,-636 # ffffffffc0206618 <commands+0xaa8>
ffffffffc020189c:	00005617          	auipc	a2,0x5
ffffffffc02018a0:	b8460613          	addi	a2,a2,-1148 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02018a4:	11900593          	li	a1,281
ffffffffc02018a8:	00005517          	auipc	a0,0x5
ffffffffc02018ac:	b9050513          	addi	a0,a0,-1136 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02018b0:	bdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02018b4:	00005697          	auipc	a3,0x5
ffffffffc02018b8:	e8468693          	addi	a3,a3,-380 # ffffffffc0206738 <commands+0xbc8>
ffffffffc02018bc:	00005617          	auipc	a2,0x5
ffffffffc02018c0:	b6460613          	addi	a2,a2,-1180 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02018c4:	13700593          	li	a1,311
ffffffffc02018c8:	00005517          	auipc	a0,0x5
ffffffffc02018cc:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02018d0:	bbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc02018d4:	00005697          	auipc	a3,0x5
ffffffffc02018d8:	e9468693          	addi	a3,a3,-364 # ffffffffc0206768 <commands+0xbf8>
ffffffffc02018dc:	00005617          	auipc	a2,0x5
ffffffffc02018e0:	b4460613          	addi	a2,a2,-1212 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02018e4:	14700593          	li	a1,327
ffffffffc02018e8:	00005517          	auipc	a0,0x5
ffffffffc02018ec:	b5050513          	addi	a0,a0,-1200 # ffffffffc0206438 <commands+0x8c8>
ffffffffc02018f0:	b9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc02018f4:	00005697          	auipc	a3,0x5
ffffffffc02018f8:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0206450 <commands+0x8e0>
ffffffffc02018fc:	00005617          	auipc	a2,0x5
ffffffffc0201900:	b2460613          	addi	a2,a2,-1244 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201904:	11300593          	li	a1,275
ffffffffc0201908:	00005517          	auipc	a0,0x5
ffffffffc020190c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201910:	b7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201914:	00005697          	auipc	a3,0x5
ffffffffc0201918:	b7c68693          	addi	a3,a3,-1156 # ffffffffc0206490 <commands+0x920>
ffffffffc020191c:	00005617          	auipc	a2,0x5
ffffffffc0201920:	b0460613          	addi	a2,a2,-1276 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201924:	0d800593          	li	a1,216
ffffffffc0201928:	00005517          	auipc	a0,0x5
ffffffffc020192c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201930:	b5ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201934 <default_free_pages>:
{
ffffffffc0201934:	1141                	addi	sp,sp,-16
ffffffffc0201936:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201938:	14058463          	beqz	a1,ffffffffc0201a80 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc020193c:	00659693          	slli	a3,a1,0x6
ffffffffc0201940:	96aa                	add	a3,a3,a0
ffffffffc0201942:	87aa                	mv	a5,a0
ffffffffc0201944:	02d50263          	beq	a0,a3,ffffffffc0201968 <default_free_pages+0x34>
ffffffffc0201948:	6798                	ld	a4,8(a5)
ffffffffc020194a:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020194c:	10071a63          	bnez	a4,ffffffffc0201a60 <default_free_pages+0x12c>
ffffffffc0201950:	6798                	ld	a4,8(a5)
ffffffffc0201952:	8b09                	andi	a4,a4,2
ffffffffc0201954:	10071663          	bnez	a4,ffffffffc0201a60 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201958:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc020195c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201960:	04078793          	addi	a5,a5,64
ffffffffc0201964:	fed792e3          	bne	a5,a3,ffffffffc0201948 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201968:	2581                	sext.w	a1,a1
ffffffffc020196a:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020196c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201970:	4789                	li	a5,2
ffffffffc0201972:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201976:	000ce697          	auipc	a3,0xce
ffffffffc020197a:	99268693          	addi	a3,a3,-1646 # ffffffffc02cf308 <free_area>
ffffffffc020197e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201980:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201982:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201986:	9db9                	addw	a1,a1,a4
ffffffffc0201988:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc020198a:	0ad78463          	beq	a5,a3,ffffffffc0201a32 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc020198e:	fe878713          	addi	a4,a5,-24
ffffffffc0201992:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201996:	4581                	li	a1,0
            if (base < page)
ffffffffc0201998:	00e56a63          	bltu	a0,a4,ffffffffc02019ac <default_free_pages+0x78>
    return listelm->next;
ffffffffc020199c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020199e:	04d70c63          	beq	a4,a3,ffffffffc02019f6 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02019a2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019a4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019a8:	fee57ae3          	bgeu	a0,a4,ffffffffc020199c <default_free_pages+0x68>
ffffffffc02019ac:	c199                	beqz	a1,ffffffffc02019b2 <default_free_pages+0x7e>
ffffffffc02019ae:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02019b2:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02019b4:	e390                	sd	a2,0(a5)
ffffffffc02019b6:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02019b8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019ba:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02019bc:	00d70d63          	beq	a4,a3,ffffffffc02019d6 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02019c0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02019c4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02019c8:	02059813          	slli	a6,a1,0x20
ffffffffc02019cc:	01a85793          	srli	a5,a6,0x1a
ffffffffc02019d0:	97b2                	add	a5,a5,a2
ffffffffc02019d2:	02f50c63          	beq	a0,a5,ffffffffc0201a0a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02019d6:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02019d8:	00d78c63          	beq	a5,a3,ffffffffc02019f0 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc02019dc:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02019de:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02019e2:	02061593          	slli	a1,a2,0x20
ffffffffc02019e6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02019ea:	972a                	add	a4,a4,a0
ffffffffc02019ec:	04e68a63          	beq	a3,a4,ffffffffc0201a40 <default_free_pages+0x10c>
}
ffffffffc02019f0:	60a2                	ld	ra,8(sp)
ffffffffc02019f2:	0141                	addi	sp,sp,16
ffffffffc02019f4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02019f6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02019f8:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02019fa:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02019fc:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc02019fe:	02d70763          	beq	a4,a3,ffffffffc0201a2c <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201a02:	8832                	mv	a6,a2
ffffffffc0201a04:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a06:	87ba                	mv	a5,a4
ffffffffc0201a08:	bf71                	j	ffffffffc02019a4 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201a0a:	491c                	lw	a5,16(a0)
ffffffffc0201a0c:	9dbd                	addw	a1,a1,a5
ffffffffc0201a0e:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201a12:	57f5                	li	a5,-3
ffffffffc0201a14:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201a18:	01853803          	ld	a6,24(a0)
ffffffffc0201a1c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201a1e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201a20:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201a24:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201a26:	0105b023          	sd	a6,0(a1)
ffffffffc0201a2a:	b77d                	j	ffffffffc02019d8 <default_free_pages+0xa4>
ffffffffc0201a2c:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a2e:	873e                	mv	a4,a5
ffffffffc0201a30:	bf41                	j	ffffffffc02019c0 <default_free_pages+0x8c>
}
ffffffffc0201a32:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a34:	e390                	sd	a2,0(a5)
ffffffffc0201a36:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a38:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a3a:	ed1c                	sd	a5,24(a0)
ffffffffc0201a3c:	0141                	addi	sp,sp,16
ffffffffc0201a3e:	8082                	ret
            base->property += p->property;
ffffffffc0201a40:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201a44:	ff078693          	addi	a3,a5,-16
ffffffffc0201a48:	9e39                	addw	a2,a2,a4
ffffffffc0201a4a:	c910                	sw	a2,16(a0)
ffffffffc0201a4c:	5775                	li	a4,-3
ffffffffc0201a4e:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201a52:	6398                	ld	a4,0(a5)
ffffffffc0201a54:	679c                	ld	a5,8(a5)
}
ffffffffc0201a56:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201a58:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201a5a:	e398                	sd	a4,0(a5)
ffffffffc0201a5c:	0141                	addi	sp,sp,16
ffffffffc0201a5e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201a60:	00005697          	auipc	a3,0x5
ffffffffc0201a64:	d2068693          	addi	a3,a3,-736 # ffffffffc0206780 <commands+0xc10>
ffffffffc0201a68:	00005617          	auipc	a2,0x5
ffffffffc0201a6c:	9b860613          	addi	a2,a2,-1608 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201a70:	09400593          	li	a1,148
ffffffffc0201a74:	00005517          	auipc	a0,0x5
ffffffffc0201a78:	9c450513          	addi	a0,a0,-1596 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201a7c:	a13fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a80:	00005697          	auipc	a3,0x5
ffffffffc0201a84:	cf868693          	addi	a3,a3,-776 # ffffffffc0206778 <commands+0xc08>
ffffffffc0201a88:	00005617          	auipc	a2,0x5
ffffffffc0201a8c:	99860613          	addi	a2,a2,-1640 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201a90:	09000593          	li	a1,144
ffffffffc0201a94:	00005517          	auipc	a0,0x5
ffffffffc0201a98:	9a450513          	addi	a0,a0,-1628 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201a9c:	9f3fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201aa0 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201aa0:	c941                	beqz	a0,ffffffffc0201b30 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201aa2:	000ce597          	auipc	a1,0xce
ffffffffc0201aa6:	86658593          	addi	a1,a1,-1946 # ffffffffc02cf308 <free_area>
ffffffffc0201aaa:	0105a803          	lw	a6,16(a1)
ffffffffc0201aae:	872a                	mv	a4,a0
ffffffffc0201ab0:	02081793          	slli	a5,a6,0x20
ffffffffc0201ab4:	9381                	srli	a5,a5,0x20
ffffffffc0201ab6:	00a7ee63          	bltu	a5,a0,ffffffffc0201ad2 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201aba:	87ae                	mv	a5,a1
ffffffffc0201abc:	a801                	j	ffffffffc0201acc <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201abe:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201ac2:	02069613          	slli	a2,a3,0x20
ffffffffc0201ac6:	9201                	srli	a2,a2,0x20
ffffffffc0201ac8:	00e67763          	bgeu	a2,a4,ffffffffc0201ad6 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201acc:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201ace:	feb798e3          	bne	a5,a1,ffffffffc0201abe <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201ad2:	4501                	li	a0,0
}
ffffffffc0201ad4:	8082                	ret
    return listelm->prev;
ffffffffc0201ad6:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201ada:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201ade:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201ae2:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201ae6:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201aea:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201aee:	02c77863          	bgeu	a4,a2,ffffffffc0201b1e <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201af2:	071a                	slli	a4,a4,0x6
ffffffffc0201af4:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201af6:	41c686bb          	subw	a3,a3,t3
ffffffffc0201afa:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201afc:	00870613          	addi	a2,a4,8
ffffffffc0201b00:	4689                	li	a3,2
ffffffffc0201b02:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201b06:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201b0a:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201b0e:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201b12:	e290                	sd	a2,0(a3)
ffffffffc0201b14:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201b18:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201b1a:	01173c23          	sd	a7,24(a4)
ffffffffc0201b1e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201b22:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201b26:	5775                	li	a4,-3
ffffffffc0201b28:	17c1                	addi	a5,a5,-16
ffffffffc0201b2a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201b2e:	8082                	ret
{
ffffffffc0201b30:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201b32:	00005697          	auipc	a3,0x5
ffffffffc0201b36:	c4668693          	addi	a3,a3,-954 # ffffffffc0206778 <commands+0xc08>
ffffffffc0201b3a:	00005617          	auipc	a2,0x5
ffffffffc0201b3e:	8e660613          	addi	a2,a2,-1818 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201b42:	06c00593          	li	a1,108
ffffffffc0201b46:	00005517          	auipc	a0,0x5
ffffffffc0201b4a:	8f250513          	addi	a0,a0,-1806 # ffffffffc0206438 <commands+0x8c8>
{
ffffffffc0201b4e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201b50:	93ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b54 <default_init_memmap>:
{
ffffffffc0201b54:	1141                	addi	sp,sp,-16
ffffffffc0201b56:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201b58:	c5f1                	beqz	a1,ffffffffc0201c24 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201b5a:	00659693          	slli	a3,a1,0x6
ffffffffc0201b5e:	96aa                	add	a3,a3,a0
ffffffffc0201b60:	87aa                	mv	a5,a0
ffffffffc0201b62:	00d50f63          	beq	a0,a3,ffffffffc0201b80 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201b66:	6798                	ld	a4,8(a5)
ffffffffc0201b68:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201b6a:	cf49                	beqz	a4,ffffffffc0201c04 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201b6c:	0007a823          	sw	zero,16(a5)
ffffffffc0201b70:	0007b423          	sd	zero,8(a5)
ffffffffc0201b74:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201b78:	04078793          	addi	a5,a5,64
ffffffffc0201b7c:	fed795e3          	bne	a5,a3,ffffffffc0201b66 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201b80:	2581                	sext.w	a1,a1
ffffffffc0201b82:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201b84:	4789                	li	a5,2
ffffffffc0201b86:	00850713          	addi	a4,a0,8
ffffffffc0201b8a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201b8e:	000cd697          	auipc	a3,0xcd
ffffffffc0201b92:	77a68693          	addi	a3,a3,1914 # ffffffffc02cf308 <free_area>
ffffffffc0201b96:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201b98:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201b9a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201b9e:	9db9                	addw	a1,a1,a4
ffffffffc0201ba0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201ba2:	04d78a63          	beq	a5,a3,ffffffffc0201bf6 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201ba6:	fe878713          	addi	a4,a5,-24
ffffffffc0201baa:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201bae:	4581                	li	a1,0
            if (base < page)
ffffffffc0201bb0:	00e56a63          	bltu	a0,a4,ffffffffc0201bc4 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201bb4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201bb6:	02d70263          	beq	a4,a3,ffffffffc0201bda <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201bba:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201bbc:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201bc0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201bb4 <default_init_memmap+0x60>
ffffffffc0201bc4:	c199                	beqz	a1,ffffffffc0201bca <default_init_memmap+0x76>
ffffffffc0201bc6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201bca:	6398                	ld	a4,0(a5)
}
ffffffffc0201bcc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201bce:	e390                	sd	a2,0(a5)
ffffffffc0201bd0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201bd2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201bd4:	ed18                	sd	a4,24(a0)
ffffffffc0201bd6:	0141                	addi	sp,sp,16
ffffffffc0201bd8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201bda:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201bdc:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201bde:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201be0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201be2:	00d70663          	beq	a4,a3,ffffffffc0201bee <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201be6:	8832                	mv	a6,a2
ffffffffc0201be8:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201bea:	87ba                	mv	a5,a4
ffffffffc0201bec:	bfc1                	j	ffffffffc0201bbc <default_init_memmap+0x68>
}
ffffffffc0201bee:	60a2                	ld	ra,8(sp)
ffffffffc0201bf0:	e290                	sd	a2,0(a3)
ffffffffc0201bf2:	0141                	addi	sp,sp,16
ffffffffc0201bf4:	8082                	ret
ffffffffc0201bf6:	60a2                	ld	ra,8(sp)
ffffffffc0201bf8:	e390                	sd	a2,0(a5)
ffffffffc0201bfa:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201bfc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201bfe:	ed1c                	sd	a5,24(a0)
ffffffffc0201c00:	0141                	addi	sp,sp,16
ffffffffc0201c02:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201c04:	00005697          	auipc	a3,0x5
ffffffffc0201c08:	ba468693          	addi	a3,a3,-1116 # ffffffffc02067a8 <commands+0xc38>
ffffffffc0201c0c:	00005617          	auipc	a2,0x5
ffffffffc0201c10:	81460613          	addi	a2,a2,-2028 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201c14:	04b00593          	li	a1,75
ffffffffc0201c18:	00005517          	auipc	a0,0x5
ffffffffc0201c1c:	82050513          	addi	a0,a0,-2016 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201c20:	86ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201c24:	00005697          	auipc	a3,0x5
ffffffffc0201c28:	b5468693          	addi	a3,a3,-1196 # ffffffffc0206778 <commands+0xc08>
ffffffffc0201c2c:	00004617          	auipc	a2,0x4
ffffffffc0201c30:	7f460613          	addi	a2,a2,2036 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201c34:	04700593          	li	a1,71
ffffffffc0201c38:	00005517          	auipc	a0,0x5
ffffffffc0201c3c:	80050513          	addi	a0,a0,-2048 # ffffffffc0206438 <commands+0x8c8>
ffffffffc0201c40:	84ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c44 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201c44:	c94d                	beqz	a0,ffffffffc0201cf6 <slob_free+0xb2>
{
ffffffffc0201c46:	1141                	addi	sp,sp,-16
ffffffffc0201c48:	e022                	sd	s0,0(sp)
ffffffffc0201c4a:	e406                	sd	ra,8(sp)
ffffffffc0201c4c:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201c4e:	e9c1                	bnez	a1,ffffffffc0201cde <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c50:	100027f3          	csrr	a5,sstatus
ffffffffc0201c54:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201c56:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c58:	ebd9                	bnez	a5,ffffffffc0201cee <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201c5a:	000cd617          	auipc	a2,0xcd
ffffffffc0201c5e:	29e60613          	addi	a2,a2,670 # ffffffffc02ceef8 <slobfree>
ffffffffc0201c62:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c64:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201c66:	679c                	ld	a5,8(a5)
ffffffffc0201c68:	02877a63          	bgeu	a4,s0,ffffffffc0201c9c <slob_free+0x58>
ffffffffc0201c6c:	00f46463          	bltu	s0,a5,ffffffffc0201c74 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c70:	fef76ae3          	bltu	a4,a5,ffffffffc0201c64 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201c74:	400c                	lw	a1,0(s0)
ffffffffc0201c76:	00459693          	slli	a3,a1,0x4
ffffffffc0201c7a:	96a2                	add	a3,a3,s0
ffffffffc0201c7c:	02d78a63          	beq	a5,a3,ffffffffc0201cb0 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201c80:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201c82:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201c84:	00469793          	slli	a5,a3,0x4
ffffffffc0201c88:	97ba                	add	a5,a5,a4
ffffffffc0201c8a:	02f40e63          	beq	s0,a5,ffffffffc0201cc6 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201c8e:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201c90:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201c92:	e129                	bnez	a0,ffffffffc0201cd4 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201c94:	60a2                	ld	ra,8(sp)
ffffffffc0201c96:	6402                	ld	s0,0(sp)
ffffffffc0201c98:	0141                	addi	sp,sp,16
ffffffffc0201c9a:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c9c:	fcf764e3          	bltu	a4,a5,ffffffffc0201c64 <slob_free+0x20>
ffffffffc0201ca0:	fcf472e3          	bgeu	s0,a5,ffffffffc0201c64 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201ca4:	400c                	lw	a1,0(s0)
ffffffffc0201ca6:	00459693          	slli	a3,a1,0x4
ffffffffc0201caa:	96a2                	add	a3,a3,s0
ffffffffc0201cac:	fcd79ae3          	bne	a5,a3,ffffffffc0201c80 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201cb0:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201cb2:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201cb4:	9db5                	addw	a1,a1,a3
ffffffffc0201cb6:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201cb8:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201cba:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201cbc:	00469793          	slli	a5,a3,0x4
ffffffffc0201cc0:	97ba                	add	a5,a5,a4
ffffffffc0201cc2:	fcf416e3          	bne	s0,a5,ffffffffc0201c8e <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201cc6:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201cc8:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201cca:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201ccc:	9ebd                	addw	a3,a3,a5
ffffffffc0201cce:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201cd0:	e70c                	sd	a1,8(a4)
ffffffffc0201cd2:	d169                	beqz	a0,ffffffffc0201c94 <slob_free+0x50>
}
ffffffffc0201cd4:	6402                	ld	s0,0(sp)
ffffffffc0201cd6:	60a2                	ld	ra,8(sp)
ffffffffc0201cd8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201cda:	cd5fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201cde:	25bd                	addiw	a1,a1,15
ffffffffc0201ce0:	8191                	srli	a1,a1,0x4
ffffffffc0201ce2:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ce4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ce8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201cea:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cec:	d7bd                	beqz	a5,ffffffffc0201c5a <slob_free+0x16>
        intr_disable();
ffffffffc0201cee:	cc7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201cf2:	4505                	li	a0,1
ffffffffc0201cf4:	b79d                	j	ffffffffc0201c5a <slob_free+0x16>
ffffffffc0201cf6:	8082                	ret

ffffffffc0201cf8 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201cf8:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201cfa:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201cfc:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201d00:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201d02:	352000ef          	jal	ra,ffffffffc0202054 <alloc_pages>
	if (!page)
ffffffffc0201d06:	c91d                	beqz	a0,ffffffffc0201d3c <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201d08:	000d1697          	auipc	a3,0xd1
ffffffffc0201d0c:	6706b683          	ld	a3,1648(a3) # ffffffffc02d3378 <pages>
ffffffffc0201d10:	8d15                	sub	a0,a0,a3
ffffffffc0201d12:	8519                	srai	a0,a0,0x6
ffffffffc0201d14:	00006697          	auipc	a3,0x6
ffffffffc0201d18:	d4c6b683          	ld	a3,-692(a3) # ffffffffc0207a60 <nbase>
ffffffffc0201d1c:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201d1e:	00c51793          	slli	a5,a0,0xc
ffffffffc0201d22:	83b1                	srli	a5,a5,0xc
ffffffffc0201d24:	000d1717          	auipc	a4,0xd1
ffffffffc0201d28:	64c73703          	ld	a4,1612(a4) # ffffffffc02d3370 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201d2c:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201d2e:	00e7fa63          	bgeu	a5,a4,ffffffffc0201d42 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201d32:	000d1697          	auipc	a3,0xd1
ffffffffc0201d36:	6566b683          	ld	a3,1622(a3) # ffffffffc02d3388 <va_pa_offset>
ffffffffc0201d3a:	9536                	add	a0,a0,a3
}
ffffffffc0201d3c:	60a2                	ld	ra,8(sp)
ffffffffc0201d3e:	0141                	addi	sp,sp,16
ffffffffc0201d40:	8082                	ret
ffffffffc0201d42:	86aa                	mv	a3,a0
ffffffffc0201d44:	00004617          	auipc	a2,0x4
ffffffffc0201d48:	64c60613          	addi	a2,a2,1612 # ffffffffc0206390 <commands+0x820>
ffffffffc0201d4c:	07100593          	li	a1,113
ffffffffc0201d50:	00004517          	auipc	a0,0x4
ffffffffc0201d54:	5f850513          	addi	a0,a0,1528 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0201d58:	f36fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d5c <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201d5c:	1101                	addi	sp,sp,-32
ffffffffc0201d5e:	ec06                	sd	ra,24(sp)
ffffffffc0201d60:	e822                	sd	s0,16(sp)
ffffffffc0201d62:	e426                	sd	s1,8(sp)
ffffffffc0201d64:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d66:	01050713          	addi	a4,a0,16
ffffffffc0201d6a:	6785                	lui	a5,0x1
ffffffffc0201d6c:	0cf77363          	bgeu	a4,a5,ffffffffc0201e32 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201d70:	00f50493          	addi	s1,a0,15
ffffffffc0201d74:	8091                	srli	s1,s1,0x4
ffffffffc0201d76:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d78:	10002673          	csrr	a2,sstatus
ffffffffc0201d7c:	8a09                	andi	a2,a2,2
ffffffffc0201d7e:	e25d                	bnez	a2,ffffffffc0201e24 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201d80:	000cd917          	auipc	s2,0xcd
ffffffffc0201d84:	17890913          	addi	s2,s2,376 # ffffffffc02ceef8 <slobfree>
ffffffffc0201d88:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201d8c:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201d8e:	4398                	lw	a4,0(a5)
ffffffffc0201d90:	08975e63          	bge	a4,s1,ffffffffc0201e2c <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201d94:	00f68b63          	beq	a3,a5,ffffffffc0201daa <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201d98:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201d9a:	4018                	lw	a4,0(s0)
ffffffffc0201d9c:	02975a63          	bge	a4,s1,ffffffffc0201dd0 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201da0:	00093683          	ld	a3,0(s2)
ffffffffc0201da4:	87a2                	mv	a5,s0
ffffffffc0201da6:	fef699e3          	bne	a3,a5,ffffffffc0201d98 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201daa:	ee31                	bnez	a2,ffffffffc0201e06 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201dac:	4501                	li	a0,0
ffffffffc0201dae:	f4bff0ef          	jal	ra,ffffffffc0201cf8 <__slob_get_free_pages.constprop.0>
ffffffffc0201db2:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201db4:	cd05                	beqz	a0,ffffffffc0201dec <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201db6:	6585                	lui	a1,0x1
ffffffffc0201db8:	e8dff0ef          	jal	ra,ffffffffc0201c44 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dbc:	10002673          	csrr	a2,sstatus
ffffffffc0201dc0:	8a09                	andi	a2,a2,2
ffffffffc0201dc2:	ee05                	bnez	a2,ffffffffc0201dfa <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201dc4:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201dc8:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201dca:	4018                	lw	a4,0(s0)
ffffffffc0201dcc:	fc974ae3          	blt	a4,s1,ffffffffc0201da0 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201dd0:	04e48763          	beq	s1,a4,ffffffffc0201e1e <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201dd4:	00449693          	slli	a3,s1,0x4
ffffffffc0201dd8:	96a2                	add	a3,a3,s0
ffffffffc0201dda:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201ddc:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201dde:	9f05                	subw	a4,a4,s1
ffffffffc0201de0:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201de2:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201de4:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201de6:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201dea:	e20d                	bnez	a2,ffffffffc0201e0c <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201dec:	60e2                	ld	ra,24(sp)
ffffffffc0201dee:	8522                	mv	a0,s0
ffffffffc0201df0:	6442                	ld	s0,16(sp)
ffffffffc0201df2:	64a2                	ld	s1,8(sp)
ffffffffc0201df4:	6902                	ld	s2,0(sp)
ffffffffc0201df6:	6105                	addi	sp,sp,32
ffffffffc0201df8:	8082                	ret
        intr_disable();
ffffffffc0201dfa:	bbbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201dfe:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201e02:	4605                	li	a2,1
ffffffffc0201e04:	b7d1                	j	ffffffffc0201dc8 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201e06:	ba9fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e0a:	b74d                	j	ffffffffc0201dac <slob_alloc.constprop.0+0x50>
ffffffffc0201e0c:	ba3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201e10:	60e2                	ld	ra,24(sp)
ffffffffc0201e12:	8522                	mv	a0,s0
ffffffffc0201e14:	6442                	ld	s0,16(sp)
ffffffffc0201e16:	64a2                	ld	s1,8(sp)
ffffffffc0201e18:	6902                	ld	s2,0(sp)
ffffffffc0201e1a:	6105                	addi	sp,sp,32
ffffffffc0201e1c:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201e1e:	6418                	ld	a4,8(s0)
ffffffffc0201e20:	e798                	sd	a4,8(a5)
ffffffffc0201e22:	b7d1                	j	ffffffffc0201de6 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201e24:	b91fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201e28:	4605                	li	a2,1
ffffffffc0201e2a:	bf99                	j	ffffffffc0201d80 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201e2c:	843e                	mv	s0,a5
ffffffffc0201e2e:	87b6                	mv	a5,a3
ffffffffc0201e30:	b745                	j	ffffffffc0201dd0 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201e32:	00005697          	auipc	a3,0x5
ffffffffc0201e36:	9d668693          	addi	a3,a3,-1578 # ffffffffc0206808 <default_pmm_manager+0x38>
ffffffffc0201e3a:	00004617          	auipc	a2,0x4
ffffffffc0201e3e:	5e660613          	addi	a2,a2,1510 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0201e42:	06300593          	li	a1,99
ffffffffc0201e46:	00005517          	auipc	a0,0x5
ffffffffc0201e4a:	9e250513          	addi	a0,a0,-1566 # ffffffffc0206828 <default_pmm_manager+0x58>
ffffffffc0201e4e:	e40fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e52 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201e52:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201e54:	00005517          	auipc	a0,0x5
ffffffffc0201e58:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0206840 <default_pmm_manager+0x70>
{
ffffffffc0201e5c:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201e5e:	b36fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201e62:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201e64:	00005517          	auipc	a0,0x5
ffffffffc0201e68:	9f450513          	addi	a0,a0,-1548 # ffffffffc0206858 <default_pmm_manager+0x88>
}
ffffffffc0201e6c:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201e6e:	b26fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201e72 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201e72:	4501                	li	a0,0
ffffffffc0201e74:	8082                	ret

ffffffffc0201e76 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201e76:	1101                	addi	sp,sp,-32
ffffffffc0201e78:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201e7a:	6905                	lui	s2,0x1
{
ffffffffc0201e7c:	e822                	sd	s0,16(sp)
ffffffffc0201e7e:	ec06                	sd	ra,24(sp)
ffffffffc0201e80:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201e82:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bd1>
{
ffffffffc0201e86:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201e88:	04a7f963          	bgeu	a5,a0,ffffffffc0201eda <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201e8c:	4561                	li	a0,24
ffffffffc0201e8e:	ecfff0ef          	jal	ra,ffffffffc0201d5c <slob_alloc.constprop.0>
ffffffffc0201e92:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201e94:	c929                	beqz	a0,ffffffffc0201ee6 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201e96:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201e9a:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201e9c:	00f95763          	bge	s2,a5,ffffffffc0201eaa <kmalloc+0x34>
ffffffffc0201ea0:	6705                	lui	a4,0x1
ffffffffc0201ea2:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201ea4:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201ea6:	fef74ee3          	blt	a4,a5,ffffffffc0201ea2 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201eaa:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201eac:	e4dff0ef          	jal	ra,ffffffffc0201cf8 <__slob_get_free_pages.constprop.0>
ffffffffc0201eb0:	e488                	sd	a0,8(s1)
ffffffffc0201eb2:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201eb4:	c525                	beqz	a0,ffffffffc0201f1c <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eb6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eba:	8b89                	andi	a5,a5,2
ffffffffc0201ebc:	ef8d                	bnez	a5,ffffffffc0201ef6 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201ebe:	000d1797          	auipc	a5,0xd1
ffffffffc0201ec2:	49a78793          	addi	a5,a5,1178 # ffffffffc02d3358 <bigblocks>
ffffffffc0201ec6:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201ec8:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201eca:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201ecc:	60e2                	ld	ra,24(sp)
ffffffffc0201ece:	8522                	mv	a0,s0
ffffffffc0201ed0:	6442                	ld	s0,16(sp)
ffffffffc0201ed2:	64a2                	ld	s1,8(sp)
ffffffffc0201ed4:	6902                	ld	s2,0(sp)
ffffffffc0201ed6:	6105                	addi	sp,sp,32
ffffffffc0201ed8:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201eda:	0541                	addi	a0,a0,16
ffffffffc0201edc:	e81ff0ef          	jal	ra,ffffffffc0201d5c <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201ee0:	01050413          	addi	s0,a0,16
ffffffffc0201ee4:	f565                	bnez	a0,ffffffffc0201ecc <kmalloc+0x56>
ffffffffc0201ee6:	4401                	li	s0,0
}
ffffffffc0201ee8:	60e2                	ld	ra,24(sp)
ffffffffc0201eea:	8522                	mv	a0,s0
ffffffffc0201eec:	6442                	ld	s0,16(sp)
ffffffffc0201eee:	64a2                	ld	s1,8(sp)
ffffffffc0201ef0:	6902                	ld	s2,0(sp)
ffffffffc0201ef2:	6105                	addi	sp,sp,32
ffffffffc0201ef4:	8082                	ret
        intr_disable();
ffffffffc0201ef6:	abffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201efa:	000d1797          	auipc	a5,0xd1
ffffffffc0201efe:	45e78793          	addi	a5,a5,1118 # ffffffffc02d3358 <bigblocks>
ffffffffc0201f02:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201f04:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201f06:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201f08:	aa7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201f0c:	6480                	ld	s0,8(s1)
}
ffffffffc0201f0e:	60e2                	ld	ra,24(sp)
ffffffffc0201f10:	64a2                	ld	s1,8(sp)
ffffffffc0201f12:	8522                	mv	a0,s0
ffffffffc0201f14:	6442                	ld	s0,16(sp)
ffffffffc0201f16:	6902                	ld	s2,0(sp)
ffffffffc0201f18:	6105                	addi	sp,sp,32
ffffffffc0201f1a:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201f1c:	45e1                	li	a1,24
ffffffffc0201f1e:	8526                	mv	a0,s1
ffffffffc0201f20:	d25ff0ef          	jal	ra,ffffffffc0201c44 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201f24:	b765                	j	ffffffffc0201ecc <kmalloc+0x56>

ffffffffc0201f26 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201f26:	c169                	beqz	a0,ffffffffc0201fe8 <kfree+0xc2>
{
ffffffffc0201f28:	1101                	addi	sp,sp,-32
ffffffffc0201f2a:	e822                	sd	s0,16(sp)
ffffffffc0201f2c:	ec06                	sd	ra,24(sp)
ffffffffc0201f2e:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201f30:	03451793          	slli	a5,a0,0x34
ffffffffc0201f34:	842a                	mv	s0,a0
ffffffffc0201f36:	e3d9                	bnez	a5,ffffffffc0201fbc <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f38:	100027f3          	csrr	a5,sstatus
ffffffffc0201f3c:	8b89                	andi	a5,a5,2
ffffffffc0201f3e:	e7d9                	bnez	a5,ffffffffc0201fcc <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201f40:	000d1797          	auipc	a5,0xd1
ffffffffc0201f44:	4187b783          	ld	a5,1048(a5) # ffffffffc02d3358 <bigblocks>
    return 0;
ffffffffc0201f48:	4601                	li	a2,0
ffffffffc0201f4a:	cbad                	beqz	a5,ffffffffc0201fbc <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201f4c:	000d1697          	auipc	a3,0xd1
ffffffffc0201f50:	40c68693          	addi	a3,a3,1036 # ffffffffc02d3358 <bigblocks>
ffffffffc0201f54:	a021                	j	ffffffffc0201f5c <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201f56:	01048693          	addi	a3,s1,16
ffffffffc0201f5a:	c3a5                	beqz	a5,ffffffffc0201fba <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201f5c:	6798                	ld	a4,8(a5)
ffffffffc0201f5e:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201f60:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201f62:	fe871ae3          	bne	a4,s0,ffffffffc0201f56 <kfree+0x30>
				*last = bb->next;
ffffffffc0201f66:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201f68:	ee2d                	bnez	a2,ffffffffc0201fe2 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201f6a:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201f6e:	4098                	lw	a4,0(s1)
ffffffffc0201f70:	08f46963          	bltu	s0,a5,ffffffffc0202002 <kfree+0xdc>
ffffffffc0201f74:	000d1697          	auipc	a3,0xd1
ffffffffc0201f78:	4146b683          	ld	a3,1044(a3) # ffffffffc02d3388 <va_pa_offset>
ffffffffc0201f7c:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201f7e:	8031                	srli	s0,s0,0xc
ffffffffc0201f80:	000d1797          	auipc	a5,0xd1
ffffffffc0201f84:	3f07b783          	ld	a5,1008(a5) # ffffffffc02d3370 <npage>
ffffffffc0201f88:	06f47163          	bgeu	s0,a5,ffffffffc0201fea <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201f8c:	00006517          	auipc	a0,0x6
ffffffffc0201f90:	ad453503          	ld	a0,-1324(a0) # ffffffffc0207a60 <nbase>
ffffffffc0201f94:	8c09                	sub	s0,s0,a0
ffffffffc0201f96:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201f98:	000d1517          	auipc	a0,0xd1
ffffffffc0201f9c:	3e053503          	ld	a0,992(a0) # ffffffffc02d3378 <pages>
ffffffffc0201fa0:	4585                	li	a1,1
ffffffffc0201fa2:	9522                	add	a0,a0,s0
ffffffffc0201fa4:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201fa8:	0ea000ef          	jal	ra,ffffffffc0202092 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201fac:	6442                	ld	s0,16(sp)
ffffffffc0201fae:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201fb0:	8526                	mv	a0,s1
}
ffffffffc0201fb2:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201fb4:	45e1                	li	a1,24
}
ffffffffc0201fb6:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fb8:	b171                	j	ffffffffc0201c44 <slob_free>
ffffffffc0201fba:	e20d                	bnez	a2,ffffffffc0201fdc <kfree+0xb6>
ffffffffc0201fbc:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201fc0:	6442                	ld	s0,16(sp)
ffffffffc0201fc2:	60e2                	ld	ra,24(sp)
ffffffffc0201fc4:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fc6:	4581                	li	a1,0
}
ffffffffc0201fc8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201fca:	b9ad                	j	ffffffffc0201c44 <slob_free>
        intr_disable();
ffffffffc0201fcc:	9e9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201fd0:	000d1797          	auipc	a5,0xd1
ffffffffc0201fd4:	3887b783          	ld	a5,904(a5) # ffffffffc02d3358 <bigblocks>
        return 1;
ffffffffc0201fd8:	4605                	li	a2,1
ffffffffc0201fda:	fbad                	bnez	a5,ffffffffc0201f4c <kfree+0x26>
        intr_enable();
ffffffffc0201fdc:	9d3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201fe0:	bff1                	j	ffffffffc0201fbc <kfree+0x96>
ffffffffc0201fe2:	9cdfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201fe6:	b751                	j	ffffffffc0201f6a <kfree+0x44>
ffffffffc0201fe8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201fea:	00004617          	auipc	a2,0x4
ffffffffc0201fee:	36e60613          	addi	a2,a2,878 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0201ff2:	06900593          	li	a1,105
ffffffffc0201ff6:	00004517          	auipc	a0,0x4
ffffffffc0201ffa:	35250513          	addi	a0,a0,850 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0201ffe:	c90fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0202002:	86a2                	mv	a3,s0
ffffffffc0202004:	00005617          	auipc	a2,0x5
ffffffffc0202008:	87460613          	addi	a2,a2,-1932 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc020200c:	07700593          	li	a1,119
ffffffffc0202010:	00004517          	auipc	a0,0x4
ffffffffc0202014:	33850513          	addi	a0,a0,824 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0202018:	c76fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020201c <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc020201c:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc020201e:	00004617          	auipc	a2,0x4
ffffffffc0202022:	33a60613          	addi	a2,a2,826 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0202026:	06900593          	li	a1,105
ffffffffc020202a:	00004517          	auipc	a0,0x4
ffffffffc020202e:	31e50513          	addi	a0,a0,798 # ffffffffc0206348 <commands+0x7d8>
pa2page(uintptr_t pa)
ffffffffc0202032:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202034:	c5afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202038 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0202038:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc020203a:	00004617          	auipc	a2,0x4
ffffffffc020203e:	2e660613          	addi	a2,a2,742 # ffffffffc0206320 <commands+0x7b0>
ffffffffc0202042:	07f00593          	li	a1,127
ffffffffc0202046:	00004517          	auipc	a0,0x4
ffffffffc020204a:	30250513          	addi	a0,a0,770 # ffffffffc0206348 <commands+0x7d8>
pte2page(pte_t pte)
ffffffffc020204e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202050:	c3efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202054 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202054:	100027f3          	csrr	a5,sstatus
ffffffffc0202058:	8b89                	andi	a5,a5,2
ffffffffc020205a:	e799                	bnez	a5,ffffffffc0202068 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc020205c:	000d1797          	auipc	a5,0xd1
ffffffffc0202060:	3247b783          	ld	a5,804(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc0202064:	6f9c                	ld	a5,24(a5)
ffffffffc0202066:	8782                	jr	a5
{
ffffffffc0202068:	1141                	addi	sp,sp,-16
ffffffffc020206a:	e406                	sd	ra,8(sp)
ffffffffc020206c:	e022                	sd	s0,0(sp)
ffffffffc020206e:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202070:	945fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202074:	000d1797          	auipc	a5,0xd1
ffffffffc0202078:	30c7b783          	ld	a5,780(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc020207c:	6f9c                	ld	a5,24(a5)
ffffffffc020207e:	8522                	mv	a0,s0
ffffffffc0202080:	9782                	jalr	a5
ffffffffc0202082:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202084:	92bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0202088:	60a2                	ld	ra,8(sp)
ffffffffc020208a:	8522                	mv	a0,s0
ffffffffc020208c:	6402                	ld	s0,0(sp)
ffffffffc020208e:	0141                	addi	sp,sp,16
ffffffffc0202090:	8082                	ret

ffffffffc0202092 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202092:	100027f3          	csrr	a5,sstatus
ffffffffc0202096:	8b89                	andi	a5,a5,2
ffffffffc0202098:	e799                	bnez	a5,ffffffffc02020a6 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020209a:	000d1797          	auipc	a5,0xd1
ffffffffc020209e:	2e67b783          	ld	a5,742(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02020a2:	739c                	ld	a5,32(a5)
ffffffffc02020a4:	8782                	jr	a5
{
ffffffffc02020a6:	1101                	addi	sp,sp,-32
ffffffffc02020a8:	ec06                	sd	ra,24(sp)
ffffffffc02020aa:	e822                	sd	s0,16(sp)
ffffffffc02020ac:	e426                	sd	s1,8(sp)
ffffffffc02020ae:	842a                	mv	s0,a0
ffffffffc02020b0:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02020b2:	903fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02020b6:	000d1797          	auipc	a5,0xd1
ffffffffc02020ba:	2ca7b783          	ld	a5,714(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02020be:	739c                	ld	a5,32(a5)
ffffffffc02020c0:	85a6                	mv	a1,s1
ffffffffc02020c2:	8522                	mv	a0,s0
ffffffffc02020c4:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02020c6:	6442                	ld	s0,16(sp)
ffffffffc02020c8:	60e2                	ld	ra,24(sp)
ffffffffc02020ca:	64a2                	ld	s1,8(sp)
ffffffffc02020cc:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02020ce:	8e1fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc02020d2 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02020d2:	100027f3          	csrr	a5,sstatus
ffffffffc02020d6:	8b89                	andi	a5,a5,2
ffffffffc02020d8:	e799                	bnez	a5,ffffffffc02020e6 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02020da:	000d1797          	auipc	a5,0xd1
ffffffffc02020de:	2a67b783          	ld	a5,678(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02020e2:	779c                	ld	a5,40(a5)
ffffffffc02020e4:	8782                	jr	a5
{
ffffffffc02020e6:	1141                	addi	sp,sp,-16
ffffffffc02020e8:	e406                	sd	ra,8(sp)
ffffffffc02020ea:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02020ec:	8c9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02020f0:	000d1797          	auipc	a5,0xd1
ffffffffc02020f4:	2907b783          	ld	a5,656(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02020f8:	779c                	ld	a5,40(a5)
ffffffffc02020fa:	9782                	jalr	a5
ffffffffc02020fc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02020fe:	8b1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202102:	60a2                	ld	ra,8(sp)
ffffffffc0202104:	8522                	mv	a0,s0
ffffffffc0202106:	6402                	ld	s0,0(sp)
ffffffffc0202108:	0141                	addi	sp,sp,16
ffffffffc020210a:	8082                	ret

ffffffffc020210c <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020210c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202110:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0202114:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202116:	078e                	slli	a5,a5,0x3
{
ffffffffc0202118:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020211a:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc020211e:	6094                	ld	a3,0(s1)
{
ffffffffc0202120:	f04a                	sd	s2,32(sp)
ffffffffc0202122:	ec4e                	sd	s3,24(sp)
ffffffffc0202124:	e852                	sd	s4,16(sp)
ffffffffc0202126:	fc06                	sd	ra,56(sp)
ffffffffc0202128:	f822                	sd	s0,48(sp)
ffffffffc020212a:	e456                	sd	s5,8(sp)
ffffffffc020212c:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc020212e:	0016f793          	andi	a5,a3,1
{
ffffffffc0202132:	892e                	mv	s2,a1
ffffffffc0202134:	8a32                	mv	s4,a2
ffffffffc0202136:	000d1997          	auipc	s3,0xd1
ffffffffc020213a:	23a98993          	addi	s3,s3,570 # ffffffffc02d3370 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc020213e:	efbd                	bnez	a5,ffffffffc02021bc <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202140:	14060c63          	beqz	a2,ffffffffc0202298 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202144:	100027f3          	csrr	a5,sstatus
ffffffffc0202148:	8b89                	andi	a5,a5,2
ffffffffc020214a:	14079963          	bnez	a5,ffffffffc020229c <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc020214e:	000d1797          	auipc	a5,0xd1
ffffffffc0202152:	2327b783          	ld	a5,562(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc0202156:	6f9c                	ld	a5,24(a5)
ffffffffc0202158:	4505                	li	a0,1
ffffffffc020215a:	9782                	jalr	a5
ffffffffc020215c:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020215e:	12040d63          	beqz	s0,ffffffffc0202298 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202162:	000d1b17          	auipc	s6,0xd1
ffffffffc0202166:	216b0b13          	addi	s6,s6,534 # ffffffffc02d3378 <pages>
ffffffffc020216a:	000b3503          	ld	a0,0(s6)
ffffffffc020216e:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202172:	000d1997          	auipc	s3,0xd1
ffffffffc0202176:	1fe98993          	addi	s3,s3,510 # ffffffffc02d3370 <npage>
ffffffffc020217a:	40a40533          	sub	a0,s0,a0
ffffffffc020217e:	8519                	srai	a0,a0,0x6
ffffffffc0202180:	9556                	add	a0,a0,s5
ffffffffc0202182:	0009b703          	ld	a4,0(s3)
ffffffffc0202186:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020218a:	4685                	li	a3,1
ffffffffc020218c:	c014                	sw	a3,0(s0)
ffffffffc020218e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202190:	0532                	slli	a0,a0,0xc
ffffffffc0202192:	16e7f763          	bgeu	a5,a4,ffffffffc0202300 <get_pte+0x1f4>
ffffffffc0202196:	000d1797          	auipc	a5,0xd1
ffffffffc020219a:	1f27b783          	ld	a5,498(a5) # ffffffffc02d3388 <va_pa_offset>
ffffffffc020219e:	6605                	lui	a2,0x1
ffffffffc02021a0:	4581                	li	a1,0
ffffffffc02021a2:	953e                	add	a0,a0,a5
ffffffffc02021a4:	736030ef          	jal	ra,ffffffffc02058da <memset>
    return page - pages + nbase;
ffffffffc02021a8:	000b3683          	ld	a3,0(s6)
ffffffffc02021ac:	40d406b3          	sub	a3,s0,a3
ffffffffc02021b0:	8699                	srai	a3,a3,0x6
ffffffffc02021b2:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02021b4:	06aa                	slli	a3,a3,0xa
ffffffffc02021b6:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02021ba:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021bc:	77fd                	lui	a5,0xfffff
ffffffffc02021be:	068a                	slli	a3,a3,0x2
ffffffffc02021c0:	0009b703          	ld	a4,0(s3)
ffffffffc02021c4:	8efd                	and	a3,a3,a5
ffffffffc02021c6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02021ca:	10e7ff63          	bgeu	a5,a4,ffffffffc02022e8 <get_pte+0x1dc>
ffffffffc02021ce:	000d1a97          	auipc	s5,0xd1
ffffffffc02021d2:	1baa8a93          	addi	s5,s5,442 # ffffffffc02d3388 <va_pa_offset>
ffffffffc02021d6:	000ab403          	ld	s0,0(s5)
ffffffffc02021da:	01595793          	srli	a5,s2,0x15
ffffffffc02021de:	1ff7f793          	andi	a5,a5,511
ffffffffc02021e2:	96a2                	add	a3,a3,s0
ffffffffc02021e4:	00379413          	slli	s0,a5,0x3
ffffffffc02021e8:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02021ea:	6014                	ld	a3,0(s0)
ffffffffc02021ec:	0016f793          	andi	a5,a3,1
ffffffffc02021f0:	ebad                	bnez	a5,ffffffffc0202262 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02021f2:	0a0a0363          	beqz	s4,ffffffffc0202298 <get_pte+0x18c>
ffffffffc02021f6:	100027f3          	csrr	a5,sstatus
ffffffffc02021fa:	8b89                	andi	a5,a5,2
ffffffffc02021fc:	efcd                	bnez	a5,ffffffffc02022b6 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc02021fe:	000d1797          	auipc	a5,0xd1
ffffffffc0202202:	1827b783          	ld	a5,386(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc0202206:	6f9c                	ld	a5,24(a5)
ffffffffc0202208:	4505                	li	a0,1
ffffffffc020220a:	9782                	jalr	a5
ffffffffc020220c:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020220e:	c4c9                	beqz	s1,ffffffffc0202298 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202210:	000d1b17          	auipc	s6,0xd1
ffffffffc0202214:	168b0b13          	addi	s6,s6,360 # ffffffffc02d3378 <pages>
ffffffffc0202218:	000b3503          	ld	a0,0(s6)
ffffffffc020221c:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202220:	0009b703          	ld	a4,0(s3)
ffffffffc0202224:	40a48533          	sub	a0,s1,a0
ffffffffc0202228:	8519                	srai	a0,a0,0x6
ffffffffc020222a:	9552                	add	a0,a0,s4
ffffffffc020222c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202230:	4685                	li	a3,1
ffffffffc0202232:	c094                	sw	a3,0(s1)
ffffffffc0202234:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202236:	0532                	slli	a0,a0,0xc
ffffffffc0202238:	0ee7f163          	bgeu	a5,a4,ffffffffc020231a <get_pte+0x20e>
ffffffffc020223c:	000ab783          	ld	a5,0(s5)
ffffffffc0202240:	6605                	lui	a2,0x1
ffffffffc0202242:	4581                	li	a1,0
ffffffffc0202244:	953e                	add	a0,a0,a5
ffffffffc0202246:	694030ef          	jal	ra,ffffffffc02058da <memset>
    return page - pages + nbase;
ffffffffc020224a:	000b3683          	ld	a3,0(s6)
ffffffffc020224e:	40d486b3          	sub	a3,s1,a3
ffffffffc0202252:	8699                	srai	a3,a3,0x6
ffffffffc0202254:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202256:	06aa                	slli	a3,a3,0xa
ffffffffc0202258:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020225c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020225e:	0009b703          	ld	a4,0(s3)
ffffffffc0202262:	068a                	slli	a3,a3,0x2
ffffffffc0202264:	757d                	lui	a0,0xfffff
ffffffffc0202266:	8ee9                	and	a3,a3,a0
ffffffffc0202268:	00c6d793          	srli	a5,a3,0xc
ffffffffc020226c:	06e7f263          	bgeu	a5,a4,ffffffffc02022d0 <get_pte+0x1c4>
ffffffffc0202270:	000ab503          	ld	a0,0(s5)
ffffffffc0202274:	00c95913          	srli	s2,s2,0xc
ffffffffc0202278:	1ff97913          	andi	s2,s2,511
ffffffffc020227c:	96aa                	add	a3,a3,a0
ffffffffc020227e:	00391513          	slli	a0,s2,0x3
ffffffffc0202282:	9536                	add	a0,a0,a3
}
ffffffffc0202284:	70e2                	ld	ra,56(sp)
ffffffffc0202286:	7442                	ld	s0,48(sp)
ffffffffc0202288:	74a2                	ld	s1,40(sp)
ffffffffc020228a:	7902                	ld	s2,32(sp)
ffffffffc020228c:	69e2                	ld	s3,24(sp)
ffffffffc020228e:	6a42                	ld	s4,16(sp)
ffffffffc0202290:	6aa2                	ld	s5,8(sp)
ffffffffc0202292:	6b02                	ld	s6,0(sp)
ffffffffc0202294:	6121                	addi	sp,sp,64
ffffffffc0202296:	8082                	ret
            return NULL;
ffffffffc0202298:	4501                	li	a0,0
ffffffffc020229a:	b7ed                	j	ffffffffc0202284 <get_pte+0x178>
        intr_disable();
ffffffffc020229c:	f18fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022a0:	000d1797          	auipc	a5,0xd1
ffffffffc02022a4:	0e07b783          	ld	a5,224(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02022a8:	6f9c                	ld	a5,24(a5)
ffffffffc02022aa:	4505                	li	a0,1
ffffffffc02022ac:	9782                	jalr	a5
ffffffffc02022ae:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02022b0:	efefe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022b4:	b56d                	j	ffffffffc020215e <get_pte+0x52>
        intr_disable();
ffffffffc02022b6:	efefe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022ba:	000d1797          	auipc	a5,0xd1
ffffffffc02022be:	0c67b783          	ld	a5,198(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02022c2:	6f9c                	ld	a5,24(a5)
ffffffffc02022c4:	4505                	li	a0,1
ffffffffc02022c6:	9782                	jalr	a5
ffffffffc02022c8:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02022ca:	ee4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022ce:	b781                	j	ffffffffc020220e <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02022d0:	00004617          	auipc	a2,0x4
ffffffffc02022d4:	0c060613          	addi	a2,a2,192 # ffffffffc0206390 <commands+0x820>
ffffffffc02022d8:	0fa00593          	li	a1,250
ffffffffc02022dc:	00004517          	auipc	a0,0x4
ffffffffc02022e0:	5c450513          	addi	a0,a0,1476 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02022e4:	9aafe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02022e8:	00004617          	auipc	a2,0x4
ffffffffc02022ec:	0a860613          	addi	a2,a2,168 # ffffffffc0206390 <commands+0x820>
ffffffffc02022f0:	0ed00593          	li	a1,237
ffffffffc02022f4:	00004517          	auipc	a0,0x4
ffffffffc02022f8:	5ac50513          	addi	a0,a0,1452 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02022fc:	992fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202300:	86aa                	mv	a3,a0
ffffffffc0202302:	00004617          	auipc	a2,0x4
ffffffffc0202306:	08e60613          	addi	a2,a2,142 # ffffffffc0206390 <commands+0x820>
ffffffffc020230a:	0e900593          	li	a1,233
ffffffffc020230e:	00004517          	auipc	a0,0x4
ffffffffc0202312:	59250513          	addi	a0,a0,1426 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0202316:	978fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020231a:	86aa                	mv	a3,a0
ffffffffc020231c:	00004617          	auipc	a2,0x4
ffffffffc0202320:	07460613          	addi	a2,a2,116 # ffffffffc0206390 <commands+0x820>
ffffffffc0202324:	0f700593          	li	a1,247
ffffffffc0202328:	00004517          	auipc	a0,0x4
ffffffffc020232c:	57850513          	addi	a0,a0,1400 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0202330:	95efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202334 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202334:	1141                	addi	sp,sp,-16
ffffffffc0202336:	e022                	sd	s0,0(sp)
ffffffffc0202338:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020233a:	4601                	li	a2,0
{
ffffffffc020233c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020233e:	dcfff0ef          	jal	ra,ffffffffc020210c <get_pte>
    if (ptep_store != NULL)
ffffffffc0202342:	c011                	beqz	s0,ffffffffc0202346 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202344:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202346:	c511                	beqz	a0,ffffffffc0202352 <get_page+0x1e>
ffffffffc0202348:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020234a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020234c:	0017f713          	andi	a4,a5,1
ffffffffc0202350:	e709                	bnez	a4,ffffffffc020235a <get_page+0x26>
}
ffffffffc0202352:	60a2                	ld	ra,8(sp)
ffffffffc0202354:	6402                	ld	s0,0(sp)
ffffffffc0202356:	0141                	addi	sp,sp,16
ffffffffc0202358:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020235a:	078a                	slli	a5,a5,0x2
ffffffffc020235c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020235e:	000d1717          	auipc	a4,0xd1
ffffffffc0202362:	01273703          	ld	a4,18(a4) # ffffffffc02d3370 <npage>
ffffffffc0202366:	00e7ff63          	bgeu	a5,a4,ffffffffc0202384 <get_page+0x50>
ffffffffc020236a:	60a2                	ld	ra,8(sp)
ffffffffc020236c:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020236e:	fff80537          	lui	a0,0xfff80
ffffffffc0202372:	97aa                	add	a5,a5,a0
ffffffffc0202374:	079a                	slli	a5,a5,0x6
ffffffffc0202376:	000d1517          	auipc	a0,0xd1
ffffffffc020237a:	00253503          	ld	a0,2(a0) # ffffffffc02d3378 <pages>
ffffffffc020237e:	953e                	add	a0,a0,a5
ffffffffc0202380:	0141                	addi	sp,sp,16
ffffffffc0202382:	8082                	ret
ffffffffc0202384:	c99ff0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>

ffffffffc0202388 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202388:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020238a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020238e:	f486                	sd	ra,104(sp)
ffffffffc0202390:	f0a2                	sd	s0,96(sp)
ffffffffc0202392:	eca6                	sd	s1,88(sp)
ffffffffc0202394:	e8ca                	sd	s2,80(sp)
ffffffffc0202396:	e4ce                	sd	s3,72(sp)
ffffffffc0202398:	e0d2                	sd	s4,64(sp)
ffffffffc020239a:	fc56                	sd	s5,56(sp)
ffffffffc020239c:	f85a                	sd	s6,48(sp)
ffffffffc020239e:	f45e                	sd	s7,40(sp)
ffffffffc02023a0:	f062                	sd	s8,32(sp)
ffffffffc02023a2:	ec66                	sd	s9,24(sp)
ffffffffc02023a4:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023a6:	17d2                	slli	a5,a5,0x34
ffffffffc02023a8:	e3ed                	bnez	a5,ffffffffc020248a <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02023aa:	002007b7          	lui	a5,0x200
ffffffffc02023ae:	842e                	mv	s0,a1
ffffffffc02023b0:	0ef5ed63          	bltu	a1,a5,ffffffffc02024aa <unmap_range+0x122>
ffffffffc02023b4:	8932                	mv	s2,a2
ffffffffc02023b6:	0ec5fa63          	bgeu	a1,a2,ffffffffc02024aa <unmap_range+0x122>
ffffffffc02023ba:	4785                	li	a5,1
ffffffffc02023bc:	07fe                	slli	a5,a5,0x1f
ffffffffc02023be:	0ec7e663          	bltu	a5,a2,ffffffffc02024aa <unmap_range+0x122>
ffffffffc02023c2:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02023c4:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02023c6:	000d1c97          	auipc	s9,0xd1
ffffffffc02023ca:	faac8c93          	addi	s9,s9,-86 # ffffffffc02d3370 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02023ce:	000d1c17          	auipc	s8,0xd1
ffffffffc02023d2:	faac0c13          	addi	s8,s8,-86 # ffffffffc02d3378 <pages>
ffffffffc02023d6:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02023da:	000d1d17          	auipc	s10,0xd1
ffffffffc02023de:	fa6d0d13          	addi	s10,s10,-90 # ffffffffc02d3380 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02023e2:	00200b37          	lui	s6,0x200
ffffffffc02023e6:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02023ea:	4601                	li	a2,0
ffffffffc02023ec:	85a2                	mv	a1,s0
ffffffffc02023ee:	854e                	mv	a0,s3
ffffffffc02023f0:	d1dff0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc02023f4:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02023f6:	cd29                	beqz	a0,ffffffffc0202450 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc02023f8:	611c                	ld	a5,0(a0)
ffffffffc02023fa:	e395                	bnez	a5,ffffffffc020241e <unmap_range+0x96>
        start += PGSIZE;
ffffffffc02023fc:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02023fe:	ff2466e3          	bltu	s0,s2,ffffffffc02023ea <unmap_range+0x62>
}
ffffffffc0202402:	70a6                	ld	ra,104(sp)
ffffffffc0202404:	7406                	ld	s0,96(sp)
ffffffffc0202406:	64e6                	ld	s1,88(sp)
ffffffffc0202408:	6946                	ld	s2,80(sp)
ffffffffc020240a:	69a6                	ld	s3,72(sp)
ffffffffc020240c:	6a06                	ld	s4,64(sp)
ffffffffc020240e:	7ae2                	ld	s5,56(sp)
ffffffffc0202410:	7b42                	ld	s6,48(sp)
ffffffffc0202412:	7ba2                	ld	s7,40(sp)
ffffffffc0202414:	7c02                	ld	s8,32(sp)
ffffffffc0202416:	6ce2                	ld	s9,24(sp)
ffffffffc0202418:	6d42                	ld	s10,16(sp)
ffffffffc020241a:	6165                	addi	sp,sp,112
ffffffffc020241c:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc020241e:	0017f713          	andi	a4,a5,1
ffffffffc0202422:	df69                	beqz	a4,ffffffffc02023fc <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202424:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202428:	078a                	slli	a5,a5,0x2
ffffffffc020242a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020242c:	08e7ff63          	bgeu	a5,a4,ffffffffc02024ca <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202430:	000c3503          	ld	a0,0(s8)
ffffffffc0202434:	97de                	add	a5,a5,s7
ffffffffc0202436:	079a                	slli	a5,a5,0x6
ffffffffc0202438:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020243a:	411c                	lw	a5,0(a0)
ffffffffc020243c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202440:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202442:	cf11                	beqz	a4,ffffffffc020245e <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202444:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202448:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020244c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020244e:	bf45                	j	ffffffffc02023fe <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202450:	945a                	add	s0,s0,s6
ffffffffc0202452:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0202456:	d455                	beqz	s0,ffffffffc0202402 <unmap_range+0x7a>
ffffffffc0202458:	f92469e3          	bltu	s0,s2,ffffffffc02023ea <unmap_range+0x62>
ffffffffc020245c:	b75d                	j	ffffffffc0202402 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020245e:	100027f3          	csrr	a5,sstatus
ffffffffc0202462:	8b89                	andi	a5,a5,2
ffffffffc0202464:	e799                	bnez	a5,ffffffffc0202472 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc0202466:	000d3783          	ld	a5,0(s10)
ffffffffc020246a:	4585                	li	a1,1
ffffffffc020246c:	739c                	ld	a5,32(a5)
ffffffffc020246e:	9782                	jalr	a5
    if (flag)
ffffffffc0202470:	bfd1                	j	ffffffffc0202444 <unmap_range+0xbc>
ffffffffc0202472:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202474:	d40fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202478:	000d3783          	ld	a5,0(s10)
ffffffffc020247c:	6522                	ld	a0,8(sp)
ffffffffc020247e:	4585                	li	a1,1
ffffffffc0202480:	739c                	ld	a5,32(a5)
ffffffffc0202482:	9782                	jalr	a5
        intr_enable();
ffffffffc0202484:	d2afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202488:	bf75                	j	ffffffffc0202444 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020248a:	00004697          	auipc	a3,0x4
ffffffffc020248e:	42668693          	addi	a3,a3,1062 # ffffffffc02068b0 <default_pmm_manager+0xe0>
ffffffffc0202492:	00004617          	auipc	a2,0x4
ffffffffc0202496:	f8e60613          	addi	a2,a2,-114 # ffffffffc0206420 <commands+0x8b0>
ffffffffc020249a:	12000593          	li	a1,288
ffffffffc020249e:	00004517          	auipc	a0,0x4
ffffffffc02024a2:	40250513          	addi	a0,a0,1026 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02024a6:	fe9fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02024aa:	00004697          	auipc	a3,0x4
ffffffffc02024ae:	43668693          	addi	a3,a3,1078 # ffffffffc02068e0 <default_pmm_manager+0x110>
ffffffffc02024b2:	00004617          	auipc	a2,0x4
ffffffffc02024b6:	f6e60613          	addi	a2,a2,-146 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02024ba:	12100593          	li	a1,289
ffffffffc02024be:	00004517          	auipc	a0,0x4
ffffffffc02024c2:	3e250513          	addi	a0,a0,994 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02024c6:	fc9fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02024ca:	b53ff0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>

ffffffffc02024ce <exit_range>:
{
ffffffffc02024ce:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024d0:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02024d4:	fc86                	sd	ra,120(sp)
ffffffffc02024d6:	f8a2                	sd	s0,112(sp)
ffffffffc02024d8:	f4a6                	sd	s1,104(sp)
ffffffffc02024da:	f0ca                	sd	s2,96(sp)
ffffffffc02024dc:	ecce                	sd	s3,88(sp)
ffffffffc02024de:	e8d2                	sd	s4,80(sp)
ffffffffc02024e0:	e4d6                	sd	s5,72(sp)
ffffffffc02024e2:	e0da                	sd	s6,64(sp)
ffffffffc02024e4:	fc5e                	sd	s7,56(sp)
ffffffffc02024e6:	f862                	sd	s8,48(sp)
ffffffffc02024e8:	f466                	sd	s9,40(sp)
ffffffffc02024ea:	f06a                	sd	s10,32(sp)
ffffffffc02024ec:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024ee:	17d2                	slli	a5,a5,0x34
ffffffffc02024f0:	20079a63          	bnez	a5,ffffffffc0202704 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc02024f4:	002007b7          	lui	a5,0x200
ffffffffc02024f8:	24f5e463          	bltu	a1,a5,ffffffffc0202740 <exit_range+0x272>
ffffffffc02024fc:	8ab2                	mv	s5,a2
ffffffffc02024fe:	24c5f163          	bgeu	a1,a2,ffffffffc0202740 <exit_range+0x272>
ffffffffc0202502:	4785                	li	a5,1
ffffffffc0202504:	07fe                	slli	a5,a5,0x1f
ffffffffc0202506:	22c7ed63          	bltu	a5,a2,ffffffffc0202740 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020250a:	c00009b7          	lui	s3,0xc0000
ffffffffc020250e:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202512:	ffe00937          	lui	s2,0xffe00
ffffffffc0202516:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020251a:	5cfd                	li	s9,-1
ffffffffc020251c:	8c2a                	mv	s8,a0
ffffffffc020251e:	0125f933          	and	s2,a1,s2
ffffffffc0202522:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202524:	000d1d17          	auipc	s10,0xd1
ffffffffc0202528:	e4cd0d13          	addi	s10,s10,-436 # ffffffffc02d3370 <npage>
    return KADDR(page2pa(page));
ffffffffc020252c:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202530:	000d1717          	auipc	a4,0xd1
ffffffffc0202534:	e4870713          	addi	a4,a4,-440 # ffffffffc02d3378 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202538:	000d1d97          	auipc	s11,0xd1
ffffffffc020253c:	e48d8d93          	addi	s11,s11,-440 # ffffffffc02d3380 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202540:	c0000437          	lui	s0,0xc0000
ffffffffc0202544:	944e                	add	s0,s0,s3
ffffffffc0202546:	8079                	srli	s0,s0,0x1e
ffffffffc0202548:	1ff47413          	andi	s0,s0,511
ffffffffc020254c:	040e                	slli	s0,s0,0x3
ffffffffc020254e:	9462                	add	s0,s0,s8
ffffffffc0202550:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ec8>
        if (pde1 & PTE_V)
ffffffffc0202554:	001a7793          	andi	a5,s4,1
ffffffffc0202558:	eb99                	bnez	a5,ffffffffc020256e <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020255a:	12098463          	beqz	s3,ffffffffc0202682 <exit_range+0x1b4>
ffffffffc020255e:	400007b7          	lui	a5,0x40000
ffffffffc0202562:	97ce                	add	a5,a5,s3
ffffffffc0202564:	894e                	mv	s2,s3
ffffffffc0202566:	1159fe63          	bgeu	s3,s5,ffffffffc0202682 <exit_range+0x1b4>
ffffffffc020256a:	89be                	mv	s3,a5
ffffffffc020256c:	bfd1                	j	ffffffffc0202540 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc020256e:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202572:	0a0a                	slli	s4,s4,0x2
ffffffffc0202574:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202578:	1cfa7263          	bgeu	s4,a5,ffffffffc020273c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020257c:	fff80637          	lui	a2,0xfff80
ffffffffc0202580:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202582:	000806b7          	lui	a3,0x80
ffffffffc0202586:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202588:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020258c:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020258e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202590:	18f5fa63          	bgeu	a1,a5,ffffffffc0202724 <exit_range+0x256>
ffffffffc0202594:	000d1817          	auipc	a6,0xd1
ffffffffc0202598:	df480813          	addi	a6,a6,-524 # ffffffffc02d3388 <va_pa_offset>
ffffffffc020259c:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02025a0:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02025a2:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02025a6:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02025a8:	00080337          	lui	t1,0x80
ffffffffc02025ac:	6885                	lui	a7,0x1
ffffffffc02025ae:	a819                	j	ffffffffc02025c4 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02025b0:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02025b2:	002007b7          	lui	a5,0x200
ffffffffc02025b6:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02025b8:	08090c63          	beqz	s2,ffffffffc0202650 <exit_range+0x182>
ffffffffc02025bc:	09397a63          	bgeu	s2,s3,ffffffffc0202650 <exit_range+0x182>
ffffffffc02025c0:	0f597063          	bgeu	s2,s5,ffffffffc02026a0 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02025c4:	01595493          	srli	s1,s2,0x15
ffffffffc02025c8:	1ff4f493          	andi	s1,s1,511
ffffffffc02025cc:	048e                	slli	s1,s1,0x3
ffffffffc02025ce:	94da                	add	s1,s1,s6
ffffffffc02025d0:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02025d2:	0017f693          	andi	a3,a5,1
ffffffffc02025d6:	dee9                	beqz	a3,ffffffffc02025b0 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02025d8:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02025dc:	078a                	slli	a5,a5,0x2
ffffffffc02025de:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025e0:	14b7fe63          	bgeu	a5,a1,ffffffffc020273c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02025e4:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02025e6:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc02025ea:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02025ee:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02025f2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02025f4:	12bef863          	bgeu	t4,a1,ffffffffc0202724 <exit_range+0x256>
ffffffffc02025f8:	00083783          	ld	a5,0(a6)
ffffffffc02025fc:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02025fe:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202602:	629c                	ld	a5,0(a3)
ffffffffc0202604:	8b85                	andi	a5,a5,1
ffffffffc0202606:	f7d5                	bnez	a5,ffffffffc02025b2 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202608:	06a1                	addi	a3,a3,8
ffffffffc020260a:	fed59ce3          	bne	a1,a3,ffffffffc0202602 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc020260e:	631c                	ld	a5,0(a4)
ffffffffc0202610:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202612:	100027f3          	csrr	a5,sstatus
ffffffffc0202616:	8b89                	andi	a5,a5,2
ffffffffc0202618:	e7d9                	bnez	a5,ffffffffc02026a6 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020261a:	000db783          	ld	a5,0(s11)
ffffffffc020261e:	4585                	li	a1,1
ffffffffc0202620:	e032                	sd	a2,0(sp)
ffffffffc0202622:	739c                	ld	a5,32(a5)
ffffffffc0202624:	9782                	jalr	a5
    if (flag)
ffffffffc0202626:	6602                	ld	a2,0(sp)
ffffffffc0202628:	000d1817          	auipc	a6,0xd1
ffffffffc020262c:	d6080813          	addi	a6,a6,-672 # ffffffffc02d3388 <va_pa_offset>
ffffffffc0202630:	fff80e37          	lui	t3,0xfff80
ffffffffc0202634:	00080337          	lui	t1,0x80
ffffffffc0202638:	6885                	lui	a7,0x1
ffffffffc020263a:	000d1717          	auipc	a4,0xd1
ffffffffc020263e:	d3e70713          	addi	a4,a4,-706 # ffffffffc02d3378 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202642:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202646:	002007b7          	lui	a5,0x200
ffffffffc020264a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020264c:	f60918e3          	bnez	s2,ffffffffc02025bc <exit_range+0xee>
            if (free_pd0)
ffffffffc0202650:	f00b85e3          	beqz	s7,ffffffffc020255a <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202654:	000d3783          	ld	a5,0(s10)
ffffffffc0202658:	0efa7263          	bgeu	s4,a5,ffffffffc020273c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020265c:	6308                	ld	a0,0(a4)
ffffffffc020265e:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202660:	100027f3          	csrr	a5,sstatus
ffffffffc0202664:	8b89                	andi	a5,a5,2
ffffffffc0202666:	efad                	bnez	a5,ffffffffc02026e0 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202668:	000db783          	ld	a5,0(s11)
ffffffffc020266c:	4585                	li	a1,1
ffffffffc020266e:	739c                	ld	a5,32(a5)
ffffffffc0202670:	9782                	jalr	a5
ffffffffc0202672:	000d1717          	auipc	a4,0xd1
ffffffffc0202676:	d0670713          	addi	a4,a4,-762 # ffffffffc02d3378 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020267a:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc020267e:	ee0990e3          	bnez	s3,ffffffffc020255e <exit_range+0x90>
}
ffffffffc0202682:	70e6                	ld	ra,120(sp)
ffffffffc0202684:	7446                	ld	s0,112(sp)
ffffffffc0202686:	74a6                	ld	s1,104(sp)
ffffffffc0202688:	7906                	ld	s2,96(sp)
ffffffffc020268a:	69e6                	ld	s3,88(sp)
ffffffffc020268c:	6a46                	ld	s4,80(sp)
ffffffffc020268e:	6aa6                	ld	s5,72(sp)
ffffffffc0202690:	6b06                	ld	s6,64(sp)
ffffffffc0202692:	7be2                	ld	s7,56(sp)
ffffffffc0202694:	7c42                	ld	s8,48(sp)
ffffffffc0202696:	7ca2                	ld	s9,40(sp)
ffffffffc0202698:	7d02                	ld	s10,32(sp)
ffffffffc020269a:	6de2                	ld	s11,24(sp)
ffffffffc020269c:	6109                	addi	sp,sp,128
ffffffffc020269e:	8082                	ret
            if (free_pd0)
ffffffffc02026a0:	ea0b8fe3          	beqz	s7,ffffffffc020255e <exit_range+0x90>
ffffffffc02026a4:	bf45                	j	ffffffffc0202654 <exit_range+0x186>
ffffffffc02026a6:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02026a8:	e42a                	sd	a0,8(sp)
ffffffffc02026aa:	b0afe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02026ae:	000db783          	ld	a5,0(s11)
ffffffffc02026b2:	6522                	ld	a0,8(sp)
ffffffffc02026b4:	4585                	li	a1,1
ffffffffc02026b6:	739c                	ld	a5,32(a5)
ffffffffc02026b8:	9782                	jalr	a5
        intr_enable();
ffffffffc02026ba:	af4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02026be:	6602                	ld	a2,0(sp)
ffffffffc02026c0:	000d1717          	auipc	a4,0xd1
ffffffffc02026c4:	cb870713          	addi	a4,a4,-840 # ffffffffc02d3378 <pages>
ffffffffc02026c8:	6885                	lui	a7,0x1
ffffffffc02026ca:	00080337          	lui	t1,0x80
ffffffffc02026ce:	fff80e37          	lui	t3,0xfff80
ffffffffc02026d2:	000d1817          	auipc	a6,0xd1
ffffffffc02026d6:	cb680813          	addi	a6,a6,-842 # ffffffffc02d3388 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02026da:	0004b023          	sd	zero,0(s1)
ffffffffc02026de:	b7a5                	j	ffffffffc0202646 <exit_range+0x178>
ffffffffc02026e0:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02026e2:	ad2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02026e6:	000db783          	ld	a5,0(s11)
ffffffffc02026ea:	6502                	ld	a0,0(sp)
ffffffffc02026ec:	4585                	li	a1,1
ffffffffc02026ee:	739c                	ld	a5,32(a5)
ffffffffc02026f0:	9782                	jalr	a5
        intr_enable();
ffffffffc02026f2:	abcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02026f6:	000d1717          	auipc	a4,0xd1
ffffffffc02026fa:	c8270713          	addi	a4,a4,-894 # ffffffffc02d3378 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02026fe:	00043023          	sd	zero,0(s0)
ffffffffc0202702:	bfb5                	j	ffffffffc020267e <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202704:	00004697          	auipc	a3,0x4
ffffffffc0202708:	1ac68693          	addi	a3,a3,428 # ffffffffc02068b0 <default_pmm_manager+0xe0>
ffffffffc020270c:	00004617          	auipc	a2,0x4
ffffffffc0202710:	d1460613          	addi	a2,a2,-748 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0202714:	13500593          	li	a1,309
ffffffffc0202718:	00004517          	auipc	a0,0x4
ffffffffc020271c:	18850513          	addi	a0,a0,392 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0202720:	d6ffd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202724:	00004617          	auipc	a2,0x4
ffffffffc0202728:	c6c60613          	addi	a2,a2,-916 # ffffffffc0206390 <commands+0x820>
ffffffffc020272c:	07100593          	li	a1,113
ffffffffc0202730:	00004517          	auipc	a0,0x4
ffffffffc0202734:	c1850513          	addi	a0,a0,-1000 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0202738:	d57fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020273c:	8e1ff0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202740:	00004697          	auipc	a3,0x4
ffffffffc0202744:	1a068693          	addi	a3,a3,416 # ffffffffc02068e0 <default_pmm_manager+0x110>
ffffffffc0202748:	00004617          	auipc	a2,0x4
ffffffffc020274c:	cd860613          	addi	a2,a2,-808 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0202750:	13600593          	li	a1,310
ffffffffc0202754:	00004517          	auipc	a0,0x4
ffffffffc0202758:	14c50513          	addi	a0,a0,332 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020275c:	d33fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202760 <page_remove>:
{
ffffffffc0202760:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202762:	4601                	li	a2,0
{
ffffffffc0202764:	ec26                	sd	s1,24(sp)
ffffffffc0202766:	f406                	sd	ra,40(sp)
ffffffffc0202768:	f022                	sd	s0,32(sp)
ffffffffc020276a:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020276c:	9a1ff0ef          	jal	ra,ffffffffc020210c <get_pte>
    if (ptep != NULL)
ffffffffc0202770:	c511                	beqz	a0,ffffffffc020277c <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202772:	611c                	ld	a5,0(a0)
ffffffffc0202774:	842a                	mv	s0,a0
ffffffffc0202776:	0017f713          	andi	a4,a5,1
ffffffffc020277a:	e711                	bnez	a4,ffffffffc0202786 <page_remove+0x26>
}
ffffffffc020277c:	70a2                	ld	ra,40(sp)
ffffffffc020277e:	7402                	ld	s0,32(sp)
ffffffffc0202780:	64e2                	ld	s1,24(sp)
ffffffffc0202782:	6145                	addi	sp,sp,48
ffffffffc0202784:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202786:	078a                	slli	a5,a5,0x2
ffffffffc0202788:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020278a:	000d1717          	auipc	a4,0xd1
ffffffffc020278e:	be673703          	ld	a4,-1050(a4) # ffffffffc02d3370 <npage>
ffffffffc0202792:	06e7f363          	bgeu	a5,a4,ffffffffc02027f8 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202796:	fff80537          	lui	a0,0xfff80
ffffffffc020279a:	97aa                	add	a5,a5,a0
ffffffffc020279c:	079a                	slli	a5,a5,0x6
ffffffffc020279e:	000d1517          	auipc	a0,0xd1
ffffffffc02027a2:	bda53503          	ld	a0,-1062(a0) # ffffffffc02d3378 <pages>
ffffffffc02027a6:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02027a8:	411c                	lw	a5,0(a0)
ffffffffc02027aa:	fff7871b          	addiw	a4,a5,-1
ffffffffc02027ae:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02027b0:	cb11                	beqz	a4,ffffffffc02027c4 <page_remove+0x64>
        *ptep = 0;
ffffffffc02027b2:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027b6:	12048073          	sfence.vma	s1
}
ffffffffc02027ba:	70a2                	ld	ra,40(sp)
ffffffffc02027bc:	7402                	ld	s0,32(sp)
ffffffffc02027be:	64e2                	ld	s1,24(sp)
ffffffffc02027c0:	6145                	addi	sp,sp,48
ffffffffc02027c2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02027c4:	100027f3          	csrr	a5,sstatus
ffffffffc02027c8:	8b89                	andi	a5,a5,2
ffffffffc02027ca:	eb89                	bnez	a5,ffffffffc02027dc <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02027cc:	000d1797          	auipc	a5,0xd1
ffffffffc02027d0:	bb47b783          	ld	a5,-1100(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02027d4:	739c                	ld	a5,32(a5)
ffffffffc02027d6:	4585                	li	a1,1
ffffffffc02027d8:	9782                	jalr	a5
    if (flag)
ffffffffc02027da:	bfe1                	j	ffffffffc02027b2 <page_remove+0x52>
        intr_disable();
ffffffffc02027dc:	e42a                	sd	a0,8(sp)
ffffffffc02027de:	9d6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02027e2:	000d1797          	auipc	a5,0xd1
ffffffffc02027e6:	b9e7b783          	ld	a5,-1122(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02027ea:	739c                	ld	a5,32(a5)
ffffffffc02027ec:	6522                	ld	a0,8(sp)
ffffffffc02027ee:	4585                	li	a1,1
ffffffffc02027f0:	9782                	jalr	a5
        intr_enable();
ffffffffc02027f2:	9bcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02027f6:	bf75                	j	ffffffffc02027b2 <page_remove+0x52>
ffffffffc02027f8:	825ff0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>

ffffffffc02027fc <page_insert>:
{
ffffffffc02027fc:	7139                	addi	sp,sp,-64
ffffffffc02027fe:	e852                	sd	s4,16(sp)
ffffffffc0202800:	8a32                	mv	s4,a2
ffffffffc0202802:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202804:	4605                	li	a2,1
{
ffffffffc0202806:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202808:	85d2                	mv	a1,s4
{
ffffffffc020280a:	f426                	sd	s1,40(sp)
ffffffffc020280c:	fc06                	sd	ra,56(sp)
ffffffffc020280e:	f04a                	sd	s2,32(sp)
ffffffffc0202810:	ec4e                	sd	s3,24(sp)
ffffffffc0202812:	e456                	sd	s5,8(sp)
ffffffffc0202814:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202816:	8f7ff0ef          	jal	ra,ffffffffc020210c <get_pte>
    if (ptep == NULL)
ffffffffc020281a:	c961                	beqz	a0,ffffffffc02028ea <page_insert+0xee>
    page->ref += 1;
ffffffffc020281c:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc020281e:	611c                	ld	a5,0(a0)
ffffffffc0202820:	89aa                	mv	s3,a0
ffffffffc0202822:	0016871b          	addiw	a4,a3,1
ffffffffc0202826:	c018                	sw	a4,0(s0)
ffffffffc0202828:	0017f713          	andi	a4,a5,1
ffffffffc020282c:	ef05                	bnez	a4,ffffffffc0202864 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020282e:	000d1717          	auipc	a4,0xd1
ffffffffc0202832:	b4a73703          	ld	a4,-1206(a4) # ffffffffc02d3378 <pages>
ffffffffc0202836:	8c19                	sub	s0,s0,a4
ffffffffc0202838:	000807b7          	lui	a5,0x80
ffffffffc020283c:	8419                	srai	s0,s0,0x6
ffffffffc020283e:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202840:	042a                	slli	s0,s0,0xa
ffffffffc0202842:	8cc1                	or	s1,s1,s0
ffffffffc0202844:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202848:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ec8>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020284c:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202850:	4501                	li	a0,0
}
ffffffffc0202852:	70e2                	ld	ra,56(sp)
ffffffffc0202854:	7442                	ld	s0,48(sp)
ffffffffc0202856:	74a2                	ld	s1,40(sp)
ffffffffc0202858:	7902                	ld	s2,32(sp)
ffffffffc020285a:	69e2                	ld	s3,24(sp)
ffffffffc020285c:	6a42                	ld	s4,16(sp)
ffffffffc020285e:	6aa2                	ld	s5,8(sp)
ffffffffc0202860:	6121                	addi	sp,sp,64
ffffffffc0202862:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202864:	078a                	slli	a5,a5,0x2
ffffffffc0202866:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202868:	000d1717          	auipc	a4,0xd1
ffffffffc020286c:	b0873703          	ld	a4,-1272(a4) # ffffffffc02d3370 <npage>
ffffffffc0202870:	06e7ff63          	bgeu	a5,a4,ffffffffc02028ee <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202874:	000d1a97          	auipc	s5,0xd1
ffffffffc0202878:	b04a8a93          	addi	s5,s5,-1276 # ffffffffc02d3378 <pages>
ffffffffc020287c:	000ab703          	ld	a4,0(s5)
ffffffffc0202880:	fff80937          	lui	s2,0xfff80
ffffffffc0202884:	993e                	add	s2,s2,a5
ffffffffc0202886:	091a                	slli	s2,s2,0x6
ffffffffc0202888:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020288a:	01240c63          	beq	s0,s2,ffffffffc02028a2 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020288e:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcacc54>
ffffffffc0202892:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202896:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020289a:	c691                	beqz	a3,ffffffffc02028a6 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020289c:	120a0073          	sfence.vma	s4
}
ffffffffc02028a0:	bf59                	j	ffffffffc0202836 <page_insert+0x3a>
ffffffffc02028a2:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02028a4:	bf49                	j	ffffffffc0202836 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028a6:	100027f3          	csrr	a5,sstatus
ffffffffc02028aa:	8b89                	andi	a5,a5,2
ffffffffc02028ac:	ef91                	bnez	a5,ffffffffc02028c8 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02028ae:	000d1797          	auipc	a5,0xd1
ffffffffc02028b2:	ad27b783          	ld	a5,-1326(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02028b6:	739c                	ld	a5,32(a5)
ffffffffc02028b8:	4585                	li	a1,1
ffffffffc02028ba:	854a                	mv	a0,s2
ffffffffc02028bc:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02028be:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028c2:	120a0073          	sfence.vma	s4
ffffffffc02028c6:	bf85                	j	ffffffffc0202836 <page_insert+0x3a>
        intr_disable();
ffffffffc02028c8:	8ecfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028cc:	000d1797          	auipc	a5,0xd1
ffffffffc02028d0:	ab47b783          	ld	a5,-1356(a5) # ffffffffc02d3380 <pmm_manager>
ffffffffc02028d4:	739c                	ld	a5,32(a5)
ffffffffc02028d6:	4585                	li	a1,1
ffffffffc02028d8:	854a                	mv	a0,s2
ffffffffc02028da:	9782                	jalr	a5
        intr_enable();
ffffffffc02028dc:	8d2fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02028e0:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028e4:	120a0073          	sfence.vma	s4
ffffffffc02028e8:	b7b9                	j	ffffffffc0202836 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02028ea:	5571                	li	a0,-4
ffffffffc02028ec:	b79d                	j	ffffffffc0202852 <page_insert+0x56>
ffffffffc02028ee:	f2eff0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>

ffffffffc02028f2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02028f2:	00004797          	auipc	a5,0x4
ffffffffc02028f6:	ede78793          	addi	a5,a5,-290 # ffffffffc02067d0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02028fa:	638c                	ld	a1,0(a5)
{
ffffffffc02028fc:	7159                	addi	sp,sp,-112
ffffffffc02028fe:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202900:	00004517          	auipc	a0,0x4
ffffffffc0202904:	ff850513          	addi	a0,a0,-8 # ffffffffc02068f8 <default_pmm_manager+0x128>
    pmm_manager = &default_pmm_manager;
ffffffffc0202908:	000d1b17          	auipc	s6,0xd1
ffffffffc020290c:	a78b0b13          	addi	s6,s6,-1416 # ffffffffc02d3380 <pmm_manager>
{
ffffffffc0202910:	f486                	sd	ra,104(sp)
ffffffffc0202912:	e8ca                	sd	s2,80(sp)
ffffffffc0202914:	e4ce                	sd	s3,72(sp)
ffffffffc0202916:	f0a2                	sd	s0,96(sp)
ffffffffc0202918:	eca6                	sd	s1,88(sp)
ffffffffc020291a:	e0d2                	sd	s4,64(sp)
ffffffffc020291c:	fc56                	sd	s5,56(sp)
ffffffffc020291e:	f45e                	sd	s7,40(sp)
ffffffffc0202920:	f062                	sd	s8,32(sp)
ffffffffc0202922:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202924:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202928:	86dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc020292c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202930:	000d1997          	auipc	s3,0xd1
ffffffffc0202934:	a5898993          	addi	s3,s3,-1448 # ffffffffc02d3388 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202938:	679c                	ld	a5,8(a5)
ffffffffc020293a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020293c:	57f5                	li	a5,-3
ffffffffc020293e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202940:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202944:	856fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202948:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020294a:	85afe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc020294e:	200505e3          	beqz	a0,ffffffffc0203358 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202952:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202954:	00004517          	auipc	a0,0x4
ffffffffc0202958:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206930 <default_pmm_manager+0x160>
ffffffffc020295c:	839fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202960:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202964:	fff40693          	addi	a3,s0,-1
ffffffffc0202968:	864a                	mv	a2,s2
ffffffffc020296a:	85a6                	mv	a1,s1
ffffffffc020296c:	00004517          	auipc	a0,0x4
ffffffffc0202970:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206948 <default_pmm_manager+0x178>
ffffffffc0202974:	821fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202978:	c8000737          	lui	a4,0xc8000
ffffffffc020297c:	87a2                	mv	a5,s0
ffffffffc020297e:	54876163          	bltu	a4,s0,ffffffffc0202ec0 <pmm_init+0x5ce>
ffffffffc0202982:	757d                	lui	a0,0xfffff
ffffffffc0202984:	000d2617          	auipc	a2,0xd2
ffffffffc0202988:	a2760613          	addi	a2,a2,-1497 # ffffffffc02d43ab <end+0xfff>
ffffffffc020298c:	8e69                	and	a2,a2,a0
ffffffffc020298e:	000d1497          	auipc	s1,0xd1
ffffffffc0202992:	9e248493          	addi	s1,s1,-1566 # ffffffffc02d3370 <npage>
ffffffffc0202996:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020299a:	000d1b97          	auipc	s7,0xd1
ffffffffc020299e:	9deb8b93          	addi	s7,s7,-1570 # ffffffffc02d3378 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02029a2:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02029a4:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029a8:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02029ac:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029ae:	02f50863          	beq	a0,a5,ffffffffc02029de <pmm_init+0xec>
ffffffffc02029b2:	4781                	li	a5,0
ffffffffc02029b4:	4585                	li	a1,1
ffffffffc02029b6:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02029ba:	00679513          	slli	a0,a5,0x6
ffffffffc02029be:	9532                	add	a0,a0,a2
ffffffffc02029c0:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd2bc5c>
ffffffffc02029c4:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029c8:	6088                	ld	a0,0(s1)
ffffffffc02029ca:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc02029cc:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029d0:	00d50733          	add	a4,a0,a3
ffffffffc02029d4:	fee7e3e3          	bltu	a5,a4,ffffffffc02029ba <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02029d8:	071a                	slli	a4,a4,0x6
ffffffffc02029da:	00e606b3          	add	a3,a2,a4
ffffffffc02029de:	c02007b7          	lui	a5,0xc0200
ffffffffc02029e2:	2ef6ece3          	bltu	a3,a5,ffffffffc02034da <pmm_init+0xbe8>
ffffffffc02029e6:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02029ea:	77fd                	lui	a5,0xfffff
ffffffffc02029ec:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02029ee:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02029f0:	5086eb63          	bltu	a3,s0,ffffffffc0202f06 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02029f4:	00004517          	auipc	a0,0x4
ffffffffc02029f8:	f7c50513          	addi	a0,a0,-132 # ffffffffc0206970 <default_pmm_manager+0x1a0>
ffffffffc02029fc:	f98fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202a00:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a04:	000d1917          	auipc	s2,0xd1
ffffffffc0202a08:	96490913          	addi	s2,s2,-1692 # ffffffffc02d3368 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202a0c:	7b9c                	ld	a5,48(a5)
ffffffffc0202a0e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202a10:	00004517          	auipc	a0,0x4
ffffffffc0202a14:	f7850513          	addi	a0,a0,-136 # ffffffffc0206988 <default_pmm_manager+0x1b8>
ffffffffc0202a18:	f7cfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a1c:	00007697          	auipc	a3,0x7
ffffffffc0202a20:	5e468693          	addi	a3,a3,1508 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202a24:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202a28:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a2c:	28f6ebe3          	bltu	a3,a5,ffffffffc02034c2 <pmm_init+0xbd0>
ffffffffc0202a30:	0009b783          	ld	a5,0(s3)
ffffffffc0202a34:	8e9d                	sub	a3,a3,a5
ffffffffc0202a36:	000d1797          	auipc	a5,0xd1
ffffffffc0202a3a:	92d7b523          	sd	a3,-1750(a5) # ffffffffc02d3360 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202a3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202a42:	8b89                	andi	a5,a5,2
ffffffffc0202a44:	4a079763          	bnez	a5,ffffffffc0202ef2 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a48:	000b3783          	ld	a5,0(s6)
ffffffffc0202a4c:	779c                	ld	a5,40(a5)
ffffffffc0202a4e:	9782                	jalr	a5
ffffffffc0202a50:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202a52:	6098                	ld	a4,0(s1)
ffffffffc0202a54:	c80007b7          	lui	a5,0xc8000
ffffffffc0202a58:	83b1                	srli	a5,a5,0xc
ffffffffc0202a5a:	66e7e363          	bltu	a5,a4,ffffffffc02030c0 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202a5e:	00093503          	ld	a0,0(s2)
ffffffffc0202a62:	62050f63          	beqz	a0,ffffffffc02030a0 <pmm_init+0x7ae>
ffffffffc0202a66:	03451793          	slli	a5,a0,0x34
ffffffffc0202a6a:	62079b63          	bnez	a5,ffffffffc02030a0 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202a6e:	4601                	li	a2,0
ffffffffc0202a70:	4581                	li	a1,0
ffffffffc0202a72:	8c3ff0ef          	jal	ra,ffffffffc0202334 <get_page>
ffffffffc0202a76:	60051563          	bnez	a0,ffffffffc0203080 <pmm_init+0x78e>
ffffffffc0202a7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a7e:	8b89                	andi	a5,a5,2
ffffffffc0202a80:	44079e63          	bnez	a5,ffffffffc0202edc <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a84:	000b3783          	ld	a5,0(s6)
ffffffffc0202a88:	4505                	li	a0,1
ffffffffc0202a8a:	6f9c                	ld	a5,24(a5)
ffffffffc0202a8c:	9782                	jalr	a5
ffffffffc0202a8e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202a90:	00093503          	ld	a0,0(s2)
ffffffffc0202a94:	4681                	li	a3,0
ffffffffc0202a96:	4601                	li	a2,0
ffffffffc0202a98:	85d2                	mv	a1,s4
ffffffffc0202a9a:	d63ff0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc0202a9e:	26051ae3          	bnez	a0,ffffffffc0203512 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202aa2:	00093503          	ld	a0,0(s2)
ffffffffc0202aa6:	4601                	li	a2,0
ffffffffc0202aa8:	4581                	li	a1,0
ffffffffc0202aaa:	e62ff0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc0202aae:	240502e3          	beqz	a0,ffffffffc02034f2 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202ab2:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202ab4:	0017f713          	andi	a4,a5,1
ffffffffc0202ab8:	5a070263          	beqz	a4,ffffffffc020305c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202abc:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202abe:	078a                	slli	a5,a5,0x2
ffffffffc0202ac0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ac2:	58e7fb63          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac6:	000bb683          	ld	a3,0(s7)
ffffffffc0202aca:	fff80637          	lui	a2,0xfff80
ffffffffc0202ace:	97b2                	add	a5,a5,a2
ffffffffc0202ad0:	079a                	slli	a5,a5,0x6
ffffffffc0202ad2:	97b6                	add	a5,a5,a3
ffffffffc0202ad4:	14fa17e3          	bne	s4,a5,ffffffffc0203422 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202ad8:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc0202adc:	4785                	li	a5,1
ffffffffc0202ade:	12f692e3          	bne	a3,a5,ffffffffc0203402 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202ae2:	00093503          	ld	a0,0(s2)
ffffffffc0202ae6:	77fd                	lui	a5,0xfffff
ffffffffc0202ae8:	6114                	ld	a3,0(a0)
ffffffffc0202aea:	068a                	slli	a3,a3,0x2
ffffffffc0202aec:	8efd                	and	a3,a3,a5
ffffffffc0202aee:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202af2:	0ee67ce3          	bgeu	a2,a4,ffffffffc02033ea <pmm_init+0xaf8>
ffffffffc0202af6:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202afa:	96e2                	add	a3,a3,s8
ffffffffc0202afc:	0006ba83          	ld	s5,0(a3)
ffffffffc0202b00:	0a8a                	slli	s5,s5,0x2
ffffffffc0202b02:	00fafab3          	and	s5,s5,a5
ffffffffc0202b06:	00cad793          	srli	a5,s5,0xc
ffffffffc0202b0a:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02033d0 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b0e:	4601                	li	a2,0
ffffffffc0202b10:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b12:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b14:	df8ff0ef          	jal	ra,ffffffffc020210c <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b18:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b1a:	55551363          	bne	a0,s5,ffffffffc0203060 <pmm_init+0x76e>
ffffffffc0202b1e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b22:	8b89                	andi	a5,a5,2
ffffffffc0202b24:	3a079163          	bnez	a5,ffffffffc0202ec6 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b28:	000b3783          	ld	a5,0(s6)
ffffffffc0202b2c:	4505                	li	a0,1
ffffffffc0202b2e:	6f9c                	ld	a5,24(a5)
ffffffffc0202b30:	9782                	jalr	a5
ffffffffc0202b32:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202b34:	00093503          	ld	a0,0(s2)
ffffffffc0202b38:	46d1                	li	a3,20
ffffffffc0202b3a:	6605                	lui	a2,0x1
ffffffffc0202b3c:	85e2                	mv	a1,s8
ffffffffc0202b3e:	cbfff0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc0202b42:	060517e3          	bnez	a0,ffffffffc02033b0 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b46:	00093503          	ld	a0,0(s2)
ffffffffc0202b4a:	4601                	li	a2,0
ffffffffc0202b4c:	6585                	lui	a1,0x1
ffffffffc0202b4e:	dbeff0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc0202b52:	02050fe3          	beqz	a0,ffffffffc0203390 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202b56:	611c                	ld	a5,0(a0)
ffffffffc0202b58:	0107f713          	andi	a4,a5,16
ffffffffc0202b5c:	7c070e63          	beqz	a4,ffffffffc0203338 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202b60:	8b91                	andi	a5,a5,4
ffffffffc0202b62:	7a078b63          	beqz	a5,ffffffffc0203318 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b66:	00093503          	ld	a0,0(s2)
ffffffffc0202b6a:	611c                	ld	a5,0(a0)
ffffffffc0202b6c:	8bc1                	andi	a5,a5,16
ffffffffc0202b6e:	78078563          	beqz	a5,ffffffffc02032f8 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202b72:	000c2703          	lw	a4,0(s8)
ffffffffc0202b76:	4785                	li	a5,1
ffffffffc0202b78:	76f71063          	bne	a4,a5,ffffffffc02032d8 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202b7c:	4681                	li	a3,0
ffffffffc0202b7e:	6605                	lui	a2,0x1
ffffffffc0202b80:	85d2                	mv	a1,s4
ffffffffc0202b82:	c7bff0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc0202b86:	72051963          	bnez	a0,ffffffffc02032b8 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202b8a:	000a2703          	lw	a4,0(s4)
ffffffffc0202b8e:	4789                	li	a5,2
ffffffffc0202b90:	70f71463          	bne	a4,a5,ffffffffc0203298 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202b94:	000c2783          	lw	a5,0(s8)
ffffffffc0202b98:	6e079063          	bnez	a5,ffffffffc0203278 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b9c:	00093503          	ld	a0,0(s2)
ffffffffc0202ba0:	4601                	li	a2,0
ffffffffc0202ba2:	6585                	lui	a1,0x1
ffffffffc0202ba4:	d68ff0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc0202ba8:	6a050863          	beqz	a0,ffffffffc0203258 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202bac:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202bae:	00177793          	andi	a5,a4,1
ffffffffc0202bb2:	4a078563          	beqz	a5,ffffffffc020305c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202bb6:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202bb8:	00271793          	slli	a5,a4,0x2
ffffffffc0202bbc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bbe:	48d7fd63          	bgeu	a5,a3,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bc2:	000bb683          	ld	a3,0(s7)
ffffffffc0202bc6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202bca:	97d6                	add	a5,a5,s5
ffffffffc0202bcc:	079a                	slli	a5,a5,0x6
ffffffffc0202bce:	97b6                	add	a5,a5,a3
ffffffffc0202bd0:	66fa1463          	bne	s4,a5,ffffffffc0203238 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202bd4:	8b41                	andi	a4,a4,16
ffffffffc0202bd6:	64071163          	bnez	a4,ffffffffc0203218 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202bda:	00093503          	ld	a0,0(s2)
ffffffffc0202bde:	4581                	li	a1,0
ffffffffc0202be0:	b81ff0ef          	jal	ra,ffffffffc0202760 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202be4:	000a2c83          	lw	s9,0(s4)
ffffffffc0202be8:	4785                	li	a5,1
ffffffffc0202bea:	60fc9763          	bne	s9,a5,ffffffffc02031f8 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202bee:	000c2783          	lw	a5,0(s8)
ffffffffc0202bf2:	5e079363          	bnez	a5,ffffffffc02031d8 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202bf6:	00093503          	ld	a0,0(s2)
ffffffffc0202bfa:	6585                	lui	a1,0x1
ffffffffc0202bfc:	b65ff0ef          	jal	ra,ffffffffc0202760 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202c00:	000a2783          	lw	a5,0(s4)
ffffffffc0202c04:	52079a63          	bnez	a5,ffffffffc0203138 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202c08:	000c2783          	lw	a5,0(s8)
ffffffffc0202c0c:	50079663          	bnez	a5,ffffffffc0203118 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202c10:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c14:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c16:	000a3683          	ld	a3,0(s4)
ffffffffc0202c1a:	068a                	slli	a3,a3,0x2
ffffffffc0202c1c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c1e:	42b6fd63          	bgeu	a3,a1,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c22:	000bb503          	ld	a0,0(s7)
ffffffffc0202c26:	96d6                	add	a3,a3,s5
ffffffffc0202c28:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202c2a:	00d507b3          	add	a5,a0,a3
ffffffffc0202c2e:	439c                	lw	a5,0(a5)
ffffffffc0202c30:	4d979463          	bne	a5,s9,ffffffffc02030f8 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202c34:	8699                	srai	a3,a3,0x6
ffffffffc0202c36:	00080637          	lui	a2,0x80
ffffffffc0202c3a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202c3c:	00c69713          	slli	a4,a3,0xc
ffffffffc0202c40:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c42:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c44:	48b77e63          	bgeu	a4,a1,ffffffffc02030e0 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202c48:	0009b703          	ld	a4,0(s3)
ffffffffc0202c4c:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c4e:	629c                	ld	a5,0(a3)
ffffffffc0202c50:	078a                	slli	a5,a5,0x2
ffffffffc0202c52:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c54:	40b7f263          	bgeu	a5,a1,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c58:	8f91                	sub	a5,a5,a2
ffffffffc0202c5a:	079a                	slli	a5,a5,0x6
ffffffffc0202c5c:	953e                	add	a0,a0,a5
ffffffffc0202c5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202c62:	8b89                	andi	a5,a5,2
ffffffffc0202c64:	30079963          	bnez	a5,ffffffffc0202f76 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202c68:	000b3783          	ld	a5,0(s6)
ffffffffc0202c6c:	4585                	li	a1,1
ffffffffc0202c6e:	739c                	ld	a5,32(a5)
ffffffffc0202c70:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c72:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202c76:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c78:	078a                	slli	a5,a5,0x2
ffffffffc0202c7a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c7c:	3ce7fe63          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c80:	000bb503          	ld	a0,0(s7)
ffffffffc0202c84:	fff80737          	lui	a4,0xfff80
ffffffffc0202c88:	97ba                	add	a5,a5,a4
ffffffffc0202c8a:	079a                	slli	a5,a5,0x6
ffffffffc0202c8c:	953e                	add	a0,a0,a5
ffffffffc0202c8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202c92:	8b89                	andi	a5,a5,2
ffffffffc0202c94:	2c079563          	bnez	a5,ffffffffc0202f5e <pmm_init+0x66c>
ffffffffc0202c98:	000b3783          	ld	a5,0(s6)
ffffffffc0202c9c:	4585                	li	a1,1
ffffffffc0202c9e:	739c                	ld	a5,32(a5)
ffffffffc0202ca0:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ca2:	00093783          	ld	a5,0(s2)
ffffffffc0202ca6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd2bc54>
    asm volatile("sfence.vma");
ffffffffc0202caa:	12000073          	sfence.vma
ffffffffc0202cae:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb2:	8b89                	andi	a5,a5,2
ffffffffc0202cb4:	28079b63          	bnez	a5,ffffffffc0202f4a <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cb8:	000b3783          	ld	a5,0(s6)
ffffffffc0202cbc:	779c                	ld	a5,40(a5)
ffffffffc0202cbe:	9782                	jalr	a5
ffffffffc0202cc0:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202cc2:	4b441b63          	bne	s0,s4,ffffffffc0203178 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202cc6:	00004517          	auipc	a0,0x4
ffffffffc0202cca:	fea50513          	addi	a0,a0,-22 # ffffffffc0206cb0 <default_pmm_manager+0x4e0>
ffffffffc0202cce:	cc6fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202cd2:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd6:	8b89                	andi	a5,a5,2
ffffffffc0202cd8:	24079f63          	bnez	a5,ffffffffc0202f36 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce0:	779c                	ld	a5,40(a5)
ffffffffc0202ce2:	9782                	jalr	a5
ffffffffc0202ce4:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202ce6:	6098                	ld	a4,0(s1)
ffffffffc0202ce8:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202cec:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202cee:	00c71793          	slli	a5,a4,0xc
ffffffffc0202cf2:	6a05                	lui	s4,0x1
ffffffffc0202cf4:	02f47c63          	bgeu	s0,a5,ffffffffc0202d2c <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202cf8:	00c45793          	srli	a5,s0,0xc
ffffffffc0202cfc:	00093503          	ld	a0,0(s2)
ffffffffc0202d00:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202ffe <pmm_init+0x70c>
ffffffffc0202d04:	0009b583          	ld	a1,0(s3)
ffffffffc0202d08:	4601                	li	a2,0
ffffffffc0202d0a:	95a2                	add	a1,a1,s0
ffffffffc0202d0c:	c00ff0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc0202d10:	32050463          	beqz	a0,ffffffffc0203038 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d14:	611c                	ld	a5,0(a0)
ffffffffc0202d16:	078a                	slli	a5,a5,0x2
ffffffffc0202d18:	0157f7b3          	and	a5,a5,s5
ffffffffc0202d1c:	2e879e63          	bne	a5,s0,ffffffffc0203018 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d20:	6098                	ld	a4,0(s1)
ffffffffc0202d22:	9452                	add	s0,s0,s4
ffffffffc0202d24:	00c71793          	slli	a5,a4,0xc
ffffffffc0202d28:	fcf468e3          	bltu	s0,a5,ffffffffc0202cf8 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202d2c:	00093783          	ld	a5,0(s2)
ffffffffc0202d30:	639c                	ld	a5,0(a5)
ffffffffc0202d32:	42079363          	bnez	a5,ffffffffc0203158 <pmm_init+0x866>
ffffffffc0202d36:	100027f3          	csrr	a5,sstatus
ffffffffc0202d3a:	8b89                	andi	a5,a5,2
ffffffffc0202d3c:	24079963          	bnez	a5,ffffffffc0202f8e <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d40:	000b3783          	ld	a5,0(s6)
ffffffffc0202d44:	4505                	li	a0,1
ffffffffc0202d46:	6f9c                	ld	a5,24(a5)
ffffffffc0202d48:	9782                	jalr	a5
ffffffffc0202d4a:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202d4c:	00093503          	ld	a0,0(s2)
ffffffffc0202d50:	4699                	li	a3,6
ffffffffc0202d52:	10000613          	li	a2,256
ffffffffc0202d56:	85d2                	mv	a1,s4
ffffffffc0202d58:	aa5ff0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc0202d5c:	44051e63          	bnez	a0,ffffffffc02031b8 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202d60:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc0202d64:	4785                	li	a5,1
ffffffffc0202d66:	42f71963          	bne	a4,a5,ffffffffc0203198 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d6a:	00093503          	ld	a0,0(s2)
ffffffffc0202d6e:	6405                	lui	s0,0x1
ffffffffc0202d70:	4699                	li	a3,6
ffffffffc0202d72:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ac0>
ffffffffc0202d76:	85d2                	mv	a1,s4
ffffffffc0202d78:	a85ff0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc0202d7c:	72051363          	bnez	a0,ffffffffc02034a2 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202d80:	000a2703          	lw	a4,0(s4)
ffffffffc0202d84:	4789                	li	a5,2
ffffffffc0202d86:	6ef71e63          	bne	a4,a5,ffffffffc0203482 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202d8a:	00004597          	auipc	a1,0x4
ffffffffc0202d8e:	06e58593          	addi	a1,a1,110 # ffffffffc0206df8 <default_pmm_manager+0x628>
ffffffffc0202d92:	10000513          	li	a0,256
ffffffffc0202d96:	2d9020ef          	jal	ra,ffffffffc020586e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202d9a:	10040593          	addi	a1,s0,256
ffffffffc0202d9e:	10000513          	li	a0,256
ffffffffc0202da2:	2df020ef          	jal	ra,ffffffffc0205880 <strcmp>
ffffffffc0202da6:	6a051e63          	bnez	a0,ffffffffc0203462 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202daa:	000bb683          	ld	a3,0(s7)
ffffffffc0202dae:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202db2:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202db4:	40da06b3          	sub	a3,s4,a3
ffffffffc0202db8:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202dba:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202dbc:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202dbe:	8031                	srli	s0,s0,0xc
ffffffffc0202dc0:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202dc4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202dc6:	30f77d63          	bgeu	a4,a5,ffffffffc02030e0 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202dca:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202dce:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202dd2:	96be                	add	a3,a3,a5
ffffffffc0202dd4:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202dd8:	261020ef          	jal	ra,ffffffffc0205838 <strlen>
ffffffffc0202ddc:	66051363          	bnez	a0,ffffffffc0203442 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202de0:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202de4:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202de6:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd2bc54>
ffffffffc0202dea:	068a                	slli	a3,a3,0x2
ffffffffc0202dec:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dee:	26f6f563          	bgeu	a3,a5,ffffffffc0203058 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202df2:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202df4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202df6:	2ef47563          	bgeu	s0,a5,ffffffffc02030e0 <pmm_init+0x7ee>
ffffffffc0202dfa:	0009b403          	ld	s0,0(s3)
ffffffffc0202dfe:	9436                	add	s0,s0,a3
ffffffffc0202e00:	100027f3          	csrr	a5,sstatus
ffffffffc0202e04:	8b89                	andi	a5,a5,2
ffffffffc0202e06:	1e079163          	bnez	a5,ffffffffc0202fe8 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202e0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e0e:	4585                	li	a1,1
ffffffffc0202e10:	8552                	mv	a0,s4
ffffffffc0202e12:	739c                	ld	a5,32(a5)
ffffffffc0202e14:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e16:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202e18:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e1a:	078a                	slli	a5,a5,0x2
ffffffffc0202e1c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e1e:	22e7fd63          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e22:	000bb503          	ld	a0,0(s7)
ffffffffc0202e26:	fff80737          	lui	a4,0xfff80
ffffffffc0202e2a:	97ba                	add	a5,a5,a4
ffffffffc0202e2c:	079a                	slli	a5,a5,0x6
ffffffffc0202e2e:	953e                	add	a0,a0,a5
ffffffffc0202e30:	100027f3          	csrr	a5,sstatus
ffffffffc0202e34:	8b89                	andi	a5,a5,2
ffffffffc0202e36:	18079d63          	bnez	a5,ffffffffc0202fd0 <pmm_init+0x6de>
ffffffffc0202e3a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e3e:	4585                	li	a1,1
ffffffffc0202e40:	739c                	ld	a5,32(a5)
ffffffffc0202e42:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e44:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202e48:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e4a:	078a                	slli	a5,a5,0x2
ffffffffc0202e4c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e4e:	20e7f563          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e52:	000bb503          	ld	a0,0(s7)
ffffffffc0202e56:	fff80737          	lui	a4,0xfff80
ffffffffc0202e5a:	97ba                	add	a5,a5,a4
ffffffffc0202e5c:	079a                	slli	a5,a5,0x6
ffffffffc0202e5e:	953e                	add	a0,a0,a5
ffffffffc0202e60:	100027f3          	csrr	a5,sstatus
ffffffffc0202e64:	8b89                	andi	a5,a5,2
ffffffffc0202e66:	14079963          	bnez	a5,ffffffffc0202fb8 <pmm_init+0x6c6>
ffffffffc0202e6a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e6e:	4585                	li	a1,1
ffffffffc0202e70:	739c                	ld	a5,32(a5)
ffffffffc0202e72:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202e74:	00093783          	ld	a5,0(s2)
ffffffffc0202e78:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202e7c:	12000073          	sfence.vma
ffffffffc0202e80:	100027f3          	csrr	a5,sstatus
ffffffffc0202e84:	8b89                	andi	a5,a5,2
ffffffffc0202e86:	10079f63          	bnez	a5,ffffffffc0202fa4 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e8e:	779c                	ld	a5,40(a5)
ffffffffc0202e90:	9782                	jalr	a5
ffffffffc0202e92:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202e94:	4c8c1e63          	bne	s8,s0,ffffffffc0203370 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202e98:	00004517          	auipc	a0,0x4
ffffffffc0202e9c:	fd850513          	addi	a0,a0,-40 # ffffffffc0206e70 <default_pmm_manager+0x6a0>
ffffffffc0202ea0:	af4fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202ea4:	7406                	ld	s0,96(sp)
ffffffffc0202ea6:	70a6                	ld	ra,104(sp)
ffffffffc0202ea8:	64e6                	ld	s1,88(sp)
ffffffffc0202eaa:	6946                	ld	s2,80(sp)
ffffffffc0202eac:	69a6                	ld	s3,72(sp)
ffffffffc0202eae:	6a06                	ld	s4,64(sp)
ffffffffc0202eb0:	7ae2                	ld	s5,56(sp)
ffffffffc0202eb2:	7b42                	ld	s6,48(sp)
ffffffffc0202eb4:	7ba2                	ld	s7,40(sp)
ffffffffc0202eb6:	7c02                	ld	s8,32(sp)
ffffffffc0202eb8:	6ce2                	ld	s9,24(sp)
ffffffffc0202eba:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202ebc:	f97fe06f          	j	ffffffffc0201e52 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202ec0:	c80007b7          	lui	a5,0xc8000
ffffffffc0202ec4:	bc7d                	j	ffffffffc0202982 <pmm_init+0x90>
        intr_disable();
ffffffffc0202ec6:	aeffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202eca:	000b3783          	ld	a5,0(s6)
ffffffffc0202ece:	4505                	li	a0,1
ffffffffc0202ed0:	6f9c                	ld	a5,24(a5)
ffffffffc0202ed2:	9782                	jalr	a5
ffffffffc0202ed4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202ed6:	ad9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202eda:	b9a9                	j	ffffffffc0202b34 <pmm_init+0x242>
        intr_disable();
ffffffffc0202edc:	ad9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202ee0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ee4:	4505                	li	a0,1
ffffffffc0202ee6:	6f9c                	ld	a5,24(a5)
ffffffffc0202ee8:	9782                	jalr	a5
ffffffffc0202eea:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202eec:	ac3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ef0:	b645                	j	ffffffffc0202a90 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202ef2:	ac3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ef6:	000b3783          	ld	a5,0(s6)
ffffffffc0202efa:	779c                	ld	a5,40(a5)
ffffffffc0202efc:	9782                	jalr	a5
ffffffffc0202efe:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f00:	aaffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f04:	b6b9                	j	ffffffffc0202a52 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202f06:	6705                	lui	a4,0x1
ffffffffc0202f08:	177d                	addi	a4,a4,-1
ffffffffc0202f0a:	96ba                	add	a3,a3,a4
ffffffffc0202f0c:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202f0e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202f12:	14a77363          	bgeu	a4,a0,ffffffffc0203058 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202f16:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202f1a:	fff80537          	lui	a0,0xfff80
ffffffffc0202f1e:	972a                	add	a4,a4,a0
ffffffffc0202f20:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202f22:	8c1d                	sub	s0,s0,a5
ffffffffc0202f24:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202f28:	00c45593          	srli	a1,s0,0xc
ffffffffc0202f2c:	9532                	add	a0,a0,a2
ffffffffc0202f2e:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202f30:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202f34:	b4c1                	j	ffffffffc02029f4 <pmm_init+0x102>
        intr_disable();
ffffffffc0202f36:	a7ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f3a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f3e:	779c                	ld	a5,40(a5)
ffffffffc0202f40:	9782                	jalr	a5
ffffffffc0202f42:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202f44:	a6bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f48:	bb79                	j	ffffffffc0202ce6 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202f4a:	a6bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202f4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202f52:	779c                	ld	a5,40(a5)
ffffffffc0202f54:	9782                	jalr	a5
ffffffffc0202f56:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f58:	a57fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f5c:	b39d                	j	ffffffffc0202cc2 <pmm_init+0x3d0>
ffffffffc0202f5e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f60:	a55fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f64:	000b3783          	ld	a5,0(s6)
ffffffffc0202f68:	6522                	ld	a0,8(sp)
ffffffffc0202f6a:	4585                	li	a1,1
ffffffffc0202f6c:	739c                	ld	a5,32(a5)
ffffffffc0202f6e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f70:	a3ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f74:	b33d                	j	ffffffffc0202ca2 <pmm_init+0x3b0>
ffffffffc0202f76:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f78:	a3dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202f7c:	000b3783          	ld	a5,0(s6)
ffffffffc0202f80:	6522                	ld	a0,8(sp)
ffffffffc0202f82:	4585                	li	a1,1
ffffffffc0202f84:	739c                	ld	a5,32(a5)
ffffffffc0202f86:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f88:	a27fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f8c:	b1dd                	j	ffffffffc0202c72 <pmm_init+0x380>
        intr_disable();
ffffffffc0202f8e:	a27fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202f92:	000b3783          	ld	a5,0(s6)
ffffffffc0202f96:	4505                	li	a0,1
ffffffffc0202f98:	6f9c                	ld	a5,24(a5)
ffffffffc0202f9a:	9782                	jalr	a5
ffffffffc0202f9c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f9e:	a11fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fa2:	b36d                	j	ffffffffc0202d4c <pmm_init+0x45a>
        intr_disable();
ffffffffc0202fa4:	a11fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fa8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fac:	779c                	ld	a5,40(a5)
ffffffffc0202fae:	9782                	jalr	a5
ffffffffc0202fb0:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202fb2:	9fdfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fb6:	bdf9                	j	ffffffffc0202e94 <pmm_init+0x5a2>
ffffffffc0202fb8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202fba:	9fbfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202fbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202fc2:	6522                	ld	a0,8(sp)
ffffffffc0202fc4:	4585                	li	a1,1
ffffffffc0202fc6:	739c                	ld	a5,32(a5)
ffffffffc0202fc8:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fca:	9e5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fce:	b55d                	j	ffffffffc0202e74 <pmm_init+0x582>
ffffffffc0202fd0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202fd2:	9e3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202fd6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fda:	6522                	ld	a0,8(sp)
ffffffffc0202fdc:	4585                	li	a1,1
ffffffffc0202fde:	739c                	ld	a5,32(a5)
ffffffffc0202fe0:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fe2:	9cdfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fe6:	bdb9                	j	ffffffffc0202e44 <pmm_init+0x552>
        intr_disable();
ffffffffc0202fe8:	9cdfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202fec:	000b3783          	ld	a5,0(s6)
ffffffffc0202ff0:	4585                	li	a1,1
ffffffffc0202ff2:	8552                	mv	a0,s4
ffffffffc0202ff4:	739c                	ld	a5,32(a5)
ffffffffc0202ff6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ff8:	9b7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ffc:	bd29                	j	ffffffffc0202e16 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ffe:	86a2                	mv	a3,s0
ffffffffc0203000:	00003617          	auipc	a2,0x3
ffffffffc0203004:	39060613          	addi	a2,a2,912 # ffffffffc0206390 <commands+0x820>
ffffffffc0203008:	25900593          	li	a1,601
ffffffffc020300c:	00004517          	auipc	a0,0x4
ffffffffc0203010:	89450513          	addi	a0,a0,-1900 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203014:	c7afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203018:	00004697          	auipc	a3,0x4
ffffffffc020301c:	cf868693          	addi	a3,a3,-776 # ffffffffc0206d10 <default_pmm_manager+0x540>
ffffffffc0203020:	00003617          	auipc	a2,0x3
ffffffffc0203024:	40060613          	addi	a2,a2,1024 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203028:	25a00593          	li	a1,602
ffffffffc020302c:	00004517          	auipc	a0,0x4
ffffffffc0203030:	87450513          	addi	a0,a0,-1932 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203034:	c5afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203038:	00004697          	auipc	a3,0x4
ffffffffc020303c:	c9868693          	addi	a3,a3,-872 # ffffffffc0206cd0 <default_pmm_manager+0x500>
ffffffffc0203040:	00003617          	auipc	a2,0x3
ffffffffc0203044:	3e060613          	addi	a2,a2,992 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203048:	25900593          	li	a1,601
ffffffffc020304c:	00004517          	auipc	a0,0x4
ffffffffc0203050:	85450513          	addi	a0,a0,-1964 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203054:	c3afd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203058:	fc5fe0ef          	jal	ra,ffffffffc020201c <pa2page.part.0>
ffffffffc020305c:	fddfe0ef          	jal	ra,ffffffffc0202038 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203060:	00004697          	auipc	a3,0x4
ffffffffc0203064:	a6868693          	addi	a3,a3,-1432 # ffffffffc0206ac8 <default_pmm_manager+0x2f8>
ffffffffc0203068:	00003617          	auipc	a2,0x3
ffffffffc020306c:	3b860613          	addi	a2,a2,952 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203070:	22900593          	li	a1,553
ffffffffc0203074:	00004517          	auipc	a0,0x4
ffffffffc0203078:	82c50513          	addi	a0,a0,-2004 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020307c:	c12fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203080:	00004697          	auipc	a3,0x4
ffffffffc0203084:	98868693          	addi	a3,a3,-1656 # ffffffffc0206a08 <default_pmm_manager+0x238>
ffffffffc0203088:	00003617          	auipc	a2,0x3
ffffffffc020308c:	39860613          	addi	a2,a2,920 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203090:	21c00593          	li	a1,540
ffffffffc0203094:	00004517          	auipc	a0,0x4
ffffffffc0203098:	80c50513          	addi	a0,a0,-2036 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020309c:	bf2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02030a0:	00004697          	auipc	a3,0x4
ffffffffc02030a4:	92868693          	addi	a3,a3,-1752 # ffffffffc02069c8 <default_pmm_manager+0x1f8>
ffffffffc02030a8:	00003617          	auipc	a2,0x3
ffffffffc02030ac:	37860613          	addi	a2,a2,888 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02030b0:	21b00593          	li	a1,539
ffffffffc02030b4:	00003517          	auipc	a0,0x3
ffffffffc02030b8:	7ec50513          	addi	a0,a0,2028 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02030bc:	bd2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02030c0:	00004697          	auipc	a3,0x4
ffffffffc02030c4:	8e868693          	addi	a3,a3,-1816 # ffffffffc02069a8 <default_pmm_manager+0x1d8>
ffffffffc02030c8:	00003617          	auipc	a2,0x3
ffffffffc02030cc:	35860613          	addi	a2,a2,856 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02030d0:	21a00593          	li	a1,538
ffffffffc02030d4:	00003517          	auipc	a0,0x3
ffffffffc02030d8:	7cc50513          	addi	a0,a0,1996 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02030dc:	bb2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02030e0:	00003617          	auipc	a2,0x3
ffffffffc02030e4:	2b060613          	addi	a2,a2,688 # ffffffffc0206390 <commands+0x820>
ffffffffc02030e8:	07100593          	li	a1,113
ffffffffc02030ec:	00003517          	auipc	a0,0x3
ffffffffc02030f0:	25c50513          	addi	a0,a0,604 # ffffffffc0206348 <commands+0x7d8>
ffffffffc02030f4:	b9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02030f8:	00004697          	auipc	a3,0x4
ffffffffc02030fc:	b6068693          	addi	a3,a3,-1184 # ffffffffc0206c58 <default_pmm_manager+0x488>
ffffffffc0203100:	00003617          	auipc	a2,0x3
ffffffffc0203104:	32060613          	addi	a2,a2,800 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203108:	24200593          	li	a1,578
ffffffffc020310c:	00003517          	auipc	a0,0x3
ffffffffc0203110:	79450513          	addi	a0,a0,1940 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203114:	b7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203118:	00004697          	auipc	a3,0x4
ffffffffc020311c:	af868693          	addi	a3,a3,-1288 # ffffffffc0206c10 <default_pmm_manager+0x440>
ffffffffc0203120:	00003617          	auipc	a2,0x3
ffffffffc0203124:	30060613          	addi	a2,a2,768 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203128:	24000593          	li	a1,576
ffffffffc020312c:	00003517          	auipc	a0,0x3
ffffffffc0203130:	77450513          	addi	a0,a0,1908 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203134:	b5afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203138:	00004697          	auipc	a3,0x4
ffffffffc020313c:	b0868693          	addi	a3,a3,-1272 # ffffffffc0206c40 <default_pmm_manager+0x470>
ffffffffc0203140:	00003617          	auipc	a2,0x3
ffffffffc0203144:	2e060613          	addi	a2,a2,736 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203148:	23f00593          	li	a1,575
ffffffffc020314c:	00003517          	auipc	a0,0x3
ffffffffc0203150:	75450513          	addi	a0,a0,1876 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203154:	b3afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203158:	00004697          	auipc	a3,0x4
ffffffffc020315c:	bd068693          	addi	a3,a3,-1072 # ffffffffc0206d28 <default_pmm_manager+0x558>
ffffffffc0203160:	00003617          	auipc	a2,0x3
ffffffffc0203164:	2c060613          	addi	a2,a2,704 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203168:	25d00593          	li	a1,605
ffffffffc020316c:	00003517          	auipc	a0,0x3
ffffffffc0203170:	73450513          	addi	a0,a0,1844 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203174:	b1afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203178:	00004697          	auipc	a3,0x4
ffffffffc020317c:	b1068693          	addi	a3,a3,-1264 # ffffffffc0206c88 <default_pmm_manager+0x4b8>
ffffffffc0203180:	00003617          	auipc	a2,0x3
ffffffffc0203184:	2a060613          	addi	a2,a2,672 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203188:	24a00593          	li	a1,586
ffffffffc020318c:	00003517          	auipc	a0,0x3
ffffffffc0203190:	71450513          	addi	a0,a0,1812 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203194:	afafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203198:	00004697          	auipc	a3,0x4
ffffffffc020319c:	be868693          	addi	a3,a3,-1048 # ffffffffc0206d80 <default_pmm_manager+0x5b0>
ffffffffc02031a0:	00003617          	auipc	a2,0x3
ffffffffc02031a4:	28060613          	addi	a2,a2,640 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02031a8:	26200593          	li	a1,610
ffffffffc02031ac:	00003517          	auipc	a0,0x3
ffffffffc02031b0:	6f450513          	addi	a0,a0,1780 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02031b4:	adafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02031b8:	00004697          	auipc	a3,0x4
ffffffffc02031bc:	b8868693          	addi	a3,a3,-1144 # ffffffffc0206d40 <default_pmm_manager+0x570>
ffffffffc02031c0:	00003617          	auipc	a2,0x3
ffffffffc02031c4:	26060613          	addi	a2,a2,608 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02031c8:	26100593          	li	a1,609
ffffffffc02031cc:	00003517          	auipc	a0,0x3
ffffffffc02031d0:	6d450513          	addi	a0,a0,1748 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02031d4:	abafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02031d8:	00004697          	auipc	a3,0x4
ffffffffc02031dc:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206c10 <default_pmm_manager+0x440>
ffffffffc02031e0:	00003617          	auipc	a2,0x3
ffffffffc02031e4:	24060613          	addi	a2,a2,576 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02031e8:	23c00593          	li	a1,572
ffffffffc02031ec:	00003517          	auipc	a0,0x3
ffffffffc02031f0:	6b450513          	addi	a0,a0,1716 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02031f4:	a9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02031f8:	00004697          	auipc	a3,0x4
ffffffffc02031fc:	8b868693          	addi	a3,a3,-1864 # ffffffffc0206ab0 <default_pmm_manager+0x2e0>
ffffffffc0203200:	00003617          	auipc	a2,0x3
ffffffffc0203204:	22060613          	addi	a2,a2,544 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203208:	23b00593          	li	a1,571
ffffffffc020320c:	00003517          	auipc	a0,0x3
ffffffffc0203210:	69450513          	addi	a0,a0,1684 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203214:	a7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203218:	00004697          	auipc	a3,0x4
ffffffffc020321c:	a1068693          	addi	a3,a3,-1520 # ffffffffc0206c28 <default_pmm_manager+0x458>
ffffffffc0203220:	00003617          	auipc	a2,0x3
ffffffffc0203224:	20060613          	addi	a2,a2,512 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203228:	23800593          	li	a1,568
ffffffffc020322c:	00003517          	auipc	a0,0x3
ffffffffc0203230:	67450513          	addi	a0,a0,1652 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203234:	a5afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203238:	00004697          	auipc	a3,0x4
ffffffffc020323c:	86068693          	addi	a3,a3,-1952 # ffffffffc0206a98 <default_pmm_manager+0x2c8>
ffffffffc0203240:	00003617          	auipc	a2,0x3
ffffffffc0203244:	1e060613          	addi	a2,a2,480 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203248:	23700593          	li	a1,567
ffffffffc020324c:	00003517          	auipc	a0,0x3
ffffffffc0203250:	65450513          	addi	a0,a0,1620 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203254:	a3afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203258:	00004697          	auipc	a3,0x4
ffffffffc020325c:	8e068693          	addi	a3,a3,-1824 # ffffffffc0206b38 <default_pmm_manager+0x368>
ffffffffc0203260:	00003617          	auipc	a2,0x3
ffffffffc0203264:	1c060613          	addi	a2,a2,448 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203268:	23600593          	li	a1,566
ffffffffc020326c:	00003517          	auipc	a0,0x3
ffffffffc0203270:	63450513          	addi	a0,a0,1588 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203274:	a1afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203278:	00004697          	auipc	a3,0x4
ffffffffc020327c:	99868693          	addi	a3,a3,-1640 # ffffffffc0206c10 <default_pmm_manager+0x440>
ffffffffc0203280:	00003617          	auipc	a2,0x3
ffffffffc0203284:	1a060613          	addi	a2,a2,416 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203288:	23500593          	li	a1,565
ffffffffc020328c:	00003517          	auipc	a0,0x3
ffffffffc0203290:	61450513          	addi	a0,a0,1556 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203294:	9fafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203298:	00004697          	auipc	a3,0x4
ffffffffc020329c:	96068693          	addi	a3,a3,-1696 # ffffffffc0206bf8 <default_pmm_manager+0x428>
ffffffffc02032a0:	00003617          	auipc	a2,0x3
ffffffffc02032a4:	18060613          	addi	a2,a2,384 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02032a8:	23400593          	li	a1,564
ffffffffc02032ac:	00003517          	auipc	a0,0x3
ffffffffc02032b0:	5f450513          	addi	a0,a0,1524 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02032b4:	9dafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02032b8:	00004697          	auipc	a3,0x4
ffffffffc02032bc:	91068693          	addi	a3,a3,-1776 # ffffffffc0206bc8 <default_pmm_manager+0x3f8>
ffffffffc02032c0:	00003617          	auipc	a2,0x3
ffffffffc02032c4:	16060613          	addi	a2,a2,352 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02032c8:	23300593          	li	a1,563
ffffffffc02032cc:	00003517          	auipc	a0,0x3
ffffffffc02032d0:	5d450513          	addi	a0,a0,1492 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02032d4:	9bafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02032d8:	00004697          	auipc	a3,0x4
ffffffffc02032dc:	8d868693          	addi	a3,a3,-1832 # ffffffffc0206bb0 <default_pmm_manager+0x3e0>
ffffffffc02032e0:	00003617          	auipc	a2,0x3
ffffffffc02032e4:	14060613          	addi	a2,a2,320 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02032e8:	23100593          	li	a1,561
ffffffffc02032ec:	00003517          	auipc	a0,0x3
ffffffffc02032f0:	5b450513          	addi	a0,a0,1460 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02032f4:	99afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02032f8:	00004697          	auipc	a3,0x4
ffffffffc02032fc:	89868693          	addi	a3,a3,-1896 # ffffffffc0206b90 <default_pmm_manager+0x3c0>
ffffffffc0203300:	00003617          	auipc	a2,0x3
ffffffffc0203304:	12060613          	addi	a2,a2,288 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203308:	23000593          	li	a1,560
ffffffffc020330c:	00003517          	auipc	a0,0x3
ffffffffc0203310:	59450513          	addi	a0,a0,1428 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203314:	97afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203318:	00004697          	auipc	a3,0x4
ffffffffc020331c:	86868693          	addi	a3,a3,-1944 # ffffffffc0206b80 <default_pmm_manager+0x3b0>
ffffffffc0203320:	00003617          	auipc	a2,0x3
ffffffffc0203324:	10060613          	addi	a2,a2,256 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203328:	22f00593          	li	a1,559
ffffffffc020332c:	00003517          	auipc	a0,0x3
ffffffffc0203330:	57450513          	addi	a0,a0,1396 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203334:	95afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203338:	00004697          	auipc	a3,0x4
ffffffffc020333c:	83868693          	addi	a3,a3,-1992 # ffffffffc0206b70 <default_pmm_manager+0x3a0>
ffffffffc0203340:	00003617          	auipc	a2,0x3
ffffffffc0203344:	0e060613          	addi	a2,a2,224 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203348:	22e00593          	li	a1,558
ffffffffc020334c:	00003517          	auipc	a0,0x3
ffffffffc0203350:	55450513          	addi	a0,a0,1364 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203354:	93afd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc0203358:	00003617          	auipc	a2,0x3
ffffffffc020335c:	5b860613          	addi	a2,a2,1464 # ffffffffc0206910 <default_pmm_manager+0x140>
ffffffffc0203360:	06500593          	li	a1,101
ffffffffc0203364:	00003517          	auipc	a0,0x3
ffffffffc0203368:	53c50513          	addi	a0,a0,1340 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020336c:	922fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203370:	00004697          	auipc	a3,0x4
ffffffffc0203374:	91868693          	addi	a3,a3,-1768 # ffffffffc0206c88 <default_pmm_manager+0x4b8>
ffffffffc0203378:	00003617          	auipc	a2,0x3
ffffffffc020337c:	0a860613          	addi	a2,a2,168 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203380:	27400593          	li	a1,628
ffffffffc0203384:	00003517          	auipc	a0,0x3
ffffffffc0203388:	51c50513          	addi	a0,a0,1308 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020338c:	902fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203390:	00003697          	auipc	a3,0x3
ffffffffc0203394:	7a868693          	addi	a3,a3,1960 # ffffffffc0206b38 <default_pmm_manager+0x368>
ffffffffc0203398:	00003617          	auipc	a2,0x3
ffffffffc020339c:	08860613          	addi	a2,a2,136 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02033a0:	22d00593          	li	a1,557
ffffffffc02033a4:	00003517          	auipc	a0,0x3
ffffffffc02033a8:	4fc50513          	addi	a0,a0,1276 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02033ac:	8e2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02033b0:	00003697          	auipc	a3,0x3
ffffffffc02033b4:	74868693          	addi	a3,a3,1864 # ffffffffc0206af8 <default_pmm_manager+0x328>
ffffffffc02033b8:	00003617          	auipc	a2,0x3
ffffffffc02033bc:	06860613          	addi	a2,a2,104 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02033c0:	22c00593          	li	a1,556
ffffffffc02033c4:	00003517          	auipc	a0,0x3
ffffffffc02033c8:	4dc50513          	addi	a0,a0,1244 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02033cc:	8c2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02033d0:	86d6                	mv	a3,s5
ffffffffc02033d2:	00003617          	auipc	a2,0x3
ffffffffc02033d6:	fbe60613          	addi	a2,a2,-66 # ffffffffc0206390 <commands+0x820>
ffffffffc02033da:	22800593          	li	a1,552
ffffffffc02033de:	00003517          	auipc	a0,0x3
ffffffffc02033e2:	4c250513          	addi	a0,a0,1218 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02033e6:	8a8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02033ea:	00003617          	auipc	a2,0x3
ffffffffc02033ee:	fa660613          	addi	a2,a2,-90 # ffffffffc0206390 <commands+0x820>
ffffffffc02033f2:	22700593          	li	a1,551
ffffffffc02033f6:	00003517          	auipc	a0,0x3
ffffffffc02033fa:	4aa50513          	addi	a0,a0,1194 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02033fe:	890fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203402:	00003697          	auipc	a3,0x3
ffffffffc0203406:	6ae68693          	addi	a3,a3,1710 # ffffffffc0206ab0 <default_pmm_manager+0x2e0>
ffffffffc020340a:	00003617          	auipc	a2,0x3
ffffffffc020340e:	01660613          	addi	a2,a2,22 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203412:	22500593          	li	a1,549
ffffffffc0203416:	00003517          	auipc	a0,0x3
ffffffffc020341a:	48a50513          	addi	a0,a0,1162 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020341e:	870fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203422:	00003697          	auipc	a3,0x3
ffffffffc0203426:	67668693          	addi	a3,a3,1654 # ffffffffc0206a98 <default_pmm_manager+0x2c8>
ffffffffc020342a:	00003617          	auipc	a2,0x3
ffffffffc020342e:	ff660613          	addi	a2,a2,-10 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203432:	22400593          	li	a1,548
ffffffffc0203436:	00003517          	auipc	a0,0x3
ffffffffc020343a:	46a50513          	addi	a0,a0,1130 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020343e:	850fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203442:	00004697          	auipc	a3,0x4
ffffffffc0203446:	a0668693          	addi	a3,a3,-1530 # ffffffffc0206e48 <default_pmm_manager+0x678>
ffffffffc020344a:	00003617          	auipc	a2,0x3
ffffffffc020344e:	fd660613          	addi	a2,a2,-42 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203452:	26b00593          	li	a1,619
ffffffffc0203456:	00003517          	auipc	a0,0x3
ffffffffc020345a:	44a50513          	addi	a0,a0,1098 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020345e:	830fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203462:	00004697          	auipc	a3,0x4
ffffffffc0203466:	9ae68693          	addi	a3,a3,-1618 # ffffffffc0206e10 <default_pmm_manager+0x640>
ffffffffc020346a:	00003617          	auipc	a2,0x3
ffffffffc020346e:	fb660613          	addi	a2,a2,-74 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203472:	26800593          	li	a1,616
ffffffffc0203476:	00003517          	auipc	a0,0x3
ffffffffc020347a:	42a50513          	addi	a0,a0,1066 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020347e:	810fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203482:	00004697          	auipc	a3,0x4
ffffffffc0203486:	95e68693          	addi	a3,a3,-1698 # ffffffffc0206de0 <default_pmm_manager+0x610>
ffffffffc020348a:	00003617          	auipc	a2,0x3
ffffffffc020348e:	f9660613          	addi	a2,a2,-106 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203492:	26400593          	li	a1,612
ffffffffc0203496:	00003517          	auipc	a0,0x3
ffffffffc020349a:	40a50513          	addi	a0,a0,1034 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020349e:	ff1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02034a2:	00004697          	auipc	a3,0x4
ffffffffc02034a6:	8f668693          	addi	a3,a3,-1802 # ffffffffc0206d98 <default_pmm_manager+0x5c8>
ffffffffc02034aa:	00003617          	auipc	a2,0x3
ffffffffc02034ae:	f7660613          	addi	a2,a2,-138 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02034b2:	26300593          	li	a1,611
ffffffffc02034b6:	00003517          	auipc	a0,0x3
ffffffffc02034ba:	3ea50513          	addi	a0,a0,1002 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02034be:	fd1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02034c2:	00003617          	auipc	a2,0x3
ffffffffc02034c6:	3b660613          	addi	a2,a2,950 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc02034ca:	0c900593          	li	a1,201
ffffffffc02034ce:	00003517          	auipc	a0,0x3
ffffffffc02034d2:	3d250513          	addi	a0,a0,978 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02034d6:	fb9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02034da:	00003617          	auipc	a2,0x3
ffffffffc02034de:	39e60613          	addi	a2,a2,926 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc02034e2:	08100593          	li	a1,129
ffffffffc02034e6:	00003517          	auipc	a0,0x3
ffffffffc02034ea:	3ba50513          	addi	a0,a0,954 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02034ee:	fa1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02034f2:	00003697          	auipc	a3,0x3
ffffffffc02034f6:	57668693          	addi	a3,a3,1398 # ffffffffc0206a68 <default_pmm_manager+0x298>
ffffffffc02034fa:	00003617          	auipc	a2,0x3
ffffffffc02034fe:	f2660613          	addi	a2,a2,-218 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203502:	22300593          	li	a1,547
ffffffffc0203506:	00003517          	auipc	a0,0x3
ffffffffc020350a:	39a50513          	addi	a0,a0,922 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020350e:	f81fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203512:	00003697          	auipc	a3,0x3
ffffffffc0203516:	52668693          	addi	a3,a3,1318 # ffffffffc0206a38 <default_pmm_manager+0x268>
ffffffffc020351a:	00003617          	auipc	a2,0x3
ffffffffc020351e:	f0660613          	addi	a2,a2,-250 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203522:	22000593          	li	a1,544
ffffffffc0203526:	00003517          	auipc	a0,0x3
ffffffffc020352a:	37a50513          	addi	a0,a0,890 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020352e:	f61fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203532 <copy_range>:
{
ffffffffc0203532:	7175                	addi	sp,sp,-144
ffffffffc0203534:	e122                	sd	s0,128(sp)
ffffffffc0203536:	8436                	mv	s0,a3
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203538:	8ed1                	or	a3,a3,a2
{
ffffffffc020353a:	e506                	sd	ra,136(sp)
ffffffffc020353c:	fca6                	sd	s1,120(sp)
ffffffffc020353e:	f8ca                	sd	s2,112(sp)
ffffffffc0203540:	f4ce                	sd	s3,104(sp)
ffffffffc0203542:	f0d2                	sd	s4,96(sp)
ffffffffc0203544:	ecd6                	sd	s5,88(sp)
ffffffffc0203546:	e8da                	sd	s6,80(sp)
ffffffffc0203548:	e4de                	sd	s7,72(sp)
ffffffffc020354a:	e0e2                	sd	s8,64(sp)
ffffffffc020354c:	fc66                	sd	s9,56(sp)
ffffffffc020354e:	f86a                	sd	s10,48(sp)
ffffffffc0203550:	f46e                	sd	s11,40(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203552:	16d2                	slli	a3,a3,0x34
{
ffffffffc0203554:	e83a                	sd	a4,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203556:	26069063          	bnez	a3,ffffffffc02037b6 <copy_range+0x284>
    assert(USER_ACCESS(start, end));
ffffffffc020355a:	00200737          	lui	a4,0x200
ffffffffc020355e:	8db2                	mv	s11,a2
ffffffffc0203560:	1ae66563          	bltu	a2,a4,ffffffffc020370a <copy_range+0x1d8>
ffffffffc0203564:	1a867363          	bgeu	a2,s0,ffffffffc020370a <copy_range+0x1d8>
ffffffffc0203568:	4705                	li	a4,1
ffffffffc020356a:	077e                	slli	a4,a4,0x1f
ffffffffc020356c:	18876f63          	bltu	a4,s0,ffffffffc020370a <copy_range+0x1d8>
ffffffffc0203570:	5cfd                	li	s9,-1
ffffffffc0203572:	00ccd793          	srli	a5,s9,0xc
ffffffffc0203576:	8a2a                	mv	s4,a0
ffffffffc0203578:	84ae                	mv	s1,a1
        start += PGSIZE;
ffffffffc020357a:	6905                	lui	s2,0x1
    if (PPN(pa) >= npage)
ffffffffc020357c:	000d0b97          	auipc	s7,0xd0
ffffffffc0203580:	df4b8b93          	addi	s7,s7,-524 # ffffffffc02d3370 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203584:	000d0b17          	auipc	s6,0xd0
ffffffffc0203588:	df4b0b13          	addi	s6,s6,-524 # ffffffffc02d3378 <pages>
    return KADDR(page2pa(page));
ffffffffc020358c:	ec3e                	sd	a5,24(sp)
        page = pmm_manager->alloc_pages(n);
ffffffffc020358e:	000d0c17          	auipc	s8,0xd0
ffffffffc0203592:	df2c0c13          	addi	s8,s8,-526 # ffffffffc02d3380 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203596:	4601                	li	a2,0
ffffffffc0203598:	85ee                	mv	a1,s11
ffffffffc020359a:	8526                	mv	a0,s1
ffffffffc020359c:	b71fe0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc02035a0:	89aa                	mv	s3,a0
        if (ptep == NULL)
ffffffffc02035a2:	c169                	beqz	a0,ffffffffc0203664 <copy_range+0x132>
        if (*ptep & PTE_V)
ffffffffc02035a4:	6114                	ld	a3,0(a0)
ffffffffc02035a6:	8a85                	andi	a3,a3,1
ffffffffc02035a8:	e685                	bnez	a3,ffffffffc02035d0 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02035aa:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc02035ac:	fe8de5e3          	bltu	s11,s0,ffffffffc0203596 <copy_range+0x64>
    return 0;
ffffffffc02035b0:	4501                	li	a0,0
}
ffffffffc02035b2:	60aa                	ld	ra,136(sp)
ffffffffc02035b4:	640a                	ld	s0,128(sp)
ffffffffc02035b6:	74e6                	ld	s1,120(sp)
ffffffffc02035b8:	7946                	ld	s2,112(sp)
ffffffffc02035ba:	79a6                	ld	s3,104(sp)
ffffffffc02035bc:	7a06                	ld	s4,96(sp)
ffffffffc02035be:	6ae6                	ld	s5,88(sp)
ffffffffc02035c0:	6b46                	ld	s6,80(sp)
ffffffffc02035c2:	6ba6                	ld	s7,72(sp)
ffffffffc02035c4:	6c06                	ld	s8,64(sp)
ffffffffc02035c6:	7ce2                	ld	s9,56(sp)
ffffffffc02035c8:	7d42                	ld	s10,48(sp)
ffffffffc02035ca:	7da2                	ld	s11,40(sp)
ffffffffc02035cc:	6149                	addi	sp,sp,144
ffffffffc02035ce:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02035d0:	4605                	li	a2,1
ffffffffc02035d2:	85ee                	mv	a1,s11
ffffffffc02035d4:	8552                	mv	a0,s4
ffffffffc02035d6:	b37fe0ef          	jal	ra,ffffffffc020210c <get_pte>
ffffffffc02035da:	10050a63          	beqz	a0,ffffffffc02036ee <copy_range+0x1bc>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02035de:	0009b603          	ld	a2,0(s3)
ffffffffc02035e2:	0006079b          	sext.w	a5,a2
    if (!(pte & PTE_V))
ffffffffc02035e6:	00167593          	andi	a1,a2,1
ffffffffc02035ea:	e43e                	sd	a5,8(sp)
ffffffffc02035ec:	01f67a93          	andi	s5,a2,31
ffffffffc02035f0:	10058163          	beqz	a1,ffffffffc02036f2 <copy_range+0x1c0>
    if (PPN(pa) >= npage)
ffffffffc02035f4:	000bb583          	ld	a1,0(s7)
    return pa2page(PTE_ADDR(pte));
ffffffffc02035f8:	060a                	slli	a2,a2,0x2
ffffffffc02035fa:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc02035fc:	16b67763          	bgeu	a2,a1,ffffffffc020376a <copy_range+0x238>
    return &pages[PPN(pa) - nbase];
ffffffffc0203600:	000b3583          	ld	a1,0(s6)
ffffffffc0203604:	fff807b7          	lui	a5,0xfff80
ffffffffc0203608:	963e                	add	a2,a2,a5
ffffffffc020360a:	061a                	slli	a2,a2,0x6
ffffffffc020360c:	00c58d33          	add	s10,a1,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203610:	10002673          	csrr	a2,sstatus
ffffffffc0203614:	8a09                	andi	a2,a2,2
ffffffffc0203616:	e625                	bnez	a2,ffffffffc020367e <copy_range+0x14c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203618:	000c3603          	ld	a2,0(s8)
ffffffffc020361c:	4505                	li	a0,1
ffffffffc020361e:	6e10                	ld	a2,24(a2)
ffffffffc0203620:	9602                	jalr	a2
ffffffffc0203622:	8caa                	mv	s9,a0
            assert(page != NULL);
ffffffffc0203624:	120d0363          	beqz	s10,ffffffffc020374a <copy_range+0x218>
            assert(npage != NULL);
ffffffffc0203628:	100c8163          	beqz	s9,ffffffffc020372a <copy_range+0x1f8>
            if (share) {
ffffffffc020362c:	67c2                	ld	a5,16(sp)
ffffffffc020362e:	c3bd                	beqz	a5,ffffffffc0203694 <copy_range+0x162>
                if (perm & PTE_W) {
ffffffffc0203630:	67a2                	ld	a5,8(sp)
ffffffffc0203632:	0047f613          	andi	a2,a5,4
ffffffffc0203636:	ce19                	beqz	a2,ffffffffc0203654 <copy_range+0x122>
                    *ptep = (*ptep & ~PTE_W) | PTE_COW;
ffffffffc0203638:	0009b603          	ld	a2,0(s3)
                    perm = (perm & ~PTE_W) | PTE_COW;
ffffffffc020363c:	01b7f693          	andi	a3,a5,27
ffffffffc0203640:	1006ea93          	ori	s5,a3,256
                    *ptep = (*ptep & ~PTE_W) | PTE_COW;
ffffffffc0203644:	efb67613          	andi	a2,a2,-261
ffffffffc0203648:	10066613          	ori	a2,a2,256
ffffffffc020364c:	00c9b023          	sd	a2,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203650:	120d8073          	sfence.vma	s11
                ret = page_insert(to, page, start, perm);
ffffffffc0203654:	866e                	mv	a2,s11
ffffffffc0203656:	86d6                	mv	a3,s5
ffffffffc0203658:	85ea                	mv	a1,s10
ffffffffc020365a:	8552                	mv	a0,s4
ffffffffc020365c:	9a0ff0ef          	jal	ra,ffffffffc02027fc <page_insert>
        start += PGSIZE;
ffffffffc0203660:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc0203662:	b7a9                	j	ffffffffc02035ac <copy_range+0x7a>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203664:	00200637          	lui	a2,0x200
ffffffffc0203668:	00cd87b3          	add	a5,s11,a2
ffffffffc020366c:	ffe00637          	lui	a2,0xffe00
ffffffffc0203670:	00c7fdb3          	and	s11,a5,a2
    } while (start != 0 && start < end);
ffffffffc0203674:	f20d8ee3          	beqz	s11,ffffffffc02035b0 <copy_range+0x7e>
ffffffffc0203678:	f08defe3          	bltu	s11,s0,ffffffffc0203596 <copy_range+0x64>
ffffffffc020367c:	bf15                	j	ffffffffc02035b0 <copy_range+0x7e>
        intr_disable();
ffffffffc020367e:	b36fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203682:	000c3603          	ld	a2,0(s8)
ffffffffc0203686:	4505                	li	a0,1
ffffffffc0203688:	6e10                	ld	a2,24(a2)
ffffffffc020368a:	9602                	jalr	a2
ffffffffc020368c:	8caa                	mv	s9,a0
        intr_enable();
ffffffffc020368e:	b20fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203692:	bf49                	j	ffffffffc0203624 <copy_range+0xf2>
    return page - pages + nbase;
ffffffffc0203694:	000b3703          	ld	a4,0(s6)
    return KADDR(page2pa(page));
ffffffffc0203698:	67e2                	ld	a5,24(sp)
    return page - pages + nbase;
ffffffffc020369a:	00080337          	lui	t1,0x80
ffffffffc020369e:	40ed0633          	sub	a2,s10,a4
ffffffffc02036a2:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc02036a4:	000bb883          	ld	a7,0(s7)
    return page - pages + nbase;
ffffffffc02036a8:	961a                	add	a2,a2,t1
    return KADDR(page2pa(page));
ffffffffc02036aa:	00f675b3          	and	a1,a2,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02036ae:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc02036b0:	0f15f663          	bgeu	a1,a7,ffffffffc020379c <copy_range+0x26a>
ffffffffc02036b4:	000d0797          	auipc	a5,0xd0
ffffffffc02036b8:	cd478793          	addi	a5,a5,-812 # ffffffffc02d3388 <va_pa_offset>
ffffffffc02036bc:	6388                	ld	a0,0(a5)
    return page - pages + nbase;
ffffffffc02036be:	40ec8733          	sub	a4,s9,a4
    return KADDR(page2pa(page));
ffffffffc02036c2:	67e2                	ld	a5,24(sp)
    return page - pages + nbase;
ffffffffc02036c4:	8719                	srai	a4,a4,0x6
ffffffffc02036c6:	971a                	add	a4,a4,t1
    return KADDR(page2pa(page));
ffffffffc02036c8:	00f77333          	and	t1,a4,a5
ffffffffc02036cc:	00a605b3          	add	a1,a2,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02036d0:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc02036d2:	0b137863          	bgeu	t1,a7,ffffffffc0203782 <copy_range+0x250>
                memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02036d6:	6605                	lui	a2,0x1
ffffffffc02036d8:	953a                	add	a0,a0,a4
ffffffffc02036da:	212020ef          	jal	ra,ffffffffc02058ec <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc02036de:	866e                	mv	a2,s11
ffffffffc02036e0:	86d6                	mv	a3,s5
ffffffffc02036e2:	85e6                	mv	a1,s9
ffffffffc02036e4:	8552                	mv	a0,s4
ffffffffc02036e6:	916ff0ef          	jal	ra,ffffffffc02027fc <page_insert>
        start += PGSIZE;
ffffffffc02036ea:	9dca                	add	s11,s11,s2
    } while (start != 0 && start < end);
ffffffffc02036ec:	b5c1                	j	ffffffffc02035ac <copy_range+0x7a>
                return -E_NO_MEM;
ffffffffc02036ee:	5571                	li	a0,-4
ffffffffc02036f0:	b5c9                	j	ffffffffc02035b2 <copy_range+0x80>
        panic("pte2page called with invalid pte");
ffffffffc02036f2:	00003617          	auipc	a2,0x3
ffffffffc02036f6:	c2e60613          	addi	a2,a2,-978 # ffffffffc0206320 <commands+0x7b0>
ffffffffc02036fa:	07f00593          	li	a1,127
ffffffffc02036fe:	00003517          	auipc	a0,0x3
ffffffffc0203702:	c4a50513          	addi	a0,a0,-950 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0203706:	d89fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020370a:	00003697          	auipc	a3,0x3
ffffffffc020370e:	1d668693          	addi	a3,a3,470 # ffffffffc02068e0 <default_pmm_manager+0x110>
ffffffffc0203712:	00003617          	auipc	a2,0x3
ffffffffc0203716:	d0e60613          	addi	a2,a2,-754 # ffffffffc0206420 <commands+0x8b0>
ffffffffc020371a:	17c00593          	li	a1,380
ffffffffc020371e:	00003517          	auipc	a0,0x3
ffffffffc0203722:	18250513          	addi	a0,a0,386 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203726:	d69fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc020372a:	00003697          	auipc	a3,0x3
ffffffffc020372e:	77668693          	addi	a3,a3,1910 # ffffffffc0206ea0 <default_pmm_manager+0x6d0>
ffffffffc0203732:	00003617          	auipc	a2,0x3
ffffffffc0203736:	cee60613          	addi	a2,a2,-786 # ffffffffc0206420 <commands+0x8b0>
ffffffffc020373a:	19500593          	li	a1,405
ffffffffc020373e:	00003517          	auipc	a0,0x3
ffffffffc0203742:	16250513          	addi	a0,a0,354 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203746:	d49fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc020374a:	00003697          	auipc	a3,0x3
ffffffffc020374e:	74668693          	addi	a3,a3,1862 # ffffffffc0206e90 <default_pmm_manager+0x6c0>
ffffffffc0203752:	00003617          	auipc	a2,0x3
ffffffffc0203756:	cce60613          	addi	a2,a2,-818 # ffffffffc0206420 <commands+0x8b0>
ffffffffc020375a:	19400593          	li	a1,404
ffffffffc020375e:	00003517          	auipc	a0,0x3
ffffffffc0203762:	14250513          	addi	a0,a0,322 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc0203766:	d29fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020376a:	00003617          	auipc	a2,0x3
ffffffffc020376e:	bee60613          	addi	a2,a2,-1042 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0203772:	06900593          	li	a1,105
ffffffffc0203776:	00003517          	auipc	a0,0x3
ffffffffc020377a:	bd250513          	addi	a0,a0,-1070 # ffffffffc0206348 <commands+0x7d8>
ffffffffc020377e:	d11fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0203782:	86ba                	mv	a3,a4
ffffffffc0203784:	00003617          	auipc	a2,0x3
ffffffffc0203788:	c0c60613          	addi	a2,a2,-1012 # ffffffffc0206390 <commands+0x820>
ffffffffc020378c:	07100593          	li	a1,113
ffffffffc0203790:	00003517          	auipc	a0,0x3
ffffffffc0203794:	bb850513          	addi	a0,a0,-1096 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0203798:	cf7fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020379c:	86b2                	mv	a3,a2
ffffffffc020379e:	07100593          	li	a1,113
ffffffffc02037a2:	00003617          	auipc	a2,0x3
ffffffffc02037a6:	bee60613          	addi	a2,a2,-1042 # ffffffffc0206390 <commands+0x820>
ffffffffc02037aa:	00003517          	auipc	a0,0x3
ffffffffc02037ae:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0206348 <commands+0x7d8>
ffffffffc02037b2:	cddfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02037b6:	00003697          	auipc	a3,0x3
ffffffffc02037ba:	0fa68693          	addi	a3,a3,250 # ffffffffc02068b0 <default_pmm_manager+0xe0>
ffffffffc02037be:	00003617          	auipc	a2,0x3
ffffffffc02037c2:	c6260613          	addi	a2,a2,-926 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02037c6:	17b00593          	li	a1,379
ffffffffc02037ca:	00003517          	auipc	a0,0x3
ffffffffc02037ce:	0d650513          	addi	a0,a0,214 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc02037d2:	cbdfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02037d6 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02037d6:	12058073          	sfence.vma	a1
}
ffffffffc02037da:	8082                	ret

ffffffffc02037dc <pgdir_alloc_page>:
{
ffffffffc02037dc:	7179                	addi	sp,sp,-48
ffffffffc02037de:	ec26                	sd	s1,24(sp)
ffffffffc02037e0:	e84a                	sd	s2,16(sp)
ffffffffc02037e2:	e052                	sd	s4,0(sp)
ffffffffc02037e4:	f406                	sd	ra,40(sp)
ffffffffc02037e6:	f022                	sd	s0,32(sp)
ffffffffc02037e8:	e44e                	sd	s3,8(sp)
ffffffffc02037ea:	8a2a                	mv	s4,a0
ffffffffc02037ec:	84ae                	mv	s1,a1
ffffffffc02037ee:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02037f0:	100027f3          	csrr	a5,sstatus
ffffffffc02037f4:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02037f6:	000d0997          	auipc	s3,0xd0
ffffffffc02037fa:	b8a98993          	addi	s3,s3,-1142 # ffffffffc02d3380 <pmm_manager>
ffffffffc02037fe:	ef8d                	bnez	a5,ffffffffc0203838 <pgdir_alloc_page+0x5c>
ffffffffc0203800:	0009b783          	ld	a5,0(s3)
ffffffffc0203804:	4505                	li	a0,1
ffffffffc0203806:	6f9c                	ld	a5,24(a5)
ffffffffc0203808:	9782                	jalr	a5
ffffffffc020380a:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc020380c:	cc09                	beqz	s0,ffffffffc0203826 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020380e:	86ca                	mv	a3,s2
ffffffffc0203810:	8626                	mv	a2,s1
ffffffffc0203812:	85a2                	mv	a1,s0
ffffffffc0203814:	8552                	mv	a0,s4
ffffffffc0203816:	fe7fe0ef          	jal	ra,ffffffffc02027fc <page_insert>
ffffffffc020381a:	e915                	bnez	a0,ffffffffc020384e <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc020381c:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc020381e:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203820:	4785                	li	a5,1
ffffffffc0203822:	04f71e63          	bne	a4,a5,ffffffffc020387e <pgdir_alloc_page+0xa2>
}
ffffffffc0203826:	70a2                	ld	ra,40(sp)
ffffffffc0203828:	8522                	mv	a0,s0
ffffffffc020382a:	7402                	ld	s0,32(sp)
ffffffffc020382c:	64e2                	ld	s1,24(sp)
ffffffffc020382e:	6942                	ld	s2,16(sp)
ffffffffc0203830:	69a2                	ld	s3,8(sp)
ffffffffc0203832:	6a02                	ld	s4,0(sp)
ffffffffc0203834:	6145                	addi	sp,sp,48
ffffffffc0203836:	8082                	ret
        intr_disable();
ffffffffc0203838:	97cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020383c:	0009b783          	ld	a5,0(s3)
ffffffffc0203840:	4505                	li	a0,1
ffffffffc0203842:	6f9c                	ld	a5,24(a5)
ffffffffc0203844:	9782                	jalr	a5
ffffffffc0203846:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203848:	966fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020384c:	b7c1                	j	ffffffffc020380c <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020384e:	100027f3          	csrr	a5,sstatus
ffffffffc0203852:	8b89                	andi	a5,a5,2
ffffffffc0203854:	eb89                	bnez	a5,ffffffffc0203866 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203856:	0009b783          	ld	a5,0(s3)
ffffffffc020385a:	8522                	mv	a0,s0
ffffffffc020385c:	4585                	li	a1,1
ffffffffc020385e:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203860:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203862:	9782                	jalr	a5
    if (flag)
ffffffffc0203864:	b7c9                	j	ffffffffc0203826 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203866:	94efd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020386a:	0009b783          	ld	a5,0(s3)
ffffffffc020386e:	8522                	mv	a0,s0
ffffffffc0203870:	4585                	li	a1,1
ffffffffc0203872:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203874:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203876:	9782                	jalr	a5
        intr_enable();
ffffffffc0203878:	936fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020387c:	b76d                	j	ffffffffc0203826 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc020387e:	00003697          	auipc	a3,0x3
ffffffffc0203882:	63268693          	addi	a3,a3,1586 # ffffffffc0206eb0 <default_pmm_manager+0x6e0>
ffffffffc0203886:	00003617          	auipc	a2,0x3
ffffffffc020388a:	b9a60613          	addi	a2,a2,-1126 # ffffffffc0206420 <commands+0x8b0>
ffffffffc020388e:	20100593          	li	a1,513
ffffffffc0203892:	00003517          	auipc	a0,0x3
ffffffffc0203896:	00e50513          	addi	a0,a0,14 # ffffffffc02068a0 <default_pmm_manager+0xd0>
ffffffffc020389a:	bf5fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020389e <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020389e:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02038a0:	00003697          	auipc	a3,0x3
ffffffffc02038a4:	62868693          	addi	a3,a3,1576 # ffffffffc0206ec8 <default_pmm_manager+0x6f8>
ffffffffc02038a8:	00003617          	auipc	a2,0x3
ffffffffc02038ac:	b7860613          	addi	a2,a2,-1160 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02038b0:	07400593          	li	a1,116
ffffffffc02038b4:	00003517          	auipc	a0,0x3
ffffffffc02038b8:	63450513          	addi	a0,a0,1588 # ffffffffc0206ee8 <default_pmm_manager+0x718>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02038bc:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02038be:	bd1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038c2 <mm_create>:
{
ffffffffc02038c2:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038c4:	04000513          	li	a0,64
{
ffffffffc02038c8:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038ca:	dacfe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
    if (mm != NULL)
ffffffffc02038ce:	cd19                	beqz	a0,ffffffffc02038ec <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02038d0:	e508                	sd	a0,8(a0)
ffffffffc02038d2:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02038d4:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02038d8:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02038dc:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02038e0:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02038e4:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02038e8:	02053c23          	sd	zero,56(a0)
}
ffffffffc02038ec:	60a2                	ld	ra,8(sp)
ffffffffc02038ee:	0141                	addi	sp,sp,16
ffffffffc02038f0:	8082                	ret

ffffffffc02038f2 <find_vma>:
{
ffffffffc02038f2:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02038f4:	c505                	beqz	a0,ffffffffc020391c <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02038f6:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02038f8:	c501                	beqz	a0,ffffffffc0203900 <find_vma+0xe>
ffffffffc02038fa:	651c                	ld	a5,8(a0)
ffffffffc02038fc:	02f5f263          	bgeu	a1,a5,ffffffffc0203920 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203900:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203902:	00f68d63          	beq	a3,a5,ffffffffc020391c <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203906:	fe87b703          	ld	a4,-24(a5)
ffffffffc020390a:	00e5e663          	bltu	a1,a4,ffffffffc0203916 <find_vma+0x24>
ffffffffc020390e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203912:	00e5ec63          	bltu	a1,a4,ffffffffc020392a <find_vma+0x38>
ffffffffc0203916:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203918:	fef697e3          	bne	a3,a5,ffffffffc0203906 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020391c:	4501                	li	a0,0
}
ffffffffc020391e:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203920:	691c                	ld	a5,16(a0)
ffffffffc0203922:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203900 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203926:	ea88                	sd	a0,16(a3)
ffffffffc0203928:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020392a:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020392e:	ea88                	sd	a0,16(a3)
ffffffffc0203930:	8082                	ret

ffffffffc0203932 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203932:	6590                	ld	a2,8(a1)
ffffffffc0203934:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203938:	1141                	addi	sp,sp,-16
ffffffffc020393a:	e406                	sd	ra,8(sp)
ffffffffc020393c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020393e:	01066763          	bltu	a2,a6,ffffffffc020394c <insert_vma_struct+0x1a>
ffffffffc0203942:	a085                	j	ffffffffc02039a2 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203944:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203948:	04e66863          	bltu	a2,a4,ffffffffc0203998 <insert_vma_struct+0x66>
ffffffffc020394c:	86be                	mv	a3,a5
ffffffffc020394e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203950:	fef51ae3          	bne	a0,a5,ffffffffc0203944 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203954:	02a68463          	beq	a3,a0,ffffffffc020397c <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203958:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020395c:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203960:	08e8f163          	bgeu	a7,a4,ffffffffc02039e2 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203964:	04e66f63          	bltu	a2,a4,ffffffffc02039c2 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203968:	00f50a63          	beq	a0,a5,ffffffffc020397c <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020396c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203970:	05076963          	bltu	a4,a6,ffffffffc02039c2 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203974:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203978:	02c77363          	bgeu	a4,a2,ffffffffc020399e <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020397c:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020397e:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203980:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203984:	e390                	sd	a2,0(a5)
ffffffffc0203986:	e690                	sd	a2,8(a3)
}
ffffffffc0203988:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc020398a:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020398c:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020398e:	0017079b          	addiw	a5,a4,1
ffffffffc0203992:	d11c                	sw	a5,32(a0)
}
ffffffffc0203994:	0141                	addi	sp,sp,16
ffffffffc0203996:	8082                	ret
    if (le_prev != list)
ffffffffc0203998:	fca690e3          	bne	a3,a0,ffffffffc0203958 <insert_vma_struct+0x26>
ffffffffc020399c:	bfd1                	j	ffffffffc0203970 <insert_vma_struct+0x3e>
ffffffffc020399e:	f01ff0ef          	jal	ra,ffffffffc020389e <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02039a2:	00003697          	auipc	a3,0x3
ffffffffc02039a6:	55668693          	addi	a3,a3,1366 # ffffffffc0206ef8 <default_pmm_manager+0x728>
ffffffffc02039aa:	00003617          	auipc	a2,0x3
ffffffffc02039ae:	a7660613          	addi	a2,a2,-1418 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02039b2:	07a00593          	li	a1,122
ffffffffc02039b6:	00003517          	auipc	a0,0x3
ffffffffc02039ba:	53250513          	addi	a0,a0,1330 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc02039be:	ad1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039c2:	00003697          	auipc	a3,0x3
ffffffffc02039c6:	57668693          	addi	a3,a3,1398 # ffffffffc0206f38 <default_pmm_manager+0x768>
ffffffffc02039ca:	00003617          	auipc	a2,0x3
ffffffffc02039ce:	a5660613          	addi	a2,a2,-1450 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02039d2:	07300593          	li	a1,115
ffffffffc02039d6:	00003517          	auipc	a0,0x3
ffffffffc02039da:	51250513          	addi	a0,a0,1298 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc02039de:	ab1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02039e2:	00003697          	auipc	a3,0x3
ffffffffc02039e6:	53668693          	addi	a3,a3,1334 # ffffffffc0206f18 <default_pmm_manager+0x748>
ffffffffc02039ea:	00003617          	auipc	a2,0x3
ffffffffc02039ee:	a3660613          	addi	a2,a2,-1482 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02039f2:	07200593          	li	a1,114
ffffffffc02039f6:	00003517          	auipc	a0,0x3
ffffffffc02039fa:	4f250513          	addi	a0,a0,1266 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc02039fe:	a91fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a02 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203a02:	591c                	lw	a5,48(a0)
{
ffffffffc0203a04:	1141                	addi	sp,sp,-16
ffffffffc0203a06:	e406                	sd	ra,8(sp)
ffffffffc0203a08:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203a0a:	e78d                	bnez	a5,ffffffffc0203a34 <mm_destroy+0x32>
ffffffffc0203a0c:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203a0e:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203a10:	00a40c63          	beq	s0,a0,ffffffffc0203a28 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203a14:	6118                	ld	a4,0(a0)
ffffffffc0203a16:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203a18:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203a1a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203a1c:	e398                	sd	a4,0(a5)
ffffffffc0203a1e:	d08fe0ef          	jal	ra,ffffffffc0201f26 <kfree>
    return listelm->next;
ffffffffc0203a22:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203a24:	fea418e3          	bne	s0,a0,ffffffffc0203a14 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203a28:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203a2a:	6402                	ld	s0,0(sp)
ffffffffc0203a2c:	60a2                	ld	ra,8(sp)
ffffffffc0203a2e:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203a30:	cf6fe06f          	j	ffffffffc0201f26 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203a34:	00003697          	auipc	a3,0x3
ffffffffc0203a38:	52468693          	addi	a3,a3,1316 # ffffffffc0206f58 <default_pmm_manager+0x788>
ffffffffc0203a3c:	00003617          	auipc	a2,0x3
ffffffffc0203a40:	9e460613          	addi	a2,a2,-1564 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203a44:	09e00593          	li	a1,158
ffffffffc0203a48:	00003517          	auipc	a0,0x3
ffffffffc0203a4c:	4a050513          	addi	a0,a0,1184 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203a50:	a3ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a54 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203a54:	7139                	addi	sp,sp,-64
ffffffffc0203a56:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a58:	6405                	lui	s0,0x1
ffffffffc0203a5a:	147d                	addi	s0,s0,-1
ffffffffc0203a5c:	77fd                	lui	a5,0xfffff
ffffffffc0203a5e:	9622                	add	a2,a2,s0
ffffffffc0203a60:	962e                	add	a2,a2,a1
{
ffffffffc0203a62:	f426                	sd	s1,40(sp)
ffffffffc0203a64:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a66:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203a6a:	f04a                	sd	s2,32(sp)
ffffffffc0203a6c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a6e:	e852                	sd	s4,16(sp)
ffffffffc0203a70:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203a72:	002005b7          	lui	a1,0x200
ffffffffc0203a76:	00f67433          	and	s0,a2,a5
ffffffffc0203a7a:	06b4e363          	bltu	s1,a1,ffffffffc0203ae0 <mm_map+0x8c>
ffffffffc0203a7e:	0684f163          	bgeu	s1,s0,ffffffffc0203ae0 <mm_map+0x8c>
ffffffffc0203a82:	4785                	li	a5,1
ffffffffc0203a84:	07fe                	slli	a5,a5,0x1f
ffffffffc0203a86:	0487ed63          	bltu	a5,s0,ffffffffc0203ae0 <mm_map+0x8c>
ffffffffc0203a8a:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203a8c:	cd21                	beqz	a0,ffffffffc0203ae4 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203a8e:	85a6                	mv	a1,s1
ffffffffc0203a90:	8ab6                	mv	s5,a3
ffffffffc0203a92:	8a3a                	mv	s4,a4
ffffffffc0203a94:	e5fff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
ffffffffc0203a98:	c501                	beqz	a0,ffffffffc0203aa0 <mm_map+0x4c>
ffffffffc0203a9a:	651c                	ld	a5,8(a0)
ffffffffc0203a9c:	0487e263          	bltu	a5,s0,ffffffffc0203ae0 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203aa0:	03000513          	li	a0,48
ffffffffc0203aa4:	bd2fe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
ffffffffc0203aa8:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203aaa:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203aac:	02090163          	beqz	s2,ffffffffc0203ace <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203ab0:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203ab2:	00993423          	sd	s1,8(s2) # 1008 <_binary_obj___user_faultread_out_size-0x8bb8>
        vma->vm_end = vm_end;
ffffffffc0203ab6:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203aba:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203abe:	85ca                	mv	a1,s2
ffffffffc0203ac0:	e73ff0ef          	jal	ra,ffffffffc0203932 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203ac4:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203ac6:	000a0463          	beqz	s4,ffffffffc0203ace <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203aca:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0203ace:	70e2                	ld	ra,56(sp)
ffffffffc0203ad0:	7442                	ld	s0,48(sp)
ffffffffc0203ad2:	74a2                	ld	s1,40(sp)
ffffffffc0203ad4:	7902                	ld	s2,32(sp)
ffffffffc0203ad6:	69e2                	ld	s3,24(sp)
ffffffffc0203ad8:	6a42                	ld	s4,16(sp)
ffffffffc0203ada:	6aa2                	ld	s5,8(sp)
ffffffffc0203adc:	6121                	addi	sp,sp,64
ffffffffc0203ade:	8082                	ret
        return -E_INVAL;
ffffffffc0203ae0:	5575                	li	a0,-3
ffffffffc0203ae2:	b7f5                	j	ffffffffc0203ace <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203ae4:	00003697          	auipc	a3,0x3
ffffffffc0203ae8:	48c68693          	addi	a3,a3,1164 # ffffffffc0206f70 <default_pmm_manager+0x7a0>
ffffffffc0203aec:	00003617          	auipc	a2,0x3
ffffffffc0203af0:	93460613          	addi	a2,a2,-1740 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203af4:	0b300593          	li	a1,179
ffffffffc0203af8:	00003517          	auipc	a0,0x3
ffffffffc0203afc:	3f050513          	addi	a0,a0,1008 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203b00:	98ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b04 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203b04:	7139                	addi	sp,sp,-64
ffffffffc0203b06:	fc06                	sd	ra,56(sp)
ffffffffc0203b08:	f822                	sd	s0,48(sp)
ffffffffc0203b0a:	f426                	sd	s1,40(sp)
ffffffffc0203b0c:	f04a                	sd	s2,32(sp)
ffffffffc0203b0e:	ec4e                	sd	s3,24(sp)
ffffffffc0203b10:	e852                	sd	s4,16(sp)
ffffffffc0203b12:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203b14:	c52d                	beqz	a0,ffffffffc0203b7e <dup_mmap+0x7a>
ffffffffc0203b16:	892a                	mv	s2,a0
ffffffffc0203b18:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203b1a:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203b1c:	e595                	bnez	a1,ffffffffc0203b48 <dup_mmap+0x44>
ffffffffc0203b1e:	a085                	j	ffffffffc0203b7e <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203b20:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203b22:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ed0>
        vma->vm_end = vm_end;
ffffffffc0203b26:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203b2a:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203b2e:	e05ff0ef          	jal	ra,ffffffffc0203932 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203b32:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bd0>
ffffffffc0203b36:	fe843603          	ld	a2,-24(s0)
ffffffffc0203b3a:	6c8c                	ld	a1,24(s1)
ffffffffc0203b3c:	01893503          	ld	a0,24(s2)
ffffffffc0203b40:	4701                	li	a4,0
ffffffffc0203b42:	9f1ff0ef          	jal	ra,ffffffffc0203532 <copy_range>
ffffffffc0203b46:	e105                	bnez	a0,ffffffffc0203b66 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203b48:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203b4a:	02848863          	beq	s1,s0,ffffffffc0203b7a <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b4e:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203b52:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203b56:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203b5a:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b5e:	b18fe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
ffffffffc0203b62:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203b64:	fd55                	bnez	a0,ffffffffc0203b20 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203b66:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203b68:	70e2                	ld	ra,56(sp)
ffffffffc0203b6a:	7442                	ld	s0,48(sp)
ffffffffc0203b6c:	74a2                	ld	s1,40(sp)
ffffffffc0203b6e:	7902                	ld	s2,32(sp)
ffffffffc0203b70:	69e2                	ld	s3,24(sp)
ffffffffc0203b72:	6a42                	ld	s4,16(sp)
ffffffffc0203b74:	6aa2                	ld	s5,8(sp)
ffffffffc0203b76:	6121                	addi	sp,sp,64
ffffffffc0203b78:	8082                	ret
    return 0;
ffffffffc0203b7a:	4501                	li	a0,0
ffffffffc0203b7c:	b7f5                	j	ffffffffc0203b68 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203b7e:	00003697          	auipc	a3,0x3
ffffffffc0203b82:	40268693          	addi	a3,a3,1026 # ffffffffc0206f80 <default_pmm_manager+0x7b0>
ffffffffc0203b86:	00003617          	auipc	a2,0x3
ffffffffc0203b8a:	89a60613          	addi	a2,a2,-1894 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203b8e:	0cf00593          	li	a1,207
ffffffffc0203b92:	00003517          	auipc	a0,0x3
ffffffffc0203b96:	35650513          	addi	a0,a0,854 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203b9a:	8f5fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b9e <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203b9e:	1101                	addi	sp,sp,-32
ffffffffc0203ba0:	ec06                	sd	ra,24(sp)
ffffffffc0203ba2:	e822                	sd	s0,16(sp)
ffffffffc0203ba4:	e426                	sd	s1,8(sp)
ffffffffc0203ba6:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203ba8:	c531                	beqz	a0,ffffffffc0203bf4 <exit_mmap+0x56>
ffffffffc0203baa:	591c                	lw	a5,48(a0)
ffffffffc0203bac:	84aa                	mv	s1,a0
ffffffffc0203bae:	e3b9                	bnez	a5,ffffffffc0203bf4 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203bb0:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203bb2:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203bb6:	02850663          	beq	a0,s0,ffffffffc0203be2 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bba:	ff043603          	ld	a2,-16(s0)
ffffffffc0203bbe:	fe843583          	ld	a1,-24(s0)
ffffffffc0203bc2:	854a                	mv	a0,s2
ffffffffc0203bc4:	fc4fe0ef          	jal	ra,ffffffffc0202388 <unmap_range>
ffffffffc0203bc8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203bca:	fe8498e3          	bne	s1,s0,ffffffffc0203bba <exit_mmap+0x1c>
ffffffffc0203bce:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203bd0:	00848c63          	beq	s1,s0,ffffffffc0203be8 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bd4:	ff043603          	ld	a2,-16(s0)
ffffffffc0203bd8:	fe843583          	ld	a1,-24(s0)
ffffffffc0203bdc:	854a                	mv	a0,s2
ffffffffc0203bde:	8f1fe0ef          	jal	ra,ffffffffc02024ce <exit_range>
ffffffffc0203be2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203be4:	fe8498e3          	bne	s1,s0,ffffffffc0203bd4 <exit_mmap+0x36>
    }
}
ffffffffc0203be8:	60e2                	ld	ra,24(sp)
ffffffffc0203bea:	6442                	ld	s0,16(sp)
ffffffffc0203bec:	64a2                	ld	s1,8(sp)
ffffffffc0203bee:	6902                	ld	s2,0(sp)
ffffffffc0203bf0:	6105                	addi	sp,sp,32
ffffffffc0203bf2:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203bf4:	00003697          	auipc	a3,0x3
ffffffffc0203bf8:	3ac68693          	addi	a3,a3,940 # ffffffffc0206fa0 <default_pmm_manager+0x7d0>
ffffffffc0203bfc:	00003617          	auipc	a2,0x3
ffffffffc0203c00:	82460613          	addi	a2,a2,-2012 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203c04:	0e800593          	li	a1,232
ffffffffc0203c08:	00003517          	auipc	a0,0x3
ffffffffc0203c0c:	2e050513          	addi	a0,a0,736 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203c10:	87ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c14 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203c14:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c16:	04000513          	li	a0,64
{
ffffffffc0203c1a:	fc06                	sd	ra,56(sp)
ffffffffc0203c1c:	f822                	sd	s0,48(sp)
ffffffffc0203c1e:	f426                	sd	s1,40(sp)
ffffffffc0203c20:	f04a                	sd	s2,32(sp)
ffffffffc0203c22:	ec4e                	sd	s3,24(sp)
ffffffffc0203c24:	e852                	sd	s4,16(sp)
ffffffffc0203c26:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c28:	a4efe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
    if (mm != NULL)
ffffffffc0203c2c:	2e050663          	beqz	a0,ffffffffc0203f18 <vmm_init+0x304>
ffffffffc0203c30:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203c32:	e508                	sd	a0,8(a0)
ffffffffc0203c34:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203c36:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203c3a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203c3e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203c42:	02053423          	sd	zero,40(a0)
ffffffffc0203c46:	02052823          	sw	zero,48(a0)
ffffffffc0203c4a:	02053c23          	sd	zero,56(a0)
ffffffffc0203c4e:	03200413          	li	s0,50
ffffffffc0203c52:	a811                	j	ffffffffc0203c66 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203c54:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203c56:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203c58:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203c5c:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203c5e:	8526                	mv	a0,s1
ffffffffc0203c60:	cd3ff0ef          	jal	ra,ffffffffc0203932 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203c64:	c80d                	beqz	s0,ffffffffc0203c96 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c66:	03000513          	li	a0,48
ffffffffc0203c6a:	a0cfe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
ffffffffc0203c6e:	85aa                	mv	a1,a0
ffffffffc0203c70:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203c74:	f165                	bnez	a0,ffffffffc0203c54 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203c76:	00003697          	auipc	a3,0x3
ffffffffc0203c7a:	4c268693          	addi	a3,a3,1218 # ffffffffc0207138 <default_pmm_manager+0x968>
ffffffffc0203c7e:	00002617          	auipc	a2,0x2
ffffffffc0203c82:	7a260613          	addi	a2,a2,1954 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203c86:	12c00593          	li	a1,300
ffffffffc0203c8a:	00003517          	auipc	a0,0x3
ffffffffc0203c8e:	25e50513          	addi	a0,a0,606 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203c92:	ffcfc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203c96:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203c9a:	1f900913          	li	s2,505
ffffffffc0203c9e:	a819                	j	ffffffffc0203cb4 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203ca0:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203ca2:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203ca4:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ca8:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203caa:	8526                	mv	a0,s1
ffffffffc0203cac:	c87ff0ef          	jal	ra,ffffffffc0203932 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cb0:	03240a63          	beq	s0,s2,ffffffffc0203ce4 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203cb4:	03000513          	li	a0,48
ffffffffc0203cb8:	9befe0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
ffffffffc0203cbc:	85aa                	mv	a1,a0
ffffffffc0203cbe:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203cc2:	fd79                	bnez	a0,ffffffffc0203ca0 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203cc4:	00003697          	auipc	a3,0x3
ffffffffc0203cc8:	47468693          	addi	a3,a3,1140 # ffffffffc0207138 <default_pmm_manager+0x968>
ffffffffc0203ccc:	00002617          	auipc	a2,0x2
ffffffffc0203cd0:	75460613          	addi	a2,a2,1876 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203cd4:	13300593          	li	a1,307
ffffffffc0203cd8:	00003517          	auipc	a0,0x3
ffffffffc0203cdc:	21050513          	addi	a0,a0,528 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203ce0:	faefc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203ce4:	649c                	ld	a5,8(s1)
ffffffffc0203ce6:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203ce8:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203cec:	16f48663          	beq	s1,a5,ffffffffc0203e58 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203cf0:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd2bc3c>
ffffffffc0203cf4:	ffe70693          	addi	a3,a4,-2 # 1ffffe <_binary_obj___user_exit_out_size+0x1f4ec6>
ffffffffc0203cf8:	10d61063          	bne	a2,a3,ffffffffc0203df8 <vmm_init+0x1e4>
ffffffffc0203cfc:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203d00:	0ed71c63          	bne	a4,a3,ffffffffc0203df8 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203d04:	0715                	addi	a4,a4,5
ffffffffc0203d06:	679c                	ld	a5,8(a5)
ffffffffc0203d08:	feb712e3          	bne	a4,a1,ffffffffc0203cec <vmm_init+0xd8>
ffffffffc0203d0c:	4a1d                	li	s4,7
ffffffffc0203d0e:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d10:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203d14:	85a2                	mv	a1,s0
ffffffffc0203d16:	8526                	mv	a0,s1
ffffffffc0203d18:	bdbff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
ffffffffc0203d1c:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203d1e:	16050d63          	beqz	a0,ffffffffc0203e98 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203d22:	00140593          	addi	a1,s0,1
ffffffffc0203d26:	8526                	mv	a0,s1
ffffffffc0203d28:	bcbff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
ffffffffc0203d2c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203d2e:	14050563          	beqz	a0,ffffffffc0203e78 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203d32:	85d2                	mv	a1,s4
ffffffffc0203d34:	8526                	mv	a0,s1
ffffffffc0203d36:	bbdff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203d3a:	16051f63          	bnez	a0,ffffffffc0203eb8 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203d3e:	00340593          	addi	a1,s0,3
ffffffffc0203d42:	8526                	mv	a0,s1
ffffffffc0203d44:	bafff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203d48:	1a051863          	bnez	a0,ffffffffc0203ef8 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203d4c:	00440593          	addi	a1,s0,4
ffffffffc0203d50:	8526                	mv	a0,s1
ffffffffc0203d52:	ba1ff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203d56:	18051163          	bnez	a0,ffffffffc0203ed8 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d5a:	00893783          	ld	a5,8(s2)
ffffffffc0203d5e:	0a879d63          	bne	a5,s0,ffffffffc0203e18 <vmm_init+0x204>
ffffffffc0203d62:	01093783          	ld	a5,16(s2)
ffffffffc0203d66:	0b479963          	bne	a5,s4,ffffffffc0203e18 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203d6a:	0089b783          	ld	a5,8(s3)
ffffffffc0203d6e:	0c879563          	bne	a5,s0,ffffffffc0203e38 <vmm_init+0x224>
ffffffffc0203d72:	0109b783          	ld	a5,16(s3)
ffffffffc0203d76:	0d479163          	bne	a5,s4,ffffffffc0203e38 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d7a:	0415                	addi	s0,s0,5
ffffffffc0203d7c:	0a15                	addi	s4,s4,5
ffffffffc0203d7e:	f9541be3          	bne	s0,s5,ffffffffc0203d14 <vmm_init+0x100>
ffffffffc0203d82:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203d84:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203d86:	85a2                	mv	a1,s0
ffffffffc0203d88:	8526                	mv	a0,s1
ffffffffc0203d8a:	b69ff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
ffffffffc0203d8e:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203d92:	c90d                	beqz	a0,ffffffffc0203dc4 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203d94:	6914                	ld	a3,16(a0)
ffffffffc0203d96:	6510                	ld	a2,8(a0)
ffffffffc0203d98:	00003517          	auipc	a0,0x3
ffffffffc0203d9c:	32850513          	addi	a0,a0,808 # ffffffffc02070c0 <default_pmm_manager+0x8f0>
ffffffffc0203da0:	bf4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203da4:	00003697          	auipc	a3,0x3
ffffffffc0203da8:	34468693          	addi	a3,a3,836 # ffffffffc02070e8 <default_pmm_manager+0x918>
ffffffffc0203dac:	00002617          	auipc	a2,0x2
ffffffffc0203db0:	67460613          	addi	a2,a2,1652 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203db4:	15900593          	li	a1,345
ffffffffc0203db8:	00003517          	auipc	a0,0x3
ffffffffc0203dbc:	13050513          	addi	a0,a0,304 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203dc0:	ecefc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203dc4:	147d                	addi	s0,s0,-1
ffffffffc0203dc6:	fd2410e3          	bne	s0,s2,ffffffffc0203d86 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203dca:	8526                	mv	a0,s1
ffffffffc0203dcc:	c37ff0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203dd0:	00003517          	auipc	a0,0x3
ffffffffc0203dd4:	33050513          	addi	a0,a0,816 # ffffffffc0207100 <default_pmm_manager+0x930>
ffffffffc0203dd8:	bbcfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203ddc:	7442                	ld	s0,48(sp)
ffffffffc0203dde:	70e2                	ld	ra,56(sp)
ffffffffc0203de0:	74a2                	ld	s1,40(sp)
ffffffffc0203de2:	7902                	ld	s2,32(sp)
ffffffffc0203de4:	69e2                	ld	s3,24(sp)
ffffffffc0203de6:	6a42                	ld	s4,16(sp)
ffffffffc0203de8:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203dea:	00003517          	auipc	a0,0x3
ffffffffc0203dee:	33650513          	addi	a0,a0,822 # ffffffffc0207120 <default_pmm_manager+0x950>
}
ffffffffc0203df2:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203df4:	ba0fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203df8:	00003697          	auipc	a3,0x3
ffffffffc0203dfc:	1e068693          	addi	a3,a3,480 # ffffffffc0206fd8 <default_pmm_manager+0x808>
ffffffffc0203e00:	00002617          	auipc	a2,0x2
ffffffffc0203e04:	62060613          	addi	a2,a2,1568 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203e08:	13d00593          	li	a1,317
ffffffffc0203e0c:	00003517          	auipc	a0,0x3
ffffffffc0203e10:	0dc50513          	addi	a0,a0,220 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203e14:	e7afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203e18:	00003697          	auipc	a3,0x3
ffffffffc0203e1c:	24868693          	addi	a3,a3,584 # ffffffffc0207060 <default_pmm_manager+0x890>
ffffffffc0203e20:	00002617          	auipc	a2,0x2
ffffffffc0203e24:	60060613          	addi	a2,a2,1536 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203e28:	14e00593          	li	a1,334
ffffffffc0203e2c:	00003517          	auipc	a0,0x3
ffffffffc0203e30:	0bc50513          	addi	a0,a0,188 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203e34:	e5afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203e38:	00003697          	auipc	a3,0x3
ffffffffc0203e3c:	25868693          	addi	a3,a3,600 # ffffffffc0207090 <default_pmm_manager+0x8c0>
ffffffffc0203e40:	00002617          	auipc	a2,0x2
ffffffffc0203e44:	5e060613          	addi	a2,a2,1504 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203e48:	14f00593          	li	a1,335
ffffffffc0203e4c:	00003517          	auipc	a0,0x3
ffffffffc0203e50:	09c50513          	addi	a0,a0,156 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203e54:	e3afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203e58:	00003697          	auipc	a3,0x3
ffffffffc0203e5c:	16868693          	addi	a3,a3,360 # ffffffffc0206fc0 <default_pmm_manager+0x7f0>
ffffffffc0203e60:	00002617          	auipc	a2,0x2
ffffffffc0203e64:	5c060613          	addi	a2,a2,1472 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203e68:	13b00593          	li	a1,315
ffffffffc0203e6c:	00003517          	auipc	a0,0x3
ffffffffc0203e70:	07c50513          	addi	a0,a0,124 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203e74:	e1afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203e78:	00003697          	auipc	a3,0x3
ffffffffc0203e7c:	1a868693          	addi	a3,a3,424 # ffffffffc0207020 <default_pmm_manager+0x850>
ffffffffc0203e80:	00002617          	auipc	a2,0x2
ffffffffc0203e84:	5a060613          	addi	a2,a2,1440 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203e88:	14600593          	li	a1,326
ffffffffc0203e8c:	00003517          	auipc	a0,0x3
ffffffffc0203e90:	05c50513          	addi	a0,a0,92 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203e94:	dfafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203e98:	00003697          	auipc	a3,0x3
ffffffffc0203e9c:	17868693          	addi	a3,a3,376 # ffffffffc0207010 <default_pmm_manager+0x840>
ffffffffc0203ea0:	00002617          	auipc	a2,0x2
ffffffffc0203ea4:	58060613          	addi	a2,a2,1408 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203ea8:	14400593          	li	a1,324
ffffffffc0203eac:	00003517          	auipc	a0,0x3
ffffffffc0203eb0:	03c50513          	addi	a0,a0,60 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203eb4:	ddafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203eb8:	00003697          	auipc	a3,0x3
ffffffffc0203ebc:	17868693          	addi	a3,a3,376 # ffffffffc0207030 <default_pmm_manager+0x860>
ffffffffc0203ec0:	00002617          	auipc	a2,0x2
ffffffffc0203ec4:	56060613          	addi	a2,a2,1376 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203ec8:	14800593          	li	a1,328
ffffffffc0203ecc:	00003517          	auipc	a0,0x3
ffffffffc0203ed0:	01c50513          	addi	a0,a0,28 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203ed4:	dbafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203ed8:	00003697          	auipc	a3,0x3
ffffffffc0203edc:	17868693          	addi	a3,a3,376 # ffffffffc0207050 <default_pmm_manager+0x880>
ffffffffc0203ee0:	00002617          	auipc	a2,0x2
ffffffffc0203ee4:	54060613          	addi	a2,a2,1344 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203ee8:	14c00593          	li	a1,332
ffffffffc0203eec:	00003517          	auipc	a0,0x3
ffffffffc0203ef0:	ffc50513          	addi	a0,a0,-4 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203ef4:	d9afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203ef8:	00003697          	auipc	a3,0x3
ffffffffc0203efc:	14868693          	addi	a3,a3,328 # ffffffffc0207040 <default_pmm_manager+0x870>
ffffffffc0203f00:	00002617          	auipc	a2,0x2
ffffffffc0203f04:	52060613          	addi	a2,a2,1312 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203f08:	14a00593          	li	a1,330
ffffffffc0203f0c:	00003517          	auipc	a0,0x3
ffffffffc0203f10:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203f14:	d7afc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203f18:	00003697          	auipc	a3,0x3
ffffffffc0203f1c:	05868693          	addi	a3,a3,88 # ffffffffc0206f70 <default_pmm_manager+0x7a0>
ffffffffc0203f20:	00002617          	auipc	a2,0x2
ffffffffc0203f24:	50060613          	addi	a2,a2,1280 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0203f28:	12400593          	li	a1,292
ffffffffc0203f2c:	00003517          	auipc	a0,0x3
ffffffffc0203f30:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206ee8 <default_pmm_manager+0x718>
ffffffffc0203f34:	d5afc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f38 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203f38:	7179                	addi	sp,sp,-48
ffffffffc0203f3a:	f022                	sd	s0,32(sp)
ffffffffc0203f3c:	f406                	sd	ra,40(sp)
ffffffffc0203f3e:	ec26                	sd	s1,24(sp)
ffffffffc0203f40:	e84a                	sd	s2,16(sp)
ffffffffc0203f42:	e44e                	sd	s3,8(sp)
ffffffffc0203f44:	e052                	sd	s4,0(sp)
ffffffffc0203f46:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203f48:	c135                	beqz	a0,ffffffffc0203fac <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203f4a:	002007b7          	lui	a5,0x200
ffffffffc0203f4e:	04f5e663          	bltu	a1,a5,ffffffffc0203f9a <user_mem_check+0x62>
ffffffffc0203f52:	00c584b3          	add	s1,a1,a2
ffffffffc0203f56:	0495f263          	bgeu	a1,s1,ffffffffc0203f9a <user_mem_check+0x62>
ffffffffc0203f5a:	4785                	li	a5,1
ffffffffc0203f5c:	07fe                	slli	a5,a5,0x1f
ffffffffc0203f5e:	0297ee63          	bltu	a5,s1,ffffffffc0203f9a <user_mem_check+0x62>
ffffffffc0203f62:	892a                	mv	s2,a0
ffffffffc0203f64:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f66:	6a05                	lui	s4,0x1
ffffffffc0203f68:	a821                	j	ffffffffc0203f80 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f6a:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f6e:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203f70:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f72:	c685                	beqz	a3,ffffffffc0203f9a <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203f74:	c399                	beqz	a5,ffffffffc0203f7a <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f76:	02e46263          	bltu	s0,a4,ffffffffc0203f9a <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203f7a:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203f7c:	04947663          	bgeu	s0,s1,ffffffffc0203fc8 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203f80:	85a2                	mv	a1,s0
ffffffffc0203f82:	854a                	mv	a0,s2
ffffffffc0203f84:	96fff0ef          	jal	ra,ffffffffc02038f2 <find_vma>
ffffffffc0203f88:	c909                	beqz	a0,ffffffffc0203f9a <user_mem_check+0x62>
ffffffffc0203f8a:	6518                	ld	a4,8(a0)
ffffffffc0203f8c:	00e46763          	bltu	s0,a4,ffffffffc0203f9a <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f90:	4d1c                	lw	a5,24(a0)
ffffffffc0203f92:	fc099ce3          	bnez	s3,ffffffffc0203f6a <user_mem_check+0x32>
ffffffffc0203f96:	8b85                	andi	a5,a5,1
ffffffffc0203f98:	f3ed                	bnez	a5,ffffffffc0203f7a <user_mem_check+0x42>
            return 0;
ffffffffc0203f9a:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203f9c:	70a2                	ld	ra,40(sp)
ffffffffc0203f9e:	7402                	ld	s0,32(sp)
ffffffffc0203fa0:	64e2                	ld	s1,24(sp)
ffffffffc0203fa2:	6942                	ld	s2,16(sp)
ffffffffc0203fa4:	69a2                	ld	s3,8(sp)
ffffffffc0203fa6:	6a02                	ld	s4,0(sp)
ffffffffc0203fa8:	6145                	addi	sp,sp,48
ffffffffc0203faa:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fac:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fb0:	4501                	li	a0,0
ffffffffc0203fb2:	fef5e5e3          	bltu	a1,a5,ffffffffc0203f9c <user_mem_check+0x64>
ffffffffc0203fb6:	962e                	add	a2,a2,a1
ffffffffc0203fb8:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203f9c <user_mem_check+0x64>
ffffffffc0203fbc:	c8000537          	lui	a0,0xc8000
ffffffffc0203fc0:	0505                	addi	a0,a0,1
ffffffffc0203fc2:	00a63533          	sltu	a0,a2,a0
ffffffffc0203fc6:	bfd9                	j	ffffffffc0203f9c <user_mem_check+0x64>
        return 1;
ffffffffc0203fc8:	4505                	li	a0,1
ffffffffc0203fca:	bfc9                	j	ffffffffc0203f9c <user_mem_check+0x64>

ffffffffc0203fcc <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203fcc:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203fce:	9402                	jalr	s0

	jal do_exit
ffffffffc0203fd0:	63e000ef          	jal	ra,ffffffffc020460e <do_exit>

ffffffffc0203fd4 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203fd4:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203fd6:	10800513          	li	a0,264
{
ffffffffc0203fda:	e022                	sd	s0,0(sp)
ffffffffc0203fdc:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203fde:	e99fd0ef          	jal	ra,ffffffffc0201e76 <kmalloc>
ffffffffc0203fe2:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203fe4:	c929                	beqz	a0,ffffffffc0204036 <alloc_proc+0x62>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 初始化进程状态为未初始化
        proc->state = PROC_UNINIT;
ffffffffc0203fe6:	57fd                	li	a5,-1
ffffffffc0203fe8:	1782                	slli	a5,a5,0x20
ffffffffc0203fea:	e11c                	sd	a5,0(a0)
        // 初始化父进程指针为NULL
        proc->parent = NULL;
        // 初始化内存管理结构为NULL
        proc->mm = NULL;
        // 初始化上下文结构（全部设为0）
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203fec:	07000613          	li	a2,112
ffffffffc0203ff0:	4581                	li	a1,0
        proc->pgdir = 0;//turned into uninit status     
ffffffffc0203ff2:	0a053423          	sd	zero,168(a0) # ffffffffc80000a8 <end+0x7d2ccfc>
        proc->runs = 0;
ffffffffc0203ff6:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203ffa:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203ffe:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0204002:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0204006:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020400a:	03050513          	addi	a0,a0,48
ffffffffc020400e:	0cd010ef          	jal	ra,ffffffffc02058da <memset>
        // 初始化陷阱帧指针为NULL
        proc->tf = NULL;
        // 初始化进程标志为0
        proc->flags = 0;
        // 初始化进程名称为空字符串
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0204012:	4641                	li	a2,16
        proc->tf = NULL;
ffffffffc0204014:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0204018:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc020401c:	4581                	li	a1,0
ffffffffc020401e:	0b440513          	addi	a0,s0,180
ffffffffc0204022:	0b9010ef          	jal	ra,ffffffffc02058da <memset>
        // 初始化等待状态为0
        proc->wait_state = 0;
ffffffffc0204026:	0e042623          	sw	zero,236(s0)
        // 初始化进程关系指针为NULL
        proc->cptr = NULL;
ffffffffc020402a:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc020402e:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0204032:	0e043c23          	sd	zero,248(s0)
    }
    return proc;
}
ffffffffc0204036:	60a2                	ld	ra,8(sp)
ffffffffc0204038:	8522                	mv	a0,s0
ffffffffc020403a:	6402                	ld	s0,0(sp)
ffffffffc020403c:	0141                	addi	sp,sp,16
ffffffffc020403e:	8082                	ret

ffffffffc0204040 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204040:	000cf797          	auipc	a5,0xcf
ffffffffc0204044:	3507b783          	ld	a5,848(a5) # ffffffffc02d3390 <current>
ffffffffc0204048:	73c8                	ld	a0,160(a5)
ffffffffc020404a:	8a0fd06f          	j	ffffffffc02010ea <forkrets>

ffffffffc020404e <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020404e:	000cf797          	auipc	a5,0xcf
ffffffffc0204052:	3427b783          	ld	a5,834(a5) # ffffffffc02d3390 <current>
ffffffffc0204056:	43cc                	lw	a1,4(a5)
{
ffffffffc0204058:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020405a:	00003617          	auipc	a2,0x3
ffffffffc020405e:	0ee60613          	addi	a2,a2,238 # ffffffffc0207148 <default_pmm_manager+0x978>
ffffffffc0204062:	00003517          	auipc	a0,0x3
ffffffffc0204066:	0f650513          	addi	a0,a0,246 # ffffffffc0207158 <default_pmm_manager+0x988>
{
ffffffffc020406a:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020406c:	928fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0204070:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0204074:	91078793          	addi	a5,a5,-1776 # a980 <_binary_obj___user_forktest_out_size>
ffffffffc0204078:	e43e                	sd	a5,8(sp)
ffffffffc020407a:	00003517          	auipc	a0,0x3
ffffffffc020407e:	0ce50513          	addi	a0,a0,206 # ffffffffc0207148 <default_pmm_manager+0x978>
ffffffffc0204082:	0006e797          	auipc	a5,0x6e
ffffffffc0204086:	1f678793          	addi	a5,a5,502 # ffffffffc0272278 <_binary_obj___user_forktest_out_start>
ffffffffc020408a:	f03e                	sd	a5,32(sp)
ffffffffc020408c:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc020408e:	e802                	sd	zero,16(sp)
ffffffffc0204090:	7a8010ef          	jal	ra,ffffffffc0205838 <strlen>
ffffffffc0204094:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204096:	4511                	li	a0,4
ffffffffc0204098:	55a2                	lw	a1,40(sp)
ffffffffc020409a:	4662                	lw	a2,24(sp)
ffffffffc020409c:	5682                	lw	a3,32(sp)
ffffffffc020409e:	4722                	lw	a4,8(sp)
ffffffffc02040a0:	48a9                	li	a7,10
ffffffffc02040a2:	9002                	ebreak
ffffffffc02040a4:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02040a6:	65c2                	ld	a1,16(sp)
ffffffffc02040a8:	00003517          	auipc	a0,0x3
ffffffffc02040ac:	0d850513          	addi	a0,a0,216 # ffffffffc0207180 <default_pmm_manager+0x9b0>
ffffffffc02040b0:	8e4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc02040b4:	00003617          	auipc	a2,0x3
ffffffffc02040b8:	0dc60613          	addi	a2,a2,220 # ffffffffc0207190 <default_pmm_manager+0x9c0>
ffffffffc02040bc:	43a00593          	li	a1,1082
ffffffffc02040c0:	00003517          	auipc	a0,0x3
ffffffffc02040c4:	0f050513          	addi	a0,a0,240 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02040c8:	bc6fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02040cc <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02040cc:	6d14                	ld	a3,24(a0)
{
ffffffffc02040ce:	1141                	addi	sp,sp,-16
ffffffffc02040d0:	e406                	sd	ra,8(sp)
ffffffffc02040d2:	c02007b7          	lui	a5,0xc0200
ffffffffc02040d6:	02f6ee63          	bltu	a3,a5,ffffffffc0204112 <put_pgdir+0x46>
ffffffffc02040da:	000cf517          	auipc	a0,0xcf
ffffffffc02040de:	2ae53503          	ld	a0,686(a0) # ffffffffc02d3388 <va_pa_offset>
ffffffffc02040e2:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc02040e4:	82b1                	srli	a3,a3,0xc
ffffffffc02040e6:	000cf797          	auipc	a5,0xcf
ffffffffc02040ea:	28a7b783          	ld	a5,650(a5) # ffffffffc02d3370 <npage>
ffffffffc02040ee:	02f6fe63          	bgeu	a3,a5,ffffffffc020412a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02040f2:	00004517          	auipc	a0,0x4
ffffffffc02040f6:	96e53503          	ld	a0,-1682(a0) # ffffffffc0207a60 <nbase>
}
ffffffffc02040fa:	60a2                	ld	ra,8(sp)
ffffffffc02040fc:	8e89                	sub	a3,a3,a0
ffffffffc02040fe:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204100:	000cf517          	auipc	a0,0xcf
ffffffffc0204104:	27853503          	ld	a0,632(a0) # ffffffffc02d3378 <pages>
ffffffffc0204108:	4585                	li	a1,1
ffffffffc020410a:	9536                	add	a0,a0,a3
}
ffffffffc020410c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020410e:	f85fd06f          	j	ffffffffc0202092 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204112:	00002617          	auipc	a2,0x2
ffffffffc0204116:	76660613          	addi	a2,a2,1894 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc020411a:	07700593          	li	a1,119
ffffffffc020411e:	00002517          	auipc	a0,0x2
ffffffffc0204122:	22a50513          	addi	a0,a0,554 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0204126:	b68fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020412a:	00002617          	auipc	a2,0x2
ffffffffc020412e:	22e60613          	addi	a2,a2,558 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0204132:	06900593          	li	a1,105
ffffffffc0204136:	00002517          	auipc	a0,0x2
ffffffffc020413a:	21250513          	addi	a0,a0,530 # ffffffffc0206348 <commands+0x7d8>
ffffffffc020413e:	b50fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204142 <proc_run>:
{
ffffffffc0204142:	7179                	addi	sp,sp,-48
ffffffffc0204144:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204146:	000cf917          	auipc	s2,0xcf
ffffffffc020414a:	24a90913          	addi	s2,s2,586 # ffffffffc02d3390 <current>
{
ffffffffc020414e:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0204150:	00093483          	ld	s1,0(s2)
{
ffffffffc0204154:	f406                	sd	ra,40(sp)
ffffffffc0204156:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0204158:	02a48963          	beq	s1,a0,ffffffffc020418a <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020415c:	100027f3          	csrr	a5,sstatus
ffffffffc0204160:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204162:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204164:	e7a9                	bnez	a5,ffffffffc02041ae <proc_run+0x6c>
        if (proc->pgdir != 0) {
ffffffffc0204166:	755c                	ld	a5,168(a0)
        current = proc;
ffffffffc0204168:	00a93023          	sd	a0,0(s2)
        if (proc->pgdir != 0) {
ffffffffc020416c:	c78d                	beqz	a5,ffffffffc0204196 <proc_run+0x54>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc020416e:	577d                	li	a4,-1
ffffffffc0204170:	177e                	slli	a4,a4,0x3f
ffffffffc0204172:	83b1                	srli	a5,a5,0xc
ffffffffc0204174:	8fd9                	or	a5,a5,a4
ffffffffc0204176:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));//in switch.S,store and load some reg
ffffffffc020417a:	03050593          	addi	a1,a0,48
ffffffffc020417e:	03048513          	addi	a0,s1,48
ffffffffc0204182:	05c010ef          	jal	ra,ffffffffc02051de <switch_to>
    if (flag)
ffffffffc0204186:	00099d63          	bnez	s3,ffffffffc02041a0 <proc_run+0x5e>
}
ffffffffc020418a:	70a2                	ld	ra,40(sp)
ffffffffc020418c:	7482                	ld	s1,32(sp)
ffffffffc020418e:	6962                	ld	s2,24(sp)
ffffffffc0204190:	69c2                	ld	s3,16(sp)
ffffffffc0204192:	6145                	addi	sp,sp,48
ffffffffc0204194:	8082                	ret
ffffffffc0204196:	000cf797          	auipc	a5,0xcf
ffffffffc020419a:	1ca7b783          	ld	a5,458(a5) # ffffffffc02d3360 <boot_pgdir_pa>
ffffffffc020419e:	bfc1                	j	ffffffffc020416e <proc_run+0x2c>
ffffffffc02041a0:	70a2                	ld	ra,40(sp)
ffffffffc02041a2:	7482                	ld	s1,32(sp)
ffffffffc02041a4:	6962                	ld	s2,24(sp)
ffffffffc02041a6:	69c2                	ld	s3,16(sp)
ffffffffc02041a8:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02041aa:	805fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02041ae:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02041b0:	805fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02041b4:	6522                	ld	a0,8(sp)
ffffffffc02041b6:	4985                	li	s3,1
ffffffffc02041b8:	b77d                	j	ffffffffc0204166 <proc_run+0x24>

ffffffffc02041ba <do_fork>:
{
ffffffffc02041ba:	7119                	addi	sp,sp,-128
ffffffffc02041bc:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02041be:	000cf917          	auipc	s2,0xcf
ffffffffc02041c2:	1ea90913          	addi	s2,s2,490 # ffffffffc02d33a8 <nr_process>
ffffffffc02041c6:	00092703          	lw	a4,0(s2)
{
ffffffffc02041ca:	fc86                	sd	ra,120(sp)
ffffffffc02041cc:	f8a2                	sd	s0,112(sp)
ffffffffc02041ce:	f4a6                	sd	s1,104(sp)
ffffffffc02041d0:	ecce                	sd	s3,88(sp)
ffffffffc02041d2:	e8d2                	sd	s4,80(sp)
ffffffffc02041d4:	e4d6                	sd	s5,72(sp)
ffffffffc02041d6:	e0da                	sd	s6,64(sp)
ffffffffc02041d8:	fc5e                	sd	s7,56(sp)
ffffffffc02041da:	f862                	sd	s8,48(sp)
ffffffffc02041dc:	f466                	sd	s9,40(sp)
ffffffffc02041de:	f06a                	sd	s10,32(sp)
ffffffffc02041e0:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02041e2:	6785                	lui	a5,0x1
ffffffffc02041e4:	32f75b63          	bge	a4,a5,ffffffffc020451a <do_fork+0x360>
ffffffffc02041e8:	8a2a                	mv	s4,a0
ffffffffc02041ea:	89ae                	mv	s3,a1
ffffffffc02041ec:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02041ee:	de7ff0ef          	jal	ra,ffffffffc0203fd4 <alloc_proc>
ffffffffc02041f2:	84aa                	mv	s1,a0
ffffffffc02041f4:	30050463          	beqz	a0,ffffffffc02044fc <do_fork+0x342>
    proc->parent=current;
ffffffffc02041f8:	000cfc17          	auipc	s8,0xcf
ffffffffc02041fc:	198c0c13          	addi	s8,s8,408 # ffffffffc02d3390 <current>
ffffffffc0204200:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state==0);
ffffffffc0204204:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ad4>
    proc->parent=current;
ffffffffc0204208:	f11c                	sd	a5,32(a0)
    assert(current->wait_state==0);
ffffffffc020420a:	30071d63          	bnez	a4,ffffffffc0204524 <do_fork+0x36a>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020420e:	4509                	li	a0,2
ffffffffc0204210:	e45fd0ef          	jal	ra,ffffffffc0202054 <alloc_pages>
    if (page != NULL)
ffffffffc0204214:	2e050163          	beqz	a0,ffffffffc02044f6 <do_fork+0x33c>
    return page - pages + nbase;
ffffffffc0204218:	000cfa97          	auipc	s5,0xcf
ffffffffc020421c:	160a8a93          	addi	s5,s5,352 # ffffffffc02d3378 <pages>
ffffffffc0204220:	000ab683          	ld	a3,0(s5)
ffffffffc0204224:	00004b17          	auipc	s6,0x4
ffffffffc0204228:	83cb0b13          	addi	s6,s6,-1988 # ffffffffc0207a60 <nbase>
ffffffffc020422c:	000b3783          	ld	a5,0(s6)
ffffffffc0204230:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204234:	000cfb97          	auipc	s7,0xcf
ffffffffc0204238:	13cb8b93          	addi	s7,s7,316 # ffffffffc02d3370 <npage>
    return page - pages + nbase;
ffffffffc020423c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020423e:	5dfd                	li	s11,-1
ffffffffc0204240:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204244:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204246:	00cddd93          	srli	s11,s11,0xc
ffffffffc020424a:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020424e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204250:	2ee67a63          	bgeu	a2,a4,ffffffffc0204544 <do_fork+0x38a>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204254:	000c3603          	ld	a2,0(s8)
ffffffffc0204258:	000cfc17          	auipc	s8,0xcf
ffffffffc020425c:	130c0c13          	addi	s8,s8,304 # ffffffffc02d3388 <va_pa_offset>
ffffffffc0204260:	000c3703          	ld	a4,0(s8)
ffffffffc0204264:	02863d03          	ld	s10,40(a2)
ffffffffc0204268:	e43e                	sd	a5,8(sp)
ffffffffc020426a:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020426c:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc020426e:	020d0863          	beqz	s10,ffffffffc020429e <do_fork+0xe4>
    if (clone_flags & CLONE_VM)
ffffffffc0204272:	100a7a13          	andi	s4,s4,256
ffffffffc0204276:	1c0a0163          	beqz	s4,ffffffffc0204438 <do_fork+0x27e>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020427a:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020427e:	018d3783          	ld	a5,24(s10)
ffffffffc0204282:	c02006b7          	lui	a3,0xc0200
ffffffffc0204286:	2705                	addiw	a4,a4,1
ffffffffc0204288:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc020428c:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204290:	2ed7e263          	bltu	a5,a3,ffffffffc0204574 <do_fork+0x3ba>
ffffffffc0204294:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204298:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020429a:	8f99                	sub	a5,a5,a4
ffffffffc020429c:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020429e:	6789                	lui	a5,0x2
ffffffffc02042a0:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7ce0>
ffffffffc02042a4:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02042a6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042a8:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02042aa:	87b6                	mv	a5,a3
ffffffffc02042ac:	12040893          	addi	a7,s0,288
ffffffffc02042b0:	00063803          	ld	a6,0(a2)
ffffffffc02042b4:	6608                	ld	a0,8(a2)
ffffffffc02042b6:	6a0c                	ld	a1,16(a2)
ffffffffc02042b8:	6e18                	ld	a4,24(a2)
ffffffffc02042ba:	0107b023          	sd	a6,0(a5)
ffffffffc02042be:	e788                	sd	a0,8(a5)
ffffffffc02042c0:	eb8c                	sd	a1,16(a5)
ffffffffc02042c2:	ef98                	sd	a4,24(a5)
ffffffffc02042c4:	02060613          	addi	a2,a2,32
ffffffffc02042c8:	02078793          	addi	a5,a5,32
ffffffffc02042cc:	ff1612e3          	bne	a2,a7,ffffffffc02042b0 <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc02042d0:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02042d4:	12098f63          	beqz	s3,ffffffffc0204412 <do_fork+0x258>
ffffffffc02042d8:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02042dc:	00000797          	auipc	a5,0x0
ffffffffc02042e0:	d6478793          	addi	a5,a5,-668 # ffffffffc0204040 <forkret>
ffffffffc02042e4:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02042e6:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042e8:	100027f3          	csrr	a5,sstatus
ffffffffc02042ec:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02042ee:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042f0:	14079063          	bnez	a5,ffffffffc0204430 <do_fork+0x276>
    if (++last_pid >= MAX_PID)
ffffffffc02042f4:	000cb817          	auipc	a6,0xcb
ffffffffc02042f8:	c0c80813          	addi	a6,a6,-1012 # ffffffffc02cef00 <last_pid.1>
ffffffffc02042fc:	00082783          	lw	a5,0(a6)
ffffffffc0204300:	6709                	lui	a4,0x2
ffffffffc0204302:	0017851b          	addiw	a0,a5,1
ffffffffc0204306:	00a82023          	sw	a0,0(a6)
ffffffffc020430a:	08e55d63          	bge	a0,a4,ffffffffc02043a4 <do_fork+0x1ea>
    if (last_pid >= next_safe)
ffffffffc020430e:	000cb317          	auipc	t1,0xcb
ffffffffc0204312:	bf630313          	addi	t1,t1,-1034 # ffffffffc02cef04 <next_safe.0>
ffffffffc0204316:	00032783          	lw	a5,0(t1)
ffffffffc020431a:	000cf417          	auipc	s0,0xcf
ffffffffc020431e:	00640413          	addi	s0,s0,6 # ffffffffc02d3320 <proc_list>
ffffffffc0204322:	08f55963          	bge	a0,a5,ffffffffc02043b4 <do_fork+0x1fa>
    proc->pid = get_pid();
ffffffffc0204326:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204328:	45a9                	li	a1,10
ffffffffc020432a:	2501                	sext.w	a0,a0
ffffffffc020432c:	108010ef          	jal	ra,ffffffffc0205434 <hash32>
ffffffffc0204330:	02051793          	slli	a5,a0,0x20
ffffffffc0204334:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204338:	000cb797          	auipc	a5,0xcb
ffffffffc020433c:	fe878793          	addi	a5,a5,-24 # ffffffffc02cf320 <hash_list>
ffffffffc0204340:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204342:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204344:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204346:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020434a:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020434c:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020434e:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204350:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204352:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0204356:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204358:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020435a:	e21c                	sd	a5,0(a2)
ffffffffc020435c:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc020435e:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204360:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204362:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204366:	10e4b023          	sd	a4,256(s1)
ffffffffc020436a:	c311                	beqz	a4,ffffffffc020436e <do_fork+0x1b4>
        proc->optr->yptr = proc;
ffffffffc020436c:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc020436e:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0204372:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204374:	2785                	addiw	a5,a5,1
ffffffffc0204376:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc020437a:	18099363          	bnez	s3,ffffffffc0204500 <do_fork+0x346>
    wakeup_proc(proc);
ffffffffc020437e:	8526                	mv	a0,s1
ffffffffc0204380:	6c9000ef          	jal	ra,ffffffffc0205248 <wakeup_proc>
    ret = proc->pid;
ffffffffc0204384:	40c8                	lw	a0,4(s1)
}
ffffffffc0204386:	70e6                	ld	ra,120(sp)
ffffffffc0204388:	7446                	ld	s0,112(sp)
ffffffffc020438a:	74a6                	ld	s1,104(sp)
ffffffffc020438c:	7906                	ld	s2,96(sp)
ffffffffc020438e:	69e6                	ld	s3,88(sp)
ffffffffc0204390:	6a46                	ld	s4,80(sp)
ffffffffc0204392:	6aa6                	ld	s5,72(sp)
ffffffffc0204394:	6b06                	ld	s6,64(sp)
ffffffffc0204396:	7be2                	ld	s7,56(sp)
ffffffffc0204398:	7c42                	ld	s8,48(sp)
ffffffffc020439a:	7ca2                	ld	s9,40(sp)
ffffffffc020439c:	7d02                	ld	s10,32(sp)
ffffffffc020439e:	6de2                	ld	s11,24(sp)
ffffffffc02043a0:	6109                	addi	sp,sp,128
ffffffffc02043a2:	8082                	ret
        last_pid = 1;
ffffffffc02043a4:	4785                	li	a5,1
ffffffffc02043a6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02043aa:	4505                	li	a0,1
ffffffffc02043ac:	000cb317          	auipc	t1,0xcb
ffffffffc02043b0:	b5830313          	addi	t1,t1,-1192 # ffffffffc02cef04 <next_safe.0>
    return listelm->next;
ffffffffc02043b4:	000cf417          	auipc	s0,0xcf
ffffffffc02043b8:	f6c40413          	addi	s0,s0,-148 # ffffffffc02d3320 <proc_list>
ffffffffc02043bc:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02043c0:	6789                	lui	a5,0x2
ffffffffc02043c2:	00f32023          	sw	a5,0(t1)
ffffffffc02043c6:	86aa                	mv	a3,a0
ffffffffc02043c8:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02043ca:	6e89                	lui	t4,0x2
ffffffffc02043cc:	148e0263          	beq	t3,s0,ffffffffc0204510 <do_fork+0x356>
ffffffffc02043d0:	88ae                	mv	a7,a1
ffffffffc02043d2:	87f2                	mv	a5,t3
ffffffffc02043d4:	6609                	lui	a2,0x2
ffffffffc02043d6:	a811                	j	ffffffffc02043ea <do_fork+0x230>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02043d8:	00e6d663          	bge	a3,a4,ffffffffc02043e4 <do_fork+0x22a>
ffffffffc02043dc:	00c75463          	bge	a4,a2,ffffffffc02043e4 <do_fork+0x22a>
ffffffffc02043e0:	863a                	mv	a2,a4
ffffffffc02043e2:	4885                	li	a7,1
ffffffffc02043e4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02043e6:	00878d63          	beq	a5,s0,ffffffffc0204400 <do_fork+0x246>
            if (proc->pid == last_pid)
ffffffffc02043ea:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc02043ee:	fed715e3          	bne	a4,a3,ffffffffc02043d8 <do_fork+0x21e>
                if (++last_pid >= next_safe)
ffffffffc02043f2:	2685                	addiw	a3,a3,1
ffffffffc02043f4:	10c6d963          	bge	a3,a2,ffffffffc0204506 <do_fork+0x34c>
ffffffffc02043f8:	679c                	ld	a5,8(a5)
ffffffffc02043fa:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02043fc:	fe8797e3          	bne	a5,s0,ffffffffc02043ea <do_fork+0x230>
ffffffffc0204400:	c581                	beqz	a1,ffffffffc0204408 <do_fork+0x24e>
ffffffffc0204402:	00d82023          	sw	a3,0(a6)
ffffffffc0204406:	8536                	mv	a0,a3
ffffffffc0204408:	f0088fe3          	beqz	a7,ffffffffc0204326 <do_fork+0x16c>
ffffffffc020440c:	00c32023          	sw	a2,0(t1)
ffffffffc0204410:	bf19                	j	ffffffffc0204326 <do_fork+0x16c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204412:	89b6                	mv	s3,a3
ffffffffc0204414:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204418:	00000797          	auipc	a5,0x0
ffffffffc020441c:	c2878793          	addi	a5,a5,-984 # ffffffffc0204040 <forkret>
ffffffffc0204420:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204422:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204424:	100027f3          	csrr	a5,sstatus
ffffffffc0204428:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020442a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020442c:	ec0784e3          	beqz	a5,ffffffffc02042f4 <do_fork+0x13a>
        intr_disable();
ffffffffc0204430:	d84fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204434:	4985                	li	s3,1
ffffffffc0204436:	bd7d                	j	ffffffffc02042f4 <do_fork+0x13a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204438:	c8aff0ef          	jal	ra,ffffffffc02038c2 <mm_create>
ffffffffc020443c:	8caa                	mv	s9,a0
ffffffffc020443e:	c541                	beqz	a0,ffffffffc02044c6 <do_fork+0x30c>
    if ((page = alloc_page()) == NULL)
ffffffffc0204440:	4505                	li	a0,1
ffffffffc0204442:	c13fd0ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0204446:	cd2d                	beqz	a0,ffffffffc02044c0 <do_fork+0x306>
    return page - pages + nbase;
ffffffffc0204448:	000ab683          	ld	a3,0(s5)
ffffffffc020444c:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020444e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204452:	40d506b3          	sub	a3,a0,a3
ffffffffc0204456:	8699                	srai	a3,a3,0x6
ffffffffc0204458:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020445a:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020445e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204460:	0eedf263          	bgeu	s11,a4,ffffffffc0204544 <do_fork+0x38a>
ffffffffc0204464:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204468:	6605                	lui	a2,0x1
ffffffffc020446a:	000cf597          	auipc	a1,0xcf
ffffffffc020446e:	efe5b583          	ld	a1,-258(a1) # ffffffffc02d3368 <boot_pgdir_va>
ffffffffc0204472:	9a36                	add	s4,s4,a3
ffffffffc0204474:	8552                	mv	a0,s4
ffffffffc0204476:	476010ef          	jal	ra,ffffffffc02058ec <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020447a:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc020447e:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204482:	4785                	li	a5,1
ffffffffc0204484:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204488:	8b85                	andi	a5,a5,1
ffffffffc020448a:	4a05                	li	s4,1
ffffffffc020448c:	c799                	beqz	a5,ffffffffc020449a <do_fork+0x2e0>
    {
        schedule();
ffffffffc020448e:	63b000ef          	jal	ra,ffffffffc02052c8 <schedule>
ffffffffc0204492:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204496:	8b85                	andi	a5,a5,1
ffffffffc0204498:	fbfd                	bnez	a5,ffffffffc020448e <do_fork+0x2d4>
        ret = dup_mmap(mm, oldmm);
ffffffffc020449a:	85ea                	mv	a1,s10
ffffffffc020449c:	8566                	mv	a0,s9
ffffffffc020449e:	e66ff0ef          	jal	ra,ffffffffc0203b04 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02044a2:	57f9                	li	a5,-2
ffffffffc02044a4:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02044a8:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02044aa:	0e078e63          	beqz	a5,ffffffffc02045a6 <do_fork+0x3ec>
good_mm:
ffffffffc02044ae:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02044b0:	dc0505e3          	beqz	a0,ffffffffc020427a <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc02044b4:	8566                	mv	a0,s9
ffffffffc02044b6:	ee8ff0ef          	jal	ra,ffffffffc0203b9e <exit_mmap>
    put_pgdir(mm);
ffffffffc02044ba:	8566                	mv	a0,s9
ffffffffc02044bc:	c11ff0ef          	jal	ra,ffffffffc02040cc <put_pgdir>
    mm_destroy(mm);
ffffffffc02044c0:	8566                	mv	a0,s9
ffffffffc02044c2:	d40ff0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044c6:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02044c8:	c02007b7          	lui	a5,0xc0200
ffffffffc02044cc:	0cf6e163          	bltu	a3,a5,ffffffffc020458e <do_fork+0x3d4>
ffffffffc02044d0:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02044d4:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02044d8:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02044dc:	83b1                	srli	a5,a5,0xc
ffffffffc02044de:	06e7ff63          	bgeu	a5,a4,ffffffffc020455c <do_fork+0x3a2>
    return &pages[PPN(pa) - nbase];
ffffffffc02044e2:	000b3703          	ld	a4,0(s6)
ffffffffc02044e6:	000ab503          	ld	a0,0(s5)
ffffffffc02044ea:	4589                	li	a1,2
ffffffffc02044ec:	8f99                	sub	a5,a5,a4
ffffffffc02044ee:	079a                	slli	a5,a5,0x6
ffffffffc02044f0:	953e                	add	a0,a0,a5
ffffffffc02044f2:	ba1fd0ef          	jal	ra,ffffffffc0202092 <free_pages>
    kfree(proc);
ffffffffc02044f6:	8526                	mv	a0,s1
ffffffffc02044f8:	a2ffd0ef          	jal	ra,ffffffffc0201f26 <kfree>
    ret = -E_NO_MEM;
ffffffffc02044fc:	5571                	li	a0,-4
    return ret;
ffffffffc02044fe:	b561                	j	ffffffffc0204386 <do_fork+0x1cc>
        intr_enable();
ffffffffc0204500:	caefc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204504:	bdad                	j	ffffffffc020437e <do_fork+0x1c4>
                    if (last_pid >= MAX_PID)
ffffffffc0204506:	01d6c363          	blt	a3,t4,ffffffffc020450c <do_fork+0x352>
                        last_pid = 1;
ffffffffc020450a:	4685                	li	a3,1
                    goto repeat;
ffffffffc020450c:	4585                	li	a1,1
ffffffffc020450e:	bd7d                	j	ffffffffc02043cc <do_fork+0x212>
ffffffffc0204510:	c599                	beqz	a1,ffffffffc020451e <do_fork+0x364>
ffffffffc0204512:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204516:	8536                	mv	a0,a3
ffffffffc0204518:	b539                	j	ffffffffc0204326 <do_fork+0x16c>
    int ret = -E_NO_FREE_PROC;
ffffffffc020451a:	556d                	li	a0,-5
ffffffffc020451c:	b5ad                	j	ffffffffc0204386 <do_fork+0x1cc>
    return last_pid;
ffffffffc020451e:	00082503          	lw	a0,0(a6)
ffffffffc0204522:	b511                	j	ffffffffc0204326 <do_fork+0x16c>
    assert(current->wait_state==0);
ffffffffc0204524:	00003697          	auipc	a3,0x3
ffffffffc0204528:	ca468693          	addi	a3,a3,-860 # ffffffffc02071c8 <default_pmm_manager+0x9f8>
ffffffffc020452c:	00002617          	auipc	a2,0x2
ffffffffc0204530:	ef460613          	addi	a2,a2,-268 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204534:	1f300593          	li	a1,499
ffffffffc0204538:	00003517          	auipc	a0,0x3
ffffffffc020453c:	c7850513          	addi	a0,a0,-904 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204540:	f4ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204544:	00002617          	auipc	a2,0x2
ffffffffc0204548:	e4c60613          	addi	a2,a2,-436 # ffffffffc0206390 <commands+0x820>
ffffffffc020454c:	07100593          	li	a1,113
ffffffffc0204550:	00002517          	auipc	a0,0x2
ffffffffc0204554:	df850513          	addi	a0,a0,-520 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0204558:	f37fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020455c:	00002617          	auipc	a2,0x2
ffffffffc0204560:	dfc60613          	addi	a2,a2,-516 # ffffffffc0206358 <commands+0x7e8>
ffffffffc0204564:	06900593          	li	a1,105
ffffffffc0204568:	00002517          	auipc	a0,0x2
ffffffffc020456c:	de050513          	addi	a0,a0,-544 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0204570:	f1ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204574:	86be                	mv	a3,a5
ffffffffc0204576:	00002617          	auipc	a2,0x2
ffffffffc020457a:	30260613          	addi	a2,a2,770 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc020457e:	1b200593          	li	a1,434
ffffffffc0204582:	00003517          	auipc	a0,0x3
ffffffffc0204586:	c2e50513          	addi	a0,a0,-978 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc020458a:	f05fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020458e:	00002617          	auipc	a2,0x2
ffffffffc0204592:	2ea60613          	addi	a2,a2,746 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc0204596:	07700593          	li	a1,119
ffffffffc020459a:	00002517          	auipc	a0,0x2
ffffffffc020459e:	dae50513          	addi	a0,a0,-594 # ffffffffc0206348 <commands+0x7d8>
ffffffffc02045a2:	eedfb0ef          	jal	ra,ffffffffc020048e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02045a6:	00003617          	auipc	a2,0x3
ffffffffc02045aa:	c3a60613          	addi	a2,a2,-966 # ffffffffc02071e0 <default_pmm_manager+0xa10>
ffffffffc02045ae:	03f00593          	li	a1,63
ffffffffc02045b2:	00003517          	auipc	a0,0x3
ffffffffc02045b6:	c3e50513          	addi	a0,a0,-962 # ffffffffc02071f0 <default_pmm_manager+0xa20>
ffffffffc02045ba:	ed5fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02045be <kernel_thread>:
{
ffffffffc02045be:	7129                	addi	sp,sp,-320
ffffffffc02045c0:	fa22                	sd	s0,304(sp)
ffffffffc02045c2:	f626                	sd	s1,296(sp)
ffffffffc02045c4:	f24a                	sd	s2,288(sp)
ffffffffc02045c6:	84ae                	mv	s1,a1
ffffffffc02045c8:	892a                	mv	s2,a0
ffffffffc02045ca:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045cc:	4581                	li	a1,0
ffffffffc02045ce:	12000613          	li	a2,288
ffffffffc02045d2:	850a                	mv	a0,sp
{
ffffffffc02045d4:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045d6:	304010ef          	jal	ra,ffffffffc02058da <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02045da:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02045dc:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02045de:	100027f3          	csrr	a5,sstatus
ffffffffc02045e2:	edd7f793          	andi	a5,a5,-291
ffffffffc02045e6:	1207e793          	ori	a5,a5,288
ffffffffc02045ea:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045ec:	860a                	mv	a2,sp
ffffffffc02045ee:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;//defined same as lab4
ffffffffc02045f2:	00000797          	auipc	a5,0x0
ffffffffc02045f6:	9da78793          	addi	a5,a5,-1574 # ffffffffc0203fcc <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045fa:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;//defined same as lab4
ffffffffc02045fc:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045fe:	bbdff0ef          	jal	ra,ffffffffc02041ba <do_fork>
}
ffffffffc0204602:	70f2                	ld	ra,312(sp)
ffffffffc0204604:	7452                	ld	s0,304(sp)
ffffffffc0204606:	74b2                	ld	s1,296(sp)
ffffffffc0204608:	7912                	ld	s2,288(sp)
ffffffffc020460a:	6131                	addi	sp,sp,320
ffffffffc020460c:	8082                	ret

ffffffffc020460e <do_exit>:
{
ffffffffc020460e:	7179                	addi	sp,sp,-48
ffffffffc0204610:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204612:	000cf417          	auipc	s0,0xcf
ffffffffc0204616:	d7e40413          	addi	s0,s0,-642 # ffffffffc02d3390 <current>
ffffffffc020461a:	601c                	ld	a5,0(s0)
{
ffffffffc020461c:	f406                	sd	ra,40(sp)
ffffffffc020461e:	ec26                	sd	s1,24(sp)
ffffffffc0204620:	e84a                	sd	s2,16(sp)
ffffffffc0204622:	e44e                	sd	s3,8(sp)
ffffffffc0204624:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204626:	000cf717          	auipc	a4,0xcf
ffffffffc020462a:	d7273703          	ld	a4,-654(a4) # ffffffffc02d3398 <idleproc>
ffffffffc020462e:	0ce78c63          	beq	a5,a4,ffffffffc0204706 <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204632:	000cf497          	auipc	s1,0xcf
ffffffffc0204636:	d6e48493          	addi	s1,s1,-658 # ffffffffc02d33a0 <initproc>
ffffffffc020463a:	6098                	ld	a4,0(s1)
ffffffffc020463c:	0ee78b63          	beq	a5,a4,ffffffffc0204732 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204640:	0287b983          	ld	s3,40(a5)
ffffffffc0204644:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204646:	02098663          	beqz	s3,ffffffffc0204672 <do_exit+0x64>
ffffffffc020464a:	000cf797          	auipc	a5,0xcf
ffffffffc020464e:	d167b783          	ld	a5,-746(a5) # ffffffffc02d3360 <boot_pgdir_pa>
ffffffffc0204652:	577d                	li	a4,-1
ffffffffc0204654:	177e                	slli	a4,a4,0x3f
ffffffffc0204656:	83b1                	srli	a5,a5,0xc
ffffffffc0204658:	8fd9                	or	a5,a5,a4
ffffffffc020465a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020465e:	0309a783          	lw	a5,48(s3)
ffffffffc0204662:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204666:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020466a:	cb55                	beqz	a4,ffffffffc020471e <do_exit+0x110>
        current->mm = NULL;
ffffffffc020466c:	601c                	ld	a5,0(s0)
ffffffffc020466e:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204672:	601c                	ld	a5,0(s0)
ffffffffc0204674:	470d                	li	a4,3
ffffffffc0204676:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204678:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020467c:	100027f3          	csrr	a5,sstatus
ffffffffc0204680:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204682:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204684:	e3f9                	bnez	a5,ffffffffc020474a <do_exit+0x13c>
        proc = current->parent;
ffffffffc0204686:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204688:	800007b7          	lui	a5,0x80000
ffffffffc020468c:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020468e:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204690:	0ec52703          	lw	a4,236(a0)
ffffffffc0204694:	0af70f63          	beq	a4,a5,ffffffffc0204752 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204698:	6018                	ld	a4,0(s0)
ffffffffc020469a:	7b7c                	ld	a5,240(a4)
ffffffffc020469c:	c3a1                	beqz	a5,ffffffffc02046dc <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020469e:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046a2:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046a4:	0985                	addi	s3,s3,1
ffffffffc02046a6:	a021                	j	ffffffffc02046ae <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02046a8:	6018                	ld	a4,0(s0)
ffffffffc02046aa:	7b7c                	ld	a5,240(a4)
ffffffffc02046ac:	cb85                	beqz	a5,ffffffffc02046dc <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02046ae:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fc8>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046b2:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02046b4:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046b6:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02046b8:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046bc:	10e7b023          	sd	a4,256(a5)
ffffffffc02046c0:	c311                	beqz	a4,ffffffffc02046c4 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02046c2:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046c4:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02046c6:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02046c8:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046ca:	fd271fe3          	bne	a4,s2,ffffffffc02046a8 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046ce:	0ec52783          	lw	a5,236(a0)
ffffffffc02046d2:	fd379be3          	bne	a5,s3,ffffffffc02046a8 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02046d6:	373000ef          	jal	ra,ffffffffc0205248 <wakeup_proc>
ffffffffc02046da:	b7f9                	j	ffffffffc02046a8 <do_exit+0x9a>
    if (flag)
ffffffffc02046dc:	020a1263          	bnez	s4,ffffffffc0204700 <do_exit+0xf2>
    schedule();
ffffffffc02046e0:	3e9000ef          	jal	ra,ffffffffc02052c8 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02046e4:	601c                	ld	a5,0(s0)
ffffffffc02046e6:	00003617          	auipc	a2,0x3
ffffffffc02046ea:	b4260613          	addi	a2,a2,-1214 # ffffffffc0207228 <default_pmm_manager+0xa58>
ffffffffc02046ee:	26a00593          	li	a1,618
ffffffffc02046f2:	43d4                	lw	a3,4(a5)
ffffffffc02046f4:	00003517          	auipc	a0,0x3
ffffffffc02046f8:	abc50513          	addi	a0,a0,-1348 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02046fc:	d93fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204700:	aaefc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204704:	bff1                	j	ffffffffc02046e0 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204706:	00003617          	auipc	a2,0x3
ffffffffc020470a:	b0260613          	addi	a2,a2,-1278 # ffffffffc0207208 <default_pmm_manager+0xa38>
ffffffffc020470e:	22d00593          	li	a1,557
ffffffffc0204712:	00003517          	auipc	a0,0x3
ffffffffc0204716:	a9e50513          	addi	a0,a0,-1378 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc020471a:	d75fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc020471e:	854e                	mv	a0,s3
ffffffffc0204720:	c7eff0ef          	jal	ra,ffffffffc0203b9e <exit_mmap>
            put_pgdir(mm);
ffffffffc0204724:	854e                	mv	a0,s3
ffffffffc0204726:	9a7ff0ef          	jal	ra,ffffffffc02040cc <put_pgdir>
            mm_destroy(mm);
ffffffffc020472a:	854e                	mv	a0,s3
ffffffffc020472c:	ad6ff0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>
ffffffffc0204730:	bf35                	j	ffffffffc020466c <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204732:	00003617          	auipc	a2,0x3
ffffffffc0204736:	ae660613          	addi	a2,a2,-1306 # ffffffffc0207218 <default_pmm_manager+0xa48>
ffffffffc020473a:	23100593          	li	a1,561
ffffffffc020473e:	00003517          	auipc	a0,0x3
ffffffffc0204742:	a7250513          	addi	a0,a0,-1422 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204746:	d49fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc020474a:	a6afc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020474e:	4a05                	li	s4,1
ffffffffc0204750:	bf1d                	j	ffffffffc0204686 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204752:	2f7000ef          	jal	ra,ffffffffc0205248 <wakeup_proc>
ffffffffc0204756:	b789                	j	ffffffffc0204698 <do_exit+0x8a>

ffffffffc0204758 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204758:	715d                	addi	sp,sp,-80
ffffffffc020475a:	f84a                	sd	s2,48(sp)
ffffffffc020475c:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc020475e:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204762:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204764:	fc26                	sd	s1,56(sp)
ffffffffc0204766:	f052                	sd	s4,32(sp)
ffffffffc0204768:	ec56                	sd	s5,24(sp)
ffffffffc020476a:	e85a                	sd	s6,16(sp)
ffffffffc020476c:	e45e                	sd	s7,8(sp)
ffffffffc020476e:	e486                	sd	ra,72(sp)
ffffffffc0204770:	e0a2                	sd	s0,64(sp)
ffffffffc0204772:	84aa                	mv	s1,a0
ffffffffc0204774:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204776:	000cfb97          	auipc	s7,0xcf
ffffffffc020477a:	c1ab8b93          	addi	s7,s7,-998 # ffffffffc02d3390 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc020477e:	00050b1b          	sext.w	s6,a0
ffffffffc0204782:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204786:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204788:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc020478a:	ccbd                	beqz	s1,ffffffffc0204808 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc020478c:	0359e863          	bltu	s3,s5,ffffffffc02047bc <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204790:	45a9                	li	a1,10
ffffffffc0204792:	855a                	mv	a0,s6
ffffffffc0204794:	4a1000ef          	jal	ra,ffffffffc0205434 <hash32>
ffffffffc0204798:	02051793          	slli	a5,a0,0x20
ffffffffc020479c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02047a0:	000cb797          	auipc	a5,0xcb
ffffffffc02047a4:	b8078793          	addi	a5,a5,-1152 # ffffffffc02cf320 <hash_list>
ffffffffc02047a8:	953e                	add	a0,a0,a5
ffffffffc02047aa:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02047ac:	a029                	j	ffffffffc02047b6 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02047ae:	f2c42783          	lw	a5,-212(s0)
ffffffffc02047b2:	02978163          	beq	a5,s1,ffffffffc02047d4 <do_wait.part.0+0x7c>
ffffffffc02047b6:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02047b8:	fe851be3          	bne	a0,s0,ffffffffc02047ae <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02047bc:	5579                	li	a0,-2
}
ffffffffc02047be:	60a6                	ld	ra,72(sp)
ffffffffc02047c0:	6406                	ld	s0,64(sp)
ffffffffc02047c2:	74e2                	ld	s1,56(sp)
ffffffffc02047c4:	7942                	ld	s2,48(sp)
ffffffffc02047c6:	79a2                	ld	s3,40(sp)
ffffffffc02047c8:	7a02                	ld	s4,32(sp)
ffffffffc02047ca:	6ae2                	ld	s5,24(sp)
ffffffffc02047cc:	6b42                	ld	s6,16(sp)
ffffffffc02047ce:	6ba2                	ld	s7,8(sp)
ffffffffc02047d0:	6161                	addi	sp,sp,80
ffffffffc02047d2:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02047d4:	000bb683          	ld	a3,0(s7)
ffffffffc02047d8:	f4843783          	ld	a5,-184(s0)
ffffffffc02047dc:	fed790e3          	bne	a5,a3,ffffffffc02047bc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047e0:	f2842703          	lw	a4,-216(s0)
ffffffffc02047e4:	478d                	li	a5,3
ffffffffc02047e6:	0ef70b63          	beq	a4,a5,ffffffffc02048dc <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02047ea:	4785                	li	a5,1
ffffffffc02047ec:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02047ee:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02047f2:	2d7000ef          	jal	ra,ffffffffc02052c8 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02047f6:	000bb783          	ld	a5,0(s7)
ffffffffc02047fa:	0b07a783          	lw	a5,176(a5)
ffffffffc02047fe:	8b85                	andi	a5,a5,1
ffffffffc0204800:	d7c9                	beqz	a5,ffffffffc020478a <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204802:	555d                	li	a0,-9
ffffffffc0204804:	e0bff0ef          	jal	ra,ffffffffc020460e <do_exit>
        proc = current->cptr;
ffffffffc0204808:	000bb683          	ld	a3,0(s7)
ffffffffc020480c:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020480e:	d45d                	beqz	s0,ffffffffc02047bc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204810:	470d                	li	a4,3
ffffffffc0204812:	a021                	j	ffffffffc020481a <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204814:	10043403          	ld	s0,256(s0)
ffffffffc0204818:	d869                	beqz	s0,ffffffffc02047ea <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020481a:	401c                	lw	a5,0(s0)
ffffffffc020481c:	fee79ce3          	bne	a5,a4,ffffffffc0204814 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204820:	000cf797          	auipc	a5,0xcf
ffffffffc0204824:	b787b783          	ld	a5,-1160(a5) # ffffffffc02d3398 <idleproc>
ffffffffc0204828:	0c878963          	beq	a5,s0,ffffffffc02048fa <do_wait.part.0+0x1a2>
ffffffffc020482c:	000cf797          	auipc	a5,0xcf
ffffffffc0204830:	b747b783          	ld	a5,-1164(a5) # ffffffffc02d33a0 <initproc>
ffffffffc0204834:	0cf40363          	beq	s0,a5,ffffffffc02048fa <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204838:	000a0663          	beqz	s4,ffffffffc0204844 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020483c:	0e842783          	lw	a5,232(s0)
ffffffffc0204840:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204844:	100027f3          	csrr	a5,sstatus
ffffffffc0204848:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020484a:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020484c:	e7c1                	bnez	a5,ffffffffc02048d4 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020484e:	6c70                	ld	a2,216(s0)
ffffffffc0204850:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204852:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204856:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204858:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020485a:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020485c:	6470                	ld	a2,200(s0)
ffffffffc020485e:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204860:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204862:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204864:	c319                	beqz	a4,ffffffffc020486a <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204866:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204868:	7c7c                	ld	a5,248(s0)
ffffffffc020486a:	c3b5                	beqz	a5,ffffffffc02048ce <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020486c:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204870:	000cf717          	auipc	a4,0xcf
ffffffffc0204874:	b3870713          	addi	a4,a4,-1224 # ffffffffc02d33a8 <nr_process>
ffffffffc0204878:	431c                	lw	a5,0(a4)
ffffffffc020487a:	37fd                	addiw	a5,a5,-1
ffffffffc020487c:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020487e:	e5a9                	bnez	a1,ffffffffc02048c8 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204880:	6814                	ld	a3,16(s0)
ffffffffc0204882:	c02007b7          	lui	a5,0xc0200
ffffffffc0204886:	04f6ee63          	bltu	a3,a5,ffffffffc02048e2 <do_wait.part.0+0x18a>
ffffffffc020488a:	000cf797          	auipc	a5,0xcf
ffffffffc020488e:	afe7b783          	ld	a5,-1282(a5) # ffffffffc02d3388 <va_pa_offset>
ffffffffc0204892:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204894:	82b1                	srli	a3,a3,0xc
ffffffffc0204896:	000cf797          	auipc	a5,0xcf
ffffffffc020489a:	ada7b783          	ld	a5,-1318(a5) # ffffffffc02d3370 <npage>
ffffffffc020489e:	06f6fa63          	bgeu	a3,a5,ffffffffc0204912 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02048a2:	00003517          	auipc	a0,0x3
ffffffffc02048a6:	1be53503          	ld	a0,446(a0) # ffffffffc0207a60 <nbase>
ffffffffc02048aa:	8e89                	sub	a3,a3,a0
ffffffffc02048ac:	069a                	slli	a3,a3,0x6
ffffffffc02048ae:	000cf517          	auipc	a0,0xcf
ffffffffc02048b2:	aca53503          	ld	a0,-1334(a0) # ffffffffc02d3378 <pages>
ffffffffc02048b6:	9536                	add	a0,a0,a3
ffffffffc02048b8:	4589                	li	a1,2
ffffffffc02048ba:	fd8fd0ef          	jal	ra,ffffffffc0202092 <free_pages>
    kfree(proc);
ffffffffc02048be:	8522                	mv	a0,s0
ffffffffc02048c0:	e66fd0ef          	jal	ra,ffffffffc0201f26 <kfree>
    return 0;
ffffffffc02048c4:	4501                	li	a0,0
ffffffffc02048c6:	bde5                	j	ffffffffc02047be <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02048c8:	8e6fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02048cc:	bf55                	j	ffffffffc0204880 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02048ce:	701c                	ld	a5,32(s0)
ffffffffc02048d0:	fbf8                	sd	a4,240(a5)
ffffffffc02048d2:	bf79                	j	ffffffffc0204870 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02048d4:	8e0fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02048d8:	4585                	li	a1,1
ffffffffc02048da:	bf95                	j	ffffffffc020484e <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02048dc:	f2840413          	addi	s0,s0,-216
ffffffffc02048e0:	b781                	j	ffffffffc0204820 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02048e2:	00002617          	auipc	a2,0x2
ffffffffc02048e6:	f9660613          	addi	a2,a2,-106 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc02048ea:	07700593          	li	a1,119
ffffffffc02048ee:	00002517          	auipc	a0,0x2
ffffffffc02048f2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0206348 <commands+0x7d8>
ffffffffc02048f6:	b99fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02048fa:	00003617          	auipc	a2,0x3
ffffffffc02048fe:	94e60613          	addi	a2,a2,-1714 # ffffffffc0207248 <default_pmm_manager+0xa78>
ffffffffc0204902:	3c800593          	li	a1,968
ffffffffc0204906:	00003517          	auipc	a0,0x3
ffffffffc020490a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc020490e:	b81fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204912:	00002617          	auipc	a2,0x2
ffffffffc0204916:	a4660613          	addi	a2,a2,-1466 # ffffffffc0206358 <commands+0x7e8>
ffffffffc020491a:	06900593          	li	a1,105
ffffffffc020491e:	00002517          	auipc	a0,0x2
ffffffffc0204922:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0204926:	b69fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020492a <init_main>:
// init_main - the second kernel thread used to create user_main kernel threads
// a new init_main,diffres from merely print in l.a.b.4
// give birth 2 child,and kill zombies
static int
init_main(void *arg)
{
ffffffffc020492a:	1141                	addi	sp,sp,-16
ffffffffc020492c:	e406                	sd	ra,8(sp)
    //for check,avoid mem leak...
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020492e:	fa4fd0ef          	jal	ra,ffffffffc02020d2 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204932:	d40fd0ef          	jal	ra,ffffffffc0201e72 <kallocated>

    //in the kernel_t,new a 'kernel_t' user_main
    //idle_main.cptr->init_main
    //                init_main.cptr->user_main
    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204936:	4601                	li	a2,0
ffffffffc0204938:	4581                	li	a1,0
ffffffffc020493a:	fffff517          	auipc	a0,0xfffff
ffffffffc020493e:	71450513          	addi	a0,a0,1812 # ffffffffc020404e <user_main>
ffffffffc0204942:	c7dff0ef          	jal	ra,ffffffffc02045be <kernel_thread>
    //shall not be idle_main neither
    if (pid <= 0)
ffffffffc0204946:	00a04563          	bgtz	a0,ffffffffc0204950 <init_main+0x26>
ffffffffc020494a:	a071                	j	ffffffffc02049d6 <init_main+0xac>
    //  (here,given init_main is a kernel_proc,having no user mem space)
    //when do_wait returns 0,means have founded a zombie child and
    //only when there is no child,it will return -E_BAD_PROC,no loop
    while (do_wait(0, NULL) == 0)
    {
        schedule(); //since ve kill a zombie,try giving the control 2 other runnable thread
ffffffffc020494c:	17d000ef          	jal	ra,ffffffffc02052c8 <schedule>
    if (code_store != NULL)
ffffffffc0204950:	4581                	li	a1,0
ffffffffc0204952:	4501                	li	a0,0
ffffffffc0204954:	e05ff0ef          	jal	ra,ffffffffc0204758 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204958:	d975                	beqz	a0,ffffffffc020494c <init_main+0x22>
                    //current is init_main,and user_main will run
    }
    //above are core behaviour

    //if user_main exit
    cprintf("all user-mode processes have quit.\n");
ffffffffc020495a:	00003517          	auipc	a0,0x3
ffffffffc020495e:	92e50513          	addi	a0,a0,-1746 # ffffffffc0207288 <default_pmm_manager+0xab8>
ffffffffc0204962:	833fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    //no child no sibling for initproc
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204966:	000cf797          	auipc	a5,0xcf
ffffffffc020496a:	a3a7b783          	ld	a5,-1478(a5) # ffffffffc02d33a0 <initproc>
ffffffffc020496e:	7bf8                	ld	a4,240(a5)
ffffffffc0204970:	e339                	bnez	a4,ffffffffc02049b6 <init_main+0x8c>
ffffffffc0204972:	7ff8                	ld	a4,248(a5)
ffffffffc0204974:	e329                	bnez	a4,ffffffffc02049b6 <init_main+0x8c>
ffffffffc0204976:	1007b703          	ld	a4,256(a5)
ffffffffc020497a:	ef15                	bnez	a4,ffffffffc02049b6 <init_main+0x8c>
    //only idleproc and initproc now
    assert(nr_process == 2);
ffffffffc020497c:	000cf697          	auipc	a3,0xcf
ffffffffc0204980:	a2c6a683          	lw	a3,-1492(a3) # ffffffffc02d33a8 <nr_process>
ffffffffc0204984:	4709                	li	a4,2
ffffffffc0204986:	0ae69463          	bne	a3,a4,ffffffffc0204a2e <init_main+0x104>
    return listelm->next;
ffffffffc020498a:	000cf697          	auipc	a3,0xcf
ffffffffc020498e:	99668693          	addi	a3,a3,-1642 # ffffffffc02d3320 <proc_list>
    //proc list have but 2 elements
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204992:	6698                	ld	a4,8(a3)
ffffffffc0204994:	0c878793          	addi	a5,a5,200
ffffffffc0204998:	06f71b63          	bne	a4,a5,ffffffffc0204a0e <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020499c:	629c                	ld	a5,0(a3)
ffffffffc020499e:	04f71863          	bne	a4,a5,ffffffffc02049ee <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02049a2:	00003517          	auipc	a0,0x3
ffffffffc02049a6:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0207370 <default_pmm_manager+0xba0>
ffffffffc02049aa:	feafb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02049ae:	60a2                	ld	ra,8(sp)
ffffffffc02049b0:	4501                	li	a0,0
ffffffffc02049b2:	0141                	addi	sp,sp,16
ffffffffc02049b4:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02049b6:	00003697          	auipc	a3,0x3
ffffffffc02049ba:	8fa68693          	addi	a3,a3,-1798 # ffffffffc02072b0 <default_pmm_manager+0xae0>
ffffffffc02049be:	00002617          	auipc	a2,0x2
ffffffffc02049c2:	a6260613          	addi	a2,a2,-1438 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02049c6:	46000593          	li	a1,1120
ffffffffc02049ca:	00002517          	auipc	a0,0x2
ffffffffc02049ce:	7e650513          	addi	a0,a0,2022 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02049d2:	abdfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02049d6:	00003617          	auipc	a2,0x3
ffffffffc02049da:	89260613          	addi	a2,a2,-1902 # ffffffffc0207268 <default_pmm_manager+0xa98>
ffffffffc02049de:	44e00593          	li	a1,1102
ffffffffc02049e2:	00002517          	auipc	a0,0x2
ffffffffc02049e6:	7ce50513          	addi	a0,a0,1998 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02049ea:	aa5fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02049ee:	00003697          	auipc	a3,0x3
ffffffffc02049f2:	95268693          	addi	a3,a3,-1710 # ffffffffc0207340 <default_pmm_manager+0xb70>
ffffffffc02049f6:	00002617          	auipc	a2,0x2
ffffffffc02049fa:	a2a60613          	addi	a2,a2,-1494 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02049fe:	46500593          	li	a1,1125
ffffffffc0204a02:	00002517          	auipc	a0,0x2
ffffffffc0204a06:	7ae50513          	addi	a0,a0,1966 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204a0a:	a85fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a0e:	00003697          	auipc	a3,0x3
ffffffffc0204a12:	90268693          	addi	a3,a3,-1790 # ffffffffc0207310 <default_pmm_manager+0xb40>
ffffffffc0204a16:	00002617          	auipc	a2,0x2
ffffffffc0204a1a:	a0a60613          	addi	a2,a2,-1526 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204a1e:	46400593          	li	a1,1124
ffffffffc0204a22:	00002517          	auipc	a0,0x2
ffffffffc0204a26:	78e50513          	addi	a0,a0,1934 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204a2a:	a65fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204a2e:	00003697          	auipc	a3,0x3
ffffffffc0204a32:	8d268693          	addi	a3,a3,-1838 # ffffffffc0207300 <default_pmm_manager+0xb30>
ffffffffc0204a36:	00002617          	auipc	a2,0x2
ffffffffc0204a3a:	9ea60613          	addi	a2,a2,-1558 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204a3e:	46200593          	li	a1,1122
ffffffffc0204a42:	00002517          	auipc	a0,0x2
ffffffffc0204a46:	76e50513          	addi	a0,a0,1902 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204a4a:	a45fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a4e <do_execve>:
{
ffffffffc0204a4e:	7171                	addi	sp,sp,-176
ffffffffc0204a50:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a52:	000cfd97          	auipc	s11,0xcf
ffffffffc0204a56:	93ed8d93          	addi	s11,s11,-1730 # ffffffffc02d3390 <current>
ffffffffc0204a5a:	000db783          	ld	a5,0(s11)
{
ffffffffc0204a5e:	e54e                	sd	s3,136(sp)
ffffffffc0204a60:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a62:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204a66:	e94a                	sd	s2,144(sp)
ffffffffc0204a68:	f4de                	sd	s7,104(sp)
ffffffffc0204a6a:	892a                	mv	s2,a0
ffffffffc0204a6c:	8bb2                	mv	s7,a2
ffffffffc0204a6e:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a70:	862e                	mv	a2,a1
ffffffffc0204a72:	4681                	li	a3,0
ffffffffc0204a74:	85aa                	mv	a1,a0
ffffffffc0204a76:	854e                	mv	a0,s3
{
ffffffffc0204a78:	f506                	sd	ra,168(sp)
ffffffffc0204a7a:	f122                	sd	s0,160(sp)
ffffffffc0204a7c:	e152                	sd	s4,128(sp)
ffffffffc0204a7e:	fcd6                	sd	s5,120(sp)
ffffffffc0204a80:	f8da                	sd	s6,112(sp)
ffffffffc0204a82:	f0e2                	sd	s8,96(sp)
ffffffffc0204a84:	ece6                	sd	s9,88(sp)
ffffffffc0204a86:	e8ea                	sd	s10,80(sp)
ffffffffc0204a88:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a8a:	caeff0ef          	jal	ra,ffffffffc0203f38 <user_mem_check>
ffffffffc0204a8e:	40050a63          	beqz	a0,ffffffffc0204ea2 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204a92:	4641                	li	a2,16
ffffffffc0204a94:	4581                	li	a1,0
ffffffffc0204a96:	1808                	addi	a0,sp,48
ffffffffc0204a98:	643000ef          	jal	ra,ffffffffc02058da <memset>
    memcpy(local_name, name, len);
ffffffffc0204a9c:	47bd                	li	a5,15
ffffffffc0204a9e:	8626                	mv	a2,s1
ffffffffc0204aa0:	1e97e263          	bltu	a5,s1,ffffffffc0204c84 <do_execve+0x236>
ffffffffc0204aa4:	85ca                	mv	a1,s2
ffffffffc0204aa6:	1808                	addi	a0,sp,48
ffffffffc0204aa8:	645000ef          	jal	ra,ffffffffc02058ec <memcpy>
    if (mm != NULL)
ffffffffc0204aac:	1e098363          	beqz	s3,ffffffffc0204c92 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204ab0:	00002517          	auipc	a0,0x2
ffffffffc0204ab4:	4c050513          	addi	a0,a0,1216 # ffffffffc0206f70 <default_pmm_manager+0x7a0>
ffffffffc0204ab8:	f14fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204abc:	000cf797          	auipc	a5,0xcf
ffffffffc0204ac0:	8a47b783          	ld	a5,-1884(a5) # ffffffffc02d3360 <boot_pgdir_pa>
ffffffffc0204ac4:	577d                	li	a4,-1
ffffffffc0204ac6:	177e                	slli	a4,a4,0x3f
ffffffffc0204ac8:	83b1                	srli	a5,a5,0xc
ffffffffc0204aca:	8fd9                	or	a5,a5,a4
ffffffffc0204acc:	18079073          	csrw	satp,a5
ffffffffc0204ad0:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b90>
ffffffffc0204ad4:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204ad8:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204adc:	2c070463          	beqz	a4,ffffffffc0204da4 <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204ae0:	000db783          	ld	a5,0(s11)
ffffffffc0204ae4:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204ae8:	ddbfe0ef          	jal	ra,ffffffffc02038c2 <mm_create>
ffffffffc0204aec:	84aa                	mv	s1,a0
ffffffffc0204aee:	1c050d63          	beqz	a0,ffffffffc0204cc8 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204af2:	4505                	li	a0,1
ffffffffc0204af4:	d60fd0ef          	jal	ra,ffffffffc0202054 <alloc_pages>
ffffffffc0204af8:	3a050963          	beqz	a0,ffffffffc0204eaa <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204afc:	000cfc97          	auipc	s9,0xcf
ffffffffc0204b00:	87cc8c93          	addi	s9,s9,-1924 # ffffffffc02d3378 <pages>
ffffffffc0204b04:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204b08:	000cfc17          	auipc	s8,0xcf
ffffffffc0204b0c:	868c0c13          	addi	s8,s8,-1944 # ffffffffc02d3370 <npage>
    return page - pages + nbase;
ffffffffc0204b10:	00003717          	auipc	a4,0x3
ffffffffc0204b14:	f5073703          	ld	a4,-176(a4) # ffffffffc0207a60 <nbase>
ffffffffc0204b18:	40d506b3          	sub	a3,a0,a3
ffffffffc0204b1c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204b1e:	5afd                	li	s5,-1
ffffffffc0204b20:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204b24:	96ba                	add	a3,a3,a4
ffffffffc0204b26:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b28:	00cad713          	srli	a4,s5,0xc
ffffffffc0204b2c:	ec3a                	sd	a4,24(sp)
ffffffffc0204b2e:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b30:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b32:	38f77063          	bgeu	a4,a5,ffffffffc0204eb2 <do_execve+0x464>
ffffffffc0204b36:	000cfb17          	auipc	s6,0xcf
ffffffffc0204b3a:	852b0b13          	addi	s6,s6,-1966 # ffffffffc02d3388 <va_pa_offset>
ffffffffc0204b3e:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204b42:	6605                	lui	a2,0x1
ffffffffc0204b44:	000cf597          	auipc	a1,0xcf
ffffffffc0204b48:	8245b583          	ld	a1,-2012(a1) # ffffffffc02d3368 <boot_pgdir_va>
ffffffffc0204b4c:	9936                	add	s2,s2,a3
ffffffffc0204b4e:	854a                	mv	a0,s2
ffffffffc0204b50:	59d000ef          	jal	ra,ffffffffc02058ec <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b54:	7782                	ld	a5,32(sp)
ffffffffc0204b56:	4398                	lw	a4,0(a5)
ffffffffc0204b58:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204b5c:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b60:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b9447>
ffffffffc0204b64:	14f71863          	bne	a4,a5,ffffffffc0204cb4 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum/* times sizeof(proghdr) */;
ffffffffc0204b68:	7682                	ld	a3,32(sp)
ffffffffc0204b6a:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b6e:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum/* times sizeof(proghdr) */;
ffffffffc0204b72:	00371793          	slli	a5,a4,0x3
ffffffffc0204b76:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b78:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum/* times sizeof(proghdr) */;
ffffffffc0204b7a:	078e                	slli	a5,a5,0x3
ffffffffc0204b7c:	97ce                	add	a5,a5,s3
ffffffffc0204b7e:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204b80:	00f9fc63          	bgeu	s3,a5,ffffffffc0204b98 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204b84:	0009a783          	lw	a5,0(s3)
ffffffffc0204b88:	4705                	li	a4,1
ffffffffc0204b8a:	14e78163          	beq	a5,a4,ffffffffc0204ccc <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204b8e:	77a2                	ld	a5,40(sp)
ffffffffc0204b90:	03898993          	addi	s3,s3,56
ffffffffc0204b94:	fef9e8e3          	bltu	s3,a5,ffffffffc0204b84 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204b98:	4701                	li	a4,0
ffffffffc0204b9a:	46ad                	li	a3,11
ffffffffc0204b9c:	00100637          	lui	a2,0x100
ffffffffc0204ba0:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204ba4:	8526                	mv	a0,s1
ffffffffc0204ba6:	eaffe0ef          	jal	ra,ffffffffc0203a54 <mm_map>
ffffffffc0204baa:	8a2a                	mv	s4,a0
ffffffffc0204bac:	1e051263          	bnez	a0,ffffffffc0204d90 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204bb0:	6c88                	ld	a0,24(s1)
ffffffffc0204bb2:	467d                	li	a2,31
ffffffffc0204bb4:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204bb8:	c25fe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204bbc:	38050363          	beqz	a0,ffffffffc0204f42 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bc0:	6c88                	ld	a0,24(s1)
ffffffffc0204bc2:	467d                	li	a2,31
ffffffffc0204bc4:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204bc8:	c15fe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204bcc:	34050b63          	beqz	a0,ffffffffc0204f22 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bd0:	6c88                	ld	a0,24(s1)
ffffffffc0204bd2:	467d                	li	a2,31
ffffffffc0204bd4:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204bd8:	c05fe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204bdc:	32050363          	beqz	a0,ffffffffc0204f02 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204be0:	6c88                	ld	a0,24(s1)
ffffffffc0204be2:	467d                	li	a2,31
ffffffffc0204be4:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204be8:	bf5fe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204bec:	2e050b63          	beqz	a0,ffffffffc0204ee2 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204bf0:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204bf2:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bf6:	6c94                	ld	a3,24(s1)
ffffffffc0204bf8:	2785                	addiw	a5,a5,1
ffffffffc0204bfa:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204bfc:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bfe:	c02007b7          	lui	a5,0xc0200
ffffffffc0204c02:	2cf6e463          	bltu	a3,a5,ffffffffc0204eca <do_execve+0x47c>
ffffffffc0204c06:	000b3783          	ld	a5,0(s6)
ffffffffc0204c0a:	577d                	li	a4,-1
ffffffffc0204c0c:	177e                	slli	a4,a4,0x3f
ffffffffc0204c0e:	8e9d                	sub	a3,a3,a5
ffffffffc0204c10:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204c14:	f654                	sd	a3,168(a2)
ffffffffc0204c16:	8fd9                	or	a5,a5,a4
ffffffffc0204c18:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204c1c:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c1e:	4581                	li	a1,0
ffffffffc0204c20:	12000613          	li	a2,288
ffffffffc0204c24:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204c26:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c2a:	4b1000ef          	jal	ra,ffffffffc02058da <memset>
    tf->epc = elf->e_entry;
ffffffffc0204c2e:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c30:	000db903          	ld	s2,0(s11)
    sstatus &= ~SSTATUS_SPP;   // 清 SPP
ffffffffc0204c34:	eff4f493          	andi	s1,s1,-257
    tf->epc = elf->e_entry;
ffffffffc0204c38:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c3a:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c3c:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f7c>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c40:	07fe                	slli	a5,a5,0x1f
    sstatus |= SSTATUS_SPIE;   // 置 SPIE
ffffffffc0204c42:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c46:	4641                	li	a2,16
ffffffffc0204c48:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c4a:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204c4c:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus;
ffffffffc0204c50:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c54:	854a                	mv	a0,s2
ffffffffc0204c56:	485000ef          	jal	ra,ffffffffc02058da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204c5a:	463d                	li	a2,15
ffffffffc0204c5c:	180c                	addi	a1,sp,48
ffffffffc0204c5e:	854a                	mv	a0,s2
ffffffffc0204c60:	48d000ef          	jal	ra,ffffffffc02058ec <memcpy>
}
ffffffffc0204c64:	70aa                	ld	ra,168(sp)
ffffffffc0204c66:	740a                	ld	s0,160(sp)
ffffffffc0204c68:	64ea                	ld	s1,152(sp)
ffffffffc0204c6a:	694a                	ld	s2,144(sp)
ffffffffc0204c6c:	69aa                	ld	s3,136(sp)
ffffffffc0204c6e:	7ae6                	ld	s5,120(sp)
ffffffffc0204c70:	7b46                	ld	s6,112(sp)
ffffffffc0204c72:	7ba6                	ld	s7,104(sp)
ffffffffc0204c74:	7c06                	ld	s8,96(sp)
ffffffffc0204c76:	6ce6                	ld	s9,88(sp)
ffffffffc0204c78:	6d46                	ld	s10,80(sp)
ffffffffc0204c7a:	6da6                	ld	s11,72(sp)
ffffffffc0204c7c:	8552                	mv	a0,s4
ffffffffc0204c7e:	6a0a                	ld	s4,128(sp)
ffffffffc0204c80:	614d                	addi	sp,sp,176
ffffffffc0204c82:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204c84:	463d                	li	a2,15
ffffffffc0204c86:	85ca                	mv	a1,s2
ffffffffc0204c88:	1808                	addi	a0,sp,48
ffffffffc0204c8a:	463000ef          	jal	ra,ffffffffc02058ec <memcpy>
    if (mm != NULL)
ffffffffc0204c8e:	e20991e3          	bnez	s3,ffffffffc0204ab0 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204c92:	000db783          	ld	a5,0(s11)
ffffffffc0204c96:	779c                	ld	a5,40(a5)
ffffffffc0204c98:	e40788e3          	beqz	a5,ffffffffc0204ae8 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c9c:	00002617          	auipc	a2,0x2
ffffffffc0204ca0:	6f460613          	addi	a2,a2,1780 # ffffffffc0207390 <default_pmm_manager+0xbc0>
ffffffffc0204ca4:	27900593          	li	a1,633
ffffffffc0204ca8:	00002517          	auipc	a0,0x2
ffffffffc0204cac:	50850513          	addi	a0,a0,1288 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204cb0:	fdefb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204cb4:	8526                	mv	a0,s1
ffffffffc0204cb6:	c16ff0ef          	jal	ra,ffffffffc02040cc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204cba:	8526                	mv	a0,s1
ffffffffc0204cbc:	d47fe0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204cc0:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204cc2:	8552                	mv	a0,s4
ffffffffc0204cc4:	94bff0ef          	jal	ra,ffffffffc020460e <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204cc8:	5a71                	li	s4,-4
ffffffffc0204cca:	bfe5                	j	ffffffffc0204cc2 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204ccc:	0289b603          	ld	a2,40(s3)
ffffffffc0204cd0:	0209b783          	ld	a5,32(s3)
ffffffffc0204cd4:	1cf66d63          	bltu	a2,a5,ffffffffc0204eae <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204cd8:	0049a783          	lw	a5,4(s3)
ffffffffc0204cdc:	0017f693          	andi	a3,a5,1
ffffffffc0204ce0:	c291                	beqz	a3,ffffffffc0204ce4 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204ce2:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ce4:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ce8:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204cea:	e779                	bnez	a4,ffffffffc0204db8 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204cec:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204cee:	c781                	beqz	a5,ffffffffc0204cf6 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204cf0:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204cf4:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204cf6:	0026f793          	andi	a5,a3,2
ffffffffc0204cfa:	e3f1                	bnez	a5,ffffffffc0204dbe <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204cfc:	0046f793          	andi	a5,a3,4
ffffffffc0204d00:	c399                	beqz	a5,ffffffffc0204d06 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204d02:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204d06:	0109b583          	ld	a1,16(s3)
ffffffffc0204d0a:	4701                	li	a4,0
ffffffffc0204d0c:	8526                	mv	a0,s1
ffffffffc0204d0e:	d47fe0ef          	jal	ra,ffffffffc0203a54 <mm_map>
ffffffffc0204d12:	8a2a                	mv	s4,a0
ffffffffc0204d14:	ed35                	bnez	a0,ffffffffc0204d90 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d16:	0109bb83          	ld	s7,16(s3)
ffffffffc0204d1a:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d1c:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d20:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d24:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d28:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d2a:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d2c:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204d2e:	054be963          	bltu	s7,s4,ffffffffc0204d80 <do_execve+0x332>
ffffffffc0204d32:	aa95                	j	ffffffffc0204ea6 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d34:	6785                	lui	a5,0x1
ffffffffc0204d36:	415b8533          	sub	a0,s7,s5
ffffffffc0204d3a:	9abe                	add	s5,s5,a5
ffffffffc0204d3c:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204d40:	015a7463          	bgeu	s4,s5,ffffffffc0204d48 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204d44:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204d48:	000cb683          	ld	a3,0(s9)
ffffffffc0204d4c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d4e:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204d52:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d56:	8699                	srai	a3,a3,0x6
ffffffffc0204d58:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204d5a:	67e2                	ld	a5,24(sp)
ffffffffc0204d5c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d60:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d62:	14b87863          	bgeu	a6,a1,ffffffffc0204eb2 <do_execve+0x464>
ffffffffc0204d66:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d6a:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204d6c:	9bb2                	add	s7,s7,a2
ffffffffc0204d6e:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d70:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204d72:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d74:	379000ef          	jal	ra,ffffffffc02058ec <memcpy>
            start += size, from += size;
ffffffffc0204d78:	6622                	ld	a2,8(sp)
ffffffffc0204d7a:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204d7c:	054bf363          	bgeu	s7,s4,ffffffffc0204dc2 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204d80:	6c88                	ld	a0,24(s1)
ffffffffc0204d82:	866a                	mv	a2,s10
ffffffffc0204d84:	85d6                	mv	a1,s5
ffffffffc0204d86:	a57fe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204d8a:	842a                	mv	s0,a0
ffffffffc0204d8c:	f545                	bnez	a0,ffffffffc0204d34 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204d8e:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204d90:	8526                	mv	a0,s1
ffffffffc0204d92:	e0dfe0ef          	jal	ra,ffffffffc0203b9e <exit_mmap>
    put_pgdir(mm);
ffffffffc0204d96:	8526                	mv	a0,s1
ffffffffc0204d98:	b34ff0ef          	jal	ra,ffffffffc02040cc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204d9c:	8526                	mv	a0,s1
ffffffffc0204d9e:	c65fe0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>
    return ret;
ffffffffc0204da2:	b705                	j	ffffffffc0204cc2 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204da4:	854e                	mv	a0,s3
ffffffffc0204da6:	df9fe0ef          	jal	ra,ffffffffc0203b9e <exit_mmap>
            put_pgdir(mm);
ffffffffc0204daa:	854e                	mv	a0,s3
ffffffffc0204dac:	b20ff0ef          	jal	ra,ffffffffc02040cc <put_pgdir>
            mm_destroy(mm);
ffffffffc0204db0:	854e                	mv	a0,s3
ffffffffc0204db2:	c51fe0ef          	jal	ra,ffffffffc0203a02 <mm_destroy>
ffffffffc0204db6:	b32d                	j	ffffffffc0204ae0 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204db8:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dbc:	fb95                	bnez	a5,ffffffffc0204cf0 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204dbe:	4d5d                	li	s10,23
ffffffffc0204dc0:	bf35                	j	ffffffffc0204cfc <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204dc2:	0109b683          	ld	a3,16(s3)
ffffffffc0204dc6:	0289b903          	ld	s2,40(s3)
ffffffffc0204dca:	9936                	add	s2,s2,a3
        if (start < la)//the last page not used up entirely,we shall do zero-fill
ffffffffc0204dcc:	075bfd63          	bgeu	s7,s5,ffffffffc0204e46 <do_execve+0x3f8>
            if (start == end)//len(bss)==0..
ffffffffc0204dd0:	db790fe3          	beq	s2,s7,ffffffffc0204b8e <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204dd4:	6785                	lui	a5,0x1
ffffffffc0204dd6:	00fb8533          	add	a0,s7,a5
ffffffffc0204dda:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204dde:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204de2:	0b597d63          	bgeu	s2,s5,ffffffffc0204e9c <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204de6:	000cb683          	ld	a3,0(s9)
ffffffffc0204dea:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204dec:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204df0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204df4:	8699                	srai	a3,a3,0x6
ffffffffc0204df6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204df8:	67e2                	ld	a5,24(sp)
ffffffffc0204dfa:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204dfe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e00:	0ac5f963          	bgeu	a1,a2,ffffffffc0204eb2 <do_execve+0x464>
ffffffffc0204e04:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);//zfill bss
ffffffffc0204e08:	8652                	mv	a2,s4
ffffffffc0204e0a:	4581                	li	a1,0
ffffffffc0204e0c:	96c2                	add	a3,a3,a6
ffffffffc0204e0e:	9536                	add	a0,a0,a3
ffffffffc0204e10:	2cb000ef          	jal	ra,ffffffffc02058da <memset>
            start += size;
ffffffffc0204e14:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204e18:	03597463          	bgeu	s2,s5,ffffffffc0204e40 <do_execve+0x3f2>
ffffffffc0204e1c:	d6e909e3          	beq	s2,a4,ffffffffc0204b8e <do_execve+0x140>
ffffffffc0204e20:	00002697          	auipc	a3,0x2
ffffffffc0204e24:	59868693          	addi	a3,a3,1432 # ffffffffc02073b8 <default_pmm_manager+0xbe8>
ffffffffc0204e28:	00001617          	auipc	a2,0x1
ffffffffc0204e2c:	5f860613          	addi	a2,a2,1528 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204e30:	2f800593          	li	a1,760
ffffffffc0204e34:	00002517          	auipc	a0,0x2
ffffffffc0204e38:	37c50513          	addi	a0,a0,892 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204e3c:	e52fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204e40:	ff5710e3          	bne	a4,s5,ffffffffc0204e20 <do_execve+0x3d2>
ffffffffc0204e44:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204e46:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204b8e <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e4a:	6c88                	ld	a0,24(s1)
ffffffffc0204e4c:	866a                	mv	a2,s10
ffffffffc0204e4e:	85d6                	mv	a1,s5
ffffffffc0204e50:	98dfe0ef          	jal	ra,ffffffffc02037dc <pgdir_alloc_page>
ffffffffc0204e54:	842a                	mv	s0,a0
ffffffffc0204e56:	dd05                	beqz	a0,ffffffffc0204d8e <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e58:	6785                	lui	a5,0x1
ffffffffc0204e5a:	415b8533          	sub	a0,s7,s5
ffffffffc0204e5e:	9abe                	add	s5,s5,a5
ffffffffc0204e60:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204e64:	01597463          	bgeu	s2,s5,ffffffffc0204e6c <do_execve+0x41e>
                size -= la - end;
ffffffffc0204e68:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204e6c:	000cb683          	ld	a3,0(s9)
ffffffffc0204e70:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e72:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204e76:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e7a:	8699                	srai	a3,a3,0x6
ffffffffc0204e7c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e7e:	67e2                	ld	a5,24(sp)
ffffffffc0204e80:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e84:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e86:	02b87663          	bgeu	a6,a1,ffffffffc0204eb2 <do_execve+0x464>
ffffffffc0204e8a:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e8e:	4581                	li	a1,0
            start += size;
ffffffffc0204e90:	9bb2                	add	s7,s7,a2
ffffffffc0204e92:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e94:	9536                	add	a0,a0,a3
ffffffffc0204e96:	245000ef          	jal	ra,ffffffffc02058da <memset>
ffffffffc0204e9a:	b775                	j	ffffffffc0204e46 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204e9c:	417a8a33          	sub	s4,s5,s7
ffffffffc0204ea0:	b799                	j	ffffffffc0204de6 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204ea2:	5a75                	li	s4,-3
ffffffffc0204ea4:	b3c1                	j	ffffffffc0204c64 <do_execve+0x216>
        while (start < end)
ffffffffc0204ea6:	86de                	mv	a3,s7
ffffffffc0204ea8:	bf39                	j	ffffffffc0204dc6 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204eaa:	5a71                	li	s4,-4
ffffffffc0204eac:	bdc5                	j	ffffffffc0204d9c <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204eae:	5a61                	li	s4,-8
ffffffffc0204eb0:	b5c5                	j	ffffffffc0204d90 <do_execve+0x342>
ffffffffc0204eb2:	00001617          	auipc	a2,0x1
ffffffffc0204eb6:	4de60613          	addi	a2,a2,1246 # ffffffffc0206390 <commands+0x820>
ffffffffc0204eba:	07100593          	li	a1,113
ffffffffc0204ebe:	00001517          	auipc	a0,0x1
ffffffffc0204ec2:	48a50513          	addi	a0,a0,1162 # ffffffffc0206348 <commands+0x7d8>
ffffffffc0204ec6:	dc8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204eca:	00002617          	auipc	a2,0x2
ffffffffc0204ece:	9ae60613          	addi	a2,a2,-1618 # ffffffffc0206878 <default_pmm_manager+0xa8>
ffffffffc0204ed2:	31b00593          	li	a1,795
ffffffffc0204ed6:	00002517          	auipc	a0,0x2
ffffffffc0204eda:	2da50513          	addi	a0,a0,730 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204ede:	db0fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ee2:	00002697          	auipc	a3,0x2
ffffffffc0204ee6:	5ee68693          	addi	a3,a3,1518 # ffffffffc02074d0 <default_pmm_manager+0xd00>
ffffffffc0204eea:	00001617          	auipc	a2,0x1
ffffffffc0204eee:	53660613          	addi	a2,a2,1334 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204ef2:	31600593          	li	a1,790
ffffffffc0204ef6:	00002517          	auipc	a0,0x2
ffffffffc0204efa:	2ba50513          	addi	a0,a0,698 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204efe:	d90fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f02:	00002697          	auipc	a3,0x2
ffffffffc0204f06:	58668693          	addi	a3,a3,1414 # ffffffffc0207488 <default_pmm_manager+0xcb8>
ffffffffc0204f0a:	00001617          	auipc	a2,0x1
ffffffffc0204f0e:	51660613          	addi	a2,a2,1302 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204f12:	31500593          	li	a1,789
ffffffffc0204f16:	00002517          	auipc	a0,0x2
ffffffffc0204f1a:	29a50513          	addi	a0,a0,666 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204f1e:	d70fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f22:	00002697          	auipc	a3,0x2
ffffffffc0204f26:	51e68693          	addi	a3,a3,1310 # ffffffffc0207440 <default_pmm_manager+0xc70>
ffffffffc0204f2a:	00001617          	auipc	a2,0x1
ffffffffc0204f2e:	4f660613          	addi	a2,a2,1270 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204f32:	31400593          	li	a1,788
ffffffffc0204f36:	00002517          	auipc	a0,0x2
ffffffffc0204f3a:	27a50513          	addi	a0,a0,634 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204f3e:	d50fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204f42:	00002697          	auipc	a3,0x2
ffffffffc0204f46:	4b668693          	addi	a3,a3,1206 # ffffffffc02073f8 <default_pmm_manager+0xc28>
ffffffffc0204f4a:	00001617          	auipc	a2,0x1
ffffffffc0204f4e:	4d660613          	addi	a2,a2,1238 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0204f52:	31300593          	li	a1,787
ffffffffc0204f56:	00002517          	auipc	a0,0x2
ffffffffc0204f5a:	25a50513          	addi	a0,a0,602 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0204f5e:	d30fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f62 <do_yield>:
    current->need_resched = 1;
ffffffffc0204f62:	000ce797          	auipc	a5,0xce
ffffffffc0204f66:	42e7b783          	ld	a5,1070(a5) # ffffffffc02d3390 <current>
ffffffffc0204f6a:	4705                	li	a4,1
ffffffffc0204f6c:	ef98                	sd	a4,24(a5)
}
ffffffffc0204f6e:	4501                	li	a0,0
ffffffffc0204f70:	8082                	ret

ffffffffc0204f72 <do_wait>:
{
ffffffffc0204f72:	1101                	addi	sp,sp,-32
ffffffffc0204f74:	e822                	sd	s0,16(sp)
ffffffffc0204f76:	e426                	sd	s1,8(sp)
ffffffffc0204f78:	ec06                	sd	ra,24(sp)
ffffffffc0204f7a:	842e                	mv	s0,a1
ffffffffc0204f7c:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204f7e:	c999                	beqz	a1,ffffffffc0204f94 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204f80:	000ce797          	auipc	a5,0xce
ffffffffc0204f84:	4107b783          	ld	a5,1040(a5) # ffffffffc02d3390 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f88:	7788                	ld	a0,40(a5)
ffffffffc0204f8a:	4685                	li	a3,1
ffffffffc0204f8c:	4611                	li	a2,4
ffffffffc0204f8e:	fabfe0ef          	jal	ra,ffffffffc0203f38 <user_mem_check>
ffffffffc0204f92:	c909                	beqz	a0,ffffffffc0204fa4 <do_wait+0x32>
ffffffffc0204f94:	85a2                	mv	a1,s0
}
ffffffffc0204f96:	6442                	ld	s0,16(sp)
ffffffffc0204f98:	60e2                	ld	ra,24(sp)
ffffffffc0204f9a:	8526                	mv	a0,s1
ffffffffc0204f9c:	64a2                	ld	s1,8(sp)
ffffffffc0204f9e:	6105                	addi	sp,sp,32
ffffffffc0204fa0:	fb8ff06f          	j	ffffffffc0204758 <do_wait.part.0>
ffffffffc0204fa4:	60e2                	ld	ra,24(sp)
ffffffffc0204fa6:	6442                	ld	s0,16(sp)
ffffffffc0204fa8:	64a2                	ld	s1,8(sp)
ffffffffc0204faa:	5575                	li	a0,-3
ffffffffc0204fac:	6105                	addi	sp,sp,32
ffffffffc0204fae:	8082                	ret

ffffffffc0204fb0 <do_kill>:
{
ffffffffc0204fb0:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fb2:	6789                	lui	a5,0x2
{
ffffffffc0204fb4:	e406                	sd	ra,8(sp)
ffffffffc0204fb6:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fb8:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204fbc:	17f9                	addi	a5,a5,-2
ffffffffc0204fbe:	02e7e963          	bltu	a5,a4,ffffffffc0204ff0 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fc2:	842a                	mv	s0,a0
ffffffffc0204fc4:	45a9                	li	a1,10
ffffffffc0204fc6:	2501                	sext.w	a0,a0
ffffffffc0204fc8:	46c000ef          	jal	ra,ffffffffc0205434 <hash32>
ffffffffc0204fcc:	02051793          	slli	a5,a0,0x20
ffffffffc0204fd0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204fd4:	000ca797          	auipc	a5,0xca
ffffffffc0204fd8:	34c78793          	addi	a5,a5,844 # ffffffffc02cf320 <hash_list>
ffffffffc0204fdc:	953e                	add	a0,a0,a5
ffffffffc0204fde:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204fe0:	a029                	j	ffffffffc0204fea <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204fe2:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204fe6:	00870b63          	beq	a4,s0,ffffffffc0204ffc <do_kill+0x4c>
ffffffffc0204fea:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204fec:	fef51be3          	bne	a0,a5,ffffffffc0204fe2 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204ff0:	5475                	li	s0,-3
}
ffffffffc0204ff2:	60a2                	ld	ra,8(sp)
ffffffffc0204ff4:	8522                	mv	a0,s0
ffffffffc0204ff6:	6402                	ld	s0,0(sp)
ffffffffc0204ff8:	0141                	addi	sp,sp,16
ffffffffc0204ffa:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204ffc:	fd87a703          	lw	a4,-40(a5)
ffffffffc0205000:	00177693          	andi	a3,a4,1
ffffffffc0205004:	e295                	bnez	a3,ffffffffc0205028 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205006:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0205008:	00176713          	ori	a4,a4,1
ffffffffc020500c:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0205010:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205012:	fe06d0e3          	bgez	a3,ffffffffc0204ff2 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0205016:	f2878513          	addi	a0,a5,-216
ffffffffc020501a:	22e000ef          	jal	ra,ffffffffc0205248 <wakeup_proc>
}
ffffffffc020501e:	60a2                	ld	ra,8(sp)
ffffffffc0205020:	8522                	mv	a0,s0
ffffffffc0205022:	6402                	ld	s0,0(sp)
ffffffffc0205024:	0141                	addi	sp,sp,16
ffffffffc0205026:	8082                	ret
        return -E_KILLED;
ffffffffc0205028:	545d                	li	s0,-9
ffffffffc020502a:	b7e1                	j	ffffffffc0204ff2 <do_kill+0x42>

ffffffffc020502c <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc020502c:	1101                	addi	sp,sp,-32
ffffffffc020502e:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205030:	000ce797          	auipc	a5,0xce
ffffffffc0205034:	2f078793          	addi	a5,a5,752 # ffffffffc02d3320 <proc_list>
ffffffffc0205038:	ec06                	sd	ra,24(sp)
ffffffffc020503a:	e822                	sd	s0,16(sp)
ffffffffc020503c:	e04a                	sd	s2,0(sp)
ffffffffc020503e:	000ca497          	auipc	s1,0xca
ffffffffc0205042:	2e248493          	addi	s1,s1,738 # ffffffffc02cf320 <hash_list>
ffffffffc0205046:	e79c                	sd	a5,8(a5)
ffffffffc0205048:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020504a:	000ce717          	auipc	a4,0xce
ffffffffc020504e:	2d670713          	addi	a4,a4,726 # ffffffffc02d3320 <proc_list>
ffffffffc0205052:	87a6                	mv	a5,s1
ffffffffc0205054:	e79c                	sd	a5,8(a5)
ffffffffc0205056:	e39c                	sd	a5,0(a5)
ffffffffc0205058:	07c1                	addi	a5,a5,16
ffffffffc020505a:	fef71de3          	bne	a4,a5,ffffffffc0205054 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020505e:	f77fe0ef          	jal	ra,ffffffffc0203fd4 <alloc_proc>
ffffffffc0205062:	000ce917          	auipc	s2,0xce
ffffffffc0205066:	33690913          	addi	s2,s2,822 # ffffffffc02d3398 <idleproc>
ffffffffc020506a:	00a93023          	sd	a0,0(s2)
ffffffffc020506e:	0e050f63          	beqz	a0,ffffffffc020516c <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205072:	4789                	li	a5,2
ffffffffc0205074:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205076:	00003797          	auipc	a5,0x3
ffffffffc020507a:	f8a78793          	addi	a5,a5,-118 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020507e:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205082:	e91c                	sd	a5,16(a0)
    //for cpu_idle resc branch
    idleproc->need_resched = 1;
ffffffffc0205084:	4785                	li	a5,1
ffffffffc0205086:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205088:	4641                	li	a2,16
ffffffffc020508a:	4581                	li	a1,0
ffffffffc020508c:	8522                	mv	a0,s0
ffffffffc020508e:	04d000ef          	jal	ra,ffffffffc02058da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205092:	463d                	li	a2,15
ffffffffc0205094:	00002597          	auipc	a1,0x2
ffffffffc0205098:	49c58593          	addi	a1,a1,1180 # ffffffffc0207530 <default_pmm_manager+0xd60>
ffffffffc020509c:	8522                	mv	a0,s0
ffffffffc020509e:	04f000ef          	jal	ra,ffffffffc02058ec <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02050a2:	000ce717          	auipc	a4,0xce
ffffffffc02050a6:	30670713          	addi	a4,a4,774 # ffffffffc02d33a8 <nr_process>
ffffffffc02050aa:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02050ac:	00093683          	ld	a3,0(s2)
//----------------below are init_main init------------------
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050b0:	4601                	li	a2,0
    nr_process++;
ffffffffc02050b2:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050b4:	4581                	li	a1,0
ffffffffc02050b6:	00000517          	auipc	a0,0x0
ffffffffc02050ba:	87450513          	addi	a0,a0,-1932 # ffffffffc020492a <init_main>
    nr_process++;
ffffffffc02050be:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02050c0:	000ce797          	auipc	a5,0xce
ffffffffc02050c4:	2cd7b823          	sd	a3,720(a5) # ffffffffc02d3390 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050c8:	cf6ff0ef          	jal	ra,ffffffffc02045be <kernel_thread>
ffffffffc02050cc:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02050ce:	08a05363          	blez	a0,ffffffffc0205154 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02050d2:	6789                	lui	a5,0x2
ffffffffc02050d4:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050d8:	17f9                	addi	a5,a5,-2
ffffffffc02050da:	2501                	sext.w	a0,a0
ffffffffc02050dc:	02e7e363          	bltu	a5,a4,ffffffffc0205102 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050e0:	45a9                	li	a1,10
ffffffffc02050e2:	352000ef          	jal	ra,ffffffffc0205434 <hash32>
ffffffffc02050e6:	02051793          	slli	a5,a0,0x20
ffffffffc02050ea:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02050ee:	96a6                	add	a3,a3,s1
ffffffffc02050f0:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02050f2:	a029                	j	ffffffffc02050fc <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02050f4:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c94>
ffffffffc02050f8:	04870b63          	beq	a4,s0,ffffffffc020514e <proc_init+0x122>
    return listelm->next;
ffffffffc02050fc:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050fe:	fef69be3          	bne	a3,a5,ffffffffc02050f4 <proc_init+0xc8>
    return NULL;
ffffffffc0205102:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205104:	0b478493          	addi	s1,a5,180
ffffffffc0205108:	4641                	li	a2,16
ffffffffc020510a:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020510c:	000ce417          	auipc	s0,0xce
ffffffffc0205110:	29440413          	addi	s0,s0,660 # ffffffffc02d33a0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205114:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205116:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205118:	7c2000ef          	jal	ra,ffffffffc02058da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020511c:	463d                	li	a2,15
ffffffffc020511e:	00002597          	auipc	a1,0x2
ffffffffc0205122:	43a58593          	addi	a1,a1,1082 # ffffffffc0207558 <default_pmm_manager+0xd88>
ffffffffc0205126:	8526                	mv	a0,s1
ffffffffc0205128:	7c4000ef          	jal	ra,ffffffffc02058ec <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020512c:	00093783          	ld	a5,0(s2)
ffffffffc0205130:	cbb5                	beqz	a5,ffffffffc02051a4 <proc_init+0x178>
ffffffffc0205132:	43dc                	lw	a5,4(a5)
ffffffffc0205134:	eba5                	bnez	a5,ffffffffc02051a4 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205136:	601c                	ld	a5,0(s0)
ffffffffc0205138:	c7b1                	beqz	a5,ffffffffc0205184 <proc_init+0x158>
ffffffffc020513a:	43d8                	lw	a4,4(a5)
ffffffffc020513c:	4785                	li	a5,1
ffffffffc020513e:	04f71363          	bne	a4,a5,ffffffffc0205184 <proc_init+0x158>
}
ffffffffc0205142:	60e2                	ld	ra,24(sp)
ffffffffc0205144:	6442                	ld	s0,16(sp)
ffffffffc0205146:	64a2                	ld	s1,8(sp)
ffffffffc0205148:	6902                	ld	s2,0(sp)
ffffffffc020514a:	6105                	addi	sp,sp,32
ffffffffc020514c:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020514e:	f2878793          	addi	a5,a5,-216
ffffffffc0205152:	bf4d                	j	ffffffffc0205104 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0205154:	00002617          	auipc	a2,0x2
ffffffffc0205158:	3e460613          	addi	a2,a2,996 # ffffffffc0207538 <default_pmm_manager+0xd68>
ffffffffc020515c:	48900593          	li	a1,1161
ffffffffc0205160:	00002517          	auipc	a0,0x2
ffffffffc0205164:	05050513          	addi	a0,a0,80 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0205168:	b26fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020516c:	00002617          	auipc	a2,0x2
ffffffffc0205170:	3ac60613          	addi	a2,a2,940 # ffffffffc0207518 <default_pmm_manager+0xd48>
ffffffffc0205174:	47900593          	li	a1,1145
ffffffffc0205178:	00002517          	auipc	a0,0x2
ffffffffc020517c:	03850513          	addi	a0,a0,56 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc0205180:	b0efb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205184:	00002697          	auipc	a3,0x2
ffffffffc0205188:	40468693          	addi	a3,a3,1028 # ffffffffc0207588 <default_pmm_manager+0xdb8>
ffffffffc020518c:	00001617          	auipc	a2,0x1
ffffffffc0205190:	29460613          	addi	a2,a2,660 # ffffffffc0206420 <commands+0x8b0>
ffffffffc0205194:	49000593          	li	a1,1168
ffffffffc0205198:	00002517          	auipc	a0,0x2
ffffffffc020519c:	01850513          	addi	a0,a0,24 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02051a0:	aeefb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02051a4:	00002697          	auipc	a3,0x2
ffffffffc02051a8:	3bc68693          	addi	a3,a3,956 # ffffffffc0207560 <default_pmm_manager+0xd90>
ffffffffc02051ac:	00001617          	auipc	a2,0x1
ffffffffc02051b0:	27460613          	addi	a2,a2,628 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02051b4:	48f00593          	li	a1,1167
ffffffffc02051b8:	00002517          	auipc	a0,0x2
ffffffffc02051bc:	ff850513          	addi	a0,a0,-8 # ffffffffc02071b0 <default_pmm_manager+0x9e0>
ffffffffc02051c0:	acefb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02051c4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02051c4:	1141                	addi	sp,sp,-16
ffffffffc02051c6:	e022                	sd	s0,0(sp)
ffffffffc02051c8:	e406                	sd	ra,8(sp)
ffffffffc02051ca:	000ce417          	auipc	s0,0xce
ffffffffc02051ce:	1c640413          	addi	s0,s0,454 # ffffffffc02d3390 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02051d2:	6018                	ld	a4,0(s0)
ffffffffc02051d4:	6f1c                	ld	a5,24(a4)
ffffffffc02051d6:	dffd                	beqz	a5,ffffffffc02051d4 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02051d8:	0f0000ef          	jal	ra,ffffffffc02052c8 <schedule>
ffffffffc02051dc:	bfdd                	j	ffffffffc02051d2 <cpu_idle+0xe>

ffffffffc02051de <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02051de:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02051e2:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02051e6:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02051e8:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02051ea:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02051ee:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02051f2:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02051f6:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02051fa:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02051fe:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205202:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205206:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020520a:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020520e:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205212:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205216:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020521a:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020521c:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020521e:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205222:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205226:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020522a:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020522e:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205232:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205236:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020523a:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020523e:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205242:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205246:	8082                	ret

ffffffffc0205248 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205248:	4118                	lw	a4,0(a0)
{
ffffffffc020524a:	1101                	addi	sp,sp,-32
ffffffffc020524c:	ec06                	sd	ra,24(sp)
ffffffffc020524e:	e822                	sd	s0,16(sp)
ffffffffc0205250:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205252:	478d                	li	a5,3
ffffffffc0205254:	04f70b63          	beq	a4,a5,ffffffffc02052aa <wakeup_proc+0x62>
ffffffffc0205258:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020525a:	100027f3          	csrr	a5,sstatus
ffffffffc020525e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205260:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205262:	ef9d                	bnez	a5,ffffffffc02052a0 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205264:	4789                	li	a5,2
ffffffffc0205266:	02f70163          	beq	a4,a5,ffffffffc0205288 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc020526a:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020526c:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205270:	e491                	bnez	s1,ffffffffc020527c <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205272:	60e2                	ld	ra,24(sp)
ffffffffc0205274:	6442                	ld	s0,16(sp)
ffffffffc0205276:	64a2                	ld	s1,8(sp)
ffffffffc0205278:	6105                	addi	sp,sp,32
ffffffffc020527a:	8082                	ret
ffffffffc020527c:	6442                	ld	s0,16(sp)
ffffffffc020527e:	60e2                	ld	ra,24(sp)
ffffffffc0205280:	64a2                	ld	s1,8(sp)
ffffffffc0205282:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205284:	f2afb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205288:	00002617          	auipc	a2,0x2
ffffffffc020528c:	36060613          	addi	a2,a2,864 # ffffffffc02075e8 <default_pmm_manager+0xe18>
ffffffffc0205290:	45d1                	li	a1,20
ffffffffc0205292:	00002517          	auipc	a0,0x2
ffffffffc0205296:	33e50513          	addi	a0,a0,830 # ffffffffc02075d0 <default_pmm_manager+0xe00>
ffffffffc020529a:	a5cfb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc020529e:	bfc9                	j	ffffffffc0205270 <wakeup_proc+0x28>
        intr_disable();
ffffffffc02052a0:	f14fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02052a4:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc02052a6:	4485                	li	s1,1
ffffffffc02052a8:	bf75                	j	ffffffffc0205264 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02052aa:	00002697          	auipc	a3,0x2
ffffffffc02052ae:	30668693          	addi	a3,a3,774 # ffffffffc02075b0 <default_pmm_manager+0xde0>
ffffffffc02052b2:	00001617          	auipc	a2,0x1
ffffffffc02052b6:	16e60613          	addi	a2,a2,366 # ffffffffc0206420 <commands+0x8b0>
ffffffffc02052ba:	45a5                	li	a1,9
ffffffffc02052bc:	00002517          	auipc	a0,0x2
ffffffffc02052c0:	31450513          	addi	a0,a0,788 # ffffffffc02075d0 <default_pmm_manager+0xe00>
ffffffffc02052c4:	9cafb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02052c8 <schedule>:

void schedule(void)
{
ffffffffc02052c8:	1141                	addi	sp,sp,-16
ffffffffc02052ca:	e406                	sd	ra,8(sp)
ffffffffc02052cc:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02052ce:	100027f3          	csrr	a5,sstatus
ffffffffc02052d2:	8b89                	andi	a5,a5,2
ffffffffc02052d4:	4401                	li	s0,0
ffffffffc02052d6:	efbd                	bnez	a5,ffffffffc0205354 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02052d8:	000ce897          	auipc	a7,0xce
ffffffffc02052dc:	0b88b883          	ld	a7,184(a7) # ffffffffc02d3390 <current>
ffffffffc02052e0:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02052e4:	000ce517          	auipc	a0,0xce
ffffffffc02052e8:	0b453503          	ld	a0,180(a0) # ffffffffc02d3398 <idleproc>
ffffffffc02052ec:	04a88e63          	beq	a7,a0,ffffffffc0205348 <schedule+0x80>
ffffffffc02052f0:	0c888693          	addi	a3,a7,200
ffffffffc02052f4:	000ce617          	auipc	a2,0xce
ffffffffc02052f8:	02c60613          	addi	a2,a2,44 # ffffffffc02d3320 <proc_list>
        le = last;
ffffffffc02052fc:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02052fe:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205300:	4809                	li	a6,2
ffffffffc0205302:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205304:	00c78863          	beq	a5,a2,ffffffffc0205314 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205308:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020530c:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205310:	03070163          	beq	a4,a6,ffffffffc0205332 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205314:	fef697e3          	bne	a3,a5,ffffffffc0205302 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205318:	ed89                	bnez	a1,ffffffffc0205332 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020531a:	451c                	lw	a5,8(a0)
ffffffffc020531c:	2785                	addiw	a5,a5,1
ffffffffc020531e:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205320:	00a88463          	beq	a7,a0,ffffffffc0205328 <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205324:	e1ffe0ef          	jal	ra,ffffffffc0204142 <proc_run>
    if (flag)
ffffffffc0205328:	e819                	bnez	s0,ffffffffc020533e <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020532a:	60a2                	ld	ra,8(sp)
ffffffffc020532c:	6402                	ld	s0,0(sp)
ffffffffc020532e:	0141                	addi	sp,sp,16
ffffffffc0205330:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205332:	4198                	lw	a4,0(a1)
ffffffffc0205334:	4789                	li	a5,2
ffffffffc0205336:	fef712e3          	bne	a4,a5,ffffffffc020531a <schedule+0x52>
ffffffffc020533a:	852e                	mv	a0,a1
ffffffffc020533c:	bff9                	j	ffffffffc020531a <schedule+0x52>
}
ffffffffc020533e:	6402                	ld	s0,0(sp)
ffffffffc0205340:	60a2                	ld	ra,8(sp)
ffffffffc0205342:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205344:	e6afb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205348:	000ce617          	auipc	a2,0xce
ffffffffc020534c:	fd860613          	addi	a2,a2,-40 # ffffffffc02d3320 <proc_list>
ffffffffc0205350:	86b2                	mv	a3,a2
ffffffffc0205352:	b76d                	j	ffffffffc02052fc <schedule+0x34>
        intr_disable();
ffffffffc0205354:	e60fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205358:	4405                	li	s0,1
ffffffffc020535a:	bfbd                	j	ffffffffc02052d8 <schedule+0x10>

ffffffffc020535c <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020535c:	000ce797          	auipc	a5,0xce
ffffffffc0205360:	0347b783          	ld	a5,52(a5) # ffffffffc02d3390 <current>
}
ffffffffc0205364:	43c8                	lw	a0,4(a5)
ffffffffc0205366:	8082                	ret

ffffffffc0205368 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205368:	4501                	li	a0,0
ffffffffc020536a:	8082                	ret

ffffffffc020536c <sys_putc>:
    cputchar(c);
ffffffffc020536c:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020536e:	1141                	addi	sp,sp,-16
ffffffffc0205370:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205372:	e59fa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc0205376:	60a2                	ld	ra,8(sp)
ffffffffc0205378:	4501                	li	a0,0
ffffffffc020537a:	0141                	addi	sp,sp,16
ffffffffc020537c:	8082                	ret

ffffffffc020537e <sys_kill>:
    return do_kill(pid);
ffffffffc020537e:	4108                	lw	a0,0(a0)
ffffffffc0205380:	c31ff06f          	j	ffffffffc0204fb0 <do_kill>

ffffffffc0205384 <sys_yield>:
    return do_yield();
ffffffffc0205384:	bdfff06f          	j	ffffffffc0204f62 <do_yield>

ffffffffc0205388 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205388:	6d14                	ld	a3,24(a0)
ffffffffc020538a:	6910                	ld	a2,16(a0)
ffffffffc020538c:	650c                	ld	a1,8(a0)
ffffffffc020538e:	6108                	ld	a0,0(a0)
ffffffffc0205390:	ebeff06f          	j	ffffffffc0204a4e <do_execve>

ffffffffc0205394 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205394:	650c                	ld	a1,8(a0)
ffffffffc0205396:	4108                	lw	a0,0(a0)
ffffffffc0205398:	bdbff06f          	j	ffffffffc0204f72 <do_wait>

ffffffffc020539c <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020539c:	000ce797          	auipc	a5,0xce
ffffffffc02053a0:	ff47b783          	ld	a5,-12(a5) # ffffffffc02d3390 <current>
ffffffffc02053a4:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02053a6:	4501                	li	a0,0
ffffffffc02053a8:	6a0c                	ld	a1,16(a2)
ffffffffc02053aa:	e11fe06f          	j	ffffffffc02041ba <do_fork>

ffffffffc02053ae <sys_exit>:
    return do_exit(error_code);
ffffffffc02053ae:	4108                	lw	a0,0(a0)
ffffffffc02053b0:	a5eff06f          	j	ffffffffc020460e <do_exit>

ffffffffc02053b4 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02053b4:	715d                	addi	sp,sp,-80
ffffffffc02053b6:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053b8:	000ce497          	auipc	s1,0xce
ffffffffc02053bc:	fd848493          	addi	s1,s1,-40 # ffffffffc02d3390 <current>
ffffffffc02053c0:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02053c2:	e0a2                	sd	s0,64(sp)
ffffffffc02053c4:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053c6:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02053c8:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053ca:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02053cc:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053d0:	0327ee63          	bltu	a5,s2,ffffffffc020540c <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02053d4:	00391713          	slli	a4,s2,0x3
ffffffffc02053d8:	00002797          	auipc	a5,0x2
ffffffffc02053dc:	27878793          	addi	a5,a5,632 # ffffffffc0207650 <syscalls>
ffffffffc02053e0:	97ba                	add	a5,a5,a4
ffffffffc02053e2:	639c                	ld	a5,0(a5)
ffffffffc02053e4:	c785                	beqz	a5,ffffffffc020540c <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02053e6:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02053e8:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02053ea:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02053ec:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02053ee:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02053f0:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02053f2:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02053f4:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02053f6:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02053f8:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053fa:	0028                	addi	a0,sp,8
ffffffffc02053fc:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02053fe:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205400:	e828                	sd	a0,80(s0)
}
ffffffffc0205402:	6406                	ld	s0,64(sp)
ffffffffc0205404:	74e2                	ld	s1,56(sp)
ffffffffc0205406:	7942                	ld	s2,48(sp)
ffffffffc0205408:	6161                	addi	sp,sp,80
ffffffffc020540a:	8082                	ret
    print_trapframe(tf);
ffffffffc020540c:	8522                	mv	a0,s0
ffffffffc020540e:	f96fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205412:	609c                	ld	a5,0(s1)
ffffffffc0205414:	86ca                	mv	a3,s2
ffffffffc0205416:	00002617          	auipc	a2,0x2
ffffffffc020541a:	1f260613          	addi	a2,a2,498 # ffffffffc0207608 <default_pmm_manager+0xe38>
ffffffffc020541e:	43d8                	lw	a4,4(a5)
ffffffffc0205420:	06200593          	li	a1,98
ffffffffc0205424:	0b478793          	addi	a5,a5,180
ffffffffc0205428:	00002517          	auipc	a0,0x2
ffffffffc020542c:	21050513          	addi	a0,a0,528 # ffffffffc0207638 <default_pmm_manager+0xe68>
ffffffffc0205430:	85efb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205434 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205434:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205438:	2785                	addiw	a5,a5,1
ffffffffc020543a:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc020543e:	02000793          	li	a5,32
ffffffffc0205442:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205444:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205448:	8082                	ret

ffffffffc020544a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020544a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020544e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205450:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205454:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205456:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020545a:	f022                	sd	s0,32(sp)
ffffffffc020545c:	ec26                	sd	s1,24(sp)
ffffffffc020545e:	e84a                	sd	s2,16(sp)
ffffffffc0205460:	f406                	sd	ra,40(sp)
ffffffffc0205462:	e44e                	sd	s3,8(sp)
ffffffffc0205464:	84aa                	mv	s1,a0
ffffffffc0205466:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205468:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020546c:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020546e:	03067e63          	bgeu	a2,a6,ffffffffc02054aa <printnum+0x60>
ffffffffc0205472:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205474:	00805763          	blez	s0,ffffffffc0205482 <printnum+0x38>
ffffffffc0205478:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020547a:	85ca                	mv	a1,s2
ffffffffc020547c:	854e                	mv	a0,s3
ffffffffc020547e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205480:	fc65                	bnez	s0,ffffffffc0205478 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205482:	1a02                	slli	s4,s4,0x20
ffffffffc0205484:	00002797          	auipc	a5,0x2
ffffffffc0205488:	2cc78793          	addi	a5,a5,716 # ffffffffc0207750 <syscalls+0x100>
ffffffffc020548c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205490:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205492:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205494:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205498:	70a2                	ld	ra,40(sp)
ffffffffc020549a:	69a2                	ld	s3,8(sp)
ffffffffc020549c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020549e:	85ca                	mv	a1,s2
ffffffffc02054a0:	87a6                	mv	a5,s1
}
ffffffffc02054a2:	6942                	ld	s2,16(sp)
ffffffffc02054a4:	64e2                	ld	s1,24(sp)
ffffffffc02054a6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054a8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02054aa:	03065633          	divu	a2,a2,a6
ffffffffc02054ae:	8722                	mv	a4,s0
ffffffffc02054b0:	f9bff0ef          	jal	ra,ffffffffc020544a <printnum>
ffffffffc02054b4:	b7f9                	j	ffffffffc0205482 <printnum+0x38>

ffffffffc02054b6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02054b6:	7119                	addi	sp,sp,-128
ffffffffc02054b8:	f4a6                	sd	s1,104(sp)
ffffffffc02054ba:	f0ca                	sd	s2,96(sp)
ffffffffc02054bc:	ecce                	sd	s3,88(sp)
ffffffffc02054be:	e8d2                	sd	s4,80(sp)
ffffffffc02054c0:	e4d6                	sd	s5,72(sp)
ffffffffc02054c2:	e0da                	sd	s6,64(sp)
ffffffffc02054c4:	fc5e                	sd	s7,56(sp)
ffffffffc02054c6:	f06a                	sd	s10,32(sp)
ffffffffc02054c8:	fc86                	sd	ra,120(sp)
ffffffffc02054ca:	f8a2                	sd	s0,112(sp)
ffffffffc02054cc:	f862                	sd	s8,48(sp)
ffffffffc02054ce:	f466                	sd	s9,40(sp)
ffffffffc02054d0:	ec6e                	sd	s11,24(sp)
ffffffffc02054d2:	892a                	mv	s2,a0
ffffffffc02054d4:	84ae                	mv	s1,a1
ffffffffc02054d6:	8d32                	mv	s10,a2
ffffffffc02054d8:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054da:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02054de:	5b7d                	li	s6,-1
ffffffffc02054e0:	00002a97          	auipc	s5,0x2
ffffffffc02054e4:	29ca8a93          	addi	s5,s5,668 # ffffffffc020777c <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054e8:	00002b97          	auipc	s7,0x2
ffffffffc02054ec:	4b0b8b93          	addi	s7,s7,1200 # ffffffffc0207998 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054f0:	000d4503          	lbu	a0,0(s10)
ffffffffc02054f4:	001d0413          	addi	s0,s10,1
ffffffffc02054f8:	01350a63          	beq	a0,s3,ffffffffc020550c <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02054fc:	c121                	beqz	a0,ffffffffc020553c <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02054fe:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205500:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205502:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205504:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205508:	ff351ae3          	bne	a0,s3,ffffffffc02054fc <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020550c:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205510:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205514:	4c81                	li	s9,0
ffffffffc0205516:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205518:	5c7d                	li	s8,-1
ffffffffc020551a:	5dfd                	li	s11,-1
ffffffffc020551c:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205520:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205522:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205526:	0ff5f593          	zext.b	a1,a1
ffffffffc020552a:	00140d13          	addi	s10,s0,1
ffffffffc020552e:	04b56263          	bltu	a0,a1,ffffffffc0205572 <vprintfmt+0xbc>
ffffffffc0205532:	058a                	slli	a1,a1,0x2
ffffffffc0205534:	95d6                	add	a1,a1,s5
ffffffffc0205536:	4194                	lw	a3,0(a1)
ffffffffc0205538:	96d6                	add	a3,a3,s5
ffffffffc020553a:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020553c:	70e6                	ld	ra,120(sp)
ffffffffc020553e:	7446                	ld	s0,112(sp)
ffffffffc0205540:	74a6                	ld	s1,104(sp)
ffffffffc0205542:	7906                	ld	s2,96(sp)
ffffffffc0205544:	69e6                	ld	s3,88(sp)
ffffffffc0205546:	6a46                	ld	s4,80(sp)
ffffffffc0205548:	6aa6                	ld	s5,72(sp)
ffffffffc020554a:	6b06                	ld	s6,64(sp)
ffffffffc020554c:	7be2                	ld	s7,56(sp)
ffffffffc020554e:	7c42                	ld	s8,48(sp)
ffffffffc0205550:	7ca2                	ld	s9,40(sp)
ffffffffc0205552:	7d02                	ld	s10,32(sp)
ffffffffc0205554:	6de2                	ld	s11,24(sp)
ffffffffc0205556:	6109                	addi	sp,sp,128
ffffffffc0205558:	8082                	ret
            padc = '0';
ffffffffc020555a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020555c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205560:	846a                	mv	s0,s10
ffffffffc0205562:	00140d13          	addi	s10,s0,1
ffffffffc0205566:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020556a:	0ff5f593          	zext.b	a1,a1
ffffffffc020556e:	fcb572e3          	bgeu	a0,a1,ffffffffc0205532 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205572:	85a6                	mv	a1,s1
ffffffffc0205574:	02500513          	li	a0,37
ffffffffc0205578:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020557a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020557e:	8d22                	mv	s10,s0
ffffffffc0205580:	f73788e3          	beq	a5,s3,ffffffffc02054f0 <vprintfmt+0x3a>
ffffffffc0205584:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205588:	1d7d                	addi	s10,s10,-1
ffffffffc020558a:	ff379de3          	bne	a5,s3,ffffffffc0205584 <vprintfmt+0xce>
ffffffffc020558e:	b78d                	j	ffffffffc02054f0 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205590:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205594:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205598:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020559a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020559e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02055a2:	02d86463          	bltu	a6,a3,ffffffffc02055ca <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02055a6:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02055aa:	002c169b          	slliw	a3,s8,0x2
ffffffffc02055ae:	0186873b          	addw	a4,a3,s8
ffffffffc02055b2:	0017171b          	slliw	a4,a4,0x1
ffffffffc02055b6:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02055b8:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02055bc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02055be:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02055c2:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02055c6:	fed870e3          	bgeu	a6,a3,ffffffffc02055a6 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02055ca:	f40ddce3          	bgez	s11,ffffffffc0205522 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02055ce:	8de2                	mv	s11,s8
ffffffffc02055d0:	5c7d                	li	s8,-1
ffffffffc02055d2:	bf81                	j	ffffffffc0205522 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02055d4:	fffdc693          	not	a3,s11
ffffffffc02055d8:	96fd                	srai	a3,a3,0x3f
ffffffffc02055da:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055de:	00144603          	lbu	a2,1(s0)
ffffffffc02055e2:	2d81                	sext.w	s11,s11
ffffffffc02055e4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055e6:	bf35                	j	ffffffffc0205522 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02055e8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055ec:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02055f0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055f2:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02055f4:	bfd9                	j	ffffffffc02055ca <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02055f6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055f8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055fc:	01174463          	blt	a4,a7,ffffffffc0205604 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205600:	1a088e63          	beqz	a7,ffffffffc02057bc <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205604:	000a3603          	ld	a2,0(s4)
ffffffffc0205608:	46c1                	li	a3,16
ffffffffc020560a:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020560c:	2781                	sext.w	a5,a5
ffffffffc020560e:	876e                	mv	a4,s11
ffffffffc0205610:	85a6                	mv	a1,s1
ffffffffc0205612:	854a                	mv	a0,s2
ffffffffc0205614:	e37ff0ef          	jal	ra,ffffffffc020544a <printnum>
            break;
ffffffffc0205618:	bde1                	j	ffffffffc02054f0 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020561a:	000a2503          	lw	a0,0(s4)
ffffffffc020561e:	85a6                	mv	a1,s1
ffffffffc0205620:	0a21                	addi	s4,s4,8
ffffffffc0205622:	9902                	jalr	s2
            break;
ffffffffc0205624:	b5f1                	j	ffffffffc02054f0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205626:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205628:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020562c:	01174463          	blt	a4,a7,ffffffffc0205634 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205630:	18088163          	beqz	a7,ffffffffc02057b2 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205634:	000a3603          	ld	a2,0(s4)
ffffffffc0205638:	46a9                	li	a3,10
ffffffffc020563a:	8a2e                	mv	s4,a1
ffffffffc020563c:	bfc1                	j	ffffffffc020560c <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020563e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205642:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205644:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205646:	bdf1                	j	ffffffffc0205522 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205648:	85a6                	mv	a1,s1
ffffffffc020564a:	02500513          	li	a0,37
ffffffffc020564e:	9902                	jalr	s2
            break;
ffffffffc0205650:	b545                	j	ffffffffc02054f0 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205652:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205656:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205658:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020565a:	b5e1                	j	ffffffffc0205522 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020565c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020565e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205662:	01174463          	blt	a4,a7,ffffffffc020566a <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205666:	14088163          	beqz	a7,ffffffffc02057a8 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020566a:	000a3603          	ld	a2,0(s4)
ffffffffc020566e:	46a1                	li	a3,8
ffffffffc0205670:	8a2e                	mv	s4,a1
ffffffffc0205672:	bf69                	j	ffffffffc020560c <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205674:	03000513          	li	a0,48
ffffffffc0205678:	85a6                	mv	a1,s1
ffffffffc020567a:	e03e                	sd	a5,0(sp)
ffffffffc020567c:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020567e:	85a6                	mv	a1,s1
ffffffffc0205680:	07800513          	li	a0,120
ffffffffc0205684:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205686:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205688:	6782                	ld	a5,0(sp)
ffffffffc020568a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020568c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205690:	bfb5                	j	ffffffffc020560c <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205692:	000a3403          	ld	s0,0(s4)
ffffffffc0205696:	008a0713          	addi	a4,s4,8
ffffffffc020569a:	e03a                	sd	a4,0(sp)
ffffffffc020569c:	14040263          	beqz	s0,ffffffffc02057e0 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02056a0:	0fb05763          	blez	s11,ffffffffc020578e <vprintfmt+0x2d8>
ffffffffc02056a4:	02d00693          	li	a3,45
ffffffffc02056a8:	0cd79163          	bne	a5,a3,ffffffffc020576a <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056ac:	00044783          	lbu	a5,0(s0)
ffffffffc02056b0:	0007851b          	sext.w	a0,a5
ffffffffc02056b4:	cf85                	beqz	a5,ffffffffc02056ec <vprintfmt+0x236>
ffffffffc02056b6:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056ba:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056be:	000c4563          	bltz	s8,ffffffffc02056c8 <vprintfmt+0x212>
ffffffffc02056c2:	3c7d                	addiw	s8,s8,-1
ffffffffc02056c4:	036c0263          	beq	s8,s6,ffffffffc02056e8 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02056c8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056ca:	0e0c8e63          	beqz	s9,ffffffffc02057c6 <vprintfmt+0x310>
ffffffffc02056ce:	3781                	addiw	a5,a5,-32
ffffffffc02056d0:	0ef47b63          	bgeu	s0,a5,ffffffffc02057c6 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02056d4:	03f00513          	li	a0,63
ffffffffc02056d8:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056da:	000a4783          	lbu	a5,0(s4)
ffffffffc02056de:	3dfd                	addiw	s11,s11,-1
ffffffffc02056e0:	0a05                	addi	s4,s4,1
ffffffffc02056e2:	0007851b          	sext.w	a0,a5
ffffffffc02056e6:	ffe1                	bnez	a5,ffffffffc02056be <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02056e8:	01b05963          	blez	s11,ffffffffc02056fa <vprintfmt+0x244>
ffffffffc02056ec:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02056ee:	85a6                	mv	a1,s1
ffffffffc02056f0:	02000513          	li	a0,32
ffffffffc02056f4:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02056f6:	fe0d9be3          	bnez	s11,ffffffffc02056ec <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02056fa:	6a02                	ld	s4,0(sp)
ffffffffc02056fc:	bbd5                	j	ffffffffc02054f0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02056fe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205700:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205704:	01174463          	blt	a4,a7,ffffffffc020570c <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205708:	08088d63          	beqz	a7,ffffffffc02057a2 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020570c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205710:	0a044d63          	bltz	s0,ffffffffc02057ca <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205714:	8622                	mv	a2,s0
ffffffffc0205716:	8a66                	mv	s4,s9
ffffffffc0205718:	46a9                	li	a3,10
ffffffffc020571a:	bdcd                	j	ffffffffc020560c <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020571c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205720:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205722:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205724:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205728:	8fb5                	xor	a5,a5,a3
ffffffffc020572a:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020572e:	02d74163          	blt	a4,a3,ffffffffc0205750 <vprintfmt+0x29a>
ffffffffc0205732:	00369793          	slli	a5,a3,0x3
ffffffffc0205736:	97de                	add	a5,a5,s7
ffffffffc0205738:	639c                	ld	a5,0(a5)
ffffffffc020573a:	cb99                	beqz	a5,ffffffffc0205750 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020573c:	86be                	mv	a3,a5
ffffffffc020573e:	00000617          	auipc	a2,0x0
ffffffffc0205742:	1f260613          	addi	a2,a2,498 # ffffffffc0205930 <etext+0x2c>
ffffffffc0205746:	85a6                	mv	a1,s1
ffffffffc0205748:	854a                	mv	a0,s2
ffffffffc020574a:	0ce000ef          	jal	ra,ffffffffc0205818 <printfmt>
ffffffffc020574e:	b34d                	j	ffffffffc02054f0 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205750:	00002617          	auipc	a2,0x2
ffffffffc0205754:	02060613          	addi	a2,a2,32 # ffffffffc0207770 <syscalls+0x120>
ffffffffc0205758:	85a6                	mv	a1,s1
ffffffffc020575a:	854a                	mv	a0,s2
ffffffffc020575c:	0bc000ef          	jal	ra,ffffffffc0205818 <printfmt>
ffffffffc0205760:	bb41                	j	ffffffffc02054f0 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205762:	00002417          	auipc	s0,0x2
ffffffffc0205766:	00640413          	addi	s0,s0,6 # ffffffffc0207768 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020576a:	85e2                	mv	a1,s8
ffffffffc020576c:	8522                	mv	a0,s0
ffffffffc020576e:	e43e                	sd	a5,8(sp)
ffffffffc0205770:	0e2000ef          	jal	ra,ffffffffc0205852 <strnlen>
ffffffffc0205774:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205778:	01b05b63          	blez	s11,ffffffffc020578e <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020577c:	67a2                	ld	a5,8(sp)
ffffffffc020577e:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205782:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205784:	85a6                	mv	a1,s1
ffffffffc0205786:	8552                	mv	a0,s4
ffffffffc0205788:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020578a:	fe0d9ce3          	bnez	s11,ffffffffc0205782 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020578e:	00044783          	lbu	a5,0(s0)
ffffffffc0205792:	00140a13          	addi	s4,s0,1
ffffffffc0205796:	0007851b          	sext.w	a0,a5
ffffffffc020579a:	d3a5                	beqz	a5,ffffffffc02056fa <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020579c:	05e00413          	li	s0,94
ffffffffc02057a0:	bf39                	j	ffffffffc02056be <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02057a2:	000a2403          	lw	s0,0(s4)
ffffffffc02057a6:	b7ad                	j	ffffffffc0205710 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02057a8:	000a6603          	lwu	a2,0(s4)
ffffffffc02057ac:	46a1                	li	a3,8
ffffffffc02057ae:	8a2e                	mv	s4,a1
ffffffffc02057b0:	bdb1                	j	ffffffffc020560c <vprintfmt+0x156>
ffffffffc02057b2:	000a6603          	lwu	a2,0(s4)
ffffffffc02057b6:	46a9                	li	a3,10
ffffffffc02057b8:	8a2e                	mv	s4,a1
ffffffffc02057ba:	bd89                	j	ffffffffc020560c <vprintfmt+0x156>
ffffffffc02057bc:	000a6603          	lwu	a2,0(s4)
ffffffffc02057c0:	46c1                	li	a3,16
ffffffffc02057c2:	8a2e                	mv	s4,a1
ffffffffc02057c4:	b5a1                	j	ffffffffc020560c <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02057c6:	9902                	jalr	s2
ffffffffc02057c8:	bf09                	j	ffffffffc02056da <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02057ca:	85a6                	mv	a1,s1
ffffffffc02057cc:	02d00513          	li	a0,45
ffffffffc02057d0:	e03e                	sd	a5,0(sp)
ffffffffc02057d2:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02057d4:	6782                	ld	a5,0(sp)
ffffffffc02057d6:	8a66                	mv	s4,s9
ffffffffc02057d8:	40800633          	neg	a2,s0
ffffffffc02057dc:	46a9                	li	a3,10
ffffffffc02057de:	b53d                	j	ffffffffc020560c <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02057e0:	03b05163          	blez	s11,ffffffffc0205802 <vprintfmt+0x34c>
ffffffffc02057e4:	02d00693          	li	a3,45
ffffffffc02057e8:	f6d79de3          	bne	a5,a3,ffffffffc0205762 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02057ec:	00002417          	auipc	s0,0x2
ffffffffc02057f0:	f7c40413          	addi	s0,s0,-132 # ffffffffc0207768 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057f4:	02800793          	li	a5,40
ffffffffc02057f8:	02800513          	li	a0,40
ffffffffc02057fc:	00140a13          	addi	s4,s0,1
ffffffffc0205800:	bd6d                	j	ffffffffc02056ba <vprintfmt+0x204>
ffffffffc0205802:	00002a17          	auipc	s4,0x2
ffffffffc0205806:	f67a0a13          	addi	s4,s4,-153 # ffffffffc0207769 <syscalls+0x119>
ffffffffc020580a:	02800513          	li	a0,40
ffffffffc020580e:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205812:	05e00413          	li	s0,94
ffffffffc0205816:	b565                	j	ffffffffc02056be <vprintfmt+0x208>

ffffffffc0205818 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205818:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020581a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020581e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205820:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205822:	ec06                	sd	ra,24(sp)
ffffffffc0205824:	f83a                	sd	a4,48(sp)
ffffffffc0205826:	fc3e                	sd	a5,56(sp)
ffffffffc0205828:	e0c2                	sd	a6,64(sp)
ffffffffc020582a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020582c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020582e:	c89ff0ef          	jal	ra,ffffffffc02054b6 <vprintfmt>
}
ffffffffc0205832:	60e2                	ld	ra,24(sp)
ffffffffc0205834:	6161                	addi	sp,sp,80
ffffffffc0205836:	8082                	ret

ffffffffc0205838 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205838:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020583c:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020583e:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205840:	cb81                	beqz	a5,ffffffffc0205850 <strlen+0x18>
        cnt ++;
ffffffffc0205842:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205844:	00a707b3          	add	a5,a4,a0
ffffffffc0205848:	0007c783          	lbu	a5,0(a5)
ffffffffc020584c:	fbfd                	bnez	a5,ffffffffc0205842 <strlen+0xa>
ffffffffc020584e:	8082                	ret
    }
    return cnt;
}
ffffffffc0205850:	8082                	ret

ffffffffc0205852 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205852:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205854:	e589                	bnez	a1,ffffffffc020585e <strnlen+0xc>
ffffffffc0205856:	a811                	j	ffffffffc020586a <strnlen+0x18>
        cnt ++;
ffffffffc0205858:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020585a:	00f58863          	beq	a1,a5,ffffffffc020586a <strnlen+0x18>
ffffffffc020585e:	00f50733          	add	a4,a0,a5
ffffffffc0205862:	00074703          	lbu	a4,0(a4)
ffffffffc0205866:	fb6d                	bnez	a4,ffffffffc0205858 <strnlen+0x6>
ffffffffc0205868:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020586a:	852e                	mv	a0,a1
ffffffffc020586c:	8082                	ret

ffffffffc020586e <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020586e:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205870:	0005c703          	lbu	a4,0(a1)
ffffffffc0205874:	0785                	addi	a5,a5,1
ffffffffc0205876:	0585                	addi	a1,a1,1
ffffffffc0205878:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020587c:	fb75                	bnez	a4,ffffffffc0205870 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020587e:	8082                	ret

ffffffffc0205880 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205880:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205884:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205888:	cb89                	beqz	a5,ffffffffc020589a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020588a:	0505                	addi	a0,a0,1
ffffffffc020588c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020588e:	fee789e3          	beq	a5,a4,ffffffffc0205880 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205892:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205896:	9d19                	subw	a0,a0,a4
ffffffffc0205898:	8082                	ret
ffffffffc020589a:	4501                	li	a0,0
ffffffffc020589c:	bfed                	j	ffffffffc0205896 <strcmp+0x16>

ffffffffc020589e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020589e:	c20d                	beqz	a2,ffffffffc02058c0 <strncmp+0x22>
ffffffffc02058a0:	962e                	add	a2,a2,a1
ffffffffc02058a2:	a031                	j	ffffffffc02058ae <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02058a4:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058a6:	00e79a63          	bne	a5,a4,ffffffffc02058ba <strncmp+0x1c>
ffffffffc02058aa:	00b60b63          	beq	a2,a1,ffffffffc02058c0 <strncmp+0x22>
ffffffffc02058ae:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02058b2:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058b4:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02058b8:	f7f5                	bnez	a5,ffffffffc02058a4 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058ba:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02058be:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058c0:	4501                	li	a0,0
ffffffffc02058c2:	8082                	ret

ffffffffc02058c4 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02058c4:	00054783          	lbu	a5,0(a0)
ffffffffc02058c8:	c799                	beqz	a5,ffffffffc02058d6 <strchr+0x12>
        if (*s == c) {
ffffffffc02058ca:	00f58763          	beq	a1,a5,ffffffffc02058d8 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02058ce:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02058d2:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02058d4:	fbfd                	bnez	a5,ffffffffc02058ca <strchr+0x6>
    }
    return NULL;
ffffffffc02058d6:	4501                	li	a0,0
}
ffffffffc02058d8:	8082                	ret

ffffffffc02058da <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02058da:	ca01                	beqz	a2,ffffffffc02058ea <memset+0x10>
ffffffffc02058dc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02058de:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02058e0:	0785                	addi	a5,a5,1
ffffffffc02058e2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02058e6:	fec79de3          	bne	a5,a2,ffffffffc02058e0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02058ea:	8082                	ret

ffffffffc02058ec <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02058ec:	ca19                	beqz	a2,ffffffffc0205902 <memcpy+0x16>
ffffffffc02058ee:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02058f0:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02058f2:	0005c703          	lbu	a4,0(a1)
ffffffffc02058f6:	0585                	addi	a1,a1,1
ffffffffc02058f8:	0785                	addi	a5,a5,1
ffffffffc02058fa:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02058fe:	fec59ae3          	bne	a1,a2,ffffffffc02058f2 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205902:	8082                	ret
