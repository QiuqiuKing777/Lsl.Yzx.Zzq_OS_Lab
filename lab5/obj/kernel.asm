
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
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	35e50513          	addi	a0,a0,862 # ffffffffc02a63a8 <buf>
ffffffffc0200052:	000ab617          	auipc	a2,0xab
ffffffffc0200056:	80260613          	addi	a2,a2,-2046 # ffffffffc02aa854 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	676050ef          	jal	ra,ffffffffc02056d8 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	69a58593          	addi	a1,a1,1690 # ffffffffc0205708 <etext+0x6>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	6b250513          	addi	a0,a0,1714 # ffffffffc0205728 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6b4020ef          	jal	ra,ffffffffc020273a <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	181030ef          	jal	ra,ffffffffc0203a12 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	595040ef          	jal	ra,ffffffffc0204e2a <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	721040ef          	jal	ra,ffffffffc0204fc2 <cpu_idle>

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
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	67450513          	addi	a0,a0,1652 # ffffffffc0205730 <etext+0x2e>
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
ffffffffc02000d2:	000a6b97          	auipc	s7,0xa6
ffffffffc02000d6:	2d6b8b93          	addi	s7,s7,726 # ffffffffc02a63a8 <buf>
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
ffffffffc020012e:	000a6517          	auipc	a0,0xa6
ffffffffc0200132:	27a50513          	addi	a0,a0,634 # ffffffffc02a63a8 <buf>
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
ffffffffc0200188:	12c050ef          	jal	ra,ffffffffc02052b4 <vprintfmt>
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
ffffffffc02001be:	0f6050ef          	jal	ra,ffffffffc02052b4 <vprintfmt>
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
ffffffffc0200222:	51a50513          	addi	a0,a0,1306 # ffffffffc0205738 <etext+0x36>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	52450513          	addi	a0,a0,1316 # ffffffffc0205758 <etext+0x56>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	4c258593          	addi	a1,a1,1218 # ffffffffc0205702 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	53050513          	addi	a0,a0,1328 # ffffffffc0205778 <etext+0x76>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000a6597          	auipc	a1,0xa6
ffffffffc0200258:	15458593          	addi	a1,a1,340 # ffffffffc02a63a8 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	53c50513          	addi	a0,a0,1340 # ffffffffc0205798 <etext+0x96>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000aa597          	auipc	a1,0xaa
ffffffffc020026c:	5ec58593          	addi	a1,a1,1516 # ffffffffc02aa854 <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	54850513          	addi	a0,a0,1352 # ffffffffc02057b8 <etext+0xb6>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000ab597          	auipc	a1,0xab
ffffffffc0200280:	9d758593          	addi	a1,a1,-1577 # ffffffffc02aac53 <end+0x3ff>
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
ffffffffc02002a2:	53a50513          	addi	a0,a0,1338 # ffffffffc02057d8 <etext+0xd6>
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
ffffffffc02002b0:	55c60613          	addi	a2,a2,1372 # ffffffffc0205808 <etext+0x106>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	56850513          	addi	a0,a0,1384 # ffffffffc0205820 <etext+0x11e>
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
ffffffffc02002cc:	57060613          	addi	a2,a2,1392 # ffffffffc0205838 <etext+0x136>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	58858593          	addi	a1,a1,1416 # ffffffffc0205858 <etext+0x156>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	58850513          	addi	a0,a0,1416 # ffffffffc0205860 <etext+0x15e>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	58a60613          	addi	a2,a2,1418 # ffffffffc0205870 <etext+0x16e>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	5aa58593          	addi	a1,a1,1450 # ffffffffc0205898 <etext+0x196>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	56a50513          	addi	a0,a0,1386 # ffffffffc0205860 <etext+0x15e>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	5a660613          	addi	a2,a2,1446 # ffffffffc02058a8 <etext+0x1a6>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	5be58593          	addi	a1,a1,1470 # ffffffffc02058c8 <etext+0x1c6>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	54e50513          	addi	a0,a0,1358 # ffffffffc0205860 <etext+0x15e>
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
ffffffffc0200350:	58c50513          	addi	a0,a0,1420 # ffffffffc02058d8 <etext+0x1d6>
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
ffffffffc0200372:	59250513          	addi	a0,a0,1426 # ffffffffc0205900 <etext+0x1fe>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	5ecc0c13          	addi	s8,s8,1516 # ffffffffc0205970 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	59c90913          	addi	s2,s2,1436 # ffffffffc0205928 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	59c48493          	addi	s1,s1,1436 # ffffffffc0205930 <etext+0x22e>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	59ab0b13          	addi	s6,s6,1434 # ffffffffc0205938 <etext+0x236>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	4b2a0a13          	addi	s4,s4,1202 # ffffffffc0205858 <etext+0x156>
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
ffffffffc02003cc:	5a8d0d13          	addi	s10,s10,1448 # ffffffffc0205970 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	2a8050ef          	jal	ra,ffffffffc020567e <strcmp>
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
ffffffffc02003ea:	294050ef          	jal	ra,ffffffffc020567e <strcmp>
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
ffffffffc0200428:	29a050ef          	jal	ra,ffffffffc02056c2 <strchr>
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
ffffffffc0200466:	25c050ef          	jal	ra,ffffffffc02056c2 <strchr>
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
ffffffffc0200484:	4d850513          	addi	a0,a0,1240 # ffffffffc0205958 <etext+0x256>
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
ffffffffc020048e:	000aa317          	auipc	t1,0xaa
ffffffffc0200492:	34230313          	addi	t1,t1,834 # ffffffffc02aa7d0 <is_panic>
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
ffffffffc02004c0:	4fc50513          	addi	a0,a0,1276 # ffffffffc02059b8 <commands+0x48>
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
ffffffffc02004d6:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206ac0 <default_pmm_manager+0x578>
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
ffffffffc020050a:	4d250513          	addi	a0,a0,1234 # ffffffffc02059d8 <commands+0x68>
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
ffffffffc020052a:	59a50513          	addi	a0,a0,1434 # ffffffffc0206ac0 <default_pmm_manager+0x578>
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
ffffffffc0200540:	000aa717          	auipc	a4,0xaa
ffffffffc0200544:	2af73023          	sd	a5,672(a4) # ffffffffc02aa7e0 <timebase>
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
ffffffffc0200564:	49850513          	addi	a0,a0,1176 # ffffffffc02059f8 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000aa797          	auipc	a5,0xaa
ffffffffc020056c:	2607b823          	sd	zero,624(a5) # ffffffffc02aa7d8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000aa797          	auipc	a5,0xaa
ffffffffc020057a:	26a7b783          	ld	a5,618(a5) # ffffffffc02aa7e0 <timebase>
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
ffffffffc0200604:	41850513          	addi	a0,a0,1048 # ffffffffc0205a18 <commands+0xa8>
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
ffffffffc0200632:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205a28 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	3f450513          	addi	a0,a0,1012 # ffffffffc0205a38 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	3fc50513          	addi	a0,a0,1020 # ffffffffc0205a50 <commands+0xe0>
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
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe35699>
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
ffffffffc0200712:	39290913          	addi	s2,s2,914 # ffffffffc0205aa0 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	37c48493          	addi	s1,s1,892 # ffffffffc0205a98 <commands+0x128>
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
ffffffffc0200774:	3a850513          	addi	a0,a0,936 # ffffffffc0205b18 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	3d450513          	addi	a0,a0,980 # ffffffffc0205b50 <commands+0x1e0>
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
ffffffffc02007c0:	2b450513          	addi	a0,a0,692 # ffffffffc0205a70 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	66d040ef          	jal	ra,ffffffffc0205636 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	6c5040ef          	jal	ra,ffffffffc020569c <strncmp>
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
ffffffffc020086e:	611040ef          	jal	ra,ffffffffc020567e <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	22650513          	addi	a0,a0,550 # ffffffffc0205aa8 <commands+0x138>
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
ffffffffc0200954:	17850513          	addi	a0,a0,376 # ffffffffc0205ac8 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	17e50513          	addi	a0,a0,382 # ffffffffc0205ae0 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	18c50513          	addi	a0,a0,396 # ffffffffc0205b00 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	1d050513          	addi	a0,a0,464 # ffffffffc0205b50 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000aa797          	auipc	a5,0xaa
ffffffffc020098c:	e687b023          	sd	s0,-416(a5) # ffffffffc02aa7e8 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000aa797          	auipc	a5,0xaa
ffffffffc0200994:	e767b023          	sd	s6,-416(a5) # ffffffffc02aa7f0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000aa517          	auipc	a0,0xaa
ffffffffc020099e:	e4e53503          	ld	a0,-434(a0) # ffffffffc02aa7e8 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000aa517          	auipc	a0,0xaa
ffffffffc02009a8:	e4c53503          	ld	a0,-436(a0) # ffffffffc02aa7f0 <memory_size>
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
ffffffffc02009c4:	4a878793          	addi	a5,a5,1192 # ffffffffc0200e68 <__alltraps>
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
ffffffffc02009e2:	18a50513          	addi	a0,a0,394 # ffffffffc0205b68 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	19250513          	addi	a0,a0,402 # ffffffffc0205b80 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	19c50513          	addi	a0,a0,412 # ffffffffc0205b98 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	1a650513          	addi	a0,a0,422 # ffffffffc0205bb0 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	1b050513          	addi	a0,a0,432 # ffffffffc0205bc8 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	1ba50513          	addi	a0,a0,442 # ffffffffc0205be0 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	1c450513          	addi	a0,a0,452 # ffffffffc0205bf8 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	1ce50513          	addi	a0,a0,462 # ffffffffc0205c10 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	1d850513          	addi	a0,a0,472 # ffffffffc0205c28 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	1e250513          	addi	a0,a0,482 # ffffffffc0205c40 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	1ec50513          	addi	a0,a0,492 # ffffffffc0205c58 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	1f650513          	addi	a0,a0,502 # ffffffffc0205c70 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	20050513          	addi	a0,a0,512 # ffffffffc0205c88 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	20a50513          	addi	a0,a0,522 # ffffffffc0205ca0 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	21450513          	addi	a0,a0,532 # ffffffffc0205cb8 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	21e50513          	addi	a0,a0,542 # ffffffffc0205cd0 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	22850513          	addi	a0,a0,552 # ffffffffc0205ce8 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	23250513          	addi	a0,a0,562 # ffffffffc0205d00 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	23c50513          	addi	a0,a0,572 # ffffffffc0205d18 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	24650513          	addi	a0,a0,582 # ffffffffc0205d30 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	25050513          	addi	a0,a0,592 # ffffffffc0205d48 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	25a50513          	addi	a0,a0,602 # ffffffffc0205d60 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	26450513          	addi	a0,a0,612 # ffffffffc0205d78 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	26e50513          	addi	a0,a0,622 # ffffffffc0205d90 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	27850513          	addi	a0,a0,632 # ffffffffc0205da8 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	28250513          	addi	a0,a0,642 # ffffffffc0205dc0 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	28c50513          	addi	a0,a0,652 # ffffffffc0205dd8 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	29650513          	addi	a0,a0,662 # ffffffffc0205df0 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	2a050513          	addi	a0,a0,672 # ffffffffc0205e08 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	2aa50513          	addi	a0,a0,682 # ffffffffc0205e20 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	2b450513          	addi	a0,a0,692 # ffffffffc0205e38 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	2ba50513          	addi	a0,a0,698 # ffffffffc0205e50 <commands+0x4e0>
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
ffffffffc0200bb0:	2bc50513          	addi	a0,a0,700 # ffffffffc0205e68 <commands+0x4f8>
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
ffffffffc0200bc8:	2bc50513          	addi	a0,a0,700 # ffffffffc0205e80 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	2c450513          	addi	a0,a0,708 # ffffffffc0205e98 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	2cc50513          	addi	a0,a0,716 # ffffffffc0205eb0 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	2c850513          	addi	a0,a0,712 # ffffffffc0205ec0 <commands+0x550>
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
ffffffffc0200c18:	37470713          	addi	a4,a4,884 # ffffffffc0205f88 <commands+0x618>
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
ffffffffc0200c2a:	31250513          	addi	a0,a0,786 # ffffffffc0205f38 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	2e650513          	addi	a0,a0,742 # ffffffffc0205f18 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	29a50513          	addi	a0,a0,666 # ffffffffc0205ed8 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	2ae50513          	addi	a0,a0,686 # ffffffffc0205ef8 <commands+0x588>
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
ffffffffc0200c5e:	000aa797          	auipc	a5,0xaa
ffffffffc0200c62:	b7a78793          	addi	a5,a5,-1158 # ffffffffc02aa7d8 <ticks>
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
ffffffffc0200c82:	2ea50513          	addi	a0,a0,746 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0200c86:	d0eff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c8a:	bf29                	j	ffffffffc0200ba4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c8c:	06400593          	li	a1,100
ffffffffc0200c90:	00005517          	auipc	a0,0x5
ffffffffc0200c94:	2c850513          	addi	a0,a0,712 # ffffffffc0205f58 <commands+0x5e8>
ffffffffc0200c98:	cfcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            num++;
ffffffffc0200c9c:	000aa717          	auipc	a4,0xaa
ffffffffc0200ca0:	b5c70713          	addi	a4,a4,-1188 # ffffffffc02aa7f8 <num>
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
ffffffffc0200cc2:	1141                	addi	sp,sp,-16
ffffffffc0200cc4:	e022                	sd	s0,0(sp)
ffffffffc0200cc6:	e406                	sd	ra,8(sp)
ffffffffc0200cc8:	473d                	li	a4,15
ffffffffc0200cca:	842a                	mv	s0,a0
ffffffffc0200ccc:	0cf76463          	bltu	a4,a5,ffffffffc0200d94 <exception_handler+0xd6>
ffffffffc0200cd0:	00005717          	auipc	a4,0x5
ffffffffc0200cd4:	47870713          	addi	a4,a4,1144 # ffffffffc0206148 <commands+0x7d8>
ffffffffc0200cd8:	078a                	slli	a5,a5,0x2
ffffffffc0200cda:	97ba                	add	a5,a5,a4
ffffffffc0200cdc:	439c                	lw	a5,0(a5)
ffffffffc0200cde:	97ba                	add	a5,a5,a4
ffffffffc0200ce0:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200ce2:	00005517          	auipc	a0,0x5
ffffffffc0200ce6:	3be50513          	addi	a0,a0,958 # ffffffffc02060a0 <commands+0x730>
ffffffffc0200cea:	caaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cee:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cf2:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cf4:	0791                	addi	a5,a5,4
ffffffffc0200cf6:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cfa:	6402                	ld	s0,0(sp)
ffffffffc0200cfc:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cfe:	4b40406f          	j	ffffffffc02051b2 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d02:	00005517          	auipc	a0,0x5
ffffffffc0200d06:	3be50513          	addi	a0,a0,958 # ffffffffc02060c0 <commands+0x750>
}
ffffffffc0200d0a:	6402                	ld	s0,0(sp)
ffffffffc0200d0c:	60a2                	ld	ra,8(sp)
ffffffffc0200d0e:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d10:	c84ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d14:	00005517          	auipc	a0,0x5
ffffffffc0200d18:	3cc50513          	addi	a0,a0,972 # ffffffffc02060e0 <commands+0x770>
ffffffffc0200d1c:	b7fd                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d1e:	00005517          	auipc	a0,0x5
ffffffffc0200d22:	3e250513          	addi	a0,a0,994 # ffffffffc0206100 <commands+0x790>
ffffffffc0200d26:	b7d5                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d28:	00005517          	auipc	a0,0x5
ffffffffc0200d2c:	3f050513          	addi	a0,a0,1008 # ffffffffc0206118 <commands+0x7a8>
ffffffffc0200d30:	bfe9                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d32:	00005517          	auipc	a0,0x5
ffffffffc0200d36:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206130 <commands+0x7c0>
ffffffffc0200d3a:	bfc1                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d3c:	00005517          	auipc	a0,0x5
ffffffffc0200d40:	27c50513          	addi	a0,a0,636 # ffffffffc0205fb8 <commands+0x648>
ffffffffc0200d44:	b7d9                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d46:	00005517          	auipc	a0,0x5
ffffffffc0200d4a:	29250513          	addi	a0,a0,658 # ffffffffc0205fd8 <commands+0x668>
ffffffffc0200d4e:	bf75                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d50:	00005517          	auipc	a0,0x5
ffffffffc0200d54:	2a850513          	addi	a0,a0,680 # ffffffffc0205ff8 <commands+0x688>
ffffffffc0200d58:	bf4d                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d5a:	00005517          	auipc	a0,0x5
ffffffffc0200d5e:	2b650513          	addi	a0,a0,694 # ffffffffc0206010 <commands+0x6a0>
ffffffffc0200d62:	c32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d66:	6458                	ld	a4,136(s0)
ffffffffc0200d68:	47a9                	li	a5,10
ffffffffc0200d6a:	04f70663          	beq	a4,a5,ffffffffc0200db6 <exception_handler+0xf8>
}
ffffffffc0200d6e:	60a2                	ld	ra,8(sp)
ffffffffc0200d70:	6402                	ld	s0,0(sp)
ffffffffc0200d72:	0141                	addi	sp,sp,16
ffffffffc0200d74:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d76:	00005517          	auipc	a0,0x5
ffffffffc0200d7a:	2aa50513          	addi	a0,a0,682 # ffffffffc0206020 <commands+0x6b0>
ffffffffc0200d7e:	b771                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d80:	00005517          	auipc	a0,0x5
ffffffffc0200d84:	2c050513          	addi	a0,a0,704 # ffffffffc0206040 <commands+0x6d0>
ffffffffc0200d88:	b749                	j	ffffffffc0200d0a <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d8a:	00005517          	auipc	a0,0x5
ffffffffc0200d8e:	2fe50513          	addi	a0,a0,766 # ffffffffc0206088 <commands+0x718>
ffffffffc0200d92:	bfa5                	j	ffffffffc0200d0a <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d94:	8522                	mv	a0,s0
}
ffffffffc0200d96:	6402                	ld	s0,0(sp)
ffffffffc0200d98:	60a2                	ld	ra,8(sp)
ffffffffc0200d9a:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d9c:	b521                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d9e:	00005617          	auipc	a2,0x5
ffffffffc0200da2:	2ba60613          	addi	a2,a2,698 # ffffffffc0206058 <commands+0x6e8>
ffffffffc0200da6:	0c300593          	li	a1,195
ffffffffc0200daa:	00005517          	auipc	a0,0x5
ffffffffc0200dae:	2c650513          	addi	a0,a0,710 # ffffffffc0206070 <commands+0x700>
ffffffffc0200db2:	edcff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200db6:	10843783          	ld	a5,264(s0)
ffffffffc0200dba:	0791                	addi	a5,a5,4
ffffffffc0200dbc:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dc0:	3f2040ef          	jal	ra,ffffffffc02051b2 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dc4:	000aa797          	auipc	a5,0xaa
ffffffffc0200dc8:	a747b783          	ld	a5,-1420(a5) # ffffffffc02aa838 <current>
ffffffffc0200dcc:	6b9c                	ld	a5,16(a5)
ffffffffc0200dce:	8522                	mv	a0,s0
}
ffffffffc0200dd0:	6402                	ld	s0,0(sp)
ffffffffc0200dd2:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd4:	6589                	lui	a1,0x2
ffffffffc0200dd6:	95be                	add	a1,a1,a5
}
ffffffffc0200dd8:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dda:	aab1                	j	ffffffffc0200f36 <kernel_execve_ret>

ffffffffc0200ddc <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200ddc:	1101                	addi	sp,sp,-32
ffffffffc0200dde:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200de0:	000aa417          	auipc	s0,0xaa
ffffffffc0200de4:	a5840413          	addi	s0,s0,-1448 # ffffffffc02aa838 <current>
ffffffffc0200de8:	6018                	ld	a4,0(s0)
{
ffffffffc0200dea:	ec06                	sd	ra,24(sp)
ffffffffc0200dec:	e426                	sd	s1,8(sp)
ffffffffc0200dee:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200df0:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200df4:	cf1d                	beqz	a4,ffffffffc0200e32 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200df6:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dfa:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200dfe:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e00:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e04:	0206c463          	bltz	a3,ffffffffc0200e2c <trap+0x50>
        exception_handler(tf);
ffffffffc0200e08:	eb7ff0ef          	jal	ra,ffffffffc0200cbe <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e0c:	601c                	ld	a5,0(s0)
ffffffffc0200e0e:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e12:	e499                	bnez	s1,ffffffffc0200e20 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e14:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e18:	8b05                	andi	a4,a4,1
ffffffffc0200e1a:	e329                	bnez	a4,ffffffffc0200e5c <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e1c:	6f9c                	ld	a5,24(a5)
ffffffffc0200e1e:	eb85                	bnez	a5,ffffffffc0200e4e <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e20:	60e2                	ld	ra,24(sp)
ffffffffc0200e22:	6442                	ld	s0,16(sp)
ffffffffc0200e24:	64a2                	ld	s1,8(sp)
ffffffffc0200e26:	6902                	ld	s2,0(sp)
ffffffffc0200e28:	6105                	addi	sp,sp,32
ffffffffc0200e2a:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e2c:	ddbff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e30:	bff1                	j	ffffffffc0200e0c <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e32:	0006c863          	bltz	a3,ffffffffc0200e42 <trap+0x66>
}
ffffffffc0200e36:	6442                	ld	s0,16(sp)
ffffffffc0200e38:	60e2                	ld	ra,24(sp)
ffffffffc0200e3a:	64a2                	ld	s1,8(sp)
ffffffffc0200e3c:	6902                	ld	s2,0(sp)
ffffffffc0200e3e:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e40:	bdbd                	j	ffffffffc0200cbe <exception_handler>
}
ffffffffc0200e42:	6442                	ld	s0,16(sp)
ffffffffc0200e44:	60e2                	ld	ra,24(sp)
ffffffffc0200e46:	64a2                	ld	s1,8(sp)
ffffffffc0200e48:	6902                	ld	s2,0(sp)
ffffffffc0200e4a:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e4c:	bb6d                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e4e:	6442                	ld	s0,16(sp)
ffffffffc0200e50:	60e2                	ld	ra,24(sp)
ffffffffc0200e52:	64a2                	ld	s1,8(sp)
ffffffffc0200e54:	6902                	ld	s2,0(sp)
ffffffffc0200e56:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e58:	26e0406f          	j	ffffffffc02050c6 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e5c:	555d                	li	a0,-9
ffffffffc0200e5e:	5ae030ef          	jal	ra,ffffffffc020440c <do_exit>
            if (current->need_resched)
ffffffffc0200e62:	601c                	ld	a5,0(s0)
ffffffffc0200e64:	bf65                	j	ffffffffc0200e1c <trap+0x40>
	...

ffffffffc0200e68 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e68:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e6c:	00011463          	bnez	sp,ffffffffc0200e74 <__alltraps+0xc>
ffffffffc0200e70:	14002173          	csrr	sp,sscratch
ffffffffc0200e74:	712d                	addi	sp,sp,-288
ffffffffc0200e76:	e002                	sd	zero,0(sp)
ffffffffc0200e78:	e406                	sd	ra,8(sp)
ffffffffc0200e7a:	ec0e                	sd	gp,24(sp)
ffffffffc0200e7c:	f012                	sd	tp,32(sp)
ffffffffc0200e7e:	f416                	sd	t0,40(sp)
ffffffffc0200e80:	f81a                	sd	t1,48(sp)
ffffffffc0200e82:	fc1e                	sd	t2,56(sp)
ffffffffc0200e84:	e0a2                	sd	s0,64(sp)
ffffffffc0200e86:	e4a6                	sd	s1,72(sp)
ffffffffc0200e88:	e8aa                	sd	a0,80(sp)
ffffffffc0200e8a:	ecae                	sd	a1,88(sp)
ffffffffc0200e8c:	f0b2                	sd	a2,96(sp)
ffffffffc0200e8e:	f4b6                	sd	a3,104(sp)
ffffffffc0200e90:	f8ba                	sd	a4,112(sp)
ffffffffc0200e92:	fcbe                	sd	a5,120(sp)
ffffffffc0200e94:	e142                	sd	a6,128(sp)
ffffffffc0200e96:	e546                	sd	a7,136(sp)
ffffffffc0200e98:	e94a                	sd	s2,144(sp)
ffffffffc0200e9a:	ed4e                	sd	s3,152(sp)
ffffffffc0200e9c:	f152                	sd	s4,160(sp)
ffffffffc0200e9e:	f556                	sd	s5,168(sp)
ffffffffc0200ea0:	f95a                	sd	s6,176(sp)
ffffffffc0200ea2:	fd5e                	sd	s7,184(sp)
ffffffffc0200ea4:	e1e2                	sd	s8,192(sp)
ffffffffc0200ea6:	e5e6                	sd	s9,200(sp)
ffffffffc0200ea8:	e9ea                	sd	s10,208(sp)
ffffffffc0200eaa:	edee                	sd	s11,216(sp)
ffffffffc0200eac:	f1f2                	sd	t3,224(sp)
ffffffffc0200eae:	f5f6                	sd	t4,232(sp)
ffffffffc0200eb0:	f9fa                	sd	t5,240(sp)
ffffffffc0200eb2:	fdfe                	sd	t6,248(sp)
ffffffffc0200eb4:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200eb8:	100024f3          	csrr	s1,sstatus
ffffffffc0200ebc:	14102973          	csrr	s2,sepc
ffffffffc0200ec0:	143029f3          	csrr	s3,stval
ffffffffc0200ec4:	14202a73          	csrr	s4,scause
ffffffffc0200ec8:	e822                	sd	s0,16(sp)
ffffffffc0200eca:	e226                	sd	s1,256(sp)
ffffffffc0200ecc:	e64a                	sd	s2,264(sp)
ffffffffc0200ece:	ea4e                	sd	s3,272(sp)
ffffffffc0200ed0:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ed2:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ed4:	f09ff0ef          	jal	ra,ffffffffc0200ddc <trap>

ffffffffc0200ed8 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ed8:	6492                	ld	s1,256(sp)
ffffffffc0200eda:	6932                	ld	s2,264(sp)
ffffffffc0200edc:	1004f413          	andi	s0,s1,256
ffffffffc0200ee0:	e401                	bnez	s0,ffffffffc0200ee8 <__trapret+0x10>
ffffffffc0200ee2:	1200                	addi	s0,sp,288
ffffffffc0200ee4:	14041073          	csrw	sscratch,s0
ffffffffc0200ee8:	10049073          	csrw	sstatus,s1
ffffffffc0200eec:	14191073          	csrw	sepc,s2
ffffffffc0200ef0:	60a2                	ld	ra,8(sp)
ffffffffc0200ef2:	61e2                	ld	gp,24(sp)
ffffffffc0200ef4:	7202                	ld	tp,32(sp)
ffffffffc0200ef6:	72a2                	ld	t0,40(sp)
ffffffffc0200ef8:	7342                	ld	t1,48(sp)
ffffffffc0200efa:	73e2                	ld	t2,56(sp)
ffffffffc0200efc:	6406                	ld	s0,64(sp)
ffffffffc0200efe:	64a6                	ld	s1,72(sp)
ffffffffc0200f00:	6546                	ld	a0,80(sp)
ffffffffc0200f02:	65e6                	ld	a1,88(sp)
ffffffffc0200f04:	7606                	ld	a2,96(sp)
ffffffffc0200f06:	76a6                	ld	a3,104(sp)
ffffffffc0200f08:	7746                	ld	a4,112(sp)
ffffffffc0200f0a:	77e6                	ld	a5,120(sp)
ffffffffc0200f0c:	680a                	ld	a6,128(sp)
ffffffffc0200f0e:	68aa                	ld	a7,136(sp)
ffffffffc0200f10:	694a                	ld	s2,144(sp)
ffffffffc0200f12:	69ea                	ld	s3,152(sp)
ffffffffc0200f14:	7a0a                	ld	s4,160(sp)
ffffffffc0200f16:	7aaa                	ld	s5,168(sp)
ffffffffc0200f18:	7b4a                	ld	s6,176(sp)
ffffffffc0200f1a:	7bea                	ld	s7,184(sp)
ffffffffc0200f1c:	6c0e                	ld	s8,192(sp)
ffffffffc0200f1e:	6cae                	ld	s9,200(sp)
ffffffffc0200f20:	6d4e                	ld	s10,208(sp)
ffffffffc0200f22:	6dee                	ld	s11,216(sp)
ffffffffc0200f24:	7e0e                	ld	t3,224(sp)
ffffffffc0200f26:	7eae                	ld	t4,232(sp)
ffffffffc0200f28:	7f4e                	ld	t5,240(sp)
ffffffffc0200f2a:	7fee                	ld	t6,248(sp)
ffffffffc0200f2c:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f2e:	10200073          	sret

ffffffffc0200f32 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f32:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f34:	b755                	j	ffffffffc0200ed8 <__trapret>

ffffffffc0200f36 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f36:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f3a:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f3e:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f42:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f46:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f4a:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f4e:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f52:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f56:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f5a:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f5c:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f5e:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f60:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f62:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f64:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f66:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f68:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f6a:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f6c:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f6e:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f70:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f72:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f74:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f76:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f78:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f7a:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f7c:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f7e:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f80:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f82:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f84:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f86:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f88:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f8a:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f8c:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f8e:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f90:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f92:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f94:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f96:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f98:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f9a:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f9c:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f9e:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200fa0:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200fa2:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fa4:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fa6:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fa8:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200faa:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fac:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200fae:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fb0:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200fb2:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fb4:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fb6:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fb8:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fba:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fbc:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fbe:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fc0:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fc2:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fc4:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fc6:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fc8:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fca:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fcc:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fce:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fd0:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fd2:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fd4:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fd6:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fd8:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fda:	812e                	mv	sp,a1
ffffffffc0200fdc:	bdf5                	j	ffffffffc0200ed8 <__trapret>

ffffffffc0200fde <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fde:	000a5797          	auipc	a5,0xa5
ffffffffc0200fe2:	7ca78793          	addi	a5,a5,1994 # ffffffffc02a67a8 <free_area>
ffffffffc0200fe6:	e79c                	sd	a5,8(a5)
ffffffffc0200fe8:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fea:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fee:	8082                	ret

ffffffffc0200ff0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200ff0:	000a5517          	auipc	a0,0xa5
ffffffffc0200ff4:	7c856503          	lwu	a0,1992(a0) # ffffffffc02a67b8 <free_area+0x10>
ffffffffc0200ff8:	8082                	ret

ffffffffc0200ffa <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200ffa:	715d                	addi	sp,sp,-80
ffffffffc0200ffc:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200ffe:	000a5417          	auipc	s0,0xa5
ffffffffc0201002:	7aa40413          	addi	s0,s0,1962 # ffffffffc02a67a8 <free_area>
ffffffffc0201006:	641c                	ld	a5,8(s0)
ffffffffc0201008:	e486                	sd	ra,72(sp)
ffffffffc020100a:	fc26                	sd	s1,56(sp)
ffffffffc020100c:	f84a                	sd	s2,48(sp)
ffffffffc020100e:	f44e                	sd	s3,40(sp)
ffffffffc0201010:	f052                	sd	s4,32(sp)
ffffffffc0201012:	ec56                	sd	s5,24(sp)
ffffffffc0201014:	e85a                	sd	s6,16(sp)
ffffffffc0201016:	e45e                	sd	s7,8(sp)
ffffffffc0201018:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020101a:	2a878d63          	beq	a5,s0,ffffffffc02012d4 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020101e:	4481                	li	s1,0
ffffffffc0201020:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201022:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201026:	8b09                	andi	a4,a4,2
ffffffffc0201028:	2a070a63          	beqz	a4,ffffffffc02012dc <default_check+0x2e2>
        count++, total += p->property;
ffffffffc020102c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201030:	679c                	ld	a5,8(a5)
ffffffffc0201032:	2905                	addiw	s2,s2,1
ffffffffc0201034:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201036:	fe8796e3          	bne	a5,s0,ffffffffc0201022 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc020103a:	89a6                	mv	s3,s1
ffffffffc020103c:	6df000ef          	jal	ra,ffffffffc0201f1a <nr_free_pages>
ffffffffc0201040:	6f351e63          	bne	a0,s3,ffffffffc020173c <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201044:	4505                	li	a0,1
ffffffffc0201046:	657000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020104a:	8aaa                	mv	s5,a0
ffffffffc020104c:	42050863          	beqz	a0,ffffffffc020147c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201050:	4505                	li	a0,1
ffffffffc0201052:	64b000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201056:	89aa                	mv	s3,a0
ffffffffc0201058:	70050263          	beqz	a0,ffffffffc020175c <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020105c:	4505                	li	a0,1
ffffffffc020105e:	63f000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201062:	8a2a                	mv	s4,a0
ffffffffc0201064:	48050c63          	beqz	a0,ffffffffc02014fc <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201068:	293a8a63          	beq	s5,s3,ffffffffc02012fc <default_check+0x302>
ffffffffc020106c:	28aa8863          	beq	s5,a0,ffffffffc02012fc <default_check+0x302>
ffffffffc0201070:	28a98663          	beq	s3,a0,ffffffffc02012fc <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201074:	000aa783          	lw	a5,0(s5)
ffffffffc0201078:	2a079263          	bnez	a5,ffffffffc020131c <default_check+0x322>
ffffffffc020107c:	0009a783          	lw	a5,0(s3)
ffffffffc0201080:	28079e63          	bnez	a5,ffffffffc020131c <default_check+0x322>
ffffffffc0201084:	411c                	lw	a5,0(a0)
ffffffffc0201086:	28079b63          	bnez	a5,ffffffffc020131c <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc020108a:	000a9797          	auipc	a5,0xa9
ffffffffc020108e:	7967b783          	ld	a5,1942(a5) # ffffffffc02aa820 <pages>
ffffffffc0201092:	40fa8733          	sub	a4,s5,a5
ffffffffc0201096:	00006617          	auipc	a2,0x6
ffffffffc020109a:	7d263603          	ld	a2,2002(a2) # ffffffffc0207868 <nbase>
ffffffffc020109e:	8719                	srai	a4,a4,0x6
ffffffffc02010a0:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010a2:	000a9697          	auipc	a3,0xa9
ffffffffc02010a6:	7766b683          	ld	a3,1910(a3) # ffffffffc02aa818 <npage>
ffffffffc02010aa:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010ac:	0732                	slli	a4,a4,0xc
ffffffffc02010ae:	28d77763          	bgeu	a4,a3,ffffffffc020133c <default_check+0x342>
    return page - pages + nbase;
ffffffffc02010b2:	40f98733          	sub	a4,s3,a5
ffffffffc02010b6:	8719                	srai	a4,a4,0x6
ffffffffc02010b8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010ba:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010bc:	4cd77063          	bgeu	a4,a3,ffffffffc020157c <default_check+0x582>
    return page - pages + nbase;
ffffffffc02010c0:	40f507b3          	sub	a5,a0,a5
ffffffffc02010c4:	8799                	srai	a5,a5,0x6
ffffffffc02010c6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010c8:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010ca:	30d7f963          	bgeu	a5,a3,ffffffffc02013dc <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010ce:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010d0:	00043c03          	ld	s8,0(s0)
ffffffffc02010d4:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010d8:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010dc:	e400                	sd	s0,8(s0)
ffffffffc02010de:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010e0:	000a5797          	auipc	a5,0xa5
ffffffffc02010e4:	6c07ac23          	sw	zero,1752(a5) # ffffffffc02a67b8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010e8:	5b5000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc02010ec:	2c051863          	bnez	a0,ffffffffc02013bc <default_check+0x3c2>
    free_page(p0);
ffffffffc02010f0:	4585                	li	a1,1
ffffffffc02010f2:	8556                	mv	a0,s5
ffffffffc02010f4:	5e7000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_page(p1);
ffffffffc02010f8:	4585                	li	a1,1
ffffffffc02010fa:	854e                	mv	a0,s3
ffffffffc02010fc:	5df000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_page(p2);
ffffffffc0201100:	4585                	li	a1,1
ffffffffc0201102:	8552                	mv	a0,s4
ffffffffc0201104:	5d7000ef          	jal	ra,ffffffffc0201eda <free_pages>
    assert(nr_free == 3);
ffffffffc0201108:	4818                	lw	a4,16(s0)
ffffffffc020110a:	478d                	li	a5,3
ffffffffc020110c:	28f71863          	bne	a4,a5,ffffffffc020139c <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201110:	4505                	li	a0,1
ffffffffc0201112:	58b000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201116:	89aa                	mv	s3,a0
ffffffffc0201118:	26050263          	beqz	a0,ffffffffc020137c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020111c:	4505                	li	a0,1
ffffffffc020111e:	57f000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201122:	8aaa                	mv	s5,a0
ffffffffc0201124:	3a050c63          	beqz	a0,ffffffffc02014dc <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201128:	4505                	li	a0,1
ffffffffc020112a:	573000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020112e:	8a2a                	mv	s4,a0
ffffffffc0201130:	38050663          	beqz	a0,ffffffffc02014bc <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201134:	4505                	li	a0,1
ffffffffc0201136:	567000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020113a:	36051163          	bnez	a0,ffffffffc020149c <default_check+0x4a2>
    free_page(p0);
ffffffffc020113e:	4585                	li	a1,1
ffffffffc0201140:	854e                	mv	a0,s3
ffffffffc0201142:	599000ef          	jal	ra,ffffffffc0201eda <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201146:	641c                	ld	a5,8(s0)
ffffffffc0201148:	20878a63          	beq	a5,s0,ffffffffc020135c <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc020114c:	4505                	li	a0,1
ffffffffc020114e:	54f000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201152:	30a99563          	bne	s3,a0,ffffffffc020145c <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201156:	4505                	li	a0,1
ffffffffc0201158:	545000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020115c:	2e051063          	bnez	a0,ffffffffc020143c <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201160:	481c                	lw	a5,16(s0)
ffffffffc0201162:	2a079d63          	bnez	a5,ffffffffc020141c <default_check+0x422>
    free_page(p);
ffffffffc0201166:	854e                	mv	a0,s3
ffffffffc0201168:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020116a:	01843023          	sd	s8,0(s0)
ffffffffc020116e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201172:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201176:	565000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_page(p1);
ffffffffc020117a:	4585                	li	a1,1
ffffffffc020117c:	8556                	mv	a0,s5
ffffffffc020117e:	55d000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_page(p2);
ffffffffc0201182:	4585                	li	a1,1
ffffffffc0201184:	8552                	mv	a0,s4
ffffffffc0201186:	555000ef          	jal	ra,ffffffffc0201eda <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020118a:	4515                	li	a0,5
ffffffffc020118c:	511000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201190:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201192:	26050563          	beqz	a0,ffffffffc02013fc <default_check+0x402>
ffffffffc0201196:	651c                	ld	a5,8(a0)
ffffffffc0201198:	8385                	srli	a5,a5,0x1
ffffffffc020119a:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc020119c:	54079063          	bnez	a5,ffffffffc02016dc <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011a0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011a2:	00043b03          	ld	s6,0(s0)
ffffffffc02011a6:	00843a83          	ld	s5,8(s0)
ffffffffc02011aa:	e000                	sd	s0,0(s0)
ffffffffc02011ac:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02011ae:	4ef000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc02011b2:	50051563          	bnez	a0,ffffffffc02016bc <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011b6:	08098a13          	addi	s4,s3,128
ffffffffc02011ba:	8552                	mv	a0,s4
ffffffffc02011bc:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011be:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02011c2:	000a5797          	auipc	a5,0xa5
ffffffffc02011c6:	5e07ab23          	sw	zero,1526(a5) # ffffffffc02a67b8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011ca:	511000ef          	jal	ra,ffffffffc0201eda <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011ce:	4511                	li	a0,4
ffffffffc02011d0:	4cd000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc02011d4:	4c051463          	bnez	a0,ffffffffc020169c <default_check+0x6a2>
ffffffffc02011d8:	0889b783          	ld	a5,136(s3)
ffffffffc02011dc:	8385                	srli	a5,a5,0x1
ffffffffc02011de:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011e0:	48078e63          	beqz	a5,ffffffffc020167c <default_check+0x682>
ffffffffc02011e4:	0909a703          	lw	a4,144(s3)
ffffffffc02011e8:	478d                	li	a5,3
ffffffffc02011ea:	48f71963          	bne	a4,a5,ffffffffc020167c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011ee:	450d                	li	a0,3
ffffffffc02011f0:	4ad000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc02011f4:	8c2a                	mv	s8,a0
ffffffffc02011f6:	46050363          	beqz	a0,ffffffffc020165c <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02011fa:	4505                	li	a0,1
ffffffffc02011fc:	4a1000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201200:	42051e63          	bnez	a0,ffffffffc020163c <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201204:	418a1c63          	bne	s4,s8,ffffffffc020161c <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201208:	4585                	li	a1,1
ffffffffc020120a:	854e                	mv	a0,s3
ffffffffc020120c:	4cf000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_pages(p1, 3);
ffffffffc0201210:	458d                	li	a1,3
ffffffffc0201212:	8552                	mv	a0,s4
ffffffffc0201214:	4c7000ef          	jal	ra,ffffffffc0201eda <free_pages>
ffffffffc0201218:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020121c:	04098c13          	addi	s8,s3,64
ffffffffc0201220:	8385                	srli	a5,a5,0x1
ffffffffc0201222:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201224:	3c078c63          	beqz	a5,ffffffffc02015fc <default_check+0x602>
ffffffffc0201228:	0109a703          	lw	a4,16(s3)
ffffffffc020122c:	4785                	li	a5,1
ffffffffc020122e:	3cf71763          	bne	a4,a5,ffffffffc02015fc <default_check+0x602>
ffffffffc0201232:	008a3783          	ld	a5,8(s4)
ffffffffc0201236:	8385                	srli	a5,a5,0x1
ffffffffc0201238:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020123a:	3a078163          	beqz	a5,ffffffffc02015dc <default_check+0x5e2>
ffffffffc020123e:	010a2703          	lw	a4,16(s4)
ffffffffc0201242:	478d                	li	a5,3
ffffffffc0201244:	38f71c63          	bne	a4,a5,ffffffffc02015dc <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201248:	4505                	li	a0,1
ffffffffc020124a:	453000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020124e:	36a99763          	bne	s3,a0,ffffffffc02015bc <default_check+0x5c2>
    free_page(p0);
ffffffffc0201252:	4585                	li	a1,1
ffffffffc0201254:	487000ef          	jal	ra,ffffffffc0201eda <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201258:	4509                	li	a0,2
ffffffffc020125a:	443000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc020125e:	32aa1f63          	bne	s4,a0,ffffffffc020159c <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201262:	4589                	li	a1,2
ffffffffc0201264:	477000ef          	jal	ra,ffffffffc0201eda <free_pages>
    free_page(p2);
ffffffffc0201268:	4585                	li	a1,1
ffffffffc020126a:	8562                	mv	a0,s8
ffffffffc020126c:	46f000ef          	jal	ra,ffffffffc0201eda <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201270:	4515                	li	a0,5
ffffffffc0201272:	42b000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201276:	89aa                	mv	s3,a0
ffffffffc0201278:	48050263          	beqz	a0,ffffffffc02016fc <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020127c:	4505                	li	a0,1
ffffffffc020127e:	41f000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0201282:	2c051d63          	bnez	a0,ffffffffc020155c <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201286:	481c                	lw	a5,16(s0)
ffffffffc0201288:	2a079a63          	bnez	a5,ffffffffc020153c <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020128c:	4595                	li	a1,5
ffffffffc020128e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201290:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201294:	01643023          	sd	s6,0(s0)
ffffffffc0201298:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc020129c:	43f000ef          	jal	ra,ffffffffc0201eda <free_pages>
    return listelm->next;
ffffffffc02012a0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012a2:	00878963          	beq	a5,s0,ffffffffc02012b4 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012a6:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012aa:	679c                	ld	a5,8(a5)
ffffffffc02012ac:	397d                	addiw	s2,s2,-1
ffffffffc02012ae:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012b0:	fe879be3          	bne	a5,s0,ffffffffc02012a6 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012b4:	26091463          	bnez	s2,ffffffffc020151c <default_check+0x522>
    assert(total == 0);
ffffffffc02012b8:	46049263          	bnez	s1,ffffffffc020171c <default_check+0x722>
}
ffffffffc02012bc:	60a6                	ld	ra,72(sp)
ffffffffc02012be:	6406                	ld	s0,64(sp)
ffffffffc02012c0:	74e2                	ld	s1,56(sp)
ffffffffc02012c2:	7942                	ld	s2,48(sp)
ffffffffc02012c4:	79a2                	ld	s3,40(sp)
ffffffffc02012c6:	7a02                	ld	s4,32(sp)
ffffffffc02012c8:	6ae2                	ld	s5,24(sp)
ffffffffc02012ca:	6b42                	ld	s6,16(sp)
ffffffffc02012cc:	6ba2                	ld	s7,8(sp)
ffffffffc02012ce:	6c02                	ld	s8,0(sp)
ffffffffc02012d0:	6161                	addi	sp,sp,80
ffffffffc02012d2:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012d4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012d6:	4481                	li	s1,0
ffffffffc02012d8:	4901                	li	s2,0
ffffffffc02012da:	b38d                	j	ffffffffc020103c <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012dc:	00005697          	auipc	a3,0x5
ffffffffc02012e0:	eac68693          	addi	a3,a3,-340 # ffffffffc0206188 <commands+0x818>
ffffffffc02012e4:	00005617          	auipc	a2,0x5
ffffffffc02012e8:	eb460613          	addi	a2,a2,-332 # ffffffffc0206198 <commands+0x828>
ffffffffc02012ec:	11000593          	li	a1,272
ffffffffc02012f0:	00005517          	auipc	a0,0x5
ffffffffc02012f4:	ec050513          	addi	a0,a0,-320 # ffffffffc02061b0 <commands+0x840>
ffffffffc02012f8:	996ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02012fc:	00005697          	auipc	a3,0x5
ffffffffc0201300:	f4c68693          	addi	a3,a3,-180 # ffffffffc0206248 <commands+0x8d8>
ffffffffc0201304:	00005617          	auipc	a2,0x5
ffffffffc0201308:	e9460613          	addi	a2,a2,-364 # ffffffffc0206198 <commands+0x828>
ffffffffc020130c:	0db00593          	li	a1,219
ffffffffc0201310:	00005517          	auipc	a0,0x5
ffffffffc0201314:	ea050513          	addi	a0,a0,-352 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201318:	976ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020131c:	00005697          	auipc	a3,0x5
ffffffffc0201320:	f5468693          	addi	a3,a3,-172 # ffffffffc0206270 <commands+0x900>
ffffffffc0201324:	00005617          	auipc	a2,0x5
ffffffffc0201328:	e7460613          	addi	a2,a2,-396 # ffffffffc0206198 <commands+0x828>
ffffffffc020132c:	0dc00593          	li	a1,220
ffffffffc0201330:	00005517          	auipc	a0,0x5
ffffffffc0201334:	e8050513          	addi	a0,a0,-384 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201338:	956ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020133c:	00005697          	auipc	a3,0x5
ffffffffc0201340:	f7468693          	addi	a3,a3,-140 # ffffffffc02062b0 <commands+0x940>
ffffffffc0201344:	00005617          	auipc	a2,0x5
ffffffffc0201348:	e5460613          	addi	a2,a2,-428 # ffffffffc0206198 <commands+0x828>
ffffffffc020134c:	0de00593          	li	a1,222
ffffffffc0201350:	00005517          	auipc	a0,0x5
ffffffffc0201354:	e6050513          	addi	a0,a0,-416 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201358:	936ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc020135c:	00005697          	auipc	a3,0x5
ffffffffc0201360:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206338 <commands+0x9c8>
ffffffffc0201364:	00005617          	auipc	a2,0x5
ffffffffc0201368:	e3460613          	addi	a2,a2,-460 # ffffffffc0206198 <commands+0x828>
ffffffffc020136c:	0f700593          	li	a1,247
ffffffffc0201370:	00005517          	auipc	a0,0x5
ffffffffc0201374:	e4050513          	addi	a0,a0,-448 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201378:	916ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020137c:	00005697          	auipc	a3,0x5
ffffffffc0201380:	e6c68693          	addi	a3,a3,-404 # ffffffffc02061e8 <commands+0x878>
ffffffffc0201384:	00005617          	auipc	a2,0x5
ffffffffc0201388:	e1460613          	addi	a2,a2,-492 # ffffffffc0206198 <commands+0x828>
ffffffffc020138c:	0f000593          	li	a1,240
ffffffffc0201390:	00005517          	auipc	a0,0x5
ffffffffc0201394:	e2050513          	addi	a0,a0,-480 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201398:	8f6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc020139c:	00005697          	auipc	a3,0x5
ffffffffc02013a0:	f8c68693          	addi	a3,a3,-116 # ffffffffc0206328 <commands+0x9b8>
ffffffffc02013a4:	00005617          	auipc	a2,0x5
ffffffffc02013a8:	df460613          	addi	a2,a2,-524 # ffffffffc0206198 <commands+0x828>
ffffffffc02013ac:	0ee00593          	li	a1,238
ffffffffc02013b0:	00005517          	auipc	a0,0x5
ffffffffc02013b4:	e0050513          	addi	a0,a0,-512 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013b8:	8d6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013bc:	00005697          	auipc	a3,0x5
ffffffffc02013c0:	f5468693          	addi	a3,a3,-172 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02013c4:	00005617          	auipc	a2,0x5
ffffffffc02013c8:	dd460613          	addi	a2,a2,-556 # ffffffffc0206198 <commands+0x828>
ffffffffc02013cc:	0e900593          	li	a1,233
ffffffffc02013d0:	00005517          	auipc	a0,0x5
ffffffffc02013d4:	de050513          	addi	a0,a0,-544 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013d8:	8b6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013dc:	00005697          	auipc	a3,0x5
ffffffffc02013e0:	f1468693          	addi	a3,a3,-236 # ffffffffc02062f0 <commands+0x980>
ffffffffc02013e4:	00005617          	auipc	a2,0x5
ffffffffc02013e8:	db460613          	addi	a2,a2,-588 # ffffffffc0206198 <commands+0x828>
ffffffffc02013ec:	0e000593          	li	a1,224
ffffffffc02013f0:	00005517          	auipc	a0,0x5
ffffffffc02013f4:	dc050513          	addi	a0,a0,-576 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013f8:	896ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02013fc:	00005697          	auipc	a3,0x5
ffffffffc0201400:	f8468693          	addi	a3,a3,-124 # ffffffffc0206380 <commands+0xa10>
ffffffffc0201404:	00005617          	auipc	a2,0x5
ffffffffc0201408:	d9460613          	addi	a2,a2,-620 # ffffffffc0206198 <commands+0x828>
ffffffffc020140c:	11800593          	li	a1,280
ffffffffc0201410:	00005517          	auipc	a0,0x5
ffffffffc0201414:	da050513          	addi	a0,a0,-608 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201418:	876ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc020141c:	00005697          	auipc	a3,0x5
ffffffffc0201420:	f5468693          	addi	a3,a3,-172 # ffffffffc0206370 <commands+0xa00>
ffffffffc0201424:	00005617          	auipc	a2,0x5
ffffffffc0201428:	d7460613          	addi	a2,a2,-652 # ffffffffc0206198 <commands+0x828>
ffffffffc020142c:	0fd00593          	li	a1,253
ffffffffc0201430:	00005517          	auipc	a0,0x5
ffffffffc0201434:	d8050513          	addi	a0,a0,-640 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201438:	856ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020143c:	00005697          	auipc	a3,0x5
ffffffffc0201440:	ed468693          	addi	a3,a3,-300 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201444:	00005617          	auipc	a2,0x5
ffffffffc0201448:	d5460613          	addi	a2,a2,-684 # ffffffffc0206198 <commands+0x828>
ffffffffc020144c:	0fb00593          	li	a1,251
ffffffffc0201450:	00005517          	auipc	a0,0x5
ffffffffc0201454:	d6050513          	addi	a0,a0,-672 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201458:	836ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020145c:	00005697          	auipc	a3,0x5
ffffffffc0201460:	ef468693          	addi	a3,a3,-268 # ffffffffc0206350 <commands+0x9e0>
ffffffffc0201464:	00005617          	auipc	a2,0x5
ffffffffc0201468:	d3460613          	addi	a2,a2,-716 # ffffffffc0206198 <commands+0x828>
ffffffffc020146c:	0fa00593          	li	a1,250
ffffffffc0201470:	00005517          	auipc	a0,0x5
ffffffffc0201474:	d4050513          	addi	a0,a0,-704 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201478:	816ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020147c:	00005697          	auipc	a3,0x5
ffffffffc0201480:	d6c68693          	addi	a3,a3,-660 # ffffffffc02061e8 <commands+0x878>
ffffffffc0201484:	00005617          	auipc	a2,0x5
ffffffffc0201488:	d1460613          	addi	a2,a2,-748 # ffffffffc0206198 <commands+0x828>
ffffffffc020148c:	0d700593          	li	a1,215
ffffffffc0201490:	00005517          	auipc	a0,0x5
ffffffffc0201494:	d2050513          	addi	a0,a0,-736 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201498:	ff7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020149c:	00005697          	auipc	a3,0x5
ffffffffc02014a0:	e7468693          	addi	a3,a3,-396 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02014a4:	00005617          	auipc	a2,0x5
ffffffffc02014a8:	cf460613          	addi	a2,a2,-780 # ffffffffc0206198 <commands+0x828>
ffffffffc02014ac:	0f400593          	li	a1,244
ffffffffc02014b0:	00005517          	auipc	a0,0x5
ffffffffc02014b4:	d0050513          	addi	a0,a0,-768 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014b8:	fd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014bc:	00005697          	auipc	a3,0x5
ffffffffc02014c0:	d6c68693          	addi	a3,a3,-660 # ffffffffc0206228 <commands+0x8b8>
ffffffffc02014c4:	00005617          	auipc	a2,0x5
ffffffffc02014c8:	cd460613          	addi	a2,a2,-812 # ffffffffc0206198 <commands+0x828>
ffffffffc02014cc:	0f200593          	li	a1,242
ffffffffc02014d0:	00005517          	auipc	a0,0x5
ffffffffc02014d4:	ce050513          	addi	a0,a0,-800 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014d8:	fb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014dc:	00005697          	auipc	a3,0x5
ffffffffc02014e0:	d2c68693          	addi	a3,a3,-724 # ffffffffc0206208 <commands+0x898>
ffffffffc02014e4:	00005617          	auipc	a2,0x5
ffffffffc02014e8:	cb460613          	addi	a2,a2,-844 # ffffffffc0206198 <commands+0x828>
ffffffffc02014ec:	0f100593          	li	a1,241
ffffffffc02014f0:	00005517          	auipc	a0,0x5
ffffffffc02014f4:	cc050513          	addi	a0,a0,-832 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014f8:	f97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014fc:	00005697          	auipc	a3,0x5
ffffffffc0201500:	d2c68693          	addi	a3,a3,-724 # ffffffffc0206228 <commands+0x8b8>
ffffffffc0201504:	00005617          	auipc	a2,0x5
ffffffffc0201508:	c9460613          	addi	a2,a2,-876 # ffffffffc0206198 <commands+0x828>
ffffffffc020150c:	0d900593          	li	a1,217
ffffffffc0201510:	00005517          	auipc	a0,0x5
ffffffffc0201514:	ca050513          	addi	a0,a0,-864 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201518:	f77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc020151c:	00005697          	auipc	a3,0x5
ffffffffc0201520:	fb468693          	addi	a3,a3,-76 # ffffffffc02064d0 <commands+0xb60>
ffffffffc0201524:	00005617          	auipc	a2,0x5
ffffffffc0201528:	c7460613          	addi	a2,a2,-908 # ffffffffc0206198 <commands+0x828>
ffffffffc020152c:	14600593          	li	a1,326
ffffffffc0201530:	00005517          	auipc	a0,0x5
ffffffffc0201534:	c8050513          	addi	a0,a0,-896 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201538:	f57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc020153c:	00005697          	auipc	a3,0x5
ffffffffc0201540:	e3468693          	addi	a3,a3,-460 # ffffffffc0206370 <commands+0xa00>
ffffffffc0201544:	00005617          	auipc	a2,0x5
ffffffffc0201548:	c5460613          	addi	a2,a2,-940 # ffffffffc0206198 <commands+0x828>
ffffffffc020154c:	13a00593          	li	a1,314
ffffffffc0201550:	00005517          	auipc	a0,0x5
ffffffffc0201554:	c6050513          	addi	a0,a0,-928 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201558:	f37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020155c:	00005697          	auipc	a3,0x5
ffffffffc0201560:	db468693          	addi	a3,a3,-588 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201564:	00005617          	auipc	a2,0x5
ffffffffc0201568:	c3460613          	addi	a2,a2,-972 # ffffffffc0206198 <commands+0x828>
ffffffffc020156c:	13800593          	li	a1,312
ffffffffc0201570:	00005517          	auipc	a0,0x5
ffffffffc0201574:	c4050513          	addi	a0,a0,-960 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201578:	f17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020157c:	00005697          	auipc	a3,0x5
ffffffffc0201580:	d5468693          	addi	a3,a3,-684 # ffffffffc02062d0 <commands+0x960>
ffffffffc0201584:	00005617          	auipc	a2,0x5
ffffffffc0201588:	c1460613          	addi	a2,a2,-1004 # ffffffffc0206198 <commands+0x828>
ffffffffc020158c:	0df00593          	li	a1,223
ffffffffc0201590:	00005517          	auipc	a0,0x5
ffffffffc0201594:	c2050513          	addi	a0,a0,-992 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201598:	ef7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020159c:	00005697          	auipc	a3,0x5
ffffffffc02015a0:	ef468693          	addi	a3,a3,-268 # ffffffffc0206490 <commands+0xb20>
ffffffffc02015a4:	00005617          	auipc	a2,0x5
ffffffffc02015a8:	bf460613          	addi	a2,a2,-1036 # ffffffffc0206198 <commands+0x828>
ffffffffc02015ac:	13200593          	li	a1,306
ffffffffc02015b0:	00005517          	auipc	a0,0x5
ffffffffc02015b4:	c0050513          	addi	a0,a0,-1024 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015b8:	ed7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015bc:	00005697          	auipc	a3,0x5
ffffffffc02015c0:	eb468693          	addi	a3,a3,-332 # ffffffffc0206470 <commands+0xb00>
ffffffffc02015c4:	00005617          	auipc	a2,0x5
ffffffffc02015c8:	bd460613          	addi	a2,a2,-1068 # ffffffffc0206198 <commands+0x828>
ffffffffc02015cc:	13000593          	li	a1,304
ffffffffc02015d0:	00005517          	auipc	a0,0x5
ffffffffc02015d4:	be050513          	addi	a0,a0,-1056 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015d8:	eb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015dc:	00005697          	auipc	a3,0x5
ffffffffc02015e0:	e6c68693          	addi	a3,a3,-404 # ffffffffc0206448 <commands+0xad8>
ffffffffc02015e4:	00005617          	auipc	a2,0x5
ffffffffc02015e8:	bb460613          	addi	a2,a2,-1100 # ffffffffc0206198 <commands+0x828>
ffffffffc02015ec:	12e00593          	li	a1,302
ffffffffc02015f0:	00005517          	auipc	a0,0x5
ffffffffc02015f4:	bc050513          	addi	a0,a0,-1088 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015f8:	e97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015fc:	00005697          	auipc	a3,0x5
ffffffffc0201600:	e2468693          	addi	a3,a3,-476 # ffffffffc0206420 <commands+0xab0>
ffffffffc0201604:	00005617          	auipc	a2,0x5
ffffffffc0201608:	b9460613          	addi	a2,a2,-1132 # ffffffffc0206198 <commands+0x828>
ffffffffc020160c:	12d00593          	li	a1,301
ffffffffc0201610:	00005517          	auipc	a0,0x5
ffffffffc0201614:	ba050513          	addi	a0,a0,-1120 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201618:	e77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc020161c:	00005697          	auipc	a3,0x5
ffffffffc0201620:	df468693          	addi	a3,a3,-524 # ffffffffc0206410 <commands+0xaa0>
ffffffffc0201624:	00005617          	auipc	a2,0x5
ffffffffc0201628:	b7460613          	addi	a2,a2,-1164 # ffffffffc0206198 <commands+0x828>
ffffffffc020162c:	12800593          	li	a1,296
ffffffffc0201630:	00005517          	auipc	a0,0x5
ffffffffc0201634:	b8050513          	addi	a0,a0,-1152 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201638:	e57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020163c:	00005697          	auipc	a3,0x5
ffffffffc0201640:	cd468693          	addi	a3,a3,-812 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201644:	00005617          	auipc	a2,0x5
ffffffffc0201648:	b5460613          	addi	a2,a2,-1196 # ffffffffc0206198 <commands+0x828>
ffffffffc020164c:	12700593          	li	a1,295
ffffffffc0201650:	00005517          	auipc	a0,0x5
ffffffffc0201654:	b6050513          	addi	a0,a0,-1184 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201658:	e37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020165c:	00005697          	auipc	a3,0x5
ffffffffc0201660:	d9468693          	addi	a3,a3,-620 # ffffffffc02063f0 <commands+0xa80>
ffffffffc0201664:	00005617          	auipc	a2,0x5
ffffffffc0201668:	b3460613          	addi	a2,a2,-1228 # ffffffffc0206198 <commands+0x828>
ffffffffc020166c:	12600593          	li	a1,294
ffffffffc0201670:	00005517          	auipc	a0,0x5
ffffffffc0201674:	b4050513          	addi	a0,a0,-1216 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201678:	e17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020167c:	00005697          	auipc	a3,0x5
ffffffffc0201680:	d4468693          	addi	a3,a3,-700 # ffffffffc02063c0 <commands+0xa50>
ffffffffc0201684:	00005617          	auipc	a2,0x5
ffffffffc0201688:	b1460613          	addi	a2,a2,-1260 # ffffffffc0206198 <commands+0x828>
ffffffffc020168c:	12500593          	li	a1,293
ffffffffc0201690:	00005517          	auipc	a0,0x5
ffffffffc0201694:	b2050513          	addi	a0,a0,-1248 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201698:	df7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020169c:	00005697          	auipc	a3,0x5
ffffffffc02016a0:	d0c68693          	addi	a3,a3,-756 # ffffffffc02063a8 <commands+0xa38>
ffffffffc02016a4:	00005617          	auipc	a2,0x5
ffffffffc02016a8:	af460613          	addi	a2,a2,-1292 # ffffffffc0206198 <commands+0x828>
ffffffffc02016ac:	12400593          	li	a1,292
ffffffffc02016b0:	00005517          	auipc	a0,0x5
ffffffffc02016b4:	b0050513          	addi	a0,a0,-1280 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016b8:	dd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016bc:	00005697          	auipc	a3,0x5
ffffffffc02016c0:	c5468693          	addi	a3,a3,-940 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02016c4:	00005617          	auipc	a2,0x5
ffffffffc02016c8:	ad460613          	addi	a2,a2,-1324 # ffffffffc0206198 <commands+0x828>
ffffffffc02016cc:	11e00593          	li	a1,286
ffffffffc02016d0:	00005517          	auipc	a0,0x5
ffffffffc02016d4:	ae050513          	addi	a0,a0,-1312 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016d8:	db7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02016dc:	00005697          	auipc	a3,0x5
ffffffffc02016e0:	cb468693          	addi	a3,a3,-844 # ffffffffc0206390 <commands+0xa20>
ffffffffc02016e4:	00005617          	auipc	a2,0x5
ffffffffc02016e8:	ab460613          	addi	a2,a2,-1356 # ffffffffc0206198 <commands+0x828>
ffffffffc02016ec:	11900593          	li	a1,281
ffffffffc02016f0:	00005517          	auipc	a0,0x5
ffffffffc02016f4:	ac050513          	addi	a0,a0,-1344 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016f8:	d97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016fc:	00005697          	auipc	a3,0x5
ffffffffc0201700:	db468693          	addi	a3,a3,-588 # ffffffffc02064b0 <commands+0xb40>
ffffffffc0201704:	00005617          	auipc	a2,0x5
ffffffffc0201708:	a9460613          	addi	a2,a2,-1388 # ffffffffc0206198 <commands+0x828>
ffffffffc020170c:	13700593          	li	a1,311
ffffffffc0201710:	00005517          	auipc	a0,0x5
ffffffffc0201714:	aa050513          	addi	a0,a0,-1376 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201718:	d77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc020171c:	00005697          	auipc	a3,0x5
ffffffffc0201720:	dc468693          	addi	a3,a3,-572 # ffffffffc02064e0 <commands+0xb70>
ffffffffc0201724:	00005617          	auipc	a2,0x5
ffffffffc0201728:	a7460613          	addi	a2,a2,-1420 # ffffffffc0206198 <commands+0x828>
ffffffffc020172c:	14700593          	li	a1,327
ffffffffc0201730:	00005517          	auipc	a0,0x5
ffffffffc0201734:	a8050513          	addi	a0,a0,-1408 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201738:	d57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc020173c:	00005697          	auipc	a3,0x5
ffffffffc0201740:	a8c68693          	addi	a3,a3,-1396 # ffffffffc02061c8 <commands+0x858>
ffffffffc0201744:	00005617          	auipc	a2,0x5
ffffffffc0201748:	a5460613          	addi	a2,a2,-1452 # ffffffffc0206198 <commands+0x828>
ffffffffc020174c:	11300593          	li	a1,275
ffffffffc0201750:	00005517          	auipc	a0,0x5
ffffffffc0201754:	a6050513          	addi	a0,a0,-1440 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201758:	d37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020175c:	00005697          	auipc	a3,0x5
ffffffffc0201760:	aac68693          	addi	a3,a3,-1364 # ffffffffc0206208 <commands+0x898>
ffffffffc0201764:	00005617          	auipc	a2,0x5
ffffffffc0201768:	a3460613          	addi	a2,a2,-1484 # ffffffffc0206198 <commands+0x828>
ffffffffc020176c:	0d800593          	li	a1,216
ffffffffc0201770:	00005517          	auipc	a0,0x5
ffffffffc0201774:	a4050513          	addi	a0,a0,-1472 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201778:	d17fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020177c <default_free_pages>:
{
ffffffffc020177c:	1141                	addi	sp,sp,-16
ffffffffc020177e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201780:	14058463          	beqz	a1,ffffffffc02018c8 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201784:	00659693          	slli	a3,a1,0x6
ffffffffc0201788:	96aa                	add	a3,a3,a0
ffffffffc020178a:	87aa                	mv	a5,a0
ffffffffc020178c:	02d50263          	beq	a0,a3,ffffffffc02017b0 <default_free_pages+0x34>
ffffffffc0201790:	6798                	ld	a4,8(a5)
ffffffffc0201792:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201794:	10071a63          	bnez	a4,ffffffffc02018a8 <default_free_pages+0x12c>
ffffffffc0201798:	6798                	ld	a4,8(a5)
ffffffffc020179a:	8b09                	andi	a4,a4,2
ffffffffc020179c:	10071663          	bnez	a4,ffffffffc02018a8 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02017a0:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017a4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017a8:	04078793          	addi	a5,a5,64
ffffffffc02017ac:	fed792e3          	bne	a5,a3,ffffffffc0201790 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017b0:	2581                	sext.w	a1,a1
ffffffffc02017b2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017b4:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017b8:	4789                	li	a5,2
ffffffffc02017ba:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017be:	000a5697          	auipc	a3,0xa5
ffffffffc02017c2:	fea68693          	addi	a3,a3,-22 # ffffffffc02a67a8 <free_area>
ffffffffc02017c6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017c8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017ca:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017ce:	9db9                	addw	a1,a1,a4
ffffffffc02017d0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017d2:	0ad78463          	beq	a5,a3,ffffffffc020187a <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02017d6:	fe878713          	addi	a4,a5,-24
ffffffffc02017da:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017de:	4581                	li	a1,0
            if (base < page)
ffffffffc02017e0:	00e56a63          	bltu	a0,a4,ffffffffc02017f4 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017e4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017e6:	04d70c63          	beq	a4,a3,ffffffffc020183e <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02017ea:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017ec:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017f0:	fee57ae3          	bgeu	a0,a4,ffffffffc02017e4 <default_free_pages+0x68>
ffffffffc02017f4:	c199                	beqz	a1,ffffffffc02017fa <default_free_pages+0x7e>
ffffffffc02017f6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017fa:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017fc:	e390                	sd	a2,0(a5)
ffffffffc02017fe:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201800:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201802:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201804:	00d70d63          	beq	a4,a3,ffffffffc020181e <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201808:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc020180c:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201810:	02059813          	slli	a6,a1,0x20
ffffffffc0201814:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201818:	97b2                	add	a5,a5,a2
ffffffffc020181a:	02f50c63          	beq	a0,a5,ffffffffc0201852 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020181e:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201820:	00d78c63          	beq	a5,a3,ffffffffc0201838 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201824:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201826:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc020182a:	02061593          	slli	a1,a2,0x20
ffffffffc020182e:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201832:	972a                	add	a4,a4,a0
ffffffffc0201834:	04e68a63          	beq	a3,a4,ffffffffc0201888 <default_free_pages+0x10c>
}
ffffffffc0201838:	60a2                	ld	ra,8(sp)
ffffffffc020183a:	0141                	addi	sp,sp,16
ffffffffc020183c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020183e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201840:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201842:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201844:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201846:	02d70763          	beq	a4,a3,ffffffffc0201874 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc020184a:	8832                	mv	a6,a2
ffffffffc020184c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020184e:	87ba                	mv	a5,a4
ffffffffc0201850:	bf71                	j	ffffffffc02017ec <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201852:	491c                	lw	a5,16(a0)
ffffffffc0201854:	9dbd                	addw	a1,a1,a5
ffffffffc0201856:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020185a:	57f5                	li	a5,-3
ffffffffc020185c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201860:	01853803          	ld	a6,24(a0)
ffffffffc0201864:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201866:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201868:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc020186c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020186e:	0105b023          	sd	a6,0(a1)
ffffffffc0201872:	b77d                	j	ffffffffc0201820 <default_free_pages+0xa4>
ffffffffc0201874:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201876:	873e                	mv	a4,a5
ffffffffc0201878:	bf41                	j	ffffffffc0201808 <default_free_pages+0x8c>
}
ffffffffc020187a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020187c:	e390                	sd	a2,0(a5)
ffffffffc020187e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201880:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201882:	ed1c                	sd	a5,24(a0)
ffffffffc0201884:	0141                	addi	sp,sp,16
ffffffffc0201886:	8082                	ret
            base->property += p->property;
ffffffffc0201888:	ff87a703          	lw	a4,-8(a5)
ffffffffc020188c:	ff078693          	addi	a3,a5,-16
ffffffffc0201890:	9e39                	addw	a2,a2,a4
ffffffffc0201892:	c910                	sw	a2,16(a0)
ffffffffc0201894:	5775                	li	a4,-3
ffffffffc0201896:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020189a:	6398                	ld	a4,0(a5)
ffffffffc020189c:	679c                	ld	a5,8(a5)
}
ffffffffc020189e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018a0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018a2:	e398                	sd	a4,0(a5)
ffffffffc02018a4:	0141                	addi	sp,sp,16
ffffffffc02018a6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018a8:	00005697          	auipc	a3,0x5
ffffffffc02018ac:	c5068693          	addi	a3,a3,-944 # ffffffffc02064f8 <commands+0xb88>
ffffffffc02018b0:	00005617          	auipc	a2,0x5
ffffffffc02018b4:	8e860613          	addi	a2,a2,-1816 # ffffffffc0206198 <commands+0x828>
ffffffffc02018b8:	09400593          	li	a1,148
ffffffffc02018bc:	00005517          	auipc	a0,0x5
ffffffffc02018c0:	8f450513          	addi	a0,a0,-1804 # ffffffffc02061b0 <commands+0x840>
ffffffffc02018c4:	bcbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc02018c8:	00005697          	auipc	a3,0x5
ffffffffc02018cc:	c2868693          	addi	a3,a3,-984 # ffffffffc02064f0 <commands+0xb80>
ffffffffc02018d0:	00005617          	auipc	a2,0x5
ffffffffc02018d4:	8c860613          	addi	a2,a2,-1848 # ffffffffc0206198 <commands+0x828>
ffffffffc02018d8:	09000593          	li	a1,144
ffffffffc02018dc:	00005517          	auipc	a0,0x5
ffffffffc02018e0:	8d450513          	addi	a0,a0,-1836 # ffffffffc02061b0 <commands+0x840>
ffffffffc02018e4:	babfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02018e8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018e8:	c941                	beqz	a0,ffffffffc0201978 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018ea:	000a5597          	auipc	a1,0xa5
ffffffffc02018ee:	ebe58593          	addi	a1,a1,-322 # ffffffffc02a67a8 <free_area>
ffffffffc02018f2:	0105a803          	lw	a6,16(a1)
ffffffffc02018f6:	872a                	mv	a4,a0
ffffffffc02018f8:	02081793          	slli	a5,a6,0x20
ffffffffc02018fc:	9381                	srli	a5,a5,0x20
ffffffffc02018fe:	00a7ee63          	bltu	a5,a0,ffffffffc020191a <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201902:	87ae                	mv	a5,a1
ffffffffc0201904:	a801                	j	ffffffffc0201914 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201906:	ff87a683          	lw	a3,-8(a5)
ffffffffc020190a:	02069613          	slli	a2,a3,0x20
ffffffffc020190e:	9201                	srli	a2,a2,0x20
ffffffffc0201910:	00e67763          	bgeu	a2,a4,ffffffffc020191e <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201914:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201916:	feb798e3          	bne	a5,a1,ffffffffc0201906 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020191a:	4501                	li	a0,0
}
ffffffffc020191c:	8082                	ret
    return listelm->prev;
ffffffffc020191e:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201922:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201926:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc020192a:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020192e:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201932:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201936:	02c77863          	bgeu	a4,a2,ffffffffc0201966 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc020193a:	071a                	slli	a4,a4,0x6
ffffffffc020193c:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020193e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201942:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201944:	00870613          	addi	a2,a4,8
ffffffffc0201948:	4689                	li	a3,2
ffffffffc020194a:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020194e:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201952:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201956:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020195a:	e290                	sd	a2,0(a3)
ffffffffc020195c:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201960:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201962:	01173c23          	sd	a7,24(a4)
ffffffffc0201966:	41c8083b          	subw	a6,a6,t3
ffffffffc020196a:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020196e:	5775                	li	a4,-3
ffffffffc0201970:	17c1                	addi	a5,a5,-16
ffffffffc0201972:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201976:	8082                	ret
{
ffffffffc0201978:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020197a:	00005697          	auipc	a3,0x5
ffffffffc020197e:	b7668693          	addi	a3,a3,-1162 # ffffffffc02064f0 <commands+0xb80>
ffffffffc0201982:	00005617          	auipc	a2,0x5
ffffffffc0201986:	81660613          	addi	a2,a2,-2026 # ffffffffc0206198 <commands+0x828>
ffffffffc020198a:	06c00593          	li	a1,108
ffffffffc020198e:	00005517          	auipc	a0,0x5
ffffffffc0201992:	82250513          	addi	a0,a0,-2014 # ffffffffc02061b0 <commands+0x840>
{
ffffffffc0201996:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201998:	af7fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020199c <default_init_memmap>:
{
ffffffffc020199c:	1141                	addi	sp,sp,-16
ffffffffc020199e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019a0:	c5f1                	beqz	a1,ffffffffc0201a6c <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02019a2:	00659693          	slli	a3,a1,0x6
ffffffffc02019a6:	96aa                	add	a3,a3,a0
ffffffffc02019a8:	87aa                	mv	a5,a0
ffffffffc02019aa:	00d50f63          	beq	a0,a3,ffffffffc02019c8 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019ae:	6798                	ld	a4,8(a5)
ffffffffc02019b0:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02019b2:	cf49                	beqz	a4,ffffffffc0201a4c <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019b4:	0007a823          	sw	zero,16(a5)
ffffffffc02019b8:	0007b423          	sd	zero,8(a5)
ffffffffc02019bc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019c0:	04078793          	addi	a5,a5,64
ffffffffc02019c4:	fed795e3          	bne	a5,a3,ffffffffc02019ae <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019c8:	2581                	sext.w	a1,a1
ffffffffc02019ca:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019cc:	4789                	li	a5,2
ffffffffc02019ce:	00850713          	addi	a4,a0,8
ffffffffc02019d2:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019d6:	000a5697          	auipc	a3,0xa5
ffffffffc02019da:	dd268693          	addi	a3,a3,-558 # ffffffffc02a67a8 <free_area>
ffffffffc02019de:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019e0:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019e2:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019e6:	9db9                	addw	a1,a1,a4
ffffffffc02019e8:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019ea:	04d78a63          	beq	a5,a3,ffffffffc0201a3e <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019ee:	fe878713          	addi	a4,a5,-24
ffffffffc02019f2:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019f6:	4581                	li	a1,0
            if (base < page)
ffffffffc02019f8:	00e56a63          	bltu	a0,a4,ffffffffc0201a0c <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019fc:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019fe:	02d70263          	beq	a4,a3,ffffffffc0201a22 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201a02:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a04:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a08:	fee57ae3          	bgeu	a0,a4,ffffffffc02019fc <default_init_memmap+0x60>
ffffffffc0201a0c:	c199                	beqz	a1,ffffffffc0201a12 <default_init_memmap+0x76>
ffffffffc0201a0e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a12:	6398                	ld	a4,0(a5)
}
ffffffffc0201a14:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a16:	e390                	sd	a2,0(a5)
ffffffffc0201a18:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a1a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a1c:	ed18                	sd	a4,24(a0)
ffffffffc0201a1e:	0141                	addi	sp,sp,16
ffffffffc0201a20:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a22:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a24:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a26:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a28:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a2a:	00d70663          	beq	a4,a3,ffffffffc0201a36 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a2e:	8832                	mv	a6,a2
ffffffffc0201a30:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a32:	87ba                	mv	a5,a4
ffffffffc0201a34:	bfc1                	j	ffffffffc0201a04 <default_init_memmap+0x68>
}
ffffffffc0201a36:	60a2                	ld	ra,8(sp)
ffffffffc0201a38:	e290                	sd	a2,0(a3)
ffffffffc0201a3a:	0141                	addi	sp,sp,16
ffffffffc0201a3c:	8082                	ret
ffffffffc0201a3e:	60a2                	ld	ra,8(sp)
ffffffffc0201a40:	e390                	sd	a2,0(a5)
ffffffffc0201a42:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a44:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a46:	ed1c                	sd	a5,24(a0)
ffffffffc0201a48:	0141                	addi	sp,sp,16
ffffffffc0201a4a:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a4c:	00005697          	auipc	a3,0x5
ffffffffc0201a50:	ad468693          	addi	a3,a3,-1324 # ffffffffc0206520 <commands+0xbb0>
ffffffffc0201a54:	00004617          	auipc	a2,0x4
ffffffffc0201a58:	74460613          	addi	a2,a2,1860 # ffffffffc0206198 <commands+0x828>
ffffffffc0201a5c:	04b00593          	li	a1,75
ffffffffc0201a60:	00004517          	auipc	a0,0x4
ffffffffc0201a64:	75050513          	addi	a0,a0,1872 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201a68:	a27fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a6c:	00005697          	auipc	a3,0x5
ffffffffc0201a70:	a8468693          	addi	a3,a3,-1404 # ffffffffc02064f0 <commands+0xb80>
ffffffffc0201a74:	00004617          	auipc	a2,0x4
ffffffffc0201a78:	72460613          	addi	a2,a2,1828 # ffffffffc0206198 <commands+0x828>
ffffffffc0201a7c:	04700593          	li	a1,71
ffffffffc0201a80:	00004517          	auipc	a0,0x4
ffffffffc0201a84:	73050513          	addi	a0,a0,1840 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201a88:	a07fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a8c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a8c:	c94d                	beqz	a0,ffffffffc0201b3e <slob_free+0xb2>
{
ffffffffc0201a8e:	1141                	addi	sp,sp,-16
ffffffffc0201a90:	e022                	sd	s0,0(sp)
ffffffffc0201a92:	e406                	sd	ra,8(sp)
ffffffffc0201a94:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a96:	e9c1                	bnez	a1,ffffffffc0201b26 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a98:	100027f3          	csrr	a5,sstatus
ffffffffc0201a9c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a9e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aa0:	ebd9                	bnez	a5,ffffffffc0201b36 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aa2:	000a5617          	auipc	a2,0xa5
ffffffffc0201aa6:	8f660613          	addi	a2,a2,-1802 # ffffffffc02a6398 <slobfree>
ffffffffc0201aaa:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aac:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aae:	679c                	ld	a5,8(a5)
ffffffffc0201ab0:	02877a63          	bgeu	a4,s0,ffffffffc0201ae4 <slob_free+0x58>
ffffffffc0201ab4:	00f46463          	bltu	s0,a5,ffffffffc0201abc <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ab8:	fef76ae3          	bltu	a4,a5,ffffffffc0201aac <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201abc:	400c                	lw	a1,0(s0)
ffffffffc0201abe:	00459693          	slli	a3,a1,0x4
ffffffffc0201ac2:	96a2                	add	a3,a3,s0
ffffffffc0201ac4:	02d78a63          	beq	a5,a3,ffffffffc0201af8 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ac8:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201aca:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201acc:	00469793          	slli	a5,a3,0x4
ffffffffc0201ad0:	97ba                	add	a5,a5,a4
ffffffffc0201ad2:	02f40e63          	beq	s0,a5,ffffffffc0201b0e <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201ad6:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201ad8:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ada:	e129                	bnez	a0,ffffffffc0201b1c <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201adc:	60a2                	ld	ra,8(sp)
ffffffffc0201ade:	6402                	ld	s0,0(sp)
ffffffffc0201ae0:	0141                	addi	sp,sp,16
ffffffffc0201ae2:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ae4:	fcf764e3          	bltu	a4,a5,ffffffffc0201aac <slob_free+0x20>
ffffffffc0201ae8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201aac <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201aec:	400c                	lw	a1,0(s0)
ffffffffc0201aee:	00459693          	slli	a3,a1,0x4
ffffffffc0201af2:	96a2                	add	a3,a3,s0
ffffffffc0201af4:	fcd79ae3          	bne	a5,a3,ffffffffc0201ac8 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201af8:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201afa:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201afc:	9db5                	addw	a1,a1,a3
ffffffffc0201afe:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201b00:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201b02:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b04:	00469793          	slli	a5,a3,0x4
ffffffffc0201b08:	97ba                	add	a5,a5,a4
ffffffffc0201b0a:	fcf416e3          	bne	s0,a5,ffffffffc0201ad6 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201b0e:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201b10:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201b12:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b14:	9ebd                	addw	a3,a3,a5
ffffffffc0201b16:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b18:	e70c                	sd	a1,8(a4)
ffffffffc0201b1a:	d169                	beqz	a0,ffffffffc0201adc <slob_free+0x50>
}
ffffffffc0201b1c:	6402                	ld	s0,0(sp)
ffffffffc0201b1e:	60a2                	ld	ra,8(sp)
ffffffffc0201b20:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b22:	e8dfe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b26:	25bd                	addiw	a1,a1,15
ffffffffc0201b28:	8191                	srli	a1,a1,0x4
ffffffffc0201b2a:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b2c:	100027f3          	csrr	a5,sstatus
ffffffffc0201b30:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b32:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b34:	d7bd                	beqz	a5,ffffffffc0201aa2 <slob_free+0x16>
        intr_disable();
ffffffffc0201b36:	e7ffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b3a:	4505                	li	a0,1
ffffffffc0201b3c:	b79d                	j	ffffffffc0201aa2 <slob_free+0x16>
ffffffffc0201b3e:	8082                	ret

ffffffffc0201b40 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b40:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b42:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b44:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b48:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b4a:	352000ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
	if (!page)
ffffffffc0201b4e:	c91d                	beqz	a0,ffffffffc0201b84 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b50:	000a9697          	auipc	a3,0xa9
ffffffffc0201b54:	cd06b683          	ld	a3,-816(a3) # ffffffffc02aa820 <pages>
ffffffffc0201b58:	8d15                	sub	a0,a0,a3
ffffffffc0201b5a:	8519                	srai	a0,a0,0x6
ffffffffc0201b5c:	00006697          	auipc	a3,0x6
ffffffffc0201b60:	d0c6b683          	ld	a3,-756(a3) # ffffffffc0207868 <nbase>
ffffffffc0201b64:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201b66:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b6a:	83b1                	srli	a5,a5,0xc
ffffffffc0201b6c:	000a9717          	auipc	a4,0xa9
ffffffffc0201b70:	cac73703          	ld	a4,-852(a4) # ffffffffc02aa818 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b74:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b76:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b8a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b7a:	000a9697          	auipc	a3,0xa9
ffffffffc0201b7e:	cb66b683          	ld	a3,-842(a3) # ffffffffc02aa830 <va_pa_offset>
ffffffffc0201b82:	9536                	add	a0,a0,a3
}
ffffffffc0201b84:	60a2                	ld	ra,8(sp)
ffffffffc0201b86:	0141                	addi	sp,sp,16
ffffffffc0201b88:	8082                	ret
ffffffffc0201b8a:	86aa                	mv	a3,a0
ffffffffc0201b8c:	00005617          	auipc	a2,0x5
ffffffffc0201b90:	9f460613          	addi	a2,a2,-1548 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0201b94:	07100593          	li	a1,113
ffffffffc0201b98:	00005517          	auipc	a0,0x5
ffffffffc0201b9c:	a1050513          	addi	a0,a0,-1520 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201ba0:	8effe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ba4 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201ba4:	1101                	addi	sp,sp,-32
ffffffffc0201ba6:	ec06                	sd	ra,24(sp)
ffffffffc0201ba8:	e822                	sd	s0,16(sp)
ffffffffc0201baa:	e426                	sd	s1,8(sp)
ffffffffc0201bac:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bae:	01050713          	addi	a4,a0,16
ffffffffc0201bb2:	6785                	lui	a5,0x1
ffffffffc0201bb4:	0cf77363          	bgeu	a4,a5,ffffffffc0201c7a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201bb8:	00f50493          	addi	s1,a0,15
ffffffffc0201bbc:	8091                	srli	s1,s1,0x4
ffffffffc0201bbe:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bc0:	10002673          	csrr	a2,sstatus
ffffffffc0201bc4:	8a09                	andi	a2,a2,2
ffffffffc0201bc6:	e25d                	bnez	a2,ffffffffc0201c6c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201bc8:	000a4917          	auipc	s2,0xa4
ffffffffc0201bcc:	7d090913          	addi	s2,s2,2000 # ffffffffc02a6398 <slobfree>
ffffffffc0201bd0:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bd4:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201bd6:	4398                	lw	a4,0(a5)
ffffffffc0201bd8:	08975e63          	bge	a4,s1,ffffffffc0201c74 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201bdc:	00f68b63          	beq	a3,a5,ffffffffc0201bf2 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201be0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201be2:	4018                	lw	a4,0(s0)
ffffffffc0201be4:	02975a63          	bge	a4,s1,ffffffffc0201c18 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201be8:	00093683          	ld	a3,0(s2)
ffffffffc0201bec:	87a2                	mv	a5,s0
ffffffffc0201bee:	fef699e3          	bne	a3,a5,ffffffffc0201be0 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201bf2:	ee31                	bnez	a2,ffffffffc0201c4e <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201bf4:	4501                	li	a0,0
ffffffffc0201bf6:	f4bff0ef          	jal	ra,ffffffffc0201b40 <__slob_get_free_pages.constprop.0>
ffffffffc0201bfa:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201bfc:	cd05                	beqz	a0,ffffffffc0201c34 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201bfe:	6585                	lui	a1,0x1
ffffffffc0201c00:	e8dff0ef          	jal	ra,ffffffffc0201a8c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c04:	10002673          	csrr	a2,sstatus
ffffffffc0201c08:	8a09                	andi	a2,a2,2
ffffffffc0201c0a:	ee05                	bnez	a2,ffffffffc0201c42 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c0c:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c10:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c12:	4018                	lw	a4,0(s0)
ffffffffc0201c14:	fc974ae3          	blt	a4,s1,ffffffffc0201be8 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c18:	04e48763          	beq	s1,a4,ffffffffc0201c66 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c1c:	00449693          	slli	a3,s1,0x4
ffffffffc0201c20:	96a2                	add	a3,a3,s0
ffffffffc0201c22:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c24:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c26:	9f05                	subw	a4,a4,s1
ffffffffc0201c28:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c2a:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c2c:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c2e:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c32:	e20d                	bnez	a2,ffffffffc0201c54 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c34:	60e2                	ld	ra,24(sp)
ffffffffc0201c36:	8522                	mv	a0,s0
ffffffffc0201c38:	6442                	ld	s0,16(sp)
ffffffffc0201c3a:	64a2                	ld	s1,8(sp)
ffffffffc0201c3c:	6902                	ld	s2,0(sp)
ffffffffc0201c3e:	6105                	addi	sp,sp,32
ffffffffc0201c40:	8082                	ret
        intr_disable();
ffffffffc0201c42:	d73fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c46:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c4a:	4605                	li	a2,1
ffffffffc0201c4c:	b7d1                	j	ffffffffc0201c10 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c4e:	d61fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c52:	b74d                	j	ffffffffc0201bf4 <slob_alloc.constprop.0+0x50>
ffffffffc0201c54:	d5bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201c58:	60e2                	ld	ra,24(sp)
ffffffffc0201c5a:	8522                	mv	a0,s0
ffffffffc0201c5c:	6442                	ld	s0,16(sp)
ffffffffc0201c5e:	64a2                	ld	s1,8(sp)
ffffffffc0201c60:	6902                	ld	s2,0(sp)
ffffffffc0201c62:	6105                	addi	sp,sp,32
ffffffffc0201c64:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c66:	6418                	ld	a4,8(s0)
ffffffffc0201c68:	e798                	sd	a4,8(a5)
ffffffffc0201c6a:	b7d1                	j	ffffffffc0201c2e <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c6c:	d49fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201c70:	4605                	li	a2,1
ffffffffc0201c72:	bf99                	j	ffffffffc0201bc8 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201c74:	843e                	mv	s0,a5
ffffffffc0201c76:	87b6                	mv	a5,a3
ffffffffc0201c78:	b745                	j	ffffffffc0201c18 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c7a:	00005697          	auipc	a3,0x5
ffffffffc0201c7e:	93e68693          	addi	a3,a3,-1730 # ffffffffc02065b8 <default_pmm_manager+0x70>
ffffffffc0201c82:	00004617          	auipc	a2,0x4
ffffffffc0201c86:	51660613          	addi	a2,a2,1302 # ffffffffc0206198 <commands+0x828>
ffffffffc0201c8a:	06300593          	li	a1,99
ffffffffc0201c8e:	00005517          	auipc	a0,0x5
ffffffffc0201c92:	94a50513          	addi	a0,a0,-1718 # ffffffffc02065d8 <default_pmm_manager+0x90>
ffffffffc0201c96:	ff8fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c9a <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201c9a:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201c9c:	00005517          	auipc	a0,0x5
ffffffffc0201ca0:	95450513          	addi	a0,a0,-1708 # ffffffffc02065f0 <default_pmm_manager+0xa8>
{
ffffffffc0201ca4:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201ca6:	ceefe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201caa:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cac:	00005517          	auipc	a0,0x5
ffffffffc0201cb0:	95c50513          	addi	a0,a0,-1700 # ffffffffc0206608 <default_pmm_manager+0xc0>
}
ffffffffc0201cb4:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cb6:	cdefe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201cba <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201cba:	4501                	li	a0,0
ffffffffc0201cbc:	8082                	ret

ffffffffc0201cbe <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201cbe:	1101                	addi	sp,sp,-32
ffffffffc0201cc0:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cc2:	6905                	lui	s2,0x1
{
ffffffffc0201cc4:	e822                	sd	s0,16(sp)
ffffffffc0201cc6:	ec06                	sd	ra,24(sp)
ffffffffc0201cc8:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cca:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc9>
{
ffffffffc0201cce:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cd0:	04a7f963          	bgeu	a5,a0,ffffffffc0201d22 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201cd4:	4561                	li	a0,24
ffffffffc0201cd6:	ecfff0ef          	jal	ra,ffffffffc0201ba4 <slob_alloc.constprop.0>
ffffffffc0201cda:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201cdc:	c929                	beqz	a0,ffffffffc0201d2e <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201cde:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201ce2:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201ce4:	00f95763          	bge	s2,a5,ffffffffc0201cf2 <kmalloc+0x34>
ffffffffc0201ce8:	6705                	lui	a4,0x1
ffffffffc0201cea:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201cec:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cee:	fef74ee3          	blt	a4,a5,ffffffffc0201cea <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201cf2:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201cf4:	e4dff0ef          	jal	ra,ffffffffc0201b40 <__slob_get_free_pages.constprop.0>
ffffffffc0201cf8:	e488                	sd	a0,8(s1)
ffffffffc0201cfa:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201cfc:	c525                	beqz	a0,ffffffffc0201d64 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cfe:	100027f3          	csrr	a5,sstatus
ffffffffc0201d02:	8b89                	andi	a5,a5,2
ffffffffc0201d04:	ef8d                	bnez	a5,ffffffffc0201d3e <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d06:	000a9797          	auipc	a5,0xa9
ffffffffc0201d0a:	afa78793          	addi	a5,a5,-1286 # ffffffffc02aa800 <bigblocks>
ffffffffc0201d0e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d10:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d12:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d14:	60e2                	ld	ra,24(sp)
ffffffffc0201d16:	8522                	mv	a0,s0
ffffffffc0201d18:	6442                	ld	s0,16(sp)
ffffffffc0201d1a:	64a2                	ld	s1,8(sp)
ffffffffc0201d1c:	6902                	ld	s2,0(sp)
ffffffffc0201d1e:	6105                	addi	sp,sp,32
ffffffffc0201d20:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d22:	0541                	addi	a0,a0,16
ffffffffc0201d24:	e81ff0ef          	jal	ra,ffffffffc0201ba4 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d28:	01050413          	addi	s0,a0,16
ffffffffc0201d2c:	f565                	bnez	a0,ffffffffc0201d14 <kmalloc+0x56>
ffffffffc0201d2e:	4401                	li	s0,0
}
ffffffffc0201d30:	60e2                	ld	ra,24(sp)
ffffffffc0201d32:	8522                	mv	a0,s0
ffffffffc0201d34:	6442                	ld	s0,16(sp)
ffffffffc0201d36:	64a2                	ld	s1,8(sp)
ffffffffc0201d38:	6902                	ld	s2,0(sp)
ffffffffc0201d3a:	6105                	addi	sp,sp,32
ffffffffc0201d3c:	8082                	ret
        intr_disable();
ffffffffc0201d3e:	c77fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d42:	000a9797          	auipc	a5,0xa9
ffffffffc0201d46:	abe78793          	addi	a5,a5,-1346 # ffffffffc02aa800 <bigblocks>
ffffffffc0201d4a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d4c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d4e:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d50:	c5ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d54:	6480                	ld	s0,8(s1)
}
ffffffffc0201d56:	60e2                	ld	ra,24(sp)
ffffffffc0201d58:	64a2                	ld	s1,8(sp)
ffffffffc0201d5a:	8522                	mv	a0,s0
ffffffffc0201d5c:	6442                	ld	s0,16(sp)
ffffffffc0201d5e:	6902                	ld	s2,0(sp)
ffffffffc0201d60:	6105                	addi	sp,sp,32
ffffffffc0201d62:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d64:	45e1                	li	a1,24
ffffffffc0201d66:	8526                	mv	a0,s1
ffffffffc0201d68:	d25ff0ef          	jal	ra,ffffffffc0201a8c <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201d6c:	b765                	j	ffffffffc0201d14 <kmalloc+0x56>

ffffffffc0201d6e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d6e:	c169                	beqz	a0,ffffffffc0201e30 <kfree+0xc2>
{
ffffffffc0201d70:	1101                	addi	sp,sp,-32
ffffffffc0201d72:	e822                	sd	s0,16(sp)
ffffffffc0201d74:	ec06                	sd	ra,24(sp)
ffffffffc0201d76:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d78:	03451793          	slli	a5,a0,0x34
ffffffffc0201d7c:	842a                	mv	s0,a0
ffffffffc0201d7e:	e3d9                	bnez	a5,ffffffffc0201e04 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d80:	100027f3          	csrr	a5,sstatus
ffffffffc0201d84:	8b89                	andi	a5,a5,2
ffffffffc0201d86:	e7d9                	bnez	a5,ffffffffc0201e14 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d88:	000a9797          	auipc	a5,0xa9
ffffffffc0201d8c:	a787b783          	ld	a5,-1416(a5) # ffffffffc02aa800 <bigblocks>
    return 0;
ffffffffc0201d90:	4601                	li	a2,0
ffffffffc0201d92:	cbad                	beqz	a5,ffffffffc0201e04 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201d94:	000a9697          	auipc	a3,0xa9
ffffffffc0201d98:	a6c68693          	addi	a3,a3,-1428 # ffffffffc02aa800 <bigblocks>
ffffffffc0201d9c:	a021                	j	ffffffffc0201da4 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d9e:	01048693          	addi	a3,s1,16
ffffffffc0201da2:	c3a5                	beqz	a5,ffffffffc0201e02 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201da4:	6798                	ld	a4,8(a5)
ffffffffc0201da6:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201da8:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201daa:	fe871ae3          	bne	a4,s0,ffffffffc0201d9e <kfree+0x30>
				*last = bb->next;
ffffffffc0201dae:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201db0:	ee2d                	bnez	a2,ffffffffc0201e2a <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201db2:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201db6:	4098                	lw	a4,0(s1)
ffffffffc0201db8:	08f46963          	bltu	s0,a5,ffffffffc0201e4a <kfree+0xdc>
ffffffffc0201dbc:	000a9697          	auipc	a3,0xa9
ffffffffc0201dc0:	a746b683          	ld	a3,-1420(a3) # ffffffffc02aa830 <va_pa_offset>
ffffffffc0201dc4:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201dc6:	8031                	srli	s0,s0,0xc
ffffffffc0201dc8:	000a9797          	auipc	a5,0xa9
ffffffffc0201dcc:	a507b783          	ld	a5,-1456(a5) # ffffffffc02aa818 <npage>
ffffffffc0201dd0:	06f47163          	bgeu	s0,a5,ffffffffc0201e32 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dd4:	00006517          	auipc	a0,0x6
ffffffffc0201dd8:	a9453503          	ld	a0,-1388(a0) # ffffffffc0207868 <nbase>
ffffffffc0201ddc:	8c09                	sub	s0,s0,a0
ffffffffc0201dde:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201de0:	000a9517          	auipc	a0,0xa9
ffffffffc0201de4:	a4053503          	ld	a0,-1472(a0) # ffffffffc02aa820 <pages>
ffffffffc0201de8:	4585                	li	a1,1
ffffffffc0201dea:	9522                	add	a0,a0,s0
ffffffffc0201dec:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201df0:	0ea000ef          	jal	ra,ffffffffc0201eda <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201df4:	6442                	ld	s0,16(sp)
ffffffffc0201df6:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201df8:	8526                	mv	a0,s1
}
ffffffffc0201dfa:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dfc:	45e1                	li	a1,24
}
ffffffffc0201dfe:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e00:	b171                	j	ffffffffc0201a8c <slob_free>
ffffffffc0201e02:	e20d                	bnez	a2,ffffffffc0201e24 <kfree+0xb6>
ffffffffc0201e04:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e08:	6442                	ld	s0,16(sp)
ffffffffc0201e0a:	60e2                	ld	ra,24(sp)
ffffffffc0201e0c:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e0e:	4581                	li	a1,0
}
ffffffffc0201e10:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e12:	b9ad                	j	ffffffffc0201a8c <slob_free>
        intr_disable();
ffffffffc0201e14:	ba1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e18:	000a9797          	auipc	a5,0xa9
ffffffffc0201e1c:	9e87b783          	ld	a5,-1560(a5) # ffffffffc02aa800 <bigblocks>
        return 1;
ffffffffc0201e20:	4605                	li	a2,1
ffffffffc0201e22:	fbad                	bnez	a5,ffffffffc0201d94 <kfree+0x26>
        intr_enable();
ffffffffc0201e24:	b8bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e28:	bff1                	j	ffffffffc0201e04 <kfree+0x96>
ffffffffc0201e2a:	b85fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e2e:	b751                	j	ffffffffc0201db2 <kfree+0x44>
ffffffffc0201e30:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e32:	00005617          	auipc	a2,0x5
ffffffffc0201e36:	81e60613          	addi	a2,a2,-2018 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0201e3a:	06900593          	li	a1,105
ffffffffc0201e3e:	00004517          	auipc	a0,0x4
ffffffffc0201e42:	76a50513          	addi	a0,a0,1898 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201e46:	e48fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e4a:	86a2                	mv	a3,s0
ffffffffc0201e4c:	00004617          	auipc	a2,0x4
ffffffffc0201e50:	7dc60613          	addi	a2,a2,2012 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0201e54:	07700593          	li	a1,119
ffffffffc0201e58:	00004517          	auipc	a0,0x4
ffffffffc0201e5c:	75050513          	addi	a0,a0,1872 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201e60:	e2efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e64 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e64:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e66:	00004617          	auipc	a2,0x4
ffffffffc0201e6a:	7ea60613          	addi	a2,a2,2026 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0201e6e:	06900593          	li	a1,105
ffffffffc0201e72:	00004517          	auipc	a0,0x4
ffffffffc0201e76:	73650513          	addi	a0,a0,1846 # ffffffffc02065a8 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201e7a:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201e7c:	e12fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e80 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201e80:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201e82:	00004617          	auipc	a2,0x4
ffffffffc0201e86:	7ee60613          	addi	a2,a2,2030 # ffffffffc0206670 <default_pmm_manager+0x128>
ffffffffc0201e8a:	07f00593          	li	a1,127
ffffffffc0201e8e:	00004517          	auipc	a0,0x4
ffffffffc0201e92:	71a50513          	addi	a0,a0,1818 # ffffffffc02065a8 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201e96:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201e98:	df6fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e9c <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201ea0:	8b89                	andi	a5,a5,2
ffffffffc0201ea2:	e799                	bnez	a5,ffffffffc0201eb0 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ea4:	000a9797          	auipc	a5,0xa9
ffffffffc0201ea8:	9847b783          	ld	a5,-1660(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201eac:	6f9c                	ld	a5,24(a5)
ffffffffc0201eae:	8782                	jr	a5
{
ffffffffc0201eb0:	1141                	addi	sp,sp,-16
ffffffffc0201eb2:	e406                	sd	ra,8(sp)
ffffffffc0201eb4:	e022                	sd	s0,0(sp)
ffffffffc0201eb6:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201eb8:	afdfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ebc:	000a9797          	auipc	a5,0xa9
ffffffffc0201ec0:	96c7b783          	ld	a5,-1684(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201ec4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ec6:	8522                	mv	a0,s0
ffffffffc0201ec8:	9782                	jalr	a5
ffffffffc0201eca:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ecc:	ae3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ed0:	60a2                	ld	ra,8(sp)
ffffffffc0201ed2:	8522                	mv	a0,s0
ffffffffc0201ed4:	6402                	ld	s0,0(sp)
ffffffffc0201ed6:	0141                	addi	sp,sp,16
ffffffffc0201ed8:	8082                	ret

ffffffffc0201eda <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eda:	100027f3          	csrr	a5,sstatus
ffffffffc0201ede:	8b89                	andi	a5,a5,2
ffffffffc0201ee0:	e799                	bnez	a5,ffffffffc0201eee <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201ee2:	000a9797          	auipc	a5,0xa9
ffffffffc0201ee6:	9467b783          	ld	a5,-1722(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201eea:	739c                	ld	a5,32(a5)
ffffffffc0201eec:	8782                	jr	a5
{
ffffffffc0201eee:	1101                	addi	sp,sp,-32
ffffffffc0201ef0:	ec06                	sd	ra,24(sp)
ffffffffc0201ef2:	e822                	sd	s0,16(sp)
ffffffffc0201ef4:	e426                	sd	s1,8(sp)
ffffffffc0201ef6:	842a                	mv	s0,a0
ffffffffc0201ef8:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201efa:	abbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201efe:	000a9797          	auipc	a5,0xa9
ffffffffc0201f02:	92a7b783          	ld	a5,-1750(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201f06:	739c                	ld	a5,32(a5)
ffffffffc0201f08:	85a6                	mv	a1,s1
ffffffffc0201f0a:	8522                	mv	a0,s0
ffffffffc0201f0c:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f0e:	6442                	ld	s0,16(sp)
ffffffffc0201f10:	60e2                	ld	ra,24(sp)
ffffffffc0201f12:	64a2                	ld	s1,8(sp)
ffffffffc0201f14:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f16:	a99fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f1a <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f1a:	100027f3          	csrr	a5,sstatus
ffffffffc0201f1e:	8b89                	andi	a5,a5,2
ffffffffc0201f20:	e799                	bnez	a5,ffffffffc0201f2e <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f22:	000a9797          	auipc	a5,0xa9
ffffffffc0201f26:	9067b783          	ld	a5,-1786(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201f2a:	779c                	ld	a5,40(a5)
ffffffffc0201f2c:	8782                	jr	a5
{
ffffffffc0201f2e:	1141                	addi	sp,sp,-16
ffffffffc0201f30:	e406                	sd	ra,8(sp)
ffffffffc0201f32:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f34:	a81fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f38:	000a9797          	auipc	a5,0xa9
ffffffffc0201f3c:	8f07b783          	ld	a5,-1808(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201f40:	779c                	ld	a5,40(a5)
ffffffffc0201f42:	9782                	jalr	a5
ffffffffc0201f44:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f46:	a69fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f4a:	60a2                	ld	ra,8(sp)
ffffffffc0201f4c:	8522                	mv	a0,s0
ffffffffc0201f4e:	6402                	ld	s0,0(sp)
ffffffffc0201f50:	0141                	addi	sp,sp,16
ffffffffc0201f52:	8082                	ret

ffffffffc0201f54 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f54:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f58:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201f5c:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f5e:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f60:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f62:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f66:	6094                	ld	a3,0(s1)
{
ffffffffc0201f68:	f04a                	sd	s2,32(sp)
ffffffffc0201f6a:	ec4e                	sd	s3,24(sp)
ffffffffc0201f6c:	e852                	sd	s4,16(sp)
ffffffffc0201f6e:	fc06                	sd	ra,56(sp)
ffffffffc0201f70:	f822                	sd	s0,48(sp)
ffffffffc0201f72:	e456                	sd	s5,8(sp)
ffffffffc0201f74:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f76:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f7a:	892e                	mv	s2,a1
ffffffffc0201f7c:	8a32                	mv	s4,a2
ffffffffc0201f7e:	000a9997          	auipc	s3,0xa9
ffffffffc0201f82:	89a98993          	addi	s3,s3,-1894 # ffffffffc02aa818 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f86:	efbd                	bnez	a5,ffffffffc0202004 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f88:	14060c63          	beqz	a2,ffffffffc02020e0 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f8c:	100027f3          	csrr	a5,sstatus
ffffffffc0201f90:	8b89                	andi	a5,a5,2
ffffffffc0201f92:	14079963          	bnez	a5,ffffffffc02020e4 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f96:	000a9797          	auipc	a5,0xa9
ffffffffc0201f9a:	8927b783          	ld	a5,-1902(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0201f9e:	6f9c                	ld	a5,24(a5)
ffffffffc0201fa0:	4505                	li	a0,1
ffffffffc0201fa2:	9782                	jalr	a5
ffffffffc0201fa4:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fa6:	12040d63          	beqz	s0,ffffffffc02020e0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201faa:	000a9b17          	auipc	s6,0xa9
ffffffffc0201fae:	876b0b13          	addi	s6,s6,-1930 # ffffffffc02aa820 <pages>
ffffffffc0201fb2:	000b3503          	ld	a0,0(s6)
ffffffffc0201fb6:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fba:	000a9997          	auipc	s3,0xa9
ffffffffc0201fbe:	85e98993          	addi	s3,s3,-1954 # ffffffffc02aa818 <npage>
ffffffffc0201fc2:	40a40533          	sub	a0,s0,a0
ffffffffc0201fc6:	8519                	srai	a0,a0,0x6
ffffffffc0201fc8:	9556                	add	a0,a0,s5
ffffffffc0201fca:	0009b703          	ld	a4,0(s3)
ffffffffc0201fce:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fd2:	4685                	li	a3,1
ffffffffc0201fd4:	c014                	sw	a3,0(s0)
ffffffffc0201fd6:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fd8:	0532                	slli	a0,a0,0xc
ffffffffc0201fda:	16e7f763          	bgeu	a5,a4,ffffffffc0202148 <get_pte+0x1f4>
ffffffffc0201fde:	000a9797          	auipc	a5,0xa9
ffffffffc0201fe2:	8527b783          	ld	a5,-1966(a5) # ffffffffc02aa830 <va_pa_offset>
ffffffffc0201fe6:	6605                	lui	a2,0x1
ffffffffc0201fe8:	4581                	li	a1,0
ffffffffc0201fea:	953e                	add	a0,a0,a5
ffffffffc0201fec:	6ec030ef          	jal	ra,ffffffffc02056d8 <memset>
    return page - pages + nbase;
ffffffffc0201ff0:	000b3683          	ld	a3,0(s6)
ffffffffc0201ff4:	40d406b3          	sub	a3,s0,a3
ffffffffc0201ff8:	8699                	srai	a3,a3,0x6
ffffffffc0201ffa:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201ffc:	06aa                	slli	a3,a3,0xa
ffffffffc0201ffe:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202002:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202004:	77fd                	lui	a5,0xfffff
ffffffffc0202006:	068a                	slli	a3,a3,0x2
ffffffffc0202008:	0009b703          	ld	a4,0(s3)
ffffffffc020200c:	8efd                	and	a3,a3,a5
ffffffffc020200e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202012:	10e7ff63          	bgeu	a5,a4,ffffffffc0202130 <get_pte+0x1dc>
ffffffffc0202016:	000a9a97          	auipc	s5,0xa9
ffffffffc020201a:	81aa8a93          	addi	s5,s5,-2022 # ffffffffc02aa830 <va_pa_offset>
ffffffffc020201e:	000ab403          	ld	s0,0(s5)
ffffffffc0202022:	01595793          	srli	a5,s2,0x15
ffffffffc0202026:	1ff7f793          	andi	a5,a5,511
ffffffffc020202a:	96a2                	add	a3,a3,s0
ffffffffc020202c:	00379413          	slli	s0,a5,0x3
ffffffffc0202030:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202032:	6014                	ld	a3,0(s0)
ffffffffc0202034:	0016f793          	andi	a5,a3,1
ffffffffc0202038:	ebad                	bnez	a5,ffffffffc02020aa <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020203a:	0a0a0363          	beqz	s4,ffffffffc02020e0 <get_pte+0x18c>
ffffffffc020203e:	100027f3          	csrr	a5,sstatus
ffffffffc0202042:	8b89                	andi	a5,a5,2
ffffffffc0202044:	efcd                	bnez	a5,ffffffffc02020fe <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202046:	000a8797          	auipc	a5,0xa8
ffffffffc020204a:	7e27b783          	ld	a5,2018(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc020204e:	6f9c                	ld	a5,24(a5)
ffffffffc0202050:	4505                	li	a0,1
ffffffffc0202052:	9782                	jalr	a5
ffffffffc0202054:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202056:	c4c9                	beqz	s1,ffffffffc02020e0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202058:	000a8b17          	auipc	s6,0xa8
ffffffffc020205c:	7c8b0b13          	addi	s6,s6,1992 # ffffffffc02aa820 <pages>
ffffffffc0202060:	000b3503          	ld	a0,0(s6)
ffffffffc0202064:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202068:	0009b703          	ld	a4,0(s3)
ffffffffc020206c:	40a48533          	sub	a0,s1,a0
ffffffffc0202070:	8519                	srai	a0,a0,0x6
ffffffffc0202072:	9552                	add	a0,a0,s4
ffffffffc0202074:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202078:	4685                	li	a3,1
ffffffffc020207a:	c094                	sw	a3,0(s1)
ffffffffc020207c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020207e:	0532                	slli	a0,a0,0xc
ffffffffc0202080:	0ee7f163          	bgeu	a5,a4,ffffffffc0202162 <get_pte+0x20e>
ffffffffc0202084:	000ab783          	ld	a5,0(s5)
ffffffffc0202088:	6605                	lui	a2,0x1
ffffffffc020208a:	4581                	li	a1,0
ffffffffc020208c:	953e                	add	a0,a0,a5
ffffffffc020208e:	64a030ef          	jal	ra,ffffffffc02056d8 <memset>
    return page - pages + nbase;
ffffffffc0202092:	000b3683          	ld	a3,0(s6)
ffffffffc0202096:	40d486b3          	sub	a3,s1,a3
ffffffffc020209a:	8699                	srai	a3,a3,0x6
ffffffffc020209c:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020209e:	06aa                	slli	a3,a3,0xa
ffffffffc02020a0:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020a4:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020a6:	0009b703          	ld	a4,0(s3)
ffffffffc02020aa:	068a                	slli	a3,a3,0x2
ffffffffc02020ac:	757d                	lui	a0,0xfffff
ffffffffc02020ae:	8ee9                	and	a3,a3,a0
ffffffffc02020b0:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020b4:	06e7f263          	bgeu	a5,a4,ffffffffc0202118 <get_pte+0x1c4>
ffffffffc02020b8:	000ab503          	ld	a0,0(s5)
ffffffffc02020bc:	00c95913          	srli	s2,s2,0xc
ffffffffc02020c0:	1ff97913          	andi	s2,s2,511
ffffffffc02020c4:	96aa                	add	a3,a3,a0
ffffffffc02020c6:	00391513          	slli	a0,s2,0x3
ffffffffc02020ca:	9536                	add	a0,a0,a3
}
ffffffffc02020cc:	70e2                	ld	ra,56(sp)
ffffffffc02020ce:	7442                	ld	s0,48(sp)
ffffffffc02020d0:	74a2                	ld	s1,40(sp)
ffffffffc02020d2:	7902                	ld	s2,32(sp)
ffffffffc02020d4:	69e2                	ld	s3,24(sp)
ffffffffc02020d6:	6a42                	ld	s4,16(sp)
ffffffffc02020d8:	6aa2                	ld	s5,8(sp)
ffffffffc02020da:	6b02                	ld	s6,0(sp)
ffffffffc02020dc:	6121                	addi	sp,sp,64
ffffffffc02020de:	8082                	ret
            return NULL;
ffffffffc02020e0:	4501                	li	a0,0
ffffffffc02020e2:	b7ed                	j	ffffffffc02020cc <get_pte+0x178>
        intr_disable();
ffffffffc02020e4:	8d1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020e8:	000a8797          	auipc	a5,0xa8
ffffffffc02020ec:	7407b783          	ld	a5,1856(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc02020f0:	6f9c                	ld	a5,24(a5)
ffffffffc02020f2:	4505                	li	a0,1
ffffffffc02020f4:	9782                	jalr	a5
ffffffffc02020f6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02020f8:	8b7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02020fc:	b56d                	j	ffffffffc0201fa6 <get_pte+0x52>
        intr_disable();
ffffffffc02020fe:	8b7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202102:	000a8797          	auipc	a5,0xa8
ffffffffc0202106:	7267b783          	ld	a5,1830(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc020210a:	6f9c                	ld	a5,24(a5)
ffffffffc020210c:	4505                	li	a0,1
ffffffffc020210e:	9782                	jalr	a5
ffffffffc0202110:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0202112:	89dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202116:	b781                	j	ffffffffc0202056 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202118:	00004617          	auipc	a2,0x4
ffffffffc020211c:	46860613          	addi	a2,a2,1128 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202120:	0fa00593          	li	a1,250
ffffffffc0202124:	00004517          	auipc	a0,0x4
ffffffffc0202128:	57450513          	addi	a0,a0,1396 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020212c:	b62fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202130:	00004617          	auipc	a2,0x4
ffffffffc0202134:	45060613          	addi	a2,a2,1104 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202138:	0ed00593          	li	a1,237
ffffffffc020213c:	00004517          	auipc	a0,0x4
ffffffffc0202140:	55c50513          	addi	a0,a0,1372 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202144:	b4afe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202148:	86aa                	mv	a3,a0
ffffffffc020214a:	00004617          	auipc	a2,0x4
ffffffffc020214e:	43660613          	addi	a2,a2,1078 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202152:	0e900593          	li	a1,233
ffffffffc0202156:	00004517          	auipc	a0,0x4
ffffffffc020215a:	54250513          	addi	a0,a0,1346 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020215e:	b30fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202162:	86aa                	mv	a3,a0
ffffffffc0202164:	00004617          	auipc	a2,0x4
ffffffffc0202168:	41c60613          	addi	a2,a2,1052 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020216c:	0f700593          	li	a1,247
ffffffffc0202170:	00004517          	auipc	a0,0x4
ffffffffc0202174:	52850513          	addi	a0,a0,1320 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202178:	b16fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020217c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020217c:	1141                	addi	sp,sp,-16
ffffffffc020217e:	e022                	sd	s0,0(sp)
ffffffffc0202180:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202182:	4601                	li	a2,0
{
ffffffffc0202184:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202186:	dcfff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
    if (ptep_store != NULL)
ffffffffc020218a:	c011                	beqz	s0,ffffffffc020218e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020218c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020218e:	c511                	beqz	a0,ffffffffc020219a <get_page+0x1e>
ffffffffc0202190:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202192:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202194:	0017f713          	andi	a4,a5,1
ffffffffc0202198:	e709                	bnez	a4,ffffffffc02021a2 <get_page+0x26>
}
ffffffffc020219a:	60a2                	ld	ra,8(sp)
ffffffffc020219c:	6402                	ld	s0,0(sp)
ffffffffc020219e:	0141                	addi	sp,sp,16
ffffffffc02021a0:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02021a2:	078a                	slli	a5,a5,0x2
ffffffffc02021a4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021a6:	000a8717          	auipc	a4,0xa8
ffffffffc02021aa:	67273703          	ld	a4,1650(a4) # ffffffffc02aa818 <npage>
ffffffffc02021ae:	00e7ff63          	bgeu	a5,a4,ffffffffc02021cc <get_page+0x50>
ffffffffc02021b2:	60a2                	ld	ra,8(sp)
ffffffffc02021b4:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021b6:	fff80537          	lui	a0,0xfff80
ffffffffc02021ba:	97aa                	add	a5,a5,a0
ffffffffc02021bc:	079a                	slli	a5,a5,0x6
ffffffffc02021be:	000a8517          	auipc	a0,0xa8
ffffffffc02021c2:	66253503          	ld	a0,1634(a0) # ffffffffc02aa820 <pages>
ffffffffc02021c6:	953e                	add	a0,a0,a5
ffffffffc02021c8:	0141                	addi	sp,sp,16
ffffffffc02021ca:	8082                	ret
ffffffffc02021cc:	c99ff0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>

ffffffffc02021d0 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02021d0:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021d2:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021d6:	f486                	sd	ra,104(sp)
ffffffffc02021d8:	f0a2                	sd	s0,96(sp)
ffffffffc02021da:	eca6                	sd	s1,88(sp)
ffffffffc02021dc:	e8ca                	sd	s2,80(sp)
ffffffffc02021de:	e4ce                	sd	s3,72(sp)
ffffffffc02021e0:	e0d2                	sd	s4,64(sp)
ffffffffc02021e2:	fc56                	sd	s5,56(sp)
ffffffffc02021e4:	f85a                	sd	s6,48(sp)
ffffffffc02021e6:	f45e                	sd	s7,40(sp)
ffffffffc02021e8:	f062                	sd	s8,32(sp)
ffffffffc02021ea:	ec66                	sd	s9,24(sp)
ffffffffc02021ec:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021ee:	17d2                	slli	a5,a5,0x34
ffffffffc02021f0:	e3ed                	bnez	a5,ffffffffc02022d2 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02021f2:	002007b7          	lui	a5,0x200
ffffffffc02021f6:	842e                	mv	s0,a1
ffffffffc02021f8:	0ef5ed63          	bltu	a1,a5,ffffffffc02022f2 <unmap_range+0x122>
ffffffffc02021fc:	8932                	mv	s2,a2
ffffffffc02021fe:	0ec5fa63          	bgeu	a1,a2,ffffffffc02022f2 <unmap_range+0x122>
ffffffffc0202202:	4785                	li	a5,1
ffffffffc0202204:	07fe                	slli	a5,a5,0x1f
ffffffffc0202206:	0ec7e663          	bltu	a5,a2,ffffffffc02022f2 <unmap_range+0x122>
ffffffffc020220a:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc020220c:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020220e:	000a8c97          	auipc	s9,0xa8
ffffffffc0202212:	60ac8c93          	addi	s9,s9,1546 # ffffffffc02aa818 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202216:	000a8c17          	auipc	s8,0xa8
ffffffffc020221a:	60ac0c13          	addi	s8,s8,1546 # ffffffffc02aa820 <pages>
ffffffffc020221e:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc0202222:	000a8d17          	auipc	s10,0xa8
ffffffffc0202226:	606d0d13          	addi	s10,s10,1542 # ffffffffc02aa828 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020222a:	00200b37          	lui	s6,0x200
ffffffffc020222e:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202232:	4601                	li	a2,0
ffffffffc0202234:	85a2                	mv	a1,s0
ffffffffc0202236:	854e                	mv	a0,s3
ffffffffc0202238:	d1dff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc020223c:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020223e:	cd29                	beqz	a0,ffffffffc0202298 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202240:	611c                	ld	a5,0(a0)
ffffffffc0202242:	e395                	bnez	a5,ffffffffc0202266 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202244:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202246:	ff2466e3          	bltu	s0,s2,ffffffffc0202232 <unmap_range+0x62>
}
ffffffffc020224a:	70a6                	ld	ra,104(sp)
ffffffffc020224c:	7406                	ld	s0,96(sp)
ffffffffc020224e:	64e6                	ld	s1,88(sp)
ffffffffc0202250:	6946                	ld	s2,80(sp)
ffffffffc0202252:	69a6                	ld	s3,72(sp)
ffffffffc0202254:	6a06                	ld	s4,64(sp)
ffffffffc0202256:	7ae2                	ld	s5,56(sp)
ffffffffc0202258:	7b42                	ld	s6,48(sp)
ffffffffc020225a:	7ba2                	ld	s7,40(sp)
ffffffffc020225c:	7c02                	ld	s8,32(sp)
ffffffffc020225e:	6ce2                	ld	s9,24(sp)
ffffffffc0202260:	6d42                	ld	s10,16(sp)
ffffffffc0202262:	6165                	addi	sp,sp,112
ffffffffc0202264:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202266:	0017f713          	andi	a4,a5,1
ffffffffc020226a:	df69                	beqz	a4,ffffffffc0202244 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc020226c:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202270:	078a                	slli	a5,a5,0x2
ffffffffc0202272:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202274:	08e7ff63          	bgeu	a5,a4,ffffffffc0202312 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202278:	000c3503          	ld	a0,0(s8)
ffffffffc020227c:	97de                	add	a5,a5,s7
ffffffffc020227e:	079a                	slli	a5,a5,0x6
ffffffffc0202280:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202282:	411c                	lw	a5,0(a0)
ffffffffc0202284:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202288:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020228a:	cf11                	beqz	a4,ffffffffc02022a6 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc020228c:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202290:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202294:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202296:	bf45                	j	ffffffffc0202246 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202298:	945a                	add	s0,s0,s6
ffffffffc020229a:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020229e:	d455                	beqz	s0,ffffffffc020224a <unmap_range+0x7a>
ffffffffc02022a0:	f92469e3          	bltu	s0,s2,ffffffffc0202232 <unmap_range+0x62>
ffffffffc02022a4:	b75d                	j	ffffffffc020224a <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022a6:	100027f3          	csrr	a5,sstatus
ffffffffc02022aa:	8b89                	andi	a5,a5,2
ffffffffc02022ac:	e799                	bnez	a5,ffffffffc02022ba <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02022ae:	000d3783          	ld	a5,0(s10)
ffffffffc02022b2:	4585                	li	a1,1
ffffffffc02022b4:	739c                	ld	a5,32(a5)
ffffffffc02022b6:	9782                	jalr	a5
    if (flag)
ffffffffc02022b8:	bfd1                	j	ffffffffc020228c <unmap_range+0xbc>
ffffffffc02022ba:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02022bc:	ef8fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022c0:	000d3783          	ld	a5,0(s10)
ffffffffc02022c4:	6522                	ld	a0,8(sp)
ffffffffc02022c6:	4585                	li	a1,1
ffffffffc02022c8:	739c                	ld	a5,32(a5)
ffffffffc02022ca:	9782                	jalr	a5
        intr_enable();
ffffffffc02022cc:	ee2fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022d0:	bf75                	j	ffffffffc020228c <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022d2:	00004697          	auipc	a3,0x4
ffffffffc02022d6:	3d668693          	addi	a3,a3,982 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc02022da:	00004617          	auipc	a2,0x4
ffffffffc02022de:	ebe60613          	addi	a2,a2,-322 # ffffffffc0206198 <commands+0x828>
ffffffffc02022e2:	12000593          	li	a1,288
ffffffffc02022e6:	00004517          	auipc	a0,0x4
ffffffffc02022ea:	3b250513          	addi	a0,a0,946 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02022ee:	9a0fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02022f2:	00004697          	auipc	a3,0x4
ffffffffc02022f6:	3e668693          	addi	a3,a3,998 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc02022fa:	00004617          	auipc	a2,0x4
ffffffffc02022fe:	e9e60613          	addi	a2,a2,-354 # ffffffffc0206198 <commands+0x828>
ffffffffc0202302:	12100593          	li	a1,289
ffffffffc0202306:	00004517          	auipc	a0,0x4
ffffffffc020230a:	39250513          	addi	a0,a0,914 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020230e:	980fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202312:	b53ff0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>

ffffffffc0202316 <exit_range>:
{
ffffffffc0202316:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202318:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020231c:	fc86                	sd	ra,120(sp)
ffffffffc020231e:	f8a2                	sd	s0,112(sp)
ffffffffc0202320:	f4a6                	sd	s1,104(sp)
ffffffffc0202322:	f0ca                	sd	s2,96(sp)
ffffffffc0202324:	ecce                	sd	s3,88(sp)
ffffffffc0202326:	e8d2                	sd	s4,80(sp)
ffffffffc0202328:	e4d6                	sd	s5,72(sp)
ffffffffc020232a:	e0da                	sd	s6,64(sp)
ffffffffc020232c:	fc5e                	sd	s7,56(sp)
ffffffffc020232e:	f862                	sd	s8,48(sp)
ffffffffc0202330:	f466                	sd	s9,40(sp)
ffffffffc0202332:	f06a                	sd	s10,32(sp)
ffffffffc0202334:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202336:	17d2                	slli	a5,a5,0x34
ffffffffc0202338:	20079a63          	bnez	a5,ffffffffc020254c <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc020233c:	002007b7          	lui	a5,0x200
ffffffffc0202340:	24f5e463          	bltu	a1,a5,ffffffffc0202588 <exit_range+0x272>
ffffffffc0202344:	8ab2                	mv	s5,a2
ffffffffc0202346:	24c5f163          	bgeu	a1,a2,ffffffffc0202588 <exit_range+0x272>
ffffffffc020234a:	4785                	li	a5,1
ffffffffc020234c:	07fe                	slli	a5,a5,0x1f
ffffffffc020234e:	22c7ed63          	bltu	a5,a2,ffffffffc0202588 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202352:	c00009b7          	lui	s3,0xc0000
ffffffffc0202356:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020235a:	ffe00937          	lui	s2,0xffe00
ffffffffc020235e:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202362:	5cfd                	li	s9,-1
ffffffffc0202364:	8c2a                	mv	s8,a0
ffffffffc0202366:	0125f933          	and	s2,a1,s2
ffffffffc020236a:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc020236c:	000a8d17          	auipc	s10,0xa8
ffffffffc0202370:	4acd0d13          	addi	s10,s10,1196 # ffffffffc02aa818 <npage>
    return KADDR(page2pa(page));
ffffffffc0202374:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202378:	000a8717          	auipc	a4,0xa8
ffffffffc020237c:	4a870713          	addi	a4,a4,1192 # ffffffffc02aa820 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202380:	000a8d97          	auipc	s11,0xa8
ffffffffc0202384:	4a8d8d93          	addi	s11,s11,1192 # ffffffffc02aa828 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202388:	c0000437          	lui	s0,0xc0000
ffffffffc020238c:	944e                	add	s0,s0,s3
ffffffffc020238e:	8079                	srli	s0,s0,0x1e
ffffffffc0202390:	1ff47413          	andi	s0,s0,511
ffffffffc0202394:	040e                	slli	s0,s0,0x3
ffffffffc0202396:	9462                	add	s0,s0,s8
ffffffffc0202398:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
        if (pde1 & PTE_V)
ffffffffc020239c:	001a7793          	andi	a5,s4,1
ffffffffc02023a0:	eb99                	bnez	a5,ffffffffc02023b6 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02023a2:	12098463          	beqz	s3,ffffffffc02024ca <exit_range+0x1b4>
ffffffffc02023a6:	400007b7          	lui	a5,0x40000
ffffffffc02023aa:	97ce                	add	a5,a5,s3
ffffffffc02023ac:	894e                	mv	s2,s3
ffffffffc02023ae:	1159fe63          	bgeu	s3,s5,ffffffffc02024ca <exit_range+0x1b4>
ffffffffc02023b2:	89be                	mv	s3,a5
ffffffffc02023b4:	bfd1                	j	ffffffffc0202388 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023b6:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023ba:	0a0a                	slli	s4,s4,0x2
ffffffffc02023bc:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02023c0:	1cfa7263          	bgeu	s4,a5,ffffffffc0202584 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023c4:	fff80637          	lui	a2,0xfff80
ffffffffc02023c8:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02023ca:	000806b7          	lui	a3,0x80
ffffffffc02023ce:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02023d0:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02023d4:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023d6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023d8:	18f5fa63          	bgeu	a1,a5,ffffffffc020256c <exit_range+0x256>
ffffffffc02023dc:	000a8817          	auipc	a6,0xa8
ffffffffc02023e0:	45480813          	addi	a6,a6,1108 # ffffffffc02aa830 <va_pa_offset>
ffffffffc02023e4:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02023e8:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02023ea:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02023ee:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02023f0:	00080337          	lui	t1,0x80
ffffffffc02023f4:	6885                	lui	a7,0x1
ffffffffc02023f6:	a819                	j	ffffffffc020240c <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02023f8:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02023fa:	002007b7          	lui	a5,0x200
ffffffffc02023fe:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202400:	08090c63          	beqz	s2,ffffffffc0202498 <exit_range+0x182>
ffffffffc0202404:	09397a63          	bgeu	s2,s3,ffffffffc0202498 <exit_range+0x182>
ffffffffc0202408:	0f597063          	bgeu	s2,s5,ffffffffc02024e8 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc020240c:	01595493          	srli	s1,s2,0x15
ffffffffc0202410:	1ff4f493          	andi	s1,s1,511
ffffffffc0202414:	048e                	slli	s1,s1,0x3
ffffffffc0202416:	94da                	add	s1,s1,s6
ffffffffc0202418:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc020241a:	0017f693          	andi	a3,a5,1
ffffffffc020241e:	dee9                	beqz	a3,ffffffffc02023f8 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202420:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202424:	078a                	slli	a5,a5,0x2
ffffffffc0202426:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202428:	14b7fe63          	bgeu	a5,a1,ffffffffc0202584 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020242c:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020242e:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0202432:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202436:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020243a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020243c:	12bef863          	bgeu	t4,a1,ffffffffc020256c <exit_range+0x256>
ffffffffc0202440:	00083783          	ld	a5,0(a6)
ffffffffc0202444:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202446:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc020244a:	629c                	ld	a5,0(a3)
ffffffffc020244c:	8b85                	andi	a5,a5,1
ffffffffc020244e:	f7d5                	bnez	a5,ffffffffc02023fa <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202450:	06a1                	addi	a3,a3,8
ffffffffc0202452:	fed59ce3          	bne	a1,a3,ffffffffc020244a <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202456:	631c                	ld	a5,0(a4)
ffffffffc0202458:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020245a:	100027f3          	csrr	a5,sstatus
ffffffffc020245e:	8b89                	andi	a5,a5,2
ffffffffc0202460:	e7d9                	bnez	a5,ffffffffc02024ee <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202462:	000db783          	ld	a5,0(s11)
ffffffffc0202466:	4585                	li	a1,1
ffffffffc0202468:	e032                	sd	a2,0(sp)
ffffffffc020246a:	739c                	ld	a5,32(a5)
ffffffffc020246c:	9782                	jalr	a5
    if (flag)
ffffffffc020246e:	6602                	ld	a2,0(sp)
ffffffffc0202470:	000a8817          	auipc	a6,0xa8
ffffffffc0202474:	3c080813          	addi	a6,a6,960 # ffffffffc02aa830 <va_pa_offset>
ffffffffc0202478:	fff80e37          	lui	t3,0xfff80
ffffffffc020247c:	00080337          	lui	t1,0x80
ffffffffc0202480:	6885                	lui	a7,0x1
ffffffffc0202482:	000a8717          	auipc	a4,0xa8
ffffffffc0202486:	39e70713          	addi	a4,a4,926 # ffffffffc02aa820 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020248a:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020248e:	002007b7          	lui	a5,0x200
ffffffffc0202492:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202494:	f60918e3          	bnez	s2,ffffffffc0202404 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202498:	f00b85e3          	beqz	s7,ffffffffc02023a2 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc020249c:	000d3783          	ld	a5,0(s10)
ffffffffc02024a0:	0efa7263          	bgeu	s4,a5,ffffffffc0202584 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a4:	6308                	ld	a0,0(a4)
ffffffffc02024a6:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024a8:	100027f3          	csrr	a5,sstatus
ffffffffc02024ac:	8b89                	andi	a5,a5,2
ffffffffc02024ae:	efad                	bnez	a5,ffffffffc0202528 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02024b0:	000db783          	ld	a5,0(s11)
ffffffffc02024b4:	4585                	li	a1,1
ffffffffc02024b6:	739c                	ld	a5,32(a5)
ffffffffc02024b8:	9782                	jalr	a5
ffffffffc02024ba:	000a8717          	auipc	a4,0xa8
ffffffffc02024be:	36670713          	addi	a4,a4,870 # ffffffffc02aa820 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024c2:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02024c6:	ee0990e3          	bnez	s3,ffffffffc02023a6 <exit_range+0x90>
}
ffffffffc02024ca:	70e6                	ld	ra,120(sp)
ffffffffc02024cc:	7446                	ld	s0,112(sp)
ffffffffc02024ce:	74a6                	ld	s1,104(sp)
ffffffffc02024d0:	7906                	ld	s2,96(sp)
ffffffffc02024d2:	69e6                	ld	s3,88(sp)
ffffffffc02024d4:	6a46                	ld	s4,80(sp)
ffffffffc02024d6:	6aa6                	ld	s5,72(sp)
ffffffffc02024d8:	6b06                	ld	s6,64(sp)
ffffffffc02024da:	7be2                	ld	s7,56(sp)
ffffffffc02024dc:	7c42                	ld	s8,48(sp)
ffffffffc02024de:	7ca2                	ld	s9,40(sp)
ffffffffc02024e0:	7d02                	ld	s10,32(sp)
ffffffffc02024e2:	6de2                	ld	s11,24(sp)
ffffffffc02024e4:	6109                	addi	sp,sp,128
ffffffffc02024e6:	8082                	ret
            if (free_pd0)
ffffffffc02024e8:	ea0b8fe3          	beqz	s7,ffffffffc02023a6 <exit_range+0x90>
ffffffffc02024ec:	bf45                	j	ffffffffc020249c <exit_range+0x186>
ffffffffc02024ee:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02024f0:	e42a                	sd	a0,8(sp)
ffffffffc02024f2:	cc2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02024f6:	000db783          	ld	a5,0(s11)
ffffffffc02024fa:	6522                	ld	a0,8(sp)
ffffffffc02024fc:	4585                	li	a1,1
ffffffffc02024fe:	739c                	ld	a5,32(a5)
ffffffffc0202500:	9782                	jalr	a5
        intr_enable();
ffffffffc0202502:	cacfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202506:	6602                	ld	a2,0(sp)
ffffffffc0202508:	000a8717          	auipc	a4,0xa8
ffffffffc020250c:	31870713          	addi	a4,a4,792 # ffffffffc02aa820 <pages>
ffffffffc0202510:	6885                	lui	a7,0x1
ffffffffc0202512:	00080337          	lui	t1,0x80
ffffffffc0202516:	fff80e37          	lui	t3,0xfff80
ffffffffc020251a:	000a8817          	auipc	a6,0xa8
ffffffffc020251e:	31680813          	addi	a6,a6,790 # ffffffffc02aa830 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202522:	0004b023          	sd	zero,0(s1)
ffffffffc0202526:	b7a5                	j	ffffffffc020248e <exit_range+0x178>
ffffffffc0202528:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc020252a:	c8afe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020252e:	000db783          	ld	a5,0(s11)
ffffffffc0202532:	6502                	ld	a0,0(sp)
ffffffffc0202534:	4585                	li	a1,1
ffffffffc0202536:	739c                	ld	a5,32(a5)
ffffffffc0202538:	9782                	jalr	a5
        intr_enable();
ffffffffc020253a:	c74fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020253e:	000a8717          	auipc	a4,0xa8
ffffffffc0202542:	2e270713          	addi	a4,a4,738 # ffffffffc02aa820 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202546:	00043023          	sd	zero,0(s0)
ffffffffc020254a:	bfb5                	j	ffffffffc02024c6 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020254c:	00004697          	auipc	a3,0x4
ffffffffc0202550:	15c68693          	addi	a3,a3,348 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc0202554:	00004617          	auipc	a2,0x4
ffffffffc0202558:	c4460613          	addi	a2,a2,-956 # ffffffffc0206198 <commands+0x828>
ffffffffc020255c:	13500593          	li	a1,309
ffffffffc0202560:	00004517          	auipc	a0,0x4
ffffffffc0202564:	13850513          	addi	a0,a0,312 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202568:	f27fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020256c:	00004617          	auipc	a2,0x4
ffffffffc0202570:	01460613          	addi	a2,a2,20 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202574:	07100593          	li	a1,113
ffffffffc0202578:	00004517          	auipc	a0,0x4
ffffffffc020257c:	03050513          	addi	a0,a0,48 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0202580:	f0ffd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202584:	8e1ff0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202588:	00004697          	auipc	a3,0x4
ffffffffc020258c:	15068693          	addi	a3,a3,336 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc0202590:	00004617          	auipc	a2,0x4
ffffffffc0202594:	c0860613          	addi	a2,a2,-1016 # ffffffffc0206198 <commands+0x828>
ffffffffc0202598:	13600593          	li	a1,310
ffffffffc020259c:	00004517          	auipc	a0,0x4
ffffffffc02025a0:	0fc50513          	addi	a0,a0,252 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02025a4:	eebfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02025a8 <page_remove>:
{
ffffffffc02025a8:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025aa:	4601                	li	a2,0
{
ffffffffc02025ac:	ec26                	sd	s1,24(sp)
ffffffffc02025ae:	f406                	sd	ra,40(sp)
ffffffffc02025b0:	f022                	sd	s0,32(sp)
ffffffffc02025b2:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025b4:	9a1ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
    if (ptep != NULL)
ffffffffc02025b8:	c511                	beqz	a0,ffffffffc02025c4 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02025ba:	611c                	ld	a5,0(a0)
ffffffffc02025bc:	842a                	mv	s0,a0
ffffffffc02025be:	0017f713          	andi	a4,a5,1
ffffffffc02025c2:	e711                	bnez	a4,ffffffffc02025ce <page_remove+0x26>
}
ffffffffc02025c4:	70a2                	ld	ra,40(sp)
ffffffffc02025c6:	7402                	ld	s0,32(sp)
ffffffffc02025c8:	64e2                	ld	s1,24(sp)
ffffffffc02025ca:	6145                	addi	sp,sp,48
ffffffffc02025cc:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025ce:	078a                	slli	a5,a5,0x2
ffffffffc02025d0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025d2:	000a8717          	auipc	a4,0xa8
ffffffffc02025d6:	24673703          	ld	a4,582(a4) # ffffffffc02aa818 <npage>
ffffffffc02025da:	06e7f363          	bgeu	a5,a4,ffffffffc0202640 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02025de:	fff80537          	lui	a0,0xfff80
ffffffffc02025e2:	97aa                	add	a5,a5,a0
ffffffffc02025e4:	079a                	slli	a5,a5,0x6
ffffffffc02025e6:	000a8517          	auipc	a0,0xa8
ffffffffc02025ea:	23a53503          	ld	a0,570(a0) # ffffffffc02aa820 <pages>
ffffffffc02025ee:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02025f0:	411c                	lw	a5,0(a0)
ffffffffc02025f2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02025f6:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02025f8:	cb11                	beqz	a4,ffffffffc020260c <page_remove+0x64>
        *ptep = 0;
ffffffffc02025fa:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025fe:	12048073          	sfence.vma	s1
}
ffffffffc0202602:	70a2                	ld	ra,40(sp)
ffffffffc0202604:	7402                	ld	s0,32(sp)
ffffffffc0202606:	64e2                	ld	s1,24(sp)
ffffffffc0202608:	6145                	addi	sp,sp,48
ffffffffc020260a:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020260c:	100027f3          	csrr	a5,sstatus
ffffffffc0202610:	8b89                	andi	a5,a5,2
ffffffffc0202612:	eb89                	bnez	a5,ffffffffc0202624 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202614:	000a8797          	auipc	a5,0xa8
ffffffffc0202618:	2147b783          	ld	a5,532(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc020261c:	739c                	ld	a5,32(a5)
ffffffffc020261e:	4585                	li	a1,1
ffffffffc0202620:	9782                	jalr	a5
    if (flag)
ffffffffc0202622:	bfe1                	j	ffffffffc02025fa <page_remove+0x52>
        intr_disable();
ffffffffc0202624:	e42a                	sd	a0,8(sp)
ffffffffc0202626:	b8efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020262a:	000a8797          	auipc	a5,0xa8
ffffffffc020262e:	1fe7b783          	ld	a5,510(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc0202632:	739c                	ld	a5,32(a5)
ffffffffc0202634:	6522                	ld	a0,8(sp)
ffffffffc0202636:	4585                	li	a1,1
ffffffffc0202638:	9782                	jalr	a5
        intr_enable();
ffffffffc020263a:	b74fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020263e:	bf75                	j	ffffffffc02025fa <page_remove+0x52>
ffffffffc0202640:	825ff0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>

ffffffffc0202644 <page_insert>:
{
ffffffffc0202644:	7139                	addi	sp,sp,-64
ffffffffc0202646:	e852                	sd	s4,16(sp)
ffffffffc0202648:	8a32                	mv	s4,a2
ffffffffc020264a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020264c:	4605                	li	a2,1
{
ffffffffc020264e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202650:	85d2                	mv	a1,s4
{
ffffffffc0202652:	f426                	sd	s1,40(sp)
ffffffffc0202654:	fc06                	sd	ra,56(sp)
ffffffffc0202656:	f04a                	sd	s2,32(sp)
ffffffffc0202658:	ec4e                	sd	s3,24(sp)
ffffffffc020265a:	e456                	sd	s5,8(sp)
ffffffffc020265c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020265e:	8f7ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
    if (ptep == NULL)
ffffffffc0202662:	c961                	beqz	a0,ffffffffc0202732 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202664:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202666:	611c                	ld	a5,0(a0)
ffffffffc0202668:	89aa                	mv	s3,a0
ffffffffc020266a:	0016871b          	addiw	a4,a3,1
ffffffffc020266e:	c018                	sw	a4,0(s0)
ffffffffc0202670:	0017f713          	andi	a4,a5,1
ffffffffc0202674:	ef05                	bnez	a4,ffffffffc02026ac <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202676:	000a8717          	auipc	a4,0xa8
ffffffffc020267a:	1aa73703          	ld	a4,426(a4) # ffffffffc02aa820 <pages>
ffffffffc020267e:	8c19                	sub	s0,s0,a4
ffffffffc0202680:	000807b7          	lui	a5,0x80
ffffffffc0202684:	8419                	srai	s0,s0,0x6
ffffffffc0202686:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202688:	042a                	slli	s0,s0,0xa
ffffffffc020268a:	8cc1                	or	s1,s1,s0
ffffffffc020268c:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202690:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202694:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202698:	4501                	li	a0,0
}
ffffffffc020269a:	70e2                	ld	ra,56(sp)
ffffffffc020269c:	7442                	ld	s0,48(sp)
ffffffffc020269e:	74a2                	ld	s1,40(sp)
ffffffffc02026a0:	7902                	ld	s2,32(sp)
ffffffffc02026a2:	69e2                	ld	s3,24(sp)
ffffffffc02026a4:	6a42                	ld	s4,16(sp)
ffffffffc02026a6:	6aa2                	ld	s5,8(sp)
ffffffffc02026a8:	6121                	addi	sp,sp,64
ffffffffc02026aa:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02026ac:	078a                	slli	a5,a5,0x2
ffffffffc02026ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026b0:	000a8717          	auipc	a4,0xa8
ffffffffc02026b4:	16873703          	ld	a4,360(a4) # ffffffffc02aa818 <npage>
ffffffffc02026b8:	06e7ff63          	bgeu	a5,a4,ffffffffc0202736 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02026bc:	000a8a97          	auipc	s5,0xa8
ffffffffc02026c0:	164a8a93          	addi	s5,s5,356 # ffffffffc02aa820 <pages>
ffffffffc02026c4:	000ab703          	ld	a4,0(s5)
ffffffffc02026c8:	fff80937          	lui	s2,0xfff80
ffffffffc02026cc:	993e                	add	s2,s2,a5
ffffffffc02026ce:	091a                	slli	s2,s2,0x6
ffffffffc02026d0:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02026d2:	01240c63          	beq	s0,s2,ffffffffc02026ea <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02026d6:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd57ac>
ffffffffc02026da:	fff7869b          	addiw	a3,a5,-1
ffffffffc02026de:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02026e2:	c691                	beqz	a3,ffffffffc02026ee <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026e4:	120a0073          	sfence.vma	s4
}
ffffffffc02026e8:	bf59                	j	ffffffffc020267e <page_insert+0x3a>
ffffffffc02026ea:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02026ec:	bf49                	j	ffffffffc020267e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026ee:	100027f3          	csrr	a5,sstatus
ffffffffc02026f2:	8b89                	andi	a5,a5,2
ffffffffc02026f4:	ef91                	bnez	a5,ffffffffc0202710 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02026f6:	000a8797          	auipc	a5,0xa8
ffffffffc02026fa:	1327b783          	ld	a5,306(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc02026fe:	739c                	ld	a5,32(a5)
ffffffffc0202700:	4585                	li	a1,1
ffffffffc0202702:	854a                	mv	a0,s2
ffffffffc0202704:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202706:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020270a:	120a0073          	sfence.vma	s4
ffffffffc020270e:	bf85                	j	ffffffffc020267e <page_insert+0x3a>
        intr_disable();
ffffffffc0202710:	aa4fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202714:	000a8797          	auipc	a5,0xa8
ffffffffc0202718:	1147b783          	ld	a5,276(a5) # ffffffffc02aa828 <pmm_manager>
ffffffffc020271c:	739c                	ld	a5,32(a5)
ffffffffc020271e:	4585                	li	a1,1
ffffffffc0202720:	854a                	mv	a0,s2
ffffffffc0202722:	9782                	jalr	a5
        intr_enable();
ffffffffc0202724:	a8afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202728:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020272c:	120a0073          	sfence.vma	s4
ffffffffc0202730:	b7b9                	j	ffffffffc020267e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202732:	5571                	li	a0,-4
ffffffffc0202734:	b79d                	j	ffffffffc020269a <page_insert+0x56>
ffffffffc0202736:	f2eff0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>

ffffffffc020273a <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020273a:	00004797          	auipc	a5,0x4
ffffffffc020273e:	e0e78793          	addi	a5,a5,-498 # ffffffffc0206548 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202742:	638c                	ld	a1,0(a5)
{
ffffffffc0202744:	7159                	addi	sp,sp,-112
ffffffffc0202746:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202748:	00004517          	auipc	a0,0x4
ffffffffc020274c:	fa850513          	addi	a0,a0,-88 # ffffffffc02066f0 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202750:	000a8b17          	auipc	s6,0xa8
ffffffffc0202754:	0d8b0b13          	addi	s6,s6,216 # ffffffffc02aa828 <pmm_manager>
{
ffffffffc0202758:	f486                	sd	ra,104(sp)
ffffffffc020275a:	e8ca                	sd	s2,80(sp)
ffffffffc020275c:	e4ce                	sd	s3,72(sp)
ffffffffc020275e:	f0a2                	sd	s0,96(sp)
ffffffffc0202760:	eca6                	sd	s1,88(sp)
ffffffffc0202762:	e0d2                	sd	s4,64(sp)
ffffffffc0202764:	fc56                	sd	s5,56(sp)
ffffffffc0202766:	f45e                	sd	s7,40(sp)
ffffffffc0202768:	f062                	sd	s8,32(sp)
ffffffffc020276a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020276c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202770:	a25fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202774:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202778:	000a8997          	auipc	s3,0xa8
ffffffffc020277c:	0b898993          	addi	s3,s3,184 # ffffffffc02aa830 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202780:	679c                	ld	a5,8(a5)
ffffffffc0202782:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202784:	57f5                	li	a5,-3
ffffffffc0202786:	07fa                	slli	a5,a5,0x1e
ffffffffc0202788:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020278c:	a0efe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202790:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202792:	a12fe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202796:	200505e3          	beqz	a0,ffffffffc02031a0 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc020279a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc020279c:	00004517          	auipc	a0,0x4
ffffffffc02027a0:	f8c50513          	addi	a0,a0,-116 # ffffffffc0206728 <default_pmm_manager+0x1e0>
ffffffffc02027a4:	9f1fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027a8:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02027ac:	fff40693          	addi	a3,s0,-1
ffffffffc02027b0:	864a                	mv	a2,s2
ffffffffc02027b2:	85a6                	mv	a1,s1
ffffffffc02027b4:	00004517          	auipc	a0,0x4
ffffffffc02027b8:	f8c50513          	addi	a0,a0,-116 # ffffffffc0206740 <default_pmm_manager+0x1f8>
ffffffffc02027bc:	9d9fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02027c0:	c8000737          	lui	a4,0xc8000
ffffffffc02027c4:	87a2                	mv	a5,s0
ffffffffc02027c6:	54876163          	bltu	a4,s0,ffffffffc0202d08 <pmm_init+0x5ce>
ffffffffc02027ca:	757d                	lui	a0,0xfffff
ffffffffc02027cc:	000a9617          	auipc	a2,0xa9
ffffffffc02027d0:	08760613          	addi	a2,a2,135 # ffffffffc02ab853 <end+0xfff>
ffffffffc02027d4:	8e69                	and	a2,a2,a0
ffffffffc02027d6:	000a8497          	auipc	s1,0xa8
ffffffffc02027da:	04248493          	addi	s1,s1,66 # ffffffffc02aa818 <npage>
ffffffffc02027de:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027e2:	000a8b97          	auipc	s7,0xa8
ffffffffc02027e6:	03eb8b93          	addi	s7,s7,62 # ffffffffc02aa820 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02027ea:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027ec:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027f0:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027f4:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027f6:	02f50863          	beq	a0,a5,ffffffffc0202826 <pmm_init+0xec>
ffffffffc02027fa:	4781                	li	a5,0
ffffffffc02027fc:	4585                	li	a1,1
ffffffffc02027fe:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202802:	00679513          	slli	a0,a5,0x6
ffffffffc0202806:	9532                	add	a0,a0,a2
ffffffffc0202808:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd547b4>
ffffffffc020280c:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202810:	6088                	ld	a0,0(s1)
ffffffffc0202812:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202814:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202818:	00d50733          	add	a4,a0,a3
ffffffffc020281c:	fee7e3e3          	bltu	a5,a4,ffffffffc0202802 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202820:	071a                	slli	a4,a4,0x6
ffffffffc0202822:	00e606b3          	add	a3,a2,a4
ffffffffc0202826:	c02007b7          	lui	a5,0xc0200
ffffffffc020282a:	2ef6ece3          	bltu	a3,a5,ffffffffc0203322 <pmm_init+0xbe8>
ffffffffc020282e:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202832:	77fd                	lui	a5,0xfffff
ffffffffc0202834:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202836:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202838:	5086eb63          	bltu	a3,s0,ffffffffc0202d4e <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020283c:	00004517          	auipc	a0,0x4
ffffffffc0202840:	f2c50513          	addi	a0,a0,-212 # ffffffffc0206768 <default_pmm_manager+0x220>
ffffffffc0202844:	951fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202848:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020284c:	000a8917          	auipc	s2,0xa8
ffffffffc0202850:	fc490913          	addi	s2,s2,-60 # ffffffffc02aa810 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202854:	7b9c                	ld	a5,48(a5)
ffffffffc0202856:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202858:	00004517          	auipc	a0,0x4
ffffffffc020285c:	f2850513          	addi	a0,a0,-216 # ffffffffc0206780 <default_pmm_manager+0x238>
ffffffffc0202860:	935fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202864:	00007697          	auipc	a3,0x7
ffffffffc0202868:	79c68693          	addi	a3,a3,1948 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc020286c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202870:	c02007b7          	lui	a5,0xc0200
ffffffffc0202874:	28f6ebe3          	bltu	a3,a5,ffffffffc020330a <pmm_init+0xbd0>
ffffffffc0202878:	0009b783          	ld	a5,0(s3)
ffffffffc020287c:	8e9d                	sub	a3,a3,a5
ffffffffc020287e:	000a8797          	auipc	a5,0xa8
ffffffffc0202882:	f8d7b523          	sd	a3,-118(a5) # ffffffffc02aa808 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202886:	100027f3          	csrr	a5,sstatus
ffffffffc020288a:	8b89                	andi	a5,a5,2
ffffffffc020288c:	4a079763          	bnez	a5,ffffffffc0202d3a <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202890:	000b3783          	ld	a5,0(s6)
ffffffffc0202894:	779c                	ld	a5,40(a5)
ffffffffc0202896:	9782                	jalr	a5
ffffffffc0202898:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020289a:	6098                	ld	a4,0(s1)
ffffffffc020289c:	c80007b7          	lui	a5,0xc8000
ffffffffc02028a0:	83b1                	srli	a5,a5,0xc
ffffffffc02028a2:	66e7e363          	bltu	a5,a4,ffffffffc0202f08 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028a6:	00093503          	ld	a0,0(s2)
ffffffffc02028aa:	62050f63          	beqz	a0,ffffffffc0202ee8 <pmm_init+0x7ae>
ffffffffc02028ae:	03451793          	slli	a5,a0,0x34
ffffffffc02028b2:	62079b63          	bnez	a5,ffffffffc0202ee8 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028b6:	4601                	li	a2,0
ffffffffc02028b8:	4581                	li	a1,0
ffffffffc02028ba:	8c3ff0ef          	jal	ra,ffffffffc020217c <get_page>
ffffffffc02028be:	60051563          	bnez	a0,ffffffffc0202ec8 <pmm_init+0x78e>
ffffffffc02028c2:	100027f3          	csrr	a5,sstatus
ffffffffc02028c6:	8b89                	andi	a5,a5,2
ffffffffc02028c8:	44079e63          	bnez	a5,ffffffffc0202d24 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028cc:	000b3783          	ld	a5,0(s6)
ffffffffc02028d0:	4505                	li	a0,1
ffffffffc02028d2:	6f9c                	ld	a5,24(a5)
ffffffffc02028d4:	9782                	jalr	a5
ffffffffc02028d6:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02028d8:	00093503          	ld	a0,0(s2)
ffffffffc02028dc:	4681                	li	a3,0
ffffffffc02028de:	4601                	li	a2,0
ffffffffc02028e0:	85d2                	mv	a1,s4
ffffffffc02028e2:	d63ff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc02028e6:	26051ae3          	bnez	a0,ffffffffc020335a <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02028ea:	00093503          	ld	a0,0(s2)
ffffffffc02028ee:	4601                	li	a2,0
ffffffffc02028f0:	4581                	li	a1,0
ffffffffc02028f2:	e62ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc02028f6:	240502e3          	beqz	a0,ffffffffc020333a <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc02028fa:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02028fc:	0017f713          	andi	a4,a5,1
ffffffffc0202900:	5a070263          	beqz	a4,ffffffffc0202ea4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202904:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202906:	078a                	slli	a5,a5,0x2
ffffffffc0202908:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020290a:	58e7fb63          	bgeu	a5,a4,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020290e:	000bb683          	ld	a3,0(s7)
ffffffffc0202912:	fff80637          	lui	a2,0xfff80
ffffffffc0202916:	97b2                	add	a5,a5,a2
ffffffffc0202918:	079a                	slli	a5,a5,0x6
ffffffffc020291a:	97b6                	add	a5,a5,a3
ffffffffc020291c:	14fa17e3          	bne	s4,a5,ffffffffc020326a <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202920:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202924:	4785                	li	a5,1
ffffffffc0202926:	12f692e3          	bne	a3,a5,ffffffffc020324a <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020292a:	00093503          	ld	a0,0(s2)
ffffffffc020292e:	77fd                	lui	a5,0xfffff
ffffffffc0202930:	6114                	ld	a3,0(a0)
ffffffffc0202932:	068a                	slli	a3,a3,0x2
ffffffffc0202934:	8efd                	and	a3,a3,a5
ffffffffc0202936:	00c6d613          	srli	a2,a3,0xc
ffffffffc020293a:	0ee67ce3          	bgeu	a2,a4,ffffffffc0203232 <pmm_init+0xaf8>
ffffffffc020293e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202942:	96e2                	add	a3,a3,s8
ffffffffc0202944:	0006ba83          	ld	s5,0(a3)
ffffffffc0202948:	0a8a                	slli	s5,s5,0x2
ffffffffc020294a:	00fafab3          	and	s5,s5,a5
ffffffffc020294e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202952:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203218 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202956:	4601                	li	a2,0
ffffffffc0202958:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020295a:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020295c:	df8ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202960:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202962:	55551363          	bne	a0,s5,ffffffffc0202ea8 <pmm_init+0x76e>
ffffffffc0202966:	100027f3          	csrr	a5,sstatus
ffffffffc020296a:	8b89                	andi	a5,a5,2
ffffffffc020296c:	3a079163          	bnez	a5,ffffffffc0202d0e <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202970:	000b3783          	ld	a5,0(s6)
ffffffffc0202974:	4505                	li	a0,1
ffffffffc0202976:	6f9c                	ld	a5,24(a5)
ffffffffc0202978:	9782                	jalr	a5
ffffffffc020297a:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020297c:	00093503          	ld	a0,0(s2)
ffffffffc0202980:	46d1                	li	a3,20
ffffffffc0202982:	6605                	lui	a2,0x1
ffffffffc0202984:	85e2                	mv	a1,s8
ffffffffc0202986:	cbfff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc020298a:	060517e3          	bnez	a0,ffffffffc02031f8 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020298e:	00093503          	ld	a0,0(s2)
ffffffffc0202992:	4601                	li	a2,0
ffffffffc0202994:	6585                	lui	a1,0x1
ffffffffc0202996:	dbeff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc020299a:	02050fe3          	beqz	a0,ffffffffc02031d8 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc020299e:	611c                	ld	a5,0(a0)
ffffffffc02029a0:	0107f713          	andi	a4,a5,16
ffffffffc02029a4:	7c070e63          	beqz	a4,ffffffffc0203180 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02029a8:	8b91                	andi	a5,a5,4
ffffffffc02029aa:	7a078b63          	beqz	a5,ffffffffc0203160 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02029ae:	00093503          	ld	a0,0(s2)
ffffffffc02029b2:	611c                	ld	a5,0(a0)
ffffffffc02029b4:	8bc1                	andi	a5,a5,16
ffffffffc02029b6:	78078563          	beqz	a5,ffffffffc0203140 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02029ba:	000c2703          	lw	a4,0(s8)
ffffffffc02029be:	4785                	li	a5,1
ffffffffc02029c0:	76f71063          	bne	a4,a5,ffffffffc0203120 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02029c4:	4681                	li	a3,0
ffffffffc02029c6:	6605                	lui	a2,0x1
ffffffffc02029c8:	85d2                	mv	a1,s4
ffffffffc02029ca:	c7bff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc02029ce:	72051963          	bnez	a0,ffffffffc0203100 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02029d2:	000a2703          	lw	a4,0(s4)
ffffffffc02029d6:	4789                	li	a5,2
ffffffffc02029d8:	70f71463          	bne	a4,a5,ffffffffc02030e0 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02029dc:	000c2783          	lw	a5,0(s8)
ffffffffc02029e0:	6e079063          	bnez	a5,ffffffffc02030c0 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029e4:	00093503          	ld	a0,0(s2)
ffffffffc02029e8:	4601                	li	a2,0
ffffffffc02029ea:	6585                	lui	a1,0x1
ffffffffc02029ec:	d68ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc02029f0:	6a050863          	beqz	a0,ffffffffc02030a0 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc02029f4:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02029f6:	00177793          	andi	a5,a4,1
ffffffffc02029fa:	4a078563          	beqz	a5,ffffffffc0202ea4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02029fe:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a00:	00271793          	slli	a5,a4,0x2
ffffffffc0202a04:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a06:	48d7fd63          	bgeu	a5,a3,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a0a:	000bb683          	ld	a3,0(s7)
ffffffffc0202a0e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a12:	97d6                	add	a5,a5,s5
ffffffffc0202a14:	079a                	slli	a5,a5,0x6
ffffffffc0202a16:	97b6                	add	a5,a5,a3
ffffffffc0202a18:	66fa1463          	bne	s4,a5,ffffffffc0203080 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a1c:	8b41                	andi	a4,a4,16
ffffffffc0202a1e:	64071163          	bnez	a4,ffffffffc0203060 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a22:	00093503          	ld	a0,0(s2)
ffffffffc0202a26:	4581                	li	a1,0
ffffffffc0202a28:	b81ff0ef          	jal	ra,ffffffffc02025a8 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a2c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a30:	4785                	li	a5,1
ffffffffc0202a32:	60fc9763          	bne	s9,a5,ffffffffc0203040 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a36:	000c2783          	lw	a5,0(s8)
ffffffffc0202a3a:	5e079363          	bnez	a5,ffffffffc0203020 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a3e:	00093503          	ld	a0,0(s2)
ffffffffc0202a42:	6585                	lui	a1,0x1
ffffffffc0202a44:	b65ff0ef          	jal	ra,ffffffffc02025a8 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a48:	000a2783          	lw	a5,0(s4)
ffffffffc0202a4c:	52079a63          	bnez	a5,ffffffffc0202f80 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a50:	000c2783          	lw	a5,0(s8)
ffffffffc0202a54:	50079663          	bnez	a5,ffffffffc0202f60 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a58:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202a5c:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a5e:	000a3683          	ld	a3,0(s4)
ffffffffc0202a62:	068a                	slli	a3,a3,0x2
ffffffffc0202a64:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a66:	42b6fd63          	bgeu	a3,a1,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a6a:	000bb503          	ld	a0,0(s7)
ffffffffc0202a6e:	96d6                	add	a3,a3,s5
ffffffffc0202a70:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202a72:	00d507b3          	add	a5,a0,a3
ffffffffc0202a76:	439c                	lw	a5,0(a5)
ffffffffc0202a78:	4d979463          	bne	a5,s9,ffffffffc0202f40 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202a7c:	8699                	srai	a3,a3,0x6
ffffffffc0202a7e:	00080637          	lui	a2,0x80
ffffffffc0202a82:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202a84:	00c69713          	slli	a4,a3,0xc
ffffffffc0202a88:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a8a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a8c:	48b77e63          	bgeu	a4,a1,ffffffffc0202f28 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202a90:	0009b703          	ld	a4,0(s3)
ffffffffc0202a94:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a96:	629c                	ld	a5,0(a3)
ffffffffc0202a98:	078a                	slli	a5,a5,0x2
ffffffffc0202a9a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a9c:	40b7f263          	bgeu	a5,a1,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aa0:	8f91                	sub	a5,a5,a2
ffffffffc0202aa2:	079a                	slli	a5,a5,0x6
ffffffffc0202aa4:	953e                	add	a0,a0,a5
ffffffffc0202aa6:	100027f3          	csrr	a5,sstatus
ffffffffc0202aaa:	8b89                	andi	a5,a5,2
ffffffffc0202aac:	30079963          	bnez	a5,ffffffffc0202dbe <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202ab0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ab4:	4585                	li	a1,1
ffffffffc0202ab6:	739c                	ld	a5,32(a5)
ffffffffc0202ab8:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aba:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202abe:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac0:	078a                	slli	a5,a5,0x2
ffffffffc0202ac2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ac4:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac8:	000bb503          	ld	a0,0(s7)
ffffffffc0202acc:	fff80737          	lui	a4,0xfff80
ffffffffc0202ad0:	97ba                	add	a5,a5,a4
ffffffffc0202ad2:	079a                	slli	a5,a5,0x6
ffffffffc0202ad4:	953e                	add	a0,a0,a5
ffffffffc0202ad6:	100027f3          	csrr	a5,sstatus
ffffffffc0202ada:	8b89                	andi	a5,a5,2
ffffffffc0202adc:	2c079563          	bnez	a5,ffffffffc0202da6 <pmm_init+0x66c>
ffffffffc0202ae0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ae4:	4585                	li	a1,1
ffffffffc0202ae6:	739c                	ld	a5,32(a5)
ffffffffc0202ae8:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202aea:	00093783          	ld	a5,0(s2)
ffffffffc0202aee:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd547ac>
    asm volatile("sfence.vma");
ffffffffc0202af2:	12000073          	sfence.vma
ffffffffc0202af6:	100027f3          	csrr	a5,sstatus
ffffffffc0202afa:	8b89                	andi	a5,a5,2
ffffffffc0202afc:	28079b63          	bnez	a5,ffffffffc0202d92 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b00:	000b3783          	ld	a5,0(s6)
ffffffffc0202b04:	779c                	ld	a5,40(a5)
ffffffffc0202b06:	9782                	jalr	a5
ffffffffc0202b08:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b0a:	4b441b63          	bne	s0,s4,ffffffffc0202fc0 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b0e:	00004517          	auipc	a0,0x4
ffffffffc0202b12:	f9a50513          	addi	a0,a0,-102 # ffffffffc0206aa8 <default_pmm_manager+0x560>
ffffffffc0202b16:	e7efd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b1a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b1e:	8b89                	andi	a5,a5,2
ffffffffc0202b20:	24079f63          	bnez	a5,ffffffffc0202d7e <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b24:	000b3783          	ld	a5,0(s6)
ffffffffc0202b28:	779c                	ld	a5,40(a5)
ffffffffc0202b2a:	9782                	jalr	a5
ffffffffc0202b2c:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b2e:	6098                	ld	a4,0(s1)
ffffffffc0202b30:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b34:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b36:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b3a:	6a05                	lui	s4,0x1
ffffffffc0202b3c:	02f47c63          	bgeu	s0,a5,ffffffffc0202b74 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b40:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b44:	00093503          	ld	a0,0(s2)
ffffffffc0202b48:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e46 <pmm_init+0x70c>
ffffffffc0202b4c:	0009b583          	ld	a1,0(s3)
ffffffffc0202b50:	4601                	li	a2,0
ffffffffc0202b52:	95a2                	add	a1,a1,s0
ffffffffc0202b54:	c00ff0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc0202b58:	32050463          	beqz	a0,ffffffffc0202e80 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b5c:	611c                	ld	a5,0(a0)
ffffffffc0202b5e:	078a                	slli	a5,a5,0x2
ffffffffc0202b60:	0157f7b3          	and	a5,a5,s5
ffffffffc0202b64:	2e879e63          	bne	a5,s0,ffffffffc0202e60 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b68:	6098                	ld	a4,0(s1)
ffffffffc0202b6a:	9452                	add	s0,s0,s4
ffffffffc0202b6c:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b70:	fcf468e3          	bltu	s0,a5,ffffffffc0202b40 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202b74:	00093783          	ld	a5,0(s2)
ffffffffc0202b78:	639c                	ld	a5,0(a5)
ffffffffc0202b7a:	42079363          	bnez	a5,ffffffffc0202fa0 <pmm_init+0x866>
ffffffffc0202b7e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b82:	8b89                	andi	a5,a5,2
ffffffffc0202b84:	24079963          	bnez	a5,ffffffffc0202dd6 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b88:	000b3783          	ld	a5,0(s6)
ffffffffc0202b8c:	4505                	li	a0,1
ffffffffc0202b8e:	6f9c                	ld	a5,24(a5)
ffffffffc0202b90:	9782                	jalr	a5
ffffffffc0202b92:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202b94:	00093503          	ld	a0,0(s2)
ffffffffc0202b98:	4699                	li	a3,6
ffffffffc0202b9a:	10000613          	li	a2,256
ffffffffc0202b9e:	85d2                	mv	a1,s4
ffffffffc0202ba0:	aa5ff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc0202ba4:	44051e63          	bnez	a0,ffffffffc0203000 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202ba8:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202bac:	4785                	li	a5,1
ffffffffc0202bae:	42f71963          	bne	a4,a5,ffffffffc0202fe0 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202bb2:	00093503          	ld	a0,0(s2)
ffffffffc0202bb6:	6405                	lui	s0,0x1
ffffffffc0202bb8:	4699                	li	a3,6
ffffffffc0202bba:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab8>
ffffffffc0202bbe:	85d2                	mv	a1,s4
ffffffffc0202bc0:	a85ff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc0202bc4:	72051363          	bnez	a0,ffffffffc02032ea <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202bc8:	000a2703          	lw	a4,0(s4)
ffffffffc0202bcc:	4789                	li	a5,2
ffffffffc0202bce:	6ef71e63          	bne	a4,a5,ffffffffc02032ca <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202bd2:	00004597          	auipc	a1,0x4
ffffffffc0202bd6:	01e58593          	addi	a1,a1,30 # ffffffffc0206bf0 <default_pmm_manager+0x6a8>
ffffffffc0202bda:	10000513          	li	a0,256
ffffffffc0202bde:	28f020ef          	jal	ra,ffffffffc020566c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202be2:	10040593          	addi	a1,s0,256
ffffffffc0202be6:	10000513          	li	a0,256
ffffffffc0202bea:	295020ef          	jal	ra,ffffffffc020567e <strcmp>
ffffffffc0202bee:	6a051e63          	bnez	a0,ffffffffc02032aa <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202bf2:	000bb683          	ld	a3,0(s7)
ffffffffc0202bf6:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202bfa:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202bfc:	40da06b3          	sub	a3,s4,a3
ffffffffc0202c00:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202c02:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c04:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c06:	8031                	srli	s0,s0,0xc
ffffffffc0202c08:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c0c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c0e:	30f77d63          	bgeu	a4,a5,ffffffffc0202f28 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c12:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c16:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c1a:	96be                	add	a3,a3,a5
ffffffffc0202c1c:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c20:	217020ef          	jal	ra,ffffffffc0205636 <strlen>
ffffffffc0202c24:	66051363          	bnez	a0,ffffffffc020328a <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c28:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c2c:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c2e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd547ac>
ffffffffc0202c32:	068a                	slli	a3,a3,0x2
ffffffffc0202c34:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c36:	26f6f563          	bgeu	a3,a5,ffffffffc0202ea0 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c3a:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c3c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c3e:	2ef47563          	bgeu	s0,a5,ffffffffc0202f28 <pmm_init+0x7ee>
ffffffffc0202c42:	0009b403          	ld	s0,0(s3)
ffffffffc0202c46:	9436                	add	s0,s0,a3
ffffffffc0202c48:	100027f3          	csrr	a5,sstatus
ffffffffc0202c4c:	8b89                	andi	a5,a5,2
ffffffffc0202c4e:	1e079163          	bnez	a5,ffffffffc0202e30 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c52:	000b3783          	ld	a5,0(s6)
ffffffffc0202c56:	4585                	li	a1,1
ffffffffc0202c58:	8552                	mv	a0,s4
ffffffffc0202c5a:	739c                	ld	a5,32(a5)
ffffffffc0202c5c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c5e:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202c60:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c62:	078a                	slli	a5,a5,0x2
ffffffffc0202c64:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c66:	22e7fd63          	bgeu	a5,a4,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c6a:	000bb503          	ld	a0,0(s7)
ffffffffc0202c6e:	fff80737          	lui	a4,0xfff80
ffffffffc0202c72:	97ba                	add	a5,a5,a4
ffffffffc0202c74:	079a                	slli	a5,a5,0x6
ffffffffc0202c76:	953e                	add	a0,a0,a5
ffffffffc0202c78:	100027f3          	csrr	a5,sstatus
ffffffffc0202c7c:	8b89                	andi	a5,a5,2
ffffffffc0202c7e:	18079d63          	bnez	a5,ffffffffc0202e18 <pmm_init+0x6de>
ffffffffc0202c82:	000b3783          	ld	a5,0(s6)
ffffffffc0202c86:	4585                	li	a1,1
ffffffffc0202c88:	739c                	ld	a5,32(a5)
ffffffffc0202c8a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c8c:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202c90:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c92:	078a                	slli	a5,a5,0x2
ffffffffc0202c94:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c96:	20e7f563          	bgeu	a5,a4,ffffffffc0202ea0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c9a:	000bb503          	ld	a0,0(s7)
ffffffffc0202c9e:	fff80737          	lui	a4,0xfff80
ffffffffc0202ca2:	97ba                	add	a5,a5,a4
ffffffffc0202ca4:	079a                	slli	a5,a5,0x6
ffffffffc0202ca6:	953e                	add	a0,a0,a5
ffffffffc0202ca8:	100027f3          	csrr	a5,sstatus
ffffffffc0202cac:	8b89                	andi	a5,a5,2
ffffffffc0202cae:	14079963          	bnez	a5,ffffffffc0202e00 <pmm_init+0x6c6>
ffffffffc0202cb2:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb6:	4585                	li	a1,1
ffffffffc0202cb8:	739c                	ld	a5,32(a5)
ffffffffc0202cba:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202cbc:	00093783          	ld	a5,0(s2)
ffffffffc0202cc0:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202cc4:	12000073          	sfence.vma
ffffffffc0202cc8:	100027f3          	csrr	a5,sstatus
ffffffffc0202ccc:	8b89                	andi	a5,a5,2
ffffffffc0202cce:	10079f63          	bnez	a5,ffffffffc0202dec <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cd2:	000b3783          	ld	a5,0(s6)
ffffffffc0202cd6:	779c                	ld	a5,40(a5)
ffffffffc0202cd8:	9782                	jalr	a5
ffffffffc0202cda:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202cdc:	4c8c1e63          	bne	s8,s0,ffffffffc02031b8 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ce0:	00004517          	auipc	a0,0x4
ffffffffc0202ce4:	f8850513          	addi	a0,a0,-120 # ffffffffc0206c68 <default_pmm_manager+0x720>
ffffffffc0202ce8:	cacfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202cec:	7406                	ld	s0,96(sp)
ffffffffc0202cee:	70a6                	ld	ra,104(sp)
ffffffffc0202cf0:	64e6                	ld	s1,88(sp)
ffffffffc0202cf2:	6946                	ld	s2,80(sp)
ffffffffc0202cf4:	69a6                	ld	s3,72(sp)
ffffffffc0202cf6:	6a06                	ld	s4,64(sp)
ffffffffc0202cf8:	7ae2                	ld	s5,56(sp)
ffffffffc0202cfa:	7b42                	ld	s6,48(sp)
ffffffffc0202cfc:	7ba2                	ld	s7,40(sp)
ffffffffc0202cfe:	7c02                	ld	s8,32(sp)
ffffffffc0202d00:	6ce2                	ld	s9,24(sp)
ffffffffc0202d02:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d04:	f97fe06f          	j	ffffffffc0201c9a <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202d08:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d0c:	bc7d                	j	ffffffffc02027ca <pmm_init+0x90>
        intr_disable();
ffffffffc0202d0e:	ca7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d12:	000b3783          	ld	a5,0(s6)
ffffffffc0202d16:	4505                	li	a0,1
ffffffffc0202d18:	6f9c                	ld	a5,24(a5)
ffffffffc0202d1a:	9782                	jalr	a5
ffffffffc0202d1c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d1e:	c91fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d22:	b9a9                	j	ffffffffc020297c <pmm_init+0x242>
        intr_disable();
ffffffffc0202d24:	c91fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d28:	000b3783          	ld	a5,0(s6)
ffffffffc0202d2c:	4505                	li	a0,1
ffffffffc0202d2e:	6f9c                	ld	a5,24(a5)
ffffffffc0202d30:	9782                	jalr	a5
ffffffffc0202d32:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d34:	c7bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d38:	b645                	j	ffffffffc02028d8 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d3a:	c7bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d3e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d42:	779c                	ld	a5,40(a5)
ffffffffc0202d44:	9782                	jalr	a5
ffffffffc0202d46:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d48:	c67fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d4c:	b6b9                	j	ffffffffc020289a <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d4e:	6705                	lui	a4,0x1
ffffffffc0202d50:	177d                	addi	a4,a4,-1
ffffffffc0202d52:	96ba                	add	a3,a3,a4
ffffffffc0202d54:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d56:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d5a:	14a77363          	bgeu	a4,a0,ffffffffc0202ea0 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d5e:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202d62:	fff80537          	lui	a0,0xfff80
ffffffffc0202d66:	972a                	add	a4,a4,a0
ffffffffc0202d68:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202d6a:	8c1d                	sub	s0,s0,a5
ffffffffc0202d6c:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202d70:	00c45593          	srli	a1,s0,0xc
ffffffffc0202d74:	9532                	add	a0,a0,a2
ffffffffc0202d76:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202d78:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202d7c:	b4c1                	j	ffffffffc020283c <pmm_init+0x102>
        intr_disable();
ffffffffc0202d7e:	c37fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d82:	000b3783          	ld	a5,0(s6)
ffffffffc0202d86:	779c                	ld	a5,40(a5)
ffffffffc0202d88:	9782                	jalr	a5
ffffffffc0202d8a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d8c:	c23fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d90:	bb79                	j	ffffffffc0202b2e <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202d92:	c23fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d96:	000b3783          	ld	a5,0(s6)
ffffffffc0202d9a:	779c                	ld	a5,40(a5)
ffffffffc0202d9c:	9782                	jalr	a5
ffffffffc0202d9e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202da0:	c0ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202da4:	b39d                	j	ffffffffc0202b0a <pmm_init+0x3d0>
ffffffffc0202da6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202da8:	c0dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202dac:	000b3783          	ld	a5,0(s6)
ffffffffc0202db0:	6522                	ld	a0,8(sp)
ffffffffc0202db2:	4585                	li	a1,1
ffffffffc0202db4:	739c                	ld	a5,32(a5)
ffffffffc0202db6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202db8:	bf7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dbc:	b33d                	j	ffffffffc0202aea <pmm_init+0x3b0>
ffffffffc0202dbe:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dc0:	bf5fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dc4:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc8:	6522                	ld	a0,8(sp)
ffffffffc0202dca:	4585                	li	a1,1
ffffffffc0202dcc:	739c                	ld	a5,32(a5)
ffffffffc0202dce:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dd0:	bdffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dd4:	b1dd                	j	ffffffffc0202aba <pmm_init+0x380>
        intr_disable();
ffffffffc0202dd6:	bdffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dda:	000b3783          	ld	a5,0(s6)
ffffffffc0202dde:	4505                	li	a0,1
ffffffffc0202de0:	6f9c                	ld	a5,24(a5)
ffffffffc0202de2:	9782                	jalr	a5
ffffffffc0202de4:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202de6:	bc9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dea:	b36d                	j	ffffffffc0202b94 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202dec:	bc9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202df0:	000b3783          	ld	a5,0(s6)
ffffffffc0202df4:	779c                	ld	a5,40(a5)
ffffffffc0202df6:	9782                	jalr	a5
ffffffffc0202df8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202dfa:	bb5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dfe:	bdf9                	j	ffffffffc0202cdc <pmm_init+0x5a2>
ffffffffc0202e00:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e02:	bb3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e06:	000b3783          	ld	a5,0(s6)
ffffffffc0202e0a:	6522                	ld	a0,8(sp)
ffffffffc0202e0c:	4585                	li	a1,1
ffffffffc0202e0e:	739c                	ld	a5,32(a5)
ffffffffc0202e10:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e12:	b9dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e16:	b55d                	j	ffffffffc0202cbc <pmm_init+0x582>
ffffffffc0202e18:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e1a:	b9bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e1e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e22:	6522                	ld	a0,8(sp)
ffffffffc0202e24:	4585                	li	a1,1
ffffffffc0202e26:	739c                	ld	a5,32(a5)
ffffffffc0202e28:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e2a:	b85fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e2e:	bdb9                	j	ffffffffc0202c8c <pmm_init+0x552>
        intr_disable();
ffffffffc0202e30:	b85fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e34:	000b3783          	ld	a5,0(s6)
ffffffffc0202e38:	4585                	li	a1,1
ffffffffc0202e3a:	8552                	mv	a0,s4
ffffffffc0202e3c:	739c                	ld	a5,32(a5)
ffffffffc0202e3e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e40:	b6ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e44:	bd29                	j	ffffffffc0202c5e <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e46:	86a2                	mv	a3,s0
ffffffffc0202e48:	00003617          	auipc	a2,0x3
ffffffffc0202e4c:	73860613          	addi	a2,a2,1848 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202e50:	25400593          	li	a1,596
ffffffffc0202e54:	00004517          	auipc	a0,0x4
ffffffffc0202e58:	84450513          	addi	a0,a0,-1980 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e5c:	e32fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e60:	00004697          	auipc	a3,0x4
ffffffffc0202e64:	ca868693          	addi	a3,a3,-856 # ffffffffc0206b08 <default_pmm_manager+0x5c0>
ffffffffc0202e68:	00003617          	auipc	a2,0x3
ffffffffc0202e6c:	33060613          	addi	a2,a2,816 # ffffffffc0206198 <commands+0x828>
ffffffffc0202e70:	25500593          	li	a1,597
ffffffffc0202e74:	00004517          	auipc	a0,0x4
ffffffffc0202e78:	82450513          	addi	a0,a0,-2012 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e7c:	e12fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e80:	00004697          	auipc	a3,0x4
ffffffffc0202e84:	c4868693          	addi	a3,a3,-952 # ffffffffc0206ac8 <default_pmm_manager+0x580>
ffffffffc0202e88:	00003617          	auipc	a2,0x3
ffffffffc0202e8c:	31060613          	addi	a2,a2,784 # ffffffffc0206198 <commands+0x828>
ffffffffc0202e90:	25400593          	li	a1,596
ffffffffc0202e94:	00004517          	auipc	a0,0x4
ffffffffc0202e98:	80450513          	addi	a0,a0,-2044 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e9c:	df2fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202ea0:	fc5fe0ef          	jal	ra,ffffffffc0201e64 <pa2page.part.0>
ffffffffc0202ea4:	fddfe0ef          	jal	ra,ffffffffc0201e80 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202ea8:	00004697          	auipc	a3,0x4
ffffffffc0202eac:	a1868693          	addi	a3,a3,-1512 # ffffffffc02068c0 <default_pmm_manager+0x378>
ffffffffc0202eb0:	00003617          	auipc	a2,0x3
ffffffffc0202eb4:	2e860613          	addi	a2,a2,744 # ffffffffc0206198 <commands+0x828>
ffffffffc0202eb8:	22400593          	li	a1,548
ffffffffc0202ebc:	00003517          	auipc	a0,0x3
ffffffffc0202ec0:	7dc50513          	addi	a0,a0,2012 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ec4:	dcafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202ec8:	00004697          	auipc	a3,0x4
ffffffffc0202ecc:	93868693          	addi	a3,a3,-1736 # ffffffffc0206800 <default_pmm_manager+0x2b8>
ffffffffc0202ed0:	00003617          	auipc	a2,0x3
ffffffffc0202ed4:	2c860613          	addi	a2,a2,712 # ffffffffc0206198 <commands+0x828>
ffffffffc0202ed8:	21700593          	li	a1,535
ffffffffc0202edc:	00003517          	auipc	a0,0x3
ffffffffc0202ee0:	7bc50513          	addi	a0,a0,1980 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ee4:	daafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ee8:	00004697          	auipc	a3,0x4
ffffffffc0202eec:	8d868693          	addi	a3,a3,-1832 # ffffffffc02067c0 <default_pmm_manager+0x278>
ffffffffc0202ef0:	00003617          	auipc	a2,0x3
ffffffffc0202ef4:	2a860613          	addi	a2,a2,680 # ffffffffc0206198 <commands+0x828>
ffffffffc0202ef8:	21600593          	li	a1,534
ffffffffc0202efc:	00003517          	auipc	a0,0x3
ffffffffc0202f00:	79c50513          	addi	a0,a0,1948 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f04:	d8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f08:	00004697          	auipc	a3,0x4
ffffffffc0202f0c:	89868693          	addi	a3,a3,-1896 # ffffffffc02067a0 <default_pmm_manager+0x258>
ffffffffc0202f10:	00003617          	auipc	a2,0x3
ffffffffc0202f14:	28860613          	addi	a2,a2,648 # ffffffffc0206198 <commands+0x828>
ffffffffc0202f18:	21500593          	li	a1,533
ffffffffc0202f1c:	00003517          	auipc	a0,0x3
ffffffffc0202f20:	77c50513          	addi	a0,a0,1916 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f24:	d6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f28:	00003617          	auipc	a2,0x3
ffffffffc0202f2c:	65860613          	addi	a2,a2,1624 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202f30:	07100593          	li	a1,113
ffffffffc0202f34:	00003517          	auipc	a0,0x3
ffffffffc0202f38:	67450513          	addi	a0,a0,1652 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0202f3c:	d52fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f40:	00004697          	auipc	a3,0x4
ffffffffc0202f44:	b1068693          	addi	a3,a3,-1264 # ffffffffc0206a50 <default_pmm_manager+0x508>
ffffffffc0202f48:	00003617          	auipc	a2,0x3
ffffffffc0202f4c:	25060613          	addi	a2,a2,592 # ffffffffc0206198 <commands+0x828>
ffffffffc0202f50:	23d00593          	li	a1,573
ffffffffc0202f54:	00003517          	auipc	a0,0x3
ffffffffc0202f58:	74450513          	addi	a0,a0,1860 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f5c:	d32fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f60:	00004697          	auipc	a3,0x4
ffffffffc0202f64:	aa868693          	addi	a3,a3,-1368 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc0202f68:	00003617          	auipc	a2,0x3
ffffffffc0202f6c:	23060613          	addi	a2,a2,560 # ffffffffc0206198 <commands+0x828>
ffffffffc0202f70:	23b00593          	li	a1,571
ffffffffc0202f74:	00003517          	auipc	a0,0x3
ffffffffc0202f78:	72450513          	addi	a0,a0,1828 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f7c:	d12fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f80:	00004697          	auipc	a3,0x4
ffffffffc0202f84:	ab868693          	addi	a3,a3,-1352 # ffffffffc0206a38 <default_pmm_manager+0x4f0>
ffffffffc0202f88:	00003617          	auipc	a2,0x3
ffffffffc0202f8c:	21060613          	addi	a2,a2,528 # ffffffffc0206198 <commands+0x828>
ffffffffc0202f90:	23a00593          	li	a1,570
ffffffffc0202f94:	00003517          	auipc	a0,0x3
ffffffffc0202f98:	70450513          	addi	a0,a0,1796 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f9c:	cf2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202fa0:	00004697          	auipc	a3,0x4
ffffffffc0202fa4:	b8068693          	addi	a3,a3,-1152 # ffffffffc0206b20 <default_pmm_manager+0x5d8>
ffffffffc0202fa8:	00003617          	auipc	a2,0x3
ffffffffc0202fac:	1f060613          	addi	a2,a2,496 # ffffffffc0206198 <commands+0x828>
ffffffffc0202fb0:	25800593          	li	a1,600
ffffffffc0202fb4:	00003517          	auipc	a0,0x3
ffffffffc0202fb8:	6e450513          	addi	a0,a0,1764 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202fbc:	cd2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202fc0:	00004697          	auipc	a3,0x4
ffffffffc0202fc4:	ac068693          	addi	a3,a3,-1344 # ffffffffc0206a80 <default_pmm_manager+0x538>
ffffffffc0202fc8:	00003617          	auipc	a2,0x3
ffffffffc0202fcc:	1d060613          	addi	a2,a2,464 # ffffffffc0206198 <commands+0x828>
ffffffffc0202fd0:	24500593          	li	a1,581
ffffffffc0202fd4:	00003517          	auipc	a0,0x3
ffffffffc0202fd8:	6c450513          	addi	a0,a0,1732 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202fdc:	cb2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fe0:	00004697          	auipc	a3,0x4
ffffffffc0202fe4:	b9868693          	addi	a3,a3,-1128 # ffffffffc0206b78 <default_pmm_manager+0x630>
ffffffffc0202fe8:	00003617          	auipc	a2,0x3
ffffffffc0202fec:	1b060613          	addi	a2,a2,432 # ffffffffc0206198 <commands+0x828>
ffffffffc0202ff0:	25d00593          	li	a1,605
ffffffffc0202ff4:	00003517          	auipc	a0,0x3
ffffffffc0202ff8:	6a450513          	addi	a0,a0,1700 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ffc:	c92fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203000:	00004697          	auipc	a3,0x4
ffffffffc0203004:	b3868693          	addi	a3,a3,-1224 # ffffffffc0206b38 <default_pmm_manager+0x5f0>
ffffffffc0203008:	00003617          	auipc	a2,0x3
ffffffffc020300c:	19060613          	addi	a2,a2,400 # ffffffffc0206198 <commands+0x828>
ffffffffc0203010:	25c00593          	li	a1,604
ffffffffc0203014:	00003517          	auipc	a0,0x3
ffffffffc0203018:	68450513          	addi	a0,a0,1668 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020301c:	c72fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203020:	00004697          	auipc	a3,0x4
ffffffffc0203024:	9e868693          	addi	a3,a3,-1560 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc0203028:	00003617          	auipc	a2,0x3
ffffffffc020302c:	17060613          	addi	a2,a2,368 # ffffffffc0206198 <commands+0x828>
ffffffffc0203030:	23700593          	li	a1,567
ffffffffc0203034:	00003517          	auipc	a0,0x3
ffffffffc0203038:	66450513          	addi	a0,a0,1636 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020303c:	c52fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203040:	00004697          	auipc	a3,0x4
ffffffffc0203044:	86868693          	addi	a3,a3,-1944 # ffffffffc02068a8 <default_pmm_manager+0x360>
ffffffffc0203048:	00003617          	auipc	a2,0x3
ffffffffc020304c:	15060613          	addi	a2,a2,336 # ffffffffc0206198 <commands+0x828>
ffffffffc0203050:	23600593          	li	a1,566
ffffffffc0203054:	00003517          	auipc	a0,0x3
ffffffffc0203058:	64450513          	addi	a0,a0,1604 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020305c:	c32fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203060:	00004697          	auipc	a3,0x4
ffffffffc0203064:	9c068693          	addi	a3,a3,-1600 # ffffffffc0206a20 <default_pmm_manager+0x4d8>
ffffffffc0203068:	00003617          	auipc	a2,0x3
ffffffffc020306c:	13060613          	addi	a2,a2,304 # ffffffffc0206198 <commands+0x828>
ffffffffc0203070:	23300593          	li	a1,563
ffffffffc0203074:	00003517          	auipc	a0,0x3
ffffffffc0203078:	62450513          	addi	a0,a0,1572 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020307c:	c12fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203080:	00004697          	auipc	a3,0x4
ffffffffc0203084:	81068693          	addi	a3,a3,-2032 # ffffffffc0206890 <default_pmm_manager+0x348>
ffffffffc0203088:	00003617          	auipc	a2,0x3
ffffffffc020308c:	11060613          	addi	a2,a2,272 # ffffffffc0206198 <commands+0x828>
ffffffffc0203090:	23200593          	li	a1,562
ffffffffc0203094:	00003517          	auipc	a0,0x3
ffffffffc0203098:	60450513          	addi	a0,a0,1540 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020309c:	bf2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030a0:	00004697          	auipc	a3,0x4
ffffffffc02030a4:	89068693          	addi	a3,a3,-1904 # ffffffffc0206930 <default_pmm_manager+0x3e8>
ffffffffc02030a8:	00003617          	auipc	a2,0x3
ffffffffc02030ac:	0f060613          	addi	a2,a2,240 # ffffffffc0206198 <commands+0x828>
ffffffffc02030b0:	23100593          	li	a1,561
ffffffffc02030b4:	00003517          	auipc	a0,0x3
ffffffffc02030b8:	5e450513          	addi	a0,a0,1508 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030bc:	bd2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030c0:	00004697          	auipc	a3,0x4
ffffffffc02030c4:	94868693          	addi	a3,a3,-1720 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc02030c8:	00003617          	auipc	a2,0x3
ffffffffc02030cc:	0d060613          	addi	a2,a2,208 # ffffffffc0206198 <commands+0x828>
ffffffffc02030d0:	23000593          	li	a1,560
ffffffffc02030d4:	00003517          	auipc	a0,0x3
ffffffffc02030d8:	5c450513          	addi	a0,a0,1476 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030dc:	bb2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02030e0:	00004697          	auipc	a3,0x4
ffffffffc02030e4:	91068693          	addi	a3,a3,-1776 # ffffffffc02069f0 <default_pmm_manager+0x4a8>
ffffffffc02030e8:	00003617          	auipc	a2,0x3
ffffffffc02030ec:	0b060613          	addi	a2,a2,176 # ffffffffc0206198 <commands+0x828>
ffffffffc02030f0:	22f00593          	li	a1,559
ffffffffc02030f4:	00003517          	auipc	a0,0x3
ffffffffc02030f8:	5a450513          	addi	a0,a0,1444 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030fc:	b92fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203100:	00004697          	auipc	a3,0x4
ffffffffc0203104:	8c068693          	addi	a3,a3,-1856 # ffffffffc02069c0 <default_pmm_manager+0x478>
ffffffffc0203108:	00003617          	auipc	a2,0x3
ffffffffc020310c:	09060613          	addi	a2,a2,144 # ffffffffc0206198 <commands+0x828>
ffffffffc0203110:	22e00593          	li	a1,558
ffffffffc0203114:	00003517          	auipc	a0,0x3
ffffffffc0203118:	58450513          	addi	a0,a0,1412 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020311c:	b72fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203120:	00004697          	auipc	a3,0x4
ffffffffc0203124:	88868693          	addi	a3,a3,-1912 # ffffffffc02069a8 <default_pmm_manager+0x460>
ffffffffc0203128:	00003617          	auipc	a2,0x3
ffffffffc020312c:	07060613          	addi	a2,a2,112 # ffffffffc0206198 <commands+0x828>
ffffffffc0203130:	22c00593          	li	a1,556
ffffffffc0203134:	00003517          	auipc	a0,0x3
ffffffffc0203138:	56450513          	addi	a0,a0,1380 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020313c:	b52fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203140:	00004697          	auipc	a3,0x4
ffffffffc0203144:	84868693          	addi	a3,a3,-1976 # ffffffffc0206988 <default_pmm_manager+0x440>
ffffffffc0203148:	00003617          	auipc	a2,0x3
ffffffffc020314c:	05060613          	addi	a2,a2,80 # ffffffffc0206198 <commands+0x828>
ffffffffc0203150:	22b00593          	li	a1,555
ffffffffc0203154:	00003517          	auipc	a0,0x3
ffffffffc0203158:	54450513          	addi	a0,a0,1348 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020315c:	b32fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203160:	00004697          	auipc	a3,0x4
ffffffffc0203164:	81868693          	addi	a3,a3,-2024 # ffffffffc0206978 <default_pmm_manager+0x430>
ffffffffc0203168:	00003617          	auipc	a2,0x3
ffffffffc020316c:	03060613          	addi	a2,a2,48 # ffffffffc0206198 <commands+0x828>
ffffffffc0203170:	22a00593          	li	a1,554
ffffffffc0203174:	00003517          	auipc	a0,0x3
ffffffffc0203178:	52450513          	addi	a0,a0,1316 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020317c:	b12fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203180:	00003697          	auipc	a3,0x3
ffffffffc0203184:	7e868693          	addi	a3,a3,2024 # ffffffffc0206968 <default_pmm_manager+0x420>
ffffffffc0203188:	00003617          	auipc	a2,0x3
ffffffffc020318c:	01060613          	addi	a2,a2,16 # ffffffffc0206198 <commands+0x828>
ffffffffc0203190:	22900593          	li	a1,553
ffffffffc0203194:	00003517          	auipc	a0,0x3
ffffffffc0203198:	50450513          	addi	a0,a0,1284 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020319c:	af2fd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc02031a0:	00003617          	auipc	a2,0x3
ffffffffc02031a4:	56860613          	addi	a2,a2,1384 # ffffffffc0206708 <default_pmm_manager+0x1c0>
ffffffffc02031a8:	06500593          	li	a1,101
ffffffffc02031ac:	00003517          	auipc	a0,0x3
ffffffffc02031b0:	4ec50513          	addi	a0,a0,1260 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031b4:	adafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031b8:	00004697          	auipc	a3,0x4
ffffffffc02031bc:	8c868693          	addi	a3,a3,-1848 # ffffffffc0206a80 <default_pmm_manager+0x538>
ffffffffc02031c0:	00003617          	auipc	a2,0x3
ffffffffc02031c4:	fd860613          	addi	a2,a2,-40 # ffffffffc0206198 <commands+0x828>
ffffffffc02031c8:	26f00593          	li	a1,623
ffffffffc02031cc:	00003517          	auipc	a0,0x3
ffffffffc02031d0:	4cc50513          	addi	a0,a0,1228 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031d4:	abafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031d8:	00003697          	auipc	a3,0x3
ffffffffc02031dc:	75868693          	addi	a3,a3,1880 # ffffffffc0206930 <default_pmm_manager+0x3e8>
ffffffffc02031e0:	00003617          	auipc	a2,0x3
ffffffffc02031e4:	fb860613          	addi	a2,a2,-72 # ffffffffc0206198 <commands+0x828>
ffffffffc02031e8:	22800593          	li	a1,552
ffffffffc02031ec:	00003517          	auipc	a0,0x3
ffffffffc02031f0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031f4:	a9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02031f8:	00003697          	auipc	a3,0x3
ffffffffc02031fc:	6f868693          	addi	a3,a3,1784 # ffffffffc02068f0 <default_pmm_manager+0x3a8>
ffffffffc0203200:	00003617          	auipc	a2,0x3
ffffffffc0203204:	f9860613          	addi	a2,a2,-104 # ffffffffc0206198 <commands+0x828>
ffffffffc0203208:	22700593          	li	a1,551
ffffffffc020320c:	00003517          	auipc	a0,0x3
ffffffffc0203210:	48c50513          	addi	a0,a0,1164 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203214:	a7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203218:	86d6                	mv	a3,s5
ffffffffc020321a:	00003617          	auipc	a2,0x3
ffffffffc020321e:	36660613          	addi	a2,a2,870 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0203222:	22300593          	li	a1,547
ffffffffc0203226:	00003517          	auipc	a0,0x3
ffffffffc020322a:	47250513          	addi	a0,a0,1138 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020322e:	a60fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203232:	00003617          	auipc	a2,0x3
ffffffffc0203236:	34e60613          	addi	a2,a2,846 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020323a:	22200593          	li	a1,546
ffffffffc020323e:	00003517          	auipc	a0,0x3
ffffffffc0203242:	45a50513          	addi	a0,a0,1114 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203246:	a48fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020324a:	00003697          	auipc	a3,0x3
ffffffffc020324e:	65e68693          	addi	a3,a3,1630 # ffffffffc02068a8 <default_pmm_manager+0x360>
ffffffffc0203252:	00003617          	auipc	a2,0x3
ffffffffc0203256:	f4660613          	addi	a2,a2,-186 # ffffffffc0206198 <commands+0x828>
ffffffffc020325a:	22000593          	li	a1,544
ffffffffc020325e:	00003517          	auipc	a0,0x3
ffffffffc0203262:	43a50513          	addi	a0,a0,1082 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203266:	a28fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020326a:	00003697          	auipc	a3,0x3
ffffffffc020326e:	62668693          	addi	a3,a3,1574 # ffffffffc0206890 <default_pmm_manager+0x348>
ffffffffc0203272:	00003617          	auipc	a2,0x3
ffffffffc0203276:	f2660613          	addi	a2,a2,-218 # ffffffffc0206198 <commands+0x828>
ffffffffc020327a:	21f00593          	li	a1,543
ffffffffc020327e:	00003517          	auipc	a0,0x3
ffffffffc0203282:	41a50513          	addi	a0,a0,1050 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203286:	a08fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020328a:	00004697          	auipc	a3,0x4
ffffffffc020328e:	9b668693          	addi	a3,a3,-1610 # ffffffffc0206c40 <default_pmm_manager+0x6f8>
ffffffffc0203292:	00003617          	auipc	a2,0x3
ffffffffc0203296:	f0660613          	addi	a2,a2,-250 # ffffffffc0206198 <commands+0x828>
ffffffffc020329a:	26600593          	li	a1,614
ffffffffc020329e:	00003517          	auipc	a0,0x3
ffffffffc02032a2:	3fa50513          	addi	a0,a0,1018 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032a6:	9e8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032aa:	00004697          	auipc	a3,0x4
ffffffffc02032ae:	95e68693          	addi	a3,a3,-1698 # ffffffffc0206c08 <default_pmm_manager+0x6c0>
ffffffffc02032b2:	00003617          	auipc	a2,0x3
ffffffffc02032b6:	ee660613          	addi	a2,a2,-282 # ffffffffc0206198 <commands+0x828>
ffffffffc02032ba:	26300593          	li	a1,611
ffffffffc02032be:	00003517          	auipc	a0,0x3
ffffffffc02032c2:	3da50513          	addi	a0,a0,986 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032c6:	9c8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02032ca:	00004697          	auipc	a3,0x4
ffffffffc02032ce:	90e68693          	addi	a3,a3,-1778 # ffffffffc0206bd8 <default_pmm_manager+0x690>
ffffffffc02032d2:	00003617          	auipc	a2,0x3
ffffffffc02032d6:	ec660613          	addi	a2,a2,-314 # ffffffffc0206198 <commands+0x828>
ffffffffc02032da:	25f00593          	li	a1,607
ffffffffc02032de:	00003517          	auipc	a0,0x3
ffffffffc02032e2:	3ba50513          	addi	a0,a0,954 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032e6:	9a8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032ea:	00004697          	auipc	a3,0x4
ffffffffc02032ee:	8a668693          	addi	a3,a3,-1882 # ffffffffc0206b90 <default_pmm_manager+0x648>
ffffffffc02032f2:	00003617          	auipc	a2,0x3
ffffffffc02032f6:	ea660613          	addi	a2,a2,-346 # ffffffffc0206198 <commands+0x828>
ffffffffc02032fa:	25e00593          	li	a1,606
ffffffffc02032fe:	00003517          	auipc	a0,0x3
ffffffffc0203302:	39a50513          	addi	a0,a0,922 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203306:	988fd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020330a:	00003617          	auipc	a2,0x3
ffffffffc020330e:	31e60613          	addi	a2,a2,798 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0203312:	0c900593          	li	a1,201
ffffffffc0203316:	00003517          	auipc	a0,0x3
ffffffffc020331a:	38250513          	addi	a0,a0,898 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020331e:	970fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203322:	00003617          	auipc	a2,0x3
ffffffffc0203326:	30660613          	addi	a2,a2,774 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc020332a:	08100593          	li	a1,129
ffffffffc020332e:	00003517          	auipc	a0,0x3
ffffffffc0203332:	36a50513          	addi	a0,a0,874 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203336:	958fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020333a:	00003697          	auipc	a3,0x3
ffffffffc020333e:	52668693          	addi	a3,a3,1318 # ffffffffc0206860 <default_pmm_manager+0x318>
ffffffffc0203342:	00003617          	auipc	a2,0x3
ffffffffc0203346:	e5660613          	addi	a2,a2,-426 # ffffffffc0206198 <commands+0x828>
ffffffffc020334a:	21e00593          	li	a1,542
ffffffffc020334e:	00003517          	auipc	a0,0x3
ffffffffc0203352:	34a50513          	addi	a0,a0,842 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203356:	938fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020335a:	00003697          	auipc	a3,0x3
ffffffffc020335e:	4d668693          	addi	a3,a3,1238 # ffffffffc0206830 <default_pmm_manager+0x2e8>
ffffffffc0203362:	00003617          	auipc	a2,0x3
ffffffffc0203366:	e3660613          	addi	a2,a2,-458 # ffffffffc0206198 <commands+0x828>
ffffffffc020336a:	21b00593          	li	a1,539
ffffffffc020336e:	00003517          	auipc	a0,0x3
ffffffffc0203372:	32a50513          	addi	a0,a0,810 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203376:	918fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020337a <copy_range>:
{
ffffffffc020337a:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020337c:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203380:	f486                	sd	ra,104(sp)
ffffffffc0203382:	f0a2                	sd	s0,96(sp)
ffffffffc0203384:	eca6                	sd	s1,88(sp)
ffffffffc0203386:	e8ca                	sd	s2,80(sp)
ffffffffc0203388:	e4ce                	sd	s3,72(sp)
ffffffffc020338a:	e0d2                	sd	s4,64(sp)
ffffffffc020338c:	fc56                	sd	s5,56(sp)
ffffffffc020338e:	f85a                	sd	s6,48(sp)
ffffffffc0203390:	f45e                	sd	s7,40(sp)
ffffffffc0203392:	f062                	sd	s8,32(sp)
ffffffffc0203394:	ec66                	sd	s9,24(sp)
ffffffffc0203396:	e86a                	sd	s10,16(sp)
ffffffffc0203398:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020339a:	17d2                	slli	a5,a5,0x34
ffffffffc020339c:	20079f63          	bnez	a5,ffffffffc02035ba <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc02033a0:	002007b7          	lui	a5,0x200
ffffffffc02033a4:	8432                	mv	s0,a2
ffffffffc02033a6:	1af66263          	bltu	a2,a5,ffffffffc020354a <copy_range+0x1d0>
ffffffffc02033aa:	8936                	mv	s2,a3
ffffffffc02033ac:	18d67f63          	bgeu	a2,a3,ffffffffc020354a <copy_range+0x1d0>
ffffffffc02033b0:	4785                	li	a5,1
ffffffffc02033b2:	07fe                	slli	a5,a5,0x1f
ffffffffc02033b4:	18d7eb63          	bltu	a5,a3,ffffffffc020354a <copy_range+0x1d0>
ffffffffc02033b8:	5b7d                	li	s6,-1
ffffffffc02033ba:	8aaa                	mv	s5,a0
ffffffffc02033bc:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02033be:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02033c0:	000a7c17          	auipc	s8,0xa7
ffffffffc02033c4:	458c0c13          	addi	s8,s8,1112 # ffffffffc02aa818 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02033c8:	000a7b97          	auipc	s7,0xa7
ffffffffc02033cc:	458b8b93          	addi	s7,s7,1112 # ffffffffc02aa820 <pages>
    return KADDR(page2pa(page));
ffffffffc02033d0:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02033d4:	000a7c97          	auipc	s9,0xa7
ffffffffc02033d8:	454c8c93          	addi	s9,s9,1108 # ffffffffc02aa828 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02033dc:	4601                	li	a2,0
ffffffffc02033de:	85a2                	mv	a1,s0
ffffffffc02033e0:	854e                	mv	a0,s3
ffffffffc02033e2:	b73fe0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc02033e6:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02033e8:	0e050c63          	beqz	a0,ffffffffc02034e0 <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02033ec:	611c                	ld	a5,0(a0)
ffffffffc02033ee:	8b85                	andi	a5,a5,1
ffffffffc02033f0:	e785                	bnez	a5,ffffffffc0203418 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02033f2:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02033f4:	ff2464e3          	bltu	s0,s2,ffffffffc02033dc <copy_range+0x62>
    return 0;
ffffffffc02033f8:	4501                	li	a0,0
}
ffffffffc02033fa:	70a6                	ld	ra,104(sp)
ffffffffc02033fc:	7406                	ld	s0,96(sp)
ffffffffc02033fe:	64e6                	ld	s1,88(sp)
ffffffffc0203400:	6946                	ld	s2,80(sp)
ffffffffc0203402:	69a6                	ld	s3,72(sp)
ffffffffc0203404:	6a06                	ld	s4,64(sp)
ffffffffc0203406:	7ae2                	ld	s5,56(sp)
ffffffffc0203408:	7b42                	ld	s6,48(sp)
ffffffffc020340a:	7ba2                	ld	s7,40(sp)
ffffffffc020340c:	7c02                	ld	s8,32(sp)
ffffffffc020340e:	6ce2                	ld	s9,24(sp)
ffffffffc0203410:	6d42                	ld	s10,16(sp)
ffffffffc0203412:	6da2                	ld	s11,8(sp)
ffffffffc0203414:	6165                	addi	sp,sp,112
ffffffffc0203416:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203418:	4605                	li	a2,1
ffffffffc020341a:	85a2                	mv	a1,s0
ffffffffc020341c:	8556                	mv	a0,s5
ffffffffc020341e:	b37fe0ef          	jal	ra,ffffffffc0201f54 <get_pte>
ffffffffc0203422:	c56d                	beqz	a0,ffffffffc020350c <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203424:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203426:	0017f713          	andi	a4,a5,1
ffffffffc020342a:	01f7f493          	andi	s1,a5,31
ffffffffc020342e:	16070a63          	beqz	a4,ffffffffc02035a2 <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0203432:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203436:	078a                	slli	a5,a5,0x2
ffffffffc0203438:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020343c:	14d77763          	bgeu	a4,a3,ffffffffc020358a <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203440:	000bb783          	ld	a5,0(s7)
ffffffffc0203444:	fff806b7          	lui	a3,0xfff80
ffffffffc0203448:	9736                	add	a4,a4,a3
ffffffffc020344a:	071a                	slli	a4,a4,0x6
ffffffffc020344c:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203450:	10002773          	csrr	a4,sstatus
ffffffffc0203454:	8b09                	andi	a4,a4,2
ffffffffc0203456:	e345                	bnez	a4,ffffffffc02034f6 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203458:	000cb703          	ld	a4,0(s9)
ffffffffc020345c:	4505                	li	a0,1
ffffffffc020345e:	6f18                	ld	a4,24(a4)
ffffffffc0203460:	9702                	jalr	a4
ffffffffc0203462:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203464:	0c0d8363          	beqz	s11,ffffffffc020352a <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203468:	100d0163          	beqz	s10,ffffffffc020356a <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc020346c:	000bb703          	ld	a4,0(s7)
ffffffffc0203470:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203474:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203478:	40ed86b3          	sub	a3,s11,a4
ffffffffc020347c:	8699                	srai	a3,a3,0x6
ffffffffc020347e:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203480:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203484:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203486:	08c7f663          	bgeu	a5,a2,ffffffffc0203512 <copy_range+0x198>
    return page - pages + nbase;
ffffffffc020348a:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc020348e:	000a7717          	auipc	a4,0xa7
ffffffffc0203492:	3a270713          	addi	a4,a4,930 # ffffffffc02aa830 <va_pa_offset>
ffffffffc0203496:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203498:	8799                	srai	a5,a5,0x6
ffffffffc020349a:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc020349c:	0167f733          	and	a4,a5,s6
ffffffffc02034a0:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034a4:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02034a6:	06c77563          	bgeu	a4,a2,ffffffffc0203510 <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02034aa:	6605                	lui	a2,0x1
ffffffffc02034ac:	953e                	add	a0,a0,a5
ffffffffc02034ae:	23c020ef          	jal	ra,ffffffffc02056ea <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc02034b2:	86a6                	mv	a3,s1
ffffffffc02034b4:	8622                	mv	a2,s0
ffffffffc02034b6:	85ea                	mv	a1,s10
ffffffffc02034b8:	8556                	mv	a0,s5
ffffffffc02034ba:	98aff0ef          	jal	ra,ffffffffc0202644 <page_insert>
            assert(ret == 0);
ffffffffc02034be:	d915                	beqz	a0,ffffffffc02033f2 <copy_range+0x78>
ffffffffc02034c0:	00003697          	auipc	a3,0x3
ffffffffc02034c4:	7e868693          	addi	a3,a3,2024 # ffffffffc0206ca8 <default_pmm_manager+0x760>
ffffffffc02034c8:	00003617          	auipc	a2,0x3
ffffffffc02034cc:	cd060613          	addi	a2,a2,-816 # ffffffffc0206198 <commands+0x828>
ffffffffc02034d0:	1b300593          	li	a1,435
ffffffffc02034d4:	00003517          	auipc	a0,0x3
ffffffffc02034d8:	1c450513          	addi	a0,a0,452 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02034dc:	fb3fc0ef          	jal	ra,ffffffffc020048e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02034e0:	00200637          	lui	a2,0x200
ffffffffc02034e4:	9432                	add	s0,s0,a2
ffffffffc02034e6:	ffe00637          	lui	a2,0xffe00
ffffffffc02034ea:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02034ec:	f00406e3          	beqz	s0,ffffffffc02033f8 <copy_range+0x7e>
ffffffffc02034f0:	ef2466e3          	bltu	s0,s2,ffffffffc02033dc <copy_range+0x62>
ffffffffc02034f4:	b711                	j	ffffffffc02033f8 <copy_range+0x7e>
        intr_disable();
ffffffffc02034f6:	cbefd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034fa:	000cb703          	ld	a4,0(s9)
ffffffffc02034fe:	4505                	li	a0,1
ffffffffc0203500:	6f18                	ld	a4,24(a4)
ffffffffc0203502:	9702                	jalr	a4
ffffffffc0203504:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203506:	ca8fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020350a:	bfa9                	j	ffffffffc0203464 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc020350c:	5571                	li	a0,-4
ffffffffc020350e:	b5f5                	j	ffffffffc02033fa <copy_range+0x80>
ffffffffc0203510:	86be                	mv	a3,a5
ffffffffc0203512:	00003617          	auipc	a2,0x3
ffffffffc0203516:	06e60613          	addi	a2,a2,110 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020351a:	07100593          	li	a1,113
ffffffffc020351e:	00003517          	auipc	a0,0x3
ffffffffc0203522:	08a50513          	addi	a0,a0,138 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203526:	f69fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc020352a:	00003697          	auipc	a3,0x3
ffffffffc020352e:	75e68693          	addi	a3,a3,1886 # ffffffffc0206c88 <default_pmm_manager+0x740>
ffffffffc0203532:	00003617          	auipc	a2,0x3
ffffffffc0203536:	c6660613          	addi	a2,a2,-922 # ffffffffc0206198 <commands+0x828>
ffffffffc020353a:	19400593          	li	a1,404
ffffffffc020353e:	00003517          	auipc	a0,0x3
ffffffffc0203542:	15a50513          	addi	a0,a0,346 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203546:	f49fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020354a:	00003697          	auipc	a3,0x3
ffffffffc020354e:	18e68693          	addi	a3,a3,398 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc0203552:	00003617          	auipc	a2,0x3
ffffffffc0203556:	c4660613          	addi	a2,a2,-954 # ffffffffc0206198 <commands+0x828>
ffffffffc020355a:	17c00593          	li	a1,380
ffffffffc020355e:	00003517          	auipc	a0,0x3
ffffffffc0203562:	13a50513          	addi	a0,a0,314 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203566:	f29fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc020356a:	00003697          	auipc	a3,0x3
ffffffffc020356e:	72e68693          	addi	a3,a3,1838 # ffffffffc0206c98 <default_pmm_manager+0x750>
ffffffffc0203572:	00003617          	auipc	a2,0x3
ffffffffc0203576:	c2660613          	addi	a2,a2,-986 # ffffffffc0206198 <commands+0x828>
ffffffffc020357a:	19500593          	li	a1,405
ffffffffc020357e:	00003517          	auipc	a0,0x3
ffffffffc0203582:	11a50513          	addi	a0,a0,282 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203586:	f09fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020358a:	00003617          	auipc	a2,0x3
ffffffffc020358e:	0c660613          	addi	a2,a2,198 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0203592:	06900593          	li	a1,105
ffffffffc0203596:	00003517          	auipc	a0,0x3
ffffffffc020359a:	01250513          	addi	a0,a0,18 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc020359e:	ef1fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035a2:	00003617          	auipc	a2,0x3
ffffffffc02035a6:	0ce60613          	addi	a2,a2,206 # ffffffffc0206670 <default_pmm_manager+0x128>
ffffffffc02035aa:	07f00593          	li	a1,127
ffffffffc02035ae:	00003517          	auipc	a0,0x3
ffffffffc02035b2:	ffa50513          	addi	a0,a0,-6 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02035b6:	ed9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02035ba:	00003697          	auipc	a3,0x3
ffffffffc02035be:	0ee68693          	addi	a3,a3,238 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc02035c2:	00003617          	auipc	a2,0x3
ffffffffc02035c6:	bd660613          	addi	a2,a2,-1066 # ffffffffc0206198 <commands+0x828>
ffffffffc02035ca:	17b00593          	li	a1,379
ffffffffc02035ce:	00003517          	auipc	a0,0x3
ffffffffc02035d2:	0ca50513          	addi	a0,a0,202 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02035d6:	eb9fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02035da <pgdir_alloc_page>:
{
ffffffffc02035da:	7179                	addi	sp,sp,-48
ffffffffc02035dc:	ec26                	sd	s1,24(sp)
ffffffffc02035de:	e84a                	sd	s2,16(sp)
ffffffffc02035e0:	e052                	sd	s4,0(sp)
ffffffffc02035e2:	f406                	sd	ra,40(sp)
ffffffffc02035e4:	f022                	sd	s0,32(sp)
ffffffffc02035e6:	e44e                	sd	s3,8(sp)
ffffffffc02035e8:	8a2a                	mv	s4,a0
ffffffffc02035ea:	84ae                	mv	s1,a1
ffffffffc02035ec:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035ee:	100027f3          	csrr	a5,sstatus
ffffffffc02035f2:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02035f4:	000a7997          	auipc	s3,0xa7
ffffffffc02035f8:	23498993          	addi	s3,s3,564 # ffffffffc02aa828 <pmm_manager>
ffffffffc02035fc:	ef8d                	bnez	a5,ffffffffc0203636 <pgdir_alloc_page+0x5c>
ffffffffc02035fe:	0009b783          	ld	a5,0(s3)
ffffffffc0203602:	4505                	li	a0,1
ffffffffc0203604:	6f9c                	ld	a5,24(a5)
ffffffffc0203606:	9782                	jalr	a5
ffffffffc0203608:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc020360a:	cc09                	beqz	s0,ffffffffc0203624 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020360c:	86ca                	mv	a3,s2
ffffffffc020360e:	8626                	mv	a2,s1
ffffffffc0203610:	85a2                	mv	a1,s0
ffffffffc0203612:	8552                	mv	a0,s4
ffffffffc0203614:	830ff0ef          	jal	ra,ffffffffc0202644 <page_insert>
ffffffffc0203618:	e915                	bnez	a0,ffffffffc020364c <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc020361a:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc020361c:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020361e:	4785                	li	a5,1
ffffffffc0203620:	04f71e63          	bne	a4,a5,ffffffffc020367c <pgdir_alloc_page+0xa2>
}
ffffffffc0203624:	70a2                	ld	ra,40(sp)
ffffffffc0203626:	8522                	mv	a0,s0
ffffffffc0203628:	7402                	ld	s0,32(sp)
ffffffffc020362a:	64e2                	ld	s1,24(sp)
ffffffffc020362c:	6942                	ld	s2,16(sp)
ffffffffc020362e:	69a2                	ld	s3,8(sp)
ffffffffc0203630:	6a02                	ld	s4,0(sp)
ffffffffc0203632:	6145                	addi	sp,sp,48
ffffffffc0203634:	8082                	ret
        intr_disable();
ffffffffc0203636:	b7efd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020363a:	0009b783          	ld	a5,0(s3)
ffffffffc020363e:	4505                	li	a0,1
ffffffffc0203640:	6f9c                	ld	a5,24(a5)
ffffffffc0203642:	9782                	jalr	a5
ffffffffc0203644:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203646:	b68fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020364a:	b7c1                	j	ffffffffc020360a <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020364c:	100027f3          	csrr	a5,sstatus
ffffffffc0203650:	8b89                	andi	a5,a5,2
ffffffffc0203652:	eb89                	bnez	a5,ffffffffc0203664 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203654:	0009b783          	ld	a5,0(s3)
ffffffffc0203658:	8522                	mv	a0,s0
ffffffffc020365a:	4585                	li	a1,1
ffffffffc020365c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020365e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203660:	9782                	jalr	a5
    if (flag)
ffffffffc0203662:	b7c9                	j	ffffffffc0203624 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203664:	b50fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203668:	0009b783          	ld	a5,0(s3)
ffffffffc020366c:	8522                	mv	a0,s0
ffffffffc020366e:	4585                	li	a1,1
ffffffffc0203670:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203672:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203674:	9782                	jalr	a5
        intr_enable();
ffffffffc0203676:	b38fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020367a:	b76d                	j	ffffffffc0203624 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc020367c:	00003697          	auipc	a3,0x3
ffffffffc0203680:	63c68693          	addi	a3,a3,1596 # ffffffffc0206cb8 <default_pmm_manager+0x770>
ffffffffc0203684:	00003617          	auipc	a2,0x3
ffffffffc0203688:	b1460613          	addi	a2,a2,-1260 # ffffffffc0206198 <commands+0x828>
ffffffffc020368c:	1fc00593          	li	a1,508
ffffffffc0203690:	00003517          	auipc	a0,0x3
ffffffffc0203694:	00850513          	addi	a0,a0,8 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203698:	df7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020369c <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020369c:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020369e:	00003697          	auipc	a3,0x3
ffffffffc02036a2:	63268693          	addi	a3,a3,1586 # ffffffffc0206cd0 <default_pmm_manager+0x788>
ffffffffc02036a6:	00003617          	auipc	a2,0x3
ffffffffc02036aa:	af260613          	addi	a2,a2,-1294 # ffffffffc0206198 <commands+0x828>
ffffffffc02036ae:	07400593          	li	a1,116
ffffffffc02036b2:	00003517          	auipc	a0,0x3
ffffffffc02036b6:	63e50513          	addi	a0,a0,1598 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036ba:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036bc:	dd3fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036c0 <mm_create>:
{
ffffffffc02036c0:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036c2:	04000513          	li	a0,64
{
ffffffffc02036c6:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036c8:	df6fe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
    if (mm != NULL)
ffffffffc02036cc:	cd19                	beqz	a0,ffffffffc02036ea <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036ce:	e508                	sd	a0,8(a0)
ffffffffc02036d0:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036d2:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036d6:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036da:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036de:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036e2:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036e6:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036ea:	60a2                	ld	ra,8(sp)
ffffffffc02036ec:	0141                	addi	sp,sp,16
ffffffffc02036ee:	8082                	ret

ffffffffc02036f0 <find_vma>:
{
ffffffffc02036f0:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036f2:	c505                	beqz	a0,ffffffffc020371a <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02036f4:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036f6:	c501                	beqz	a0,ffffffffc02036fe <find_vma+0xe>
ffffffffc02036f8:	651c                	ld	a5,8(a0)
ffffffffc02036fa:	02f5f263          	bgeu	a1,a5,ffffffffc020371e <find_vma+0x2e>
    return listelm->next;
ffffffffc02036fe:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203700:	00f68d63          	beq	a3,a5,ffffffffc020371a <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203704:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f4eb8>
ffffffffc0203708:	00e5e663          	bltu	a1,a4,ffffffffc0203714 <find_vma+0x24>
ffffffffc020370c:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203710:	00e5ec63          	bltu	a1,a4,ffffffffc0203728 <find_vma+0x38>
ffffffffc0203714:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203716:	fef697e3          	bne	a3,a5,ffffffffc0203704 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020371a:	4501                	li	a0,0
}
ffffffffc020371c:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020371e:	691c                	ld	a5,16(a0)
ffffffffc0203720:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02036fe <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203724:	ea88                	sd	a0,16(a3)
ffffffffc0203726:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203728:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020372c:	ea88                	sd	a0,16(a3)
ffffffffc020372e:	8082                	ret

ffffffffc0203730 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203730:	6590                	ld	a2,8(a1)
ffffffffc0203732:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_exit_out_size+0x74ee0>
{
ffffffffc0203736:	1141                	addi	sp,sp,-16
ffffffffc0203738:	e406                	sd	ra,8(sp)
ffffffffc020373a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020373c:	01066763          	bltu	a2,a6,ffffffffc020374a <insert_vma_struct+0x1a>
ffffffffc0203740:	a085                	j	ffffffffc02037a0 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203742:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203746:	04e66863          	bltu	a2,a4,ffffffffc0203796 <insert_vma_struct+0x66>
ffffffffc020374a:	86be                	mv	a3,a5
ffffffffc020374c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020374e:	fef51ae3          	bne	a0,a5,ffffffffc0203742 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203752:	02a68463          	beq	a3,a0,ffffffffc020377a <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203756:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020375a:	fe86b883          	ld	a7,-24(a3)
ffffffffc020375e:	08e8f163          	bgeu	a7,a4,ffffffffc02037e0 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203762:	04e66f63          	bltu	a2,a4,ffffffffc02037c0 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203766:	00f50a63          	beq	a0,a5,ffffffffc020377a <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020376a:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020376e:	05076963          	bltu	a4,a6,ffffffffc02037c0 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203772:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203776:	02c77363          	bgeu	a4,a2,ffffffffc020379c <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020377a:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020377c:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020377e:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203782:	e390                	sd	a2,0(a5)
ffffffffc0203784:	e690                	sd	a2,8(a3)
}
ffffffffc0203786:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203788:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020378a:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020378c:	0017079b          	addiw	a5,a4,1
ffffffffc0203790:	d11c                	sw	a5,32(a0)
}
ffffffffc0203792:	0141                	addi	sp,sp,16
ffffffffc0203794:	8082                	ret
    if (le_prev != list)
ffffffffc0203796:	fca690e3          	bne	a3,a0,ffffffffc0203756 <insert_vma_struct+0x26>
ffffffffc020379a:	bfd1                	j	ffffffffc020376e <insert_vma_struct+0x3e>
ffffffffc020379c:	f01ff0ef          	jal	ra,ffffffffc020369c <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037a0:	00003697          	auipc	a3,0x3
ffffffffc02037a4:	56068693          	addi	a3,a3,1376 # ffffffffc0206d00 <default_pmm_manager+0x7b8>
ffffffffc02037a8:	00003617          	auipc	a2,0x3
ffffffffc02037ac:	9f060613          	addi	a2,a2,-1552 # ffffffffc0206198 <commands+0x828>
ffffffffc02037b0:	07a00593          	li	a1,122
ffffffffc02037b4:	00003517          	auipc	a0,0x3
ffffffffc02037b8:	53c50513          	addi	a0,a0,1340 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02037bc:	cd3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037c0:	00003697          	auipc	a3,0x3
ffffffffc02037c4:	58068693          	addi	a3,a3,1408 # ffffffffc0206d40 <default_pmm_manager+0x7f8>
ffffffffc02037c8:	00003617          	auipc	a2,0x3
ffffffffc02037cc:	9d060613          	addi	a2,a2,-1584 # ffffffffc0206198 <commands+0x828>
ffffffffc02037d0:	07300593          	li	a1,115
ffffffffc02037d4:	00003517          	auipc	a0,0x3
ffffffffc02037d8:	51c50513          	addi	a0,a0,1308 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02037dc:	cb3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02037e0:	00003697          	auipc	a3,0x3
ffffffffc02037e4:	54068693          	addi	a3,a3,1344 # ffffffffc0206d20 <default_pmm_manager+0x7d8>
ffffffffc02037e8:	00003617          	auipc	a2,0x3
ffffffffc02037ec:	9b060613          	addi	a2,a2,-1616 # ffffffffc0206198 <commands+0x828>
ffffffffc02037f0:	07200593          	li	a1,114
ffffffffc02037f4:	00003517          	auipc	a0,0x3
ffffffffc02037f8:	4fc50513          	addi	a0,a0,1276 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02037fc:	c93fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203800 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203800:	591c                	lw	a5,48(a0)
{
ffffffffc0203802:	1141                	addi	sp,sp,-16
ffffffffc0203804:	e406                	sd	ra,8(sp)
ffffffffc0203806:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203808:	e78d                	bnez	a5,ffffffffc0203832 <mm_destroy+0x32>
ffffffffc020380a:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020380c:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020380e:	00a40c63          	beq	s0,a0,ffffffffc0203826 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203812:	6118                	ld	a4,0(a0)
ffffffffc0203814:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203816:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203818:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020381a:	e398                	sd	a4,0(a5)
ffffffffc020381c:	d52fe0ef          	jal	ra,ffffffffc0201d6e <kfree>
    return listelm->next;
ffffffffc0203820:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203822:	fea418e3          	bne	s0,a0,ffffffffc0203812 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203826:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203828:	6402                	ld	s0,0(sp)
ffffffffc020382a:	60a2                	ld	ra,8(sp)
ffffffffc020382c:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020382e:	d40fe06f          	j	ffffffffc0201d6e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203832:	00003697          	auipc	a3,0x3
ffffffffc0203836:	52e68693          	addi	a3,a3,1326 # ffffffffc0206d60 <default_pmm_manager+0x818>
ffffffffc020383a:	00003617          	auipc	a2,0x3
ffffffffc020383e:	95e60613          	addi	a2,a2,-1698 # ffffffffc0206198 <commands+0x828>
ffffffffc0203842:	09e00593          	li	a1,158
ffffffffc0203846:	00003517          	auipc	a0,0x3
ffffffffc020384a:	4aa50513          	addi	a0,a0,1194 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc020384e:	c41fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203852 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203852:	7139                	addi	sp,sp,-64
ffffffffc0203854:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203856:	6405                	lui	s0,0x1
ffffffffc0203858:	147d                	addi	s0,s0,-1
ffffffffc020385a:	77fd                	lui	a5,0xfffff
ffffffffc020385c:	9622                	add	a2,a2,s0
ffffffffc020385e:	962e                	add	a2,a2,a1
{
ffffffffc0203860:	f426                	sd	s1,40(sp)
ffffffffc0203862:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203864:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203868:	f04a                	sd	s2,32(sp)
ffffffffc020386a:	ec4e                	sd	s3,24(sp)
ffffffffc020386c:	e852                	sd	s4,16(sp)
ffffffffc020386e:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203870:	002005b7          	lui	a1,0x200
ffffffffc0203874:	00f67433          	and	s0,a2,a5
ffffffffc0203878:	06b4e363          	bltu	s1,a1,ffffffffc02038de <mm_map+0x8c>
ffffffffc020387c:	0684f163          	bgeu	s1,s0,ffffffffc02038de <mm_map+0x8c>
ffffffffc0203880:	4785                	li	a5,1
ffffffffc0203882:	07fe                	slli	a5,a5,0x1f
ffffffffc0203884:	0487ed63          	bltu	a5,s0,ffffffffc02038de <mm_map+0x8c>
ffffffffc0203888:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc020388a:	cd21                	beqz	a0,ffffffffc02038e2 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc020388c:	85a6                	mv	a1,s1
ffffffffc020388e:	8ab6                	mv	s5,a3
ffffffffc0203890:	8a3a                	mv	s4,a4
ffffffffc0203892:	e5fff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
ffffffffc0203896:	c501                	beqz	a0,ffffffffc020389e <mm_map+0x4c>
ffffffffc0203898:	651c                	ld	a5,8(a0)
ffffffffc020389a:	0487e263          	bltu	a5,s0,ffffffffc02038de <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020389e:	03000513          	li	a0,48
ffffffffc02038a2:	c1cfe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
ffffffffc02038a6:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02038a8:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02038aa:	02090163          	beqz	s2,ffffffffc02038cc <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02038ae:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02038b0:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02038b4:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02038b8:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02038bc:	85ca                	mv	a1,s2
ffffffffc02038be:	e73ff0ef          	jal	ra,ffffffffc0203730 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02038c2:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02038c4:	000a0463          	beqz	s4,ffffffffc02038cc <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02038c8:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>

out:
    return ret;
}
ffffffffc02038cc:	70e2                	ld	ra,56(sp)
ffffffffc02038ce:	7442                	ld	s0,48(sp)
ffffffffc02038d0:	74a2                	ld	s1,40(sp)
ffffffffc02038d2:	7902                	ld	s2,32(sp)
ffffffffc02038d4:	69e2                	ld	s3,24(sp)
ffffffffc02038d6:	6a42                	ld	s4,16(sp)
ffffffffc02038d8:	6aa2                	ld	s5,8(sp)
ffffffffc02038da:	6121                	addi	sp,sp,64
ffffffffc02038dc:	8082                	ret
        return -E_INVAL;
ffffffffc02038de:	5575                	li	a0,-3
ffffffffc02038e0:	b7f5                	j	ffffffffc02038cc <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02038e2:	00003697          	auipc	a3,0x3
ffffffffc02038e6:	49668693          	addi	a3,a3,1174 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc02038ea:	00003617          	auipc	a2,0x3
ffffffffc02038ee:	8ae60613          	addi	a2,a2,-1874 # ffffffffc0206198 <commands+0x828>
ffffffffc02038f2:	0b300593          	li	a1,179
ffffffffc02038f6:	00003517          	auipc	a0,0x3
ffffffffc02038fa:	3fa50513          	addi	a0,a0,1018 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02038fe:	b91fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203902 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203902:	7139                	addi	sp,sp,-64
ffffffffc0203904:	fc06                	sd	ra,56(sp)
ffffffffc0203906:	f822                	sd	s0,48(sp)
ffffffffc0203908:	f426                	sd	s1,40(sp)
ffffffffc020390a:	f04a                	sd	s2,32(sp)
ffffffffc020390c:	ec4e                	sd	s3,24(sp)
ffffffffc020390e:	e852                	sd	s4,16(sp)
ffffffffc0203910:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203912:	c52d                	beqz	a0,ffffffffc020397c <dup_mmap+0x7a>
ffffffffc0203914:	892a                	mv	s2,a0
ffffffffc0203916:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203918:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc020391a:	e595                	bnez	a1,ffffffffc0203946 <dup_mmap+0x44>
ffffffffc020391c:	a085                	j	ffffffffc020397c <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020391e:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203920:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ed8>
        vma->vm_end = vm_end;
ffffffffc0203924:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203928:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc020392c:	e05ff0ef          	jal	ra,ffffffffc0203730 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203930:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc8>
ffffffffc0203934:	fe843603          	ld	a2,-24(s0)
ffffffffc0203938:	6c8c                	ld	a1,24(s1)
ffffffffc020393a:	01893503          	ld	a0,24(s2)
ffffffffc020393e:	4701                	li	a4,0
ffffffffc0203940:	a3bff0ef          	jal	ra,ffffffffc020337a <copy_range>
ffffffffc0203944:	e105                	bnez	a0,ffffffffc0203964 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203946:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203948:	02848863          	beq	s1,s0,ffffffffc0203978 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020394c:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203950:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203954:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203958:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020395c:	b62fe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
ffffffffc0203960:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203962:	fd55                	bnez	a0,ffffffffc020391e <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203964:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203966:	70e2                	ld	ra,56(sp)
ffffffffc0203968:	7442                	ld	s0,48(sp)
ffffffffc020396a:	74a2                	ld	s1,40(sp)
ffffffffc020396c:	7902                	ld	s2,32(sp)
ffffffffc020396e:	69e2                	ld	s3,24(sp)
ffffffffc0203970:	6a42                	ld	s4,16(sp)
ffffffffc0203972:	6aa2                	ld	s5,8(sp)
ffffffffc0203974:	6121                	addi	sp,sp,64
ffffffffc0203976:	8082                	ret
    return 0;
ffffffffc0203978:	4501                	li	a0,0
ffffffffc020397a:	b7f5                	j	ffffffffc0203966 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc020397c:	00003697          	auipc	a3,0x3
ffffffffc0203980:	40c68693          	addi	a3,a3,1036 # ffffffffc0206d88 <default_pmm_manager+0x840>
ffffffffc0203984:	00003617          	auipc	a2,0x3
ffffffffc0203988:	81460613          	addi	a2,a2,-2028 # ffffffffc0206198 <commands+0x828>
ffffffffc020398c:	0cf00593          	li	a1,207
ffffffffc0203990:	00003517          	auipc	a0,0x3
ffffffffc0203994:	36050513          	addi	a0,a0,864 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203998:	af7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020399c <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc020399c:	1101                	addi	sp,sp,-32
ffffffffc020399e:	ec06                	sd	ra,24(sp)
ffffffffc02039a0:	e822                	sd	s0,16(sp)
ffffffffc02039a2:	e426                	sd	s1,8(sp)
ffffffffc02039a4:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039a6:	c531                	beqz	a0,ffffffffc02039f2 <exit_mmap+0x56>
ffffffffc02039a8:	591c                	lw	a5,48(a0)
ffffffffc02039aa:	84aa                	mv	s1,a0
ffffffffc02039ac:	e3b9                	bnez	a5,ffffffffc02039f2 <exit_mmap+0x56>
    return listelm->next;
ffffffffc02039ae:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02039b0:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039b4:	02850663          	beq	a0,s0,ffffffffc02039e0 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039b8:	ff043603          	ld	a2,-16(s0)
ffffffffc02039bc:	fe843583          	ld	a1,-24(s0)
ffffffffc02039c0:	854a                	mv	a0,s2
ffffffffc02039c2:	80ffe0ef          	jal	ra,ffffffffc02021d0 <unmap_range>
ffffffffc02039c6:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039c8:	fe8498e3          	bne	s1,s0,ffffffffc02039b8 <exit_mmap+0x1c>
ffffffffc02039cc:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039ce:	00848c63          	beq	s1,s0,ffffffffc02039e6 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039d2:	ff043603          	ld	a2,-16(s0)
ffffffffc02039d6:	fe843583          	ld	a1,-24(s0)
ffffffffc02039da:	854a                	mv	a0,s2
ffffffffc02039dc:	93bfe0ef          	jal	ra,ffffffffc0202316 <exit_range>
ffffffffc02039e0:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039e2:	fe8498e3          	bne	s1,s0,ffffffffc02039d2 <exit_mmap+0x36>
    }
}
ffffffffc02039e6:	60e2                	ld	ra,24(sp)
ffffffffc02039e8:	6442                	ld	s0,16(sp)
ffffffffc02039ea:	64a2                	ld	s1,8(sp)
ffffffffc02039ec:	6902                	ld	s2,0(sp)
ffffffffc02039ee:	6105                	addi	sp,sp,32
ffffffffc02039f0:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039f2:	00003697          	auipc	a3,0x3
ffffffffc02039f6:	3b668693          	addi	a3,a3,950 # ffffffffc0206da8 <default_pmm_manager+0x860>
ffffffffc02039fa:	00002617          	auipc	a2,0x2
ffffffffc02039fe:	79e60613          	addi	a2,a2,1950 # ffffffffc0206198 <commands+0x828>
ffffffffc0203a02:	0e800593          	li	a1,232
ffffffffc0203a06:	00003517          	auipc	a0,0x3
ffffffffc0203a0a:	2ea50513          	addi	a0,a0,746 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203a0e:	a81fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a12 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203a12:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a14:	04000513          	li	a0,64
{
ffffffffc0203a18:	fc06                	sd	ra,56(sp)
ffffffffc0203a1a:	f822                	sd	s0,48(sp)
ffffffffc0203a1c:	f426                	sd	s1,40(sp)
ffffffffc0203a1e:	f04a                	sd	s2,32(sp)
ffffffffc0203a20:	ec4e                	sd	s3,24(sp)
ffffffffc0203a22:	e852                	sd	s4,16(sp)
ffffffffc0203a24:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a26:	a98fe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
    if (mm != NULL)
ffffffffc0203a2a:	2e050663          	beqz	a0,ffffffffc0203d16 <vmm_init+0x304>
ffffffffc0203a2e:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203a30:	e508                	sd	a0,8(a0)
ffffffffc0203a32:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a34:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a38:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a3c:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a40:	02053423          	sd	zero,40(a0)
ffffffffc0203a44:	02052823          	sw	zero,48(a0)
ffffffffc0203a48:	02053c23          	sd	zero,56(a0)
ffffffffc0203a4c:	03200413          	li	s0,50
ffffffffc0203a50:	a811                	j	ffffffffc0203a64 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203a52:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a54:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a56:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a5a:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a5c:	8526                	mv	a0,s1
ffffffffc0203a5e:	cd3ff0ef          	jal	ra,ffffffffc0203730 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a62:	c80d                	beqz	s0,ffffffffc0203a94 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a64:	03000513          	li	a0,48
ffffffffc0203a68:	a56fe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
ffffffffc0203a6c:	85aa                	mv	a1,a0
ffffffffc0203a6e:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a72:	f165                	bnez	a0,ffffffffc0203a52 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203a74:	00003697          	auipc	a3,0x3
ffffffffc0203a78:	4cc68693          	addi	a3,a3,1228 # ffffffffc0206f40 <default_pmm_manager+0x9f8>
ffffffffc0203a7c:	00002617          	auipc	a2,0x2
ffffffffc0203a80:	71c60613          	addi	a2,a2,1820 # ffffffffc0206198 <commands+0x828>
ffffffffc0203a84:	12c00593          	li	a1,300
ffffffffc0203a88:	00003517          	auipc	a0,0x3
ffffffffc0203a8c:	26850513          	addi	a0,a0,616 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203a90:	9fffc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203a94:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a98:	1f900913          	li	s2,505
ffffffffc0203a9c:	a819                	j	ffffffffc0203ab2 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203a9e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203aa0:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203aa2:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aa6:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203aa8:	8526                	mv	a0,s1
ffffffffc0203aaa:	c87ff0ef          	jal	ra,ffffffffc0203730 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aae:	03240a63          	beq	s0,s2,ffffffffc0203ae2 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ab2:	03000513          	li	a0,48
ffffffffc0203ab6:	a08fe0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
ffffffffc0203aba:	85aa                	mv	a1,a0
ffffffffc0203abc:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203ac0:	fd79                	bnez	a0,ffffffffc0203a9e <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203ac2:	00003697          	auipc	a3,0x3
ffffffffc0203ac6:	47e68693          	addi	a3,a3,1150 # ffffffffc0206f40 <default_pmm_manager+0x9f8>
ffffffffc0203aca:	00002617          	auipc	a2,0x2
ffffffffc0203ace:	6ce60613          	addi	a2,a2,1742 # ffffffffc0206198 <commands+0x828>
ffffffffc0203ad2:	13300593          	li	a1,307
ffffffffc0203ad6:	00003517          	auipc	a0,0x3
ffffffffc0203ada:	21a50513          	addi	a0,a0,538 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203ade:	9b1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203ae2:	649c                	ld	a5,8(s1)
ffffffffc0203ae4:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203ae6:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203aea:	16f48663          	beq	s1,a5,ffffffffc0203c56 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203aee:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd54794>
ffffffffc0203af2:	ffe70693          	addi	a3,a4,-2
ffffffffc0203af6:	10d61063          	bne	a2,a3,ffffffffc0203bf6 <vmm_init+0x1e4>
ffffffffc0203afa:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203afe:	0ed71c63          	bne	a4,a3,ffffffffc0203bf6 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203b02:	0715                	addi	a4,a4,5
ffffffffc0203b04:	679c                	ld	a5,8(a5)
ffffffffc0203b06:	feb712e3          	bne	a4,a1,ffffffffc0203aea <vmm_init+0xd8>
ffffffffc0203b0a:	4a1d                	li	s4,7
ffffffffc0203b0c:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b0e:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b12:	85a2                	mv	a1,s0
ffffffffc0203b14:	8526                	mv	a0,s1
ffffffffc0203b16:	bdbff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
ffffffffc0203b1a:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b1c:	16050d63          	beqz	a0,ffffffffc0203c96 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b20:	00140593          	addi	a1,s0,1
ffffffffc0203b24:	8526                	mv	a0,s1
ffffffffc0203b26:	bcbff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
ffffffffc0203b2a:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b2c:	14050563          	beqz	a0,ffffffffc0203c76 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203b30:	85d2                	mv	a1,s4
ffffffffc0203b32:	8526                	mv	a0,s1
ffffffffc0203b34:	bbdff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b38:	16051f63          	bnez	a0,ffffffffc0203cb6 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b3c:	00340593          	addi	a1,s0,3
ffffffffc0203b40:	8526                	mv	a0,s1
ffffffffc0203b42:	bafff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b46:	1a051863          	bnez	a0,ffffffffc0203cf6 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b4a:	00440593          	addi	a1,s0,4
ffffffffc0203b4e:	8526                	mv	a0,s1
ffffffffc0203b50:	ba1ff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b54:	18051163          	bnez	a0,ffffffffc0203cd6 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b58:	00893783          	ld	a5,8(s2)
ffffffffc0203b5c:	0a879d63          	bne	a5,s0,ffffffffc0203c16 <vmm_init+0x204>
ffffffffc0203b60:	01093783          	ld	a5,16(s2)
ffffffffc0203b64:	0b479963          	bne	a5,s4,ffffffffc0203c16 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b68:	0089b783          	ld	a5,8(s3)
ffffffffc0203b6c:	0c879563          	bne	a5,s0,ffffffffc0203c36 <vmm_init+0x224>
ffffffffc0203b70:	0109b783          	ld	a5,16(s3)
ffffffffc0203b74:	0d479163          	bne	a5,s4,ffffffffc0203c36 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b78:	0415                	addi	s0,s0,5
ffffffffc0203b7a:	0a15                	addi	s4,s4,5
ffffffffc0203b7c:	f9541be3          	bne	s0,s5,ffffffffc0203b12 <vmm_init+0x100>
ffffffffc0203b80:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b82:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b84:	85a2                	mv	a1,s0
ffffffffc0203b86:	8526                	mv	a0,s1
ffffffffc0203b88:	b69ff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
ffffffffc0203b8c:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203b90:	c90d                	beqz	a0,ffffffffc0203bc2 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203b92:	6914                	ld	a3,16(a0)
ffffffffc0203b94:	6510                	ld	a2,8(a0)
ffffffffc0203b96:	00003517          	auipc	a0,0x3
ffffffffc0203b9a:	33250513          	addi	a0,a0,818 # ffffffffc0206ec8 <default_pmm_manager+0x980>
ffffffffc0203b9e:	df6fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203ba2:	00003697          	auipc	a3,0x3
ffffffffc0203ba6:	34e68693          	addi	a3,a3,846 # ffffffffc0206ef0 <default_pmm_manager+0x9a8>
ffffffffc0203baa:	00002617          	auipc	a2,0x2
ffffffffc0203bae:	5ee60613          	addi	a2,a2,1518 # ffffffffc0206198 <commands+0x828>
ffffffffc0203bb2:	15900593          	li	a1,345
ffffffffc0203bb6:	00003517          	auipc	a0,0x3
ffffffffc0203bba:	13a50513          	addi	a0,a0,314 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203bbe:	8d1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203bc2:	147d                	addi	s0,s0,-1
ffffffffc0203bc4:	fd2410e3          	bne	s0,s2,ffffffffc0203b84 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203bc8:	8526                	mv	a0,s1
ffffffffc0203bca:	c37ff0ef          	jal	ra,ffffffffc0203800 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203bce:	00003517          	auipc	a0,0x3
ffffffffc0203bd2:	33a50513          	addi	a0,a0,826 # ffffffffc0206f08 <default_pmm_manager+0x9c0>
ffffffffc0203bd6:	dbefc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203bda:	7442                	ld	s0,48(sp)
ffffffffc0203bdc:	70e2                	ld	ra,56(sp)
ffffffffc0203bde:	74a2                	ld	s1,40(sp)
ffffffffc0203be0:	7902                	ld	s2,32(sp)
ffffffffc0203be2:	69e2                	ld	s3,24(sp)
ffffffffc0203be4:	6a42                	ld	s4,16(sp)
ffffffffc0203be6:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203be8:	00003517          	auipc	a0,0x3
ffffffffc0203bec:	34050513          	addi	a0,a0,832 # ffffffffc0206f28 <default_pmm_manager+0x9e0>
}
ffffffffc0203bf0:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bf2:	da2fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203bf6:	00003697          	auipc	a3,0x3
ffffffffc0203bfa:	1ea68693          	addi	a3,a3,490 # ffffffffc0206de0 <default_pmm_manager+0x898>
ffffffffc0203bfe:	00002617          	auipc	a2,0x2
ffffffffc0203c02:	59a60613          	addi	a2,a2,1434 # ffffffffc0206198 <commands+0x828>
ffffffffc0203c06:	13d00593          	li	a1,317
ffffffffc0203c0a:	00003517          	auipc	a0,0x3
ffffffffc0203c0e:	0e650513          	addi	a0,a0,230 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c12:	87dfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c16:	00003697          	auipc	a3,0x3
ffffffffc0203c1a:	25268693          	addi	a3,a3,594 # ffffffffc0206e68 <default_pmm_manager+0x920>
ffffffffc0203c1e:	00002617          	auipc	a2,0x2
ffffffffc0203c22:	57a60613          	addi	a2,a2,1402 # ffffffffc0206198 <commands+0x828>
ffffffffc0203c26:	14e00593          	li	a1,334
ffffffffc0203c2a:	00003517          	auipc	a0,0x3
ffffffffc0203c2e:	0c650513          	addi	a0,a0,198 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c32:	85dfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c36:	00003697          	auipc	a3,0x3
ffffffffc0203c3a:	26268693          	addi	a3,a3,610 # ffffffffc0206e98 <default_pmm_manager+0x950>
ffffffffc0203c3e:	00002617          	auipc	a2,0x2
ffffffffc0203c42:	55a60613          	addi	a2,a2,1370 # ffffffffc0206198 <commands+0x828>
ffffffffc0203c46:	14f00593          	li	a1,335
ffffffffc0203c4a:	00003517          	auipc	a0,0x3
ffffffffc0203c4e:	0a650513          	addi	a0,a0,166 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c52:	83dfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c56:	00003697          	auipc	a3,0x3
ffffffffc0203c5a:	17268693          	addi	a3,a3,370 # ffffffffc0206dc8 <default_pmm_manager+0x880>
ffffffffc0203c5e:	00002617          	auipc	a2,0x2
ffffffffc0203c62:	53a60613          	addi	a2,a2,1338 # ffffffffc0206198 <commands+0x828>
ffffffffc0203c66:	13b00593          	li	a1,315
ffffffffc0203c6a:	00003517          	auipc	a0,0x3
ffffffffc0203c6e:	08650513          	addi	a0,a0,134 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c72:	81dfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203c76:	00003697          	auipc	a3,0x3
ffffffffc0203c7a:	1b268693          	addi	a3,a3,434 # ffffffffc0206e28 <default_pmm_manager+0x8e0>
ffffffffc0203c7e:	00002617          	auipc	a2,0x2
ffffffffc0203c82:	51a60613          	addi	a2,a2,1306 # ffffffffc0206198 <commands+0x828>
ffffffffc0203c86:	14600593          	li	a1,326
ffffffffc0203c8a:	00003517          	auipc	a0,0x3
ffffffffc0203c8e:	06650513          	addi	a0,a0,102 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c92:	ffcfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203c96:	00003697          	auipc	a3,0x3
ffffffffc0203c9a:	18268693          	addi	a3,a3,386 # ffffffffc0206e18 <default_pmm_manager+0x8d0>
ffffffffc0203c9e:	00002617          	auipc	a2,0x2
ffffffffc0203ca2:	4fa60613          	addi	a2,a2,1274 # ffffffffc0206198 <commands+0x828>
ffffffffc0203ca6:	14400593          	li	a1,324
ffffffffc0203caa:	00003517          	auipc	a0,0x3
ffffffffc0203cae:	04650513          	addi	a0,a0,70 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cb2:	fdcfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203cb6:	00003697          	auipc	a3,0x3
ffffffffc0203cba:	18268693          	addi	a3,a3,386 # ffffffffc0206e38 <default_pmm_manager+0x8f0>
ffffffffc0203cbe:	00002617          	auipc	a2,0x2
ffffffffc0203cc2:	4da60613          	addi	a2,a2,1242 # ffffffffc0206198 <commands+0x828>
ffffffffc0203cc6:	14800593          	li	a1,328
ffffffffc0203cca:	00003517          	auipc	a0,0x3
ffffffffc0203cce:	02650513          	addi	a0,a0,38 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cd2:	fbcfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203cd6:	00003697          	auipc	a3,0x3
ffffffffc0203cda:	18268693          	addi	a3,a3,386 # ffffffffc0206e58 <default_pmm_manager+0x910>
ffffffffc0203cde:	00002617          	auipc	a2,0x2
ffffffffc0203ce2:	4ba60613          	addi	a2,a2,1210 # ffffffffc0206198 <commands+0x828>
ffffffffc0203ce6:	14c00593          	li	a1,332
ffffffffc0203cea:	00003517          	auipc	a0,0x3
ffffffffc0203cee:	00650513          	addi	a0,a0,6 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cf2:	f9cfc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203cf6:	00003697          	auipc	a3,0x3
ffffffffc0203cfa:	15268693          	addi	a3,a3,338 # ffffffffc0206e48 <default_pmm_manager+0x900>
ffffffffc0203cfe:	00002617          	auipc	a2,0x2
ffffffffc0203d02:	49a60613          	addi	a2,a2,1178 # ffffffffc0206198 <commands+0x828>
ffffffffc0203d06:	14a00593          	li	a1,330
ffffffffc0203d0a:	00003517          	auipc	a0,0x3
ffffffffc0203d0e:	fe650513          	addi	a0,a0,-26 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203d12:	f7cfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203d16:	00003697          	auipc	a3,0x3
ffffffffc0203d1a:	06268693          	addi	a3,a3,98 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc0203d1e:	00002617          	auipc	a2,0x2
ffffffffc0203d22:	47a60613          	addi	a2,a2,1146 # ffffffffc0206198 <commands+0x828>
ffffffffc0203d26:	12400593          	li	a1,292
ffffffffc0203d2a:	00003517          	auipc	a0,0x3
ffffffffc0203d2e:	fc650513          	addi	a0,a0,-58 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203d32:	f5cfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d36 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d36:	7179                	addi	sp,sp,-48
ffffffffc0203d38:	f022                	sd	s0,32(sp)
ffffffffc0203d3a:	f406                	sd	ra,40(sp)
ffffffffc0203d3c:	ec26                	sd	s1,24(sp)
ffffffffc0203d3e:	e84a                	sd	s2,16(sp)
ffffffffc0203d40:	e44e                	sd	s3,8(sp)
ffffffffc0203d42:	e052                	sd	s4,0(sp)
ffffffffc0203d44:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d46:	c135                	beqz	a0,ffffffffc0203daa <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d48:	002007b7          	lui	a5,0x200
ffffffffc0203d4c:	04f5e663          	bltu	a1,a5,ffffffffc0203d98 <user_mem_check+0x62>
ffffffffc0203d50:	00c584b3          	add	s1,a1,a2
ffffffffc0203d54:	0495f263          	bgeu	a1,s1,ffffffffc0203d98 <user_mem_check+0x62>
ffffffffc0203d58:	4785                	li	a5,1
ffffffffc0203d5a:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d5c:	0297ee63          	bltu	a5,s1,ffffffffc0203d98 <user_mem_check+0x62>
ffffffffc0203d60:	892a                	mv	s2,a0
ffffffffc0203d62:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d64:	6a05                	lui	s4,0x1
ffffffffc0203d66:	a821                	j	ffffffffc0203d7e <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d68:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d6c:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d6e:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d70:	c685                	beqz	a3,ffffffffc0203d98 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d72:	c399                	beqz	a5,ffffffffc0203d78 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d74:	02e46263          	bltu	s0,a4,ffffffffc0203d98 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d78:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d7a:	04947663          	bgeu	s0,s1,ffffffffc0203dc6 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d7e:	85a2                	mv	a1,s0
ffffffffc0203d80:	854a                	mv	a0,s2
ffffffffc0203d82:	96fff0ef          	jal	ra,ffffffffc02036f0 <find_vma>
ffffffffc0203d86:	c909                	beqz	a0,ffffffffc0203d98 <user_mem_check+0x62>
ffffffffc0203d88:	6518                	ld	a4,8(a0)
ffffffffc0203d8a:	00e46763          	bltu	s0,a4,ffffffffc0203d98 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d8e:	4d1c                	lw	a5,24(a0)
ffffffffc0203d90:	fc099ce3          	bnez	s3,ffffffffc0203d68 <user_mem_check+0x32>
ffffffffc0203d94:	8b85                	andi	a5,a5,1
ffffffffc0203d96:	f3ed                	bnez	a5,ffffffffc0203d78 <user_mem_check+0x42>
            return 0;
ffffffffc0203d98:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d9a:	70a2                	ld	ra,40(sp)
ffffffffc0203d9c:	7402                	ld	s0,32(sp)
ffffffffc0203d9e:	64e2                	ld	s1,24(sp)
ffffffffc0203da0:	6942                	ld	s2,16(sp)
ffffffffc0203da2:	69a2                	ld	s3,8(sp)
ffffffffc0203da4:	6a02                	ld	s4,0(sp)
ffffffffc0203da6:	6145                	addi	sp,sp,48
ffffffffc0203da8:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203daa:	c02007b7          	lui	a5,0xc0200
ffffffffc0203dae:	4501                	li	a0,0
ffffffffc0203db0:	fef5e5e3          	bltu	a1,a5,ffffffffc0203d9a <user_mem_check+0x64>
ffffffffc0203db4:	962e                	add	a2,a2,a1
ffffffffc0203db6:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203d9a <user_mem_check+0x64>
ffffffffc0203dba:	c8000537          	lui	a0,0xc8000
ffffffffc0203dbe:	0505                	addi	a0,a0,1
ffffffffc0203dc0:	00a63533          	sltu	a0,a2,a0
ffffffffc0203dc4:	bfd9                	j	ffffffffc0203d9a <user_mem_check+0x64>
        return 1;
ffffffffc0203dc6:	4505                	li	a0,1
ffffffffc0203dc8:	bfc9                	j	ffffffffc0203d9a <user_mem_check+0x64>

ffffffffc0203dca <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203dca:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203dcc:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dce:	63e000ef          	jal	ra,ffffffffc020440c <do_exit>

ffffffffc0203dd2 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203dd2:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203dd4:	10800513          	li	a0,264
{
ffffffffc0203dd8:	e022                	sd	s0,0(sp)
ffffffffc0203dda:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ddc:	ee3fd0ef          	jal	ra,ffffffffc0201cbe <kmalloc>
ffffffffc0203de0:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203de2:	c929                	beqz	a0,ffffffffc0203e34 <alloc_proc+0x62>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 初始化进程状态为未初始化
        proc->state = PROC_UNINIT;
ffffffffc0203de4:	57fd                	li	a5,-1
ffffffffc0203de6:	1782                	slli	a5,a5,0x20
ffffffffc0203de8:	e11c                	sd	a5,0(a0)
        // 初始化父进程指针为NULL
        proc->parent = NULL;
        // 初始化内存管理结构为NULL
        proc->mm = NULL;
        // 初始化上下文结构（全部设为0）
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203dea:	07000613          	li	a2,112
ffffffffc0203dee:	4581                	li	a1,0
        proc->pgdir = 0;//turned into uninit status     
ffffffffc0203df0:	0a053423          	sd	zero,168(a0) # ffffffffc80000a8 <end+0x7d55854>
        proc->runs = 0;
ffffffffc0203df4:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203df8:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203dfc:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203e00:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203e04:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e08:	03050513          	addi	a0,a0,48
ffffffffc0203e0c:	0cd010ef          	jal	ra,ffffffffc02056d8 <memset>
        // 初始化陷阱帧指针为NULL
        proc->tf = NULL;
        // 初始化进程标志为0
        proc->flags = 0;
        // 初始化进程名称为空字符串
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0203e10:	4641                	li	a2,16
        proc->tf = NULL;
ffffffffc0203e12:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203e16:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0203e1a:	4581                	li	a1,0
ffffffffc0203e1c:	0b440513          	addi	a0,s0,180
ffffffffc0203e20:	0b9010ef          	jal	ra,ffffffffc02056d8 <memset>
        // 初始化等待状态为0
        proc->wait_state = 0;
ffffffffc0203e24:	0e042623          	sw	zero,236(s0)
        // 初始化进程关系指针为NULL
        proc->cptr = NULL;
ffffffffc0203e28:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc0203e2c:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0203e30:	0e043c23          	sd	zero,248(s0)
    }
    return proc;
}
ffffffffc0203e34:	60a2                	ld	ra,8(sp)
ffffffffc0203e36:	8522                	mv	a0,s0
ffffffffc0203e38:	6402                	ld	s0,0(sp)
ffffffffc0203e3a:	0141                	addi	sp,sp,16
ffffffffc0203e3c:	8082                	ret

ffffffffc0203e3e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e3e:	000a7797          	auipc	a5,0xa7
ffffffffc0203e42:	9fa7b783          	ld	a5,-1542(a5) # ffffffffc02aa838 <current>
ffffffffc0203e46:	73c8                	ld	a0,160(a5)
ffffffffc0203e48:	8eafd06f          	j	ffffffffc0200f32 <forkrets>

ffffffffc0203e4c <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e4c:	000a7797          	auipc	a5,0xa7
ffffffffc0203e50:	9ec7b783          	ld	a5,-1556(a5) # ffffffffc02aa838 <current>
ffffffffc0203e54:	43cc                	lw	a1,4(a5)
{
ffffffffc0203e56:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e58:	00003617          	auipc	a2,0x3
ffffffffc0203e5c:	0f860613          	addi	a2,a2,248 # ffffffffc0206f50 <default_pmm_manager+0xa08>
ffffffffc0203e60:	00003517          	auipc	a0,0x3
ffffffffc0203e64:	10050513          	addi	a0,a0,256 # ffffffffc0206f60 <default_pmm_manager+0xa18>
{
ffffffffc0203e68:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e6a:	b2afc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203e6e:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203e72:	b0a78793          	addi	a5,a5,-1270 # a978 <_binary_obj___user_forktest_out_size>
ffffffffc0203e76:	e43e                	sd	a5,8(sp)
ffffffffc0203e78:	00003517          	auipc	a0,0x3
ffffffffc0203e7c:	0d850513          	addi	a0,a0,216 # ffffffffc0206f50 <default_pmm_manager+0xa08>
ffffffffc0203e80:	00046797          	auipc	a5,0x46
ffffffffc0203e84:	8e078793          	addi	a5,a5,-1824 # ffffffffc0249760 <_binary_obj___user_forktest_out_start>
ffffffffc0203e88:	f03e                	sd	a5,32(sp)
ffffffffc0203e8a:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203e8c:	e802                	sd	zero,16(sp)
ffffffffc0203e8e:	7a8010ef          	jal	ra,ffffffffc0205636 <strlen>
ffffffffc0203e92:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203e94:	4511                	li	a0,4
ffffffffc0203e96:	55a2                	lw	a1,40(sp)
ffffffffc0203e98:	4662                	lw	a2,24(sp)
ffffffffc0203e9a:	5682                	lw	a3,32(sp)
ffffffffc0203e9c:	4722                	lw	a4,8(sp)
ffffffffc0203e9e:	48a9                	li	a7,10
ffffffffc0203ea0:	9002                	ebreak
ffffffffc0203ea2:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203ea4:	65c2                	ld	a1,16(sp)
ffffffffc0203ea6:	00003517          	auipc	a0,0x3
ffffffffc0203eaa:	0e250513          	addi	a0,a0,226 # ffffffffc0206f88 <default_pmm_manager+0xa40>
ffffffffc0203eae:	ae6fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0203eb2:	00003617          	auipc	a2,0x3
ffffffffc0203eb6:	0e660613          	addi	a2,a2,230 # ffffffffc0206f98 <default_pmm_manager+0xa50>
ffffffffc0203eba:	3ce00593          	li	a1,974
ffffffffc0203ebe:	00003517          	auipc	a0,0x3
ffffffffc0203ec2:	0fa50513          	addi	a0,a0,250 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0203ec6:	dc8fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203eca <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203eca:	6d14                	ld	a3,24(a0)
{
ffffffffc0203ecc:	1141                	addi	sp,sp,-16
ffffffffc0203ece:	e406                	sd	ra,8(sp)
ffffffffc0203ed0:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ed4:	02f6ee63          	bltu	a3,a5,ffffffffc0203f10 <put_pgdir+0x46>
ffffffffc0203ed8:	000a7517          	auipc	a0,0xa7
ffffffffc0203edc:	95853503          	ld	a0,-1704(a0) # ffffffffc02aa830 <va_pa_offset>
ffffffffc0203ee0:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203ee2:	82b1                	srli	a3,a3,0xc
ffffffffc0203ee4:	000a7797          	auipc	a5,0xa7
ffffffffc0203ee8:	9347b783          	ld	a5,-1740(a5) # ffffffffc02aa818 <npage>
ffffffffc0203eec:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f28 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203ef0:	00004517          	auipc	a0,0x4
ffffffffc0203ef4:	97853503          	ld	a0,-1672(a0) # ffffffffc0207868 <nbase>
}
ffffffffc0203ef8:	60a2                	ld	ra,8(sp)
ffffffffc0203efa:	8e89                	sub	a3,a3,a0
ffffffffc0203efc:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203efe:	000a7517          	auipc	a0,0xa7
ffffffffc0203f02:	92253503          	ld	a0,-1758(a0) # ffffffffc02aa820 <pages>
ffffffffc0203f06:	4585                	li	a1,1
ffffffffc0203f08:	9536                	add	a0,a0,a3
}
ffffffffc0203f0a:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f0c:	fcffd06f          	j	ffffffffc0201eda <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f10:	00002617          	auipc	a2,0x2
ffffffffc0203f14:	71860613          	addi	a2,a2,1816 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0203f18:	07700593          	li	a1,119
ffffffffc0203f1c:	00002517          	auipc	a0,0x2
ffffffffc0203f20:	68c50513          	addi	a0,a0,1676 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203f24:	d6afc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f28:	00002617          	auipc	a2,0x2
ffffffffc0203f2c:	72860613          	addi	a2,a2,1832 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0203f30:	06900593          	li	a1,105
ffffffffc0203f34:	00002517          	auipc	a0,0x2
ffffffffc0203f38:	67450513          	addi	a0,a0,1652 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203f3c:	d52fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f40 <proc_run>:
{
ffffffffc0203f40:	7179                	addi	sp,sp,-48
ffffffffc0203f42:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f44:	000a7917          	auipc	s2,0xa7
ffffffffc0203f48:	8f490913          	addi	s2,s2,-1804 # ffffffffc02aa838 <current>
{
ffffffffc0203f4c:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f4e:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f52:	f406                	sd	ra,40(sp)
ffffffffc0203f54:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f56:	02a48963          	beq	s1,a0,ffffffffc0203f88 <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f5a:	100027f3          	csrr	a5,sstatus
ffffffffc0203f5e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203f60:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f62:	e7a9                	bnez	a5,ffffffffc0203fac <proc_run+0x6c>
        if (proc->pgdir != 0) {
ffffffffc0203f64:	755c                	ld	a5,168(a0)
        current = proc;
ffffffffc0203f66:	00a93023          	sd	a0,0(s2)
        if (proc->pgdir != 0) {
ffffffffc0203f6a:	c78d                	beqz	a5,ffffffffc0203f94 <proc_run+0x54>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203f6c:	577d                	li	a4,-1
ffffffffc0203f6e:	177e                	slli	a4,a4,0x3f
ffffffffc0203f70:	83b1                	srli	a5,a5,0xc
ffffffffc0203f72:	8fd9                	or	a5,a5,a4
ffffffffc0203f74:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));//in switch.S,store and load some reg
ffffffffc0203f78:	03050593          	addi	a1,a0,48
ffffffffc0203f7c:	03048513          	addi	a0,s1,48
ffffffffc0203f80:	05c010ef          	jal	ra,ffffffffc0204fdc <switch_to>
    if (flag)
ffffffffc0203f84:	00099d63          	bnez	s3,ffffffffc0203f9e <proc_run+0x5e>
}
ffffffffc0203f88:	70a2                	ld	ra,40(sp)
ffffffffc0203f8a:	7482                	ld	s1,32(sp)
ffffffffc0203f8c:	6962                	ld	s2,24(sp)
ffffffffc0203f8e:	69c2                	ld	s3,16(sp)
ffffffffc0203f90:	6145                	addi	sp,sp,48
ffffffffc0203f92:	8082                	ret
ffffffffc0203f94:	000a7797          	auipc	a5,0xa7
ffffffffc0203f98:	8747b783          	ld	a5,-1932(a5) # ffffffffc02aa808 <boot_pgdir_pa>
ffffffffc0203f9c:	bfc1                	j	ffffffffc0203f6c <proc_run+0x2c>
ffffffffc0203f9e:	70a2                	ld	ra,40(sp)
ffffffffc0203fa0:	7482                	ld	s1,32(sp)
ffffffffc0203fa2:	6962                	ld	s2,24(sp)
ffffffffc0203fa4:	69c2                	ld	s3,16(sp)
ffffffffc0203fa6:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203fa8:	a07fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203fac:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203fae:	a07fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203fb2:	6522                	ld	a0,8(sp)
ffffffffc0203fb4:	4985                	li	s3,1
ffffffffc0203fb6:	b77d                	j	ffffffffc0203f64 <proc_run+0x24>

ffffffffc0203fb8 <do_fork>:
{
ffffffffc0203fb8:	7119                	addi	sp,sp,-128
ffffffffc0203fba:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fbc:	000a7917          	auipc	s2,0xa7
ffffffffc0203fc0:	89490913          	addi	s2,s2,-1900 # ffffffffc02aa850 <nr_process>
ffffffffc0203fc4:	00092703          	lw	a4,0(s2)
{
ffffffffc0203fc8:	fc86                	sd	ra,120(sp)
ffffffffc0203fca:	f8a2                	sd	s0,112(sp)
ffffffffc0203fcc:	f4a6                	sd	s1,104(sp)
ffffffffc0203fce:	ecce                	sd	s3,88(sp)
ffffffffc0203fd0:	e8d2                	sd	s4,80(sp)
ffffffffc0203fd2:	e4d6                	sd	s5,72(sp)
ffffffffc0203fd4:	e0da                	sd	s6,64(sp)
ffffffffc0203fd6:	fc5e                	sd	s7,56(sp)
ffffffffc0203fd8:	f862                	sd	s8,48(sp)
ffffffffc0203fda:	f466                	sd	s9,40(sp)
ffffffffc0203fdc:	f06a                	sd	s10,32(sp)
ffffffffc0203fde:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fe0:	6785                	lui	a5,0x1
ffffffffc0203fe2:	32f75b63          	bge	a4,a5,ffffffffc0204318 <do_fork+0x360>
ffffffffc0203fe6:	8a2a                	mv	s4,a0
ffffffffc0203fe8:	89ae                	mv	s3,a1
ffffffffc0203fea:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203fec:	de7ff0ef          	jal	ra,ffffffffc0203dd2 <alloc_proc>
ffffffffc0203ff0:	84aa                	mv	s1,a0
ffffffffc0203ff2:	30050463          	beqz	a0,ffffffffc02042fa <do_fork+0x342>
    proc->parent=current;
ffffffffc0203ff6:	000a7c17          	auipc	s8,0xa7
ffffffffc0203ffa:	842c0c13          	addi	s8,s8,-1982 # ffffffffc02aa838 <current>
ffffffffc0203ffe:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state==0);
ffffffffc0204002:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8acc>
    proc->parent=current;
ffffffffc0204006:	f11c                	sd	a5,32(a0)
    assert(current->wait_state==0);
ffffffffc0204008:	30071d63          	bnez	a4,ffffffffc0204322 <do_fork+0x36a>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020400c:	4509                	li	a0,2
ffffffffc020400e:	e8ffd0ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
    if (page != NULL)
ffffffffc0204012:	2e050163          	beqz	a0,ffffffffc02042f4 <do_fork+0x33c>
    return page - pages + nbase;
ffffffffc0204016:	000a7a97          	auipc	s5,0xa7
ffffffffc020401a:	80aa8a93          	addi	s5,s5,-2038 # ffffffffc02aa820 <pages>
ffffffffc020401e:	000ab683          	ld	a3,0(s5)
ffffffffc0204022:	00004b17          	auipc	s6,0x4
ffffffffc0204026:	846b0b13          	addi	s6,s6,-1978 # ffffffffc0207868 <nbase>
ffffffffc020402a:	000b3783          	ld	a5,0(s6)
ffffffffc020402e:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204032:	000a6b97          	auipc	s7,0xa6
ffffffffc0204036:	7e6b8b93          	addi	s7,s7,2022 # ffffffffc02aa818 <npage>
    return page - pages + nbase;
ffffffffc020403a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020403c:	5dfd                	li	s11,-1
ffffffffc020403e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204042:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204044:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204048:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020404c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020404e:	2ee67a63          	bgeu	a2,a4,ffffffffc0204342 <do_fork+0x38a>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204052:	000c3603          	ld	a2,0(s8)
ffffffffc0204056:	000a6c17          	auipc	s8,0xa6
ffffffffc020405a:	7dac0c13          	addi	s8,s8,2010 # ffffffffc02aa830 <va_pa_offset>
ffffffffc020405e:	000c3703          	ld	a4,0(s8)
ffffffffc0204062:	02863d03          	ld	s10,40(a2)
ffffffffc0204066:	e43e                	sd	a5,8(sp)
ffffffffc0204068:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020406a:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc020406c:	020d0863          	beqz	s10,ffffffffc020409c <do_fork+0xe4>
    if (clone_flags & CLONE_VM)
ffffffffc0204070:	100a7a13          	andi	s4,s4,256
ffffffffc0204074:	1c0a0163          	beqz	s4,ffffffffc0204236 <do_fork+0x27e>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204078:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020407c:	018d3783          	ld	a5,24(s10)
ffffffffc0204080:	c02006b7          	lui	a3,0xc0200
ffffffffc0204084:	2705                	addiw	a4,a4,1
ffffffffc0204086:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc020408a:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020408e:	2ed7e263          	bltu	a5,a3,ffffffffc0204372 <do_fork+0x3ba>
ffffffffc0204092:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204096:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204098:	8f99                	sub	a5,a5,a4
ffffffffc020409a:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020409c:	6789                	lui	a5,0x2
ffffffffc020409e:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>
ffffffffc02040a2:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02040a4:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040a6:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02040a8:	87b6                	mv	a5,a3
ffffffffc02040aa:	12040893          	addi	a7,s0,288
ffffffffc02040ae:	00063803          	ld	a6,0(a2)
ffffffffc02040b2:	6608                	ld	a0,8(a2)
ffffffffc02040b4:	6a0c                	ld	a1,16(a2)
ffffffffc02040b6:	6e18                	ld	a4,24(a2)
ffffffffc02040b8:	0107b023          	sd	a6,0(a5)
ffffffffc02040bc:	e788                	sd	a0,8(a5)
ffffffffc02040be:	eb8c                	sd	a1,16(a5)
ffffffffc02040c0:	ef98                	sd	a4,24(a5)
ffffffffc02040c2:	02060613          	addi	a2,a2,32
ffffffffc02040c6:	02078793          	addi	a5,a5,32
ffffffffc02040ca:	ff1612e3          	bne	a2,a7,ffffffffc02040ae <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc02040ce:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040d2:	12098f63          	beqz	s3,ffffffffc0204210 <do_fork+0x258>
ffffffffc02040d6:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040da:	00000797          	auipc	a5,0x0
ffffffffc02040de:	d6478793          	addi	a5,a5,-668 # ffffffffc0203e3e <forkret>
ffffffffc02040e2:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02040e4:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040e6:	100027f3          	csrr	a5,sstatus
ffffffffc02040ea:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02040ec:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040ee:	14079063          	bnez	a5,ffffffffc020422e <do_fork+0x276>
    if (++last_pid >= MAX_PID)
ffffffffc02040f2:	000a2817          	auipc	a6,0xa2
ffffffffc02040f6:	2ae80813          	addi	a6,a6,686 # ffffffffc02a63a0 <last_pid.1>
ffffffffc02040fa:	00082783          	lw	a5,0(a6)
ffffffffc02040fe:	6709                	lui	a4,0x2
ffffffffc0204100:	0017851b          	addiw	a0,a5,1
ffffffffc0204104:	00a82023          	sw	a0,0(a6)
ffffffffc0204108:	08e55d63          	bge	a0,a4,ffffffffc02041a2 <do_fork+0x1ea>
    if (last_pid >= next_safe)
ffffffffc020410c:	000a2317          	auipc	t1,0xa2
ffffffffc0204110:	29830313          	addi	t1,t1,664 # ffffffffc02a63a4 <next_safe.0>
ffffffffc0204114:	00032783          	lw	a5,0(t1)
ffffffffc0204118:	000a6417          	auipc	s0,0xa6
ffffffffc020411c:	6a840413          	addi	s0,s0,1704 # ffffffffc02aa7c0 <proc_list>
ffffffffc0204120:	08f55963          	bge	a0,a5,ffffffffc02041b2 <do_fork+0x1fa>
    proc->pid = get_pid();
ffffffffc0204124:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204126:	45a9                	li	a1,10
ffffffffc0204128:	2501                	sext.w	a0,a0
ffffffffc020412a:	108010ef          	jal	ra,ffffffffc0205232 <hash32>
ffffffffc020412e:	02051793          	slli	a5,a0,0x20
ffffffffc0204132:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204136:	000a2797          	auipc	a5,0xa2
ffffffffc020413a:	68a78793          	addi	a5,a5,1674 # ffffffffc02a67c0 <hash_list>
ffffffffc020413e:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204140:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204142:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204144:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0204148:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020414a:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020414c:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020414e:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204150:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0204154:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204156:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0204158:	e21c                	sd	a5,0(a2)
ffffffffc020415a:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc020415c:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc020415e:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204160:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204164:	10e4b023          	sd	a4,256(s1)
ffffffffc0204168:	c311                	beqz	a4,ffffffffc020416c <do_fork+0x1b4>
        proc->optr->yptr = proc;
ffffffffc020416a:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc020416c:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0204170:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204172:	2785                	addiw	a5,a5,1
ffffffffc0204174:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc0204178:	18099363          	bnez	s3,ffffffffc02042fe <do_fork+0x346>
    wakeup_proc(proc);
ffffffffc020417c:	8526                	mv	a0,s1
ffffffffc020417e:	6c9000ef          	jal	ra,ffffffffc0205046 <wakeup_proc>
    ret = proc->pid;
ffffffffc0204182:	40c8                	lw	a0,4(s1)
}
ffffffffc0204184:	70e6                	ld	ra,120(sp)
ffffffffc0204186:	7446                	ld	s0,112(sp)
ffffffffc0204188:	74a6                	ld	s1,104(sp)
ffffffffc020418a:	7906                	ld	s2,96(sp)
ffffffffc020418c:	69e6                	ld	s3,88(sp)
ffffffffc020418e:	6a46                	ld	s4,80(sp)
ffffffffc0204190:	6aa6                	ld	s5,72(sp)
ffffffffc0204192:	6b06                	ld	s6,64(sp)
ffffffffc0204194:	7be2                	ld	s7,56(sp)
ffffffffc0204196:	7c42                	ld	s8,48(sp)
ffffffffc0204198:	7ca2                	ld	s9,40(sp)
ffffffffc020419a:	7d02                	ld	s10,32(sp)
ffffffffc020419c:	6de2                	ld	s11,24(sp)
ffffffffc020419e:	6109                	addi	sp,sp,128
ffffffffc02041a0:	8082                	ret
        last_pid = 1;
ffffffffc02041a2:	4785                	li	a5,1
ffffffffc02041a4:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041a8:	4505                	li	a0,1
ffffffffc02041aa:	000a2317          	auipc	t1,0xa2
ffffffffc02041ae:	1fa30313          	addi	t1,t1,506 # ffffffffc02a63a4 <next_safe.0>
    return listelm->next;
ffffffffc02041b2:	000a6417          	auipc	s0,0xa6
ffffffffc02041b6:	60e40413          	addi	s0,s0,1550 # ffffffffc02aa7c0 <proc_list>
ffffffffc02041ba:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02041be:	6789                	lui	a5,0x2
ffffffffc02041c0:	00f32023          	sw	a5,0(t1)
ffffffffc02041c4:	86aa                	mv	a3,a0
ffffffffc02041c6:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02041c8:	6e89                	lui	t4,0x2
ffffffffc02041ca:	148e0263          	beq	t3,s0,ffffffffc020430e <do_fork+0x356>
ffffffffc02041ce:	88ae                	mv	a7,a1
ffffffffc02041d0:	87f2                	mv	a5,t3
ffffffffc02041d2:	6609                	lui	a2,0x2
ffffffffc02041d4:	a811                	j	ffffffffc02041e8 <do_fork+0x230>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02041d6:	00e6d663          	bge	a3,a4,ffffffffc02041e2 <do_fork+0x22a>
ffffffffc02041da:	00c75463          	bge	a4,a2,ffffffffc02041e2 <do_fork+0x22a>
ffffffffc02041de:	863a                	mv	a2,a4
ffffffffc02041e0:	4885                	li	a7,1
ffffffffc02041e2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02041e4:	00878d63          	beq	a5,s0,ffffffffc02041fe <do_fork+0x246>
            if (proc->pid == last_pid)
ffffffffc02041e8:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc02041ec:	fed715e3          	bne	a4,a3,ffffffffc02041d6 <do_fork+0x21e>
                if (++last_pid >= next_safe)
ffffffffc02041f0:	2685                	addiw	a3,a3,1
ffffffffc02041f2:	10c6d963          	bge	a3,a2,ffffffffc0204304 <do_fork+0x34c>
ffffffffc02041f6:	679c                	ld	a5,8(a5)
ffffffffc02041f8:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02041fa:	fe8797e3          	bne	a5,s0,ffffffffc02041e8 <do_fork+0x230>
ffffffffc02041fe:	c581                	beqz	a1,ffffffffc0204206 <do_fork+0x24e>
ffffffffc0204200:	00d82023          	sw	a3,0(a6)
ffffffffc0204204:	8536                	mv	a0,a3
ffffffffc0204206:	f0088fe3          	beqz	a7,ffffffffc0204124 <do_fork+0x16c>
ffffffffc020420a:	00c32023          	sw	a2,0(t1)
ffffffffc020420e:	bf19                	j	ffffffffc0204124 <do_fork+0x16c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204210:	89b6                	mv	s3,a3
ffffffffc0204212:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204216:	00000797          	auipc	a5,0x0
ffffffffc020421a:	c2878793          	addi	a5,a5,-984 # ffffffffc0203e3e <forkret>
ffffffffc020421e:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204220:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204222:	100027f3          	csrr	a5,sstatus
ffffffffc0204226:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204228:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020422a:	ec0784e3          	beqz	a5,ffffffffc02040f2 <do_fork+0x13a>
        intr_disable();
ffffffffc020422e:	f86fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204232:	4985                	li	s3,1
ffffffffc0204234:	bd7d                	j	ffffffffc02040f2 <do_fork+0x13a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204236:	c8aff0ef          	jal	ra,ffffffffc02036c0 <mm_create>
ffffffffc020423a:	8caa                	mv	s9,a0
ffffffffc020423c:	c541                	beqz	a0,ffffffffc02042c4 <do_fork+0x30c>
    if ((page = alloc_page()) == NULL)
ffffffffc020423e:	4505                	li	a0,1
ffffffffc0204240:	c5dfd0ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc0204244:	cd2d                	beqz	a0,ffffffffc02042be <do_fork+0x306>
    return page - pages + nbase;
ffffffffc0204246:	000ab683          	ld	a3,0(s5)
ffffffffc020424a:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020424c:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204250:	40d506b3          	sub	a3,a0,a3
ffffffffc0204254:	8699                	srai	a3,a3,0x6
ffffffffc0204256:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204258:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020425c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020425e:	0eedf263          	bgeu	s11,a4,ffffffffc0204342 <do_fork+0x38a>
ffffffffc0204262:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204266:	6605                	lui	a2,0x1
ffffffffc0204268:	000a6597          	auipc	a1,0xa6
ffffffffc020426c:	5a85b583          	ld	a1,1448(a1) # ffffffffc02aa810 <boot_pgdir_va>
ffffffffc0204270:	9a36                	add	s4,s4,a3
ffffffffc0204272:	8552                	mv	a0,s4
ffffffffc0204274:	476010ef          	jal	ra,ffffffffc02056ea <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204278:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc020427c:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204280:	4785                	li	a5,1
ffffffffc0204282:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204286:	8b85                	andi	a5,a5,1
ffffffffc0204288:	4a05                	li	s4,1
ffffffffc020428a:	c799                	beqz	a5,ffffffffc0204298 <do_fork+0x2e0>
    {
        schedule();
ffffffffc020428c:	63b000ef          	jal	ra,ffffffffc02050c6 <schedule>
ffffffffc0204290:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204294:	8b85                	andi	a5,a5,1
ffffffffc0204296:	fbfd                	bnez	a5,ffffffffc020428c <do_fork+0x2d4>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204298:	85ea                	mv	a1,s10
ffffffffc020429a:	8566                	mv	a0,s9
ffffffffc020429c:	e66ff0ef          	jal	ra,ffffffffc0203902 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02042a0:	57f9                	li	a5,-2
ffffffffc02042a2:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02042a6:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02042a8:	0e078e63          	beqz	a5,ffffffffc02043a4 <do_fork+0x3ec>
good_mm:
ffffffffc02042ac:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02042ae:	dc0505e3          	beqz	a0,ffffffffc0204078 <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc02042b2:	8566                	mv	a0,s9
ffffffffc02042b4:	ee8ff0ef          	jal	ra,ffffffffc020399c <exit_mmap>
    put_pgdir(mm);
ffffffffc02042b8:	8566                	mv	a0,s9
ffffffffc02042ba:	c11ff0ef          	jal	ra,ffffffffc0203eca <put_pgdir>
    mm_destroy(mm);
ffffffffc02042be:	8566                	mv	a0,s9
ffffffffc02042c0:	d40ff0ef          	jal	ra,ffffffffc0203800 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042c4:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02042c6:	c02007b7          	lui	a5,0xc0200
ffffffffc02042ca:	0cf6e163          	bltu	a3,a5,ffffffffc020438c <do_fork+0x3d4>
ffffffffc02042ce:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02042d2:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042d6:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042da:	83b1                	srli	a5,a5,0xc
ffffffffc02042dc:	06e7ff63          	bgeu	a5,a4,ffffffffc020435a <do_fork+0x3a2>
    return &pages[PPN(pa) - nbase];
ffffffffc02042e0:	000b3703          	ld	a4,0(s6)
ffffffffc02042e4:	000ab503          	ld	a0,0(s5)
ffffffffc02042e8:	4589                	li	a1,2
ffffffffc02042ea:	8f99                	sub	a5,a5,a4
ffffffffc02042ec:	079a                	slli	a5,a5,0x6
ffffffffc02042ee:	953e                	add	a0,a0,a5
ffffffffc02042f0:	bebfd0ef          	jal	ra,ffffffffc0201eda <free_pages>
    kfree(proc);
ffffffffc02042f4:	8526                	mv	a0,s1
ffffffffc02042f6:	a79fd0ef          	jal	ra,ffffffffc0201d6e <kfree>
    ret = -E_NO_MEM;
ffffffffc02042fa:	5571                	li	a0,-4
    return ret;
ffffffffc02042fc:	b561                	j	ffffffffc0204184 <do_fork+0x1cc>
        intr_enable();
ffffffffc02042fe:	eb0fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204302:	bdad                	j	ffffffffc020417c <do_fork+0x1c4>
                    if (last_pid >= MAX_PID)
ffffffffc0204304:	01d6c363          	blt	a3,t4,ffffffffc020430a <do_fork+0x352>
                        last_pid = 1;
ffffffffc0204308:	4685                	li	a3,1
                    goto repeat;
ffffffffc020430a:	4585                	li	a1,1
ffffffffc020430c:	bd7d                	j	ffffffffc02041ca <do_fork+0x212>
ffffffffc020430e:	c599                	beqz	a1,ffffffffc020431c <do_fork+0x364>
ffffffffc0204310:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204314:	8536                	mv	a0,a3
ffffffffc0204316:	b539                	j	ffffffffc0204124 <do_fork+0x16c>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204318:	556d                	li	a0,-5
ffffffffc020431a:	b5ad                	j	ffffffffc0204184 <do_fork+0x1cc>
    return last_pid;
ffffffffc020431c:	00082503          	lw	a0,0(a6)
ffffffffc0204320:	b511                	j	ffffffffc0204124 <do_fork+0x16c>
    assert(current->wait_state==0);
ffffffffc0204322:	00003697          	auipc	a3,0x3
ffffffffc0204326:	cae68693          	addi	a3,a3,-850 # ffffffffc0206fd0 <default_pmm_manager+0xa88>
ffffffffc020432a:	00002617          	auipc	a2,0x2
ffffffffc020432e:	e6e60613          	addi	a2,a2,-402 # ffffffffc0206198 <commands+0x828>
ffffffffc0204332:	1e400593          	li	a1,484
ffffffffc0204336:	00003517          	auipc	a0,0x3
ffffffffc020433a:	c8250513          	addi	a0,a0,-894 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020433e:	950fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204342:	00002617          	auipc	a2,0x2
ffffffffc0204346:	23e60613          	addi	a2,a2,574 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020434a:	07100593          	li	a1,113
ffffffffc020434e:	00002517          	auipc	a0,0x2
ffffffffc0204352:	25a50513          	addi	a0,a0,602 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204356:	938fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020435a:	00002617          	auipc	a2,0x2
ffffffffc020435e:	2f660613          	addi	a2,a2,758 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0204362:	06900593          	li	a1,105
ffffffffc0204366:	00002517          	auipc	a0,0x2
ffffffffc020436a:	24250513          	addi	a0,a0,578 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc020436e:	920fc0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204372:	86be                	mv	a3,a5
ffffffffc0204374:	00002617          	auipc	a2,0x2
ffffffffc0204378:	2b460613          	addi	a2,a2,692 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc020437c:	1a300593          	li	a1,419
ffffffffc0204380:	00003517          	auipc	a0,0x3
ffffffffc0204384:	c3850513          	addi	a0,a0,-968 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204388:	906fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020438c:	00002617          	auipc	a2,0x2
ffffffffc0204390:	29c60613          	addi	a2,a2,668 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0204394:	07700593          	li	a1,119
ffffffffc0204398:	00002517          	auipc	a0,0x2
ffffffffc020439c:	21050513          	addi	a0,a0,528 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02043a0:	8eefc0ef          	jal	ra,ffffffffc020048e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02043a4:	00003617          	auipc	a2,0x3
ffffffffc02043a8:	c4460613          	addi	a2,a2,-956 # ffffffffc0206fe8 <default_pmm_manager+0xaa0>
ffffffffc02043ac:	03f00593          	li	a1,63
ffffffffc02043b0:	00003517          	auipc	a0,0x3
ffffffffc02043b4:	c4850513          	addi	a0,a0,-952 # ffffffffc0206ff8 <default_pmm_manager+0xab0>
ffffffffc02043b8:	8d6fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02043bc <kernel_thread>:
{
ffffffffc02043bc:	7129                	addi	sp,sp,-320
ffffffffc02043be:	fa22                	sd	s0,304(sp)
ffffffffc02043c0:	f626                	sd	s1,296(sp)
ffffffffc02043c2:	f24a                	sd	s2,288(sp)
ffffffffc02043c4:	84ae                	mv	s1,a1
ffffffffc02043c6:	892a                	mv	s2,a0
ffffffffc02043c8:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043ca:	4581                	li	a1,0
ffffffffc02043cc:	12000613          	li	a2,288
ffffffffc02043d0:	850a                	mv	a0,sp
{
ffffffffc02043d2:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043d4:	304010ef          	jal	ra,ffffffffc02056d8 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043d8:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043da:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043dc:	100027f3          	csrr	a5,sstatus
ffffffffc02043e0:	edd7f793          	andi	a5,a5,-291
ffffffffc02043e4:	1207e793          	ori	a5,a5,288
ffffffffc02043e8:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043ea:	860a                	mv	a2,sp
ffffffffc02043ec:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043f0:	00000797          	auipc	a5,0x0
ffffffffc02043f4:	9da78793          	addi	a5,a5,-1574 # ffffffffc0203dca <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043f8:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043fa:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043fc:	bbdff0ef          	jal	ra,ffffffffc0203fb8 <do_fork>
}
ffffffffc0204400:	70f2                	ld	ra,312(sp)
ffffffffc0204402:	7452                	ld	s0,304(sp)
ffffffffc0204404:	74b2                	ld	s1,296(sp)
ffffffffc0204406:	7912                	ld	s2,288(sp)
ffffffffc0204408:	6131                	addi	sp,sp,320
ffffffffc020440a:	8082                	ret

ffffffffc020440c <do_exit>:
{
ffffffffc020440c:	7179                	addi	sp,sp,-48
ffffffffc020440e:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204410:	000a6417          	auipc	s0,0xa6
ffffffffc0204414:	42840413          	addi	s0,s0,1064 # ffffffffc02aa838 <current>
ffffffffc0204418:	601c                	ld	a5,0(s0)
{
ffffffffc020441a:	f406                	sd	ra,40(sp)
ffffffffc020441c:	ec26                	sd	s1,24(sp)
ffffffffc020441e:	e84a                	sd	s2,16(sp)
ffffffffc0204420:	e44e                	sd	s3,8(sp)
ffffffffc0204422:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204424:	000a6717          	auipc	a4,0xa6
ffffffffc0204428:	41c73703          	ld	a4,1052(a4) # ffffffffc02aa840 <idleproc>
ffffffffc020442c:	0ce78c63          	beq	a5,a4,ffffffffc0204504 <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204430:	000a6497          	auipc	s1,0xa6
ffffffffc0204434:	41848493          	addi	s1,s1,1048 # ffffffffc02aa848 <initproc>
ffffffffc0204438:	6098                	ld	a4,0(s1)
ffffffffc020443a:	0ee78b63          	beq	a5,a4,ffffffffc0204530 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc020443e:	0287b983          	ld	s3,40(a5)
ffffffffc0204442:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204444:	02098663          	beqz	s3,ffffffffc0204470 <do_exit+0x64>
ffffffffc0204448:	000a6797          	auipc	a5,0xa6
ffffffffc020444c:	3c07b783          	ld	a5,960(a5) # ffffffffc02aa808 <boot_pgdir_pa>
ffffffffc0204450:	577d                	li	a4,-1
ffffffffc0204452:	177e                	slli	a4,a4,0x3f
ffffffffc0204454:	83b1                	srli	a5,a5,0xc
ffffffffc0204456:	8fd9                	or	a5,a5,a4
ffffffffc0204458:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020445c:	0309a783          	lw	a5,48(s3)
ffffffffc0204460:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204464:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204468:	cb55                	beqz	a4,ffffffffc020451c <do_exit+0x110>
        current->mm = NULL;
ffffffffc020446a:	601c                	ld	a5,0(s0)
ffffffffc020446c:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204470:	601c                	ld	a5,0(s0)
ffffffffc0204472:	470d                	li	a4,3
ffffffffc0204474:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204476:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020447a:	100027f3          	csrr	a5,sstatus
ffffffffc020447e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204480:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204482:	e3f9                	bnez	a5,ffffffffc0204548 <do_exit+0x13c>
        proc = current->parent;
ffffffffc0204484:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204486:	800007b7          	lui	a5,0x80000
ffffffffc020448a:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020448c:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc020448e:	0ec52703          	lw	a4,236(a0)
ffffffffc0204492:	0af70f63          	beq	a4,a5,ffffffffc0204550 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204496:	6018                	ld	a4,0(s0)
ffffffffc0204498:	7b7c                	ld	a5,240(a4)
ffffffffc020449a:	c3a1                	beqz	a5,ffffffffc02044da <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020449c:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044a0:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044a2:	0985                	addi	s3,s3,1
ffffffffc02044a4:	a021                	j	ffffffffc02044ac <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02044a6:	6018                	ld	a4,0(s0)
ffffffffc02044a8:	7b7c                	ld	a5,240(a4)
ffffffffc02044aa:	cb85                	beqz	a5,ffffffffc02044da <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02044ac:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fd0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b0:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02044b2:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b4:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02044b6:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044ba:	10e7b023          	sd	a4,256(a5)
ffffffffc02044be:	c311                	beqz	a4,ffffffffc02044c2 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02044c0:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044c2:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02044c4:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02044c6:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044c8:	fd271fe3          	bne	a4,s2,ffffffffc02044a6 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044cc:	0ec52783          	lw	a5,236(a0)
ffffffffc02044d0:	fd379be3          	bne	a5,s3,ffffffffc02044a6 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02044d4:	373000ef          	jal	ra,ffffffffc0205046 <wakeup_proc>
ffffffffc02044d8:	b7f9                	j	ffffffffc02044a6 <do_exit+0x9a>
    if (flag)
ffffffffc02044da:	020a1263          	bnez	s4,ffffffffc02044fe <do_exit+0xf2>
    schedule();
ffffffffc02044de:	3e9000ef          	jal	ra,ffffffffc02050c6 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044e2:	601c                	ld	a5,0(s0)
ffffffffc02044e4:	00003617          	auipc	a2,0x3
ffffffffc02044e8:	b4c60613          	addi	a2,a2,-1204 # ffffffffc0207030 <default_pmm_manager+0xae8>
ffffffffc02044ec:	24e00593          	li	a1,590
ffffffffc02044f0:	43d4                	lw	a3,4(a5)
ffffffffc02044f2:	00003517          	auipc	a0,0x3
ffffffffc02044f6:	ac650513          	addi	a0,a0,-1338 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02044fa:	f95fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02044fe:	cb0fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204502:	bff1                	j	ffffffffc02044de <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204504:	00003617          	auipc	a2,0x3
ffffffffc0204508:	b0c60613          	addi	a2,a2,-1268 # ffffffffc0207010 <default_pmm_manager+0xac8>
ffffffffc020450c:	21a00593          	li	a1,538
ffffffffc0204510:	00003517          	auipc	a0,0x3
ffffffffc0204514:	aa850513          	addi	a0,a0,-1368 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204518:	f77fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc020451c:	854e                	mv	a0,s3
ffffffffc020451e:	c7eff0ef          	jal	ra,ffffffffc020399c <exit_mmap>
            put_pgdir(mm);
ffffffffc0204522:	854e                	mv	a0,s3
ffffffffc0204524:	9a7ff0ef          	jal	ra,ffffffffc0203eca <put_pgdir>
            mm_destroy(mm);
ffffffffc0204528:	854e                	mv	a0,s3
ffffffffc020452a:	ad6ff0ef          	jal	ra,ffffffffc0203800 <mm_destroy>
ffffffffc020452e:	bf35                	j	ffffffffc020446a <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204530:	00003617          	auipc	a2,0x3
ffffffffc0204534:	af060613          	addi	a2,a2,-1296 # ffffffffc0207020 <default_pmm_manager+0xad8>
ffffffffc0204538:	21e00593          	li	a1,542
ffffffffc020453c:	00003517          	auipc	a0,0x3
ffffffffc0204540:	a7c50513          	addi	a0,a0,-1412 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204544:	f4bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204548:	c6cfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020454c:	4a05                	li	s4,1
ffffffffc020454e:	bf1d                	j	ffffffffc0204484 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204550:	2f7000ef          	jal	ra,ffffffffc0205046 <wakeup_proc>
ffffffffc0204554:	b789                	j	ffffffffc0204496 <do_exit+0x8a>

ffffffffc0204556 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204556:	715d                	addi	sp,sp,-80
ffffffffc0204558:	f84a                	sd	s2,48(sp)
ffffffffc020455a:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc020455c:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204560:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204562:	fc26                	sd	s1,56(sp)
ffffffffc0204564:	f052                	sd	s4,32(sp)
ffffffffc0204566:	ec56                	sd	s5,24(sp)
ffffffffc0204568:	e85a                	sd	s6,16(sp)
ffffffffc020456a:	e45e                	sd	s7,8(sp)
ffffffffc020456c:	e486                	sd	ra,72(sp)
ffffffffc020456e:	e0a2                	sd	s0,64(sp)
ffffffffc0204570:	84aa                	mv	s1,a0
ffffffffc0204572:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204574:	000a6b97          	auipc	s7,0xa6
ffffffffc0204578:	2c4b8b93          	addi	s7,s7,708 # ffffffffc02aa838 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc020457c:	00050b1b          	sext.w	s6,a0
ffffffffc0204580:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204584:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204586:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204588:	ccbd                	beqz	s1,ffffffffc0204606 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc020458a:	0359e863          	bltu	s3,s5,ffffffffc02045ba <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020458e:	45a9                	li	a1,10
ffffffffc0204590:	855a                	mv	a0,s6
ffffffffc0204592:	4a1000ef          	jal	ra,ffffffffc0205232 <hash32>
ffffffffc0204596:	02051793          	slli	a5,a0,0x20
ffffffffc020459a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020459e:	000a2797          	auipc	a5,0xa2
ffffffffc02045a2:	22278793          	addi	a5,a5,546 # ffffffffc02a67c0 <hash_list>
ffffffffc02045a6:	953e                	add	a0,a0,a5
ffffffffc02045a8:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02045aa:	a029                	j	ffffffffc02045b4 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02045ac:	f2c42783          	lw	a5,-212(s0)
ffffffffc02045b0:	02978163          	beq	a5,s1,ffffffffc02045d2 <do_wait.part.0+0x7c>
ffffffffc02045b4:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02045b6:	fe851be3          	bne	a0,s0,ffffffffc02045ac <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02045ba:	5579                	li	a0,-2
}
ffffffffc02045bc:	60a6                	ld	ra,72(sp)
ffffffffc02045be:	6406                	ld	s0,64(sp)
ffffffffc02045c0:	74e2                	ld	s1,56(sp)
ffffffffc02045c2:	7942                	ld	s2,48(sp)
ffffffffc02045c4:	79a2                	ld	s3,40(sp)
ffffffffc02045c6:	7a02                	ld	s4,32(sp)
ffffffffc02045c8:	6ae2                	ld	s5,24(sp)
ffffffffc02045ca:	6b42                	ld	s6,16(sp)
ffffffffc02045cc:	6ba2                	ld	s7,8(sp)
ffffffffc02045ce:	6161                	addi	sp,sp,80
ffffffffc02045d0:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045d2:	000bb683          	ld	a3,0(s7)
ffffffffc02045d6:	f4843783          	ld	a5,-184(s0)
ffffffffc02045da:	fed790e3          	bne	a5,a3,ffffffffc02045ba <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045de:	f2842703          	lw	a4,-216(s0)
ffffffffc02045e2:	478d                	li	a5,3
ffffffffc02045e4:	0ef70b63          	beq	a4,a5,ffffffffc02046da <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045e8:	4785                	li	a5,1
ffffffffc02045ea:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045ec:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02045f0:	2d7000ef          	jal	ra,ffffffffc02050c6 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045f4:	000bb783          	ld	a5,0(s7)
ffffffffc02045f8:	0b07a783          	lw	a5,176(a5)
ffffffffc02045fc:	8b85                	andi	a5,a5,1
ffffffffc02045fe:	d7c9                	beqz	a5,ffffffffc0204588 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204600:	555d                	li	a0,-9
ffffffffc0204602:	e0bff0ef          	jal	ra,ffffffffc020440c <do_exit>
        proc = current->cptr;
ffffffffc0204606:	000bb683          	ld	a3,0(s7)
ffffffffc020460a:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020460c:	d45d                	beqz	s0,ffffffffc02045ba <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020460e:	470d                	li	a4,3
ffffffffc0204610:	a021                	j	ffffffffc0204618 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204612:	10043403          	ld	s0,256(s0)
ffffffffc0204616:	d869                	beqz	s0,ffffffffc02045e8 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204618:	401c                	lw	a5,0(s0)
ffffffffc020461a:	fee79ce3          	bne	a5,a4,ffffffffc0204612 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc020461e:	000a6797          	auipc	a5,0xa6
ffffffffc0204622:	2227b783          	ld	a5,546(a5) # ffffffffc02aa840 <idleproc>
ffffffffc0204626:	0c878963          	beq	a5,s0,ffffffffc02046f8 <do_wait.part.0+0x1a2>
ffffffffc020462a:	000a6797          	auipc	a5,0xa6
ffffffffc020462e:	21e7b783          	ld	a5,542(a5) # ffffffffc02aa848 <initproc>
ffffffffc0204632:	0cf40363          	beq	s0,a5,ffffffffc02046f8 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204636:	000a0663          	beqz	s4,ffffffffc0204642 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020463a:	0e842783          	lw	a5,232(s0)
ffffffffc020463e:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204642:	100027f3          	csrr	a5,sstatus
ffffffffc0204646:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204648:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020464a:	e7c1                	bnez	a5,ffffffffc02046d2 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020464c:	6c70                	ld	a2,216(s0)
ffffffffc020464e:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204650:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204654:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204656:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204658:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020465a:	6470                	ld	a2,200(s0)
ffffffffc020465c:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020465e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204660:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204662:	c319                	beqz	a4,ffffffffc0204668 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204664:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204666:	7c7c                	ld	a5,248(s0)
ffffffffc0204668:	c3b5                	beqz	a5,ffffffffc02046cc <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020466a:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc020466e:	000a6717          	auipc	a4,0xa6
ffffffffc0204672:	1e270713          	addi	a4,a4,482 # ffffffffc02aa850 <nr_process>
ffffffffc0204676:	431c                	lw	a5,0(a4)
ffffffffc0204678:	37fd                	addiw	a5,a5,-1
ffffffffc020467a:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020467c:	e5a9                	bnez	a1,ffffffffc02046c6 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020467e:	6814                	ld	a3,16(s0)
ffffffffc0204680:	c02007b7          	lui	a5,0xc0200
ffffffffc0204684:	04f6ee63          	bltu	a3,a5,ffffffffc02046e0 <do_wait.part.0+0x18a>
ffffffffc0204688:	000a6797          	auipc	a5,0xa6
ffffffffc020468c:	1a87b783          	ld	a5,424(a5) # ffffffffc02aa830 <va_pa_offset>
ffffffffc0204690:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204692:	82b1                	srli	a3,a3,0xc
ffffffffc0204694:	000a6797          	auipc	a5,0xa6
ffffffffc0204698:	1847b783          	ld	a5,388(a5) # ffffffffc02aa818 <npage>
ffffffffc020469c:	06f6fa63          	bgeu	a3,a5,ffffffffc0204710 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02046a0:	00003517          	auipc	a0,0x3
ffffffffc02046a4:	1c853503          	ld	a0,456(a0) # ffffffffc0207868 <nbase>
ffffffffc02046a8:	8e89                	sub	a3,a3,a0
ffffffffc02046aa:	069a                	slli	a3,a3,0x6
ffffffffc02046ac:	000a6517          	auipc	a0,0xa6
ffffffffc02046b0:	17453503          	ld	a0,372(a0) # ffffffffc02aa820 <pages>
ffffffffc02046b4:	9536                	add	a0,a0,a3
ffffffffc02046b6:	4589                	li	a1,2
ffffffffc02046b8:	823fd0ef          	jal	ra,ffffffffc0201eda <free_pages>
    kfree(proc);
ffffffffc02046bc:	8522                	mv	a0,s0
ffffffffc02046be:	eb0fd0ef          	jal	ra,ffffffffc0201d6e <kfree>
    return 0;
ffffffffc02046c2:	4501                	li	a0,0
ffffffffc02046c4:	bde5                	j	ffffffffc02045bc <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02046c6:	ae8fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046ca:	bf55                	j	ffffffffc020467e <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046cc:	701c                	ld	a5,32(s0)
ffffffffc02046ce:	fbf8                	sd	a4,240(a5)
ffffffffc02046d0:	bf79                	j	ffffffffc020466e <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046d2:	ae2fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02046d6:	4585                	li	a1,1
ffffffffc02046d8:	bf95                	j	ffffffffc020464c <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046da:	f2840413          	addi	s0,s0,-216
ffffffffc02046de:	b781                	j	ffffffffc020461e <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046e0:	00002617          	auipc	a2,0x2
ffffffffc02046e4:	f4860613          	addi	a2,a2,-184 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc02046e8:	07700593          	li	a1,119
ffffffffc02046ec:	00002517          	auipc	a0,0x2
ffffffffc02046f0:	ebc50513          	addi	a0,a0,-324 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02046f4:	d9bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02046f8:	00003617          	auipc	a2,0x3
ffffffffc02046fc:	95860613          	addi	a2,a2,-1704 # ffffffffc0207050 <default_pmm_manager+0xb08>
ffffffffc0204700:	37600593          	li	a1,886
ffffffffc0204704:	00003517          	auipc	a0,0x3
ffffffffc0204708:	8b450513          	addi	a0,a0,-1868 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020470c:	d83fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204710:	00002617          	auipc	a2,0x2
ffffffffc0204714:	f4060613          	addi	a2,a2,-192 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0204718:	06900593          	li	a1,105
ffffffffc020471c:	00002517          	auipc	a0,0x2
ffffffffc0204720:	e8c50513          	addi	a0,a0,-372 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204724:	d6bfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204728 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204728:	1141                	addi	sp,sp,-16
ffffffffc020472a:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020472c:	feefd0ef          	jal	ra,ffffffffc0201f1a <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204730:	d8afd0ef          	jal	ra,ffffffffc0201cba <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204734:	4601                	li	a2,0
ffffffffc0204736:	4581                	li	a1,0
ffffffffc0204738:	fffff517          	auipc	a0,0xfffff
ffffffffc020473c:	71450513          	addi	a0,a0,1812 # ffffffffc0203e4c <user_main>
ffffffffc0204740:	c7dff0ef          	jal	ra,ffffffffc02043bc <kernel_thread>
    if (pid <= 0)
ffffffffc0204744:	00a04563          	bgtz	a0,ffffffffc020474e <init_main+0x26>
ffffffffc0204748:	a071                	j	ffffffffc02047d4 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020474a:	17d000ef          	jal	ra,ffffffffc02050c6 <schedule>
    if (code_store != NULL)
ffffffffc020474e:	4581                	li	a1,0
ffffffffc0204750:	4501                	li	a0,0
ffffffffc0204752:	e05ff0ef          	jal	ra,ffffffffc0204556 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204756:	d975                	beqz	a0,ffffffffc020474a <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204758:	00003517          	auipc	a0,0x3
ffffffffc020475c:	93850513          	addi	a0,a0,-1736 # ffffffffc0207090 <default_pmm_manager+0xb48>
ffffffffc0204760:	a35fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204764:	000a6797          	auipc	a5,0xa6
ffffffffc0204768:	0e47b783          	ld	a5,228(a5) # ffffffffc02aa848 <initproc>
ffffffffc020476c:	7bf8                	ld	a4,240(a5)
ffffffffc020476e:	e339                	bnez	a4,ffffffffc02047b4 <init_main+0x8c>
ffffffffc0204770:	7ff8                	ld	a4,248(a5)
ffffffffc0204772:	e329                	bnez	a4,ffffffffc02047b4 <init_main+0x8c>
ffffffffc0204774:	1007b703          	ld	a4,256(a5)
ffffffffc0204778:	ef15                	bnez	a4,ffffffffc02047b4 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020477a:	000a6697          	auipc	a3,0xa6
ffffffffc020477e:	0d66a683          	lw	a3,214(a3) # ffffffffc02aa850 <nr_process>
ffffffffc0204782:	4709                	li	a4,2
ffffffffc0204784:	0ae69463          	bne	a3,a4,ffffffffc020482c <init_main+0x104>
    return listelm->next;
ffffffffc0204788:	000a6697          	auipc	a3,0xa6
ffffffffc020478c:	03868693          	addi	a3,a3,56 # ffffffffc02aa7c0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204790:	6698                	ld	a4,8(a3)
ffffffffc0204792:	0c878793          	addi	a5,a5,200
ffffffffc0204796:	06f71b63          	bne	a4,a5,ffffffffc020480c <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020479a:	629c                	ld	a5,0(a3)
ffffffffc020479c:	04f71863          	bne	a4,a5,ffffffffc02047ec <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02047a0:	00003517          	auipc	a0,0x3
ffffffffc02047a4:	9d850513          	addi	a0,a0,-1576 # ffffffffc0207178 <default_pmm_manager+0xc30>
ffffffffc02047a8:	9edfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02047ac:	60a2                	ld	ra,8(sp)
ffffffffc02047ae:	4501                	li	a0,0
ffffffffc02047b0:	0141                	addi	sp,sp,16
ffffffffc02047b2:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02047b4:	00003697          	auipc	a3,0x3
ffffffffc02047b8:	90468693          	addi	a3,a3,-1788 # ffffffffc02070b8 <default_pmm_manager+0xb70>
ffffffffc02047bc:	00002617          	auipc	a2,0x2
ffffffffc02047c0:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0206198 <commands+0x828>
ffffffffc02047c4:	3e400593          	li	a1,996
ffffffffc02047c8:	00002517          	auipc	a0,0x2
ffffffffc02047cc:	7f050513          	addi	a0,a0,2032 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02047d0:	cbffb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02047d4:	00003617          	auipc	a2,0x3
ffffffffc02047d8:	89c60613          	addi	a2,a2,-1892 # ffffffffc0207070 <default_pmm_manager+0xb28>
ffffffffc02047dc:	3db00593          	li	a1,987
ffffffffc02047e0:	00002517          	auipc	a0,0x2
ffffffffc02047e4:	7d850513          	addi	a0,a0,2008 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02047e8:	ca7fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047ec:	00003697          	auipc	a3,0x3
ffffffffc02047f0:	95c68693          	addi	a3,a3,-1700 # ffffffffc0207148 <default_pmm_manager+0xc00>
ffffffffc02047f4:	00002617          	auipc	a2,0x2
ffffffffc02047f8:	9a460613          	addi	a2,a2,-1628 # ffffffffc0206198 <commands+0x828>
ffffffffc02047fc:	3e700593          	li	a1,999
ffffffffc0204800:	00002517          	auipc	a0,0x2
ffffffffc0204804:	7b850513          	addi	a0,a0,1976 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204808:	c87fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020480c:	00003697          	auipc	a3,0x3
ffffffffc0204810:	90c68693          	addi	a3,a3,-1780 # ffffffffc0207118 <default_pmm_manager+0xbd0>
ffffffffc0204814:	00002617          	auipc	a2,0x2
ffffffffc0204818:	98460613          	addi	a2,a2,-1660 # ffffffffc0206198 <commands+0x828>
ffffffffc020481c:	3e600593          	li	a1,998
ffffffffc0204820:	00002517          	auipc	a0,0x2
ffffffffc0204824:	79850513          	addi	a0,a0,1944 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204828:	c67fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc020482c:	00003697          	auipc	a3,0x3
ffffffffc0204830:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0207108 <default_pmm_manager+0xbc0>
ffffffffc0204834:	00002617          	auipc	a2,0x2
ffffffffc0204838:	96460613          	addi	a2,a2,-1692 # ffffffffc0206198 <commands+0x828>
ffffffffc020483c:	3e500593          	li	a1,997
ffffffffc0204840:	00002517          	auipc	a0,0x2
ffffffffc0204844:	77850513          	addi	a0,a0,1912 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204848:	c47fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020484c <do_execve>:
{
ffffffffc020484c:	7171                	addi	sp,sp,-176
ffffffffc020484e:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204850:	000a6d97          	auipc	s11,0xa6
ffffffffc0204854:	fe8d8d93          	addi	s11,s11,-24 # ffffffffc02aa838 <current>
ffffffffc0204858:	000db783          	ld	a5,0(s11)
{
ffffffffc020485c:	e54e                	sd	s3,136(sp)
ffffffffc020485e:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204860:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204864:	e94a                	sd	s2,144(sp)
ffffffffc0204866:	f4de                	sd	s7,104(sp)
ffffffffc0204868:	892a                	mv	s2,a0
ffffffffc020486a:	8bb2                	mv	s7,a2
ffffffffc020486c:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020486e:	862e                	mv	a2,a1
ffffffffc0204870:	4681                	li	a3,0
ffffffffc0204872:	85aa                	mv	a1,a0
ffffffffc0204874:	854e                	mv	a0,s3
{
ffffffffc0204876:	f506                	sd	ra,168(sp)
ffffffffc0204878:	f122                	sd	s0,160(sp)
ffffffffc020487a:	e152                	sd	s4,128(sp)
ffffffffc020487c:	fcd6                	sd	s5,120(sp)
ffffffffc020487e:	f8da                	sd	s6,112(sp)
ffffffffc0204880:	f0e2                	sd	s8,96(sp)
ffffffffc0204882:	ece6                	sd	s9,88(sp)
ffffffffc0204884:	e8ea                	sd	s10,80(sp)
ffffffffc0204886:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204888:	caeff0ef          	jal	ra,ffffffffc0203d36 <user_mem_check>
ffffffffc020488c:	40050a63          	beqz	a0,ffffffffc0204ca0 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204890:	4641                	li	a2,16
ffffffffc0204892:	4581                	li	a1,0
ffffffffc0204894:	1808                	addi	a0,sp,48
ffffffffc0204896:	643000ef          	jal	ra,ffffffffc02056d8 <memset>
    memcpy(local_name, name, len);
ffffffffc020489a:	47bd                	li	a5,15
ffffffffc020489c:	8626                	mv	a2,s1
ffffffffc020489e:	1e97e263          	bltu	a5,s1,ffffffffc0204a82 <do_execve+0x236>
ffffffffc02048a2:	85ca                	mv	a1,s2
ffffffffc02048a4:	1808                	addi	a0,sp,48
ffffffffc02048a6:	645000ef          	jal	ra,ffffffffc02056ea <memcpy>
    if (mm != NULL)
ffffffffc02048aa:	1e098363          	beqz	s3,ffffffffc0204a90 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc02048ae:	00002517          	auipc	a0,0x2
ffffffffc02048b2:	4ca50513          	addi	a0,a0,1226 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc02048b6:	917fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc02048ba:	000a6797          	auipc	a5,0xa6
ffffffffc02048be:	f4e7b783          	ld	a5,-178(a5) # ffffffffc02aa808 <boot_pgdir_pa>
ffffffffc02048c2:	577d                	li	a4,-1
ffffffffc02048c4:	177e                	slli	a4,a4,0x3f
ffffffffc02048c6:	83b1                	srli	a5,a5,0xc
ffffffffc02048c8:	8fd9                	or	a5,a5,a4
ffffffffc02048ca:	18079073          	csrw	satp,a5
ffffffffc02048ce:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b88>
ffffffffc02048d2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048d6:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02048da:	2c070463          	beqz	a4,ffffffffc0204ba2 <do_execve+0x356>
        current->mm = NULL;
ffffffffc02048de:	000db783          	ld	a5,0(s11)
ffffffffc02048e2:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048e6:	ddbfe0ef          	jal	ra,ffffffffc02036c0 <mm_create>
ffffffffc02048ea:	84aa                	mv	s1,a0
ffffffffc02048ec:	1c050d63          	beqz	a0,ffffffffc0204ac6 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc02048f0:	4505                	li	a0,1
ffffffffc02048f2:	daafd0ef          	jal	ra,ffffffffc0201e9c <alloc_pages>
ffffffffc02048f6:	3a050963          	beqz	a0,ffffffffc0204ca8 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc02048fa:	000a6c97          	auipc	s9,0xa6
ffffffffc02048fe:	f26c8c93          	addi	s9,s9,-218 # ffffffffc02aa820 <pages>
ffffffffc0204902:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204906:	000a6c17          	auipc	s8,0xa6
ffffffffc020490a:	f12c0c13          	addi	s8,s8,-238 # ffffffffc02aa818 <npage>
    return page - pages + nbase;
ffffffffc020490e:	00003717          	auipc	a4,0x3
ffffffffc0204912:	f5a73703          	ld	a4,-166(a4) # ffffffffc0207868 <nbase>
ffffffffc0204916:	40d506b3          	sub	a3,a0,a3
ffffffffc020491a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020491c:	5afd                	li	s5,-1
ffffffffc020491e:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204922:	96ba                	add	a3,a3,a4
ffffffffc0204924:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204926:	00cad713          	srli	a4,s5,0xc
ffffffffc020492a:	ec3a                	sd	a4,24(sp)
ffffffffc020492c:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020492e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204930:	38f77063          	bgeu	a4,a5,ffffffffc0204cb0 <do_execve+0x464>
ffffffffc0204934:	000a6b17          	auipc	s6,0xa6
ffffffffc0204938:	efcb0b13          	addi	s6,s6,-260 # ffffffffc02aa830 <va_pa_offset>
ffffffffc020493c:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204940:	6605                	lui	a2,0x1
ffffffffc0204942:	000a6597          	auipc	a1,0xa6
ffffffffc0204946:	ece5b583          	ld	a1,-306(a1) # ffffffffc02aa810 <boot_pgdir_va>
ffffffffc020494a:	9936                	add	s2,s2,a3
ffffffffc020494c:	854a                	mv	a0,s2
ffffffffc020494e:	59d000ef          	jal	ra,ffffffffc02056ea <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204952:	7782                	ld	a5,32(sp)
ffffffffc0204954:	4398                	lw	a4,0(a5)
ffffffffc0204956:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc020495a:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020495e:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b944f>
ffffffffc0204962:	14f71863          	bne	a4,a5,ffffffffc0204ab2 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204966:	7682                	ld	a3,32(sp)
ffffffffc0204968:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020496c:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204970:	00371793          	slli	a5,a4,0x3
ffffffffc0204974:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204976:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204978:	078e                	slli	a5,a5,0x3
ffffffffc020497a:	97ce                	add	a5,a5,s3
ffffffffc020497c:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc020497e:	00f9fc63          	bgeu	s3,a5,ffffffffc0204996 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204982:	0009a783          	lw	a5,0(s3)
ffffffffc0204986:	4705                	li	a4,1
ffffffffc0204988:	14e78163          	beq	a5,a4,ffffffffc0204aca <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc020498c:	77a2                	ld	a5,40(sp)
ffffffffc020498e:	03898993          	addi	s3,s3,56
ffffffffc0204992:	fef9e8e3          	bltu	s3,a5,ffffffffc0204982 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204996:	4701                	li	a4,0
ffffffffc0204998:	46ad                	li	a3,11
ffffffffc020499a:	00100637          	lui	a2,0x100
ffffffffc020499e:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02049a2:	8526                	mv	a0,s1
ffffffffc02049a4:	eaffe0ef          	jal	ra,ffffffffc0203852 <mm_map>
ffffffffc02049a8:	8a2a                	mv	s4,a0
ffffffffc02049aa:	1e051263          	bnez	a0,ffffffffc0204b8e <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02049ae:	6c88                	ld	a0,24(s1)
ffffffffc02049b0:	467d                	li	a2,31
ffffffffc02049b2:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02049b6:	c25fe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc02049ba:	38050363          	beqz	a0,ffffffffc0204d40 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049be:	6c88                	ld	a0,24(s1)
ffffffffc02049c0:	467d                	li	a2,31
ffffffffc02049c2:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049c6:	c15fe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc02049ca:	34050b63          	beqz	a0,ffffffffc0204d20 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049ce:	6c88                	ld	a0,24(s1)
ffffffffc02049d0:	467d                	li	a2,31
ffffffffc02049d2:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049d6:	c05fe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc02049da:	32050363          	beqz	a0,ffffffffc0204d00 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049de:	6c88                	ld	a0,24(s1)
ffffffffc02049e0:	467d                	li	a2,31
ffffffffc02049e2:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049e6:	bf5fe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc02049ea:	2e050b63          	beqz	a0,ffffffffc0204ce0 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc02049ee:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc02049f0:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049f4:	6c94                	ld	a3,24(s1)
ffffffffc02049f6:	2785                	addiw	a5,a5,1
ffffffffc02049f8:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc02049fa:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049fc:	c02007b7          	lui	a5,0xc0200
ffffffffc0204a00:	2cf6e463          	bltu	a3,a5,ffffffffc0204cc8 <do_execve+0x47c>
ffffffffc0204a04:	000b3783          	ld	a5,0(s6)
ffffffffc0204a08:	577d                	li	a4,-1
ffffffffc0204a0a:	177e                	slli	a4,a4,0x3f
ffffffffc0204a0c:	8e9d                	sub	a3,a3,a5
ffffffffc0204a0e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a12:	f654                	sd	a3,168(a2)
ffffffffc0204a14:	8fd9                	or	a5,a5,a4
ffffffffc0204a16:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a1a:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a1c:	4581                	li	a1,0
ffffffffc0204a1e:	12000613          	li	a2,288
ffffffffc0204a22:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204a24:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a28:	4b1000ef          	jal	ra,ffffffffc02056d8 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a2c:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a2e:	000db903          	ld	s2,0(s11)
    sstatus &= ~SSTATUS_SPP;   // 清 SPP
ffffffffc0204a32:	eff4f493          	andi	s1,s1,-257
    tf->epc = elf->e_entry;
ffffffffc0204a36:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a38:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a3a:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f84>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a3e:	07fe                	slli	a5,a5,0x1f
    sstatus |= SSTATUS_SPIE;   // 置 SPIE
ffffffffc0204a40:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a44:	4641                	li	a2,16
ffffffffc0204a46:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a48:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204a4a:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus;
ffffffffc0204a4e:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a52:	854a                	mv	a0,s2
ffffffffc0204a54:	485000ef          	jal	ra,ffffffffc02056d8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a58:	463d                	li	a2,15
ffffffffc0204a5a:	180c                	addi	a1,sp,48
ffffffffc0204a5c:	854a                	mv	a0,s2
ffffffffc0204a5e:	48d000ef          	jal	ra,ffffffffc02056ea <memcpy>
}
ffffffffc0204a62:	70aa                	ld	ra,168(sp)
ffffffffc0204a64:	740a                	ld	s0,160(sp)
ffffffffc0204a66:	64ea                	ld	s1,152(sp)
ffffffffc0204a68:	694a                	ld	s2,144(sp)
ffffffffc0204a6a:	69aa                	ld	s3,136(sp)
ffffffffc0204a6c:	7ae6                	ld	s5,120(sp)
ffffffffc0204a6e:	7b46                	ld	s6,112(sp)
ffffffffc0204a70:	7ba6                	ld	s7,104(sp)
ffffffffc0204a72:	7c06                	ld	s8,96(sp)
ffffffffc0204a74:	6ce6                	ld	s9,88(sp)
ffffffffc0204a76:	6d46                	ld	s10,80(sp)
ffffffffc0204a78:	6da6                	ld	s11,72(sp)
ffffffffc0204a7a:	8552                	mv	a0,s4
ffffffffc0204a7c:	6a0a                	ld	s4,128(sp)
ffffffffc0204a7e:	614d                	addi	sp,sp,176
ffffffffc0204a80:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a82:	463d                	li	a2,15
ffffffffc0204a84:	85ca                	mv	a1,s2
ffffffffc0204a86:	1808                	addi	a0,sp,48
ffffffffc0204a88:	463000ef          	jal	ra,ffffffffc02056ea <memcpy>
    if (mm != NULL)
ffffffffc0204a8c:	e20991e3          	bnez	s3,ffffffffc02048ae <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a90:	000db783          	ld	a5,0(s11)
ffffffffc0204a94:	779c                	ld	a5,40(a5)
ffffffffc0204a96:	e40788e3          	beqz	a5,ffffffffc02048e6 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a9a:	00002617          	auipc	a2,0x2
ffffffffc0204a9e:	6fe60613          	addi	a2,a2,1790 # ffffffffc0207198 <default_pmm_manager+0xc50>
ffffffffc0204aa2:	25a00593          	li	a1,602
ffffffffc0204aa6:	00002517          	auipc	a0,0x2
ffffffffc0204aaa:	51250513          	addi	a0,a0,1298 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204aae:	9e1fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204ab2:	8526                	mv	a0,s1
ffffffffc0204ab4:	c16ff0ef          	jal	ra,ffffffffc0203eca <put_pgdir>
    mm_destroy(mm);
ffffffffc0204ab8:	8526                	mv	a0,s1
ffffffffc0204aba:	d47fe0ef          	jal	ra,ffffffffc0203800 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204abe:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204ac0:	8552                	mv	a0,s4
ffffffffc0204ac2:	94bff0ef          	jal	ra,ffffffffc020440c <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204ac6:	5a71                	li	s4,-4
ffffffffc0204ac8:	bfe5                	j	ffffffffc0204ac0 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204aca:	0289b603          	ld	a2,40(s3)
ffffffffc0204ace:	0209b783          	ld	a5,32(s3)
ffffffffc0204ad2:	1cf66d63          	bltu	a2,a5,ffffffffc0204cac <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204ad6:	0049a783          	lw	a5,4(s3)
ffffffffc0204ada:	0017f693          	andi	a3,a5,1
ffffffffc0204ade:	c291                	beqz	a3,ffffffffc0204ae2 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204ae0:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ae2:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ae6:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ae8:	e779                	bnez	a4,ffffffffc0204bb6 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204aea:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204aec:	c781                	beqz	a5,ffffffffc0204af4 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204aee:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204af2:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204af4:	0026f793          	andi	a5,a3,2
ffffffffc0204af8:	e3f1                	bnez	a5,ffffffffc0204bbc <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204afa:	0046f793          	andi	a5,a3,4
ffffffffc0204afe:	c399                	beqz	a5,ffffffffc0204b04 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204b00:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204b04:	0109b583          	ld	a1,16(s3)
ffffffffc0204b08:	4701                	li	a4,0
ffffffffc0204b0a:	8526                	mv	a0,s1
ffffffffc0204b0c:	d47fe0ef          	jal	ra,ffffffffc0203852 <mm_map>
ffffffffc0204b10:	8a2a                	mv	s4,a0
ffffffffc0204b12:	ed35                	bnez	a0,ffffffffc0204b8e <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b14:	0109bb83          	ld	s7,16(s3)
ffffffffc0204b18:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b1a:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b1e:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b22:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b26:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b28:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b2a:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204b2c:	054be963          	bltu	s7,s4,ffffffffc0204b7e <do_execve+0x332>
ffffffffc0204b30:	aa95                	j	ffffffffc0204ca4 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b32:	6785                	lui	a5,0x1
ffffffffc0204b34:	415b8533          	sub	a0,s7,s5
ffffffffc0204b38:	9abe                	add	s5,s5,a5
ffffffffc0204b3a:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b3e:	015a7463          	bgeu	s4,s5,ffffffffc0204b46 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204b42:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204b46:	000cb683          	ld	a3,0(s9)
ffffffffc0204b4a:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b4c:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b50:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b54:	8699                	srai	a3,a3,0x6
ffffffffc0204b56:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b58:	67e2                	ld	a5,24(sp)
ffffffffc0204b5a:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b5e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b60:	14b87863          	bgeu	a6,a1,ffffffffc0204cb0 <do_execve+0x464>
ffffffffc0204b64:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b68:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204b6a:	9bb2                	add	s7,s7,a2
ffffffffc0204b6c:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b6e:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b70:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b72:	379000ef          	jal	ra,ffffffffc02056ea <memcpy>
            start += size, from += size;
ffffffffc0204b76:	6622                	ld	a2,8(sp)
ffffffffc0204b78:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b7a:	054bf363          	bgeu	s7,s4,ffffffffc0204bc0 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b7e:	6c88                	ld	a0,24(s1)
ffffffffc0204b80:	866a                	mv	a2,s10
ffffffffc0204b82:	85d6                	mv	a1,s5
ffffffffc0204b84:	a57fe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc0204b88:	842a                	mv	s0,a0
ffffffffc0204b8a:	f545                	bnez	a0,ffffffffc0204b32 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204b8c:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204b8e:	8526                	mv	a0,s1
ffffffffc0204b90:	e0dfe0ef          	jal	ra,ffffffffc020399c <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b94:	8526                	mv	a0,s1
ffffffffc0204b96:	b34ff0ef          	jal	ra,ffffffffc0203eca <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b9a:	8526                	mv	a0,s1
ffffffffc0204b9c:	c65fe0ef          	jal	ra,ffffffffc0203800 <mm_destroy>
    return ret;
ffffffffc0204ba0:	b705                	j	ffffffffc0204ac0 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204ba2:	854e                	mv	a0,s3
ffffffffc0204ba4:	df9fe0ef          	jal	ra,ffffffffc020399c <exit_mmap>
            put_pgdir(mm);
ffffffffc0204ba8:	854e                	mv	a0,s3
ffffffffc0204baa:	b20ff0ef          	jal	ra,ffffffffc0203eca <put_pgdir>
            mm_destroy(mm);
ffffffffc0204bae:	854e                	mv	a0,s3
ffffffffc0204bb0:	c51fe0ef          	jal	ra,ffffffffc0203800 <mm_destroy>
ffffffffc0204bb4:	b32d                	j	ffffffffc02048de <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204bb6:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bba:	fb95                	bnez	a5,ffffffffc0204aee <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bbc:	4d5d                	li	s10,23
ffffffffc0204bbe:	bf35                	j	ffffffffc0204afa <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204bc0:	0109b683          	ld	a3,16(s3)
ffffffffc0204bc4:	0289b903          	ld	s2,40(s3)
ffffffffc0204bc8:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204bca:	075bfd63          	bgeu	s7,s5,ffffffffc0204c44 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204bce:	db790fe3          	beq	s2,s7,ffffffffc020498c <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204bd2:	6785                	lui	a5,0x1
ffffffffc0204bd4:	00fb8533          	add	a0,s7,a5
ffffffffc0204bd8:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204bdc:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204be0:	0b597d63          	bgeu	s2,s5,ffffffffc0204c9a <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204be4:	000cb683          	ld	a3,0(s9)
ffffffffc0204be8:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bea:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204bee:	40d406b3          	sub	a3,s0,a3
ffffffffc0204bf2:	8699                	srai	a3,a3,0x6
ffffffffc0204bf4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204bf6:	67e2                	ld	a5,24(sp)
ffffffffc0204bf8:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bfc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bfe:	0ac5f963          	bgeu	a1,a2,ffffffffc0204cb0 <do_execve+0x464>
ffffffffc0204c02:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c06:	8652                	mv	a2,s4
ffffffffc0204c08:	4581                	li	a1,0
ffffffffc0204c0a:	96c2                	add	a3,a3,a6
ffffffffc0204c0c:	9536                	add	a0,a0,a3
ffffffffc0204c0e:	2cb000ef          	jal	ra,ffffffffc02056d8 <memset>
            start += size;
ffffffffc0204c12:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204c16:	03597463          	bgeu	s2,s5,ffffffffc0204c3e <do_execve+0x3f2>
ffffffffc0204c1a:	d6e909e3          	beq	s2,a4,ffffffffc020498c <do_execve+0x140>
ffffffffc0204c1e:	00002697          	auipc	a3,0x2
ffffffffc0204c22:	5a268693          	addi	a3,a3,1442 # ffffffffc02071c0 <default_pmm_manager+0xc78>
ffffffffc0204c26:	00001617          	auipc	a2,0x1
ffffffffc0204c2a:	57260613          	addi	a2,a2,1394 # ffffffffc0206198 <commands+0x828>
ffffffffc0204c2e:	2c300593          	li	a1,707
ffffffffc0204c32:	00002517          	auipc	a0,0x2
ffffffffc0204c36:	38650513          	addi	a0,a0,902 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204c3a:	855fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204c3e:	ff5710e3          	bne	a4,s5,ffffffffc0204c1e <do_execve+0x3d2>
ffffffffc0204c42:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204c44:	d52bf4e3          	bgeu	s7,s2,ffffffffc020498c <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c48:	6c88                	ld	a0,24(s1)
ffffffffc0204c4a:	866a                	mv	a2,s10
ffffffffc0204c4c:	85d6                	mv	a1,s5
ffffffffc0204c4e:	98dfe0ef          	jal	ra,ffffffffc02035da <pgdir_alloc_page>
ffffffffc0204c52:	842a                	mv	s0,a0
ffffffffc0204c54:	dd05                	beqz	a0,ffffffffc0204b8c <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c56:	6785                	lui	a5,0x1
ffffffffc0204c58:	415b8533          	sub	a0,s7,s5
ffffffffc0204c5c:	9abe                	add	s5,s5,a5
ffffffffc0204c5e:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c62:	01597463          	bgeu	s2,s5,ffffffffc0204c6a <do_execve+0x41e>
                size -= la - end;
ffffffffc0204c66:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204c6a:	000cb683          	ld	a3,0(s9)
ffffffffc0204c6e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c70:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c74:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c78:	8699                	srai	a3,a3,0x6
ffffffffc0204c7a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c7c:	67e2                	ld	a5,24(sp)
ffffffffc0204c7e:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c82:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c84:	02b87663          	bgeu	a6,a1,ffffffffc0204cb0 <do_execve+0x464>
ffffffffc0204c88:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c8c:	4581                	li	a1,0
            start += size;
ffffffffc0204c8e:	9bb2                	add	s7,s7,a2
ffffffffc0204c90:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c92:	9536                	add	a0,a0,a3
ffffffffc0204c94:	245000ef          	jal	ra,ffffffffc02056d8 <memset>
ffffffffc0204c98:	b775                	j	ffffffffc0204c44 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c9a:	417a8a33          	sub	s4,s5,s7
ffffffffc0204c9e:	b799                	j	ffffffffc0204be4 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204ca0:	5a75                	li	s4,-3
ffffffffc0204ca2:	b3c1                	j	ffffffffc0204a62 <do_execve+0x216>
        while (start < end)
ffffffffc0204ca4:	86de                	mv	a3,s7
ffffffffc0204ca6:	bf39                	j	ffffffffc0204bc4 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204ca8:	5a71                	li	s4,-4
ffffffffc0204caa:	bdc5                	j	ffffffffc0204b9a <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204cac:	5a61                	li	s4,-8
ffffffffc0204cae:	b5c5                	j	ffffffffc0204b8e <do_execve+0x342>
ffffffffc0204cb0:	00002617          	auipc	a2,0x2
ffffffffc0204cb4:	8d060613          	addi	a2,a2,-1840 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0204cb8:	07100593          	li	a1,113
ffffffffc0204cbc:	00002517          	auipc	a0,0x2
ffffffffc0204cc0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204cc4:	fcafb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cc8:	00002617          	auipc	a2,0x2
ffffffffc0204ccc:	96060613          	addi	a2,a2,-1696 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0204cd0:	2e200593          	li	a1,738
ffffffffc0204cd4:	00002517          	auipc	a0,0x2
ffffffffc0204cd8:	2e450513          	addi	a0,a0,740 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204cdc:	fb2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ce0:	00002697          	auipc	a3,0x2
ffffffffc0204ce4:	5f868693          	addi	a3,a3,1528 # ffffffffc02072d8 <default_pmm_manager+0xd90>
ffffffffc0204ce8:	00001617          	auipc	a2,0x1
ffffffffc0204cec:	4b060613          	addi	a2,a2,1200 # ffffffffc0206198 <commands+0x828>
ffffffffc0204cf0:	2dd00593          	li	a1,733
ffffffffc0204cf4:	00002517          	auipc	a0,0x2
ffffffffc0204cf8:	2c450513          	addi	a0,a0,708 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204cfc:	f92fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d00:	00002697          	auipc	a3,0x2
ffffffffc0204d04:	59068693          	addi	a3,a3,1424 # ffffffffc0207290 <default_pmm_manager+0xd48>
ffffffffc0204d08:	00001617          	auipc	a2,0x1
ffffffffc0204d0c:	49060613          	addi	a2,a2,1168 # ffffffffc0206198 <commands+0x828>
ffffffffc0204d10:	2dc00593          	li	a1,732
ffffffffc0204d14:	00002517          	auipc	a0,0x2
ffffffffc0204d18:	2a450513          	addi	a0,a0,676 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d1c:	f72fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d20:	00002697          	auipc	a3,0x2
ffffffffc0204d24:	52868693          	addi	a3,a3,1320 # ffffffffc0207248 <default_pmm_manager+0xd00>
ffffffffc0204d28:	00001617          	auipc	a2,0x1
ffffffffc0204d2c:	47060613          	addi	a2,a2,1136 # ffffffffc0206198 <commands+0x828>
ffffffffc0204d30:	2db00593          	li	a1,731
ffffffffc0204d34:	00002517          	auipc	a0,0x2
ffffffffc0204d38:	28450513          	addi	a0,a0,644 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d3c:	f52fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d40:	00002697          	auipc	a3,0x2
ffffffffc0204d44:	4c068693          	addi	a3,a3,1216 # ffffffffc0207200 <default_pmm_manager+0xcb8>
ffffffffc0204d48:	00001617          	auipc	a2,0x1
ffffffffc0204d4c:	45060613          	addi	a2,a2,1104 # ffffffffc0206198 <commands+0x828>
ffffffffc0204d50:	2da00593          	li	a1,730
ffffffffc0204d54:	00002517          	auipc	a0,0x2
ffffffffc0204d58:	26450513          	addi	a0,a0,612 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d5c:	f32fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204d60 <do_yield>:
    current->need_resched = 1;
ffffffffc0204d60:	000a6797          	auipc	a5,0xa6
ffffffffc0204d64:	ad87b783          	ld	a5,-1320(a5) # ffffffffc02aa838 <current>
ffffffffc0204d68:	4705                	li	a4,1
ffffffffc0204d6a:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d6c:	4501                	li	a0,0
ffffffffc0204d6e:	8082                	ret

ffffffffc0204d70 <do_wait>:
{
ffffffffc0204d70:	1101                	addi	sp,sp,-32
ffffffffc0204d72:	e822                	sd	s0,16(sp)
ffffffffc0204d74:	e426                	sd	s1,8(sp)
ffffffffc0204d76:	ec06                	sd	ra,24(sp)
ffffffffc0204d78:	842e                	mv	s0,a1
ffffffffc0204d7a:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d7c:	c999                	beqz	a1,ffffffffc0204d92 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d7e:	000a6797          	auipc	a5,0xa6
ffffffffc0204d82:	aba7b783          	ld	a5,-1350(a5) # ffffffffc02aa838 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d86:	7788                	ld	a0,40(a5)
ffffffffc0204d88:	4685                	li	a3,1
ffffffffc0204d8a:	4611                	li	a2,4
ffffffffc0204d8c:	fabfe0ef          	jal	ra,ffffffffc0203d36 <user_mem_check>
ffffffffc0204d90:	c909                	beqz	a0,ffffffffc0204da2 <do_wait+0x32>
ffffffffc0204d92:	85a2                	mv	a1,s0
}
ffffffffc0204d94:	6442                	ld	s0,16(sp)
ffffffffc0204d96:	60e2                	ld	ra,24(sp)
ffffffffc0204d98:	8526                	mv	a0,s1
ffffffffc0204d9a:	64a2                	ld	s1,8(sp)
ffffffffc0204d9c:	6105                	addi	sp,sp,32
ffffffffc0204d9e:	fb8ff06f          	j	ffffffffc0204556 <do_wait.part.0>
ffffffffc0204da2:	60e2                	ld	ra,24(sp)
ffffffffc0204da4:	6442                	ld	s0,16(sp)
ffffffffc0204da6:	64a2                	ld	s1,8(sp)
ffffffffc0204da8:	5575                	li	a0,-3
ffffffffc0204daa:	6105                	addi	sp,sp,32
ffffffffc0204dac:	8082                	ret

ffffffffc0204dae <do_kill>:
{
ffffffffc0204dae:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204db0:	6789                	lui	a5,0x2
{
ffffffffc0204db2:	e406                	sd	ra,8(sp)
ffffffffc0204db4:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204db6:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204dba:	17f9                	addi	a5,a5,-2
ffffffffc0204dbc:	02e7e963          	bltu	a5,a4,ffffffffc0204dee <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204dc0:	842a                	mv	s0,a0
ffffffffc0204dc2:	45a9                	li	a1,10
ffffffffc0204dc4:	2501                	sext.w	a0,a0
ffffffffc0204dc6:	46c000ef          	jal	ra,ffffffffc0205232 <hash32>
ffffffffc0204dca:	02051793          	slli	a5,a0,0x20
ffffffffc0204dce:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204dd2:	000a2797          	auipc	a5,0xa2
ffffffffc0204dd6:	9ee78793          	addi	a5,a5,-1554 # ffffffffc02a67c0 <hash_list>
ffffffffc0204dda:	953e                	add	a0,a0,a5
ffffffffc0204ddc:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204dde:	a029                	j	ffffffffc0204de8 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204de0:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204de4:	00870b63          	beq	a4,s0,ffffffffc0204dfa <do_kill+0x4c>
ffffffffc0204de8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204dea:	fef51be3          	bne	a0,a5,ffffffffc0204de0 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204dee:	5475                	li	s0,-3
}
ffffffffc0204df0:	60a2                	ld	ra,8(sp)
ffffffffc0204df2:	8522                	mv	a0,s0
ffffffffc0204df4:	6402                	ld	s0,0(sp)
ffffffffc0204df6:	0141                	addi	sp,sp,16
ffffffffc0204df8:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204dfa:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204dfe:	00177693          	andi	a3,a4,1
ffffffffc0204e02:	e295                	bnez	a3,ffffffffc0204e26 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e04:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204e06:	00176713          	ori	a4,a4,1
ffffffffc0204e0a:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204e0e:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e10:	fe06d0e3          	bgez	a3,ffffffffc0204df0 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204e14:	f2878513          	addi	a0,a5,-216
ffffffffc0204e18:	22e000ef          	jal	ra,ffffffffc0205046 <wakeup_proc>
}
ffffffffc0204e1c:	60a2                	ld	ra,8(sp)
ffffffffc0204e1e:	8522                	mv	a0,s0
ffffffffc0204e20:	6402                	ld	s0,0(sp)
ffffffffc0204e22:	0141                	addi	sp,sp,16
ffffffffc0204e24:	8082                	ret
        return -E_KILLED;
ffffffffc0204e26:	545d                	li	s0,-9
ffffffffc0204e28:	b7e1                	j	ffffffffc0204df0 <do_kill+0x42>

ffffffffc0204e2a <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204e2a:	1101                	addi	sp,sp,-32
ffffffffc0204e2c:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204e2e:	000a6797          	auipc	a5,0xa6
ffffffffc0204e32:	99278793          	addi	a5,a5,-1646 # ffffffffc02aa7c0 <proc_list>
ffffffffc0204e36:	ec06                	sd	ra,24(sp)
ffffffffc0204e38:	e822                	sd	s0,16(sp)
ffffffffc0204e3a:	e04a                	sd	s2,0(sp)
ffffffffc0204e3c:	000a2497          	auipc	s1,0xa2
ffffffffc0204e40:	98448493          	addi	s1,s1,-1660 # ffffffffc02a67c0 <hash_list>
ffffffffc0204e44:	e79c                	sd	a5,8(a5)
ffffffffc0204e46:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e48:	000a6717          	auipc	a4,0xa6
ffffffffc0204e4c:	97870713          	addi	a4,a4,-1672 # ffffffffc02aa7c0 <proc_list>
ffffffffc0204e50:	87a6                	mv	a5,s1
ffffffffc0204e52:	e79c                	sd	a5,8(a5)
ffffffffc0204e54:	e39c                	sd	a5,0(a5)
ffffffffc0204e56:	07c1                	addi	a5,a5,16
ffffffffc0204e58:	fef71de3          	bne	a4,a5,ffffffffc0204e52 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e5c:	f77fe0ef          	jal	ra,ffffffffc0203dd2 <alloc_proc>
ffffffffc0204e60:	000a6917          	auipc	s2,0xa6
ffffffffc0204e64:	9e090913          	addi	s2,s2,-1568 # ffffffffc02aa840 <idleproc>
ffffffffc0204e68:	00a93023          	sd	a0,0(s2)
ffffffffc0204e6c:	0e050f63          	beqz	a0,ffffffffc0204f6a <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e70:	4789                	li	a5,2
ffffffffc0204e72:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e74:	00003797          	auipc	a5,0x3
ffffffffc0204e78:	18c78793          	addi	a5,a5,396 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e7c:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e80:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e82:	4785                	li	a5,1
ffffffffc0204e84:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e86:	4641                	li	a2,16
ffffffffc0204e88:	4581                	li	a1,0
ffffffffc0204e8a:	8522                	mv	a0,s0
ffffffffc0204e8c:	04d000ef          	jal	ra,ffffffffc02056d8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e90:	463d                	li	a2,15
ffffffffc0204e92:	00002597          	auipc	a1,0x2
ffffffffc0204e96:	4a658593          	addi	a1,a1,1190 # ffffffffc0207338 <default_pmm_manager+0xdf0>
ffffffffc0204e9a:	8522                	mv	a0,s0
ffffffffc0204e9c:	04f000ef          	jal	ra,ffffffffc02056ea <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204ea0:	000a6717          	auipc	a4,0xa6
ffffffffc0204ea4:	9b070713          	addi	a4,a4,-1616 # ffffffffc02aa850 <nr_process>
ffffffffc0204ea8:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204eaa:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eae:	4601                	li	a2,0
    nr_process++;
ffffffffc0204eb0:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eb2:	4581                	li	a1,0
ffffffffc0204eb4:	00000517          	auipc	a0,0x0
ffffffffc0204eb8:	87450513          	addi	a0,a0,-1932 # ffffffffc0204728 <init_main>
    nr_process++;
ffffffffc0204ebc:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204ebe:	000a6797          	auipc	a5,0xa6
ffffffffc0204ec2:	96d7bd23          	sd	a3,-1670(a5) # ffffffffc02aa838 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ec6:	cf6ff0ef          	jal	ra,ffffffffc02043bc <kernel_thread>
ffffffffc0204eca:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ecc:	08a05363          	blez	a0,ffffffffc0204f52 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ed0:	6789                	lui	a5,0x2
ffffffffc0204ed2:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ed6:	17f9                	addi	a5,a5,-2
ffffffffc0204ed8:	2501                	sext.w	a0,a0
ffffffffc0204eda:	02e7e363          	bltu	a5,a4,ffffffffc0204f00 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ede:	45a9                	li	a1,10
ffffffffc0204ee0:	352000ef          	jal	ra,ffffffffc0205232 <hash32>
ffffffffc0204ee4:	02051793          	slli	a5,a0,0x20
ffffffffc0204ee8:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204eec:	96a6                	add	a3,a3,s1
ffffffffc0204eee:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204ef0:	a029                	j	ffffffffc0204efa <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204ef2:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c8c>
ffffffffc0204ef6:	04870b63          	beq	a4,s0,ffffffffc0204f4c <proc_init+0x122>
    return listelm->next;
ffffffffc0204efa:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204efc:	fef69be3          	bne	a3,a5,ffffffffc0204ef2 <proc_init+0xc8>
    return NULL;
ffffffffc0204f00:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f02:	0b478493          	addi	s1,a5,180
ffffffffc0204f06:	4641                	li	a2,16
ffffffffc0204f08:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204f0a:	000a6417          	auipc	s0,0xa6
ffffffffc0204f0e:	93e40413          	addi	s0,s0,-1730 # ffffffffc02aa848 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f12:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204f14:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f16:	7c2000ef          	jal	ra,ffffffffc02056d8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f1a:	463d                	li	a2,15
ffffffffc0204f1c:	00002597          	auipc	a1,0x2
ffffffffc0204f20:	44458593          	addi	a1,a1,1092 # ffffffffc0207360 <default_pmm_manager+0xe18>
ffffffffc0204f24:	8526                	mv	a0,s1
ffffffffc0204f26:	7c4000ef          	jal	ra,ffffffffc02056ea <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f2a:	00093783          	ld	a5,0(s2)
ffffffffc0204f2e:	cbb5                	beqz	a5,ffffffffc0204fa2 <proc_init+0x178>
ffffffffc0204f30:	43dc                	lw	a5,4(a5)
ffffffffc0204f32:	eba5                	bnez	a5,ffffffffc0204fa2 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f34:	601c                	ld	a5,0(s0)
ffffffffc0204f36:	c7b1                	beqz	a5,ffffffffc0204f82 <proc_init+0x158>
ffffffffc0204f38:	43d8                	lw	a4,4(a5)
ffffffffc0204f3a:	4785                	li	a5,1
ffffffffc0204f3c:	04f71363          	bne	a4,a5,ffffffffc0204f82 <proc_init+0x158>
}
ffffffffc0204f40:	60e2                	ld	ra,24(sp)
ffffffffc0204f42:	6442                	ld	s0,16(sp)
ffffffffc0204f44:	64a2                	ld	s1,8(sp)
ffffffffc0204f46:	6902                	ld	s2,0(sp)
ffffffffc0204f48:	6105                	addi	sp,sp,32
ffffffffc0204f4a:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f4c:	f2878793          	addi	a5,a5,-216
ffffffffc0204f50:	bf4d                	j	ffffffffc0204f02 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f52:	00002617          	auipc	a2,0x2
ffffffffc0204f56:	3ee60613          	addi	a2,a2,1006 # ffffffffc0207340 <default_pmm_manager+0xdf8>
ffffffffc0204f5a:	40a00593          	li	a1,1034
ffffffffc0204f5e:	00002517          	auipc	a0,0x2
ffffffffc0204f62:	05a50513          	addi	a0,a0,90 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204f66:	d28fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f6a:	00002617          	auipc	a2,0x2
ffffffffc0204f6e:	3b660613          	addi	a2,a2,950 # ffffffffc0207320 <default_pmm_manager+0xdd8>
ffffffffc0204f72:	3fb00593          	li	a1,1019
ffffffffc0204f76:	00002517          	auipc	a0,0x2
ffffffffc0204f7a:	04250513          	addi	a0,a0,66 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204f7e:	d10fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f82:	00002697          	auipc	a3,0x2
ffffffffc0204f86:	40e68693          	addi	a3,a3,1038 # ffffffffc0207390 <default_pmm_manager+0xe48>
ffffffffc0204f8a:	00001617          	auipc	a2,0x1
ffffffffc0204f8e:	20e60613          	addi	a2,a2,526 # ffffffffc0206198 <commands+0x828>
ffffffffc0204f92:	41100593          	li	a1,1041
ffffffffc0204f96:	00002517          	auipc	a0,0x2
ffffffffc0204f9a:	02250513          	addi	a0,a0,34 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204f9e:	cf0fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204fa2:	00002697          	auipc	a3,0x2
ffffffffc0204fa6:	3c668693          	addi	a3,a3,966 # ffffffffc0207368 <default_pmm_manager+0xe20>
ffffffffc0204faa:	00001617          	auipc	a2,0x1
ffffffffc0204fae:	1ee60613          	addi	a2,a2,494 # ffffffffc0206198 <commands+0x828>
ffffffffc0204fb2:	41000593          	li	a1,1040
ffffffffc0204fb6:	00002517          	auipc	a0,0x2
ffffffffc0204fba:	00250513          	addi	a0,a0,2 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204fbe:	cd0fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204fc2 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204fc2:	1141                	addi	sp,sp,-16
ffffffffc0204fc4:	e022                	sd	s0,0(sp)
ffffffffc0204fc6:	e406                	sd	ra,8(sp)
ffffffffc0204fc8:	000a6417          	auipc	s0,0xa6
ffffffffc0204fcc:	87040413          	addi	s0,s0,-1936 # ffffffffc02aa838 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204fd0:	6018                	ld	a4,0(s0)
ffffffffc0204fd2:	6f1c                	ld	a5,24(a4)
ffffffffc0204fd4:	dffd                	beqz	a5,ffffffffc0204fd2 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204fd6:	0f0000ef          	jal	ra,ffffffffc02050c6 <schedule>
ffffffffc0204fda:	bfdd                	j	ffffffffc0204fd0 <cpu_idle+0xe>

ffffffffc0204fdc <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204fdc:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204fe0:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204fe4:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204fe6:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204fe8:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204fec:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204ff0:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204ff4:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204ff8:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204ffc:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205000:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205004:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205008:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020500c:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205010:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205014:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205018:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020501a:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020501c:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205020:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205024:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205028:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020502c:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205030:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205034:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205038:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020503c:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205040:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205044:	8082                	ret

ffffffffc0205046 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205046:	4118                	lw	a4,0(a0)
{
ffffffffc0205048:	1101                	addi	sp,sp,-32
ffffffffc020504a:	ec06                	sd	ra,24(sp)
ffffffffc020504c:	e822                	sd	s0,16(sp)
ffffffffc020504e:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205050:	478d                	li	a5,3
ffffffffc0205052:	04f70b63          	beq	a4,a5,ffffffffc02050a8 <wakeup_proc+0x62>
ffffffffc0205056:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205058:	100027f3          	csrr	a5,sstatus
ffffffffc020505c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020505e:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205060:	ef9d                	bnez	a5,ffffffffc020509e <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205062:	4789                	li	a5,2
ffffffffc0205064:	02f70163          	beq	a4,a5,ffffffffc0205086 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205068:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020506a:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc020506e:	e491                	bnez	s1,ffffffffc020507a <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205070:	60e2                	ld	ra,24(sp)
ffffffffc0205072:	6442                	ld	s0,16(sp)
ffffffffc0205074:	64a2                	ld	s1,8(sp)
ffffffffc0205076:	6105                	addi	sp,sp,32
ffffffffc0205078:	8082                	ret
ffffffffc020507a:	6442                	ld	s0,16(sp)
ffffffffc020507c:	60e2                	ld	ra,24(sp)
ffffffffc020507e:	64a2                	ld	s1,8(sp)
ffffffffc0205080:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205082:	92dfb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205086:	00002617          	auipc	a2,0x2
ffffffffc020508a:	36a60613          	addi	a2,a2,874 # ffffffffc02073f0 <default_pmm_manager+0xea8>
ffffffffc020508e:	45d1                	li	a1,20
ffffffffc0205090:	00002517          	auipc	a0,0x2
ffffffffc0205094:	34850513          	addi	a0,a0,840 # ffffffffc02073d8 <default_pmm_manager+0xe90>
ffffffffc0205098:	c5efb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc020509c:	bfc9                	j	ffffffffc020506e <wakeup_proc+0x28>
        intr_disable();
ffffffffc020509e:	917fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02050a2:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc02050a4:	4485                	li	s1,1
ffffffffc02050a6:	bf75                	j	ffffffffc0205062 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02050a8:	00002697          	auipc	a3,0x2
ffffffffc02050ac:	31068693          	addi	a3,a3,784 # ffffffffc02073b8 <default_pmm_manager+0xe70>
ffffffffc02050b0:	00001617          	auipc	a2,0x1
ffffffffc02050b4:	0e860613          	addi	a2,a2,232 # ffffffffc0206198 <commands+0x828>
ffffffffc02050b8:	45a5                	li	a1,9
ffffffffc02050ba:	00002517          	auipc	a0,0x2
ffffffffc02050be:	31e50513          	addi	a0,a0,798 # ffffffffc02073d8 <default_pmm_manager+0xe90>
ffffffffc02050c2:	bccfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02050c6 <schedule>:

void schedule(void)
{
ffffffffc02050c6:	1141                	addi	sp,sp,-16
ffffffffc02050c8:	e406                	sd	ra,8(sp)
ffffffffc02050ca:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050cc:	100027f3          	csrr	a5,sstatus
ffffffffc02050d0:	8b89                	andi	a5,a5,2
ffffffffc02050d2:	4401                	li	s0,0
ffffffffc02050d4:	efbd                	bnez	a5,ffffffffc0205152 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02050d6:	000a5897          	auipc	a7,0xa5
ffffffffc02050da:	7628b883          	ld	a7,1890(a7) # ffffffffc02aa838 <current>
ffffffffc02050de:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050e2:	000a5517          	auipc	a0,0xa5
ffffffffc02050e6:	75e53503          	ld	a0,1886(a0) # ffffffffc02aa840 <idleproc>
ffffffffc02050ea:	04a88e63          	beq	a7,a0,ffffffffc0205146 <schedule+0x80>
ffffffffc02050ee:	0c888693          	addi	a3,a7,200
ffffffffc02050f2:	000a5617          	auipc	a2,0xa5
ffffffffc02050f6:	6ce60613          	addi	a2,a2,1742 # ffffffffc02aa7c0 <proc_list>
        le = last;
ffffffffc02050fa:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02050fc:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02050fe:	4809                	li	a6,2
ffffffffc0205100:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205102:	00c78863          	beq	a5,a2,ffffffffc0205112 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205106:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020510a:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc020510e:	03070163          	beq	a4,a6,ffffffffc0205130 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205112:	fef697e3          	bne	a3,a5,ffffffffc0205100 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205116:	ed89                	bnez	a1,ffffffffc0205130 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205118:	451c                	lw	a5,8(a0)
ffffffffc020511a:	2785                	addiw	a5,a5,1
ffffffffc020511c:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc020511e:	00a88463          	beq	a7,a0,ffffffffc0205126 <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205122:	e1ffe0ef          	jal	ra,ffffffffc0203f40 <proc_run>
    if (flag)
ffffffffc0205126:	e819                	bnez	s0,ffffffffc020513c <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205128:	60a2                	ld	ra,8(sp)
ffffffffc020512a:	6402                	ld	s0,0(sp)
ffffffffc020512c:	0141                	addi	sp,sp,16
ffffffffc020512e:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205130:	4198                	lw	a4,0(a1)
ffffffffc0205132:	4789                	li	a5,2
ffffffffc0205134:	fef712e3          	bne	a4,a5,ffffffffc0205118 <schedule+0x52>
ffffffffc0205138:	852e                	mv	a0,a1
ffffffffc020513a:	bff9                	j	ffffffffc0205118 <schedule+0x52>
}
ffffffffc020513c:	6402                	ld	s0,0(sp)
ffffffffc020513e:	60a2                	ld	ra,8(sp)
ffffffffc0205140:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205142:	86dfb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205146:	000a5617          	auipc	a2,0xa5
ffffffffc020514a:	67a60613          	addi	a2,a2,1658 # ffffffffc02aa7c0 <proc_list>
ffffffffc020514e:	86b2                	mv	a3,a2
ffffffffc0205150:	b76d                	j	ffffffffc02050fa <schedule+0x34>
        intr_disable();
ffffffffc0205152:	863fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205156:	4405                	li	s0,1
ffffffffc0205158:	bfbd                	j	ffffffffc02050d6 <schedule+0x10>

ffffffffc020515a <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020515a:	000a5797          	auipc	a5,0xa5
ffffffffc020515e:	6de7b783          	ld	a5,1758(a5) # ffffffffc02aa838 <current>
}
ffffffffc0205162:	43c8                	lw	a0,4(a5)
ffffffffc0205164:	8082                	ret

ffffffffc0205166 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205166:	4501                	li	a0,0
ffffffffc0205168:	8082                	ret

ffffffffc020516a <sys_putc>:
    cputchar(c);
ffffffffc020516a:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020516c:	1141                	addi	sp,sp,-16
ffffffffc020516e:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205170:	85afb0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc0205174:	60a2                	ld	ra,8(sp)
ffffffffc0205176:	4501                	li	a0,0
ffffffffc0205178:	0141                	addi	sp,sp,16
ffffffffc020517a:	8082                	ret

ffffffffc020517c <sys_kill>:
    return do_kill(pid);
ffffffffc020517c:	4108                	lw	a0,0(a0)
ffffffffc020517e:	c31ff06f          	j	ffffffffc0204dae <do_kill>

ffffffffc0205182 <sys_yield>:
    return do_yield();
ffffffffc0205182:	bdfff06f          	j	ffffffffc0204d60 <do_yield>

ffffffffc0205186 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205186:	6d14                	ld	a3,24(a0)
ffffffffc0205188:	6910                	ld	a2,16(a0)
ffffffffc020518a:	650c                	ld	a1,8(a0)
ffffffffc020518c:	6108                	ld	a0,0(a0)
ffffffffc020518e:	ebeff06f          	j	ffffffffc020484c <do_execve>

ffffffffc0205192 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205192:	650c                	ld	a1,8(a0)
ffffffffc0205194:	4108                	lw	a0,0(a0)
ffffffffc0205196:	bdbff06f          	j	ffffffffc0204d70 <do_wait>

ffffffffc020519a <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020519a:	000a5797          	auipc	a5,0xa5
ffffffffc020519e:	69e7b783          	ld	a5,1694(a5) # ffffffffc02aa838 <current>
ffffffffc02051a2:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02051a4:	4501                	li	a0,0
ffffffffc02051a6:	6a0c                	ld	a1,16(a2)
ffffffffc02051a8:	e11fe06f          	j	ffffffffc0203fb8 <do_fork>

ffffffffc02051ac <sys_exit>:
    return do_exit(error_code);
ffffffffc02051ac:	4108                	lw	a0,0(a0)
ffffffffc02051ae:	a5eff06f          	j	ffffffffc020440c <do_exit>

ffffffffc02051b2 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02051b2:	715d                	addi	sp,sp,-80
ffffffffc02051b4:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051b6:	000a5497          	auipc	s1,0xa5
ffffffffc02051ba:	68248493          	addi	s1,s1,1666 # ffffffffc02aa838 <current>
ffffffffc02051be:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02051c0:	e0a2                	sd	s0,64(sp)
ffffffffc02051c2:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051c4:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02051c6:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051c8:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02051ca:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051ce:	0327ee63          	bltu	a5,s2,ffffffffc020520a <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02051d2:	00391713          	slli	a4,s2,0x3
ffffffffc02051d6:	00002797          	auipc	a5,0x2
ffffffffc02051da:	28278793          	addi	a5,a5,642 # ffffffffc0207458 <syscalls>
ffffffffc02051de:	97ba                	add	a5,a5,a4
ffffffffc02051e0:	639c                	ld	a5,0(a5)
ffffffffc02051e2:	c785                	beqz	a5,ffffffffc020520a <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02051e4:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02051e6:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02051e8:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02051ea:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02051ec:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02051ee:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02051f0:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02051f2:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02051f4:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02051f6:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051f8:	0028                	addi	a0,sp,8
ffffffffc02051fa:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02051fc:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051fe:	e828                	sd	a0,80(s0)
}
ffffffffc0205200:	6406                	ld	s0,64(sp)
ffffffffc0205202:	74e2                	ld	s1,56(sp)
ffffffffc0205204:	7942                	ld	s2,48(sp)
ffffffffc0205206:	6161                	addi	sp,sp,80
ffffffffc0205208:	8082                	ret
    print_trapframe(tf);
ffffffffc020520a:	8522                	mv	a0,s0
ffffffffc020520c:	999fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205210:	609c                	ld	a5,0(s1)
ffffffffc0205212:	86ca                	mv	a3,s2
ffffffffc0205214:	00002617          	auipc	a2,0x2
ffffffffc0205218:	1fc60613          	addi	a2,a2,508 # ffffffffc0207410 <default_pmm_manager+0xec8>
ffffffffc020521c:	43d8                	lw	a4,4(a5)
ffffffffc020521e:	06200593          	li	a1,98
ffffffffc0205222:	0b478793          	addi	a5,a5,180
ffffffffc0205226:	00002517          	auipc	a0,0x2
ffffffffc020522a:	21a50513          	addi	a0,a0,538 # ffffffffc0207440 <default_pmm_manager+0xef8>
ffffffffc020522e:	a60fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205232 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205232:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205236:	2785                	addiw	a5,a5,1
ffffffffc0205238:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc020523c:	02000793          	li	a5,32
ffffffffc0205240:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205242:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205246:	8082                	ret

ffffffffc0205248 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205248:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020524c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020524e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205252:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205254:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205258:	f022                	sd	s0,32(sp)
ffffffffc020525a:	ec26                	sd	s1,24(sp)
ffffffffc020525c:	e84a                	sd	s2,16(sp)
ffffffffc020525e:	f406                	sd	ra,40(sp)
ffffffffc0205260:	e44e                	sd	s3,8(sp)
ffffffffc0205262:	84aa                	mv	s1,a0
ffffffffc0205264:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205266:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020526a:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020526c:	03067e63          	bgeu	a2,a6,ffffffffc02052a8 <printnum+0x60>
ffffffffc0205270:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205272:	00805763          	blez	s0,ffffffffc0205280 <printnum+0x38>
ffffffffc0205276:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205278:	85ca                	mv	a1,s2
ffffffffc020527a:	854e                	mv	a0,s3
ffffffffc020527c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020527e:	fc65                	bnez	s0,ffffffffc0205276 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205280:	1a02                	slli	s4,s4,0x20
ffffffffc0205282:	00002797          	auipc	a5,0x2
ffffffffc0205286:	2d678793          	addi	a5,a5,726 # ffffffffc0207558 <syscalls+0x100>
ffffffffc020528a:	020a5a13          	srli	s4,s4,0x20
ffffffffc020528e:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205290:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205292:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205296:	70a2                	ld	ra,40(sp)
ffffffffc0205298:	69a2                	ld	s3,8(sp)
ffffffffc020529a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020529c:	85ca                	mv	a1,s2
ffffffffc020529e:	87a6                	mv	a5,s1
}
ffffffffc02052a0:	6942                	ld	s2,16(sp)
ffffffffc02052a2:	64e2                	ld	s1,24(sp)
ffffffffc02052a4:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052a6:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02052a8:	03065633          	divu	a2,a2,a6
ffffffffc02052ac:	8722                	mv	a4,s0
ffffffffc02052ae:	f9bff0ef          	jal	ra,ffffffffc0205248 <printnum>
ffffffffc02052b2:	b7f9                	j	ffffffffc0205280 <printnum+0x38>

ffffffffc02052b4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02052b4:	7119                	addi	sp,sp,-128
ffffffffc02052b6:	f4a6                	sd	s1,104(sp)
ffffffffc02052b8:	f0ca                	sd	s2,96(sp)
ffffffffc02052ba:	ecce                	sd	s3,88(sp)
ffffffffc02052bc:	e8d2                	sd	s4,80(sp)
ffffffffc02052be:	e4d6                	sd	s5,72(sp)
ffffffffc02052c0:	e0da                	sd	s6,64(sp)
ffffffffc02052c2:	fc5e                	sd	s7,56(sp)
ffffffffc02052c4:	f06a                	sd	s10,32(sp)
ffffffffc02052c6:	fc86                	sd	ra,120(sp)
ffffffffc02052c8:	f8a2                	sd	s0,112(sp)
ffffffffc02052ca:	f862                	sd	s8,48(sp)
ffffffffc02052cc:	f466                	sd	s9,40(sp)
ffffffffc02052ce:	ec6e                	sd	s11,24(sp)
ffffffffc02052d0:	892a                	mv	s2,a0
ffffffffc02052d2:	84ae                	mv	s1,a1
ffffffffc02052d4:	8d32                	mv	s10,a2
ffffffffc02052d6:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052d8:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02052dc:	5b7d                	li	s6,-1
ffffffffc02052de:	00002a97          	auipc	s5,0x2
ffffffffc02052e2:	2a6a8a93          	addi	s5,s5,678 # ffffffffc0207584 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02052e6:	00002b97          	auipc	s7,0x2
ffffffffc02052ea:	4bab8b93          	addi	s7,s7,1210 # ffffffffc02077a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052ee:	000d4503          	lbu	a0,0(s10)
ffffffffc02052f2:	001d0413          	addi	s0,s10,1
ffffffffc02052f6:	01350a63          	beq	a0,s3,ffffffffc020530a <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02052fa:	c121                	beqz	a0,ffffffffc020533a <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02052fc:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052fe:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205300:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205302:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205306:	ff351ae3          	bne	a0,s3,ffffffffc02052fa <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020530a:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020530e:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205312:	4c81                	li	s9,0
ffffffffc0205314:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205316:	5c7d                	li	s8,-1
ffffffffc0205318:	5dfd                	li	s11,-1
ffffffffc020531a:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020531e:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205320:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205324:	0ff5f593          	zext.b	a1,a1
ffffffffc0205328:	00140d13          	addi	s10,s0,1
ffffffffc020532c:	04b56263          	bltu	a0,a1,ffffffffc0205370 <vprintfmt+0xbc>
ffffffffc0205330:	058a                	slli	a1,a1,0x2
ffffffffc0205332:	95d6                	add	a1,a1,s5
ffffffffc0205334:	4194                	lw	a3,0(a1)
ffffffffc0205336:	96d6                	add	a3,a3,s5
ffffffffc0205338:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020533a:	70e6                	ld	ra,120(sp)
ffffffffc020533c:	7446                	ld	s0,112(sp)
ffffffffc020533e:	74a6                	ld	s1,104(sp)
ffffffffc0205340:	7906                	ld	s2,96(sp)
ffffffffc0205342:	69e6                	ld	s3,88(sp)
ffffffffc0205344:	6a46                	ld	s4,80(sp)
ffffffffc0205346:	6aa6                	ld	s5,72(sp)
ffffffffc0205348:	6b06                	ld	s6,64(sp)
ffffffffc020534a:	7be2                	ld	s7,56(sp)
ffffffffc020534c:	7c42                	ld	s8,48(sp)
ffffffffc020534e:	7ca2                	ld	s9,40(sp)
ffffffffc0205350:	7d02                	ld	s10,32(sp)
ffffffffc0205352:	6de2                	ld	s11,24(sp)
ffffffffc0205354:	6109                	addi	sp,sp,128
ffffffffc0205356:	8082                	ret
            padc = '0';
ffffffffc0205358:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020535a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020535e:	846a                	mv	s0,s10
ffffffffc0205360:	00140d13          	addi	s10,s0,1
ffffffffc0205364:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205368:	0ff5f593          	zext.b	a1,a1
ffffffffc020536c:	fcb572e3          	bgeu	a0,a1,ffffffffc0205330 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205370:	85a6                	mv	a1,s1
ffffffffc0205372:	02500513          	li	a0,37
ffffffffc0205376:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205378:	fff44783          	lbu	a5,-1(s0)
ffffffffc020537c:	8d22                	mv	s10,s0
ffffffffc020537e:	f73788e3          	beq	a5,s3,ffffffffc02052ee <vprintfmt+0x3a>
ffffffffc0205382:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205386:	1d7d                	addi	s10,s10,-1
ffffffffc0205388:	ff379de3          	bne	a5,s3,ffffffffc0205382 <vprintfmt+0xce>
ffffffffc020538c:	b78d                	j	ffffffffc02052ee <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020538e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205392:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205396:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205398:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020539c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053a0:	02d86463          	bltu	a6,a3,ffffffffc02053c8 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02053a4:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02053a8:	002c169b          	slliw	a3,s8,0x2
ffffffffc02053ac:	0186873b          	addw	a4,a3,s8
ffffffffc02053b0:	0017171b          	slliw	a4,a4,0x1
ffffffffc02053b4:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02053b6:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02053ba:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02053bc:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02053c0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053c4:	fed870e3          	bgeu	a6,a3,ffffffffc02053a4 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02053c8:	f40ddce3          	bgez	s11,ffffffffc0205320 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02053cc:	8de2                	mv	s11,s8
ffffffffc02053ce:	5c7d                	li	s8,-1
ffffffffc02053d0:	bf81                	j	ffffffffc0205320 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02053d2:	fffdc693          	not	a3,s11
ffffffffc02053d6:	96fd                	srai	a3,a3,0x3f
ffffffffc02053d8:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053dc:	00144603          	lbu	a2,1(s0)
ffffffffc02053e0:	2d81                	sext.w	s11,s11
ffffffffc02053e2:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053e4:	bf35                	j	ffffffffc0205320 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02053e6:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053ea:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02053ee:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053f0:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02053f2:	bfd9                	j	ffffffffc02053c8 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02053f4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053f6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053fa:	01174463          	blt	a4,a7,ffffffffc0205402 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02053fe:	1a088e63          	beqz	a7,ffffffffc02055ba <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205402:	000a3603          	ld	a2,0(s4)
ffffffffc0205406:	46c1                	li	a3,16
ffffffffc0205408:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020540a:	2781                	sext.w	a5,a5
ffffffffc020540c:	876e                	mv	a4,s11
ffffffffc020540e:	85a6                	mv	a1,s1
ffffffffc0205410:	854a                	mv	a0,s2
ffffffffc0205412:	e37ff0ef          	jal	ra,ffffffffc0205248 <printnum>
            break;
ffffffffc0205416:	bde1                	j	ffffffffc02052ee <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205418:	000a2503          	lw	a0,0(s4)
ffffffffc020541c:	85a6                	mv	a1,s1
ffffffffc020541e:	0a21                	addi	s4,s4,8
ffffffffc0205420:	9902                	jalr	s2
            break;
ffffffffc0205422:	b5f1                	j	ffffffffc02052ee <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205424:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205426:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020542a:	01174463          	blt	a4,a7,ffffffffc0205432 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020542e:	18088163          	beqz	a7,ffffffffc02055b0 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205432:	000a3603          	ld	a2,0(s4)
ffffffffc0205436:	46a9                	li	a3,10
ffffffffc0205438:	8a2e                	mv	s4,a1
ffffffffc020543a:	bfc1                	j	ffffffffc020540a <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020543c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205440:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205442:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205444:	bdf1                	j	ffffffffc0205320 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205446:	85a6                	mv	a1,s1
ffffffffc0205448:	02500513          	li	a0,37
ffffffffc020544c:	9902                	jalr	s2
            break;
ffffffffc020544e:	b545                	j	ffffffffc02052ee <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205450:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205454:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205456:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205458:	b5e1                	j	ffffffffc0205320 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020545a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020545c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205460:	01174463          	blt	a4,a7,ffffffffc0205468 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205464:	14088163          	beqz	a7,ffffffffc02055a6 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205468:	000a3603          	ld	a2,0(s4)
ffffffffc020546c:	46a1                	li	a3,8
ffffffffc020546e:	8a2e                	mv	s4,a1
ffffffffc0205470:	bf69                	j	ffffffffc020540a <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205472:	03000513          	li	a0,48
ffffffffc0205476:	85a6                	mv	a1,s1
ffffffffc0205478:	e03e                	sd	a5,0(sp)
ffffffffc020547a:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020547c:	85a6                	mv	a1,s1
ffffffffc020547e:	07800513          	li	a0,120
ffffffffc0205482:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205484:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205486:	6782                	ld	a5,0(sp)
ffffffffc0205488:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020548a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020548e:	bfb5                	j	ffffffffc020540a <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205490:	000a3403          	ld	s0,0(s4)
ffffffffc0205494:	008a0713          	addi	a4,s4,8
ffffffffc0205498:	e03a                	sd	a4,0(sp)
ffffffffc020549a:	14040263          	beqz	s0,ffffffffc02055de <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020549e:	0fb05763          	blez	s11,ffffffffc020558c <vprintfmt+0x2d8>
ffffffffc02054a2:	02d00693          	li	a3,45
ffffffffc02054a6:	0cd79163          	bne	a5,a3,ffffffffc0205568 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054aa:	00044783          	lbu	a5,0(s0)
ffffffffc02054ae:	0007851b          	sext.w	a0,a5
ffffffffc02054b2:	cf85                	beqz	a5,ffffffffc02054ea <vprintfmt+0x236>
ffffffffc02054b4:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054b8:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054bc:	000c4563          	bltz	s8,ffffffffc02054c6 <vprintfmt+0x212>
ffffffffc02054c0:	3c7d                	addiw	s8,s8,-1
ffffffffc02054c2:	036c0263          	beq	s8,s6,ffffffffc02054e6 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02054c6:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054c8:	0e0c8e63          	beqz	s9,ffffffffc02055c4 <vprintfmt+0x310>
ffffffffc02054cc:	3781                	addiw	a5,a5,-32
ffffffffc02054ce:	0ef47b63          	bgeu	s0,a5,ffffffffc02055c4 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02054d2:	03f00513          	li	a0,63
ffffffffc02054d6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054d8:	000a4783          	lbu	a5,0(s4)
ffffffffc02054dc:	3dfd                	addiw	s11,s11,-1
ffffffffc02054de:	0a05                	addi	s4,s4,1
ffffffffc02054e0:	0007851b          	sext.w	a0,a5
ffffffffc02054e4:	ffe1                	bnez	a5,ffffffffc02054bc <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02054e6:	01b05963          	blez	s11,ffffffffc02054f8 <vprintfmt+0x244>
ffffffffc02054ea:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02054ec:	85a6                	mv	a1,s1
ffffffffc02054ee:	02000513          	li	a0,32
ffffffffc02054f2:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02054f4:	fe0d9be3          	bnez	s11,ffffffffc02054ea <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02054f8:	6a02                	ld	s4,0(sp)
ffffffffc02054fa:	bbd5                	j	ffffffffc02052ee <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02054fc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02054fe:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205502:	01174463          	blt	a4,a7,ffffffffc020550a <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205506:	08088d63          	beqz	a7,ffffffffc02055a0 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020550a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020550e:	0a044d63          	bltz	s0,ffffffffc02055c8 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205512:	8622                	mv	a2,s0
ffffffffc0205514:	8a66                	mv	s4,s9
ffffffffc0205516:	46a9                	li	a3,10
ffffffffc0205518:	bdcd                	j	ffffffffc020540a <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020551a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020551e:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205520:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205522:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205526:	8fb5                	xor	a5,a5,a3
ffffffffc0205528:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020552c:	02d74163          	blt	a4,a3,ffffffffc020554e <vprintfmt+0x29a>
ffffffffc0205530:	00369793          	slli	a5,a3,0x3
ffffffffc0205534:	97de                	add	a5,a5,s7
ffffffffc0205536:	639c                	ld	a5,0(a5)
ffffffffc0205538:	cb99                	beqz	a5,ffffffffc020554e <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020553a:	86be                	mv	a3,a5
ffffffffc020553c:	00000617          	auipc	a2,0x0
ffffffffc0205540:	1f460613          	addi	a2,a2,500 # ffffffffc0205730 <etext+0x2e>
ffffffffc0205544:	85a6                	mv	a1,s1
ffffffffc0205546:	854a                	mv	a0,s2
ffffffffc0205548:	0ce000ef          	jal	ra,ffffffffc0205616 <printfmt>
ffffffffc020554c:	b34d                	j	ffffffffc02052ee <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020554e:	00002617          	auipc	a2,0x2
ffffffffc0205552:	02a60613          	addi	a2,a2,42 # ffffffffc0207578 <syscalls+0x120>
ffffffffc0205556:	85a6                	mv	a1,s1
ffffffffc0205558:	854a                	mv	a0,s2
ffffffffc020555a:	0bc000ef          	jal	ra,ffffffffc0205616 <printfmt>
ffffffffc020555e:	bb41                	j	ffffffffc02052ee <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205560:	00002417          	auipc	s0,0x2
ffffffffc0205564:	01040413          	addi	s0,s0,16 # ffffffffc0207570 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205568:	85e2                	mv	a1,s8
ffffffffc020556a:	8522                	mv	a0,s0
ffffffffc020556c:	e43e                	sd	a5,8(sp)
ffffffffc020556e:	0e2000ef          	jal	ra,ffffffffc0205650 <strnlen>
ffffffffc0205572:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205576:	01b05b63          	blez	s11,ffffffffc020558c <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020557a:	67a2                	ld	a5,8(sp)
ffffffffc020557c:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205580:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205582:	85a6                	mv	a1,s1
ffffffffc0205584:	8552                	mv	a0,s4
ffffffffc0205586:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205588:	fe0d9ce3          	bnez	s11,ffffffffc0205580 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020558c:	00044783          	lbu	a5,0(s0)
ffffffffc0205590:	00140a13          	addi	s4,s0,1
ffffffffc0205594:	0007851b          	sext.w	a0,a5
ffffffffc0205598:	d3a5                	beqz	a5,ffffffffc02054f8 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020559a:	05e00413          	li	s0,94
ffffffffc020559e:	bf39                	j	ffffffffc02054bc <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02055a0:	000a2403          	lw	s0,0(s4)
ffffffffc02055a4:	b7ad                	j	ffffffffc020550e <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02055a6:	000a6603          	lwu	a2,0(s4)
ffffffffc02055aa:	46a1                	li	a3,8
ffffffffc02055ac:	8a2e                	mv	s4,a1
ffffffffc02055ae:	bdb1                	j	ffffffffc020540a <vprintfmt+0x156>
ffffffffc02055b0:	000a6603          	lwu	a2,0(s4)
ffffffffc02055b4:	46a9                	li	a3,10
ffffffffc02055b6:	8a2e                	mv	s4,a1
ffffffffc02055b8:	bd89                	j	ffffffffc020540a <vprintfmt+0x156>
ffffffffc02055ba:	000a6603          	lwu	a2,0(s4)
ffffffffc02055be:	46c1                	li	a3,16
ffffffffc02055c0:	8a2e                	mv	s4,a1
ffffffffc02055c2:	b5a1                	j	ffffffffc020540a <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02055c4:	9902                	jalr	s2
ffffffffc02055c6:	bf09                	j	ffffffffc02054d8 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02055c8:	85a6                	mv	a1,s1
ffffffffc02055ca:	02d00513          	li	a0,45
ffffffffc02055ce:	e03e                	sd	a5,0(sp)
ffffffffc02055d0:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02055d2:	6782                	ld	a5,0(sp)
ffffffffc02055d4:	8a66                	mv	s4,s9
ffffffffc02055d6:	40800633          	neg	a2,s0
ffffffffc02055da:	46a9                	li	a3,10
ffffffffc02055dc:	b53d                	j	ffffffffc020540a <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02055de:	03b05163          	blez	s11,ffffffffc0205600 <vprintfmt+0x34c>
ffffffffc02055e2:	02d00693          	li	a3,45
ffffffffc02055e6:	f6d79de3          	bne	a5,a3,ffffffffc0205560 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02055ea:	00002417          	auipc	s0,0x2
ffffffffc02055ee:	f8640413          	addi	s0,s0,-122 # ffffffffc0207570 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055f2:	02800793          	li	a5,40
ffffffffc02055f6:	02800513          	li	a0,40
ffffffffc02055fa:	00140a13          	addi	s4,s0,1
ffffffffc02055fe:	bd6d                	j	ffffffffc02054b8 <vprintfmt+0x204>
ffffffffc0205600:	00002a17          	auipc	s4,0x2
ffffffffc0205604:	f71a0a13          	addi	s4,s4,-143 # ffffffffc0207571 <syscalls+0x119>
ffffffffc0205608:	02800513          	li	a0,40
ffffffffc020560c:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205610:	05e00413          	li	s0,94
ffffffffc0205614:	b565                	j	ffffffffc02054bc <vprintfmt+0x208>

ffffffffc0205616 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205616:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205618:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020561c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020561e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205620:	ec06                	sd	ra,24(sp)
ffffffffc0205622:	f83a                	sd	a4,48(sp)
ffffffffc0205624:	fc3e                	sd	a5,56(sp)
ffffffffc0205626:	e0c2                	sd	a6,64(sp)
ffffffffc0205628:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020562a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020562c:	c89ff0ef          	jal	ra,ffffffffc02052b4 <vprintfmt>
}
ffffffffc0205630:	60e2                	ld	ra,24(sp)
ffffffffc0205632:	6161                	addi	sp,sp,80
ffffffffc0205634:	8082                	ret

ffffffffc0205636 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205636:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020563a:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020563c:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020563e:	cb81                	beqz	a5,ffffffffc020564e <strlen+0x18>
        cnt ++;
ffffffffc0205640:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205642:	00a707b3          	add	a5,a4,a0
ffffffffc0205646:	0007c783          	lbu	a5,0(a5)
ffffffffc020564a:	fbfd                	bnez	a5,ffffffffc0205640 <strlen+0xa>
ffffffffc020564c:	8082                	ret
    }
    return cnt;
}
ffffffffc020564e:	8082                	ret

ffffffffc0205650 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205650:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205652:	e589                	bnez	a1,ffffffffc020565c <strnlen+0xc>
ffffffffc0205654:	a811                	j	ffffffffc0205668 <strnlen+0x18>
        cnt ++;
ffffffffc0205656:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205658:	00f58863          	beq	a1,a5,ffffffffc0205668 <strnlen+0x18>
ffffffffc020565c:	00f50733          	add	a4,a0,a5
ffffffffc0205660:	00074703          	lbu	a4,0(a4)
ffffffffc0205664:	fb6d                	bnez	a4,ffffffffc0205656 <strnlen+0x6>
ffffffffc0205666:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205668:	852e                	mv	a0,a1
ffffffffc020566a:	8082                	ret

ffffffffc020566c <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020566c:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020566e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205672:	0785                	addi	a5,a5,1
ffffffffc0205674:	0585                	addi	a1,a1,1
ffffffffc0205676:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020567a:	fb75                	bnez	a4,ffffffffc020566e <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020567c:	8082                	ret

ffffffffc020567e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020567e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205682:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205686:	cb89                	beqz	a5,ffffffffc0205698 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205688:	0505                	addi	a0,a0,1
ffffffffc020568a:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020568c:	fee789e3          	beq	a5,a4,ffffffffc020567e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205690:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205694:	9d19                	subw	a0,a0,a4
ffffffffc0205696:	8082                	ret
ffffffffc0205698:	4501                	li	a0,0
ffffffffc020569a:	bfed                	j	ffffffffc0205694 <strcmp+0x16>

ffffffffc020569c <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020569c:	c20d                	beqz	a2,ffffffffc02056be <strncmp+0x22>
ffffffffc020569e:	962e                	add	a2,a2,a1
ffffffffc02056a0:	a031                	j	ffffffffc02056ac <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02056a2:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02056a4:	00e79a63          	bne	a5,a4,ffffffffc02056b8 <strncmp+0x1c>
ffffffffc02056a8:	00b60b63          	beq	a2,a1,ffffffffc02056be <strncmp+0x22>
ffffffffc02056ac:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02056b0:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02056b2:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02056b6:	f7f5                	bnez	a5,ffffffffc02056a2 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056b8:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02056bc:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056be:	4501                	li	a0,0
ffffffffc02056c0:	8082                	ret

ffffffffc02056c2 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02056c2:	00054783          	lbu	a5,0(a0)
ffffffffc02056c6:	c799                	beqz	a5,ffffffffc02056d4 <strchr+0x12>
        if (*s == c) {
ffffffffc02056c8:	00f58763          	beq	a1,a5,ffffffffc02056d6 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02056cc:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02056d0:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02056d2:	fbfd                	bnez	a5,ffffffffc02056c8 <strchr+0x6>
    }
    return NULL;
ffffffffc02056d4:	4501                	li	a0,0
}
ffffffffc02056d6:	8082                	ret

ffffffffc02056d8 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02056d8:	ca01                	beqz	a2,ffffffffc02056e8 <memset+0x10>
ffffffffc02056da:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02056dc:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02056de:	0785                	addi	a5,a5,1
ffffffffc02056e0:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02056e4:	fec79de3          	bne	a5,a2,ffffffffc02056de <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02056e8:	8082                	ret

ffffffffc02056ea <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02056ea:	ca19                	beqz	a2,ffffffffc0205700 <memcpy+0x16>
ffffffffc02056ec:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02056ee:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02056f0:	0005c703          	lbu	a4,0(a1)
ffffffffc02056f4:	0585                	addi	a1,a1,1
ffffffffc02056f6:	0785                	addi	a5,a5,1
ffffffffc02056f8:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02056fc:	fec59ae3          	bne	a1,a2,ffffffffc02056f0 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205700:	8082                	ret
