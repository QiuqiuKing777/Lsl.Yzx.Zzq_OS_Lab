
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	3c20b0ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0200066:	52c000ef          	jal	ra,ffffffffc0200592 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	42658593          	addi	a1,a1,1062 # ffffffffc020b490 <etext+0x2>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	43e50513          	addi	a0,a0,1086 # ffffffffc020b4b0 <etext+0x22>
ffffffffc020007a:	12c000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ae000ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc0200082:	62a000ef          	jal	ra,ffffffffc02006ac <dtb_init>
ffffffffc0200086:	24b020ef          	jal	ra,ffffffffc0202ad0 <pmm_init>
ffffffffc020008a:	3ef000ef          	jal	ra,ffffffffc0200c78 <pic_init>
ffffffffc020008e:	515000ef          	jal	ra,ffffffffc0200da2 <idt_init>
ffffffffc0200092:	6d7030ef          	jal	ra,ffffffffc0203f68 <vmm_init>
ffffffffc0200096:	11e070ef          	jal	ra,ffffffffc02071b4 <sched_init>
ffffffffc020009a:	525060ef          	jal	ra,ffffffffc0206dbe <proc_init>
ffffffffc020009e:	1bf000ef          	jal	ra,ffffffffc0200a5c <ide_init>
ffffffffc02000a2:	108050ef          	jal	ra,ffffffffc02051aa <fs_init>
ffffffffc02000a6:	4a4000ef          	jal	ra,ffffffffc020054a <clock_init>
ffffffffc02000aa:	3c3000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02000ae:	6dd060ef          	jal	ra,ffffffffc0206f8a <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	715d                	addi	sp,sp,-80
ffffffffc02000b4:	e486                	sd	ra,72(sp)
ffffffffc02000b6:	e0a6                	sd	s1,64(sp)
ffffffffc02000b8:	fc4a                	sd	s2,56(sp)
ffffffffc02000ba:	f84e                	sd	s3,48(sp)
ffffffffc02000bc:	f452                	sd	s4,40(sp)
ffffffffc02000be:	f056                	sd	s5,32(sp)
ffffffffc02000c0:	ec5a                	sd	s6,24(sp)
ffffffffc02000c2:	e85e                	sd	s7,16(sp)
ffffffffc02000c4:	c901                	beqz	a0,ffffffffc02000d4 <readline+0x22>
ffffffffc02000c6:	85aa                	mv	a1,a0
ffffffffc02000c8:	0000b517          	auipc	a0,0xb
ffffffffc02000cc:	3f050513          	addi	a0,a0,1008 # ffffffffc020b4b8 <etext+0x2a>
ffffffffc02000d0:	0d6000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02000d4:	4481                	li	s1,0
ffffffffc02000d6:	497d                	li	s2,31
ffffffffc02000d8:	49a1                	li	s3,8
ffffffffc02000da:	4aa9                	li	s5,10
ffffffffc02000dc:	4b35                	li	s6,13
ffffffffc02000de:	00091b97          	auipc	s7,0x91
ffffffffc02000e2:	f82b8b93          	addi	s7,s7,-126 # ffffffffc0291060 <buf>
ffffffffc02000e6:	3fe00a13          	li	s4,1022
ffffffffc02000ea:	0fa000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000ee:	00054a63          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc02000f2:	00a95a63          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc02000f6:	029a5263          	bge	s4,s1,ffffffffc020011a <readline+0x68>
ffffffffc02000fa:	0ea000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000fe:	fe055ae3          	bgez	a0,ffffffffc02000f2 <readline+0x40>
ffffffffc0200102:	4501                	li	a0,0
ffffffffc0200104:	a091                	j	ffffffffc0200148 <readline+0x96>
ffffffffc0200106:	03351463          	bne	a0,s3,ffffffffc020012e <readline+0x7c>
ffffffffc020010a:	e8a9                	bnez	s1,ffffffffc020015c <readline+0xaa>
ffffffffc020010c:	0d8000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc0200110:	fe0549e3          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc0200114:	fea959e3          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc0200118:	4481                	li	s1,0
ffffffffc020011a:	e42a                	sd	a0,8(sp)
ffffffffc020011c:	0c6000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200120:	6522                	ld	a0,8(sp)
ffffffffc0200122:	009b87b3          	add	a5,s7,s1
ffffffffc0200126:	2485                	addiw	s1,s1,1
ffffffffc0200128:	00a78023          	sb	a0,0(a5)
ffffffffc020012c:	bf7d                	j	ffffffffc02000ea <readline+0x38>
ffffffffc020012e:	01550463          	beq	a0,s5,ffffffffc0200136 <readline+0x84>
ffffffffc0200132:	fb651ce3          	bne	a0,s6,ffffffffc02000ea <readline+0x38>
ffffffffc0200136:	0ac000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020013a:	00091517          	auipc	a0,0x91
ffffffffc020013e:	f2650513          	addi	a0,a0,-218 # ffffffffc0291060 <buf>
ffffffffc0200142:	94aa                	add	s1,s1,a0
ffffffffc0200144:	00048023          	sb	zero,0(s1)
ffffffffc0200148:	60a6                	ld	ra,72(sp)
ffffffffc020014a:	6486                	ld	s1,64(sp)
ffffffffc020014c:	7962                	ld	s2,56(sp)
ffffffffc020014e:	79c2                	ld	s3,48(sp)
ffffffffc0200150:	7a22                	ld	s4,40(sp)
ffffffffc0200152:	7a82                	ld	s5,32(sp)
ffffffffc0200154:	6b62                	ld	s6,24(sp)
ffffffffc0200156:	6bc2                	ld	s7,16(sp)
ffffffffc0200158:	6161                	addi	sp,sp,80
ffffffffc020015a:	8082                	ret
ffffffffc020015c:	4521                	li	a0,8
ffffffffc020015e:	084000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200162:	34fd                	addiw	s1,s1,-1
ffffffffc0200164:	b759                	j	ffffffffc02000ea <readline+0x38>

ffffffffc0200166 <cputch>:
ffffffffc0200166:	1141                	addi	sp,sp,-16
ffffffffc0200168:	e022                	sd	s0,0(sp)
ffffffffc020016a:	e406                	sd	ra,8(sp)
ffffffffc020016c:	842e                	mv	s0,a1
ffffffffc020016e:	432000ef          	jal	ra,ffffffffc02005a0 <cons_putc>
ffffffffc0200172:	401c                	lw	a5,0(s0)
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	2785                	addiw	a5,a5,1
ffffffffc0200178:	c01c                	sw	a5,0(s0)
ffffffffc020017a:	6402                	ld	s0,0(sp)
ffffffffc020017c:	0141                	addi	sp,sp,16
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fdc50513          	addi	a0,a0,-36 # ffffffffc0200166 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	5fd0a0ef          	jal	ra,ffffffffc020af96 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc02001ac:	8e2a                	mv	t3,a0
ffffffffc02001ae:	f42e                	sd	a1,40(sp)
ffffffffc02001b0:	75dd                	lui	a1,0xffff7
ffffffffc02001b2:	f832                	sd	a2,48(sp)
ffffffffc02001b4:	fc36                	sd	a3,56(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	00000517          	auipc	a0,0x0
ffffffffc02001bc:	fae50513          	addi	a0,a0,-82 # ffffffffc0200166 <cputch>
ffffffffc02001c0:	0050                	addi	a2,sp,4
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	86f2                	mv	a3,t3
ffffffffc02001c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001ca:	ec06                	sd	ra,24(sp)
ffffffffc02001cc:	e4be                	sd	a5,72(sp)
ffffffffc02001ce:	e8c2                	sd	a6,80(sp)
ffffffffc02001d0:	ecc6                	sd	a7,88(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	c202                	sw	zero,4(sp)
ffffffffc02001d6:	5c10a0ef          	jal	ra,ffffffffc020af96 <vprintfmt>
ffffffffc02001da:	60e2                	ld	ra,24(sp)
ffffffffc02001dc:	4512                	lw	a0,4(sp)
ffffffffc02001de:	6125                	addi	sp,sp,96
ffffffffc02001e0:	8082                	ret

ffffffffc02001e2 <cputchar>:
ffffffffc02001e2:	ae7d                	j	ffffffffc02005a0 <cons_putc>

ffffffffc02001e4 <getchar>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	40c000ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc02001ec:	dd75                	beqz	a0,ffffffffc02001e8 <getchar+0x4>
ffffffffc02001ee:	60a2                	ld	ra,8(sp)
ffffffffc02001f0:	0141                	addi	sp,sp,16
ffffffffc02001f2:	8082                	ret

ffffffffc02001f4 <strdup>:
ffffffffc02001f4:	1101                	addi	sp,sp,-32
ffffffffc02001f6:	ec06                	sd	ra,24(sp)
ffffffffc02001f8:	e822                	sd	s0,16(sp)
ffffffffc02001fa:	e426                	sd	s1,8(sp)
ffffffffc02001fc:	e04a                	sd	s2,0(sp)
ffffffffc02001fe:	892a                	mv	s2,a0
ffffffffc0200200:	1820b0ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc0200204:	842a                	mv	s0,a0
ffffffffc0200206:	0505                	addi	a0,a0,1
ffffffffc0200208:	587010ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020020c:	84aa                	mv	s1,a0
ffffffffc020020e:	c901                	beqz	a0,ffffffffc020021e <strdup+0x2a>
ffffffffc0200210:	8622                	mv	a2,s0
ffffffffc0200212:	85ca                	mv	a1,s2
ffffffffc0200214:	9426                	add	s0,s0,s1
ffffffffc0200216:	2600b0ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	60e2                	ld	ra,24(sp)
ffffffffc0200220:	6442                	ld	s0,16(sp)
ffffffffc0200222:	6902                	ld	s2,0(sp)
ffffffffc0200224:	8526                	mv	a0,s1
ffffffffc0200226:	64a2                	ld	s1,8(sp)
ffffffffc0200228:	6105                	addi	sp,sp,32
ffffffffc020022a:	8082                	ret

ffffffffc020022c <print_kerninfo>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	0000b517          	auipc	a0,0xb
ffffffffc0200232:	29250513          	addi	a0,a0,658 # ffffffffc020b4c0 <etext+0x32>
ffffffffc0200236:	e406                	sd	ra,8(sp)
ffffffffc0200238:	f6fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020023c:	00000597          	auipc	a1,0x0
ffffffffc0200240:	e0e58593          	addi	a1,a1,-498 # ffffffffc020004a <kern_init>
ffffffffc0200244:	0000b517          	auipc	a0,0xb
ffffffffc0200248:	29c50513          	addi	a0,a0,668 # ffffffffc020b4e0 <etext+0x52>
ffffffffc020024c:	f5bff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200250:	0000b597          	auipc	a1,0xb
ffffffffc0200254:	23e58593          	addi	a1,a1,574 # ffffffffc020b48e <etext>
ffffffffc0200258:	0000b517          	auipc	a0,0xb
ffffffffc020025c:	2a850513          	addi	a0,a0,680 # ffffffffc020b500 <etext+0x72>
ffffffffc0200260:	f47ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200264:	00091597          	auipc	a1,0x91
ffffffffc0200268:	dfc58593          	addi	a1,a1,-516 # ffffffffc0291060 <buf>
ffffffffc020026c:	0000b517          	auipc	a0,0xb
ffffffffc0200270:	2b450513          	addi	a0,a0,692 # ffffffffc020b520 <etext+0x92>
ffffffffc0200274:	f33ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200278:	00096597          	auipc	a1,0x96
ffffffffc020027c:	69858593          	addi	a1,a1,1688 # ffffffffc0296910 <end>
ffffffffc0200280:	0000b517          	auipc	a0,0xb
ffffffffc0200284:	2c050513          	addi	a0,a0,704 # ffffffffc020b540 <etext+0xb2>
ffffffffc0200288:	f1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020028c:	00097597          	auipc	a1,0x97
ffffffffc0200290:	a8358593          	addi	a1,a1,-1405 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200294:	00000797          	auipc	a5,0x0
ffffffffc0200298:	db678793          	addi	a5,a5,-586 # ffffffffc020004a <kern_init>
ffffffffc020029c:	40f587b3          	sub	a5,a1,a5
ffffffffc02002a0:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a4:	60a2                	ld	ra,8(sp)
ffffffffc02002a6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002aa:	95be                	add	a1,a1,a5
ffffffffc02002ac:	85a9                	srai	a1,a1,0xa
ffffffffc02002ae:	0000b517          	auipc	a0,0xb
ffffffffc02002b2:	2b250513          	addi	a0,a0,690 # ffffffffc020b560 <etext+0xd2>
ffffffffc02002b6:	0141                	addi	sp,sp,16
ffffffffc02002b8:	b5fd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002ba <print_stackframe>:
ffffffffc02002ba:	1141                	addi	sp,sp,-16
ffffffffc02002bc:	0000b617          	auipc	a2,0xb
ffffffffc02002c0:	2d460613          	addi	a2,a2,724 # ffffffffc020b590 <etext+0x102>
ffffffffc02002c4:	04e00593          	li	a1,78
ffffffffc02002c8:	0000b517          	auipc	a0,0xb
ffffffffc02002cc:	2e050513          	addi	a0,a0,736 # ffffffffc020b5a8 <etext+0x11a>
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	1cc000ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02002d6 <mon_help>:
ffffffffc02002d6:	1141                	addi	sp,sp,-16
ffffffffc02002d8:	0000b617          	auipc	a2,0xb
ffffffffc02002dc:	2e860613          	addi	a2,a2,744 # ffffffffc020b5c0 <etext+0x132>
ffffffffc02002e0:	0000b597          	auipc	a1,0xb
ffffffffc02002e4:	30058593          	addi	a1,a1,768 # ffffffffc020b5e0 <etext+0x152>
ffffffffc02002e8:	0000b517          	auipc	a0,0xb
ffffffffc02002ec:	30050513          	addi	a0,a0,768 # ffffffffc020b5e8 <etext+0x15a>
ffffffffc02002f0:	e406                	sd	ra,8(sp)
ffffffffc02002f2:	eb5ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02002f6:	0000b617          	auipc	a2,0xb
ffffffffc02002fa:	30260613          	addi	a2,a2,770 # ffffffffc020b5f8 <etext+0x16a>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	32258593          	addi	a1,a1,802 # ffffffffc020b620 <etext+0x192>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	2e250513          	addi	a0,a0,738 # ffffffffc020b5e8 <etext+0x15a>
ffffffffc020030e:	e99ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200312:	0000b617          	auipc	a2,0xb
ffffffffc0200316:	31e60613          	addi	a2,a2,798 # ffffffffc020b630 <etext+0x1a2>
ffffffffc020031a:	0000b597          	auipc	a1,0xb
ffffffffc020031e:	33658593          	addi	a1,a1,822 # ffffffffc020b650 <etext+0x1c2>
ffffffffc0200322:	0000b517          	auipc	a0,0xb
ffffffffc0200326:	2c650513          	addi	a0,a0,710 # ffffffffc020b5e8 <etext+0x15a>
ffffffffc020032a:	e7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_kerninfo>:
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
ffffffffc020033a:	ef3ff0ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <mon_backtrace>:
ffffffffc0200346:	1141                	addi	sp,sp,-16
ffffffffc0200348:	e406                	sd	ra,8(sp)
ffffffffc020034a:	f71ff0ef          	jal	ra,ffffffffc02002ba <print_stackframe>
ffffffffc020034e:	60a2                	ld	ra,8(sp)
ffffffffc0200350:	4501                	li	a0,0
ffffffffc0200352:	0141                	addi	sp,sp,16
ffffffffc0200354:	8082                	ret

ffffffffc0200356 <kmonitor>:
ffffffffc0200356:	7115                	addi	sp,sp,-224
ffffffffc0200358:	ed5e                	sd	s7,152(sp)
ffffffffc020035a:	8baa                	mv	s7,a0
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	30450513          	addi	a0,a0,772 # ffffffffc020b660 <etext+0x1d2>
ffffffffc0200364:	ed86                	sd	ra,216(sp)
ffffffffc0200366:	e9a2                	sd	s0,208(sp)
ffffffffc0200368:	e5a6                	sd	s1,200(sp)
ffffffffc020036a:	e1ca                	sd	s2,192(sp)
ffffffffc020036c:	fd4e                	sd	s3,184(sp)
ffffffffc020036e:	f952                	sd	s4,176(sp)
ffffffffc0200370:	f556                	sd	s5,168(sp)
ffffffffc0200372:	f15a                	sd	s6,160(sp)
ffffffffc0200374:	e962                	sd	s8,144(sp)
ffffffffc0200376:	e566                	sd	s9,136(sp)
ffffffffc0200378:	e16a                	sd	s10,128(sp)
ffffffffc020037a:	e2dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020037e:	0000b517          	auipc	a0,0xb
ffffffffc0200382:	30a50513          	addi	a0,a0,778 # ffffffffc020b688 <etext+0x1fa>
ffffffffc0200386:	e21ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020038a:	000b8563          	beqz	s7,ffffffffc0200394 <kmonitor+0x3e>
ffffffffc020038e:	855e                	mv	a0,s7
ffffffffc0200390:	3fb000ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0200394:	0000bc17          	auipc	s8,0xb
ffffffffc0200398:	364c0c13          	addi	s8,s8,868 # ffffffffc020b6f8 <commands>
ffffffffc020039c:	0000b917          	auipc	s2,0xb
ffffffffc02003a0:	31490913          	addi	s2,s2,788 # ffffffffc020b6b0 <etext+0x222>
ffffffffc02003a4:	0000b497          	auipc	s1,0xb
ffffffffc02003a8:	31448493          	addi	s1,s1,788 # ffffffffc020b6b8 <etext+0x22a>
ffffffffc02003ac:	49bd                	li	s3,15
ffffffffc02003ae:	0000bb17          	auipc	s6,0xb
ffffffffc02003b2:	312b0b13          	addi	s6,s6,786 # ffffffffc020b6c0 <etext+0x232>
ffffffffc02003b6:	0000ba17          	auipc	s4,0xb
ffffffffc02003ba:	22aa0a13          	addi	s4,s4,554 # ffffffffc020b5e0 <etext+0x152>
ffffffffc02003be:	4a8d                	li	s5,3
ffffffffc02003c0:	854a                	mv	a0,s2
ffffffffc02003c2:	cf1ff0ef          	jal	ra,ffffffffc02000b2 <readline>
ffffffffc02003c6:	842a                	mv	s0,a0
ffffffffc02003c8:	dd65                	beqz	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003ca:	00054583          	lbu	a1,0(a0)
ffffffffc02003ce:	4c81                	li	s9,0
ffffffffc02003d0:	e1bd                	bnez	a1,ffffffffc0200436 <kmonitor+0xe0>
ffffffffc02003d2:	fe0c87e3          	beqz	s9,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003d6:	6582                	ld	a1,0(sp)
ffffffffc02003d8:	0000bd17          	auipc	s10,0xb
ffffffffc02003dc:	320d0d13          	addi	s10,s10,800 # ffffffffc020b6f8 <commands>
ffffffffc02003e0:	8552                	mv	a0,s4
ffffffffc02003e2:	4401                	li	s0,0
ffffffffc02003e4:	0d61                	addi	s10,s10,24
ffffffffc02003e6:	7e50a0ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc02003ea:	c919                	beqz	a0,ffffffffc0200400 <kmonitor+0xaa>
ffffffffc02003ec:	2405                	addiw	s0,s0,1
ffffffffc02003ee:	0b540063          	beq	s0,s5,ffffffffc020048e <kmonitor+0x138>
ffffffffc02003f2:	000d3503          	ld	a0,0(s10)
ffffffffc02003f6:	6582                	ld	a1,0(sp)
ffffffffc02003f8:	0d61                	addi	s10,s10,24
ffffffffc02003fa:	7d10a0ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc02003fe:	f57d                	bnez	a0,ffffffffc02003ec <kmonitor+0x96>
ffffffffc0200400:	00141793          	slli	a5,s0,0x1
ffffffffc0200404:	97a2                	add	a5,a5,s0
ffffffffc0200406:	078e                	slli	a5,a5,0x3
ffffffffc0200408:	97e2                	add	a5,a5,s8
ffffffffc020040a:	6b9c                	ld	a5,16(a5)
ffffffffc020040c:	865e                	mv	a2,s7
ffffffffc020040e:	002c                	addi	a1,sp,8
ffffffffc0200410:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200414:	9782                	jalr	a5
ffffffffc0200416:	fa0555e3          	bgez	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc020041a:	60ee                	ld	ra,216(sp)
ffffffffc020041c:	644e                	ld	s0,208(sp)
ffffffffc020041e:	64ae                	ld	s1,200(sp)
ffffffffc0200420:	690e                	ld	s2,192(sp)
ffffffffc0200422:	79ea                	ld	s3,184(sp)
ffffffffc0200424:	7a4a                	ld	s4,176(sp)
ffffffffc0200426:	7aaa                	ld	s5,168(sp)
ffffffffc0200428:	7b0a                	ld	s6,160(sp)
ffffffffc020042a:	6bea                	ld	s7,152(sp)
ffffffffc020042c:	6c4a                	ld	s8,144(sp)
ffffffffc020042e:	6caa                	ld	s9,136(sp)
ffffffffc0200430:	6d0a                	ld	s10,128(sp)
ffffffffc0200432:	612d                	addi	sp,sp,224
ffffffffc0200434:	8082                	ret
ffffffffc0200436:	8526                	mv	a0,s1
ffffffffc0200438:	7d70a0ef          	jal	ra,ffffffffc020b40e <strchr>
ffffffffc020043c:	c901                	beqz	a0,ffffffffc020044c <kmonitor+0xf6>
ffffffffc020043e:	00144583          	lbu	a1,1(s0)
ffffffffc0200442:	00040023          	sb	zero,0(s0)
ffffffffc0200446:	0405                	addi	s0,s0,1
ffffffffc0200448:	d5c9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc020044a:	b7f5                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc020044c:	00044783          	lbu	a5,0(s0)
ffffffffc0200450:	d3c9                	beqz	a5,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200452:	033c8963          	beq	s9,s3,ffffffffc0200484 <kmonitor+0x12e>
ffffffffc0200456:	003c9793          	slli	a5,s9,0x3
ffffffffc020045a:	0118                	addi	a4,sp,128
ffffffffc020045c:	97ba                	add	a5,a5,a4
ffffffffc020045e:	f887b023          	sd	s0,-128(a5)
ffffffffc0200462:	00044583          	lbu	a1,0(s0)
ffffffffc0200466:	2c85                	addiw	s9,s9,1
ffffffffc0200468:	e591                	bnez	a1,ffffffffc0200474 <kmonitor+0x11e>
ffffffffc020046a:	b7b5                	j	ffffffffc02003d6 <kmonitor+0x80>
ffffffffc020046c:	00144583          	lbu	a1,1(s0)
ffffffffc0200470:	0405                	addi	s0,s0,1
ffffffffc0200472:	d1a5                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200474:	8526                	mv	a0,s1
ffffffffc0200476:	7990a0ef          	jal	ra,ffffffffc020b40e <strchr>
ffffffffc020047a:	d96d                	beqz	a0,ffffffffc020046c <kmonitor+0x116>
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
ffffffffc0200480:	d9a9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200482:	bf55                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc0200484:	45c1                	li	a1,16
ffffffffc0200486:	855a                	mv	a0,s6
ffffffffc0200488:	d1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020048c:	b7e9                	j	ffffffffc0200456 <kmonitor+0x100>
ffffffffc020048e:	6582                	ld	a1,0(sp)
ffffffffc0200490:	0000b517          	auipc	a0,0xb
ffffffffc0200494:	25050513          	addi	a0,a0,592 # ffffffffc020b6e0 <etext+0x252>
ffffffffc0200498:	d0fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020049c:	b715                	j	ffffffffc02003c0 <kmonitor+0x6a>

ffffffffc020049e <__panic>:
ffffffffc020049e:	00096317          	auipc	t1,0x96
ffffffffc02004a2:	3ca30313          	addi	t1,t1,970 # ffffffffc0296868 <is_panic>
ffffffffc02004a6:	00033e03          	ld	t3,0(t1)
ffffffffc02004aa:	715d                	addi	sp,sp,-80
ffffffffc02004ac:	ec06                	sd	ra,24(sp)
ffffffffc02004ae:	e822                	sd	s0,16(sp)
ffffffffc02004b0:	f436                	sd	a3,40(sp)
ffffffffc02004b2:	f83a                	sd	a4,48(sp)
ffffffffc02004b4:	fc3e                	sd	a5,56(sp)
ffffffffc02004b6:	e0c2                	sd	a6,64(sp)
ffffffffc02004b8:	e4c6                	sd	a7,72(sp)
ffffffffc02004ba:	020e1a63          	bnez	t3,ffffffffc02004ee <__panic+0x50>
ffffffffc02004be:	4785                	li	a5,1
ffffffffc02004c0:	00f33023          	sd	a5,0(t1)
ffffffffc02004c4:	8432                	mv	s0,a2
ffffffffc02004c6:	103c                	addi	a5,sp,40
ffffffffc02004c8:	862e                	mv	a2,a1
ffffffffc02004ca:	85aa                	mv	a1,a0
ffffffffc02004cc:	0000b517          	auipc	a0,0xb
ffffffffc02004d0:	27450513          	addi	a0,a0,628 # ffffffffc020b740 <commands+0x48>
ffffffffc02004d4:	e43e                	sd	a5,8(sp)
ffffffffc02004d6:	cd1ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004da:	65a2                	ld	a1,8(sp)
ffffffffc02004dc:	8522                	mv	a0,s0
ffffffffc02004de:	ca3ff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc02004e2:	0000c517          	auipc	a0,0xc
ffffffffc02004e6:	51e50513          	addi	a0,a0,1310 # ffffffffc020ca00 <default_pmm_manager+0x610>
ffffffffc02004ea:	cbdff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	48a1                	li	a7,8
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	778000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02004fe:	4501                	li	a0,0
ffffffffc0200500:	e57ff0ef          	jal	ra,ffffffffc0200356 <kmonitor>
ffffffffc0200504:	bfed                	j	ffffffffc02004fe <__panic+0x60>

ffffffffc0200506 <__warn>:
ffffffffc0200506:	715d                	addi	sp,sp,-80
ffffffffc0200508:	832e                	mv	t1,a1
ffffffffc020050a:	e822                	sd	s0,16(sp)
ffffffffc020050c:	85aa                	mv	a1,a0
ffffffffc020050e:	8432                	mv	s0,a2
ffffffffc0200510:	fc3e                	sd	a5,56(sp)
ffffffffc0200512:	861a                	mv	a2,t1
ffffffffc0200514:	103c                	addi	a5,sp,40
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	24a50513          	addi	a0,a0,586 # ffffffffc020b760 <commands+0x68>
ffffffffc020051e:	ec06                	sd	ra,24(sp)
ffffffffc0200520:	f436                	sd	a3,40(sp)
ffffffffc0200522:	f83a                	sd	a4,48(sp)
ffffffffc0200524:	e0c2                	sd	a6,64(sp)
ffffffffc0200526:	e4c6                	sd	a7,72(sp)
ffffffffc0200528:	e43e                	sd	a5,8(sp)
ffffffffc020052a:	c7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020052e:	65a2                	ld	a1,8(sp)
ffffffffc0200530:	8522                	mv	a0,s0
ffffffffc0200532:	c4fff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc0200536:	0000c517          	auipc	a0,0xc
ffffffffc020053a:	4ca50513          	addi	a0,a0,1226 # ffffffffc020ca00 <default_pmm_manager+0x610>
ffffffffc020053e:	c69ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200542:	60e2                	ld	ra,24(sp)
ffffffffc0200544:	6442                	ld	s0,16(sp)
ffffffffc0200546:	6161                	addi	sp,sp,80
ffffffffc0200548:	8082                	ret

ffffffffc020054a <clock_init>:
ffffffffc020054a:	02000793          	li	a5,32
ffffffffc020054e:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200552:	c0102573          	rdtime	a0
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	0000b517          	auipc	a0,0xb
ffffffffc020056c:	21850513          	addi	a0,a0,536 # ffffffffc020b780 <commands+0x88>
ffffffffc0200570:	00096797          	auipc	a5,0x96
ffffffffc0200574:	3007b023          	sd	zero,768(a5) # ffffffffc0296870 <ticks>
ffffffffc0200578:	b13d                	j	ffffffffc02001a6 <cprintf>

ffffffffc020057a <clock_set_next_event>:
ffffffffc020057a:	c0102573          	rdtime	a0
ffffffffc020057e:	67e1                	lui	a5,0x18
ffffffffc0200580:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4881                	li	a7,0
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <cons_init>:
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4889                	li	a7,2
ffffffffc020059a:	00000073          	ecall
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <cons_putc>:
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	100027f3          	csrr	a5,sstatus
ffffffffc02005a8:	8b89                	andi	a5,a5,2
ffffffffc02005aa:	4701                	li	a4,0
ffffffffc02005ac:	ef95                	bnez	a5,ffffffffc02005e8 <cons_putc+0x48>
ffffffffc02005ae:	47a1                	li	a5,8
ffffffffc02005b0:	00f50b63          	beq	a0,a5,ffffffffc02005c6 <cons_putc+0x26>
ffffffffc02005b4:	4581                	li	a1,0
ffffffffc02005b6:	4601                	li	a2,0
ffffffffc02005b8:	4885                	li	a7,1
ffffffffc02005ba:	00000073          	ecall
ffffffffc02005be:	e315                	bnez	a4,ffffffffc02005e2 <cons_putc+0x42>
ffffffffc02005c0:	60e2                	ld	ra,24(sp)
ffffffffc02005c2:	6105                	addi	sp,sp,32
ffffffffc02005c4:	8082                	ret
ffffffffc02005c6:	4521                	li	a0,8
ffffffffc02005c8:	4581                	li	a1,0
ffffffffc02005ca:	4601                	li	a2,0
ffffffffc02005cc:	4885                	li	a7,1
ffffffffc02005ce:	00000073          	ecall
ffffffffc02005d2:	02000513          	li	a0,32
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	4521                	li	a0,8
ffffffffc02005dc:	00000073          	ecall
ffffffffc02005e0:	d365                	beqz	a4,ffffffffc02005c0 <cons_putc+0x20>
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6105                	addi	sp,sp,32
ffffffffc02005e6:	a559                	j	ffffffffc0200c6c <intr_enable>
ffffffffc02005e8:	e42a                	sd	a0,8(sp)
ffffffffc02005ea:	688000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02005ee:	6522                	ld	a0,8(sp)
ffffffffc02005f0:	4705                	li	a4,1
ffffffffc02005f2:	bf75                	j	ffffffffc02005ae <cons_putc+0xe>

ffffffffc02005f4 <cons_getc>:
ffffffffc02005f4:	1101                	addi	sp,sp,-32
ffffffffc02005f6:	ec06                	sd	ra,24(sp)
ffffffffc02005f8:	100027f3          	csrr	a5,sstatus
ffffffffc02005fc:	8b89                	andi	a5,a5,2
ffffffffc02005fe:	4801                	li	a6,0
ffffffffc0200600:	e3d5                	bnez	a5,ffffffffc02006a4 <cons_getc+0xb0>
ffffffffc0200602:	00091697          	auipc	a3,0x91
ffffffffc0200606:	e5e68693          	addi	a3,a3,-418 # ffffffffc0291460 <cons>
ffffffffc020060a:	07f00713          	li	a4,127
ffffffffc020060e:	20000313          	li	t1,512
ffffffffc0200612:	a021                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200614:	0ff57513          	zext.b	a0,a0
ffffffffc0200618:	ef91                	bnez	a5,ffffffffc0200634 <cons_getc+0x40>
ffffffffc020061a:	4501                	li	a0,0
ffffffffc020061c:	4581                	li	a1,0
ffffffffc020061e:	4601                	li	a2,0
ffffffffc0200620:	4889                	li	a7,2
ffffffffc0200622:	00000073          	ecall
ffffffffc0200626:	0005079b          	sext.w	a5,a0
ffffffffc020062a:	0207c763          	bltz	a5,ffffffffc0200658 <cons_getc+0x64>
ffffffffc020062e:	fee793e3          	bne	a5,a4,ffffffffc0200614 <cons_getc+0x20>
ffffffffc0200632:	4521                	li	a0,8
ffffffffc0200634:	2046a783          	lw	a5,516(a3)
ffffffffc0200638:	02079613          	slli	a2,a5,0x20
ffffffffc020063c:	9201                	srli	a2,a2,0x20
ffffffffc020063e:	2785                	addiw	a5,a5,1
ffffffffc0200640:	9636                	add	a2,a2,a3
ffffffffc0200642:	20f6a223          	sw	a5,516(a3)
ffffffffc0200646:	00a60023          	sb	a0,0(a2)
ffffffffc020064a:	fc6798e3          	bne	a5,t1,ffffffffc020061a <cons_getc+0x26>
ffffffffc020064e:	00091797          	auipc	a5,0x91
ffffffffc0200652:	0007ab23          	sw	zero,22(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200656:	b7d1                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200658:	2006a783          	lw	a5,512(a3)
ffffffffc020065c:	2046a703          	lw	a4,516(a3)
ffffffffc0200660:	4501                	li	a0,0
ffffffffc0200662:	00f70f63          	beq	a4,a5,ffffffffc0200680 <cons_getc+0x8c>
ffffffffc0200666:	0017861b          	addiw	a2,a5,1
ffffffffc020066a:	1782                	slli	a5,a5,0x20
ffffffffc020066c:	9381                	srli	a5,a5,0x20
ffffffffc020066e:	97b6                	add	a5,a5,a3
ffffffffc0200670:	20c6a023          	sw	a2,512(a3)
ffffffffc0200674:	20000713          	li	a4,512
ffffffffc0200678:	0007c503          	lbu	a0,0(a5)
ffffffffc020067c:	00e60763          	beq	a2,a4,ffffffffc020068a <cons_getc+0x96>
ffffffffc0200680:	00081b63          	bnez	a6,ffffffffc0200696 <cons_getc+0xa2>
ffffffffc0200684:	60e2                	ld	ra,24(sp)
ffffffffc0200686:	6105                	addi	sp,sp,32
ffffffffc0200688:	8082                	ret
ffffffffc020068a:	00091797          	auipc	a5,0x91
ffffffffc020068e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200692:	fe0809e3          	beqz	a6,ffffffffc0200684 <cons_getc+0x90>
ffffffffc0200696:	e42a                	sd	a0,8(sp)
ffffffffc0200698:	5d4000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020069c:	60e2                	ld	ra,24(sp)
ffffffffc020069e:	6522                	ld	a0,8(sp)
ffffffffc02006a0:	6105                	addi	sp,sp,32
ffffffffc02006a2:	8082                	ret
ffffffffc02006a4:	5ce000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02006a8:	4805                	li	a6,1
ffffffffc02006aa:	bfa1                	j	ffffffffc0200602 <cons_getc+0xe>

ffffffffc02006ac <dtb_init>:
ffffffffc02006ac:	7119                	addi	sp,sp,-128
ffffffffc02006ae:	0000b517          	auipc	a0,0xb
ffffffffc02006b2:	0f250513          	addi	a0,a0,242 # ffffffffc020b7a0 <commands+0xa8>
ffffffffc02006b6:	fc86                	sd	ra,120(sp)
ffffffffc02006b8:	f8a2                	sd	s0,112(sp)
ffffffffc02006ba:	e8d2                	sd	s4,80(sp)
ffffffffc02006bc:	f4a6                	sd	s1,104(sp)
ffffffffc02006be:	f0ca                	sd	s2,96(sp)
ffffffffc02006c0:	ecce                	sd	s3,88(sp)
ffffffffc02006c2:	e4d6                	sd	s5,72(sp)
ffffffffc02006c4:	e0da                	sd	s6,64(sp)
ffffffffc02006c6:	fc5e                	sd	s7,56(sp)
ffffffffc02006c8:	f862                	sd	s8,48(sp)
ffffffffc02006ca:	f466                	sd	s9,40(sp)
ffffffffc02006cc:	f06a                	sd	s10,32(sp)
ffffffffc02006ce:	ec6e                	sd	s11,24(sp)
ffffffffc02006d0:	ad7ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006d4:	00014597          	auipc	a1,0x14
ffffffffc02006d8:	92c5b583          	ld	a1,-1748(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006dc:	0000b517          	auipc	a0,0xb
ffffffffc02006e0:	0d450513          	addi	a0,a0,212 # ffffffffc020b7b0 <commands+0xb8>
ffffffffc02006e4:	ac3ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006e8:	00014417          	auipc	s0,0x14
ffffffffc02006ec:	92040413          	addi	s0,s0,-1760 # ffffffffc0214008 <boot_dtb>
ffffffffc02006f0:	600c                	ld	a1,0(s0)
ffffffffc02006f2:	0000b517          	auipc	a0,0xb
ffffffffc02006f6:	0ce50513          	addi	a0,a0,206 # ffffffffc020b7c0 <commands+0xc8>
ffffffffc02006fa:	aadff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006fe:	00043a03          	ld	s4,0(s0)
ffffffffc0200702:	0000b517          	auipc	a0,0xb
ffffffffc0200706:	0d650513          	addi	a0,a0,214 # ffffffffc020b7d8 <commands+0xe0>
ffffffffc020070a:	120a0463          	beqz	s4,ffffffffc0200832 <dtb_init+0x186>
ffffffffc020070e:	57f5                	li	a5,-3
ffffffffc0200710:	07fa                	slli	a5,a5,0x1e
ffffffffc0200712:	00fa0733          	add	a4,s4,a5
ffffffffc0200716:	431c                	lw	a5,0(a4)
ffffffffc0200718:	00ff0637          	lui	a2,0xff0
ffffffffc020071c:	6b41                	lui	s6,0x10
ffffffffc020071e:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200722:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200726:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020072a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020072e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200732:	8df1                	and	a1,a1,a2
ffffffffc0200734:	8ec9                	or	a3,a3,a0
ffffffffc0200736:	0087979b          	slliw	a5,a5,0x8
ffffffffc020073a:	1b7d                	addi	s6,s6,-1
ffffffffc020073c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200740:	8dd5                	or	a1,a1,a3
ffffffffc0200742:	8ddd                	or	a1,a1,a5
ffffffffc0200744:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200748:	2581                	sext.w	a1,a1
ffffffffc020074a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc020074e:	10f59163          	bne	a1,a5,ffffffffc0200850 <dtb_init+0x1a4>
ffffffffc0200752:	471c                	lw	a5,8(a4)
ffffffffc0200754:	4754                	lw	a3,12(a4)
ffffffffc0200756:	4c81                	li	s9,0
ffffffffc0200758:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020075c:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200760:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200764:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200768:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020076c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200770:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200774:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200778:	0105959b          	slliw	a1,a1,0x10
ffffffffc020077c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200780:	8d71                	and	a0,a0,a2
ffffffffc0200782:	01146433          	or	s0,s0,a7
ffffffffc0200786:	0086969b          	slliw	a3,a3,0x8
ffffffffc020078a:	010a6a33          	or	s4,s4,a6
ffffffffc020078e:	8e6d                	and	a2,a2,a1
ffffffffc0200790:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200794:	8c49                	or	s0,s0,a0
ffffffffc0200796:	0166f6b3          	and	a3,a3,s6
ffffffffc020079a:	00ca6a33          	or	s4,s4,a2
ffffffffc020079e:	0167f7b3          	and	a5,a5,s6
ffffffffc02007a2:	8c55                	or	s0,s0,a3
ffffffffc02007a4:	00fa6a33          	or	s4,s4,a5
ffffffffc02007a8:	1402                	slli	s0,s0,0x20
ffffffffc02007aa:	1a02                	slli	s4,s4,0x20
ffffffffc02007ac:	9001                	srli	s0,s0,0x20
ffffffffc02007ae:	020a5a13          	srli	s4,s4,0x20
ffffffffc02007b2:	943a                	add	s0,s0,a4
ffffffffc02007b4:	9a3a                	add	s4,s4,a4
ffffffffc02007b6:	00ff0c37          	lui	s8,0xff0
ffffffffc02007ba:	4b8d                	li	s7,3
ffffffffc02007bc:	0000b917          	auipc	s2,0xb
ffffffffc02007c0:	06c90913          	addi	s2,s2,108 # ffffffffc020b828 <commands+0x130>
ffffffffc02007c4:	49bd                	li	s3,15
ffffffffc02007c6:	4d91                	li	s11,4
ffffffffc02007c8:	4d05                	li	s10,1
ffffffffc02007ca:	0000b497          	auipc	s1,0xb
ffffffffc02007ce:	05648493          	addi	s1,s1,86 # ffffffffc020b820 <commands+0x128>
ffffffffc02007d2:	000a2703          	lw	a4,0(s4)
ffffffffc02007d6:	004a0a93          	addi	s5,s4,4
ffffffffc02007da:	0087569b          	srliw	a3,a4,0x8
ffffffffc02007de:	0187179b          	slliw	a5,a4,0x18
ffffffffc02007e2:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e6:	0106969b          	slliw	a3,a3,0x10
ffffffffc02007ea:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ee:	8fd1                	or	a5,a5,a2
ffffffffc02007f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02007f4:	0087171b          	slliw	a4,a4,0x8
ffffffffc02007f8:	8fd5                	or	a5,a5,a3
ffffffffc02007fa:	00eb7733          	and	a4,s6,a4
ffffffffc02007fe:	8fd9                	or	a5,a5,a4
ffffffffc0200800:	2781                	sext.w	a5,a5
ffffffffc0200802:	09778c63          	beq	a5,s7,ffffffffc020089a <dtb_init+0x1ee>
ffffffffc0200806:	00fbea63          	bltu	s7,a5,ffffffffc020081a <dtb_init+0x16e>
ffffffffc020080a:	07a78663          	beq	a5,s10,ffffffffc0200876 <dtb_init+0x1ca>
ffffffffc020080e:	4709                	li	a4,2
ffffffffc0200810:	00e79763          	bne	a5,a4,ffffffffc020081e <dtb_init+0x172>
ffffffffc0200814:	4c81                	li	s9,0
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	bf6d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020081a:	ffb78ee3          	beq	a5,s11,ffffffffc0200816 <dtb_init+0x16a>
ffffffffc020081e:	0000b517          	auipc	a0,0xb
ffffffffc0200822:	08250513          	addi	a0,a0,130 # ffffffffc020b8a0 <commands+0x1a8>
ffffffffc0200826:	981ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020082a:	0000b517          	auipc	a0,0xb
ffffffffc020082e:	0ae50513          	addi	a0,a0,174 # ffffffffc020b8d8 <commands+0x1e0>
ffffffffc0200832:	7446                	ld	s0,112(sp)
ffffffffc0200834:	70e6                	ld	ra,120(sp)
ffffffffc0200836:	74a6                	ld	s1,104(sp)
ffffffffc0200838:	7906                	ld	s2,96(sp)
ffffffffc020083a:	69e6                	ld	s3,88(sp)
ffffffffc020083c:	6a46                	ld	s4,80(sp)
ffffffffc020083e:	6aa6                	ld	s5,72(sp)
ffffffffc0200840:	6b06                	ld	s6,64(sp)
ffffffffc0200842:	7be2                	ld	s7,56(sp)
ffffffffc0200844:	7c42                	ld	s8,48(sp)
ffffffffc0200846:	7ca2                	ld	s9,40(sp)
ffffffffc0200848:	7d02                	ld	s10,32(sp)
ffffffffc020084a:	6de2                	ld	s11,24(sp)
ffffffffc020084c:	6109                	addi	sp,sp,128
ffffffffc020084e:	baa1                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200850:	7446                	ld	s0,112(sp)
ffffffffc0200852:	70e6                	ld	ra,120(sp)
ffffffffc0200854:	74a6                	ld	s1,104(sp)
ffffffffc0200856:	7906                	ld	s2,96(sp)
ffffffffc0200858:	69e6                	ld	s3,88(sp)
ffffffffc020085a:	6a46                	ld	s4,80(sp)
ffffffffc020085c:	6aa6                	ld	s5,72(sp)
ffffffffc020085e:	6b06                	ld	s6,64(sp)
ffffffffc0200860:	7be2                	ld	s7,56(sp)
ffffffffc0200862:	7c42                	ld	s8,48(sp)
ffffffffc0200864:	7ca2                	ld	s9,40(sp)
ffffffffc0200866:	7d02                	ld	s10,32(sp)
ffffffffc0200868:	6de2                	ld	s11,24(sp)
ffffffffc020086a:	0000b517          	auipc	a0,0xb
ffffffffc020086e:	f8e50513          	addi	a0,a0,-114 # ffffffffc020b7f8 <commands+0x100>
ffffffffc0200872:	6109                	addi	sp,sp,128
ffffffffc0200874:	ba0d                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200876:	8556                	mv	a0,s5
ffffffffc0200878:	30b0a0ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc020087c:	8a2a                	mv	s4,a0
ffffffffc020087e:	4619                	li	a2,6
ffffffffc0200880:	85a6                	mv	a1,s1
ffffffffc0200882:	8556                	mv	a0,s5
ffffffffc0200884:	2a01                	sext.w	s4,s4
ffffffffc0200886:	3630a0ef          	jal	ra,ffffffffc020b3e8 <strncmp>
ffffffffc020088a:	e111                	bnez	a0,ffffffffc020088e <dtb_init+0x1e2>
ffffffffc020088c:	4c85                	li	s9,1
ffffffffc020088e:	0a91                	addi	s5,s5,4
ffffffffc0200890:	9ad2                	add	s5,s5,s4
ffffffffc0200892:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200896:	8a56                	mv	s4,s5
ffffffffc0200898:	bf2d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020089a:	004a2783          	lw	a5,4(s4)
ffffffffc020089e:	00ca0693          	addi	a3,s4,12
ffffffffc02008a2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02008a6:	01879a9b          	slliw	s5,a5,0x18
ffffffffc02008aa:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008ae:	0107171b          	slliw	a4,a4,0x10
ffffffffc02008b2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008b6:	00caeab3          	or	s5,s5,a2
ffffffffc02008ba:	01877733          	and	a4,a4,s8
ffffffffc02008be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02008c2:	00eaeab3          	or	s5,s5,a4
ffffffffc02008c6:	00fb77b3          	and	a5,s6,a5
ffffffffc02008ca:	00faeab3          	or	s5,s5,a5
ffffffffc02008ce:	2a81                	sext.w	s5,s5
ffffffffc02008d0:	000c9c63          	bnez	s9,ffffffffc02008e8 <dtb_init+0x23c>
ffffffffc02008d4:	1a82                	slli	s5,s5,0x20
ffffffffc02008d6:	00368793          	addi	a5,a3,3
ffffffffc02008da:	020ada93          	srli	s5,s5,0x20
ffffffffc02008de:	9abe                	add	s5,s5,a5
ffffffffc02008e0:	ffcafa93          	andi	s5,s5,-4
ffffffffc02008e4:	8a56                	mv	s4,s5
ffffffffc02008e6:	b5f5                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc02008e8:	008a2783          	lw	a5,8(s4)
ffffffffc02008ec:	85ca                	mv	a1,s2
ffffffffc02008ee:	e436                	sd	a3,8(sp)
ffffffffc02008f0:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02008f4:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008f8:	0187971b          	slliw	a4,a5,0x18
ffffffffc02008fc:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200900:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200904:	8f51                	or	a4,a4,a2
ffffffffc0200906:	01857533          	and	a0,a0,s8
ffffffffc020090a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020090e:	8d59                	or	a0,a0,a4
ffffffffc0200910:	00fb77b3          	and	a5,s6,a5
ffffffffc0200914:	8d5d                	or	a0,a0,a5
ffffffffc0200916:	1502                	slli	a0,a0,0x20
ffffffffc0200918:	9101                	srli	a0,a0,0x20
ffffffffc020091a:	9522                	add	a0,a0,s0
ffffffffc020091c:	2af0a0ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc0200920:	66a2                	ld	a3,8(sp)
ffffffffc0200922:	f94d                	bnez	a0,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200924:	fb59f8e3          	bgeu	s3,s5,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200928:	00ca3783          	ld	a5,12(s4)
ffffffffc020092c:	014a3703          	ld	a4,20(s4)
ffffffffc0200930:	0000b517          	auipc	a0,0xb
ffffffffc0200934:	f0050513          	addi	a0,a0,-256 # ffffffffc020b830 <commands+0x138>
ffffffffc0200938:	4207d613          	srai	a2,a5,0x20
ffffffffc020093c:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200940:	42075593          	srai	a1,a4,0x20
ffffffffc0200944:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200948:	0186581b          	srliw	a6,a2,0x18
ffffffffc020094c:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200950:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200954:	0187d693          	srli	a3,a5,0x18
ffffffffc0200958:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020095c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200960:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200964:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200968:	010f6f33          	or	t5,t5,a6
ffffffffc020096c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200970:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200974:	01837333          	and	t1,t1,s8
ffffffffc0200978:	01c46433          	or	s0,s0,t3
ffffffffc020097c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200980:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200984:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200988:	0107581b          	srliw	a6,a4,0x10
ffffffffc020098c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200990:	8361                	srli	a4,a4,0x18
ffffffffc0200992:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200996:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020099a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020099e:	00cb7633          	and	a2,s6,a2
ffffffffc02009a2:	0088181b          	slliw	a6,a6,0x8
ffffffffc02009a6:	0085959b          	slliw	a1,a1,0x8
ffffffffc02009aa:	00646433          	or	s0,s0,t1
ffffffffc02009ae:	0187f7b3          	and	a5,a5,s8
ffffffffc02009b2:	01fe6333          	or	t1,t3,t6
ffffffffc02009b6:	01877c33          	and	s8,a4,s8
ffffffffc02009ba:	0088989b          	slliw	a7,a7,0x8
ffffffffc02009be:	011b78b3          	and	a7,s6,a7
ffffffffc02009c2:	005eeeb3          	or	t4,t4,t0
ffffffffc02009c6:	00c6e733          	or	a4,a3,a2
ffffffffc02009ca:	006c6c33          	or	s8,s8,t1
ffffffffc02009ce:	010b76b3          	and	a3,s6,a6
ffffffffc02009d2:	00bb7b33          	and	s6,s6,a1
ffffffffc02009d6:	01d7e7b3          	or	a5,a5,t4
ffffffffc02009da:	016c6b33          	or	s6,s8,s6
ffffffffc02009de:	01146433          	or	s0,s0,a7
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	1702                	slli	a4,a4,0x20
ffffffffc02009e6:	1b02                	slli	s6,s6,0x20
ffffffffc02009e8:	1782                	slli	a5,a5,0x20
ffffffffc02009ea:	9301                	srli	a4,a4,0x20
ffffffffc02009ec:	1402                	slli	s0,s0,0x20
ffffffffc02009ee:	020b5b13          	srli	s6,s6,0x20
ffffffffc02009f2:	0167eb33          	or	s6,a5,s6
ffffffffc02009f6:	8c59                	or	s0,s0,a4
ffffffffc02009f8:	faeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a2                	mv	a1,s0
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	e5250513          	addi	a0,a0,-430 # ffffffffc020b850 <commands+0x158>
ffffffffc0200a06:	fa0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	014b5613          	srli	a2,s6,0x14
ffffffffc0200a0e:	85da                	mv	a1,s6
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	e5850513          	addi	a0,a0,-424 # ffffffffc020b868 <commands+0x170>
ffffffffc0200a18:	f8eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	008b05b3          	add	a1,s6,s0
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	e6650513          	addi	a0,a0,-410 # ffffffffc020b888 <commands+0x190>
ffffffffc0200a2a:	f7cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	0000b517          	auipc	a0,0xb
ffffffffc0200a32:	eaa50513          	addi	a0,a0,-342 # ffffffffc020b8d8 <commands+0x1e0>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200a3e:	00096797          	auipc	a5,0x96
ffffffffc0200a42:	e567b123          	sd	s6,-446(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200a46:	b3f5                	j	ffffffffc0200832 <dtb_init+0x186>

ffffffffc0200a48 <get_memory_base>:
ffffffffc0200a48:	00096517          	auipc	a0,0x96
ffffffffc0200a4c:	e3053503          	ld	a0,-464(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200a50:	8082                	ret

ffffffffc0200a52 <get_memory_size>:
ffffffffc0200a52:	00096517          	auipc	a0,0x96
ffffffffc0200a56:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200a5a:	8082                	ret

ffffffffc0200a5c <ide_init>:
ffffffffc0200a5c:	1141                	addi	sp,sp,-16
ffffffffc0200a5e:	00091597          	auipc	a1,0x91
ffffffffc0200a62:	c5a58593          	addi	a1,a1,-934 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a66:	4505                	li	a0,1
ffffffffc0200a68:	e022                	sd	s0,0(sp)
ffffffffc0200a6a:	00091797          	auipc	a5,0x91
ffffffffc0200a6e:	be07af23          	sw	zero,-1026(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a72:	00091797          	auipc	a5,0x91
ffffffffc0200a76:	c407a323          	sw	zero,-954(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a7a:	00091797          	auipc	a5,0x91
ffffffffc0200a7e:	c807a723          	sw	zero,-882(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a82:	00091797          	auipc	a5,0x91
ffffffffc0200a86:	cc07ab23          	sw	zero,-810(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	00091417          	auipc	s0,0x91
ffffffffc0200a90:	bdc40413          	addi	s0,s0,-1060 # ffffffffc0291668 <ide_devices>
ffffffffc0200a94:	23a000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200a98:	483c                	lw	a5,80(s0)
ffffffffc0200a9a:	cf99                	beqz	a5,ffffffffc0200ab8 <ide_init+0x5c>
ffffffffc0200a9c:	00091597          	auipc	a1,0x91
ffffffffc0200aa0:	c6c58593          	addi	a1,a1,-916 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa4:	4509                	li	a0,2
ffffffffc0200aa6:	228000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200aaa:	0a042783          	lw	a5,160(s0)
ffffffffc0200aae:	c785                	beqz	a5,ffffffffc0200ad6 <ide_init+0x7a>
ffffffffc0200ab0:	60a2                	ld	ra,8(sp)
ffffffffc0200ab2:	6402                	ld	s0,0(sp)
ffffffffc0200ab4:	0141                	addi	sp,sp,16
ffffffffc0200ab6:	8082                	ret
ffffffffc0200ab8:	0000b697          	auipc	a3,0xb
ffffffffc0200abc:	e3868693          	addi	a3,a3,-456 # ffffffffc020b8f0 <commands+0x1f8>
ffffffffc0200ac0:	0000b617          	auipc	a2,0xb
ffffffffc0200ac4:	e4860613          	addi	a2,a2,-440 # ffffffffc020b908 <commands+0x210>
ffffffffc0200ac8:	45c5                	li	a1,17
ffffffffc0200aca:	0000b517          	auipc	a0,0xb
ffffffffc0200ace:	e5650513          	addi	a0,a0,-426 # ffffffffc020b920 <commands+0x228>
ffffffffc0200ad2:	9cdff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200ad6:	0000b697          	auipc	a3,0xb
ffffffffc0200ada:	e6268693          	addi	a3,a3,-414 # ffffffffc020b938 <commands+0x240>
ffffffffc0200ade:	0000b617          	auipc	a2,0xb
ffffffffc0200ae2:	e2a60613          	addi	a2,a2,-470 # ffffffffc020b908 <commands+0x210>
ffffffffc0200ae6:	45d1                	li	a1,20
ffffffffc0200ae8:	0000b517          	auipc	a0,0xb
ffffffffc0200aec:	e3850513          	addi	a0,a0,-456 # ffffffffc020b920 <commands+0x228>
ffffffffc0200af0:	9afff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200af4 <ide_device_valid>:
ffffffffc0200af4:	478d                	li	a5,3
ffffffffc0200af6:	00a7ef63          	bltu	a5,a0,ffffffffc0200b14 <ide_device_valid+0x20>
ffffffffc0200afa:	00251793          	slli	a5,a0,0x2
ffffffffc0200afe:	953e                	add	a0,a0,a5
ffffffffc0200b00:	0512                	slli	a0,a0,0x4
ffffffffc0200b02:	00091797          	auipc	a5,0x91
ffffffffc0200b06:	b6678793          	addi	a5,a5,-1178 # ffffffffc0291668 <ide_devices>
ffffffffc0200b0a:	953e                	add	a0,a0,a5
ffffffffc0200b0c:	4108                	lw	a0,0(a0)
ffffffffc0200b0e:	00a03533          	snez	a0,a0
ffffffffc0200b12:	8082                	ret
ffffffffc0200b14:	4501                	li	a0,0
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <ide_device_size>:
ffffffffc0200b18:	478d                	li	a5,3
ffffffffc0200b1a:	02a7e163          	bltu	a5,a0,ffffffffc0200b3c <ide_device_size+0x24>
ffffffffc0200b1e:	00251793          	slli	a5,a0,0x2
ffffffffc0200b22:	953e                	add	a0,a0,a5
ffffffffc0200b24:	0512                	slli	a0,a0,0x4
ffffffffc0200b26:	00091797          	auipc	a5,0x91
ffffffffc0200b2a:	b4278793          	addi	a5,a5,-1214 # ffffffffc0291668 <ide_devices>
ffffffffc0200b2e:	97aa                	add	a5,a5,a0
ffffffffc0200b30:	4398                	lw	a4,0(a5)
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	c709                	beqz	a4,ffffffffc0200b3e <ide_device_size+0x26>
ffffffffc0200b36:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b3a:	8082                	ret
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	8082                	ret

ffffffffc0200b40 <ide_read_secs>:
ffffffffc0200b40:	1141                	addi	sp,sp,-16
ffffffffc0200b42:	e406                	sd	ra,8(sp)
ffffffffc0200b44:	08000793          	li	a5,128
ffffffffc0200b48:	04d7e763          	bltu	a5,a3,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b4c:	478d                	li	a5,3
ffffffffc0200b4e:	0005081b          	sext.w	a6,a0
ffffffffc0200b52:	04a7e263          	bltu	a5,a0,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b56:	00281793          	slli	a5,a6,0x2
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0792                	slli	a5,a5,0x4
ffffffffc0200b5e:	00091817          	auipc	a6,0x91
ffffffffc0200b62:	b0a80813          	addi	a6,a6,-1270 # ffffffffc0291668 <ide_devices>
ffffffffc0200b66:	97c2                	add	a5,a5,a6
ffffffffc0200b68:	0007a883          	lw	a7,0(a5)
ffffffffc0200b6c:	02088563          	beqz	a7,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b70:	100008b7          	lui	a7,0x10000
ffffffffc0200b74:	0515f163          	bgeu	a1,a7,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
ffffffffc0200b7c:	00d58733          	add	a4,a1,a3
ffffffffc0200b80:	02e8eb63          	bltu	a7,a4,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b84:	00251713          	slli	a4,a0,0x2
ffffffffc0200b88:	60a2                	ld	ra,8(sp)
ffffffffc0200b8a:	63bc                	ld	a5,64(a5)
ffffffffc0200b8c:	953a                	add	a0,a0,a4
ffffffffc0200b8e:	0512                	slli	a0,a0,0x4
ffffffffc0200b90:	9542                	add	a0,a0,a6
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8782                	jr	a5
ffffffffc0200b96:	0000b697          	auipc	a3,0xb
ffffffffc0200b9a:	dba68693          	addi	a3,a3,-582 # ffffffffc020b950 <commands+0x258>
ffffffffc0200b9e:	0000b617          	auipc	a2,0xb
ffffffffc0200ba2:	d6a60613          	addi	a2,a2,-662 # ffffffffc020b908 <commands+0x210>
ffffffffc0200ba6:	02200593          	li	a1,34
ffffffffc0200baa:	0000b517          	auipc	a0,0xb
ffffffffc0200bae:	d7650513          	addi	a0,a0,-650 # ffffffffc020b920 <commands+0x228>
ffffffffc0200bb2:	8edff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	dc268693          	addi	a3,a3,-574 # ffffffffc020b978 <commands+0x280>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	d4a60613          	addi	a2,a2,-694 # ffffffffc020b908 <commands+0x210>
ffffffffc0200bc6:	02300593          	li	a1,35
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	d5650513          	addi	a0,a0,-682 # ffffffffc020b920 <commands+0x228>
ffffffffc0200bd2:	8cdff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200bd6 <ide_write_secs>:
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
ffffffffc0200bda:	08000793          	li	a5,128
ffffffffc0200bde:	04d7e763          	bltu	a5,a3,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200be2:	478d                	li	a5,3
ffffffffc0200be4:	0005081b          	sext.w	a6,a0
ffffffffc0200be8:	04a7e263          	bltu	a5,a0,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200bec:	00281793          	slli	a5,a6,0x2
ffffffffc0200bf0:	97c2                	add	a5,a5,a6
ffffffffc0200bf2:	0792                	slli	a5,a5,0x4
ffffffffc0200bf4:	00091817          	auipc	a6,0x91
ffffffffc0200bf8:	a7480813          	addi	a6,a6,-1420 # ffffffffc0291668 <ide_devices>
ffffffffc0200bfc:	97c2                	add	a5,a5,a6
ffffffffc0200bfe:	0007a883          	lw	a7,0(a5)
ffffffffc0200c02:	02088563          	beqz	a7,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200c06:	100008b7          	lui	a7,0x10000
ffffffffc0200c0a:	0515f163          	bgeu	a1,a7,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c0e:	1582                	slli	a1,a1,0x20
ffffffffc0200c10:	9181                	srli	a1,a1,0x20
ffffffffc0200c12:	00d58733          	add	a4,a1,a3
ffffffffc0200c16:	02e8eb63          	bltu	a7,a4,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c1a:	00251713          	slli	a4,a0,0x2
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
ffffffffc0200c20:	67bc                	ld	a5,72(a5)
ffffffffc0200c22:	953a                	add	a0,a0,a4
ffffffffc0200c24:	0512                	slli	a0,a0,0x4
ffffffffc0200c26:	9542                	add	a0,a0,a6
ffffffffc0200c28:	0141                	addi	sp,sp,16
ffffffffc0200c2a:	8782                	jr	a5
ffffffffc0200c2c:	0000b697          	auipc	a3,0xb
ffffffffc0200c30:	d2468693          	addi	a3,a3,-732 # ffffffffc020b950 <commands+0x258>
ffffffffc0200c34:	0000b617          	auipc	a2,0xb
ffffffffc0200c38:	cd460613          	addi	a2,a2,-812 # ffffffffc020b908 <commands+0x210>
ffffffffc0200c3c:	02900593          	li	a1,41
ffffffffc0200c40:	0000b517          	auipc	a0,0xb
ffffffffc0200c44:	ce050513          	addi	a0,a0,-800 # ffffffffc020b920 <commands+0x228>
ffffffffc0200c48:	857ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200c4c:	0000b697          	auipc	a3,0xb
ffffffffc0200c50:	d2c68693          	addi	a3,a3,-724 # ffffffffc020b978 <commands+0x280>
ffffffffc0200c54:	0000b617          	auipc	a2,0xb
ffffffffc0200c58:	cb460613          	addi	a2,a2,-844 # ffffffffc020b908 <commands+0x210>
ffffffffc0200c5c:	02a00593          	li	a1,42
ffffffffc0200c60:	0000b517          	auipc	a0,0xb
ffffffffc0200c64:	cc050513          	addi	a0,a0,-832 # ffffffffc020b920 <commands+0x228>
ffffffffc0200c68:	837ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200c6c <intr_enable>:
ffffffffc0200c6c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c70:	8082                	ret

ffffffffc0200c72 <intr_disable>:
ffffffffc0200c72:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <pic_init>:
ffffffffc0200c78:	8082                	ret

ffffffffc0200c7a <ramdisk_write>:
ffffffffc0200c7a:	00856703          	lwu	a4,8(a0)
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
ffffffffc0200c82:	8f0d                	sub	a4,a4,a1
ffffffffc0200c84:	87ae                	mv	a5,a1
ffffffffc0200c86:	85b2                	mv	a1,a2
ffffffffc0200c88:	00e6f363          	bgeu	a3,a4,ffffffffc0200c8e <ramdisk_write+0x14>
ffffffffc0200c8c:	8736                	mv	a4,a3
ffffffffc0200c8e:	6908                	ld	a0,16(a0)
ffffffffc0200c90:	07a6                	slli	a5,a5,0x9
ffffffffc0200c92:	00971613          	slli	a2,a4,0x9
ffffffffc0200c96:	953e                	add	a0,a0,a5
ffffffffc0200c98:	7de0a0ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	7b40a0ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	1101                	addi	sp,sp,-32
ffffffffc0200cd0:	e822                	sd	s0,16(sp)
ffffffffc0200cd2:	842e                	mv	s0,a1
ffffffffc0200cd4:	e426                	sd	s1,8(sp)
ffffffffc0200cd6:	05000613          	li	a2,80
ffffffffc0200cda:	84aa                	mv	s1,a0
ffffffffc0200cdc:	4581                	li	a1,0
ffffffffc0200cde:	8522                	mv	a0,s0
ffffffffc0200ce0:	ec06                	sd	ra,24(sp)
ffffffffc0200ce2:	e04a                	sd	s2,0(sp)
ffffffffc0200ce4:	7400a0ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0200ce8:	4785                	li	a5,1
ffffffffc0200cea:	06f48b63          	beq	s1,a5,ffffffffc0200d60 <ramdisk_init+0x92>
ffffffffc0200cee:	4789                	li	a5,2
ffffffffc0200cf0:	00090617          	auipc	a2,0x90
ffffffffc0200cf4:	32060613          	addi	a2,a2,800 # ffffffffc0291010 <arena>
ffffffffc0200cf8:	0001b917          	auipc	s2,0x1b
ffffffffc0200cfc:	01890913          	addi	s2,s2,24 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d00:	08f49563          	bne	s1,a5,ffffffffc0200d8a <ramdisk_init+0xbc>
ffffffffc0200d04:	06c90863          	beq	s2,a2,ffffffffc0200d74 <ramdisk_init+0xa6>
ffffffffc0200d08:	412604b3          	sub	s1,a2,s2
ffffffffc0200d0c:	86a6                	mv	a3,s1
ffffffffc0200d0e:	85ca                	mv	a1,s2
ffffffffc0200d10:	167d                	addi	a2,a2,-1
ffffffffc0200d12:	0000b517          	auipc	a0,0xb
ffffffffc0200d16:	cbe50513          	addi	a0,a0,-834 # ffffffffc020b9d0 <commands+0x2d8>
ffffffffc0200d1a:	c8cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0785                	addi	a5,a5,1
ffffffffc0200d24:	0094d49b          	srliw	s1,s1,0x9
ffffffffc0200d28:	e01c                	sd	a5,0(s0)
ffffffffc0200d2a:	c404                	sw	s1,8(s0)
ffffffffc0200d2c:	01243823          	sd	s2,16(s0)
ffffffffc0200d30:	02040513          	addi	a0,s0,32
ffffffffc0200d34:	0000b597          	auipc	a1,0xb
ffffffffc0200d38:	cf458593          	addi	a1,a1,-780 # ffffffffc020ba28 <commands+0x330>
ffffffffc0200d3c:	67c0a0ef          	jal	ra,ffffffffc020b3b8 <strcpy>
ffffffffc0200d40:	00000797          	auipc	a5,0x0
ffffffffc0200d44:	f6478793          	addi	a5,a5,-156 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d48:	e03c                	sd	a5,64(s0)
ffffffffc0200d4a:	00000797          	auipc	a5,0x0
ffffffffc0200d4e:	f3078793          	addi	a5,a5,-208 # ffffffffc0200c7a <ramdisk_write>
ffffffffc0200d52:	60e2                	ld	ra,24(sp)
ffffffffc0200d54:	e43c                	sd	a5,72(s0)
ffffffffc0200d56:	6442                	ld	s0,16(sp)
ffffffffc0200d58:	64a2                	ld	s1,8(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
ffffffffc0200d5e:	8082                	ret
ffffffffc0200d60:	0001b617          	auipc	a2,0x1b
ffffffffc0200d64:	fb060613          	addi	a2,a2,-80 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d68:	00013917          	auipc	s2,0x13
ffffffffc0200d6c:	2a890913          	addi	s2,s2,680 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d70:	f8c91ce3          	bne	s2,a2,ffffffffc0200d08 <ramdisk_init+0x3a>
ffffffffc0200d74:	6442                	ld	s0,16(sp)
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	64a2                	ld	s1,8(sp)
ffffffffc0200d7a:	6902                	ld	s2,0(sp)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	c3c50513          	addi	a0,a0,-964 # ffffffffc020b9b8 <commands+0x2c0>
ffffffffc0200d84:	6105                	addi	sp,sp,32
ffffffffc0200d86:	c20ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d8a:	0000b617          	auipc	a2,0xb
ffffffffc0200d8e:	c6e60613          	addi	a2,a2,-914 # ffffffffc020b9f8 <commands+0x300>
ffffffffc0200d92:	03200593          	li	a1,50
ffffffffc0200d96:	0000b517          	auipc	a0,0xb
ffffffffc0200d9a:	c7a50513          	addi	a0,a0,-902 # ffffffffc020ba10 <commands+0x318>
ffffffffc0200d9e:	f00ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200da2 <idt_init>:
ffffffffc0200da2:	14005073          	csrwi	sscratch,0
ffffffffc0200da6:	00000797          	auipc	a5,0x0
ffffffffc0200daa:	43a78793          	addi	a5,a5,1082 # ffffffffc02011e0 <__alltraps>
ffffffffc0200dae:	10579073          	csrw	stvec,a5
ffffffffc0200db2:	000407b7          	lui	a5,0x40
ffffffffc0200db6:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dba:	8082                	ret

ffffffffc0200dbc <print_regs>:
ffffffffc0200dbc:	610c                	ld	a1,0(a0)
ffffffffc0200dbe:	1141                	addi	sp,sp,-16
ffffffffc0200dc0:	e022                	sd	s0,0(sp)
ffffffffc0200dc2:	842a                	mv	s0,a0
ffffffffc0200dc4:	0000b517          	auipc	a0,0xb
ffffffffc0200dc8:	c7450513          	addi	a0,a0,-908 # ffffffffc020ba38 <commands+0x340>
ffffffffc0200dcc:	e406                	sd	ra,8(sp)
ffffffffc0200dce:	bd8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dd2:	640c                	ld	a1,8(s0)
ffffffffc0200dd4:	0000b517          	auipc	a0,0xb
ffffffffc0200dd8:	c7c50513          	addi	a0,a0,-900 # ffffffffc020ba50 <commands+0x358>
ffffffffc0200ddc:	bcaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200de0:	680c                	ld	a1,16(s0)
ffffffffc0200de2:	0000b517          	auipc	a0,0xb
ffffffffc0200de6:	c8650513          	addi	a0,a0,-890 # ffffffffc020ba68 <commands+0x370>
ffffffffc0200dea:	bbcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dee:	6c0c                	ld	a1,24(s0)
ffffffffc0200df0:	0000b517          	auipc	a0,0xb
ffffffffc0200df4:	c9050513          	addi	a0,a0,-880 # ffffffffc020ba80 <commands+0x388>
ffffffffc0200df8:	baeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dfc:	700c                	ld	a1,32(s0)
ffffffffc0200dfe:	0000b517          	auipc	a0,0xb
ffffffffc0200e02:	c9a50513          	addi	a0,a0,-870 # ffffffffc020ba98 <commands+0x3a0>
ffffffffc0200e06:	ba0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e0a:	740c                	ld	a1,40(s0)
ffffffffc0200e0c:	0000b517          	auipc	a0,0xb
ffffffffc0200e10:	ca450513          	addi	a0,a0,-860 # ffffffffc020bab0 <commands+0x3b8>
ffffffffc0200e14:	b92ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e18:	780c                	ld	a1,48(s0)
ffffffffc0200e1a:	0000b517          	auipc	a0,0xb
ffffffffc0200e1e:	cae50513          	addi	a0,a0,-850 # ffffffffc020bac8 <commands+0x3d0>
ffffffffc0200e22:	b84ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e26:	7c0c                	ld	a1,56(s0)
ffffffffc0200e28:	0000b517          	auipc	a0,0xb
ffffffffc0200e2c:	cb850513          	addi	a0,a0,-840 # ffffffffc020bae0 <commands+0x3e8>
ffffffffc0200e30:	b76ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e34:	602c                	ld	a1,64(s0)
ffffffffc0200e36:	0000b517          	auipc	a0,0xb
ffffffffc0200e3a:	cc250513          	addi	a0,a0,-830 # ffffffffc020baf8 <commands+0x400>
ffffffffc0200e3e:	b68ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e42:	642c                	ld	a1,72(s0)
ffffffffc0200e44:	0000b517          	auipc	a0,0xb
ffffffffc0200e48:	ccc50513          	addi	a0,a0,-820 # ffffffffc020bb10 <commands+0x418>
ffffffffc0200e4c:	b5aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e50:	682c                	ld	a1,80(s0)
ffffffffc0200e52:	0000b517          	auipc	a0,0xb
ffffffffc0200e56:	cd650513          	addi	a0,a0,-810 # ffffffffc020bb28 <commands+0x430>
ffffffffc0200e5a:	b4cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e5e:	6c2c                	ld	a1,88(s0)
ffffffffc0200e60:	0000b517          	auipc	a0,0xb
ffffffffc0200e64:	ce050513          	addi	a0,a0,-800 # ffffffffc020bb40 <commands+0x448>
ffffffffc0200e68:	b3eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e6c:	702c                	ld	a1,96(s0)
ffffffffc0200e6e:	0000b517          	auipc	a0,0xb
ffffffffc0200e72:	cea50513          	addi	a0,a0,-790 # ffffffffc020bb58 <commands+0x460>
ffffffffc0200e76:	b30ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e7a:	742c                	ld	a1,104(s0)
ffffffffc0200e7c:	0000b517          	auipc	a0,0xb
ffffffffc0200e80:	cf450513          	addi	a0,a0,-780 # ffffffffc020bb70 <commands+0x478>
ffffffffc0200e84:	b22ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e88:	782c                	ld	a1,112(s0)
ffffffffc0200e8a:	0000b517          	auipc	a0,0xb
ffffffffc0200e8e:	cfe50513          	addi	a0,a0,-770 # ffffffffc020bb88 <commands+0x490>
ffffffffc0200e92:	b14ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e96:	7c2c                	ld	a1,120(s0)
ffffffffc0200e98:	0000b517          	auipc	a0,0xb
ffffffffc0200e9c:	d0850513          	addi	a0,a0,-760 # ffffffffc020bba0 <commands+0x4a8>
ffffffffc0200ea0:	b06ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ea4:	604c                	ld	a1,128(s0)
ffffffffc0200ea6:	0000b517          	auipc	a0,0xb
ffffffffc0200eaa:	d1250513          	addi	a0,a0,-750 # ffffffffc020bbb8 <commands+0x4c0>
ffffffffc0200eae:	af8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eb2:	644c                	ld	a1,136(s0)
ffffffffc0200eb4:	0000b517          	auipc	a0,0xb
ffffffffc0200eb8:	d1c50513          	addi	a0,a0,-740 # ffffffffc020bbd0 <commands+0x4d8>
ffffffffc0200ebc:	aeaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ec0:	684c                	ld	a1,144(s0)
ffffffffc0200ec2:	0000b517          	auipc	a0,0xb
ffffffffc0200ec6:	d2650513          	addi	a0,a0,-730 # ffffffffc020bbe8 <commands+0x4f0>
ffffffffc0200eca:	adcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ece:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed0:	0000b517          	auipc	a0,0xb
ffffffffc0200ed4:	d3050513          	addi	a0,a0,-720 # ffffffffc020bc00 <commands+0x508>
ffffffffc0200ed8:	aceff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200edc:	704c                	ld	a1,160(s0)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	d3a50513          	addi	a0,a0,-710 # ffffffffc020bc18 <commands+0x520>
ffffffffc0200ee6:	ac0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eea:	744c                	ld	a1,168(s0)
ffffffffc0200eec:	0000b517          	auipc	a0,0xb
ffffffffc0200ef0:	d4450513          	addi	a0,a0,-700 # ffffffffc020bc30 <commands+0x538>
ffffffffc0200ef4:	ab2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ef8:	784c                	ld	a1,176(s0)
ffffffffc0200efa:	0000b517          	auipc	a0,0xb
ffffffffc0200efe:	d4e50513          	addi	a0,a0,-690 # ffffffffc020bc48 <commands+0x550>
ffffffffc0200f02:	aa4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f06:	7c4c                	ld	a1,184(s0)
ffffffffc0200f08:	0000b517          	auipc	a0,0xb
ffffffffc0200f0c:	d5850513          	addi	a0,a0,-680 # ffffffffc020bc60 <commands+0x568>
ffffffffc0200f10:	a96ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f14:	606c                	ld	a1,192(s0)
ffffffffc0200f16:	0000b517          	auipc	a0,0xb
ffffffffc0200f1a:	d6250513          	addi	a0,a0,-670 # ffffffffc020bc78 <commands+0x580>
ffffffffc0200f1e:	a88ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f22:	646c                	ld	a1,200(s0)
ffffffffc0200f24:	0000b517          	auipc	a0,0xb
ffffffffc0200f28:	d6c50513          	addi	a0,a0,-660 # ffffffffc020bc90 <commands+0x598>
ffffffffc0200f2c:	a7aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f30:	686c                	ld	a1,208(s0)
ffffffffc0200f32:	0000b517          	auipc	a0,0xb
ffffffffc0200f36:	d7650513          	addi	a0,a0,-650 # ffffffffc020bca8 <commands+0x5b0>
ffffffffc0200f3a:	a6cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f3e:	6c6c                	ld	a1,216(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	d8050513          	addi	a0,a0,-640 # ffffffffc020bcc0 <commands+0x5c8>
ffffffffc0200f48:	a5eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	706c                	ld	a1,224(s0)
ffffffffc0200f4e:	0000b517          	auipc	a0,0xb
ffffffffc0200f52:	d8a50513          	addi	a0,a0,-630 # ffffffffc020bcd8 <commands+0x5e0>
ffffffffc0200f56:	a50ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f5a:	746c                	ld	a1,232(s0)
ffffffffc0200f5c:	0000b517          	auipc	a0,0xb
ffffffffc0200f60:	d9450513          	addi	a0,a0,-620 # ffffffffc020bcf0 <commands+0x5f8>
ffffffffc0200f64:	a42ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f68:	786c                	ld	a1,240(s0)
ffffffffc0200f6a:	0000b517          	auipc	a0,0xb
ffffffffc0200f6e:	d9e50513          	addi	a0,a0,-610 # ffffffffc020bd08 <commands+0x610>
ffffffffc0200f72:	a34ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f76:	7c6c                	ld	a1,248(s0)
ffffffffc0200f78:	6402                	ld	s0,0(sp)
ffffffffc0200f7a:	60a2                	ld	ra,8(sp)
ffffffffc0200f7c:	0000b517          	auipc	a0,0xb
ffffffffc0200f80:	da450513          	addi	a0,a0,-604 # ffffffffc020bd20 <commands+0x628>
ffffffffc0200f84:	0141                	addi	sp,sp,16
ffffffffc0200f86:	a20ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f8a <print_trapframe>:
ffffffffc0200f8a:	1141                	addi	sp,sp,-16
ffffffffc0200f8c:	e022                	sd	s0,0(sp)
ffffffffc0200f8e:	85aa                	mv	a1,a0
ffffffffc0200f90:	842a                	mv	s0,a0
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	da650513          	addi	a0,a0,-602 # ffffffffc020bd38 <commands+0x640>
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
ffffffffc0200f9c:	a0aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fa0:	8522                	mv	a0,s0
ffffffffc0200fa2:	e1bff0ef          	jal	ra,ffffffffc0200dbc <print_regs>
ffffffffc0200fa6:	10043583          	ld	a1,256(s0)
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	da650513          	addi	a0,a0,-602 # ffffffffc020bd50 <commands+0x658>
ffffffffc0200fb2:	9f4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	10843583          	ld	a1,264(s0)
ffffffffc0200fba:	0000b517          	auipc	a0,0xb
ffffffffc0200fbe:	dae50513          	addi	a0,a0,-594 # ffffffffc020bd68 <commands+0x670>
ffffffffc0200fc2:	9e4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fc6:	11043583          	ld	a1,272(s0)
ffffffffc0200fca:	0000b517          	auipc	a0,0xb
ffffffffc0200fce:	db650513          	addi	a0,a0,-586 # ffffffffc020bd80 <commands+0x688>
ffffffffc0200fd2:	9d4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fd6:	11843583          	ld	a1,280(s0)
ffffffffc0200fda:	6402                	ld	s0,0(sp)
ffffffffc0200fdc:	60a2                	ld	ra,8(sp)
ffffffffc0200fde:	0000b517          	auipc	a0,0xb
ffffffffc0200fe2:	db250513          	addi	a0,a0,-590 # ffffffffc020bd90 <commands+0x698>
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	9beff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fec <interrupt_handler>:
ffffffffc0200fec:	11853783          	ld	a5,280(a0)
ffffffffc0200ff0:	472d                	li	a4,11
ffffffffc0200ff2:	0786                	slli	a5,a5,0x1
ffffffffc0200ff4:	8385                	srli	a5,a5,0x1
ffffffffc0200ff6:	06f76c63          	bltu	a4,a5,ffffffffc020106e <interrupt_handler+0x82>
ffffffffc0200ffa:	0000b717          	auipc	a4,0xb
ffffffffc0200ffe:	e4e70713          	addi	a4,a4,-434 # ffffffffc020be48 <commands+0x750>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	8782                	jr	a5
ffffffffc020100c:	0000b517          	auipc	a0,0xb
ffffffffc0201010:	dfc50513          	addi	a0,a0,-516 # ffffffffc020be08 <commands+0x710>
ffffffffc0201014:	992ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201018:	0000b517          	auipc	a0,0xb
ffffffffc020101c:	dd050513          	addi	a0,a0,-560 # ffffffffc020bde8 <commands+0x6f0>
ffffffffc0201020:	986ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201024:	0000b517          	auipc	a0,0xb
ffffffffc0201028:	d8450513          	addi	a0,a0,-636 # ffffffffc020bda8 <commands+0x6b0>
ffffffffc020102c:	97aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	d9850513          	addi	a0,a0,-616 # ffffffffc020bdc8 <commands+0x6d0>
ffffffffc0201038:	96eff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103c:	1141                	addi	sp,sp,-16
ffffffffc020103e:	e406                	sd	ra,8(sp)
ffffffffc0201040:	d3aff0ef          	jal	ra,ffffffffc020057a <clock_set_next_event>
ffffffffc0201044:	00096717          	auipc	a4,0x96
ffffffffc0201048:	82c70713          	addi	a4,a4,-2004 # ffffffffc0296870 <ticks>
ffffffffc020104c:	631c                	ld	a5,0(a4)
ffffffffc020104e:	0785                	addi	a5,a5,1
ffffffffc0201050:	e31c                	sd	a5,0(a4)
ffffffffc0201052:	472060ef          	jal	ra,ffffffffc02074c4 <run_timer_list>
ffffffffc0201056:	d9eff0ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc020105a:	60a2                	ld	ra,8(sp)
ffffffffc020105c:	0141                	addi	sp,sp,16
ffffffffc020105e:	3370706f          	j	ffffffffc0208b94 <dev_stdin_write>
ffffffffc0201062:	0000b517          	auipc	a0,0xb
ffffffffc0201066:	dc650513          	addi	a0,a0,-570 # ffffffffc020be28 <commands+0x730>
ffffffffc020106a:	93cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020106e:	bf31                	j	ffffffffc0200f8a <print_trapframe>

ffffffffc0201070 <exception_handler>:
ffffffffc0201070:	11853783          	ld	a5,280(a0)
ffffffffc0201074:	1141                	addi	sp,sp,-16
ffffffffc0201076:	e022                	sd	s0,0(sp)
ffffffffc0201078:	e406                	sd	ra,8(sp)
ffffffffc020107a:	473d                	li	a4,15
ffffffffc020107c:	842a                	mv	s0,a0
ffffffffc020107e:	0af76b63          	bltu	a4,a5,ffffffffc0201134 <exception_handler+0xc4>
ffffffffc0201082:	0000b717          	auipc	a4,0xb
ffffffffc0201086:	f8670713          	addi	a4,a4,-122 # ffffffffc020c008 <commands+0x910>
ffffffffc020108a:	078a                	slli	a5,a5,0x2
ffffffffc020108c:	97ba                	add	a5,a5,a4
ffffffffc020108e:	439c                	lw	a5,0(a5)
ffffffffc0201090:	97ba                	add	a5,a5,a4
ffffffffc0201092:	8782                	jr	a5
ffffffffc0201094:	0000b517          	auipc	a0,0xb
ffffffffc0201098:	ecc50513          	addi	a0,a0,-308 # ffffffffc020bf60 <commands+0x868>
ffffffffc020109c:	90aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010a0:	10843783          	ld	a5,264(s0)
ffffffffc02010a4:	60a2                	ld	ra,8(sp)
ffffffffc02010a6:	0791                	addi	a5,a5,4
ffffffffc02010a8:	10f43423          	sd	a5,264(s0)
ffffffffc02010ac:	6402                	ld	s0,0(sp)
ffffffffc02010ae:	0141                	addi	sp,sp,16
ffffffffc02010b0:	62a0606f          	j	ffffffffc02076da <syscall>
ffffffffc02010b4:	0000b517          	auipc	a0,0xb
ffffffffc02010b8:	ecc50513          	addi	a0,a0,-308 # ffffffffc020bf80 <commands+0x888>
ffffffffc02010bc:	6402                	ld	s0,0(sp)
ffffffffc02010be:	60a2                	ld	ra,8(sp)
ffffffffc02010c0:	0141                	addi	sp,sp,16
ffffffffc02010c2:	8e4ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010c6:	0000b517          	auipc	a0,0xb
ffffffffc02010ca:	eda50513          	addi	a0,a0,-294 # ffffffffc020bfa0 <commands+0x8a8>
ffffffffc02010ce:	b7fd                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010d0:	0000b517          	auipc	a0,0xb
ffffffffc02010d4:	ef050513          	addi	a0,a0,-272 # ffffffffc020bfc0 <commands+0x8c8>
ffffffffc02010d8:	b7d5                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010da:	0000b517          	auipc	a0,0xb
ffffffffc02010de:	efe50513          	addi	a0,a0,-258 # ffffffffc020bfd8 <commands+0x8e0>
ffffffffc02010e2:	bfe9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010e4:	0000b517          	auipc	a0,0xb
ffffffffc02010e8:	f0c50513          	addi	a0,a0,-244 # ffffffffc020bff0 <commands+0x8f8>
ffffffffc02010ec:	bfc1                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010ee:	0000b517          	auipc	a0,0xb
ffffffffc02010f2:	d8a50513          	addi	a0,a0,-630 # ffffffffc020be78 <commands+0x780>
ffffffffc02010f6:	b7d9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010f8:	0000b517          	auipc	a0,0xb
ffffffffc02010fc:	da050513          	addi	a0,a0,-608 # ffffffffc020be98 <commands+0x7a0>
ffffffffc0201100:	bf75                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201102:	0000b517          	auipc	a0,0xb
ffffffffc0201106:	db650513          	addi	a0,a0,-586 # ffffffffc020beb8 <commands+0x7c0>
ffffffffc020110a:	bf4d                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020110c:	0000b517          	auipc	a0,0xb
ffffffffc0201110:	dc450513          	addi	a0,a0,-572 # ffffffffc020bed0 <commands+0x7d8>
ffffffffc0201114:	b765                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201116:	0000b517          	auipc	a0,0xb
ffffffffc020111a:	dca50513          	addi	a0,a0,-566 # ffffffffc020bee0 <commands+0x7e8>
ffffffffc020111e:	bf79                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201120:	0000b517          	auipc	a0,0xb
ffffffffc0201124:	de050513          	addi	a0,a0,-544 # ffffffffc020bf00 <commands+0x808>
ffffffffc0201128:	bf51                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020112a:	0000b517          	auipc	a0,0xb
ffffffffc020112e:	e1e50513          	addi	a0,a0,-482 # ffffffffc020bf48 <commands+0x850>
ffffffffc0201132:	b769                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201134:	8522                	mv	a0,s0
ffffffffc0201136:	6402                	ld	s0,0(sp)
ffffffffc0201138:	60a2                	ld	ra,8(sp)
ffffffffc020113a:	0141                	addi	sp,sp,16
ffffffffc020113c:	b5b9                	j	ffffffffc0200f8a <print_trapframe>
ffffffffc020113e:	0000b617          	auipc	a2,0xb
ffffffffc0201142:	dda60613          	addi	a2,a2,-550 # ffffffffc020bf18 <commands+0x820>
ffffffffc0201146:	0b100593          	li	a1,177
ffffffffc020114a:	0000b517          	auipc	a0,0xb
ffffffffc020114e:	de650513          	addi	a0,a0,-538 # ffffffffc020bf30 <commands+0x838>
ffffffffc0201152:	b4cff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201156 <trap>:
ffffffffc0201156:	1101                	addi	sp,sp,-32
ffffffffc0201158:	e822                	sd	s0,16(sp)
ffffffffc020115a:	00095417          	auipc	s0,0x95
ffffffffc020115e:	76640413          	addi	s0,s0,1894 # ffffffffc02968c0 <current>
ffffffffc0201162:	6018                	ld	a4,0(s0)
ffffffffc0201164:	ec06                	sd	ra,24(sp)
ffffffffc0201166:	e426                	sd	s1,8(sp)
ffffffffc0201168:	e04a                	sd	s2,0(sp)
ffffffffc020116a:	11853683          	ld	a3,280(a0)
ffffffffc020116e:	cf1d                	beqz	a4,ffffffffc02011ac <trap+0x56>
ffffffffc0201170:	10053483          	ld	s1,256(a0)
ffffffffc0201174:	0a073903          	ld	s2,160(a4)
ffffffffc0201178:	f348                	sd	a0,160(a4)
ffffffffc020117a:	1004f493          	andi	s1,s1,256
ffffffffc020117e:	0206c463          	bltz	a3,ffffffffc02011a6 <trap+0x50>
ffffffffc0201182:	eefff0ef          	jal	ra,ffffffffc0201070 <exception_handler>
ffffffffc0201186:	601c                	ld	a5,0(s0)
ffffffffc0201188:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc020118c:	e499                	bnez	s1,ffffffffc020119a <trap+0x44>
ffffffffc020118e:	0b07a703          	lw	a4,176(a5)
ffffffffc0201192:	8b05                	andi	a4,a4,1
ffffffffc0201194:	e329                	bnez	a4,ffffffffc02011d6 <trap+0x80>
ffffffffc0201196:	6f9c                	ld	a5,24(a5)
ffffffffc0201198:	eb85                	bnez	a5,ffffffffc02011c8 <trap+0x72>
ffffffffc020119a:	60e2                	ld	ra,24(sp)
ffffffffc020119c:	6442                	ld	s0,16(sp)
ffffffffc020119e:	64a2                	ld	s1,8(sp)
ffffffffc02011a0:	6902                	ld	s2,0(sp)
ffffffffc02011a2:	6105                	addi	sp,sp,32
ffffffffc02011a4:	8082                	ret
ffffffffc02011a6:	e47ff0ef          	jal	ra,ffffffffc0200fec <interrupt_handler>
ffffffffc02011aa:	bff1                	j	ffffffffc0201186 <trap+0x30>
ffffffffc02011ac:	0006c863          	bltz	a3,ffffffffc02011bc <trap+0x66>
ffffffffc02011b0:	6442                	ld	s0,16(sp)
ffffffffc02011b2:	60e2                	ld	ra,24(sp)
ffffffffc02011b4:	64a2                	ld	s1,8(sp)
ffffffffc02011b6:	6902                	ld	s2,0(sp)
ffffffffc02011b8:	6105                	addi	sp,sp,32
ffffffffc02011ba:	bd5d                	j	ffffffffc0201070 <exception_handler>
ffffffffc02011bc:	6442                	ld	s0,16(sp)
ffffffffc02011be:	60e2                	ld	ra,24(sp)
ffffffffc02011c0:	64a2                	ld	s1,8(sp)
ffffffffc02011c2:	6902                	ld	s2,0(sp)
ffffffffc02011c4:	6105                	addi	sp,sp,32
ffffffffc02011c6:	b51d                	j	ffffffffc0200fec <interrupt_handler>
ffffffffc02011c8:	6442                	ld	s0,16(sp)
ffffffffc02011ca:	60e2                	ld	ra,24(sp)
ffffffffc02011cc:	64a2                	ld	s1,8(sp)
ffffffffc02011ce:	6902                	ld	s2,0(sp)
ffffffffc02011d0:	6105                	addi	sp,sp,32
ffffffffc02011d2:	0e60606f          	j	ffffffffc02072b8 <schedule>
ffffffffc02011d6:	555d                	li	a0,-9
ffffffffc02011d8:	687040ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc02011dc:	601c                	ld	a5,0(s0)
ffffffffc02011de:	bf65                	j	ffffffffc0201196 <trap+0x40>

ffffffffc02011e0 <__alltraps>:
ffffffffc02011e0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011e4:	00011463          	bnez	sp,ffffffffc02011ec <__alltraps+0xc>
ffffffffc02011e8:	14002173          	csrr	sp,sscratch
ffffffffc02011ec:	712d                	addi	sp,sp,-288
ffffffffc02011ee:	e002                	sd	zero,0(sp)
ffffffffc02011f0:	e406                	sd	ra,8(sp)
ffffffffc02011f2:	ec0e                	sd	gp,24(sp)
ffffffffc02011f4:	f012                	sd	tp,32(sp)
ffffffffc02011f6:	f416                	sd	t0,40(sp)
ffffffffc02011f8:	f81a                	sd	t1,48(sp)
ffffffffc02011fa:	fc1e                	sd	t2,56(sp)
ffffffffc02011fc:	e0a2                	sd	s0,64(sp)
ffffffffc02011fe:	e4a6                	sd	s1,72(sp)
ffffffffc0201200:	e8aa                	sd	a0,80(sp)
ffffffffc0201202:	ecae                	sd	a1,88(sp)
ffffffffc0201204:	f0b2                	sd	a2,96(sp)
ffffffffc0201206:	f4b6                	sd	a3,104(sp)
ffffffffc0201208:	f8ba                	sd	a4,112(sp)
ffffffffc020120a:	fcbe                	sd	a5,120(sp)
ffffffffc020120c:	e142                	sd	a6,128(sp)
ffffffffc020120e:	e546                	sd	a7,136(sp)
ffffffffc0201210:	e94a                	sd	s2,144(sp)
ffffffffc0201212:	ed4e                	sd	s3,152(sp)
ffffffffc0201214:	f152                	sd	s4,160(sp)
ffffffffc0201216:	f556                	sd	s5,168(sp)
ffffffffc0201218:	f95a                	sd	s6,176(sp)
ffffffffc020121a:	fd5e                	sd	s7,184(sp)
ffffffffc020121c:	e1e2                	sd	s8,192(sp)
ffffffffc020121e:	e5e6                	sd	s9,200(sp)
ffffffffc0201220:	e9ea                	sd	s10,208(sp)
ffffffffc0201222:	edee                	sd	s11,216(sp)
ffffffffc0201224:	f1f2                	sd	t3,224(sp)
ffffffffc0201226:	f5f6                	sd	t4,232(sp)
ffffffffc0201228:	f9fa                	sd	t5,240(sp)
ffffffffc020122a:	fdfe                	sd	t6,248(sp)
ffffffffc020122c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201230:	100024f3          	csrr	s1,sstatus
ffffffffc0201234:	14102973          	csrr	s2,sepc
ffffffffc0201238:	143029f3          	csrr	s3,stval
ffffffffc020123c:	14202a73          	csrr	s4,scause
ffffffffc0201240:	e822                	sd	s0,16(sp)
ffffffffc0201242:	e226                	sd	s1,256(sp)
ffffffffc0201244:	e64a                	sd	s2,264(sp)
ffffffffc0201246:	ea4e                	sd	s3,272(sp)
ffffffffc0201248:	ee52                	sd	s4,280(sp)
ffffffffc020124a:	850a                	mv	a0,sp
ffffffffc020124c:	f0bff0ef          	jal	ra,ffffffffc0201156 <trap>

ffffffffc0201250 <__trapret>:
ffffffffc0201250:	6492                	ld	s1,256(sp)
ffffffffc0201252:	6932                	ld	s2,264(sp)
ffffffffc0201254:	1004f413          	andi	s0,s1,256
ffffffffc0201258:	e401                	bnez	s0,ffffffffc0201260 <__trapret+0x10>
ffffffffc020125a:	1200                	addi	s0,sp,288
ffffffffc020125c:	14041073          	csrw	sscratch,s0
ffffffffc0201260:	10049073          	csrw	sstatus,s1
ffffffffc0201264:	14191073          	csrw	sepc,s2
ffffffffc0201268:	60a2                	ld	ra,8(sp)
ffffffffc020126a:	61e2                	ld	gp,24(sp)
ffffffffc020126c:	7202                	ld	tp,32(sp)
ffffffffc020126e:	72a2                	ld	t0,40(sp)
ffffffffc0201270:	7342                	ld	t1,48(sp)
ffffffffc0201272:	73e2                	ld	t2,56(sp)
ffffffffc0201274:	6406                	ld	s0,64(sp)
ffffffffc0201276:	64a6                	ld	s1,72(sp)
ffffffffc0201278:	6546                	ld	a0,80(sp)
ffffffffc020127a:	65e6                	ld	a1,88(sp)
ffffffffc020127c:	7606                	ld	a2,96(sp)
ffffffffc020127e:	76a6                	ld	a3,104(sp)
ffffffffc0201280:	7746                	ld	a4,112(sp)
ffffffffc0201282:	77e6                	ld	a5,120(sp)
ffffffffc0201284:	680a                	ld	a6,128(sp)
ffffffffc0201286:	68aa                	ld	a7,136(sp)
ffffffffc0201288:	694a                	ld	s2,144(sp)
ffffffffc020128a:	69ea                	ld	s3,152(sp)
ffffffffc020128c:	7a0a                	ld	s4,160(sp)
ffffffffc020128e:	7aaa                	ld	s5,168(sp)
ffffffffc0201290:	7b4a                	ld	s6,176(sp)
ffffffffc0201292:	7bea                	ld	s7,184(sp)
ffffffffc0201294:	6c0e                	ld	s8,192(sp)
ffffffffc0201296:	6cae                	ld	s9,200(sp)
ffffffffc0201298:	6d4e                	ld	s10,208(sp)
ffffffffc020129a:	6dee                	ld	s11,216(sp)
ffffffffc020129c:	7e0e                	ld	t3,224(sp)
ffffffffc020129e:	7eae                	ld	t4,232(sp)
ffffffffc02012a0:	7f4e                	ld	t5,240(sp)
ffffffffc02012a2:	7fee                	ld	t6,248(sp)
ffffffffc02012a4:	6142                	ld	sp,16(sp)
ffffffffc02012a6:	10200073          	sret

ffffffffc02012aa <forkrets>:
ffffffffc02012aa:	812a                	mv	sp,a0
ffffffffc02012ac:	b755                	j	ffffffffc0201250 <__trapret>

ffffffffc02012ae <default_init>:
ffffffffc02012ae:	00090797          	auipc	a5,0x90
ffffffffc02012b2:	4fa78793          	addi	a5,a5,1274 # ffffffffc02917a8 <free_area>
ffffffffc02012b6:	e79c                	sd	a5,8(a5)
ffffffffc02012b8:	e39c                	sd	a5,0(a5)
ffffffffc02012ba:	0007a823          	sw	zero,16(a5)
ffffffffc02012be:	8082                	ret

ffffffffc02012c0 <default_nr_free_pages>:
ffffffffc02012c0:	00090517          	auipc	a0,0x90
ffffffffc02012c4:	4f856503          	lwu	a0,1272(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02012c8:	8082                	ret

ffffffffc02012ca <default_check>:
ffffffffc02012ca:	715d                	addi	sp,sp,-80
ffffffffc02012cc:	e0a2                	sd	s0,64(sp)
ffffffffc02012ce:	00090417          	auipc	s0,0x90
ffffffffc02012d2:	4da40413          	addi	s0,s0,1242 # ffffffffc02917a8 <free_area>
ffffffffc02012d6:	641c                	ld	a5,8(s0)
ffffffffc02012d8:	e486                	sd	ra,72(sp)
ffffffffc02012da:	fc26                	sd	s1,56(sp)
ffffffffc02012dc:	f84a                	sd	s2,48(sp)
ffffffffc02012de:	f44e                	sd	s3,40(sp)
ffffffffc02012e0:	f052                	sd	s4,32(sp)
ffffffffc02012e2:	ec56                	sd	s5,24(sp)
ffffffffc02012e4:	e85a                	sd	s6,16(sp)
ffffffffc02012e6:	e45e                	sd	s7,8(sp)
ffffffffc02012e8:	e062                	sd	s8,0(sp)
ffffffffc02012ea:	2a878d63          	beq	a5,s0,ffffffffc02015a4 <default_check+0x2da>
ffffffffc02012ee:	4481                	li	s1,0
ffffffffc02012f0:	4901                	li	s2,0
ffffffffc02012f2:	ff07b703          	ld	a4,-16(a5)
ffffffffc02012f6:	8b09                	andi	a4,a4,2
ffffffffc02012f8:	2a070a63          	beqz	a4,ffffffffc02015ac <default_check+0x2e2>
ffffffffc02012fc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201300:	679c                	ld	a5,8(a5)
ffffffffc0201302:	2905                	addiw	s2,s2,1
ffffffffc0201304:	9cb9                	addw	s1,s1,a4
ffffffffc0201306:	fe8796e3          	bne	a5,s0,ffffffffc02012f2 <default_check+0x28>
ffffffffc020130a:	89a6                	mv	s3,s1
ffffffffc020130c:	6df000ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc0201310:	6f351e63          	bne	a0,s3,ffffffffc0201a0c <default_check+0x742>
ffffffffc0201314:	4505                	li	a0,1
ffffffffc0201316:	657000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020131a:	8aaa                	mv	s5,a0
ffffffffc020131c:	42050863          	beqz	a0,ffffffffc020174c <default_check+0x482>
ffffffffc0201320:	4505                	li	a0,1
ffffffffc0201322:	64b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201326:	89aa                	mv	s3,a0
ffffffffc0201328:	70050263          	beqz	a0,ffffffffc0201a2c <default_check+0x762>
ffffffffc020132c:	4505                	li	a0,1
ffffffffc020132e:	63f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201332:	8a2a                	mv	s4,a0
ffffffffc0201334:	48050c63          	beqz	a0,ffffffffc02017cc <default_check+0x502>
ffffffffc0201338:	293a8a63          	beq	s5,s3,ffffffffc02015cc <default_check+0x302>
ffffffffc020133c:	28aa8863          	beq	s5,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201340:	28a98663          	beq	s3,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201344:	000aa783          	lw	a5,0(s5)
ffffffffc0201348:	2a079263          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020134c:	0009a783          	lw	a5,0(s3)
ffffffffc0201350:	28079e63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc0201354:	411c                	lw	a5,0(a0)
ffffffffc0201356:	28079b63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020135a:	00095797          	auipc	a5,0x95
ffffffffc020135e:	54e7b783          	ld	a5,1358(a5) # ffffffffc02968a8 <pages>
ffffffffc0201362:	40fa8733          	sub	a4,s5,a5
ffffffffc0201366:	0000e617          	auipc	a2,0xe
ffffffffc020136a:	3ca63603          	ld	a2,970(a2) # ffffffffc020f730 <nbase>
ffffffffc020136e:	8719                	srai	a4,a4,0x6
ffffffffc0201370:	9732                	add	a4,a4,a2
ffffffffc0201372:	00095697          	auipc	a3,0x95
ffffffffc0201376:	52e6b683          	ld	a3,1326(a3) # ffffffffc02968a0 <npage>
ffffffffc020137a:	06b2                	slli	a3,a3,0xc
ffffffffc020137c:	0732                	slli	a4,a4,0xc
ffffffffc020137e:	28d77763          	bgeu	a4,a3,ffffffffc020160c <default_check+0x342>
ffffffffc0201382:	40f98733          	sub	a4,s3,a5
ffffffffc0201386:	8719                	srai	a4,a4,0x6
ffffffffc0201388:	9732                	add	a4,a4,a2
ffffffffc020138a:	0732                	slli	a4,a4,0xc
ffffffffc020138c:	4cd77063          	bgeu	a4,a3,ffffffffc020184c <default_check+0x582>
ffffffffc0201390:	40f507b3          	sub	a5,a0,a5
ffffffffc0201394:	8799                	srai	a5,a5,0x6
ffffffffc0201396:	97b2                	add	a5,a5,a2
ffffffffc0201398:	07b2                	slli	a5,a5,0xc
ffffffffc020139a:	30d7f963          	bgeu	a5,a3,ffffffffc02016ac <default_check+0x3e2>
ffffffffc020139e:	4505                	li	a0,1
ffffffffc02013a0:	00043c03          	ld	s8,0(s0)
ffffffffc02013a4:	00843b83          	ld	s7,8(s0)
ffffffffc02013a8:	01042b03          	lw	s6,16(s0)
ffffffffc02013ac:	e400                	sd	s0,8(s0)
ffffffffc02013ae:	e000                	sd	s0,0(s0)
ffffffffc02013b0:	00090797          	auipc	a5,0x90
ffffffffc02013b4:	4007a423          	sw	zero,1032(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013b8:	5b5000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013bc:	2c051863          	bnez	a0,ffffffffc020168c <default_check+0x3c2>
ffffffffc02013c0:	4585                	li	a1,1
ffffffffc02013c2:	8556                	mv	a0,s5
ffffffffc02013c4:	5e7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013c8:	4585                	li	a1,1
ffffffffc02013ca:	854e                	mv	a0,s3
ffffffffc02013cc:	5df000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d0:	4585                	li	a1,1
ffffffffc02013d2:	8552                	mv	a0,s4
ffffffffc02013d4:	5d7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d8:	4818                	lw	a4,16(s0)
ffffffffc02013da:	478d                	li	a5,3
ffffffffc02013dc:	28f71863          	bne	a4,a5,ffffffffc020166c <default_check+0x3a2>
ffffffffc02013e0:	4505                	li	a0,1
ffffffffc02013e2:	58b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013e6:	89aa                	mv	s3,a0
ffffffffc02013e8:	26050263          	beqz	a0,ffffffffc020164c <default_check+0x382>
ffffffffc02013ec:	4505                	li	a0,1
ffffffffc02013ee:	57f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013f2:	8aaa                	mv	s5,a0
ffffffffc02013f4:	3a050c63          	beqz	a0,ffffffffc02017ac <default_check+0x4e2>
ffffffffc02013f8:	4505                	li	a0,1
ffffffffc02013fa:	573000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013fe:	8a2a                	mv	s4,a0
ffffffffc0201400:	38050663          	beqz	a0,ffffffffc020178c <default_check+0x4c2>
ffffffffc0201404:	4505                	li	a0,1
ffffffffc0201406:	567000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020140a:	36051163          	bnez	a0,ffffffffc020176c <default_check+0x4a2>
ffffffffc020140e:	4585                	li	a1,1
ffffffffc0201410:	854e                	mv	a0,s3
ffffffffc0201412:	599000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201416:	641c                	ld	a5,8(s0)
ffffffffc0201418:	20878a63          	beq	a5,s0,ffffffffc020162c <default_check+0x362>
ffffffffc020141c:	4505                	li	a0,1
ffffffffc020141e:	54f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201422:	30a99563          	bne	s3,a0,ffffffffc020172c <default_check+0x462>
ffffffffc0201426:	4505                	li	a0,1
ffffffffc0201428:	545000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020142c:	2e051063          	bnez	a0,ffffffffc020170c <default_check+0x442>
ffffffffc0201430:	481c                	lw	a5,16(s0)
ffffffffc0201432:	2a079d63          	bnez	a5,ffffffffc02016ec <default_check+0x422>
ffffffffc0201436:	854e                	mv	a0,s3
ffffffffc0201438:	4585                	li	a1,1
ffffffffc020143a:	01843023          	sd	s8,0(s0)
ffffffffc020143e:	01743423          	sd	s7,8(s0)
ffffffffc0201442:	01642823          	sw	s6,16(s0)
ffffffffc0201446:	565000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020144a:	4585                	li	a1,1
ffffffffc020144c:	8556                	mv	a0,s5
ffffffffc020144e:	55d000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201452:	4585                	li	a1,1
ffffffffc0201454:	8552                	mv	a0,s4
ffffffffc0201456:	555000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020145a:	4515                	li	a0,5
ffffffffc020145c:	511000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201460:	89aa                	mv	s3,a0
ffffffffc0201462:	26050563          	beqz	a0,ffffffffc02016cc <default_check+0x402>
ffffffffc0201466:	651c                	ld	a5,8(a0)
ffffffffc0201468:	8385                	srli	a5,a5,0x1
ffffffffc020146a:	8b85                	andi	a5,a5,1
ffffffffc020146c:	54079063          	bnez	a5,ffffffffc02019ac <default_check+0x6e2>
ffffffffc0201470:	4505                	li	a0,1
ffffffffc0201472:	00043b03          	ld	s6,0(s0)
ffffffffc0201476:	00843a83          	ld	s5,8(s0)
ffffffffc020147a:	e000                	sd	s0,0(s0)
ffffffffc020147c:	e400                	sd	s0,8(s0)
ffffffffc020147e:	4ef000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201482:	50051563          	bnez	a0,ffffffffc020198c <default_check+0x6c2>
ffffffffc0201486:	08098a13          	addi	s4,s3,128
ffffffffc020148a:	8552                	mv	a0,s4
ffffffffc020148c:	458d                	li	a1,3
ffffffffc020148e:	01042b83          	lw	s7,16(s0)
ffffffffc0201492:	00090797          	auipc	a5,0x90
ffffffffc0201496:	3207a323          	sw	zero,806(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020149a:	511000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020149e:	4511                	li	a0,4
ffffffffc02014a0:	4cd000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014a4:	4c051463          	bnez	a0,ffffffffc020196c <default_check+0x6a2>
ffffffffc02014a8:	0889b783          	ld	a5,136(s3)
ffffffffc02014ac:	8385                	srli	a5,a5,0x1
ffffffffc02014ae:	8b85                	andi	a5,a5,1
ffffffffc02014b0:	48078e63          	beqz	a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014b4:	0909a703          	lw	a4,144(s3)
ffffffffc02014b8:	478d                	li	a5,3
ffffffffc02014ba:	48f71963          	bne	a4,a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014be:	450d                	li	a0,3
ffffffffc02014c0:	4ad000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014c4:	8c2a                	mv	s8,a0
ffffffffc02014c6:	46050363          	beqz	a0,ffffffffc020192c <default_check+0x662>
ffffffffc02014ca:	4505                	li	a0,1
ffffffffc02014cc:	4a1000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014d0:	42051e63          	bnez	a0,ffffffffc020190c <default_check+0x642>
ffffffffc02014d4:	418a1c63          	bne	s4,s8,ffffffffc02018ec <default_check+0x622>
ffffffffc02014d8:	4585                	li	a1,1
ffffffffc02014da:	854e                	mv	a0,s3
ffffffffc02014dc:	4cf000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e0:	458d                	li	a1,3
ffffffffc02014e2:	8552                	mv	a0,s4
ffffffffc02014e4:	4c7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e8:	0089b783          	ld	a5,8(s3)
ffffffffc02014ec:	04098c13          	addi	s8,s3,64
ffffffffc02014f0:	8385                	srli	a5,a5,0x1
ffffffffc02014f2:	8b85                	andi	a5,a5,1
ffffffffc02014f4:	3c078c63          	beqz	a5,ffffffffc02018cc <default_check+0x602>
ffffffffc02014f8:	0109a703          	lw	a4,16(s3)
ffffffffc02014fc:	4785                	li	a5,1
ffffffffc02014fe:	3cf71763          	bne	a4,a5,ffffffffc02018cc <default_check+0x602>
ffffffffc0201502:	008a3783          	ld	a5,8(s4)
ffffffffc0201506:	8385                	srli	a5,a5,0x1
ffffffffc0201508:	8b85                	andi	a5,a5,1
ffffffffc020150a:	3a078163          	beqz	a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc020150e:	010a2703          	lw	a4,16(s4)
ffffffffc0201512:	478d                	li	a5,3
ffffffffc0201514:	38f71c63          	bne	a4,a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc0201518:	4505                	li	a0,1
ffffffffc020151a:	453000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020151e:	36a99763          	bne	s3,a0,ffffffffc020188c <default_check+0x5c2>
ffffffffc0201522:	4585                	li	a1,1
ffffffffc0201524:	487000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201528:	4509                	li	a0,2
ffffffffc020152a:	443000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020152e:	32aa1f63          	bne	s4,a0,ffffffffc020186c <default_check+0x5a2>
ffffffffc0201532:	4589                	li	a1,2
ffffffffc0201534:	477000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201538:	4585                	li	a1,1
ffffffffc020153a:	8562                	mv	a0,s8
ffffffffc020153c:	46f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201540:	4515                	li	a0,5
ffffffffc0201542:	42b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201546:	89aa                	mv	s3,a0
ffffffffc0201548:	48050263          	beqz	a0,ffffffffc02019cc <default_check+0x702>
ffffffffc020154c:	4505                	li	a0,1
ffffffffc020154e:	41f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201552:	2c051d63          	bnez	a0,ffffffffc020182c <default_check+0x562>
ffffffffc0201556:	481c                	lw	a5,16(s0)
ffffffffc0201558:	2a079a63          	bnez	a5,ffffffffc020180c <default_check+0x542>
ffffffffc020155c:	4595                	li	a1,5
ffffffffc020155e:	854e                	mv	a0,s3
ffffffffc0201560:	01742823          	sw	s7,16(s0)
ffffffffc0201564:	01643023          	sd	s6,0(s0)
ffffffffc0201568:	01543423          	sd	s5,8(s0)
ffffffffc020156c:	43f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201570:	641c                	ld	a5,8(s0)
ffffffffc0201572:	00878963          	beq	a5,s0,ffffffffc0201584 <default_check+0x2ba>
ffffffffc0201576:	ff87a703          	lw	a4,-8(a5)
ffffffffc020157a:	679c                	ld	a5,8(a5)
ffffffffc020157c:	397d                	addiw	s2,s2,-1
ffffffffc020157e:	9c99                	subw	s1,s1,a4
ffffffffc0201580:	fe879be3          	bne	a5,s0,ffffffffc0201576 <default_check+0x2ac>
ffffffffc0201584:	26091463          	bnez	s2,ffffffffc02017ec <default_check+0x522>
ffffffffc0201588:	46049263          	bnez	s1,ffffffffc02019ec <default_check+0x722>
ffffffffc020158c:	60a6                	ld	ra,72(sp)
ffffffffc020158e:	6406                	ld	s0,64(sp)
ffffffffc0201590:	74e2                	ld	s1,56(sp)
ffffffffc0201592:	7942                	ld	s2,48(sp)
ffffffffc0201594:	79a2                	ld	s3,40(sp)
ffffffffc0201596:	7a02                	ld	s4,32(sp)
ffffffffc0201598:	6ae2                	ld	s5,24(sp)
ffffffffc020159a:	6b42                	ld	s6,16(sp)
ffffffffc020159c:	6ba2                	ld	s7,8(sp)
ffffffffc020159e:	6c02                	ld	s8,0(sp)
ffffffffc02015a0:	6161                	addi	sp,sp,80
ffffffffc02015a2:	8082                	ret
ffffffffc02015a4:	4981                	li	s3,0
ffffffffc02015a6:	4481                	li	s1,0
ffffffffc02015a8:	4901                	li	s2,0
ffffffffc02015aa:	b38d                	j	ffffffffc020130c <default_check+0x42>
ffffffffc02015ac:	0000b697          	auipc	a3,0xb
ffffffffc02015b0:	a9c68693          	addi	a3,a3,-1380 # ffffffffc020c048 <commands+0x950>
ffffffffc02015b4:	0000a617          	auipc	a2,0xa
ffffffffc02015b8:	35460613          	addi	a2,a2,852 # ffffffffc020b908 <commands+0x210>
ffffffffc02015bc:	0ef00593          	li	a1,239
ffffffffc02015c0:	0000b517          	auipc	a0,0xb
ffffffffc02015c4:	a9850513          	addi	a0,a0,-1384 # ffffffffc020c058 <commands+0x960>
ffffffffc02015c8:	ed7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015cc:	0000b697          	auipc	a3,0xb
ffffffffc02015d0:	b2468693          	addi	a3,a3,-1244 # ffffffffc020c0f0 <commands+0x9f8>
ffffffffc02015d4:	0000a617          	auipc	a2,0xa
ffffffffc02015d8:	33460613          	addi	a2,a2,820 # ffffffffc020b908 <commands+0x210>
ffffffffc02015dc:	0bc00593          	li	a1,188
ffffffffc02015e0:	0000b517          	auipc	a0,0xb
ffffffffc02015e4:	a7850513          	addi	a0,a0,-1416 # ffffffffc020c058 <commands+0x960>
ffffffffc02015e8:	eb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015ec:	0000b697          	auipc	a3,0xb
ffffffffc02015f0:	b2c68693          	addi	a3,a3,-1236 # ffffffffc020c118 <commands+0xa20>
ffffffffc02015f4:	0000a617          	auipc	a2,0xa
ffffffffc02015f8:	31460613          	addi	a2,a2,788 # ffffffffc020b908 <commands+0x210>
ffffffffc02015fc:	0bd00593          	li	a1,189
ffffffffc0201600:	0000b517          	auipc	a0,0xb
ffffffffc0201604:	a5850513          	addi	a0,a0,-1448 # ffffffffc020c058 <commands+0x960>
ffffffffc0201608:	e97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020160c:	0000b697          	auipc	a3,0xb
ffffffffc0201610:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020c158 <commands+0xa60>
ffffffffc0201614:	0000a617          	auipc	a2,0xa
ffffffffc0201618:	2f460613          	addi	a2,a2,756 # ffffffffc020b908 <commands+0x210>
ffffffffc020161c:	0bf00593          	li	a1,191
ffffffffc0201620:	0000b517          	auipc	a0,0xb
ffffffffc0201624:	a3850513          	addi	a0,a0,-1480 # ffffffffc020c058 <commands+0x960>
ffffffffc0201628:	e77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020162c:	0000b697          	auipc	a3,0xb
ffffffffc0201630:	bb468693          	addi	a3,a3,-1100 # ffffffffc020c1e0 <commands+0xae8>
ffffffffc0201634:	0000a617          	auipc	a2,0xa
ffffffffc0201638:	2d460613          	addi	a2,a2,724 # ffffffffc020b908 <commands+0x210>
ffffffffc020163c:	0d800593          	li	a1,216
ffffffffc0201640:	0000b517          	auipc	a0,0xb
ffffffffc0201644:	a1850513          	addi	a0,a0,-1512 # ffffffffc020c058 <commands+0x960>
ffffffffc0201648:	e57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020164c:	0000b697          	auipc	a3,0xb
ffffffffc0201650:	a4468693          	addi	a3,a3,-1468 # ffffffffc020c090 <commands+0x998>
ffffffffc0201654:	0000a617          	auipc	a2,0xa
ffffffffc0201658:	2b460613          	addi	a2,a2,692 # ffffffffc020b908 <commands+0x210>
ffffffffc020165c:	0d100593          	li	a1,209
ffffffffc0201660:	0000b517          	auipc	a0,0xb
ffffffffc0201664:	9f850513          	addi	a0,a0,-1544 # ffffffffc020c058 <commands+0x960>
ffffffffc0201668:	e37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020166c:	0000b697          	auipc	a3,0xb
ffffffffc0201670:	b6468693          	addi	a3,a3,-1180 # ffffffffc020c1d0 <commands+0xad8>
ffffffffc0201674:	0000a617          	auipc	a2,0xa
ffffffffc0201678:	29460613          	addi	a2,a2,660 # ffffffffc020b908 <commands+0x210>
ffffffffc020167c:	0cf00593          	li	a1,207
ffffffffc0201680:	0000b517          	auipc	a0,0xb
ffffffffc0201684:	9d850513          	addi	a0,a0,-1576 # ffffffffc020c058 <commands+0x960>
ffffffffc0201688:	e17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020168c:	0000b697          	auipc	a3,0xb
ffffffffc0201690:	b2c68693          	addi	a3,a3,-1236 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201694:	0000a617          	auipc	a2,0xa
ffffffffc0201698:	27460613          	addi	a2,a2,628 # ffffffffc020b908 <commands+0x210>
ffffffffc020169c:	0ca00593          	li	a1,202
ffffffffc02016a0:	0000b517          	auipc	a0,0xb
ffffffffc02016a4:	9b850513          	addi	a0,a0,-1608 # ffffffffc020c058 <commands+0x960>
ffffffffc02016a8:	df7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ac:	0000b697          	auipc	a3,0xb
ffffffffc02016b0:	aec68693          	addi	a3,a3,-1300 # ffffffffc020c198 <commands+0xaa0>
ffffffffc02016b4:	0000a617          	auipc	a2,0xa
ffffffffc02016b8:	25460613          	addi	a2,a2,596 # ffffffffc020b908 <commands+0x210>
ffffffffc02016bc:	0c100593          	li	a1,193
ffffffffc02016c0:	0000b517          	auipc	a0,0xb
ffffffffc02016c4:	99850513          	addi	a0,a0,-1640 # ffffffffc020c058 <commands+0x960>
ffffffffc02016c8:	dd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016cc:	0000b697          	auipc	a3,0xb
ffffffffc02016d0:	b5c68693          	addi	a3,a3,-1188 # ffffffffc020c228 <commands+0xb30>
ffffffffc02016d4:	0000a617          	auipc	a2,0xa
ffffffffc02016d8:	23460613          	addi	a2,a2,564 # ffffffffc020b908 <commands+0x210>
ffffffffc02016dc:	0f700593          	li	a1,247
ffffffffc02016e0:	0000b517          	auipc	a0,0xb
ffffffffc02016e4:	97850513          	addi	a0,a0,-1672 # ffffffffc020c058 <commands+0x960>
ffffffffc02016e8:	db7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ec:	0000b697          	auipc	a3,0xb
ffffffffc02016f0:	b2c68693          	addi	a3,a3,-1236 # ffffffffc020c218 <commands+0xb20>
ffffffffc02016f4:	0000a617          	auipc	a2,0xa
ffffffffc02016f8:	21460613          	addi	a2,a2,532 # ffffffffc020b908 <commands+0x210>
ffffffffc02016fc:	0de00593          	li	a1,222
ffffffffc0201700:	0000b517          	auipc	a0,0xb
ffffffffc0201704:	95850513          	addi	a0,a0,-1704 # ffffffffc020c058 <commands+0x960>
ffffffffc0201708:	d97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020170c:	0000b697          	auipc	a3,0xb
ffffffffc0201710:	aac68693          	addi	a3,a3,-1364 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201714:	0000a617          	auipc	a2,0xa
ffffffffc0201718:	1f460613          	addi	a2,a2,500 # ffffffffc020b908 <commands+0x210>
ffffffffc020171c:	0dc00593          	li	a1,220
ffffffffc0201720:	0000b517          	auipc	a0,0xb
ffffffffc0201724:	93850513          	addi	a0,a0,-1736 # ffffffffc020c058 <commands+0x960>
ffffffffc0201728:	d77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020172c:	0000b697          	auipc	a3,0xb
ffffffffc0201730:	acc68693          	addi	a3,a3,-1332 # ffffffffc020c1f8 <commands+0xb00>
ffffffffc0201734:	0000a617          	auipc	a2,0xa
ffffffffc0201738:	1d460613          	addi	a2,a2,468 # ffffffffc020b908 <commands+0x210>
ffffffffc020173c:	0db00593          	li	a1,219
ffffffffc0201740:	0000b517          	auipc	a0,0xb
ffffffffc0201744:	91850513          	addi	a0,a0,-1768 # ffffffffc020c058 <commands+0x960>
ffffffffc0201748:	d57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020174c:	0000b697          	auipc	a3,0xb
ffffffffc0201750:	94468693          	addi	a3,a3,-1724 # ffffffffc020c090 <commands+0x998>
ffffffffc0201754:	0000a617          	auipc	a2,0xa
ffffffffc0201758:	1b460613          	addi	a2,a2,436 # ffffffffc020b908 <commands+0x210>
ffffffffc020175c:	0b800593          	li	a1,184
ffffffffc0201760:	0000b517          	auipc	a0,0xb
ffffffffc0201764:	8f850513          	addi	a0,a0,-1800 # ffffffffc020c058 <commands+0x960>
ffffffffc0201768:	d37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020176c:	0000b697          	auipc	a3,0xb
ffffffffc0201770:	a4c68693          	addi	a3,a3,-1460 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201774:	0000a617          	auipc	a2,0xa
ffffffffc0201778:	19460613          	addi	a2,a2,404 # ffffffffc020b908 <commands+0x210>
ffffffffc020177c:	0d500593          	li	a1,213
ffffffffc0201780:	0000b517          	auipc	a0,0xb
ffffffffc0201784:	8d850513          	addi	a0,a0,-1832 # ffffffffc020c058 <commands+0x960>
ffffffffc0201788:	d17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020178c:	0000b697          	auipc	a3,0xb
ffffffffc0201790:	94468693          	addi	a3,a3,-1724 # ffffffffc020c0d0 <commands+0x9d8>
ffffffffc0201794:	0000a617          	auipc	a2,0xa
ffffffffc0201798:	17460613          	addi	a2,a2,372 # ffffffffc020b908 <commands+0x210>
ffffffffc020179c:	0d300593          	li	a1,211
ffffffffc02017a0:	0000b517          	auipc	a0,0xb
ffffffffc02017a4:	8b850513          	addi	a0,a0,-1864 # ffffffffc020c058 <commands+0x960>
ffffffffc02017a8:	cf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ac:	0000b697          	auipc	a3,0xb
ffffffffc02017b0:	90468693          	addi	a3,a3,-1788 # ffffffffc020c0b0 <commands+0x9b8>
ffffffffc02017b4:	0000a617          	auipc	a2,0xa
ffffffffc02017b8:	15460613          	addi	a2,a2,340 # ffffffffc020b908 <commands+0x210>
ffffffffc02017bc:	0d200593          	li	a1,210
ffffffffc02017c0:	0000b517          	auipc	a0,0xb
ffffffffc02017c4:	89850513          	addi	a0,a0,-1896 # ffffffffc020c058 <commands+0x960>
ffffffffc02017c8:	cd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017cc:	0000b697          	auipc	a3,0xb
ffffffffc02017d0:	90468693          	addi	a3,a3,-1788 # ffffffffc020c0d0 <commands+0x9d8>
ffffffffc02017d4:	0000a617          	auipc	a2,0xa
ffffffffc02017d8:	13460613          	addi	a2,a2,308 # ffffffffc020b908 <commands+0x210>
ffffffffc02017dc:	0ba00593          	li	a1,186
ffffffffc02017e0:	0000b517          	auipc	a0,0xb
ffffffffc02017e4:	87850513          	addi	a0,a0,-1928 # ffffffffc020c058 <commands+0x960>
ffffffffc02017e8:	cb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ec:	0000b697          	auipc	a3,0xb
ffffffffc02017f0:	b8c68693          	addi	a3,a3,-1140 # ffffffffc020c378 <commands+0xc80>
ffffffffc02017f4:	0000a617          	auipc	a2,0xa
ffffffffc02017f8:	11460613          	addi	a2,a2,276 # ffffffffc020b908 <commands+0x210>
ffffffffc02017fc:	12400593          	li	a1,292
ffffffffc0201800:	0000b517          	auipc	a0,0xb
ffffffffc0201804:	85850513          	addi	a0,a0,-1960 # ffffffffc020c058 <commands+0x960>
ffffffffc0201808:	c97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020180c:	0000b697          	auipc	a3,0xb
ffffffffc0201810:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c218 <commands+0xb20>
ffffffffc0201814:	0000a617          	auipc	a2,0xa
ffffffffc0201818:	0f460613          	addi	a2,a2,244 # ffffffffc020b908 <commands+0x210>
ffffffffc020181c:	11900593          	li	a1,281
ffffffffc0201820:	0000b517          	auipc	a0,0xb
ffffffffc0201824:	83850513          	addi	a0,a0,-1992 # ffffffffc020c058 <commands+0x960>
ffffffffc0201828:	c77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020182c:	0000b697          	auipc	a3,0xb
ffffffffc0201830:	98c68693          	addi	a3,a3,-1652 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201834:	0000a617          	auipc	a2,0xa
ffffffffc0201838:	0d460613          	addi	a2,a2,212 # ffffffffc020b908 <commands+0x210>
ffffffffc020183c:	11700593          	li	a1,279
ffffffffc0201840:	0000b517          	auipc	a0,0xb
ffffffffc0201844:	81850513          	addi	a0,a0,-2024 # ffffffffc020c058 <commands+0x960>
ffffffffc0201848:	c57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020184c:	0000b697          	auipc	a3,0xb
ffffffffc0201850:	92c68693          	addi	a3,a3,-1748 # ffffffffc020c178 <commands+0xa80>
ffffffffc0201854:	0000a617          	auipc	a2,0xa
ffffffffc0201858:	0b460613          	addi	a2,a2,180 # ffffffffc020b908 <commands+0x210>
ffffffffc020185c:	0c000593          	li	a1,192
ffffffffc0201860:	0000a517          	auipc	a0,0xa
ffffffffc0201864:	7f850513          	addi	a0,a0,2040 # ffffffffc020c058 <commands+0x960>
ffffffffc0201868:	c37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020186c:	0000b697          	auipc	a3,0xb
ffffffffc0201870:	acc68693          	addi	a3,a3,-1332 # ffffffffc020c338 <commands+0xc40>
ffffffffc0201874:	0000a617          	auipc	a2,0xa
ffffffffc0201878:	09460613          	addi	a2,a2,148 # ffffffffc020b908 <commands+0x210>
ffffffffc020187c:	11100593          	li	a1,273
ffffffffc0201880:	0000a517          	auipc	a0,0xa
ffffffffc0201884:	7d850513          	addi	a0,a0,2008 # ffffffffc020c058 <commands+0x960>
ffffffffc0201888:	c17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020188c:	0000b697          	auipc	a3,0xb
ffffffffc0201890:	a8c68693          	addi	a3,a3,-1396 # ffffffffc020c318 <commands+0xc20>
ffffffffc0201894:	0000a617          	auipc	a2,0xa
ffffffffc0201898:	07460613          	addi	a2,a2,116 # ffffffffc020b908 <commands+0x210>
ffffffffc020189c:	10f00593          	li	a1,271
ffffffffc02018a0:	0000a517          	auipc	a0,0xa
ffffffffc02018a4:	7b850513          	addi	a0,a0,1976 # ffffffffc020c058 <commands+0x960>
ffffffffc02018a8:	bf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ac:	0000b697          	auipc	a3,0xb
ffffffffc02018b0:	a4468693          	addi	a3,a3,-1468 # ffffffffc020c2f0 <commands+0xbf8>
ffffffffc02018b4:	0000a617          	auipc	a2,0xa
ffffffffc02018b8:	05460613          	addi	a2,a2,84 # ffffffffc020b908 <commands+0x210>
ffffffffc02018bc:	10d00593          	li	a1,269
ffffffffc02018c0:	0000a517          	auipc	a0,0xa
ffffffffc02018c4:	79850513          	addi	a0,a0,1944 # ffffffffc020c058 <commands+0x960>
ffffffffc02018c8:	bd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018cc:	0000b697          	auipc	a3,0xb
ffffffffc02018d0:	9fc68693          	addi	a3,a3,-1540 # ffffffffc020c2c8 <commands+0xbd0>
ffffffffc02018d4:	0000a617          	auipc	a2,0xa
ffffffffc02018d8:	03460613          	addi	a2,a2,52 # ffffffffc020b908 <commands+0x210>
ffffffffc02018dc:	10c00593          	li	a1,268
ffffffffc02018e0:	0000a517          	auipc	a0,0xa
ffffffffc02018e4:	77850513          	addi	a0,a0,1912 # ffffffffc020c058 <commands+0x960>
ffffffffc02018e8:	bb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ec:	0000b697          	auipc	a3,0xb
ffffffffc02018f0:	9cc68693          	addi	a3,a3,-1588 # ffffffffc020c2b8 <commands+0xbc0>
ffffffffc02018f4:	0000a617          	auipc	a2,0xa
ffffffffc02018f8:	01460613          	addi	a2,a2,20 # ffffffffc020b908 <commands+0x210>
ffffffffc02018fc:	10700593          	li	a1,263
ffffffffc0201900:	0000a517          	auipc	a0,0xa
ffffffffc0201904:	75850513          	addi	a0,a0,1880 # ffffffffc020c058 <commands+0x960>
ffffffffc0201908:	b97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020190c:	0000b697          	auipc	a3,0xb
ffffffffc0201910:	8ac68693          	addi	a3,a3,-1876 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201914:	0000a617          	auipc	a2,0xa
ffffffffc0201918:	ff460613          	addi	a2,a2,-12 # ffffffffc020b908 <commands+0x210>
ffffffffc020191c:	10600593          	li	a1,262
ffffffffc0201920:	0000a517          	auipc	a0,0xa
ffffffffc0201924:	73850513          	addi	a0,a0,1848 # ffffffffc020c058 <commands+0x960>
ffffffffc0201928:	b77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020192c:	0000b697          	auipc	a3,0xb
ffffffffc0201930:	96c68693          	addi	a3,a3,-1684 # ffffffffc020c298 <commands+0xba0>
ffffffffc0201934:	0000a617          	auipc	a2,0xa
ffffffffc0201938:	fd460613          	addi	a2,a2,-44 # ffffffffc020b908 <commands+0x210>
ffffffffc020193c:	10500593          	li	a1,261
ffffffffc0201940:	0000a517          	auipc	a0,0xa
ffffffffc0201944:	71850513          	addi	a0,a0,1816 # ffffffffc020c058 <commands+0x960>
ffffffffc0201948:	b57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020194c:	0000b697          	auipc	a3,0xb
ffffffffc0201950:	91c68693          	addi	a3,a3,-1764 # ffffffffc020c268 <commands+0xb70>
ffffffffc0201954:	0000a617          	auipc	a2,0xa
ffffffffc0201958:	fb460613          	addi	a2,a2,-76 # ffffffffc020b908 <commands+0x210>
ffffffffc020195c:	10400593          	li	a1,260
ffffffffc0201960:	0000a517          	auipc	a0,0xa
ffffffffc0201964:	6f850513          	addi	a0,a0,1784 # ffffffffc020c058 <commands+0x960>
ffffffffc0201968:	b37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020196c:	0000b697          	auipc	a3,0xb
ffffffffc0201970:	8e468693          	addi	a3,a3,-1820 # ffffffffc020c250 <commands+0xb58>
ffffffffc0201974:	0000a617          	auipc	a2,0xa
ffffffffc0201978:	f9460613          	addi	a2,a2,-108 # ffffffffc020b908 <commands+0x210>
ffffffffc020197c:	10300593          	li	a1,259
ffffffffc0201980:	0000a517          	auipc	a0,0xa
ffffffffc0201984:	6d850513          	addi	a0,a0,1752 # ffffffffc020c058 <commands+0x960>
ffffffffc0201988:	b17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020198c:	0000b697          	auipc	a3,0xb
ffffffffc0201990:	82c68693          	addi	a3,a3,-2004 # ffffffffc020c1b8 <commands+0xac0>
ffffffffc0201994:	0000a617          	auipc	a2,0xa
ffffffffc0201998:	f7460613          	addi	a2,a2,-140 # ffffffffc020b908 <commands+0x210>
ffffffffc020199c:	0fd00593          	li	a1,253
ffffffffc02019a0:	0000a517          	auipc	a0,0xa
ffffffffc02019a4:	6b850513          	addi	a0,a0,1720 # ffffffffc020c058 <commands+0x960>
ffffffffc02019a8:	af7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ac:	0000b697          	auipc	a3,0xb
ffffffffc02019b0:	88c68693          	addi	a3,a3,-1908 # ffffffffc020c238 <commands+0xb40>
ffffffffc02019b4:	0000a617          	auipc	a2,0xa
ffffffffc02019b8:	f5460613          	addi	a2,a2,-172 # ffffffffc020b908 <commands+0x210>
ffffffffc02019bc:	0f800593          	li	a1,248
ffffffffc02019c0:	0000a517          	auipc	a0,0xa
ffffffffc02019c4:	69850513          	addi	a0,a0,1688 # ffffffffc020c058 <commands+0x960>
ffffffffc02019c8:	ad7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019cc:	0000b697          	auipc	a3,0xb
ffffffffc02019d0:	98c68693          	addi	a3,a3,-1652 # ffffffffc020c358 <commands+0xc60>
ffffffffc02019d4:	0000a617          	auipc	a2,0xa
ffffffffc02019d8:	f3460613          	addi	a2,a2,-204 # ffffffffc020b908 <commands+0x210>
ffffffffc02019dc:	11600593          	li	a1,278
ffffffffc02019e0:	0000a517          	auipc	a0,0xa
ffffffffc02019e4:	67850513          	addi	a0,a0,1656 # ffffffffc020c058 <commands+0x960>
ffffffffc02019e8:	ab7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ec:	0000b697          	auipc	a3,0xb
ffffffffc02019f0:	99c68693          	addi	a3,a3,-1636 # ffffffffc020c388 <commands+0xc90>
ffffffffc02019f4:	0000a617          	auipc	a2,0xa
ffffffffc02019f8:	f1460613          	addi	a2,a2,-236 # ffffffffc020b908 <commands+0x210>
ffffffffc02019fc:	12500593          	li	a1,293
ffffffffc0201a00:	0000a517          	auipc	a0,0xa
ffffffffc0201a04:	65850513          	addi	a0,a0,1624 # ffffffffc020c058 <commands+0x960>
ffffffffc0201a08:	a97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a0c:	0000a697          	auipc	a3,0xa
ffffffffc0201a10:	66468693          	addi	a3,a3,1636 # ffffffffc020c070 <commands+0x978>
ffffffffc0201a14:	0000a617          	auipc	a2,0xa
ffffffffc0201a18:	ef460613          	addi	a2,a2,-268 # ffffffffc020b908 <commands+0x210>
ffffffffc0201a1c:	0f200593          	li	a1,242
ffffffffc0201a20:	0000a517          	auipc	a0,0xa
ffffffffc0201a24:	63850513          	addi	a0,a0,1592 # ffffffffc020c058 <commands+0x960>
ffffffffc0201a28:	a77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a2c:	0000a697          	auipc	a3,0xa
ffffffffc0201a30:	68468693          	addi	a3,a3,1668 # ffffffffc020c0b0 <commands+0x9b8>
ffffffffc0201a34:	0000a617          	auipc	a2,0xa
ffffffffc0201a38:	ed460613          	addi	a2,a2,-300 # ffffffffc020b908 <commands+0x210>
ffffffffc0201a3c:	0b900593          	li	a1,185
ffffffffc0201a40:	0000a517          	auipc	a0,0xa
ffffffffc0201a44:	61850513          	addi	a0,a0,1560 # ffffffffc020c058 <commands+0x960>
ffffffffc0201a48:	a57fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201a4c <default_free_pages>:
ffffffffc0201a4c:	1141                	addi	sp,sp,-16
ffffffffc0201a4e:	e406                	sd	ra,8(sp)
ffffffffc0201a50:	14058463          	beqz	a1,ffffffffc0201b98 <default_free_pages+0x14c>
ffffffffc0201a54:	00659693          	slli	a3,a1,0x6
ffffffffc0201a58:	96aa                	add	a3,a3,a0
ffffffffc0201a5a:	87aa                	mv	a5,a0
ffffffffc0201a5c:	02d50263          	beq	a0,a3,ffffffffc0201a80 <default_free_pages+0x34>
ffffffffc0201a60:	6798                	ld	a4,8(a5)
ffffffffc0201a62:	8b05                	andi	a4,a4,1
ffffffffc0201a64:	10071a63          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a68:	6798                	ld	a4,8(a5)
ffffffffc0201a6a:	8b09                	andi	a4,a4,2
ffffffffc0201a6c:	10071663          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a70:	0007b423          	sd	zero,8(a5)
ffffffffc0201a74:	0007a023          	sw	zero,0(a5)
ffffffffc0201a78:	04078793          	addi	a5,a5,64
ffffffffc0201a7c:	fed792e3          	bne	a5,a3,ffffffffc0201a60 <default_free_pages+0x14>
ffffffffc0201a80:	2581                	sext.w	a1,a1
ffffffffc0201a82:	c90c                	sw	a1,16(a0)
ffffffffc0201a84:	00850893          	addi	a7,a0,8
ffffffffc0201a88:	4789                	li	a5,2
ffffffffc0201a8a:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a8e:	00090697          	auipc	a3,0x90
ffffffffc0201a92:	d1a68693          	addi	a3,a3,-742 # ffffffffc02917a8 <free_area>
ffffffffc0201a96:	4a98                	lw	a4,16(a3)
ffffffffc0201a98:	669c                	ld	a5,8(a3)
ffffffffc0201a9a:	01850613          	addi	a2,a0,24
ffffffffc0201a9e:	9db9                	addw	a1,a1,a4
ffffffffc0201aa0:	ca8c                	sw	a1,16(a3)
ffffffffc0201aa2:	0ad78463          	beq	a5,a3,ffffffffc0201b4a <default_free_pages+0xfe>
ffffffffc0201aa6:	fe878713          	addi	a4,a5,-24
ffffffffc0201aaa:	0006b803          	ld	a6,0(a3)
ffffffffc0201aae:	4581                	li	a1,0
ffffffffc0201ab0:	00e56a63          	bltu	a0,a4,ffffffffc0201ac4 <default_free_pages+0x78>
ffffffffc0201ab4:	6798                	ld	a4,8(a5)
ffffffffc0201ab6:	04d70c63          	beq	a4,a3,ffffffffc0201b0e <default_free_pages+0xc2>
ffffffffc0201aba:	87ba                	mv	a5,a4
ffffffffc0201abc:	fe878713          	addi	a4,a5,-24
ffffffffc0201ac0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ab4 <default_free_pages+0x68>
ffffffffc0201ac4:	c199                	beqz	a1,ffffffffc0201aca <default_free_pages+0x7e>
ffffffffc0201ac6:	0106b023          	sd	a6,0(a3)
ffffffffc0201aca:	6398                	ld	a4,0(a5)
ffffffffc0201acc:	e390                	sd	a2,0(a5)
ffffffffc0201ace:	e710                	sd	a2,8(a4)
ffffffffc0201ad0:	f11c                	sd	a5,32(a0)
ffffffffc0201ad2:	ed18                	sd	a4,24(a0)
ffffffffc0201ad4:	00d70d63          	beq	a4,a3,ffffffffc0201aee <default_free_pages+0xa2>
ffffffffc0201ad8:	ff872583          	lw	a1,-8(a4)
ffffffffc0201adc:	fe870613          	addi	a2,a4,-24
ffffffffc0201ae0:	02059813          	slli	a6,a1,0x20
ffffffffc0201ae4:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201ae8:	97b2                	add	a5,a5,a2
ffffffffc0201aea:	02f50c63          	beq	a0,a5,ffffffffc0201b22 <default_free_pages+0xd6>
ffffffffc0201aee:	711c                	ld	a5,32(a0)
ffffffffc0201af0:	00d78c63          	beq	a5,a3,ffffffffc0201b08 <default_free_pages+0xbc>
ffffffffc0201af4:	4910                	lw	a2,16(a0)
ffffffffc0201af6:	fe878693          	addi	a3,a5,-24
ffffffffc0201afa:	02061593          	slli	a1,a2,0x20
ffffffffc0201afe:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b02:	972a                	add	a4,a4,a0
ffffffffc0201b04:	04e68a63          	beq	a3,a4,ffffffffc0201b58 <default_free_pages+0x10c>
ffffffffc0201b08:	60a2                	ld	ra,8(sp)
ffffffffc0201b0a:	0141                	addi	sp,sp,16
ffffffffc0201b0c:	8082                	ret
ffffffffc0201b0e:	e790                	sd	a2,8(a5)
ffffffffc0201b10:	f114                	sd	a3,32(a0)
ffffffffc0201b12:	6798                	ld	a4,8(a5)
ffffffffc0201b14:	ed1c                	sd	a5,24(a0)
ffffffffc0201b16:	02d70763          	beq	a4,a3,ffffffffc0201b44 <default_free_pages+0xf8>
ffffffffc0201b1a:	8832                	mv	a6,a2
ffffffffc0201b1c:	4585                	li	a1,1
ffffffffc0201b1e:	87ba                	mv	a5,a4
ffffffffc0201b20:	bf71                	j	ffffffffc0201abc <default_free_pages+0x70>
ffffffffc0201b22:	491c                	lw	a5,16(a0)
ffffffffc0201b24:	9dbd                	addw	a1,a1,a5
ffffffffc0201b26:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201b2a:	57f5                	li	a5,-3
ffffffffc0201b2c:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201b30:	01853803          	ld	a6,24(a0)
ffffffffc0201b34:	710c                	ld	a1,32(a0)
ffffffffc0201b36:	8532                	mv	a0,a2
ffffffffc0201b38:	00b83423          	sd	a1,8(a6)
ffffffffc0201b3c:	671c                	ld	a5,8(a4)
ffffffffc0201b3e:	0105b023          	sd	a6,0(a1)
ffffffffc0201b42:	b77d                	j	ffffffffc0201af0 <default_free_pages+0xa4>
ffffffffc0201b44:	e290                	sd	a2,0(a3)
ffffffffc0201b46:	873e                	mv	a4,a5
ffffffffc0201b48:	bf41                	j	ffffffffc0201ad8 <default_free_pages+0x8c>
ffffffffc0201b4a:	60a2                	ld	ra,8(sp)
ffffffffc0201b4c:	e390                	sd	a2,0(a5)
ffffffffc0201b4e:	e790                	sd	a2,8(a5)
ffffffffc0201b50:	f11c                	sd	a5,32(a0)
ffffffffc0201b52:	ed1c                	sd	a5,24(a0)
ffffffffc0201b54:	0141                	addi	sp,sp,16
ffffffffc0201b56:	8082                	ret
ffffffffc0201b58:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b5c:	ff078693          	addi	a3,a5,-16
ffffffffc0201b60:	9e39                	addw	a2,a2,a4
ffffffffc0201b62:	c910                	sw	a2,16(a0)
ffffffffc0201b64:	5775                	li	a4,-3
ffffffffc0201b66:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201b6a:	6398                	ld	a4,0(a5)
ffffffffc0201b6c:	679c                	ld	a5,8(a5)
ffffffffc0201b6e:	60a2                	ld	ra,8(sp)
ffffffffc0201b70:	e71c                	sd	a5,8(a4)
ffffffffc0201b72:	e398                	sd	a4,0(a5)
ffffffffc0201b74:	0141                	addi	sp,sp,16
ffffffffc0201b76:	8082                	ret
ffffffffc0201b78:	0000b697          	auipc	a3,0xb
ffffffffc0201b7c:	82868693          	addi	a3,a3,-2008 # ffffffffc020c3a0 <commands+0xca8>
ffffffffc0201b80:	0000a617          	auipc	a2,0xa
ffffffffc0201b84:	d8860613          	addi	a2,a2,-632 # ffffffffc020b908 <commands+0x210>
ffffffffc0201b88:	08200593          	li	a1,130
ffffffffc0201b8c:	0000a517          	auipc	a0,0xa
ffffffffc0201b90:	4cc50513          	addi	a0,a0,1228 # ffffffffc020c058 <commands+0x960>
ffffffffc0201b94:	90bfe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201b98:	0000b697          	auipc	a3,0xb
ffffffffc0201b9c:	80068693          	addi	a3,a3,-2048 # ffffffffc020c398 <commands+0xca0>
ffffffffc0201ba0:	0000a617          	auipc	a2,0xa
ffffffffc0201ba4:	d6860613          	addi	a2,a2,-664 # ffffffffc020b908 <commands+0x210>
ffffffffc0201ba8:	07f00593          	li	a1,127
ffffffffc0201bac:	0000a517          	auipc	a0,0xa
ffffffffc0201bb0:	4ac50513          	addi	a0,a0,1196 # ffffffffc020c058 <commands+0x960>
ffffffffc0201bb4:	8ebfe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201bb8 <default_alloc_pages>:
ffffffffc0201bb8:	c941                	beqz	a0,ffffffffc0201c48 <default_alloc_pages+0x90>
ffffffffc0201bba:	00090597          	auipc	a1,0x90
ffffffffc0201bbe:	bee58593          	addi	a1,a1,-1042 # ffffffffc02917a8 <free_area>
ffffffffc0201bc2:	0105a803          	lw	a6,16(a1)
ffffffffc0201bc6:	872a                	mv	a4,a0
ffffffffc0201bc8:	02081793          	slli	a5,a6,0x20
ffffffffc0201bcc:	9381                	srli	a5,a5,0x20
ffffffffc0201bce:	00a7ee63          	bltu	a5,a0,ffffffffc0201bea <default_alloc_pages+0x32>
ffffffffc0201bd2:	87ae                	mv	a5,a1
ffffffffc0201bd4:	a801                	j	ffffffffc0201be4 <default_alloc_pages+0x2c>
ffffffffc0201bd6:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201bda:	02069613          	slli	a2,a3,0x20
ffffffffc0201bde:	9201                	srli	a2,a2,0x20
ffffffffc0201be0:	00e67763          	bgeu	a2,a4,ffffffffc0201bee <default_alloc_pages+0x36>
ffffffffc0201be4:	679c                	ld	a5,8(a5)
ffffffffc0201be6:	feb798e3          	bne	a5,a1,ffffffffc0201bd6 <default_alloc_pages+0x1e>
ffffffffc0201bea:	4501                	li	a0,0
ffffffffc0201bec:	8082                	ret
ffffffffc0201bee:	0007b883          	ld	a7,0(a5)
ffffffffc0201bf2:	0087b303          	ld	t1,8(a5)
ffffffffc0201bf6:	fe878513          	addi	a0,a5,-24
ffffffffc0201bfa:	00070e1b          	sext.w	t3,a4
ffffffffc0201bfe:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc0201c02:	01133023          	sd	a7,0(t1)
ffffffffc0201c06:	02c77863          	bgeu	a4,a2,ffffffffc0201c36 <default_alloc_pages+0x7e>
ffffffffc0201c0a:	071a                	slli	a4,a4,0x6
ffffffffc0201c0c:	972a                	add	a4,a4,a0
ffffffffc0201c0e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201c12:	cb14                	sw	a3,16(a4)
ffffffffc0201c14:	00870613          	addi	a2,a4,8
ffffffffc0201c18:	4689                	li	a3,2
ffffffffc0201c1a:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201c1e:	0088b683          	ld	a3,8(a7)
ffffffffc0201c22:	01870613          	addi	a2,a4,24
ffffffffc0201c26:	0105a803          	lw	a6,16(a1)
ffffffffc0201c2a:	e290                	sd	a2,0(a3)
ffffffffc0201c2c:	00c8b423          	sd	a2,8(a7)
ffffffffc0201c30:	f314                	sd	a3,32(a4)
ffffffffc0201c32:	01173c23          	sd	a7,24(a4)
ffffffffc0201c36:	41c8083b          	subw	a6,a6,t3
ffffffffc0201c3a:	0105a823          	sw	a6,16(a1)
ffffffffc0201c3e:	5775                	li	a4,-3
ffffffffc0201c40:	17c1                	addi	a5,a5,-16
ffffffffc0201c42:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c46:	8082                	ret
ffffffffc0201c48:	1141                	addi	sp,sp,-16
ffffffffc0201c4a:	0000a697          	auipc	a3,0xa
ffffffffc0201c4e:	74e68693          	addi	a3,a3,1870 # ffffffffc020c398 <commands+0xca0>
ffffffffc0201c52:	0000a617          	auipc	a2,0xa
ffffffffc0201c56:	cb660613          	addi	a2,a2,-842 # ffffffffc020b908 <commands+0x210>
ffffffffc0201c5a:	06100593          	li	a1,97
ffffffffc0201c5e:	0000a517          	auipc	a0,0xa
ffffffffc0201c62:	3fa50513          	addi	a0,a0,1018 # ffffffffc020c058 <commands+0x960>
ffffffffc0201c66:	e406                	sd	ra,8(sp)
ffffffffc0201c68:	837fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201c6c <default_init_memmap>:
ffffffffc0201c6c:	1141                	addi	sp,sp,-16
ffffffffc0201c6e:	e406                	sd	ra,8(sp)
ffffffffc0201c70:	c5f1                	beqz	a1,ffffffffc0201d3c <default_init_memmap+0xd0>
ffffffffc0201c72:	00659693          	slli	a3,a1,0x6
ffffffffc0201c76:	96aa                	add	a3,a3,a0
ffffffffc0201c78:	87aa                	mv	a5,a0
ffffffffc0201c7a:	00d50f63          	beq	a0,a3,ffffffffc0201c98 <default_init_memmap+0x2c>
ffffffffc0201c7e:	6798                	ld	a4,8(a5)
ffffffffc0201c80:	8b05                	andi	a4,a4,1
ffffffffc0201c82:	cf49                	beqz	a4,ffffffffc0201d1c <default_init_memmap+0xb0>
ffffffffc0201c84:	0007a823          	sw	zero,16(a5)
ffffffffc0201c88:	0007b423          	sd	zero,8(a5)
ffffffffc0201c8c:	0007a023          	sw	zero,0(a5)
ffffffffc0201c90:	04078793          	addi	a5,a5,64
ffffffffc0201c94:	fed795e3          	bne	a5,a3,ffffffffc0201c7e <default_init_memmap+0x12>
ffffffffc0201c98:	2581                	sext.w	a1,a1
ffffffffc0201c9a:	c90c                	sw	a1,16(a0)
ffffffffc0201c9c:	4789                	li	a5,2
ffffffffc0201c9e:	00850713          	addi	a4,a0,8
ffffffffc0201ca2:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201ca6:	00090697          	auipc	a3,0x90
ffffffffc0201caa:	b0268693          	addi	a3,a3,-1278 # ffffffffc02917a8 <free_area>
ffffffffc0201cae:	4a98                	lw	a4,16(a3)
ffffffffc0201cb0:	669c                	ld	a5,8(a3)
ffffffffc0201cb2:	01850613          	addi	a2,a0,24
ffffffffc0201cb6:	9db9                	addw	a1,a1,a4
ffffffffc0201cb8:	ca8c                	sw	a1,16(a3)
ffffffffc0201cba:	04d78a63          	beq	a5,a3,ffffffffc0201d0e <default_init_memmap+0xa2>
ffffffffc0201cbe:	fe878713          	addi	a4,a5,-24
ffffffffc0201cc2:	0006b803          	ld	a6,0(a3)
ffffffffc0201cc6:	4581                	li	a1,0
ffffffffc0201cc8:	00e56a63          	bltu	a0,a4,ffffffffc0201cdc <default_init_memmap+0x70>
ffffffffc0201ccc:	6798                	ld	a4,8(a5)
ffffffffc0201cce:	02d70263          	beq	a4,a3,ffffffffc0201cf2 <default_init_memmap+0x86>
ffffffffc0201cd2:	87ba                	mv	a5,a4
ffffffffc0201cd4:	fe878713          	addi	a4,a5,-24
ffffffffc0201cd8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ccc <default_init_memmap+0x60>
ffffffffc0201cdc:	c199                	beqz	a1,ffffffffc0201ce2 <default_init_memmap+0x76>
ffffffffc0201cde:	0106b023          	sd	a6,0(a3)
ffffffffc0201ce2:	6398                	ld	a4,0(a5)
ffffffffc0201ce4:	60a2                	ld	ra,8(sp)
ffffffffc0201ce6:	e390                	sd	a2,0(a5)
ffffffffc0201ce8:	e710                	sd	a2,8(a4)
ffffffffc0201cea:	f11c                	sd	a5,32(a0)
ffffffffc0201cec:	ed18                	sd	a4,24(a0)
ffffffffc0201cee:	0141                	addi	sp,sp,16
ffffffffc0201cf0:	8082                	ret
ffffffffc0201cf2:	e790                	sd	a2,8(a5)
ffffffffc0201cf4:	f114                	sd	a3,32(a0)
ffffffffc0201cf6:	6798                	ld	a4,8(a5)
ffffffffc0201cf8:	ed1c                	sd	a5,24(a0)
ffffffffc0201cfa:	00d70663          	beq	a4,a3,ffffffffc0201d06 <default_init_memmap+0x9a>
ffffffffc0201cfe:	8832                	mv	a6,a2
ffffffffc0201d00:	4585                	li	a1,1
ffffffffc0201d02:	87ba                	mv	a5,a4
ffffffffc0201d04:	bfc1                	j	ffffffffc0201cd4 <default_init_memmap+0x68>
ffffffffc0201d06:	60a2                	ld	ra,8(sp)
ffffffffc0201d08:	e290                	sd	a2,0(a3)
ffffffffc0201d0a:	0141                	addi	sp,sp,16
ffffffffc0201d0c:	8082                	ret
ffffffffc0201d0e:	60a2                	ld	ra,8(sp)
ffffffffc0201d10:	e390                	sd	a2,0(a5)
ffffffffc0201d12:	e790                	sd	a2,8(a5)
ffffffffc0201d14:	f11c                	sd	a5,32(a0)
ffffffffc0201d16:	ed1c                	sd	a5,24(a0)
ffffffffc0201d18:	0141                	addi	sp,sp,16
ffffffffc0201d1a:	8082                	ret
ffffffffc0201d1c:	0000a697          	auipc	a3,0xa
ffffffffc0201d20:	6ac68693          	addi	a3,a3,1708 # ffffffffc020c3c8 <commands+0xcd0>
ffffffffc0201d24:	0000a617          	auipc	a2,0xa
ffffffffc0201d28:	be460613          	addi	a2,a2,-1052 # ffffffffc020b908 <commands+0x210>
ffffffffc0201d2c:	04800593          	li	a1,72
ffffffffc0201d30:	0000a517          	auipc	a0,0xa
ffffffffc0201d34:	32850513          	addi	a0,a0,808 # ffffffffc020c058 <commands+0x960>
ffffffffc0201d38:	f66fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201d3c:	0000a697          	auipc	a3,0xa
ffffffffc0201d40:	65c68693          	addi	a3,a3,1628 # ffffffffc020c398 <commands+0xca0>
ffffffffc0201d44:	0000a617          	auipc	a2,0xa
ffffffffc0201d48:	bc460613          	addi	a2,a2,-1084 # ffffffffc020b908 <commands+0x210>
ffffffffc0201d4c:	04500593          	li	a1,69
ffffffffc0201d50:	0000a517          	auipc	a0,0xa
ffffffffc0201d54:	30850513          	addi	a0,a0,776 # ffffffffc020c058 <commands+0x960>
ffffffffc0201d58:	f46fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201d5c <slob_free>:
ffffffffc0201d5c:	c94d                	beqz	a0,ffffffffc0201e0e <slob_free+0xb2>
ffffffffc0201d5e:	1141                	addi	sp,sp,-16
ffffffffc0201d60:	e022                	sd	s0,0(sp)
ffffffffc0201d62:	e406                	sd	ra,8(sp)
ffffffffc0201d64:	842a                	mv	s0,a0
ffffffffc0201d66:	e9c1                	bnez	a1,ffffffffc0201df6 <slob_free+0x9a>
ffffffffc0201d68:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6c:	8b89                	andi	a5,a5,2
ffffffffc0201d6e:	4501                	li	a0,0
ffffffffc0201d70:	ebd9                	bnez	a5,ffffffffc0201e06 <slob_free+0xaa>
ffffffffc0201d72:	0008f617          	auipc	a2,0x8f
ffffffffc0201d76:	2de60613          	addi	a2,a2,734 # ffffffffc0291050 <slobfree>
ffffffffc0201d7a:	621c                	ld	a5,0(a2)
ffffffffc0201d7c:	873e                	mv	a4,a5
ffffffffc0201d7e:	679c                	ld	a5,8(a5)
ffffffffc0201d80:	02877a63          	bgeu	a4,s0,ffffffffc0201db4 <slob_free+0x58>
ffffffffc0201d84:	00f46463          	bltu	s0,a5,ffffffffc0201d8c <slob_free+0x30>
ffffffffc0201d88:	fef76ae3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201d8c:	400c                	lw	a1,0(s0)
ffffffffc0201d8e:	00459693          	slli	a3,a1,0x4
ffffffffc0201d92:	96a2                	add	a3,a3,s0
ffffffffc0201d94:	02d78a63          	beq	a5,a3,ffffffffc0201dc8 <slob_free+0x6c>
ffffffffc0201d98:	4314                	lw	a3,0(a4)
ffffffffc0201d9a:	e41c                	sd	a5,8(s0)
ffffffffc0201d9c:	00469793          	slli	a5,a3,0x4
ffffffffc0201da0:	97ba                	add	a5,a5,a4
ffffffffc0201da2:	02f40e63          	beq	s0,a5,ffffffffc0201dde <slob_free+0x82>
ffffffffc0201da6:	e700                	sd	s0,8(a4)
ffffffffc0201da8:	e218                	sd	a4,0(a2)
ffffffffc0201daa:	e129                	bnez	a0,ffffffffc0201dec <slob_free+0x90>
ffffffffc0201dac:	60a2                	ld	ra,8(sp)
ffffffffc0201dae:	6402                	ld	s0,0(sp)
ffffffffc0201db0:	0141                	addi	sp,sp,16
ffffffffc0201db2:	8082                	ret
ffffffffc0201db4:	fcf764e3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201db8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201dbc:	400c                	lw	a1,0(s0)
ffffffffc0201dbe:	00459693          	slli	a3,a1,0x4
ffffffffc0201dc2:	96a2                	add	a3,a3,s0
ffffffffc0201dc4:	fcd79ae3          	bne	a5,a3,ffffffffc0201d98 <slob_free+0x3c>
ffffffffc0201dc8:	4394                	lw	a3,0(a5)
ffffffffc0201dca:	679c                	ld	a5,8(a5)
ffffffffc0201dcc:	9db5                	addw	a1,a1,a3
ffffffffc0201dce:	c00c                	sw	a1,0(s0)
ffffffffc0201dd0:	4314                	lw	a3,0(a4)
ffffffffc0201dd2:	e41c                	sd	a5,8(s0)
ffffffffc0201dd4:	00469793          	slli	a5,a3,0x4
ffffffffc0201dd8:	97ba                	add	a5,a5,a4
ffffffffc0201dda:	fcf416e3          	bne	s0,a5,ffffffffc0201da6 <slob_free+0x4a>
ffffffffc0201dde:	401c                	lw	a5,0(s0)
ffffffffc0201de0:	640c                	ld	a1,8(s0)
ffffffffc0201de2:	e218                	sd	a4,0(a2)
ffffffffc0201de4:	9ebd                	addw	a3,a3,a5
ffffffffc0201de6:	c314                	sw	a3,0(a4)
ffffffffc0201de8:	e70c                	sd	a1,8(a4)
ffffffffc0201dea:	d169                	beqz	a0,ffffffffc0201dac <slob_free+0x50>
ffffffffc0201dec:	6402                	ld	s0,0(sp)
ffffffffc0201dee:	60a2                	ld	ra,8(sp)
ffffffffc0201df0:	0141                	addi	sp,sp,16
ffffffffc0201df2:	e7bfe06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0201df6:	25bd                	addiw	a1,a1,15
ffffffffc0201df8:	8191                	srli	a1,a1,0x4
ffffffffc0201dfa:	c10c                	sw	a1,0(a0)
ffffffffc0201dfc:	100027f3          	csrr	a5,sstatus
ffffffffc0201e00:	8b89                	andi	a5,a5,2
ffffffffc0201e02:	4501                	li	a0,0
ffffffffc0201e04:	d7bd                	beqz	a5,ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e06:	e6dfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201e0a:	4505                	li	a0,1
ffffffffc0201e0c:	b79d                	j	ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e0e:	8082                	ret

ffffffffc0201e10 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e10:	4785                	li	a5,1
ffffffffc0201e12:	1141                	addi	sp,sp,-16
ffffffffc0201e14:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e18:	e406                	sd	ra,8(sp)
ffffffffc0201e1a:	352000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201e1e:	c91d                	beqz	a0,ffffffffc0201e54 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e20:	00095697          	auipc	a3,0x95
ffffffffc0201e24:	a886b683          	ld	a3,-1400(a3) # ffffffffc02968a8 <pages>
ffffffffc0201e28:	8d15                	sub	a0,a0,a3
ffffffffc0201e2a:	8519                	srai	a0,a0,0x6
ffffffffc0201e2c:	0000e697          	auipc	a3,0xe
ffffffffc0201e30:	9046b683          	ld	a3,-1788(a3) # ffffffffc020f730 <nbase>
ffffffffc0201e34:	9536                	add	a0,a0,a3
ffffffffc0201e36:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e3a:	83b1                	srli	a5,a5,0xc
ffffffffc0201e3c:	00095717          	auipc	a4,0x95
ffffffffc0201e40:	a6473703          	ld	a4,-1436(a4) # ffffffffc02968a0 <npage>
ffffffffc0201e44:	0532                	slli	a0,a0,0xc
ffffffffc0201e46:	00e7fa63          	bgeu	a5,a4,ffffffffc0201e5a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e4a:	00095697          	auipc	a3,0x95
ffffffffc0201e4e:	a6e6b683          	ld	a3,-1426(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201e52:	9536                	add	a0,a0,a3
ffffffffc0201e54:	60a2                	ld	ra,8(sp)
ffffffffc0201e56:	0141                	addi	sp,sp,16
ffffffffc0201e58:	8082                	ret
ffffffffc0201e5a:	86aa                	mv	a3,a0
ffffffffc0201e5c:	0000a617          	auipc	a2,0xa
ffffffffc0201e60:	5cc60613          	addi	a2,a2,1484 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0201e64:	07100593          	li	a1,113
ffffffffc0201e68:	0000a517          	auipc	a0,0xa
ffffffffc0201e6c:	5e850513          	addi	a0,a0,1512 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0201e70:	e2efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201e74 <slob_alloc.constprop.0>:
ffffffffc0201e74:	1101                	addi	sp,sp,-32
ffffffffc0201e76:	ec06                	sd	ra,24(sp)
ffffffffc0201e78:	e822                	sd	s0,16(sp)
ffffffffc0201e7a:	e426                	sd	s1,8(sp)
ffffffffc0201e7c:	e04a                	sd	s2,0(sp)
ffffffffc0201e7e:	01050713          	addi	a4,a0,16
ffffffffc0201e82:	6785                	lui	a5,0x1
ffffffffc0201e84:	0cf77363          	bgeu	a4,a5,ffffffffc0201f4a <slob_alloc.constprop.0+0xd6>
ffffffffc0201e88:	00f50493          	addi	s1,a0,15
ffffffffc0201e8c:	8091                	srli	s1,s1,0x4
ffffffffc0201e8e:	2481                	sext.w	s1,s1
ffffffffc0201e90:	10002673          	csrr	a2,sstatus
ffffffffc0201e94:	8a09                	andi	a2,a2,2
ffffffffc0201e96:	e25d                	bnez	a2,ffffffffc0201f3c <slob_alloc.constprop.0+0xc8>
ffffffffc0201e98:	0008f917          	auipc	s2,0x8f
ffffffffc0201e9c:	1b890913          	addi	s2,s2,440 # ffffffffc0291050 <slobfree>
ffffffffc0201ea0:	00093683          	ld	a3,0(s2)
ffffffffc0201ea4:	669c                	ld	a5,8(a3)
ffffffffc0201ea6:	4398                	lw	a4,0(a5)
ffffffffc0201ea8:	08975e63          	bge	a4,s1,ffffffffc0201f44 <slob_alloc.constprop.0+0xd0>
ffffffffc0201eac:	00f68b63          	beq	a3,a5,ffffffffc0201ec2 <slob_alloc.constprop.0+0x4e>
ffffffffc0201eb0:	6780                	ld	s0,8(a5)
ffffffffc0201eb2:	4018                	lw	a4,0(s0)
ffffffffc0201eb4:	02975a63          	bge	a4,s1,ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201eb8:	00093683          	ld	a3,0(s2)
ffffffffc0201ebc:	87a2                	mv	a5,s0
ffffffffc0201ebe:	fef699e3          	bne	a3,a5,ffffffffc0201eb0 <slob_alloc.constprop.0+0x3c>
ffffffffc0201ec2:	ee31                	bnez	a2,ffffffffc0201f1e <slob_alloc.constprop.0+0xaa>
ffffffffc0201ec4:	4501                	li	a0,0
ffffffffc0201ec6:	f4bff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201eca:	842a                	mv	s0,a0
ffffffffc0201ecc:	cd05                	beqz	a0,ffffffffc0201f04 <slob_alloc.constprop.0+0x90>
ffffffffc0201ece:	6585                	lui	a1,0x1
ffffffffc0201ed0:	e8dff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc0201ed4:	10002673          	csrr	a2,sstatus
ffffffffc0201ed8:	8a09                	andi	a2,a2,2
ffffffffc0201eda:	ee05                	bnez	a2,ffffffffc0201f12 <slob_alloc.constprop.0+0x9e>
ffffffffc0201edc:	00093783          	ld	a5,0(s2)
ffffffffc0201ee0:	6780                	ld	s0,8(a5)
ffffffffc0201ee2:	4018                	lw	a4,0(s0)
ffffffffc0201ee4:	fc974ae3          	blt	a4,s1,ffffffffc0201eb8 <slob_alloc.constprop.0+0x44>
ffffffffc0201ee8:	04e48763          	beq	s1,a4,ffffffffc0201f36 <slob_alloc.constprop.0+0xc2>
ffffffffc0201eec:	00449693          	slli	a3,s1,0x4
ffffffffc0201ef0:	96a2                	add	a3,a3,s0
ffffffffc0201ef2:	e794                	sd	a3,8(a5)
ffffffffc0201ef4:	640c                	ld	a1,8(s0)
ffffffffc0201ef6:	9f05                	subw	a4,a4,s1
ffffffffc0201ef8:	c298                	sw	a4,0(a3)
ffffffffc0201efa:	e68c                	sd	a1,8(a3)
ffffffffc0201efc:	c004                	sw	s1,0(s0)
ffffffffc0201efe:	00f93023          	sd	a5,0(s2)
ffffffffc0201f02:	e20d                	bnez	a2,ffffffffc0201f24 <slob_alloc.constprop.0+0xb0>
ffffffffc0201f04:	60e2                	ld	ra,24(sp)
ffffffffc0201f06:	8522                	mv	a0,s0
ffffffffc0201f08:	6442                	ld	s0,16(sp)
ffffffffc0201f0a:	64a2                	ld	s1,8(sp)
ffffffffc0201f0c:	6902                	ld	s2,0(sp)
ffffffffc0201f0e:	6105                	addi	sp,sp,32
ffffffffc0201f10:	8082                	ret
ffffffffc0201f12:	d61fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f16:	00093783          	ld	a5,0(s2)
ffffffffc0201f1a:	4605                	li	a2,1
ffffffffc0201f1c:	b7d1                	j	ffffffffc0201ee0 <slob_alloc.constprop.0+0x6c>
ffffffffc0201f1e:	d4ffe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f22:	b74d                	j	ffffffffc0201ec4 <slob_alloc.constprop.0+0x50>
ffffffffc0201f24:	d49fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f28:	60e2                	ld	ra,24(sp)
ffffffffc0201f2a:	8522                	mv	a0,s0
ffffffffc0201f2c:	6442                	ld	s0,16(sp)
ffffffffc0201f2e:	64a2                	ld	s1,8(sp)
ffffffffc0201f30:	6902                	ld	s2,0(sp)
ffffffffc0201f32:	6105                	addi	sp,sp,32
ffffffffc0201f34:	8082                	ret
ffffffffc0201f36:	6418                	ld	a4,8(s0)
ffffffffc0201f38:	e798                	sd	a4,8(a5)
ffffffffc0201f3a:	b7d1                	j	ffffffffc0201efe <slob_alloc.constprop.0+0x8a>
ffffffffc0201f3c:	d37fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f40:	4605                	li	a2,1
ffffffffc0201f42:	bf99                	j	ffffffffc0201e98 <slob_alloc.constprop.0+0x24>
ffffffffc0201f44:	843e                	mv	s0,a5
ffffffffc0201f46:	87b6                	mv	a5,a3
ffffffffc0201f48:	b745                	j	ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201f4a:	0000a697          	auipc	a3,0xa
ffffffffc0201f4e:	51668693          	addi	a3,a3,1302 # ffffffffc020c460 <default_pmm_manager+0x70>
ffffffffc0201f52:	0000a617          	auipc	a2,0xa
ffffffffc0201f56:	9b660613          	addi	a2,a2,-1610 # ffffffffc020b908 <commands+0x210>
ffffffffc0201f5a:	06300593          	li	a1,99
ffffffffc0201f5e:	0000a517          	auipc	a0,0xa
ffffffffc0201f62:	52250513          	addi	a0,a0,1314 # ffffffffc020c480 <default_pmm_manager+0x90>
ffffffffc0201f66:	d38fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201f6a <kmalloc_init>:
ffffffffc0201f6a:	1141                	addi	sp,sp,-16
ffffffffc0201f6c:	0000a517          	auipc	a0,0xa
ffffffffc0201f70:	52c50513          	addi	a0,a0,1324 # ffffffffc020c498 <default_pmm_manager+0xa8>
ffffffffc0201f74:	e406                	sd	ra,8(sp)
ffffffffc0201f76:	a30fe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201f7a:	60a2                	ld	ra,8(sp)
ffffffffc0201f7c:	0000a517          	auipc	a0,0xa
ffffffffc0201f80:	53450513          	addi	a0,a0,1332 # ffffffffc020c4b0 <default_pmm_manager+0xc0>
ffffffffc0201f84:	0141                	addi	sp,sp,16
ffffffffc0201f86:	a20fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201f8a <kallocated>:
ffffffffc0201f8a:	4501                	li	a0,0
ffffffffc0201f8c:	8082                	ret

ffffffffc0201f8e <kmalloc>:
ffffffffc0201f8e:	1101                	addi	sp,sp,-32
ffffffffc0201f90:	e04a                	sd	s2,0(sp)
ffffffffc0201f92:	6905                	lui	s2,0x1
ffffffffc0201f94:	e822                	sd	s0,16(sp)
ffffffffc0201f96:	ec06                	sd	ra,24(sp)
ffffffffc0201f98:	e426                	sd	s1,8(sp)
ffffffffc0201f9a:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201f9e:	842a                	mv	s0,a0
ffffffffc0201fa0:	04a7f963          	bgeu	a5,a0,ffffffffc0201ff2 <kmalloc+0x64>
ffffffffc0201fa4:	4561                	li	a0,24
ffffffffc0201fa6:	ecfff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201faa:	84aa                	mv	s1,a0
ffffffffc0201fac:	c929                	beqz	a0,ffffffffc0201ffe <kmalloc+0x70>
ffffffffc0201fae:	0004079b          	sext.w	a5,s0
ffffffffc0201fb2:	4501                	li	a0,0
ffffffffc0201fb4:	00f95763          	bge	s2,a5,ffffffffc0201fc2 <kmalloc+0x34>
ffffffffc0201fb8:	6705                	lui	a4,0x1
ffffffffc0201fba:	8785                	srai	a5,a5,0x1
ffffffffc0201fbc:	2505                	addiw	a0,a0,1
ffffffffc0201fbe:	fef74ee3          	blt	a4,a5,ffffffffc0201fba <kmalloc+0x2c>
ffffffffc0201fc2:	c088                	sw	a0,0(s1)
ffffffffc0201fc4:	e4dff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201fc8:	e488                	sd	a0,8(s1)
ffffffffc0201fca:	842a                	mv	s0,a0
ffffffffc0201fcc:	c525                	beqz	a0,ffffffffc0202034 <kmalloc+0xa6>
ffffffffc0201fce:	100027f3          	csrr	a5,sstatus
ffffffffc0201fd2:	8b89                	andi	a5,a5,2
ffffffffc0201fd4:	ef8d                	bnez	a5,ffffffffc020200e <kmalloc+0x80>
ffffffffc0201fd6:	00095797          	auipc	a5,0x95
ffffffffc0201fda:	8b278793          	addi	a5,a5,-1870 # ffffffffc0296888 <bigblocks>
ffffffffc0201fde:	6398                	ld	a4,0(a5)
ffffffffc0201fe0:	e384                	sd	s1,0(a5)
ffffffffc0201fe2:	e898                	sd	a4,16(s1)
ffffffffc0201fe4:	60e2                	ld	ra,24(sp)
ffffffffc0201fe6:	8522                	mv	a0,s0
ffffffffc0201fe8:	6442                	ld	s0,16(sp)
ffffffffc0201fea:	64a2                	ld	s1,8(sp)
ffffffffc0201fec:	6902                	ld	s2,0(sp)
ffffffffc0201fee:	6105                	addi	sp,sp,32
ffffffffc0201ff0:	8082                	ret
ffffffffc0201ff2:	0541                	addi	a0,a0,16
ffffffffc0201ff4:	e81ff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201ff8:	01050413          	addi	s0,a0,16
ffffffffc0201ffc:	f565                	bnez	a0,ffffffffc0201fe4 <kmalloc+0x56>
ffffffffc0201ffe:	4401                	li	s0,0
ffffffffc0202000:	60e2                	ld	ra,24(sp)
ffffffffc0202002:	8522                	mv	a0,s0
ffffffffc0202004:	6442                	ld	s0,16(sp)
ffffffffc0202006:	64a2                	ld	s1,8(sp)
ffffffffc0202008:	6902                	ld	s2,0(sp)
ffffffffc020200a:	6105                	addi	sp,sp,32
ffffffffc020200c:	8082                	ret
ffffffffc020200e:	c65fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202012:	00095797          	auipc	a5,0x95
ffffffffc0202016:	87678793          	addi	a5,a5,-1930 # ffffffffc0296888 <bigblocks>
ffffffffc020201a:	6398                	ld	a4,0(a5)
ffffffffc020201c:	e384                	sd	s1,0(a5)
ffffffffc020201e:	e898                	sd	a4,16(s1)
ffffffffc0202020:	c4dfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202024:	6480                	ld	s0,8(s1)
ffffffffc0202026:	60e2                	ld	ra,24(sp)
ffffffffc0202028:	64a2                	ld	s1,8(sp)
ffffffffc020202a:	8522                	mv	a0,s0
ffffffffc020202c:	6442                	ld	s0,16(sp)
ffffffffc020202e:	6902                	ld	s2,0(sp)
ffffffffc0202030:	6105                	addi	sp,sp,32
ffffffffc0202032:	8082                	ret
ffffffffc0202034:	45e1                	li	a1,24
ffffffffc0202036:	8526                	mv	a0,s1
ffffffffc0202038:	d25ff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc020203c:	b765                	j	ffffffffc0201fe4 <kmalloc+0x56>

ffffffffc020203e <kfree>:
ffffffffc020203e:	c169                	beqz	a0,ffffffffc0202100 <kfree+0xc2>
ffffffffc0202040:	1101                	addi	sp,sp,-32
ffffffffc0202042:	e822                	sd	s0,16(sp)
ffffffffc0202044:	ec06                	sd	ra,24(sp)
ffffffffc0202046:	e426                	sd	s1,8(sp)
ffffffffc0202048:	03451793          	slli	a5,a0,0x34
ffffffffc020204c:	842a                	mv	s0,a0
ffffffffc020204e:	e3d9                	bnez	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202050:	100027f3          	csrr	a5,sstatus
ffffffffc0202054:	8b89                	andi	a5,a5,2
ffffffffc0202056:	e7d9                	bnez	a5,ffffffffc02020e4 <kfree+0xa6>
ffffffffc0202058:	00095797          	auipc	a5,0x95
ffffffffc020205c:	8307b783          	ld	a5,-2000(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202060:	4601                	li	a2,0
ffffffffc0202062:	cbad                	beqz	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202064:	00095697          	auipc	a3,0x95
ffffffffc0202068:	82468693          	addi	a3,a3,-2012 # ffffffffc0296888 <bigblocks>
ffffffffc020206c:	a021                	j	ffffffffc0202074 <kfree+0x36>
ffffffffc020206e:	01048693          	addi	a3,s1,16
ffffffffc0202072:	c3a5                	beqz	a5,ffffffffc02020d2 <kfree+0x94>
ffffffffc0202074:	6798                	ld	a4,8(a5)
ffffffffc0202076:	84be                	mv	s1,a5
ffffffffc0202078:	6b9c                	ld	a5,16(a5)
ffffffffc020207a:	fe871ae3          	bne	a4,s0,ffffffffc020206e <kfree+0x30>
ffffffffc020207e:	e29c                	sd	a5,0(a3)
ffffffffc0202080:	ee2d                	bnez	a2,ffffffffc02020fa <kfree+0xbc>
ffffffffc0202082:	c02007b7          	lui	a5,0xc0200
ffffffffc0202086:	4098                	lw	a4,0(s1)
ffffffffc0202088:	08f46963          	bltu	s0,a5,ffffffffc020211a <kfree+0xdc>
ffffffffc020208c:	00095697          	auipc	a3,0x95
ffffffffc0202090:	82c6b683          	ld	a3,-2004(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202094:	8c15                	sub	s0,s0,a3
ffffffffc0202096:	8031                	srli	s0,s0,0xc
ffffffffc0202098:	00095797          	auipc	a5,0x95
ffffffffc020209c:	8087b783          	ld	a5,-2040(a5) # ffffffffc02968a0 <npage>
ffffffffc02020a0:	06f47163          	bgeu	s0,a5,ffffffffc0202102 <kfree+0xc4>
ffffffffc02020a4:	0000d517          	auipc	a0,0xd
ffffffffc02020a8:	68c53503          	ld	a0,1676(a0) # ffffffffc020f730 <nbase>
ffffffffc02020ac:	8c09                	sub	s0,s0,a0
ffffffffc02020ae:	041a                	slli	s0,s0,0x6
ffffffffc02020b0:	00094517          	auipc	a0,0x94
ffffffffc02020b4:	7f853503          	ld	a0,2040(a0) # ffffffffc02968a8 <pages>
ffffffffc02020b8:	4585                	li	a1,1
ffffffffc02020ba:	9522                	add	a0,a0,s0
ffffffffc02020bc:	00e595bb          	sllw	a1,a1,a4
ffffffffc02020c0:	0ea000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02020c4:	6442                	ld	s0,16(sp)
ffffffffc02020c6:	60e2                	ld	ra,24(sp)
ffffffffc02020c8:	8526                	mv	a0,s1
ffffffffc02020ca:	64a2                	ld	s1,8(sp)
ffffffffc02020cc:	45e1                	li	a1,24
ffffffffc02020ce:	6105                	addi	sp,sp,32
ffffffffc02020d0:	b171                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020d2:	e20d                	bnez	a2,ffffffffc02020f4 <kfree+0xb6>
ffffffffc02020d4:	ff040513          	addi	a0,s0,-16
ffffffffc02020d8:	6442                	ld	s0,16(sp)
ffffffffc02020da:	60e2                	ld	ra,24(sp)
ffffffffc02020dc:	64a2                	ld	s1,8(sp)
ffffffffc02020de:	4581                	li	a1,0
ffffffffc02020e0:	6105                	addi	sp,sp,32
ffffffffc02020e2:	b9ad                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020e4:	b8ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02020e8:	00094797          	auipc	a5,0x94
ffffffffc02020ec:	7a07b783          	ld	a5,1952(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020f0:	4605                	li	a2,1
ffffffffc02020f2:	fbad                	bnez	a5,ffffffffc0202064 <kfree+0x26>
ffffffffc02020f4:	b79fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020f8:	bff1                	j	ffffffffc02020d4 <kfree+0x96>
ffffffffc02020fa:	b73fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020fe:	b751                	j	ffffffffc0202082 <kfree+0x44>
ffffffffc0202100:	8082                	ret
ffffffffc0202102:	0000a617          	auipc	a2,0xa
ffffffffc0202106:	3f660613          	addi	a2,a2,1014 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc020210a:	06900593          	li	a1,105
ffffffffc020210e:	0000a517          	auipc	a0,0xa
ffffffffc0202112:	34250513          	addi	a0,a0,834 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0202116:	b88fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020211a:	86a2                	mv	a3,s0
ffffffffc020211c:	0000a617          	auipc	a2,0xa
ffffffffc0202120:	3b460613          	addi	a2,a2,948 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0202124:	07700593          	li	a1,119
ffffffffc0202128:	0000a517          	auipc	a0,0xa
ffffffffc020212c:	32850513          	addi	a0,a0,808 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0202130:	b6efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202134 <pa2page.part.0>:
ffffffffc0202134:	1141                	addi	sp,sp,-16
ffffffffc0202136:	0000a617          	auipc	a2,0xa
ffffffffc020213a:	3c260613          	addi	a2,a2,962 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc020213e:	06900593          	li	a1,105
ffffffffc0202142:	0000a517          	auipc	a0,0xa
ffffffffc0202146:	30e50513          	addi	a0,a0,782 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc020214a:	e406                	sd	ra,8(sp)
ffffffffc020214c:	b52fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202150 <pte2page.part.0>:
ffffffffc0202150:	1141                	addi	sp,sp,-16
ffffffffc0202152:	0000a617          	auipc	a2,0xa
ffffffffc0202156:	3c660613          	addi	a2,a2,966 # ffffffffc020c518 <default_pmm_manager+0x128>
ffffffffc020215a:	07f00593          	li	a1,127
ffffffffc020215e:	0000a517          	auipc	a0,0xa
ffffffffc0202162:	2f250513          	addi	a0,a0,754 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0202166:	e406                	sd	ra,8(sp)
ffffffffc0202168:	b36fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020216c <alloc_pages>:
ffffffffc020216c:	100027f3          	csrr	a5,sstatus
ffffffffc0202170:	8b89                	andi	a5,a5,2
ffffffffc0202172:	e799                	bnez	a5,ffffffffc0202180 <alloc_pages+0x14>
ffffffffc0202174:	00094797          	auipc	a5,0x94
ffffffffc0202178:	73c7b783          	ld	a5,1852(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020217c:	6f9c                	ld	a5,24(a5)
ffffffffc020217e:	8782                	jr	a5
ffffffffc0202180:	1141                	addi	sp,sp,-16
ffffffffc0202182:	e406                	sd	ra,8(sp)
ffffffffc0202184:	e022                	sd	s0,0(sp)
ffffffffc0202186:	842a                	mv	s0,a0
ffffffffc0202188:	aebfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020218c:	00094797          	auipc	a5,0x94
ffffffffc0202190:	7247b783          	ld	a5,1828(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202194:	6f9c                	ld	a5,24(a5)
ffffffffc0202196:	8522                	mv	a0,s0
ffffffffc0202198:	9782                	jalr	a5
ffffffffc020219a:	842a                	mv	s0,a0
ffffffffc020219c:	ad1fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02021a0:	60a2                	ld	ra,8(sp)
ffffffffc02021a2:	8522                	mv	a0,s0
ffffffffc02021a4:	6402                	ld	s0,0(sp)
ffffffffc02021a6:	0141                	addi	sp,sp,16
ffffffffc02021a8:	8082                	ret

ffffffffc02021aa <free_pages>:
ffffffffc02021aa:	100027f3          	csrr	a5,sstatus
ffffffffc02021ae:	8b89                	andi	a5,a5,2
ffffffffc02021b0:	e799                	bnez	a5,ffffffffc02021be <free_pages+0x14>
ffffffffc02021b2:	00094797          	auipc	a5,0x94
ffffffffc02021b6:	6fe7b783          	ld	a5,1790(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021ba:	739c                	ld	a5,32(a5)
ffffffffc02021bc:	8782                	jr	a5
ffffffffc02021be:	1101                	addi	sp,sp,-32
ffffffffc02021c0:	ec06                	sd	ra,24(sp)
ffffffffc02021c2:	e822                	sd	s0,16(sp)
ffffffffc02021c4:	e426                	sd	s1,8(sp)
ffffffffc02021c6:	842a                	mv	s0,a0
ffffffffc02021c8:	84ae                	mv	s1,a1
ffffffffc02021ca:	aa9fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02021ce:	00094797          	auipc	a5,0x94
ffffffffc02021d2:	6e27b783          	ld	a5,1762(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021d6:	739c                	ld	a5,32(a5)
ffffffffc02021d8:	85a6                	mv	a1,s1
ffffffffc02021da:	8522                	mv	a0,s0
ffffffffc02021dc:	9782                	jalr	a5
ffffffffc02021de:	6442                	ld	s0,16(sp)
ffffffffc02021e0:	60e2                	ld	ra,24(sp)
ffffffffc02021e2:	64a2                	ld	s1,8(sp)
ffffffffc02021e4:	6105                	addi	sp,sp,32
ffffffffc02021e6:	a87fe06f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc02021ea <nr_free_pages>:
ffffffffc02021ea:	100027f3          	csrr	a5,sstatus
ffffffffc02021ee:	8b89                	andi	a5,a5,2
ffffffffc02021f0:	e799                	bnez	a5,ffffffffc02021fe <nr_free_pages+0x14>
ffffffffc02021f2:	00094797          	auipc	a5,0x94
ffffffffc02021f6:	6be7b783          	ld	a5,1726(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021fa:	779c                	ld	a5,40(a5)
ffffffffc02021fc:	8782                	jr	a5
ffffffffc02021fe:	1141                	addi	sp,sp,-16
ffffffffc0202200:	e406                	sd	ra,8(sp)
ffffffffc0202202:	e022                	sd	s0,0(sp)
ffffffffc0202204:	a6ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202208:	00094797          	auipc	a5,0x94
ffffffffc020220c:	6a87b783          	ld	a5,1704(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202210:	779c                	ld	a5,40(a5)
ffffffffc0202212:	9782                	jalr	a5
ffffffffc0202214:	842a                	mv	s0,a0
ffffffffc0202216:	a57fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020221a:	60a2                	ld	ra,8(sp)
ffffffffc020221c:	8522                	mv	a0,s0
ffffffffc020221e:	6402                	ld	s0,0(sp)
ffffffffc0202220:	0141                	addi	sp,sp,16
ffffffffc0202222:	8082                	ret

ffffffffc0202224 <get_pte>:
ffffffffc0202224:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202228:	1ff7f793          	andi	a5,a5,511
ffffffffc020222c:	7139                	addi	sp,sp,-64
ffffffffc020222e:	078e                	slli	a5,a5,0x3
ffffffffc0202230:	f426                	sd	s1,40(sp)
ffffffffc0202232:	00f504b3          	add	s1,a0,a5
ffffffffc0202236:	6094                	ld	a3,0(s1)
ffffffffc0202238:	f04a                	sd	s2,32(sp)
ffffffffc020223a:	ec4e                	sd	s3,24(sp)
ffffffffc020223c:	e852                	sd	s4,16(sp)
ffffffffc020223e:	fc06                	sd	ra,56(sp)
ffffffffc0202240:	f822                	sd	s0,48(sp)
ffffffffc0202242:	e456                	sd	s5,8(sp)
ffffffffc0202244:	e05a                	sd	s6,0(sp)
ffffffffc0202246:	0016f793          	andi	a5,a3,1
ffffffffc020224a:	892e                	mv	s2,a1
ffffffffc020224c:	8a32                	mv	s4,a2
ffffffffc020224e:	00094997          	auipc	s3,0x94
ffffffffc0202252:	65298993          	addi	s3,s3,1618 # ffffffffc02968a0 <npage>
ffffffffc0202256:	efbd                	bnez	a5,ffffffffc02022d4 <get_pte+0xb0>
ffffffffc0202258:	14060c63          	beqz	a2,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020225c:	100027f3          	csrr	a5,sstatus
ffffffffc0202260:	8b89                	andi	a5,a5,2
ffffffffc0202262:	14079963          	bnez	a5,ffffffffc02023b4 <get_pte+0x190>
ffffffffc0202266:	00094797          	auipc	a5,0x94
ffffffffc020226a:	64a7b783          	ld	a5,1610(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020226e:	6f9c                	ld	a5,24(a5)
ffffffffc0202270:	4505                	li	a0,1
ffffffffc0202272:	9782                	jalr	a5
ffffffffc0202274:	842a                	mv	s0,a0
ffffffffc0202276:	12040d63          	beqz	s0,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020227a:	00094b17          	auipc	s6,0x94
ffffffffc020227e:	62eb0b13          	addi	s6,s6,1582 # ffffffffc02968a8 <pages>
ffffffffc0202282:	000b3503          	ld	a0,0(s6)
ffffffffc0202286:	00080ab7          	lui	s5,0x80
ffffffffc020228a:	00094997          	auipc	s3,0x94
ffffffffc020228e:	61698993          	addi	s3,s3,1558 # ffffffffc02968a0 <npage>
ffffffffc0202292:	40a40533          	sub	a0,s0,a0
ffffffffc0202296:	8519                	srai	a0,a0,0x6
ffffffffc0202298:	9556                	add	a0,a0,s5
ffffffffc020229a:	0009b703          	ld	a4,0(s3)
ffffffffc020229e:	00c51793          	slli	a5,a0,0xc
ffffffffc02022a2:	4685                	li	a3,1
ffffffffc02022a4:	c014                	sw	a3,0(s0)
ffffffffc02022a6:	83b1                	srli	a5,a5,0xc
ffffffffc02022a8:	0532                	slli	a0,a0,0xc
ffffffffc02022aa:	16e7f763          	bgeu	a5,a4,ffffffffc0202418 <get_pte+0x1f4>
ffffffffc02022ae:	00094797          	auipc	a5,0x94
ffffffffc02022b2:	60a7b783          	ld	a5,1546(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022b6:	6605                	lui	a2,0x1
ffffffffc02022b8:	4581                	li	a1,0
ffffffffc02022ba:	953e                	add	a0,a0,a5
ffffffffc02022bc:	168090ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc02022c0:	000b3683          	ld	a3,0(s6)
ffffffffc02022c4:	40d406b3          	sub	a3,s0,a3
ffffffffc02022c8:	8699                	srai	a3,a3,0x6
ffffffffc02022ca:	96d6                	add	a3,a3,s5
ffffffffc02022cc:	06aa                	slli	a3,a3,0xa
ffffffffc02022ce:	0116e693          	ori	a3,a3,17
ffffffffc02022d2:	e094                	sd	a3,0(s1)
ffffffffc02022d4:	77fd                	lui	a5,0xfffff
ffffffffc02022d6:	068a                	slli	a3,a3,0x2
ffffffffc02022d8:	0009b703          	ld	a4,0(s3)
ffffffffc02022dc:	8efd                	and	a3,a3,a5
ffffffffc02022de:	00c6d793          	srli	a5,a3,0xc
ffffffffc02022e2:	10e7ff63          	bgeu	a5,a4,ffffffffc0202400 <get_pte+0x1dc>
ffffffffc02022e6:	00094a97          	auipc	s5,0x94
ffffffffc02022ea:	5d2a8a93          	addi	s5,s5,1490 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022ee:	000ab403          	ld	s0,0(s5)
ffffffffc02022f2:	01595793          	srli	a5,s2,0x15
ffffffffc02022f6:	1ff7f793          	andi	a5,a5,511
ffffffffc02022fa:	96a2                	add	a3,a3,s0
ffffffffc02022fc:	00379413          	slli	s0,a5,0x3
ffffffffc0202300:	9436                	add	s0,s0,a3
ffffffffc0202302:	6014                	ld	a3,0(s0)
ffffffffc0202304:	0016f793          	andi	a5,a3,1
ffffffffc0202308:	ebad                	bnez	a5,ffffffffc020237a <get_pte+0x156>
ffffffffc020230a:	0a0a0363          	beqz	s4,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020230e:	100027f3          	csrr	a5,sstatus
ffffffffc0202312:	8b89                	andi	a5,a5,2
ffffffffc0202314:	efcd                	bnez	a5,ffffffffc02023ce <get_pte+0x1aa>
ffffffffc0202316:	00094797          	auipc	a5,0x94
ffffffffc020231a:	59a7b783          	ld	a5,1434(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020231e:	6f9c                	ld	a5,24(a5)
ffffffffc0202320:	4505                	li	a0,1
ffffffffc0202322:	9782                	jalr	a5
ffffffffc0202324:	84aa                	mv	s1,a0
ffffffffc0202326:	c4c9                	beqz	s1,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc0202328:	00094b17          	auipc	s6,0x94
ffffffffc020232c:	580b0b13          	addi	s6,s6,1408 # ffffffffc02968a8 <pages>
ffffffffc0202330:	000b3503          	ld	a0,0(s6)
ffffffffc0202334:	00080a37          	lui	s4,0x80
ffffffffc0202338:	0009b703          	ld	a4,0(s3)
ffffffffc020233c:	40a48533          	sub	a0,s1,a0
ffffffffc0202340:	8519                	srai	a0,a0,0x6
ffffffffc0202342:	9552                	add	a0,a0,s4
ffffffffc0202344:	00c51793          	slli	a5,a0,0xc
ffffffffc0202348:	4685                	li	a3,1
ffffffffc020234a:	c094                	sw	a3,0(s1)
ffffffffc020234c:	83b1                	srli	a5,a5,0xc
ffffffffc020234e:	0532                	slli	a0,a0,0xc
ffffffffc0202350:	0ee7f163          	bgeu	a5,a4,ffffffffc0202432 <get_pte+0x20e>
ffffffffc0202354:	000ab783          	ld	a5,0(s5)
ffffffffc0202358:	6605                	lui	a2,0x1
ffffffffc020235a:	4581                	li	a1,0
ffffffffc020235c:	953e                	add	a0,a0,a5
ffffffffc020235e:	0c6090ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0202362:	000b3683          	ld	a3,0(s6)
ffffffffc0202366:	40d486b3          	sub	a3,s1,a3
ffffffffc020236a:	8699                	srai	a3,a3,0x6
ffffffffc020236c:	96d2                	add	a3,a3,s4
ffffffffc020236e:	06aa                	slli	a3,a3,0xa
ffffffffc0202370:	0116e693          	ori	a3,a3,17
ffffffffc0202374:	e014                	sd	a3,0(s0)
ffffffffc0202376:	0009b703          	ld	a4,0(s3)
ffffffffc020237a:	068a                	slli	a3,a3,0x2
ffffffffc020237c:	757d                	lui	a0,0xfffff
ffffffffc020237e:	8ee9                	and	a3,a3,a0
ffffffffc0202380:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202384:	06e7f263          	bgeu	a5,a4,ffffffffc02023e8 <get_pte+0x1c4>
ffffffffc0202388:	000ab503          	ld	a0,0(s5)
ffffffffc020238c:	00c95913          	srli	s2,s2,0xc
ffffffffc0202390:	1ff97913          	andi	s2,s2,511
ffffffffc0202394:	96aa                	add	a3,a3,a0
ffffffffc0202396:	00391513          	slli	a0,s2,0x3
ffffffffc020239a:	9536                	add	a0,a0,a3
ffffffffc020239c:	70e2                	ld	ra,56(sp)
ffffffffc020239e:	7442                	ld	s0,48(sp)
ffffffffc02023a0:	74a2                	ld	s1,40(sp)
ffffffffc02023a2:	7902                	ld	s2,32(sp)
ffffffffc02023a4:	69e2                	ld	s3,24(sp)
ffffffffc02023a6:	6a42                	ld	s4,16(sp)
ffffffffc02023a8:	6aa2                	ld	s5,8(sp)
ffffffffc02023aa:	6b02                	ld	s6,0(sp)
ffffffffc02023ac:	6121                	addi	sp,sp,64
ffffffffc02023ae:	8082                	ret
ffffffffc02023b0:	4501                	li	a0,0
ffffffffc02023b2:	b7ed                	j	ffffffffc020239c <get_pte+0x178>
ffffffffc02023b4:	8bffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023b8:	00094797          	auipc	a5,0x94
ffffffffc02023bc:	4f87b783          	ld	a5,1272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023c0:	6f9c                	ld	a5,24(a5)
ffffffffc02023c2:	4505                	li	a0,1
ffffffffc02023c4:	9782                	jalr	a5
ffffffffc02023c6:	842a                	mv	s0,a0
ffffffffc02023c8:	8a5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023cc:	b56d                	j	ffffffffc0202276 <get_pte+0x52>
ffffffffc02023ce:	8a5fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023d2:	00094797          	auipc	a5,0x94
ffffffffc02023d6:	4de7b783          	ld	a5,1246(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023da:	6f9c                	ld	a5,24(a5)
ffffffffc02023dc:	4505                	li	a0,1
ffffffffc02023de:	9782                	jalr	a5
ffffffffc02023e0:	84aa                	mv	s1,a0
ffffffffc02023e2:	88bfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023e6:	b781                	j	ffffffffc0202326 <get_pte+0x102>
ffffffffc02023e8:	0000a617          	auipc	a2,0xa
ffffffffc02023ec:	04060613          	addi	a2,a2,64 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc02023f0:	13200593          	li	a1,306
ffffffffc02023f4:	0000a517          	auipc	a0,0xa
ffffffffc02023f8:	14c50513          	addi	a0,a0,332 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02023fc:	8a2fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202400:	0000a617          	auipc	a2,0xa
ffffffffc0202404:	02860613          	addi	a2,a2,40 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0202408:	12500593          	li	a1,293
ffffffffc020240c:	0000a517          	auipc	a0,0xa
ffffffffc0202410:	13450513          	addi	a0,a0,308 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0202414:	88afe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202418:	86aa                	mv	a3,a0
ffffffffc020241a:	0000a617          	auipc	a2,0xa
ffffffffc020241e:	00e60613          	addi	a2,a2,14 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0202422:	12100593          	li	a1,289
ffffffffc0202426:	0000a517          	auipc	a0,0xa
ffffffffc020242a:	11a50513          	addi	a0,a0,282 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020242e:	870fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202432:	86aa                	mv	a3,a0
ffffffffc0202434:	0000a617          	auipc	a2,0xa
ffffffffc0202438:	ff460613          	addi	a2,a2,-12 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc020243c:	12f00593          	li	a1,303
ffffffffc0202440:	0000a517          	auipc	a0,0xa
ffffffffc0202444:	10050513          	addi	a0,a0,256 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0202448:	856fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020244c <boot_map_segment>:
ffffffffc020244c:	6785                	lui	a5,0x1
ffffffffc020244e:	7139                	addi	sp,sp,-64
ffffffffc0202450:	00d5c833          	xor	a6,a1,a3
ffffffffc0202454:	17fd                	addi	a5,a5,-1
ffffffffc0202456:	fc06                	sd	ra,56(sp)
ffffffffc0202458:	f822                	sd	s0,48(sp)
ffffffffc020245a:	f426                	sd	s1,40(sp)
ffffffffc020245c:	f04a                	sd	s2,32(sp)
ffffffffc020245e:	ec4e                	sd	s3,24(sp)
ffffffffc0202460:	e852                	sd	s4,16(sp)
ffffffffc0202462:	e456                	sd	s5,8(sp)
ffffffffc0202464:	00f87833          	and	a6,a6,a5
ffffffffc0202468:	08081563          	bnez	a6,ffffffffc02024f2 <boot_map_segment+0xa6>
ffffffffc020246c:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202470:	963e                	add	a2,a2,a5
ffffffffc0202472:	94b2                	add	s1,s1,a2
ffffffffc0202474:	797d                	lui	s2,0xfffff
ffffffffc0202476:	80b1                	srli	s1,s1,0xc
ffffffffc0202478:	0125f5b3          	and	a1,a1,s2
ffffffffc020247c:	0126f6b3          	and	a3,a3,s2
ffffffffc0202480:	c0a1                	beqz	s1,ffffffffc02024c0 <boot_map_segment+0x74>
ffffffffc0202482:	00176713          	ori	a4,a4,1
ffffffffc0202486:	04b2                	slli	s1,s1,0xc
ffffffffc0202488:	02071993          	slli	s3,a4,0x20
ffffffffc020248c:	8a2a                	mv	s4,a0
ffffffffc020248e:	842e                	mv	s0,a1
ffffffffc0202490:	94ae                	add	s1,s1,a1
ffffffffc0202492:	40b68933          	sub	s2,a3,a1
ffffffffc0202496:	0209d993          	srli	s3,s3,0x20
ffffffffc020249a:	6a85                	lui	s5,0x1
ffffffffc020249c:	4605                	li	a2,1
ffffffffc020249e:	85a2                	mv	a1,s0
ffffffffc02024a0:	8552                	mv	a0,s4
ffffffffc02024a2:	d83ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02024a6:	008907b3          	add	a5,s2,s0
ffffffffc02024aa:	c505                	beqz	a0,ffffffffc02024d2 <boot_map_segment+0x86>
ffffffffc02024ac:	83b1                	srli	a5,a5,0xc
ffffffffc02024ae:	07aa                	slli	a5,a5,0xa
ffffffffc02024b0:	0137e7b3          	or	a5,a5,s3
ffffffffc02024b4:	0017e793          	ori	a5,a5,1
ffffffffc02024b8:	e11c                	sd	a5,0(a0)
ffffffffc02024ba:	9456                	add	s0,s0,s5
ffffffffc02024bc:	fe8490e3          	bne	s1,s0,ffffffffc020249c <boot_map_segment+0x50>
ffffffffc02024c0:	70e2                	ld	ra,56(sp)
ffffffffc02024c2:	7442                	ld	s0,48(sp)
ffffffffc02024c4:	74a2                	ld	s1,40(sp)
ffffffffc02024c6:	7902                	ld	s2,32(sp)
ffffffffc02024c8:	69e2                	ld	s3,24(sp)
ffffffffc02024ca:	6a42                	ld	s4,16(sp)
ffffffffc02024cc:	6aa2                	ld	s5,8(sp)
ffffffffc02024ce:	6121                	addi	sp,sp,64
ffffffffc02024d0:	8082                	ret
ffffffffc02024d2:	0000a697          	auipc	a3,0xa
ffffffffc02024d6:	09668693          	addi	a3,a3,150 # ffffffffc020c568 <default_pmm_manager+0x178>
ffffffffc02024da:	00009617          	auipc	a2,0x9
ffffffffc02024de:	42e60613          	addi	a2,a2,1070 # ffffffffc020b908 <commands+0x210>
ffffffffc02024e2:	09c00593          	li	a1,156
ffffffffc02024e6:	0000a517          	auipc	a0,0xa
ffffffffc02024ea:	05a50513          	addi	a0,a0,90 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02024ee:	fb1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024f2:	0000a697          	auipc	a3,0xa
ffffffffc02024f6:	05e68693          	addi	a3,a3,94 # ffffffffc020c550 <default_pmm_manager+0x160>
ffffffffc02024fa:	00009617          	auipc	a2,0x9
ffffffffc02024fe:	40e60613          	addi	a2,a2,1038 # ffffffffc020b908 <commands+0x210>
ffffffffc0202502:	09500593          	li	a1,149
ffffffffc0202506:	0000a517          	auipc	a0,0xa
ffffffffc020250a:	03a50513          	addi	a0,a0,58 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020250e:	f91fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202512 <get_page>:
ffffffffc0202512:	1141                	addi	sp,sp,-16
ffffffffc0202514:	e022                	sd	s0,0(sp)
ffffffffc0202516:	8432                	mv	s0,a2
ffffffffc0202518:	4601                	li	a2,0
ffffffffc020251a:	e406                	sd	ra,8(sp)
ffffffffc020251c:	d09ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202520:	c011                	beqz	s0,ffffffffc0202524 <get_page+0x12>
ffffffffc0202522:	e008                	sd	a0,0(s0)
ffffffffc0202524:	c511                	beqz	a0,ffffffffc0202530 <get_page+0x1e>
ffffffffc0202526:	611c                	ld	a5,0(a0)
ffffffffc0202528:	4501                	li	a0,0
ffffffffc020252a:	0017f713          	andi	a4,a5,1
ffffffffc020252e:	e709                	bnez	a4,ffffffffc0202538 <get_page+0x26>
ffffffffc0202530:	60a2                	ld	ra,8(sp)
ffffffffc0202532:	6402                	ld	s0,0(sp)
ffffffffc0202534:	0141                	addi	sp,sp,16
ffffffffc0202536:	8082                	ret
ffffffffc0202538:	078a                	slli	a5,a5,0x2
ffffffffc020253a:	83b1                	srli	a5,a5,0xc
ffffffffc020253c:	00094717          	auipc	a4,0x94
ffffffffc0202540:	36473703          	ld	a4,868(a4) # ffffffffc02968a0 <npage>
ffffffffc0202544:	00e7ff63          	bgeu	a5,a4,ffffffffc0202562 <get_page+0x50>
ffffffffc0202548:	60a2                	ld	ra,8(sp)
ffffffffc020254a:	6402                	ld	s0,0(sp)
ffffffffc020254c:	fff80537          	lui	a0,0xfff80
ffffffffc0202550:	97aa                	add	a5,a5,a0
ffffffffc0202552:	079a                	slli	a5,a5,0x6
ffffffffc0202554:	00094517          	auipc	a0,0x94
ffffffffc0202558:	35453503          	ld	a0,852(a0) # ffffffffc02968a8 <pages>
ffffffffc020255c:	953e                	add	a0,a0,a5
ffffffffc020255e:	0141                	addi	sp,sp,16
ffffffffc0202560:	8082                	ret
ffffffffc0202562:	bd3ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202566 <unmap_range>:
ffffffffc0202566:	7159                	addi	sp,sp,-112
ffffffffc0202568:	00c5e7b3          	or	a5,a1,a2
ffffffffc020256c:	f486                	sd	ra,104(sp)
ffffffffc020256e:	f0a2                	sd	s0,96(sp)
ffffffffc0202570:	eca6                	sd	s1,88(sp)
ffffffffc0202572:	e8ca                	sd	s2,80(sp)
ffffffffc0202574:	e4ce                	sd	s3,72(sp)
ffffffffc0202576:	e0d2                	sd	s4,64(sp)
ffffffffc0202578:	fc56                	sd	s5,56(sp)
ffffffffc020257a:	f85a                	sd	s6,48(sp)
ffffffffc020257c:	f45e                	sd	s7,40(sp)
ffffffffc020257e:	f062                	sd	s8,32(sp)
ffffffffc0202580:	ec66                	sd	s9,24(sp)
ffffffffc0202582:	e86a                	sd	s10,16(sp)
ffffffffc0202584:	17d2                	slli	a5,a5,0x34
ffffffffc0202586:	e3ed                	bnez	a5,ffffffffc0202668 <unmap_range+0x102>
ffffffffc0202588:	002007b7          	lui	a5,0x200
ffffffffc020258c:	842e                	mv	s0,a1
ffffffffc020258e:	0ef5ed63          	bltu	a1,a5,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202592:	8932                	mv	s2,a2
ffffffffc0202594:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202598:	4785                	li	a5,1
ffffffffc020259a:	07fe                	slli	a5,a5,0x1f
ffffffffc020259c:	0ec7e663          	bltu	a5,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc02025a0:	89aa                	mv	s3,a0
ffffffffc02025a2:	6a05                	lui	s4,0x1
ffffffffc02025a4:	00094c97          	auipc	s9,0x94
ffffffffc02025a8:	2fcc8c93          	addi	s9,s9,764 # ffffffffc02968a0 <npage>
ffffffffc02025ac:	00094c17          	auipc	s8,0x94
ffffffffc02025b0:	2fcc0c13          	addi	s8,s8,764 # ffffffffc02968a8 <pages>
ffffffffc02025b4:	fff80bb7          	lui	s7,0xfff80
ffffffffc02025b8:	00094d17          	auipc	s10,0x94
ffffffffc02025bc:	2f8d0d13          	addi	s10,s10,760 # ffffffffc02968b0 <pmm_manager>
ffffffffc02025c0:	00200b37          	lui	s6,0x200
ffffffffc02025c4:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02025c8:	4601                	li	a2,0
ffffffffc02025ca:	85a2                	mv	a1,s0
ffffffffc02025cc:	854e                	mv	a0,s3
ffffffffc02025ce:	c57ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02025d2:	84aa                	mv	s1,a0
ffffffffc02025d4:	cd29                	beqz	a0,ffffffffc020262e <unmap_range+0xc8>
ffffffffc02025d6:	611c                	ld	a5,0(a0)
ffffffffc02025d8:	e395                	bnez	a5,ffffffffc02025fc <unmap_range+0x96>
ffffffffc02025da:	9452                	add	s0,s0,s4
ffffffffc02025dc:	ff2466e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc02025e0:	70a6                	ld	ra,104(sp)
ffffffffc02025e2:	7406                	ld	s0,96(sp)
ffffffffc02025e4:	64e6                	ld	s1,88(sp)
ffffffffc02025e6:	6946                	ld	s2,80(sp)
ffffffffc02025e8:	69a6                	ld	s3,72(sp)
ffffffffc02025ea:	6a06                	ld	s4,64(sp)
ffffffffc02025ec:	7ae2                	ld	s5,56(sp)
ffffffffc02025ee:	7b42                	ld	s6,48(sp)
ffffffffc02025f0:	7ba2                	ld	s7,40(sp)
ffffffffc02025f2:	7c02                	ld	s8,32(sp)
ffffffffc02025f4:	6ce2                	ld	s9,24(sp)
ffffffffc02025f6:	6d42                	ld	s10,16(sp)
ffffffffc02025f8:	6165                	addi	sp,sp,112
ffffffffc02025fa:	8082                	ret
ffffffffc02025fc:	0017f713          	andi	a4,a5,1
ffffffffc0202600:	df69                	beqz	a4,ffffffffc02025da <unmap_range+0x74>
ffffffffc0202602:	000cb703          	ld	a4,0(s9)
ffffffffc0202606:	078a                	slli	a5,a5,0x2
ffffffffc0202608:	83b1                	srli	a5,a5,0xc
ffffffffc020260a:	08e7ff63          	bgeu	a5,a4,ffffffffc02026a8 <unmap_range+0x142>
ffffffffc020260e:	000c3503          	ld	a0,0(s8)
ffffffffc0202612:	97de                	add	a5,a5,s7
ffffffffc0202614:	079a                	slli	a5,a5,0x6
ffffffffc0202616:	953e                	add	a0,a0,a5
ffffffffc0202618:	411c                	lw	a5,0(a0)
ffffffffc020261a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020261e:	c118                	sw	a4,0(a0)
ffffffffc0202620:	cf11                	beqz	a4,ffffffffc020263c <unmap_range+0xd6>
ffffffffc0202622:	0004b023          	sd	zero,0(s1)
ffffffffc0202626:	12040073          	sfence.vma	s0
ffffffffc020262a:	9452                	add	s0,s0,s4
ffffffffc020262c:	bf45                	j	ffffffffc02025dc <unmap_range+0x76>
ffffffffc020262e:	945a                	add	s0,s0,s6
ffffffffc0202630:	01547433          	and	s0,s0,s5
ffffffffc0202634:	d455                	beqz	s0,ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc0202636:	f92469e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc020263a:	b75d                	j	ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc020263c:	100027f3          	csrr	a5,sstatus
ffffffffc0202640:	8b89                	andi	a5,a5,2
ffffffffc0202642:	e799                	bnez	a5,ffffffffc0202650 <unmap_range+0xea>
ffffffffc0202644:	000d3783          	ld	a5,0(s10)
ffffffffc0202648:	4585                	li	a1,1
ffffffffc020264a:	739c                	ld	a5,32(a5)
ffffffffc020264c:	9782                	jalr	a5
ffffffffc020264e:	bfd1                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202650:	e42a                	sd	a0,8(sp)
ffffffffc0202652:	e20fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202656:	000d3783          	ld	a5,0(s10)
ffffffffc020265a:	6522                	ld	a0,8(sp)
ffffffffc020265c:	4585                	li	a1,1
ffffffffc020265e:	739c                	ld	a5,32(a5)
ffffffffc0202660:	9782                	jalr	a5
ffffffffc0202662:	e0afe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202666:	bf75                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202668:	0000a697          	auipc	a3,0xa
ffffffffc020266c:	f1068693          	addi	a3,a3,-240 # ffffffffc020c578 <default_pmm_manager+0x188>
ffffffffc0202670:	00009617          	auipc	a2,0x9
ffffffffc0202674:	29860613          	addi	a2,a2,664 # ffffffffc020b908 <commands+0x210>
ffffffffc0202678:	15a00593          	li	a1,346
ffffffffc020267c:	0000a517          	auipc	a0,0xa
ffffffffc0202680:	ec450513          	addi	a0,a0,-316 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0202684:	e1bfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202688:	0000a697          	auipc	a3,0xa
ffffffffc020268c:	f2068693          	addi	a3,a3,-224 # ffffffffc020c5a8 <default_pmm_manager+0x1b8>
ffffffffc0202690:	00009617          	auipc	a2,0x9
ffffffffc0202694:	27860613          	addi	a2,a2,632 # ffffffffc020b908 <commands+0x210>
ffffffffc0202698:	15b00593          	li	a1,347
ffffffffc020269c:	0000a517          	auipc	a0,0xa
ffffffffc02026a0:	ea450513          	addi	a0,a0,-348 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02026a4:	dfbfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02026a8:	a8dff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02026ac <exit_range>:
ffffffffc02026ac:	7119                	addi	sp,sp,-128
ffffffffc02026ae:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026b2:	fc86                	sd	ra,120(sp)
ffffffffc02026b4:	f8a2                	sd	s0,112(sp)
ffffffffc02026b6:	f4a6                	sd	s1,104(sp)
ffffffffc02026b8:	f0ca                	sd	s2,96(sp)
ffffffffc02026ba:	ecce                	sd	s3,88(sp)
ffffffffc02026bc:	e8d2                	sd	s4,80(sp)
ffffffffc02026be:	e4d6                	sd	s5,72(sp)
ffffffffc02026c0:	e0da                	sd	s6,64(sp)
ffffffffc02026c2:	fc5e                	sd	s7,56(sp)
ffffffffc02026c4:	f862                	sd	s8,48(sp)
ffffffffc02026c6:	f466                	sd	s9,40(sp)
ffffffffc02026c8:	f06a                	sd	s10,32(sp)
ffffffffc02026ca:	ec6e                	sd	s11,24(sp)
ffffffffc02026cc:	17d2                	slli	a5,a5,0x34
ffffffffc02026ce:	20079a63          	bnez	a5,ffffffffc02028e2 <exit_range+0x236>
ffffffffc02026d2:	002007b7          	lui	a5,0x200
ffffffffc02026d6:	24f5e463          	bltu	a1,a5,ffffffffc020291e <exit_range+0x272>
ffffffffc02026da:	8ab2                	mv	s5,a2
ffffffffc02026dc:	24c5f163          	bgeu	a1,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e0:	4785                	li	a5,1
ffffffffc02026e2:	07fe                	slli	a5,a5,0x1f
ffffffffc02026e4:	22c7ed63          	bltu	a5,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e8:	c00009b7          	lui	s3,0xc0000
ffffffffc02026ec:	0135f9b3          	and	s3,a1,s3
ffffffffc02026f0:	ffe00937          	lui	s2,0xffe00
ffffffffc02026f4:	400007b7          	lui	a5,0x40000
ffffffffc02026f8:	5cfd                	li	s9,-1
ffffffffc02026fa:	8c2a                	mv	s8,a0
ffffffffc02026fc:	0125f933          	and	s2,a1,s2
ffffffffc0202700:	99be                	add	s3,s3,a5
ffffffffc0202702:	00094d17          	auipc	s10,0x94
ffffffffc0202706:	19ed0d13          	addi	s10,s10,414 # ffffffffc02968a0 <npage>
ffffffffc020270a:	00ccdc93          	srli	s9,s9,0xc
ffffffffc020270e:	00094717          	auipc	a4,0x94
ffffffffc0202712:	19a70713          	addi	a4,a4,410 # ffffffffc02968a8 <pages>
ffffffffc0202716:	00094d97          	auipc	s11,0x94
ffffffffc020271a:	19ad8d93          	addi	s11,s11,410 # ffffffffc02968b0 <pmm_manager>
ffffffffc020271e:	c0000437          	lui	s0,0xc0000
ffffffffc0202722:	944e                	add	s0,s0,s3
ffffffffc0202724:	8079                	srli	s0,s0,0x1e
ffffffffc0202726:	1ff47413          	andi	s0,s0,511
ffffffffc020272a:	040e                	slli	s0,s0,0x3
ffffffffc020272c:	9462                	add	s0,s0,s8
ffffffffc020272e:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202732:	001a7793          	andi	a5,s4,1
ffffffffc0202736:	eb99                	bnez	a5,ffffffffc020274c <exit_range+0xa0>
ffffffffc0202738:	12098463          	beqz	s3,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc020273c:	400007b7          	lui	a5,0x40000
ffffffffc0202740:	97ce                	add	a5,a5,s3
ffffffffc0202742:	894e                	mv	s2,s3
ffffffffc0202744:	1159fe63          	bgeu	s3,s5,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc0202748:	89be                	mv	s3,a5
ffffffffc020274a:	bfd1                	j	ffffffffc020271e <exit_range+0x72>
ffffffffc020274c:	000d3783          	ld	a5,0(s10)
ffffffffc0202750:	0a0a                	slli	s4,s4,0x2
ffffffffc0202752:	00ca5a13          	srli	s4,s4,0xc
ffffffffc0202756:	1cfa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020275a:	fff80637          	lui	a2,0xfff80
ffffffffc020275e:	9652                	add	a2,a2,s4
ffffffffc0202760:	000806b7          	lui	a3,0x80
ffffffffc0202764:	96b2                	add	a3,a3,a2
ffffffffc0202766:	0196f5b3          	and	a1,a3,s9
ffffffffc020276a:	061a                	slli	a2,a2,0x6
ffffffffc020276c:	06b2                	slli	a3,a3,0xc
ffffffffc020276e:	18f5fa63          	bgeu	a1,a5,ffffffffc0202902 <exit_range+0x256>
ffffffffc0202772:	00094817          	auipc	a6,0x94
ffffffffc0202776:	14680813          	addi	a6,a6,326 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020277a:	00083b03          	ld	s6,0(a6)
ffffffffc020277e:	4b85                	li	s7,1
ffffffffc0202780:	fff80e37          	lui	t3,0xfff80
ffffffffc0202784:	9b36                	add	s6,s6,a3
ffffffffc0202786:	00080337          	lui	t1,0x80
ffffffffc020278a:	6885                	lui	a7,0x1
ffffffffc020278c:	a819                	j	ffffffffc02027a2 <exit_range+0xf6>
ffffffffc020278e:	4b81                	li	s7,0
ffffffffc0202790:	002007b7          	lui	a5,0x200
ffffffffc0202794:	993e                	add	s2,s2,a5
ffffffffc0202796:	08090c63          	beqz	s2,ffffffffc020282e <exit_range+0x182>
ffffffffc020279a:	09397a63          	bgeu	s2,s3,ffffffffc020282e <exit_range+0x182>
ffffffffc020279e:	0f597063          	bgeu	s2,s5,ffffffffc020287e <exit_range+0x1d2>
ffffffffc02027a2:	01595493          	srli	s1,s2,0x15
ffffffffc02027a6:	1ff4f493          	andi	s1,s1,511
ffffffffc02027aa:	048e                	slli	s1,s1,0x3
ffffffffc02027ac:	94da                	add	s1,s1,s6
ffffffffc02027ae:	609c                	ld	a5,0(s1)
ffffffffc02027b0:	0017f693          	andi	a3,a5,1
ffffffffc02027b4:	dee9                	beqz	a3,ffffffffc020278e <exit_range+0xe2>
ffffffffc02027b6:	000d3583          	ld	a1,0(s10)
ffffffffc02027ba:	078a                	slli	a5,a5,0x2
ffffffffc02027bc:	83b1                	srli	a5,a5,0xc
ffffffffc02027be:	14b7fe63          	bgeu	a5,a1,ffffffffc020291a <exit_range+0x26e>
ffffffffc02027c2:	97f2                	add	a5,a5,t3
ffffffffc02027c4:	006786b3          	add	a3,a5,t1
ffffffffc02027c8:	0196feb3          	and	t4,a3,s9
ffffffffc02027cc:	00679513          	slli	a0,a5,0x6
ffffffffc02027d0:	06b2                	slli	a3,a3,0xc
ffffffffc02027d2:	12bef863          	bgeu	t4,a1,ffffffffc0202902 <exit_range+0x256>
ffffffffc02027d6:	00083783          	ld	a5,0(a6)
ffffffffc02027da:	96be                	add	a3,a3,a5
ffffffffc02027dc:	011685b3          	add	a1,a3,a7
ffffffffc02027e0:	629c                	ld	a5,0(a3)
ffffffffc02027e2:	8b85                	andi	a5,a5,1
ffffffffc02027e4:	f7d5                	bnez	a5,ffffffffc0202790 <exit_range+0xe4>
ffffffffc02027e6:	06a1                	addi	a3,a3,8
ffffffffc02027e8:	fed59ce3          	bne	a1,a3,ffffffffc02027e0 <exit_range+0x134>
ffffffffc02027ec:	631c                	ld	a5,0(a4)
ffffffffc02027ee:	953e                	add	a0,a0,a5
ffffffffc02027f0:	100027f3          	csrr	a5,sstatus
ffffffffc02027f4:	8b89                	andi	a5,a5,2
ffffffffc02027f6:	e7d9                	bnez	a5,ffffffffc0202884 <exit_range+0x1d8>
ffffffffc02027f8:	000db783          	ld	a5,0(s11)
ffffffffc02027fc:	4585                	li	a1,1
ffffffffc02027fe:	e032                	sd	a2,0(sp)
ffffffffc0202800:	739c                	ld	a5,32(a5)
ffffffffc0202802:	9782                	jalr	a5
ffffffffc0202804:	6602                	ld	a2,0(sp)
ffffffffc0202806:	00094817          	auipc	a6,0x94
ffffffffc020280a:	0b280813          	addi	a6,a6,178 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020280e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202812:	00080337          	lui	t1,0x80
ffffffffc0202816:	6885                	lui	a7,0x1
ffffffffc0202818:	00094717          	auipc	a4,0x94
ffffffffc020281c:	09070713          	addi	a4,a4,144 # ffffffffc02968a8 <pages>
ffffffffc0202820:	0004b023          	sd	zero,0(s1)
ffffffffc0202824:	002007b7          	lui	a5,0x200
ffffffffc0202828:	993e                	add	s2,s2,a5
ffffffffc020282a:	f60918e3          	bnez	s2,ffffffffc020279a <exit_range+0xee>
ffffffffc020282e:	f00b85e3          	beqz	s7,ffffffffc0202738 <exit_range+0x8c>
ffffffffc0202832:	000d3783          	ld	a5,0(s10)
ffffffffc0202836:	0efa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020283a:	6308                	ld	a0,0(a4)
ffffffffc020283c:	9532                	add	a0,a0,a2
ffffffffc020283e:	100027f3          	csrr	a5,sstatus
ffffffffc0202842:	8b89                	andi	a5,a5,2
ffffffffc0202844:	efad                	bnez	a5,ffffffffc02028be <exit_range+0x212>
ffffffffc0202846:	000db783          	ld	a5,0(s11)
ffffffffc020284a:	4585                	li	a1,1
ffffffffc020284c:	739c                	ld	a5,32(a5)
ffffffffc020284e:	9782                	jalr	a5
ffffffffc0202850:	00094717          	auipc	a4,0x94
ffffffffc0202854:	05870713          	addi	a4,a4,88 # ffffffffc02968a8 <pages>
ffffffffc0202858:	00043023          	sd	zero,0(s0)
ffffffffc020285c:	ee0990e3          	bnez	s3,ffffffffc020273c <exit_range+0x90>
ffffffffc0202860:	70e6                	ld	ra,120(sp)
ffffffffc0202862:	7446                	ld	s0,112(sp)
ffffffffc0202864:	74a6                	ld	s1,104(sp)
ffffffffc0202866:	7906                	ld	s2,96(sp)
ffffffffc0202868:	69e6                	ld	s3,88(sp)
ffffffffc020286a:	6a46                	ld	s4,80(sp)
ffffffffc020286c:	6aa6                	ld	s5,72(sp)
ffffffffc020286e:	6b06                	ld	s6,64(sp)
ffffffffc0202870:	7be2                	ld	s7,56(sp)
ffffffffc0202872:	7c42                	ld	s8,48(sp)
ffffffffc0202874:	7ca2                	ld	s9,40(sp)
ffffffffc0202876:	7d02                	ld	s10,32(sp)
ffffffffc0202878:	6de2                	ld	s11,24(sp)
ffffffffc020287a:	6109                	addi	sp,sp,128
ffffffffc020287c:	8082                	ret
ffffffffc020287e:	ea0b8fe3          	beqz	s7,ffffffffc020273c <exit_range+0x90>
ffffffffc0202882:	bf45                	j	ffffffffc0202832 <exit_range+0x186>
ffffffffc0202884:	e032                	sd	a2,0(sp)
ffffffffc0202886:	e42a                	sd	a0,8(sp)
ffffffffc0202888:	beafe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020288c:	000db783          	ld	a5,0(s11)
ffffffffc0202890:	6522                	ld	a0,8(sp)
ffffffffc0202892:	4585                	li	a1,1
ffffffffc0202894:	739c                	ld	a5,32(a5)
ffffffffc0202896:	9782                	jalr	a5
ffffffffc0202898:	bd4fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020289c:	6602                	ld	a2,0(sp)
ffffffffc020289e:	00094717          	auipc	a4,0x94
ffffffffc02028a2:	00a70713          	addi	a4,a4,10 # ffffffffc02968a8 <pages>
ffffffffc02028a6:	6885                	lui	a7,0x1
ffffffffc02028a8:	00080337          	lui	t1,0x80
ffffffffc02028ac:	fff80e37          	lui	t3,0xfff80
ffffffffc02028b0:	00094817          	auipc	a6,0x94
ffffffffc02028b4:	00880813          	addi	a6,a6,8 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02028b8:	0004b023          	sd	zero,0(s1)
ffffffffc02028bc:	b7a5                	j	ffffffffc0202824 <exit_range+0x178>
ffffffffc02028be:	e02a                	sd	a0,0(sp)
ffffffffc02028c0:	bb2fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02028c4:	000db783          	ld	a5,0(s11)
ffffffffc02028c8:	6502                	ld	a0,0(sp)
ffffffffc02028ca:	4585                	li	a1,1
ffffffffc02028cc:	739c                	ld	a5,32(a5)
ffffffffc02028ce:	9782                	jalr	a5
ffffffffc02028d0:	b9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02028d4:	00094717          	auipc	a4,0x94
ffffffffc02028d8:	fd470713          	addi	a4,a4,-44 # ffffffffc02968a8 <pages>
ffffffffc02028dc:	00043023          	sd	zero,0(s0)
ffffffffc02028e0:	bfb5                	j	ffffffffc020285c <exit_range+0x1b0>
ffffffffc02028e2:	0000a697          	auipc	a3,0xa
ffffffffc02028e6:	c9668693          	addi	a3,a3,-874 # ffffffffc020c578 <default_pmm_manager+0x188>
ffffffffc02028ea:	00009617          	auipc	a2,0x9
ffffffffc02028ee:	01e60613          	addi	a2,a2,30 # ffffffffc020b908 <commands+0x210>
ffffffffc02028f2:	16f00593          	li	a1,367
ffffffffc02028f6:	0000a517          	auipc	a0,0xa
ffffffffc02028fa:	c4a50513          	addi	a0,a0,-950 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02028fe:	ba1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202902:	0000a617          	auipc	a2,0xa
ffffffffc0202906:	b2660613          	addi	a2,a2,-1242 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc020290a:	07100593          	li	a1,113
ffffffffc020290e:	0000a517          	auipc	a0,0xa
ffffffffc0202912:	b4250513          	addi	a0,a0,-1214 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0202916:	b89fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020291a:	81bff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc020291e:	0000a697          	auipc	a3,0xa
ffffffffc0202922:	c8a68693          	addi	a3,a3,-886 # ffffffffc020c5a8 <default_pmm_manager+0x1b8>
ffffffffc0202926:	00009617          	auipc	a2,0x9
ffffffffc020292a:	fe260613          	addi	a2,a2,-30 # ffffffffc020b908 <commands+0x210>
ffffffffc020292e:	17000593          	li	a1,368
ffffffffc0202932:	0000a517          	auipc	a0,0xa
ffffffffc0202936:	c0e50513          	addi	a0,a0,-1010 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020293a:	b65fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020293e <page_remove>:
ffffffffc020293e:	7179                	addi	sp,sp,-48
ffffffffc0202940:	4601                	li	a2,0
ffffffffc0202942:	ec26                	sd	s1,24(sp)
ffffffffc0202944:	f406                	sd	ra,40(sp)
ffffffffc0202946:	f022                	sd	s0,32(sp)
ffffffffc0202948:	84ae                	mv	s1,a1
ffffffffc020294a:	8dbff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020294e:	c511                	beqz	a0,ffffffffc020295a <page_remove+0x1c>
ffffffffc0202950:	611c                	ld	a5,0(a0)
ffffffffc0202952:	842a                	mv	s0,a0
ffffffffc0202954:	0017f713          	andi	a4,a5,1
ffffffffc0202958:	e711                	bnez	a4,ffffffffc0202964 <page_remove+0x26>
ffffffffc020295a:	70a2                	ld	ra,40(sp)
ffffffffc020295c:	7402                	ld	s0,32(sp)
ffffffffc020295e:	64e2                	ld	s1,24(sp)
ffffffffc0202960:	6145                	addi	sp,sp,48
ffffffffc0202962:	8082                	ret
ffffffffc0202964:	078a                	slli	a5,a5,0x2
ffffffffc0202966:	83b1                	srli	a5,a5,0xc
ffffffffc0202968:	00094717          	auipc	a4,0x94
ffffffffc020296c:	f3873703          	ld	a4,-200(a4) # ffffffffc02968a0 <npage>
ffffffffc0202970:	06e7f363          	bgeu	a5,a4,ffffffffc02029d6 <page_remove+0x98>
ffffffffc0202974:	fff80537          	lui	a0,0xfff80
ffffffffc0202978:	97aa                	add	a5,a5,a0
ffffffffc020297a:	079a                	slli	a5,a5,0x6
ffffffffc020297c:	00094517          	auipc	a0,0x94
ffffffffc0202980:	f2c53503          	ld	a0,-212(a0) # ffffffffc02968a8 <pages>
ffffffffc0202984:	953e                	add	a0,a0,a5
ffffffffc0202986:	411c                	lw	a5,0(a0)
ffffffffc0202988:	fff7871b          	addiw	a4,a5,-1
ffffffffc020298c:	c118                	sw	a4,0(a0)
ffffffffc020298e:	cb11                	beqz	a4,ffffffffc02029a2 <page_remove+0x64>
ffffffffc0202990:	00043023          	sd	zero,0(s0)
ffffffffc0202994:	12048073          	sfence.vma	s1
ffffffffc0202998:	70a2                	ld	ra,40(sp)
ffffffffc020299a:	7402                	ld	s0,32(sp)
ffffffffc020299c:	64e2                	ld	s1,24(sp)
ffffffffc020299e:	6145                	addi	sp,sp,48
ffffffffc02029a0:	8082                	ret
ffffffffc02029a2:	100027f3          	csrr	a5,sstatus
ffffffffc02029a6:	8b89                	andi	a5,a5,2
ffffffffc02029a8:	eb89                	bnez	a5,ffffffffc02029ba <page_remove+0x7c>
ffffffffc02029aa:	00094797          	auipc	a5,0x94
ffffffffc02029ae:	f067b783          	ld	a5,-250(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029b2:	739c                	ld	a5,32(a5)
ffffffffc02029b4:	4585                	li	a1,1
ffffffffc02029b6:	9782                	jalr	a5
ffffffffc02029b8:	bfe1                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029ba:	e42a                	sd	a0,8(sp)
ffffffffc02029bc:	ab6fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02029c0:	00094797          	auipc	a5,0x94
ffffffffc02029c4:	ef07b783          	ld	a5,-272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029c8:	739c                	ld	a5,32(a5)
ffffffffc02029ca:	6522                	ld	a0,8(sp)
ffffffffc02029cc:	4585                	li	a1,1
ffffffffc02029ce:	9782                	jalr	a5
ffffffffc02029d0:	a9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02029d4:	bf75                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029d6:	f5eff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02029da <page_insert>:
ffffffffc02029da:	7139                	addi	sp,sp,-64
ffffffffc02029dc:	e852                	sd	s4,16(sp)
ffffffffc02029de:	8a32                	mv	s4,a2
ffffffffc02029e0:	f822                	sd	s0,48(sp)
ffffffffc02029e2:	4605                	li	a2,1
ffffffffc02029e4:	842e                	mv	s0,a1
ffffffffc02029e6:	85d2                	mv	a1,s4
ffffffffc02029e8:	f426                	sd	s1,40(sp)
ffffffffc02029ea:	fc06                	sd	ra,56(sp)
ffffffffc02029ec:	f04a                	sd	s2,32(sp)
ffffffffc02029ee:	ec4e                	sd	s3,24(sp)
ffffffffc02029f0:	e456                	sd	s5,8(sp)
ffffffffc02029f2:	84b6                	mv	s1,a3
ffffffffc02029f4:	831ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02029f8:	c961                	beqz	a0,ffffffffc0202ac8 <page_insert+0xee>
ffffffffc02029fa:	4014                	lw	a3,0(s0)
ffffffffc02029fc:	611c                	ld	a5,0(a0)
ffffffffc02029fe:	89aa                	mv	s3,a0
ffffffffc0202a00:	0016871b          	addiw	a4,a3,1
ffffffffc0202a04:	c018                	sw	a4,0(s0)
ffffffffc0202a06:	0017f713          	andi	a4,a5,1
ffffffffc0202a0a:	ef05                	bnez	a4,ffffffffc0202a42 <page_insert+0x68>
ffffffffc0202a0c:	00094717          	auipc	a4,0x94
ffffffffc0202a10:	e9c73703          	ld	a4,-356(a4) # ffffffffc02968a8 <pages>
ffffffffc0202a14:	8c19                	sub	s0,s0,a4
ffffffffc0202a16:	000807b7          	lui	a5,0x80
ffffffffc0202a1a:	8419                	srai	s0,s0,0x6
ffffffffc0202a1c:	943e                	add	s0,s0,a5
ffffffffc0202a1e:	042a                	slli	s0,s0,0xa
ffffffffc0202a20:	8cc1                	or	s1,s1,s0
ffffffffc0202a22:	0014e493          	ori	s1,s1,1
ffffffffc0202a26:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202a2a:	120a0073          	sfence.vma	s4
ffffffffc0202a2e:	4501                	li	a0,0
ffffffffc0202a30:	70e2                	ld	ra,56(sp)
ffffffffc0202a32:	7442                	ld	s0,48(sp)
ffffffffc0202a34:	74a2                	ld	s1,40(sp)
ffffffffc0202a36:	7902                	ld	s2,32(sp)
ffffffffc0202a38:	69e2                	ld	s3,24(sp)
ffffffffc0202a3a:	6a42                	ld	s4,16(sp)
ffffffffc0202a3c:	6aa2                	ld	s5,8(sp)
ffffffffc0202a3e:	6121                	addi	sp,sp,64
ffffffffc0202a40:	8082                	ret
ffffffffc0202a42:	078a                	slli	a5,a5,0x2
ffffffffc0202a44:	83b1                	srli	a5,a5,0xc
ffffffffc0202a46:	00094717          	auipc	a4,0x94
ffffffffc0202a4a:	e5a73703          	ld	a4,-422(a4) # ffffffffc02968a0 <npage>
ffffffffc0202a4e:	06e7ff63          	bgeu	a5,a4,ffffffffc0202acc <page_insert+0xf2>
ffffffffc0202a52:	00094a97          	auipc	s5,0x94
ffffffffc0202a56:	e56a8a93          	addi	s5,s5,-426 # ffffffffc02968a8 <pages>
ffffffffc0202a5a:	000ab703          	ld	a4,0(s5)
ffffffffc0202a5e:	fff80937          	lui	s2,0xfff80
ffffffffc0202a62:	993e                	add	s2,s2,a5
ffffffffc0202a64:	091a                	slli	s2,s2,0x6
ffffffffc0202a66:	993a                	add	s2,s2,a4
ffffffffc0202a68:	01240c63          	beq	s0,s2,ffffffffc0202a80 <page_insert+0xa6>
ffffffffc0202a6c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202a70:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202a74:	00d92023          	sw	a3,0(s2)
ffffffffc0202a78:	c691                	beqz	a3,ffffffffc0202a84 <page_insert+0xaa>
ffffffffc0202a7a:	120a0073          	sfence.vma	s4
ffffffffc0202a7e:	bf59                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a80:	c014                	sw	a3,0(s0)
ffffffffc0202a82:	bf49                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a84:	100027f3          	csrr	a5,sstatus
ffffffffc0202a88:	8b89                	andi	a5,a5,2
ffffffffc0202a8a:	ef91                	bnez	a5,ffffffffc0202aa6 <page_insert+0xcc>
ffffffffc0202a8c:	00094797          	auipc	a5,0x94
ffffffffc0202a90:	e247b783          	ld	a5,-476(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a94:	739c                	ld	a5,32(a5)
ffffffffc0202a96:	4585                	li	a1,1
ffffffffc0202a98:	854a                	mv	a0,s2
ffffffffc0202a9a:	9782                	jalr	a5
ffffffffc0202a9c:	000ab703          	ld	a4,0(s5)
ffffffffc0202aa0:	120a0073          	sfence.vma	s4
ffffffffc0202aa4:	bf85                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202aa6:	9ccfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202aaa:	00094797          	auipc	a5,0x94
ffffffffc0202aae:	e067b783          	ld	a5,-506(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ab2:	739c                	ld	a5,32(a5)
ffffffffc0202ab4:	4585                	li	a1,1
ffffffffc0202ab6:	854a                	mv	a0,s2
ffffffffc0202ab8:	9782                	jalr	a5
ffffffffc0202aba:	9b2fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202abe:	000ab703          	ld	a4,0(s5)
ffffffffc0202ac2:	120a0073          	sfence.vma	s4
ffffffffc0202ac6:	b7b9                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202ac8:	5571                	li	a0,-4
ffffffffc0202aca:	b79d                	j	ffffffffc0202a30 <page_insert+0x56>
ffffffffc0202acc:	e68ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202ad0 <pmm_init>:
ffffffffc0202ad0:	0000a797          	auipc	a5,0xa
ffffffffc0202ad4:	92078793          	addi	a5,a5,-1760 # ffffffffc020c3f0 <default_pmm_manager>
ffffffffc0202ad8:	638c                	ld	a1,0(a5)
ffffffffc0202ada:	7159                	addi	sp,sp,-112
ffffffffc0202adc:	f85a                	sd	s6,48(sp)
ffffffffc0202ade:	0000a517          	auipc	a0,0xa
ffffffffc0202ae2:	ae250513          	addi	a0,a0,-1310 # ffffffffc020c5c0 <default_pmm_manager+0x1d0>
ffffffffc0202ae6:	00094b17          	auipc	s6,0x94
ffffffffc0202aea:	dcab0b13          	addi	s6,s6,-566 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202aee:	f486                	sd	ra,104(sp)
ffffffffc0202af0:	e8ca                	sd	s2,80(sp)
ffffffffc0202af2:	e4ce                	sd	s3,72(sp)
ffffffffc0202af4:	f0a2                	sd	s0,96(sp)
ffffffffc0202af6:	eca6                	sd	s1,88(sp)
ffffffffc0202af8:	e0d2                	sd	s4,64(sp)
ffffffffc0202afa:	fc56                	sd	s5,56(sp)
ffffffffc0202afc:	f45e                	sd	s7,40(sp)
ffffffffc0202afe:	f062                	sd	s8,32(sp)
ffffffffc0202b00:	ec66                	sd	s9,24(sp)
ffffffffc0202b02:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b06:	ea0fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0e:	00094997          	auipc	s3,0x94
ffffffffc0202b12:	daa98993          	addi	s3,s3,-598 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202b16:	679c                	ld	a5,8(a5)
ffffffffc0202b18:	9782                	jalr	a5
ffffffffc0202b1a:	57f5                	li	a5,-3
ffffffffc0202b1c:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b1e:	00f9b023          	sd	a5,0(s3)
ffffffffc0202b22:	f27fd0ef          	jal	ra,ffffffffc0200a48 <get_memory_base>
ffffffffc0202b26:	892a                	mv	s2,a0
ffffffffc0202b28:	f2bfd0ef          	jal	ra,ffffffffc0200a52 <get_memory_size>
ffffffffc0202b2c:	280502e3          	beqz	a0,ffffffffc02035b0 <pmm_init+0xae0>
ffffffffc0202b30:	84aa                	mv	s1,a0
ffffffffc0202b32:	0000a517          	auipc	a0,0xa
ffffffffc0202b36:	ac650513          	addi	a0,a0,-1338 # ffffffffc020c5f8 <default_pmm_manager+0x208>
ffffffffc0202b3a:	e6cfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b3e:	00990433          	add	s0,s2,s1
ffffffffc0202b42:	fff40693          	addi	a3,s0,-1
ffffffffc0202b46:	864a                	mv	a2,s2
ffffffffc0202b48:	85a6                	mv	a1,s1
ffffffffc0202b4a:	0000a517          	auipc	a0,0xa
ffffffffc0202b4e:	ac650513          	addi	a0,a0,-1338 # ffffffffc020c610 <default_pmm_manager+0x220>
ffffffffc0202b52:	e54fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b56:	c8000737          	lui	a4,0xc8000
ffffffffc0202b5a:	87a2                	mv	a5,s0
ffffffffc0202b5c:	5e876e63          	bltu	a4,s0,ffffffffc0203158 <pmm_init+0x688>
ffffffffc0202b60:	757d                	lui	a0,0xfffff
ffffffffc0202b62:	00095617          	auipc	a2,0x95
ffffffffc0202b66:	dad60613          	addi	a2,a2,-595 # ffffffffc029790f <end+0xfff>
ffffffffc0202b6a:	8e69                	and	a2,a2,a0
ffffffffc0202b6c:	00094497          	auipc	s1,0x94
ffffffffc0202b70:	d3448493          	addi	s1,s1,-716 # ffffffffc02968a0 <npage>
ffffffffc0202b74:	00c7d513          	srli	a0,a5,0xc
ffffffffc0202b78:	00094b97          	auipc	s7,0x94
ffffffffc0202b7c:	d30b8b93          	addi	s7,s7,-720 # ffffffffc02968a8 <pages>
ffffffffc0202b80:	e088                	sd	a0,0(s1)
ffffffffc0202b82:	00cbb023          	sd	a2,0(s7)
ffffffffc0202b86:	000807b7          	lui	a5,0x80
ffffffffc0202b8a:	86b2                	mv	a3,a2
ffffffffc0202b8c:	02f50863          	beq	a0,a5,ffffffffc0202bbc <pmm_init+0xec>
ffffffffc0202b90:	4781                	li	a5,0
ffffffffc0202b92:	4585                	li	a1,1
ffffffffc0202b94:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b98:	00679513          	slli	a0,a5,0x6
ffffffffc0202b9c:	9532                	add	a0,a0,a2
ffffffffc0202b9e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0202ba2:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0202ba6:	6088                	ld	a0,0(s1)
ffffffffc0202ba8:	0785                	addi	a5,a5,1
ffffffffc0202baa:	000bb603          	ld	a2,0(s7)
ffffffffc0202bae:	00d50733          	add	a4,a0,a3
ffffffffc0202bb2:	fee7e3e3          	bltu	a5,a4,ffffffffc0202b98 <pmm_init+0xc8>
ffffffffc0202bb6:	071a                	slli	a4,a4,0x6
ffffffffc0202bb8:	00e606b3          	add	a3,a2,a4
ffffffffc0202bbc:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bc0:	3af6eae3          	bltu	a3,a5,ffffffffc0203774 <pmm_init+0xca4>
ffffffffc0202bc4:	0009b583          	ld	a1,0(s3)
ffffffffc0202bc8:	77fd                	lui	a5,0xfffff
ffffffffc0202bca:	8c7d                	and	s0,s0,a5
ffffffffc0202bcc:	8e8d                	sub	a3,a3,a1
ffffffffc0202bce:	5e86e363          	bltu	a3,s0,ffffffffc02031b4 <pmm_init+0x6e4>
ffffffffc0202bd2:	0000a517          	auipc	a0,0xa
ffffffffc0202bd6:	a6650513          	addi	a0,a0,-1434 # ffffffffc020c638 <default_pmm_manager+0x248>
ffffffffc0202bda:	dccfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bde:	000b3783          	ld	a5,0(s6)
ffffffffc0202be2:	7b9c                	ld	a5,48(a5)
ffffffffc0202be4:	9782                	jalr	a5
ffffffffc0202be6:	0000a517          	auipc	a0,0xa
ffffffffc0202bea:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020c650 <default_pmm_manager+0x260>
ffffffffc0202bee:	db8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bf2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bf6:	8b89                	andi	a5,a5,2
ffffffffc0202bf8:	5a079363          	bnez	a5,ffffffffc020319e <pmm_init+0x6ce>
ffffffffc0202bfc:	000b3783          	ld	a5,0(s6)
ffffffffc0202c00:	4505                	li	a0,1
ffffffffc0202c02:	6f9c                	ld	a5,24(a5)
ffffffffc0202c04:	9782                	jalr	a5
ffffffffc0202c06:	842a                	mv	s0,a0
ffffffffc0202c08:	180408e3          	beqz	s0,ffffffffc0203598 <pmm_init+0xac8>
ffffffffc0202c0c:	000bb683          	ld	a3,0(s7)
ffffffffc0202c10:	5a7d                	li	s4,-1
ffffffffc0202c12:	6098                	ld	a4,0(s1)
ffffffffc0202c14:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c18:	8699                	srai	a3,a3,0x6
ffffffffc0202c1a:	00080437          	lui	s0,0x80
ffffffffc0202c1e:	96a2                	add	a3,a3,s0
ffffffffc0202c20:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202c24:	8ff5                	and	a5,a5,a3
ffffffffc0202c26:	06b2                	slli	a3,a3,0xc
ffffffffc0202c28:	30e7fde3          	bgeu	a5,a4,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202c2c:	0009b403          	ld	s0,0(s3)
ffffffffc0202c30:	6605                	lui	a2,0x1
ffffffffc0202c32:	4581                	li	a1,0
ffffffffc0202c34:	9436                	add	s0,s0,a3
ffffffffc0202c36:	8522                	mv	a0,s0
ffffffffc0202c38:	7ec080ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0202c3c:	0009b683          	ld	a3,0(s3)
ffffffffc0202c40:	77fd                	lui	a5,0xfffff
ffffffffc0202c42:	0000a917          	auipc	s2,0xa
ffffffffc0202c46:	84b90913          	addi	s2,s2,-1973 # ffffffffc020c48d <default_pmm_manager+0x9d>
ffffffffc0202c4a:	00f97933          	and	s2,s2,a5
ffffffffc0202c4e:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202c52:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202c56:	964a                	add	a2,a2,s2
ffffffffc0202c58:	4729                	li	a4,10
ffffffffc0202c5a:	40da86b3          	sub	a3,s5,a3
ffffffffc0202c5e:	c02005b7          	lui	a1,0xc0200
ffffffffc0202c62:	8522                	mv	a0,s0
ffffffffc0202c64:	fe8ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c68:	c8000637          	lui	a2,0xc8000
ffffffffc0202c6c:	41260633          	sub	a2,a2,s2
ffffffffc0202c70:	3f596ce3          	bltu	s2,s5,ffffffffc0203868 <pmm_init+0xd98>
ffffffffc0202c74:	0009b683          	ld	a3,0(s3)
ffffffffc0202c78:	85ca                	mv	a1,s2
ffffffffc0202c7a:	4719                	li	a4,6
ffffffffc0202c7c:	40d906b3          	sub	a3,s2,a3
ffffffffc0202c80:	8522                	mv	a0,s0
ffffffffc0202c82:	00094917          	auipc	s2,0x94
ffffffffc0202c86:	c1690913          	addi	s2,s2,-1002 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0202c8a:	fc2ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c8e:	00893023          	sd	s0,0(s2)
ffffffffc0202c92:	2d5464e3          	bltu	s0,s5,ffffffffc020375a <pmm_init+0xc8a>
ffffffffc0202c96:	0009b783          	ld	a5,0(s3)
ffffffffc0202c9a:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202c9c:	8c1d                	sub	s0,s0,a5
ffffffffc0202c9e:	00c45793          	srli	a5,s0,0xc
ffffffffc0202ca2:	00094717          	auipc	a4,0x94
ffffffffc0202ca6:	be873723          	sd	s0,-1042(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0202caa:	0147ea33          	or	s4,a5,s4
ffffffffc0202cae:	180a1073          	csrw	satp,s4
ffffffffc0202cb2:	12000073          	sfence.vma
ffffffffc0202cb6:	0000a517          	auipc	a0,0xa
ffffffffc0202cba:	9da50513          	addi	a0,a0,-1574 # ffffffffc020c690 <default_pmm_manager+0x2a0>
ffffffffc0202cbe:	ce8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202cc2:	0000e717          	auipc	a4,0xe
ffffffffc0202cc6:	33e70713          	addi	a4,a4,830 # ffffffffc0211000 <bootstack>
ffffffffc0202cca:	0000e797          	auipc	a5,0xe
ffffffffc0202cce:	33678793          	addi	a5,a5,822 # ffffffffc0211000 <bootstack>
ffffffffc0202cd2:	5cf70d63          	beq	a4,a5,ffffffffc02032ac <pmm_init+0x7dc>
ffffffffc0202cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202cda:	8b89                	andi	a5,a5,2
ffffffffc0202cdc:	4a079763          	bnez	a5,ffffffffc020318a <pmm_init+0x6ba>
ffffffffc0202ce0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce4:	779c                	ld	a5,40(a5)
ffffffffc0202ce6:	9782                	jalr	a5
ffffffffc0202ce8:	842a                	mv	s0,a0
ffffffffc0202cea:	6098                	ld	a4,0(s1)
ffffffffc0202cec:	c80007b7          	lui	a5,0xc8000
ffffffffc0202cf0:	83b1                	srli	a5,a5,0xc
ffffffffc0202cf2:	08e7e3e3          	bltu	a5,a4,ffffffffc0203578 <pmm_init+0xaa8>
ffffffffc0202cf6:	00093503          	ld	a0,0(s2)
ffffffffc0202cfa:	04050fe3          	beqz	a0,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202cfe:	03451793          	slli	a5,a0,0x34
ffffffffc0202d02:	04079be3          	bnez	a5,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202d06:	4601                	li	a2,0
ffffffffc0202d08:	4581                	li	a1,0
ffffffffc0202d0a:	809ff0ef          	jal	ra,ffffffffc0202512 <get_page>
ffffffffc0202d0e:	2e0511e3          	bnez	a0,ffffffffc02037f0 <pmm_init+0xd20>
ffffffffc0202d12:	100027f3          	csrr	a5,sstatus
ffffffffc0202d16:	8b89                	andi	a5,a5,2
ffffffffc0202d18:	44079e63          	bnez	a5,ffffffffc0203174 <pmm_init+0x6a4>
ffffffffc0202d1c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d20:	4505                	li	a0,1
ffffffffc0202d22:	6f9c                	ld	a5,24(a5)
ffffffffc0202d24:	9782                	jalr	a5
ffffffffc0202d26:	8a2a                	mv	s4,a0
ffffffffc0202d28:	00093503          	ld	a0,0(s2)
ffffffffc0202d2c:	4681                	li	a3,0
ffffffffc0202d2e:	4601                	li	a2,0
ffffffffc0202d30:	85d2                	mv	a1,s4
ffffffffc0202d32:	ca9ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202d36:	26051be3          	bnez	a0,ffffffffc02037ac <pmm_init+0xcdc>
ffffffffc0202d3a:	00093503          	ld	a0,0(s2)
ffffffffc0202d3e:	4601                	li	a2,0
ffffffffc0202d40:	4581                	li	a1,0
ffffffffc0202d42:	ce2ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202d46:	280505e3          	beqz	a0,ffffffffc02037d0 <pmm_init+0xd00>
ffffffffc0202d4a:	611c                	ld	a5,0(a0)
ffffffffc0202d4c:	0017f713          	andi	a4,a5,1
ffffffffc0202d50:	26070ee3          	beqz	a4,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202d54:	6098                	ld	a4,0(s1)
ffffffffc0202d56:	078a                	slli	a5,a5,0x2
ffffffffc0202d58:	83b1                	srli	a5,a5,0xc
ffffffffc0202d5a:	62e7f363          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202d5e:	000bb683          	ld	a3,0(s7)
ffffffffc0202d62:	fff80637          	lui	a2,0xfff80
ffffffffc0202d66:	97b2                	add	a5,a5,a2
ffffffffc0202d68:	079a                	slli	a5,a5,0x6
ffffffffc0202d6a:	97b6                	add	a5,a5,a3
ffffffffc0202d6c:	2afa12e3          	bne	s4,a5,ffffffffc0203810 <pmm_init+0xd40>
ffffffffc0202d70:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202d74:	4785                	li	a5,1
ffffffffc0202d76:	2cf699e3          	bne	a3,a5,ffffffffc0203848 <pmm_init+0xd78>
ffffffffc0202d7a:	00093503          	ld	a0,0(s2)
ffffffffc0202d7e:	77fd                	lui	a5,0xfffff
ffffffffc0202d80:	6114                	ld	a3,0(a0)
ffffffffc0202d82:	068a                	slli	a3,a3,0x2
ffffffffc0202d84:	8efd                	and	a3,a3,a5
ffffffffc0202d86:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202d8a:	2ae673e3          	bgeu	a2,a4,ffffffffc0203830 <pmm_init+0xd60>
ffffffffc0202d8e:	0009bc03          	ld	s8,0(s3)
ffffffffc0202d92:	96e2                	add	a3,a3,s8
ffffffffc0202d94:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202d98:	0a8a                	slli	s5,s5,0x2
ffffffffc0202d9a:	00fafab3          	and	s5,s5,a5
ffffffffc0202d9e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202da2:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203608 <pmm_init+0xb38>
ffffffffc0202da6:	4601                	li	a2,0
ffffffffc0202da8:	6585                	lui	a1,0x1
ffffffffc0202daa:	9ae2                	add	s5,s5,s8
ffffffffc0202dac:	c78ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202db0:	0aa1                	addi	s5,s5,8
ffffffffc0202db2:	03551be3          	bne	a0,s5,ffffffffc02035e8 <pmm_init+0xb18>
ffffffffc0202db6:	100027f3          	csrr	a5,sstatus
ffffffffc0202dba:	8b89                	andi	a5,a5,2
ffffffffc0202dbc:	3a079163          	bnez	a5,ffffffffc020315e <pmm_init+0x68e>
ffffffffc0202dc0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc4:	4505                	li	a0,1
ffffffffc0202dc6:	6f9c                	ld	a5,24(a5)
ffffffffc0202dc8:	9782                	jalr	a5
ffffffffc0202dca:	8c2a                	mv	s8,a0
ffffffffc0202dcc:	00093503          	ld	a0,0(s2)
ffffffffc0202dd0:	46d1                	li	a3,20
ffffffffc0202dd2:	6605                	lui	a2,0x1
ffffffffc0202dd4:	85e2                	mv	a1,s8
ffffffffc0202dd6:	c05ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202dda:	1a0519e3          	bnez	a0,ffffffffc020378c <pmm_init+0xcbc>
ffffffffc0202dde:	00093503          	ld	a0,0(s2)
ffffffffc0202de2:	4601                	li	a2,0
ffffffffc0202de4:	6585                	lui	a1,0x1
ffffffffc0202de6:	c3eff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202dea:	10050ce3          	beqz	a0,ffffffffc0203702 <pmm_init+0xc32>
ffffffffc0202dee:	611c                	ld	a5,0(a0)
ffffffffc0202df0:	0107f713          	andi	a4,a5,16
ffffffffc0202df4:	0e0707e3          	beqz	a4,ffffffffc02036e2 <pmm_init+0xc12>
ffffffffc0202df8:	8b91                	andi	a5,a5,4
ffffffffc0202dfa:	0c0784e3          	beqz	a5,ffffffffc02036c2 <pmm_init+0xbf2>
ffffffffc0202dfe:	00093503          	ld	a0,0(s2)
ffffffffc0202e02:	611c                	ld	a5,0(a0)
ffffffffc0202e04:	8bc1                	andi	a5,a5,16
ffffffffc0202e06:	08078ee3          	beqz	a5,ffffffffc02036a2 <pmm_init+0xbd2>
ffffffffc0202e0a:	000c2703          	lw	a4,0(s8)
ffffffffc0202e0e:	4785                	li	a5,1
ffffffffc0202e10:	06f719e3          	bne	a4,a5,ffffffffc0203682 <pmm_init+0xbb2>
ffffffffc0202e14:	4681                	li	a3,0
ffffffffc0202e16:	6605                	lui	a2,0x1
ffffffffc0202e18:	85d2                	mv	a1,s4
ffffffffc0202e1a:	bc1ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202e1e:	040512e3          	bnez	a0,ffffffffc0203662 <pmm_init+0xb92>
ffffffffc0202e22:	000a2703          	lw	a4,0(s4)
ffffffffc0202e26:	4789                	li	a5,2
ffffffffc0202e28:	00f71de3          	bne	a4,a5,ffffffffc0203642 <pmm_init+0xb72>
ffffffffc0202e2c:	000c2783          	lw	a5,0(s8)
ffffffffc0202e30:	7e079963          	bnez	a5,ffffffffc0203622 <pmm_init+0xb52>
ffffffffc0202e34:	00093503          	ld	a0,0(s2)
ffffffffc0202e38:	4601                	li	a2,0
ffffffffc0202e3a:	6585                	lui	a1,0x1
ffffffffc0202e3c:	be8ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202e40:	54050263          	beqz	a0,ffffffffc0203384 <pmm_init+0x8b4>
ffffffffc0202e44:	6118                	ld	a4,0(a0)
ffffffffc0202e46:	00177793          	andi	a5,a4,1
ffffffffc0202e4a:	180781e3          	beqz	a5,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202e4e:	6094                	ld	a3,0(s1)
ffffffffc0202e50:	00271793          	slli	a5,a4,0x2
ffffffffc0202e54:	83b1                	srli	a5,a5,0xc
ffffffffc0202e56:	52d7f563          	bgeu	a5,a3,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202e5a:	000bb683          	ld	a3,0(s7)
ffffffffc0202e5e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202e62:	97d6                	add	a5,a5,s5
ffffffffc0202e64:	079a                	slli	a5,a5,0x6
ffffffffc0202e66:	97b6                	add	a5,a5,a3
ffffffffc0202e68:	58fa1e63          	bne	s4,a5,ffffffffc0203404 <pmm_init+0x934>
ffffffffc0202e6c:	8b41                	andi	a4,a4,16
ffffffffc0202e6e:	56071b63          	bnez	a4,ffffffffc02033e4 <pmm_init+0x914>
ffffffffc0202e72:	00093503          	ld	a0,0(s2)
ffffffffc0202e76:	4581                	li	a1,0
ffffffffc0202e78:	ac7ff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e7c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202e80:	4785                	li	a5,1
ffffffffc0202e82:	5cfc9163          	bne	s9,a5,ffffffffc0203444 <pmm_init+0x974>
ffffffffc0202e86:	000c2783          	lw	a5,0(s8)
ffffffffc0202e8a:	58079d63          	bnez	a5,ffffffffc0203424 <pmm_init+0x954>
ffffffffc0202e8e:	00093503          	ld	a0,0(s2)
ffffffffc0202e92:	6585                	lui	a1,0x1
ffffffffc0202e94:	aabff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e98:	000a2783          	lw	a5,0(s4)
ffffffffc0202e9c:	200793e3          	bnez	a5,ffffffffc02038a2 <pmm_init+0xdd2>
ffffffffc0202ea0:	000c2783          	lw	a5,0(s8)
ffffffffc0202ea4:	1c079fe3          	bnez	a5,ffffffffc0203882 <pmm_init+0xdb2>
ffffffffc0202ea8:	00093a03          	ld	s4,0(s2)
ffffffffc0202eac:	608c                	ld	a1,0(s1)
ffffffffc0202eae:	000a3683          	ld	a3,0(s4)
ffffffffc0202eb2:	068a                	slli	a3,a3,0x2
ffffffffc0202eb4:	82b1                	srli	a3,a3,0xc
ffffffffc0202eb6:	4cb6f563          	bgeu	a3,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202eba:	000bb503          	ld	a0,0(s7)
ffffffffc0202ebe:	96d6                	add	a3,a3,s5
ffffffffc0202ec0:	069a                	slli	a3,a3,0x6
ffffffffc0202ec2:	00d507b3          	add	a5,a0,a3
ffffffffc0202ec6:	439c                	lw	a5,0(a5)
ffffffffc0202ec8:	4f979e63          	bne	a5,s9,ffffffffc02033c4 <pmm_init+0x8f4>
ffffffffc0202ecc:	8699                	srai	a3,a3,0x6
ffffffffc0202ece:	00080637          	lui	a2,0x80
ffffffffc0202ed2:	96b2                	add	a3,a3,a2
ffffffffc0202ed4:	00c69713          	slli	a4,a3,0xc
ffffffffc0202ed8:	8331                	srli	a4,a4,0xc
ffffffffc0202eda:	06b2                	slli	a3,a3,0xc
ffffffffc0202edc:	06b773e3          	bgeu	a4,a1,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202ee0:	0009b703          	ld	a4,0(s3)
ffffffffc0202ee4:	96ba                	add	a3,a3,a4
ffffffffc0202ee6:	629c                	ld	a5,0(a3)
ffffffffc0202ee8:	078a                	slli	a5,a5,0x2
ffffffffc0202eea:	83b1                	srli	a5,a5,0xc
ffffffffc0202eec:	48b7fa63          	bgeu	a5,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202ef0:	8f91                	sub	a5,a5,a2
ffffffffc0202ef2:	079a                	slli	a5,a5,0x6
ffffffffc0202ef4:	953e                	add	a0,a0,a5
ffffffffc0202ef6:	100027f3          	csrr	a5,sstatus
ffffffffc0202efa:	8b89                	andi	a5,a5,2
ffffffffc0202efc:	32079463          	bnez	a5,ffffffffc0203224 <pmm_init+0x754>
ffffffffc0202f00:	000b3783          	ld	a5,0(s6)
ffffffffc0202f04:	4585                	li	a1,1
ffffffffc0202f06:	739c                	ld	a5,32(a5)
ffffffffc0202f08:	9782                	jalr	a5
ffffffffc0202f0a:	000a3783          	ld	a5,0(s4)
ffffffffc0202f0e:	6098                	ld	a4,0(s1)
ffffffffc0202f10:	078a                	slli	a5,a5,0x2
ffffffffc0202f12:	83b1                	srli	a5,a5,0xc
ffffffffc0202f14:	46e7f663          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202f18:	000bb503          	ld	a0,0(s7)
ffffffffc0202f1c:	fff80737          	lui	a4,0xfff80
ffffffffc0202f20:	97ba                	add	a5,a5,a4
ffffffffc0202f22:	079a                	slli	a5,a5,0x6
ffffffffc0202f24:	953e                	add	a0,a0,a5
ffffffffc0202f26:	100027f3          	csrr	a5,sstatus
ffffffffc0202f2a:	8b89                	andi	a5,a5,2
ffffffffc0202f2c:	2e079063          	bnez	a5,ffffffffc020320c <pmm_init+0x73c>
ffffffffc0202f30:	000b3783          	ld	a5,0(s6)
ffffffffc0202f34:	4585                	li	a1,1
ffffffffc0202f36:	739c                	ld	a5,32(a5)
ffffffffc0202f38:	9782                	jalr	a5
ffffffffc0202f3a:	00093783          	ld	a5,0(s2)
ffffffffc0202f3e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202f42:	12000073          	sfence.vma
ffffffffc0202f46:	100027f3          	csrr	a5,sstatus
ffffffffc0202f4a:	8b89                	andi	a5,a5,2
ffffffffc0202f4c:	2a079663          	bnez	a5,ffffffffc02031f8 <pmm_init+0x728>
ffffffffc0202f50:	000b3783          	ld	a5,0(s6)
ffffffffc0202f54:	779c                	ld	a5,40(a5)
ffffffffc0202f56:	9782                	jalr	a5
ffffffffc0202f58:	8a2a                	mv	s4,a0
ffffffffc0202f5a:	7d441463          	bne	s0,s4,ffffffffc0203722 <pmm_init+0xc52>
ffffffffc0202f5e:	0000a517          	auipc	a0,0xa
ffffffffc0202f62:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020c9e8 <default_pmm_manager+0x5f8>
ffffffffc0202f66:	a40fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202f6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202f6e:	8b89                	andi	a5,a5,2
ffffffffc0202f70:	26079a63          	bnez	a5,ffffffffc02031e4 <pmm_init+0x714>
ffffffffc0202f74:	000b3783          	ld	a5,0(s6)
ffffffffc0202f78:	779c                	ld	a5,40(a5)
ffffffffc0202f7a:	9782                	jalr	a5
ffffffffc0202f7c:	8c2a                	mv	s8,a0
ffffffffc0202f7e:	6098                	ld	a4,0(s1)
ffffffffc0202f80:	c0200437          	lui	s0,0xc0200
ffffffffc0202f84:	7afd                	lui	s5,0xfffff
ffffffffc0202f86:	00c71793          	slli	a5,a4,0xc
ffffffffc0202f8a:	6a05                	lui	s4,0x1
ffffffffc0202f8c:	02f47c63          	bgeu	s0,a5,ffffffffc0202fc4 <pmm_init+0x4f4>
ffffffffc0202f90:	00c45793          	srli	a5,s0,0xc
ffffffffc0202f94:	00093503          	ld	a0,0(s2)
ffffffffc0202f98:	3ae7f763          	bgeu	a5,a4,ffffffffc0203346 <pmm_init+0x876>
ffffffffc0202f9c:	0009b583          	ld	a1,0(s3)
ffffffffc0202fa0:	4601                	li	a2,0
ffffffffc0202fa2:	95a2                	add	a1,a1,s0
ffffffffc0202fa4:	a80ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202fa8:	36050f63          	beqz	a0,ffffffffc0203326 <pmm_init+0x856>
ffffffffc0202fac:	611c                	ld	a5,0(a0)
ffffffffc0202fae:	078a                	slli	a5,a5,0x2
ffffffffc0202fb0:	0157f7b3          	and	a5,a5,s5
ffffffffc0202fb4:	3a879663          	bne	a5,s0,ffffffffc0203360 <pmm_init+0x890>
ffffffffc0202fb8:	6098                	ld	a4,0(s1)
ffffffffc0202fba:	9452                	add	s0,s0,s4
ffffffffc0202fbc:	00c71793          	slli	a5,a4,0xc
ffffffffc0202fc0:	fcf468e3          	bltu	s0,a5,ffffffffc0202f90 <pmm_init+0x4c0>
ffffffffc0202fc4:	00093783          	ld	a5,0(s2)
ffffffffc0202fc8:	639c                	ld	a5,0(a5)
ffffffffc0202fca:	48079d63          	bnez	a5,ffffffffc0203464 <pmm_init+0x994>
ffffffffc0202fce:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd2:	8b89                	andi	a5,a5,2
ffffffffc0202fd4:	26079463          	bnez	a5,ffffffffc020323c <pmm_init+0x76c>
ffffffffc0202fd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fdc:	4505                	li	a0,1
ffffffffc0202fde:	6f9c                	ld	a5,24(a5)
ffffffffc0202fe0:	9782                	jalr	a5
ffffffffc0202fe2:	8a2a                	mv	s4,a0
ffffffffc0202fe4:	00093503          	ld	a0,0(s2)
ffffffffc0202fe8:	4699                	li	a3,6
ffffffffc0202fea:	10000613          	li	a2,256
ffffffffc0202fee:	85d2                	mv	a1,s4
ffffffffc0202ff0:	9ebff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202ff4:	4a051863          	bnez	a0,ffffffffc02034a4 <pmm_init+0x9d4>
ffffffffc0202ff8:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202ffc:	4785                	li	a5,1
ffffffffc0202ffe:	48f71363          	bne	a4,a5,ffffffffc0203484 <pmm_init+0x9b4>
ffffffffc0203002:	00093503          	ld	a0,0(s2)
ffffffffc0203006:	6405                	lui	s0,0x1
ffffffffc0203008:	4699                	li	a3,6
ffffffffc020300a:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020300e:	85d2                	mv	a1,s4
ffffffffc0203010:	9cbff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203014:	38051863          	bnez	a0,ffffffffc02033a4 <pmm_init+0x8d4>
ffffffffc0203018:	000a2703          	lw	a4,0(s4)
ffffffffc020301c:	4789                	li	a5,2
ffffffffc020301e:	4ef71363          	bne	a4,a5,ffffffffc0203504 <pmm_init+0xa34>
ffffffffc0203022:	0000a597          	auipc	a1,0xa
ffffffffc0203026:	b0e58593          	addi	a1,a1,-1266 # ffffffffc020cb30 <default_pmm_manager+0x740>
ffffffffc020302a:	10000513          	li	a0,256
ffffffffc020302e:	38a080ef          	jal	ra,ffffffffc020b3b8 <strcpy>
ffffffffc0203032:	10040593          	addi	a1,s0,256
ffffffffc0203036:	10000513          	li	a0,256
ffffffffc020303a:	390080ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc020303e:	4a051363          	bnez	a0,ffffffffc02034e4 <pmm_init+0xa14>
ffffffffc0203042:	000bb683          	ld	a3,0(s7)
ffffffffc0203046:	00080737          	lui	a4,0x80
ffffffffc020304a:	547d                	li	s0,-1
ffffffffc020304c:	40da06b3          	sub	a3,s4,a3
ffffffffc0203050:	8699                	srai	a3,a3,0x6
ffffffffc0203052:	609c                	ld	a5,0(s1)
ffffffffc0203054:	96ba                	add	a3,a3,a4
ffffffffc0203056:	8031                	srli	s0,s0,0xc
ffffffffc0203058:	0086f733          	and	a4,a3,s0
ffffffffc020305c:	06b2                	slli	a3,a3,0xc
ffffffffc020305e:	6ef77263          	bgeu	a4,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203062:	0009b783          	ld	a5,0(s3)
ffffffffc0203066:	10000513          	li	a0,256
ffffffffc020306a:	96be                	add	a3,a3,a5
ffffffffc020306c:	10068023          	sb	zero,256(a3)
ffffffffc0203070:	312080ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc0203074:	44051863          	bnez	a0,ffffffffc02034c4 <pmm_init+0x9f4>
ffffffffc0203078:	00093a83          	ld	s5,0(s2)
ffffffffc020307c:	609c                	ld	a5,0(s1)
ffffffffc020307e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203082:	068a                	slli	a3,a3,0x2
ffffffffc0203084:	82b1                	srli	a3,a3,0xc
ffffffffc0203086:	2ef6fd63          	bgeu	a3,a5,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc020308a:	8c75                	and	s0,s0,a3
ffffffffc020308c:	06b2                	slli	a3,a3,0xc
ffffffffc020308e:	6af47a63          	bgeu	s0,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203092:	0009b403          	ld	s0,0(s3)
ffffffffc0203096:	9436                	add	s0,s0,a3
ffffffffc0203098:	100027f3          	csrr	a5,sstatus
ffffffffc020309c:	8b89                	andi	a5,a5,2
ffffffffc020309e:	1e079c63          	bnez	a5,ffffffffc0203296 <pmm_init+0x7c6>
ffffffffc02030a2:	000b3783          	ld	a5,0(s6)
ffffffffc02030a6:	4585                	li	a1,1
ffffffffc02030a8:	8552                	mv	a0,s4
ffffffffc02030aa:	739c                	ld	a5,32(a5)
ffffffffc02030ac:	9782                	jalr	a5
ffffffffc02030ae:	601c                	ld	a5,0(s0)
ffffffffc02030b0:	6098                	ld	a4,0(s1)
ffffffffc02030b2:	078a                	slli	a5,a5,0x2
ffffffffc02030b4:	83b1                	srli	a5,a5,0xc
ffffffffc02030b6:	2ce7f563          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ba:	000bb503          	ld	a0,0(s7)
ffffffffc02030be:	fff80737          	lui	a4,0xfff80
ffffffffc02030c2:	97ba                	add	a5,a5,a4
ffffffffc02030c4:	079a                	slli	a5,a5,0x6
ffffffffc02030c6:	953e                	add	a0,a0,a5
ffffffffc02030c8:	100027f3          	csrr	a5,sstatus
ffffffffc02030cc:	8b89                	andi	a5,a5,2
ffffffffc02030ce:	1a079863          	bnez	a5,ffffffffc020327e <pmm_init+0x7ae>
ffffffffc02030d2:	000b3783          	ld	a5,0(s6)
ffffffffc02030d6:	4585                	li	a1,1
ffffffffc02030d8:	739c                	ld	a5,32(a5)
ffffffffc02030da:	9782                	jalr	a5
ffffffffc02030dc:	000ab783          	ld	a5,0(s5)
ffffffffc02030e0:	6098                	ld	a4,0(s1)
ffffffffc02030e2:	078a                	slli	a5,a5,0x2
ffffffffc02030e4:	83b1                	srli	a5,a5,0xc
ffffffffc02030e6:	28e7fd63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ea:	000bb503          	ld	a0,0(s7)
ffffffffc02030ee:	fff80737          	lui	a4,0xfff80
ffffffffc02030f2:	97ba                	add	a5,a5,a4
ffffffffc02030f4:	079a                	slli	a5,a5,0x6
ffffffffc02030f6:	953e                	add	a0,a0,a5
ffffffffc02030f8:	100027f3          	csrr	a5,sstatus
ffffffffc02030fc:	8b89                	andi	a5,a5,2
ffffffffc02030fe:	16079463          	bnez	a5,ffffffffc0203266 <pmm_init+0x796>
ffffffffc0203102:	000b3783          	ld	a5,0(s6)
ffffffffc0203106:	4585                	li	a1,1
ffffffffc0203108:	739c                	ld	a5,32(a5)
ffffffffc020310a:	9782                	jalr	a5
ffffffffc020310c:	00093783          	ld	a5,0(s2)
ffffffffc0203110:	0007b023          	sd	zero,0(a5)
ffffffffc0203114:	12000073          	sfence.vma
ffffffffc0203118:	100027f3          	csrr	a5,sstatus
ffffffffc020311c:	8b89                	andi	a5,a5,2
ffffffffc020311e:	12079a63          	bnez	a5,ffffffffc0203252 <pmm_init+0x782>
ffffffffc0203122:	000b3783          	ld	a5,0(s6)
ffffffffc0203126:	779c                	ld	a5,40(a5)
ffffffffc0203128:	9782                	jalr	a5
ffffffffc020312a:	842a                	mv	s0,a0
ffffffffc020312c:	488c1e63          	bne	s8,s0,ffffffffc02035c8 <pmm_init+0xaf8>
ffffffffc0203130:	0000a517          	auipc	a0,0xa
ffffffffc0203134:	a7850513          	addi	a0,a0,-1416 # ffffffffc020cba8 <default_pmm_manager+0x7b8>
ffffffffc0203138:	86efd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020313c:	7406                	ld	s0,96(sp)
ffffffffc020313e:	70a6                	ld	ra,104(sp)
ffffffffc0203140:	64e6                	ld	s1,88(sp)
ffffffffc0203142:	6946                	ld	s2,80(sp)
ffffffffc0203144:	69a6                	ld	s3,72(sp)
ffffffffc0203146:	6a06                	ld	s4,64(sp)
ffffffffc0203148:	7ae2                	ld	s5,56(sp)
ffffffffc020314a:	7b42                	ld	s6,48(sp)
ffffffffc020314c:	7ba2                	ld	s7,40(sp)
ffffffffc020314e:	7c02                	ld	s8,32(sp)
ffffffffc0203150:	6ce2                	ld	s9,24(sp)
ffffffffc0203152:	6165                	addi	sp,sp,112
ffffffffc0203154:	e17fe06f          	j	ffffffffc0201f6a <kmalloc_init>
ffffffffc0203158:	c80007b7          	lui	a5,0xc8000
ffffffffc020315c:	b411                	j	ffffffffc0202b60 <pmm_init+0x90>
ffffffffc020315e:	b15fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203162:	000b3783          	ld	a5,0(s6)
ffffffffc0203166:	4505                	li	a0,1
ffffffffc0203168:	6f9c                	ld	a5,24(a5)
ffffffffc020316a:	9782                	jalr	a5
ffffffffc020316c:	8c2a                	mv	s8,a0
ffffffffc020316e:	afffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203172:	b9a9                	j	ffffffffc0202dcc <pmm_init+0x2fc>
ffffffffc0203174:	afffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203178:	000b3783          	ld	a5,0(s6)
ffffffffc020317c:	4505                	li	a0,1
ffffffffc020317e:	6f9c                	ld	a5,24(a5)
ffffffffc0203180:	9782                	jalr	a5
ffffffffc0203182:	8a2a                	mv	s4,a0
ffffffffc0203184:	ae9fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203188:	b645                	j	ffffffffc0202d28 <pmm_init+0x258>
ffffffffc020318a:	ae9fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020318e:	000b3783          	ld	a5,0(s6)
ffffffffc0203192:	779c                	ld	a5,40(a5)
ffffffffc0203194:	9782                	jalr	a5
ffffffffc0203196:	842a                	mv	s0,a0
ffffffffc0203198:	ad5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020319c:	b6b9                	j	ffffffffc0202cea <pmm_init+0x21a>
ffffffffc020319e:	ad5fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031a2:	000b3783          	ld	a5,0(s6)
ffffffffc02031a6:	4505                	li	a0,1
ffffffffc02031a8:	6f9c                	ld	a5,24(a5)
ffffffffc02031aa:	9782                	jalr	a5
ffffffffc02031ac:	842a                	mv	s0,a0
ffffffffc02031ae:	abffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031b2:	bc99                	j	ffffffffc0202c08 <pmm_init+0x138>
ffffffffc02031b4:	6705                	lui	a4,0x1
ffffffffc02031b6:	177d                	addi	a4,a4,-1
ffffffffc02031b8:	96ba                	add	a3,a3,a4
ffffffffc02031ba:	8ff5                	and	a5,a5,a3
ffffffffc02031bc:	00c7d713          	srli	a4,a5,0xc
ffffffffc02031c0:	1ca77063          	bgeu	a4,a0,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02031c4:	000b3683          	ld	a3,0(s6)
ffffffffc02031c8:	fff80537          	lui	a0,0xfff80
ffffffffc02031cc:	972a                	add	a4,a4,a0
ffffffffc02031ce:	6a94                	ld	a3,16(a3)
ffffffffc02031d0:	8c1d                	sub	s0,s0,a5
ffffffffc02031d2:	00671513          	slli	a0,a4,0x6
ffffffffc02031d6:	00c45593          	srli	a1,s0,0xc
ffffffffc02031da:	9532                	add	a0,a0,a2
ffffffffc02031dc:	9682                	jalr	a3
ffffffffc02031de:	0009b583          	ld	a1,0(s3)
ffffffffc02031e2:	bac5                	j	ffffffffc0202bd2 <pmm_init+0x102>
ffffffffc02031e4:	a8ffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031e8:	000b3783          	ld	a5,0(s6)
ffffffffc02031ec:	779c                	ld	a5,40(a5)
ffffffffc02031ee:	9782                	jalr	a5
ffffffffc02031f0:	8c2a                	mv	s8,a0
ffffffffc02031f2:	a7bfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031f6:	b361                	j	ffffffffc0202f7e <pmm_init+0x4ae>
ffffffffc02031f8:	a7bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031fc:	000b3783          	ld	a5,0(s6)
ffffffffc0203200:	779c                	ld	a5,40(a5)
ffffffffc0203202:	9782                	jalr	a5
ffffffffc0203204:	8a2a                	mv	s4,a0
ffffffffc0203206:	a67fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020320a:	bb81                	j	ffffffffc0202f5a <pmm_init+0x48a>
ffffffffc020320c:	e42a                	sd	a0,8(sp)
ffffffffc020320e:	a65fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203212:	000b3783          	ld	a5,0(s6)
ffffffffc0203216:	6522                	ld	a0,8(sp)
ffffffffc0203218:	4585                	li	a1,1
ffffffffc020321a:	739c                	ld	a5,32(a5)
ffffffffc020321c:	9782                	jalr	a5
ffffffffc020321e:	a4ffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203222:	bb21                	j	ffffffffc0202f3a <pmm_init+0x46a>
ffffffffc0203224:	e42a                	sd	a0,8(sp)
ffffffffc0203226:	a4dfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020322a:	000b3783          	ld	a5,0(s6)
ffffffffc020322e:	6522                	ld	a0,8(sp)
ffffffffc0203230:	4585                	li	a1,1
ffffffffc0203232:	739c                	ld	a5,32(a5)
ffffffffc0203234:	9782                	jalr	a5
ffffffffc0203236:	a37fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020323a:	b9c1                	j	ffffffffc0202f0a <pmm_init+0x43a>
ffffffffc020323c:	a37fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203240:	000b3783          	ld	a5,0(s6)
ffffffffc0203244:	4505                	li	a0,1
ffffffffc0203246:	6f9c                	ld	a5,24(a5)
ffffffffc0203248:	9782                	jalr	a5
ffffffffc020324a:	8a2a                	mv	s4,a0
ffffffffc020324c:	a21fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203250:	bb51                	j	ffffffffc0202fe4 <pmm_init+0x514>
ffffffffc0203252:	a21fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203256:	000b3783          	ld	a5,0(s6)
ffffffffc020325a:	779c                	ld	a5,40(a5)
ffffffffc020325c:	9782                	jalr	a5
ffffffffc020325e:	842a                	mv	s0,a0
ffffffffc0203260:	a0dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203264:	b5e1                	j	ffffffffc020312c <pmm_init+0x65c>
ffffffffc0203266:	e42a                	sd	a0,8(sp)
ffffffffc0203268:	a0bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020326c:	000b3783          	ld	a5,0(s6)
ffffffffc0203270:	6522                	ld	a0,8(sp)
ffffffffc0203272:	4585                	li	a1,1
ffffffffc0203274:	739c                	ld	a5,32(a5)
ffffffffc0203276:	9782                	jalr	a5
ffffffffc0203278:	9f5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020327c:	bd41                	j	ffffffffc020310c <pmm_init+0x63c>
ffffffffc020327e:	e42a                	sd	a0,8(sp)
ffffffffc0203280:	9f3fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203284:	000b3783          	ld	a5,0(s6)
ffffffffc0203288:	6522                	ld	a0,8(sp)
ffffffffc020328a:	4585                	li	a1,1
ffffffffc020328c:	739c                	ld	a5,32(a5)
ffffffffc020328e:	9782                	jalr	a5
ffffffffc0203290:	9ddfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203294:	b5a1                	j	ffffffffc02030dc <pmm_init+0x60c>
ffffffffc0203296:	9ddfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020329a:	000b3783          	ld	a5,0(s6)
ffffffffc020329e:	4585                	li	a1,1
ffffffffc02032a0:	8552                	mv	a0,s4
ffffffffc02032a2:	739c                	ld	a5,32(a5)
ffffffffc02032a4:	9782                	jalr	a5
ffffffffc02032a6:	9c7fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032aa:	b511                	j	ffffffffc02030ae <pmm_init+0x5de>
ffffffffc02032ac:	00010417          	auipc	s0,0x10
ffffffffc02032b0:	d5440413          	addi	s0,s0,-684 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032b4:	00010797          	auipc	a5,0x10
ffffffffc02032b8:	d4c78793          	addi	a5,a5,-692 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032bc:	a0f41de3          	bne	s0,a5,ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc02032c0:	4581                	li	a1,0
ffffffffc02032c2:	6605                	lui	a2,0x1
ffffffffc02032c4:	8522                	mv	a0,s0
ffffffffc02032c6:	15e080ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc02032ca:	0000d597          	auipc	a1,0xd
ffffffffc02032ce:	d3658593          	addi	a1,a1,-714 # ffffffffc0210000 <bootstackguard>
ffffffffc02032d2:	0000e797          	auipc	a5,0xe
ffffffffc02032d6:	d20786a3          	sb	zero,-723(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc02032da:	0000d797          	auipc	a5,0xd
ffffffffc02032de:	d2078323          	sb	zero,-730(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc02032e2:	00093503          	ld	a0,0(s2)
ffffffffc02032e6:	2555ec63          	bltu	a1,s5,ffffffffc020353e <pmm_init+0xa6e>
ffffffffc02032ea:	0009b683          	ld	a3,0(s3)
ffffffffc02032ee:	4701                	li	a4,0
ffffffffc02032f0:	6605                	lui	a2,0x1
ffffffffc02032f2:	40d586b3          	sub	a3,a1,a3
ffffffffc02032f6:	956ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc02032fa:	00093503          	ld	a0,0(s2)
ffffffffc02032fe:	23546363          	bltu	s0,s5,ffffffffc0203524 <pmm_init+0xa54>
ffffffffc0203302:	0009b683          	ld	a3,0(s3)
ffffffffc0203306:	4701                	li	a4,0
ffffffffc0203308:	6605                	lui	a2,0x1
ffffffffc020330a:	40d406b3          	sub	a3,s0,a3
ffffffffc020330e:	85a2                	mv	a1,s0
ffffffffc0203310:	93cff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0203314:	12000073          	sfence.vma
ffffffffc0203318:	00009517          	auipc	a0,0x9
ffffffffc020331c:	3a050513          	addi	a0,a0,928 # ffffffffc020c6b8 <default_pmm_manager+0x2c8>
ffffffffc0203320:	e87fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203324:	ba4d                	j	ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc0203326:	00009697          	auipc	a3,0x9
ffffffffc020332a:	6e268693          	addi	a3,a3,1762 # ffffffffc020ca08 <default_pmm_manager+0x618>
ffffffffc020332e:	00008617          	auipc	a2,0x8
ffffffffc0203332:	5da60613          	addi	a2,a2,1498 # ffffffffc020b908 <commands+0x210>
ffffffffc0203336:	28800593          	li	a1,648
ffffffffc020333a:	00009517          	auipc	a0,0x9
ffffffffc020333e:	20650513          	addi	a0,a0,518 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203342:	95cfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203346:	86a2                	mv	a3,s0
ffffffffc0203348:	00009617          	auipc	a2,0x9
ffffffffc020334c:	0e060613          	addi	a2,a2,224 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0203350:	28800593          	li	a1,648
ffffffffc0203354:	00009517          	auipc	a0,0x9
ffffffffc0203358:	1ec50513          	addi	a0,a0,492 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020335c:	942fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203360:	00009697          	auipc	a3,0x9
ffffffffc0203364:	6e868693          	addi	a3,a3,1768 # ffffffffc020ca48 <default_pmm_manager+0x658>
ffffffffc0203368:	00008617          	auipc	a2,0x8
ffffffffc020336c:	5a060613          	addi	a2,a2,1440 # ffffffffc020b908 <commands+0x210>
ffffffffc0203370:	28900593          	li	a1,649
ffffffffc0203374:	00009517          	auipc	a0,0x9
ffffffffc0203378:	1cc50513          	addi	a0,a0,460 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020337c:	922fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203380:	db5fe0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc0203384:	00009697          	auipc	a3,0x9
ffffffffc0203388:	4ec68693          	addi	a3,a3,1260 # ffffffffc020c870 <default_pmm_manager+0x480>
ffffffffc020338c:	00008617          	auipc	a2,0x8
ffffffffc0203390:	57c60613          	addi	a2,a2,1404 # ffffffffc020b908 <commands+0x210>
ffffffffc0203394:	26500593          	li	a1,613
ffffffffc0203398:	00009517          	auipc	a0,0x9
ffffffffc020339c:	1a850513          	addi	a0,a0,424 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02033a0:	8fefd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033a4:	00009697          	auipc	a3,0x9
ffffffffc02033a8:	72c68693          	addi	a3,a3,1836 # ffffffffc020cad0 <default_pmm_manager+0x6e0>
ffffffffc02033ac:	00008617          	auipc	a2,0x8
ffffffffc02033b0:	55c60613          	addi	a2,a2,1372 # ffffffffc020b908 <commands+0x210>
ffffffffc02033b4:	29200593          	li	a1,658
ffffffffc02033b8:	00009517          	auipc	a0,0x9
ffffffffc02033bc:	18850513          	addi	a0,a0,392 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02033c0:	8defd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033c4:	00009697          	auipc	a3,0x9
ffffffffc02033c8:	5cc68693          	addi	a3,a3,1484 # ffffffffc020c990 <default_pmm_manager+0x5a0>
ffffffffc02033cc:	00008617          	auipc	a2,0x8
ffffffffc02033d0:	53c60613          	addi	a2,a2,1340 # ffffffffc020b908 <commands+0x210>
ffffffffc02033d4:	27100593          	li	a1,625
ffffffffc02033d8:	00009517          	auipc	a0,0x9
ffffffffc02033dc:	16850513          	addi	a0,a0,360 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02033e0:	8befd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033e4:	00009697          	auipc	a3,0x9
ffffffffc02033e8:	57c68693          	addi	a3,a3,1404 # ffffffffc020c960 <default_pmm_manager+0x570>
ffffffffc02033ec:	00008617          	auipc	a2,0x8
ffffffffc02033f0:	51c60613          	addi	a2,a2,1308 # ffffffffc020b908 <commands+0x210>
ffffffffc02033f4:	26700593          	li	a1,615
ffffffffc02033f8:	00009517          	auipc	a0,0x9
ffffffffc02033fc:	14850513          	addi	a0,a0,328 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203400:	89efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203404:	00009697          	auipc	a3,0x9
ffffffffc0203408:	3cc68693          	addi	a3,a3,972 # ffffffffc020c7d0 <default_pmm_manager+0x3e0>
ffffffffc020340c:	00008617          	auipc	a2,0x8
ffffffffc0203410:	4fc60613          	addi	a2,a2,1276 # ffffffffc020b908 <commands+0x210>
ffffffffc0203414:	26600593          	li	a1,614
ffffffffc0203418:	00009517          	auipc	a0,0x9
ffffffffc020341c:	12850513          	addi	a0,a0,296 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203420:	87efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203424:	00009697          	auipc	a3,0x9
ffffffffc0203428:	52468693          	addi	a3,a3,1316 # ffffffffc020c948 <default_pmm_manager+0x558>
ffffffffc020342c:	00008617          	auipc	a2,0x8
ffffffffc0203430:	4dc60613          	addi	a2,a2,1244 # ffffffffc020b908 <commands+0x210>
ffffffffc0203434:	26b00593          	li	a1,619
ffffffffc0203438:	00009517          	auipc	a0,0x9
ffffffffc020343c:	10850513          	addi	a0,a0,264 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203440:	85efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203444:	00009697          	auipc	a3,0x9
ffffffffc0203448:	3a468693          	addi	a3,a3,932 # ffffffffc020c7e8 <default_pmm_manager+0x3f8>
ffffffffc020344c:	00008617          	auipc	a2,0x8
ffffffffc0203450:	4bc60613          	addi	a2,a2,1212 # ffffffffc020b908 <commands+0x210>
ffffffffc0203454:	26a00593          	li	a1,618
ffffffffc0203458:	00009517          	auipc	a0,0x9
ffffffffc020345c:	0e850513          	addi	a0,a0,232 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203460:	83efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203464:	00009697          	auipc	a3,0x9
ffffffffc0203468:	5fc68693          	addi	a3,a3,1532 # ffffffffc020ca60 <default_pmm_manager+0x670>
ffffffffc020346c:	00008617          	auipc	a2,0x8
ffffffffc0203470:	49c60613          	addi	a2,a2,1180 # ffffffffc020b908 <commands+0x210>
ffffffffc0203474:	28c00593          	li	a1,652
ffffffffc0203478:	00009517          	auipc	a0,0x9
ffffffffc020347c:	0c850513          	addi	a0,a0,200 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203480:	81efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203484:	00009697          	auipc	a3,0x9
ffffffffc0203488:	63468693          	addi	a3,a3,1588 # ffffffffc020cab8 <default_pmm_manager+0x6c8>
ffffffffc020348c:	00008617          	auipc	a2,0x8
ffffffffc0203490:	47c60613          	addi	a2,a2,1148 # ffffffffc020b908 <commands+0x210>
ffffffffc0203494:	29100593          	li	a1,657
ffffffffc0203498:	00009517          	auipc	a0,0x9
ffffffffc020349c:	0a850513          	addi	a0,a0,168 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02034a0:	ffffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034a4:	00009697          	auipc	a3,0x9
ffffffffc02034a8:	5d468693          	addi	a3,a3,1492 # ffffffffc020ca78 <default_pmm_manager+0x688>
ffffffffc02034ac:	00008617          	auipc	a2,0x8
ffffffffc02034b0:	45c60613          	addi	a2,a2,1116 # ffffffffc020b908 <commands+0x210>
ffffffffc02034b4:	29000593          	li	a1,656
ffffffffc02034b8:	00009517          	auipc	a0,0x9
ffffffffc02034bc:	08850513          	addi	a0,a0,136 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02034c0:	fdffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034c4:	00009697          	auipc	a3,0x9
ffffffffc02034c8:	6bc68693          	addi	a3,a3,1724 # ffffffffc020cb80 <default_pmm_manager+0x790>
ffffffffc02034cc:	00008617          	auipc	a2,0x8
ffffffffc02034d0:	43c60613          	addi	a2,a2,1084 # ffffffffc020b908 <commands+0x210>
ffffffffc02034d4:	29a00593          	li	a1,666
ffffffffc02034d8:	00009517          	auipc	a0,0x9
ffffffffc02034dc:	06850513          	addi	a0,a0,104 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02034e0:	fbffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034e4:	00009697          	auipc	a3,0x9
ffffffffc02034e8:	66468693          	addi	a3,a3,1636 # ffffffffc020cb48 <default_pmm_manager+0x758>
ffffffffc02034ec:	00008617          	auipc	a2,0x8
ffffffffc02034f0:	41c60613          	addi	a2,a2,1052 # ffffffffc020b908 <commands+0x210>
ffffffffc02034f4:	29700593          	li	a1,663
ffffffffc02034f8:	00009517          	auipc	a0,0x9
ffffffffc02034fc:	04850513          	addi	a0,a0,72 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203500:	f9ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203504:	00009697          	auipc	a3,0x9
ffffffffc0203508:	61468693          	addi	a3,a3,1556 # ffffffffc020cb18 <default_pmm_manager+0x728>
ffffffffc020350c:	00008617          	auipc	a2,0x8
ffffffffc0203510:	3fc60613          	addi	a2,a2,1020 # ffffffffc020b908 <commands+0x210>
ffffffffc0203514:	29300593          	li	a1,659
ffffffffc0203518:	00009517          	auipc	a0,0x9
ffffffffc020351c:	02850513          	addi	a0,a0,40 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203520:	f7ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203524:	86a2                	mv	a3,s0
ffffffffc0203526:	00009617          	auipc	a2,0x9
ffffffffc020352a:	faa60613          	addi	a2,a2,-86 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc020352e:	0dc00593          	li	a1,220
ffffffffc0203532:	00009517          	auipc	a0,0x9
ffffffffc0203536:	00e50513          	addi	a0,a0,14 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020353a:	f65fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020353e:	86ae                	mv	a3,a1
ffffffffc0203540:	00009617          	auipc	a2,0x9
ffffffffc0203544:	f9060613          	addi	a2,a2,-112 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0203548:	0db00593          	li	a1,219
ffffffffc020354c:	00009517          	auipc	a0,0x9
ffffffffc0203550:	ff450513          	addi	a0,a0,-12 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203554:	f4bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203558:	00009697          	auipc	a3,0x9
ffffffffc020355c:	1a868693          	addi	a3,a3,424 # ffffffffc020c700 <default_pmm_manager+0x310>
ffffffffc0203560:	00008617          	auipc	a2,0x8
ffffffffc0203564:	3a860613          	addi	a2,a2,936 # ffffffffc020b908 <commands+0x210>
ffffffffc0203568:	24a00593          	li	a1,586
ffffffffc020356c:	00009517          	auipc	a0,0x9
ffffffffc0203570:	fd450513          	addi	a0,a0,-44 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203574:	f2bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203578:	00009697          	auipc	a3,0x9
ffffffffc020357c:	16868693          	addi	a3,a3,360 # ffffffffc020c6e0 <default_pmm_manager+0x2f0>
ffffffffc0203580:	00008617          	auipc	a2,0x8
ffffffffc0203584:	38860613          	addi	a2,a2,904 # ffffffffc020b908 <commands+0x210>
ffffffffc0203588:	24900593          	li	a1,585
ffffffffc020358c:	00009517          	auipc	a0,0x9
ffffffffc0203590:	fb450513          	addi	a0,a0,-76 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203594:	f0bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203598:	00009617          	auipc	a2,0x9
ffffffffc020359c:	0d860613          	addi	a2,a2,216 # ffffffffc020c670 <default_pmm_manager+0x280>
ffffffffc02035a0:	0aa00593          	li	a1,170
ffffffffc02035a4:	00009517          	auipc	a0,0x9
ffffffffc02035a8:	f9c50513          	addi	a0,a0,-100 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02035ac:	ef3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035b0:	00009617          	auipc	a2,0x9
ffffffffc02035b4:	02860613          	addi	a2,a2,40 # ffffffffc020c5d8 <default_pmm_manager+0x1e8>
ffffffffc02035b8:	06500593          	li	a1,101
ffffffffc02035bc:	00009517          	auipc	a0,0x9
ffffffffc02035c0:	f8450513          	addi	a0,a0,-124 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02035c4:	edbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035c8:	00009697          	auipc	a3,0x9
ffffffffc02035cc:	3f868693          	addi	a3,a3,1016 # ffffffffc020c9c0 <default_pmm_manager+0x5d0>
ffffffffc02035d0:	00008617          	auipc	a2,0x8
ffffffffc02035d4:	33860613          	addi	a2,a2,824 # ffffffffc020b908 <commands+0x210>
ffffffffc02035d8:	2a300593          	li	a1,675
ffffffffc02035dc:	00009517          	auipc	a0,0x9
ffffffffc02035e0:	f6450513          	addi	a0,a0,-156 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02035e4:	ebbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035e8:	00009697          	auipc	a3,0x9
ffffffffc02035ec:	21868693          	addi	a3,a3,536 # ffffffffc020c800 <default_pmm_manager+0x410>
ffffffffc02035f0:	00008617          	auipc	a2,0x8
ffffffffc02035f4:	31860613          	addi	a2,a2,792 # ffffffffc020b908 <commands+0x210>
ffffffffc02035f8:	25800593          	li	a1,600
ffffffffc02035fc:	00009517          	auipc	a0,0x9
ffffffffc0203600:	f4450513          	addi	a0,a0,-188 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203604:	e9bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203608:	86d6                	mv	a3,s5
ffffffffc020360a:	00009617          	auipc	a2,0x9
ffffffffc020360e:	e1e60613          	addi	a2,a2,-482 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0203612:	25700593          	li	a1,599
ffffffffc0203616:	00009517          	auipc	a0,0x9
ffffffffc020361a:	f2a50513          	addi	a0,a0,-214 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020361e:	e81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203622:	00009697          	auipc	a3,0x9
ffffffffc0203626:	32668693          	addi	a3,a3,806 # ffffffffc020c948 <default_pmm_manager+0x558>
ffffffffc020362a:	00008617          	auipc	a2,0x8
ffffffffc020362e:	2de60613          	addi	a2,a2,734 # ffffffffc020b908 <commands+0x210>
ffffffffc0203632:	26400593          	li	a1,612
ffffffffc0203636:	00009517          	auipc	a0,0x9
ffffffffc020363a:	f0a50513          	addi	a0,a0,-246 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020363e:	e61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203642:	00009697          	auipc	a3,0x9
ffffffffc0203646:	2ee68693          	addi	a3,a3,750 # ffffffffc020c930 <default_pmm_manager+0x540>
ffffffffc020364a:	00008617          	auipc	a2,0x8
ffffffffc020364e:	2be60613          	addi	a2,a2,702 # ffffffffc020b908 <commands+0x210>
ffffffffc0203652:	26300593          	li	a1,611
ffffffffc0203656:	00009517          	auipc	a0,0x9
ffffffffc020365a:	eea50513          	addi	a0,a0,-278 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020365e:	e41fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203662:	00009697          	auipc	a3,0x9
ffffffffc0203666:	29e68693          	addi	a3,a3,670 # ffffffffc020c900 <default_pmm_manager+0x510>
ffffffffc020366a:	00008617          	auipc	a2,0x8
ffffffffc020366e:	29e60613          	addi	a2,a2,670 # ffffffffc020b908 <commands+0x210>
ffffffffc0203672:	26200593          	li	a1,610
ffffffffc0203676:	00009517          	auipc	a0,0x9
ffffffffc020367a:	eca50513          	addi	a0,a0,-310 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020367e:	e21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203682:	00009697          	auipc	a3,0x9
ffffffffc0203686:	26668693          	addi	a3,a3,614 # ffffffffc020c8e8 <default_pmm_manager+0x4f8>
ffffffffc020368a:	00008617          	auipc	a2,0x8
ffffffffc020368e:	27e60613          	addi	a2,a2,638 # ffffffffc020b908 <commands+0x210>
ffffffffc0203692:	26000593          	li	a1,608
ffffffffc0203696:	00009517          	auipc	a0,0x9
ffffffffc020369a:	eaa50513          	addi	a0,a0,-342 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020369e:	e01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036a2:	00009697          	auipc	a3,0x9
ffffffffc02036a6:	22668693          	addi	a3,a3,550 # ffffffffc020c8c8 <default_pmm_manager+0x4d8>
ffffffffc02036aa:	00008617          	auipc	a2,0x8
ffffffffc02036ae:	25e60613          	addi	a2,a2,606 # ffffffffc020b908 <commands+0x210>
ffffffffc02036b2:	25f00593          	li	a1,607
ffffffffc02036b6:	00009517          	auipc	a0,0x9
ffffffffc02036ba:	e8a50513          	addi	a0,a0,-374 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02036be:	de1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036c2:	00009697          	auipc	a3,0x9
ffffffffc02036c6:	1f668693          	addi	a3,a3,502 # ffffffffc020c8b8 <default_pmm_manager+0x4c8>
ffffffffc02036ca:	00008617          	auipc	a2,0x8
ffffffffc02036ce:	23e60613          	addi	a2,a2,574 # ffffffffc020b908 <commands+0x210>
ffffffffc02036d2:	25e00593          	li	a1,606
ffffffffc02036d6:	00009517          	auipc	a0,0x9
ffffffffc02036da:	e6a50513          	addi	a0,a0,-406 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02036de:	dc1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036e2:	00009697          	auipc	a3,0x9
ffffffffc02036e6:	1c668693          	addi	a3,a3,454 # ffffffffc020c8a8 <default_pmm_manager+0x4b8>
ffffffffc02036ea:	00008617          	auipc	a2,0x8
ffffffffc02036ee:	21e60613          	addi	a2,a2,542 # ffffffffc020b908 <commands+0x210>
ffffffffc02036f2:	25d00593          	li	a1,605
ffffffffc02036f6:	00009517          	auipc	a0,0x9
ffffffffc02036fa:	e4a50513          	addi	a0,a0,-438 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02036fe:	da1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203702:	00009697          	auipc	a3,0x9
ffffffffc0203706:	16e68693          	addi	a3,a3,366 # ffffffffc020c870 <default_pmm_manager+0x480>
ffffffffc020370a:	00008617          	auipc	a2,0x8
ffffffffc020370e:	1fe60613          	addi	a2,a2,510 # ffffffffc020b908 <commands+0x210>
ffffffffc0203712:	25c00593          	li	a1,604
ffffffffc0203716:	00009517          	auipc	a0,0x9
ffffffffc020371a:	e2a50513          	addi	a0,a0,-470 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020371e:	d81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203722:	00009697          	auipc	a3,0x9
ffffffffc0203726:	29e68693          	addi	a3,a3,670 # ffffffffc020c9c0 <default_pmm_manager+0x5d0>
ffffffffc020372a:	00008617          	auipc	a2,0x8
ffffffffc020372e:	1de60613          	addi	a2,a2,478 # ffffffffc020b908 <commands+0x210>
ffffffffc0203732:	27900593          	li	a1,633
ffffffffc0203736:	00009517          	auipc	a0,0x9
ffffffffc020373a:	e0a50513          	addi	a0,a0,-502 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020373e:	d61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203742:	00009617          	auipc	a2,0x9
ffffffffc0203746:	ce660613          	addi	a2,a2,-794 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc020374a:	07100593          	li	a1,113
ffffffffc020374e:	00009517          	auipc	a0,0x9
ffffffffc0203752:	d0250513          	addi	a0,a0,-766 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0203756:	d49fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020375a:	86a2                	mv	a3,s0
ffffffffc020375c:	00009617          	auipc	a2,0x9
ffffffffc0203760:	d7460613          	addi	a2,a2,-652 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0203764:	0ca00593          	li	a1,202
ffffffffc0203768:	00009517          	auipc	a0,0x9
ffffffffc020376c:	dd850513          	addi	a0,a0,-552 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203770:	d2ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203774:	00009617          	auipc	a2,0x9
ffffffffc0203778:	d5c60613          	addi	a2,a2,-676 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc020377c:	08100593          	li	a1,129
ffffffffc0203780:	00009517          	auipc	a0,0x9
ffffffffc0203784:	dc050513          	addi	a0,a0,-576 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203788:	d17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020378c:	00009697          	auipc	a3,0x9
ffffffffc0203790:	0a468693          	addi	a3,a3,164 # ffffffffc020c830 <default_pmm_manager+0x440>
ffffffffc0203794:	00008617          	auipc	a2,0x8
ffffffffc0203798:	17460613          	addi	a2,a2,372 # ffffffffc020b908 <commands+0x210>
ffffffffc020379c:	25b00593          	li	a1,603
ffffffffc02037a0:	00009517          	auipc	a0,0x9
ffffffffc02037a4:	da050513          	addi	a0,a0,-608 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02037a8:	cf7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037ac:	00009697          	auipc	a3,0x9
ffffffffc02037b0:	fc468693          	addi	a3,a3,-60 # ffffffffc020c770 <default_pmm_manager+0x380>
ffffffffc02037b4:	00008617          	auipc	a2,0x8
ffffffffc02037b8:	15460613          	addi	a2,a2,340 # ffffffffc020b908 <commands+0x210>
ffffffffc02037bc:	24f00593          	li	a1,591
ffffffffc02037c0:	00009517          	auipc	a0,0x9
ffffffffc02037c4:	d8050513          	addi	a0,a0,-640 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02037c8:	cd7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037cc:	985fe0ef          	jal	ra,ffffffffc0202150 <pte2page.part.0>
ffffffffc02037d0:	00009697          	auipc	a3,0x9
ffffffffc02037d4:	fd068693          	addi	a3,a3,-48 # ffffffffc020c7a0 <default_pmm_manager+0x3b0>
ffffffffc02037d8:	00008617          	auipc	a2,0x8
ffffffffc02037dc:	13060613          	addi	a2,a2,304 # ffffffffc020b908 <commands+0x210>
ffffffffc02037e0:	25200593          	li	a1,594
ffffffffc02037e4:	00009517          	auipc	a0,0x9
ffffffffc02037e8:	d5c50513          	addi	a0,a0,-676 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02037ec:	cb3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037f0:	00009697          	auipc	a3,0x9
ffffffffc02037f4:	f5068693          	addi	a3,a3,-176 # ffffffffc020c740 <default_pmm_manager+0x350>
ffffffffc02037f8:	00008617          	auipc	a2,0x8
ffffffffc02037fc:	11060613          	addi	a2,a2,272 # ffffffffc020b908 <commands+0x210>
ffffffffc0203800:	24b00593          	li	a1,587
ffffffffc0203804:	00009517          	auipc	a0,0x9
ffffffffc0203808:	d3c50513          	addi	a0,a0,-708 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020380c:	c93fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203810:	00009697          	auipc	a3,0x9
ffffffffc0203814:	fc068693          	addi	a3,a3,-64 # ffffffffc020c7d0 <default_pmm_manager+0x3e0>
ffffffffc0203818:	00008617          	auipc	a2,0x8
ffffffffc020381c:	0f060613          	addi	a2,a2,240 # ffffffffc020b908 <commands+0x210>
ffffffffc0203820:	25300593          	li	a1,595
ffffffffc0203824:	00009517          	auipc	a0,0x9
ffffffffc0203828:	d1c50513          	addi	a0,a0,-740 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020382c:	c73fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203830:	00009617          	auipc	a2,0x9
ffffffffc0203834:	bf860613          	addi	a2,a2,-1032 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0203838:	25600593          	li	a1,598
ffffffffc020383c:	00009517          	auipc	a0,0x9
ffffffffc0203840:	d0450513          	addi	a0,a0,-764 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203844:	c5bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203848:	00009697          	auipc	a3,0x9
ffffffffc020384c:	fa068693          	addi	a3,a3,-96 # ffffffffc020c7e8 <default_pmm_manager+0x3f8>
ffffffffc0203850:	00008617          	auipc	a2,0x8
ffffffffc0203854:	0b860613          	addi	a2,a2,184 # ffffffffc020b908 <commands+0x210>
ffffffffc0203858:	25400593          	li	a1,596
ffffffffc020385c:	00009517          	auipc	a0,0x9
ffffffffc0203860:	ce450513          	addi	a0,a0,-796 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203864:	c3bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203868:	86ca                	mv	a3,s2
ffffffffc020386a:	00009617          	auipc	a2,0x9
ffffffffc020386e:	c6660613          	addi	a2,a2,-922 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0203872:	0c600593          	li	a1,198
ffffffffc0203876:	00009517          	auipc	a0,0x9
ffffffffc020387a:	cca50513          	addi	a0,a0,-822 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020387e:	c21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203882:	00009697          	auipc	a3,0x9
ffffffffc0203886:	0c668693          	addi	a3,a3,198 # ffffffffc020c948 <default_pmm_manager+0x558>
ffffffffc020388a:	00008617          	auipc	a2,0x8
ffffffffc020388e:	07e60613          	addi	a2,a2,126 # ffffffffc020b908 <commands+0x210>
ffffffffc0203892:	26f00593          	li	a1,623
ffffffffc0203896:	00009517          	auipc	a0,0x9
ffffffffc020389a:	caa50513          	addi	a0,a0,-854 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc020389e:	c01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038a2:	00009697          	auipc	a3,0x9
ffffffffc02038a6:	0d668693          	addi	a3,a3,214 # ffffffffc020c978 <default_pmm_manager+0x588>
ffffffffc02038aa:	00008617          	auipc	a2,0x8
ffffffffc02038ae:	05e60613          	addi	a2,a2,94 # ffffffffc020b908 <commands+0x210>
ffffffffc02038b2:	26e00593          	li	a1,622
ffffffffc02038b6:	00009517          	auipc	a0,0x9
ffffffffc02038ba:	c8a50513          	addi	a0,a0,-886 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc02038be:	be1fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02038c2 <copy_range>:
ffffffffc02038c2:	7159                	addi	sp,sp,-112
ffffffffc02038c4:	00d667b3          	or	a5,a2,a3
ffffffffc02038c8:	f486                	sd	ra,104(sp)
ffffffffc02038ca:	f0a2                	sd	s0,96(sp)
ffffffffc02038cc:	eca6                	sd	s1,88(sp)
ffffffffc02038ce:	e8ca                	sd	s2,80(sp)
ffffffffc02038d0:	e4ce                	sd	s3,72(sp)
ffffffffc02038d2:	e0d2                	sd	s4,64(sp)
ffffffffc02038d4:	fc56                	sd	s5,56(sp)
ffffffffc02038d6:	f85a                	sd	s6,48(sp)
ffffffffc02038d8:	f45e                	sd	s7,40(sp)
ffffffffc02038da:	f062                	sd	s8,32(sp)
ffffffffc02038dc:	ec66                	sd	s9,24(sp)
ffffffffc02038de:	e86a                	sd	s10,16(sp)
ffffffffc02038e0:	e46e                	sd	s11,8(sp)
ffffffffc02038e2:	17d2                	slli	a5,a5,0x34
ffffffffc02038e4:	20079f63          	bnez	a5,ffffffffc0203b02 <copy_range+0x240>
ffffffffc02038e8:	002007b7          	lui	a5,0x200
ffffffffc02038ec:	8432                	mv	s0,a2
ffffffffc02038ee:	1af66263          	bltu	a2,a5,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc02038f2:	8936                	mv	s2,a3
ffffffffc02038f4:	18d67f63          	bgeu	a2,a3,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc02038f8:	4785                	li	a5,1
ffffffffc02038fa:	07fe                	slli	a5,a5,0x1f
ffffffffc02038fc:	18d7eb63          	bltu	a5,a3,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc0203900:	5b7d                	li	s6,-1
ffffffffc0203902:	8aaa                	mv	s5,a0
ffffffffc0203904:	89ae                	mv	s3,a1
ffffffffc0203906:	6a05                	lui	s4,0x1
ffffffffc0203908:	00093c17          	auipc	s8,0x93
ffffffffc020390c:	f98c0c13          	addi	s8,s8,-104 # ffffffffc02968a0 <npage>
ffffffffc0203910:	00093b97          	auipc	s7,0x93
ffffffffc0203914:	f98b8b93          	addi	s7,s7,-104 # ffffffffc02968a8 <pages>
ffffffffc0203918:	00cb5b13          	srli	s6,s6,0xc
ffffffffc020391c:	00093c97          	auipc	s9,0x93
ffffffffc0203920:	f94c8c93          	addi	s9,s9,-108 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203924:	4601                	li	a2,0
ffffffffc0203926:	85a2                	mv	a1,s0
ffffffffc0203928:	854e                	mv	a0,s3
ffffffffc020392a:	8fbfe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020392e:	84aa                	mv	s1,a0
ffffffffc0203930:	0e050c63          	beqz	a0,ffffffffc0203a28 <copy_range+0x166>
ffffffffc0203934:	611c                	ld	a5,0(a0)
ffffffffc0203936:	8b85                	andi	a5,a5,1
ffffffffc0203938:	e785                	bnez	a5,ffffffffc0203960 <copy_range+0x9e>
ffffffffc020393a:	9452                	add	s0,s0,s4
ffffffffc020393c:	ff2464e3          	bltu	s0,s2,ffffffffc0203924 <copy_range+0x62>
ffffffffc0203940:	4501                	li	a0,0
ffffffffc0203942:	70a6                	ld	ra,104(sp)
ffffffffc0203944:	7406                	ld	s0,96(sp)
ffffffffc0203946:	64e6                	ld	s1,88(sp)
ffffffffc0203948:	6946                	ld	s2,80(sp)
ffffffffc020394a:	69a6                	ld	s3,72(sp)
ffffffffc020394c:	6a06                	ld	s4,64(sp)
ffffffffc020394e:	7ae2                	ld	s5,56(sp)
ffffffffc0203950:	7b42                	ld	s6,48(sp)
ffffffffc0203952:	7ba2                	ld	s7,40(sp)
ffffffffc0203954:	7c02                	ld	s8,32(sp)
ffffffffc0203956:	6ce2                	ld	s9,24(sp)
ffffffffc0203958:	6d42                	ld	s10,16(sp)
ffffffffc020395a:	6da2                	ld	s11,8(sp)
ffffffffc020395c:	6165                	addi	sp,sp,112
ffffffffc020395e:	8082                	ret
ffffffffc0203960:	4605                	li	a2,1
ffffffffc0203962:	85a2                	mv	a1,s0
ffffffffc0203964:	8556                	mv	a0,s5
ffffffffc0203966:	8bffe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020396a:	c56d                	beqz	a0,ffffffffc0203a54 <copy_range+0x192>
ffffffffc020396c:	609c                	ld	a5,0(s1)
ffffffffc020396e:	0017f713          	andi	a4,a5,1
ffffffffc0203972:	01f7f493          	andi	s1,a5,31
ffffffffc0203976:	16070a63          	beqz	a4,ffffffffc0203aea <copy_range+0x228>
ffffffffc020397a:	000c3683          	ld	a3,0(s8)
ffffffffc020397e:	078a                	slli	a5,a5,0x2
ffffffffc0203980:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203984:	14d77763          	bgeu	a4,a3,ffffffffc0203ad2 <copy_range+0x210>
ffffffffc0203988:	000bb783          	ld	a5,0(s7)
ffffffffc020398c:	fff806b7          	lui	a3,0xfff80
ffffffffc0203990:	9736                	add	a4,a4,a3
ffffffffc0203992:	071a                	slli	a4,a4,0x6
ffffffffc0203994:	00e78db3          	add	s11,a5,a4
ffffffffc0203998:	10002773          	csrr	a4,sstatus
ffffffffc020399c:	8b09                	andi	a4,a4,2
ffffffffc020399e:	e345                	bnez	a4,ffffffffc0203a3e <copy_range+0x17c>
ffffffffc02039a0:	000cb703          	ld	a4,0(s9)
ffffffffc02039a4:	4505                	li	a0,1
ffffffffc02039a6:	6f18                	ld	a4,24(a4)
ffffffffc02039a8:	9702                	jalr	a4
ffffffffc02039aa:	8d2a                	mv	s10,a0
ffffffffc02039ac:	0c0d8363          	beqz	s11,ffffffffc0203a72 <copy_range+0x1b0>
ffffffffc02039b0:	100d0163          	beqz	s10,ffffffffc0203ab2 <copy_range+0x1f0>
ffffffffc02039b4:	000bb703          	ld	a4,0(s7)
ffffffffc02039b8:	000805b7          	lui	a1,0x80
ffffffffc02039bc:	000c3603          	ld	a2,0(s8)
ffffffffc02039c0:	40ed86b3          	sub	a3,s11,a4
ffffffffc02039c4:	8699                	srai	a3,a3,0x6
ffffffffc02039c6:	96ae                	add	a3,a3,a1
ffffffffc02039c8:	0166f7b3          	and	a5,a3,s6
ffffffffc02039cc:	06b2                	slli	a3,a3,0xc
ffffffffc02039ce:	08c7f663          	bgeu	a5,a2,ffffffffc0203a5a <copy_range+0x198>
ffffffffc02039d2:	40ed07b3          	sub	a5,s10,a4
ffffffffc02039d6:	00093717          	auipc	a4,0x93
ffffffffc02039da:	ee270713          	addi	a4,a4,-286 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02039de:	6308                	ld	a0,0(a4)
ffffffffc02039e0:	8799                	srai	a5,a5,0x6
ffffffffc02039e2:	97ae                	add	a5,a5,a1
ffffffffc02039e4:	0167f733          	and	a4,a5,s6
ffffffffc02039e8:	00a685b3          	add	a1,a3,a0
ffffffffc02039ec:	07b2                	slli	a5,a5,0xc
ffffffffc02039ee:	06c77563          	bgeu	a4,a2,ffffffffc0203a58 <copy_range+0x196>
ffffffffc02039f2:	6605                	lui	a2,0x1
ffffffffc02039f4:	953e                	add	a0,a0,a5
ffffffffc02039f6:	281070ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc02039fa:	86a6                	mv	a3,s1
ffffffffc02039fc:	8622                	mv	a2,s0
ffffffffc02039fe:	85ea                	mv	a1,s10
ffffffffc0203a00:	8556                	mv	a0,s5
ffffffffc0203a02:	fd9fe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203a06:	d915                	beqz	a0,ffffffffc020393a <copy_range+0x78>
ffffffffc0203a08:	00009697          	auipc	a3,0x9
ffffffffc0203a0c:	1e068693          	addi	a3,a3,480 # ffffffffc020cbe8 <default_pmm_manager+0x7f8>
ffffffffc0203a10:	00008617          	auipc	a2,0x8
ffffffffc0203a14:	ef860613          	addi	a2,a2,-264 # ffffffffc020b908 <commands+0x210>
ffffffffc0203a18:	1e700593          	li	a1,487
ffffffffc0203a1c:	00009517          	auipc	a0,0x9
ffffffffc0203a20:	b2450513          	addi	a0,a0,-1244 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203a24:	a7bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a28:	00200637          	lui	a2,0x200
ffffffffc0203a2c:	9432                	add	s0,s0,a2
ffffffffc0203a2e:	ffe00637          	lui	a2,0xffe00
ffffffffc0203a32:	8c71                	and	s0,s0,a2
ffffffffc0203a34:	f00406e3          	beqz	s0,ffffffffc0203940 <copy_range+0x7e>
ffffffffc0203a38:	ef2466e3          	bltu	s0,s2,ffffffffc0203924 <copy_range+0x62>
ffffffffc0203a3c:	b711                	j	ffffffffc0203940 <copy_range+0x7e>
ffffffffc0203a3e:	a34fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203a42:	000cb703          	ld	a4,0(s9)
ffffffffc0203a46:	4505                	li	a0,1
ffffffffc0203a48:	6f18                	ld	a4,24(a4)
ffffffffc0203a4a:	9702                	jalr	a4
ffffffffc0203a4c:	8d2a                	mv	s10,a0
ffffffffc0203a4e:	a1efd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203a52:	bfa9                	j	ffffffffc02039ac <copy_range+0xea>
ffffffffc0203a54:	5571                	li	a0,-4
ffffffffc0203a56:	b5f5                	j	ffffffffc0203942 <copy_range+0x80>
ffffffffc0203a58:	86be                	mv	a3,a5
ffffffffc0203a5a:	00009617          	auipc	a2,0x9
ffffffffc0203a5e:	9ce60613          	addi	a2,a2,-1586 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0203a62:	07100593          	li	a1,113
ffffffffc0203a66:	00009517          	auipc	a0,0x9
ffffffffc0203a6a:	9ea50513          	addi	a0,a0,-1558 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0203a6e:	a31fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a72:	00009697          	auipc	a3,0x9
ffffffffc0203a76:	15668693          	addi	a3,a3,342 # ffffffffc020cbc8 <default_pmm_manager+0x7d8>
ffffffffc0203a7a:	00008617          	auipc	a2,0x8
ffffffffc0203a7e:	e8e60613          	addi	a2,a2,-370 # ffffffffc020b908 <commands+0x210>
ffffffffc0203a82:	1ce00593          	li	a1,462
ffffffffc0203a86:	00009517          	auipc	a0,0x9
ffffffffc0203a8a:	aba50513          	addi	a0,a0,-1350 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203a8e:	a11fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a92:	00009697          	auipc	a3,0x9
ffffffffc0203a96:	b1668693          	addi	a3,a3,-1258 # ffffffffc020c5a8 <default_pmm_manager+0x1b8>
ffffffffc0203a9a:	00008617          	auipc	a2,0x8
ffffffffc0203a9e:	e6e60613          	addi	a2,a2,-402 # ffffffffc020b908 <commands+0x210>
ffffffffc0203aa2:	1b600593          	li	a1,438
ffffffffc0203aa6:	00009517          	auipc	a0,0x9
ffffffffc0203aaa:	a9a50513          	addi	a0,a0,-1382 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203aae:	9f1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ab2:	00009697          	auipc	a3,0x9
ffffffffc0203ab6:	12668693          	addi	a3,a3,294 # ffffffffc020cbd8 <default_pmm_manager+0x7e8>
ffffffffc0203aba:	00008617          	auipc	a2,0x8
ffffffffc0203abe:	e4e60613          	addi	a2,a2,-434 # ffffffffc020b908 <commands+0x210>
ffffffffc0203ac2:	1cf00593          	li	a1,463
ffffffffc0203ac6:	00009517          	auipc	a0,0x9
ffffffffc0203aca:	a7a50513          	addi	a0,a0,-1414 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203ace:	9d1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ad2:	00009617          	auipc	a2,0x9
ffffffffc0203ad6:	a2660613          	addi	a2,a2,-1498 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc0203ada:	06900593          	li	a1,105
ffffffffc0203ade:	00009517          	auipc	a0,0x9
ffffffffc0203ae2:	97250513          	addi	a0,a0,-1678 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0203ae6:	9b9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203aea:	00009617          	auipc	a2,0x9
ffffffffc0203aee:	a2e60613          	addi	a2,a2,-1490 # ffffffffc020c518 <default_pmm_manager+0x128>
ffffffffc0203af2:	07f00593          	li	a1,127
ffffffffc0203af6:	00009517          	auipc	a0,0x9
ffffffffc0203afa:	95a50513          	addi	a0,a0,-1702 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0203afe:	9a1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b02:	00009697          	auipc	a3,0x9
ffffffffc0203b06:	a7668693          	addi	a3,a3,-1418 # ffffffffc020c578 <default_pmm_manager+0x188>
ffffffffc0203b0a:	00008617          	auipc	a2,0x8
ffffffffc0203b0e:	dfe60613          	addi	a2,a2,-514 # ffffffffc020b908 <commands+0x210>
ffffffffc0203b12:	1b500593          	li	a1,437
ffffffffc0203b16:	00009517          	auipc	a0,0x9
ffffffffc0203b1a:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203b1e:	981fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203b22 <pgdir_alloc_page>:
ffffffffc0203b22:	7179                	addi	sp,sp,-48
ffffffffc0203b24:	ec26                	sd	s1,24(sp)
ffffffffc0203b26:	e84a                	sd	s2,16(sp)
ffffffffc0203b28:	e052                	sd	s4,0(sp)
ffffffffc0203b2a:	f406                	sd	ra,40(sp)
ffffffffc0203b2c:	f022                	sd	s0,32(sp)
ffffffffc0203b2e:	e44e                	sd	s3,8(sp)
ffffffffc0203b30:	8a2a                	mv	s4,a0
ffffffffc0203b32:	84ae                	mv	s1,a1
ffffffffc0203b34:	8932                	mv	s2,a2
ffffffffc0203b36:	100027f3          	csrr	a5,sstatus
ffffffffc0203b3a:	8b89                	andi	a5,a5,2
ffffffffc0203b3c:	00093997          	auipc	s3,0x93
ffffffffc0203b40:	d7498993          	addi	s3,s3,-652 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203b44:	ef8d                	bnez	a5,ffffffffc0203b7e <pgdir_alloc_page+0x5c>
ffffffffc0203b46:	0009b783          	ld	a5,0(s3)
ffffffffc0203b4a:	4505                	li	a0,1
ffffffffc0203b4c:	6f9c                	ld	a5,24(a5)
ffffffffc0203b4e:	9782                	jalr	a5
ffffffffc0203b50:	842a                	mv	s0,a0
ffffffffc0203b52:	cc09                	beqz	s0,ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203b54:	86ca                	mv	a3,s2
ffffffffc0203b56:	8626                	mv	a2,s1
ffffffffc0203b58:	85a2                	mv	a1,s0
ffffffffc0203b5a:	8552                	mv	a0,s4
ffffffffc0203b5c:	e7ffe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203b60:	e915                	bnez	a0,ffffffffc0203b94 <pgdir_alloc_page+0x72>
ffffffffc0203b62:	4018                	lw	a4,0(s0)
ffffffffc0203b64:	fc04                	sd	s1,56(s0)
ffffffffc0203b66:	4785                	li	a5,1
ffffffffc0203b68:	04f71e63          	bne	a4,a5,ffffffffc0203bc4 <pgdir_alloc_page+0xa2>
ffffffffc0203b6c:	70a2                	ld	ra,40(sp)
ffffffffc0203b6e:	8522                	mv	a0,s0
ffffffffc0203b70:	7402                	ld	s0,32(sp)
ffffffffc0203b72:	64e2                	ld	s1,24(sp)
ffffffffc0203b74:	6942                	ld	s2,16(sp)
ffffffffc0203b76:	69a2                	ld	s3,8(sp)
ffffffffc0203b78:	6a02                	ld	s4,0(sp)
ffffffffc0203b7a:	6145                	addi	sp,sp,48
ffffffffc0203b7c:	8082                	ret
ffffffffc0203b7e:	8f4fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203b82:	0009b783          	ld	a5,0(s3)
ffffffffc0203b86:	4505                	li	a0,1
ffffffffc0203b88:	6f9c                	ld	a5,24(a5)
ffffffffc0203b8a:	9782                	jalr	a5
ffffffffc0203b8c:	842a                	mv	s0,a0
ffffffffc0203b8e:	8defd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203b92:	b7c1                	j	ffffffffc0203b52 <pgdir_alloc_page+0x30>
ffffffffc0203b94:	100027f3          	csrr	a5,sstatus
ffffffffc0203b98:	8b89                	andi	a5,a5,2
ffffffffc0203b9a:	eb89                	bnez	a5,ffffffffc0203bac <pgdir_alloc_page+0x8a>
ffffffffc0203b9c:	0009b783          	ld	a5,0(s3)
ffffffffc0203ba0:	8522                	mv	a0,s0
ffffffffc0203ba2:	4585                	li	a1,1
ffffffffc0203ba4:	739c                	ld	a5,32(a5)
ffffffffc0203ba6:	4401                	li	s0,0
ffffffffc0203ba8:	9782                	jalr	a5
ffffffffc0203baa:	b7c9                	j	ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203bac:	8c6fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203bb0:	0009b783          	ld	a5,0(s3)
ffffffffc0203bb4:	8522                	mv	a0,s0
ffffffffc0203bb6:	4585                	li	a1,1
ffffffffc0203bb8:	739c                	ld	a5,32(a5)
ffffffffc0203bba:	4401                	li	s0,0
ffffffffc0203bbc:	9782                	jalr	a5
ffffffffc0203bbe:	8aefd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203bc2:	b76d                	j	ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203bc4:	00009697          	auipc	a3,0x9
ffffffffc0203bc8:	03468693          	addi	a3,a3,52 # ffffffffc020cbf8 <default_pmm_manager+0x808>
ffffffffc0203bcc:	00008617          	auipc	a2,0x8
ffffffffc0203bd0:	d3c60613          	addi	a2,a2,-708 # ffffffffc020b908 <commands+0x210>
ffffffffc0203bd4:	23000593          	li	a1,560
ffffffffc0203bd8:	00009517          	auipc	a0,0x9
ffffffffc0203bdc:	96850513          	addi	a0,a0,-1688 # ffffffffc020c540 <default_pmm_manager+0x150>
ffffffffc0203be0:	8bffc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203be4 <check_vma_overlap.part.0>:
ffffffffc0203be4:	1141                	addi	sp,sp,-16
ffffffffc0203be6:	00009697          	auipc	a3,0x9
ffffffffc0203bea:	02a68693          	addi	a3,a3,42 # ffffffffc020cc10 <default_pmm_manager+0x820>
ffffffffc0203bee:	00008617          	auipc	a2,0x8
ffffffffc0203bf2:	d1a60613          	addi	a2,a2,-742 # ffffffffc020b908 <commands+0x210>
ffffffffc0203bf6:	07400593          	li	a1,116
ffffffffc0203bfa:	00009517          	auipc	a0,0x9
ffffffffc0203bfe:	03650513          	addi	a0,a0,54 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203c02:	e406                	sd	ra,8(sp)
ffffffffc0203c04:	89bfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c08 <mm_create>:
ffffffffc0203c08:	1141                	addi	sp,sp,-16
ffffffffc0203c0a:	05800513          	li	a0,88
ffffffffc0203c0e:	e022                	sd	s0,0(sp)
ffffffffc0203c10:	e406                	sd	ra,8(sp)
ffffffffc0203c12:	b7cfe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203c16:	842a                	mv	s0,a0
ffffffffc0203c18:	c115                	beqz	a0,ffffffffc0203c3c <mm_create+0x34>
ffffffffc0203c1a:	e408                	sd	a0,8(s0)
ffffffffc0203c1c:	e008                	sd	a0,0(s0)
ffffffffc0203c1e:	00053823          	sd	zero,16(a0)
ffffffffc0203c22:	00053c23          	sd	zero,24(a0)
ffffffffc0203c26:	02052023          	sw	zero,32(a0)
ffffffffc0203c2a:	02053423          	sd	zero,40(a0)
ffffffffc0203c2e:	02052823          	sw	zero,48(a0)
ffffffffc0203c32:	4585                	li	a1,1
ffffffffc0203c34:	03850513          	addi	a0,a0,56
ffffffffc0203c38:	123000ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0203c3c:	60a2                	ld	ra,8(sp)
ffffffffc0203c3e:	8522                	mv	a0,s0
ffffffffc0203c40:	6402                	ld	s0,0(sp)
ffffffffc0203c42:	0141                	addi	sp,sp,16
ffffffffc0203c44:	8082                	ret

ffffffffc0203c46 <find_vma>:
ffffffffc0203c46:	86aa                	mv	a3,a0
ffffffffc0203c48:	c505                	beqz	a0,ffffffffc0203c70 <find_vma+0x2a>
ffffffffc0203c4a:	6908                	ld	a0,16(a0)
ffffffffc0203c4c:	c501                	beqz	a0,ffffffffc0203c54 <find_vma+0xe>
ffffffffc0203c4e:	651c                	ld	a5,8(a0)
ffffffffc0203c50:	02f5f263          	bgeu	a1,a5,ffffffffc0203c74 <find_vma+0x2e>
ffffffffc0203c54:	669c                	ld	a5,8(a3)
ffffffffc0203c56:	00f68d63          	beq	a3,a5,ffffffffc0203c70 <find_vma+0x2a>
ffffffffc0203c5a:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203c5e:	00e5e663          	bltu	a1,a4,ffffffffc0203c6a <find_vma+0x24>
ffffffffc0203c62:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203c66:	00e5ec63          	bltu	a1,a4,ffffffffc0203c7e <find_vma+0x38>
ffffffffc0203c6a:	679c                	ld	a5,8(a5)
ffffffffc0203c6c:	fef697e3          	bne	a3,a5,ffffffffc0203c5a <find_vma+0x14>
ffffffffc0203c70:	4501                	li	a0,0
ffffffffc0203c72:	8082                	ret
ffffffffc0203c74:	691c                	ld	a5,16(a0)
ffffffffc0203c76:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203c54 <find_vma+0xe>
ffffffffc0203c7a:	ea88                	sd	a0,16(a3)
ffffffffc0203c7c:	8082                	ret
ffffffffc0203c7e:	fe078513          	addi	a0,a5,-32
ffffffffc0203c82:	ea88                	sd	a0,16(a3)
ffffffffc0203c84:	8082                	ret

ffffffffc0203c86 <insert_vma_struct>:
ffffffffc0203c86:	6590                	ld	a2,8(a1)
ffffffffc0203c88:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0203c8c:	1141                	addi	sp,sp,-16
ffffffffc0203c8e:	e406                	sd	ra,8(sp)
ffffffffc0203c90:	87aa                	mv	a5,a0
ffffffffc0203c92:	01066763          	bltu	a2,a6,ffffffffc0203ca0 <insert_vma_struct+0x1a>
ffffffffc0203c96:	a085                	j	ffffffffc0203cf6 <insert_vma_struct+0x70>
ffffffffc0203c98:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c9c:	04e66863          	bltu	a2,a4,ffffffffc0203cec <insert_vma_struct+0x66>
ffffffffc0203ca0:	86be                	mv	a3,a5
ffffffffc0203ca2:	679c                	ld	a5,8(a5)
ffffffffc0203ca4:	fef51ae3          	bne	a0,a5,ffffffffc0203c98 <insert_vma_struct+0x12>
ffffffffc0203ca8:	02a68463          	beq	a3,a0,ffffffffc0203cd0 <insert_vma_struct+0x4a>
ffffffffc0203cac:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203cb0:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203cb4:	08e8f163          	bgeu	a7,a4,ffffffffc0203d36 <insert_vma_struct+0xb0>
ffffffffc0203cb8:	04e66f63          	bltu	a2,a4,ffffffffc0203d16 <insert_vma_struct+0x90>
ffffffffc0203cbc:	00f50a63          	beq	a0,a5,ffffffffc0203cd0 <insert_vma_struct+0x4a>
ffffffffc0203cc0:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203cc4:	05076963          	bltu	a4,a6,ffffffffc0203d16 <insert_vma_struct+0x90>
ffffffffc0203cc8:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203ccc:	02c77363          	bgeu	a4,a2,ffffffffc0203cf2 <insert_vma_struct+0x6c>
ffffffffc0203cd0:	5118                	lw	a4,32(a0)
ffffffffc0203cd2:	e188                	sd	a0,0(a1)
ffffffffc0203cd4:	02058613          	addi	a2,a1,32
ffffffffc0203cd8:	e390                	sd	a2,0(a5)
ffffffffc0203cda:	e690                	sd	a2,8(a3)
ffffffffc0203cdc:	60a2                	ld	ra,8(sp)
ffffffffc0203cde:	f59c                	sd	a5,40(a1)
ffffffffc0203ce0:	f194                	sd	a3,32(a1)
ffffffffc0203ce2:	0017079b          	addiw	a5,a4,1
ffffffffc0203ce6:	d11c                	sw	a5,32(a0)
ffffffffc0203ce8:	0141                	addi	sp,sp,16
ffffffffc0203cea:	8082                	ret
ffffffffc0203cec:	fca690e3          	bne	a3,a0,ffffffffc0203cac <insert_vma_struct+0x26>
ffffffffc0203cf0:	bfd1                	j	ffffffffc0203cc4 <insert_vma_struct+0x3e>
ffffffffc0203cf2:	ef3ff0ef          	jal	ra,ffffffffc0203be4 <check_vma_overlap.part.0>
ffffffffc0203cf6:	00009697          	auipc	a3,0x9
ffffffffc0203cfa:	f4a68693          	addi	a3,a3,-182 # ffffffffc020cc40 <default_pmm_manager+0x850>
ffffffffc0203cfe:	00008617          	auipc	a2,0x8
ffffffffc0203d02:	c0a60613          	addi	a2,a2,-1014 # ffffffffc020b908 <commands+0x210>
ffffffffc0203d06:	07a00593          	li	a1,122
ffffffffc0203d0a:	00009517          	auipc	a0,0x9
ffffffffc0203d0e:	f2650513          	addi	a0,a0,-218 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203d12:	f8cfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d16:	00009697          	auipc	a3,0x9
ffffffffc0203d1a:	f6a68693          	addi	a3,a3,-150 # ffffffffc020cc80 <default_pmm_manager+0x890>
ffffffffc0203d1e:	00008617          	auipc	a2,0x8
ffffffffc0203d22:	bea60613          	addi	a2,a2,-1046 # ffffffffc020b908 <commands+0x210>
ffffffffc0203d26:	07300593          	li	a1,115
ffffffffc0203d2a:	00009517          	auipc	a0,0x9
ffffffffc0203d2e:	f0650513          	addi	a0,a0,-250 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203d32:	f6cfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d36:	00009697          	auipc	a3,0x9
ffffffffc0203d3a:	f2a68693          	addi	a3,a3,-214 # ffffffffc020cc60 <default_pmm_manager+0x870>
ffffffffc0203d3e:	00008617          	auipc	a2,0x8
ffffffffc0203d42:	bca60613          	addi	a2,a2,-1078 # ffffffffc020b908 <commands+0x210>
ffffffffc0203d46:	07200593          	li	a1,114
ffffffffc0203d4a:	00009517          	auipc	a0,0x9
ffffffffc0203d4e:	ee650513          	addi	a0,a0,-282 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203d52:	f4cfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203d56 <mm_destroy>:
ffffffffc0203d56:	591c                	lw	a5,48(a0)
ffffffffc0203d58:	1141                	addi	sp,sp,-16
ffffffffc0203d5a:	e406                	sd	ra,8(sp)
ffffffffc0203d5c:	e022                	sd	s0,0(sp)
ffffffffc0203d5e:	e78d                	bnez	a5,ffffffffc0203d88 <mm_destroy+0x32>
ffffffffc0203d60:	842a                	mv	s0,a0
ffffffffc0203d62:	6508                	ld	a0,8(a0)
ffffffffc0203d64:	00a40c63          	beq	s0,a0,ffffffffc0203d7c <mm_destroy+0x26>
ffffffffc0203d68:	6118                	ld	a4,0(a0)
ffffffffc0203d6a:	651c                	ld	a5,8(a0)
ffffffffc0203d6c:	1501                	addi	a0,a0,-32
ffffffffc0203d6e:	e71c                	sd	a5,8(a4)
ffffffffc0203d70:	e398                	sd	a4,0(a5)
ffffffffc0203d72:	accfe0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0203d76:	6408                	ld	a0,8(s0)
ffffffffc0203d78:	fea418e3          	bne	s0,a0,ffffffffc0203d68 <mm_destroy+0x12>
ffffffffc0203d7c:	8522                	mv	a0,s0
ffffffffc0203d7e:	6402                	ld	s0,0(sp)
ffffffffc0203d80:	60a2                	ld	ra,8(sp)
ffffffffc0203d82:	0141                	addi	sp,sp,16
ffffffffc0203d84:	abafe06f          	j	ffffffffc020203e <kfree>
ffffffffc0203d88:	00009697          	auipc	a3,0x9
ffffffffc0203d8c:	f1868693          	addi	a3,a3,-232 # ffffffffc020cca0 <default_pmm_manager+0x8b0>
ffffffffc0203d90:	00008617          	auipc	a2,0x8
ffffffffc0203d94:	b7860613          	addi	a2,a2,-1160 # ffffffffc020b908 <commands+0x210>
ffffffffc0203d98:	09e00593          	li	a1,158
ffffffffc0203d9c:	00009517          	auipc	a0,0x9
ffffffffc0203da0:	e9450513          	addi	a0,a0,-364 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203da4:	efafc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203da8 <mm_map>:
ffffffffc0203da8:	7139                	addi	sp,sp,-64
ffffffffc0203daa:	f822                	sd	s0,48(sp)
ffffffffc0203dac:	6405                	lui	s0,0x1
ffffffffc0203dae:	147d                	addi	s0,s0,-1
ffffffffc0203db0:	77fd                	lui	a5,0xfffff
ffffffffc0203db2:	9622                	add	a2,a2,s0
ffffffffc0203db4:	962e                	add	a2,a2,a1
ffffffffc0203db6:	f426                	sd	s1,40(sp)
ffffffffc0203db8:	fc06                	sd	ra,56(sp)
ffffffffc0203dba:	00f5f4b3          	and	s1,a1,a5
ffffffffc0203dbe:	f04a                	sd	s2,32(sp)
ffffffffc0203dc0:	ec4e                	sd	s3,24(sp)
ffffffffc0203dc2:	e852                	sd	s4,16(sp)
ffffffffc0203dc4:	e456                	sd	s5,8(sp)
ffffffffc0203dc6:	002005b7          	lui	a1,0x200
ffffffffc0203dca:	00f67433          	and	s0,a2,a5
ffffffffc0203dce:	06b4e363          	bltu	s1,a1,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dd2:	0684f163          	bgeu	s1,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dd6:	4785                	li	a5,1
ffffffffc0203dd8:	07fe                	slli	a5,a5,0x1f
ffffffffc0203dda:	0487ed63          	bltu	a5,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dde:	89aa                	mv	s3,a0
ffffffffc0203de0:	cd21                	beqz	a0,ffffffffc0203e38 <mm_map+0x90>
ffffffffc0203de2:	85a6                	mv	a1,s1
ffffffffc0203de4:	8ab6                	mv	s5,a3
ffffffffc0203de6:	8a3a                	mv	s4,a4
ffffffffc0203de8:	e5fff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0203dec:	c501                	beqz	a0,ffffffffc0203df4 <mm_map+0x4c>
ffffffffc0203dee:	651c                	ld	a5,8(a0)
ffffffffc0203df0:	0487e263          	bltu	a5,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203df4:	03000513          	li	a0,48
ffffffffc0203df8:	996fe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203dfc:	892a                	mv	s2,a0
ffffffffc0203dfe:	5571                	li	a0,-4
ffffffffc0203e00:	02090163          	beqz	s2,ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e04:	854e                	mv	a0,s3
ffffffffc0203e06:	00993423          	sd	s1,8(s2)
ffffffffc0203e0a:	00893823          	sd	s0,16(s2)
ffffffffc0203e0e:	01592c23          	sw	s5,24(s2)
ffffffffc0203e12:	85ca                	mv	a1,s2
ffffffffc0203e14:	e73ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203e18:	4501                	li	a0,0
ffffffffc0203e1a:	000a0463          	beqz	s4,ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e1e:	012a3023          	sd	s2,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203e22:	70e2                	ld	ra,56(sp)
ffffffffc0203e24:	7442                	ld	s0,48(sp)
ffffffffc0203e26:	74a2                	ld	s1,40(sp)
ffffffffc0203e28:	7902                	ld	s2,32(sp)
ffffffffc0203e2a:	69e2                	ld	s3,24(sp)
ffffffffc0203e2c:	6a42                	ld	s4,16(sp)
ffffffffc0203e2e:	6aa2                	ld	s5,8(sp)
ffffffffc0203e30:	6121                	addi	sp,sp,64
ffffffffc0203e32:	8082                	ret
ffffffffc0203e34:	5575                	li	a0,-3
ffffffffc0203e36:	b7f5                	j	ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e38:	00009697          	auipc	a3,0x9
ffffffffc0203e3c:	e8068693          	addi	a3,a3,-384 # ffffffffc020ccb8 <default_pmm_manager+0x8c8>
ffffffffc0203e40:	00008617          	auipc	a2,0x8
ffffffffc0203e44:	ac860613          	addi	a2,a2,-1336 # ffffffffc020b908 <commands+0x210>
ffffffffc0203e48:	0b300593          	li	a1,179
ffffffffc0203e4c:	00009517          	auipc	a0,0x9
ffffffffc0203e50:	de450513          	addi	a0,a0,-540 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203e54:	e4afc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203e58 <dup_mmap>:
ffffffffc0203e58:	7139                	addi	sp,sp,-64
ffffffffc0203e5a:	fc06                	sd	ra,56(sp)
ffffffffc0203e5c:	f822                	sd	s0,48(sp)
ffffffffc0203e5e:	f426                	sd	s1,40(sp)
ffffffffc0203e60:	f04a                	sd	s2,32(sp)
ffffffffc0203e62:	ec4e                	sd	s3,24(sp)
ffffffffc0203e64:	e852                	sd	s4,16(sp)
ffffffffc0203e66:	e456                	sd	s5,8(sp)
ffffffffc0203e68:	c52d                	beqz	a0,ffffffffc0203ed2 <dup_mmap+0x7a>
ffffffffc0203e6a:	892a                	mv	s2,a0
ffffffffc0203e6c:	84ae                	mv	s1,a1
ffffffffc0203e6e:	842e                	mv	s0,a1
ffffffffc0203e70:	e595                	bnez	a1,ffffffffc0203e9c <dup_mmap+0x44>
ffffffffc0203e72:	a085                	j	ffffffffc0203ed2 <dup_mmap+0x7a>
ffffffffc0203e74:	854a                	mv	a0,s2
ffffffffc0203e76:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0203e7a:	0145b823          	sd	s4,16(a1)
ffffffffc0203e7e:	0135ac23          	sw	s3,24(a1)
ffffffffc0203e82:	e05ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203e86:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0203e8a:	fe843603          	ld	a2,-24(s0)
ffffffffc0203e8e:	6c8c                	ld	a1,24(s1)
ffffffffc0203e90:	01893503          	ld	a0,24(s2)
ffffffffc0203e94:	4701                	li	a4,0
ffffffffc0203e96:	a2dff0ef          	jal	ra,ffffffffc02038c2 <copy_range>
ffffffffc0203e9a:	e105                	bnez	a0,ffffffffc0203eba <dup_mmap+0x62>
ffffffffc0203e9c:	6000                	ld	s0,0(s0)
ffffffffc0203e9e:	02848863          	beq	s1,s0,ffffffffc0203ece <dup_mmap+0x76>
ffffffffc0203ea2:	03000513          	li	a0,48
ffffffffc0203ea6:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203eaa:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203eae:	ff842983          	lw	s3,-8(s0)
ffffffffc0203eb2:	8dcfe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203eb6:	85aa                	mv	a1,a0
ffffffffc0203eb8:	fd55                	bnez	a0,ffffffffc0203e74 <dup_mmap+0x1c>
ffffffffc0203eba:	5571                	li	a0,-4
ffffffffc0203ebc:	70e2                	ld	ra,56(sp)
ffffffffc0203ebe:	7442                	ld	s0,48(sp)
ffffffffc0203ec0:	74a2                	ld	s1,40(sp)
ffffffffc0203ec2:	7902                	ld	s2,32(sp)
ffffffffc0203ec4:	69e2                	ld	s3,24(sp)
ffffffffc0203ec6:	6a42                	ld	s4,16(sp)
ffffffffc0203ec8:	6aa2                	ld	s5,8(sp)
ffffffffc0203eca:	6121                	addi	sp,sp,64
ffffffffc0203ecc:	8082                	ret
ffffffffc0203ece:	4501                	li	a0,0
ffffffffc0203ed0:	b7f5                	j	ffffffffc0203ebc <dup_mmap+0x64>
ffffffffc0203ed2:	00009697          	auipc	a3,0x9
ffffffffc0203ed6:	df668693          	addi	a3,a3,-522 # ffffffffc020ccc8 <default_pmm_manager+0x8d8>
ffffffffc0203eda:	00008617          	auipc	a2,0x8
ffffffffc0203ede:	a2e60613          	addi	a2,a2,-1490 # ffffffffc020b908 <commands+0x210>
ffffffffc0203ee2:	0cf00593          	li	a1,207
ffffffffc0203ee6:	00009517          	auipc	a0,0x9
ffffffffc0203eea:	d4a50513          	addi	a0,a0,-694 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203eee:	db0fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ef2 <exit_mmap>:
ffffffffc0203ef2:	1101                	addi	sp,sp,-32
ffffffffc0203ef4:	ec06                	sd	ra,24(sp)
ffffffffc0203ef6:	e822                	sd	s0,16(sp)
ffffffffc0203ef8:	e426                	sd	s1,8(sp)
ffffffffc0203efa:	e04a                	sd	s2,0(sp)
ffffffffc0203efc:	c531                	beqz	a0,ffffffffc0203f48 <exit_mmap+0x56>
ffffffffc0203efe:	591c                	lw	a5,48(a0)
ffffffffc0203f00:	84aa                	mv	s1,a0
ffffffffc0203f02:	e3b9                	bnez	a5,ffffffffc0203f48 <exit_mmap+0x56>
ffffffffc0203f04:	6500                	ld	s0,8(a0)
ffffffffc0203f06:	01853903          	ld	s2,24(a0)
ffffffffc0203f0a:	02850663          	beq	a0,s0,ffffffffc0203f36 <exit_mmap+0x44>
ffffffffc0203f0e:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f12:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f16:	854a                	mv	a0,s2
ffffffffc0203f18:	e4efe0ef          	jal	ra,ffffffffc0202566 <unmap_range>
ffffffffc0203f1c:	6400                	ld	s0,8(s0)
ffffffffc0203f1e:	fe8498e3          	bne	s1,s0,ffffffffc0203f0e <exit_mmap+0x1c>
ffffffffc0203f22:	6400                	ld	s0,8(s0)
ffffffffc0203f24:	00848c63          	beq	s1,s0,ffffffffc0203f3c <exit_mmap+0x4a>
ffffffffc0203f28:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f2c:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f30:	854a                	mv	a0,s2
ffffffffc0203f32:	f7afe0ef          	jal	ra,ffffffffc02026ac <exit_range>
ffffffffc0203f36:	6400                	ld	s0,8(s0)
ffffffffc0203f38:	fe8498e3          	bne	s1,s0,ffffffffc0203f28 <exit_mmap+0x36>
ffffffffc0203f3c:	60e2                	ld	ra,24(sp)
ffffffffc0203f3e:	6442                	ld	s0,16(sp)
ffffffffc0203f40:	64a2                	ld	s1,8(sp)
ffffffffc0203f42:	6902                	ld	s2,0(sp)
ffffffffc0203f44:	6105                	addi	sp,sp,32
ffffffffc0203f46:	8082                	ret
ffffffffc0203f48:	00009697          	auipc	a3,0x9
ffffffffc0203f4c:	da068693          	addi	a3,a3,-608 # ffffffffc020cce8 <default_pmm_manager+0x8f8>
ffffffffc0203f50:	00008617          	auipc	a2,0x8
ffffffffc0203f54:	9b860613          	addi	a2,a2,-1608 # ffffffffc020b908 <commands+0x210>
ffffffffc0203f58:	0e800593          	li	a1,232
ffffffffc0203f5c:	00009517          	auipc	a0,0x9
ffffffffc0203f60:	cd450513          	addi	a0,a0,-812 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203f64:	d3afc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203f68 <vmm_init>:
ffffffffc0203f68:	7139                	addi	sp,sp,-64
ffffffffc0203f6a:	05800513          	li	a0,88
ffffffffc0203f6e:	fc06                	sd	ra,56(sp)
ffffffffc0203f70:	f822                	sd	s0,48(sp)
ffffffffc0203f72:	f426                	sd	s1,40(sp)
ffffffffc0203f74:	f04a                	sd	s2,32(sp)
ffffffffc0203f76:	ec4e                	sd	s3,24(sp)
ffffffffc0203f78:	e852                	sd	s4,16(sp)
ffffffffc0203f7a:	e456                	sd	s5,8(sp)
ffffffffc0203f7c:	812fe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203f80:	2e050963          	beqz	a0,ffffffffc0204272 <vmm_init+0x30a>
ffffffffc0203f84:	e508                	sd	a0,8(a0)
ffffffffc0203f86:	e108                	sd	a0,0(a0)
ffffffffc0203f88:	00053823          	sd	zero,16(a0)
ffffffffc0203f8c:	00053c23          	sd	zero,24(a0)
ffffffffc0203f90:	02052023          	sw	zero,32(a0)
ffffffffc0203f94:	02053423          	sd	zero,40(a0)
ffffffffc0203f98:	02052823          	sw	zero,48(a0)
ffffffffc0203f9c:	84aa                	mv	s1,a0
ffffffffc0203f9e:	4585                	li	a1,1
ffffffffc0203fa0:	03850513          	addi	a0,a0,56
ffffffffc0203fa4:	5b6000ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0203fa8:	03200413          	li	s0,50
ffffffffc0203fac:	a811                	j	ffffffffc0203fc0 <vmm_init+0x58>
ffffffffc0203fae:	e500                	sd	s0,8(a0)
ffffffffc0203fb0:	e91c                	sd	a5,16(a0)
ffffffffc0203fb2:	00052c23          	sw	zero,24(a0)
ffffffffc0203fb6:	146d                	addi	s0,s0,-5
ffffffffc0203fb8:	8526                	mv	a0,s1
ffffffffc0203fba:	ccdff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203fbe:	c80d                	beqz	s0,ffffffffc0203ff0 <vmm_init+0x88>
ffffffffc0203fc0:	03000513          	li	a0,48
ffffffffc0203fc4:	fcbfd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203fc8:	85aa                	mv	a1,a0
ffffffffc0203fca:	00240793          	addi	a5,s0,2
ffffffffc0203fce:	f165                	bnez	a0,ffffffffc0203fae <vmm_init+0x46>
ffffffffc0203fd0:	00009697          	auipc	a3,0x9
ffffffffc0203fd4:	eb068693          	addi	a3,a3,-336 # ffffffffc020ce80 <default_pmm_manager+0xa90>
ffffffffc0203fd8:	00008617          	auipc	a2,0x8
ffffffffc0203fdc:	93060613          	addi	a2,a2,-1744 # ffffffffc020b908 <commands+0x210>
ffffffffc0203fe0:	12c00593          	li	a1,300
ffffffffc0203fe4:	00009517          	auipc	a0,0x9
ffffffffc0203fe8:	c4c50513          	addi	a0,a0,-948 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc0203fec:	cb2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ff0:	03700413          	li	s0,55
ffffffffc0203ff4:	1f900913          	li	s2,505
ffffffffc0203ff8:	a819                	j	ffffffffc020400e <vmm_init+0xa6>
ffffffffc0203ffa:	e500                	sd	s0,8(a0)
ffffffffc0203ffc:	e91c                	sd	a5,16(a0)
ffffffffc0203ffe:	00052c23          	sw	zero,24(a0)
ffffffffc0204002:	0415                	addi	s0,s0,5
ffffffffc0204004:	8526                	mv	a0,s1
ffffffffc0204006:	c81ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc020400a:	03240a63          	beq	s0,s2,ffffffffc020403e <vmm_init+0xd6>
ffffffffc020400e:	03000513          	li	a0,48
ffffffffc0204012:	f7dfd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0204016:	85aa                	mv	a1,a0
ffffffffc0204018:	00240793          	addi	a5,s0,2
ffffffffc020401c:	fd79                	bnez	a0,ffffffffc0203ffa <vmm_init+0x92>
ffffffffc020401e:	00009697          	auipc	a3,0x9
ffffffffc0204022:	e6268693          	addi	a3,a3,-414 # ffffffffc020ce80 <default_pmm_manager+0xa90>
ffffffffc0204026:	00008617          	auipc	a2,0x8
ffffffffc020402a:	8e260613          	addi	a2,a2,-1822 # ffffffffc020b908 <commands+0x210>
ffffffffc020402e:	13300593          	li	a1,307
ffffffffc0204032:	00009517          	auipc	a0,0x9
ffffffffc0204036:	bfe50513          	addi	a0,a0,-1026 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020403a:	c64fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020403e:	649c                	ld	a5,8(s1)
ffffffffc0204040:	471d                	li	a4,7
ffffffffc0204042:	1fb00593          	li	a1,507
ffffffffc0204046:	16f48663          	beq	s1,a5,ffffffffc02041b2 <vmm_init+0x24a>
ffffffffc020404a:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc020404e:	ffe70693          	addi	a3,a4,-2
ffffffffc0204052:	10d61063          	bne	a2,a3,ffffffffc0204152 <vmm_init+0x1ea>
ffffffffc0204056:	ff07b683          	ld	a3,-16(a5)
ffffffffc020405a:	0ed71c63          	bne	a4,a3,ffffffffc0204152 <vmm_init+0x1ea>
ffffffffc020405e:	0715                	addi	a4,a4,5
ffffffffc0204060:	679c                	ld	a5,8(a5)
ffffffffc0204062:	feb712e3          	bne	a4,a1,ffffffffc0204046 <vmm_init+0xde>
ffffffffc0204066:	4a1d                	li	s4,7
ffffffffc0204068:	4415                	li	s0,5
ffffffffc020406a:	1f900a93          	li	s5,505
ffffffffc020406e:	85a2                	mv	a1,s0
ffffffffc0204070:	8526                	mv	a0,s1
ffffffffc0204072:	bd5ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204076:	892a                	mv	s2,a0
ffffffffc0204078:	16050d63          	beqz	a0,ffffffffc02041f2 <vmm_init+0x28a>
ffffffffc020407c:	00140593          	addi	a1,s0,1
ffffffffc0204080:	8526                	mv	a0,s1
ffffffffc0204082:	bc5ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204086:	89aa                	mv	s3,a0
ffffffffc0204088:	14050563          	beqz	a0,ffffffffc02041d2 <vmm_init+0x26a>
ffffffffc020408c:	85d2                	mv	a1,s4
ffffffffc020408e:	8526                	mv	a0,s1
ffffffffc0204090:	bb7ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204094:	16051f63          	bnez	a0,ffffffffc0204212 <vmm_init+0x2aa>
ffffffffc0204098:	00340593          	addi	a1,s0,3
ffffffffc020409c:	8526                	mv	a0,s1
ffffffffc020409e:	ba9ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040a2:	1a051863          	bnez	a0,ffffffffc0204252 <vmm_init+0x2ea>
ffffffffc02040a6:	00440593          	addi	a1,s0,4
ffffffffc02040aa:	8526                	mv	a0,s1
ffffffffc02040ac:	b9bff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040b0:	18051163          	bnez	a0,ffffffffc0204232 <vmm_init+0x2ca>
ffffffffc02040b4:	00893783          	ld	a5,8(s2)
ffffffffc02040b8:	0a879d63          	bne	a5,s0,ffffffffc0204172 <vmm_init+0x20a>
ffffffffc02040bc:	01093783          	ld	a5,16(s2)
ffffffffc02040c0:	0b479963          	bne	a5,s4,ffffffffc0204172 <vmm_init+0x20a>
ffffffffc02040c4:	0089b783          	ld	a5,8(s3)
ffffffffc02040c8:	0c879563          	bne	a5,s0,ffffffffc0204192 <vmm_init+0x22a>
ffffffffc02040cc:	0109b783          	ld	a5,16(s3)
ffffffffc02040d0:	0d479163          	bne	a5,s4,ffffffffc0204192 <vmm_init+0x22a>
ffffffffc02040d4:	0415                	addi	s0,s0,5
ffffffffc02040d6:	0a15                	addi	s4,s4,5
ffffffffc02040d8:	f9541be3          	bne	s0,s5,ffffffffc020406e <vmm_init+0x106>
ffffffffc02040dc:	4411                	li	s0,4
ffffffffc02040de:	597d                	li	s2,-1
ffffffffc02040e0:	85a2                	mv	a1,s0
ffffffffc02040e2:	8526                	mv	a0,s1
ffffffffc02040e4:	b63ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040e8:	0004059b          	sext.w	a1,s0
ffffffffc02040ec:	c90d                	beqz	a0,ffffffffc020411e <vmm_init+0x1b6>
ffffffffc02040ee:	6914                	ld	a3,16(a0)
ffffffffc02040f0:	6510                	ld	a2,8(a0)
ffffffffc02040f2:	00009517          	auipc	a0,0x9
ffffffffc02040f6:	d1650513          	addi	a0,a0,-746 # ffffffffc020ce08 <default_pmm_manager+0xa18>
ffffffffc02040fa:	8acfc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02040fe:	00009697          	auipc	a3,0x9
ffffffffc0204102:	d3268693          	addi	a3,a3,-718 # ffffffffc020ce30 <default_pmm_manager+0xa40>
ffffffffc0204106:	00008617          	auipc	a2,0x8
ffffffffc020410a:	80260613          	addi	a2,a2,-2046 # ffffffffc020b908 <commands+0x210>
ffffffffc020410e:	15900593          	li	a1,345
ffffffffc0204112:	00009517          	auipc	a0,0x9
ffffffffc0204116:	b1e50513          	addi	a0,a0,-1250 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020411a:	b84fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020411e:	147d                	addi	s0,s0,-1
ffffffffc0204120:	fd2410e3          	bne	s0,s2,ffffffffc02040e0 <vmm_init+0x178>
ffffffffc0204124:	8526                	mv	a0,s1
ffffffffc0204126:	c31ff0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc020412a:	00009517          	auipc	a0,0x9
ffffffffc020412e:	d1e50513          	addi	a0,a0,-738 # ffffffffc020ce48 <default_pmm_manager+0xa58>
ffffffffc0204132:	874fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0204136:	7442                	ld	s0,48(sp)
ffffffffc0204138:	70e2                	ld	ra,56(sp)
ffffffffc020413a:	74a2                	ld	s1,40(sp)
ffffffffc020413c:	7902                	ld	s2,32(sp)
ffffffffc020413e:	69e2                	ld	s3,24(sp)
ffffffffc0204140:	6a42                	ld	s4,16(sp)
ffffffffc0204142:	6aa2                	ld	s5,8(sp)
ffffffffc0204144:	00009517          	auipc	a0,0x9
ffffffffc0204148:	d2450513          	addi	a0,a0,-732 # ffffffffc020ce68 <default_pmm_manager+0xa78>
ffffffffc020414c:	6121                	addi	sp,sp,64
ffffffffc020414e:	858fc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0204152:	00009697          	auipc	a3,0x9
ffffffffc0204156:	bce68693          	addi	a3,a3,-1074 # ffffffffc020cd20 <default_pmm_manager+0x930>
ffffffffc020415a:	00007617          	auipc	a2,0x7
ffffffffc020415e:	7ae60613          	addi	a2,a2,1966 # ffffffffc020b908 <commands+0x210>
ffffffffc0204162:	13d00593          	li	a1,317
ffffffffc0204166:	00009517          	auipc	a0,0x9
ffffffffc020416a:	aca50513          	addi	a0,a0,-1334 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020416e:	b30fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204172:	00009697          	auipc	a3,0x9
ffffffffc0204176:	c3668693          	addi	a3,a3,-970 # ffffffffc020cda8 <default_pmm_manager+0x9b8>
ffffffffc020417a:	00007617          	auipc	a2,0x7
ffffffffc020417e:	78e60613          	addi	a2,a2,1934 # ffffffffc020b908 <commands+0x210>
ffffffffc0204182:	14e00593          	li	a1,334
ffffffffc0204186:	00009517          	auipc	a0,0x9
ffffffffc020418a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020418e:	b10fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204192:	00009697          	auipc	a3,0x9
ffffffffc0204196:	c4668693          	addi	a3,a3,-954 # ffffffffc020cdd8 <default_pmm_manager+0x9e8>
ffffffffc020419a:	00007617          	auipc	a2,0x7
ffffffffc020419e:	76e60613          	addi	a2,a2,1902 # ffffffffc020b908 <commands+0x210>
ffffffffc02041a2:	14f00593          	li	a1,335
ffffffffc02041a6:	00009517          	auipc	a0,0x9
ffffffffc02041aa:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc02041ae:	af0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041b2:	00009697          	auipc	a3,0x9
ffffffffc02041b6:	b5668693          	addi	a3,a3,-1194 # ffffffffc020cd08 <default_pmm_manager+0x918>
ffffffffc02041ba:	00007617          	auipc	a2,0x7
ffffffffc02041be:	74e60613          	addi	a2,a2,1870 # ffffffffc020b908 <commands+0x210>
ffffffffc02041c2:	13b00593          	li	a1,315
ffffffffc02041c6:	00009517          	auipc	a0,0x9
ffffffffc02041ca:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc02041ce:	ad0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041d2:	00009697          	auipc	a3,0x9
ffffffffc02041d6:	b9668693          	addi	a3,a3,-1130 # ffffffffc020cd68 <default_pmm_manager+0x978>
ffffffffc02041da:	00007617          	auipc	a2,0x7
ffffffffc02041de:	72e60613          	addi	a2,a2,1838 # ffffffffc020b908 <commands+0x210>
ffffffffc02041e2:	14600593          	li	a1,326
ffffffffc02041e6:	00009517          	auipc	a0,0x9
ffffffffc02041ea:	a4a50513          	addi	a0,a0,-1462 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc02041ee:	ab0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041f2:	00009697          	auipc	a3,0x9
ffffffffc02041f6:	b6668693          	addi	a3,a3,-1178 # ffffffffc020cd58 <default_pmm_manager+0x968>
ffffffffc02041fa:	00007617          	auipc	a2,0x7
ffffffffc02041fe:	70e60613          	addi	a2,a2,1806 # ffffffffc020b908 <commands+0x210>
ffffffffc0204202:	14400593          	li	a1,324
ffffffffc0204206:	00009517          	auipc	a0,0x9
ffffffffc020420a:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020420e:	a90fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204212:	00009697          	auipc	a3,0x9
ffffffffc0204216:	b6668693          	addi	a3,a3,-1178 # ffffffffc020cd78 <default_pmm_manager+0x988>
ffffffffc020421a:	00007617          	auipc	a2,0x7
ffffffffc020421e:	6ee60613          	addi	a2,a2,1774 # ffffffffc020b908 <commands+0x210>
ffffffffc0204222:	14800593          	li	a1,328
ffffffffc0204226:	00009517          	auipc	a0,0x9
ffffffffc020422a:	a0a50513          	addi	a0,a0,-1526 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020422e:	a70fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204232:	00009697          	auipc	a3,0x9
ffffffffc0204236:	b6668693          	addi	a3,a3,-1178 # ffffffffc020cd98 <default_pmm_manager+0x9a8>
ffffffffc020423a:	00007617          	auipc	a2,0x7
ffffffffc020423e:	6ce60613          	addi	a2,a2,1742 # ffffffffc020b908 <commands+0x210>
ffffffffc0204242:	14c00593          	li	a1,332
ffffffffc0204246:	00009517          	auipc	a0,0x9
ffffffffc020424a:	9ea50513          	addi	a0,a0,-1558 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020424e:	a50fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204252:	00009697          	auipc	a3,0x9
ffffffffc0204256:	b3668693          	addi	a3,a3,-1226 # ffffffffc020cd88 <default_pmm_manager+0x998>
ffffffffc020425a:	00007617          	auipc	a2,0x7
ffffffffc020425e:	6ae60613          	addi	a2,a2,1710 # ffffffffc020b908 <commands+0x210>
ffffffffc0204262:	14a00593          	li	a1,330
ffffffffc0204266:	00009517          	auipc	a0,0x9
ffffffffc020426a:	9ca50513          	addi	a0,a0,-1590 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020426e:	a30fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204272:	00009697          	auipc	a3,0x9
ffffffffc0204276:	a4668693          	addi	a3,a3,-1466 # ffffffffc020ccb8 <default_pmm_manager+0x8c8>
ffffffffc020427a:	00007617          	auipc	a2,0x7
ffffffffc020427e:	68e60613          	addi	a2,a2,1678 # ffffffffc020b908 <commands+0x210>
ffffffffc0204282:	12400593          	li	a1,292
ffffffffc0204286:	00009517          	auipc	a0,0x9
ffffffffc020428a:	9aa50513          	addi	a0,a0,-1622 # ffffffffc020cc30 <default_pmm_manager+0x840>
ffffffffc020428e:	a10fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204292 <user_mem_check>:
ffffffffc0204292:	7179                	addi	sp,sp,-48
ffffffffc0204294:	f022                	sd	s0,32(sp)
ffffffffc0204296:	f406                	sd	ra,40(sp)
ffffffffc0204298:	ec26                	sd	s1,24(sp)
ffffffffc020429a:	e84a                	sd	s2,16(sp)
ffffffffc020429c:	e44e                	sd	s3,8(sp)
ffffffffc020429e:	e052                	sd	s4,0(sp)
ffffffffc02042a0:	842e                	mv	s0,a1
ffffffffc02042a2:	c135                	beqz	a0,ffffffffc0204306 <user_mem_check+0x74>
ffffffffc02042a4:	002007b7          	lui	a5,0x200
ffffffffc02042a8:	04f5e663          	bltu	a1,a5,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ac:	00c584b3          	add	s1,a1,a2
ffffffffc02042b0:	0495f263          	bgeu	a1,s1,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042b4:	4785                	li	a5,1
ffffffffc02042b6:	07fe                	slli	a5,a5,0x1f
ffffffffc02042b8:	0297ee63          	bltu	a5,s1,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042bc:	892a                	mv	s2,a0
ffffffffc02042be:	89b6                	mv	s3,a3
ffffffffc02042c0:	6a05                	lui	s4,0x1
ffffffffc02042c2:	a821                	j	ffffffffc02042da <user_mem_check+0x48>
ffffffffc02042c4:	0027f693          	andi	a3,a5,2
ffffffffc02042c8:	9752                	add	a4,a4,s4
ffffffffc02042ca:	8ba1                	andi	a5,a5,8
ffffffffc02042cc:	c685                	beqz	a3,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ce:	c399                	beqz	a5,ffffffffc02042d4 <user_mem_check+0x42>
ffffffffc02042d0:	02e46263          	bltu	s0,a4,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042d4:	6900                	ld	s0,16(a0)
ffffffffc02042d6:	04947663          	bgeu	s0,s1,ffffffffc0204322 <user_mem_check+0x90>
ffffffffc02042da:	85a2                	mv	a1,s0
ffffffffc02042dc:	854a                	mv	a0,s2
ffffffffc02042de:	969ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02042e2:	c909                	beqz	a0,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042e4:	6518                	ld	a4,8(a0)
ffffffffc02042e6:	00e46763          	bltu	s0,a4,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ea:	4d1c                	lw	a5,24(a0)
ffffffffc02042ec:	fc099ce3          	bnez	s3,ffffffffc02042c4 <user_mem_check+0x32>
ffffffffc02042f0:	8b85                	andi	a5,a5,1
ffffffffc02042f2:	f3ed                	bnez	a5,ffffffffc02042d4 <user_mem_check+0x42>
ffffffffc02042f4:	4501                	li	a0,0
ffffffffc02042f6:	70a2                	ld	ra,40(sp)
ffffffffc02042f8:	7402                	ld	s0,32(sp)
ffffffffc02042fa:	64e2                	ld	s1,24(sp)
ffffffffc02042fc:	6942                	ld	s2,16(sp)
ffffffffc02042fe:	69a2                	ld	s3,8(sp)
ffffffffc0204300:	6a02                	ld	s4,0(sp)
ffffffffc0204302:	6145                	addi	sp,sp,48
ffffffffc0204304:	8082                	ret
ffffffffc0204306:	c02007b7          	lui	a5,0xc0200
ffffffffc020430a:	4501                	li	a0,0
ffffffffc020430c:	fef5e5e3          	bltu	a1,a5,ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204310:	962e                	add	a2,a2,a1
ffffffffc0204312:	fec5f2e3          	bgeu	a1,a2,ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204316:	c8000537          	lui	a0,0xc8000
ffffffffc020431a:	0505                	addi	a0,a0,1
ffffffffc020431c:	00a63533          	sltu	a0,a2,a0
ffffffffc0204320:	bfd9                	j	ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204322:	4505                	li	a0,1
ffffffffc0204324:	bfc9                	j	ffffffffc02042f6 <user_mem_check+0x64>

ffffffffc0204326 <copy_from_user>:
ffffffffc0204326:	1101                	addi	sp,sp,-32
ffffffffc0204328:	e822                	sd	s0,16(sp)
ffffffffc020432a:	e426                	sd	s1,8(sp)
ffffffffc020432c:	8432                	mv	s0,a2
ffffffffc020432e:	84b6                	mv	s1,a3
ffffffffc0204330:	e04a                	sd	s2,0(sp)
ffffffffc0204332:	86ba                	mv	a3,a4
ffffffffc0204334:	892e                	mv	s2,a1
ffffffffc0204336:	8626                	mv	a2,s1
ffffffffc0204338:	85a2                	mv	a1,s0
ffffffffc020433a:	ec06                	sd	ra,24(sp)
ffffffffc020433c:	f57ff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0204340:	c519                	beqz	a0,ffffffffc020434e <copy_from_user+0x28>
ffffffffc0204342:	8626                	mv	a2,s1
ffffffffc0204344:	85a2                	mv	a1,s0
ffffffffc0204346:	854a                	mv	a0,s2
ffffffffc0204348:	12e070ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020434c:	4505                	li	a0,1
ffffffffc020434e:	60e2                	ld	ra,24(sp)
ffffffffc0204350:	6442                	ld	s0,16(sp)
ffffffffc0204352:	64a2                	ld	s1,8(sp)
ffffffffc0204354:	6902                	ld	s2,0(sp)
ffffffffc0204356:	6105                	addi	sp,sp,32
ffffffffc0204358:	8082                	ret

ffffffffc020435a <copy_to_user>:
ffffffffc020435a:	1101                	addi	sp,sp,-32
ffffffffc020435c:	e822                	sd	s0,16(sp)
ffffffffc020435e:	8436                	mv	s0,a3
ffffffffc0204360:	e04a                	sd	s2,0(sp)
ffffffffc0204362:	4685                	li	a3,1
ffffffffc0204364:	8932                	mv	s2,a2
ffffffffc0204366:	8622                	mv	a2,s0
ffffffffc0204368:	e426                	sd	s1,8(sp)
ffffffffc020436a:	ec06                	sd	ra,24(sp)
ffffffffc020436c:	84ae                	mv	s1,a1
ffffffffc020436e:	f25ff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0204372:	c519                	beqz	a0,ffffffffc0204380 <copy_to_user+0x26>
ffffffffc0204374:	8622                	mv	a2,s0
ffffffffc0204376:	85ca                	mv	a1,s2
ffffffffc0204378:	8526                	mv	a0,s1
ffffffffc020437a:	0fc070ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020437e:	4505                	li	a0,1
ffffffffc0204380:	60e2                	ld	ra,24(sp)
ffffffffc0204382:	6442                	ld	s0,16(sp)
ffffffffc0204384:	64a2                	ld	s1,8(sp)
ffffffffc0204386:	6902                	ld	s2,0(sp)
ffffffffc0204388:	6105                	addi	sp,sp,32
ffffffffc020438a:	8082                	ret

ffffffffc020438c <copy_string>:
ffffffffc020438c:	7139                	addi	sp,sp,-64
ffffffffc020438e:	ec4e                	sd	s3,24(sp)
ffffffffc0204390:	6985                	lui	s3,0x1
ffffffffc0204392:	99b2                	add	s3,s3,a2
ffffffffc0204394:	77fd                	lui	a5,0xfffff
ffffffffc0204396:	00f9f9b3          	and	s3,s3,a5
ffffffffc020439a:	f426                	sd	s1,40(sp)
ffffffffc020439c:	f04a                	sd	s2,32(sp)
ffffffffc020439e:	e852                	sd	s4,16(sp)
ffffffffc02043a0:	e456                	sd	s5,8(sp)
ffffffffc02043a2:	fc06                	sd	ra,56(sp)
ffffffffc02043a4:	f822                	sd	s0,48(sp)
ffffffffc02043a6:	84b2                	mv	s1,a2
ffffffffc02043a8:	8aaa                	mv	s5,a0
ffffffffc02043aa:	8a2e                	mv	s4,a1
ffffffffc02043ac:	8936                	mv	s2,a3
ffffffffc02043ae:	40c989b3          	sub	s3,s3,a2
ffffffffc02043b2:	a015                	j	ffffffffc02043d6 <copy_string+0x4a>
ffffffffc02043b4:	7e9060ef          	jal	ra,ffffffffc020b39c <strnlen>
ffffffffc02043b8:	87aa                	mv	a5,a0
ffffffffc02043ba:	85a6                	mv	a1,s1
ffffffffc02043bc:	8552                	mv	a0,s4
ffffffffc02043be:	8622                	mv	a2,s0
ffffffffc02043c0:	0487e363          	bltu	a5,s0,ffffffffc0204406 <copy_string+0x7a>
ffffffffc02043c4:	0329f763          	bgeu	s3,s2,ffffffffc02043f2 <copy_string+0x66>
ffffffffc02043c8:	0ae070ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc02043cc:	9a22                	add	s4,s4,s0
ffffffffc02043ce:	94a2                	add	s1,s1,s0
ffffffffc02043d0:	40890933          	sub	s2,s2,s0
ffffffffc02043d4:	6985                	lui	s3,0x1
ffffffffc02043d6:	4681                	li	a3,0
ffffffffc02043d8:	85a6                	mv	a1,s1
ffffffffc02043da:	8556                	mv	a0,s5
ffffffffc02043dc:	844a                	mv	s0,s2
ffffffffc02043de:	0129f363          	bgeu	s3,s2,ffffffffc02043e4 <copy_string+0x58>
ffffffffc02043e2:	844e                	mv	s0,s3
ffffffffc02043e4:	8622                	mv	a2,s0
ffffffffc02043e6:	eadff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc02043ea:	87aa                	mv	a5,a0
ffffffffc02043ec:	85a2                	mv	a1,s0
ffffffffc02043ee:	8526                	mv	a0,s1
ffffffffc02043f0:	f3f1                	bnez	a5,ffffffffc02043b4 <copy_string+0x28>
ffffffffc02043f2:	4501                	li	a0,0
ffffffffc02043f4:	70e2                	ld	ra,56(sp)
ffffffffc02043f6:	7442                	ld	s0,48(sp)
ffffffffc02043f8:	74a2                	ld	s1,40(sp)
ffffffffc02043fa:	7902                	ld	s2,32(sp)
ffffffffc02043fc:	69e2                	ld	s3,24(sp)
ffffffffc02043fe:	6a42                	ld	s4,16(sp)
ffffffffc0204400:	6aa2                	ld	s5,8(sp)
ffffffffc0204402:	6121                	addi	sp,sp,64
ffffffffc0204404:	8082                	ret
ffffffffc0204406:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc020440a:	06c070ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020440e:	4505                	li	a0,1
ffffffffc0204410:	b7d5                	j	ffffffffc02043f4 <copy_string+0x68>

ffffffffc0204412 <__down.constprop.0>:
ffffffffc0204412:	715d                	addi	sp,sp,-80
ffffffffc0204414:	e0a2                	sd	s0,64(sp)
ffffffffc0204416:	e486                	sd	ra,72(sp)
ffffffffc0204418:	fc26                	sd	s1,56(sp)
ffffffffc020441a:	842a                	mv	s0,a0
ffffffffc020441c:	100027f3          	csrr	a5,sstatus
ffffffffc0204420:	8b89                	andi	a5,a5,2
ffffffffc0204422:	ebb1                	bnez	a5,ffffffffc0204476 <__down.constprop.0+0x64>
ffffffffc0204424:	411c                	lw	a5,0(a0)
ffffffffc0204426:	00f05a63          	blez	a5,ffffffffc020443a <__down.constprop.0+0x28>
ffffffffc020442a:	37fd                	addiw	a5,a5,-1
ffffffffc020442c:	c11c                	sw	a5,0(a0)
ffffffffc020442e:	4501                	li	a0,0
ffffffffc0204430:	60a6                	ld	ra,72(sp)
ffffffffc0204432:	6406                	ld	s0,64(sp)
ffffffffc0204434:	74e2                	ld	s1,56(sp)
ffffffffc0204436:	6161                	addi	sp,sp,80
ffffffffc0204438:	8082                	ret
ffffffffc020443a:	00850413          	addi	s0,a0,8 # ffffffffc8000008 <end+0x7d696f8>
ffffffffc020443e:	0024                	addi	s1,sp,8
ffffffffc0204440:	10000613          	li	a2,256
ffffffffc0204444:	85a6                	mv	a1,s1
ffffffffc0204446:	8522                	mv	a0,s0
ffffffffc0204448:	2d8000ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc020444c:	66d020ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc0204450:	100027f3          	csrr	a5,sstatus
ffffffffc0204454:	8b89                	andi	a5,a5,2
ffffffffc0204456:	efb9                	bnez	a5,ffffffffc02044b4 <__down.constprop.0+0xa2>
ffffffffc0204458:	8526                	mv	a0,s1
ffffffffc020445a:	19c000ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc020445e:	e531                	bnez	a0,ffffffffc02044aa <__down.constprop.0+0x98>
ffffffffc0204460:	4542                	lw	a0,16(sp)
ffffffffc0204462:	10000793          	li	a5,256
ffffffffc0204466:	fcf515e3          	bne	a0,a5,ffffffffc0204430 <__down.constprop.0+0x1e>
ffffffffc020446a:	60a6                	ld	ra,72(sp)
ffffffffc020446c:	6406                	ld	s0,64(sp)
ffffffffc020446e:	74e2                	ld	s1,56(sp)
ffffffffc0204470:	4501                	li	a0,0
ffffffffc0204472:	6161                	addi	sp,sp,80
ffffffffc0204474:	8082                	ret
ffffffffc0204476:	ffcfc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020447a:	401c                	lw	a5,0(s0)
ffffffffc020447c:	00f05c63          	blez	a5,ffffffffc0204494 <__down.constprop.0+0x82>
ffffffffc0204480:	37fd                	addiw	a5,a5,-1
ffffffffc0204482:	c01c                	sw	a5,0(s0)
ffffffffc0204484:	fe8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204488:	60a6                	ld	ra,72(sp)
ffffffffc020448a:	6406                	ld	s0,64(sp)
ffffffffc020448c:	74e2                	ld	s1,56(sp)
ffffffffc020448e:	4501                	li	a0,0
ffffffffc0204490:	6161                	addi	sp,sp,80
ffffffffc0204492:	8082                	ret
ffffffffc0204494:	0421                	addi	s0,s0,8
ffffffffc0204496:	0024                	addi	s1,sp,8
ffffffffc0204498:	10000613          	li	a2,256
ffffffffc020449c:	85a6                	mv	a1,s1
ffffffffc020449e:	8522                	mv	a0,s0
ffffffffc02044a0:	280000ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc02044a4:	fc8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02044a8:	b755                	j	ffffffffc020444c <__down.constprop.0+0x3a>
ffffffffc02044aa:	85a6                	mv	a1,s1
ffffffffc02044ac:	8522                	mv	a0,s0
ffffffffc02044ae:	0ee000ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc02044b2:	b77d                	j	ffffffffc0204460 <__down.constprop.0+0x4e>
ffffffffc02044b4:	fbefc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02044b8:	8526                	mv	a0,s1
ffffffffc02044ba:	13c000ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc02044be:	e501                	bnez	a0,ffffffffc02044c6 <__down.constprop.0+0xb4>
ffffffffc02044c0:	facfc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02044c4:	bf71                	j	ffffffffc0204460 <__down.constprop.0+0x4e>
ffffffffc02044c6:	85a6                	mv	a1,s1
ffffffffc02044c8:	8522                	mv	a0,s0
ffffffffc02044ca:	0d2000ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc02044ce:	bfcd                	j	ffffffffc02044c0 <__down.constprop.0+0xae>

ffffffffc02044d0 <__up.constprop.0>:
ffffffffc02044d0:	1101                	addi	sp,sp,-32
ffffffffc02044d2:	e822                	sd	s0,16(sp)
ffffffffc02044d4:	ec06                	sd	ra,24(sp)
ffffffffc02044d6:	e426                	sd	s1,8(sp)
ffffffffc02044d8:	e04a                	sd	s2,0(sp)
ffffffffc02044da:	842a                	mv	s0,a0
ffffffffc02044dc:	100027f3          	csrr	a5,sstatus
ffffffffc02044e0:	8b89                	andi	a5,a5,2
ffffffffc02044e2:	4901                	li	s2,0
ffffffffc02044e4:	eba1                	bnez	a5,ffffffffc0204534 <__up.constprop.0+0x64>
ffffffffc02044e6:	00840493          	addi	s1,s0,8
ffffffffc02044ea:	8526                	mv	a0,s1
ffffffffc02044ec:	0ee000ef          	jal	ra,ffffffffc02045da <wait_queue_first>
ffffffffc02044f0:	85aa                	mv	a1,a0
ffffffffc02044f2:	cd0d                	beqz	a0,ffffffffc020452c <__up.constprop.0+0x5c>
ffffffffc02044f4:	6118                	ld	a4,0(a0)
ffffffffc02044f6:	10000793          	li	a5,256
ffffffffc02044fa:	0ec72703          	lw	a4,236(a4)
ffffffffc02044fe:	02f71f63          	bne	a4,a5,ffffffffc020453c <__up.constprop.0+0x6c>
ffffffffc0204502:	4685                	li	a3,1
ffffffffc0204504:	10000613          	li	a2,256
ffffffffc0204508:	8526                	mv	a0,s1
ffffffffc020450a:	0fa000ef          	jal	ra,ffffffffc0204604 <wakeup_wait>
ffffffffc020450e:	00091863          	bnez	s2,ffffffffc020451e <__up.constprop.0+0x4e>
ffffffffc0204512:	60e2                	ld	ra,24(sp)
ffffffffc0204514:	6442                	ld	s0,16(sp)
ffffffffc0204516:	64a2                	ld	s1,8(sp)
ffffffffc0204518:	6902                	ld	s2,0(sp)
ffffffffc020451a:	6105                	addi	sp,sp,32
ffffffffc020451c:	8082                	ret
ffffffffc020451e:	6442                	ld	s0,16(sp)
ffffffffc0204520:	60e2                	ld	ra,24(sp)
ffffffffc0204522:	64a2                	ld	s1,8(sp)
ffffffffc0204524:	6902                	ld	s2,0(sp)
ffffffffc0204526:	6105                	addi	sp,sp,32
ffffffffc0204528:	f44fc06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020452c:	401c                	lw	a5,0(s0)
ffffffffc020452e:	2785                	addiw	a5,a5,1
ffffffffc0204530:	c01c                	sw	a5,0(s0)
ffffffffc0204532:	bff1                	j	ffffffffc020450e <__up.constprop.0+0x3e>
ffffffffc0204534:	f3efc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0204538:	4905                	li	s2,1
ffffffffc020453a:	b775                	j	ffffffffc02044e6 <__up.constprop.0+0x16>
ffffffffc020453c:	00009697          	auipc	a3,0x9
ffffffffc0204540:	95468693          	addi	a3,a3,-1708 # ffffffffc020ce90 <default_pmm_manager+0xaa0>
ffffffffc0204544:	00007617          	auipc	a2,0x7
ffffffffc0204548:	3c460613          	addi	a2,a2,964 # ffffffffc020b908 <commands+0x210>
ffffffffc020454c:	45e5                	li	a1,25
ffffffffc020454e:	00009517          	auipc	a0,0x9
ffffffffc0204552:	96a50513          	addi	a0,a0,-1686 # ffffffffc020ceb8 <default_pmm_manager+0xac8>
ffffffffc0204556:	f49fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020455a <sem_init>:
ffffffffc020455a:	c10c                	sw	a1,0(a0)
ffffffffc020455c:	0521                	addi	a0,a0,8
ffffffffc020455e:	a825                	j	ffffffffc0204596 <wait_queue_init>

ffffffffc0204560 <up>:
ffffffffc0204560:	f71ff06f          	j	ffffffffc02044d0 <__up.constprop.0>

ffffffffc0204564 <down>:
ffffffffc0204564:	1141                	addi	sp,sp,-16
ffffffffc0204566:	e406                	sd	ra,8(sp)
ffffffffc0204568:	eabff0ef          	jal	ra,ffffffffc0204412 <__down.constprop.0>
ffffffffc020456c:	2501                	sext.w	a0,a0
ffffffffc020456e:	e501                	bnez	a0,ffffffffc0204576 <down+0x12>
ffffffffc0204570:	60a2                	ld	ra,8(sp)
ffffffffc0204572:	0141                	addi	sp,sp,16
ffffffffc0204574:	8082                	ret
ffffffffc0204576:	00009697          	auipc	a3,0x9
ffffffffc020457a:	95268693          	addi	a3,a3,-1710 # ffffffffc020cec8 <default_pmm_manager+0xad8>
ffffffffc020457e:	00007617          	auipc	a2,0x7
ffffffffc0204582:	38a60613          	addi	a2,a2,906 # ffffffffc020b908 <commands+0x210>
ffffffffc0204586:	04000593          	li	a1,64
ffffffffc020458a:	00009517          	auipc	a0,0x9
ffffffffc020458e:	92e50513          	addi	a0,a0,-1746 # ffffffffc020ceb8 <default_pmm_manager+0xac8>
ffffffffc0204592:	f0dfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204596 <wait_queue_init>:
ffffffffc0204596:	e508                	sd	a0,8(a0)
ffffffffc0204598:	e108                	sd	a0,0(a0)
ffffffffc020459a:	8082                	ret

ffffffffc020459c <wait_queue_del>:
ffffffffc020459c:	7198                	ld	a4,32(a1)
ffffffffc020459e:	01858793          	addi	a5,a1,24
ffffffffc02045a2:	00e78b63          	beq	a5,a4,ffffffffc02045b8 <wait_queue_del+0x1c>
ffffffffc02045a6:	6994                	ld	a3,16(a1)
ffffffffc02045a8:	00a69863          	bne	a3,a0,ffffffffc02045b8 <wait_queue_del+0x1c>
ffffffffc02045ac:	6d94                	ld	a3,24(a1)
ffffffffc02045ae:	e698                	sd	a4,8(a3)
ffffffffc02045b0:	e314                	sd	a3,0(a4)
ffffffffc02045b2:	f19c                	sd	a5,32(a1)
ffffffffc02045b4:	ed9c                	sd	a5,24(a1)
ffffffffc02045b6:	8082                	ret
ffffffffc02045b8:	1141                	addi	sp,sp,-16
ffffffffc02045ba:	00009697          	auipc	a3,0x9
ffffffffc02045be:	96e68693          	addi	a3,a3,-1682 # ffffffffc020cf28 <default_pmm_manager+0xb38>
ffffffffc02045c2:	00007617          	auipc	a2,0x7
ffffffffc02045c6:	34660613          	addi	a2,a2,838 # ffffffffc020b908 <commands+0x210>
ffffffffc02045ca:	45f1                	li	a1,28
ffffffffc02045cc:	00009517          	auipc	a0,0x9
ffffffffc02045d0:	94450513          	addi	a0,a0,-1724 # ffffffffc020cf10 <default_pmm_manager+0xb20>
ffffffffc02045d4:	e406                	sd	ra,8(sp)
ffffffffc02045d6:	ec9fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02045da <wait_queue_first>:
ffffffffc02045da:	651c                	ld	a5,8(a0)
ffffffffc02045dc:	00f50563          	beq	a0,a5,ffffffffc02045e6 <wait_queue_first+0xc>
ffffffffc02045e0:	fe878513          	addi	a0,a5,-24
ffffffffc02045e4:	8082                	ret
ffffffffc02045e6:	4501                	li	a0,0
ffffffffc02045e8:	8082                	ret

ffffffffc02045ea <wait_queue_empty>:
ffffffffc02045ea:	651c                	ld	a5,8(a0)
ffffffffc02045ec:	40a78533          	sub	a0,a5,a0
ffffffffc02045f0:	00153513          	seqz	a0,a0
ffffffffc02045f4:	8082                	ret

ffffffffc02045f6 <wait_in_queue>:
ffffffffc02045f6:	711c                	ld	a5,32(a0)
ffffffffc02045f8:	0561                	addi	a0,a0,24
ffffffffc02045fa:	40a78533          	sub	a0,a5,a0
ffffffffc02045fe:	00a03533          	snez	a0,a0
ffffffffc0204602:	8082                	ret

ffffffffc0204604 <wakeup_wait>:
ffffffffc0204604:	e689                	bnez	a3,ffffffffc020460e <wakeup_wait+0xa>
ffffffffc0204606:	6188                	ld	a0,0(a1)
ffffffffc0204608:	c590                	sw	a2,8(a1)
ffffffffc020460a:	3fd0206f          	j	ffffffffc0207206 <wakeup_proc>
ffffffffc020460e:	7198                	ld	a4,32(a1)
ffffffffc0204610:	01858793          	addi	a5,a1,24
ffffffffc0204614:	00e78e63          	beq	a5,a4,ffffffffc0204630 <wakeup_wait+0x2c>
ffffffffc0204618:	6994                	ld	a3,16(a1)
ffffffffc020461a:	00d51b63          	bne	a0,a3,ffffffffc0204630 <wakeup_wait+0x2c>
ffffffffc020461e:	6d94                	ld	a3,24(a1)
ffffffffc0204620:	6188                	ld	a0,0(a1)
ffffffffc0204622:	e698                	sd	a4,8(a3)
ffffffffc0204624:	e314                	sd	a3,0(a4)
ffffffffc0204626:	f19c                	sd	a5,32(a1)
ffffffffc0204628:	ed9c                	sd	a5,24(a1)
ffffffffc020462a:	c590                	sw	a2,8(a1)
ffffffffc020462c:	3db0206f          	j	ffffffffc0207206 <wakeup_proc>
ffffffffc0204630:	1141                	addi	sp,sp,-16
ffffffffc0204632:	00009697          	auipc	a3,0x9
ffffffffc0204636:	8f668693          	addi	a3,a3,-1802 # ffffffffc020cf28 <default_pmm_manager+0xb38>
ffffffffc020463a:	00007617          	auipc	a2,0x7
ffffffffc020463e:	2ce60613          	addi	a2,a2,718 # ffffffffc020b908 <commands+0x210>
ffffffffc0204642:	45f1                	li	a1,28
ffffffffc0204644:	00009517          	auipc	a0,0x9
ffffffffc0204648:	8cc50513          	addi	a0,a0,-1844 # ffffffffc020cf10 <default_pmm_manager+0xb20>
ffffffffc020464c:	e406                	sd	ra,8(sp)
ffffffffc020464e:	e51fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204652 <wakeup_queue>:
ffffffffc0204652:	651c                	ld	a5,8(a0)
ffffffffc0204654:	0ca78563          	beq	a5,a0,ffffffffc020471e <wakeup_queue+0xcc>
ffffffffc0204658:	1101                	addi	sp,sp,-32
ffffffffc020465a:	e822                	sd	s0,16(sp)
ffffffffc020465c:	e426                	sd	s1,8(sp)
ffffffffc020465e:	e04a                	sd	s2,0(sp)
ffffffffc0204660:	ec06                	sd	ra,24(sp)
ffffffffc0204662:	84aa                	mv	s1,a0
ffffffffc0204664:	892e                	mv	s2,a1
ffffffffc0204666:	fe878413          	addi	s0,a5,-24
ffffffffc020466a:	e23d                	bnez	a2,ffffffffc02046d0 <wakeup_queue+0x7e>
ffffffffc020466c:	6008                	ld	a0,0(s0)
ffffffffc020466e:	01242423          	sw	s2,8(s0)
ffffffffc0204672:	395020ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc0204676:	701c                	ld	a5,32(s0)
ffffffffc0204678:	01840713          	addi	a4,s0,24
ffffffffc020467c:	02e78463          	beq	a5,a4,ffffffffc02046a4 <wakeup_queue+0x52>
ffffffffc0204680:	6818                	ld	a4,16(s0)
ffffffffc0204682:	02e49163          	bne	s1,a4,ffffffffc02046a4 <wakeup_queue+0x52>
ffffffffc0204686:	02f48f63          	beq	s1,a5,ffffffffc02046c4 <wakeup_queue+0x72>
ffffffffc020468a:	fe87b503          	ld	a0,-24(a5)
ffffffffc020468e:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204692:	fe878413          	addi	s0,a5,-24
ffffffffc0204696:	371020ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc020469a:	701c                	ld	a5,32(s0)
ffffffffc020469c:	01840713          	addi	a4,s0,24
ffffffffc02046a0:	fee790e3          	bne	a5,a4,ffffffffc0204680 <wakeup_queue+0x2e>
ffffffffc02046a4:	00009697          	auipc	a3,0x9
ffffffffc02046a8:	88468693          	addi	a3,a3,-1916 # ffffffffc020cf28 <default_pmm_manager+0xb38>
ffffffffc02046ac:	00007617          	auipc	a2,0x7
ffffffffc02046b0:	25c60613          	addi	a2,a2,604 # ffffffffc020b908 <commands+0x210>
ffffffffc02046b4:	02200593          	li	a1,34
ffffffffc02046b8:	00009517          	auipc	a0,0x9
ffffffffc02046bc:	85850513          	addi	a0,a0,-1960 # ffffffffc020cf10 <default_pmm_manager+0xb20>
ffffffffc02046c0:	ddffb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02046c4:	60e2                	ld	ra,24(sp)
ffffffffc02046c6:	6442                	ld	s0,16(sp)
ffffffffc02046c8:	64a2                	ld	s1,8(sp)
ffffffffc02046ca:	6902                	ld	s2,0(sp)
ffffffffc02046cc:	6105                	addi	sp,sp,32
ffffffffc02046ce:	8082                	ret
ffffffffc02046d0:	6798                	ld	a4,8(a5)
ffffffffc02046d2:	02f70763          	beq	a4,a5,ffffffffc0204700 <wakeup_queue+0xae>
ffffffffc02046d6:	6814                	ld	a3,16(s0)
ffffffffc02046d8:	02d49463          	bne	s1,a3,ffffffffc0204700 <wakeup_queue+0xae>
ffffffffc02046dc:	6c14                	ld	a3,24(s0)
ffffffffc02046de:	6008                	ld	a0,0(s0)
ffffffffc02046e0:	e698                	sd	a4,8(a3)
ffffffffc02046e2:	e314                	sd	a3,0(a4)
ffffffffc02046e4:	f01c                	sd	a5,32(s0)
ffffffffc02046e6:	ec1c                	sd	a5,24(s0)
ffffffffc02046e8:	01242423          	sw	s2,8(s0)
ffffffffc02046ec:	31b020ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc02046f0:	6480                	ld	s0,8(s1)
ffffffffc02046f2:	fc8489e3          	beq	s1,s0,ffffffffc02046c4 <wakeup_queue+0x72>
ffffffffc02046f6:	6418                	ld	a4,8(s0)
ffffffffc02046f8:	87a2                	mv	a5,s0
ffffffffc02046fa:	1421                	addi	s0,s0,-24
ffffffffc02046fc:	fce79de3          	bne	a5,a4,ffffffffc02046d6 <wakeup_queue+0x84>
ffffffffc0204700:	00009697          	auipc	a3,0x9
ffffffffc0204704:	82868693          	addi	a3,a3,-2008 # ffffffffc020cf28 <default_pmm_manager+0xb38>
ffffffffc0204708:	00007617          	auipc	a2,0x7
ffffffffc020470c:	20060613          	addi	a2,a2,512 # ffffffffc020b908 <commands+0x210>
ffffffffc0204710:	45f1                	li	a1,28
ffffffffc0204712:	00008517          	auipc	a0,0x8
ffffffffc0204716:	7fe50513          	addi	a0,a0,2046 # ffffffffc020cf10 <default_pmm_manager+0xb20>
ffffffffc020471a:	d85fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020471e:	8082                	ret

ffffffffc0204720 <wait_current_set>:
ffffffffc0204720:	00092797          	auipc	a5,0x92
ffffffffc0204724:	1a07b783          	ld	a5,416(a5) # ffffffffc02968c0 <current>
ffffffffc0204728:	c39d                	beqz	a5,ffffffffc020474e <wait_current_set+0x2e>
ffffffffc020472a:	01858713          	addi	a4,a1,24
ffffffffc020472e:	800006b7          	lui	a3,0x80000
ffffffffc0204732:	ed98                	sd	a4,24(a1)
ffffffffc0204734:	e19c                	sd	a5,0(a1)
ffffffffc0204736:	c594                	sw	a3,8(a1)
ffffffffc0204738:	4685                	li	a3,1
ffffffffc020473a:	c394                	sw	a3,0(a5)
ffffffffc020473c:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204740:	611c                	ld	a5,0(a0)
ffffffffc0204742:	e988                	sd	a0,16(a1)
ffffffffc0204744:	e118                	sd	a4,0(a0)
ffffffffc0204746:	e798                	sd	a4,8(a5)
ffffffffc0204748:	f188                	sd	a0,32(a1)
ffffffffc020474a:	ed9c                	sd	a5,24(a1)
ffffffffc020474c:	8082                	ret
ffffffffc020474e:	1141                	addi	sp,sp,-16
ffffffffc0204750:	00009697          	auipc	a3,0x9
ffffffffc0204754:	81868693          	addi	a3,a3,-2024 # ffffffffc020cf68 <default_pmm_manager+0xb78>
ffffffffc0204758:	00007617          	auipc	a2,0x7
ffffffffc020475c:	1b060613          	addi	a2,a2,432 # ffffffffc020b908 <commands+0x210>
ffffffffc0204760:	07400593          	li	a1,116
ffffffffc0204764:	00008517          	auipc	a0,0x8
ffffffffc0204768:	7ac50513          	addi	a0,a0,1964 # ffffffffc020cf10 <default_pmm_manager+0xb20>
ffffffffc020476c:	e406                	sd	ra,8(sp)
ffffffffc020476e:	d31fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204772 <get_fd_array.part.0>:
ffffffffc0204772:	1141                	addi	sp,sp,-16
ffffffffc0204774:	00009697          	auipc	a3,0x9
ffffffffc0204778:	80468693          	addi	a3,a3,-2044 # ffffffffc020cf78 <default_pmm_manager+0xb88>
ffffffffc020477c:	00007617          	auipc	a2,0x7
ffffffffc0204780:	18c60613          	addi	a2,a2,396 # ffffffffc020b908 <commands+0x210>
ffffffffc0204784:	45d1                	li	a1,20
ffffffffc0204786:	00009517          	auipc	a0,0x9
ffffffffc020478a:	82250513          	addi	a0,a0,-2014 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc020478e:	e406                	sd	ra,8(sp)
ffffffffc0204790:	d0ffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204794 <fd_array_alloc>:
ffffffffc0204794:	00092797          	auipc	a5,0x92
ffffffffc0204798:	12c7b783          	ld	a5,300(a5) # ffffffffc02968c0 <current>
ffffffffc020479c:	1487b783          	ld	a5,328(a5)
ffffffffc02047a0:	1141                	addi	sp,sp,-16
ffffffffc02047a2:	e406                	sd	ra,8(sp)
ffffffffc02047a4:	c3a5                	beqz	a5,ffffffffc0204804 <fd_array_alloc+0x70>
ffffffffc02047a6:	4b98                	lw	a4,16(a5)
ffffffffc02047a8:	04e05e63          	blez	a4,ffffffffc0204804 <fd_array_alloc+0x70>
ffffffffc02047ac:	775d                	lui	a4,0xffff7
ffffffffc02047ae:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02047b2:	679c                	ld	a5,8(a5)
ffffffffc02047b4:	02e50863          	beq	a0,a4,ffffffffc02047e4 <fd_array_alloc+0x50>
ffffffffc02047b8:	04700713          	li	a4,71
ffffffffc02047bc:	04a76263          	bltu	a4,a0,ffffffffc0204800 <fd_array_alloc+0x6c>
ffffffffc02047c0:	00351713          	slli	a4,a0,0x3
ffffffffc02047c4:	40a70533          	sub	a0,a4,a0
ffffffffc02047c8:	050e                	slli	a0,a0,0x3
ffffffffc02047ca:	97aa                	add	a5,a5,a0
ffffffffc02047cc:	4398                	lw	a4,0(a5)
ffffffffc02047ce:	e71d                	bnez	a4,ffffffffc02047fc <fd_array_alloc+0x68>
ffffffffc02047d0:	5b88                	lw	a0,48(a5)
ffffffffc02047d2:	e91d                	bnez	a0,ffffffffc0204808 <fd_array_alloc+0x74>
ffffffffc02047d4:	4705                	li	a4,1
ffffffffc02047d6:	c398                	sw	a4,0(a5)
ffffffffc02047d8:	0207b423          	sd	zero,40(a5)
ffffffffc02047dc:	e19c                	sd	a5,0(a1)
ffffffffc02047de:	60a2                	ld	ra,8(sp)
ffffffffc02047e0:	0141                	addi	sp,sp,16
ffffffffc02047e2:	8082                	ret
ffffffffc02047e4:	6685                	lui	a3,0x1
ffffffffc02047e6:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02047ea:	96be                	add	a3,a3,a5
ffffffffc02047ec:	4398                	lw	a4,0(a5)
ffffffffc02047ee:	d36d                	beqz	a4,ffffffffc02047d0 <fd_array_alloc+0x3c>
ffffffffc02047f0:	03878793          	addi	a5,a5,56
ffffffffc02047f4:	fef69ce3          	bne	a3,a5,ffffffffc02047ec <fd_array_alloc+0x58>
ffffffffc02047f8:	5529                	li	a0,-22
ffffffffc02047fa:	b7d5                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc02047fc:	5545                	li	a0,-15
ffffffffc02047fe:	b7c5                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc0204800:	5575                	li	a0,-3
ffffffffc0204802:	bff1                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc0204804:	f6fff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204808:	00008697          	auipc	a3,0x8
ffffffffc020480c:	7b068693          	addi	a3,a3,1968 # ffffffffc020cfb8 <default_pmm_manager+0xbc8>
ffffffffc0204810:	00007617          	auipc	a2,0x7
ffffffffc0204814:	0f860613          	addi	a2,a2,248 # ffffffffc020b908 <commands+0x210>
ffffffffc0204818:	03b00593          	li	a1,59
ffffffffc020481c:	00008517          	auipc	a0,0x8
ffffffffc0204820:	78c50513          	addi	a0,a0,1932 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204824:	c7bfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204828 <fd_array_free>:
ffffffffc0204828:	411c                	lw	a5,0(a0)
ffffffffc020482a:	1141                	addi	sp,sp,-16
ffffffffc020482c:	e022                	sd	s0,0(sp)
ffffffffc020482e:	e406                	sd	ra,8(sp)
ffffffffc0204830:	4705                	li	a4,1
ffffffffc0204832:	842a                	mv	s0,a0
ffffffffc0204834:	04e78063          	beq	a5,a4,ffffffffc0204874 <fd_array_free+0x4c>
ffffffffc0204838:	470d                	li	a4,3
ffffffffc020483a:	04e79563          	bne	a5,a4,ffffffffc0204884 <fd_array_free+0x5c>
ffffffffc020483e:	591c                	lw	a5,48(a0)
ffffffffc0204840:	c38d                	beqz	a5,ffffffffc0204862 <fd_array_free+0x3a>
ffffffffc0204842:	00008697          	auipc	a3,0x8
ffffffffc0204846:	77668693          	addi	a3,a3,1910 # ffffffffc020cfb8 <default_pmm_manager+0xbc8>
ffffffffc020484a:	00007617          	auipc	a2,0x7
ffffffffc020484e:	0be60613          	addi	a2,a2,190 # ffffffffc020b908 <commands+0x210>
ffffffffc0204852:	04500593          	li	a1,69
ffffffffc0204856:	00008517          	auipc	a0,0x8
ffffffffc020485a:	75250513          	addi	a0,a0,1874 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc020485e:	c41fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204862:	7408                	ld	a0,40(s0)
ffffffffc0204864:	019030ef          	jal	ra,ffffffffc020807c <vfs_close>
ffffffffc0204868:	60a2                	ld	ra,8(sp)
ffffffffc020486a:	00042023          	sw	zero,0(s0)
ffffffffc020486e:	6402                	ld	s0,0(sp)
ffffffffc0204870:	0141                	addi	sp,sp,16
ffffffffc0204872:	8082                	ret
ffffffffc0204874:	591c                	lw	a5,48(a0)
ffffffffc0204876:	f7f1                	bnez	a5,ffffffffc0204842 <fd_array_free+0x1a>
ffffffffc0204878:	60a2                	ld	ra,8(sp)
ffffffffc020487a:	00042023          	sw	zero,0(s0)
ffffffffc020487e:	6402                	ld	s0,0(sp)
ffffffffc0204880:	0141                	addi	sp,sp,16
ffffffffc0204882:	8082                	ret
ffffffffc0204884:	00008697          	auipc	a3,0x8
ffffffffc0204888:	76c68693          	addi	a3,a3,1900 # ffffffffc020cff0 <default_pmm_manager+0xc00>
ffffffffc020488c:	00007617          	auipc	a2,0x7
ffffffffc0204890:	07c60613          	addi	a2,a2,124 # ffffffffc020b908 <commands+0x210>
ffffffffc0204894:	04400593          	li	a1,68
ffffffffc0204898:	00008517          	auipc	a0,0x8
ffffffffc020489c:	71050513          	addi	a0,a0,1808 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc02048a0:	bfffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02048a4 <fd_array_release>:
ffffffffc02048a4:	4118                	lw	a4,0(a0)
ffffffffc02048a6:	1141                	addi	sp,sp,-16
ffffffffc02048a8:	e406                	sd	ra,8(sp)
ffffffffc02048aa:	4685                	li	a3,1
ffffffffc02048ac:	3779                	addiw	a4,a4,-2
ffffffffc02048ae:	04e6e063          	bltu	a3,a4,ffffffffc02048ee <fd_array_release+0x4a>
ffffffffc02048b2:	5918                	lw	a4,48(a0)
ffffffffc02048b4:	00e05d63          	blez	a4,ffffffffc02048ce <fd_array_release+0x2a>
ffffffffc02048b8:	fff7069b          	addiw	a3,a4,-1
ffffffffc02048bc:	d914                	sw	a3,48(a0)
ffffffffc02048be:	c681                	beqz	a3,ffffffffc02048c6 <fd_array_release+0x22>
ffffffffc02048c0:	60a2                	ld	ra,8(sp)
ffffffffc02048c2:	0141                	addi	sp,sp,16
ffffffffc02048c4:	8082                	ret
ffffffffc02048c6:	60a2                	ld	ra,8(sp)
ffffffffc02048c8:	0141                	addi	sp,sp,16
ffffffffc02048ca:	f5fff06f          	j	ffffffffc0204828 <fd_array_free>
ffffffffc02048ce:	00008697          	auipc	a3,0x8
ffffffffc02048d2:	79268693          	addi	a3,a3,1938 # ffffffffc020d060 <default_pmm_manager+0xc70>
ffffffffc02048d6:	00007617          	auipc	a2,0x7
ffffffffc02048da:	03260613          	addi	a2,a2,50 # ffffffffc020b908 <commands+0x210>
ffffffffc02048de:	05600593          	li	a1,86
ffffffffc02048e2:	00008517          	auipc	a0,0x8
ffffffffc02048e6:	6c650513          	addi	a0,a0,1734 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc02048ea:	bb5fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02048ee:	00008697          	auipc	a3,0x8
ffffffffc02048f2:	73a68693          	addi	a3,a3,1850 # ffffffffc020d028 <default_pmm_manager+0xc38>
ffffffffc02048f6:	00007617          	auipc	a2,0x7
ffffffffc02048fa:	01260613          	addi	a2,a2,18 # ffffffffc020b908 <commands+0x210>
ffffffffc02048fe:	05500593          	li	a1,85
ffffffffc0204902:	00008517          	auipc	a0,0x8
ffffffffc0204906:	6a650513          	addi	a0,a0,1702 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc020490a:	b95fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020490e <fd_array_open.part.0>:
ffffffffc020490e:	1141                	addi	sp,sp,-16
ffffffffc0204910:	00008697          	auipc	a3,0x8
ffffffffc0204914:	76868693          	addi	a3,a3,1896 # ffffffffc020d078 <default_pmm_manager+0xc88>
ffffffffc0204918:	00007617          	auipc	a2,0x7
ffffffffc020491c:	ff060613          	addi	a2,a2,-16 # ffffffffc020b908 <commands+0x210>
ffffffffc0204920:	05f00593          	li	a1,95
ffffffffc0204924:	00008517          	auipc	a0,0x8
ffffffffc0204928:	68450513          	addi	a0,a0,1668 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc020492c:	e406                	sd	ra,8(sp)
ffffffffc020492e:	b71fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204932 <fd_array_init>:
ffffffffc0204932:	4781                	li	a5,0
ffffffffc0204934:	04800713          	li	a4,72
ffffffffc0204938:	cd1c                	sw	a5,24(a0)
ffffffffc020493a:	02052823          	sw	zero,48(a0)
ffffffffc020493e:	00052023          	sw	zero,0(a0)
ffffffffc0204942:	2785                	addiw	a5,a5,1
ffffffffc0204944:	03850513          	addi	a0,a0,56
ffffffffc0204948:	fee798e3          	bne	a5,a4,ffffffffc0204938 <fd_array_init+0x6>
ffffffffc020494c:	8082                	ret

ffffffffc020494e <fd_array_close>:
ffffffffc020494e:	4118                	lw	a4,0(a0)
ffffffffc0204950:	1141                	addi	sp,sp,-16
ffffffffc0204952:	e406                	sd	ra,8(sp)
ffffffffc0204954:	e022                	sd	s0,0(sp)
ffffffffc0204956:	4789                	li	a5,2
ffffffffc0204958:	04f71a63          	bne	a4,a5,ffffffffc02049ac <fd_array_close+0x5e>
ffffffffc020495c:	591c                	lw	a5,48(a0)
ffffffffc020495e:	842a                	mv	s0,a0
ffffffffc0204960:	02f05663          	blez	a5,ffffffffc020498c <fd_array_close+0x3e>
ffffffffc0204964:	37fd                	addiw	a5,a5,-1
ffffffffc0204966:	470d                	li	a4,3
ffffffffc0204968:	c118                	sw	a4,0(a0)
ffffffffc020496a:	d91c                	sw	a5,48(a0)
ffffffffc020496c:	0007871b          	sext.w	a4,a5
ffffffffc0204970:	c709                	beqz	a4,ffffffffc020497a <fd_array_close+0x2c>
ffffffffc0204972:	60a2                	ld	ra,8(sp)
ffffffffc0204974:	6402                	ld	s0,0(sp)
ffffffffc0204976:	0141                	addi	sp,sp,16
ffffffffc0204978:	8082                	ret
ffffffffc020497a:	7508                	ld	a0,40(a0)
ffffffffc020497c:	700030ef          	jal	ra,ffffffffc020807c <vfs_close>
ffffffffc0204980:	60a2                	ld	ra,8(sp)
ffffffffc0204982:	00042023          	sw	zero,0(s0)
ffffffffc0204986:	6402                	ld	s0,0(sp)
ffffffffc0204988:	0141                	addi	sp,sp,16
ffffffffc020498a:	8082                	ret
ffffffffc020498c:	00008697          	auipc	a3,0x8
ffffffffc0204990:	6d468693          	addi	a3,a3,1748 # ffffffffc020d060 <default_pmm_manager+0xc70>
ffffffffc0204994:	00007617          	auipc	a2,0x7
ffffffffc0204998:	f7460613          	addi	a2,a2,-140 # ffffffffc020b908 <commands+0x210>
ffffffffc020499c:	06800593          	li	a1,104
ffffffffc02049a0:	00008517          	auipc	a0,0x8
ffffffffc02049a4:	60850513          	addi	a0,a0,1544 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc02049a8:	af7fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02049ac:	00008697          	auipc	a3,0x8
ffffffffc02049b0:	62468693          	addi	a3,a3,1572 # ffffffffc020cfd0 <default_pmm_manager+0xbe0>
ffffffffc02049b4:	00007617          	auipc	a2,0x7
ffffffffc02049b8:	f5460613          	addi	a2,a2,-172 # ffffffffc020b908 <commands+0x210>
ffffffffc02049bc:	06700593          	li	a1,103
ffffffffc02049c0:	00008517          	auipc	a0,0x8
ffffffffc02049c4:	5e850513          	addi	a0,a0,1512 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc02049c8:	ad7fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049cc <fd_array_dup>:
ffffffffc02049cc:	7179                	addi	sp,sp,-48
ffffffffc02049ce:	e84a                	sd	s2,16(sp)
ffffffffc02049d0:	00052903          	lw	s2,0(a0)
ffffffffc02049d4:	f406                	sd	ra,40(sp)
ffffffffc02049d6:	f022                	sd	s0,32(sp)
ffffffffc02049d8:	ec26                	sd	s1,24(sp)
ffffffffc02049da:	e44e                	sd	s3,8(sp)
ffffffffc02049dc:	4785                	li	a5,1
ffffffffc02049de:	04f91663          	bne	s2,a5,ffffffffc0204a2a <fd_array_dup+0x5e>
ffffffffc02049e2:	0005a983          	lw	s3,0(a1)
ffffffffc02049e6:	4789                	li	a5,2
ffffffffc02049e8:	04f99163          	bne	s3,a5,ffffffffc0204a2a <fd_array_dup+0x5e>
ffffffffc02049ec:	7584                	ld	s1,40(a1)
ffffffffc02049ee:	699c                	ld	a5,16(a1)
ffffffffc02049f0:	7194                	ld	a3,32(a1)
ffffffffc02049f2:	6598                	ld	a4,8(a1)
ffffffffc02049f4:	842a                	mv	s0,a0
ffffffffc02049f6:	e91c                	sd	a5,16(a0)
ffffffffc02049f8:	f114                	sd	a3,32(a0)
ffffffffc02049fa:	e518                	sd	a4,8(a0)
ffffffffc02049fc:	8526                	mv	a0,s1
ffffffffc02049fe:	5dd020ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0204a02:	8526                	mv	a0,s1
ffffffffc0204a04:	5e3020ef          	jal	ra,ffffffffc02077e6 <inode_open_inc>
ffffffffc0204a08:	401c                	lw	a5,0(s0)
ffffffffc0204a0a:	f404                	sd	s1,40(s0)
ffffffffc0204a0c:	03279f63          	bne	a5,s2,ffffffffc0204a4a <fd_array_dup+0x7e>
ffffffffc0204a10:	cc8d                	beqz	s1,ffffffffc0204a4a <fd_array_dup+0x7e>
ffffffffc0204a12:	581c                	lw	a5,48(s0)
ffffffffc0204a14:	01342023          	sw	s3,0(s0)
ffffffffc0204a18:	70a2                	ld	ra,40(sp)
ffffffffc0204a1a:	2785                	addiw	a5,a5,1
ffffffffc0204a1c:	d81c                	sw	a5,48(s0)
ffffffffc0204a1e:	7402                	ld	s0,32(sp)
ffffffffc0204a20:	64e2                	ld	s1,24(sp)
ffffffffc0204a22:	6942                	ld	s2,16(sp)
ffffffffc0204a24:	69a2                	ld	s3,8(sp)
ffffffffc0204a26:	6145                	addi	sp,sp,48
ffffffffc0204a28:	8082                	ret
ffffffffc0204a2a:	00008697          	auipc	a3,0x8
ffffffffc0204a2e:	67e68693          	addi	a3,a3,1662 # ffffffffc020d0a8 <default_pmm_manager+0xcb8>
ffffffffc0204a32:	00007617          	auipc	a2,0x7
ffffffffc0204a36:	ed660613          	addi	a2,a2,-298 # ffffffffc020b908 <commands+0x210>
ffffffffc0204a3a:	07300593          	li	a1,115
ffffffffc0204a3e:	00008517          	auipc	a0,0x8
ffffffffc0204a42:	56a50513          	addi	a0,a0,1386 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204a46:	a59fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204a4a:	ec5ff0ef          	jal	ra,ffffffffc020490e <fd_array_open.part.0>

ffffffffc0204a4e <file_testfd>:
ffffffffc0204a4e:	04700793          	li	a5,71
ffffffffc0204a52:	04a7e263          	bltu	a5,a0,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a56:	00092797          	auipc	a5,0x92
ffffffffc0204a5a:	e6a7b783          	ld	a5,-406(a5) # ffffffffc02968c0 <current>
ffffffffc0204a5e:	1487b783          	ld	a5,328(a5)
ffffffffc0204a62:	cf85                	beqz	a5,ffffffffc0204a9a <file_testfd+0x4c>
ffffffffc0204a64:	4b98                	lw	a4,16(a5)
ffffffffc0204a66:	02e05a63          	blez	a4,ffffffffc0204a9a <file_testfd+0x4c>
ffffffffc0204a6a:	6798                	ld	a4,8(a5)
ffffffffc0204a6c:	00351793          	slli	a5,a0,0x3
ffffffffc0204a70:	8f89                	sub	a5,a5,a0
ffffffffc0204a72:	078e                	slli	a5,a5,0x3
ffffffffc0204a74:	97ba                	add	a5,a5,a4
ffffffffc0204a76:	4394                	lw	a3,0(a5)
ffffffffc0204a78:	4709                	li	a4,2
ffffffffc0204a7a:	00e69e63          	bne	a3,a4,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a7e:	4f98                	lw	a4,24(a5)
ffffffffc0204a80:	00a71b63          	bne	a4,a0,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a84:	c199                	beqz	a1,ffffffffc0204a8a <file_testfd+0x3c>
ffffffffc0204a86:	6788                	ld	a0,8(a5)
ffffffffc0204a88:	c901                	beqz	a0,ffffffffc0204a98 <file_testfd+0x4a>
ffffffffc0204a8a:	4505                	li	a0,1
ffffffffc0204a8c:	c611                	beqz	a2,ffffffffc0204a98 <file_testfd+0x4a>
ffffffffc0204a8e:	6b88                	ld	a0,16(a5)
ffffffffc0204a90:	00a03533          	snez	a0,a0
ffffffffc0204a94:	8082                	ret
ffffffffc0204a96:	4501                	li	a0,0
ffffffffc0204a98:	8082                	ret
ffffffffc0204a9a:	1141                	addi	sp,sp,-16
ffffffffc0204a9c:	e406                	sd	ra,8(sp)
ffffffffc0204a9e:	cd5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204aa2 <file_open>:
ffffffffc0204aa2:	711d                	addi	sp,sp,-96
ffffffffc0204aa4:	ec86                	sd	ra,88(sp)
ffffffffc0204aa6:	e8a2                	sd	s0,80(sp)
ffffffffc0204aa8:	e4a6                	sd	s1,72(sp)
ffffffffc0204aaa:	e0ca                	sd	s2,64(sp)
ffffffffc0204aac:	fc4e                	sd	s3,56(sp)
ffffffffc0204aae:	f852                	sd	s4,48(sp)
ffffffffc0204ab0:	0035f793          	andi	a5,a1,3
ffffffffc0204ab4:	470d                	li	a4,3
ffffffffc0204ab6:	0ce78163          	beq	a5,a4,ffffffffc0204b78 <file_open+0xd6>
ffffffffc0204aba:	078e                	slli	a5,a5,0x3
ffffffffc0204abc:	00009717          	auipc	a4,0x9
ffffffffc0204ac0:	85c70713          	addi	a4,a4,-1956 # ffffffffc020d318 <CSWTCH.79>
ffffffffc0204ac4:	892a                	mv	s2,a0
ffffffffc0204ac6:	00009697          	auipc	a3,0x9
ffffffffc0204aca:	83a68693          	addi	a3,a3,-1990 # ffffffffc020d300 <CSWTCH.78>
ffffffffc0204ace:	755d                	lui	a0,0xffff7
ffffffffc0204ad0:	96be                	add	a3,a3,a5
ffffffffc0204ad2:	84ae                	mv	s1,a1
ffffffffc0204ad4:	97ba                	add	a5,a5,a4
ffffffffc0204ad6:	858a                	mv	a1,sp
ffffffffc0204ad8:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204adc:	0006ba03          	ld	s4,0(a3)
ffffffffc0204ae0:	0007b983          	ld	s3,0(a5)
ffffffffc0204ae4:	cb1ff0ef          	jal	ra,ffffffffc0204794 <fd_array_alloc>
ffffffffc0204ae8:	842a                	mv	s0,a0
ffffffffc0204aea:	c911                	beqz	a0,ffffffffc0204afe <file_open+0x5c>
ffffffffc0204aec:	60e6                	ld	ra,88(sp)
ffffffffc0204aee:	8522                	mv	a0,s0
ffffffffc0204af0:	6446                	ld	s0,80(sp)
ffffffffc0204af2:	64a6                	ld	s1,72(sp)
ffffffffc0204af4:	6906                	ld	s2,64(sp)
ffffffffc0204af6:	79e2                	ld	s3,56(sp)
ffffffffc0204af8:	7a42                	ld	s4,48(sp)
ffffffffc0204afa:	6125                	addi	sp,sp,96
ffffffffc0204afc:	8082                	ret
ffffffffc0204afe:	0030                	addi	a2,sp,8
ffffffffc0204b00:	85a6                	mv	a1,s1
ffffffffc0204b02:	854a                	mv	a0,s2
ffffffffc0204b04:	3d2030ef          	jal	ra,ffffffffc0207ed6 <vfs_open>
ffffffffc0204b08:	842a                	mv	s0,a0
ffffffffc0204b0a:	e13d                	bnez	a0,ffffffffc0204b70 <file_open+0xce>
ffffffffc0204b0c:	6782                	ld	a5,0(sp)
ffffffffc0204b0e:	0204f493          	andi	s1,s1,32
ffffffffc0204b12:	6422                	ld	s0,8(sp)
ffffffffc0204b14:	0207b023          	sd	zero,32(a5)
ffffffffc0204b18:	c885                	beqz	s1,ffffffffc0204b48 <file_open+0xa6>
ffffffffc0204b1a:	c03d                	beqz	s0,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b1c:	783c                	ld	a5,112(s0)
ffffffffc0204b1e:	c3ad                	beqz	a5,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b20:	779c                	ld	a5,40(a5)
ffffffffc0204b22:	cfb9                	beqz	a5,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b24:	8522                	mv	a0,s0
ffffffffc0204b26:	00008597          	auipc	a1,0x8
ffffffffc0204b2a:	60a58593          	addi	a1,a1,1546 # ffffffffc020d130 <default_pmm_manager+0xd40>
ffffffffc0204b2e:	4c5020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204b32:	783c                	ld	a5,112(s0)
ffffffffc0204b34:	6522                	ld	a0,8(sp)
ffffffffc0204b36:	080c                	addi	a1,sp,16
ffffffffc0204b38:	779c                	ld	a5,40(a5)
ffffffffc0204b3a:	9782                	jalr	a5
ffffffffc0204b3c:	842a                	mv	s0,a0
ffffffffc0204b3e:	e515                	bnez	a0,ffffffffc0204b6a <file_open+0xc8>
ffffffffc0204b40:	6782                	ld	a5,0(sp)
ffffffffc0204b42:	7722                	ld	a4,40(sp)
ffffffffc0204b44:	6422                	ld	s0,8(sp)
ffffffffc0204b46:	f398                	sd	a4,32(a5)
ffffffffc0204b48:	4394                	lw	a3,0(a5)
ffffffffc0204b4a:	f780                	sd	s0,40(a5)
ffffffffc0204b4c:	0147b423          	sd	s4,8(a5)
ffffffffc0204b50:	0137b823          	sd	s3,16(a5)
ffffffffc0204b54:	4705                	li	a4,1
ffffffffc0204b56:	02e69363          	bne	a3,a4,ffffffffc0204b7c <file_open+0xda>
ffffffffc0204b5a:	c00d                	beqz	s0,ffffffffc0204b7c <file_open+0xda>
ffffffffc0204b5c:	5b98                	lw	a4,48(a5)
ffffffffc0204b5e:	4689                	li	a3,2
ffffffffc0204b60:	4f80                	lw	s0,24(a5)
ffffffffc0204b62:	2705                	addiw	a4,a4,1
ffffffffc0204b64:	c394                	sw	a3,0(a5)
ffffffffc0204b66:	db98                	sw	a4,48(a5)
ffffffffc0204b68:	b751                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b6a:	6522                	ld	a0,8(sp)
ffffffffc0204b6c:	510030ef          	jal	ra,ffffffffc020807c <vfs_close>
ffffffffc0204b70:	6502                	ld	a0,0(sp)
ffffffffc0204b72:	cb7ff0ef          	jal	ra,ffffffffc0204828 <fd_array_free>
ffffffffc0204b76:	bf9d                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b78:	5475                	li	s0,-3
ffffffffc0204b7a:	bf8d                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b7c:	d93ff0ef          	jal	ra,ffffffffc020490e <fd_array_open.part.0>
ffffffffc0204b80:	00008697          	auipc	a3,0x8
ffffffffc0204b84:	56068693          	addi	a3,a3,1376 # ffffffffc020d0e0 <default_pmm_manager+0xcf0>
ffffffffc0204b88:	00007617          	auipc	a2,0x7
ffffffffc0204b8c:	d8060613          	addi	a2,a2,-640 # ffffffffc020b908 <commands+0x210>
ffffffffc0204b90:	0b500593          	li	a1,181
ffffffffc0204b94:	00008517          	auipc	a0,0x8
ffffffffc0204b98:	41450513          	addi	a0,a0,1044 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204b9c:	903fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ba0 <file_close>:
ffffffffc0204ba0:	04700713          	li	a4,71
ffffffffc0204ba4:	04a76563          	bltu	a4,a0,ffffffffc0204bee <file_close+0x4e>
ffffffffc0204ba8:	00092717          	auipc	a4,0x92
ffffffffc0204bac:	d1873703          	ld	a4,-744(a4) # ffffffffc02968c0 <current>
ffffffffc0204bb0:	14873703          	ld	a4,328(a4)
ffffffffc0204bb4:	1141                	addi	sp,sp,-16
ffffffffc0204bb6:	e406                	sd	ra,8(sp)
ffffffffc0204bb8:	cf0d                	beqz	a4,ffffffffc0204bf2 <file_close+0x52>
ffffffffc0204bba:	4b14                	lw	a3,16(a4)
ffffffffc0204bbc:	02d05b63          	blez	a3,ffffffffc0204bf2 <file_close+0x52>
ffffffffc0204bc0:	6718                	ld	a4,8(a4)
ffffffffc0204bc2:	87aa                	mv	a5,a0
ffffffffc0204bc4:	050e                	slli	a0,a0,0x3
ffffffffc0204bc6:	8d1d                	sub	a0,a0,a5
ffffffffc0204bc8:	050e                	slli	a0,a0,0x3
ffffffffc0204bca:	953a                	add	a0,a0,a4
ffffffffc0204bcc:	4114                	lw	a3,0(a0)
ffffffffc0204bce:	4709                	li	a4,2
ffffffffc0204bd0:	00e69b63          	bne	a3,a4,ffffffffc0204be6 <file_close+0x46>
ffffffffc0204bd4:	4d18                	lw	a4,24(a0)
ffffffffc0204bd6:	00f71863          	bne	a4,a5,ffffffffc0204be6 <file_close+0x46>
ffffffffc0204bda:	d75ff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc0204bde:	60a2                	ld	ra,8(sp)
ffffffffc0204be0:	4501                	li	a0,0
ffffffffc0204be2:	0141                	addi	sp,sp,16
ffffffffc0204be4:	8082                	ret
ffffffffc0204be6:	60a2                	ld	ra,8(sp)
ffffffffc0204be8:	5575                	li	a0,-3
ffffffffc0204bea:	0141                	addi	sp,sp,16
ffffffffc0204bec:	8082                	ret
ffffffffc0204bee:	5575                	li	a0,-3
ffffffffc0204bf0:	8082                	ret
ffffffffc0204bf2:	b81ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204bf6 <file_read>:
ffffffffc0204bf6:	715d                	addi	sp,sp,-80
ffffffffc0204bf8:	e486                	sd	ra,72(sp)
ffffffffc0204bfa:	e0a2                	sd	s0,64(sp)
ffffffffc0204bfc:	fc26                	sd	s1,56(sp)
ffffffffc0204bfe:	f84a                	sd	s2,48(sp)
ffffffffc0204c00:	f44e                	sd	s3,40(sp)
ffffffffc0204c02:	f052                	sd	s4,32(sp)
ffffffffc0204c04:	0006b023          	sd	zero,0(a3)
ffffffffc0204c08:	04700793          	li	a5,71
ffffffffc0204c0c:	0aa7e463          	bltu	a5,a0,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c10:	00092797          	auipc	a5,0x92
ffffffffc0204c14:	cb07b783          	ld	a5,-848(a5) # ffffffffc02968c0 <current>
ffffffffc0204c18:	1487b783          	ld	a5,328(a5)
ffffffffc0204c1c:	cfd1                	beqz	a5,ffffffffc0204cb8 <file_read+0xc2>
ffffffffc0204c1e:	4b98                	lw	a4,16(a5)
ffffffffc0204c20:	08e05c63          	blez	a4,ffffffffc0204cb8 <file_read+0xc2>
ffffffffc0204c24:	6780                	ld	s0,8(a5)
ffffffffc0204c26:	00351793          	slli	a5,a0,0x3
ffffffffc0204c2a:	8f89                	sub	a5,a5,a0
ffffffffc0204c2c:	078e                	slli	a5,a5,0x3
ffffffffc0204c2e:	943e                	add	s0,s0,a5
ffffffffc0204c30:	00042983          	lw	s3,0(s0)
ffffffffc0204c34:	4789                	li	a5,2
ffffffffc0204c36:	06f99f63          	bne	s3,a5,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c3a:	4c1c                	lw	a5,24(s0)
ffffffffc0204c3c:	06a79c63          	bne	a5,a0,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c40:	641c                	ld	a5,8(s0)
ffffffffc0204c42:	cbad                	beqz	a5,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c44:	581c                	lw	a5,48(s0)
ffffffffc0204c46:	8a36                	mv	s4,a3
ffffffffc0204c48:	7014                	ld	a3,32(s0)
ffffffffc0204c4a:	2785                	addiw	a5,a5,1
ffffffffc0204c4c:	850a                	mv	a0,sp
ffffffffc0204c4e:	d81c                	sw	a5,48(s0)
ffffffffc0204c50:	792000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0204c54:	02843903          	ld	s2,40(s0)
ffffffffc0204c58:	84aa                	mv	s1,a0
ffffffffc0204c5a:	06090163          	beqz	s2,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c5e:	07093783          	ld	a5,112(s2)
ffffffffc0204c62:	cfa9                	beqz	a5,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c64:	6f9c                	ld	a5,24(a5)
ffffffffc0204c66:	cbb9                	beqz	a5,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c68:	00008597          	auipc	a1,0x8
ffffffffc0204c6c:	52058593          	addi	a1,a1,1312 # ffffffffc020d188 <default_pmm_manager+0xd98>
ffffffffc0204c70:	854a                	mv	a0,s2
ffffffffc0204c72:	381020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204c76:	07093783          	ld	a5,112(s2)
ffffffffc0204c7a:	7408                	ld	a0,40(s0)
ffffffffc0204c7c:	85a6                	mv	a1,s1
ffffffffc0204c7e:	6f9c                	ld	a5,24(a5)
ffffffffc0204c80:	9782                	jalr	a5
ffffffffc0204c82:	689c                	ld	a5,16(s1)
ffffffffc0204c84:	6c94                	ld	a3,24(s1)
ffffffffc0204c86:	4018                	lw	a4,0(s0)
ffffffffc0204c88:	84aa                	mv	s1,a0
ffffffffc0204c8a:	8f95                	sub	a5,a5,a3
ffffffffc0204c8c:	03370063          	beq	a4,s3,ffffffffc0204cac <file_read+0xb6>
ffffffffc0204c90:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204c94:	8522                	mv	a0,s0
ffffffffc0204c96:	c0fff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204c9a:	60a6                	ld	ra,72(sp)
ffffffffc0204c9c:	6406                	ld	s0,64(sp)
ffffffffc0204c9e:	7942                	ld	s2,48(sp)
ffffffffc0204ca0:	79a2                	ld	s3,40(sp)
ffffffffc0204ca2:	7a02                	ld	s4,32(sp)
ffffffffc0204ca4:	8526                	mv	a0,s1
ffffffffc0204ca6:	74e2                	ld	s1,56(sp)
ffffffffc0204ca8:	6161                	addi	sp,sp,80
ffffffffc0204caa:	8082                	ret
ffffffffc0204cac:	7018                	ld	a4,32(s0)
ffffffffc0204cae:	973e                	add	a4,a4,a5
ffffffffc0204cb0:	f018                	sd	a4,32(s0)
ffffffffc0204cb2:	bff9                	j	ffffffffc0204c90 <file_read+0x9a>
ffffffffc0204cb4:	54f5                	li	s1,-3
ffffffffc0204cb6:	b7d5                	j	ffffffffc0204c9a <file_read+0xa4>
ffffffffc0204cb8:	abbff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204cbc:	00008697          	auipc	a3,0x8
ffffffffc0204cc0:	47c68693          	addi	a3,a3,1148 # ffffffffc020d138 <default_pmm_manager+0xd48>
ffffffffc0204cc4:	00007617          	auipc	a2,0x7
ffffffffc0204cc8:	c4460613          	addi	a2,a2,-956 # ffffffffc020b908 <commands+0x210>
ffffffffc0204ccc:	0de00593          	li	a1,222
ffffffffc0204cd0:	00008517          	auipc	a0,0x8
ffffffffc0204cd4:	2d850513          	addi	a0,a0,728 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204cd8:	fc6fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204cdc <file_write>:
ffffffffc0204cdc:	715d                	addi	sp,sp,-80
ffffffffc0204cde:	e486                	sd	ra,72(sp)
ffffffffc0204ce0:	e0a2                	sd	s0,64(sp)
ffffffffc0204ce2:	fc26                	sd	s1,56(sp)
ffffffffc0204ce4:	f84a                	sd	s2,48(sp)
ffffffffc0204ce6:	f44e                	sd	s3,40(sp)
ffffffffc0204ce8:	f052                	sd	s4,32(sp)
ffffffffc0204cea:	0006b023          	sd	zero,0(a3)
ffffffffc0204cee:	04700793          	li	a5,71
ffffffffc0204cf2:	0aa7e463          	bltu	a5,a0,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204cf6:	00092797          	auipc	a5,0x92
ffffffffc0204cfa:	bca7b783          	ld	a5,-1078(a5) # ffffffffc02968c0 <current>
ffffffffc0204cfe:	1487b783          	ld	a5,328(a5)
ffffffffc0204d02:	cfd1                	beqz	a5,ffffffffc0204d9e <file_write+0xc2>
ffffffffc0204d04:	4b98                	lw	a4,16(a5)
ffffffffc0204d06:	08e05c63          	blez	a4,ffffffffc0204d9e <file_write+0xc2>
ffffffffc0204d0a:	6780                	ld	s0,8(a5)
ffffffffc0204d0c:	00351793          	slli	a5,a0,0x3
ffffffffc0204d10:	8f89                	sub	a5,a5,a0
ffffffffc0204d12:	078e                	slli	a5,a5,0x3
ffffffffc0204d14:	943e                	add	s0,s0,a5
ffffffffc0204d16:	00042983          	lw	s3,0(s0)
ffffffffc0204d1a:	4789                	li	a5,2
ffffffffc0204d1c:	06f99f63          	bne	s3,a5,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d20:	4c1c                	lw	a5,24(s0)
ffffffffc0204d22:	06a79c63          	bne	a5,a0,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d26:	681c                	ld	a5,16(s0)
ffffffffc0204d28:	cbad                	beqz	a5,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d2a:	581c                	lw	a5,48(s0)
ffffffffc0204d2c:	8a36                	mv	s4,a3
ffffffffc0204d2e:	7014                	ld	a3,32(s0)
ffffffffc0204d30:	2785                	addiw	a5,a5,1
ffffffffc0204d32:	850a                	mv	a0,sp
ffffffffc0204d34:	d81c                	sw	a5,48(s0)
ffffffffc0204d36:	6ac000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0204d3a:	02843903          	ld	s2,40(s0)
ffffffffc0204d3e:	84aa                	mv	s1,a0
ffffffffc0204d40:	06090163          	beqz	s2,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d44:	07093783          	ld	a5,112(s2)
ffffffffc0204d48:	cfa9                	beqz	a5,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d4a:	739c                	ld	a5,32(a5)
ffffffffc0204d4c:	cbb9                	beqz	a5,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d4e:	00008597          	auipc	a1,0x8
ffffffffc0204d52:	49258593          	addi	a1,a1,1170 # ffffffffc020d1e0 <default_pmm_manager+0xdf0>
ffffffffc0204d56:	854a                	mv	a0,s2
ffffffffc0204d58:	29b020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204d5c:	07093783          	ld	a5,112(s2)
ffffffffc0204d60:	7408                	ld	a0,40(s0)
ffffffffc0204d62:	85a6                	mv	a1,s1
ffffffffc0204d64:	739c                	ld	a5,32(a5)
ffffffffc0204d66:	9782                	jalr	a5
ffffffffc0204d68:	689c                	ld	a5,16(s1)
ffffffffc0204d6a:	6c94                	ld	a3,24(s1)
ffffffffc0204d6c:	4018                	lw	a4,0(s0)
ffffffffc0204d6e:	84aa                	mv	s1,a0
ffffffffc0204d70:	8f95                	sub	a5,a5,a3
ffffffffc0204d72:	03370063          	beq	a4,s3,ffffffffc0204d92 <file_write+0xb6>
ffffffffc0204d76:	00fa3023          	sd	a5,0(s4)
ffffffffc0204d7a:	8522                	mv	a0,s0
ffffffffc0204d7c:	b29ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204d80:	60a6                	ld	ra,72(sp)
ffffffffc0204d82:	6406                	ld	s0,64(sp)
ffffffffc0204d84:	7942                	ld	s2,48(sp)
ffffffffc0204d86:	79a2                	ld	s3,40(sp)
ffffffffc0204d88:	7a02                	ld	s4,32(sp)
ffffffffc0204d8a:	8526                	mv	a0,s1
ffffffffc0204d8c:	74e2                	ld	s1,56(sp)
ffffffffc0204d8e:	6161                	addi	sp,sp,80
ffffffffc0204d90:	8082                	ret
ffffffffc0204d92:	7018                	ld	a4,32(s0)
ffffffffc0204d94:	973e                	add	a4,a4,a5
ffffffffc0204d96:	f018                	sd	a4,32(s0)
ffffffffc0204d98:	bff9                	j	ffffffffc0204d76 <file_write+0x9a>
ffffffffc0204d9a:	54f5                	li	s1,-3
ffffffffc0204d9c:	b7d5                	j	ffffffffc0204d80 <file_write+0xa4>
ffffffffc0204d9e:	9d5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204da2:	00008697          	auipc	a3,0x8
ffffffffc0204da6:	3ee68693          	addi	a3,a3,1006 # ffffffffc020d190 <default_pmm_manager+0xda0>
ffffffffc0204daa:	00007617          	auipc	a2,0x7
ffffffffc0204dae:	b5e60613          	addi	a2,a2,-1186 # ffffffffc020b908 <commands+0x210>
ffffffffc0204db2:	0f800593          	li	a1,248
ffffffffc0204db6:	00008517          	auipc	a0,0x8
ffffffffc0204dba:	1f250513          	addi	a0,a0,498 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204dbe:	ee0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204dc2 <file_seek>:
ffffffffc0204dc2:	7139                	addi	sp,sp,-64
ffffffffc0204dc4:	fc06                	sd	ra,56(sp)
ffffffffc0204dc6:	f822                	sd	s0,48(sp)
ffffffffc0204dc8:	f426                	sd	s1,40(sp)
ffffffffc0204dca:	f04a                	sd	s2,32(sp)
ffffffffc0204dcc:	04700793          	li	a5,71
ffffffffc0204dd0:	08a7e863          	bltu	a5,a0,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204dd4:	00092797          	auipc	a5,0x92
ffffffffc0204dd8:	aec7b783          	ld	a5,-1300(a5) # ffffffffc02968c0 <current>
ffffffffc0204ddc:	1487b783          	ld	a5,328(a5)
ffffffffc0204de0:	cfdd                	beqz	a5,ffffffffc0204e9e <file_seek+0xdc>
ffffffffc0204de2:	4b98                	lw	a4,16(a5)
ffffffffc0204de4:	0ae05d63          	blez	a4,ffffffffc0204e9e <file_seek+0xdc>
ffffffffc0204de8:	6780                	ld	s0,8(a5)
ffffffffc0204dea:	00351793          	slli	a5,a0,0x3
ffffffffc0204dee:	8f89                	sub	a5,a5,a0
ffffffffc0204df0:	078e                	slli	a5,a5,0x3
ffffffffc0204df2:	943e                	add	s0,s0,a5
ffffffffc0204df4:	4018                	lw	a4,0(s0)
ffffffffc0204df6:	4789                	li	a5,2
ffffffffc0204df8:	06f71463          	bne	a4,a5,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204dfc:	4c1c                	lw	a5,24(s0)
ffffffffc0204dfe:	06a79163          	bne	a5,a0,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204e02:	581c                	lw	a5,48(s0)
ffffffffc0204e04:	4685                	li	a3,1
ffffffffc0204e06:	892e                	mv	s2,a1
ffffffffc0204e08:	2785                	addiw	a5,a5,1
ffffffffc0204e0a:	d81c                	sw	a5,48(s0)
ffffffffc0204e0c:	02d60063          	beq	a2,a3,ffffffffc0204e2c <file_seek+0x6a>
ffffffffc0204e10:	06e60063          	beq	a2,a4,ffffffffc0204e70 <file_seek+0xae>
ffffffffc0204e14:	54f5                	li	s1,-3
ffffffffc0204e16:	ce11                	beqz	a2,ffffffffc0204e32 <file_seek+0x70>
ffffffffc0204e18:	8522                	mv	a0,s0
ffffffffc0204e1a:	a8bff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204e1e:	70e2                	ld	ra,56(sp)
ffffffffc0204e20:	7442                	ld	s0,48(sp)
ffffffffc0204e22:	7902                	ld	s2,32(sp)
ffffffffc0204e24:	8526                	mv	a0,s1
ffffffffc0204e26:	74a2                	ld	s1,40(sp)
ffffffffc0204e28:	6121                	addi	sp,sp,64
ffffffffc0204e2a:	8082                	ret
ffffffffc0204e2c:	701c                	ld	a5,32(s0)
ffffffffc0204e2e:	00f58933          	add	s2,a1,a5
ffffffffc0204e32:	7404                	ld	s1,40(s0)
ffffffffc0204e34:	c4bd                	beqz	s1,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e36:	78bc                	ld	a5,112(s1)
ffffffffc0204e38:	c7ad                	beqz	a5,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e3a:	6fbc                	ld	a5,88(a5)
ffffffffc0204e3c:	c3bd                	beqz	a5,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e3e:	8526                	mv	a0,s1
ffffffffc0204e40:	00008597          	auipc	a1,0x8
ffffffffc0204e44:	3f858593          	addi	a1,a1,1016 # ffffffffc020d238 <default_pmm_manager+0xe48>
ffffffffc0204e48:	1ab020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204e4c:	78bc                	ld	a5,112(s1)
ffffffffc0204e4e:	7408                	ld	a0,40(s0)
ffffffffc0204e50:	85ca                	mv	a1,s2
ffffffffc0204e52:	6fbc                	ld	a5,88(a5)
ffffffffc0204e54:	9782                	jalr	a5
ffffffffc0204e56:	84aa                	mv	s1,a0
ffffffffc0204e58:	f161                	bnez	a0,ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e5a:	03243023          	sd	s2,32(s0)
ffffffffc0204e5e:	bf6d                	j	ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e60:	70e2                	ld	ra,56(sp)
ffffffffc0204e62:	7442                	ld	s0,48(sp)
ffffffffc0204e64:	54f5                	li	s1,-3
ffffffffc0204e66:	7902                	ld	s2,32(sp)
ffffffffc0204e68:	8526                	mv	a0,s1
ffffffffc0204e6a:	74a2                	ld	s1,40(sp)
ffffffffc0204e6c:	6121                	addi	sp,sp,64
ffffffffc0204e6e:	8082                	ret
ffffffffc0204e70:	7404                	ld	s1,40(s0)
ffffffffc0204e72:	c8a1                	beqz	s1,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e74:	78bc                	ld	a5,112(s1)
ffffffffc0204e76:	c7b1                	beqz	a5,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e78:	779c                	ld	a5,40(a5)
ffffffffc0204e7a:	c7a1                	beqz	a5,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e7c:	8526                	mv	a0,s1
ffffffffc0204e7e:	00008597          	auipc	a1,0x8
ffffffffc0204e82:	2b258593          	addi	a1,a1,690 # ffffffffc020d130 <default_pmm_manager+0xd40>
ffffffffc0204e86:	16d020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204e8a:	78bc                	ld	a5,112(s1)
ffffffffc0204e8c:	7408                	ld	a0,40(s0)
ffffffffc0204e8e:	858a                	mv	a1,sp
ffffffffc0204e90:	779c                	ld	a5,40(a5)
ffffffffc0204e92:	9782                	jalr	a5
ffffffffc0204e94:	84aa                	mv	s1,a0
ffffffffc0204e96:	f149                	bnez	a0,ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e98:	67e2                	ld	a5,24(sp)
ffffffffc0204e9a:	993e                	add	s2,s2,a5
ffffffffc0204e9c:	bf59                	j	ffffffffc0204e32 <file_seek+0x70>
ffffffffc0204e9e:	8d5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204ea2:	00008697          	auipc	a3,0x8
ffffffffc0204ea6:	34668693          	addi	a3,a3,838 # ffffffffc020d1e8 <default_pmm_manager+0xdf8>
ffffffffc0204eaa:	00007617          	auipc	a2,0x7
ffffffffc0204eae:	a5e60613          	addi	a2,a2,-1442 # ffffffffc020b908 <commands+0x210>
ffffffffc0204eb2:	11a00593          	li	a1,282
ffffffffc0204eb6:	00008517          	auipc	a0,0x8
ffffffffc0204eba:	0f250513          	addi	a0,a0,242 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204ebe:	de0fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204ec2:	00008697          	auipc	a3,0x8
ffffffffc0204ec6:	21e68693          	addi	a3,a3,542 # ffffffffc020d0e0 <default_pmm_manager+0xcf0>
ffffffffc0204eca:	00007617          	auipc	a2,0x7
ffffffffc0204ece:	a3e60613          	addi	a2,a2,-1474 # ffffffffc020b908 <commands+0x210>
ffffffffc0204ed2:	11200593          	li	a1,274
ffffffffc0204ed6:	00008517          	auipc	a0,0x8
ffffffffc0204eda:	0d250513          	addi	a0,a0,210 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204ede:	dc0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ee2 <file_fstat>:
ffffffffc0204ee2:	1101                	addi	sp,sp,-32
ffffffffc0204ee4:	ec06                	sd	ra,24(sp)
ffffffffc0204ee6:	e822                	sd	s0,16(sp)
ffffffffc0204ee8:	e426                	sd	s1,8(sp)
ffffffffc0204eea:	e04a                	sd	s2,0(sp)
ffffffffc0204eec:	04700793          	li	a5,71
ffffffffc0204ef0:	06a7ef63          	bltu	a5,a0,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204ef4:	00092797          	auipc	a5,0x92
ffffffffc0204ef8:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc02968c0 <current>
ffffffffc0204efc:	1487b783          	ld	a5,328(a5)
ffffffffc0204f00:	cfd9                	beqz	a5,ffffffffc0204f9e <file_fstat+0xbc>
ffffffffc0204f02:	4b98                	lw	a4,16(a5)
ffffffffc0204f04:	08e05d63          	blez	a4,ffffffffc0204f9e <file_fstat+0xbc>
ffffffffc0204f08:	6780                	ld	s0,8(a5)
ffffffffc0204f0a:	00351793          	slli	a5,a0,0x3
ffffffffc0204f0e:	8f89                	sub	a5,a5,a0
ffffffffc0204f10:	078e                	slli	a5,a5,0x3
ffffffffc0204f12:	943e                	add	s0,s0,a5
ffffffffc0204f14:	4018                	lw	a4,0(s0)
ffffffffc0204f16:	4789                	li	a5,2
ffffffffc0204f18:	04f71b63          	bne	a4,a5,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204f1c:	4c1c                	lw	a5,24(s0)
ffffffffc0204f1e:	04a79863          	bne	a5,a0,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204f22:	581c                	lw	a5,48(s0)
ffffffffc0204f24:	02843903          	ld	s2,40(s0)
ffffffffc0204f28:	2785                	addiw	a5,a5,1
ffffffffc0204f2a:	d81c                	sw	a5,48(s0)
ffffffffc0204f2c:	04090963          	beqz	s2,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f30:	07093783          	ld	a5,112(s2)
ffffffffc0204f34:	c7a9                	beqz	a5,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f36:	779c                	ld	a5,40(a5)
ffffffffc0204f38:	c3b9                	beqz	a5,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f3a:	84ae                	mv	s1,a1
ffffffffc0204f3c:	854a                	mv	a0,s2
ffffffffc0204f3e:	00008597          	auipc	a1,0x8
ffffffffc0204f42:	1f258593          	addi	a1,a1,498 # ffffffffc020d130 <default_pmm_manager+0xd40>
ffffffffc0204f46:	0ad020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0204f4a:	07093783          	ld	a5,112(s2)
ffffffffc0204f4e:	7408                	ld	a0,40(s0)
ffffffffc0204f50:	85a6                	mv	a1,s1
ffffffffc0204f52:	779c                	ld	a5,40(a5)
ffffffffc0204f54:	9782                	jalr	a5
ffffffffc0204f56:	87aa                	mv	a5,a0
ffffffffc0204f58:	8522                	mv	a0,s0
ffffffffc0204f5a:	843e                	mv	s0,a5
ffffffffc0204f5c:	949ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204f60:	60e2                	ld	ra,24(sp)
ffffffffc0204f62:	8522                	mv	a0,s0
ffffffffc0204f64:	6442                	ld	s0,16(sp)
ffffffffc0204f66:	64a2                	ld	s1,8(sp)
ffffffffc0204f68:	6902                	ld	s2,0(sp)
ffffffffc0204f6a:	6105                	addi	sp,sp,32
ffffffffc0204f6c:	8082                	ret
ffffffffc0204f6e:	5475                	li	s0,-3
ffffffffc0204f70:	60e2                	ld	ra,24(sp)
ffffffffc0204f72:	8522                	mv	a0,s0
ffffffffc0204f74:	6442                	ld	s0,16(sp)
ffffffffc0204f76:	64a2                	ld	s1,8(sp)
ffffffffc0204f78:	6902                	ld	s2,0(sp)
ffffffffc0204f7a:	6105                	addi	sp,sp,32
ffffffffc0204f7c:	8082                	ret
ffffffffc0204f7e:	00008697          	auipc	a3,0x8
ffffffffc0204f82:	16268693          	addi	a3,a3,354 # ffffffffc020d0e0 <default_pmm_manager+0xcf0>
ffffffffc0204f86:	00007617          	auipc	a2,0x7
ffffffffc0204f8a:	98260613          	addi	a2,a2,-1662 # ffffffffc020b908 <commands+0x210>
ffffffffc0204f8e:	12c00593          	li	a1,300
ffffffffc0204f92:	00008517          	auipc	a0,0x8
ffffffffc0204f96:	01650513          	addi	a0,a0,22 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0204f9a:	d04fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204f9e:	fd4ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204fa2 <file_fsync>:
ffffffffc0204fa2:	1101                	addi	sp,sp,-32
ffffffffc0204fa4:	ec06                	sd	ra,24(sp)
ffffffffc0204fa6:	e822                	sd	s0,16(sp)
ffffffffc0204fa8:	e426                	sd	s1,8(sp)
ffffffffc0204faa:	04700793          	li	a5,71
ffffffffc0204fae:	06a7e863          	bltu	a5,a0,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fb2:	00092797          	auipc	a5,0x92
ffffffffc0204fb6:	90e7b783          	ld	a5,-1778(a5) # ffffffffc02968c0 <current>
ffffffffc0204fba:	1487b783          	ld	a5,328(a5)
ffffffffc0204fbe:	c7d9                	beqz	a5,ffffffffc020504c <file_fsync+0xaa>
ffffffffc0204fc0:	4b98                	lw	a4,16(a5)
ffffffffc0204fc2:	08e05563          	blez	a4,ffffffffc020504c <file_fsync+0xaa>
ffffffffc0204fc6:	6780                	ld	s0,8(a5)
ffffffffc0204fc8:	00351793          	slli	a5,a0,0x3
ffffffffc0204fcc:	8f89                	sub	a5,a5,a0
ffffffffc0204fce:	078e                	slli	a5,a5,0x3
ffffffffc0204fd0:	943e                	add	s0,s0,a5
ffffffffc0204fd2:	4018                	lw	a4,0(s0)
ffffffffc0204fd4:	4789                	li	a5,2
ffffffffc0204fd6:	04f71463          	bne	a4,a5,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fda:	4c1c                	lw	a5,24(s0)
ffffffffc0204fdc:	04a79163          	bne	a5,a0,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fe0:	581c                	lw	a5,48(s0)
ffffffffc0204fe2:	7404                	ld	s1,40(s0)
ffffffffc0204fe4:	2785                	addiw	a5,a5,1
ffffffffc0204fe6:	d81c                	sw	a5,48(s0)
ffffffffc0204fe8:	c0b1                	beqz	s1,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204fea:	78bc                	ld	a5,112(s1)
ffffffffc0204fec:	c3a1                	beqz	a5,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204fee:	7b9c                	ld	a5,48(a5)
ffffffffc0204ff0:	cf95                	beqz	a5,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204ff2:	00008597          	auipc	a1,0x8
ffffffffc0204ff6:	29e58593          	addi	a1,a1,670 # ffffffffc020d290 <default_pmm_manager+0xea0>
ffffffffc0204ffa:	8526                	mv	a0,s1
ffffffffc0204ffc:	7f6020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0205000:	78bc                	ld	a5,112(s1)
ffffffffc0205002:	7408                	ld	a0,40(s0)
ffffffffc0205004:	7b9c                	ld	a5,48(a5)
ffffffffc0205006:	9782                	jalr	a5
ffffffffc0205008:	87aa                	mv	a5,a0
ffffffffc020500a:	8522                	mv	a0,s0
ffffffffc020500c:	843e                	mv	s0,a5
ffffffffc020500e:	897ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0205012:	60e2                	ld	ra,24(sp)
ffffffffc0205014:	8522                	mv	a0,s0
ffffffffc0205016:	6442                	ld	s0,16(sp)
ffffffffc0205018:	64a2                	ld	s1,8(sp)
ffffffffc020501a:	6105                	addi	sp,sp,32
ffffffffc020501c:	8082                	ret
ffffffffc020501e:	5475                	li	s0,-3
ffffffffc0205020:	60e2                	ld	ra,24(sp)
ffffffffc0205022:	8522                	mv	a0,s0
ffffffffc0205024:	6442                	ld	s0,16(sp)
ffffffffc0205026:	64a2                	ld	s1,8(sp)
ffffffffc0205028:	6105                	addi	sp,sp,32
ffffffffc020502a:	8082                	ret
ffffffffc020502c:	00008697          	auipc	a3,0x8
ffffffffc0205030:	21468693          	addi	a3,a3,532 # ffffffffc020d240 <default_pmm_manager+0xe50>
ffffffffc0205034:	00007617          	auipc	a2,0x7
ffffffffc0205038:	8d460613          	addi	a2,a2,-1836 # ffffffffc020b908 <commands+0x210>
ffffffffc020503c:	13a00593          	li	a1,314
ffffffffc0205040:	00008517          	auipc	a0,0x8
ffffffffc0205044:	f6850513          	addi	a0,a0,-152 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc0205048:	c56fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020504c:	f26ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0205050 <file_getdirentry>:
ffffffffc0205050:	715d                	addi	sp,sp,-80
ffffffffc0205052:	e486                	sd	ra,72(sp)
ffffffffc0205054:	e0a2                	sd	s0,64(sp)
ffffffffc0205056:	fc26                	sd	s1,56(sp)
ffffffffc0205058:	f84a                	sd	s2,48(sp)
ffffffffc020505a:	f44e                	sd	s3,40(sp)
ffffffffc020505c:	04700793          	li	a5,71
ffffffffc0205060:	0aa7e063          	bltu	a5,a0,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc0205064:	00092797          	auipc	a5,0x92
ffffffffc0205068:	85c7b783          	ld	a5,-1956(a5) # ffffffffc02968c0 <current>
ffffffffc020506c:	1487b783          	ld	a5,328(a5)
ffffffffc0205070:	c3e9                	beqz	a5,ffffffffc0205132 <file_getdirentry+0xe2>
ffffffffc0205072:	4b98                	lw	a4,16(a5)
ffffffffc0205074:	0ae05f63          	blez	a4,ffffffffc0205132 <file_getdirentry+0xe2>
ffffffffc0205078:	6780                	ld	s0,8(a5)
ffffffffc020507a:	00351793          	slli	a5,a0,0x3
ffffffffc020507e:	8f89                	sub	a5,a5,a0
ffffffffc0205080:	078e                	slli	a5,a5,0x3
ffffffffc0205082:	943e                	add	s0,s0,a5
ffffffffc0205084:	4018                	lw	a4,0(s0)
ffffffffc0205086:	4789                	li	a5,2
ffffffffc0205088:	06f71c63          	bne	a4,a5,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc020508c:	4c1c                	lw	a5,24(s0)
ffffffffc020508e:	06a79963          	bne	a5,a0,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc0205092:	581c                	lw	a5,48(s0)
ffffffffc0205094:	6194                	ld	a3,0(a1)
ffffffffc0205096:	84ae                	mv	s1,a1
ffffffffc0205098:	2785                	addiw	a5,a5,1
ffffffffc020509a:	10000613          	li	a2,256
ffffffffc020509e:	d81c                	sw	a5,48(s0)
ffffffffc02050a0:	05a1                	addi	a1,a1,8
ffffffffc02050a2:	850a                	mv	a0,sp
ffffffffc02050a4:	33e000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02050a8:	02843983          	ld	s3,40(s0)
ffffffffc02050ac:	892a                	mv	s2,a0
ffffffffc02050ae:	06098263          	beqz	s3,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050b2:	0709b783          	ld	a5,112(s3) # 1070 <_binary_bin_swap_img_size-0x6c90>
ffffffffc02050b6:	cfb1                	beqz	a5,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050b8:	63bc                	ld	a5,64(a5)
ffffffffc02050ba:	cfa1                	beqz	a5,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050bc:	854e                	mv	a0,s3
ffffffffc02050be:	00008597          	auipc	a1,0x8
ffffffffc02050c2:	23258593          	addi	a1,a1,562 # ffffffffc020d2f0 <default_pmm_manager+0xf00>
ffffffffc02050c6:	72c020ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02050ca:	0709b783          	ld	a5,112(s3)
ffffffffc02050ce:	7408                	ld	a0,40(s0)
ffffffffc02050d0:	85ca                	mv	a1,s2
ffffffffc02050d2:	63bc                	ld	a5,64(a5)
ffffffffc02050d4:	9782                	jalr	a5
ffffffffc02050d6:	89aa                	mv	s3,a0
ffffffffc02050d8:	e909                	bnez	a0,ffffffffc02050ea <file_getdirentry+0x9a>
ffffffffc02050da:	609c                	ld	a5,0(s1)
ffffffffc02050dc:	01093683          	ld	a3,16(s2)
ffffffffc02050e0:	01893703          	ld	a4,24(s2)
ffffffffc02050e4:	97b6                	add	a5,a5,a3
ffffffffc02050e6:	8f99                	sub	a5,a5,a4
ffffffffc02050e8:	e09c                	sd	a5,0(s1)
ffffffffc02050ea:	8522                	mv	a0,s0
ffffffffc02050ec:	fb8ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc02050f0:	60a6                	ld	ra,72(sp)
ffffffffc02050f2:	6406                	ld	s0,64(sp)
ffffffffc02050f4:	74e2                	ld	s1,56(sp)
ffffffffc02050f6:	7942                	ld	s2,48(sp)
ffffffffc02050f8:	854e                	mv	a0,s3
ffffffffc02050fa:	79a2                	ld	s3,40(sp)
ffffffffc02050fc:	6161                	addi	sp,sp,80
ffffffffc02050fe:	8082                	ret
ffffffffc0205100:	60a6                	ld	ra,72(sp)
ffffffffc0205102:	6406                	ld	s0,64(sp)
ffffffffc0205104:	59f5                	li	s3,-3
ffffffffc0205106:	74e2                	ld	s1,56(sp)
ffffffffc0205108:	7942                	ld	s2,48(sp)
ffffffffc020510a:	854e                	mv	a0,s3
ffffffffc020510c:	79a2                	ld	s3,40(sp)
ffffffffc020510e:	6161                	addi	sp,sp,80
ffffffffc0205110:	8082                	ret
ffffffffc0205112:	00008697          	auipc	a3,0x8
ffffffffc0205116:	18668693          	addi	a3,a3,390 # ffffffffc020d298 <default_pmm_manager+0xea8>
ffffffffc020511a:	00006617          	auipc	a2,0x6
ffffffffc020511e:	7ee60613          	addi	a2,a2,2030 # ffffffffc020b908 <commands+0x210>
ffffffffc0205122:	14a00593          	li	a1,330
ffffffffc0205126:	00008517          	auipc	a0,0x8
ffffffffc020512a:	e8250513          	addi	a0,a0,-382 # ffffffffc020cfa8 <default_pmm_manager+0xbb8>
ffffffffc020512e:	b70fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205132:	e40ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0205136 <file_dup>:
ffffffffc0205136:	04700713          	li	a4,71
ffffffffc020513a:	06a76463          	bltu	a4,a0,ffffffffc02051a2 <file_dup+0x6c>
ffffffffc020513e:	00091717          	auipc	a4,0x91
ffffffffc0205142:	78273703          	ld	a4,1922(a4) # ffffffffc02968c0 <current>
ffffffffc0205146:	14873703          	ld	a4,328(a4)
ffffffffc020514a:	1101                	addi	sp,sp,-32
ffffffffc020514c:	ec06                	sd	ra,24(sp)
ffffffffc020514e:	e822                	sd	s0,16(sp)
ffffffffc0205150:	cb39                	beqz	a4,ffffffffc02051a6 <file_dup+0x70>
ffffffffc0205152:	4b14                	lw	a3,16(a4)
ffffffffc0205154:	04d05963          	blez	a3,ffffffffc02051a6 <file_dup+0x70>
ffffffffc0205158:	6700                	ld	s0,8(a4)
ffffffffc020515a:	00351713          	slli	a4,a0,0x3
ffffffffc020515e:	8f09                	sub	a4,a4,a0
ffffffffc0205160:	070e                	slli	a4,a4,0x3
ffffffffc0205162:	943a                	add	s0,s0,a4
ffffffffc0205164:	4014                	lw	a3,0(s0)
ffffffffc0205166:	4709                	li	a4,2
ffffffffc0205168:	02e69863          	bne	a3,a4,ffffffffc0205198 <file_dup+0x62>
ffffffffc020516c:	4c18                	lw	a4,24(s0)
ffffffffc020516e:	02a71563          	bne	a4,a0,ffffffffc0205198 <file_dup+0x62>
ffffffffc0205172:	852e                	mv	a0,a1
ffffffffc0205174:	002c                	addi	a1,sp,8
ffffffffc0205176:	e1eff0ef          	jal	ra,ffffffffc0204794 <fd_array_alloc>
ffffffffc020517a:	c509                	beqz	a0,ffffffffc0205184 <file_dup+0x4e>
ffffffffc020517c:	60e2                	ld	ra,24(sp)
ffffffffc020517e:	6442                	ld	s0,16(sp)
ffffffffc0205180:	6105                	addi	sp,sp,32
ffffffffc0205182:	8082                	ret
ffffffffc0205184:	6522                	ld	a0,8(sp)
ffffffffc0205186:	85a2                	mv	a1,s0
ffffffffc0205188:	845ff0ef          	jal	ra,ffffffffc02049cc <fd_array_dup>
ffffffffc020518c:	67a2                	ld	a5,8(sp)
ffffffffc020518e:	60e2                	ld	ra,24(sp)
ffffffffc0205190:	6442                	ld	s0,16(sp)
ffffffffc0205192:	4f88                	lw	a0,24(a5)
ffffffffc0205194:	6105                	addi	sp,sp,32
ffffffffc0205196:	8082                	ret
ffffffffc0205198:	60e2                	ld	ra,24(sp)
ffffffffc020519a:	6442                	ld	s0,16(sp)
ffffffffc020519c:	5575                	li	a0,-3
ffffffffc020519e:	6105                	addi	sp,sp,32
ffffffffc02051a0:	8082                	ret
ffffffffc02051a2:	5575                	li	a0,-3
ffffffffc02051a4:	8082                	ret
ffffffffc02051a6:	dccff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc02051aa <fs_init>:
ffffffffc02051aa:	1141                	addi	sp,sp,-16
ffffffffc02051ac:	e406                	sd	ra,8(sp)
ffffffffc02051ae:	063020ef          	jal	ra,ffffffffc0207a10 <vfs_init>
ffffffffc02051b2:	53a030ef          	jal	ra,ffffffffc02086ec <dev_init>
ffffffffc02051b6:	60a2                	ld	ra,8(sp)
ffffffffc02051b8:	0141                	addi	sp,sp,16
ffffffffc02051ba:	68b0306f          	j	ffffffffc0209044 <sfs_init>

ffffffffc02051be <fs_cleanup>:
ffffffffc02051be:	2a50206f          	j	ffffffffc0207c62 <vfs_cleanup>

ffffffffc02051c2 <lock_files>:
ffffffffc02051c2:	0561                	addi	a0,a0,24
ffffffffc02051c4:	ba0ff06f          	j	ffffffffc0204564 <down>

ffffffffc02051c8 <unlock_files>:
ffffffffc02051c8:	0561                	addi	a0,a0,24
ffffffffc02051ca:	b96ff06f          	j	ffffffffc0204560 <up>

ffffffffc02051ce <files_create>:
ffffffffc02051ce:	1141                	addi	sp,sp,-16
ffffffffc02051d0:	6505                	lui	a0,0x1
ffffffffc02051d2:	e022                	sd	s0,0(sp)
ffffffffc02051d4:	e406                	sd	ra,8(sp)
ffffffffc02051d6:	db9fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02051da:	842a                	mv	s0,a0
ffffffffc02051dc:	cd19                	beqz	a0,ffffffffc02051fa <files_create+0x2c>
ffffffffc02051de:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02051e2:	00043023          	sd	zero,0(s0)
ffffffffc02051e6:	0561                	addi	a0,a0,24
ffffffffc02051e8:	e41c                	sd	a5,8(s0)
ffffffffc02051ea:	00042823          	sw	zero,16(s0)
ffffffffc02051ee:	4585                	li	a1,1
ffffffffc02051f0:	b6aff0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02051f4:	6408                	ld	a0,8(s0)
ffffffffc02051f6:	f3cff0ef          	jal	ra,ffffffffc0204932 <fd_array_init>
ffffffffc02051fa:	60a2                	ld	ra,8(sp)
ffffffffc02051fc:	8522                	mv	a0,s0
ffffffffc02051fe:	6402                	ld	s0,0(sp)
ffffffffc0205200:	0141                	addi	sp,sp,16
ffffffffc0205202:	8082                	ret

ffffffffc0205204 <files_destroy>:
ffffffffc0205204:	7179                	addi	sp,sp,-48
ffffffffc0205206:	f406                	sd	ra,40(sp)
ffffffffc0205208:	f022                	sd	s0,32(sp)
ffffffffc020520a:	ec26                	sd	s1,24(sp)
ffffffffc020520c:	e84a                	sd	s2,16(sp)
ffffffffc020520e:	e44e                	sd	s3,8(sp)
ffffffffc0205210:	c52d                	beqz	a0,ffffffffc020527a <files_destroy+0x76>
ffffffffc0205212:	491c                	lw	a5,16(a0)
ffffffffc0205214:	89aa                	mv	s3,a0
ffffffffc0205216:	e3b5                	bnez	a5,ffffffffc020527a <files_destroy+0x76>
ffffffffc0205218:	6108                	ld	a0,0(a0)
ffffffffc020521a:	c119                	beqz	a0,ffffffffc0205220 <files_destroy+0x1c>
ffffffffc020521c:	68c020ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0205220:	0089b403          	ld	s0,8(s3)
ffffffffc0205224:	6485                	lui	s1,0x1
ffffffffc0205226:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc020522a:	94a2                	add	s1,s1,s0
ffffffffc020522c:	4909                	li	s2,2
ffffffffc020522e:	401c                	lw	a5,0(s0)
ffffffffc0205230:	03278063          	beq	a5,s2,ffffffffc0205250 <files_destroy+0x4c>
ffffffffc0205234:	e39d                	bnez	a5,ffffffffc020525a <files_destroy+0x56>
ffffffffc0205236:	03840413          	addi	s0,s0,56
ffffffffc020523a:	fe849ae3          	bne	s1,s0,ffffffffc020522e <files_destroy+0x2a>
ffffffffc020523e:	7402                	ld	s0,32(sp)
ffffffffc0205240:	70a2                	ld	ra,40(sp)
ffffffffc0205242:	64e2                	ld	s1,24(sp)
ffffffffc0205244:	6942                	ld	s2,16(sp)
ffffffffc0205246:	854e                	mv	a0,s3
ffffffffc0205248:	69a2                	ld	s3,8(sp)
ffffffffc020524a:	6145                	addi	sp,sp,48
ffffffffc020524c:	df3fc06f          	j	ffffffffc020203e <kfree>
ffffffffc0205250:	8522                	mv	a0,s0
ffffffffc0205252:	efcff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc0205256:	401c                	lw	a5,0(s0)
ffffffffc0205258:	bff1                	j	ffffffffc0205234 <files_destroy+0x30>
ffffffffc020525a:	00008697          	auipc	a3,0x8
ffffffffc020525e:	11668693          	addi	a3,a3,278 # ffffffffc020d370 <CSWTCH.79+0x58>
ffffffffc0205262:	00006617          	auipc	a2,0x6
ffffffffc0205266:	6a660613          	addi	a2,a2,1702 # ffffffffc020b908 <commands+0x210>
ffffffffc020526a:	03d00593          	li	a1,61
ffffffffc020526e:	00008517          	auipc	a0,0x8
ffffffffc0205272:	0f250513          	addi	a0,a0,242 # ffffffffc020d360 <CSWTCH.79+0x48>
ffffffffc0205276:	a28fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020527a:	00008697          	auipc	a3,0x8
ffffffffc020527e:	0b668693          	addi	a3,a3,182 # ffffffffc020d330 <CSWTCH.79+0x18>
ffffffffc0205282:	00006617          	auipc	a2,0x6
ffffffffc0205286:	68660613          	addi	a2,a2,1670 # ffffffffc020b908 <commands+0x210>
ffffffffc020528a:	03300593          	li	a1,51
ffffffffc020528e:	00008517          	auipc	a0,0x8
ffffffffc0205292:	0d250513          	addi	a0,a0,210 # ffffffffc020d360 <CSWTCH.79+0x48>
ffffffffc0205296:	a08fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020529a <files_closeall>:
ffffffffc020529a:	1101                	addi	sp,sp,-32
ffffffffc020529c:	ec06                	sd	ra,24(sp)
ffffffffc020529e:	e822                	sd	s0,16(sp)
ffffffffc02052a0:	e426                	sd	s1,8(sp)
ffffffffc02052a2:	e04a                	sd	s2,0(sp)
ffffffffc02052a4:	c129                	beqz	a0,ffffffffc02052e6 <files_closeall+0x4c>
ffffffffc02052a6:	491c                	lw	a5,16(a0)
ffffffffc02052a8:	02f05f63          	blez	a5,ffffffffc02052e6 <files_closeall+0x4c>
ffffffffc02052ac:	6504                	ld	s1,8(a0)
ffffffffc02052ae:	6785                	lui	a5,0x1
ffffffffc02052b0:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02052b4:	07048413          	addi	s0,s1,112
ffffffffc02052b8:	4909                	li	s2,2
ffffffffc02052ba:	94be                	add	s1,s1,a5
ffffffffc02052bc:	a029                	j	ffffffffc02052c6 <files_closeall+0x2c>
ffffffffc02052be:	03840413          	addi	s0,s0,56
ffffffffc02052c2:	00848c63          	beq	s1,s0,ffffffffc02052da <files_closeall+0x40>
ffffffffc02052c6:	401c                	lw	a5,0(s0)
ffffffffc02052c8:	ff279be3          	bne	a5,s2,ffffffffc02052be <files_closeall+0x24>
ffffffffc02052cc:	8522                	mv	a0,s0
ffffffffc02052ce:	03840413          	addi	s0,s0,56
ffffffffc02052d2:	e7cff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc02052d6:	fe8498e3          	bne	s1,s0,ffffffffc02052c6 <files_closeall+0x2c>
ffffffffc02052da:	60e2                	ld	ra,24(sp)
ffffffffc02052dc:	6442                	ld	s0,16(sp)
ffffffffc02052de:	64a2                	ld	s1,8(sp)
ffffffffc02052e0:	6902                	ld	s2,0(sp)
ffffffffc02052e2:	6105                	addi	sp,sp,32
ffffffffc02052e4:	8082                	ret
ffffffffc02052e6:	00008697          	auipc	a3,0x8
ffffffffc02052ea:	c9268693          	addi	a3,a3,-878 # ffffffffc020cf78 <default_pmm_manager+0xb88>
ffffffffc02052ee:	00006617          	auipc	a2,0x6
ffffffffc02052f2:	61a60613          	addi	a2,a2,1562 # ffffffffc020b908 <commands+0x210>
ffffffffc02052f6:	04500593          	li	a1,69
ffffffffc02052fa:	00008517          	auipc	a0,0x8
ffffffffc02052fe:	06650513          	addi	a0,a0,102 # ffffffffc020d360 <CSWTCH.79+0x48>
ffffffffc0205302:	99cfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205306 <dup_files>:
ffffffffc0205306:	7179                	addi	sp,sp,-48
ffffffffc0205308:	f406                	sd	ra,40(sp)
ffffffffc020530a:	f022                	sd	s0,32(sp)
ffffffffc020530c:	ec26                	sd	s1,24(sp)
ffffffffc020530e:	e84a                	sd	s2,16(sp)
ffffffffc0205310:	e44e                	sd	s3,8(sp)
ffffffffc0205312:	e052                	sd	s4,0(sp)
ffffffffc0205314:	c52d                	beqz	a0,ffffffffc020537e <dup_files+0x78>
ffffffffc0205316:	842e                	mv	s0,a1
ffffffffc0205318:	c1bd                	beqz	a1,ffffffffc020537e <dup_files+0x78>
ffffffffc020531a:	491c                	lw	a5,16(a0)
ffffffffc020531c:	84aa                	mv	s1,a0
ffffffffc020531e:	e3c1                	bnez	a5,ffffffffc020539e <dup_files+0x98>
ffffffffc0205320:	499c                	lw	a5,16(a1)
ffffffffc0205322:	06f05e63          	blez	a5,ffffffffc020539e <dup_files+0x98>
ffffffffc0205326:	6188                	ld	a0,0(a1)
ffffffffc0205328:	e088                	sd	a0,0(s1)
ffffffffc020532a:	c119                	beqz	a0,ffffffffc0205330 <dup_files+0x2a>
ffffffffc020532c:	4ae020ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0205330:	6400                	ld	s0,8(s0)
ffffffffc0205332:	6905                	lui	s2,0x1
ffffffffc0205334:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205338:	6484                	ld	s1,8(s1)
ffffffffc020533a:	9922                	add	s2,s2,s0
ffffffffc020533c:	4989                	li	s3,2
ffffffffc020533e:	4a05                	li	s4,1
ffffffffc0205340:	a039                	j	ffffffffc020534e <dup_files+0x48>
ffffffffc0205342:	03840413          	addi	s0,s0,56
ffffffffc0205346:	03848493          	addi	s1,s1,56
ffffffffc020534a:	02890163          	beq	s2,s0,ffffffffc020536c <dup_files+0x66>
ffffffffc020534e:	401c                	lw	a5,0(s0)
ffffffffc0205350:	ff3799e3          	bne	a5,s3,ffffffffc0205342 <dup_files+0x3c>
ffffffffc0205354:	0144a023          	sw	s4,0(s1)
ffffffffc0205358:	85a2                	mv	a1,s0
ffffffffc020535a:	8526                	mv	a0,s1
ffffffffc020535c:	03840413          	addi	s0,s0,56
ffffffffc0205360:	e6cff0ef          	jal	ra,ffffffffc02049cc <fd_array_dup>
ffffffffc0205364:	03848493          	addi	s1,s1,56
ffffffffc0205368:	fe8913e3          	bne	s2,s0,ffffffffc020534e <dup_files+0x48>
ffffffffc020536c:	70a2                	ld	ra,40(sp)
ffffffffc020536e:	7402                	ld	s0,32(sp)
ffffffffc0205370:	64e2                	ld	s1,24(sp)
ffffffffc0205372:	6942                	ld	s2,16(sp)
ffffffffc0205374:	69a2                	ld	s3,8(sp)
ffffffffc0205376:	6a02                	ld	s4,0(sp)
ffffffffc0205378:	4501                	li	a0,0
ffffffffc020537a:	6145                	addi	sp,sp,48
ffffffffc020537c:	8082                	ret
ffffffffc020537e:	00008697          	auipc	a3,0x8
ffffffffc0205382:	94a68693          	addi	a3,a3,-1718 # ffffffffc020ccc8 <default_pmm_manager+0x8d8>
ffffffffc0205386:	00006617          	auipc	a2,0x6
ffffffffc020538a:	58260613          	addi	a2,a2,1410 # ffffffffc020b908 <commands+0x210>
ffffffffc020538e:	05300593          	li	a1,83
ffffffffc0205392:	00008517          	auipc	a0,0x8
ffffffffc0205396:	fce50513          	addi	a0,a0,-50 # ffffffffc020d360 <CSWTCH.79+0x48>
ffffffffc020539a:	904fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020539e:	00008697          	auipc	a3,0x8
ffffffffc02053a2:	fea68693          	addi	a3,a3,-22 # ffffffffc020d388 <CSWTCH.79+0x70>
ffffffffc02053a6:	00006617          	auipc	a2,0x6
ffffffffc02053aa:	56260613          	addi	a2,a2,1378 # ffffffffc020b908 <commands+0x210>
ffffffffc02053ae:	05400593          	li	a1,84
ffffffffc02053b2:	00008517          	auipc	a0,0x8
ffffffffc02053b6:	fae50513          	addi	a0,a0,-82 # ffffffffc020d360 <CSWTCH.79+0x48>
ffffffffc02053ba:	8e4fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02053be <iobuf_skip.part.0>:
ffffffffc02053be:	1141                	addi	sp,sp,-16
ffffffffc02053c0:	00008697          	auipc	a3,0x8
ffffffffc02053c4:	ff868693          	addi	a3,a3,-8 # ffffffffc020d3b8 <CSWTCH.79+0xa0>
ffffffffc02053c8:	00006617          	auipc	a2,0x6
ffffffffc02053cc:	54060613          	addi	a2,a2,1344 # ffffffffc020b908 <commands+0x210>
ffffffffc02053d0:	04a00593          	li	a1,74
ffffffffc02053d4:	00008517          	auipc	a0,0x8
ffffffffc02053d8:	ffc50513          	addi	a0,a0,-4 # ffffffffc020d3d0 <CSWTCH.79+0xb8>
ffffffffc02053dc:	e406                	sd	ra,8(sp)
ffffffffc02053de:	8c0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02053e2 <iobuf_init>:
ffffffffc02053e2:	e10c                	sd	a1,0(a0)
ffffffffc02053e4:	e514                	sd	a3,8(a0)
ffffffffc02053e6:	ed10                	sd	a2,24(a0)
ffffffffc02053e8:	e910                	sd	a2,16(a0)
ffffffffc02053ea:	8082                	ret

ffffffffc02053ec <iobuf_move>:
ffffffffc02053ec:	7179                	addi	sp,sp,-48
ffffffffc02053ee:	ec26                	sd	s1,24(sp)
ffffffffc02053f0:	6d04                	ld	s1,24(a0)
ffffffffc02053f2:	f022                	sd	s0,32(sp)
ffffffffc02053f4:	e84a                	sd	s2,16(sp)
ffffffffc02053f6:	e44e                	sd	s3,8(sp)
ffffffffc02053f8:	f406                	sd	ra,40(sp)
ffffffffc02053fa:	842a                	mv	s0,a0
ffffffffc02053fc:	8932                	mv	s2,a2
ffffffffc02053fe:	852e                	mv	a0,a1
ffffffffc0205400:	89ba                	mv	s3,a4
ffffffffc0205402:	00967363          	bgeu	a2,s1,ffffffffc0205408 <iobuf_move+0x1c>
ffffffffc0205406:	84b2                	mv	s1,a2
ffffffffc0205408:	c495                	beqz	s1,ffffffffc0205434 <iobuf_move+0x48>
ffffffffc020540a:	600c                	ld	a1,0(s0)
ffffffffc020540c:	c681                	beqz	a3,ffffffffc0205414 <iobuf_move+0x28>
ffffffffc020540e:	87ae                	mv	a5,a1
ffffffffc0205410:	85aa                	mv	a1,a0
ffffffffc0205412:	853e                	mv	a0,a5
ffffffffc0205414:	8626                	mv	a2,s1
ffffffffc0205416:	020060ef          	jal	ra,ffffffffc020b436 <memmove>
ffffffffc020541a:	6c1c                	ld	a5,24(s0)
ffffffffc020541c:	0297ea63          	bltu	a5,s1,ffffffffc0205450 <iobuf_move+0x64>
ffffffffc0205420:	6014                	ld	a3,0(s0)
ffffffffc0205422:	6418                	ld	a4,8(s0)
ffffffffc0205424:	8f85                	sub	a5,a5,s1
ffffffffc0205426:	96a6                	add	a3,a3,s1
ffffffffc0205428:	9726                	add	a4,a4,s1
ffffffffc020542a:	e014                	sd	a3,0(s0)
ffffffffc020542c:	e418                	sd	a4,8(s0)
ffffffffc020542e:	ec1c                	sd	a5,24(s0)
ffffffffc0205430:	40990933          	sub	s2,s2,s1
ffffffffc0205434:	00098463          	beqz	s3,ffffffffc020543c <iobuf_move+0x50>
ffffffffc0205438:	0099b023          	sd	s1,0(s3)
ffffffffc020543c:	4501                	li	a0,0
ffffffffc020543e:	00091b63          	bnez	s2,ffffffffc0205454 <iobuf_move+0x68>
ffffffffc0205442:	70a2                	ld	ra,40(sp)
ffffffffc0205444:	7402                	ld	s0,32(sp)
ffffffffc0205446:	64e2                	ld	s1,24(sp)
ffffffffc0205448:	6942                	ld	s2,16(sp)
ffffffffc020544a:	69a2                	ld	s3,8(sp)
ffffffffc020544c:	6145                	addi	sp,sp,48
ffffffffc020544e:	8082                	ret
ffffffffc0205450:	f6fff0ef          	jal	ra,ffffffffc02053be <iobuf_skip.part.0>
ffffffffc0205454:	5571                	li	a0,-4
ffffffffc0205456:	b7f5                	j	ffffffffc0205442 <iobuf_move+0x56>

ffffffffc0205458 <iobuf_skip>:
ffffffffc0205458:	6d1c                	ld	a5,24(a0)
ffffffffc020545a:	00b7eb63          	bltu	a5,a1,ffffffffc0205470 <iobuf_skip+0x18>
ffffffffc020545e:	6114                	ld	a3,0(a0)
ffffffffc0205460:	6518                	ld	a4,8(a0)
ffffffffc0205462:	8f8d                	sub	a5,a5,a1
ffffffffc0205464:	96ae                	add	a3,a3,a1
ffffffffc0205466:	95ba                	add	a1,a1,a4
ffffffffc0205468:	e114                	sd	a3,0(a0)
ffffffffc020546a:	e50c                	sd	a1,8(a0)
ffffffffc020546c:	ed1c                	sd	a5,24(a0)
ffffffffc020546e:	8082                	ret
ffffffffc0205470:	1141                	addi	sp,sp,-16
ffffffffc0205472:	e406                	sd	ra,8(sp)
ffffffffc0205474:	f4bff0ef          	jal	ra,ffffffffc02053be <iobuf_skip.part.0>

ffffffffc0205478 <copy_path>:
ffffffffc0205478:	7139                	addi	sp,sp,-64
ffffffffc020547a:	f04a                	sd	s2,32(sp)
ffffffffc020547c:	00091917          	auipc	s2,0x91
ffffffffc0205480:	44490913          	addi	s2,s2,1092 # ffffffffc02968c0 <current>
ffffffffc0205484:	00093703          	ld	a4,0(s2)
ffffffffc0205488:	ec4e                	sd	s3,24(sp)
ffffffffc020548a:	89aa                	mv	s3,a0
ffffffffc020548c:	6505                	lui	a0,0x1
ffffffffc020548e:	f426                	sd	s1,40(sp)
ffffffffc0205490:	e852                	sd	s4,16(sp)
ffffffffc0205492:	fc06                	sd	ra,56(sp)
ffffffffc0205494:	f822                	sd	s0,48(sp)
ffffffffc0205496:	e456                	sd	s5,8(sp)
ffffffffc0205498:	02873a03          	ld	s4,40(a4)
ffffffffc020549c:	84ae                	mv	s1,a1
ffffffffc020549e:	af1fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02054a2:	c141                	beqz	a0,ffffffffc0205522 <copy_path+0xaa>
ffffffffc02054a4:	842a                	mv	s0,a0
ffffffffc02054a6:	040a0563          	beqz	s4,ffffffffc02054f0 <copy_path+0x78>
ffffffffc02054aa:	038a0a93          	addi	s5,s4,56
ffffffffc02054ae:	8556                	mv	a0,s5
ffffffffc02054b0:	8b4ff0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02054b4:	00093783          	ld	a5,0(s2)
ffffffffc02054b8:	cba1                	beqz	a5,ffffffffc0205508 <copy_path+0x90>
ffffffffc02054ba:	43dc                	lw	a5,4(a5)
ffffffffc02054bc:	6685                	lui	a3,0x1
ffffffffc02054be:	8626                	mv	a2,s1
ffffffffc02054c0:	04fa2823          	sw	a5,80(s4)
ffffffffc02054c4:	85a2                	mv	a1,s0
ffffffffc02054c6:	8552                	mv	a0,s4
ffffffffc02054c8:	ec5fe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc02054cc:	c529                	beqz	a0,ffffffffc0205516 <copy_path+0x9e>
ffffffffc02054ce:	8556                	mv	a0,s5
ffffffffc02054d0:	890ff0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02054d4:	040a2823          	sw	zero,80(s4)
ffffffffc02054d8:	0089b023          	sd	s0,0(s3)
ffffffffc02054dc:	4501                	li	a0,0
ffffffffc02054de:	70e2                	ld	ra,56(sp)
ffffffffc02054e0:	7442                	ld	s0,48(sp)
ffffffffc02054e2:	74a2                	ld	s1,40(sp)
ffffffffc02054e4:	7902                	ld	s2,32(sp)
ffffffffc02054e6:	69e2                	ld	s3,24(sp)
ffffffffc02054e8:	6a42                	ld	s4,16(sp)
ffffffffc02054ea:	6aa2                	ld	s5,8(sp)
ffffffffc02054ec:	6121                	addi	sp,sp,64
ffffffffc02054ee:	8082                	ret
ffffffffc02054f0:	85aa                	mv	a1,a0
ffffffffc02054f2:	6685                	lui	a3,0x1
ffffffffc02054f4:	8626                	mv	a2,s1
ffffffffc02054f6:	4501                	li	a0,0
ffffffffc02054f8:	e95fe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc02054fc:	fd71                	bnez	a0,ffffffffc02054d8 <copy_path+0x60>
ffffffffc02054fe:	8522                	mv	a0,s0
ffffffffc0205500:	b3ffc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205504:	5575                	li	a0,-3
ffffffffc0205506:	bfe1                	j	ffffffffc02054de <copy_path+0x66>
ffffffffc0205508:	6685                	lui	a3,0x1
ffffffffc020550a:	8626                	mv	a2,s1
ffffffffc020550c:	85a2                	mv	a1,s0
ffffffffc020550e:	8552                	mv	a0,s4
ffffffffc0205510:	e7dfe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc0205514:	fd4d                	bnez	a0,ffffffffc02054ce <copy_path+0x56>
ffffffffc0205516:	8556                	mv	a0,s5
ffffffffc0205518:	848ff0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020551c:	040a2823          	sw	zero,80(s4)
ffffffffc0205520:	bff9                	j	ffffffffc02054fe <copy_path+0x86>
ffffffffc0205522:	5571                	li	a0,-4
ffffffffc0205524:	bf6d                	j	ffffffffc02054de <copy_path+0x66>

ffffffffc0205526 <sysfile_open>:
ffffffffc0205526:	7179                	addi	sp,sp,-48
ffffffffc0205528:	872a                	mv	a4,a0
ffffffffc020552a:	ec26                	sd	s1,24(sp)
ffffffffc020552c:	0028                	addi	a0,sp,8
ffffffffc020552e:	84ae                	mv	s1,a1
ffffffffc0205530:	85ba                	mv	a1,a4
ffffffffc0205532:	f022                	sd	s0,32(sp)
ffffffffc0205534:	f406                	sd	ra,40(sp)
ffffffffc0205536:	f43ff0ef          	jal	ra,ffffffffc0205478 <copy_path>
ffffffffc020553a:	842a                	mv	s0,a0
ffffffffc020553c:	e909                	bnez	a0,ffffffffc020554e <sysfile_open+0x28>
ffffffffc020553e:	6522                	ld	a0,8(sp)
ffffffffc0205540:	85a6                	mv	a1,s1
ffffffffc0205542:	d60ff0ef          	jal	ra,ffffffffc0204aa2 <file_open>
ffffffffc0205546:	842a                	mv	s0,a0
ffffffffc0205548:	6522                	ld	a0,8(sp)
ffffffffc020554a:	af5fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020554e:	70a2                	ld	ra,40(sp)
ffffffffc0205550:	8522                	mv	a0,s0
ffffffffc0205552:	7402                	ld	s0,32(sp)
ffffffffc0205554:	64e2                	ld	s1,24(sp)
ffffffffc0205556:	6145                	addi	sp,sp,48
ffffffffc0205558:	8082                	ret

ffffffffc020555a <sysfile_close>:
ffffffffc020555a:	e46ff06f          	j	ffffffffc0204ba0 <file_close>

ffffffffc020555e <sysfile_read>:
ffffffffc020555e:	7159                	addi	sp,sp,-112
ffffffffc0205560:	f0a2                	sd	s0,96(sp)
ffffffffc0205562:	f486                	sd	ra,104(sp)
ffffffffc0205564:	eca6                	sd	s1,88(sp)
ffffffffc0205566:	e8ca                	sd	s2,80(sp)
ffffffffc0205568:	e4ce                	sd	s3,72(sp)
ffffffffc020556a:	e0d2                	sd	s4,64(sp)
ffffffffc020556c:	fc56                	sd	s5,56(sp)
ffffffffc020556e:	f85a                	sd	s6,48(sp)
ffffffffc0205570:	f45e                	sd	s7,40(sp)
ffffffffc0205572:	f062                	sd	s8,32(sp)
ffffffffc0205574:	ec66                	sd	s9,24(sp)
ffffffffc0205576:	4401                	li	s0,0
ffffffffc0205578:	ee19                	bnez	a2,ffffffffc0205596 <sysfile_read+0x38>
ffffffffc020557a:	70a6                	ld	ra,104(sp)
ffffffffc020557c:	8522                	mv	a0,s0
ffffffffc020557e:	7406                	ld	s0,96(sp)
ffffffffc0205580:	64e6                	ld	s1,88(sp)
ffffffffc0205582:	6946                	ld	s2,80(sp)
ffffffffc0205584:	69a6                	ld	s3,72(sp)
ffffffffc0205586:	6a06                	ld	s4,64(sp)
ffffffffc0205588:	7ae2                	ld	s5,56(sp)
ffffffffc020558a:	7b42                	ld	s6,48(sp)
ffffffffc020558c:	7ba2                	ld	s7,40(sp)
ffffffffc020558e:	7c02                	ld	s8,32(sp)
ffffffffc0205590:	6ce2                	ld	s9,24(sp)
ffffffffc0205592:	6165                	addi	sp,sp,112
ffffffffc0205594:	8082                	ret
ffffffffc0205596:	00091c97          	auipc	s9,0x91
ffffffffc020559a:	32ac8c93          	addi	s9,s9,810 # ffffffffc02968c0 <current>
ffffffffc020559e:	000cb783          	ld	a5,0(s9)
ffffffffc02055a2:	84b2                	mv	s1,a2
ffffffffc02055a4:	8b2e                	mv	s6,a1
ffffffffc02055a6:	4601                	li	a2,0
ffffffffc02055a8:	4585                	li	a1,1
ffffffffc02055aa:	0287b903          	ld	s2,40(a5)
ffffffffc02055ae:	8aaa                	mv	s5,a0
ffffffffc02055b0:	c9eff0ef          	jal	ra,ffffffffc0204a4e <file_testfd>
ffffffffc02055b4:	c959                	beqz	a0,ffffffffc020564a <sysfile_read+0xec>
ffffffffc02055b6:	6505                	lui	a0,0x1
ffffffffc02055b8:	9d7fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02055bc:	89aa                	mv	s3,a0
ffffffffc02055be:	c941                	beqz	a0,ffffffffc020564e <sysfile_read+0xf0>
ffffffffc02055c0:	4b81                	li	s7,0
ffffffffc02055c2:	6a05                	lui	s4,0x1
ffffffffc02055c4:	03890c13          	addi	s8,s2,56
ffffffffc02055c8:	0744ec63          	bltu	s1,s4,ffffffffc0205640 <sysfile_read+0xe2>
ffffffffc02055cc:	e452                	sd	s4,8(sp)
ffffffffc02055ce:	6605                	lui	a2,0x1
ffffffffc02055d0:	0034                	addi	a3,sp,8
ffffffffc02055d2:	85ce                	mv	a1,s3
ffffffffc02055d4:	8556                	mv	a0,s5
ffffffffc02055d6:	e20ff0ef          	jal	ra,ffffffffc0204bf6 <file_read>
ffffffffc02055da:	66a2                	ld	a3,8(sp)
ffffffffc02055dc:	842a                	mv	s0,a0
ffffffffc02055de:	ca9d                	beqz	a3,ffffffffc0205614 <sysfile_read+0xb6>
ffffffffc02055e0:	00090c63          	beqz	s2,ffffffffc02055f8 <sysfile_read+0x9a>
ffffffffc02055e4:	8562                	mv	a0,s8
ffffffffc02055e6:	f7ffe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02055ea:	000cb783          	ld	a5,0(s9)
ffffffffc02055ee:	cfa1                	beqz	a5,ffffffffc0205646 <sysfile_read+0xe8>
ffffffffc02055f0:	43dc                	lw	a5,4(a5)
ffffffffc02055f2:	66a2                	ld	a3,8(sp)
ffffffffc02055f4:	04f92823          	sw	a5,80(s2)
ffffffffc02055f8:	864e                	mv	a2,s3
ffffffffc02055fa:	85da                	mv	a1,s6
ffffffffc02055fc:	854a                	mv	a0,s2
ffffffffc02055fe:	d5dfe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205602:	c50d                	beqz	a0,ffffffffc020562c <sysfile_read+0xce>
ffffffffc0205604:	67a2                	ld	a5,8(sp)
ffffffffc0205606:	04f4e663          	bltu	s1,a5,ffffffffc0205652 <sysfile_read+0xf4>
ffffffffc020560a:	9b3e                	add	s6,s6,a5
ffffffffc020560c:	8c9d                	sub	s1,s1,a5
ffffffffc020560e:	9bbe                	add	s7,s7,a5
ffffffffc0205610:	02091263          	bnez	s2,ffffffffc0205634 <sysfile_read+0xd6>
ffffffffc0205614:	e401                	bnez	s0,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc0205616:	67a2                	ld	a5,8(sp)
ffffffffc0205618:	c391                	beqz	a5,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc020561a:	f4dd                	bnez	s1,ffffffffc02055c8 <sysfile_read+0x6a>
ffffffffc020561c:	854e                	mv	a0,s3
ffffffffc020561e:	a21fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205622:	f40b8ce3          	beqz	s7,ffffffffc020557a <sysfile_read+0x1c>
ffffffffc0205626:	000b841b          	sext.w	s0,s7
ffffffffc020562a:	bf81                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc020562c:	e011                	bnez	s0,ffffffffc0205630 <sysfile_read+0xd2>
ffffffffc020562e:	5475                	li	s0,-3
ffffffffc0205630:	fe0906e3          	beqz	s2,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc0205634:	8562                	mv	a0,s8
ffffffffc0205636:	f2bfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020563a:	04092823          	sw	zero,80(s2)
ffffffffc020563e:	bfd9                	j	ffffffffc0205614 <sysfile_read+0xb6>
ffffffffc0205640:	e426                	sd	s1,8(sp)
ffffffffc0205642:	8626                	mv	a2,s1
ffffffffc0205644:	b771                	j	ffffffffc02055d0 <sysfile_read+0x72>
ffffffffc0205646:	66a2                	ld	a3,8(sp)
ffffffffc0205648:	bf45                	j	ffffffffc02055f8 <sysfile_read+0x9a>
ffffffffc020564a:	5475                	li	s0,-3
ffffffffc020564c:	b73d                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc020564e:	5471                	li	s0,-4
ffffffffc0205650:	b72d                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc0205652:	00008697          	auipc	a3,0x8
ffffffffc0205656:	d8e68693          	addi	a3,a3,-626 # ffffffffc020d3e0 <CSWTCH.79+0xc8>
ffffffffc020565a:	00006617          	auipc	a2,0x6
ffffffffc020565e:	2ae60613          	addi	a2,a2,686 # ffffffffc020b908 <commands+0x210>
ffffffffc0205662:	05600593          	li	a1,86
ffffffffc0205666:	00008517          	auipc	a0,0x8
ffffffffc020566a:	d8a50513          	addi	a0,a0,-630 # ffffffffc020d3f0 <CSWTCH.79+0xd8>
ffffffffc020566e:	e31fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205672 <sysfile_write>:
ffffffffc0205672:	7159                	addi	sp,sp,-112
ffffffffc0205674:	e8ca                	sd	s2,80(sp)
ffffffffc0205676:	f486                	sd	ra,104(sp)
ffffffffc0205678:	f0a2                	sd	s0,96(sp)
ffffffffc020567a:	eca6                	sd	s1,88(sp)
ffffffffc020567c:	e4ce                	sd	s3,72(sp)
ffffffffc020567e:	e0d2                	sd	s4,64(sp)
ffffffffc0205680:	fc56                	sd	s5,56(sp)
ffffffffc0205682:	f85a                	sd	s6,48(sp)
ffffffffc0205684:	f45e                	sd	s7,40(sp)
ffffffffc0205686:	f062                	sd	s8,32(sp)
ffffffffc0205688:	ec66                	sd	s9,24(sp)
ffffffffc020568a:	4901                	li	s2,0
ffffffffc020568c:	ee19                	bnez	a2,ffffffffc02056aa <sysfile_write+0x38>
ffffffffc020568e:	70a6                	ld	ra,104(sp)
ffffffffc0205690:	7406                	ld	s0,96(sp)
ffffffffc0205692:	64e6                	ld	s1,88(sp)
ffffffffc0205694:	69a6                	ld	s3,72(sp)
ffffffffc0205696:	6a06                	ld	s4,64(sp)
ffffffffc0205698:	7ae2                	ld	s5,56(sp)
ffffffffc020569a:	7b42                	ld	s6,48(sp)
ffffffffc020569c:	7ba2                	ld	s7,40(sp)
ffffffffc020569e:	7c02                	ld	s8,32(sp)
ffffffffc02056a0:	6ce2                	ld	s9,24(sp)
ffffffffc02056a2:	854a                	mv	a0,s2
ffffffffc02056a4:	6946                	ld	s2,80(sp)
ffffffffc02056a6:	6165                	addi	sp,sp,112
ffffffffc02056a8:	8082                	ret
ffffffffc02056aa:	00091c17          	auipc	s8,0x91
ffffffffc02056ae:	216c0c13          	addi	s8,s8,534 # ffffffffc02968c0 <current>
ffffffffc02056b2:	000c3783          	ld	a5,0(s8)
ffffffffc02056b6:	8432                	mv	s0,a2
ffffffffc02056b8:	89ae                	mv	s3,a1
ffffffffc02056ba:	4605                	li	a2,1
ffffffffc02056bc:	4581                	li	a1,0
ffffffffc02056be:	7784                	ld	s1,40(a5)
ffffffffc02056c0:	8baa                	mv	s7,a0
ffffffffc02056c2:	b8cff0ef          	jal	ra,ffffffffc0204a4e <file_testfd>
ffffffffc02056c6:	cd59                	beqz	a0,ffffffffc0205764 <sysfile_write+0xf2>
ffffffffc02056c8:	6505                	lui	a0,0x1
ffffffffc02056ca:	8c5fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02056ce:	8a2a                	mv	s4,a0
ffffffffc02056d0:	cd41                	beqz	a0,ffffffffc0205768 <sysfile_write+0xf6>
ffffffffc02056d2:	4c81                	li	s9,0
ffffffffc02056d4:	6a85                	lui	s5,0x1
ffffffffc02056d6:	03848b13          	addi	s6,s1,56
ffffffffc02056da:	05546a63          	bltu	s0,s5,ffffffffc020572e <sysfile_write+0xbc>
ffffffffc02056de:	e456                	sd	s5,8(sp)
ffffffffc02056e0:	c8a9                	beqz	s1,ffffffffc0205732 <sysfile_write+0xc0>
ffffffffc02056e2:	855a                	mv	a0,s6
ffffffffc02056e4:	e81fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02056e8:	000c3783          	ld	a5,0(s8)
ffffffffc02056ec:	c399                	beqz	a5,ffffffffc02056f2 <sysfile_write+0x80>
ffffffffc02056ee:	43dc                	lw	a5,4(a5)
ffffffffc02056f0:	c8bc                	sw	a5,80(s1)
ffffffffc02056f2:	66a2                	ld	a3,8(sp)
ffffffffc02056f4:	4701                	li	a4,0
ffffffffc02056f6:	864e                	mv	a2,s3
ffffffffc02056f8:	85d2                	mv	a1,s4
ffffffffc02056fa:	8526                	mv	a0,s1
ffffffffc02056fc:	c2bfe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc0205700:	c139                	beqz	a0,ffffffffc0205746 <sysfile_write+0xd4>
ffffffffc0205702:	855a                	mv	a0,s6
ffffffffc0205704:	e5dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205708:	0404a823          	sw	zero,80(s1)
ffffffffc020570c:	6622                	ld	a2,8(sp)
ffffffffc020570e:	0034                	addi	a3,sp,8
ffffffffc0205710:	85d2                	mv	a1,s4
ffffffffc0205712:	855e                	mv	a0,s7
ffffffffc0205714:	dc8ff0ef          	jal	ra,ffffffffc0204cdc <file_write>
ffffffffc0205718:	67a2                	ld	a5,8(sp)
ffffffffc020571a:	892a                	mv	s2,a0
ffffffffc020571c:	ef85                	bnez	a5,ffffffffc0205754 <sysfile_write+0xe2>
ffffffffc020571e:	8552                	mv	a0,s4
ffffffffc0205720:	91ffc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205724:	f60c85e3          	beqz	s9,ffffffffc020568e <sysfile_write+0x1c>
ffffffffc0205728:	000c891b          	sext.w	s2,s9
ffffffffc020572c:	b78d                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc020572e:	e422                	sd	s0,8(sp)
ffffffffc0205730:	f8cd                	bnez	s1,ffffffffc02056e2 <sysfile_write+0x70>
ffffffffc0205732:	66a2                	ld	a3,8(sp)
ffffffffc0205734:	4701                	li	a4,0
ffffffffc0205736:	864e                	mv	a2,s3
ffffffffc0205738:	85d2                	mv	a1,s4
ffffffffc020573a:	4501                	li	a0,0
ffffffffc020573c:	bebfe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc0205740:	f571                	bnez	a0,ffffffffc020570c <sysfile_write+0x9a>
ffffffffc0205742:	5975                	li	s2,-3
ffffffffc0205744:	bfe9                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205746:	855a                	mv	a0,s6
ffffffffc0205748:	e19fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020574c:	5975                	li	s2,-3
ffffffffc020574e:	0404a823          	sw	zero,80(s1)
ffffffffc0205752:	b7f1                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205754:	00f46c63          	bltu	s0,a5,ffffffffc020576c <sysfile_write+0xfa>
ffffffffc0205758:	99be                	add	s3,s3,a5
ffffffffc020575a:	8c1d                	sub	s0,s0,a5
ffffffffc020575c:	9cbe                	add	s9,s9,a5
ffffffffc020575e:	f161                	bnez	a0,ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205760:	fc2d                	bnez	s0,ffffffffc02056da <sysfile_write+0x68>
ffffffffc0205762:	bf75                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205764:	5975                	li	s2,-3
ffffffffc0205766:	b725                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc0205768:	5971                	li	s2,-4
ffffffffc020576a:	b715                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc020576c:	00008697          	auipc	a3,0x8
ffffffffc0205770:	c7468693          	addi	a3,a3,-908 # ffffffffc020d3e0 <CSWTCH.79+0xc8>
ffffffffc0205774:	00006617          	auipc	a2,0x6
ffffffffc0205778:	19460613          	addi	a2,a2,404 # ffffffffc020b908 <commands+0x210>
ffffffffc020577c:	08b00593          	li	a1,139
ffffffffc0205780:	00008517          	auipc	a0,0x8
ffffffffc0205784:	c7050513          	addi	a0,a0,-912 # ffffffffc020d3f0 <CSWTCH.79+0xd8>
ffffffffc0205788:	d17fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020578c <sysfile_seek>:
ffffffffc020578c:	e36ff06f          	j	ffffffffc0204dc2 <file_seek>

ffffffffc0205790 <sysfile_fstat>:
ffffffffc0205790:	715d                	addi	sp,sp,-80
ffffffffc0205792:	f44e                	sd	s3,40(sp)
ffffffffc0205794:	00091997          	auipc	s3,0x91
ffffffffc0205798:	12c98993          	addi	s3,s3,300 # ffffffffc02968c0 <current>
ffffffffc020579c:	0009b703          	ld	a4,0(s3)
ffffffffc02057a0:	fc26                	sd	s1,56(sp)
ffffffffc02057a2:	84ae                	mv	s1,a1
ffffffffc02057a4:	858a                	mv	a1,sp
ffffffffc02057a6:	e0a2                	sd	s0,64(sp)
ffffffffc02057a8:	f84a                	sd	s2,48(sp)
ffffffffc02057aa:	e486                	sd	ra,72(sp)
ffffffffc02057ac:	02873903          	ld	s2,40(a4)
ffffffffc02057b0:	f052                	sd	s4,32(sp)
ffffffffc02057b2:	f30ff0ef          	jal	ra,ffffffffc0204ee2 <file_fstat>
ffffffffc02057b6:	842a                	mv	s0,a0
ffffffffc02057b8:	e91d                	bnez	a0,ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc02057ba:	04090363          	beqz	s2,ffffffffc0205800 <sysfile_fstat+0x70>
ffffffffc02057be:	03890a13          	addi	s4,s2,56
ffffffffc02057c2:	8552                	mv	a0,s4
ffffffffc02057c4:	da1fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02057c8:	0009b783          	ld	a5,0(s3)
ffffffffc02057cc:	c3b9                	beqz	a5,ffffffffc0205812 <sysfile_fstat+0x82>
ffffffffc02057ce:	43dc                	lw	a5,4(a5)
ffffffffc02057d0:	02000693          	li	a3,32
ffffffffc02057d4:	860a                	mv	a2,sp
ffffffffc02057d6:	04f92823          	sw	a5,80(s2)
ffffffffc02057da:	85a6                	mv	a1,s1
ffffffffc02057dc:	854a                	mv	a0,s2
ffffffffc02057de:	b7dfe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc02057e2:	c121                	beqz	a0,ffffffffc0205822 <sysfile_fstat+0x92>
ffffffffc02057e4:	8552                	mv	a0,s4
ffffffffc02057e6:	d7bfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02057ea:	04092823          	sw	zero,80(s2)
ffffffffc02057ee:	60a6                	ld	ra,72(sp)
ffffffffc02057f0:	8522                	mv	a0,s0
ffffffffc02057f2:	6406                	ld	s0,64(sp)
ffffffffc02057f4:	74e2                	ld	s1,56(sp)
ffffffffc02057f6:	7942                	ld	s2,48(sp)
ffffffffc02057f8:	79a2                	ld	s3,40(sp)
ffffffffc02057fa:	7a02                	ld	s4,32(sp)
ffffffffc02057fc:	6161                	addi	sp,sp,80
ffffffffc02057fe:	8082                	ret
ffffffffc0205800:	02000693          	li	a3,32
ffffffffc0205804:	860a                	mv	a2,sp
ffffffffc0205806:	85a6                	mv	a1,s1
ffffffffc0205808:	b53fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc020580c:	f16d                	bnez	a0,ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc020580e:	5475                	li	s0,-3
ffffffffc0205810:	bff9                	j	ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc0205812:	02000693          	li	a3,32
ffffffffc0205816:	860a                	mv	a2,sp
ffffffffc0205818:	85a6                	mv	a1,s1
ffffffffc020581a:	854a                	mv	a0,s2
ffffffffc020581c:	b3ffe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205820:	f171                	bnez	a0,ffffffffc02057e4 <sysfile_fstat+0x54>
ffffffffc0205822:	8552                	mv	a0,s4
ffffffffc0205824:	d3dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205828:	5475                	li	s0,-3
ffffffffc020582a:	04092823          	sw	zero,80(s2)
ffffffffc020582e:	b7c1                	j	ffffffffc02057ee <sysfile_fstat+0x5e>

ffffffffc0205830 <sysfile_fsync>:
ffffffffc0205830:	f72ff06f          	j	ffffffffc0204fa2 <file_fsync>

ffffffffc0205834 <sysfile_getcwd>:
ffffffffc0205834:	715d                	addi	sp,sp,-80
ffffffffc0205836:	f44e                	sd	s3,40(sp)
ffffffffc0205838:	00091997          	auipc	s3,0x91
ffffffffc020583c:	08898993          	addi	s3,s3,136 # ffffffffc02968c0 <current>
ffffffffc0205840:	0009b783          	ld	a5,0(s3)
ffffffffc0205844:	f84a                	sd	s2,48(sp)
ffffffffc0205846:	e486                	sd	ra,72(sp)
ffffffffc0205848:	e0a2                	sd	s0,64(sp)
ffffffffc020584a:	fc26                	sd	s1,56(sp)
ffffffffc020584c:	f052                	sd	s4,32(sp)
ffffffffc020584e:	0287b903          	ld	s2,40(a5)
ffffffffc0205852:	cda9                	beqz	a1,ffffffffc02058ac <sysfile_getcwd+0x78>
ffffffffc0205854:	842e                	mv	s0,a1
ffffffffc0205856:	84aa                	mv	s1,a0
ffffffffc0205858:	04090363          	beqz	s2,ffffffffc020589e <sysfile_getcwd+0x6a>
ffffffffc020585c:	03890a13          	addi	s4,s2,56
ffffffffc0205860:	8552                	mv	a0,s4
ffffffffc0205862:	d03fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205866:	0009b783          	ld	a5,0(s3)
ffffffffc020586a:	c781                	beqz	a5,ffffffffc0205872 <sysfile_getcwd+0x3e>
ffffffffc020586c:	43dc                	lw	a5,4(a5)
ffffffffc020586e:	04f92823          	sw	a5,80(s2)
ffffffffc0205872:	4685                	li	a3,1
ffffffffc0205874:	8622                	mv	a2,s0
ffffffffc0205876:	85a6                	mv	a1,s1
ffffffffc0205878:	854a                	mv	a0,s2
ffffffffc020587a:	a19fe0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc020587e:	e90d                	bnez	a0,ffffffffc02058b0 <sysfile_getcwd+0x7c>
ffffffffc0205880:	5475                	li	s0,-3
ffffffffc0205882:	8552                	mv	a0,s4
ffffffffc0205884:	cddfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205888:	04092823          	sw	zero,80(s2)
ffffffffc020588c:	60a6                	ld	ra,72(sp)
ffffffffc020588e:	8522                	mv	a0,s0
ffffffffc0205890:	6406                	ld	s0,64(sp)
ffffffffc0205892:	74e2                	ld	s1,56(sp)
ffffffffc0205894:	7942                	ld	s2,48(sp)
ffffffffc0205896:	79a2                	ld	s3,40(sp)
ffffffffc0205898:	7a02                	ld	s4,32(sp)
ffffffffc020589a:	6161                	addi	sp,sp,80
ffffffffc020589c:	8082                	ret
ffffffffc020589e:	862e                	mv	a2,a1
ffffffffc02058a0:	4685                	li	a3,1
ffffffffc02058a2:	85aa                	mv	a1,a0
ffffffffc02058a4:	4501                	li	a0,0
ffffffffc02058a6:	9edfe0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc02058aa:	ed09                	bnez	a0,ffffffffc02058c4 <sysfile_getcwd+0x90>
ffffffffc02058ac:	5475                	li	s0,-3
ffffffffc02058ae:	bff9                	j	ffffffffc020588c <sysfile_getcwd+0x58>
ffffffffc02058b0:	8622                	mv	a2,s0
ffffffffc02058b2:	4681                	li	a3,0
ffffffffc02058b4:	85a6                	mv	a1,s1
ffffffffc02058b6:	850a                	mv	a0,sp
ffffffffc02058b8:	b2bff0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02058bc:	2dd020ef          	jal	ra,ffffffffc0208398 <vfs_getcwd>
ffffffffc02058c0:	842a                	mv	s0,a0
ffffffffc02058c2:	b7c1                	j	ffffffffc0205882 <sysfile_getcwd+0x4e>
ffffffffc02058c4:	8622                	mv	a2,s0
ffffffffc02058c6:	4681                	li	a3,0
ffffffffc02058c8:	85a6                	mv	a1,s1
ffffffffc02058ca:	850a                	mv	a0,sp
ffffffffc02058cc:	b17ff0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02058d0:	2c9020ef          	jal	ra,ffffffffc0208398 <vfs_getcwd>
ffffffffc02058d4:	842a                	mv	s0,a0
ffffffffc02058d6:	bf5d                	j	ffffffffc020588c <sysfile_getcwd+0x58>

ffffffffc02058d8 <sysfile_getdirentry>:
ffffffffc02058d8:	7139                	addi	sp,sp,-64
ffffffffc02058da:	e852                	sd	s4,16(sp)
ffffffffc02058dc:	00091a17          	auipc	s4,0x91
ffffffffc02058e0:	fe4a0a13          	addi	s4,s4,-28 # ffffffffc02968c0 <current>
ffffffffc02058e4:	000a3703          	ld	a4,0(s4)
ffffffffc02058e8:	ec4e                	sd	s3,24(sp)
ffffffffc02058ea:	89aa                	mv	s3,a0
ffffffffc02058ec:	10800513          	li	a0,264
ffffffffc02058f0:	f426                	sd	s1,40(sp)
ffffffffc02058f2:	f04a                	sd	s2,32(sp)
ffffffffc02058f4:	fc06                	sd	ra,56(sp)
ffffffffc02058f6:	f822                	sd	s0,48(sp)
ffffffffc02058f8:	e456                	sd	s5,8(sp)
ffffffffc02058fa:	7704                	ld	s1,40(a4)
ffffffffc02058fc:	892e                	mv	s2,a1
ffffffffc02058fe:	e90fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205902:	c169                	beqz	a0,ffffffffc02059c4 <sysfile_getdirentry+0xec>
ffffffffc0205904:	842a                	mv	s0,a0
ffffffffc0205906:	c8c1                	beqz	s1,ffffffffc0205996 <sysfile_getdirentry+0xbe>
ffffffffc0205908:	03848a93          	addi	s5,s1,56
ffffffffc020590c:	8556                	mv	a0,s5
ffffffffc020590e:	c57fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205912:	000a3783          	ld	a5,0(s4)
ffffffffc0205916:	c399                	beqz	a5,ffffffffc020591c <sysfile_getdirentry+0x44>
ffffffffc0205918:	43dc                	lw	a5,4(a5)
ffffffffc020591a:	c8bc                	sw	a5,80(s1)
ffffffffc020591c:	4705                	li	a4,1
ffffffffc020591e:	46a1                	li	a3,8
ffffffffc0205920:	864a                	mv	a2,s2
ffffffffc0205922:	85a2                	mv	a1,s0
ffffffffc0205924:	8526                	mv	a0,s1
ffffffffc0205926:	a01fe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc020592a:	e505                	bnez	a0,ffffffffc0205952 <sysfile_getdirentry+0x7a>
ffffffffc020592c:	8556                	mv	a0,s5
ffffffffc020592e:	c33fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205932:	59f5                	li	s3,-3
ffffffffc0205934:	0404a823          	sw	zero,80(s1)
ffffffffc0205938:	8522                	mv	a0,s0
ffffffffc020593a:	f04fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020593e:	70e2                	ld	ra,56(sp)
ffffffffc0205940:	7442                	ld	s0,48(sp)
ffffffffc0205942:	74a2                	ld	s1,40(sp)
ffffffffc0205944:	7902                	ld	s2,32(sp)
ffffffffc0205946:	6a42                	ld	s4,16(sp)
ffffffffc0205948:	6aa2                	ld	s5,8(sp)
ffffffffc020594a:	854e                	mv	a0,s3
ffffffffc020594c:	69e2                	ld	s3,24(sp)
ffffffffc020594e:	6121                	addi	sp,sp,64
ffffffffc0205950:	8082                	ret
ffffffffc0205952:	8556                	mv	a0,s5
ffffffffc0205954:	c0dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205958:	854e                	mv	a0,s3
ffffffffc020595a:	85a2                	mv	a1,s0
ffffffffc020595c:	0404a823          	sw	zero,80(s1)
ffffffffc0205960:	ef0ff0ef          	jal	ra,ffffffffc0205050 <file_getdirentry>
ffffffffc0205964:	89aa                	mv	s3,a0
ffffffffc0205966:	f969                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc0205968:	8556                	mv	a0,s5
ffffffffc020596a:	bfbfe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020596e:	000a3783          	ld	a5,0(s4)
ffffffffc0205972:	c399                	beqz	a5,ffffffffc0205978 <sysfile_getdirentry+0xa0>
ffffffffc0205974:	43dc                	lw	a5,4(a5)
ffffffffc0205976:	c8bc                	sw	a5,80(s1)
ffffffffc0205978:	10800693          	li	a3,264
ffffffffc020597c:	8622                	mv	a2,s0
ffffffffc020597e:	85ca                	mv	a1,s2
ffffffffc0205980:	8526                	mv	a0,s1
ffffffffc0205982:	9d9fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205986:	e111                	bnez	a0,ffffffffc020598a <sysfile_getdirentry+0xb2>
ffffffffc0205988:	59f5                	li	s3,-3
ffffffffc020598a:	8556                	mv	a0,s5
ffffffffc020598c:	bd5fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205990:	0404a823          	sw	zero,80(s1)
ffffffffc0205994:	b755                	j	ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc0205996:	85aa                	mv	a1,a0
ffffffffc0205998:	4705                	li	a4,1
ffffffffc020599a:	46a1                	li	a3,8
ffffffffc020599c:	864a                	mv	a2,s2
ffffffffc020599e:	4501                	li	a0,0
ffffffffc02059a0:	987fe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc02059a4:	cd11                	beqz	a0,ffffffffc02059c0 <sysfile_getdirentry+0xe8>
ffffffffc02059a6:	854e                	mv	a0,s3
ffffffffc02059a8:	85a2                	mv	a1,s0
ffffffffc02059aa:	ea6ff0ef          	jal	ra,ffffffffc0205050 <file_getdirentry>
ffffffffc02059ae:	89aa                	mv	s3,a0
ffffffffc02059b0:	f541                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059b2:	10800693          	li	a3,264
ffffffffc02059b6:	8622                	mv	a2,s0
ffffffffc02059b8:	85ca                	mv	a1,s2
ffffffffc02059ba:	9a1fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc02059be:	fd2d                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059c0:	59f5                	li	s3,-3
ffffffffc02059c2:	bf9d                	j	ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059c4:	59f1                	li	s3,-4
ffffffffc02059c6:	bfa5                	j	ffffffffc020593e <sysfile_getdirentry+0x66>

ffffffffc02059c8 <sysfile_dup>:
ffffffffc02059c8:	f6eff06f          	j	ffffffffc0205136 <file_dup>

ffffffffc02059cc <kernel_thread_entry>:
ffffffffc02059cc:	8526                	mv	a0,s1
ffffffffc02059ce:	9402                	jalr	s0
ffffffffc02059d0:	68e000ef          	jal	ra,ffffffffc020605e <do_exit>

ffffffffc02059d4 <alloc_proc>:
ffffffffc02059d4:	1141                	addi	sp,sp,-16
ffffffffc02059d6:	15000513          	li	a0,336
ffffffffc02059da:	e022                	sd	s0,0(sp)
ffffffffc02059dc:	e406                	sd	ra,8(sp)
ffffffffc02059de:	db0fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02059e2:	842a                	mv	s0,a0
ffffffffc02059e4:	c141                	beqz	a0,ffffffffc0205a64 <alloc_proc+0x90>
ffffffffc02059e6:	57fd                	li	a5,-1
ffffffffc02059e8:	1782                	slli	a5,a5,0x20
ffffffffc02059ea:	e11c                	sd	a5,0(a0)
ffffffffc02059ec:	07000613          	li	a2,112
ffffffffc02059f0:	4581                	li	a1,0
ffffffffc02059f2:	14053423          	sd	zero,328(a0)
ffffffffc02059f6:	00052423          	sw	zero,8(a0)
ffffffffc02059fa:	00053823          	sd	zero,16(a0)
ffffffffc02059fe:	00053c23          	sd	zero,24(a0)
ffffffffc0205a02:	02053023          	sd	zero,32(a0)
ffffffffc0205a06:	02053423          	sd	zero,40(a0)
ffffffffc0205a0a:	03050513          	addi	a0,a0,48
ffffffffc0205a0e:	217050ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0205a12:	00091797          	auipc	a5,0x91
ffffffffc0205a16:	e7e7b783          	ld	a5,-386(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205a1a:	f45c                	sd	a5,168(s0)
ffffffffc0205a1c:	0a043023          	sd	zero,160(s0)
ffffffffc0205a20:	0a042823          	sw	zero,176(s0)
ffffffffc0205a24:	463d                	li	a2,15
ffffffffc0205a26:	4581                	li	a1,0
ffffffffc0205a28:	0b440513          	addi	a0,s0,180
ffffffffc0205a2c:	1f9050ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0205a30:	11040793          	addi	a5,s0,272
ffffffffc0205a34:	0e042623          	sw	zero,236(s0)
ffffffffc0205a38:	0e043c23          	sd	zero,248(s0)
ffffffffc0205a3c:	10043023          	sd	zero,256(s0)
ffffffffc0205a40:	0e043823          	sd	zero,240(s0)
ffffffffc0205a44:	10043423          	sd	zero,264(s0)
ffffffffc0205a48:	10f43c23          	sd	a5,280(s0)
ffffffffc0205a4c:	10f43823          	sd	a5,272(s0)
ffffffffc0205a50:	12042023          	sw	zero,288(s0)
ffffffffc0205a54:	12043423          	sd	zero,296(s0)
ffffffffc0205a58:	12043823          	sd	zero,304(s0)
ffffffffc0205a5c:	12043c23          	sd	zero,312(s0)
ffffffffc0205a60:	14043023          	sd	zero,320(s0)
ffffffffc0205a64:	60a2                	ld	ra,8(sp)
ffffffffc0205a66:	8522                	mv	a0,s0
ffffffffc0205a68:	6402                	ld	s0,0(sp)
ffffffffc0205a6a:	0141                	addi	sp,sp,16
ffffffffc0205a6c:	8082                	ret

ffffffffc0205a6e <forkret>:
ffffffffc0205a6e:	00091797          	auipc	a5,0x91
ffffffffc0205a72:	e527b783          	ld	a5,-430(a5) # ffffffffc02968c0 <current>
ffffffffc0205a76:	73c8                	ld	a0,160(a5)
ffffffffc0205a78:	833fb06f          	j	ffffffffc02012aa <forkrets>

ffffffffc0205a7c <put_pgdir.isra.0>:
ffffffffc0205a7c:	1141                	addi	sp,sp,-16
ffffffffc0205a7e:	e406                	sd	ra,8(sp)
ffffffffc0205a80:	c02007b7          	lui	a5,0xc0200
ffffffffc0205a84:	02f56e63          	bltu	a0,a5,ffffffffc0205ac0 <put_pgdir.isra.0+0x44>
ffffffffc0205a88:	00091697          	auipc	a3,0x91
ffffffffc0205a8c:	e306b683          	ld	a3,-464(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205a90:	8d15                	sub	a0,a0,a3
ffffffffc0205a92:	8131                	srli	a0,a0,0xc
ffffffffc0205a94:	00091797          	auipc	a5,0x91
ffffffffc0205a98:	e0c7b783          	ld	a5,-500(a5) # ffffffffc02968a0 <npage>
ffffffffc0205a9c:	02f57f63          	bgeu	a0,a5,ffffffffc0205ada <put_pgdir.isra.0+0x5e>
ffffffffc0205aa0:	0000a697          	auipc	a3,0xa
ffffffffc0205aa4:	c906b683          	ld	a3,-880(a3) # ffffffffc020f730 <nbase>
ffffffffc0205aa8:	60a2                	ld	ra,8(sp)
ffffffffc0205aaa:	8d15                	sub	a0,a0,a3
ffffffffc0205aac:	00091797          	auipc	a5,0x91
ffffffffc0205ab0:	dfc7b783          	ld	a5,-516(a5) # ffffffffc02968a8 <pages>
ffffffffc0205ab4:	051a                	slli	a0,a0,0x6
ffffffffc0205ab6:	4585                	li	a1,1
ffffffffc0205ab8:	953e                	add	a0,a0,a5
ffffffffc0205aba:	0141                	addi	sp,sp,16
ffffffffc0205abc:	eeefc06f          	j	ffffffffc02021aa <free_pages>
ffffffffc0205ac0:	86aa                	mv	a3,a0
ffffffffc0205ac2:	00007617          	auipc	a2,0x7
ffffffffc0205ac6:	a0e60613          	addi	a2,a2,-1522 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0205aca:	07700593          	li	a1,119
ffffffffc0205ace:	00007517          	auipc	a0,0x7
ffffffffc0205ad2:	98250513          	addi	a0,a0,-1662 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205ad6:	9c9fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205ada:	00007617          	auipc	a2,0x7
ffffffffc0205ade:	a1e60613          	addi	a2,a2,-1506 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc0205ae2:	06900593          	li	a1,105
ffffffffc0205ae6:	00007517          	auipc	a0,0x7
ffffffffc0205aea:	96a50513          	addi	a0,a0,-1686 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205aee:	9b1fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205af2 <setup_pgdir>:
ffffffffc0205af2:	1101                	addi	sp,sp,-32
ffffffffc0205af4:	e426                	sd	s1,8(sp)
ffffffffc0205af6:	84aa                	mv	s1,a0
ffffffffc0205af8:	4505                	li	a0,1
ffffffffc0205afa:	ec06                	sd	ra,24(sp)
ffffffffc0205afc:	e822                	sd	s0,16(sp)
ffffffffc0205afe:	e6efc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205b02:	c939                	beqz	a0,ffffffffc0205b58 <setup_pgdir+0x66>
ffffffffc0205b04:	00091697          	auipc	a3,0x91
ffffffffc0205b08:	da46b683          	ld	a3,-604(a3) # ffffffffc02968a8 <pages>
ffffffffc0205b0c:	40d506b3          	sub	a3,a0,a3
ffffffffc0205b10:	8699                	srai	a3,a3,0x6
ffffffffc0205b12:	0000a417          	auipc	s0,0xa
ffffffffc0205b16:	c1e43403          	ld	s0,-994(s0) # ffffffffc020f730 <nbase>
ffffffffc0205b1a:	96a2                	add	a3,a3,s0
ffffffffc0205b1c:	00c69793          	slli	a5,a3,0xc
ffffffffc0205b20:	83b1                	srli	a5,a5,0xc
ffffffffc0205b22:	00091717          	auipc	a4,0x91
ffffffffc0205b26:	d7e73703          	ld	a4,-642(a4) # ffffffffc02968a0 <npage>
ffffffffc0205b2a:	06b2                	slli	a3,a3,0xc
ffffffffc0205b2c:	02e7f863          	bgeu	a5,a4,ffffffffc0205b5c <setup_pgdir+0x6a>
ffffffffc0205b30:	00091417          	auipc	s0,0x91
ffffffffc0205b34:	d8843403          	ld	s0,-632(s0) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205b38:	9436                	add	s0,s0,a3
ffffffffc0205b3a:	6605                	lui	a2,0x1
ffffffffc0205b3c:	00091597          	auipc	a1,0x91
ffffffffc0205b40:	d5c5b583          	ld	a1,-676(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0205b44:	8522                	mv	a0,s0
ffffffffc0205b46:	131050ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0205b4a:	4501                	li	a0,0
ffffffffc0205b4c:	ec80                	sd	s0,24(s1)
ffffffffc0205b4e:	60e2                	ld	ra,24(sp)
ffffffffc0205b50:	6442                	ld	s0,16(sp)
ffffffffc0205b52:	64a2                	ld	s1,8(sp)
ffffffffc0205b54:	6105                	addi	sp,sp,32
ffffffffc0205b56:	8082                	ret
ffffffffc0205b58:	5571                	li	a0,-4
ffffffffc0205b5a:	bfd5                	j	ffffffffc0205b4e <setup_pgdir+0x5c>
ffffffffc0205b5c:	00007617          	auipc	a2,0x7
ffffffffc0205b60:	8cc60613          	addi	a2,a2,-1844 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0205b64:	07100593          	li	a1,113
ffffffffc0205b68:	00007517          	auipc	a0,0x7
ffffffffc0205b6c:	8e850513          	addi	a0,a0,-1816 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205b70:	92ffa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205b74 <proc_run>:
ffffffffc0205b74:	7179                	addi	sp,sp,-48
ffffffffc0205b76:	ec26                	sd	s1,24(sp)
ffffffffc0205b78:	00091497          	auipc	s1,0x91
ffffffffc0205b7c:	d4848493          	addi	s1,s1,-696 # ffffffffc02968c0 <current>
ffffffffc0205b80:	f022                	sd	s0,32(sp)
ffffffffc0205b82:	e44e                	sd	s3,8(sp)
ffffffffc0205b84:	f406                	sd	ra,40(sp)
ffffffffc0205b86:	0004b983          	ld	s3,0(s1)
ffffffffc0205b8a:	e84a                	sd	s2,16(sp)
ffffffffc0205b8c:	842a                	mv	s0,a0
ffffffffc0205b8e:	100027f3          	csrr	a5,sstatus
ffffffffc0205b92:	8b89                	andi	a5,a5,2
ffffffffc0205b94:	4901                	li	s2,0
ffffffffc0205b96:	e7b9                	bnez	a5,ffffffffc0205be4 <proc_run+0x70>
ffffffffc0205b98:	745c                	ld	a5,168(s0)
ffffffffc0205b9a:	e080                	sd	s0,0(s1)
ffffffffc0205b9c:	e789                	bnez	a5,ffffffffc0205ba6 <proc_run+0x32>
ffffffffc0205b9e:	00091797          	auipc	a5,0x91
ffffffffc0205ba2:	cf27b783          	ld	a5,-782(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205ba6:	577d                	li	a4,-1
ffffffffc0205ba8:	177e                	slli	a4,a4,0x3f
ffffffffc0205baa:	83b1                	srli	a5,a5,0xc
ffffffffc0205bac:	8fd9                	or	a5,a5,a4
ffffffffc0205bae:	18079073          	csrw	satp,a5
ffffffffc0205bb2:	12000073          	sfence.vma
ffffffffc0205bb6:	03040593          	addi	a1,s0,48
ffffffffc0205bba:	03098513          	addi	a0,s3,48
ffffffffc0205bbe:	4a4010ef          	jal	ra,ffffffffc0207062 <switch_to>
ffffffffc0205bc2:	00091963          	bnez	s2,ffffffffc0205bd4 <proc_run+0x60>
ffffffffc0205bc6:	70a2                	ld	ra,40(sp)
ffffffffc0205bc8:	7402                	ld	s0,32(sp)
ffffffffc0205bca:	64e2                	ld	s1,24(sp)
ffffffffc0205bcc:	6942                	ld	s2,16(sp)
ffffffffc0205bce:	69a2                	ld	s3,8(sp)
ffffffffc0205bd0:	6145                	addi	sp,sp,48
ffffffffc0205bd2:	8082                	ret
ffffffffc0205bd4:	7402                	ld	s0,32(sp)
ffffffffc0205bd6:	70a2                	ld	ra,40(sp)
ffffffffc0205bd8:	64e2                	ld	s1,24(sp)
ffffffffc0205bda:	6942                	ld	s2,16(sp)
ffffffffc0205bdc:	69a2                	ld	s3,8(sp)
ffffffffc0205bde:	6145                	addi	sp,sp,48
ffffffffc0205be0:	88cfb06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0205be4:	88efb0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205be8:	4905                	li	s2,1
ffffffffc0205bea:	b77d                	j	ffffffffc0205b98 <proc_run+0x24>

ffffffffc0205bec <do_fork>:
ffffffffc0205bec:	7119                	addi	sp,sp,-128
ffffffffc0205bee:	ecce                	sd	s3,88(sp)
ffffffffc0205bf0:	00091997          	auipc	s3,0x91
ffffffffc0205bf4:	ce898993          	addi	s3,s3,-792 # ffffffffc02968d8 <nr_process>
ffffffffc0205bf8:	0009a703          	lw	a4,0(s3)
ffffffffc0205bfc:	fc86                	sd	ra,120(sp)
ffffffffc0205bfe:	f8a2                	sd	s0,112(sp)
ffffffffc0205c00:	f4a6                	sd	s1,104(sp)
ffffffffc0205c02:	f0ca                	sd	s2,96(sp)
ffffffffc0205c04:	e8d2                	sd	s4,80(sp)
ffffffffc0205c06:	e4d6                	sd	s5,72(sp)
ffffffffc0205c08:	e0da                	sd	s6,64(sp)
ffffffffc0205c0a:	fc5e                	sd	s7,56(sp)
ffffffffc0205c0c:	f862                	sd	s8,48(sp)
ffffffffc0205c0e:	f466                	sd	s9,40(sp)
ffffffffc0205c10:	f06a                	sd	s10,32(sp)
ffffffffc0205c12:	ec6e                	sd	s11,24(sp)
ffffffffc0205c14:	6785                	lui	a5,0x1
ffffffffc0205c16:	32f75163          	bge	a4,a5,ffffffffc0205f38 <do_fork+0x34c>
ffffffffc0205c1a:	84aa                	mv	s1,a0
ffffffffc0205c1c:	892e                	mv	s2,a1
ffffffffc0205c1e:	8432                	mv	s0,a2
ffffffffc0205c20:	db5ff0ef          	jal	ra,ffffffffc02059d4 <alloc_proc>
ffffffffc0205c24:	8aaa                	mv	s5,a0
ffffffffc0205c26:	32050c63          	beqz	a0,ffffffffc0205f5e <do_fork+0x372>
ffffffffc0205c2a:	00091b97          	auipc	s7,0x91
ffffffffc0205c2e:	c96b8b93          	addi	s7,s7,-874 # ffffffffc02968c0 <current>
ffffffffc0205c32:	000bb783          	ld	a5,0(s7)
ffffffffc0205c36:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205c3a:	f11c                	sd	a5,32(a0)
ffffffffc0205c3c:	34071463          	bnez	a4,ffffffffc0205f84 <do_fork+0x398>
ffffffffc0205c40:	4509                	li	a0,2
ffffffffc0205c42:	d2afc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205c46:	2e050363          	beqz	a0,ffffffffc0205f2c <do_fork+0x340>
ffffffffc0205c4a:	00091b17          	auipc	s6,0x91
ffffffffc0205c4e:	c5eb0b13          	addi	s6,s6,-930 # ffffffffc02968a8 <pages>
ffffffffc0205c52:	000b3683          	ld	a3,0(s6)
ffffffffc0205c56:	0000aa17          	auipc	s4,0xa
ffffffffc0205c5a:	adaa3a03          	ld	s4,-1318(s4) # ffffffffc020f730 <nbase>
ffffffffc0205c5e:	00091c17          	auipc	s8,0x91
ffffffffc0205c62:	c42c0c13          	addi	s8,s8,-958 # ffffffffc02968a0 <npage>
ffffffffc0205c66:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c6a:	8699                	srai	a3,a3,0x6
ffffffffc0205c6c:	96d2                	add	a3,a3,s4
ffffffffc0205c6e:	000c3703          	ld	a4,0(s8)
ffffffffc0205c72:	00c69793          	slli	a5,a3,0xc
ffffffffc0205c76:	83b1                	srli	a5,a5,0xc
ffffffffc0205c78:	06b2                	slli	a3,a3,0xc
ffffffffc0205c7a:	2ee7f963          	bgeu	a5,a4,ffffffffc0205f6c <do_fork+0x380>
ffffffffc0205c7e:	000bb703          	ld	a4,0(s7)
ffffffffc0205c82:	00091d17          	auipc	s10,0x91
ffffffffc0205c86:	c36d0d13          	addi	s10,s10,-970 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205c8a:	000d3783          	ld	a5,0(s10)
ffffffffc0205c8e:	02873c83          	ld	s9,40(a4)
ffffffffc0205c92:	96be                	add	a3,a3,a5
ffffffffc0205c94:	00dab823          	sd	a3,16(s5) # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc0205c98:	020c8a63          	beqz	s9,ffffffffc0205ccc <do_fork+0xe0>
ffffffffc0205c9c:	1004f793          	andi	a5,s1,256
ffffffffc0205ca0:	1c078c63          	beqz	a5,ffffffffc0205e78 <do_fork+0x28c>
ffffffffc0205ca4:	030ca703          	lw	a4,48(s9)
ffffffffc0205ca8:	018cb783          	ld	a5,24(s9)
ffffffffc0205cac:	c02006b7          	lui	a3,0xc0200
ffffffffc0205cb0:	2705                	addiw	a4,a4,1
ffffffffc0205cb2:	02eca823          	sw	a4,48(s9)
ffffffffc0205cb6:	039ab423          	sd	s9,40(s5)
ffffffffc0205cba:	32d7ed63          	bltu	a5,a3,ffffffffc0205ff4 <do_fork+0x408>
ffffffffc0205cbe:	000d3703          	ld	a4,0(s10)
ffffffffc0205cc2:	010ab683          	ld	a3,16(s5)
ffffffffc0205cc6:	8f99                	sub	a5,a5,a4
ffffffffc0205cc8:	0afab423          	sd	a5,168(s5)
ffffffffc0205ccc:	6789                	lui	a5,0x2
ffffffffc0205cce:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205cd2:	96be                	add	a3,a3,a5
ffffffffc0205cd4:	0adab023          	sd	a3,160(s5)
ffffffffc0205cd8:	87b6                	mv	a5,a3
ffffffffc0205cda:	12040813          	addi	a6,s0,288
ffffffffc0205cde:	6008                	ld	a0,0(s0)
ffffffffc0205ce0:	640c                	ld	a1,8(s0)
ffffffffc0205ce2:	6810                	ld	a2,16(s0)
ffffffffc0205ce4:	6c18                	ld	a4,24(s0)
ffffffffc0205ce6:	e388                	sd	a0,0(a5)
ffffffffc0205ce8:	e78c                	sd	a1,8(a5)
ffffffffc0205cea:	eb90                	sd	a2,16(a5)
ffffffffc0205cec:	ef98                	sd	a4,24(a5)
ffffffffc0205cee:	02040413          	addi	s0,s0,32
ffffffffc0205cf2:	02078793          	addi	a5,a5,32
ffffffffc0205cf6:	ff0414e3          	bne	s0,a6,ffffffffc0205cde <do_fork+0xf2>
ffffffffc0205cfa:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205cfe:	00091363          	bnez	s2,ffffffffc0205d04 <do_fork+0x118>
ffffffffc0205d02:	8936                	mv	s2,a3
ffffffffc0205d04:	0126b823          	sd	s2,16(a3)
ffffffffc0205d08:	00000797          	auipc	a5,0x0
ffffffffc0205d0c:	d6678793          	addi	a5,a5,-666 # ffffffffc0205a6e <forkret>
ffffffffc0205d10:	02fab823          	sd	a5,48(s5)
ffffffffc0205d14:	02dabc23          	sd	a3,56(s5)
ffffffffc0205d18:	100027f3          	csrr	a5,sstatus
ffffffffc0205d1c:	8b89                	andi	a5,a5,2
ffffffffc0205d1e:	4901                	li	s2,0
ffffffffc0205d20:	20079263          	bnez	a5,ffffffffc0205f24 <do_fork+0x338>
ffffffffc0205d24:	0008b817          	auipc	a6,0x8b
ffffffffc0205d28:	33480813          	addi	a6,a6,820 # ffffffffc0291058 <last_pid.1>
ffffffffc0205d2c:	00082783          	lw	a5,0(a6)
ffffffffc0205d30:	6709                	lui	a4,0x2
ffffffffc0205d32:	0017851b          	addiw	a0,a5,1
ffffffffc0205d36:	00a82023          	sw	a0,0(a6)
ffffffffc0205d3a:	18e55563          	bge	a0,a4,ffffffffc0205ec4 <do_fork+0x2d8>
ffffffffc0205d3e:	0008b317          	auipc	t1,0x8b
ffffffffc0205d42:	31e30313          	addi	t1,t1,798 # ffffffffc029105c <next_safe.0>
ffffffffc0205d46:	00032783          	lw	a5,0(t1)
ffffffffc0205d4a:	00090417          	auipc	s0,0x90
ffffffffc0205d4e:	a7640413          	addi	s0,s0,-1418 # ffffffffc02957c0 <proc_list>
ffffffffc0205d52:	06f54063          	blt	a0,a5,ffffffffc0205db2 <do_fork+0x1c6>
ffffffffc0205d56:	00090417          	auipc	s0,0x90
ffffffffc0205d5a:	a6a40413          	addi	s0,s0,-1430 # ffffffffc02957c0 <proc_list>
ffffffffc0205d5e:	00843e03          	ld	t3,8(s0)
ffffffffc0205d62:	6789                	lui	a5,0x2
ffffffffc0205d64:	00f32023          	sw	a5,0(t1)
ffffffffc0205d68:	86aa                	mv	a3,a0
ffffffffc0205d6a:	4581                	li	a1,0
ffffffffc0205d6c:	6e89                	lui	t4,0x2
ffffffffc0205d6e:	1e8e0363          	beq	t3,s0,ffffffffc0205f54 <do_fork+0x368>
ffffffffc0205d72:	88ae                	mv	a7,a1
ffffffffc0205d74:	87f2                	mv	a5,t3
ffffffffc0205d76:	6609                	lui	a2,0x2
ffffffffc0205d78:	a811                	j	ffffffffc0205d8c <do_fork+0x1a0>
ffffffffc0205d7a:	00e6d663          	bge	a3,a4,ffffffffc0205d86 <do_fork+0x19a>
ffffffffc0205d7e:	00c75463          	bge	a4,a2,ffffffffc0205d86 <do_fork+0x19a>
ffffffffc0205d82:	863a                	mv	a2,a4
ffffffffc0205d84:	4885                	li	a7,1
ffffffffc0205d86:	679c                	ld	a5,8(a5)
ffffffffc0205d88:	00878d63          	beq	a5,s0,ffffffffc0205da2 <do_fork+0x1b6>
ffffffffc0205d8c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205d90:	fed715e3          	bne	a4,a3,ffffffffc0205d7a <do_fork+0x18e>
ffffffffc0205d94:	2685                	addiw	a3,a3,1
ffffffffc0205d96:	18c6d263          	bge	a3,a2,ffffffffc0205f1a <do_fork+0x32e>
ffffffffc0205d9a:	679c                	ld	a5,8(a5)
ffffffffc0205d9c:	4585                	li	a1,1
ffffffffc0205d9e:	fe8797e3          	bne	a5,s0,ffffffffc0205d8c <do_fork+0x1a0>
ffffffffc0205da2:	c581                	beqz	a1,ffffffffc0205daa <do_fork+0x1be>
ffffffffc0205da4:	00d82023          	sw	a3,0(a6)
ffffffffc0205da8:	8536                	mv	a0,a3
ffffffffc0205daa:	00088463          	beqz	a7,ffffffffc0205db2 <do_fork+0x1c6>
ffffffffc0205dae:	00c32023          	sw	a2,0(t1)
ffffffffc0205db2:	00aaa223          	sw	a0,4(s5)
ffffffffc0205db6:	45a9                	li	a1,10
ffffffffc0205db8:	2501                	sext.w	a0,a0
ffffffffc0205dba:	136050ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc0205dbe:	02051793          	slli	a5,a0,0x20
ffffffffc0205dc2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205dc6:	0008c797          	auipc	a5,0x8c
ffffffffc0205dca:	9fa78793          	addi	a5,a5,-1542 # ffffffffc02917c0 <hash_list>
ffffffffc0205dce:	953e                	add	a0,a0,a5
ffffffffc0205dd0:	650c                	ld	a1,8(a0)
ffffffffc0205dd2:	020ab683          	ld	a3,32(s5)
ffffffffc0205dd6:	0d8a8793          	addi	a5,s5,216
ffffffffc0205dda:	e19c                	sd	a5,0(a1)
ffffffffc0205ddc:	6410                	ld	a2,8(s0)
ffffffffc0205dde:	e51c                	sd	a5,8(a0)
ffffffffc0205de0:	7af8                	ld	a4,240(a3)
ffffffffc0205de2:	0c8a8793          	addi	a5,s5,200
ffffffffc0205de6:	0ebab023          	sd	a1,224(s5)
ffffffffc0205dea:	0caabc23          	sd	a0,216(s5)
ffffffffc0205dee:	e21c                	sd	a5,0(a2)
ffffffffc0205df0:	e41c                	sd	a5,8(s0)
ffffffffc0205df2:	0ccab823          	sd	a2,208(s5)
ffffffffc0205df6:	0c8ab423          	sd	s0,200(s5)
ffffffffc0205dfa:	0e0abc23          	sd	zero,248(s5)
ffffffffc0205dfe:	10eab023          	sd	a4,256(s5)
ffffffffc0205e02:	c319                	beqz	a4,ffffffffc0205e08 <do_fork+0x21c>
ffffffffc0205e04:	0f573c23          	sd	s5,248(a4) # 20f8 <_binary_bin_swap_img_size-0x5c08>
ffffffffc0205e08:	0009a783          	lw	a5,0(s3)
ffffffffc0205e0c:	0f56b823          	sd	s5,240(a3)
ffffffffc0205e10:	2785                	addiw	a5,a5,1
ffffffffc0205e12:	00f9a023          	sw	a5,0(s3)
ffffffffc0205e16:	0e091f63          	bnez	s2,ffffffffc0205f14 <do_fork+0x328>
ffffffffc0205e1a:	8556                	mv	a0,s5
ffffffffc0205e1c:	3ea010ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc0205e20:	000bb783          	ld	a5,0(s7)
ffffffffc0205e24:	004aa403          	lw	s0,4(s5)
ffffffffc0205e28:	1487b903          	ld	s2,328(a5)
ffffffffc0205e2c:	1a090463          	beqz	s2,ffffffffc0205fd4 <do_fork+0x3e8>
ffffffffc0205e30:	80ad                	srli	s1,s1,0xb
ffffffffc0205e32:	8885                	andi	s1,s1,1
ffffffffc0205e34:	e899                	bnez	s1,ffffffffc0205e4a <do_fork+0x25e>
ffffffffc0205e36:	b98ff0ef          	jal	ra,ffffffffc02051ce <files_create>
ffffffffc0205e3a:	84aa                	mv	s1,a0
ffffffffc0205e3c:	c14d                	beqz	a0,ffffffffc0205ede <do_fork+0x2f2>
ffffffffc0205e3e:	85ca                	mv	a1,s2
ffffffffc0205e40:	cc6ff0ef          	jal	ra,ffffffffc0205306 <dup_files>
ffffffffc0205e44:	8926                	mv	s2,s1
ffffffffc0205e46:	0e051563          	bnez	a0,ffffffffc0205f30 <do_fork+0x344>
ffffffffc0205e4a:	01092783          	lw	a5,16(s2)
ffffffffc0205e4e:	2785                	addiw	a5,a5,1
ffffffffc0205e50:	00f92823          	sw	a5,16(s2)
ffffffffc0205e54:	152ab423          	sd	s2,328(s5)
ffffffffc0205e58:	70e6                	ld	ra,120(sp)
ffffffffc0205e5a:	8522                	mv	a0,s0
ffffffffc0205e5c:	7446                	ld	s0,112(sp)
ffffffffc0205e5e:	74a6                	ld	s1,104(sp)
ffffffffc0205e60:	7906                	ld	s2,96(sp)
ffffffffc0205e62:	69e6                	ld	s3,88(sp)
ffffffffc0205e64:	6a46                	ld	s4,80(sp)
ffffffffc0205e66:	6aa6                	ld	s5,72(sp)
ffffffffc0205e68:	6b06                	ld	s6,64(sp)
ffffffffc0205e6a:	7be2                	ld	s7,56(sp)
ffffffffc0205e6c:	7c42                	ld	s8,48(sp)
ffffffffc0205e6e:	7ca2                	ld	s9,40(sp)
ffffffffc0205e70:	7d02                	ld	s10,32(sp)
ffffffffc0205e72:	6de2                	ld	s11,24(sp)
ffffffffc0205e74:	6109                	addi	sp,sp,128
ffffffffc0205e76:	8082                	ret
ffffffffc0205e78:	d91fd0ef          	jal	ra,ffffffffc0203c08 <mm_create>
ffffffffc0205e7c:	8daa                	mv	s11,a0
ffffffffc0205e7e:	0e050563          	beqz	a0,ffffffffc0205f68 <do_fork+0x37c>
ffffffffc0205e82:	c71ff0ef          	jal	ra,ffffffffc0205af2 <setup_pgdir>
ffffffffc0205e86:	e921                	bnez	a0,ffffffffc0205ed6 <do_fork+0x2ea>
ffffffffc0205e88:	038c8713          	addi	a4,s9,56
ffffffffc0205e8c:	853a                	mv	a0,a4
ffffffffc0205e8e:	e43a                	sd	a4,8(sp)
ffffffffc0205e90:	ed4fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205e94:	000bb783          	ld	a5,0(s7)
ffffffffc0205e98:	6722                	ld	a4,8(sp)
ffffffffc0205e9a:	c781                	beqz	a5,ffffffffc0205ea2 <do_fork+0x2b6>
ffffffffc0205e9c:	43dc                	lw	a5,4(a5)
ffffffffc0205e9e:	04fca823          	sw	a5,80(s9)
ffffffffc0205ea2:	85e6                	mv	a1,s9
ffffffffc0205ea4:	856e                	mv	a0,s11
ffffffffc0205ea6:	e43a                	sd	a4,8(sp)
ffffffffc0205ea8:	fb1fd0ef          	jal	ra,ffffffffc0203e58 <dup_mmap>
ffffffffc0205eac:	6722                	ld	a4,8(sp)
ffffffffc0205eae:	87aa                	mv	a5,a0
ffffffffc0205eb0:	e43e                	sd	a5,8(sp)
ffffffffc0205eb2:	853a                	mv	a0,a4
ffffffffc0205eb4:	eacfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205eb8:	67a2                	ld	a5,8(sp)
ffffffffc0205eba:	040ca823          	sw	zero,80(s9)
ffffffffc0205ebe:	efbd                	bnez	a5,ffffffffc0205f3c <do_fork+0x350>
ffffffffc0205ec0:	8cee                	mv	s9,s11
ffffffffc0205ec2:	b3cd                	j	ffffffffc0205ca4 <do_fork+0xb8>
ffffffffc0205ec4:	4785                	li	a5,1
ffffffffc0205ec6:	00f82023          	sw	a5,0(a6)
ffffffffc0205eca:	4505                	li	a0,1
ffffffffc0205ecc:	0008b317          	auipc	t1,0x8b
ffffffffc0205ed0:	19030313          	addi	t1,t1,400 # ffffffffc029105c <next_safe.0>
ffffffffc0205ed4:	b549                	j	ffffffffc0205d56 <do_fork+0x16a>
ffffffffc0205ed6:	856e                	mv	a0,s11
ffffffffc0205ed8:	e7ffd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0205edc:	5471                	li	s0,-4
ffffffffc0205ede:	010ab683          	ld	a3,16(s5)
ffffffffc0205ee2:	c02007b7          	lui	a5,0xc0200
ffffffffc0205ee6:	0cf6eb63          	bltu	a3,a5,ffffffffc0205fbc <do_fork+0x3d0>
ffffffffc0205eea:	000d3703          	ld	a4,0(s10)
ffffffffc0205eee:	000c3783          	ld	a5,0(s8)
ffffffffc0205ef2:	8e99                	sub	a3,a3,a4
ffffffffc0205ef4:	82b1                	srli	a3,a3,0xc
ffffffffc0205ef6:	0af6f763          	bgeu	a3,a5,ffffffffc0205fa4 <do_fork+0x3b8>
ffffffffc0205efa:	000b3503          	ld	a0,0(s6)
ffffffffc0205efe:	414686b3          	sub	a3,a3,s4
ffffffffc0205f02:	069a                	slli	a3,a3,0x6
ffffffffc0205f04:	4589                	li	a1,2
ffffffffc0205f06:	9536                	add	a0,a0,a3
ffffffffc0205f08:	aa2fc0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0205f0c:	8556                	mv	a0,s5
ffffffffc0205f0e:	930fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205f12:	b799                	j	ffffffffc0205e58 <do_fork+0x26c>
ffffffffc0205f14:	d59fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0205f18:	b709                	j	ffffffffc0205e1a <do_fork+0x22e>
ffffffffc0205f1a:	01d6c363          	blt	a3,t4,ffffffffc0205f20 <do_fork+0x334>
ffffffffc0205f1e:	4685                	li	a3,1
ffffffffc0205f20:	4585                	li	a1,1
ffffffffc0205f22:	b5b1                	j	ffffffffc0205d6e <do_fork+0x182>
ffffffffc0205f24:	d4ffa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205f28:	4905                	li	s2,1
ffffffffc0205f2a:	bbed                	j	ffffffffc0205d24 <do_fork+0x138>
ffffffffc0205f2c:	5471                	li	s0,-4
ffffffffc0205f2e:	bff9                	j	ffffffffc0205f0c <do_fork+0x320>
ffffffffc0205f30:	8526                	mv	a0,s1
ffffffffc0205f32:	ad2ff0ef          	jal	ra,ffffffffc0205204 <files_destroy>
ffffffffc0205f36:	b765                	j	ffffffffc0205ede <do_fork+0x2f2>
ffffffffc0205f38:	546d                	li	s0,-5
ffffffffc0205f3a:	bf39                	j	ffffffffc0205e58 <do_fork+0x26c>
ffffffffc0205f3c:	856e                	mv	a0,s11
ffffffffc0205f3e:	fb5fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc0205f42:	018db503          	ld	a0,24(s11)
ffffffffc0205f46:	5471                	li	s0,-4
ffffffffc0205f48:	b35ff0ef          	jal	ra,ffffffffc0205a7c <put_pgdir.isra.0>
ffffffffc0205f4c:	856e                	mv	a0,s11
ffffffffc0205f4e:	e09fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0205f52:	b771                	j	ffffffffc0205ede <do_fork+0x2f2>
ffffffffc0205f54:	c599                	beqz	a1,ffffffffc0205f62 <do_fork+0x376>
ffffffffc0205f56:	00d82023          	sw	a3,0(a6)
ffffffffc0205f5a:	8536                	mv	a0,a3
ffffffffc0205f5c:	bd99                	j	ffffffffc0205db2 <do_fork+0x1c6>
ffffffffc0205f5e:	5471                	li	s0,-4
ffffffffc0205f60:	bde5                	j	ffffffffc0205e58 <do_fork+0x26c>
ffffffffc0205f62:	00082503          	lw	a0,0(a6)
ffffffffc0205f66:	b5b1                	j	ffffffffc0205db2 <do_fork+0x1c6>
ffffffffc0205f68:	5471                	li	s0,-4
ffffffffc0205f6a:	bf95                	j	ffffffffc0205ede <do_fork+0x2f2>
ffffffffc0205f6c:	00006617          	auipc	a2,0x6
ffffffffc0205f70:	4bc60613          	addi	a2,a2,1212 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0205f74:	07100593          	li	a1,113
ffffffffc0205f78:	00006517          	auipc	a0,0x6
ffffffffc0205f7c:	4d850513          	addi	a0,a0,1240 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205f80:	d1efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f84:	00007697          	auipc	a3,0x7
ffffffffc0205f88:	48468693          	addi	a3,a3,1156 # ffffffffc020d408 <CSWTCH.79+0xf0>
ffffffffc0205f8c:	00006617          	auipc	a2,0x6
ffffffffc0205f90:	97c60613          	addi	a2,a2,-1668 # ffffffffc020b908 <commands+0x210>
ffffffffc0205f94:	21700593          	li	a1,535
ffffffffc0205f98:	00007517          	auipc	a0,0x7
ffffffffc0205f9c:	48850513          	addi	a0,a0,1160 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0205fa0:	cfefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fa4:	00006617          	auipc	a2,0x6
ffffffffc0205fa8:	55460613          	addi	a2,a2,1364 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc0205fac:	06900593          	li	a1,105
ffffffffc0205fb0:	00006517          	auipc	a0,0x6
ffffffffc0205fb4:	4a050513          	addi	a0,a0,1184 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205fb8:	ce6fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fbc:	00006617          	auipc	a2,0x6
ffffffffc0205fc0:	51460613          	addi	a2,a2,1300 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0205fc4:	07700593          	li	a1,119
ffffffffc0205fc8:	00006517          	auipc	a0,0x6
ffffffffc0205fcc:	48850513          	addi	a0,a0,1160 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0205fd0:	ccefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fd4:	00007697          	auipc	a3,0x7
ffffffffc0205fd8:	46468693          	addi	a3,a3,1124 # ffffffffc020d438 <CSWTCH.79+0x120>
ffffffffc0205fdc:	00006617          	auipc	a2,0x6
ffffffffc0205fe0:	92c60613          	addi	a2,a2,-1748 # ffffffffc020b908 <commands+0x210>
ffffffffc0205fe4:	1d600593          	li	a1,470
ffffffffc0205fe8:	00007517          	auipc	a0,0x7
ffffffffc0205fec:	43850513          	addi	a0,a0,1080 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0205ff0:	caefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205ff4:	86be                	mv	a3,a5
ffffffffc0205ff6:	00006617          	auipc	a2,0x6
ffffffffc0205ffa:	4da60613          	addi	a2,a2,1242 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0205ffe:	1b600593          	li	a1,438
ffffffffc0206002:	00007517          	auipc	a0,0x7
ffffffffc0206006:	41e50513          	addi	a0,a0,1054 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc020600a:	c94fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020600e <kernel_thread>:
ffffffffc020600e:	7129                	addi	sp,sp,-320
ffffffffc0206010:	fa22                	sd	s0,304(sp)
ffffffffc0206012:	f626                	sd	s1,296(sp)
ffffffffc0206014:	f24a                	sd	s2,288(sp)
ffffffffc0206016:	84ae                	mv	s1,a1
ffffffffc0206018:	892a                	mv	s2,a0
ffffffffc020601a:	8432                	mv	s0,a2
ffffffffc020601c:	4581                	li	a1,0
ffffffffc020601e:	12000613          	li	a2,288
ffffffffc0206022:	850a                	mv	a0,sp
ffffffffc0206024:	fe06                	sd	ra,312(sp)
ffffffffc0206026:	3fe050ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc020602a:	e0ca                	sd	s2,64(sp)
ffffffffc020602c:	e4a6                	sd	s1,72(sp)
ffffffffc020602e:	100027f3          	csrr	a5,sstatus
ffffffffc0206032:	edd7f793          	andi	a5,a5,-291
ffffffffc0206036:	1207e793          	ori	a5,a5,288
ffffffffc020603a:	e23e                	sd	a5,256(sp)
ffffffffc020603c:	860a                	mv	a2,sp
ffffffffc020603e:	10046513          	ori	a0,s0,256
ffffffffc0206042:	00000797          	auipc	a5,0x0
ffffffffc0206046:	98a78793          	addi	a5,a5,-1654 # ffffffffc02059cc <kernel_thread_entry>
ffffffffc020604a:	4581                	li	a1,0
ffffffffc020604c:	e63e                	sd	a5,264(sp)
ffffffffc020604e:	b9fff0ef          	jal	ra,ffffffffc0205bec <do_fork>
ffffffffc0206052:	70f2                	ld	ra,312(sp)
ffffffffc0206054:	7452                	ld	s0,304(sp)
ffffffffc0206056:	74b2                	ld	s1,296(sp)
ffffffffc0206058:	7912                	ld	s2,288(sp)
ffffffffc020605a:	6131                	addi	sp,sp,320
ffffffffc020605c:	8082                	ret

ffffffffc020605e <do_exit>:
ffffffffc020605e:	7179                	addi	sp,sp,-48
ffffffffc0206060:	f022                	sd	s0,32(sp)
ffffffffc0206062:	00091417          	auipc	s0,0x91
ffffffffc0206066:	85e40413          	addi	s0,s0,-1954 # ffffffffc02968c0 <current>
ffffffffc020606a:	601c                	ld	a5,0(s0)
ffffffffc020606c:	f406                	sd	ra,40(sp)
ffffffffc020606e:	ec26                	sd	s1,24(sp)
ffffffffc0206070:	e84a                	sd	s2,16(sp)
ffffffffc0206072:	e44e                	sd	s3,8(sp)
ffffffffc0206074:	e052                	sd	s4,0(sp)
ffffffffc0206076:	00091717          	auipc	a4,0x91
ffffffffc020607a:	85273703          	ld	a4,-1966(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020607e:	0ee78763          	beq	a5,a4,ffffffffc020616c <do_exit+0x10e>
ffffffffc0206082:	00091497          	auipc	s1,0x91
ffffffffc0206086:	84e48493          	addi	s1,s1,-1970 # ffffffffc02968d0 <initproc>
ffffffffc020608a:	6098                	ld	a4,0(s1)
ffffffffc020608c:	10e78763          	beq	a5,a4,ffffffffc020619a <do_exit+0x13c>
ffffffffc0206090:	0287b983          	ld	s3,40(a5)
ffffffffc0206094:	892a                	mv	s2,a0
ffffffffc0206096:	02098e63          	beqz	s3,ffffffffc02060d2 <do_exit+0x74>
ffffffffc020609a:	00090797          	auipc	a5,0x90
ffffffffc020609e:	7f67b783          	ld	a5,2038(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc02060a2:	577d                	li	a4,-1
ffffffffc02060a4:	177e                	slli	a4,a4,0x3f
ffffffffc02060a6:	83b1                	srli	a5,a5,0xc
ffffffffc02060a8:	8fd9                	or	a5,a5,a4
ffffffffc02060aa:	18079073          	csrw	satp,a5
ffffffffc02060ae:	0309a783          	lw	a5,48(s3)
ffffffffc02060b2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060b6:	02e9a823          	sw	a4,48(s3)
ffffffffc02060ba:	c769                	beqz	a4,ffffffffc0206184 <do_exit+0x126>
ffffffffc02060bc:	601c                	ld	a5,0(s0)
ffffffffc02060be:	1487b503          	ld	a0,328(a5)
ffffffffc02060c2:	0207b423          	sd	zero,40(a5)
ffffffffc02060c6:	c511                	beqz	a0,ffffffffc02060d2 <do_exit+0x74>
ffffffffc02060c8:	491c                	lw	a5,16(a0)
ffffffffc02060ca:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060ce:	c918                	sw	a4,16(a0)
ffffffffc02060d0:	cb59                	beqz	a4,ffffffffc0206166 <do_exit+0x108>
ffffffffc02060d2:	601c                	ld	a5,0(s0)
ffffffffc02060d4:	470d                	li	a4,3
ffffffffc02060d6:	c398                	sw	a4,0(a5)
ffffffffc02060d8:	0f27a423          	sw	s2,232(a5)
ffffffffc02060dc:	100027f3          	csrr	a5,sstatus
ffffffffc02060e0:	8b89                	andi	a5,a5,2
ffffffffc02060e2:	4a01                	li	s4,0
ffffffffc02060e4:	e7f9                	bnez	a5,ffffffffc02061b2 <do_exit+0x154>
ffffffffc02060e6:	6018                	ld	a4,0(s0)
ffffffffc02060e8:	800007b7          	lui	a5,0x80000
ffffffffc02060ec:	0785                	addi	a5,a5,1
ffffffffc02060ee:	7308                	ld	a0,32(a4)
ffffffffc02060f0:	0ec52703          	lw	a4,236(a0)
ffffffffc02060f4:	0cf70363          	beq	a4,a5,ffffffffc02061ba <do_exit+0x15c>
ffffffffc02060f8:	6018                	ld	a4,0(s0)
ffffffffc02060fa:	7b7c                	ld	a5,240(a4)
ffffffffc02060fc:	c3a1                	beqz	a5,ffffffffc020613c <do_exit+0xde>
ffffffffc02060fe:	800009b7          	lui	s3,0x80000
ffffffffc0206102:	490d                	li	s2,3
ffffffffc0206104:	0985                	addi	s3,s3,1
ffffffffc0206106:	a021                	j	ffffffffc020610e <do_exit+0xb0>
ffffffffc0206108:	6018                	ld	a4,0(s0)
ffffffffc020610a:	7b7c                	ld	a5,240(a4)
ffffffffc020610c:	cb85                	beqz	a5,ffffffffc020613c <do_exit+0xde>
ffffffffc020610e:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc0206112:	6088                	ld	a0,0(s1)
ffffffffc0206114:	fb74                	sd	a3,240(a4)
ffffffffc0206116:	7978                	ld	a4,240(a0)
ffffffffc0206118:	0e07bc23          	sd	zero,248(a5)
ffffffffc020611c:	10e7b023          	sd	a4,256(a5)
ffffffffc0206120:	c311                	beqz	a4,ffffffffc0206124 <do_exit+0xc6>
ffffffffc0206122:	ff7c                	sd	a5,248(a4)
ffffffffc0206124:	4398                	lw	a4,0(a5)
ffffffffc0206126:	f388                	sd	a0,32(a5)
ffffffffc0206128:	f97c                	sd	a5,240(a0)
ffffffffc020612a:	fd271fe3          	bne	a4,s2,ffffffffc0206108 <do_exit+0xaa>
ffffffffc020612e:	0ec52783          	lw	a5,236(a0)
ffffffffc0206132:	fd379be3          	bne	a5,s3,ffffffffc0206108 <do_exit+0xaa>
ffffffffc0206136:	0d0010ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc020613a:	b7f9                	j	ffffffffc0206108 <do_exit+0xaa>
ffffffffc020613c:	020a1263          	bnez	s4,ffffffffc0206160 <do_exit+0x102>
ffffffffc0206140:	178010ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc0206144:	601c                	ld	a5,0(s0)
ffffffffc0206146:	00007617          	auipc	a2,0x7
ffffffffc020614a:	32a60613          	addi	a2,a2,810 # ffffffffc020d470 <CSWTCH.79+0x158>
ffffffffc020614e:	28300593          	li	a1,643
ffffffffc0206152:	43d4                	lw	a3,4(a5)
ffffffffc0206154:	00007517          	auipc	a0,0x7
ffffffffc0206158:	2cc50513          	addi	a0,a0,716 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc020615c:	b42fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206160:	b0dfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206164:	bff1                	j	ffffffffc0206140 <do_exit+0xe2>
ffffffffc0206166:	89eff0ef          	jal	ra,ffffffffc0205204 <files_destroy>
ffffffffc020616a:	b7a5                	j	ffffffffc02060d2 <do_exit+0x74>
ffffffffc020616c:	00007617          	auipc	a2,0x7
ffffffffc0206170:	2e460613          	addi	a2,a2,740 # ffffffffc020d450 <CSWTCH.79+0x138>
ffffffffc0206174:	24e00593          	li	a1,590
ffffffffc0206178:	00007517          	auipc	a0,0x7
ffffffffc020617c:	2a850513          	addi	a0,a0,680 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206180:	b1efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206184:	854e                	mv	a0,s3
ffffffffc0206186:	d6dfd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc020618a:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc020618e:	8efff0ef          	jal	ra,ffffffffc0205a7c <put_pgdir.isra.0>
ffffffffc0206192:	854e                	mv	a0,s3
ffffffffc0206194:	bc3fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206198:	b715                	j	ffffffffc02060bc <do_exit+0x5e>
ffffffffc020619a:	00007617          	auipc	a2,0x7
ffffffffc020619e:	2c660613          	addi	a2,a2,710 # ffffffffc020d460 <CSWTCH.79+0x148>
ffffffffc02061a2:	25200593          	li	a1,594
ffffffffc02061a6:	00007517          	auipc	a0,0x7
ffffffffc02061aa:	27a50513          	addi	a0,a0,634 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc02061ae:	af0fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061b2:	ac1fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02061b6:	4a05                	li	s4,1
ffffffffc02061b8:	b73d                	j	ffffffffc02060e6 <do_exit+0x88>
ffffffffc02061ba:	04c010ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc02061be:	bf2d                	j	ffffffffc02060f8 <do_exit+0x9a>

ffffffffc02061c0 <do_wait.part.0>:
ffffffffc02061c0:	715d                	addi	sp,sp,-80
ffffffffc02061c2:	f84a                	sd	s2,48(sp)
ffffffffc02061c4:	f44e                	sd	s3,40(sp)
ffffffffc02061c6:	80000937          	lui	s2,0x80000
ffffffffc02061ca:	6989                	lui	s3,0x2
ffffffffc02061cc:	fc26                	sd	s1,56(sp)
ffffffffc02061ce:	f052                	sd	s4,32(sp)
ffffffffc02061d0:	ec56                	sd	s5,24(sp)
ffffffffc02061d2:	e85a                	sd	s6,16(sp)
ffffffffc02061d4:	e45e                	sd	s7,8(sp)
ffffffffc02061d6:	e486                	sd	ra,72(sp)
ffffffffc02061d8:	e0a2                	sd	s0,64(sp)
ffffffffc02061da:	84aa                	mv	s1,a0
ffffffffc02061dc:	8a2e                	mv	s4,a1
ffffffffc02061de:	00090b97          	auipc	s7,0x90
ffffffffc02061e2:	6e2b8b93          	addi	s7,s7,1762 # ffffffffc02968c0 <current>
ffffffffc02061e6:	00050b1b          	sext.w	s6,a0
ffffffffc02061ea:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02061ee:	19f9                	addi	s3,s3,-2
ffffffffc02061f0:	0905                	addi	s2,s2,1
ffffffffc02061f2:	ccbd                	beqz	s1,ffffffffc0206270 <do_wait.part.0+0xb0>
ffffffffc02061f4:	0359e863          	bltu	s3,s5,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc02061f8:	45a9                	li	a1,10
ffffffffc02061fa:	855a                	mv	a0,s6
ffffffffc02061fc:	4f5040ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc0206200:	02051793          	slli	a5,a0,0x20
ffffffffc0206204:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206208:	0008b797          	auipc	a5,0x8b
ffffffffc020620c:	5b878793          	addi	a5,a5,1464 # ffffffffc02917c0 <hash_list>
ffffffffc0206210:	953e                	add	a0,a0,a5
ffffffffc0206212:	842a                	mv	s0,a0
ffffffffc0206214:	a029                	j	ffffffffc020621e <do_wait.part.0+0x5e>
ffffffffc0206216:	f2c42783          	lw	a5,-212(s0)
ffffffffc020621a:	02978163          	beq	a5,s1,ffffffffc020623c <do_wait.part.0+0x7c>
ffffffffc020621e:	6400                	ld	s0,8(s0)
ffffffffc0206220:	fe851be3          	bne	a0,s0,ffffffffc0206216 <do_wait.part.0+0x56>
ffffffffc0206224:	5579                	li	a0,-2
ffffffffc0206226:	60a6                	ld	ra,72(sp)
ffffffffc0206228:	6406                	ld	s0,64(sp)
ffffffffc020622a:	74e2                	ld	s1,56(sp)
ffffffffc020622c:	7942                	ld	s2,48(sp)
ffffffffc020622e:	79a2                	ld	s3,40(sp)
ffffffffc0206230:	7a02                	ld	s4,32(sp)
ffffffffc0206232:	6ae2                	ld	s5,24(sp)
ffffffffc0206234:	6b42                	ld	s6,16(sp)
ffffffffc0206236:	6ba2                	ld	s7,8(sp)
ffffffffc0206238:	6161                	addi	sp,sp,80
ffffffffc020623a:	8082                	ret
ffffffffc020623c:	000bb683          	ld	a3,0(s7)
ffffffffc0206240:	f4843783          	ld	a5,-184(s0)
ffffffffc0206244:	fed790e3          	bne	a5,a3,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc0206248:	f2842703          	lw	a4,-216(s0)
ffffffffc020624c:	478d                	li	a5,3
ffffffffc020624e:	0ef70b63          	beq	a4,a5,ffffffffc0206344 <do_wait.part.0+0x184>
ffffffffc0206252:	4785                	li	a5,1
ffffffffc0206254:	c29c                	sw	a5,0(a3)
ffffffffc0206256:	0f26a623          	sw	s2,236(a3)
ffffffffc020625a:	05e010ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc020625e:	000bb783          	ld	a5,0(s7)
ffffffffc0206262:	0b07a783          	lw	a5,176(a5)
ffffffffc0206266:	8b85                	andi	a5,a5,1
ffffffffc0206268:	d7c9                	beqz	a5,ffffffffc02061f2 <do_wait.part.0+0x32>
ffffffffc020626a:	555d                	li	a0,-9
ffffffffc020626c:	df3ff0ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc0206270:	000bb683          	ld	a3,0(s7)
ffffffffc0206274:	7ae0                	ld	s0,240(a3)
ffffffffc0206276:	d45d                	beqz	s0,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc0206278:	470d                	li	a4,3
ffffffffc020627a:	a021                	j	ffffffffc0206282 <do_wait.part.0+0xc2>
ffffffffc020627c:	10043403          	ld	s0,256(s0)
ffffffffc0206280:	d869                	beqz	s0,ffffffffc0206252 <do_wait.part.0+0x92>
ffffffffc0206282:	401c                	lw	a5,0(s0)
ffffffffc0206284:	fee79ce3          	bne	a5,a4,ffffffffc020627c <do_wait.part.0+0xbc>
ffffffffc0206288:	00090797          	auipc	a5,0x90
ffffffffc020628c:	6407b783          	ld	a5,1600(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0206290:	0c878963          	beq	a5,s0,ffffffffc0206362 <do_wait.part.0+0x1a2>
ffffffffc0206294:	00090797          	auipc	a5,0x90
ffffffffc0206298:	63c7b783          	ld	a5,1596(a5) # ffffffffc02968d0 <initproc>
ffffffffc020629c:	0cf40363          	beq	s0,a5,ffffffffc0206362 <do_wait.part.0+0x1a2>
ffffffffc02062a0:	000a0663          	beqz	s4,ffffffffc02062ac <do_wait.part.0+0xec>
ffffffffc02062a4:	0e842783          	lw	a5,232(s0)
ffffffffc02062a8:	00fa2023          	sw	a5,0(s4)
ffffffffc02062ac:	100027f3          	csrr	a5,sstatus
ffffffffc02062b0:	8b89                	andi	a5,a5,2
ffffffffc02062b2:	4581                	li	a1,0
ffffffffc02062b4:	e7c1                	bnez	a5,ffffffffc020633c <do_wait.part.0+0x17c>
ffffffffc02062b6:	6c70                	ld	a2,216(s0)
ffffffffc02062b8:	7074                	ld	a3,224(s0)
ffffffffc02062ba:	10043703          	ld	a4,256(s0)
ffffffffc02062be:	7c7c                	ld	a5,248(s0)
ffffffffc02062c0:	e614                	sd	a3,8(a2)
ffffffffc02062c2:	e290                	sd	a2,0(a3)
ffffffffc02062c4:	6470                	ld	a2,200(s0)
ffffffffc02062c6:	6874                	ld	a3,208(s0)
ffffffffc02062c8:	e614                	sd	a3,8(a2)
ffffffffc02062ca:	e290                	sd	a2,0(a3)
ffffffffc02062cc:	c319                	beqz	a4,ffffffffc02062d2 <do_wait.part.0+0x112>
ffffffffc02062ce:	ff7c                	sd	a5,248(a4)
ffffffffc02062d0:	7c7c                	ld	a5,248(s0)
ffffffffc02062d2:	c3b5                	beqz	a5,ffffffffc0206336 <do_wait.part.0+0x176>
ffffffffc02062d4:	10e7b023          	sd	a4,256(a5)
ffffffffc02062d8:	00090717          	auipc	a4,0x90
ffffffffc02062dc:	60070713          	addi	a4,a4,1536 # ffffffffc02968d8 <nr_process>
ffffffffc02062e0:	431c                	lw	a5,0(a4)
ffffffffc02062e2:	37fd                	addiw	a5,a5,-1
ffffffffc02062e4:	c31c                	sw	a5,0(a4)
ffffffffc02062e6:	e5a9                	bnez	a1,ffffffffc0206330 <do_wait.part.0+0x170>
ffffffffc02062e8:	6814                	ld	a3,16(s0)
ffffffffc02062ea:	c02007b7          	lui	a5,0xc0200
ffffffffc02062ee:	04f6ee63          	bltu	a3,a5,ffffffffc020634a <do_wait.part.0+0x18a>
ffffffffc02062f2:	00090797          	auipc	a5,0x90
ffffffffc02062f6:	5c67b783          	ld	a5,1478(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02062fa:	8e9d                	sub	a3,a3,a5
ffffffffc02062fc:	82b1                	srli	a3,a3,0xc
ffffffffc02062fe:	00090797          	auipc	a5,0x90
ffffffffc0206302:	5a27b783          	ld	a5,1442(a5) # ffffffffc02968a0 <npage>
ffffffffc0206306:	06f6fa63          	bgeu	a3,a5,ffffffffc020637a <do_wait.part.0+0x1ba>
ffffffffc020630a:	00009517          	auipc	a0,0x9
ffffffffc020630e:	42653503          	ld	a0,1062(a0) # ffffffffc020f730 <nbase>
ffffffffc0206312:	8e89                	sub	a3,a3,a0
ffffffffc0206314:	069a                	slli	a3,a3,0x6
ffffffffc0206316:	00090517          	auipc	a0,0x90
ffffffffc020631a:	59253503          	ld	a0,1426(a0) # ffffffffc02968a8 <pages>
ffffffffc020631e:	9536                	add	a0,a0,a3
ffffffffc0206320:	4589                	li	a1,2
ffffffffc0206322:	e89fb0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0206326:	8522                	mv	a0,s0
ffffffffc0206328:	d17fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020632c:	4501                	li	a0,0
ffffffffc020632e:	bde5                	j	ffffffffc0206226 <do_wait.part.0+0x66>
ffffffffc0206330:	93dfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206334:	bf55                	j	ffffffffc02062e8 <do_wait.part.0+0x128>
ffffffffc0206336:	701c                	ld	a5,32(s0)
ffffffffc0206338:	fbf8                	sd	a4,240(a5)
ffffffffc020633a:	bf79                	j	ffffffffc02062d8 <do_wait.part.0+0x118>
ffffffffc020633c:	937fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206340:	4585                	li	a1,1
ffffffffc0206342:	bf95                	j	ffffffffc02062b6 <do_wait.part.0+0xf6>
ffffffffc0206344:	f2840413          	addi	s0,s0,-216
ffffffffc0206348:	b781                	j	ffffffffc0206288 <do_wait.part.0+0xc8>
ffffffffc020634a:	00006617          	auipc	a2,0x6
ffffffffc020634e:	18660613          	addi	a2,a2,390 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0206352:	07700593          	li	a1,119
ffffffffc0206356:	00006517          	auipc	a0,0x6
ffffffffc020635a:	0fa50513          	addi	a0,a0,250 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc020635e:	940fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206362:	00007617          	auipc	a2,0x7
ffffffffc0206366:	12e60613          	addi	a2,a2,302 # ffffffffc020d490 <CSWTCH.79+0x178>
ffffffffc020636a:	3f200593          	li	a1,1010
ffffffffc020636e:	00007517          	auipc	a0,0x7
ffffffffc0206372:	0b250513          	addi	a0,a0,178 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206376:	928fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020637a:	00006617          	auipc	a2,0x6
ffffffffc020637e:	17e60613          	addi	a2,a2,382 # ffffffffc020c4f8 <default_pmm_manager+0x108>
ffffffffc0206382:	06900593          	li	a1,105
ffffffffc0206386:	00006517          	auipc	a0,0x6
ffffffffc020638a:	0ca50513          	addi	a0,a0,202 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc020638e:	910fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206392 <init_main>:
ffffffffc0206392:	1141                	addi	sp,sp,-16
ffffffffc0206394:	00007517          	auipc	a0,0x7
ffffffffc0206398:	11c50513          	addi	a0,a0,284 # ffffffffc020d4b0 <CSWTCH.79+0x198>
ffffffffc020639c:	e406                	sd	ra,8(sp)
ffffffffc020639e:	68a010ef          	jal	ra,ffffffffc0207a28 <vfs_set_bootfs>
ffffffffc02063a2:	e179                	bnez	a0,ffffffffc0206468 <init_main+0xd6>
ffffffffc02063a4:	e47fb0ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc02063a8:	be3fb0ef          	jal	ra,ffffffffc0201f8a <kallocated>
ffffffffc02063ac:	4601                	li	a2,0
ffffffffc02063ae:	4581                	li	a1,0
ffffffffc02063b0:	00001517          	auipc	a0,0x1
ffffffffc02063b4:	8b050513          	addi	a0,a0,-1872 # ffffffffc0206c60 <user_main>
ffffffffc02063b8:	c57ff0ef          	jal	ra,ffffffffc020600e <kernel_thread>
ffffffffc02063bc:	00a04563          	bgtz	a0,ffffffffc02063c6 <init_main+0x34>
ffffffffc02063c0:	a841                	j	ffffffffc0206450 <init_main+0xbe>
ffffffffc02063c2:	6f7000ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc02063c6:	4581                	li	a1,0
ffffffffc02063c8:	4501                	li	a0,0
ffffffffc02063ca:	df7ff0ef          	jal	ra,ffffffffc02061c0 <do_wait.part.0>
ffffffffc02063ce:	d975                	beqz	a0,ffffffffc02063c2 <init_main+0x30>
ffffffffc02063d0:	deffe0ef          	jal	ra,ffffffffc02051be <fs_cleanup>
ffffffffc02063d4:	00007517          	auipc	a0,0x7
ffffffffc02063d8:	12450513          	addi	a0,a0,292 # ffffffffc020d4f8 <CSWTCH.79+0x1e0>
ffffffffc02063dc:	dcbf90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02063e0:	00090797          	auipc	a5,0x90
ffffffffc02063e4:	4f07b783          	ld	a5,1264(a5) # ffffffffc02968d0 <initproc>
ffffffffc02063e8:	7bf8                	ld	a4,240(a5)
ffffffffc02063ea:	e339                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063ec:	7ff8                	ld	a4,248(a5)
ffffffffc02063ee:	e329                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063f0:	1007b703          	ld	a4,256(a5)
ffffffffc02063f4:	ef15                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063f6:	00090697          	auipc	a3,0x90
ffffffffc02063fa:	4e26a683          	lw	a3,1250(a3) # ffffffffc02968d8 <nr_process>
ffffffffc02063fe:	4709                	li	a4,2
ffffffffc0206400:	0ce69163          	bne	a3,a4,ffffffffc02064c2 <init_main+0x130>
ffffffffc0206404:	0008f717          	auipc	a4,0x8f
ffffffffc0206408:	3bc70713          	addi	a4,a4,956 # ffffffffc02957c0 <proc_list>
ffffffffc020640c:	6714                	ld	a3,8(a4)
ffffffffc020640e:	0c878793          	addi	a5,a5,200
ffffffffc0206412:	08d79863          	bne	a5,a3,ffffffffc02064a2 <init_main+0x110>
ffffffffc0206416:	6318                	ld	a4,0(a4)
ffffffffc0206418:	06e79563          	bne	a5,a4,ffffffffc0206482 <init_main+0xf0>
ffffffffc020641c:	00007517          	auipc	a0,0x7
ffffffffc0206420:	1c450513          	addi	a0,a0,452 # ffffffffc020d5e0 <CSWTCH.79+0x2c8>
ffffffffc0206424:	d83f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206428:	60a2                	ld	ra,8(sp)
ffffffffc020642a:	4501                	li	a0,0
ffffffffc020642c:	0141                	addi	sp,sp,16
ffffffffc020642e:	8082                	ret
ffffffffc0206430:	00007697          	auipc	a3,0x7
ffffffffc0206434:	0f068693          	addi	a3,a3,240 # ffffffffc020d520 <CSWTCH.79+0x208>
ffffffffc0206438:	00005617          	auipc	a2,0x5
ffffffffc020643c:	4d060613          	addi	a2,a2,1232 # ffffffffc020b908 <commands+0x210>
ffffffffc0206440:	46800593          	li	a1,1128
ffffffffc0206444:	00007517          	auipc	a0,0x7
ffffffffc0206448:	fdc50513          	addi	a0,a0,-36 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc020644c:	852fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206450:	00007617          	auipc	a2,0x7
ffffffffc0206454:	08860613          	addi	a2,a2,136 # ffffffffc020d4d8 <CSWTCH.79+0x1c0>
ffffffffc0206458:	45b00593          	li	a1,1115
ffffffffc020645c:	00007517          	auipc	a0,0x7
ffffffffc0206460:	fc450513          	addi	a0,a0,-60 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206464:	83afa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206468:	86aa                	mv	a3,a0
ffffffffc020646a:	00007617          	auipc	a2,0x7
ffffffffc020646e:	04e60613          	addi	a2,a2,78 # ffffffffc020d4b8 <CSWTCH.79+0x1a0>
ffffffffc0206472:	45300593          	li	a1,1107
ffffffffc0206476:	00007517          	auipc	a0,0x7
ffffffffc020647a:	faa50513          	addi	a0,a0,-86 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc020647e:	820fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206482:	00007697          	auipc	a3,0x7
ffffffffc0206486:	12e68693          	addi	a3,a3,302 # ffffffffc020d5b0 <CSWTCH.79+0x298>
ffffffffc020648a:	00005617          	auipc	a2,0x5
ffffffffc020648e:	47e60613          	addi	a2,a2,1150 # ffffffffc020b908 <commands+0x210>
ffffffffc0206492:	46b00593          	li	a1,1131
ffffffffc0206496:	00007517          	auipc	a0,0x7
ffffffffc020649a:	f8a50513          	addi	a0,a0,-118 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc020649e:	800fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064a2:	00007697          	auipc	a3,0x7
ffffffffc02064a6:	0de68693          	addi	a3,a3,222 # ffffffffc020d580 <CSWTCH.79+0x268>
ffffffffc02064aa:	00005617          	auipc	a2,0x5
ffffffffc02064ae:	45e60613          	addi	a2,a2,1118 # ffffffffc020b908 <commands+0x210>
ffffffffc02064b2:	46a00593          	li	a1,1130
ffffffffc02064b6:	00007517          	auipc	a0,0x7
ffffffffc02064ba:	f6a50513          	addi	a0,a0,-150 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc02064be:	fe1f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064c2:	00007697          	auipc	a3,0x7
ffffffffc02064c6:	0ae68693          	addi	a3,a3,174 # ffffffffc020d570 <CSWTCH.79+0x258>
ffffffffc02064ca:	00005617          	auipc	a2,0x5
ffffffffc02064ce:	43e60613          	addi	a2,a2,1086 # ffffffffc020b908 <commands+0x210>
ffffffffc02064d2:	46900593          	li	a1,1129
ffffffffc02064d6:	00007517          	auipc	a0,0x7
ffffffffc02064da:	f4a50513          	addi	a0,a0,-182 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc02064de:	fc1f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02064e2 <do_execve>:
ffffffffc02064e2:	c9010113          	addi	sp,sp,-880
ffffffffc02064e6:	35313423          	sd	s3,840(sp)
ffffffffc02064ea:	00090997          	auipc	s3,0x90
ffffffffc02064ee:	3d698993          	addi	s3,s3,982 # ffffffffc02968c0 <current>
ffffffffc02064f2:	0009b683          	ld	a3,0(s3)
ffffffffc02064f6:	fff5871b          	addiw	a4,a1,-1
ffffffffc02064fa:	33613823          	sd	s6,816(sp)
ffffffffc02064fe:	36113423          	sd	ra,872(sp)
ffffffffc0206502:	36813023          	sd	s0,864(sp)
ffffffffc0206506:	34913c23          	sd	s1,856(sp)
ffffffffc020650a:	35213823          	sd	s2,848(sp)
ffffffffc020650e:	35413023          	sd	s4,832(sp)
ffffffffc0206512:	33513c23          	sd	s5,824(sp)
ffffffffc0206516:	33713423          	sd	s7,808(sp)
ffffffffc020651a:	33813023          	sd	s8,800(sp)
ffffffffc020651e:	31913c23          	sd	s9,792(sp)
ffffffffc0206522:	31a13823          	sd	s10,784(sp)
ffffffffc0206526:	31b13423          	sd	s11,776(sp)
ffffffffc020652a:	c03a                	sw	a4,0(sp)
ffffffffc020652c:	47fd                	li	a5,31
ffffffffc020652e:	0286bb03          	ld	s6,40(a3)
ffffffffc0206532:	62e7ee63          	bltu	a5,a4,ffffffffc0206b6e <do_execve+0x68c>
ffffffffc0206536:	842e                	mv	s0,a1
ffffffffc0206538:	84aa                	mv	s1,a0
ffffffffc020653a:	8bb2                	mv	s7,a2
ffffffffc020653c:	4581                	li	a1,0
ffffffffc020653e:	4641                	li	a2,16
ffffffffc0206540:	18a8                	addi	a0,sp,120
ffffffffc0206542:	6e3040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206546:	000b0c63          	beqz	s6,ffffffffc020655e <do_execve+0x7c>
ffffffffc020654a:	038b0513          	addi	a0,s6,56
ffffffffc020654e:	816fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0206552:	0009b783          	ld	a5,0(s3)
ffffffffc0206556:	c781                	beqz	a5,ffffffffc020655e <do_execve+0x7c>
ffffffffc0206558:	43dc                	lw	a5,4(a5)
ffffffffc020655a:	04fb2823          	sw	a5,80(s6)
ffffffffc020655e:	1e048f63          	beqz	s1,ffffffffc020675c <do_execve+0x27a>
ffffffffc0206562:	46c1                	li	a3,16
ffffffffc0206564:	8626                	mv	a2,s1
ffffffffc0206566:	18ac                	addi	a1,sp,120
ffffffffc0206568:	855a                	mv	a0,s6
ffffffffc020656a:	e23fd0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc020656e:	60050663          	beqz	a0,ffffffffc0206b7a <do_execve+0x698>
ffffffffc0206572:	00341d93          	slli	s11,s0,0x3
ffffffffc0206576:	4681                	li	a3,0
ffffffffc0206578:	866e                	mv	a2,s11
ffffffffc020657a:	85de                	mv	a1,s7
ffffffffc020657c:	855a                	mv	a0,s6
ffffffffc020657e:	d15fd0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0206582:	8a5e                	mv	s4,s7
ffffffffc0206584:	5e050763          	beqz	a0,ffffffffc0206b72 <do_execve+0x690>
ffffffffc0206588:	10010a93          	addi	s5,sp,256
ffffffffc020658c:	4481                	li	s1,0
ffffffffc020658e:	a011                	j	ffffffffc0206592 <do_execve+0xb0>
ffffffffc0206590:	84e6                	mv	s1,s9
ffffffffc0206592:	6505                	lui	a0,0x1
ffffffffc0206594:	9fbfb0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0206598:	892a                	mv	s2,a0
ffffffffc020659a:	0e050e63          	beqz	a0,ffffffffc0206696 <do_execve+0x1b4>
ffffffffc020659e:	000a3603          	ld	a2,0(s4)
ffffffffc02065a2:	85aa                	mv	a1,a0
ffffffffc02065a4:	6685                	lui	a3,0x1
ffffffffc02065a6:	855a                	mv	a0,s6
ffffffffc02065a8:	de5fd0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc02065ac:	1a050363          	beqz	a0,ffffffffc0206752 <do_execve+0x270>
ffffffffc02065b0:	012ab023          	sd	s2,0(s5)
ffffffffc02065b4:	00148c9b          	addiw	s9,s1,1
ffffffffc02065b8:	0aa1                	addi	s5,s5,8
ffffffffc02065ba:	0a21                	addi	s4,s4,8
ffffffffc02065bc:	fd941ae3          	bne	s0,s9,ffffffffc0206590 <do_execve+0xae>
ffffffffc02065c0:	000bb903          	ld	s2,0(s7)
ffffffffc02065c4:	080b0c63          	beqz	s6,ffffffffc020665c <do_execve+0x17a>
ffffffffc02065c8:	038b0513          	addi	a0,s6,56
ffffffffc02065cc:	f95fd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02065d0:	0009b783          	ld	a5,0(s3)
ffffffffc02065d4:	040b2823          	sw	zero,80(s6)
ffffffffc02065d8:	1487b503          	ld	a0,328(a5)
ffffffffc02065dc:	cbffe0ef          	jal	ra,ffffffffc020529a <files_closeall>
ffffffffc02065e0:	4581                	li	a1,0
ffffffffc02065e2:	854a                	mv	a0,s2
ffffffffc02065e4:	f43fe0ef          	jal	ra,ffffffffc0205526 <sysfile_open>
ffffffffc02065e8:	8aaa                	mv	s5,a0
ffffffffc02065ea:	04054463          	bltz	a0,ffffffffc0206632 <do_execve+0x150>
ffffffffc02065ee:	00090797          	auipc	a5,0x90
ffffffffc02065f2:	2a27b783          	ld	a5,674(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc02065f6:	577d                	li	a4,-1
ffffffffc02065f8:	177e                	slli	a4,a4,0x3f
ffffffffc02065fa:	83b1                	srli	a5,a5,0xc
ffffffffc02065fc:	8fd9                	or	a5,a5,a4
ffffffffc02065fe:	18079073          	csrw	satp,a5
ffffffffc0206602:	030b2783          	lw	a5,48(s6)
ffffffffc0206606:	fff7871b          	addiw	a4,a5,-1
ffffffffc020660a:	02eb2823          	sw	a4,48(s6)
ffffffffc020660e:	3c070863          	beqz	a4,ffffffffc02069de <do_execve+0x4fc>
ffffffffc0206612:	0009b783          	ld	a5,0(s3)
ffffffffc0206616:	0207b423          	sd	zero,40(a5)
ffffffffc020661a:	deefd0ef          	jal	ra,ffffffffc0203c08 <mm_create>
ffffffffc020661e:	8b2a                	mv	s6,a0
ffffffffc0206620:	c901                	beqz	a0,ffffffffc0206630 <do_execve+0x14e>
ffffffffc0206622:	cd0ff0ef          	jal	ra,ffffffffc0205af2 <setup_pgdir>
ffffffffc0206626:	0e050663          	beqz	a0,ffffffffc0206712 <do_execve+0x230>
ffffffffc020662a:	855a                	mv	a0,s6
ffffffffc020662c:	f2afd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206630:	5af1                	li	s5,-4
ffffffffc0206632:	6782                	ld	a5,0(sp)
ffffffffc0206634:	147d                	addi	s0,s0,-1
ffffffffc0206636:	1984                	addi	s1,sp,240
ffffffffc0206638:	02079713          	slli	a4,a5,0x20
ffffffffc020663c:	01d75793          	srli	a5,a4,0x1d
ffffffffc0206640:	040e                	slli	s0,s0,0x3
ffffffffc0206642:	94ee                	add	s1,s1,s11
ffffffffc0206644:	0218                	addi	a4,sp,256
ffffffffc0206646:	943a                	add	s0,s0,a4
ffffffffc0206648:	8c9d                	sub	s1,s1,a5
ffffffffc020664a:	6008                	ld	a0,0(s0)
ffffffffc020664c:	1461                	addi	s0,s0,-8
ffffffffc020664e:	9f1fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0206652:	fe941ce3          	bne	s0,s1,ffffffffc020664a <do_execve+0x168>
ffffffffc0206656:	8556                	mv	a0,s5
ffffffffc0206658:	a07ff0ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc020665c:	0009b783          	ld	a5,0(s3)
ffffffffc0206660:	1487b503          	ld	a0,328(a5)
ffffffffc0206664:	c37fe0ef          	jal	ra,ffffffffc020529a <files_closeall>
ffffffffc0206668:	4581                	li	a1,0
ffffffffc020666a:	854a                	mv	a0,s2
ffffffffc020666c:	ebbfe0ef          	jal	ra,ffffffffc0205526 <sysfile_open>
ffffffffc0206670:	8aaa                	mv	s5,a0
ffffffffc0206672:	fc0540e3          	bltz	a0,ffffffffc0206632 <do_execve+0x150>
ffffffffc0206676:	0009b783          	ld	a5,0(s3)
ffffffffc020667a:	779c                	ld	a5,40(a5)
ffffffffc020667c:	dfd9                	beqz	a5,ffffffffc020661a <do_execve+0x138>
ffffffffc020667e:	00007617          	auipc	a2,0x7
ffffffffc0206682:	f9260613          	addi	a2,a2,-110 # ffffffffc020d610 <CSWTCH.79+0x2f8>
ffffffffc0206686:	2a600593          	li	a1,678
ffffffffc020668a:	00007517          	auipc	a0,0x7
ffffffffc020668e:	d9650513          	addi	a0,a0,-618 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206692:	e0df90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206696:	5971                	li	s2,-4
ffffffffc0206698:	c49d                	beqz	s1,ffffffffc02066c6 <do_execve+0x1e4>
ffffffffc020669a:	00349713          	slli	a4,s1,0x3
ffffffffc020669e:	fff48413          	addi	s0,s1,-1
ffffffffc02066a2:	199c                	addi	a5,sp,240
ffffffffc02066a4:	34fd                	addiw	s1,s1,-1
ffffffffc02066a6:	97ba                	add	a5,a5,a4
ffffffffc02066a8:	02049713          	slli	a4,s1,0x20
ffffffffc02066ac:	01d75493          	srli	s1,a4,0x1d
ffffffffc02066b0:	040e                	slli	s0,s0,0x3
ffffffffc02066b2:	0218                	addi	a4,sp,256
ffffffffc02066b4:	943a                	add	s0,s0,a4
ffffffffc02066b6:	409784b3          	sub	s1,a5,s1
ffffffffc02066ba:	6008                	ld	a0,0(s0)
ffffffffc02066bc:	1461                	addi	s0,s0,-8
ffffffffc02066be:	981fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02066c2:	fe849ce3          	bne	s1,s0,ffffffffc02066ba <do_execve+0x1d8>
ffffffffc02066c6:	000b0863          	beqz	s6,ffffffffc02066d6 <do_execve+0x1f4>
ffffffffc02066ca:	038b0513          	addi	a0,s6,56
ffffffffc02066ce:	e93fd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02066d2:	040b2823          	sw	zero,80(s6)
ffffffffc02066d6:	36813083          	ld	ra,872(sp)
ffffffffc02066da:	36013403          	ld	s0,864(sp)
ffffffffc02066de:	35813483          	ld	s1,856(sp)
ffffffffc02066e2:	34813983          	ld	s3,840(sp)
ffffffffc02066e6:	34013a03          	ld	s4,832(sp)
ffffffffc02066ea:	33813a83          	ld	s5,824(sp)
ffffffffc02066ee:	33013b03          	ld	s6,816(sp)
ffffffffc02066f2:	32813b83          	ld	s7,808(sp)
ffffffffc02066f6:	32013c03          	ld	s8,800(sp)
ffffffffc02066fa:	31813c83          	ld	s9,792(sp)
ffffffffc02066fe:	31013d03          	ld	s10,784(sp)
ffffffffc0206702:	30813d83          	ld	s11,776(sp)
ffffffffc0206706:	854a                	mv	a0,s2
ffffffffc0206708:	35013903          	ld	s2,848(sp)
ffffffffc020670c:	37010113          	addi	sp,sp,880
ffffffffc0206710:	8082                	ret
ffffffffc0206712:	4601                	li	a2,0
ffffffffc0206714:	4581                	li	a1,0
ffffffffc0206716:	8556                	mv	a0,s5
ffffffffc0206718:	874ff0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc020671c:	f02a                	sd	a0,32(sp)
ffffffffc020671e:	e10d                	bnez	a0,ffffffffc0206740 <do_execve+0x25e>
ffffffffc0206720:	04000613          	li	a2,64
ffffffffc0206724:	018c                	addi	a1,sp,192
ffffffffc0206726:	8556                	mv	a0,s5
ffffffffc0206728:	e37fe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc020672c:	04000793          	li	a5,64
ffffffffc0206730:	04f50263          	beq	a0,a5,ffffffffc0206774 <do_execve+0x292>
ffffffffc0206734:	0005079b          	sext.w	a5,a0
ffffffffc0206738:	00054363          	bltz	a0,ffffffffc020673e <do_execve+0x25c>
ffffffffc020673c:	57fd                	li	a5,-1
ffffffffc020673e:	f03e                	sd	a5,32(sp)
ffffffffc0206740:	018b3503          	ld	a0,24(s6)
ffffffffc0206744:	7a82                	ld	s5,32(sp)
ffffffffc0206746:	b36ff0ef          	jal	ra,ffffffffc0205a7c <put_pgdir.isra.0>
ffffffffc020674a:	855a                	mv	a0,s6
ffffffffc020674c:	e0afd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206750:	b5cd                	j	ffffffffc0206632 <do_execve+0x150>
ffffffffc0206752:	854a                	mv	a0,s2
ffffffffc0206754:	8ebfb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0206758:	5975                	li	s2,-3
ffffffffc020675a:	bf3d                	j	ffffffffc0206698 <do_execve+0x1b6>
ffffffffc020675c:	0009b783          	ld	a5,0(s3)
ffffffffc0206760:	00007617          	auipc	a2,0x7
ffffffffc0206764:	ea060613          	addi	a2,a2,-352 # ffffffffc020d600 <CSWTCH.79+0x2e8>
ffffffffc0206768:	45c1                	li	a1,16
ffffffffc020676a:	43d4                	lw	a3,4(a5)
ffffffffc020676c:	18a8                	addi	a0,sp,120
ffffffffc020676e:	3c7040ef          	jal	ra,ffffffffc020b334 <snprintf>
ffffffffc0206772:	b501                	j	ffffffffc0206572 <do_execve+0x90>
ffffffffc0206774:	470e                	lw	a4,192(sp)
ffffffffc0206776:	464c47b7          	lui	a5,0x464c4
ffffffffc020677a:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc020677e:	3cf71963          	bne	a4,a5,ffffffffc0206b50 <do_execve+0x66e>
ffffffffc0206782:	0f815783          	lhu	a5,248(sp)
ffffffffc0206786:	ec02                	sd	zero,24(sp)
ffffffffc0206788:	cfad                	beqz	a5,ffffffffc0206802 <do_execve+0x320>
ffffffffc020678a:	57fd                	li	a5,-1
ffffffffc020678c:	83b1                	srli	a5,a5,0xc
ffffffffc020678e:	e83e                	sd	a5,16(sp)
ffffffffc0206790:	f86e                	sd	s11,48(sp)
ffffffffc0206792:	f0e6                	sd	s9,96(sp)
ffffffffc0206794:	f4a6                	sd	s1,104(sp)
ffffffffc0206796:	fc22                	sd	s0,56(sp)
ffffffffc0206798:	758e                	ld	a1,224(sp)
ffffffffc020679a:	67e2                	ld	a5,24(sp)
ffffffffc020679c:	4601                	li	a2,0
ffffffffc020679e:	8556                	mv	a0,s5
ffffffffc02067a0:	95be                	add	a1,a1,a5
ffffffffc02067a2:	febfe0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc02067a6:	e51d                	bnez	a0,ffffffffc02067d4 <do_execve+0x2f2>
ffffffffc02067a8:	03800613          	li	a2,56
ffffffffc02067ac:	012c                	addi	a1,sp,136
ffffffffc02067ae:	8556                	mv	a0,s5
ffffffffc02067b0:	daffe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc02067b4:	03800793          	li	a5,56
ffffffffc02067b8:	02f50263          	beq	a0,a5,ffffffffc02067dc <do_execve+0x2fa>
ffffffffc02067bc:	7dc2                	ld	s11,48(sp)
ffffffffc02067be:	7462                	ld	s0,56(sp)
ffffffffc02067c0:	0005091b          	sext.w	s2,a0
ffffffffc02067c4:	00054363          	bltz	a0,ffffffffc02067ca <do_execve+0x2e8>
ffffffffc02067c8:	597d                	li	s2,-1
ffffffffc02067ca:	855a                	mv	a0,s6
ffffffffc02067cc:	f26fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc02067d0:	f04a                	sd	s2,32(sp)
ffffffffc02067d2:	b7bd                	j	ffffffffc0206740 <do_execve+0x25e>
ffffffffc02067d4:	7dc2                	ld	s11,48(sp)
ffffffffc02067d6:	7462                	ld	s0,56(sp)
ffffffffc02067d8:	892a                	mv	s2,a0
ffffffffc02067da:	bfc5                	j	ffffffffc02067ca <do_execve+0x2e8>
ffffffffc02067dc:	472a                	lw	a4,136(sp)
ffffffffc02067de:	4785                	li	a5,1
ffffffffc02067e0:	20f70a63          	beq	a4,a5,ffffffffc02069f4 <do_execve+0x512>
ffffffffc02067e4:	7702                	ld	a4,32(sp)
ffffffffc02067e6:	66e2                	ld	a3,24(sp)
ffffffffc02067e8:	0f815783          	lhu	a5,248(sp)
ffffffffc02067ec:	2705                	addiw	a4,a4,1
ffffffffc02067ee:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02067f2:	f03a                	sd	a4,32(sp)
ffffffffc02067f4:	ec36                	sd	a3,24(sp)
ffffffffc02067f6:	faf741e3          	blt	a4,a5,ffffffffc0206798 <do_execve+0x2b6>
ffffffffc02067fa:	7dc2                	ld	s11,48(sp)
ffffffffc02067fc:	7c86                	ld	s9,96(sp)
ffffffffc02067fe:	74a6                	ld	s1,104(sp)
ffffffffc0206800:	7462                	ld	s0,56(sp)
ffffffffc0206802:	4701                	li	a4,0
ffffffffc0206804:	46ad                	li	a3,11
ffffffffc0206806:	00100637          	lui	a2,0x100
ffffffffc020680a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc020680e:	855a                	mv	a0,s6
ffffffffc0206810:	d98fd0ef          	jal	ra,ffffffffc0203da8 <mm_map>
ffffffffc0206814:	892a                	mv	s2,a0
ffffffffc0206816:	f955                	bnez	a0,ffffffffc02067ca <do_execve+0x2e8>
ffffffffc0206818:	018b3503          	ld	a0,24(s6)
ffffffffc020681c:	467d                	li	a2,31
ffffffffc020681e:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206822:	b00fd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206826:	3c050d63          	beqz	a0,ffffffffc0206c00 <do_execve+0x71e>
ffffffffc020682a:	018b3503          	ld	a0,24(s6)
ffffffffc020682e:	467d                	li	a2,31
ffffffffc0206830:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206834:	aeefd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206838:	40050463          	beqz	a0,ffffffffc0206c40 <do_execve+0x75e>
ffffffffc020683c:	018b3503          	ld	a0,24(s6)
ffffffffc0206840:	467d                	li	a2,31
ffffffffc0206842:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206846:	adcfd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc020684a:	3c050b63          	beqz	a0,ffffffffc0206c20 <do_execve+0x73e>
ffffffffc020684e:	018b3503          	ld	a0,24(s6)
ffffffffc0206852:	467d                	li	a2,31
ffffffffc0206854:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206858:	acafd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc020685c:	38050263          	beqz	a0,ffffffffc0206be0 <do_execve+0x6fe>
ffffffffc0206860:	018b3503          	ld	a0,24(s6)
ffffffffc0206864:	4601                	li	a2,0
ffffffffc0206866:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc020686a:	ca9fb0ef          	jal	ra,ffffffffc0202512 <get_page>
ffffffffc020686e:	00090797          	auipc	a5,0x90
ffffffffc0206872:	03a7b783          	ld	a5,58(a5) # ffffffffc02968a8 <pages>
ffffffffc0206876:	40f506b3          	sub	a3,a0,a5
ffffffffc020687a:	8699                	srai	a3,a3,0x6
ffffffffc020687c:	00009797          	auipc	a5,0x9
ffffffffc0206880:	eb47b783          	ld	a5,-332(a5) # ffffffffc020f730 <nbase>
ffffffffc0206884:	96be                	add	a3,a3,a5
ffffffffc0206886:	00c69793          	slli	a5,a3,0xc
ffffffffc020688a:	83b1                	srli	a5,a5,0xc
ffffffffc020688c:	00090717          	auipc	a4,0x90
ffffffffc0206890:	01473703          	ld	a4,20(a4) # ffffffffc02968a0 <npage>
ffffffffc0206894:	06b2                	slli	a3,a3,0xc
ffffffffc0206896:	32e7f963          	bgeu	a5,a4,ffffffffc0206bc8 <do_execve+0x6e6>
ffffffffc020689a:	00090a17          	auipc	s4,0x90
ffffffffc020689e:	01ea0a13          	addi	s4,s4,30 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02068a2:	000a3a83          	ld	s5,0(s4)
ffffffffc02068a6:	4785                	li	a5,1
ffffffffc02068a8:	10010d13          	addi	s10,sp,256
ffffffffc02068ac:	96d6                	add	a3,a3,s5
ffffffffc02068ae:	6a85                	lui	s5,0x1
ffffffffc02068b0:	9ab6                	add	s5,s5,a3
ffffffffc02068b2:	4b81                	li	s7,0
ffffffffc02068b4:	20010c13          	addi	s8,sp,512
ffffffffc02068b8:	07fe                	slli	a5,a5,0x1f
ffffffffc02068ba:	ec4a                	sd	s2,24(sp)
ffffffffc02068bc:	f022                	sd	s0,32(sp)
ffffffffc02068be:	896a                	mv	s2,s10
ffffffffc02068c0:	e456                	sd	s5,8(sp)
ffffffffc02068c2:	8d5e                	mv	s10,s7
ffffffffc02068c4:	e83e                	sd	a5,16(sp)
ffffffffc02068c6:	8bd6                	mv	s7,s5
ffffffffc02068c8:	8462                	mv	s0,s8
ffffffffc02068ca:	00093a83          	ld	s5,0(s2) # ffffffff80000000 <_binary_bin_sfs_img_size+0xffffffff7ff8ad00>
ffffffffc02068ce:	6585                	lui	a1,0x1
ffffffffc02068d0:	0921                	addi	s2,s2,8
ffffffffc02068d2:	8556                	mv	a0,s5
ffffffffc02068d4:	2c9040ef          	jal	ra,ffffffffc020b39c <strnlen>
ffffffffc02068d8:	0015061b          	addiw	a2,a0,1
ffffffffc02068dc:	40cb8bb3          	sub	s7,s7,a2
ffffffffc02068e0:	85d6                	mv	a1,s5
ffffffffc02068e2:	855e                	mv	a0,s7
ffffffffc02068e4:	393040ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc02068e8:	67a2                	ld	a5,8(sp)
ffffffffc02068ea:	6742                	ld	a4,16(sp)
ffffffffc02068ec:	0421                	addi	s0,s0,8
ffffffffc02068ee:	417787b3          	sub	a5,a5,s7
ffffffffc02068f2:	40f707b3          	sub	a5,a4,a5
ffffffffc02068f6:	fef43c23          	sd	a5,-8(s0)
ffffffffc02068fa:	87ea                	mv	a5,s10
ffffffffc02068fc:	2d05                	addiw	s10,s10,1
ffffffffc02068fe:	fc97c6e3          	blt	a5,s1,ffffffffc02068ca <do_execve+0x3e8>
ffffffffc0206902:	ff8bf613          	andi	a2,s7,-8
ffffffffc0206906:	41b605b3          	sub	a1,a2,s11
ffffffffc020690a:	6962                	ld	s2,24(sp)
ffffffffc020690c:	7402                	ld	s0,32(sp)
ffffffffc020690e:	15e1                	addi	a1,a1,-8
ffffffffc0206910:	872e                	mv	a4,a1
ffffffffc0206912:	4781                	li	a5,0
ffffffffc0206914:	000c3503          	ld	a0,0(s8)
ffffffffc0206918:	86be                	mv	a3,a5
ffffffffc020691a:	0c21                	addi	s8,s8,8
ffffffffc020691c:	e308                	sd	a0,0(a4)
ffffffffc020691e:	2785                	addiw	a5,a5,1
ffffffffc0206920:	0721                	addi	a4,a4,8
ffffffffc0206922:	fe96c9e3          	blt	a3,s1,ffffffffc0206914 <do_execve+0x432>
ffffffffc0206926:	fe063c23          	sd	zero,-8(a2) # ffff8 <_binary_bin_sfs_img_size+0x8acf8>
ffffffffc020692a:	ff95ae23          	sw	s9,-4(a1) # ffc <_binary_bin_swap_img_size-0x6d04>
ffffffffc020692e:	030b2783          	lw	a5,48(s6)
ffffffffc0206932:	0009b603          	ld	a2,0(s3)
ffffffffc0206936:	018b3683          	ld	a3,24(s6)
ffffffffc020693a:	2785                	addiw	a5,a5,1
ffffffffc020693c:	02fb2823          	sw	a5,48(s6)
ffffffffc0206940:	67a2                	ld	a5,8(sp)
ffffffffc0206942:	15f1                	addi	a1,a1,-4
ffffffffc0206944:	4485                	li	s1,1
ffffffffc0206946:	40b78ab3          	sub	s5,a5,a1
ffffffffc020694a:	04fe                	slli	s1,s1,0x1f
ffffffffc020694c:	03663423          	sd	s6,40(a2)
ffffffffc0206950:	c02007b7          	lui	a5,0xc0200
ffffffffc0206954:	415484b3          	sub	s1,s1,s5
ffffffffc0206958:	24f6ec63          	bltu	a3,a5,ffffffffc0206bb0 <do_execve+0x6ce>
ffffffffc020695c:	000a3783          	ld	a5,0(s4)
ffffffffc0206960:	577d                	li	a4,-1
ffffffffc0206962:	177e                	slli	a4,a4,0x3f
ffffffffc0206964:	8e9d                	sub	a3,a3,a5
ffffffffc0206966:	00c6d793          	srli	a5,a3,0xc
ffffffffc020696a:	f654                	sd	a3,168(a2)
ffffffffc020696c:	8fd9                	or	a5,a5,a4
ffffffffc020696e:	18079073          	csrw	satp,a5
ffffffffc0206972:	0a063a03          	ld	s4,160(a2)
ffffffffc0206976:	4581                	li	a1,0
ffffffffc0206978:	12000613          	li	a2,288
ffffffffc020697c:	8552                	mv	a0,s4
ffffffffc020697e:	2a7040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206982:	67ee                	ld	a5,216(sp)
ffffffffc0206984:	009a3823          	sd	s1,16(s4)
ffffffffc0206988:	10fa3423          	sd	a5,264(s4)
ffffffffc020698c:	100027f3          	csrr	a5,sstatus
ffffffffc0206990:	6702                	ld	a4,0(sp)
ffffffffc0206992:	eff7f793          	andi	a5,a5,-257
ffffffffc0206996:	0207e793          	ori	a5,a5,32
ffffffffc020699a:	147d                	addi	s0,s0,-1
ffffffffc020699c:	1984                	addi	s1,sp,240
ffffffffc020699e:	02071693          	slli	a3,a4,0x20
ffffffffc02069a2:	040e                	slli	s0,s0,0x3
ffffffffc02069a4:	94ee                	add	s1,s1,s11
ffffffffc02069a6:	01d6d713          	srli	a4,a3,0x1d
ffffffffc02069aa:	10fa3023          	sd	a5,256(s4)
ffffffffc02069ae:	021c                	addi	a5,sp,256
ffffffffc02069b0:	943e                	add	s0,s0,a5
ffffffffc02069b2:	8c99                	sub	s1,s1,a4
ffffffffc02069b4:	6008                	ld	a0,0(s0)
ffffffffc02069b6:	1461                	addi	s0,s0,-8
ffffffffc02069b8:	e86fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02069bc:	fe941ce3          	bne	s0,s1,ffffffffc02069b4 <do_execve+0x4d2>
ffffffffc02069c0:	0009b403          	ld	s0,0(s3)
ffffffffc02069c4:	4641                	li	a2,16
ffffffffc02069c6:	4581                	li	a1,0
ffffffffc02069c8:	0b440413          	addi	s0,s0,180
ffffffffc02069cc:	8522                	mv	a0,s0
ffffffffc02069ce:	257040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc02069d2:	463d                	li	a2,15
ffffffffc02069d4:	18ac                	addi	a1,sp,120
ffffffffc02069d6:	8522                	mv	a0,s0
ffffffffc02069d8:	29f040ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc02069dc:	b9ed                	j	ffffffffc02066d6 <do_execve+0x1f4>
ffffffffc02069de:	855a                	mv	a0,s6
ffffffffc02069e0:	d12fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc02069e4:	018b3503          	ld	a0,24(s6)
ffffffffc02069e8:	894ff0ef          	jal	ra,ffffffffc0205a7c <put_pgdir.isra.0>
ffffffffc02069ec:	855a                	mv	a0,s6
ffffffffc02069ee:	b68fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc02069f2:	b105                	j	ffffffffc0206612 <do_execve+0x130>
ffffffffc02069f4:	764a                	ld	a2,176(sp)
ffffffffc02069f6:	77aa                	ld	a5,168(sp)
ffffffffc02069f8:	18f66b63          	bltu	a2,a5,ffffffffc0206b8e <do_execve+0x6ac>
ffffffffc02069fc:	47ba                	lw	a5,140(sp)
ffffffffc02069fe:	0017f693          	andi	a3,a5,1
ffffffffc0206a02:	c291                	beqz	a3,ffffffffc0206a06 <do_execve+0x524>
ffffffffc0206a04:	4691                	li	a3,4
ffffffffc0206a06:	0027f713          	andi	a4,a5,2
ffffffffc0206a0a:	8b91                	andi	a5,a5,4
ffffffffc0206a0c:	cb01                	beqz	a4,ffffffffc0206a1c <do_execve+0x53a>
ffffffffc0206a0e:	0026e693          	ori	a3,a3,2
ffffffffc0206a12:	4c45                	li	s8,17
ffffffffc0206a14:	e791                	bnez	a5,ffffffffc0206a20 <do_execve+0x53e>
ffffffffc0206a16:	004c6c13          	ori	s8,s8,4
ffffffffc0206a1a:	a809                	j	ffffffffc0206a2c <do_execve+0x54a>
ffffffffc0206a1c:	4c45                	li	s8,17
ffffffffc0206a1e:	c781                	beqz	a5,ffffffffc0206a26 <do_execve+0x544>
ffffffffc0206a20:	0016e693          	ori	a3,a3,1
ffffffffc0206a24:	4c4d                	li	s8,19
ffffffffc0206a26:	0026f793          	andi	a5,a3,2
ffffffffc0206a2a:	f7f5                	bnez	a5,ffffffffc0206a16 <do_execve+0x534>
ffffffffc0206a2c:	0046f793          	andi	a5,a3,4
ffffffffc0206a30:	c399                	beqz	a5,ffffffffc0206a36 <do_execve+0x554>
ffffffffc0206a32:	008c6c13          	ori	s8,s8,8
ffffffffc0206a36:	65ea                	ld	a1,152(sp)
ffffffffc0206a38:	4701                	li	a4,0
ffffffffc0206a3a:	855a                	mv	a0,s6
ffffffffc0206a3c:	b6cfd0ef          	jal	ra,ffffffffc0203da8 <mm_map>
ffffffffc0206a40:	d8051ae3          	bnez	a0,ffffffffc02067d4 <do_execve+0x2f2>
ffffffffc0206a44:	6a6a                	ld	s4,152(sp)
ffffffffc0206a46:	7bca                	ld	s7,176(sp)
ffffffffc0206a48:	6705                	lui	a4,0x1
ffffffffc0206a4a:	177d                	addi	a4,a4,-1
ffffffffc0206a4c:	9bd2                	add	s7,s7,s4
ffffffffc0206a4e:	77fd                	lui	a5,0xfffff
ffffffffc0206a50:	74aa                	ld	s1,168(sp)
ffffffffc0206a52:	9bba                	add	s7,s7,a4
ffffffffc0206a54:	00fbf733          	and	a4,s7,a5
ffffffffc0206a58:	00fa7433          	and	s0,s4,a5
ffffffffc0206a5c:	e43a                	sd	a4,8(sp)
ffffffffc0206a5e:	67ca                	ld	a5,144(sp)
ffffffffc0206a60:	94d2                	add	s1,s1,s4
ffffffffc0206a62:	d8e471e3          	bgeu	s0,a4,ffffffffc02067e4 <do_execve+0x302>
ffffffffc0206a66:	414787b3          	sub	a5,a5,s4
ffffffffc0206a6a:	00009917          	auipc	s2,0x9
ffffffffc0206a6e:	cc690913          	addi	s2,s2,-826 # ffffffffc020f730 <nbase>
ffffffffc0206a72:	00090d17          	auipc	s10,0x90
ffffffffc0206a76:	e2ed0d13          	addi	s10,s10,-466 # ffffffffc02968a0 <npage>
ffffffffc0206a7a:	00090c97          	auipc	s9,0x90
ffffffffc0206a7e:	e3ec8c93          	addi	s9,s9,-450 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206a82:	e8be                	sd	a5,80(sp)
ffffffffc0206a84:	8da2                	mv	s11,s0
ffffffffc0206a86:	f456                	sd	s5,40(sp)
ffffffffc0206a88:	018b3503          	ld	a0,24(s6)
ffffffffc0206a8c:	8662                	mv	a2,s8
ffffffffc0206a8e:	85ee                	mv	a1,s11
ffffffffc0206a90:	892fd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206a94:	c579                	beqz	a0,ffffffffc0206b62 <do_execve+0x680>
ffffffffc0206a96:	00090797          	auipc	a5,0x90
ffffffffc0206a9a:	e1278793          	addi	a5,a5,-494 # ffffffffc02968a8 <pages>
ffffffffc0206a9e:	6390                	ld	a2,0(a5)
ffffffffc0206aa0:	00093683          	ld	a3,0(s2)
ffffffffc0206aa4:	67c2                	ld	a5,16(sp)
ffffffffc0206aa6:	8d11                	sub	a0,a0,a2
ffffffffc0206aa8:	8519                	srai	a0,a0,0x6
ffffffffc0206aaa:	000d3703          	ld	a4,0(s10)
ffffffffc0206aae:	9536                	add	a0,a0,a3
ffffffffc0206ab0:	00f576b3          	and	a3,a0,a5
ffffffffc0206ab4:	0532                	slli	a0,a0,0xc
ffffffffc0206ab6:	0ee6f063          	bgeu	a3,a4,ffffffffc0206b96 <do_execve+0x6b4>
ffffffffc0206aba:	000cb403          	ld	s0,0(s9)
ffffffffc0206abe:	6785                	lui	a5,0x1
ffffffffc0206ac0:	00fd8bb3          	add	s7,s11,a5
ffffffffc0206ac4:	86ee                	mv	a3,s11
ffffffffc0206ac6:	942a                	add	s0,s0,a0
ffffffffc0206ac8:	014df363          	bgeu	s11,s4,ffffffffc0206ace <do_execve+0x5ec>
ffffffffc0206acc:	86d2                	mv	a3,s4
ffffffffc0206ace:	8aa6                	mv	s5,s1
ffffffffc0206ad0:	009bf363          	bgeu	s7,s1,ffffffffc0206ad6 <do_execve+0x5f4>
ffffffffc0206ad4:	8ade                	mv	s5,s7
ffffffffc0206ad6:	0756f763          	bgeu	a3,s5,ffffffffc0206b44 <do_execve+0x662>
ffffffffc0206ada:	67c6                	ld	a5,80(sp)
ffffffffc0206adc:	7522                	ld	a0,40(sp)
ffffffffc0206ade:	4601                	li	a2,0
ffffffffc0206ae0:	00d785b3          	add	a1,a5,a3
ffffffffc0206ae4:	e0b6                	sd	a3,64(sp)
ffffffffc0206ae6:	ca7fe0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc0206aea:	ce0515e3          	bnez	a0,ffffffffc02067d4 <do_execve+0x2f2>
ffffffffc0206aee:	6686                	ld	a3,64(sp)
ffffffffc0206af0:	7522                	ld	a0,40(sp)
ffffffffc0206af2:	41b688b3          	sub	a7,a3,s11
ffffffffc0206af6:	40da8633          	sub	a2,s5,a3
ffffffffc0206afa:	011405b3          	add	a1,s0,a7
ffffffffc0206afe:	ecb2                	sd	a2,88(sp)
ffffffffc0206b00:	e4b6                	sd	a3,72(sp)
ffffffffc0206b02:	e0c6                	sd	a7,64(sp)
ffffffffc0206b04:	a5bfe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc0206b08:	6666                	ld	a2,88(sp)
ffffffffc0206b0a:	caa619e3          	bne	a2,a0,ffffffffc02067bc <do_execve+0x2da>
ffffffffc0206b0e:	66a6                	ld	a3,72(sp)
ffffffffc0206b10:	6886                	ld	a7,64(sp)
ffffffffc0206b12:	00dde963          	bltu	s11,a3,ffffffffc0206b24 <do_execve+0x642>
ffffffffc0206b16:	017aee63          	bltu	s5,s7,ffffffffc0206b32 <do_execve+0x650>
ffffffffc0206b1a:	67a2                	ld	a5,8(sp)
ffffffffc0206b1c:	04fbf763          	bgeu	s7,a5,ffffffffc0206b6a <do_execve+0x688>
ffffffffc0206b20:	8dde                	mv	s11,s7
ffffffffc0206b22:	b79d                	j	ffffffffc0206a88 <do_execve+0x5a6>
ffffffffc0206b24:	8646                	mv	a2,a7
ffffffffc0206b26:	4581                	li	a1,0
ffffffffc0206b28:	8522                	mv	a0,s0
ffffffffc0206b2a:	0fb040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206b2e:	ff7af6e3          	bgeu	s5,s7,ffffffffc0206b1a <do_execve+0x638>
ffffffffc0206b32:	41ba8533          	sub	a0,s5,s11
ffffffffc0206b36:	415b8633          	sub	a2,s7,s5
ffffffffc0206b3a:	4581                	li	a1,0
ffffffffc0206b3c:	9522                	add	a0,a0,s0
ffffffffc0206b3e:	0e7040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206b42:	bfe1                	j	ffffffffc0206b1a <do_execve+0x638>
ffffffffc0206b44:	6605                	lui	a2,0x1
ffffffffc0206b46:	4581                	li	a1,0
ffffffffc0206b48:	8522                	mv	a0,s0
ffffffffc0206b4a:	0db040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206b4e:	b7f1                	j	ffffffffc0206b1a <do_execve+0x638>
ffffffffc0206b50:	018b3503          	ld	a0,24(s6)
ffffffffc0206b54:	5ae1                	li	s5,-8
ffffffffc0206b56:	f27fe0ef          	jal	ra,ffffffffc0205a7c <put_pgdir.isra.0>
ffffffffc0206b5a:	855a                	mv	a0,s6
ffffffffc0206b5c:	9fafd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206b60:	bcc9                	j	ffffffffc0206632 <do_execve+0x150>
ffffffffc0206b62:	7dc2                	ld	s11,48(sp)
ffffffffc0206b64:	7462                	ld	s0,56(sp)
ffffffffc0206b66:	5971                	li	s2,-4
ffffffffc0206b68:	b18d                	j	ffffffffc02067ca <do_execve+0x2e8>
ffffffffc0206b6a:	7aa2                	ld	s5,40(sp)
ffffffffc0206b6c:	b9a5                	j	ffffffffc02067e4 <do_execve+0x302>
ffffffffc0206b6e:	5975                	li	s2,-3
ffffffffc0206b70:	b69d                	j	ffffffffc02066d6 <do_execve+0x1f4>
ffffffffc0206b72:	5975                	li	s2,-3
ffffffffc0206b74:	b40b1be3          	bnez	s6,ffffffffc02066ca <do_execve+0x1e8>
ffffffffc0206b78:	beb9                	j	ffffffffc02066d6 <do_execve+0x1f4>
ffffffffc0206b7a:	fe0b0ae3          	beqz	s6,ffffffffc0206b6e <do_execve+0x68c>
ffffffffc0206b7e:	038b0513          	addi	a0,s6,56
ffffffffc0206b82:	9dffd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0206b86:	5975                	li	s2,-3
ffffffffc0206b88:	040b2823          	sw	zero,80(s6)
ffffffffc0206b8c:	b6a9                	j	ffffffffc02066d6 <do_execve+0x1f4>
ffffffffc0206b8e:	7dc2                	ld	s11,48(sp)
ffffffffc0206b90:	7462                	ld	s0,56(sp)
ffffffffc0206b92:	5961                	li	s2,-8
ffffffffc0206b94:	b91d                	j	ffffffffc02067ca <do_execve+0x2e8>
ffffffffc0206b96:	86aa                	mv	a3,a0
ffffffffc0206b98:	00006617          	auipc	a2,0x6
ffffffffc0206b9c:	89060613          	addi	a2,a2,-1904 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0206ba0:	07100593          	li	a1,113
ffffffffc0206ba4:	00006517          	auipc	a0,0x6
ffffffffc0206ba8:	8ac50513          	addi	a0,a0,-1876 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0206bac:	8f3f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206bb0:	00006617          	auipc	a2,0x6
ffffffffc0206bb4:	92060613          	addi	a2,a2,-1760 # ffffffffc020c4d0 <default_pmm_manager+0xe0>
ffffffffc0206bb8:	32800593          	li	a1,808
ffffffffc0206bbc:	00007517          	auipc	a0,0x7
ffffffffc0206bc0:	86450513          	addi	a0,a0,-1948 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206bc4:	8dbf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206bc8:	00006617          	auipc	a2,0x6
ffffffffc0206bcc:	86060613          	addi	a2,a2,-1952 # ffffffffc020c428 <default_pmm_manager+0x38>
ffffffffc0206bd0:	07100593          	li	a1,113
ffffffffc0206bd4:	00006517          	auipc	a0,0x6
ffffffffc0206bd8:	87c50513          	addi	a0,a0,-1924 # ffffffffc020c450 <default_pmm_manager+0x60>
ffffffffc0206bdc:	8c3f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206be0:	00007697          	auipc	a3,0x7
ffffffffc0206be4:	b3068693          	addi	a3,a3,-1232 # ffffffffc020d710 <CSWTCH.79+0x3f8>
ffffffffc0206be8:	00005617          	auipc	a2,0x5
ffffffffc0206bec:	d2060613          	addi	a2,a2,-736 # ffffffffc020b908 <commands+0x210>
ffffffffc0206bf0:	30900593          	li	a1,777
ffffffffc0206bf4:	00007517          	auipc	a0,0x7
ffffffffc0206bf8:	82c50513          	addi	a0,a0,-2004 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206bfc:	8a3f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c00:	00007697          	auipc	a3,0x7
ffffffffc0206c04:	a3868693          	addi	a3,a3,-1480 # ffffffffc020d638 <CSWTCH.79+0x320>
ffffffffc0206c08:	00005617          	auipc	a2,0x5
ffffffffc0206c0c:	d0060613          	addi	a2,a2,-768 # ffffffffc020b908 <commands+0x210>
ffffffffc0206c10:	30600593          	li	a1,774
ffffffffc0206c14:	00007517          	auipc	a0,0x7
ffffffffc0206c18:	80c50513          	addi	a0,a0,-2036 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206c1c:	883f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c20:	00007697          	auipc	a3,0x7
ffffffffc0206c24:	aa868693          	addi	a3,a3,-1368 # ffffffffc020d6c8 <CSWTCH.79+0x3b0>
ffffffffc0206c28:	00005617          	auipc	a2,0x5
ffffffffc0206c2c:	ce060613          	addi	a2,a2,-800 # ffffffffc020b908 <commands+0x210>
ffffffffc0206c30:	30800593          	li	a1,776
ffffffffc0206c34:	00006517          	auipc	a0,0x6
ffffffffc0206c38:	7ec50513          	addi	a0,a0,2028 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206c3c:	863f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c40:	00007697          	auipc	a3,0x7
ffffffffc0206c44:	a4068693          	addi	a3,a3,-1472 # ffffffffc020d680 <CSWTCH.79+0x368>
ffffffffc0206c48:	00005617          	auipc	a2,0x5
ffffffffc0206c4c:	cc060613          	addi	a2,a2,-832 # ffffffffc020b908 <commands+0x210>
ffffffffc0206c50:	30700593          	li	a1,775
ffffffffc0206c54:	00006517          	auipc	a0,0x6
ffffffffc0206c58:	7cc50513          	addi	a0,a0,1996 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206c5c:	843f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206c60 <user_main>:
ffffffffc0206c60:	7179                	addi	sp,sp,-48
ffffffffc0206c62:	e84a                	sd	s2,16(sp)
ffffffffc0206c64:	00090917          	auipc	s2,0x90
ffffffffc0206c68:	c5c90913          	addi	s2,s2,-932 # ffffffffc02968c0 <current>
ffffffffc0206c6c:	00093783          	ld	a5,0(s2)
ffffffffc0206c70:	00007617          	auipc	a2,0x7
ffffffffc0206c74:	ae860613          	addi	a2,a2,-1304 # ffffffffc020d758 <CSWTCH.79+0x440>
ffffffffc0206c78:	00007517          	auipc	a0,0x7
ffffffffc0206c7c:	ae850513          	addi	a0,a0,-1304 # ffffffffc020d760 <CSWTCH.79+0x448>
ffffffffc0206c80:	43cc                	lw	a1,4(a5)
ffffffffc0206c82:	f406                	sd	ra,40(sp)
ffffffffc0206c84:	f022                	sd	s0,32(sp)
ffffffffc0206c86:	ec26                	sd	s1,24(sp)
ffffffffc0206c88:	e032                	sd	a2,0(sp)
ffffffffc0206c8a:	e402                	sd	zero,8(sp)
ffffffffc0206c8c:	d1af90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206c90:	6782                	ld	a5,0(sp)
ffffffffc0206c92:	cfb9                	beqz	a5,ffffffffc0206cf0 <user_main+0x90>
ffffffffc0206c94:	003c                	addi	a5,sp,8
ffffffffc0206c96:	4401                	li	s0,0
ffffffffc0206c98:	6398                	ld	a4,0(a5)
ffffffffc0206c9a:	0405                	addi	s0,s0,1
ffffffffc0206c9c:	07a1                	addi	a5,a5,8
ffffffffc0206c9e:	ff6d                	bnez	a4,ffffffffc0206c98 <user_main+0x38>
ffffffffc0206ca0:	00093783          	ld	a5,0(s2)
ffffffffc0206ca4:	12000613          	li	a2,288
ffffffffc0206ca8:	6b84                	ld	s1,16(a5)
ffffffffc0206caa:	73cc                	ld	a1,160(a5)
ffffffffc0206cac:	6789                	lui	a5,0x2
ffffffffc0206cae:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206cb2:	94be                	add	s1,s1,a5
ffffffffc0206cb4:	8526                	mv	a0,s1
ffffffffc0206cb6:	7c0040ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0206cba:	00093783          	ld	a5,0(s2)
ffffffffc0206cbe:	860a                	mv	a2,sp
ffffffffc0206cc0:	0004059b          	sext.w	a1,s0
ffffffffc0206cc4:	f3c4                	sd	s1,160(a5)
ffffffffc0206cc6:	00007517          	auipc	a0,0x7
ffffffffc0206cca:	a9250513          	addi	a0,a0,-1390 # ffffffffc020d758 <CSWTCH.79+0x440>
ffffffffc0206cce:	815ff0ef          	jal	ra,ffffffffc02064e2 <do_execve>
ffffffffc0206cd2:	8126                	mv	sp,s1
ffffffffc0206cd4:	d7cfa06f          	j	ffffffffc0201250 <__trapret>
ffffffffc0206cd8:	00007617          	auipc	a2,0x7
ffffffffc0206cdc:	ab060613          	addi	a2,a2,-1360 # ffffffffc020d788 <CSWTCH.79+0x470>
ffffffffc0206ce0:	44900593          	li	a1,1097
ffffffffc0206ce4:	00006517          	auipc	a0,0x6
ffffffffc0206ce8:	73c50513          	addi	a0,a0,1852 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206cec:	fb2f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206cf0:	4401                	li	s0,0
ffffffffc0206cf2:	b77d                	j	ffffffffc0206ca0 <user_main+0x40>

ffffffffc0206cf4 <do_yield>:
ffffffffc0206cf4:	00090797          	auipc	a5,0x90
ffffffffc0206cf8:	bcc7b783          	ld	a5,-1076(a5) # ffffffffc02968c0 <current>
ffffffffc0206cfc:	4705                	li	a4,1
ffffffffc0206cfe:	ef98                	sd	a4,24(a5)
ffffffffc0206d00:	4501                	li	a0,0
ffffffffc0206d02:	8082                	ret

ffffffffc0206d04 <do_wait>:
ffffffffc0206d04:	1101                	addi	sp,sp,-32
ffffffffc0206d06:	e822                	sd	s0,16(sp)
ffffffffc0206d08:	e426                	sd	s1,8(sp)
ffffffffc0206d0a:	ec06                	sd	ra,24(sp)
ffffffffc0206d0c:	842e                	mv	s0,a1
ffffffffc0206d0e:	84aa                	mv	s1,a0
ffffffffc0206d10:	c999                	beqz	a1,ffffffffc0206d26 <do_wait+0x22>
ffffffffc0206d12:	00090797          	auipc	a5,0x90
ffffffffc0206d16:	bae7b783          	ld	a5,-1106(a5) # ffffffffc02968c0 <current>
ffffffffc0206d1a:	7788                	ld	a0,40(a5)
ffffffffc0206d1c:	4685                	li	a3,1
ffffffffc0206d1e:	4611                	li	a2,4
ffffffffc0206d20:	d72fd0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0206d24:	c909                	beqz	a0,ffffffffc0206d36 <do_wait+0x32>
ffffffffc0206d26:	85a2                	mv	a1,s0
ffffffffc0206d28:	6442                	ld	s0,16(sp)
ffffffffc0206d2a:	60e2                	ld	ra,24(sp)
ffffffffc0206d2c:	8526                	mv	a0,s1
ffffffffc0206d2e:	64a2                	ld	s1,8(sp)
ffffffffc0206d30:	6105                	addi	sp,sp,32
ffffffffc0206d32:	c8eff06f          	j	ffffffffc02061c0 <do_wait.part.0>
ffffffffc0206d36:	60e2                	ld	ra,24(sp)
ffffffffc0206d38:	6442                	ld	s0,16(sp)
ffffffffc0206d3a:	64a2                	ld	s1,8(sp)
ffffffffc0206d3c:	5575                	li	a0,-3
ffffffffc0206d3e:	6105                	addi	sp,sp,32
ffffffffc0206d40:	8082                	ret

ffffffffc0206d42 <do_kill>:
ffffffffc0206d42:	1141                	addi	sp,sp,-16
ffffffffc0206d44:	6789                	lui	a5,0x2
ffffffffc0206d46:	e406                	sd	ra,8(sp)
ffffffffc0206d48:	e022                	sd	s0,0(sp)
ffffffffc0206d4a:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206d4e:	17f9                	addi	a5,a5,-2
ffffffffc0206d50:	02e7e963          	bltu	a5,a4,ffffffffc0206d82 <do_kill+0x40>
ffffffffc0206d54:	842a                	mv	s0,a0
ffffffffc0206d56:	45a9                	li	a1,10
ffffffffc0206d58:	2501                	sext.w	a0,a0
ffffffffc0206d5a:	196040ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc0206d5e:	02051793          	slli	a5,a0,0x20
ffffffffc0206d62:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206d66:	0008b797          	auipc	a5,0x8b
ffffffffc0206d6a:	a5a78793          	addi	a5,a5,-1446 # ffffffffc02917c0 <hash_list>
ffffffffc0206d6e:	953e                	add	a0,a0,a5
ffffffffc0206d70:	87aa                	mv	a5,a0
ffffffffc0206d72:	a029                	j	ffffffffc0206d7c <do_kill+0x3a>
ffffffffc0206d74:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206d78:	00870b63          	beq	a4,s0,ffffffffc0206d8e <do_kill+0x4c>
ffffffffc0206d7c:	679c                	ld	a5,8(a5)
ffffffffc0206d7e:	fef51be3          	bne	a0,a5,ffffffffc0206d74 <do_kill+0x32>
ffffffffc0206d82:	5475                	li	s0,-3
ffffffffc0206d84:	60a2                	ld	ra,8(sp)
ffffffffc0206d86:	8522                	mv	a0,s0
ffffffffc0206d88:	6402                	ld	s0,0(sp)
ffffffffc0206d8a:	0141                	addi	sp,sp,16
ffffffffc0206d8c:	8082                	ret
ffffffffc0206d8e:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206d92:	00177693          	andi	a3,a4,1
ffffffffc0206d96:	e295                	bnez	a3,ffffffffc0206dba <do_kill+0x78>
ffffffffc0206d98:	4bd4                	lw	a3,20(a5)
ffffffffc0206d9a:	00176713          	ori	a4,a4,1
ffffffffc0206d9e:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206da2:	4401                	li	s0,0
ffffffffc0206da4:	fe06d0e3          	bgez	a3,ffffffffc0206d84 <do_kill+0x42>
ffffffffc0206da8:	f2878513          	addi	a0,a5,-216
ffffffffc0206dac:	45a000ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc0206db0:	60a2                	ld	ra,8(sp)
ffffffffc0206db2:	8522                	mv	a0,s0
ffffffffc0206db4:	6402                	ld	s0,0(sp)
ffffffffc0206db6:	0141                	addi	sp,sp,16
ffffffffc0206db8:	8082                	ret
ffffffffc0206dba:	545d                	li	s0,-9
ffffffffc0206dbc:	b7e1                	j	ffffffffc0206d84 <do_kill+0x42>

ffffffffc0206dbe <proc_init>:
ffffffffc0206dbe:	1101                	addi	sp,sp,-32
ffffffffc0206dc0:	e426                	sd	s1,8(sp)
ffffffffc0206dc2:	0008f797          	auipc	a5,0x8f
ffffffffc0206dc6:	9fe78793          	addi	a5,a5,-1538 # ffffffffc02957c0 <proc_list>
ffffffffc0206dca:	ec06                	sd	ra,24(sp)
ffffffffc0206dcc:	e822                	sd	s0,16(sp)
ffffffffc0206dce:	e04a                	sd	s2,0(sp)
ffffffffc0206dd0:	0008b497          	auipc	s1,0x8b
ffffffffc0206dd4:	9f048493          	addi	s1,s1,-1552 # ffffffffc02917c0 <hash_list>
ffffffffc0206dd8:	e79c                	sd	a5,8(a5)
ffffffffc0206dda:	e39c                	sd	a5,0(a5)
ffffffffc0206ddc:	0008f717          	auipc	a4,0x8f
ffffffffc0206de0:	9e470713          	addi	a4,a4,-1564 # ffffffffc02957c0 <proc_list>
ffffffffc0206de4:	87a6                	mv	a5,s1
ffffffffc0206de6:	e79c                	sd	a5,8(a5)
ffffffffc0206de8:	e39c                	sd	a5,0(a5)
ffffffffc0206dea:	07c1                	addi	a5,a5,16
ffffffffc0206dec:	fef71de3          	bne	a4,a5,ffffffffc0206de6 <proc_init+0x28>
ffffffffc0206df0:	be5fe0ef          	jal	ra,ffffffffc02059d4 <alloc_proc>
ffffffffc0206df4:	00090917          	auipc	s2,0x90
ffffffffc0206df8:	ad490913          	addi	s2,s2,-1324 # ffffffffc02968c8 <idleproc>
ffffffffc0206dfc:	00a93023          	sd	a0,0(s2)
ffffffffc0206e00:	842a                	mv	s0,a0
ffffffffc0206e02:	12050863          	beqz	a0,ffffffffc0206f32 <proc_init+0x174>
ffffffffc0206e06:	4789                	li	a5,2
ffffffffc0206e08:	e11c                	sd	a5,0(a0)
ffffffffc0206e0a:	0000a797          	auipc	a5,0xa
ffffffffc0206e0e:	1f678793          	addi	a5,a5,502 # ffffffffc0211000 <bootstack>
ffffffffc0206e12:	e91c                	sd	a5,16(a0)
ffffffffc0206e14:	4785                	li	a5,1
ffffffffc0206e16:	ed1c                	sd	a5,24(a0)
ffffffffc0206e18:	bb6fe0ef          	jal	ra,ffffffffc02051ce <files_create>
ffffffffc0206e1c:	14a43423          	sd	a0,328(s0)
ffffffffc0206e20:	0e050d63          	beqz	a0,ffffffffc0206f1a <proc_init+0x15c>
ffffffffc0206e24:	00093403          	ld	s0,0(s2)
ffffffffc0206e28:	4641                	li	a2,16
ffffffffc0206e2a:	4581                	li	a1,0
ffffffffc0206e2c:	14843703          	ld	a4,328(s0)
ffffffffc0206e30:	0b440413          	addi	s0,s0,180
ffffffffc0206e34:	8522                	mv	a0,s0
ffffffffc0206e36:	4b1c                	lw	a5,16(a4)
ffffffffc0206e38:	2785                	addiw	a5,a5,1
ffffffffc0206e3a:	cb1c                	sw	a5,16(a4)
ffffffffc0206e3c:	5e8040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206e40:	463d                	li	a2,15
ffffffffc0206e42:	00007597          	auipc	a1,0x7
ffffffffc0206e46:	9a658593          	addi	a1,a1,-1626 # ffffffffc020d7e8 <CSWTCH.79+0x4d0>
ffffffffc0206e4a:	8522                	mv	a0,s0
ffffffffc0206e4c:	62a040ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0206e50:	00090717          	auipc	a4,0x90
ffffffffc0206e54:	a8870713          	addi	a4,a4,-1400 # ffffffffc02968d8 <nr_process>
ffffffffc0206e58:	431c                	lw	a5,0(a4)
ffffffffc0206e5a:	00093683          	ld	a3,0(s2)
ffffffffc0206e5e:	4601                	li	a2,0
ffffffffc0206e60:	2785                	addiw	a5,a5,1
ffffffffc0206e62:	4581                	li	a1,0
ffffffffc0206e64:	fffff517          	auipc	a0,0xfffff
ffffffffc0206e68:	52e50513          	addi	a0,a0,1326 # ffffffffc0206392 <init_main>
ffffffffc0206e6c:	c31c                	sw	a5,0(a4)
ffffffffc0206e6e:	00090797          	auipc	a5,0x90
ffffffffc0206e72:	a4d7b923          	sd	a3,-1454(a5) # ffffffffc02968c0 <current>
ffffffffc0206e76:	998ff0ef          	jal	ra,ffffffffc020600e <kernel_thread>
ffffffffc0206e7a:	842a                	mv	s0,a0
ffffffffc0206e7c:	08a05363          	blez	a0,ffffffffc0206f02 <proc_init+0x144>
ffffffffc0206e80:	6789                	lui	a5,0x2
ffffffffc0206e82:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206e86:	17f9                	addi	a5,a5,-2
ffffffffc0206e88:	2501                	sext.w	a0,a0
ffffffffc0206e8a:	02e7e363          	bltu	a5,a4,ffffffffc0206eb0 <proc_init+0xf2>
ffffffffc0206e8e:	45a9                	li	a1,10
ffffffffc0206e90:	060040ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc0206e94:	02051793          	slli	a5,a0,0x20
ffffffffc0206e98:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206e9c:	96a6                	add	a3,a3,s1
ffffffffc0206e9e:	87b6                	mv	a5,a3
ffffffffc0206ea0:	a029                	j	ffffffffc0206eaa <proc_init+0xec>
ffffffffc0206ea2:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc0206ea6:	04870b63          	beq	a4,s0,ffffffffc0206efc <proc_init+0x13e>
ffffffffc0206eaa:	679c                	ld	a5,8(a5)
ffffffffc0206eac:	fef69be3          	bne	a3,a5,ffffffffc0206ea2 <proc_init+0xe4>
ffffffffc0206eb0:	4781                	li	a5,0
ffffffffc0206eb2:	0b478493          	addi	s1,a5,180
ffffffffc0206eb6:	4641                	li	a2,16
ffffffffc0206eb8:	4581                	li	a1,0
ffffffffc0206eba:	00090417          	auipc	s0,0x90
ffffffffc0206ebe:	a1640413          	addi	s0,s0,-1514 # ffffffffc02968d0 <initproc>
ffffffffc0206ec2:	8526                	mv	a0,s1
ffffffffc0206ec4:	e01c                	sd	a5,0(s0)
ffffffffc0206ec6:	55e040ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0206eca:	463d                	li	a2,15
ffffffffc0206ecc:	00007597          	auipc	a1,0x7
ffffffffc0206ed0:	94458593          	addi	a1,a1,-1724 # ffffffffc020d810 <CSWTCH.79+0x4f8>
ffffffffc0206ed4:	8526                	mv	a0,s1
ffffffffc0206ed6:	5a0040ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc0206eda:	00093783          	ld	a5,0(s2)
ffffffffc0206ede:	c7d1                	beqz	a5,ffffffffc0206f6a <proc_init+0x1ac>
ffffffffc0206ee0:	43dc                	lw	a5,4(a5)
ffffffffc0206ee2:	e7c1                	bnez	a5,ffffffffc0206f6a <proc_init+0x1ac>
ffffffffc0206ee4:	601c                	ld	a5,0(s0)
ffffffffc0206ee6:	c3b5                	beqz	a5,ffffffffc0206f4a <proc_init+0x18c>
ffffffffc0206ee8:	43d8                	lw	a4,4(a5)
ffffffffc0206eea:	4785                	li	a5,1
ffffffffc0206eec:	04f71f63          	bne	a4,a5,ffffffffc0206f4a <proc_init+0x18c>
ffffffffc0206ef0:	60e2                	ld	ra,24(sp)
ffffffffc0206ef2:	6442                	ld	s0,16(sp)
ffffffffc0206ef4:	64a2                	ld	s1,8(sp)
ffffffffc0206ef6:	6902                	ld	s2,0(sp)
ffffffffc0206ef8:	6105                	addi	sp,sp,32
ffffffffc0206efa:	8082                	ret
ffffffffc0206efc:	f2878793          	addi	a5,a5,-216
ffffffffc0206f00:	bf4d                	j	ffffffffc0206eb2 <proc_init+0xf4>
ffffffffc0206f02:	00007617          	auipc	a2,0x7
ffffffffc0206f06:	8ee60613          	addi	a2,a2,-1810 # ffffffffc020d7f0 <CSWTCH.79+0x4d8>
ffffffffc0206f0a:	49500593          	li	a1,1173
ffffffffc0206f0e:	00006517          	auipc	a0,0x6
ffffffffc0206f12:	51250513          	addi	a0,a0,1298 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206f16:	d88f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f1a:	00007617          	auipc	a2,0x7
ffffffffc0206f1e:	8a660613          	addi	a2,a2,-1882 # ffffffffc020d7c0 <CSWTCH.79+0x4a8>
ffffffffc0206f22:	48900593          	li	a1,1161
ffffffffc0206f26:	00006517          	auipc	a0,0x6
ffffffffc0206f2a:	4fa50513          	addi	a0,a0,1274 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206f2e:	d70f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f32:	00007617          	auipc	a2,0x7
ffffffffc0206f36:	87660613          	addi	a2,a2,-1930 # ffffffffc020d7a8 <CSWTCH.79+0x490>
ffffffffc0206f3a:	47f00593          	li	a1,1151
ffffffffc0206f3e:	00006517          	auipc	a0,0x6
ffffffffc0206f42:	4e250513          	addi	a0,a0,1250 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206f46:	d58f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f4a:	00007697          	auipc	a3,0x7
ffffffffc0206f4e:	8f668693          	addi	a3,a3,-1802 # ffffffffc020d840 <CSWTCH.79+0x528>
ffffffffc0206f52:	00005617          	auipc	a2,0x5
ffffffffc0206f56:	9b660613          	addi	a2,a2,-1610 # ffffffffc020b908 <commands+0x210>
ffffffffc0206f5a:	49c00593          	li	a1,1180
ffffffffc0206f5e:	00006517          	auipc	a0,0x6
ffffffffc0206f62:	4c250513          	addi	a0,a0,1218 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206f66:	d38f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f6a:	00007697          	auipc	a3,0x7
ffffffffc0206f6e:	8ae68693          	addi	a3,a3,-1874 # ffffffffc020d818 <CSWTCH.79+0x500>
ffffffffc0206f72:	00005617          	auipc	a2,0x5
ffffffffc0206f76:	99660613          	addi	a2,a2,-1642 # ffffffffc020b908 <commands+0x210>
ffffffffc0206f7a:	49b00593          	li	a1,1179
ffffffffc0206f7e:	00006517          	auipc	a0,0x6
ffffffffc0206f82:	4a250513          	addi	a0,a0,1186 # ffffffffc020d420 <CSWTCH.79+0x108>
ffffffffc0206f86:	d18f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206f8a <cpu_idle>:
ffffffffc0206f8a:	1141                	addi	sp,sp,-16
ffffffffc0206f8c:	e022                	sd	s0,0(sp)
ffffffffc0206f8e:	e406                	sd	ra,8(sp)
ffffffffc0206f90:	00090417          	auipc	s0,0x90
ffffffffc0206f94:	93040413          	addi	s0,s0,-1744 # ffffffffc02968c0 <current>
ffffffffc0206f98:	6018                	ld	a4,0(s0)
ffffffffc0206f9a:	6f1c                	ld	a5,24(a4)
ffffffffc0206f9c:	dffd                	beqz	a5,ffffffffc0206f9a <cpu_idle+0x10>
ffffffffc0206f9e:	31a000ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc0206fa2:	bfdd                	j	ffffffffc0206f98 <cpu_idle+0xe>

ffffffffc0206fa4 <lab6_set_priority>:
ffffffffc0206fa4:	1141                	addi	sp,sp,-16
ffffffffc0206fa6:	e022                	sd	s0,0(sp)
ffffffffc0206fa8:	85aa                	mv	a1,a0
ffffffffc0206faa:	842a                	mv	s0,a0
ffffffffc0206fac:	00007517          	auipc	a0,0x7
ffffffffc0206fb0:	8bc50513          	addi	a0,a0,-1860 # ffffffffc020d868 <CSWTCH.79+0x550>
ffffffffc0206fb4:	e406                	sd	ra,8(sp)
ffffffffc0206fb6:	9f0f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206fba:	00090797          	auipc	a5,0x90
ffffffffc0206fbe:	9067b783          	ld	a5,-1786(a5) # ffffffffc02968c0 <current>
ffffffffc0206fc2:	e801                	bnez	s0,ffffffffc0206fd2 <lab6_set_priority+0x2e>
ffffffffc0206fc4:	60a2                	ld	ra,8(sp)
ffffffffc0206fc6:	6402                	ld	s0,0(sp)
ffffffffc0206fc8:	4705                	li	a4,1
ffffffffc0206fca:	14e7a223          	sw	a4,324(a5)
ffffffffc0206fce:	0141                	addi	sp,sp,16
ffffffffc0206fd0:	8082                	ret
ffffffffc0206fd2:	60a2                	ld	ra,8(sp)
ffffffffc0206fd4:	1487a223          	sw	s0,324(a5)
ffffffffc0206fd8:	6402                	ld	s0,0(sp)
ffffffffc0206fda:	0141                	addi	sp,sp,16
ffffffffc0206fdc:	8082                	ret

ffffffffc0206fde <do_sleep>:
ffffffffc0206fde:	c539                	beqz	a0,ffffffffc020702c <do_sleep+0x4e>
ffffffffc0206fe0:	7179                	addi	sp,sp,-48
ffffffffc0206fe2:	f022                	sd	s0,32(sp)
ffffffffc0206fe4:	f406                	sd	ra,40(sp)
ffffffffc0206fe6:	842a                	mv	s0,a0
ffffffffc0206fe8:	100027f3          	csrr	a5,sstatus
ffffffffc0206fec:	8b89                	andi	a5,a5,2
ffffffffc0206fee:	e3a9                	bnez	a5,ffffffffc0207030 <do_sleep+0x52>
ffffffffc0206ff0:	00090797          	auipc	a5,0x90
ffffffffc0206ff4:	8d07b783          	ld	a5,-1840(a5) # ffffffffc02968c0 <current>
ffffffffc0206ff8:	0818                	addi	a4,sp,16
ffffffffc0206ffa:	c02a                	sw	a0,0(sp)
ffffffffc0206ffc:	ec3a                	sd	a4,24(sp)
ffffffffc0206ffe:	e83a                	sd	a4,16(sp)
ffffffffc0207000:	e43e                	sd	a5,8(sp)
ffffffffc0207002:	4705                	li	a4,1
ffffffffc0207004:	c398                	sw	a4,0(a5)
ffffffffc0207006:	80000737          	lui	a4,0x80000
ffffffffc020700a:	840a                	mv	s0,sp
ffffffffc020700c:	0709                	addi	a4,a4,2
ffffffffc020700e:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207012:	8522                	mv	a0,s0
ffffffffc0207014:	364000ef          	jal	ra,ffffffffc0207378 <add_timer>
ffffffffc0207018:	2a0000ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc020701c:	8522                	mv	a0,s0
ffffffffc020701e:	422000ef          	jal	ra,ffffffffc0207440 <del_timer>
ffffffffc0207022:	70a2                	ld	ra,40(sp)
ffffffffc0207024:	7402                	ld	s0,32(sp)
ffffffffc0207026:	4501                	li	a0,0
ffffffffc0207028:	6145                	addi	sp,sp,48
ffffffffc020702a:	8082                	ret
ffffffffc020702c:	4501                	li	a0,0
ffffffffc020702e:	8082                	ret
ffffffffc0207030:	c43f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207034:	00090797          	auipc	a5,0x90
ffffffffc0207038:	88c7b783          	ld	a5,-1908(a5) # ffffffffc02968c0 <current>
ffffffffc020703c:	0818                	addi	a4,sp,16
ffffffffc020703e:	c022                	sw	s0,0(sp)
ffffffffc0207040:	e43e                	sd	a5,8(sp)
ffffffffc0207042:	ec3a                	sd	a4,24(sp)
ffffffffc0207044:	e83a                	sd	a4,16(sp)
ffffffffc0207046:	4705                	li	a4,1
ffffffffc0207048:	c398                	sw	a4,0(a5)
ffffffffc020704a:	80000737          	lui	a4,0x80000
ffffffffc020704e:	0709                	addi	a4,a4,2
ffffffffc0207050:	840a                	mv	s0,sp
ffffffffc0207052:	8522                	mv	a0,s0
ffffffffc0207054:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207058:	320000ef          	jal	ra,ffffffffc0207378 <add_timer>
ffffffffc020705c:	c11f90ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0207060:	bf65                	j	ffffffffc0207018 <do_sleep+0x3a>

ffffffffc0207062 <switch_to>:
ffffffffc0207062:	00153023          	sd	ra,0(a0)
ffffffffc0207066:	00253423          	sd	sp,8(a0)
ffffffffc020706a:	e900                	sd	s0,16(a0)
ffffffffc020706c:	ed04                	sd	s1,24(a0)
ffffffffc020706e:	03253023          	sd	s2,32(a0)
ffffffffc0207072:	03353423          	sd	s3,40(a0)
ffffffffc0207076:	03453823          	sd	s4,48(a0)
ffffffffc020707a:	03553c23          	sd	s5,56(a0)
ffffffffc020707e:	05653023          	sd	s6,64(a0)
ffffffffc0207082:	05753423          	sd	s7,72(a0)
ffffffffc0207086:	05853823          	sd	s8,80(a0)
ffffffffc020708a:	05953c23          	sd	s9,88(a0)
ffffffffc020708e:	07a53023          	sd	s10,96(a0)
ffffffffc0207092:	07b53423          	sd	s11,104(a0)
ffffffffc0207096:	0005b083          	ld	ra,0(a1)
ffffffffc020709a:	0085b103          	ld	sp,8(a1)
ffffffffc020709e:	6980                	ld	s0,16(a1)
ffffffffc02070a0:	6d84                	ld	s1,24(a1)
ffffffffc02070a2:	0205b903          	ld	s2,32(a1)
ffffffffc02070a6:	0285b983          	ld	s3,40(a1)
ffffffffc02070aa:	0305ba03          	ld	s4,48(a1)
ffffffffc02070ae:	0385ba83          	ld	s5,56(a1)
ffffffffc02070b2:	0405bb03          	ld	s6,64(a1)
ffffffffc02070b6:	0485bb83          	ld	s7,72(a1)
ffffffffc02070ba:	0505bc03          	ld	s8,80(a1)
ffffffffc02070be:	0585bc83          	ld	s9,88(a1)
ffffffffc02070c2:	0605bd03          	ld	s10,96(a1)
ffffffffc02070c6:	0685bd83          	ld	s11,104(a1)
ffffffffc02070ca:	8082                	ret

ffffffffc02070cc <RR_init>:
ffffffffc02070cc:	e508                	sd	a0,8(a0)
ffffffffc02070ce:	e108                	sd	a0,0(a0)
ffffffffc02070d0:	00052823          	sw	zero,16(a0)
ffffffffc02070d4:	8082                	ret

ffffffffc02070d6 <RR_pick_next>:
ffffffffc02070d6:	651c                	ld	a5,8(a0)
ffffffffc02070d8:	00f50563          	beq	a0,a5,ffffffffc02070e2 <RR_pick_next+0xc>
ffffffffc02070dc:	ef078513          	addi	a0,a5,-272
ffffffffc02070e0:	8082                	ret
ffffffffc02070e2:	4501                	li	a0,0
ffffffffc02070e4:	8082                	ret

ffffffffc02070e6 <RR_proc_tick>:
ffffffffc02070e6:	1205a783          	lw	a5,288(a1)
ffffffffc02070ea:	00f05563          	blez	a5,ffffffffc02070f4 <RR_proc_tick+0xe>
ffffffffc02070ee:	37fd                	addiw	a5,a5,-1
ffffffffc02070f0:	12f5a023          	sw	a5,288(a1)
ffffffffc02070f4:	e399                	bnez	a5,ffffffffc02070fa <RR_proc_tick+0x14>
ffffffffc02070f6:	4785                	li	a5,1
ffffffffc02070f8:	ed9c                	sd	a5,24(a1)
ffffffffc02070fa:	8082                	ret

ffffffffc02070fc <RR_dequeue>:
ffffffffc02070fc:	1185b703          	ld	a4,280(a1)
ffffffffc0207100:	11058793          	addi	a5,a1,272
ffffffffc0207104:	02e78363          	beq	a5,a4,ffffffffc020712a <RR_dequeue+0x2e>
ffffffffc0207108:	1085b683          	ld	a3,264(a1)
ffffffffc020710c:	00a69f63          	bne	a3,a0,ffffffffc020712a <RR_dequeue+0x2e>
ffffffffc0207110:	1105b503          	ld	a0,272(a1)
ffffffffc0207114:	4a90                	lw	a2,16(a3)
ffffffffc0207116:	e518                	sd	a4,8(a0)
ffffffffc0207118:	e308                	sd	a0,0(a4)
ffffffffc020711a:	10f5bc23          	sd	a5,280(a1)
ffffffffc020711e:	10f5b823          	sd	a5,272(a1)
ffffffffc0207122:	fff6079b          	addiw	a5,a2,-1
ffffffffc0207126:	ca9c                	sw	a5,16(a3)
ffffffffc0207128:	8082                	ret
ffffffffc020712a:	1141                	addi	sp,sp,-16
ffffffffc020712c:	00006697          	auipc	a3,0x6
ffffffffc0207130:	75468693          	addi	a3,a3,1876 # ffffffffc020d880 <CSWTCH.79+0x568>
ffffffffc0207134:	00004617          	auipc	a2,0x4
ffffffffc0207138:	7d460613          	addi	a2,a2,2004 # ffffffffc020b908 <commands+0x210>
ffffffffc020713c:	03c00593          	li	a1,60
ffffffffc0207140:	00006517          	auipc	a0,0x6
ffffffffc0207144:	77850513          	addi	a0,a0,1912 # ffffffffc020d8b8 <CSWTCH.79+0x5a0>
ffffffffc0207148:	e406                	sd	ra,8(sp)
ffffffffc020714a:	b54f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020714e <RR_enqueue>:
ffffffffc020714e:	1185b703          	ld	a4,280(a1)
ffffffffc0207152:	11058793          	addi	a5,a1,272
ffffffffc0207156:	02e79d63          	bne	a5,a4,ffffffffc0207190 <RR_enqueue+0x42>
ffffffffc020715a:	6118                	ld	a4,0(a0)
ffffffffc020715c:	1205a683          	lw	a3,288(a1)
ffffffffc0207160:	e11c                	sd	a5,0(a0)
ffffffffc0207162:	e71c                	sd	a5,8(a4)
ffffffffc0207164:	10a5bc23          	sd	a0,280(a1)
ffffffffc0207168:	10e5b823          	sd	a4,272(a1)
ffffffffc020716c:	495c                	lw	a5,20(a0)
ffffffffc020716e:	ea89                	bnez	a3,ffffffffc0207180 <RR_enqueue+0x32>
ffffffffc0207170:	12f5a023          	sw	a5,288(a1)
ffffffffc0207174:	491c                	lw	a5,16(a0)
ffffffffc0207176:	10a5b423          	sd	a0,264(a1)
ffffffffc020717a:	2785                	addiw	a5,a5,1
ffffffffc020717c:	c91c                	sw	a5,16(a0)
ffffffffc020717e:	8082                	ret
ffffffffc0207180:	fed7c8e3          	blt	a5,a3,ffffffffc0207170 <RR_enqueue+0x22>
ffffffffc0207184:	491c                	lw	a5,16(a0)
ffffffffc0207186:	10a5b423          	sd	a0,264(a1)
ffffffffc020718a:	2785                	addiw	a5,a5,1
ffffffffc020718c:	c91c                	sw	a5,16(a0)
ffffffffc020718e:	8082                	ret
ffffffffc0207190:	1141                	addi	sp,sp,-16
ffffffffc0207192:	00006697          	auipc	a3,0x6
ffffffffc0207196:	74668693          	addi	a3,a3,1862 # ffffffffc020d8d8 <CSWTCH.79+0x5c0>
ffffffffc020719a:	00004617          	auipc	a2,0x4
ffffffffc020719e:	76e60613          	addi	a2,a2,1902 # ffffffffc020b908 <commands+0x210>
ffffffffc02071a2:	02800593          	li	a1,40
ffffffffc02071a6:	00006517          	auipc	a0,0x6
ffffffffc02071aa:	71250513          	addi	a0,a0,1810 # ffffffffc020d8b8 <CSWTCH.79+0x5a0>
ffffffffc02071ae:	e406                	sd	ra,8(sp)
ffffffffc02071b0:	aeef90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02071b4 <sched_init>:
ffffffffc02071b4:	1141                	addi	sp,sp,-16
ffffffffc02071b6:	0008a717          	auipc	a4,0x8a
ffffffffc02071ba:	e6a70713          	addi	a4,a4,-406 # ffffffffc0291020 <default_sched_class>
ffffffffc02071be:	e022                	sd	s0,0(sp)
ffffffffc02071c0:	e406                	sd	ra,8(sp)
ffffffffc02071c2:	0008e797          	auipc	a5,0x8e
ffffffffc02071c6:	62e78793          	addi	a5,a5,1582 # ffffffffc02957f0 <timer_list>
ffffffffc02071ca:	6714                	ld	a3,8(a4)
ffffffffc02071cc:	0008e517          	auipc	a0,0x8e
ffffffffc02071d0:	60450513          	addi	a0,a0,1540 # ffffffffc02957d0 <__rq>
ffffffffc02071d4:	e79c                	sd	a5,8(a5)
ffffffffc02071d6:	e39c                	sd	a5,0(a5)
ffffffffc02071d8:	4795                	li	a5,5
ffffffffc02071da:	c95c                	sw	a5,20(a0)
ffffffffc02071dc:	0008f417          	auipc	s0,0x8f
ffffffffc02071e0:	70c40413          	addi	s0,s0,1804 # ffffffffc02968e8 <sched_class>
ffffffffc02071e4:	0008f797          	auipc	a5,0x8f
ffffffffc02071e8:	6ea7be23          	sd	a0,1788(a5) # ffffffffc02968e0 <rq>
ffffffffc02071ec:	e018                	sd	a4,0(s0)
ffffffffc02071ee:	9682                	jalr	a3
ffffffffc02071f0:	601c                	ld	a5,0(s0)
ffffffffc02071f2:	6402                	ld	s0,0(sp)
ffffffffc02071f4:	60a2                	ld	ra,8(sp)
ffffffffc02071f6:	638c                	ld	a1,0(a5)
ffffffffc02071f8:	00006517          	auipc	a0,0x6
ffffffffc02071fc:	71050513          	addi	a0,a0,1808 # ffffffffc020d908 <CSWTCH.79+0x5f0>
ffffffffc0207200:	0141                	addi	sp,sp,16
ffffffffc0207202:	fa5f806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0207206 <wakeup_proc>:
ffffffffc0207206:	4118                	lw	a4,0(a0)
ffffffffc0207208:	1101                	addi	sp,sp,-32
ffffffffc020720a:	ec06                	sd	ra,24(sp)
ffffffffc020720c:	e822                	sd	s0,16(sp)
ffffffffc020720e:	e426                	sd	s1,8(sp)
ffffffffc0207210:	478d                	li	a5,3
ffffffffc0207212:	08f70363          	beq	a4,a5,ffffffffc0207298 <wakeup_proc+0x92>
ffffffffc0207216:	842a                	mv	s0,a0
ffffffffc0207218:	100027f3          	csrr	a5,sstatus
ffffffffc020721c:	8b89                	andi	a5,a5,2
ffffffffc020721e:	4481                	li	s1,0
ffffffffc0207220:	e7bd                	bnez	a5,ffffffffc020728e <wakeup_proc+0x88>
ffffffffc0207222:	4789                	li	a5,2
ffffffffc0207224:	04f70863          	beq	a4,a5,ffffffffc0207274 <wakeup_proc+0x6e>
ffffffffc0207228:	c01c                	sw	a5,0(s0)
ffffffffc020722a:	0e042623          	sw	zero,236(s0)
ffffffffc020722e:	0008f797          	auipc	a5,0x8f
ffffffffc0207232:	6927b783          	ld	a5,1682(a5) # ffffffffc02968c0 <current>
ffffffffc0207236:	02878363          	beq	a5,s0,ffffffffc020725c <wakeup_proc+0x56>
ffffffffc020723a:	0008f797          	auipc	a5,0x8f
ffffffffc020723e:	68e7b783          	ld	a5,1678(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0207242:	00f40d63          	beq	s0,a5,ffffffffc020725c <wakeup_proc+0x56>
ffffffffc0207246:	0008f797          	auipc	a5,0x8f
ffffffffc020724a:	6a27b783          	ld	a5,1698(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020724e:	6b9c                	ld	a5,16(a5)
ffffffffc0207250:	85a2                	mv	a1,s0
ffffffffc0207252:	0008f517          	auipc	a0,0x8f
ffffffffc0207256:	68e53503          	ld	a0,1678(a0) # ffffffffc02968e0 <rq>
ffffffffc020725a:	9782                	jalr	a5
ffffffffc020725c:	e491                	bnez	s1,ffffffffc0207268 <wakeup_proc+0x62>
ffffffffc020725e:	60e2                	ld	ra,24(sp)
ffffffffc0207260:	6442                	ld	s0,16(sp)
ffffffffc0207262:	64a2                	ld	s1,8(sp)
ffffffffc0207264:	6105                	addi	sp,sp,32
ffffffffc0207266:	8082                	ret
ffffffffc0207268:	6442                	ld	s0,16(sp)
ffffffffc020726a:	60e2                	ld	ra,24(sp)
ffffffffc020726c:	64a2                	ld	s1,8(sp)
ffffffffc020726e:	6105                	addi	sp,sp,32
ffffffffc0207270:	9fdf906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0207274:	00006617          	auipc	a2,0x6
ffffffffc0207278:	6e460613          	addi	a2,a2,1764 # ffffffffc020d958 <CSWTCH.79+0x640>
ffffffffc020727c:	05200593          	li	a1,82
ffffffffc0207280:	00006517          	auipc	a0,0x6
ffffffffc0207284:	6c050513          	addi	a0,a0,1728 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc0207288:	a7ef90ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc020728c:	bfc1                	j	ffffffffc020725c <wakeup_proc+0x56>
ffffffffc020728e:	9e5f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207292:	4018                	lw	a4,0(s0)
ffffffffc0207294:	4485                	li	s1,1
ffffffffc0207296:	b771                	j	ffffffffc0207222 <wakeup_proc+0x1c>
ffffffffc0207298:	00006697          	auipc	a3,0x6
ffffffffc020729c:	68868693          	addi	a3,a3,1672 # ffffffffc020d920 <CSWTCH.79+0x608>
ffffffffc02072a0:	00004617          	auipc	a2,0x4
ffffffffc02072a4:	66860613          	addi	a2,a2,1640 # ffffffffc020b908 <commands+0x210>
ffffffffc02072a8:	04300593          	li	a1,67
ffffffffc02072ac:	00006517          	auipc	a0,0x6
ffffffffc02072b0:	69450513          	addi	a0,a0,1684 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc02072b4:	9eaf90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02072b8 <schedule>:
ffffffffc02072b8:	7179                	addi	sp,sp,-48
ffffffffc02072ba:	f406                	sd	ra,40(sp)
ffffffffc02072bc:	f022                	sd	s0,32(sp)
ffffffffc02072be:	ec26                	sd	s1,24(sp)
ffffffffc02072c0:	e84a                	sd	s2,16(sp)
ffffffffc02072c2:	e44e                	sd	s3,8(sp)
ffffffffc02072c4:	e052                	sd	s4,0(sp)
ffffffffc02072c6:	100027f3          	csrr	a5,sstatus
ffffffffc02072ca:	8b89                	andi	a5,a5,2
ffffffffc02072cc:	4a01                	li	s4,0
ffffffffc02072ce:	e3cd                	bnez	a5,ffffffffc0207370 <schedule+0xb8>
ffffffffc02072d0:	0008f497          	auipc	s1,0x8f
ffffffffc02072d4:	5f048493          	addi	s1,s1,1520 # ffffffffc02968c0 <current>
ffffffffc02072d8:	608c                	ld	a1,0(s1)
ffffffffc02072da:	0008f997          	auipc	s3,0x8f
ffffffffc02072de:	60e98993          	addi	s3,s3,1550 # ffffffffc02968e8 <sched_class>
ffffffffc02072e2:	0008f917          	auipc	s2,0x8f
ffffffffc02072e6:	5fe90913          	addi	s2,s2,1534 # ffffffffc02968e0 <rq>
ffffffffc02072ea:	4194                	lw	a3,0(a1)
ffffffffc02072ec:	0005bc23          	sd	zero,24(a1)
ffffffffc02072f0:	4709                	li	a4,2
ffffffffc02072f2:	0009b783          	ld	a5,0(s3)
ffffffffc02072f6:	00093503          	ld	a0,0(s2)
ffffffffc02072fa:	04e68e63          	beq	a3,a4,ffffffffc0207356 <schedule+0x9e>
ffffffffc02072fe:	739c                	ld	a5,32(a5)
ffffffffc0207300:	9782                	jalr	a5
ffffffffc0207302:	842a                	mv	s0,a0
ffffffffc0207304:	c521                	beqz	a0,ffffffffc020734c <schedule+0x94>
ffffffffc0207306:	0009b783          	ld	a5,0(s3)
ffffffffc020730a:	00093503          	ld	a0,0(s2)
ffffffffc020730e:	85a2                	mv	a1,s0
ffffffffc0207310:	6f9c                	ld	a5,24(a5)
ffffffffc0207312:	9782                	jalr	a5
ffffffffc0207314:	441c                	lw	a5,8(s0)
ffffffffc0207316:	6098                	ld	a4,0(s1)
ffffffffc0207318:	2785                	addiw	a5,a5,1
ffffffffc020731a:	c41c                	sw	a5,8(s0)
ffffffffc020731c:	00870563          	beq	a4,s0,ffffffffc0207326 <schedule+0x6e>
ffffffffc0207320:	8522                	mv	a0,s0
ffffffffc0207322:	853fe0ef          	jal	ra,ffffffffc0205b74 <proc_run>
ffffffffc0207326:	000a1a63          	bnez	s4,ffffffffc020733a <schedule+0x82>
ffffffffc020732a:	70a2                	ld	ra,40(sp)
ffffffffc020732c:	7402                	ld	s0,32(sp)
ffffffffc020732e:	64e2                	ld	s1,24(sp)
ffffffffc0207330:	6942                	ld	s2,16(sp)
ffffffffc0207332:	69a2                	ld	s3,8(sp)
ffffffffc0207334:	6a02                	ld	s4,0(sp)
ffffffffc0207336:	6145                	addi	sp,sp,48
ffffffffc0207338:	8082                	ret
ffffffffc020733a:	7402                	ld	s0,32(sp)
ffffffffc020733c:	70a2                	ld	ra,40(sp)
ffffffffc020733e:	64e2                	ld	s1,24(sp)
ffffffffc0207340:	6942                	ld	s2,16(sp)
ffffffffc0207342:	69a2                	ld	s3,8(sp)
ffffffffc0207344:	6a02                	ld	s4,0(sp)
ffffffffc0207346:	6145                	addi	sp,sp,48
ffffffffc0207348:	925f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020734c:	0008f417          	auipc	s0,0x8f
ffffffffc0207350:	57c43403          	ld	s0,1404(s0) # ffffffffc02968c8 <idleproc>
ffffffffc0207354:	b7c1                	j	ffffffffc0207314 <schedule+0x5c>
ffffffffc0207356:	0008f717          	auipc	a4,0x8f
ffffffffc020735a:	57273703          	ld	a4,1394(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020735e:	fae580e3          	beq	a1,a4,ffffffffc02072fe <schedule+0x46>
ffffffffc0207362:	6b9c                	ld	a5,16(a5)
ffffffffc0207364:	9782                	jalr	a5
ffffffffc0207366:	0009b783          	ld	a5,0(s3)
ffffffffc020736a:	00093503          	ld	a0,0(s2)
ffffffffc020736e:	bf41                	j	ffffffffc02072fe <schedule+0x46>
ffffffffc0207370:	903f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207374:	4a05                	li	s4,1
ffffffffc0207376:	bfa9                	j	ffffffffc02072d0 <schedule+0x18>

ffffffffc0207378 <add_timer>:
ffffffffc0207378:	1141                	addi	sp,sp,-16
ffffffffc020737a:	e022                	sd	s0,0(sp)
ffffffffc020737c:	e406                	sd	ra,8(sp)
ffffffffc020737e:	842a                	mv	s0,a0
ffffffffc0207380:	100027f3          	csrr	a5,sstatus
ffffffffc0207384:	8b89                	andi	a5,a5,2
ffffffffc0207386:	4501                	li	a0,0
ffffffffc0207388:	eba5                	bnez	a5,ffffffffc02073f8 <add_timer+0x80>
ffffffffc020738a:	401c                	lw	a5,0(s0)
ffffffffc020738c:	cbb5                	beqz	a5,ffffffffc0207400 <add_timer+0x88>
ffffffffc020738e:	6418                	ld	a4,8(s0)
ffffffffc0207390:	cb25                	beqz	a4,ffffffffc0207400 <add_timer+0x88>
ffffffffc0207392:	6c18                	ld	a4,24(s0)
ffffffffc0207394:	01040593          	addi	a1,s0,16
ffffffffc0207398:	08e59463          	bne	a1,a4,ffffffffc0207420 <add_timer+0xa8>
ffffffffc020739c:	0008e617          	auipc	a2,0x8e
ffffffffc02073a0:	45460613          	addi	a2,a2,1108 # ffffffffc02957f0 <timer_list>
ffffffffc02073a4:	6618                	ld	a4,8(a2)
ffffffffc02073a6:	00c71863          	bne	a4,a2,ffffffffc02073b6 <add_timer+0x3e>
ffffffffc02073aa:	a80d                	j	ffffffffc02073dc <add_timer+0x64>
ffffffffc02073ac:	6718                	ld	a4,8(a4)
ffffffffc02073ae:	9f95                	subw	a5,a5,a3
ffffffffc02073b0:	c01c                	sw	a5,0(s0)
ffffffffc02073b2:	02c70563          	beq	a4,a2,ffffffffc02073dc <add_timer+0x64>
ffffffffc02073b6:	ff072683          	lw	a3,-16(a4)
ffffffffc02073ba:	fed7f9e3          	bgeu	a5,a3,ffffffffc02073ac <add_timer+0x34>
ffffffffc02073be:	40f687bb          	subw	a5,a3,a5
ffffffffc02073c2:	fef72823          	sw	a5,-16(a4)
ffffffffc02073c6:	631c                	ld	a5,0(a4)
ffffffffc02073c8:	e30c                	sd	a1,0(a4)
ffffffffc02073ca:	e78c                	sd	a1,8(a5)
ffffffffc02073cc:	ec18                	sd	a4,24(s0)
ffffffffc02073ce:	e81c                	sd	a5,16(s0)
ffffffffc02073d0:	c105                	beqz	a0,ffffffffc02073f0 <add_timer+0x78>
ffffffffc02073d2:	6402                	ld	s0,0(sp)
ffffffffc02073d4:	60a2                	ld	ra,8(sp)
ffffffffc02073d6:	0141                	addi	sp,sp,16
ffffffffc02073d8:	895f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02073dc:	0008e717          	auipc	a4,0x8e
ffffffffc02073e0:	41470713          	addi	a4,a4,1044 # ffffffffc02957f0 <timer_list>
ffffffffc02073e4:	631c                	ld	a5,0(a4)
ffffffffc02073e6:	e30c                	sd	a1,0(a4)
ffffffffc02073e8:	e78c                	sd	a1,8(a5)
ffffffffc02073ea:	ec18                	sd	a4,24(s0)
ffffffffc02073ec:	e81c                	sd	a5,16(s0)
ffffffffc02073ee:	f175                	bnez	a0,ffffffffc02073d2 <add_timer+0x5a>
ffffffffc02073f0:	60a2                	ld	ra,8(sp)
ffffffffc02073f2:	6402                	ld	s0,0(sp)
ffffffffc02073f4:	0141                	addi	sp,sp,16
ffffffffc02073f6:	8082                	ret
ffffffffc02073f8:	87bf90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02073fc:	4505                	li	a0,1
ffffffffc02073fe:	b771                	j	ffffffffc020738a <add_timer+0x12>
ffffffffc0207400:	00006697          	auipc	a3,0x6
ffffffffc0207404:	57868693          	addi	a3,a3,1400 # ffffffffc020d978 <CSWTCH.79+0x660>
ffffffffc0207408:	00004617          	auipc	a2,0x4
ffffffffc020740c:	50060613          	addi	a2,a2,1280 # ffffffffc020b908 <commands+0x210>
ffffffffc0207410:	07a00593          	li	a1,122
ffffffffc0207414:	00006517          	auipc	a0,0x6
ffffffffc0207418:	52c50513          	addi	a0,a0,1324 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc020741c:	882f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207420:	00006697          	auipc	a3,0x6
ffffffffc0207424:	58868693          	addi	a3,a3,1416 # ffffffffc020d9a8 <CSWTCH.79+0x690>
ffffffffc0207428:	00004617          	auipc	a2,0x4
ffffffffc020742c:	4e060613          	addi	a2,a2,1248 # ffffffffc020b908 <commands+0x210>
ffffffffc0207430:	07b00593          	li	a1,123
ffffffffc0207434:	00006517          	auipc	a0,0x6
ffffffffc0207438:	50c50513          	addi	a0,a0,1292 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc020743c:	862f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207440 <del_timer>:
ffffffffc0207440:	1101                	addi	sp,sp,-32
ffffffffc0207442:	e822                	sd	s0,16(sp)
ffffffffc0207444:	ec06                	sd	ra,24(sp)
ffffffffc0207446:	e426                	sd	s1,8(sp)
ffffffffc0207448:	842a                	mv	s0,a0
ffffffffc020744a:	100027f3          	csrr	a5,sstatus
ffffffffc020744e:	8b89                	andi	a5,a5,2
ffffffffc0207450:	01050493          	addi	s1,a0,16
ffffffffc0207454:	eb9d                	bnez	a5,ffffffffc020748a <del_timer+0x4a>
ffffffffc0207456:	6d1c                	ld	a5,24(a0)
ffffffffc0207458:	02978463          	beq	a5,s1,ffffffffc0207480 <del_timer+0x40>
ffffffffc020745c:	4114                	lw	a3,0(a0)
ffffffffc020745e:	6918                	ld	a4,16(a0)
ffffffffc0207460:	ce81                	beqz	a3,ffffffffc0207478 <del_timer+0x38>
ffffffffc0207462:	0008e617          	auipc	a2,0x8e
ffffffffc0207466:	38e60613          	addi	a2,a2,910 # ffffffffc02957f0 <timer_list>
ffffffffc020746a:	00c78763          	beq	a5,a2,ffffffffc0207478 <del_timer+0x38>
ffffffffc020746e:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207472:	9eb1                	addw	a3,a3,a2
ffffffffc0207474:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207478:	e71c                	sd	a5,8(a4)
ffffffffc020747a:	e398                	sd	a4,0(a5)
ffffffffc020747c:	ec04                	sd	s1,24(s0)
ffffffffc020747e:	e804                	sd	s1,16(s0)
ffffffffc0207480:	60e2                	ld	ra,24(sp)
ffffffffc0207482:	6442                	ld	s0,16(sp)
ffffffffc0207484:	64a2                	ld	s1,8(sp)
ffffffffc0207486:	6105                	addi	sp,sp,32
ffffffffc0207488:	8082                	ret
ffffffffc020748a:	fe8f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020748e:	6c1c                	ld	a5,24(s0)
ffffffffc0207490:	02978463          	beq	a5,s1,ffffffffc02074b8 <del_timer+0x78>
ffffffffc0207494:	4014                	lw	a3,0(s0)
ffffffffc0207496:	6818                	ld	a4,16(s0)
ffffffffc0207498:	ce81                	beqz	a3,ffffffffc02074b0 <del_timer+0x70>
ffffffffc020749a:	0008e617          	auipc	a2,0x8e
ffffffffc020749e:	35660613          	addi	a2,a2,854 # ffffffffc02957f0 <timer_list>
ffffffffc02074a2:	00c78763          	beq	a5,a2,ffffffffc02074b0 <del_timer+0x70>
ffffffffc02074a6:	ff07a603          	lw	a2,-16(a5)
ffffffffc02074aa:	9eb1                	addw	a3,a3,a2
ffffffffc02074ac:	fed7a823          	sw	a3,-16(a5)
ffffffffc02074b0:	e71c                	sd	a5,8(a4)
ffffffffc02074b2:	e398                	sd	a4,0(a5)
ffffffffc02074b4:	ec04                	sd	s1,24(s0)
ffffffffc02074b6:	e804                	sd	s1,16(s0)
ffffffffc02074b8:	6442                	ld	s0,16(sp)
ffffffffc02074ba:	60e2                	ld	ra,24(sp)
ffffffffc02074bc:	64a2                	ld	s1,8(sp)
ffffffffc02074be:	6105                	addi	sp,sp,32
ffffffffc02074c0:	facf906f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc02074c4 <run_timer_list>:
ffffffffc02074c4:	7139                	addi	sp,sp,-64
ffffffffc02074c6:	fc06                	sd	ra,56(sp)
ffffffffc02074c8:	f822                	sd	s0,48(sp)
ffffffffc02074ca:	f426                	sd	s1,40(sp)
ffffffffc02074cc:	f04a                	sd	s2,32(sp)
ffffffffc02074ce:	ec4e                	sd	s3,24(sp)
ffffffffc02074d0:	e852                	sd	s4,16(sp)
ffffffffc02074d2:	e456                	sd	s5,8(sp)
ffffffffc02074d4:	e05a                	sd	s6,0(sp)
ffffffffc02074d6:	100027f3          	csrr	a5,sstatus
ffffffffc02074da:	8b89                	andi	a5,a5,2
ffffffffc02074dc:	4b01                	li	s6,0
ffffffffc02074de:	efe9                	bnez	a5,ffffffffc02075b8 <run_timer_list+0xf4>
ffffffffc02074e0:	0008e997          	auipc	s3,0x8e
ffffffffc02074e4:	31098993          	addi	s3,s3,784 # ffffffffc02957f0 <timer_list>
ffffffffc02074e8:	0089b403          	ld	s0,8(s3)
ffffffffc02074ec:	07340a63          	beq	s0,s3,ffffffffc0207560 <run_timer_list+0x9c>
ffffffffc02074f0:	ff042783          	lw	a5,-16(s0)
ffffffffc02074f4:	ff040913          	addi	s2,s0,-16
ffffffffc02074f8:	0e078763          	beqz	a5,ffffffffc02075e6 <run_timer_list+0x122>
ffffffffc02074fc:	fff7871b          	addiw	a4,a5,-1
ffffffffc0207500:	fee42823          	sw	a4,-16(s0)
ffffffffc0207504:	ef31                	bnez	a4,ffffffffc0207560 <run_timer_list+0x9c>
ffffffffc0207506:	00006a97          	auipc	s5,0x6
ffffffffc020750a:	50aa8a93          	addi	s5,s5,1290 # ffffffffc020da10 <CSWTCH.79+0x6f8>
ffffffffc020750e:	00006a17          	auipc	s4,0x6
ffffffffc0207512:	432a0a13          	addi	s4,s4,1074 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc0207516:	a005                	j	ffffffffc0207536 <run_timer_list+0x72>
ffffffffc0207518:	0a07d763          	bgez	a5,ffffffffc02075c6 <run_timer_list+0x102>
ffffffffc020751c:	8526                	mv	a0,s1
ffffffffc020751e:	ce9ff0ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc0207522:	854a                	mv	a0,s2
ffffffffc0207524:	f1dff0ef          	jal	ra,ffffffffc0207440 <del_timer>
ffffffffc0207528:	03340c63          	beq	s0,s3,ffffffffc0207560 <run_timer_list+0x9c>
ffffffffc020752c:	ff042783          	lw	a5,-16(s0)
ffffffffc0207530:	ff040913          	addi	s2,s0,-16
ffffffffc0207534:	e795                	bnez	a5,ffffffffc0207560 <run_timer_list+0x9c>
ffffffffc0207536:	00893483          	ld	s1,8(s2)
ffffffffc020753a:	6400                	ld	s0,8(s0)
ffffffffc020753c:	0ec4a783          	lw	a5,236(s1)
ffffffffc0207540:	ffe1                	bnez	a5,ffffffffc0207518 <run_timer_list+0x54>
ffffffffc0207542:	40d4                	lw	a3,4(s1)
ffffffffc0207544:	8656                	mv	a2,s5
ffffffffc0207546:	0ba00593          	li	a1,186
ffffffffc020754a:	8552                	mv	a0,s4
ffffffffc020754c:	fbbf80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc0207550:	8526                	mv	a0,s1
ffffffffc0207552:	cb5ff0ef          	jal	ra,ffffffffc0207206 <wakeup_proc>
ffffffffc0207556:	854a                	mv	a0,s2
ffffffffc0207558:	ee9ff0ef          	jal	ra,ffffffffc0207440 <del_timer>
ffffffffc020755c:	fd3418e3          	bne	s0,s3,ffffffffc020752c <run_timer_list+0x68>
ffffffffc0207560:	0008f597          	auipc	a1,0x8f
ffffffffc0207564:	3605b583          	ld	a1,864(a1) # ffffffffc02968c0 <current>
ffffffffc0207568:	c18d                	beqz	a1,ffffffffc020758a <run_timer_list+0xc6>
ffffffffc020756a:	0008f797          	auipc	a5,0x8f
ffffffffc020756e:	35e7b783          	ld	a5,862(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0207572:	04f58763          	beq	a1,a5,ffffffffc02075c0 <run_timer_list+0xfc>
ffffffffc0207576:	0008f797          	auipc	a5,0x8f
ffffffffc020757a:	3727b783          	ld	a5,882(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020757e:	779c                	ld	a5,40(a5)
ffffffffc0207580:	0008f517          	auipc	a0,0x8f
ffffffffc0207584:	36053503          	ld	a0,864(a0) # ffffffffc02968e0 <rq>
ffffffffc0207588:	9782                	jalr	a5
ffffffffc020758a:	000b1c63          	bnez	s6,ffffffffc02075a2 <run_timer_list+0xde>
ffffffffc020758e:	70e2                	ld	ra,56(sp)
ffffffffc0207590:	7442                	ld	s0,48(sp)
ffffffffc0207592:	74a2                	ld	s1,40(sp)
ffffffffc0207594:	7902                	ld	s2,32(sp)
ffffffffc0207596:	69e2                	ld	s3,24(sp)
ffffffffc0207598:	6a42                	ld	s4,16(sp)
ffffffffc020759a:	6aa2                	ld	s5,8(sp)
ffffffffc020759c:	6b02                	ld	s6,0(sp)
ffffffffc020759e:	6121                	addi	sp,sp,64
ffffffffc02075a0:	8082                	ret
ffffffffc02075a2:	7442                	ld	s0,48(sp)
ffffffffc02075a4:	70e2                	ld	ra,56(sp)
ffffffffc02075a6:	74a2                	ld	s1,40(sp)
ffffffffc02075a8:	7902                	ld	s2,32(sp)
ffffffffc02075aa:	69e2                	ld	s3,24(sp)
ffffffffc02075ac:	6a42                	ld	s4,16(sp)
ffffffffc02075ae:	6aa2                	ld	s5,8(sp)
ffffffffc02075b0:	6b02                	ld	s6,0(sp)
ffffffffc02075b2:	6121                	addi	sp,sp,64
ffffffffc02075b4:	eb8f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02075b8:	ebaf90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02075bc:	4b05                	li	s6,1
ffffffffc02075be:	b70d                	j	ffffffffc02074e0 <run_timer_list+0x1c>
ffffffffc02075c0:	4785                	li	a5,1
ffffffffc02075c2:	ed9c                	sd	a5,24(a1)
ffffffffc02075c4:	b7d9                	j	ffffffffc020758a <run_timer_list+0xc6>
ffffffffc02075c6:	00006697          	auipc	a3,0x6
ffffffffc02075ca:	42268693          	addi	a3,a3,1058 # ffffffffc020d9e8 <CSWTCH.79+0x6d0>
ffffffffc02075ce:	00004617          	auipc	a2,0x4
ffffffffc02075d2:	33a60613          	addi	a2,a2,826 # ffffffffc020b908 <commands+0x210>
ffffffffc02075d6:	0b600593          	li	a1,182
ffffffffc02075da:	00006517          	auipc	a0,0x6
ffffffffc02075de:	36650513          	addi	a0,a0,870 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc02075e2:	ebdf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02075e6:	00006697          	auipc	a3,0x6
ffffffffc02075ea:	3ea68693          	addi	a3,a3,1002 # ffffffffc020d9d0 <CSWTCH.79+0x6b8>
ffffffffc02075ee:	00004617          	auipc	a2,0x4
ffffffffc02075f2:	31a60613          	addi	a2,a2,794 # ffffffffc020b908 <commands+0x210>
ffffffffc02075f6:	0ae00593          	li	a1,174
ffffffffc02075fa:	00006517          	auipc	a0,0x6
ffffffffc02075fe:	34650513          	addi	a0,a0,838 # ffffffffc020d940 <CSWTCH.79+0x628>
ffffffffc0207602:	e9df80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207606 <sys_getpid>:
ffffffffc0207606:	0008f797          	auipc	a5,0x8f
ffffffffc020760a:	2ba7b783          	ld	a5,698(a5) # ffffffffc02968c0 <current>
ffffffffc020760e:	43c8                	lw	a0,4(a5)
ffffffffc0207610:	8082                	ret

ffffffffc0207612 <sys_pgdir>:
ffffffffc0207612:	4501                	li	a0,0
ffffffffc0207614:	8082                	ret

ffffffffc0207616 <sys_gettime>:
ffffffffc0207616:	0008f797          	auipc	a5,0x8f
ffffffffc020761a:	25a7b783          	ld	a5,602(a5) # ffffffffc0296870 <ticks>
ffffffffc020761e:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207622:	9d3d                	addw	a0,a0,a5
ffffffffc0207624:	0015151b          	slliw	a0,a0,0x1
ffffffffc0207628:	8082                	ret

ffffffffc020762a <sys_lab6_set_priority>:
ffffffffc020762a:	4108                	lw	a0,0(a0)
ffffffffc020762c:	1141                	addi	sp,sp,-16
ffffffffc020762e:	e406                	sd	ra,8(sp)
ffffffffc0207630:	975ff0ef          	jal	ra,ffffffffc0206fa4 <lab6_set_priority>
ffffffffc0207634:	60a2                	ld	ra,8(sp)
ffffffffc0207636:	4501                	li	a0,0
ffffffffc0207638:	0141                	addi	sp,sp,16
ffffffffc020763a:	8082                	ret

ffffffffc020763c <sys_dup>:
ffffffffc020763c:	450c                	lw	a1,8(a0)
ffffffffc020763e:	4108                	lw	a0,0(a0)
ffffffffc0207640:	b88fe06f          	j	ffffffffc02059c8 <sysfile_dup>

ffffffffc0207644 <sys_getdirentry>:
ffffffffc0207644:	650c                	ld	a1,8(a0)
ffffffffc0207646:	4108                	lw	a0,0(a0)
ffffffffc0207648:	a90fe06f          	j	ffffffffc02058d8 <sysfile_getdirentry>

ffffffffc020764c <sys_getcwd>:
ffffffffc020764c:	650c                	ld	a1,8(a0)
ffffffffc020764e:	6108                	ld	a0,0(a0)
ffffffffc0207650:	9e4fe06f          	j	ffffffffc0205834 <sysfile_getcwd>

ffffffffc0207654 <sys_fsync>:
ffffffffc0207654:	4108                	lw	a0,0(a0)
ffffffffc0207656:	9dafe06f          	j	ffffffffc0205830 <sysfile_fsync>

ffffffffc020765a <sys_fstat>:
ffffffffc020765a:	650c                	ld	a1,8(a0)
ffffffffc020765c:	4108                	lw	a0,0(a0)
ffffffffc020765e:	932fe06f          	j	ffffffffc0205790 <sysfile_fstat>

ffffffffc0207662 <sys_seek>:
ffffffffc0207662:	4910                	lw	a2,16(a0)
ffffffffc0207664:	650c                	ld	a1,8(a0)
ffffffffc0207666:	4108                	lw	a0,0(a0)
ffffffffc0207668:	924fe06f          	j	ffffffffc020578c <sysfile_seek>

ffffffffc020766c <sys_write>:
ffffffffc020766c:	6910                	ld	a2,16(a0)
ffffffffc020766e:	650c                	ld	a1,8(a0)
ffffffffc0207670:	4108                	lw	a0,0(a0)
ffffffffc0207672:	800fe06f          	j	ffffffffc0205672 <sysfile_write>

ffffffffc0207676 <sys_read>:
ffffffffc0207676:	6910                	ld	a2,16(a0)
ffffffffc0207678:	650c                	ld	a1,8(a0)
ffffffffc020767a:	4108                	lw	a0,0(a0)
ffffffffc020767c:	ee3fd06f          	j	ffffffffc020555e <sysfile_read>

ffffffffc0207680 <sys_close>:
ffffffffc0207680:	4108                	lw	a0,0(a0)
ffffffffc0207682:	ed9fd06f          	j	ffffffffc020555a <sysfile_close>

ffffffffc0207686 <sys_open>:
ffffffffc0207686:	450c                	lw	a1,8(a0)
ffffffffc0207688:	6108                	ld	a0,0(a0)
ffffffffc020768a:	e9dfd06f          	j	ffffffffc0205526 <sysfile_open>

ffffffffc020768e <sys_putc>:
ffffffffc020768e:	4108                	lw	a0,0(a0)
ffffffffc0207690:	1141                	addi	sp,sp,-16
ffffffffc0207692:	e406                	sd	ra,8(sp)
ffffffffc0207694:	b4ff80ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0207698:	60a2                	ld	ra,8(sp)
ffffffffc020769a:	4501                	li	a0,0
ffffffffc020769c:	0141                	addi	sp,sp,16
ffffffffc020769e:	8082                	ret

ffffffffc02076a0 <sys_kill>:
ffffffffc02076a0:	4108                	lw	a0,0(a0)
ffffffffc02076a2:	ea0ff06f          	j	ffffffffc0206d42 <do_kill>

ffffffffc02076a6 <sys_sleep>:
ffffffffc02076a6:	4108                	lw	a0,0(a0)
ffffffffc02076a8:	937ff06f          	j	ffffffffc0206fde <do_sleep>

ffffffffc02076ac <sys_yield>:
ffffffffc02076ac:	e48ff06f          	j	ffffffffc0206cf4 <do_yield>

ffffffffc02076b0 <sys_exec>:
ffffffffc02076b0:	6910                	ld	a2,16(a0)
ffffffffc02076b2:	450c                	lw	a1,8(a0)
ffffffffc02076b4:	6108                	ld	a0,0(a0)
ffffffffc02076b6:	e2dfe06f          	j	ffffffffc02064e2 <do_execve>

ffffffffc02076ba <sys_wait>:
ffffffffc02076ba:	650c                	ld	a1,8(a0)
ffffffffc02076bc:	4108                	lw	a0,0(a0)
ffffffffc02076be:	e46ff06f          	j	ffffffffc0206d04 <do_wait>

ffffffffc02076c2 <sys_fork>:
ffffffffc02076c2:	0008f797          	auipc	a5,0x8f
ffffffffc02076c6:	1fe7b783          	ld	a5,510(a5) # ffffffffc02968c0 <current>
ffffffffc02076ca:	73d0                	ld	a2,160(a5)
ffffffffc02076cc:	4501                	li	a0,0
ffffffffc02076ce:	6a0c                	ld	a1,16(a2)
ffffffffc02076d0:	d1cfe06f          	j	ffffffffc0205bec <do_fork>

ffffffffc02076d4 <sys_exit>:
ffffffffc02076d4:	4108                	lw	a0,0(a0)
ffffffffc02076d6:	989fe06f          	j	ffffffffc020605e <do_exit>

ffffffffc02076da <syscall>:
ffffffffc02076da:	715d                	addi	sp,sp,-80
ffffffffc02076dc:	fc26                	sd	s1,56(sp)
ffffffffc02076de:	0008f497          	auipc	s1,0x8f
ffffffffc02076e2:	1e248493          	addi	s1,s1,482 # ffffffffc02968c0 <current>
ffffffffc02076e6:	6098                	ld	a4,0(s1)
ffffffffc02076e8:	e0a2                	sd	s0,64(sp)
ffffffffc02076ea:	f84a                	sd	s2,48(sp)
ffffffffc02076ec:	7340                	ld	s0,160(a4)
ffffffffc02076ee:	e486                	sd	ra,72(sp)
ffffffffc02076f0:	0ff00793          	li	a5,255
ffffffffc02076f4:	05042903          	lw	s2,80(s0)
ffffffffc02076f8:	0327ee63          	bltu	a5,s2,ffffffffc0207734 <syscall+0x5a>
ffffffffc02076fc:	00391713          	slli	a4,s2,0x3
ffffffffc0207700:	00006797          	auipc	a5,0x6
ffffffffc0207704:	37878793          	addi	a5,a5,888 # ffffffffc020da78 <syscalls>
ffffffffc0207708:	97ba                	add	a5,a5,a4
ffffffffc020770a:	639c                	ld	a5,0(a5)
ffffffffc020770c:	c785                	beqz	a5,ffffffffc0207734 <syscall+0x5a>
ffffffffc020770e:	6c28                	ld	a0,88(s0)
ffffffffc0207710:	702c                	ld	a1,96(s0)
ffffffffc0207712:	7430                	ld	a2,104(s0)
ffffffffc0207714:	7834                	ld	a3,112(s0)
ffffffffc0207716:	7c38                	ld	a4,120(s0)
ffffffffc0207718:	e42a                	sd	a0,8(sp)
ffffffffc020771a:	e82e                	sd	a1,16(sp)
ffffffffc020771c:	ec32                	sd	a2,24(sp)
ffffffffc020771e:	f036                	sd	a3,32(sp)
ffffffffc0207720:	f43a                	sd	a4,40(sp)
ffffffffc0207722:	0028                	addi	a0,sp,8
ffffffffc0207724:	9782                	jalr	a5
ffffffffc0207726:	60a6                	ld	ra,72(sp)
ffffffffc0207728:	e828                	sd	a0,80(s0)
ffffffffc020772a:	6406                	ld	s0,64(sp)
ffffffffc020772c:	74e2                	ld	s1,56(sp)
ffffffffc020772e:	7942                	ld	s2,48(sp)
ffffffffc0207730:	6161                	addi	sp,sp,80
ffffffffc0207732:	8082                	ret
ffffffffc0207734:	8522                	mv	a0,s0
ffffffffc0207736:	855f90ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc020773a:	609c                	ld	a5,0(s1)
ffffffffc020773c:	86ca                	mv	a3,s2
ffffffffc020773e:	00006617          	auipc	a2,0x6
ffffffffc0207742:	2f260613          	addi	a2,a2,754 # ffffffffc020da30 <CSWTCH.79+0x718>
ffffffffc0207746:	43d8                	lw	a4,4(a5)
ffffffffc0207748:	0d800593          	li	a1,216
ffffffffc020774c:	0b478793          	addi	a5,a5,180
ffffffffc0207750:	00006517          	auipc	a0,0x6
ffffffffc0207754:	31050513          	addi	a0,a0,784 # ffffffffc020da60 <CSWTCH.79+0x748>
ffffffffc0207758:	d47f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020775c <__alloc_inode>:
ffffffffc020775c:	1141                	addi	sp,sp,-16
ffffffffc020775e:	e022                	sd	s0,0(sp)
ffffffffc0207760:	842a                	mv	s0,a0
ffffffffc0207762:	07800513          	li	a0,120
ffffffffc0207766:	e406                	sd	ra,8(sp)
ffffffffc0207768:	827fa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020776c:	c111                	beqz	a0,ffffffffc0207770 <__alloc_inode+0x14>
ffffffffc020776e:	cd20                	sw	s0,88(a0)
ffffffffc0207770:	60a2                	ld	ra,8(sp)
ffffffffc0207772:	6402                	ld	s0,0(sp)
ffffffffc0207774:	0141                	addi	sp,sp,16
ffffffffc0207776:	8082                	ret

ffffffffc0207778 <inode_init>:
ffffffffc0207778:	4785                	li	a5,1
ffffffffc020777a:	06052023          	sw	zero,96(a0)
ffffffffc020777e:	f92c                	sd	a1,112(a0)
ffffffffc0207780:	f530                	sd	a2,104(a0)
ffffffffc0207782:	cd7c                	sw	a5,92(a0)
ffffffffc0207784:	8082                	ret

ffffffffc0207786 <inode_kill>:
ffffffffc0207786:	4d78                	lw	a4,92(a0)
ffffffffc0207788:	1141                	addi	sp,sp,-16
ffffffffc020778a:	e406                	sd	ra,8(sp)
ffffffffc020778c:	e719                	bnez	a4,ffffffffc020779a <inode_kill+0x14>
ffffffffc020778e:	513c                	lw	a5,96(a0)
ffffffffc0207790:	e78d                	bnez	a5,ffffffffc02077ba <inode_kill+0x34>
ffffffffc0207792:	60a2                	ld	ra,8(sp)
ffffffffc0207794:	0141                	addi	sp,sp,16
ffffffffc0207796:	8a9fa06f          	j	ffffffffc020203e <kfree>
ffffffffc020779a:	00007697          	auipc	a3,0x7
ffffffffc020779e:	ade68693          	addi	a3,a3,-1314 # ffffffffc020e278 <syscalls+0x800>
ffffffffc02077a2:	00004617          	auipc	a2,0x4
ffffffffc02077a6:	16660613          	addi	a2,a2,358 # ffffffffc020b908 <commands+0x210>
ffffffffc02077aa:	02900593          	li	a1,41
ffffffffc02077ae:	00007517          	auipc	a0,0x7
ffffffffc02077b2:	aea50513          	addi	a0,a0,-1302 # ffffffffc020e298 <syscalls+0x820>
ffffffffc02077b6:	ce9f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02077ba:	00007697          	auipc	a3,0x7
ffffffffc02077be:	af668693          	addi	a3,a3,-1290 # ffffffffc020e2b0 <syscalls+0x838>
ffffffffc02077c2:	00004617          	auipc	a2,0x4
ffffffffc02077c6:	14660613          	addi	a2,a2,326 # ffffffffc020b908 <commands+0x210>
ffffffffc02077ca:	02a00593          	li	a1,42
ffffffffc02077ce:	00007517          	auipc	a0,0x7
ffffffffc02077d2:	aca50513          	addi	a0,a0,-1334 # ffffffffc020e298 <syscalls+0x820>
ffffffffc02077d6:	cc9f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02077da <inode_ref_inc>:
ffffffffc02077da:	4d7c                	lw	a5,92(a0)
ffffffffc02077dc:	2785                	addiw	a5,a5,1
ffffffffc02077de:	cd7c                	sw	a5,92(a0)
ffffffffc02077e0:	0007851b          	sext.w	a0,a5
ffffffffc02077e4:	8082                	ret

ffffffffc02077e6 <inode_open_inc>:
ffffffffc02077e6:	513c                	lw	a5,96(a0)
ffffffffc02077e8:	2785                	addiw	a5,a5,1
ffffffffc02077ea:	d13c                	sw	a5,96(a0)
ffffffffc02077ec:	0007851b          	sext.w	a0,a5
ffffffffc02077f0:	8082                	ret

ffffffffc02077f2 <inode_check>:
ffffffffc02077f2:	1141                	addi	sp,sp,-16
ffffffffc02077f4:	e406                	sd	ra,8(sp)
ffffffffc02077f6:	c90d                	beqz	a0,ffffffffc0207828 <inode_check+0x36>
ffffffffc02077f8:	793c                	ld	a5,112(a0)
ffffffffc02077fa:	c79d                	beqz	a5,ffffffffc0207828 <inode_check+0x36>
ffffffffc02077fc:	6398                	ld	a4,0(a5)
ffffffffc02077fe:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207802:	0786                	slli	a5,a5,0x1
ffffffffc0207804:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207808:	08f71063          	bne	a4,a5,ffffffffc0207888 <inode_check+0x96>
ffffffffc020780c:	4d78                	lw	a4,92(a0)
ffffffffc020780e:	513c                	lw	a5,96(a0)
ffffffffc0207810:	04f74c63          	blt	a4,a5,ffffffffc0207868 <inode_check+0x76>
ffffffffc0207814:	0407ca63          	bltz	a5,ffffffffc0207868 <inode_check+0x76>
ffffffffc0207818:	66c1                	lui	a3,0x10
ffffffffc020781a:	02d75763          	bge	a4,a3,ffffffffc0207848 <inode_check+0x56>
ffffffffc020781e:	02d7d563          	bge	a5,a3,ffffffffc0207848 <inode_check+0x56>
ffffffffc0207822:	60a2                	ld	ra,8(sp)
ffffffffc0207824:	0141                	addi	sp,sp,16
ffffffffc0207826:	8082                	ret
ffffffffc0207828:	00007697          	auipc	a3,0x7
ffffffffc020782c:	aa868693          	addi	a3,a3,-1368 # ffffffffc020e2d0 <syscalls+0x858>
ffffffffc0207830:	00004617          	auipc	a2,0x4
ffffffffc0207834:	0d860613          	addi	a2,a2,216 # ffffffffc020b908 <commands+0x210>
ffffffffc0207838:	06e00593          	li	a1,110
ffffffffc020783c:	00007517          	auipc	a0,0x7
ffffffffc0207840:	a5c50513          	addi	a0,a0,-1444 # ffffffffc020e298 <syscalls+0x820>
ffffffffc0207844:	c5bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207848:	00007697          	auipc	a3,0x7
ffffffffc020784c:	b0868693          	addi	a3,a3,-1272 # ffffffffc020e350 <syscalls+0x8d8>
ffffffffc0207850:	00004617          	auipc	a2,0x4
ffffffffc0207854:	0b860613          	addi	a2,a2,184 # ffffffffc020b908 <commands+0x210>
ffffffffc0207858:	07200593          	li	a1,114
ffffffffc020785c:	00007517          	auipc	a0,0x7
ffffffffc0207860:	a3c50513          	addi	a0,a0,-1476 # ffffffffc020e298 <syscalls+0x820>
ffffffffc0207864:	c3bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207868:	00007697          	auipc	a3,0x7
ffffffffc020786c:	ab868693          	addi	a3,a3,-1352 # ffffffffc020e320 <syscalls+0x8a8>
ffffffffc0207870:	00004617          	auipc	a2,0x4
ffffffffc0207874:	09860613          	addi	a2,a2,152 # ffffffffc020b908 <commands+0x210>
ffffffffc0207878:	07100593          	li	a1,113
ffffffffc020787c:	00007517          	auipc	a0,0x7
ffffffffc0207880:	a1c50513          	addi	a0,a0,-1508 # ffffffffc020e298 <syscalls+0x820>
ffffffffc0207884:	c1bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207888:	00007697          	auipc	a3,0x7
ffffffffc020788c:	a7068693          	addi	a3,a3,-1424 # ffffffffc020e2f8 <syscalls+0x880>
ffffffffc0207890:	00004617          	auipc	a2,0x4
ffffffffc0207894:	07860613          	addi	a2,a2,120 # ffffffffc020b908 <commands+0x210>
ffffffffc0207898:	06f00593          	li	a1,111
ffffffffc020789c:	00007517          	auipc	a0,0x7
ffffffffc02078a0:	9fc50513          	addi	a0,a0,-1540 # ffffffffc020e298 <syscalls+0x820>
ffffffffc02078a4:	bfbf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02078a8 <inode_ref_dec>:
ffffffffc02078a8:	4d7c                	lw	a5,92(a0)
ffffffffc02078aa:	1101                	addi	sp,sp,-32
ffffffffc02078ac:	ec06                	sd	ra,24(sp)
ffffffffc02078ae:	e822                	sd	s0,16(sp)
ffffffffc02078b0:	e426                	sd	s1,8(sp)
ffffffffc02078b2:	e04a                	sd	s2,0(sp)
ffffffffc02078b4:	06f05e63          	blez	a5,ffffffffc0207930 <inode_ref_dec+0x88>
ffffffffc02078b8:	fff7849b          	addiw	s1,a5,-1
ffffffffc02078bc:	cd64                	sw	s1,92(a0)
ffffffffc02078be:	842a                	mv	s0,a0
ffffffffc02078c0:	e09d                	bnez	s1,ffffffffc02078e6 <inode_ref_dec+0x3e>
ffffffffc02078c2:	793c                	ld	a5,112(a0)
ffffffffc02078c4:	c7b1                	beqz	a5,ffffffffc0207910 <inode_ref_dec+0x68>
ffffffffc02078c6:	0487b903          	ld	s2,72(a5)
ffffffffc02078ca:	04090363          	beqz	s2,ffffffffc0207910 <inode_ref_dec+0x68>
ffffffffc02078ce:	00007597          	auipc	a1,0x7
ffffffffc02078d2:	b3258593          	addi	a1,a1,-1230 # ffffffffc020e400 <syscalls+0x988>
ffffffffc02078d6:	f1dff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02078da:	8522                	mv	a0,s0
ffffffffc02078dc:	9902                	jalr	s2
ffffffffc02078de:	c501                	beqz	a0,ffffffffc02078e6 <inode_ref_dec+0x3e>
ffffffffc02078e0:	57c5                	li	a5,-15
ffffffffc02078e2:	00f51963          	bne	a0,a5,ffffffffc02078f4 <inode_ref_dec+0x4c>
ffffffffc02078e6:	60e2                	ld	ra,24(sp)
ffffffffc02078e8:	6442                	ld	s0,16(sp)
ffffffffc02078ea:	6902                	ld	s2,0(sp)
ffffffffc02078ec:	8526                	mv	a0,s1
ffffffffc02078ee:	64a2                	ld	s1,8(sp)
ffffffffc02078f0:	6105                	addi	sp,sp,32
ffffffffc02078f2:	8082                	ret
ffffffffc02078f4:	85aa                	mv	a1,a0
ffffffffc02078f6:	00007517          	auipc	a0,0x7
ffffffffc02078fa:	b1250513          	addi	a0,a0,-1262 # ffffffffc020e408 <syscalls+0x990>
ffffffffc02078fe:	8a9f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207902:	60e2                	ld	ra,24(sp)
ffffffffc0207904:	6442                	ld	s0,16(sp)
ffffffffc0207906:	6902                	ld	s2,0(sp)
ffffffffc0207908:	8526                	mv	a0,s1
ffffffffc020790a:	64a2                	ld	s1,8(sp)
ffffffffc020790c:	6105                	addi	sp,sp,32
ffffffffc020790e:	8082                	ret
ffffffffc0207910:	00007697          	auipc	a3,0x7
ffffffffc0207914:	aa068693          	addi	a3,a3,-1376 # ffffffffc020e3b0 <syscalls+0x938>
ffffffffc0207918:	00004617          	auipc	a2,0x4
ffffffffc020791c:	ff060613          	addi	a2,a2,-16 # ffffffffc020b908 <commands+0x210>
ffffffffc0207920:	04400593          	li	a1,68
ffffffffc0207924:	00007517          	auipc	a0,0x7
ffffffffc0207928:	97450513          	addi	a0,a0,-1676 # ffffffffc020e298 <syscalls+0x820>
ffffffffc020792c:	b73f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207930:	00007697          	auipc	a3,0x7
ffffffffc0207934:	a6068693          	addi	a3,a3,-1440 # ffffffffc020e390 <syscalls+0x918>
ffffffffc0207938:	00004617          	auipc	a2,0x4
ffffffffc020793c:	fd060613          	addi	a2,a2,-48 # ffffffffc020b908 <commands+0x210>
ffffffffc0207940:	03f00593          	li	a1,63
ffffffffc0207944:	00007517          	auipc	a0,0x7
ffffffffc0207948:	95450513          	addi	a0,a0,-1708 # ffffffffc020e298 <syscalls+0x820>
ffffffffc020794c:	b53f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207950 <inode_open_dec>:
ffffffffc0207950:	513c                	lw	a5,96(a0)
ffffffffc0207952:	1101                	addi	sp,sp,-32
ffffffffc0207954:	ec06                	sd	ra,24(sp)
ffffffffc0207956:	e822                	sd	s0,16(sp)
ffffffffc0207958:	e426                	sd	s1,8(sp)
ffffffffc020795a:	e04a                	sd	s2,0(sp)
ffffffffc020795c:	06f05b63          	blez	a5,ffffffffc02079d2 <inode_open_dec+0x82>
ffffffffc0207960:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207964:	d124                	sw	s1,96(a0)
ffffffffc0207966:	842a                	mv	s0,a0
ffffffffc0207968:	e085                	bnez	s1,ffffffffc0207988 <inode_open_dec+0x38>
ffffffffc020796a:	793c                	ld	a5,112(a0)
ffffffffc020796c:	c3b9                	beqz	a5,ffffffffc02079b2 <inode_open_dec+0x62>
ffffffffc020796e:	0107b903          	ld	s2,16(a5)
ffffffffc0207972:	04090063          	beqz	s2,ffffffffc02079b2 <inode_open_dec+0x62>
ffffffffc0207976:	00007597          	auipc	a1,0x7
ffffffffc020797a:	b2258593          	addi	a1,a1,-1246 # ffffffffc020e498 <syscalls+0xa20>
ffffffffc020797e:	e75ff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0207982:	8522                	mv	a0,s0
ffffffffc0207984:	9902                	jalr	s2
ffffffffc0207986:	e901                	bnez	a0,ffffffffc0207996 <inode_open_dec+0x46>
ffffffffc0207988:	60e2                	ld	ra,24(sp)
ffffffffc020798a:	6442                	ld	s0,16(sp)
ffffffffc020798c:	6902                	ld	s2,0(sp)
ffffffffc020798e:	8526                	mv	a0,s1
ffffffffc0207990:	64a2                	ld	s1,8(sp)
ffffffffc0207992:	6105                	addi	sp,sp,32
ffffffffc0207994:	8082                	ret
ffffffffc0207996:	85aa                	mv	a1,a0
ffffffffc0207998:	00007517          	auipc	a0,0x7
ffffffffc020799c:	b0850513          	addi	a0,a0,-1272 # ffffffffc020e4a0 <syscalls+0xa28>
ffffffffc02079a0:	807f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02079a4:	60e2                	ld	ra,24(sp)
ffffffffc02079a6:	6442                	ld	s0,16(sp)
ffffffffc02079a8:	6902                	ld	s2,0(sp)
ffffffffc02079aa:	8526                	mv	a0,s1
ffffffffc02079ac:	64a2                	ld	s1,8(sp)
ffffffffc02079ae:	6105                	addi	sp,sp,32
ffffffffc02079b0:	8082                	ret
ffffffffc02079b2:	00007697          	auipc	a3,0x7
ffffffffc02079b6:	a9668693          	addi	a3,a3,-1386 # ffffffffc020e448 <syscalls+0x9d0>
ffffffffc02079ba:	00004617          	auipc	a2,0x4
ffffffffc02079be:	f4e60613          	addi	a2,a2,-178 # ffffffffc020b908 <commands+0x210>
ffffffffc02079c2:	06100593          	li	a1,97
ffffffffc02079c6:	00007517          	auipc	a0,0x7
ffffffffc02079ca:	8d250513          	addi	a0,a0,-1838 # ffffffffc020e298 <syscalls+0x820>
ffffffffc02079ce:	ad1f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079d2:	00007697          	auipc	a3,0x7
ffffffffc02079d6:	a5668693          	addi	a3,a3,-1450 # ffffffffc020e428 <syscalls+0x9b0>
ffffffffc02079da:	00004617          	auipc	a2,0x4
ffffffffc02079de:	f2e60613          	addi	a2,a2,-210 # ffffffffc020b908 <commands+0x210>
ffffffffc02079e2:	05c00593          	li	a1,92
ffffffffc02079e6:	00007517          	auipc	a0,0x7
ffffffffc02079ea:	8b250513          	addi	a0,a0,-1870 # ffffffffc020e298 <syscalls+0x820>
ffffffffc02079ee:	ab1f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02079f2 <__alloc_fs>:
ffffffffc02079f2:	1141                	addi	sp,sp,-16
ffffffffc02079f4:	e022                	sd	s0,0(sp)
ffffffffc02079f6:	842a                	mv	s0,a0
ffffffffc02079f8:	0d800513          	li	a0,216
ffffffffc02079fc:	e406                	sd	ra,8(sp)
ffffffffc02079fe:	d90fa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207a02:	c119                	beqz	a0,ffffffffc0207a08 <__alloc_fs+0x16>
ffffffffc0207a04:	0a852823          	sw	s0,176(a0)
ffffffffc0207a08:	60a2                	ld	ra,8(sp)
ffffffffc0207a0a:	6402                	ld	s0,0(sp)
ffffffffc0207a0c:	0141                	addi	sp,sp,16
ffffffffc0207a0e:	8082                	ret

ffffffffc0207a10 <vfs_init>:
ffffffffc0207a10:	1141                	addi	sp,sp,-16
ffffffffc0207a12:	4585                	li	a1,1
ffffffffc0207a14:	0008e517          	auipc	a0,0x8e
ffffffffc0207a18:	dec50513          	addi	a0,a0,-532 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207a1c:	e406                	sd	ra,8(sp)
ffffffffc0207a1e:	b3dfc0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0207a22:	60a2                	ld	ra,8(sp)
ffffffffc0207a24:	0141                	addi	sp,sp,16
ffffffffc0207a26:	a40d                	j	ffffffffc0207c48 <vfs_devlist_init>

ffffffffc0207a28 <vfs_set_bootfs>:
ffffffffc0207a28:	7179                	addi	sp,sp,-48
ffffffffc0207a2a:	f022                	sd	s0,32(sp)
ffffffffc0207a2c:	f406                	sd	ra,40(sp)
ffffffffc0207a2e:	ec26                	sd	s1,24(sp)
ffffffffc0207a30:	e402                	sd	zero,8(sp)
ffffffffc0207a32:	842a                	mv	s0,a0
ffffffffc0207a34:	c915                	beqz	a0,ffffffffc0207a68 <vfs_set_bootfs+0x40>
ffffffffc0207a36:	03a00593          	li	a1,58
ffffffffc0207a3a:	1d5030ef          	jal	ra,ffffffffc020b40e <strchr>
ffffffffc0207a3e:	c135                	beqz	a0,ffffffffc0207aa2 <vfs_set_bootfs+0x7a>
ffffffffc0207a40:	00154783          	lbu	a5,1(a0)
ffffffffc0207a44:	efb9                	bnez	a5,ffffffffc0207aa2 <vfs_set_bootfs+0x7a>
ffffffffc0207a46:	8522                	mv	a0,s0
ffffffffc0207a48:	11f000ef          	jal	ra,ffffffffc0208366 <vfs_chdir>
ffffffffc0207a4c:	842a                	mv	s0,a0
ffffffffc0207a4e:	c519                	beqz	a0,ffffffffc0207a5c <vfs_set_bootfs+0x34>
ffffffffc0207a50:	70a2                	ld	ra,40(sp)
ffffffffc0207a52:	8522                	mv	a0,s0
ffffffffc0207a54:	7402                	ld	s0,32(sp)
ffffffffc0207a56:	64e2                	ld	s1,24(sp)
ffffffffc0207a58:	6145                	addi	sp,sp,48
ffffffffc0207a5a:	8082                	ret
ffffffffc0207a5c:	0028                	addi	a0,sp,8
ffffffffc0207a5e:	013000ef          	jal	ra,ffffffffc0208270 <vfs_get_curdir>
ffffffffc0207a62:	842a                	mv	s0,a0
ffffffffc0207a64:	f575                	bnez	a0,ffffffffc0207a50 <vfs_set_bootfs+0x28>
ffffffffc0207a66:	6422                	ld	s0,8(sp)
ffffffffc0207a68:	0008e517          	auipc	a0,0x8e
ffffffffc0207a6c:	d9850513          	addi	a0,a0,-616 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207a70:	af5fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207a74:	0008f797          	auipc	a5,0x8f
ffffffffc0207a78:	e7c78793          	addi	a5,a5,-388 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207a7c:	6384                	ld	s1,0(a5)
ffffffffc0207a7e:	0008e517          	auipc	a0,0x8e
ffffffffc0207a82:	d8250513          	addi	a0,a0,-638 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207a86:	e380                	sd	s0,0(a5)
ffffffffc0207a88:	4401                	li	s0,0
ffffffffc0207a8a:	ad7fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207a8e:	d0e9                	beqz	s1,ffffffffc0207a50 <vfs_set_bootfs+0x28>
ffffffffc0207a90:	8526                	mv	a0,s1
ffffffffc0207a92:	e17ff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0207a96:	70a2                	ld	ra,40(sp)
ffffffffc0207a98:	8522                	mv	a0,s0
ffffffffc0207a9a:	7402                	ld	s0,32(sp)
ffffffffc0207a9c:	64e2                	ld	s1,24(sp)
ffffffffc0207a9e:	6145                	addi	sp,sp,48
ffffffffc0207aa0:	8082                	ret
ffffffffc0207aa2:	5475                	li	s0,-3
ffffffffc0207aa4:	b775                	j	ffffffffc0207a50 <vfs_set_bootfs+0x28>

ffffffffc0207aa6 <vfs_get_bootfs>:
ffffffffc0207aa6:	1101                	addi	sp,sp,-32
ffffffffc0207aa8:	e426                	sd	s1,8(sp)
ffffffffc0207aaa:	0008f497          	auipc	s1,0x8f
ffffffffc0207aae:	e4648493          	addi	s1,s1,-442 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207ab2:	609c                	ld	a5,0(s1)
ffffffffc0207ab4:	ec06                	sd	ra,24(sp)
ffffffffc0207ab6:	e822                	sd	s0,16(sp)
ffffffffc0207ab8:	c3a1                	beqz	a5,ffffffffc0207af8 <vfs_get_bootfs+0x52>
ffffffffc0207aba:	842a                	mv	s0,a0
ffffffffc0207abc:	0008e517          	auipc	a0,0x8e
ffffffffc0207ac0:	d4450513          	addi	a0,a0,-700 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207ac4:	aa1fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207ac8:	6084                	ld	s1,0(s1)
ffffffffc0207aca:	c08d                	beqz	s1,ffffffffc0207aec <vfs_get_bootfs+0x46>
ffffffffc0207acc:	8526                	mv	a0,s1
ffffffffc0207ace:	d0dff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0207ad2:	0008e517          	auipc	a0,0x8e
ffffffffc0207ad6:	d2e50513          	addi	a0,a0,-722 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207ada:	a87fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207ade:	4501                	li	a0,0
ffffffffc0207ae0:	e004                	sd	s1,0(s0)
ffffffffc0207ae2:	60e2                	ld	ra,24(sp)
ffffffffc0207ae4:	6442                	ld	s0,16(sp)
ffffffffc0207ae6:	64a2                	ld	s1,8(sp)
ffffffffc0207ae8:	6105                	addi	sp,sp,32
ffffffffc0207aea:	8082                	ret
ffffffffc0207aec:	0008e517          	auipc	a0,0x8e
ffffffffc0207af0:	d1450513          	addi	a0,a0,-748 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207af4:	a6dfc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207af8:	5541                	li	a0,-16
ffffffffc0207afa:	b7e5                	j	ffffffffc0207ae2 <vfs_get_bootfs+0x3c>

ffffffffc0207afc <vfs_do_add>:
ffffffffc0207afc:	7139                	addi	sp,sp,-64
ffffffffc0207afe:	fc06                	sd	ra,56(sp)
ffffffffc0207b00:	f822                	sd	s0,48(sp)
ffffffffc0207b02:	f426                	sd	s1,40(sp)
ffffffffc0207b04:	f04a                	sd	s2,32(sp)
ffffffffc0207b06:	ec4e                	sd	s3,24(sp)
ffffffffc0207b08:	e852                	sd	s4,16(sp)
ffffffffc0207b0a:	e456                	sd	s5,8(sp)
ffffffffc0207b0c:	e05a                	sd	s6,0(sp)
ffffffffc0207b0e:	0e050b63          	beqz	a0,ffffffffc0207c04 <vfs_do_add+0x108>
ffffffffc0207b12:	842a                	mv	s0,a0
ffffffffc0207b14:	8a2e                	mv	s4,a1
ffffffffc0207b16:	8b32                	mv	s6,a2
ffffffffc0207b18:	8ab6                	mv	s5,a3
ffffffffc0207b1a:	c5cd                	beqz	a1,ffffffffc0207bc4 <vfs_do_add+0xc8>
ffffffffc0207b1c:	4db8                	lw	a4,88(a1)
ffffffffc0207b1e:	6785                	lui	a5,0x1
ffffffffc0207b20:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207b24:	0af71163          	bne	a4,a5,ffffffffc0207bc6 <vfs_do_add+0xca>
ffffffffc0207b28:	8522                	mv	a0,s0
ffffffffc0207b2a:	059030ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc0207b2e:	47fd                	li	a5,31
ffffffffc0207b30:	0ca7e663          	bltu	a5,a0,ffffffffc0207bfc <vfs_do_add+0x100>
ffffffffc0207b34:	8522                	mv	a0,s0
ffffffffc0207b36:	ebef80ef          	jal	ra,ffffffffc02001f4 <strdup>
ffffffffc0207b3a:	84aa                	mv	s1,a0
ffffffffc0207b3c:	c171                	beqz	a0,ffffffffc0207c00 <vfs_do_add+0x104>
ffffffffc0207b3e:	03000513          	li	a0,48
ffffffffc0207b42:	c4cfa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207b46:	89aa                	mv	s3,a0
ffffffffc0207b48:	c92d                	beqz	a0,ffffffffc0207bba <vfs_do_add+0xbe>
ffffffffc0207b4a:	0008e517          	auipc	a0,0x8e
ffffffffc0207b4e:	cde50513          	addi	a0,a0,-802 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207b52:	0008e917          	auipc	s2,0x8e
ffffffffc0207b56:	cc690913          	addi	s2,s2,-826 # ffffffffc0295818 <vdev_list>
ffffffffc0207b5a:	a0bfc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207b5e:	844a                	mv	s0,s2
ffffffffc0207b60:	a039                	j	ffffffffc0207b6e <vfs_do_add+0x72>
ffffffffc0207b62:	fe043503          	ld	a0,-32(s0)
ffffffffc0207b66:	85a6                	mv	a1,s1
ffffffffc0207b68:	063030ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc0207b6c:	cd2d                	beqz	a0,ffffffffc0207be6 <vfs_do_add+0xea>
ffffffffc0207b6e:	6400                	ld	s0,8(s0)
ffffffffc0207b70:	ff2419e3          	bne	s0,s2,ffffffffc0207b62 <vfs_do_add+0x66>
ffffffffc0207b74:	6418                	ld	a4,8(s0)
ffffffffc0207b76:	02098793          	addi	a5,s3,32
ffffffffc0207b7a:	0099b023          	sd	s1,0(s3)
ffffffffc0207b7e:	0149b423          	sd	s4,8(s3)
ffffffffc0207b82:	0159bc23          	sd	s5,24(s3)
ffffffffc0207b86:	0169b823          	sd	s6,16(s3)
ffffffffc0207b8a:	e31c                	sd	a5,0(a4)
ffffffffc0207b8c:	0289b023          	sd	s0,32(s3)
ffffffffc0207b90:	02e9b423          	sd	a4,40(s3)
ffffffffc0207b94:	0008e517          	auipc	a0,0x8e
ffffffffc0207b98:	c9450513          	addi	a0,a0,-876 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207b9c:	e41c                	sd	a5,8(s0)
ffffffffc0207b9e:	4401                	li	s0,0
ffffffffc0207ba0:	9c1fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207ba4:	70e2                	ld	ra,56(sp)
ffffffffc0207ba6:	8522                	mv	a0,s0
ffffffffc0207ba8:	7442                	ld	s0,48(sp)
ffffffffc0207baa:	74a2                	ld	s1,40(sp)
ffffffffc0207bac:	7902                	ld	s2,32(sp)
ffffffffc0207bae:	69e2                	ld	s3,24(sp)
ffffffffc0207bb0:	6a42                	ld	s4,16(sp)
ffffffffc0207bb2:	6aa2                	ld	s5,8(sp)
ffffffffc0207bb4:	6b02                	ld	s6,0(sp)
ffffffffc0207bb6:	6121                	addi	sp,sp,64
ffffffffc0207bb8:	8082                	ret
ffffffffc0207bba:	5471                	li	s0,-4
ffffffffc0207bbc:	8526                	mv	a0,s1
ffffffffc0207bbe:	c80fa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207bc2:	b7cd                	j	ffffffffc0207ba4 <vfs_do_add+0xa8>
ffffffffc0207bc4:	d2b5                	beqz	a3,ffffffffc0207b28 <vfs_do_add+0x2c>
ffffffffc0207bc6:	00007697          	auipc	a3,0x7
ffffffffc0207bca:	92268693          	addi	a3,a3,-1758 # ffffffffc020e4e8 <syscalls+0xa70>
ffffffffc0207bce:	00004617          	auipc	a2,0x4
ffffffffc0207bd2:	d3a60613          	addi	a2,a2,-710 # ffffffffc020b908 <commands+0x210>
ffffffffc0207bd6:	08f00593          	li	a1,143
ffffffffc0207bda:	00007517          	auipc	a0,0x7
ffffffffc0207bde:	8f650513          	addi	a0,a0,-1802 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207be2:	8bdf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207be6:	0008e517          	auipc	a0,0x8e
ffffffffc0207bea:	c4250513          	addi	a0,a0,-958 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207bee:	973fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207bf2:	854e                	mv	a0,s3
ffffffffc0207bf4:	c4afa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207bf8:	5425                	li	s0,-23
ffffffffc0207bfa:	b7c9                	j	ffffffffc0207bbc <vfs_do_add+0xc0>
ffffffffc0207bfc:	5451                	li	s0,-12
ffffffffc0207bfe:	b75d                	j	ffffffffc0207ba4 <vfs_do_add+0xa8>
ffffffffc0207c00:	5471                	li	s0,-4
ffffffffc0207c02:	b74d                	j	ffffffffc0207ba4 <vfs_do_add+0xa8>
ffffffffc0207c04:	00007697          	auipc	a3,0x7
ffffffffc0207c08:	8bc68693          	addi	a3,a3,-1860 # ffffffffc020e4c0 <syscalls+0xa48>
ffffffffc0207c0c:	00004617          	auipc	a2,0x4
ffffffffc0207c10:	cfc60613          	addi	a2,a2,-772 # ffffffffc020b908 <commands+0x210>
ffffffffc0207c14:	08e00593          	li	a1,142
ffffffffc0207c18:	00007517          	auipc	a0,0x7
ffffffffc0207c1c:	8b850513          	addi	a0,a0,-1864 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207c20:	87ff80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207c24 <find_mount.part.0>:
ffffffffc0207c24:	1141                	addi	sp,sp,-16
ffffffffc0207c26:	00007697          	auipc	a3,0x7
ffffffffc0207c2a:	89a68693          	addi	a3,a3,-1894 # ffffffffc020e4c0 <syscalls+0xa48>
ffffffffc0207c2e:	00004617          	auipc	a2,0x4
ffffffffc0207c32:	cda60613          	addi	a2,a2,-806 # ffffffffc020b908 <commands+0x210>
ffffffffc0207c36:	0cd00593          	li	a1,205
ffffffffc0207c3a:	00007517          	auipc	a0,0x7
ffffffffc0207c3e:	89650513          	addi	a0,a0,-1898 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207c42:	e406                	sd	ra,8(sp)
ffffffffc0207c44:	85bf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207c48 <vfs_devlist_init>:
ffffffffc0207c48:	0008e797          	auipc	a5,0x8e
ffffffffc0207c4c:	bd078793          	addi	a5,a5,-1072 # ffffffffc0295818 <vdev_list>
ffffffffc0207c50:	4585                	li	a1,1
ffffffffc0207c52:	0008e517          	auipc	a0,0x8e
ffffffffc0207c56:	bd650513          	addi	a0,a0,-1066 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207c5a:	e79c                	sd	a5,8(a5)
ffffffffc0207c5c:	e39c                	sd	a5,0(a5)
ffffffffc0207c5e:	8fdfc06f          	j	ffffffffc020455a <sem_init>

ffffffffc0207c62 <vfs_cleanup>:
ffffffffc0207c62:	1101                	addi	sp,sp,-32
ffffffffc0207c64:	e426                	sd	s1,8(sp)
ffffffffc0207c66:	0008e497          	auipc	s1,0x8e
ffffffffc0207c6a:	bb248493          	addi	s1,s1,-1102 # ffffffffc0295818 <vdev_list>
ffffffffc0207c6e:	649c                	ld	a5,8(s1)
ffffffffc0207c70:	ec06                	sd	ra,24(sp)
ffffffffc0207c72:	e822                	sd	s0,16(sp)
ffffffffc0207c74:	02978e63          	beq	a5,s1,ffffffffc0207cb0 <vfs_cleanup+0x4e>
ffffffffc0207c78:	0008e517          	auipc	a0,0x8e
ffffffffc0207c7c:	bb050513          	addi	a0,a0,-1104 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207c80:	8e5fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207c84:	6480                	ld	s0,8(s1)
ffffffffc0207c86:	00940b63          	beq	s0,s1,ffffffffc0207c9c <vfs_cleanup+0x3a>
ffffffffc0207c8a:	ff043783          	ld	a5,-16(s0)
ffffffffc0207c8e:	853e                	mv	a0,a5
ffffffffc0207c90:	c399                	beqz	a5,ffffffffc0207c96 <vfs_cleanup+0x34>
ffffffffc0207c92:	6bfc                	ld	a5,208(a5)
ffffffffc0207c94:	9782                	jalr	a5
ffffffffc0207c96:	6400                	ld	s0,8(s0)
ffffffffc0207c98:	fe9419e3          	bne	s0,s1,ffffffffc0207c8a <vfs_cleanup+0x28>
ffffffffc0207c9c:	6442                	ld	s0,16(sp)
ffffffffc0207c9e:	60e2                	ld	ra,24(sp)
ffffffffc0207ca0:	64a2                	ld	s1,8(sp)
ffffffffc0207ca2:	0008e517          	auipc	a0,0x8e
ffffffffc0207ca6:	b8650513          	addi	a0,a0,-1146 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207caa:	6105                	addi	sp,sp,32
ffffffffc0207cac:	8b5fc06f          	j	ffffffffc0204560 <up>
ffffffffc0207cb0:	60e2                	ld	ra,24(sp)
ffffffffc0207cb2:	6442                	ld	s0,16(sp)
ffffffffc0207cb4:	64a2                	ld	s1,8(sp)
ffffffffc0207cb6:	6105                	addi	sp,sp,32
ffffffffc0207cb8:	8082                	ret

ffffffffc0207cba <vfs_get_root>:
ffffffffc0207cba:	7179                	addi	sp,sp,-48
ffffffffc0207cbc:	f406                	sd	ra,40(sp)
ffffffffc0207cbe:	f022                	sd	s0,32(sp)
ffffffffc0207cc0:	ec26                	sd	s1,24(sp)
ffffffffc0207cc2:	e84a                	sd	s2,16(sp)
ffffffffc0207cc4:	e44e                	sd	s3,8(sp)
ffffffffc0207cc6:	e052                	sd	s4,0(sp)
ffffffffc0207cc8:	c541                	beqz	a0,ffffffffc0207d50 <vfs_get_root+0x96>
ffffffffc0207cca:	0008e917          	auipc	s2,0x8e
ffffffffc0207cce:	b4e90913          	addi	s2,s2,-1202 # ffffffffc0295818 <vdev_list>
ffffffffc0207cd2:	00893783          	ld	a5,8(s2)
ffffffffc0207cd6:	07278b63          	beq	a5,s2,ffffffffc0207d4c <vfs_get_root+0x92>
ffffffffc0207cda:	89aa                	mv	s3,a0
ffffffffc0207cdc:	0008e517          	auipc	a0,0x8e
ffffffffc0207ce0:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207ce4:	8a2e                	mv	s4,a1
ffffffffc0207ce6:	844a                	mv	s0,s2
ffffffffc0207ce8:	87dfc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207cec:	a801                	j	ffffffffc0207cfc <vfs_get_root+0x42>
ffffffffc0207cee:	fe043583          	ld	a1,-32(s0)
ffffffffc0207cf2:	854e                	mv	a0,s3
ffffffffc0207cf4:	6d6030ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc0207cf8:	84aa                	mv	s1,a0
ffffffffc0207cfa:	c505                	beqz	a0,ffffffffc0207d22 <vfs_get_root+0x68>
ffffffffc0207cfc:	6400                	ld	s0,8(s0)
ffffffffc0207cfe:	ff2418e3          	bne	s0,s2,ffffffffc0207cee <vfs_get_root+0x34>
ffffffffc0207d02:	54cd                	li	s1,-13
ffffffffc0207d04:	0008e517          	auipc	a0,0x8e
ffffffffc0207d08:	b2450513          	addi	a0,a0,-1244 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d0c:	855fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207d10:	70a2                	ld	ra,40(sp)
ffffffffc0207d12:	7402                	ld	s0,32(sp)
ffffffffc0207d14:	6942                	ld	s2,16(sp)
ffffffffc0207d16:	69a2                	ld	s3,8(sp)
ffffffffc0207d18:	6a02                	ld	s4,0(sp)
ffffffffc0207d1a:	8526                	mv	a0,s1
ffffffffc0207d1c:	64e2                	ld	s1,24(sp)
ffffffffc0207d1e:	6145                	addi	sp,sp,48
ffffffffc0207d20:	8082                	ret
ffffffffc0207d22:	ff043503          	ld	a0,-16(s0)
ffffffffc0207d26:	c519                	beqz	a0,ffffffffc0207d34 <vfs_get_root+0x7a>
ffffffffc0207d28:	617c                	ld	a5,192(a0)
ffffffffc0207d2a:	9782                	jalr	a5
ffffffffc0207d2c:	c519                	beqz	a0,ffffffffc0207d3a <vfs_get_root+0x80>
ffffffffc0207d2e:	00aa3023          	sd	a0,0(s4)
ffffffffc0207d32:	bfc9                	j	ffffffffc0207d04 <vfs_get_root+0x4a>
ffffffffc0207d34:	ff843783          	ld	a5,-8(s0)
ffffffffc0207d38:	c399                	beqz	a5,ffffffffc0207d3e <vfs_get_root+0x84>
ffffffffc0207d3a:	54c9                	li	s1,-14
ffffffffc0207d3c:	b7e1                	j	ffffffffc0207d04 <vfs_get_root+0x4a>
ffffffffc0207d3e:	fe843503          	ld	a0,-24(s0)
ffffffffc0207d42:	a99ff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0207d46:	fe843503          	ld	a0,-24(s0)
ffffffffc0207d4a:	b7cd                	j	ffffffffc0207d2c <vfs_get_root+0x72>
ffffffffc0207d4c:	54cd                	li	s1,-13
ffffffffc0207d4e:	b7c9                	j	ffffffffc0207d10 <vfs_get_root+0x56>
ffffffffc0207d50:	00006697          	auipc	a3,0x6
ffffffffc0207d54:	77068693          	addi	a3,a3,1904 # ffffffffc020e4c0 <syscalls+0xa48>
ffffffffc0207d58:	00004617          	auipc	a2,0x4
ffffffffc0207d5c:	bb060613          	addi	a2,a2,-1104 # ffffffffc020b908 <commands+0x210>
ffffffffc0207d60:	04500593          	li	a1,69
ffffffffc0207d64:	00006517          	auipc	a0,0x6
ffffffffc0207d68:	76c50513          	addi	a0,a0,1900 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207d6c:	f32f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207d70 <vfs_get_devname>:
ffffffffc0207d70:	0008e697          	auipc	a3,0x8e
ffffffffc0207d74:	aa868693          	addi	a3,a3,-1368 # ffffffffc0295818 <vdev_list>
ffffffffc0207d78:	87b6                	mv	a5,a3
ffffffffc0207d7a:	e511                	bnez	a0,ffffffffc0207d86 <vfs_get_devname+0x16>
ffffffffc0207d7c:	a829                	j	ffffffffc0207d96 <vfs_get_devname+0x26>
ffffffffc0207d7e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207d82:	00a70763          	beq	a4,a0,ffffffffc0207d90 <vfs_get_devname+0x20>
ffffffffc0207d86:	679c                	ld	a5,8(a5)
ffffffffc0207d88:	fed79be3          	bne	a5,a3,ffffffffc0207d7e <vfs_get_devname+0xe>
ffffffffc0207d8c:	4501                	li	a0,0
ffffffffc0207d8e:	8082                	ret
ffffffffc0207d90:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207d94:	8082                	ret
ffffffffc0207d96:	1141                	addi	sp,sp,-16
ffffffffc0207d98:	00006697          	auipc	a3,0x6
ffffffffc0207d9c:	7b068693          	addi	a3,a3,1968 # ffffffffc020e548 <syscalls+0xad0>
ffffffffc0207da0:	00004617          	auipc	a2,0x4
ffffffffc0207da4:	b6860613          	addi	a2,a2,-1176 # ffffffffc020b908 <commands+0x210>
ffffffffc0207da8:	06a00593          	li	a1,106
ffffffffc0207dac:	00006517          	auipc	a0,0x6
ffffffffc0207db0:	72450513          	addi	a0,a0,1828 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207db4:	e406                	sd	ra,8(sp)
ffffffffc0207db6:	ee8f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207dba <vfs_add_dev>:
ffffffffc0207dba:	86b2                	mv	a3,a2
ffffffffc0207dbc:	4601                	li	a2,0
ffffffffc0207dbe:	d3fff06f          	j	ffffffffc0207afc <vfs_do_add>

ffffffffc0207dc2 <vfs_mount>:
ffffffffc0207dc2:	7179                	addi	sp,sp,-48
ffffffffc0207dc4:	e84a                	sd	s2,16(sp)
ffffffffc0207dc6:	892a                	mv	s2,a0
ffffffffc0207dc8:	0008e517          	auipc	a0,0x8e
ffffffffc0207dcc:	a6050513          	addi	a0,a0,-1440 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207dd0:	e44e                	sd	s3,8(sp)
ffffffffc0207dd2:	f406                	sd	ra,40(sp)
ffffffffc0207dd4:	f022                	sd	s0,32(sp)
ffffffffc0207dd6:	ec26                	sd	s1,24(sp)
ffffffffc0207dd8:	89ae                	mv	s3,a1
ffffffffc0207dda:	f8afc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207dde:	08090a63          	beqz	s2,ffffffffc0207e72 <vfs_mount+0xb0>
ffffffffc0207de2:	0008e497          	auipc	s1,0x8e
ffffffffc0207de6:	a3648493          	addi	s1,s1,-1482 # ffffffffc0295818 <vdev_list>
ffffffffc0207dea:	6480                	ld	s0,8(s1)
ffffffffc0207dec:	00941663          	bne	s0,s1,ffffffffc0207df8 <vfs_mount+0x36>
ffffffffc0207df0:	a8ad                	j	ffffffffc0207e6a <vfs_mount+0xa8>
ffffffffc0207df2:	6400                	ld	s0,8(s0)
ffffffffc0207df4:	06940b63          	beq	s0,s1,ffffffffc0207e6a <vfs_mount+0xa8>
ffffffffc0207df8:	ff843783          	ld	a5,-8(s0)
ffffffffc0207dfc:	dbfd                	beqz	a5,ffffffffc0207df2 <vfs_mount+0x30>
ffffffffc0207dfe:	fe043503          	ld	a0,-32(s0)
ffffffffc0207e02:	85ca                	mv	a1,s2
ffffffffc0207e04:	5c6030ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc0207e08:	f56d                	bnez	a0,ffffffffc0207df2 <vfs_mount+0x30>
ffffffffc0207e0a:	ff043783          	ld	a5,-16(s0)
ffffffffc0207e0e:	e3a5                	bnez	a5,ffffffffc0207e6e <vfs_mount+0xac>
ffffffffc0207e10:	fe043783          	ld	a5,-32(s0)
ffffffffc0207e14:	c3c9                	beqz	a5,ffffffffc0207e96 <vfs_mount+0xd4>
ffffffffc0207e16:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e1a:	cfb5                	beqz	a5,ffffffffc0207e96 <vfs_mount+0xd4>
ffffffffc0207e1c:	fe843503          	ld	a0,-24(s0)
ffffffffc0207e20:	c939                	beqz	a0,ffffffffc0207e76 <vfs_mount+0xb4>
ffffffffc0207e22:	4d38                	lw	a4,88(a0)
ffffffffc0207e24:	6785                	lui	a5,0x1
ffffffffc0207e26:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207e2a:	04f71663          	bne	a4,a5,ffffffffc0207e76 <vfs_mount+0xb4>
ffffffffc0207e2e:	ff040593          	addi	a1,s0,-16
ffffffffc0207e32:	9982                	jalr	s3
ffffffffc0207e34:	84aa                	mv	s1,a0
ffffffffc0207e36:	ed01                	bnez	a0,ffffffffc0207e4e <vfs_mount+0x8c>
ffffffffc0207e38:	ff043783          	ld	a5,-16(s0)
ffffffffc0207e3c:	cfad                	beqz	a5,ffffffffc0207eb6 <vfs_mount+0xf4>
ffffffffc0207e3e:	fe043583          	ld	a1,-32(s0)
ffffffffc0207e42:	00006517          	auipc	a0,0x6
ffffffffc0207e46:	79650513          	addi	a0,a0,1942 # ffffffffc020e5d8 <syscalls+0xb60>
ffffffffc0207e4a:	b5cf80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207e4e:	0008e517          	auipc	a0,0x8e
ffffffffc0207e52:	9da50513          	addi	a0,a0,-1574 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e56:	f0afc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207e5a:	70a2                	ld	ra,40(sp)
ffffffffc0207e5c:	7402                	ld	s0,32(sp)
ffffffffc0207e5e:	6942                	ld	s2,16(sp)
ffffffffc0207e60:	69a2                	ld	s3,8(sp)
ffffffffc0207e62:	8526                	mv	a0,s1
ffffffffc0207e64:	64e2                	ld	s1,24(sp)
ffffffffc0207e66:	6145                	addi	sp,sp,48
ffffffffc0207e68:	8082                	ret
ffffffffc0207e6a:	54cd                	li	s1,-13
ffffffffc0207e6c:	b7cd                	j	ffffffffc0207e4e <vfs_mount+0x8c>
ffffffffc0207e6e:	54c5                	li	s1,-15
ffffffffc0207e70:	bff9                	j	ffffffffc0207e4e <vfs_mount+0x8c>
ffffffffc0207e72:	db3ff0ef          	jal	ra,ffffffffc0207c24 <find_mount.part.0>
ffffffffc0207e76:	00006697          	auipc	a3,0x6
ffffffffc0207e7a:	71268693          	addi	a3,a3,1810 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0207e7e:	00004617          	auipc	a2,0x4
ffffffffc0207e82:	a8a60613          	addi	a2,a2,-1398 # ffffffffc020b908 <commands+0x210>
ffffffffc0207e86:	0ed00593          	li	a1,237
ffffffffc0207e8a:	00006517          	auipc	a0,0x6
ffffffffc0207e8e:	64650513          	addi	a0,a0,1606 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207e92:	e0cf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207e96:	00006697          	auipc	a3,0x6
ffffffffc0207e9a:	6c268693          	addi	a3,a3,1730 # ffffffffc020e558 <syscalls+0xae0>
ffffffffc0207e9e:	00004617          	auipc	a2,0x4
ffffffffc0207ea2:	a6a60613          	addi	a2,a2,-1430 # ffffffffc020b908 <commands+0x210>
ffffffffc0207ea6:	0eb00593          	li	a1,235
ffffffffc0207eaa:	00006517          	auipc	a0,0x6
ffffffffc0207eae:	62650513          	addi	a0,a0,1574 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207eb2:	decf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207eb6:	00006697          	auipc	a3,0x6
ffffffffc0207eba:	70a68693          	addi	a3,a3,1802 # ffffffffc020e5c0 <syscalls+0xb48>
ffffffffc0207ebe:	00004617          	auipc	a2,0x4
ffffffffc0207ec2:	a4a60613          	addi	a2,a2,-1462 # ffffffffc020b908 <commands+0x210>
ffffffffc0207ec6:	0ef00593          	li	a1,239
ffffffffc0207eca:	00006517          	auipc	a0,0x6
ffffffffc0207ece:	60650513          	addi	a0,a0,1542 # ffffffffc020e4d0 <syscalls+0xa58>
ffffffffc0207ed2:	dccf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207ed6 <vfs_open>:
ffffffffc0207ed6:	711d                	addi	sp,sp,-96
ffffffffc0207ed8:	e4a6                	sd	s1,72(sp)
ffffffffc0207eda:	e0ca                	sd	s2,64(sp)
ffffffffc0207edc:	fc4e                	sd	s3,56(sp)
ffffffffc0207ede:	ec86                	sd	ra,88(sp)
ffffffffc0207ee0:	e8a2                	sd	s0,80(sp)
ffffffffc0207ee2:	f852                	sd	s4,48(sp)
ffffffffc0207ee4:	f456                	sd	s5,40(sp)
ffffffffc0207ee6:	0035f793          	andi	a5,a1,3
ffffffffc0207eea:	84ae                	mv	s1,a1
ffffffffc0207eec:	892a                	mv	s2,a0
ffffffffc0207eee:	89b2                	mv	s3,a2
ffffffffc0207ef0:	0e078663          	beqz	a5,ffffffffc0207fdc <vfs_open+0x106>
ffffffffc0207ef4:	470d                	li	a4,3
ffffffffc0207ef6:	0105fa93          	andi	s5,a1,16
ffffffffc0207efa:	0ce78f63          	beq	a5,a4,ffffffffc0207fd8 <vfs_open+0x102>
ffffffffc0207efe:	002c                	addi	a1,sp,8
ffffffffc0207f00:	854a                	mv	a0,s2
ffffffffc0207f02:	2ae000ef          	jal	ra,ffffffffc02081b0 <vfs_lookup>
ffffffffc0207f06:	842a                	mv	s0,a0
ffffffffc0207f08:	0044fa13          	andi	s4,s1,4
ffffffffc0207f0c:	e159                	bnez	a0,ffffffffc0207f92 <vfs_open+0xbc>
ffffffffc0207f0e:	00c4f793          	andi	a5,s1,12
ffffffffc0207f12:	4731                	li	a4,12
ffffffffc0207f14:	0ee78263          	beq	a5,a4,ffffffffc0207ff8 <vfs_open+0x122>
ffffffffc0207f18:	6422                	ld	s0,8(sp)
ffffffffc0207f1a:	12040163          	beqz	s0,ffffffffc020803c <vfs_open+0x166>
ffffffffc0207f1e:	783c                	ld	a5,112(s0)
ffffffffc0207f20:	cff1                	beqz	a5,ffffffffc0207ffc <vfs_open+0x126>
ffffffffc0207f22:	679c                	ld	a5,8(a5)
ffffffffc0207f24:	cfe1                	beqz	a5,ffffffffc0207ffc <vfs_open+0x126>
ffffffffc0207f26:	8522                	mv	a0,s0
ffffffffc0207f28:	00006597          	auipc	a1,0x6
ffffffffc0207f2c:	79058593          	addi	a1,a1,1936 # ffffffffc020e6b8 <syscalls+0xc40>
ffffffffc0207f30:	8c3ff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0207f34:	783c                	ld	a5,112(s0)
ffffffffc0207f36:	6522                	ld	a0,8(sp)
ffffffffc0207f38:	85a6                	mv	a1,s1
ffffffffc0207f3a:	679c                	ld	a5,8(a5)
ffffffffc0207f3c:	9782                	jalr	a5
ffffffffc0207f3e:	842a                	mv	s0,a0
ffffffffc0207f40:	6522                	ld	a0,8(sp)
ffffffffc0207f42:	e845                	bnez	s0,ffffffffc0207ff2 <vfs_open+0x11c>
ffffffffc0207f44:	015a6a33          	or	s4,s4,s5
ffffffffc0207f48:	89fff0ef          	jal	ra,ffffffffc02077e6 <inode_open_inc>
ffffffffc0207f4c:	020a0663          	beqz	s4,ffffffffc0207f78 <vfs_open+0xa2>
ffffffffc0207f50:	64a2                	ld	s1,8(sp)
ffffffffc0207f52:	c4e9                	beqz	s1,ffffffffc020801c <vfs_open+0x146>
ffffffffc0207f54:	78bc                	ld	a5,112(s1)
ffffffffc0207f56:	c3f9                	beqz	a5,ffffffffc020801c <vfs_open+0x146>
ffffffffc0207f58:	73bc                	ld	a5,96(a5)
ffffffffc0207f5a:	c3e9                	beqz	a5,ffffffffc020801c <vfs_open+0x146>
ffffffffc0207f5c:	00006597          	auipc	a1,0x6
ffffffffc0207f60:	7bc58593          	addi	a1,a1,1980 # ffffffffc020e718 <syscalls+0xca0>
ffffffffc0207f64:	8526                	mv	a0,s1
ffffffffc0207f66:	88dff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0207f6a:	78bc                	ld	a5,112(s1)
ffffffffc0207f6c:	6522                	ld	a0,8(sp)
ffffffffc0207f6e:	4581                	li	a1,0
ffffffffc0207f70:	73bc                	ld	a5,96(a5)
ffffffffc0207f72:	9782                	jalr	a5
ffffffffc0207f74:	87aa                	mv	a5,a0
ffffffffc0207f76:	e92d                	bnez	a0,ffffffffc0207fe8 <vfs_open+0x112>
ffffffffc0207f78:	67a2                	ld	a5,8(sp)
ffffffffc0207f7a:	00f9b023          	sd	a5,0(s3)
ffffffffc0207f7e:	60e6                	ld	ra,88(sp)
ffffffffc0207f80:	8522                	mv	a0,s0
ffffffffc0207f82:	6446                	ld	s0,80(sp)
ffffffffc0207f84:	64a6                	ld	s1,72(sp)
ffffffffc0207f86:	6906                	ld	s2,64(sp)
ffffffffc0207f88:	79e2                	ld	s3,56(sp)
ffffffffc0207f8a:	7a42                	ld	s4,48(sp)
ffffffffc0207f8c:	7aa2                	ld	s5,40(sp)
ffffffffc0207f8e:	6125                	addi	sp,sp,96
ffffffffc0207f90:	8082                	ret
ffffffffc0207f92:	57c1                	li	a5,-16
ffffffffc0207f94:	fef515e3          	bne	a0,a5,ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207f98:	fe0a03e3          	beqz	s4,ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207f9c:	0810                	addi	a2,sp,16
ffffffffc0207f9e:	082c                	addi	a1,sp,24
ffffffffc0207fa0:	854a                	mv	a0,s2
ffffffffc0207fa2:	2a4000ef          	jal	ra,ffffffffc0208246 <vfs_lookup_parent>
ffffffffc0207fa6:	842a                	mv	s0,a0
ffffffffc0207fa8:	f979                	bnez	a0,ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207faa:	6462                	ld	s0,24(sp)
ffffffffc0207fac:	c845                	beqz	s0,ffffffffc020805c <vfs_open+0x186>
ffffffffc0207fae:	783c                	ld	a5,112(s0)
ffffffffc0207fb0:	c7d5                	beqz	a5,ffffffffc020805c <vfs_open+0x186>
ffffffffc0207fb2:	77bc                	ld	a5,104(a5)
ffffffffc0207fb4:	c7c5                	beqz	a5,ffffffffc020805c <vfs_open+0x186>
ffffffffc0207fb6:	8522                	mv	a0,s0
ffffffffc0207fb8:	00006597          	auipc	a1,0x6
ffffffffc0207fbc:	69858593          	addi	a1,a1,1688 # ffffffffc020e650 <syscalls+0xbd8>
ffffffffc0207fc0:	833ff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0207fc4:	783c                	ld	a5,112(s0)
ffffffffc0207fc6:	65c2                	ld	a1,16(sp)
ffffffffc0207fc8:	6562                	ld	a0,24(sp)
ffffffffc0207fca:	77bc                	ld	a5,104(a5)
ffffffffc0207fcc:	4034d613          	srai	a2,s1,0x3
ffffffffc0207fd0:	0034                	addi	a3,sp,8
ffffffffc0207fd2:	8a05                	andi	a2,a2,1
ffffffffc0207fd4:	9782                	jalr	a5
ffffffffc0207fd6:	b789                	j	ffffffffc0207f18 <vfs_open+0x42>
ffffffffc0207fd8:	5475                	li	s0,-3
ffffffffc0207fda:	b755                	j	ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207fdc:	0105fa93          	andi	s5,a1,16
ffffffffc0207fe0:	5475                	li	s0,-3
ffffffffc0207fe2:	f80a9ee3          	bnez	s5,ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207fe6:	bf21                	j	ffffffffc0207efe <vfs_open+0x28>
ffffffffc0207fe8:	6522                	ld	a0,8(sp)
ffffffffc0207fea:	843e                	mv	s0,a5
ffffffffc0207fec:	965ff0ef          	jal	ra,ffffffffc0207950 <inode_open_dec>
ffffffffc0207ff0:	6522                	ld	a0,8(sp)
ffffffffc0207ff2:	8b7ff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0207ff6:	b761                	j	ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207ff8:	5425                	li	s0,-23
ffffffffc0207ffa:	b751                	j	ffffffffc0207f7e <vfs_open+0xa8>
ffffffffc0207ffc:	00006697          	auipc	a3,0x6
ffffffffc0208000:	66c68693          	addi	a3,a3,1644 # ffffffffc020e668 <syscalls+0xbf0>
ffffffffc0208004:	00004617          	auipc	a2,0x4
ffffffffc0208008:	90460613          	addi	a2,a2,-1788 # ffffffffc020b908 <commands+0x210>
ffffffffc020800c:	03300593          	li	a1,51
ffffffffc0208010:	00006517          	auipc	a0,0x6
ffffffffc0208014:	62850513          	addi	a0,a0,1576 # ffffffffc020e638 <syscalls+0xbc0>
ffffffffc0208018:	c86f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020801c:	00006697          	auipc	a3,0x6
ffffffffc0208020:	6a468693          	addi	a3,a3,1700 # ffffffffc020e6c0 <syscalls+0xc48>
ffffffffc0208024:	00004617          	auipc	a2,0x4
ffffffffc0208028:	8e460613          	addi	a2,a2,-1820 # ffffffffc020b908 <commands+0x210>
ffffffffc020802c:	03a00593          	li	a1,58
ffffffffc0208030:	00006517          	auipc	a0,0x6
ffffffffc0208034:	60850513          	addi	a0,a0,1544 # ffffffffc020e638 <syscalls+0xbc0>
ffffffffc0208038:	c66f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020803c:	00006697          	auipc	a3,0x6
ffffffffc0208040:	61c68693          	addi	a3,a3,1564 # ffffffffc020e658 <syscalls+0xbe0>
ffffffffc0208044:	00004617          	auipc	a2,0x4
ffffffffc0208048:	8c460613          	addi	a2,a2,-1852 # ffffffffc020b908 <commands+0x210>
ffffffffc020804c:	03100593          	li	a1,49
ffffffffc0208050:	00006517          	auipc	a0,0x6
ffffffffc0208054:	5e850513          	addi	a0,a0,1512 # ffffffffc020e638 <syscalls+0xbc0>
ffffffffc0208058:	c46f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020805c:	00006697          	auipc	a3,0x6
ffffffffc0208060:	58c68693          	addi	a3,a3,1420 # ffffffffc020e5e8 <syscalls+0xb70>
ffffffffc0208064:	00004617          	auipc	a2,0x4
ffffffffc0208068:	8a460613          	addi	a2,a2,-1884 # ffffffffc020b908 <commands+0x210>
ffffffffc020806c:	02c00593          	li	a1,44
ffffffffc0208070:	00006517          	auipc	a0,0x6
ffffffffc0208074:	5c850513          	addi	a0,a0,1480 # ffffffffc020e638 <syscalls+0xbc0>
ffffffffc0208078:	c26f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020807c <vfs_close>:
ffffffffc020807c:	1141                	addi	sp,sp,-16
ffffffffc020807e:	e406                	sd	ra,8(sp)
ffffffffc0208080:	e022                	sd	s0,0(sp)
ffffffffc0208082:	842a                	mv	s0,a0
ffffffffc0208084:	8cdff0ef          	jal	ra,ffffffffc0207950 <inode_open_dec>
ffffffffc0208088:	8522                	mv	a0,s0
ffffffffc020808a:	81fff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020808e:	60a2                	ld	ra,8(sp)
ffffffffc0208090:	6402                	ld	s0,0(sp)
ffffffffc0208092:	4501                	li	a0,0
ffffffffc0208094:	0141                	addi	sp,sp,16
ffffffffc0208096:	8082                	ret

ffffffffc0208098 <get_device>:
ffffffffc0208098:	7179                	addi	sp,sp,-48
ffffffffc020809a:	ec26                	sd	s1,24(sp)
ffffffffc020809c:	e84a                	sd	s2,16(sp)
ffffffffc020809e:	f406                	sd	ra,40(sp)
ffffffffc02080a0:	f022                	sd	s0,32(sp)
ffffffffc02080a2:	00054303          	lbu	t1,0(a0)
ffffffffc02080a6:	892e                	mv	s2,a1
ffffffffc02080a8:	84b2                	mv	s1,a2
ffffffffc02080aa:	02030463          	beqz	t1,ffffffffc02080d2 <get_device+0x3a>
ffffffffc02080ae:	00150413          	addi	s0,a0,1
ffffffffc02080b2:	86a2                	mv	a3,s0
ffffffffc02080b4:	879a                	mv	a5,t1
ffffffffc02080b6:	4701                	li	a4,0
ffffffffc02080b8:	03a00813          	li	a6,58
ffffffffc02080bc:	02f00893          	li	a7,47
ffffffffc02080c0:	03078263          	beq	a5,a6,ffffffffc02080e4 <get_device+0x4c>
ffffffffc02080c4:	05178963          	beq	a5,a7,ffffffffc0208116 <get_device+0x7e>
ffffffffc02080c8:	0006c783          	lbu	a5,0(a3)
ffffffffc02080cc:	2705                	addiw	a4,a4,1
ffffffffc02080ce:	0685                	addi	a3,a3,1
ffffffffc02080d0:	fbe5                	bnez	a5,ffffffffc02080c0 <get_device+0x28>
ffffffffc02080d2:	7402                	ld	s0,32(sp)
ffffffffc02080d4:	00a93023          	sd	a0,0(s2)
ffffffffc02080d8:	70a2                	ld	ra,40(sp)
ffffffffc02080da:	6942                	ld	s2,16(sp)
ffffffffc02080dc:	8526                	mv	a0,s1
ffffffffc02080de:	64e2                	ld	s1,24(sp)
ffffffffc02080e0:	6145                	addi	sp,sp,48
ffffffffc02080e2:	a279                	j	ffffffffc0208270 <vfs_get_curdir>
ffffffffc02080e4:	cb15                	beqz	a4,ffffffffc0208118 <get_device+0x80>
ffffffffc02080e6:	00e507b3          	add	a5,a0,a4
ffffffffc02080ea:	0705                	addi	a4,a4,1
ffffffffc02080ec:	00078023          	sb	zero,0(a5)
ffffffffc02080f0:	972a                	add	a4,a4,a0
ffffffffc02080f2:	02f00613          	li	a2,47
ffffffffc02080f6:	00074783          	lbu	a5,0(a4)
ffffffffc02080fa:	86ba                	mv	a3,a4
ffffffffc02080fc:	0705                	addi	a4,a4,1
ffffffffc02080fe:	fec78ce3          	beq	a5,a2,ffffffffc02080f6 <get_device+0x5e>
ffffffffc0208102:	7402                	ld	s0,32(sp)
ffffffffc0208104:	70a2                	ld	ra,40(sp)
ffffffffc0208106:	00d93023          	sd	a3,0(s2)
ffffffffc020810a:	85a6                	mv	a1,s1
ffffffffc020810c:	6942                	ld	s2,16(sp)
ffffffffc020810e:	64e2                	ld	s1,24(sp)
ffffffffc0208110:	6145                	addi	sp,sp,48
ffffffffc0208112:	ba9ff06f          	j	ffffffffc0207cba <vfs_get_root>
ffffffffc0208116:	ff55                	bnez	a4,ffffffffc02080d2 <get_device+0x3a>
ffffffffc0208118:	02f00793          	li	a5,47
ffffffffc020811c:	04f30563          	beq	t1,a5,ffffffffc0208166 <get_device+0xce>
ffffffffc0208120:	03a00793          	li	a5,58
ffffffffc0208124:	06f31663          	bne	t1,a5,ffffffffc0208190 <get_device+0xf8>
ffffffffc0208128:	0028                	addi	a0,sp,8
ffffffffc020812a:	146000ef          	jal	ra,ffffffffc0208270 <vfs_get_curdir>
ffffffffc020812e:	e515                	bnez	a0,ffffffffc020815a <get_device+0xc2>
ffffffffc0208130:	67a2                	ld	a5,8(sp)
ffffffffc0208132:	77a8                	ld	a0,104(a5)
ffffffffc0208134:	cd15                	beqz	a0,ffffffffc0208170 <get_device+0xd8>
ffffffffc0208136:	617c                	ld	a5,192(a0)
ffffffffc0208138:	9782                	jalr	a5
ffffffffc020813a:	87aa                	mv	a5,a0
ffffffffc020813c:	6522                	ld	a0,8(sp)
ffffffffc020813e:	e09c                	sd	a5,0(s1)
ffffffffc0208140:	f68ff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0208144:	02f00713          	li	a4,47
ffffffffc0208148:	a011                	j	ffffffffc020814c <get_device+0xb4>
ffffffffc020814a:	0405                	addi	s0,s0,1
ffffffffc020814c:	00044783          	lbu	a5,0(s0)
ffffffffc0208150:	fee78de3          	beq	a5,a4,ffffffffc020814a <get_device+0xb2>
ffffffffc0208154:	00893023          	sd	s0,0(s2)
ffffffffc0208158:	4501                	li	a0,0
ffffffffc020815a:	70a2                	ld	ra,40(sp)
ffffffffc020815c:	7402                	ld	s0,32(sp)
ffffffffc020815e:	64e2                	ld	s1,24(sp)
ffffffffc0208160:	6942                	ld	s2,16(sp)
ffffffffc0208162:	6145                	addi	sp,sp,48
ffffffffc0208164:	8082                	ret
ffffffffc0208166:	8526                	mv	a0,s1
ffffffffc0208168:	93fff0ef          	jal	ra,ffffffffc0207aa6 <vfs_get_bootfs>
ffffffffc020816c:	dd61                	beqz	a0,ffffffffc0208144 <get_device+0xac>
ffffffffc020816e:	b7f5                	j	ffffffffc020815a <get_device+0xc2>
ffffffffc0208170:	00006697          	auipc	a3,0x6
ffffffffc0208174:	5e068693          	addi	a3,a3,1504 # ffffffffc020e750 <syscalls+0xcd8>
ffffffffc0208178:	00003617          	auipc	a2,0x3
ffffffffc020817c:	79060613          	addi	a2,a2,1936 # ffffffffc020b908 <commands+0x210>
ffffffffc0208180:	03900593          	li	a1,57
ffffffffc0208184:	00006517          	auipc	a0,0x6
ffffffffc0208188:	5b450513          	addi	a0,a0,1460 # ffffffffc020e738 <syscalls+0xcc0>
ffffffffc020818c:	b12f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208190:	00006697          	auipc	a3,0x6
ffffffffc0208194:	59868693          	addi	a3,a3,1432 # ffffffffc020e728 <syscalls+0xcb0>
ffffffffc0208198:	00003617          	auipc	a2,0x3
ffffffffc020819c:	77060613          	addi	a2,a2,1904 # ffffffffc020b908 <commands+0x210>
ffffffffc02081a0:	03300593          	li	a1,51
ffffffffc02081a4:	00006517          	auipc	a0,0x6
ffffffffc02081a8:	59450513          	addi	a0,a0,1428 # ffffffffc020e738 <syscalls+0xcc0>
ffffffffc02081ac:	af2f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02081b0 <vfs_lookup>:
ffffffffc02081b0:	7139                	addi	sp,sp,-64
ffffffffc02081b2:	f426                	sd	s1,40(sp)
ffffffffc02081b4:	0830                	addi	a2,sp,24
ffffffffc02081b6:	84ae                	mv	s1,a1
ffffffffc02081b8:	002c                	addi	a1,sp,8
ffffffffc02081ba:	f822                	sd	s0,48(sp)
ffffffffc02081bc:	fc06                	sd	ra,56(sp)
ffffffffc02081be:	f04a                	sd	s2,32(sp)
ffffffffc02081c0:	e42a                	sd	a0,8(sp)
ffffffffc02081c2:	ed7ff0ef          	jal	ra,ffffffffc0208098 <get_device>
ffffffffc02081c6:	842a                	mv	s0,a0
ffffffffc02081c8:	ed1d                	bnez	a0,ffffffffc0208206 <vfs_lookup+0x56>
ffffffffc02081ca:	67a2                	ld	a5,8(sp)
ffffffffc02081cc:	6962                	ld	s2,24(sp)
ffffffffc02081ce:	0007c783          	lbu	a5,0(a5)
ffffffffc02081d2:	c3a9                	beqz	a5,ffffffffc0208214 <vfs_lookup+0x64>
ffffffffc02081d4:	04090963          	beqz	s2,ffffffffc0208226 <vfs_lookup+0x76>
ffffffffc02081d8:	07093783          	ld	a5,112(s2)
ffffffffc02081dc:	c7a9                	beqz	a5,ffffffffc0208226 <vfs_lookup+0x76>
ffffffffc02081de:	7bbc                	ld	a5,112(a5)
ffffffffc02081e0:	c3b9                	beqz	a5,ffffffffc0208226 <vfs_lookup+0x76>
ffffffffc02081e2:	854a                	mv	a0,s2
ffffffffc02081e4:	00006597          	auipc	a1,0x6
ffffffffc02081e8:	5d458593          	addi	a1,a1,1492 # ffffffffc020e7b8 <syscalls+0xd40>
ffffffffc02081ec:	e06ff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02081f0:	07093783          	ld	a5,112(s2)
ffffffffc02081f4:	65a2                	ld	a1,8(sp)
ffffffffc02081f6:	6562                	ld	a0,24(sp)
ffffffffc02081f8:	7bbc                	ld	a5,112(a5)
ffffffffc02081fa:	8626                	mv	a2,s1
ffffffffc02081fc:	9782                	jalr	a5
ffffffffc02081fe:	842a                	mv	s0,a0
ffffffffc0208200:	6562                	ld	a0,24(sp)
ffffffffc0208202:	ea6ff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0208206:	70e2                	ld	ra,56(sp)
ffffffffc0208208:	8522                	mv	a0,s0
ffffffffc020820a:	7442                	ld	s0,48(sp)
ffffffffc020820c:	74a2                	ld	s1,40(sp)
ffffffffc020820e:	7902                	ld	s2,32(sp)
ffffffffc0208210:	6121                	addi	sp,sp,64
ffffffffc0208212:	8082                	ret
ffffffffc0208214:	70e2                	ld	ra,56(sp)
ffffffffc0208216:	8522                	mv	a0,s0
ffffffffc0208218:	7442                	ld	s0,48(sp)
ffffffffc020821a:	0124b023          	sd	s2,0(s1)
ffffffffc020821e:	74a2                	ld	s1,40(sp)
ffffffffc0208220:	7902                	ld	s2,32(sp)
ffffffffc0208222:	6121                	addi	sp,sp,64
ffffffffc0208224:	8082                	ret
ffffffffc0208226:	00006697          	auipc	a3,0x6
ffffffffc020822a:	54268693          	addi	a3,a3,1346 # ffffffffc020e768 <syscalls+0xcf0>
ffffffffc020822e:	00003617          	auipc	a2,0x3
ffffffffc0208232:	6da60613          	addi	a2,a2,1754 # ffffffffc020b908 <commands+0x210>
ffffffffc0208236:	04f00593          	li	a1,79
ffffffffc020823a:	00006517          	auipc	a0,0x6
ffffffffc020823e:	4fe50513          	addi	a0,a0,1278 # ffffffffc020e738 <syscalls+0xcc0>
ffffffffc0208242:	a5cf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208246 <vfs_lookup_parent>:
ffffffffc0208246:	7139                	addi	sp,sp,-64
ffffffffc0208248:	f822                	sd	s0,48(sp)
ffffffffc020824a:	f426                	sd	s1,40(sp)
ffffffffc020824c:	842e                	mv	s0,a1
ffffffffc020824e:	84b2                	mv	s1,a2
ffffffffc0208250:	002c                	addi	a1,sp,8
ffffffffc0208252:	0830                	addi	a2,sp,24
ffffffffc0208254:	fc06                	sd	ra,56(sp)
ffffffffc0208256:	e42a                	sd	a0,8(sp)
ffffffffc0208258:	e41ff0ef          	jal	ra,ffffffffc0208098 <get_device>
ffffffffc020825c:	e509                	bnez	a0,ffffffffc0208266 <vfs_lookup_parent+0x20>
ffffffffc020825e:	67a2                	ld	a5,8(sp)
ffffffffc0208260:	e09c                	sd	a5,0(s1)
ffffffffc0208262:	67e2                	ld	a5,24(sp)
ffffffffc0208264:	e01c                	sd	a5,0(s0)
ffffffffc0208266:	70e2                	ld	ra,56(sp)
ffffffffc0208268:	7442                	ld	s0,48(sp)
ffffffffc020826a:	74a2                	ld	s1,40(sp)
ffffffffc020826c:	6121                	addi	sp,sp,64
ffffffffc020826e:	8082                	ret

ffffffffc0208270 <vfs_get_curdir>:
ffffffffc0208270:	0008e797          	auipc	a5,0x8e
ffffffffc0208274:	6507b783          	ld	a5,1616(a5) # ffffffffc02968c0 <current>
ffffffffc0208278:	1487b783          	ld	a5,328(a5)
ffffffffc020827c:	1101                	addi	sp,sp,-32
ffffffffc020827e:	e426                	sd	s1,8(sp)
ffffffffc0208280:	6384                	ld	s1,0(a5)
ffffffffc0208282:	ec06                	sd	ra,24(sp)
ffffffffc0208284:	e822                	sd	s0,16(sp)
ffffffffc0208286:	cc81                	beqz	s1,ffffffffc020829e <vfs_get_curdir+0x2e>
ffffffffc0208288:	842a                	mv	s0,a0
ffffffffc020828a:	8526                	mv	a0,s1
ffffffffc020828c:	d4eff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0208290:	4501                	li	a0,0
ffffffffc0208292:	e004                	sd	s1,0(s0)
ffffffffc0208294:	60e2                	ld	ra,24(sp)
ffffffffc0208296:	6442                	ld	s0,16(sp)
ffffffffc0208298:	64a2                	ld	s1,8(sp)
ffffffffc020829a:	6105                	addi	sp,sp,32
ffffffffc020829c:	8082                	ret
ffffffffc020829e:	5541                	li	a0,-16
ffffffffc02082a0:	bfd5                	j	ffffffffc0208294 <vfs_get_curdir+0x24>

ffffffffc02082a2 <vfs_set_curdir>:
ffffffffc02082a2:	7139                	addi	sp,sp,-64
ffffffffc02082a4:	f04a                	sd	s2,32(sp)
ffffffffc02082a6:	0008e917          	auipc	s2,0x8e
ffffffffc02082aa:	61a90913          	addi	s2,s2,1562 # ffffffffc02968c0 <current>
ffffffffc02082ae:	00093783          	ld	a5,0(s2)
ffffffffc02082b2:	f822                	sd	s0,48(sp)
ffffffffc02082b4:	842a                	mv	s0,a0
ffffffffc02082b6:	1487b503          	ld	a0,328(a5)
ffffffffc02082ba:	ec4e                	sd	s3,24(sp)
ffffffffc02082bc:	fc06                	sd	ra,56(sp)
ffffffffc02082be:	f426                	sd	s1,40(sp)
ffffffffc02082c0:	f03fc0ef          	jal	ra,ffffffffc02051c2 <lock_files>
ffffffffc02082c4:	00093783          	ld	a5,0(s2)
ffffffffc02082c8:	1487b503          	ld	a0,328(a5)
ffffffffc02082cc:	00053983          	ld	s3,0(a0)
ffffffffc02082d0:	07340963          	beq	s0,s3,ffffffffc0208342 <vfs_set_curdir+0xa0>
ffffffffc02082d4:	cc39                	beqz	s0,ffffffffc0208332 <vfs_set_curdir+0x90>
ffffffffc02082d6:	783c                	ld	a5,112(s0)
ffffffffc02082d8:	c7bd                	beqz	a5,ffffffffc0208346 <vfs_set_curdir+0xa4>
ffffffffc02082da:	6bbc                	ld	a5,80(a5)
ffffffffc02082dc:	c7ad                	beqz	a5,ffffffffc0208346 <vfs_set_curdir+0xa4>
ffffffffc02082de:	00006597          	auipc	a1,0x6
ffffffffc02082e2:	54a58593          	addi	a1,a1,1354 # ffffffffc020e828 <syscalls+0xdb0>
ffffffffc02082e6:	8522                	mv	a0,s0
ffffffffc02082e8:	d0aff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02082ec:	783c                	ld	a5,112(s0)
ffffffffc02082ee:	006c                	addi	a1,sp,12
ffffffffc02082f0:	8522                	mv	a0,s0
ffffffffc02082f2:	6bbc                	ld	a5,80(a5)
ffffffffc02082f4:	9782                	jalr	a5
ffffffffc02082f6:	84aa                	mv	s1,a0
ffffffffc02082f8:	e901                	bnez	a0,ffffffffc0208308 <vfs_set_curdir+0x66>
ffffffffc02082fa:	47b2                	lw	a5,12(sp)
ffffffffc02082fc:	669d                	lui	a3,0x7
ffffffffc02082fe:	6709                	lui	a4,0x2
ffffffffc0208300:	8ff5                	and	a5,a5,a3
ffffffffc0208302:	54b9                	li	s1,-18
ffffffffc0208304:	02e78063          	beq	a5,a4,ffffffffc0208324 <vfs_set_curdir+0x82>
ffffffffc0208308:	00093783          	ld	a5,0(s2)
ffffffffc020830c:	1487b503          	ld	a0,328(a5)
ffffffffc0208310:	eb9fc0ef          	jal	ra,ffffffffc02051c8 <unlock_files>
ffffffffc0208314:	70e2                	ld	ra,56(sp)
ffffffffc0208316:	7442                	ld	s0,48(sp)
ffffffffc0208318:	7902                	ld	s2,32(sp)
ffffffffc020831a:	69e2                	ld	s3,24(sp)
ffffffffc020831c:	8526                	mv	a0,s1
ffffffffc020831e:	74a2                	ld	s1,40(sp)
ffffffffc0208320:	6121                	addi	sp,sp,64
ffffffffc0208322:	8082                	ret
ffffffffc0208324:	8522                	mv	a0,s0
ffffffffc0208326:	cb4ff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc020832a:	00093783          	ld	a5,0(s2)
ffffffffc020832e:	1487b503          	ld	a0,328(a5)
ffffffffc0208332:	e100                	sd	s0,0(a0)
ffffffffc0208334:	4481                	li	s1,0
ffffffffc0208336:	fc098de3          	beqz	s3,ffffffffc0208310 <vfs_set_curdir+0x6e>
ffffffffc020833a:	854e                	mv	a0,s3
ffffffffc020833c:	d6cff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc0208340:	b7e1                	j	ffffffffc0208308 <vfs_set_curdir+0x66>
ffffffffc0208342:	4481                	li	s1,0
ffffffffc0208344:	b7f1                	j	ffffffffc0208310 <vfs_set_curdir+0x6e>
ffffffffc0208346:	00006697          	auipc	a3,0x6
ffffffffc020834a:	47a68693          	addi	a3,a3,1146 # ffffffffc020e7c0 <syscalls+0xd48>
ffffffffc020834e:	00003617          	auipc	a2,0x3
ffffffffc0208352:	5ba60613          	addi	a2,a2,1466 # ffffffffc020b908 <commands+0x210>
ffffffffc0208356:	04300593          	li	a1,67
ffffffffc020835a:	00006517          	auipc	a0,0x6
ffffffffc020835e:	4b650513          	addi	a0,a0,1206 # ffffffffc020e810 <syscalls+0xd98>
ffffffffc0208362:	93cf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208366 <vfs_chdir>:
ffffffffc0208366:	1101                	addi	sp,sp,-32
ffffffffc0208368:	002c                	addi	a1,sp,8
ffffffffc020836a:	e822                	sd	s0,16(sp)
ffffffffc020836c:	ec06                	sd	ra,24(sp)
ffffffffc020836e:	e43ff0ef          	jal	ra,ffffffffc02081b0 <vfs_lookup>
ffffffffc0208372:	842a                	mv	s0,a0
ffffffffc0208374:	c511                	beqz	a0,ffffffffc0208380 <vfs_chdir+0x1a>
ffffffffc0208376:	60e2                	ld	ra,24(sp)
ffffffffc0208378:	8522                	mv	a0,s0
ffffffffc020837a:	6442                	ld	s0,16(sp)
ffffffffc020837c:	6105                	addi	sp,sp,32
ffffffffc020837e:	8082                	ret
ffffffffc0208380:	6522                	ld	a0,8(sp)
ffffffffc0208382:	f21ff0ef          	jal	ra,ffffffffc02082a2 <vfs_set_curdir>
ffffffffc0208386:	842a                	mv	s0,a0
ffffffffc0208388:	6522                	ld	a0,8(sp)
ffffffffc020838a:	d1eff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020838e:	60e2                	ld	ra,24(sp)
ffffffffc0208390:	8522                	mv	a0,s0
ffffffffc0208392:	6442                	ld	s0,16(sp)
ffffffffc0208394:	6105                	addi	sp,sp,32
ffffffffc0208396:	8082                	ret

ffffffffc0208398 <vfs_getcwd>:
ffffffffc0208398:	0008e797          	auipc	a5,0x8e
ffffffffc020839c:	5287b783          	ld	a5,1320(a5) # ffffffffc02968c0 <current>
ffffffffc02083a0:	1487b783          	ld	a5,328(a5)
ffffffffc02083a4:	7179                	addi	sp,sp,-48
ffffffffc02083a6:	ec26                	sd	s1,24(sp)
ffffffffc02083a8:	6384                	ld	s1,0(a5)
ffffffffc02083aa:	f406                	sd	ra,40(sp)
ffffffffc02083ac:	f022                	sd	s0,32(sp)
ffffffffc02083ae:	e84a                	sd	s2,16(sp)
ffffffffc02083b0:	ccbd                	beqz	s1,ffffffffc020842e <vfs_getcwd+0x96>
ffffffffc02083b2:	892a                	mv	s2,a0
ffffffffc02083b4:	8526                	mv	a0,s1
ffffffffc02083b6:	c24ff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc02083ba:	74a8                	ld	a0,104(s1)
ffffffffc02083bc:	c93d                	beqz	a0,ffffffffc0208432 <vfs_getcwd+0x9a>
ffffffffc02083be:	9b3ff0ef          	jal	ra,ffffffffc0207d70 <vfs_get_devname>
ffffffffc02083c2:	842a                	mv	s0,a0
ffffffffc02083c4:	7bf020ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc02083c8:	862a                	mv	a2,a0
ffffffffc02083ca:	85a2                	mv	a1,s0
ffffffffc02083cc:	4701                	li	a4,0
ffffffffc02083ce:	4685                	li	a3,1
ffffffffc02083d0:	854a                	mv	a0,s2
ffffffffc02083d2:	81afd0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc02083d6:	842a                	mv	s0,a0
ffffffffc02083d8:	c919                	beqz	a0,ffffffffc02083ee <vfs_getcwd+0x56>
ffffffffc02083da:	8526                	mv	a0,s1
ffffffffc02083dc:	cccff0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc02083e0:	70a2                	ld	ra,40(sp)
ffffffffc02083e2:	8522                	mv	a0,s0
ffffffffc02083e4:	7402                	ld	s0,32(sp)
ffffffffc02083e6:	64e2                	ld	s1,24(sp)
ffffffffc02083e8:	6942                	ld	s2,16(sp)
ffffffffc02083ea:	6145                	addi	sp,sp,48
ffffffffc02083ec:	8082                	ret
ffffffffc02083ee:	03a00793          	li	a5,58
ffffffffc02083f2:	4701                	li	a4,0
ffffffffc02083f4:	4685                	li	a3,1
ffffffffc02083f6:	4605                	li	a2,1
ffffffffc02083f8:	00f10593          	addi	a1,sp,15
ffffffffc02083fc:	854a                	mv	a0,s2
ffffffffc02083fe:	00f107a3          	sb	a5,15(sp)
ffffffffc0208402:	febfc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc0208406:	842a                	mv	s0,a0
ffffffffc0208408:	f969                	bnez	a0,ffffffffc02083da <vfs_getcwd+0x42>
ffffffffc020840a:	78bc                	ld	a5,112(s1)
ffffffffc020840c:	c3b9                	beqz	a5,ffffffffc0208452 <vfs_getcwd+0xba>
ffffffffc020840e:	7f9c                	ld	a5,56(a5)
ffffffffc0208410:	c3a9                	beqz	a5,ffffffffc0208452 <vfs_getcwd+0xba>
ffffffffc0208412:	00006597          	auipc	a1,0x6
ffffffffc0208416:	47658593          	addi	a1,a1,1142 # ffffffffc020e888 <syscalls+0xe10>
ffffffffc020841a:	8526                	mv	a0,s1
ffffffffc020841c:	bd6ff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0208420:	78bc                	ld	a5,112(s1)
ffffffffc0208422:	85ca                	mv	a1,s2
ffffffffc0208424:	8526                	mv	a0,s1
ffffffffc0208426:	7f9c                	ld	a5,56(a5)
ffffffffc0208428:	9782                	jalr	a5
ffffffffc020842a:	842a                	mv	s0,a0
ffffffffc020842c:	b77d                	j	ffffffffc02083da <vfs_getcwd+0x42>
ffffffffc020842e:	5441                	li	s0,-16
ffffffffc0208430:	bf45                	j	ffffffffc02083e0 <vfs_getcwd+0x48>
ffffffffc0208432:	00006697          	auipc	a3,0x6
ffffffffc0208436:	31e68693          	addi	a3,a3,798 # ffffffffc020e750 <syscalls+0xcd8>
ffffffffc020843a:	00003617          	auipc	a2,0x3
ffffffffc020843e:	4ce60613          	addi	a2,a2,1230 # ffffffffc020b908 <commands+0x210>
ffffffffc0208442:	06e00593          	li	a1,110
ffffffffc0208446:	00006517          	auipc	a0,0x6
ffffffffc020844a:	3ca50513          	addi	a0,a0,970 # ffffffffc020e810 <syscalls+0xd98>
ffffffffc020844e:	850f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208452:	00006697          	auipc	a3,0x6
ffffffffc0208456:	3de68693          	addi	a3,a3,990 # ffffffffc020e830 <syscalls+0xdb8>
ffffffffc020845a:	00003617          	auipc	a2,0x3
ffffffffc020845e:	4ae60613          	addi	a2,a2,1198 # ffffffffc020b908 <commands+0x210>
ffffffffc0208462:	07800593          	li	a1,120
ffffffffc0208466:	00006517          	auipc	a0,0x6
ffffffffc020846a:	3aa50513          	addi	a0,a0,938 # ffffffffc020e810 <syscalls+0xd98>
ffffffffc020846e:	830f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208472 <dev_lookup>:
ffffffffc0208472:	0005c783          	lbu	a5,0(a1)
ffffffffc0208476:	e385                	bnez	a5,ffffffffc0208496 <dev_lookup+0x24>
ffffffffc0208478:	1101                	addi	sp,sp,-32
ffffffffc020847a:	e822                	sd	s0,16(sp)
ffffffffc020847c:	e426                	sd	s1,8(sp)
ffffffffc020847e:	ec06                	sd	ra,24(sp)
ffffffffc0208480:	84aa                	mv	s1,a0
ffffffffc0208482:	8432                	mv	s0,a2
ffffffffc0208484:	b56ff0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc0208488:	60e2                	ld	ra,24(sp)
ffffffffc020848a:	e004                	sd	s1,0(s0)
ffffffffc020848c:	6442                	ld	s0,16(sp)
ffffffffc020848e:	64a2                	ld	s1,8(sp)
ffffffffc0208490:	4501                	li	a0,0
ffffffffc0208492:	6105                	addi	sp,sp,32
ffffffffc0208494:	8082                	ret
ffffffffc0208496:	5541                	li	a0,-16
ffffffffc0208498:	8082                	ret

ffffffffc020849a <dev_fstat>:
ffffffffc020849a:	1101                	addi	sp,sp,-32
ffffffffc020849c:	e426                	sd	s1,8(sp)
ffffffffc020849e:	84ae                	mv	s1,a1
ffffffffc02084a0:	e822                	sd	s0,16(sp)
ffffffffc02084a2:	02000613          	li	a2,32
ffffffffc02084a6:	842a                	mv	s0,a0
ffffffffc02084a8:	4581                	li	a1,0
ffffffffc02084aa:	8526                	mv	a0,s1
ffffffffc02084ac:	ec06                	sd	ra,24(sp)
ffffffffc02084ae:	777020ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc02084b2:	c429                	beqz	s0,ffffffffc02084fc <dev_fstat+0x62>
ffffffffc02084b4:	783c                	ld	a5,112(s0)
ffffffffc02084b6:	c3b9                	beqz	a5,ffffffffc02084fc <dev_fstat+0x62>
ffffffffc02084b8:	6bbc                	ld	a5,80(a5)
ffffffffc02084ba:	c3a9                	beqz	a5,ffffffffc02084fc <dev_fstat+0x62>
ffffffffc02084bc:	00006597          	auipc	a1,0x6
ffffffffc02084c0:	36c58593          	addi	a1,a1,876 # ffffffffc020e828 <syscalls+0xdb0>
ffffffffc02084c4:	8522                	mv	a0,s0
ffffffffc02084c6:	b2cff0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02084ca:	783c                	ld	a5,112(s0)
ffffffffc02084cc:	85a6                	mv	a1,s1
ffffffffc02084ce:	8522                	mv	a0,s0
ffffffffc02084d0:	6bbc                	ld	a5,80(a5)
ffffffffc02084d2:	9782                	jalr	a5
ffffffffc02084d4:	ed19                	bnez	a0,ffffffffc02084f2 <dev_fstat+0x58>
ffffffffc02084d6:	4c38                	lw	a4,88(s0)
ffffffffc02084d8:	6785                	lui	a5,0x1
ffffffffc02084da:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02084de:	02f71f63          	bne	a4,a5,ffffffffc020851c <dev_fstat+0x82>
ffffffffc02084e2:	6018                	ld	a4,0(s0)
ffffffffc02084e4:	641c                	ld	a5,8(s0)
ffffffffc02084e6:	4685                	li	a3,1
ffffffffc02084e8:	e494                	sd	a3,8(s1)
ffffffffc02084ea:	02e787b3          	mul	a5,a5,a4
ffffffffc02084ee:	e898                	sd	a4,16(s1)
ffffffffc02084f0:	ec9c                	sd	a5,24(s1)
ffffffffc02084f2:	60e2                	ld	ra,24(sp)
ffffffffc02084f4:	6442                	ld	s0,16(sp)
ffffffffc02084f6:	64a2                	ld	s1,8(sp)
ffffffffc02084f8:	6105                	addi	sp,sp,32
ffffffffc02084fa:	8082                	ret
ffffffffc02084fc:	00006697          	auipc	a3,0x6
ffffffffc0208500:	2c468693          	addi	a3,a3,708 # ffffffffc020e7c0 <syscalls+0xd48>
ffffffffc0208504:	00003617          	auipc	a2,0x3
ffffffffc0208508:	40460613          	addi	a2,a2,1028 # ffffffffc020b908 <commands+0x210>
ffffffffc020850c:	04200593          	li	a1,66
ffffffffc0208510:	00006517          	auipc	a0,0x6
ffffffffc0208514:	38850513          	addi	a0,a0,904 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc0208518:	f87f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020851c:	00006697          	auipc	a3,0x6
ffffffffc0208520:	06c68693          	addi	a3,a3,108 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208524:	00003617          	auipc	a2,0x3
ffffffffc0208528:	3e460613          	addi	a2,a2,996 # ffffffffc020b908 <commands+0x210>
ffffffffc020852c:	04500593          	li	a1,69
ffffffffc0208530:	00006517          	auipc	a0,0x6
ffffffffc0208534:	36850513          	addi	a0,a0,872 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc0208538:	f67f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020853c <dev_ioctl>:
ffffffffc020853c:	c909                	beqz	a0,ffffffffc020854e <dev_ioctl+0x12>
ffffffffc020853e:	4d34                	lw	a3,88(a0)
ffffffffc0208540:	6705                	lui	a4,0x1
ffffffffc0208542:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208546:	00e69463          	bne	a3,a4,ffffffffc020854e <dev_ioctl+0x12>
ffffffffc020854a:	751c                	ld	a5,40(a0)
ffffffffc020854c:	8782                	jr	a5
ffffffffc020854e:	1141                	addi	sp,sp,-16
ffffffffc0208550:	00006697          	auipc	a3,0x6
ffffffffc0208554:	03868693          	addi	a3,a3,56 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208558:	00003617          	auipc	a2,0x3
ffffffffc020855c:	3b060613          	addi	a2,a2,944 # ffffffffc020b908 <commands+0x210>
ffffffffc0208560:	03500593          	li	a1,53
ffffffffc0208564:	00006517          	auipc	a0,0x6
ffffffffc0208568:	33450513          	addi	a0,a0,820 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc020856c:	e406                	sd	ra,8(sp)
ffffffffc020856e:	f31f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208572 <dev_tryseek>:
ffffffffc0208572:	c51d                	beqz	a0,ffffffffc02085a0 <dev_tryseek+0x2e>
ffffffffc0208574:	4d38                	lw	a4,88(a0)
ffffffffc0208576:	6785                	lui	a5,0x1
ffffffffc0208578:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020857c:	02f71263          	bne	a4,a5,ffffffffc02085a0 <dev_tryseek+0x2e>
ffffffffc0208580:	611c                	ld	a5,0(a0)
ffffffffc0208582:	cf89                	beqz	a5,ffffffffc020859c <dev_tryseek+0x2a>
ffffffffc0208584:	6518                	ld	a4,8(a0)
ffffffffc0208586:	02e5f6b3          	remu	a3,a1,a4
ffffffffc020858a:	ea89                	bnez	a3,ffffffffc020859c <dev_tryseek+0x2a>
ffffffffc020858c:	0005c863          	bltz	a1,ffffffffc020859c <dev_tryseek+0x2a>
ffffffffc0208590:	02e787b3          	mul	a5,a5,a4
ffffffffc0208594:	00f5f463          	bgeu	a1,a5,ffffffffc020859c <dev_tryseek+0x2a>
ffffffffc0208598:	4501                	li	a0,0
ffffffffc020859a:	8082                	ret
ffffffffc020859c:	5575                	li	a0,-3
ffffffffc020859e:	8082                	ret
ffffffffc02085a0:	1141                	addi	sp,sp,-16
ffffffffc02085a2:	00006697          	auipc	a3,0x6
ffffffffc02085a6:	fe668693          	addi	a3,a3,-26 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc02085aa:	00003617          	auipc	a2,0x3
ffffffffc02085ae:	35e60613          	addi	a2,a2,862 # ffffffffc020b908 <commands+0x210>
ffffffffc02085b2:	05f00593          	li	a1,95
ffffffffc02085b6:	00006517          	auipc	a0,0x6
ffffffffc02085ba:	2e250513          	addi	a0,a0,738 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc02085be:	e406                	sd	ra,8(sp)
ffffffffc02085c0:	edff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02085c4 <dev_gettype>:
ffffffffc02085c4:	c10d                	beqz	a0,ffffffffc02085e6 <dev_gettype+0x22>
ffffffffc02085c6:	4d38                	lw	a4,88(a0)
ffffffffc02085c8:	6785                	lui	a5,0x1
ffffffffc02085ca:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085ce:	00f71c63          	bne	a4,a5,ffffffffc02085e6 <dev_gettype+0x22>
ffffffffc02085d2:	6118                	ld	a4,0(a0)
ffffffffc02085d4:	6795                	lui	a5,0x5
ffffffffc02085d6:	c701                	beqz	a4,ffffffffc02085de <dev_gettype+0x1a>
ffffffffc02085d8:	c19c                	sw	a5,0(a1)
ffffffffc02085da:	4501                	li	a0,0
ffffffffc02085dc:	8082                	ret
ffffffffc02085de:	6791                	lui	a5,0x4
ffffffffc02085e0:	c19c                	sw	a5,0(a1)
ffffffffc02085e2:	4501                	li	a0,0
ffffffffc02085e4:	8082                	ret
ffffffffc02085e6:	1141                	addi	sp,sp,-16
ffffffffc02085e8:	00006697          	auipc	a3,0x6
ffffffffc02085ec:	fa068693          	addi	a3,a3,-96 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc02085f0:	00003617          	auipc	a2,0x3
ffffffffc02085f4:	31860613          	addi	a2,a2,792 # ffffffffc020b908 <commands+0x210>
ffffffffc02085f8:	05300593          	li	a1,83
ffffffffc02085fc:	00006517          	auipc	a0,0x6
ffffffffc0208600:	29c50513          	addi	a0,a0,668 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc0208604:	e406                	sd	ra,8(sp)
ffffffffc0208606:	e99f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020860a <dev_write>:
ffffffffc020860a:	c911                	beqz	a0,ffffffffc020861e <dev_write+0x14>
ffffffffc020860c:	4d34                	lw	a3,88(a0)
ffffffffc020860e:	6705                	lui	a4,0x1
ffffffffc0208610:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208614:	00e69563          	bne	a3,a4,ffffffffc020861e <dev_write+0x14>
ffffffffc0208618:	711c                	ld	a5,32(a0)
ffffffffc020861a:	4605                	li	a2,1
ffffffffc020861c:	8782                	jr	a5
ffffffffc020861e:	1141                	addi	sp,sp,-16
ffffffffc0208620:	00006697          	auipc	a3,0x6
ffffffffc0208624:	f6868693          	addi	a3,a3,-152 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208628:	00003617          	auipc	a2,0x3
ffffffffc020862c:	2e060613          	addi	a2,a2,736 # ffffffffc020b908 <commands+0x210>
ffffffffc0208630:	02c00593          	li	a1,44
ffffffffc0208634:	00006517          	auipc	a0,0x6
ffffffffc0208638:	26450513          	addi	a0,a0,612 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc020863c:	e406                	sd	ra,8(sp)
ffffffffc020863e:	e61f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208642 <dev_read>:
ffffffffc0208642:	c911                	beqz	a0,ffffffffc0208656 <dev_read+0x14>
ffffffffc0208644:	4d34                	lw	a3,88(a0)
ffffffffc0208646:	6705                	lui	a4,0x1
ffffffffc0208648:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020864c:	00e69563          	bne	a3,a4,ffffffffc0208656 <dev_read+0x14>
ffffffffc0208650:	711c                	ld	a5,32(a0)
ffffffffc0208652:	4601                	li	a2,0
ffffffffc0208654:	8782                	jr	a5
ffffffffc0208656:	1141                	addi	sp,sp,-16
ffffffffc0208658:	00006697          	auipc	a3,0x6
ffffffffc020865c:	f3068693          	addi	a3,a3,-208 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208660:	00003617          	auipc	a2,0x3
ffffffffc0208664:	2a860613          	addi	a2,a2,680 # ffffffffc020b908 <commands+0x210>
ffffffffc0208668:	02300593          	li	a1,35
ffffffffc020866c:	00006517          	auipc	a0,0x6
ffffffffc0208670:	22c50513          	addi	a0,a0,556 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc0208674:	e406                	sd	ra,8(sp)
ffffffffc0208676:	e29f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020867a <dev_close>:
ffffffffc020867a:	c909                	beqz	a0,ffffffffc020868c <dev_close+0x12>
ffffffffc020867c:	4d34                	lw	a3,88(a0)
ffffffffc020867e:	6705                	lui	a4,0x1
ffffffffc0208680:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208684:	00e69463          	bne	a3,a4,ffffffffc020868c <dev_close+0x12>
ffffffffc0208688:	6d1c                	ld	a5,24(a0)
ffffffffc020868a:	8782                	jr	a5
ffffffffc020868c:	1141                	addi	sp,sp,-16
ffffffffc020868e:	00006697          	auipc	a3,0x6
ffffffffc0208692:	efa68693          	addi	a3,a3,-262 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208696:	00003617          	auipc	a2,0x3
ffffffffc020869a:	27260613          	addi	a2,a2,626 # ffffffffc020b908 <commands+0x210>
ffffffffc020869e:	45e9                	li	a1,26
ffffffffc02086a0:	00006517          	auipc	a0,0x6
ffffffffc02086a4:	1f850513          	addi	a0,a0,504 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc02086a8:	e406                	sd	ra,8(sp)
ffffffffc02086aa:	df5f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086ae <dev_open>:
ffffffffc02086ae:	03c5f713          	andi	a4,a1,60
ffffffffc02086b2:	eb11                	bnez	a4,ffffffffc02086c6 <dev_open+0x18>
ffffffffc02086b4:	c919                	beqz	a0,ffffffffc02086ca <dev_open+0x1c>
ffffffffc02086b6:	4d34                	lw	a3,88(a0)
ffffffffc02086b8:	6705                	lui	a4,0x1
ffffffffc02086ba:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086be:	00e69663          	bne	a3,a4,ffffffffc02086ca <dev_open+0x1c>
ffffffffc02086c2:	691c                	ld	a5,16(a0)
ffffffffc02086c4:	8782                	jr	a5
ffffffffc02086c6:	5575                	li	a0,-3
ffffffffc02086c8:	8082                	ret
ffffffffc02086ca:	1141                	addi	sp,sp,-16
ffffffffc02086cc:	00006697          	auipc	a3,0x6
ffffffffc02086d0:	ebc68693          	addi	a3,a3,-324 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc02086d4:	00003617          	auipc	a2,0x3
ffffffffc02086d8:	23460613          	addi	a2,a2,564 # ffffffffc020b908 <commands+0x210>
ffffffffc02086dc:	45c5                	li	a1,17
ffffffffc02086de:	00006517          	auipc	a0,0x6
ffffffffc02086e2:	1ba50513          	addi	a0,a0,442 # ffffffffc020e898 <syscalls+0xe20>
ffffffffc02086e6:	e406                	sd	ra,8(sp)
ffffffffc02086e8:	db7f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086ec <dev_init>:
ffffffffc02086ec:	1141                	addi	sp,sp,-16
ffffffffc02086ee:	e406                	sd	ra,8(sp)
ffffffffc02086f0:	542000ef          	jal	ra,ffffffffc0208c32 <dev_init_stdin>
ffffffffc02086f4:	65a000ef          	jal	ra,ffffffffc0208d4e <dev_init_stdout>
ffffffffc02086f8:	60a2                	ld	ra,8(sp)
ffffffffc02086fa:	0141                	addi	sp,sp,16
ffffffffc02086fc:	a439                	j	ffffffffc020890a <dev_init_disk0>

ffffffffc02086fe <dev_create_inode>:
ffffffffc02086fe:	6505                	lui	a0,0x1
ffffffffc0208700:	1141                	addi	sp,sp,-16
ffffffffc0208702:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208706:	e022                	sd	s0,0(sp)
ffffffffc0208708:	e406                	sd	ra,8(sp)
ffffffffc020870a:	852ff0ef          	jal	ra,ffffffffc020775c <__alloc_inode>
ffffffffc020870e:	842a                	mv	s0,a0
ffffffffc0208710:	c901                	beqz	a0,ffffffffc0208720 <dev_create_inode+0x22>
ffffffffc0208712:	4601                	li	a2,0
ffffffffc0208714:	00006597          	auipc	a1,0x6
ffffffffc0208718:	19c58593          	addi	a1,a1,412 # ffffffffc020e8b0 <dev_node_ops>
ffffffffc020871c:	85cff0ef          	jal	ra,ffffffffc0207778 <inode_init>
ffffffffc0208720:	60a2                	ld	ra,8(sp)
ffffffffc0208722:	8522                	mv	a0,s0
ffffffffc0208724:	6402                	ld	s0,0(sp)
ffffffffc0208726:	0141                	addi	sp,sp,16
ffffffffc0208728:	8082                	ret

ffffffffc020872a <disk0_open>:
ffffffffc020872a:	4501                	li	a0,0
ffffffffc020872c:	8082                	ret

ffffffffc020872e <disk0_close>:
ffffffffc020872e:	4501                	li	a0,0
ffffffffc0208730:	8082                	ret

ffffffffc0208732 <disk0_ioctl>:
ffffffffc0208732:	5531                	li	a0,-20
ffffffffc0208734:	8082                	ret

ffffffffc0208736 <disk0_io>:
ffffffffc0208736:	659c                	ld	a5,8(a1)
ffffffffc0208738:	7159                	addi	sp,sp,-112
ffffffffc020873a:	eca6                	sd	s1,88(sp)
ffffffffc020873c:	f45e                	sd	s7,40(sp)
ffffffffc020873e:	6d84                	ld	s1,24(a1)
ffffffffc0208740:	6b85                	lui	s7,0x1
ffffffffc0208742:	1bfd                	addi	s7,s7,-1
ffffffffc0208744:	e4ce                	sd	s3,72(sp)
ffffffffc0208746:	43f7d993          	srai	s3,a5,0x3f
ffffffffc020874a:	0179f9b3          	and	s3,s3,s7
ffffffffc020874e:	99be                	add	s3,s3,a5
ffffffffc0208750:	8fc5                	or	a5,a5,s1
ffffffffc0208752:	f486                	sd	ra,104(sp)
ffffffffc0208754:	f0a2                	sd	s0,96(sp)
ffffffffc0208756:	e8ca                	sd	s2,80(sp)
ffffffffc0208758:	e0d2                	sd	s4,64(sp)
ffffffffc020875a:	fc56                	sd	s5,56(sp)
ffffffffc020875c:	f85a                	sd	s6,48(sp)
ffffffffc020875e:	f062                	sd	s8,32(sp)
ffffffffc0208760:	ec66                	sd	s9,24(sp)
ffffffffc0208762:	e86a                	sd	s10,16(sp)
ffffffffc0208764:	0177f7b3          	and	a5,a5,s7
ffffffffc0208768:	10079d63          	bnez	a5,ffffffffc0208882 <disk0_io+0x14c>
ffffffffc020876c:	40c9d993          	srai	s3,s3,0xc
ffffffffc0208770:	00c4d713          	srli	a4,s1,0xc
ffffffffc0208774:	2981                	sext.w	s3,s3
ffffffffc0208776:	2701                	sext.w	a4,a4
ffffffffc0208778:	00e987bb          	addw	a5,s3,a4
ffffffffc020877c:	6114                	ld	a3,0(a0)
ffffffffc020877e:	1782                	slli	a5,a5,0x20
ffffffffc0208780:	9381                	srli	a5,a5,0x20
ffffffffc0208782:	10f6e063          	bltu	a3,a5,ffffffffc0208882 <disk0_io+0x14c>
ffffffffc0208786:	4501                	li	a0,0
ffffffffc0208788:	ef19                	bnez	a4,ffffffffc02087a6 <disk0_io+0x70>
ffffffffc020878a:	70a6                	ld	ra,104(sp)
ffffffffc020878c:	7406                	ld	s0,96(sp)
ffffffffc020878e:	64e6                	ld	s1,88(sp)
ffffffffc0208790:	6946                	ld	s2,80(sp)
ffffffffc0208792:	69a6                	ld	s3,72(sp)
ffffffffc0208794:	6a06                	ld	s4,64(sp)
ffffffffc0208796:	7ae2                	ld	s5,56(sp)
ffffffffc0208798:	7b42                	ld	s6,48(sp)
ffffffffc020879a:	7ba2                	ld	s7,40(sp)
ffffffffc020879c:	7c02                	ld	s8,32(sp)
ffffffffc020879e:	6ce2                	ld	s9,24(sp)
ffffffffc02087a0:	6d42                	ld	s10,16(sp)
ffffffffc02087a2:	6165                	addi	sp,sp,112
ffffffffc02087a4:	8082                	ret
ffffffffc02087a6:	0008d517          	auipc	a0,0x8d
ffffffffc02087aa:	09a50513          	addi	a0,a0,154 # ffffffffc0295840 <disk0_sem>
ffffffffc02087ae:	8b2e                	mv	s6,a1
ffffffffc02087b0:	8c32                	mv	s8,a2
ffffffffc02087b2:	0008ea97          	auipc	s5,0x8e
ffffffffc02087b6:	146a8a93          	addi	s5,s5,326 # ffffffffc02968f8 <disk0_buffer>
ffffffffc02087ba:	dabfb0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02087be:	6c91                	lui	s9,0x4
ffffffffc02087c0:	e4b9                	bnez	s1,ffffffffc020880e <disk0_io+0xd8>
ffffffffc02087c2:	a845                	j	ffffffffc0208872 <disk0_io+0x13c>
ffffffffc02087c4:	00c4d413          	srli	s0,s1,0xc
ffffffffc02087c8:	0034169b          	slliw	a3,s0,0x3
ffffffffc02087cc:	00068d1b          	sext.w	s10,a3
ffffffffc02087d0:	1682                	slli	a3,a3,0x20
ffffffffc02087d2:	2401                	sext.w	s0,s0
ffffffffc02087d4:	9281                	srli	a3,a3,0x20
ffffffffc02087d6:	8926                	mv	s2,s1
ffffffffc02087d8:	00399a1b          	slliw	s4,s3,0x3
ffffffffc02087dc:	862e                	mv	a2,a1
ffffffffc02087de:	4509                	li	a0,2
ffffffffc02087e0:	85d2                	mv	a1,s4
ffffffffc02087e2:	b5ef80ef          	jal	ra,ffffffffc0200b40 <ide_read_secs>
ffffffffc02087e6:	e165                	bnez	a0,ffffffffc02088c6 <disk0_io+0x190>
ffffffffc02087e8:	000ab583          	ld	a1,0(s5)
ffffffffc02087ec:	0038                	addi	a4,sp,8
ffffffffc02087ee:	4685                	li	a3,1
ffffffffc02087f0:	864a                	mv	a2,s2
ffffffffc02087f2:	855a                	mv	a0,s6
ffffffffc02087f4:	bf9fc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc02087f8:	67a2                	ld	a5,8(sp)
ffffffffc02087fa:	09279663          	bne	a5,s2,ffffffffc0208886 <disk0_io+0x150>
ffffffffc02087fe:	017977b3          	and	a5,s2,s7
ffffffffc0208802:	e3d1                	bnez	a5,ffffffffc0208886 <disk0_io+0x150>
ffffffffc0208804:	412484b3          	sub	s1,s1,s2
ffffffffc0208808:	013409bb          	addw	s3,s0,s3
ffffffffc020880c:	c0bd                	beqz	s1,ffffffffc0208872 <disk0_io+0x13c>
ffffffffc020880e:	000ab583          	ld	a1,0(s5)
ffffffffc0208812:	000c1b63          	bnez	s8,ffffffffc0208828 <disk0_io+0xf2>
ffffffffc0208816:	fb94e7e3          	bltu	s1,s9,ffffffffc02087c4 <disk0_io+0x8e>
ffffffffc020881a:	02000693          	li	a3,32
ffffffffc020881e:	02000d13          	li	s10,32
ffffffffc0208822:	4411                	li	s0,4
ffffffffc0208824:	6911                	lui	s2,0x4
ffffffffc0208826:	bf4d                	j	ffffffffc02087d8 <disk0_io+0xa2>
ffffffffc0208828:	0038                	addi	a4,sp,8
ffffffffc020882a:	4681                	li	a3,0
ffffffffc020882c:	6611                	lui	a2,0x4
ffffffffc020882e:	855a                	mv	a0,s6
ffffffffc0208830:	bbdfc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc0208834:	6422                	ld	s0,8(sp)
ffffffffc0208836:	c825                	beqz	s0,ffffffffc02088a6 <disk0_io+0x170>
ffffffffc0208838:	0684e763          	bltu	s1,s0,ffffffffc02088a6 <disk0_io+0x170>
ffffffffc020883c:	017477b3          	and	a5,s0,s7
ffffffffc0208840:	e3bd                	bnez	a5,ffffffffc02088a6 <disk0_io+0x170>
ffffffffc0208842:	8031                	srli	s0,s0,0xc
ffffffffc0208844:	0034179b          	slliw	a5,s0,0x3
ffffffffc0208848:	000ab603          	ld	a2,0(s5)
ffffffffc020884c:	0039991b          	slliw	s2,s3,0x3
ffffffffc0208850:	02079693          	slli	a3,a5,0x20
ffffffffc0208854:	9281                	srli	a3,a3,0x20
ffffffffc0208856:	85ca                	mv	a1,s2
ffffffffc0208858:	4509                	li	a0,2
ffffffffc020885a:	2401                	sext.w	s0,s0
ffffffffc020885c:	00078a1b          	sext.w	s4,a5
ffffffffc0208860:	b76f80ef          	jal	ra,ffffffffc0200bd6 <ide_write_secs>
ffffffffc0208864:	e151                	bnez	a0,ffffffffc02088e8 <disk0_io+0x1b2>
ffffffffc0208866:	6922                	ld	s2,8(sp)
ffffffffc0208868:	013409bb          	addw	s3,s0,s3
ffffffffc020886c:	412484b3          	sub	s1,s1,s2
ffffffffc0208870:	fcd9                	bnez	s1,ffffffffc020880e <disk0_io+0xd8>
ffffffffc0208872:	0008d517          	auipc	a0,0x8d
ffffffffc0208876:	fce50513          	addi	a0,a0,-50 # ffffffffc0295840 <disk0_sem>
ffffffffc020887a:	ce7fb0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020887e:	4501                	li	a0,0
ffffffffc0208880:	b729                	j	ffffffffc020878a <disk0_io+0x54>
ffffffffc0208882:	5575                	li	a0,-3
ffffffffc0208884:	b719                	j	ffffffffc020878a <disk0_io+0x54>
ffffffffc0208886:	00006697          	auipc	a3,0x6
ffffffffc020888a:	1a268693          	addi	a3,a3,418 # ffffffffc020ea28 <dev_node_ops+0x178>
ffffffffc020888e:	00003617          	auipc	a2,0x3
ffffffffc0208892:	07a60613          	addi	a2,a2,122 # ffffffffc020b908 <commands+0x210>
ffffffffc0208896:	06200593          	li	a1,98
ffffffffc020889a:	00006517          	auipc	a0,0x6
ffffffffc020889e:	0d650513          	addi	a0,a0,214 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02088a2:	bfdf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02088a6:	00006697          	auipc	a3,0x6
ffffffffc02088aa:	08a68693          	addi	a3,a3,138 # ffffffffc020e930 <dev_node_ops+0x80>
ffffffffc02088ae:	00003617          	auipc	a2,0x3
ffffffffc02088b2:	05a60613          	addi	a2,a2,90 # ffffffffc020b908 <commands+0x210>
ffffffffc02088b6:	05700593          	li	a1,87
ffffffffc02088ba:	00006517          	auipc	a0,0x6
ffffffffc02088be:	0b650513          	addi	a0,a0,182 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02088c2:	bddf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02088c6:	88aa                	mv	a7,a0
ffffffffc02088c8:	886a                	mv	a6,s10
ffffffffc02088ca:	87a2                	mv	a5,s0
ffffffffc02088cc:	8752                	mv	a4,s4
ffffffffc02088ce:	86ce                	mv	a3,s3
ffffffffc02088d0:	00006617          	auipc	a2,0x6
ffffffffc02088d4:	11060613          	addi	a2,a2,272 # ffffffffc020e9e0 <dev_node_ops+0x130>
ffffffffc02088d8:	02d00593          	li	a1,45
ffffffffc02088dc:	00006517          	auipc	a0,0x6
ffffffffc02088e0:	09450513          	addi	a0,a0,148 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02088e4:	bbbf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02088e8:	88aa                	mv	a7,a0
ffffffffc02088ea:	8852                	mv	a6,s4
ffffffffc02088ec:	87a2                	mv	a5,s0
ffffffffc02088ee:	874a                	mv	a4,s2
ffffffffc02088f0:	86ce                	mv	a3,s3
ffffffffc02088f2:	00006617          	auipc	a2,0x6
ffffffffc02088f6:	09e60613          	addi	a2,a2,158 # ffffffffc020e990 <dev_node_ops+0xe0>
ffffffffc02088fa:	03700593          	li	a1,55
ffffffffc02088fe:	00006517          	auipc	a0,0x6
ffffffffc0208902:	07250513          	addi	a0,a0,114 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc0208906:	b99f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020890a <dev_init_disk0>:
ffffffffc020890a:	1101                	addi	sp,sp,-32
ffffffffc020890c:	ec06                	sd	ra,24(sp)
ffffffffc020890e:	e822                	sd	s0,16(sp)
ffffffffc0208910:	e426                	sd	s1,8(sp)
ffffffffc0208912:	dedff0ef          	jal	ra,ffffffffc02086fe <dev_create_inode>
ffffffffc0208916:	c541                	beqz	a0,ffffffffc020899e <dev_init_disk0+0x94>
ffffffffc0208918:	4d38                	lw	a4,88(a0)
ffffffffc020891a:	6485                	lui	s1,0x1
ffffffffc020891c:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208920:	842a                	mv	s0,a0
ffffffffc0208922:	0cf71f63          	bne	a4,a5,ffffffffc0208a00 <dev_init_disk0+0xf6>
ffffffffc0208926:	4509                	li	a0,2
ffffffffc0208928:	9ccf80ef          	jal	ra,ffffffffc0200af4 <ide_device_valid>
ffffffffc020892c:	cd55                	beqz	a0,ffffffffc02089e8 <dev_init_disk0+0xde>
ffffffffc020892e:	4509                	li	a0,2
ffffffffc0208930:	9e8f80ef          	jal	ra,ffffffffc0200b18 <ide_device_size>
ffffffffc0208934:	00355793          	srli	a5,a0,0x3
ffffffffc0208938:	e01c                	sd	a5,0(s0)
ffffffffc020893a:	00000797          	auipc	a5,0x0
ffffffffc020893e:	df078793          	addi	a5,a5,-528 # ffffffffc020872a <disk0_open>
ffffffffc0208942:	e81c                	sd	a5,16(s0)
ffffffffc0208944:	00000797          	auipc	a5,0x0
ffffffffc0208948:	dea78793          	addi	a5,a5,-534 # ffffffffc020872e <disk0_close>
ffffffffc020894c:	ec1c                	sd	a5,24(s0)
ffffffffc020894e:	00000797          	auipc	a5,0x0
ffffffffc0208952:	de878793          	addi	a5,a5,-536 # ffffffffc0208736 <disk0_io>
ffffffffc0208956:	f01c                	sd	a5,32(s0)
ffffffffc0208958:	00000797          	auipc	a5,0x0
ffffffffc020895c:	dda78793          	addi	a5,a5,-550 # ffffffffc0208732 <disk0_ioctl>
ffffffffc0208960:	f41c                	sd	a5,40(s0)
ffffffffc0208962:	4585                	li	a1,1
ffffffffc0208964:	0008d517          	auipc	a0,0x8d
ffffffffc0208968:	edc50513          	addi	a0,a0,-292 # ffffffffc0295840 <disk0_sem>
ffffffffc020896c:	e404                	sd	s1,8(s0)
ffffffffc020896e:	bedfb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0208972:	6511                	lui	a0,0x4
ffffffffc0208974:	e1af90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208978:	0008e797          	auipc	a5,0x8e
ffffffffc020897c:	f8a7b023          	sd	a0,-128(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208980:	c921                	beqz	a0,ffffffffc02089d0 <dev_init_disk0+0xc6>
ffffffffc0208982:	4605                	li	a2,1
ffffffffc0208984:	85a2                	mv	a1,s0
ffffffffc0208986:	00006517          	auipc	a0,0x6
ffffffffc020898a:	13250513          	addi	a0,a0,306 # ffffffffc020eab8 <dev_node_ops+0x208>
ffffffffc020898e:	c2cff0ef          	jal	ra,ffffffffc0207dba <vfs_add_dev>
ffffffffc0208992:	e115                	bnez	a0,ffffffffc02089b6 <dev_init_disk0+0xac>
ffffffffc0208994:	60e2                	ld	ra,24(sp)
ffffffffc0208996:	6442                	ld	s0,16(sp)
ffffffffc0208998:	64a2                	ld	s1,8(sp)
ffffffffc020899a:	6105                	addi	sp,sp,32
ffffffffc020899c:	8082                	ret
ffffffffc020899e:	00006617          	auipc	a2,0x6
ffffffffc02089a2:	0ba60613          	addi	a2,a2,186 # ffffffffc020ea58 <dev_node_ops+0x1a8>
ffffffffc02089a6:	08700593          	li	a1,135
ffffffffc02089aa:	00006517          	auipc	a0,0x6
ffffffffc02089ae:	fc650513          	addi	a0,a0,-58 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02089b2:	aedf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02089b6:	86aa                	mv	a3,a0
ffffffffc02089b8:	00006617          	auipc	a2,0x6
ffffffffc02089bc:	10860613          	addi	a2,a2,264 # ffffffffc020eac0 <dev_node_ops+0x210>
ffffffffc02089c0:	08d00593          	li	a1,141
ffffffffc02089c4:	00006517          	auipc	a0,0x6
ffffffffc02089c8:	fac50513          	addi	a0,a0,-84 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02089cc:	ad3f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02089d0:	00006617          	auipc	a2,0x6
ffffffffc02089d4:	0c860613          	addi	a2,a2,200 # ffffffffc020ea98 <dev_node_ops+0x1e8>
ffffffffc02089d8:	07f00593          	li	a1,127
ffffffffc02089dc:	00006517          	auipc	a0,0x6
ffffffffc02089e0:	f9450513          	addi	a0,a0,-108 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02089e4:	abbf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02089e8:	00006617          	auipc	a2,0x6
ffffffffc02089ec:	09060613          	addi	a2,a2,144 # ffffffffc020ea78 <dev_node_ops+0x1c8>
ffffffffc02089f0:	07300593          	li	a1,115
ffffffffc02089f4:	00006517          	auipc	a0,0x6
ffffffffc02089f8:	f7c50513          	addi	a0,a0,-132 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc02089fc:	aa3f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a00:	00006697          	auipc	a3,0x6
ffffffffc0208a04:	b8868693          	addi	a3,a3,-1144 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208a08:	00003617          	auipc	a2,0x3
ffffffffc0208a0c:	f0060613          	addi	a2,a2,-256 # ffffffffc020b908 <commands+0x210>
ffffffffc0208a10:	08900593          	li	a1,137
ffffffffc0208a14:	00006517          	auipc	a0,0x6
ffffffffc0208a18:	f5c50513          	addi	a0,a0,-164 # ffffffffc020e970 <dev_node_ops+0xc0>
ffffffffc0208a1c:	a83f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a20 <stdin_open>:
ffffffffc0208a20:	4501                	li	a0,0
ffffffffc0208a22:	e191                	bnez	a1,ffffffffc0208a26 <stdin_open+0x6>
ffffffffc0208a24:	8082                	ret
ffffffffc0208a26:	5575                	li	a0,-3
ffffffffc0208a28:	8082                	ret

ffffffffc0208a2a <stdin_close>:
ffffffffc0208a2a:	4501                	li	a0,0
ffffffffc0208a2c:	8082                	ret

ffffffffc0208a2e <stdin_ioctl>:
ffffffffc0208a2e:	5575                	li	a0,-3
ffffffffc0208a30:	8082                	ret

ffffffffc0208a32 <stdin_io>:
ffffffffc0208a32:	7135                	addi	sp,sp,-160
ffffffffc0208a34:	ed06                	sd	ra,152(sp)
ffffffffc0208a36:	e922                	sd	s0,144(sp)
ffffffffc0208a38:	e526                	sd	s1,136(sp)
ffffffffc0208a3a:	e14a                	sd	s2,128(sp)
ffffffffc0208a3c:	fcce                	sd	s3,120(sp)
ffffffffc0208a3e:	f8d2                	sd	s4,112(sp)
ffffffffc0208a40:	f4d6                	sd	s5,104(sp)
ffffffffc0208a42:	f0da                	sd	s6,96(sp)
ffffffffc0208a44:	ecde                	sd	s7,88(sp)
ffffffffc0208a46:	e8e2                	sd	s8,80(sp)
ffffffffc0208a48:	e4e6                	sd	s9,72(sp)
ffffffffc0208a4a:	e0ea                	sd	s10,64(sp)
ffffffffc0208a4c:	fc6e                	sd	s11,56(sp)
ffffffffc0208a4e:	14061163          	bnez	a2,ffffffffc0208b90 <stdin_io+0x15e>
ffffffffc0208a52:	0005bd83          	ld	s11,0(a1)
ffffffffc0208a56:	0185bd03          	ld	s10,24(a1)
ffffffffc0208a5a:	8b2e                	mv	s6,a1
ffffffffc0208a5c:	100027f3          	csrr	a5,sstatus
ffffffffc0208a60:	8b89                	andi	a5,a5,2
ffffffffc0208a62:	10079e63          	bnez	a5,ffffffffc0208b7e <stdin_io+0x14c>
ffffffffc0208a66:	4401                	li	s0,0
ffffffffc0208a68:	100d0963          	beqz	s10,ffffffffc0208b7a <stdin_io+0x148>
ffffffffc0208a6c:	0008e997          	auipc	s3,0x8e
ffffffffc0208a70:	e9498993          	addi	s3,s3,-364 # ffffffffc0296900 <p_rpos>
ffffffffc0208a74:	0009b783          	ld	a5,0(s3)
ffffffffc0208a78:	800004b7          	lui	s1,0x80000
ffffffffc0208a7c:	6c85                	lui	s9,0x1
ffffffffc0208a7e:	4a81                	li	s5,0
ffffffffc0208a80:	0008ea17          	auipc	s4,0x8e
ffffffffc0208a84:	e88a0a13          	addi	s4,s4,-376 # ffffffffc0296908 <p_wpos>
ffffffffc0208a88:	0491                	addi	s1,s1,4
ffffffffc0208a8a:	0008d917          	auipc	s2,0x8d
ffffffffc0208a8e:	dce90913          	addi	s2,s2,-562 # ffffffffc0295858 <__wait_queue>
ffffffffc0208a92:	1cfd                	addi	s9,s9,-1
ffffffffc0208a94:	000a3703          	ld	a4,0(s4)
ffffffffc0208a98:	000a8c1b          	sext.w	s8,s5
ffffffffc0208a9c:	8be2                	mv	s7,s8
ffffffffc0208a9e:	02e7d763          	bge	a5,a4,ffffffffc0208acc <stdin_io+0x9a>
ffffffffc0208aa2:	a859                	j	ffffffffc0208b38 <stdin_io+0x106>
ffffffffc0208aa4:	815fe0ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc0208aa8:	100027f3          	csrr	a5,sstatus
ffffffffc0208aac:	8b89                	andi	a5,a5,2
ffffffffc0208aae:	4401                	li	s0,0
ffffffffc0208ab0:	ef8d                	bnez	a5,ffffffffc0208aea <stdin_io+0xb8>
ffffffffc0208ab2:	0028                	addi	a0,sp,8
ffffffffc0208ab4:	b43fb0ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc0208ab8:	e121                	bnez	a0,ffffffffc0208af8 <stdin_io+0xc6>
ffffffffc0208aba:	47c2                	lw	a5,16(sp)
ffffffffc0208abc:	04979563          	bne	a5,s1,ffffffffc0208b06 <stdin_io+0xd4>
ffffffffc0208ac0:	0009b783          	ld	a5,0(s3)
ffffffffc0208ac4:	000a3703          	ld	a4,0(s4)
ffffffffc0208ac8:	06e7c863          	blt	a5,a4,ffffffffc0208b38 <stdin_io+0x106>
ffffffffc0208acc:	8626                	mv	a2,s1
ffffffffc0208ace:	002c                	addi	a1,sp,8
ffffffffc0208ad0:	854a                	mv	a0,s2
ffffffffc0208ad2:	c4ffb0ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc0208ad6:	d479                	beqz	s0,ffffffffc0208aa4 <stdin_io+0x72>
ffffffffc0208ad8:	994f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208adc:	fdcfe0ef          	jal	ra,ffffffffc02072b8 <schedule>
ffffffffc0208ae0:	100027f3          	csrr	a5,sstatus
ffffffffc0208ae4:	8b89                	andi	a5,a5,2
ffffffffc0208ae6:	4401                	li	s0,0
ffffffffc0208ae8:	d7e9                	beqz	a5,ffffffffc0208ab2 <stdin_io+0x80>
ffffffffc0208aea:	988f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208aee:	0028                	addi	a0,sp,8
ffffffffc0208af0:	4405                	li	s0,1
ffffffffc0208af2:	b05fb0ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc0208af6:	d171                	beqz	a0,ffffffffc0208aba <stdin_io+0x88>
ffffffffc0208af8:	002c                	addi	a1,sp,8
ffffffffc0208afa:	854a                	mv	a0,s2
ffffffffc0208afc:	aa1fb0ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc0208b00:	47c2                	lw	a5,16(sp)
ffffffffc0208b02:	fa978fe3          	beq	a5,s1,ffffffffc0208ac0 <stdin_io+0x8e>
ffffffffc0208b06:	e435                	bnez	s0,ffffffffc0208b72 <stdin_io+0x140>
ffffffffc0208b08:	060b8963          	beqz	s7,ffffffffc0208b7a <stdin_io+0x148>
ffffffffc0208b0c:	018b3783          	ld	a5,24(s6)
ffffffffc0208b10:	41578ab3          	sub	s5,a5,s5
ffffffffc0208b14:	015b3c23          	sd	s5,24(s6)
ffffffffc0208b18:	60ea                	ld	ra,152(sp)
ffffffffc0208b1a:	644a                	ld	s0,144(sp)
ffffffffc0208b1c:	64aa                	ld	s1,136(sp)
ffffffffc0208b1e:	690a                	ld	s2,128(sp)
ffffffffc0208b20:	79e6                	ld	s3,120(sp)
ffffffffc0208b22:	7a46                	ld	s4,112(sp)
ffffffffc0208b24:	7aa6                	ld	s5,104(sp)
ffffffffc0208b26:	7b06                	ld	s6,96(sp)
ffffffffc0208b28:	6c46                	ld	s8,80(sp)
ffffffffc0208b2a:	6ca6                	ld	s9,72(sp)
ffffffffc0208b2c:	6d06                	ld	s10,64(sp)
ffffffffc0208b2e:	7de2                	ld	s11,56(sp)
ffffffffc0208b30:	855e                	mv	a0,s7
ffffffffc0208b32:	6be6                	ld	s7,88(sp)
ffffffffc0208b34:	610d                	addi	sp,sp,160
ffffffffc0208b36:	8082                	ret
ffffffffc0208b38:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208b3c:	03475693          	srli	a3,a4,0x34
ffffffffc0208b40:	00d78733          	add	a4,a5,a3
ffffffffc0208b44:	01977733          	and	a4,a4,s9
ffffffffc0208b48:	8f15                	sub	a4,a4,a3
ffffffffc0208b4a:	0008d697          	auipc	a3,0x8d
ffffffffc0208b4e:	d1e68693          	addi	a3,a3,-738 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208b52:	9736                	add	a4,a4,a3
ffffffffc0208b54:	00074683          	lbu	a3,0(a4)
ffffffffc0208b58:	0785                	addi	a5,a5,1
ffffffffc0208b5a:	015d8733          	add	a4,s11,s5
ffffffffc0208b5e:	00d70023          	sb	a3,0(a4)
ffffffffc0208b62:	00f9b023          	sd	a5,0(s3)
ffffffffc0208b66:	0a85                	addi	s5,s5,1
ffffffffc0208b68:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208b6c:	f3aae4e3          	bltu	s5,s10,ffffffffc0208a94 <stdin_io+0x62>
ffffffffc0208b70:	dc51                	beqz	s0,ffffffffc0208b0c <stdin_io+0xda>
ffffffffc0208b72:	8faf80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208b76:	f80b9be3          	bnez	s7,ffffffffc0208b0c <stdin_io+0xda>
ffffffffc0208b7a:	4b81                	li	s7,0
ffffffffc0208b7c:	bf71                	j	ffffffffc0208b18 <stdin_io+0xe6>
ffffffffc0208b7e:	8f4f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208b82:	4405                	li	s0,1
ffffffffc0208b84:	ee0d14e3          	bnez	s10,ffffffffc0208a6c <stdin_io+0x3a>
ffffffffc0208b88:	8e4f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208b8c:	4b81                	li	s7,0
ffffffffc0208b8e:	b769                	j	ffffffffc0208b18 <stdin_io+0xe6>
ffffffffc0208b90:	5bf5                	li	s7,-3
ffffffffc0208b92:	b759                	j	ffffffffc0208b18 <stdin_io+0xe6>

ffffffffc0208b94 <dev_stdin_write>:
ffffffffc0208b94:	e111                	bnez	a0,ffffffffc0208b98 <dev_stdin_write+0x4>
ffffffffc0208b96:	8082                	ret
ffffffffc0208b98:	1101                	addi	sp,sp,-32
ffffffffc0208b9a:	e822                	sd	s0,16(sp)
ffffffffc0208b9c:	ec06                	sd	ra,24(sp)
ffffffffc0208b9e:	e426                	sd	s1,8(sp)
ffffffffc0208ba0:	842a                	mv	s0,a0
ffffffffc0208ba2:	100027f3          	csrr	a5,sstatus
ffffffffc0208ba6:	8b89                	andi	a5,a5,2
ffffffffc0208ba8:	4481                	li	s1,0
ffffffffc0208baa:	e3c1                	bnez	a5,ffffffffc0208c2a <dev_stdin_write+0x96>
ffffffffc0208bac:	0008e597          	auipc	a1,0x8e
ffffffffc0208bb0:	d5c58593          	addi	a1,a1,-676 # ffffffffc0296908 <p_wpos>
ffffffffc0208bb4:	6198                	ld	a4,0(a1)
ffffffffc0208bb6:	6605                	lui	a2,0x1
ffffffffc0208bb8:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208bbc:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208bc0:	92d1                	srli	a3,a3,0x34
ffffffffc0208bc2:	00d707b3          	add	a5,a4,a3
ffffffffc0208bc6:	8fe9                	and	a5,a5,a0
ffffffffc0208bc8:	8f95                	sub	a5,a5,a3
ffffffffc0208bca:	0008d697          	auipc	a3,0x8d
ffffffffc0208bce:	c9e68693          	addi	a3,a3,-866 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208bd2:	97b6                	add	a5,a5,a3
ffffffffc0208bd4:	00878023          	sb	s0,0(a5)
ffffffffc0208bd8:	0008e797          	auipc	a5,0x8e
ffffffffc0208bdc:	d287b783          	ld	a5,-728(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208be0:	40f707b3          	sub	a5,a4,a5
ffffffffc0208be4:	00c7d463          	bge	a5,a2,ffffffffc0208bec <dev_stdin_write+0x58>
ffffffffc0208be8:	0705                	addi	a4,a4,1
ffffffffc0208bea:	e198                	sd	a4,0(a1)
ffffffffc0208bec:	0008d517          	auipc	a0,0x8d
ffffffffc0208bf0:	c6c50513          	addi	a0,a0,-916 # ffffffffc0295858 <__wait_queue>
ffffffffc0208bf4:	9f7fb0ef          	jal	ra,ffffffffc02045ea <wait_queue_empty>
ffffffffc0208bf8:	cd09                	beqz	a0,ffffffffc0208c12 <dev_stdin_write+0x7e>
ffffffffc0208bfa:	e491                	bnez	s1,ffffffffc0208c06 <dev_stdin_write+0x72>
ffffffffc0208bfc:	60e2                	ld	ra,24(sp)
ffffffffc0208bfe:	6442                	ld	s0,16(sp)
ffffffffc0208c00:	64a2                	ld	s1,8(sp)
ffffffffc0208c02:	6105                	addi	sp,sp,32
ffffffffc0208c04:	8082                	ret
ffffffffc0208c06:	6442                	ld	s0,16(sp)
ffffffffc0208c08:	60e2                	ld	ra,24(sp)
ffffffffc0208c0a:	64a2                	ld	s1,8(sp)
ffffffffc0208c0c:	6105                	addi	sp,sp,32
ffffffffc0208c0e:	85ef806f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0208c12:	800005b7          	lui	a1,0x80000
ffffffffc0208c16:	4605                	li	a2,1
ffffffffc0208c18:	0591                	addi	a1,a1,4
ffffffffc0208c1a:	0008d517          	auipc	a0,0x8d
ffffffffc0208c1e:	c3e50513          	addi	a0,a0,-962 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c22:	a31fb0ef          	jal	ra,ffffffffc0204652 <wakeup_queue>
ffffffffc0208c26:	d8f9                	beqz	s1,ffffffffc0208bfc <dev_stdin_write+0x68>
ffffffffc0208c28:	bff9                	j	ffffffffc0208c06 <dev_stdin_write+0x72>
ffffffffc0208c2a:	848f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208c2e:	4485                	li	s1,1
ffffffffc0208c30:	bfb5                	j	ffffffffc0208bac <dev_stdin_write+0x18>

ffffffffc0208c32 <dev_init_stdin>:
ffffffffc0208c32:	1141                	addi	sp,sp,-16
ffffffffc0208c34:	e406                	sd	ra,8(sp)
ffffffffc0208c36:	e022                	sd	s0,0(sp)
ffffffffc0208c38:	ac7ff0ef          	jal	ra,ffffffffc02086fe <dev_create_inode>
ffffffffc0208c3c:	c93d                	beqz	a0,ffffffffc0208cb2 <dev_init_stdin+0x80>
ffffffffc0208c3e:	4d38                	lw	a4,88(a0)
ffffffffc0208c40:	6785                	lui	a5,0x1
ffffffffc0208c42:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c46:	842a                	mv	s0,a0
ffffffffc0208c48:	08f71e63          	bne	a4,a5,ffffffffc0208ce4 <dev_init_stdin+0xb2>
ffffffffc0208c4c:	4785                	li	a5,1
ffffffffc0208c4e:	e41c                	sd	a5,8(s0)
ffffffffc0208c50:	00000797          	auipc	a5,0x0
ffffffffc0208c54:	dd078793          	addi	a5,a5,-560 # ffffffffc0208a20 <stdin_open>
ffffffffc0208c58:	e81c                	sd	a5,16(s0)
ffffffffc0208c5a:	00000797          	auipc	a5,0x0
ffffffffc0208c5e:	dd078793          	addi	a5,a5,-560 # ffffffffc0208a2a <stdin_close>
ffffffffc0208c62:	ec1c                	sd	a5,24(s0)
ffffffffc0208c64:	00000797          	auipc	a5,0x0
ffffffffc0208c68:	dce78793          	addi	a5,a5,-562 # ffffffffc0208a32 <stdin_io>
ffffffffc0208c6c:	f01c                	sd	a5,32(s0)
ffffffffc0208c6e:	00000797          	auipc	a5,0x0
ffffffffc0208c72:	dc078793          	addi	a5,a5,-576 # ffffffffc0208a2e <stdin_ioctl>
ffffffffc0208c76:	f41c                	sd	a5,40(s0)
ffffffffc0208c78:	0008d517          	auipc	a0,0x8d
ffffffffc0208c7c:	be050513          	addi	a0,a0,-1056 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c80:	00043023          	sd	zero,0(s0)
ffffffffc0208c84:	0008e797          	auipc	a5,0x8e
ffffffffc0208c88:	c807b223          	sd	zero,-892(a5) # ffffffffc0296908 <p_wpos>
ffffffffc0208c8c:	0008e797          	auipc	a5,0x8e
ffffffffc0208c90:	c607ba23          	sd	zero,-908(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208c94:	903fb0ef          	jal	ra,ffffffffc0204596 <wait_queue_init>
ffffffffc0208c98:	4601                	li	a2,0
ffffffffc0208c9a:	85a2                	mv	a1,s0
ffffffffc0208c9c:	00006517          	auipc	a0,0x6
ffffffffc0208ca0:	e8450513          	addi	a0,a0,-380 # ffffffffc020eb20 <dev_node_ops+0x270>
ffffffffc0208ca4:	916ff0ef          	jal	ra,ffffffffc0207dba <vfs_add_dev>
ffffffffc0208ca8:	e10d                	bnez	a0,ffffffffc0208cca <dev_init_stdin+0x98>
ffffffffc0208caa:	60a2                	ld	ra,8(sp)
ffffffffc0208cac:	6402                	ld	s0,0(sp)
ffffffffc0208cae:	0141                	addi	sp,sp,16
ffffffffc0208cb0:	8082                	ret
ffffffffc0208cb2:	00006617          	auipc	a2,0x6
ffffffffc0208cb6:	e2e60613          	addi	a2,a2,-466 # ffffffffc020eae0 <dev_node_ops+0x230>
ffffffffc0208cba:	07500593          	li	a1,117
ffffffffc0208cbe:	00006517          	auipc	a0,0x6
ffffffffc0208cc2:	e4250513          	addi	a0,a0,-446 # ffffffffc020eb00 <dev_node_ops+0x250>
ffffffffc0208cc6:	fd8f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208cca:	86aa                	mv	a3,a0
ffffffffc0208ccc:	00006617          	auipc	a2,0x6
ffffffffc0208cd0:	e5c60613          	addi	a2,a2,-420 # ffffffffc020eb28 <dev_node_ops+0x278>
ffffffffc0208cd4:	07b00593          	li	a1,123
ffffffffc0208cd8:	00006517          	auipc	a0,0x6
ffffffffc0208cdc:	e2850513          	addi	a0,a0,-472 # ffffffffc020eb00 <dev_node_ops+0x250>
ffffffffc0208ce0:	fbef70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208ce4:	00006697          	auipc	a3,0x6
ffffffffc0208ce8:	8a468693          	addi	a3,a3,-1884 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208cec:	00003617          	auipc	a2,0x3
ffffffffc0208cf0:	c1c60613          	addi	a2,a2,-996 # ffffffffc020b908 <commands+0x210>
ffffffffc0208cf4:	07700593          	li	a1,119
ffffffffc0208cf8:	00006517          	auipc	a0,0x6
ffffffffc0208cfc:	e0850513          	addi	a0,a0,-504 # ffffffffc020eb00 <dev_node_ops+0x250>
ffffffffc0208d00:	f9ef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208d04 <stdout_open>:
ffffffffc0208d04:	4785                	li	a5,1
ffffffffc0208d06:	4501                	li	a0,0
ffffffffc0208d08:	00f59363          	bne	a1,a5,ffffffffc0208d0e <stdout_open+0xa>
ffffffffc0208d0c:	8082                	ret
ffffffffc0208d0e:	5575                	li	a0,-3
ffffffffc0208d10:	8082                	ret

ffffffffc0208d12 <stdout_close>:
ffffffffc0208d12:	4501                	li	a0,0
ffffffffc0208d14:	8082                	ret

ffffffffc0208d16 <stdout_ioctl>:
ffffffffc0208d16:	5575                	li	a0,-3
ffffffffc0208d18:	8082                	ret

ffffffffc0208d1a <stdout_io>:
ffffffffc0208d1a:	ca05                	beqz	a2,ffffffffc0208d4a <stdout_io+0x30>
ffffffffc0208d1c:	6d9c                	ld	a5,24(a1)
ffffffffc0208d1e:	1101                	addi	sp,sp,-32
ffffffffc0208d20:	e822                	sd	s0,16(sp)
ffffffffc0208d22:	e426                	sd	s1,8(sp)
ffffffffc0208d24:	ec06                	sd	ra,24(sp)
ffffffffc0208d26:	6180                	ld	s0,0(a1)
ffffffffc0208d28:	84ae                	mv	s1,a1
ffffffffc0208d2a:	cb91                	beqz	a5,ffffffffc0208d3e <stdout_io+0x24>
ffffffffc0208d2c:	00044503          	lbu	a0,0(s0)
ffffffffc0208d30:	0405                	addi	s0,s0,1
ffffffffc0208d32:	cb0f70ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0208d36:	6c9c                	ld	a5,24(s1)
ffffffffc0208d38:	17fd                	addi	a5,a5,-1
ffffffffc0208d3a:	ec9c                	sd	a5,24(s1)
ffffffffc0208d3c:	fbe5                	bnez	a5,ffffffffc0208d2c <stdout_io+0x12>
ffffffffc0208d3e:	60e2                	ld	ra,24(sp)
ffffffffc0208d40:	6442                	ld	s0,16(sp)
ffffffffc0208d42:	64a2                	ld	s1,8(sp)
ffffffffc0208d44:	4501                	li	a0,0
ffffffffc0208d46:	6105                	addi	sp,sp,32
ffffffffc0208d48:	8082                	ret
ffffffffc0208d4a:	5575                	li	a0,-3
ffffffffc0208d4c:	8082                	ret

ffffffffc0208d4e <dev_init_stdout>:
ffffffffc0208d4e:	1141                	addi	sp,sp,-16
ffffffffc0208d50:	e406                	sd	ra,8(sp)
ffffffffc0208d52:	9adff0ef          	jal	ra,ffffffffc02086fe <dev_create_inode>
ffffffffc0208d56:	c939                	beqz	a0,ffffffffc0208dac <dev_init_stdout+0x5e>
ffffffffc0208d58:	4d38                	lw	a4,88(a0)
ffffffffc0208d5a:	6785                	lui	a5,0x1
ffffffffc0208d5c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d60:	85aa                	mv	a1,a0
ffffffffc0208d62:	06f71e63          	bne	a4,a5,ffffffffc0208dde <dev_init_stdout+0x90>
ffffffffc0208d66:	4785                	li	a5,1
ffffffffc0208d68:	e51c                	sd	a5,8(a0)
ffffffffc0208d6a:	00000797          	auipc	a5,0x0
ffffffffc0208d6e:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208d04 <stdout_open>
ffffffffc0208d72:	e91c                	sd	a5,16(a0)
ffffffffc0208d74:	00000797          	auipc	a5,0x0
ffffffffc0208d78:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208d12 <stdout_close>
ffffffffc0208d7c:	ed1c                	sd	a5,24(a0)
ffffffffc0208d7e:	00000797          	auipc	a5,0x0
ffffffffc0208d82:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208d1a <stdout_io>
ffffffffc0208d86:	f11c                	sd	a5,32(a0)
ffffffffc0208d88:	00000797          	auipc	a5,0x0
ffffffffc0208d8c:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208d16 <stdout_ioctl>
ffffffffc0208d90:	00053023          	sd	zero,0(a0)
ffffffffc0208d94:	f51c                	sd	a5,40(a0)
ffffffffc0208d96:	4601                	li	a2,0
ffffffffc0208d98:	00006517          	auipc	a0,0x6
ffffffffc0208d9c:	df050513          	addi	a0,a0,-528 # ffffffffc020eb88 <dev_node_ops+0x2d8>
ffffffffc0208da0:	81aff0ef          	jal	ra,ffffffffc0207dba <vfs_add_dev>
ffffffffc0208da4:	e105                	bnez	a0,ffffffffc0208dc4 <dev_init_stdout+0x76>
ffffffffc0208da6:	60a2                	ld	ra,8(sp)
ffffffffc0208da8:	0141                	addi	sp,sp,16
ffffffffc0208daa:	8082                	ret
ffffffffc0208dac:	00006617          	auipc	a2,0x6
ffffffffc0208db0:	d9c60613          	addi	a2,a2,-612 # ffffffffc020eb48 <dev_node_ops+0x298>
ffffffffc0208db4:	03700593          	li	a1,55
ffffffffc0208db8:	00006517          	auipc	a0,0x6
ffffffffc0208dbc:	db050513          	addi	a0,a0,-592 # ffffffffc020eb68 <dev_node_ops+0x2b8>
ffffffffc0208dc0:	edef70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208dc4:	86aa                	mv	a3,a0
ffffffffc0208dc6:	00006617          	auipc	a2,0x6
ffffffffc0208dca:	dca60613          	addi	a2,a2,-566 # ffffffffc020eb90 <dev_node_ops+0x2e0>
ffffffffc0208dce:	03d00593          	li	a1,61
ffffffffc0208dd2:	00006517          	auipc	a0,0x6
ffffffffc0208dd6:	d9650513          	addi	a0,a0,-618 # ffffffffc020eb68 <dev_node_ops+0x2b8>
ffffffffc0208dda:	ec4f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208dde:	00005697          	auipc	a3,0x5
ffffffffc0208de2:	7aa68693          	addi	a3,a3,1962 # ffffffffc020e588 <syscalls+0xb10>
ffffffffc0208de6:	00003617          	auipc	a2,0x3
ffffffffc0208dea:	b2260613          	addi	a2,a2,-1246 # ffffffffc020b908 <commands+0x210>
ffffffffc0208dee:	03900593          	li	a1,57
ffffffffc0208df2:	00006517          	auipc	a0,0x6
ffffffffc0208df6:	d7650513          	addi	a0,a0,-650 # ffffffffc020eb68 <dev_node_ops+0x2b8>
ffffffffc0208dfa:	ea4f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208dfe <bitmap_translate.part.0>:
ffffffffc0208dfe:	1141                	addi	sp,sp,-16
ffffffffc0208e00:	00006697          	auipc	a3,0x6
ffffffffc0208e04:	db068693          	addi	a3,a3,-592 # ffffffffc020ebb0 <dev_node_ops+0x300>
ffffffffc0208e08:	00003617          	auipc	a2,0x3
ffffffffc0208e0c:	b0060613          	addi	a2,a2,-1280 # ffffffffc020b908 <commands+0x210>
ffffffffc0208e10:	04c00593          	li	a1,76
ffffffffc0208e14:	00006517          	auipc	a0,0x6
ffffffffc0208e18:	db450513          	addi	a0,a0,-588 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0208e1c:	e406                	sd	ra,8(sp)
ffffffffc0208e1e:	e80f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208e22 <bitmap_create>:
ffffffffc0208e22:	7139                	addi	sp,sp,-64
ffffffffc0208e24:	fc06                	sd	ra,56(sp)
ffffffffc0208e26:	f822                	sd	s0,48(sp)
ffffffffc0208e28:	f426                	sd	s1,40(sp)
ffffffffc0208e2a:	f04a                	sd	s2,32(sp)
ffffffffc0208e2c:	ec4e                	sd	s3,24(sp)
ffffffffc0208e2e:	e852                	sd	s4,16(sp)
ffffffffc0208e30:	e456                	sd	s5,8(sp)
ffffffffc0208e32:	c14d                	beqz	a0,ffffffffc0208ed4 <bitmap_create+0xb2>
ffffffffc0208e34:	842a                	mv	s0,a0
ffffffffc0208e36:	4541                	li	a0,16
ffffffffc0208e38:	956f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208e3c:	84aa                	mv	s1,a0
ffffffffc0208e3e:	cd25                	beqz	a0,ffffffffc0208eb6 <bitmap_create+0x94>
ffffffffc0208e40:	02041a13          	slli	s4,s0,0x20
ffffffffc0208e44:	020a5a13          	srli	s4,s4,0x20
ffffffffc0208e48:	01fa0793          	addi	a5,s4,31
ffffffffc0208e4c:	0057d993          	srli	s3,a5,0x5
ffffffffc0208e50:	00299a93          	slli	s5,s3,0x2
ffffffffc0208e54:	8556                	mv	a0,s5
ffffffffc0208e56:	894e                	mv	s2,s3
ffffffffc0208e58:	936f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208e5c:	c53d                	beqz	a0,ffffffffc0208eca <bitmap_create+0xa8>
ffffffffc0208e5e:	0134a223          	sw	s3,4(s1) # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208e62:	c080                	sw	s0,0(s1)
ffffffffc0208e64:	8656                	mv	a2,s5
ffffffffc0208e66:	0ff00593          	li	a1,255
ffffffffc0208e6a:	5ba020ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0208e6e:	e488                	sd	a0,8(s1)
ffffffffc0208e70:	0996                	slli	s3,s3,0x5
ffffffffc0208e72:	053a0263          	beq	s4,s3,ffffffffc0208eb6 <bitmap_create+0x94>
ffffffffc0208e76:	fff9079b          	addiw	a5,s2,-1
ffffffffc0208e7a:	0057969b          	slliw	a3,a5,0x5
ffffffffc0208e7e:	0054561b          	srliw	a2,s0,0x5
ffffffffc0208e82:	40d4073b          	subw	a4,s0,a3
ffffffffc0208e86:	0054541b          	srliw	s0,s0,0x5
ffffffffc0208e8a:	08f61463          	bne	a2,a5,ffffffffc0208f12 <bitmap_create+0xf0>
ffffffffc0208e8e:	fff7069b          	addiw	a3,a4,-1
ffffffffc0208e92:	47f9                	li	a5,30
ffffffffc0208e94:	04d7ef63          	bltu	a5,a3,ffffffffc0208ef2 <bitmap_create+0xd0>
ffffffffc0208e98:	1402                	slli	s0,s0,0x20
ffffffffc0208e9a:	8079                	srli	s0,s0,0x1e
ffffffffc0208e9c:	9522                	add	a0,a0,s0
ffffffffc0208e9e:	411c                	lw	a5,0(a0)
ffffffffc0208ea0:	4585                	li	a1,1
ffffffffc0208ea2:	02000613          	li	a2,32
ffffffffc0208ea6:	00e596bb          	sllw	a3,a1,a4
ffffffffc0208eaa:	8fb5                	xor	a5,a5,a3
ffffffffc0208eac:	2705                	addiw	a4,a4,1
ffffffffc0208eae:	2781                	sext.w	a5,a5
ffffffffc0208eb0:	fec71be3          	bne	a4,a2,ffffffffc0208ea6 <bitmap_create+0x84>
ffffffffc0208eb4:	c11c                	sw	a5,0(a0)
ffffffffc0208eb6:	70e2                	ld	ra,56(sp)
ffffffffc0208eb8:	7442                	ld	s0,48(sp)
ffffffffc0208eba:	7902                	ld	s2,32(sp)
ffffffffc0208ebc:	69e2                	ld	s3,24(sp)
ffffffffc0208ebe:	6a42                	ld	s4,16(sp)
ffffffffc0208ec0:	6aa2                	ld	s5,8(sp)
ffffffffc0208ec2:	8526                	mv	a0,s1
ffffffffc0208ec4:	74a2                	ld	s1,40(sp)
ffffffffc0208ec6:	6121                	addi	sp,sp,64
ffffffffc0208ec8:	8082                	ret
ffffffffc0208eca:	8526                	mv	a0,s1
ffffffffc0208ecc:	972f90ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0208ed0:	4481                	li	s1,0
ffffffffc0208ed2:	b7d5                	j	ffffffffc0208eb6 <bitmap_create+0x94>
ffffffffc0208ed4:	00006697          	auipc	a3,0x6
ffffffffc0208ed8:	d0c68693          	addi	a3,a3,-756 # ffffffffc020ebe0 <dev_node_ops+0x330>
ffffffffc0208edc:	00003617          	auipc	a2,0x3
ffffffffc0208ee0:	a2c60613          	addi	a2,a2,-1492 # ffffffffc020b908 <commands+0x210>
ffffffffc0208ee4:	45d5                	li	a1,21
ffffffffc0208ee6:	00006517          	auipc	a0,0x6
ffffffffc0208eea:	ce250513          	addi	a0,a0,-798 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0208eee:	db0f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208ef2:	00006697          	auipc	a3,0x6
ffffffffc0208ef6:	d2e68693          	addi	a3,a3,-722 # ffffffffc020ec20 <dev_node_ops+0x370>
ffffffffc0208efa:	00003617          	auipc	a2,0x3
ffffffffc0208efe:	a0e60613          	addi	a2,a2,-1522 # ffffffffc020b908 <commands+0x210>
ffffffffc0208f02:	02b00593          	li	a1,43
ffffffffc0208f06:	00006517          	auipc	a0,0x6
ffffffffc0208f0a:	cc250513          	addi	a0,a0,-830 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0208f0e:	d90f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f12:	00006697          	auipc	a3,0x6
ffffffffc0208f16:	cf668693          	addi	a3,a3,-778 # ffffffffc020ec08 <dev_node_ops+0x358>
ffffffffc0208f1a:	00003617          	auipc	a2,0x3
ffffffffc0208f1e:	9ee60613          	addi	a2,a2,-1554 # ffffffffc020b908 <commands+0x210>
ffffffffc0208f22:	02a00593          	li	a1,42
ffffffffc0208f26:	00006517          	auipc	a0,0x6
ffffffffc0208f2a:	ca250513          	addi	a0,a0,-862 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0208f2e:	d70f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208f32 <bitmap_alloc>:
ffffffffc0208f32:	4150                	lw	a2,4(a0)
ffffffffc0208f34:	651c                	ld	a5,8(a0)
ffffffffc0208f36:	c231                	beqz	a2,ffffffffc0208f7a <bitmap_alloc+0x48>
ffffffffc0208f38:	4701                	li	a4,0
ffffffffc0208f3a:	a029                	j	ffffffffc0208f44 <bitmap_alloc+0x12>
ffffffffc0208f3c:	2705                	addiw	a4,a4,1
ffffffffc0208f3e:	0791                	addi	a5,a5,4
ffffffffc0208f40:	02e60d63          	beq	a2,a4,ffffffffc0208f7a <bitmap_alloc+0x48>
ffffffffc0208f44:	4394                	lw	a3,0(a5)
ffffffffc0208f46:	dafd                	beqz	a3,ffffffffc0208f3c <bitmap_alloc+0xa>
ffffffffc0208f48:	4501                	li	a0,0
ffffffffc0208f4a:	4885                	li	a7,1
ffffffffc0208f4c:	8e36                	mv	t3,a3
ffffffffc0208f4e:	02000313          	li	t1,32
ffffffffc0208f52:	a021                	j	ffffffffc0208f5a <bitmap_alloc+0x28>
ffffffffc0208f54:	2505                	addiw	a0,a0,1
ffffffffc0208f56:	02650463          	beq	a0,t1,ffffffffc0208f7e <bitmap_alloc+0x4c>
ffffffffc0208f5a:	00a8983b          	sllw	a6,a7,a0
ffffffffc0208f5e:	0106f633          	and	a2,a3,a6
ffffffffc0208f62:	2601                	sext.w	a2,a2
ffffffffc0208f64:	da65                	beqz	a2,ffffffffc0208f54 <bitmap_alloc+0x22>
ffffffffc0208f66:	010e4833          	xor	a6,t3,a6
ffffffffc0208f6a:	0057171b          	slliw	a4,a4,0x5
ffffffffc0208f6e:	9f29                	addw	a4,a4,a0
ffffffffc0208f70:	0107a023          	sw	a6,0(a5)
ffffffffc0208f74:	c198                	sw	a4,0(a1)
ffffffffc0208f76:	4501                	li	a0,0
ffffffffc0208f78:	8082                	ret
ffffffffc0208f7a:	5571                	li	a0,-4
ffffffffc0208f7c:	8082                	ret
ffffffffc0208f7e:	1141                	addi	sp,sp,-16
ffffffffc0208f80:	00004697          	auipc	a3,0x4
ffffffffc0208f84:	a0868693          	addi	a3,a3,-1528 # ffffffffc020c988 <default_pmm_manager+0x598>
ffffffffc0208f88:	00003617          	auipc	a2,0x3
ffffffffc0208f8c:	98060613          	addi	a2,a2,-1664 # ffffffffc020b908 <commands+0x210>
ffffffffc0208f90:	04300593          	li	a1,67
ffffffffc0208f94:	00006517          	auipc	a0,0x6
ffffffffc0208f98:	c3450513          	addi	a0,a0,-972 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0208f9c:	e406                	sd	ra,8(sp)
ffffffffc0208f9e:	d00f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208fa2 <bitmap_test>:
ffffffffc0208fa2:	411c                	lw	a5,0(a0)
ffffffffc0208fa4:	00f5ff63          	bgeu	a1,a5,ffffffffc0208fc2 <bitmap_test+0x20>
ffffffffc0208fa8:	651c                	ld	a5,8(a0)
ffffffffc0208faa:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0208fae:	070a                	slli	a4,a4,0x2
ffffffffc0208fb0:	97ba                	add	a5,a5,a4
ffffffffc0208fb2:	4388                	lw	a0,0(a5)
ffffffffc0208fb4:	4785                	li	a5,1
ffffffffc0208fb6:	00b795bb          	sllw	a1,a5,a1
ffffffffc0208fba:	8d6d                	and	a0,a0,a1
ffffffffc0208fbc:	1502                	slli	a0,a0,0x20
ffffffffc0208fbe:	9101                	srli	a0,a0,0x20
ffffffffc0208fc0:	8082                	ret
ffffffffc0208fc2:	1141                	addi	sp,sp,-16
ffffffffc0208fc4:	e406                	sd	ra,8(sp)
ffffffffc0208fc6:	e39ff0ef          	jal	ra,ffffffffc0208dfe <bitmap_translate.part.0>

ffffffffc0208fca <bitmap_free>:
ffffffffc0208fca:	411c                	lw	a5,0(a0)
ffffffffc0208fcc:	1141                	addi	sp,sp,-16
ffffffffc0208fce:	e406                	sd	ra,8(sp)
ffffffffc0208fd0:	02f5f463          	bgeu	a1,a5,ffffffffc0208ff8 <bitmap_free+0x2e>
ffffffffc0208fd4:	651c                	ld	a5,8(a0)
ffffffffc0208fd6:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0208fda:	070a                	slli	a4,a4,0x2
ffffffffc0208fdc:	97ba                	add	a5,a5,a4
ffffffffc0208fde:	4398                	lw	a4,0(a5)
ffffffffc0208fe0:	4685                	li	a3,1
ffffffffc0208fe2:	00b695bb          	sllw	a1,a3,a1
ffffffffc0208fe6:	00b776b3          	and	a3,a4,a1
ffffffffc0208fea:	2681                	sext.w	a3,a3
ffffffffc0208fec:	ea81                	bnez	a3,ffffffffc0208ffc <bitmap_free+0x32>
ffffffffc0208fee:	60a2                	ld	ra,8(sp)
ffffffffc0208ff0:	8f4d                	or	a4,a4,a1
ffffffffc0208ff2:	c398                	sw	a4,0(a5)
ffffffffc0208ff4:	0141                	addi	sp,sp,16
ffffffffc0208ff6:	8082                	ret
ffffffffc0208ff8:	e07ff0ef          	jal	ra,ffffffffc0208dfe <bitmap_translate.part.0>
ffffffffc0208ffc:	00006697          	auipc	a3,0x6
ffffffffc0209000:	c4c68693          	addi	a3,a3,-948 # ffffffffc020ec48 <dev_node_ops+0x398>
ffffffffc0209004:	00003617          	auipc	a2,0x3
ffffffffc0209008:	90460613          	addi	a2,a2,-1788 # ffffffffc020b908 <commands+0x210>
ffffffffc020900c:	05f00593          	li	a1,95
ffffffffc0209010:	00006517          	auipc	a0,0x6
ffffffffc0209014:	bb850513          	addi	a0,a0,-1096 # ffffffffc020ebc8 <dev_node_ops+0x318>
ffffffffc0209018:	c86f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020901c <bitmap_destroy>:
ffffffffc020901c:	1141                	addi	sp,sp,-16
ffffffffc020901e:	e022                	sd	s0,0(sp)
ffffffffc0209020:	842a                	mv	s0,a0
ffffffffc0209022:	6508                	ld	a0,8(a0)
ffffffffc0209024:	e406                	sd	ra,8(sp)
ffffffffc0209026:	818f90ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020902a:	8522                	mv	a0,s0
ffffffffc020902c:	6402                	ld	s0,0(sp)
ffffffffc020902e:	60a2                	ld	ra,8(sp)
ffffffffc0209030:	0141                	addi	sp,sp,16
ffffffffc0209032:	80cf906f          	j	ffffffffc020203e <kfree>

ffffffffc0209036 <bitmap_getdata>:
ffffffffc0209036:	c589                	beqz	a1,ffffffffc0209040 <bitmap_getdata+0xa>
ffffffffc0209038:	00456783          	lwu	a5,4(a0)
ffffffffc020903c:	078a                	slli	a5,a5,0x2
ffffffffc020903e:	e19c                	sd	a5,0(a1)
ffffffffc0209040:	6508                	ld	a0,8(a0)
ffffffffc0209042:	8082                	ret

ffffffffc0209044 <sfs_init>:
ffffffffc0209044:	1141                	addi	sp,sp,-16
ffffffffc0209046:	00006517          	auipc	a0,0x6
ffffffffc020904a:	a7250513          	addi	a0,a0,-1422 # ffffffffc020eab8 <dev_node_ops+0x208>
ffffffffc020904e:	e406                	sd	ra,8(sp)
ffffffffc0209050:	554000ef          	jal	ra,ffffffffc02095a4 <sfs_mount>
ffffffffc0209054:	e501                	bnez	a0,ffffffffc020905c <sfs_init+0x18>
ffffffffc0209056:	60a2                	ld	ra,8(sp)
ffffffffc0209058:	0141                	addi	sp,sp,16
ffffffffc020905a:	8082                	ret
ffffffffc020905c:	86aa                	mv	a3,a0
ffffffffc020905e:	00006617          	auipc	a2,0x6
ffffffffc0209062:	bfa60613          	addi	a2,a2,-1030 # ffffffffc020ec58 <dev_node_ops+0x3a8>
ffffffffc0209066:	45c1                	li	a1,16
ffffffffc0209068:	00006517          	auipc	a0,0x6
ffffffffc020906c:	c1050513          	addi	a0,a0,-1008 # ffffffffc020ec78 <dev_node_ops+0x3c8>
ffffffffc0209070:	c2ef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209074 <sfs_unmount>:
ffffffffc0209074:	1141                	addi	sp,sp,-16
ffffffffc0209076:	e406                	sd	ra,8(sp)
ffffffffc0209078:	e022                	sd	s0,0(sp)
ffffffffc020907a:	cd1d                	beqz	a0,ffffffffc02090b8 <sfs_unmount+0x44>
ffffffffc020907c:	0b052783          	lw	a5,176(a0)
ffffffffc0209080:	842a                	mv	s0,a0
ffffffffc0209082:	eb9d                	bnez	a5,ffffffffc02090b8 <sfs_unmount+0x44>
ffffffffc0209084:	7158                	ld	a4,160(a0)
ffffffffc0209086:	09850793          	addi	a5,a0,152
ffffffffc020908a:	02f71563          	bne	a4,a5,ffffffffc02090b4 <sfs_unmount+0x40>
ffffffffc020908e:	613c                	ld	a5,64(a0)
ffffffffc0209090:	e7a1                	bnez	a5,ffffffffc02090d8 <sfs_unmount+0x64>
ffffffffc0209092:	7d08                	ld	a0,56(a0)
ffffffffc0209094:	f89ff0ef          	jal	ra,ffffffffc020901c <bitmap_destroy>
ffffffffc0209098:	6428                	ld	a0,72(s0)
ffffffffc020909a:	fa5f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020909e:	7448                	ld	a0,168(s0)
ffffffffc02090a0:	f9ff80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02090a4:	8522                	mv	a0,s0
ffffffffc02090a6:	f99f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02090aa:	4501                	li	a0,0
ffffffffc02090ac:	60a2                	ld	ra,8(sp)
ffffffffc02090ae:	6402                	ld	s0,0(sp)
ffffffffc02090b0:	0141                	addi	sp,sp,16
ffffffffc02090b2:	8082                	ret
ffffffffc02090b4:	5545                	li	a0,-15
ffffffffc02090b6:	bfdd                	j	ffffffffc02090ac <sfs_unmount+0x38>
ffffffffc02090b8:	00006697          	auipc	a3,0x6
ffffffffc02090bc:	bd868693          	addi	a3,a3,-1064 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc02090c0:	00003617          	auipc	a2,0x3
ffffffffc02090c4:	84860613          	addi	a2,a2,-1976 # ffffffffc020b908 <commands+0x210>
ffffffffc02090c8:	04100593          	li	a1,65
ffffffffc02090cc:	00006517          	auipc	a0,0x6
ffffffffc02090d0:	bf450513          	addi	a0,a0,-1036 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc02090d4:	bcaf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02090d8:	00006697          	auipc	a3,0x6
ffffffffc02090dc:	c0068693          	addi	a3,a3,-1024 # ffffffffc020ecd8 <dev_node_ops+0x428>
ffffffffc02090e0:	00003617          	auipc	a2,0x3
ffffffffc02090e4:	82860613          	addi	a2,a2,-2008 # ffffffffc020b908 <commands+0x210>
ffffffffc02090e8:	04500593          	li	a1,69
ffffffffc02090ec:	00006517          	auipc	a0,0x6
ffffffffc02090f0:	bd450513          	addi	a0,a0,-1068 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc02090f4:	baaf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02090f8 <sfs_cleanup>:
ffffffffc02090f8:	1101                	addi	sp,sp,-32
ffffffffc02090fa:	ec06                	sd	ra,24(sp)
ffffffffc02090fc:	e822                	sd	s0,16(sp)
ffffffffc02090fe:	e426                	sd	s1,8(sp)
ffffffffc0209100:	e04a                	sd	s2,0(sp)
ffffffffc0209102:	c525                	beqz	a0,ffffffffc020916a <sfs_cleanup+0x72>
ffffffffc0209104:	0b052783          	lw	a5,176(a0)
ffffffffc0209108:	84aa                	mv	s1,a0
ffffffffc020910a:	e3a5                	bnez	a5,ffffffffc020916a <sfs_cleanup+0x72>
ffffffffc020910c:	4158                	lw	a4,4(a0)
ffffffffc020910e:	4514                	lw	a3,8(a0)
ffffffffc0209110:	00c50913          	addi	s2,a0,12
ffffffffc0209114:	85ca                	mv	a1,s2
ffffffffc0209116:	40d7063b          	subw	a2,a4,a3
ffffffffc020911a:	00006517          	auipc	a0,0x6
ffffffffc020911e:	bd650513          	addi	a0,a0,-1066 # ffffffffc020ecf0 <dev_node_ops+0x440>
ffffffffc0209122:	884f70ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209126:	02000413          	li	s0,32
ffffffffc020912a:	a019                	j	ffffffffc0209130 <sfs_cleanup+0x38>
ffffffffc020912c:	347d                	addiw	s0,s0,-1
ffffffffc020912e:	c819                	beqz	s0,ffffffffc0209144 <sfs_cleanup+0x4c>
ffffffffc0209130:	7cdc                	ld	a5,184(s1)
ffffffffc0209132:	8526                	mv	a0,s1
ffffffffc0209134:	9782                	jalr	a5
ffffffffc0209136:	f97d                	bnez	a0,ffffffffc020912c <sfs_cleanup+0x34>
ffffffffc0209138:	60e2                	ld	ra,24(sp)
ffffffffc020913a:	6442                	ld	s0,16(sp)
ffffffffc020913c:	64a2                	ld	s1,8(sp)
ffffffffc020913e:	6902                	ld	s2,0(sp)
ffffffffc0209140:	6105                	addi	sp,sp,32
ffffffffc0209142:	8082                	ret
ffffffffc0209144:	6442                	ld	s0,16(sp)
ffffffffc0209146:	60e2                	ld	ra,24(sp)
ffffffffc0209148:	64a2                	ld	s1,8(sp)
ffffffffc020914a:	86ca                	mv	a3,s2
ffffffffc020914c:	6902                	ld	s2,0(sp)
ffffffffc020914e:	872a                	mv	a4,a0
ffffffffc0209150:	00006617          	auipc	a2,0x6
ffffffffc0209154:	bc060613          	addi	a2,a2,-1088 # ffffffffc020ed10 <dev_node_ops+0x460>
ffffffffc0209158:	05f00593          	li	a1,95
ffffffffc020915c:	00006517          	auipc	a0,0x6
ffffffffc0209160:	b6450513          	addi	a0,a0,-1180 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc0209164:	6105                	addi	sp,sp,32
ffffffffc0209166:	ba0f706f          	j	ffffffffc0200506 <__warn>
ffffffffc020916a:	00006697          	auipc	a3,0x6
ffffffffc020916e:	b2668693          	addi	a3,a3,-1242 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc0209172:	00002617          	auipc	a2,0x2
ffffffffc0209176:	79660613          	addi	a2,a2,1942 # ffffffffc020b908 <commands+0x210>
ffffffffc020917a:	05400593          	li	a1,84
ffffffffc020917e:	00006517          	auipc	a0,0x6
ffffffffc0209182:	b4250513          	addi	a0,a0,-1214 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc0209186:	b18f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020918a <sfs_sync>:
ffffffffc020918a:	7179                	addi	sp,sp,-48
ffffffffc020918c:	f406                	sd	ra,40(sp)
ffffffffc020918e:	f022                	sd	s0,32(sp)
ffffffffc0209190:	ec26                	sd	s1,24(sp)
ffffffffc0209192:	e84a                	sd	s2,16(sp)
ffffffffc0209194:	e44e                	sd	s3,8(sp)
ffffffffc0209196:	e052                	sd	s4,0(sp)
ffffffffc0209198:	cd4d                	beqz	a0,ffffffffc0209252 <sfs_sync+0xc8>
ffffffffc020919a:	0b052783          	lw	a5,176(a0)
ffffffffc020919e:	8a2a                	mv	s4,a0
ffffffffc02091a0:	ebcd                	bnez	a5,ffffffffc0209252 <sfs_sync+0xc8>
ffffffffc02091a2:	52f010ef          	jal	ra,ffffffffc020aed0 <lock_sfs_fs>
ffffffffc02091a6:	0a0a3403          	ld	s0,160(s4)
ffffffffc02091aa:	098a0913          	addi	s2,s4,152
ffffffffc02091ae:	02890763          	beq	s2,s0,ffffffffc02091dc <sfs_sync+0x52>
ffffffffc02091b2:	00004997          	auipc	s3,0x4
ffffffffc02091b6:	0de98993          	addi	s3,s3,222 # ffffffffc020d290 <default_pmm_manager+0xea0>
ffffffffc02091ba:	7c1c                	ld	a5,56(s0)
ffffffffc02091bc:	fc840493          	addi	s1,s0,-56
ffffffffc02091c0:	cbb5                	beqz	a5,ffffffffc0209234 <sfs_sync+0xaa>
ffffffffc02091c2:	7b9c                	ld	a5,48(a5)
ffffffffc02091c4:	cba5                	beqz	a5,ffffffffc0209234 <sfs_sync+0xaa>
ffffffffc02091c6:	85ce                	mv	a1,s3
ffffffffc02091c8:	8526                	mv	a0,s1
ffffffffc02091ca:	e28fe0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02091ce:	7c1c                	ld	a5,56(s0)
ffffffffc02091d0:	8526                	mv	a0,s1
ffffffffc02091d2:	7b9c                	ld	a5,48(a5)
ffffffffc02091d4:	9782                	jalr	a5
ffffffffc02091d6:	6400                	ld	s0,8(s0)
ffffffffc02091d8:	fe8911e3          	bne	s2,s0,ffffffffc02091ba <sfs_sync+0x30>
ffffffffc02091dc:	8552                	mv	a0,s4
ffffffffc02091de:	503010ef          	jal	ra,ffffffffc020aee0 <unlock_sfs_fs>
ffffffffc02091e2:	040a3783          	ld	a5,64(s4)
ffffffffc02091e6:	4501                	li	a0,0
ffffffffc02091e8:	eb89                	bnez	a5,ffffffffc02091fa <sfs_sync+0x70>
ffffffffc02091ea:	70a2                	ld	ra,40(sp)
ffffffffc02091ec:	7402                	ld	s0,32(sp)
ffffffffc02091ee:	64e2                	ld	s1,24(sp)
ffffffffc02091f0:	6942                	ld	s2,16(sp)
ffffffffc02091f2:	69a2                	ld	s3,8(sp)
ffffffffc02091f4:	6a02                	ld	s4,0(sp)
ffffffffc02091f6:	6145                	addi	sp,sp,48
ffffffffc02091f8:	8082                	ret
ffffffffc02091fa:	040a3023          	sd	zero,64(s4)
ffffffffc02091fe:	8552                	mv	a0,s4
ffffffffc0209200:	3b5010ef          	jal	ra,ffffffffc020adb4 <sfs_sync_super>
ffffffffc0209204:	cd01                	beqz	a0,ffffffffc020921c <sfs_sync+0x92>
ffffffffc0209206:	70a2                	ld	ra,40(sp)
ffffffffc0209208:	7402                	ld	s0,32(sp)
ffffffffc020920a:	4785                	li	a5,1
ffffffffc020920c:	04fa3023          	sd	a5,64(s4)
ffffffffc0209210:	64e2                	ld	s1,24(sp)
ffffffffc0209212:	6942                	ld	s2,16(sp)
ffffffffc0209214:	69a2                	ld	s3,8(sp)
ffffffffc0209216:	6a02                	ld	s4,0(sp)
ffffffffc0209218:	6145                	addi	sp,sp,48
ffffffffc020921a:	8082                	ret
ffffffffc020921c:	8552                	mv	a0,s4
ffffffffc020921e:	3dd010ef          	jal	ra,ffffffffc020adfa <sfs_sync_freemap>
ffffffffc0209222:	f175                	bnez	a0,ffffffffc0209206 <sfs_sync+0x7c>
ffffffffc0209224:	70a2                	ld	ra,40(sp)
ffffffffc0209226:	7402                	ld	s0,32(sp)
ffffffffc0209228:	64e2                	ld	s1,24(sp)
ffffffffc020922a:	6942                	ld	s2,16(sp)
ffffffffc020922c:	69a2                	ld	s3,8(sp)
ffffffffc020922e:	6a02                	ld	s4,0(sp)
ffffffffc0209230:	6145                	addi	sp,sp,48
ffffffffc0209232:	8082                	ret
ffffffffc0209234:	00004697          	auipc	a3,0x4
ffffffffc0209238:	00c68693          	addi	a3,a3,12 # ffffffffc020d240 <default_pmm_manager+0xe50>
ffffffffc020923c:	00002617          	auipc	a2,0x2
ffffffffc0209240:	6cc60613          	addi	a2,a2,1740 # ffffffffc020b908 <commands+0x210>
ffffffffc0209244:	45ed                	li	a1,27
ffffffffc0209246:	00006517          	auipc	a0,0x6
ffffffffc020924a:	a7a50513          	addi	a0,a0,-1414 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc020924e:	a50f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209252:	00006697          	auipc	a3,0x6
ffffffffc0209256:	a3e68693          	addi	a3,a3,-1474 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020925a:	00002617          	auipc	a2,0x2
ffffffffc020925e:	6ae60613          	addi	a2,a2,1710 # ffffffffc020b908 <commands+0x210>
ffffffffc0209262:	45d5                	li	a1,21
ffffffffc0209264:	00006517          	auipc	a0,0x6
ffffffffc0209268:	a5c50513          	addi	a0,a0,-1444 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc020926c:	a32f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209270 <sfs_get_root>:
ffffffffc0209270:	1101                	addi	sp,sp,-32
ffffffffc0209272:	ec06                	sd	ra,24(sp)
ffffffffc0209274:	cd09                	beqz	a0,ffffffffc020928e <sfs_get_root+0x1e>
ffffffffc0209276:	0b052783          	lw	a5,176(a0)
ffffffffc020927a:	eb91                	bnez	a5,ffffffffc020928e <sfs_get_root+0x1e>
ffffffffc020927c:	4605                	li	a2,1
ffffffffc020927e:	002c                	addi	a1,sp,8
ffffffffc0209280:	366010ef          	jal	ra,ffffffffc020a5e6 <sfs_load_inode>
ffffffffc0209284:	e50d                	bnez	a0,ffffffffc02092ae <sfs_get_root+0x3e>
ffffffffc0209286:	60e2                	ld	ra,24(sp)
ffffffffc0209288:	6522                	ld	a0,8(sp)
ffffffffc020928a:	6105                	addi	sp,sp,32
ffffffffc020928c:	8082                	ret
ffffffffc020928e:	00006697          	auipc	a3,0x6
ffffffffc0209292:	a0268693          	addi	a3,a3,-1534 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc0209296:	00002617          	auipc	a2,0x2
ffffffffc020929a:	67260613          	addi	a2,a2,1650 # ffffffffc020b908 <commands+0x210>
ffffffffc020929e:	03600593          	li	a1,54
ffffffffc02092a2:	00006517          	auipc	a0,0x6
ffffffffc02092a6:	a1e50513          	addi	a0,a0,-1506 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc02092aa:	9f4f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02092ae:	86aa                	mv	a3,a0
ffffffffc02092b0:	00006617          	auipc	a2,0x6
ffffffffc02092b4:	a8060613          	addi	a2,a2,-1408 # ffffffffc020ed30 <dev_node_ops+0x480>
ffffffffc02092b8:	03700593          	li	a1,55
ffffffffc02092bc:	00006517          	auipc	a0,0x6
ffffffffc02092c0:	a0450513          	addi	a0,a0,-1532 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc02092c4:	9daf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02092c8 <sfs_do_mount>:
ffffffffc02092c8:	6518                	ld	a4,8(a0)
ffffffffc02092ca:	7171                	addi	sp,sp,-176
ffffffffc02092cc:	f506                	sd	ra,168(sp)
ffffffffc02092ce:	f122                	sd	s0,160(sp)
ffffffffc02092d0:	ed26                	sd	s1,152(sp)
ffffffffc02092d2:	e94a                	sd	s2,144(sp)
ffffffffc02092d4:	e54e                	sd	s3,136(sp)
ffffffffc02092d6:	e152                	sd	s4,128(sp)
ffffffffc02092d8:	fcd6                	sd	s5,120(sp)
ffffffffc02092da:	f8da                	sd	s6,112(sp)
ffffffffc02092dc:	f4de                	sd	s7,104(sp)
ffffffffc02092de:	f0e2                	sd	s8,96(sp)
ffffffffc02092e0:	ece6                	sd	s9,88(sp)
ffffffffc02092e2:	e8ea                	sd	s10,80(sp)
ffffffffc02092e4:	e4ee                	sd	s11,72(sp)
ffffffffc02092e6:	6785                	lui	a5,0x1
ffffffffc02092e8:	24f71663          	bne	a4,a5,ffffffffc0209534 <sfs_do_mount+0x26c>
ffffffffc02092ec:	892a                	mv	s2,a0
ffffffffc02092ee:	4501                	li	a0,0
ffffffffc02092f0:	8aae                	mv	s5,a1
ffffffffc02092f2:	f00fe0ef          	jal	ra,ffffffffc02079f2 <__alloc_fs>
ffffffffc02092f6:	842a                	mv	s0,a0
ffffffffc02092f8:	24050463          	beqz	a0,ffffffffc0209540 <sfs_do_mount+0x278>
ffffffffc02092fc:	0b052b03          	lw	s6,176(a0)
ffffffffc0209300:	260b1263          	bnez	s6,ffffffffc0209564 <sfs_do_mount+0x29c>
ffffffffc0209304:	03253823          	sd	s2,48(a0)
ffffffffc0209308:	6505                	lui	a0,0x1
ffffffffc020930a:	c85f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020930e:	e428                	sd	a0,72(s0)
ffffffffc0209310:	84aa                	mv	s1,a0
ffffffffc0209312:	16050363          	beqz	a0,ffffffffc0209478 <sfs_do_mount+0x1b0>
ffffffffc0209316:	85aa                	mv	a1,a0
ffffffffc0209318:	4681                	li	a3,0
ffffffffc020931a:	6605                	lui	a2,0x1
ffffffffc020931c:	1008                	addi	a0,sp,32
ffffffffc020931e:	8c4fc0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0209322:	02093783          	ld	a5,32(s2)
ffffffffc0209326:	85aa                	mv	a1,a0
ffffffffc0209328:	4601                	li	a2,0
ffffffffc020932a:	854a                	mv	a0,s2
ffffffffc020932c:	9782                	jalr	a5
ffffffffc020932e:	8a2a                	mv	s4,a0
ffffffffc0209330:	10051e63          	bnez	a0,ffffffffc020944c <sfs_do_mount+0x184>
ffffffffc0209334:	408c                	lw	a1,0(s1)
ffffffffc0209336:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc020933a:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc020933e:	14c59863          	bne	a1,a2,ffffffffc020948e <sfs_do_mount+0x1c6>
ffffffffc0209342:	40dc                	lw	a5,4(s1)
ffffffffc0209344:	00093603          	ld	a2,0(s2)
ffffffffc0209348:	02079713          	slli	a4,a5,0x20
ffffffffc020934c:	9301                	srli	a4,a4,0x20
ffffffffc020934e:	12e66763          	bltu	a2,a4,ffffffffc020947c <sfs_do_mount+0x1b4>
ffffffffc0209352:	020485a3          	sb	zero,43(s1)
ffffffffc0209356:	0084af03          	lw	t5,8(s1)
ffffffffc020935a:	00c4ae83          	lw	t4,12(s1)
ffffffffc020935e:	0104ae03          	lw	t3,16(s1)
ffffffffc0209362:	0144a303          	lw	t1,20(s1)
ffffffffc0209366:	0184a883          	lw	a7,24(s1)
ffffffffc020936a:	01c4a803          	lw	a6,28(s1)
ffffffffc020936e:	5090                	lw	a2,32(s1)
ffffffffc0209370:	50d4                	lw	a3,36(s1)
ffffffffc0209372:	5498                	lw	a4,40(s1)
ffffffffc0209374:	6511                	lui	a0,0x4
ffffffffc0209376:	c00c                	sw	a1,0(s0)
ffffffffc0209378:	c05c                	sw	a5,4(s0)
ffffffffc020937a:	01e42423          	sw	t5,8(s0)
ffffffffc020937e:	01d42623          	sw	t4,12(s0)
ffffffffc0209382:	01c42823          	sw	t3,16(s0)
ffffffffc0209386:	00642a23          	sw	t1,20(s0)
ffffffffc020938a:	01142c23          	sw	a7,24(s0)
ffffffffc020938e:	01042e23          	sw	a6,28(s0)
ffffffffc0209392:	d010                	sw	a2,32(s0)
ffffffffc0209394:	d054                	sw	a3,36(s0)
ffffffffc0209396:	d418                	sw	a4,40(s0)
ffffffffc0209398:	bf7f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020939c:	f448                	sd	a0,168(s0)
ffffffffc020939e:	8c2a                	mv	s8,a0
ffffffffc02093a0:	18050c63          	beqz	a0,ffffffffc0209538 <sfs_do_mount+0x270>
ffffffffc02093a4:	6711                	lui	a4,0x4
ffffffffc02093a6:	87aa                	mv	a5,a0
ffffffffc02093a8:	972a                	add	a4,a4,a0
ffffffffc02093aa:	e79c                	sd	a5,8(a5)
ffffffffc02093ac:	e39c                	sd	a5,0(a5)
ffffffffc02093ae:	07c1                	addi	a5,a5,16
ffffffffc02093b0:	fee79de3          	bne	a5,a4,ffffffffc02093aa <sfs_do_mount+0xe2>
ffffffffc02093b4:	0044eb83          	lwu	s7,4(s1)
ffffffffc02093b8:	67a1                	lui	a5,0x8
ffffffffc02093ba:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc02093be:	9bce                	add	s7,s7,s3
ffffffffc02093c0:	77e1                	lui	a5,0xffff8
ffffffffc02093c2:	00fbfbb3          	and	s7,s7,a5
ffffffffc02093c6:	2b81                	sext.w	s7,s7
ffffffffc02093c8:	855e                	mv	a0,s7
ffffffffc02093ca:	a59ff0ef          	jal	ra,ffffffffc0208e22 <bitmap_create>
ffffffffc02093ce:	fc08                	sd	a0,56(s0)
ffffffffc02093d0:	8d2a                	mv	s10,a0
ffffffffc02093d2:	14050f63          	beqz	a0,ffffffffc0209530 <sfs_do_mount+0x268>
ffffffffc02093d6:	0044e783          	lwu	a5,4(s1)
ffffffffc02093da:	082c                	addi	a1,sp,24
ffffffffc02093dc:	97ce                	add	a5,a5,s3
ffffffffc02093de:	00f7d713          	srli	a4,a5,0xf
ffffffffc02093e2:	e43a                	sd	a4,8(sp)
ffffffffc02093e4:	40f7d993          	srai	s3,a5,0xf
ffffffffc02093e8:	c4fff0ef          	jal	ra,ffffffffc0209036 <bitmap_getdata>
ffffffffc02093ec:	14050c63          	beqz	a0,ffffffffc0209544 <sfs_do_mount+0x27c>
ffffffffc02093f0:	00c9979b          	slliw	a5,s3,0xc
ffffffffc02093f4:	66e2                	ld	a3,24(sp)
ffffffffc02093f6:	1782                	slli	a5,a5,0x20
ffffffffc02093f8:	9381                	srli	a5,a5,0x20
ffffffffc02093fa:	14d79563          	bne	a5,a3,ffffffffc0209544 <sfs_do_mount+0x27c>
ffffffffc02093fe:	6722                	ld	a4,8(sp)
ffffffffc0209400:	6d89                	lui	s11,0x2
ffffffffc0209402:	89aa                	mv	s3,a0
ffffffffc0209404:	00c71c93          	slli	s9,a4,0xc
ffffffffc0209408:	9caa                	add	s9,s9,a0
ffffffffc020940a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020940e:	e711                	bnez	a4,ffffffffc020941a <sfs_do_mount+0x152>
ffffffffc0209410:	a079                	j	ffffffffc020949e <sfs_do_mount+0x1d6>
ffffffffc0209412:	6785                	lui	a5,0x1
ffffffffc0209414:	99be                	add	s3,s3,a5
ffffffffc0209416:	093c8463          	beq	s9,s3,ffffffffc020949e <sfs_do_mount+0x1d6>
ffffffffc020941a:	013d86bb          	addw	a3,s11,s3
ffffffffc020941e:	1682                	slli	a3,a3,0x20
ffffffffc0209420:	6605                	lui	a2,0x1
ffffffffc0209422:	85ce                	mv	a1,s3
ffffffffc0209424:	9281                	srli	a3,a3,0x20
ffffffffc0209426:	1008                	addi	a0,sp,32
ffffffffc0209428:	fbbfb0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc020942c:	02093783          	ld	a5,32(s2)
ffffffffc0209430:	85aa                	mv	a1,a0
ffffffffc0209432:	4601                	li	a2,0
ffffffffc0209434:	854a                	mv	a0,s2
ffffffffc0209436:	9782                	jalr	a5
ffffffffc0209438:	dd69                	beqz	a0,ffffffffc0209412 <sfs_do_mount+0x14a>
ffffffffc020943a:	e42a                	sd	a0,8(sp)
ffffffffc020943c:	856a                	mv	a0,s10
ffffffffc020943e:	bdfff0ef          	jal	ra,ffffffffc020901c <bitmap_destroy>
ffffffffc0209442:	67a2                	ld	a5,8(sp)
ffffffffc0209444:	8a3e                	mv	s4,a5
ffffffffc0209446:	8562                	mv	a0,s8
ffffffffc0209448:	bf7f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020944c:	8526                	mv	a0,s1
ffffffffc020944e:	bf1f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209452:	8522                	mv	a0,s0
ffffffffc0209454:	bebf80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209458:	70aa                	ld	ra,168(sp)
ffffffffc020945a:	740a                	ld	s0,160(sp)
ffffffffc020945c:	64ea                	ld	s1,152(sp)
ffffffffc020945e:	694a                	ld	s2,144(sp)
ffffffffc0209460:	69aa                	ld	s3,136(sp)
ffffffffc0209462:	7ae6                	ld	s5,120(sp)
ffffffffc0209464:	7b46                	ld	s6,112(sp)
ffffffffc0209466:	7ba6                	ld	s7,104(sp)
ffffffffc0209468:	7c06                	ld	s8,96(sp)
ffffffffc020946a:	6ce6                	ld	s9,88(sp)
ffffffffc020946c:	6d46                	ld	s10,80(sp)
ffffffffc020946e:	6da6                	ld	s11,72(sp)
ffffffffc0209470:	8552                	mv	a0,s4
ffffffffc0209472:	6a0a                	ld	s4,128(sp)
ffffffffc0209474:	614d                	addi	sp,sp,176
ffffffffc0209476:	8082                	ret
ffffffffc0209478:	5a71                	li	s4,-4
ffffffffc020947a:	bfe1                	j	ffffffffc0209452 <sfs_do_mount+0x18a>
ffffffffc020947c:	85be                	mv	a1,a5
ffffffffc020947e:	00006517          	auipc	a0,0x6
ffffffffc0209482:	90a50513          	addi	a0,a0,-1782 # ffffffffc020ed88 <dev_node_ops+0x4d8>
ffffffffc0209486:	d21f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020948a:	5a75                	li	s4,-3
ffffffffc020948c:	b7c1                	j	ffffffffc020944c <sfs_do_mount+0x184>
ffffffffc020948e:	00006517          	auipc	a0,0x6
ffffffffc0209492:	8c250513          	addi	a0,a0,-1854 # ffffffffc020ed50 <dev_node_ops+0x4a0>
ffffffffc0209496:	d11f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020949a:	5a75                	li	s4,-3
ffffffffc020949c:	bf45                	j	ffffffffc020944c <sfs_do_mount+0x184>
ffffffffc020949e:	00442903          	lw	s2,4(s0)
ffffffffc02094a2:	4481                	li	s1,0
ffffffffc02094a4:	080b8c63          	beqz	s7,ffffffffc020953c <sfs_do_mount+0x274>
ffffffffc02094a8:	85a6                	mv	a1,s1
ffffffffc02094aa:	856a                	mv	a0,s10
ffffffffc02094ac:	af7ff0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc02094b0:	c111                	beqz	a0,ffffffffc02094b4 <sfs_do_mount+0x1ec>
ffffffffc02094b2:	2b05                	addiw	s6,s6,1
ffffffffc02094b4:	2485                	addiw	s1,s1,1
ffffffffc02094b6:	fe9b99e3          	bne	s7,s1,ffffffffc02094a8 <sfs_do_mount+0x1e0>
ffffffffc02094ba:	441c                	lw	a5,8(s0)
ffffffffc02094bc:	0d679463          	bne	a5,s6,ffffffffc0209584 <sfs_do_mount+0x2bc>
ffffffffc02094c0:	4585                	li	a1,1
ffffffffc02094c2:	05040513          	addi	a0,s0,80
ffffffffc02094c6:	04043023          	sd	zero,64(s0)
ffffffffc02094ca:	890fb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02094ce:	4585                	li	a1,1
ffffffffc02094d0:	06840513          	addi	a0,s0,104
ffffffffc02094d4:	886fb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02094d8:	4585                	li	a1,1
ffffffffc02094da:	08040513          	addi	a0,s0,128
ffffffffc02094de:	87cfb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02094e2:	09840793          	addi	a5,s0,152
ffffffffc02094e6:	f05c                	sd	a5,160(s0)
ffffffffc02094e8:	ec5c                	sd	a5,152(s0)
ffffffffc02094ea:	874a                	mv	a4,s2
ffffffffc02094ec:	86da                	mv	a3,s6
ffffffffc02094ee:	4169063b          	subw	a2,s2,s6
ffffffffc02094f2:	00c40593          	addi	a1,s0,12
ffffffffc02094f6:	00006517          	auipc	a0,0x6
ffffffffc02094fa:	92250513          	addi	a0,a0,-1758 # ffffffffc020ee18 <dev_node_ops+0x568>
ffffffffc02094fe:	ca9f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209502:	00000797          	auipc	a5,0x0
ffffffffc0209506:	c8878793          	addi	a5,a5,-888 # ffffffffc020918a <sfs_sync>
ffffffffc020950a:	fc5c                	sd	a5,184(s0)
ffffffffc020950c:	00000797          	auipc	a5,0x0
ffffffffc0209510:	d6478793          	addi	a5,a5,-668 # ffffffffc0209270 <sfs_get_root>
ffffffffc0209514:	e07c                	sd	a5,192(s0)
ffffffffc0209516:	00000797          	auipc	a5,0x0
ffffffffc020951a:	b5e78793          	addi	a5,a5,-1186 # ffffffffc0209074 <sfs_unmount>
ffffffffc020951e:	e47c                	sd	a5,200(s0)
ffffffffc0209520:	00000797          	auipc	a5,0x0
ffffffffc0209524:	bd878793          	addi	a5,a5,-1064 # ffffffffc02090f8 <sfs_cleanup>
ffffffffc0209528:	e87c                	sd	a5,208(s0)
ffffffffc020952a:	008ab023          	sd	s0,0(s5)
ffffffffc020952e:	b72d                	j	ffffffffc0209458 <sfs_do_mount+0x190>
ffffffffc0209530:	5a71                	li	s4,-4
ffffffffc0209532:	bf11                	j	ffffffffc0209446 <sfs_do_mount+0x17e>
ffffffffc0209534:	5a49                	li	s4,-14
ffffffffc0209536:	b70d                	j	ffffffffc0209458 <sfs_do_mount+0x190>
ffffffffc0209538:	5a71                	li	s4,-4
ffffffffc020953a:	bf09                	j	ffffffffc020944c <sfs_do_mount+0x184>
ffffffffc020953c:	4b01                	li	s6,0
ffffffffc020953e:	bfb5                	j	ffffffffc02094ba <sfs_do_mount+0x1f2>
ffffffffc0209540:	5a71                	li	s4,-4
ffffffffc0209542:	bf19                	j	ffffffffc0209458 <sfs_do_mount+0x190>
ffffffffc0209544:	00006697          	auipc	a3,0x6
ffffffffc0209548:	87468693          	addi	a3,a3,-1932 # ffffffffc020edb8 <dev_node_ops+0x508>
ffffffffc020954c:	00002617          	auipc	a2,0x2
ffffffffc0209550:	3bc60613          	addi	a2,a2,956 # ffffffffc020b908 <commands+0x210>
ffffffffc0209554:	08300593          	li	a1,131
ffffffffc0209558:	00005517          	auipc	a0,0x5
ffffffffc020955c:	76850513          	addi	a0,a0,1896 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc0209560:	f3ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209564:	00005697          	auipc	a3,0x5
ffffffffc0209568:	72c68693          	addi	a3,a3,1836 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020956c:	00002617          	auipc	a2,0x2
ffffffffc0209570:	39c60613          	addi	a2,a2,924 # ffffffffc020b908 <commands+0x210>
ffffffffc0209574:	0a300593          	li	a1,163
ffffffffc0209578:	00005517          	auipc	a0,0x5
ffffffffc020957c:	74850513          	addi	a0,a0,1864 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc0209580:	f1ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209584:	00006697          	auipc	a3,0x6
ffffffffc0209588:	86468693          	addi	a3,a3,-1948 # ffffffffc020ede8 <dev_node_ops+0x538>
ffffffffc020958c:	00002617          	auipc	a2,0x2
ffffffffc0209590:	37c60613          	addi	a2,a2,892 # ffffffffc020b908 <commands+0x210>
ffffffffc0209594:	0e000593          	li	a1,224
ffffffffc0209598:	00005517          	auipc	a0,0x5
ffffffffc020959c:	72850513          	addi	a0,a0,1832 # ffffffffc020ecc0 <dev_node_ops+0x410>
ffffffffc02095a0:	efff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02095a4 <sfs_mount>:
ffffffffc02095a4:	00000597          	auipc	a1,0x0
ffffffffc02095a8:	d2458593          	addi	a1,a1,-732 # ffffffffc02092c8 <sfs_do_mount>
ffffffffc02095ac:	817fe06f          	j	ffffffffc0207dc2 <vfs_mount>

ffffffffc02095b0 <sfs_opendir>:
ffffffffc02095b0:	0235f593          	andi	a1,a1,35
ffffffffc02095b4:	4501                	li	a0,0
ffffffffc02095b6:	e191                	bnez	a1,ffffffffc02095ba <sfs_opendir+0xa>
ffffffffc02095b8:	8082                	ret
ffffffffc02095ba:	553d                	li	a0,-17
ffffffffc02095bc:	8082                	ret

ffffffffc02095be <sfs_openfile>:
ffffffffc02095be:	4501                	li	a0,0
ffffffffc02095c0:	8082                	ret

ffffffffc02095c2 <sfs_gettype>:
ffffffffc02095c2:	1141                	addi	sp,sp,-16
ffffffffc02095c4:	e406                	sd	ra,8(sp)
ffffffffc02095c6:	c939                	beqz	a0,ffffffffc020961c <sfs_gettype+0x5a>
ffffffffc02095c8:	4d34                	lw	a3,88(a0)
ffffffffc02095ca:	6785                	lui	a5,0x1
ffffffffc02095cc:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02095d0:	04e69663          	bne	a3,a4,ffffffffc020961c <sfs_gettype+0x5a>
ffffffffc02095d4:	6114                	ld	a3,0(a0)
ffffffffc02095d6:	4709                	li	a4,2
ffffffffc02095d8:	0046d683          	lhu	a3,4(a3)
ffffffffc02095dc:	02e68a63          	beq	a3,a4,ffffffffc0209610 <sfs_gettype+0x4e>
ffffffffc02095e0:	470d                	li	a4,3
ffffffffc02095e2:	02e68163          	beq	a3,a4,ffffffffc0209604 <sfs_gettype+0x42>
ffffffffc02095e6:	4705                	li	a4,1
ffffffffc02095e8:	00e68f63          	beq	a3,a4,ffffffffc0209606 <sfs_gettype+0x44>
ffffffffc02095ec:	00006617          	auipc	a2,0x6
ffffffffc02095f0:	89c60613          	addi	a2,a2,-1892 # ffffffffc020ee88 <dev_node_ops+0x5d8>
ffffffffc02095f4:	39100593          	li	a1,913
ffffffffc02095f8:	00006517          	auipc	a0,0x6
ffffffffc02095fc:	87850513          	addi	a0,a0,-1928 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209600:	e9ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209604:	678d                	lui	a5,0x3
ffffffffc0209606:	60a2                	ld	ra,8(sp)
ffffffffc0209608:	c19c                	sw	a5,0(a1)
ffffffffc020960a:	4501                	li	a0,0
ffffffffc020960c:	0141                	addi	sp,sp,16
ffffffffc020960e:	8082                	ret
ffffffffc0209610:	60a2                	ld	ra,8(sp)
ffffffffc0209612:	6789                	lui	a5,0x2
ffffffffc0209614:	c19c                	sw	a5,0(a1)
ffffffffc0209616:	4501                	li	a0,0
ffffffffc0209618:	0141                	addi	sp,sp,16
ffffffffc020961a:	8082                	ret
ffffffffc020961c:	00006697          	auipc	a3,0x6
ffffffffc0209620:	81c68693          	addi	a3,a3,-2020 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc0209624:	00002617          	auipc	a2,0x2
ffffffffc0209628:	2e460613          	addi	a2,a2,740 # ffffffffc020b908 <commands+0x210>
ffffffffc020962c:	38500593          	li	a1,901
ffffffffc0209630:	00006517          	auipc	a0,0x6
ffffffffc0209634:	84050513          	addi	a0,a0,-1984 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209638:	e67f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020963c <sfs_fsync>:
ffffffffc020963c:	7179                	addi	sp,sp,-48
ffffffffc020963e:	ec26                	sd	s1,24(sp)
ffffffffc0209640:	7524                	ld	s1,104(a0)
ffffffffc0209642:	f406                	sd	ra,40(sp)
ffffffffc0209644:	f022                	sd	s0,32(sp)
ffffffffc0209646:	e84a                	sd	s2,16(sp)
ffffffffc0209648:	e44e                	sd	s3,8(sp)
ffffffffc020964a:	c4bd                	beqz	s1,ffffffffc02096b8 <sfs_fsync+0x7c>
ffffffffc020964c:	0b04a783          	lw	a5,176(s1)
ffffffffc0209650:	e7a5                	bnez	a5,ffffffffc02096b8 <sfs_fsync+0x7c>
ffffffffc0209652:	4d38                	lw	a4,88(a0)
ffffffffc0209654:	6785                	lui	a5,0x1
ffffffffc0209656:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020965a:	842a                	mv	s0,a0
ffffffffc020965c:	06f71e63          	bne	a4,a5,ffffffffc02096d8 <sfs_fsync+0x9c>
ffffffffc0209660:	691c                	ld	a5,16(a0)
ffffffffc0209662:	4901                	li	s2,0
ffffffffc0209664:	eb89                	bnez	a5,ffffffffc0209676 <sfs_fsync+0x3a>
ffffffffc0209666:	70a2                	ld	ra,40(sp)
ffffffffc0209668:	7402                	ld	s0,32(sp)
ffffffffc020966a:	64e2                	ld	s1,24(sp)
ffffffffc020966c:	69a2                	ld	s3,8(sp)
ffffffffc020966e:	854a                	mv	a0,s2
ffffffffc0209670:	6942                	ld	s2,16(sp)
ffffffffc0209672:	6145                	addi	sp,sp,48
ffffffffc0209674:	8082                	ret
ffffffffc0209676:	02050993          	addi	s3,a0,32
ffffffffc020967a:	854e                	mv	a0,s3
ffffffffc020967c:	ee9fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0209680:	681c                	ld	a5,16(s0)
ffffffffc0209682:	ef81                	bnez	a5,ffffffffc020969a <sfs_fsync+0x5e>
ffffffffc0209684:	854e                	mv	a0,s3
ffffffffc0209686:	edbfa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020968a:	70a2                	ld	ra,40(sp)
ffffffffc020968c:	7402                	ld	s0,32(sp)
ffffffffc020968e:	64e2                	ld	s1,24(sp)
ffffffffc0209690:	69a2                	ld	s3,8(sp)
ffffffffc0209692:	854a                	mv	a0,s2
ffffffffc0209694:	6942                	ld	s2,16(sp)
ffffffffc0209696:	6145                	addi	sp,sp,48
ffffffffc0209698:	8082                	ret
ffffffffc020969a:	4414                	lw	a3,8(s0)
ffffffffc020969c:	600c                	ld	a1,0(s0)
ffffffffc020969e:	00043823          	sd	zero,16(s0)
ffffffffc02096a2:	4701                	li	a4,0
ffffffffc02096a4:	04000613          	li	a2,64
ffffffffc02096a8:	8526                	mv	a0,s1
ffffffffc02096aa:	676010ef          	jal	ra,ffffffffc020ad20 <sfs_wbuf>
ffffffffc02096ae:	892a                	mv	s2,a0
ffffffffc02096b0:	d971                	beqz	a0,ffffffffc0209684 <sfs_fsync+0x48>
ffffffffc02096b2:	4785                	li	a5,1
ffffffffc02096b4:	e81c                	sd	a5,16(s0)
ffffffffc02096b6:	b7f9                	j	ffffffffc0209684 <sfs_fsync+0x48>
ffffffffc02096b8:	00005697          	auipc	a3,0x5
ffffffffc02096bc:	5d868693          	addi	a3,a3,1496 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc02096c0:	00002617          	auipc	a2,0x2
ffffffffc02096c4:	24860613          	addi	a2,a2,584 # ffffffffc020b908 <commands+0x210>
ffffffffc02096c8:	2c900593          	li	a1,713
ffffffffc02096cc:	00005517          	auipc	a0,0x5
ffffffffc02096d0:	7a450513          	addi	a0,a0,1956 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc02096d4:	dcbf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02096d8:	00005697          	auipc	a3,0x5
ffffffffc02096dc:	76068693          	addi	a3,a3,1888 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc02096e0:	00002617          	auipc	a2,0x2
ffffffffc02096e4:	22860613          	addi	a2,a2,552 # ffffffffc020b908 <commands+0x210>
ffffffffc02096e8:	2ca00593          	li	a1,714
ffffffffc02096ec:	00005517          	auipc	a0,0x5
ffffffffc02096f0:	78450513          	addi	a0,a0,1924 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc02096f4:	dabf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02096f8 <sfs_fstat>:
ffffffffc02096f8:	1101                	addi	sp,sp,-32
ffffffffc02096fa:	e426                	sd	s1,8(sp)
ffffffffc02096fc:	84ae                	mv	s1,a1
ffffffffc02096fe:	e822                	sd	s0,16(sp)
ffffffffc0209700:	02000613          	li	a2,32
ffffffffc0209704:	842a                	mv	s0,a0
ffffffffc0209706:	4581                	li	a1,0
ffffffffc0209708:	8526                	mv	a0,s1
ffffffffc020970a:	ec06                	sd	ra,24(sp)
ffffffffc020970c:	519010ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc0209710:	c439                	beqz	s0,ffffffffc020975e <sfs_fstat+0x66>
ffffffffc0209712:	783c                	ld	a5,112(s0)
ffffffffc0209714:	c7a9                	beqz	a5,ffffffffc020975e <sfs_fstat+0x66>
ffffffffc0209716:	6bbc                	ld	a5,80(a5)
ffffffffc0209718:	c3b9                	beqz	a5,ffffffffc020975e <sfs_fstat+0x66>
ffffffffc020971a:	00005597          	auipc	a1,0x5
ffffffffc020971e:	10e58593          	addi	a1,a1,270 # ffffffffc020e828 <syscalls+0xdb0>
ffffffffc0209722:	8522                	mv	a0,s0
ffffffffc0209724:	8cefe0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0209728:	783c                	ld	a5,112(s0)
ffffffffc020972a:	85a6                	mv	a1,s1
ffffffffc020972c:	8522                	mv	a0,s0
ffffffffc020972e:	6bbc                	ld	a5,80(a5)
ffffffffc0209730:	9782                	jalr	a5
ffffffffc0209732:	e10d                	bnez	a0,ffffffffc0209754 <sfs_fstat+0x5c>
ffffffffc0209734:	4c38                	lw	a4,88(s0)
ffffffffc0209736:	6785                	lui	a5,0x1
ffffffffc0209738:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020973c:	04f71163          	bne	a4,a5,ffffffffc020977e <sfs_fstat+0x86>
ffffffffc0209740:	601c                	ld	a5,0(s0)
ffffffffc0209742:	0067d683          	lhu	a3,6(a5)
ffffffffc0209746:	0087e703          	lwu	a4,8(a5)
ffffffffc020974a:	0007e783          	lwu	a5,0(a5)
ffffffffc020974e:	e494                	sd	a3,8(s1)
ffffffffc0209750:	e898                	sd	a4,16(s1)
ffffffffc0209752:	ec9c                	sd	a5,24(s1)
ffffffffc0209754:	60e2                	ld	ra,24(sp)
ffffffffc0209756:	6442                	ld	s0,16(sp)
ffffffffc0209758:	64a2                	ld	s1,8(sp)
ffffffffc020975a:	6105                	addi	sp,sp,32
ffffffffc020975c:	8082                	ret
ffffffffc020975e:	00005697          	auipc	a3,0x5
ffffffffc0209762:	06268693          	addi	a3,a3,98 # ffffffffc020e7c0 <syscalls+0xd48>
ffffffffc0209766:	00002617          	auipc	a2,0x2
ffffffffc020976a:	1a260613          	addi	a2,a2,418 # ffffffffc020b908 <commands+0x210>
ffffffffc020976e:	2ba00593          	li	a1,698
ffffffffc0209772:	00005517          	auipc	a0,0x5
ffffffffc0209776:	6fe50513          	addi	a0,a0,1790 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020977a:	d25f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020977e:	00005697          	auipc	a3,0x5
ffffffffc0209782:	6ba68693          	addi	a3,a3,1722 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc0209786:	00002617          	auipc	a2,0x2
ffffffffc020978a:	18260613          	addi	a2,a2,386 # ffffffffc020b908 <commands+0x210>
ffffffffc020978e:	2bd00593          	li	a1,701
ffffffffc0209792:	00005517          	auipc	a0,0x5
ffffffffc0209796:	6de50513          	addi	a0,a0,1758 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020979a:	d05f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020979e <sfs_tryseek>:
ffffffffc020979e:	080007b7          	lui	a5,0x8000
ffffffffc02097a2:	04f5fd63          	bgeu	a1,a5,ffffffffc02097fc <sfs_tryseek+0x5e>
ffffffffc02097a6:	1101                	addi	sp,sp,-32
ffffffffc02097a8:	e822                	sd	s0,16(sp)
ffffffffc02097aa:	ec06                	sd	ra,24(sp)
ffffffffc02097ac:	e426                	sd	s1,8(sp)
ffffffffc02097ae:	842a                	mv	s0,a0
ffffffffc02097b0:	c921                	beqz	a0,ffffffffc0209800 <sfs_tryseek+0x62>
ffffffffc02097b2:	4d38                	lw	a4,88(a0)
ffffffffc02097b4:	6785                	lui	a5,0x1
ffffffffc02097b6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02097ba:	04f71363          	bne	a4,a5,ffffffffc0209800 <sfs_tryseek+0x62>
ffffffffc02097be:	611c                	ld	a5,0(a0)
ffffffffc02097c0:	84ae                	mv	s1,a1
ffffffffc02097c2:	0007e783          	lwu	a5,0(a5)
ffffffffc02097c6:	02b7d563          	bge	a5,a1,ffffffffc02097f0 <sfs_tryseek+0x52>
ffffffffc02097ca:	793c                	ld	a5,112(a0)
ffffffffc02097cc:	cbb1                	beqz	a5,ffffffffc0209820 <sfs_tryseek+0x82>
ffffffffc02097ce:	73bc                	ld	a5,96(a5)
ffffffffc02097d0:	cba1                	beqz	a5,ffffffffc0209820 <sfs_tryseek+0x82>
ffffffffc02097d2:	00005597          	auipc	a1,0x5
ffffffffc02097d6:	f4658593          	addi	a1,a1,-186 # ffffffffc020e718 <syscalls+0xca0>
ffffffffc02097da:	818fe0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02097de:	783c                	ld	a5,112(s0)
ffffffffc02097e0:	8522                	mv	a0,s0
ffffffffc02097e2:	6442                	ld	s0,16(sp)
ffffffffc02097e4:	60e2                	ld	ra,24(sp)
ffffffffc02097e6:	73bc                	ld	a5,96(a5)
ffffffffc02097e8:	85a6                	mv	a1,s1
ffffffffc02097ea:	64a2                	ld	s1,8(sp)
ffffffffc02097ec:	6105                	addi	sp,sp,32
ffffffffc02097ee:	8782                	jr	a5
ffffffffc02097f0:	60e2                	ld	ra,24(sp)
ffffffffc02097f2:	6442                	ld	s0,16(sp)
ffffffffc02097f4:	64a2                	ld	s1,8(sp)
ffffffffc02097f6:	4501                	li	a0,0
ffffffffc02097f8:	6105                	addi	sp,sp,32
ffffffffc02097fa:	8082                	ret
ffffffffc02097fc:	5575                	li	a0,-3
ffffffffc02097fe:	8082                	ret
ffffffffc0209800:	00005697          	auipc	a3,0x5
ffffffffc0209804:	63868693          	addi	a3,a3,1592 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc0209808:	00002617          	auipc	a2,0x2
ffffffffc020980c:	10060613          	addi	a2,a2,256 # ffffffffc020b908 <commands+0x210>
ffffffffc0209810:	39c00593          	li	a1,924
ffffffffc0209814:	00005517          	auipc	a0,0x5
ffffffffc0209818:	65c50513          	addi	a0,a0,1628 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020981c:	c83f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209820:	00005697          	auipc	a3,0x5
ffffffffc0209824:	ea068693          	addi	a3,a3,-352 # ffffffffc020e6c0 <syscalls+0xc48>
ffffffffc0209828:	00002617          	auipc	a2,0x2
ffffffffc020982c:	0e060613          	addi	a2,a2,224 # ffffffffc020b908 <commands+0x210>
ffffffffc0209830:	39e00593          	li	a1,926
ffffffffc0209834:	00005517          	auipc	a0,0x5
ffffffffc0209838:	63c50513          	addi	a0,a0,1596 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020983c:	c63f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209840 <sfs_close>:
ffffffffc0209840:	1141                	addi	sp,sp,-16
ffffffffc0209842:	e406                	sd	ra,8(sp)
ffffffffc0209844:	e022                	sd	s0,0(sp)
ffffffffc0209846:	c11d                	beqz	a0,ffffffffc020986c <sfs_close+0x2c>
ffffffffc0209848:	793c                	ld	a5,112(a0)
ffffffffc020984a:	842a                	mv	s0,a0
ffffffffc020984c:	c385                	beqz	a5,ffffffffc020986c <sfs_close+0x2c>
ffffffffc020984e:	7b9c                	ld	a5,48(a5)
ffffffffc0209850:	cf91                	beqz	a5,ffffffffc020986c <sfs_close+0x2c>
ffffffffc0209852:	00004597          	auipc	a1,0x4
ffffffffc0209856:	a3e58593          	addi	a1,a1,-1474 # ffffffffc020d290 <default_pmm_manager+0xea0>
ffffffffc020985a:	f99fd0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc020985e:	783c                	ld	a5,112(s0)
ffffffffc0209860:	8522                	mv	a0,s0
ffffffffc0209862:	6402                	ld	s0,0(sp)
ffffffffc0209864:	60a2                	ld	ra,8(sp)
ffffffffc0209866:	7b9c                	ld	a5,48(a5)
ffffffffc0209868:	0141                	addi	sp,sp,16
ffffffffc020986a:	8782                	jr	a5
ffffffffc020986c:	00004697          	auipc	a3,0x4
ffffffffc0209870:	9d468693          	addi	a3,a3,-1580 # ffffffffc020d240 <default_pmm_manager+0xe50>
ffffffffc0209874:	00002617          	auipc	a2,0x2
ffffffffc0209878:	09460613          	addi	a2,a2,148 # ffffffffc020b908 <commands+0x210>
ffffffffc020987c:	21c00593          	li	a1,540
ffffffffc0209880:	00005517          	auipc	a0,0x5
ffffffffc0209884:	5f050513          	addi	a0,a0,1520 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209888:	c17f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020988c <sfs_io.part.0>:
ffffffffc020988c:	1141                	addi	sp,sp,-16
ffffffffc020988e:	00005697          	auipc	a3,0x5
ffffffffc0209892:	5aa68693          	addi	a3,a3,1450 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc0209896:	00002617          	auipc	a2,0x2
ffffffffc020989a:	07260613          	addi	a2,a2,114 # ffffffffc020b908 <commands+0x210>
ffffffffc020989e:	29900593          	li	a1,665
ffffffffc02098a2:	00005517          	auipc	a0,0x5
ffffffffc02098a6:	5ce50513          	addi	a0,a0,1486 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc02098aa:	e406                	sd	ra,8(sp)
ffffffffc02098ac:	bf3f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02098b0 <sfs_block_free>:
ffffffffc02098b0:	1101                	addi	sp,sp,-32
ffffffffc02098b2:	e426                	sd	s1,8(sp)
ffffffffc02098b4:	ec06                	sd	ra,24(sp)
ffffffffc02098b6:	e822                	sd	s0,16(sp)
ffffffffc02098b8:	4154                	lw	a3,4(a0)
ffffffffc02098ba:	84ae                	mv	s1,a1
ffffffffc02098bc:	c595                	beqz	a1,ffffffffc02098e8 <sfs_block_free+0x38>
ffffffffc02098be:	02d5f563          	bgeu	a1,a3,ffffffffc02098e8 <sfs_block_free+0x38>
ffffffffc02098c2:	842a                	mv	s0,a0
ffffffffc02098c4:	7d08                	ld	a0,56(a0)
ffffffffc02098c6:	edcff0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc02098ca:	ed05                	bnez	a0,ffffffffc0209902 <sfs_block_free+0x52>
ffffffffc02098cc:	7c08                	ld	a0,56(s0)
ffffffffc02098ce:	85a6                	mv	a1,s1
ffffffffc02098d0:	efaff0ef          	jal	ra,ffffffffc0208fca <bitmap_free>
ffffffffc02098d4:	441c                	lw	a5,8(s0)
ffffffffc02098d6:	4705                	li	a4,1
ffffffffc02098d8:	60e2                	ld	ra,24(sp)
ffffffffc02098da:	2785                	addiw	a5,a5,1
ffffffffc02098dc:	e038                	sd	a4,64(s0)
ffffffffc02098de:	c41c                	sw	a5,8(s0)
ffffffffc02098e0:	6442                	ld	s0,16(sp)
ffffffffc02098e2:	64a2                	ld	s1,8(sp)
ffffffffc02098e4:	6105                	addi	sp,sp,32
ffffffffc02098e6:	8082                	ret
ffffffffc02098e8:	8726                	mv	a4,s1
ffffffffc02098ea:	00005617          	auipc	a2,0x5
ffffffffc02098ee:	5b660613          	addi	a2,a2,1462 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc02098f2:	05300593          	li	a1,83
ffffffffc02098f6:	00005517          	auipc	a0,0x5
ffffffffc02098fa:	57a50513          	addi	a0,a0,1402 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc02098fe:	ba1f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209902:	00005697          	auipc	a3,0x5
ffffffffc0209906:	5d668693          	addi	a3,a3,1494 # ffffffffc020eed8 <dev_node_ops+0x628>
ffffffffc020990a:	00002617          	auipc	a2,0x2
ffffffffc020990e:	ffe60613          	addi	a2,a2,-2 # ffffffffc020b908 <commands+0x210>
ffffffffc0209912:	06a00593          	li	a1,106
ffffffffc0209916:	00005517          	auipc	a0,0x5
ffffffffc020991a:	55a50513          	addi	a0,a0,1370 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020991e:	b81f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209922 <sfs_reclaim>:
ffffffffc0209922:	1101                	addi	sp,sp,-32
ffffffffc0209924:	e426                	sd	s1,8(sp)
ffffffffc0209926:	7524                	ld	s1,104(a0)
ffffffffc0209928:	ec06                	sd	ra,24(sp)
ffffffffc020992a:	e822                	sd	s0,16(sp)
ffffffffc020992c:	e04a                	sd	s2,0(sp)
ffffffffc020992e:	0e048a63          	beqz	s1,ffffffffc0209a22 <sfs_reclaim+0x100>
ffffffffc0209932:	0b04a783          	lw	a5,176(s1)
ffffffffc0209936:	0e079663          	bnez	a5,ffffffffc0209a22 <sfs_reclaim+0x100>
ffffffffc020993a:	4d38                	lw	a4,88(a0)
ffffffffc020993c:	6785                	lui	a5,0x1
ffffffffc020993e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209942:	842a                	mv	s0,a0
ffffffffc0209944:	10f71f63          	bne	a4,a5,ffffffffc0209a62 <sfs_reclaim+0x140>
ffffffffc0209948:	8526                	mv	a0,s1
ffffffffc020994a:	586010ef          	jal	ra,ffffffffc020aed0 <lock_sfs_fs>
ffffffffc020994e:	4c1c                	lw	a5,24(s0)
ffffffffc0209950:	0ef05963          	blez	a5,ffffffffc0209a42 <sfs_reclaim+0x120>
ffffffffc0209954:	fff7871b          	addiw	a4,a5,-1
ffffffffc0209958:	cc18                	sw	a4,24(s0)
ffffffffc020995a:	eb59                	bnez	a4,ffffffffc02099f0 <sfs_reclaim+0xce>
ffffffffc020995c:	05c42903          	lw	s2,92(s0)
ffffffffc0209960:	08091863          	bnez	s2,ffffffffc02099f0 <sfs_reclaim+0xce>
ffffffffc0209964:	601c                	ld	a5,0(s0)
ffffffffc0209966:	0067d783          	lhu	a5,6(a5)
ffffffffc020996a:	e785                	bnez	a5,ffffffffc0209992 <sfs_reclaim+0x70>
ffffffffc020996c:	783c                	ld	a5,112(s0)
ffffffffc020996e:	10078a63          	beqz	a5,ffffffffc0209a82 <sfs_reclaim+0x160>
ffffffffc0209972:	73bc                	ld	a5,96(a5)
ffffffffc0209974:	10078763          	beqz	a5,ffffffffc0209a82 <sfs_reclaim+0x160>
ffffffffc0209978:	00005597          	auipc	a1,0x5
ffffffffc020997c:	da058593          	addi	a1,a1,-608 # ffffffffc020e718 <syscalls+0xca0>
ffffffffc0209980:	8522                	mv	a0,s0
ffffffffc0209982:	e71fd0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc0209986:	783c                	ld	a5,112(s0)
ffffffffc0209988:	4581                	li	a1,0
ffffffffc020998a:	8522                	mv	a0,s0
ffffffffc020998c:	73bc                	ld	a5,96(a5)
ffffffffc020998e:	9782                	jalr	a5
ffffffffc0209990:	e559                	bnez	a0,ffffffffc0209a1e <sfs_reclaim+0xfc>
ffffffffc0209992:	681c                	ld	a5,16(s0)
ffffffffc0209994:	c39d                	beqz	a5,ffffffffc02099ba <sfs_reclaim+0x98>
ffffffffc0209996:	783c                	ld	a5,112(s0)
ffffffffc0209998:	10078563          	beqz	a5,ffffffffc0209aa2 <sfs_reclaim+0x180>
ffffffffc020999c:	7b9c                	ld	a5,48(a5)
ffffffffc020999e:	10078263          	beqz	a5,ffffffffc0209aa2 <sfs_reclaim+0x180>
ffffffffc02099a2:	8522                	mv	a0,s0
ffffffffc02099a4:	00004597          	auipc	a1,0x4
ffffffffc02099a8:	8ec58593          	addi	a1,a1,-1812 # ffffffffc020d290 <default_pmm_manager+0xea0>
ffffffffc02099ac:	e47fd0ef          	jal	ra,ffffffffc02077f2 <inode_check>
ffffffffc02099b0:	783c                	ld	a5,112(s0)
ffffffffc02099b2:	8522                	mv	a0,s0
ffffffffc02099b4:	7b9c                	ld	a5,48(a5)
ffffffffc02099b6:	9782                	jalr	a5
ffffffffc02099b8:	e13d                	bnez	a0,ffffffffc0209a1e <sfs_reclaim+0xfc>
ffffffffc02099ba:	7c18                	ld	a4,56(s0)
ffffffffc02099bc:	603c                	ld	a5,64(s0)
ffffffffc02099be:	8526                	mv	a0,s1
ffffffffc02099c0:	e71c                	sd	a5,8(a4)
ffffffffc02099c2:	e398                	sd	a4,0(a5)
ffffffffc02099c4:	6438                	ld	a4,72(s0)
ffffffffc02099c6:	683c                	ld	a5,80(s0)
ffffffffc02099c8:	e71c                	sd	a5,8(a4)
ffffffffc02099ca:	e398                	sd	a4,0(a5)
ffffffffc02099cc:	514010ef          	jal	ra,ffffffffc020aee0 <unlock_sfs_fs>
ffffffffc02099d0:	6008                	ld	a0,0(s0)
ffffffffc02099d2:	00655783          	lhu	a5,6(a0)
ffffffffc02099d6:	cb85                	beqz	a5,ffffffffc0209a06 <sfs_reclaim+0xe4>
ffffffffc02099d8:	e66f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02099dc:	8522                	mv	a0,s0
ffffffffc02099de:	da9fd0ef          	jal	ra,ffffffffc0207786 <inode_kill>
ffffffffc02099e2:	60e2                	ld	ra,24(sp)
ffffffffc02099e4:	6442                	ld	s0,16(sp)
ffffffffc02099e6:	64a2                	ld	s1,8(sp)
ffffffffc02099e8:	854a                	mv	a0,s2
ffffffffc02099ea:	6902                	ld	s2,0(sp)
ffffffffc02099ec:	6105                	addi	sp,sp,32
ffffffffc02099ee:	8082                	ret
ffffffffc02099f0:	5945                	li	s2,-15
ffffffffc02099f2:	8526                	mv	a0,s1
ffffffffc02099f4:	4ec010ef          	jal	ra,ffffffffc020aee0 <unlock_sfs_fs>
ffffffffc02099f8:	60e2                	ld	ra,24(sp)
ffffffffc02099fa:	6442                	ld	s0,16(sp)
ffffffffc02099fc:	64a2                	ld	s1,8(sp)
ffffffffc02099fe:	854a                	mv	a0,s2
ffffffffc0209a00:	6902                	ld	s2,0(sp)
ffffffffc0209a02:	6105                	addi	sp,sp,32
ffffffffc0209a04:	8082                	ret
ffffffffc0209a06:	440c                	lw	a1,8(s0)
ffffffffc0209a08:	8526                	mv	a0,s1
ffffffffc0209a0a:	ea7ff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc0209a0e:	6008                	ld	a0,0(s0)
ffffffffc0209a10:	5d4c                	lw	a1,60(a0)
ffffffffc0209a12:	d1f9                	beqz	a1,ffffffffc02099d8 <sfs_reclaim+0xb6>
ffffffffc0209a14:	8526                	mv	a0,s1
ffffffffc0209a16:	e9bff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc0209a1a:	6008                	ld	a0,0(s0)
ffffffffc0209a1c:	bf75                	j	ffffffffc02099d8 <sfs_reclaim+0xb6>
ffffffffc0209a1e:	892a                	mv	s2,a0
ffffffffc0209a20:	bfc9                	j	ffffffffc02099f2 <sfs_reclaim+0xd0>
ffffffffc0209a22:	00005697          	auipc	a3,0x5
ffffffffc0209a26:	26e68693          	addi	a3,a3,622 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc0209a2a:	00002617          	auipc	a2,0x2
ffffffffc0209a2e:	ede60613          	addi	a2,a2,-290 # ffffffffc020b908 <commands+0x210>
ffffffffc0209a32:	35a00593          	li	a1,858
ffffffffc0209a36:	00005517          	auipc	a0,0x5
ffffffffc0209a3a:	43a50513          	addi	a0,a0,1082 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209a3e:	a61f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a42:	00005697          	auipc	a3,0x5
ffffffffc0209a46:	4b668693          	addi	a3,a3,1206 # ffffffffc020eef8 <dev_node_ops+0x648>
ffffffffc0209a4a:	00002617          	auipc	a2,0x2
ffffffffc0209a4e:	ebe60613          	addi	a2,a2,-322 # ffffffffc020b908 <commands+0x210>
ffffffffc0209a52:	36000593          	li	a1,864
ffffffffc0209a56:	00005517          	auipc	a0,0x5
ffffffffc0209a5a:	41a50513          	addi	a0,a0,1050 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209a5e:	a41f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a62:	00005697          	auipc	a3,0x5
ffffffffc0209a66:	3d668693          	addi	a3,a3,982 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc0209a6a:	00002617          	auipc	a2,0x2
ffffffffc0209a6e:	e9e60613          	addi	a2,a2,-354 # ffffffffc020b908 <commands+0x210>
ffffffffc0209a72:	35b00593          	li	a1,859
ffffffffc0209a76:	00005517          	auipc	a0,0x5
ffffffffc0209a7a:	3fa50513          	addi	a0,a0,1018 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209a7e:	a21f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a82:	00005697          	auipc	a3,0x5
ffffffffc0209a86:	c3e68693          	addi	a3,a3,-962 # ffffffffc020e6c0 <syscalls+0xc48>
ffffffffc0209a8a:	00002617          	auipc	a2,0x2
ffffffffc0209a8e:	e7e60613          	addi	a2,a2,-386 # ffffffffc020b908 <commands+0x210>
ffffffffc0209a92:	36500593          	li	a1,869
ffffffffc0209a96:	00005517          	auipc	a0,0x5
ffffffffc0209a9a:	3da50513          	addi	a0,a0,986 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209a9e:	a01f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209aa2:	00003697          	auipc	a3,0x3
ffffffffc0209aa6:	79e68693          	addi	a3,a3,1950 # ffffffffc020d240 <default_pmm_manager+0xe50>
ffffffffc0209aaa:	00002617          	auipc	a2,0x2
ffffffffc0209aae:	e5e60613          	addi	a2,a2,-418 # ffffffffc020b908 <commands+0x210>
ffffffffc0209ab2:	36a00593          	li	a1,874
ffffffffc0209ab6:	00005517          	auipc	a0,0x5
ffffffffc0209aba:	3ba50513          	addi	a0,a0,954 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209abe:	9e1f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209ac2 <sfs_block_alloc>:
ffffffffc0209ac2:	1101                	addi	sp,sp,-32
ffffffffc0209ac4:	e822                	sd	s0,16(sp)
ffffffffc0209ac6:	842a                	mv	s0,a0
ffffffffc0209ac8:	7d08                	ld	a0,56(a0)
ffffffffc0209aca:	e426                	sd	s1,8(sp)
ffffffffc0209acc:	ec06                	sd	ra,24(sp)
ffffffffc0209ace:	84ae                	mv	s1,a1
ffffffffc0209ad0:	c62ff0ef          	jal	ra,ffffffffc0208f32 <bitmap_alloc>
ffffffffc0209ad4:	e90d                	bnez	a0,ffffffffc0209b06 <sfs_block_alloc+0x44>
ffffffffc0209ad6:	441c                	lw	a5,8(s0)
ffffffffc0209ad8:	cbad                	beqz	a5,ffffffffc0209b4a <sfs_block_alloc+0x88>
ffffffffc0209ada:	37fd                	addiw	a5,a5,-1
ffffffffc0209adc:	c41c                	sw	a5,8(s0)
ffffffffc0209ade:	408c                	lw	a1,0(s1)
ffffffffc0209ae0:	4785                	li	a5,1
ffffffffc0209ae2:	e03c                	sd	a5,64(s0)
ffffffffc0209ae4:	4054                	lw	a3,4(s0)
ffffffffc0209ae6:	c58d                	beqz	a1,ffffffffc0209b10 <sfs_block_alloc+0x4e>
ffffffffc0209ae8:	02d5f463          	bgeu	a1,a3,ffffffffc0209b10 <sfs_block_alloc+0x4e>
ffffffffc0209aec:	7c08                	ld	a0,56(s0)
ffffffffc0209aee:	cb4ff0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc0209af2:	ed05                	bnez	a0,ffffffffc0209b2a <sfs_block_alloc+0x68>
ffffffffc0209af4:	8522                	mv	a0,s0
ffffffffc0209af6:	6442                	ld	s0,16(sp)
ffffffffc0209af8:	408c                	lw	a1,0(s1)
ffffffffc0209afa:	60e2                	ld	ra,24(sp)
ffffffffc0209afc:	64a2                	ld	s1,8(sp)
ffffffffc0209afe:	4605                	li	a2,1
ffffffffc0209b00:	6105                	addi	sp,sp,32
ffffffffc0209b02:	36e0106f          	j	ffffffffc020ae70 <sfs_clear_block>
ffffffffc0209b06:	60e2                	ld	ra,24(sp)
ffffffffc0209b08:	6442                	ld	s0,16(sp)
ffffffffc0209b0a:	64a2                	ld	s1,8(sp)
ffffffffc0209b0c:	6105                	addi	sp,sp,32
ffffffffc0209b0e:	8082                	ret
ffffffffc0209b10:	872e                	mv	a4,a1
ffffffffc0209b12:	00005617          	auipc	a2,0x5
ffffffffc0209b16:	38e60613          	addi	a2,a2,910 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc0209b1a:	05300593          	li	a1,83
ffffffffc0209b1e:	00005517          	auipc	a0,0x5
ffffffffc0209b22:	35250513          	addi	a0,a0,850 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209b26:	979f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b2a:	00005697          	auipc	a3,0x5
ffffffffc0209b2e:	40668693          	addi	a3,a3,1030 # ffffffffc020ef30 <dev_node_ops+0x680>
ffffffffc0209b32:	00002617          	auipc	a2,0x2
ffffffffc0209b36:	dd660613          	addi	a2,a2,-554 # ffffffffc020b908 <commands+0x210>
ffffffffc0209b3a:	06100593          	li	a1,97
ffffffffc0209b3e:	00005517          	auipc	a0,0x5
ffffffffc0209b42:	33250513          	addi	a0,a0,818 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209b46:	959f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b4a:	00005697          	auipc	a3,0x5
ffffffffc0209b4e:	3c668693          	addi	a3,a3,966 # ffffffffc020ef10 <dev_node_ops+0x660>
ffffffffc0209b52:	00002617          	auipc	a2,0x2
ffffffffc0209b56:	db660613          	addi	a2,a2,-586 # ffffffffc020b908 <commands+0x210>
ffffffffc0209b5a:	05f00593          	li	a1,95
ffffffffc0209b5e:	00005517          	auipc	a0,0x5
ffffffffc0209b62:	31250513          	addi	a0,a0,786 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209b66:	939f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209b6a <sfs_bmap_load_nolock>:
ffffffffc0209b6a:	7159                	addi	sp,sp,-112
ffffffffc0209b6c:	f85a                	sd	s6,48(sp)
ffffffffc0209b6e:	0005bb03          	ld	s6,0(a1)
ffffffffc0209b72:	f45e                	sd	s7,40(sp)
ffffffffc0209b74:	f486                	sd	ra,104(sp)
ffffffffc0209b76:	008b2b83          	lw	s7,8(s6)
ffffffffc0209b7a:	f0a2                	sd	s0,96(sp)
ffffffffc0209b7c:	eca6                	sd	s1,88(sp)
ffffffffc0209b7e:	e8ca                	sd	s2,80(sp)
ffffffffc0209b80:	e4ce                	sd	s3,72(sp)
ffffffffc0209b82:	e0d2                	sd	s4,64(sp)
ffffffffc0209b84:	fc56                	sd	s5,56(sp)
ffffffffc0209b86:	f062                	sd	s8,32(sp)
ffffffffc0209b88:	ec66                	sd	s9,24(sp)
ffffffffc0209b8a:	18cbe363          	bltu	s7,a2,ffffffffc0209d10 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209b8e:	47ad                	li	a5,11
ffffffffc0209b90:	8aae                	mv	s5,a1
ffffffffc0209b92:	8432                	mv	s0,a2
ffffffffc0209b94:	84aa                	mv	s1,a0
ffffffffc0209b96:	89b6                	mv	s3,a3
ffffffffc0209b98:	04c7f563          	bgeu	a5,a2,ffffffffc0209be2 <sfs_bmap_load_nolock+0x78>
ffffffffc0209b9c:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209ba0:	0007069b          	sext.w	a3,a4
ffffffffc0209ba4:	3ff00793          	li	a5,1023
ffffffffc0209ba8:	1ad7e163          	bltu	a5,a3,ffffffffc0209d4a <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209bac:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209bb0:	02071793          	slli	a5,a4,0x20
ffffffffc0209bb4:	c602                	sw	zero,12(sp)
ffffffffc0209bb6:	c452                	sw	s4,8(sp)
ffffffffc0209bb8:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209bbc:	0e0a1e63          	bnez	s4,ffffffffc0209cb8 <sfs_bmap_load_nolock+0x14e>
ffffffffc0209bc0:	0acb8663          	beq	s7,a2,ffffffffc0209c6c <sfs_bmap_load_nolock+0x102>
ffffffffc0209bc4:	4a01                	li	s4,0
ffffffffc0209bc6:	40d4                	lw	a3,4(s1)
ffffffffc0209bc8:	8752                	mv	a4,s4
ffffffffc0209bca:	00005617          	auipc	a2,0x5
ffffffffc0209bce:	2d660613          	addi	a2,a2,726 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc0209bd2:	05300593          	li	a1,83
ffffffffc0209bd6:	00005517          	auipc	a0,0x5
ffffffffc0209bda:	29a50513          	addi	a0,a0,666 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209bde:	8c1f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209be2:	02061793          	slli	a5,a2,0x20
ffffffffc0209be6:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209bea:	9a5a                	add	s4,s4,s6
ffffffffc0209bec:	00ca2583          	lw	a1,12(s4)
ffffffffc0209bf0:	c22e                	sw	a1,4(sp)
ffffffffc0209bf2:	ed99                	bnez	a1,ffffffffc0209c10 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209bf4:	fccb98e3          	bne	s7,a2,ffffffffc0209bc4 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209bf8:	004c                	addi	a1,sp,4
ffffffffc0209bfa:	ec9ff0ef          	jal	ra,ffffffffc0209ac2 <sfs_block_alloc>
ffffffffc0209bfe:	892a                	mv	s2,a0
ffffffffc0209c00:	e921                	bnez	a0,ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209c02:	4592                	lw	a1,4(sp)
ffffffffc0209c04:	4705                	li	a4,1
ffffffffc0209c06:	00ba2623          	sw	a1,12(s4)
ffffffffc0209c0a:	00eab823          	sd	a4,16(s5)
ffffffffc0209c0e:	d9dd                	beqz	a1,ffffffffc0209bc4 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209c10:	40d4                	lw	a3,4(s1)
ffffffffc0209c12:	10d5ff63          	bgeu	a1,a3,ffffffffc0209d30 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209c16:	7c88                	ld	a0,56(s1)
ffffffffc0209c18:	b8aff0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc0209c1c:	18051363          	bnez	a0,ffffffffc0209da2 <sfs_bmap_load_nolock+0x238>
ffffffffc0209c20:	4a12                	lw	s4,4(sp)
ffffffffc0209c22:	fa0a02e3          	beqz	s4,ffffffffc0209bc6 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209c26:	40dc                	lw	a5,4(s1)
ffffffffc0209c28:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209bc6 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209c2c:	7c88                	ld	a0,56(s1)
ffffffffc0209c2e:	85d2                	mv	a1,s4
ffffffffc0209c30:	b72ff0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc0209c34:	12051763          	bnez	a0,ffffffffc0209d62 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209c38:	008b9763          	bne	s7,s0,ffffffffc0209c46 <sfs_bmap_load_nolock+0xdc>
ffffffffc0209c3c:	008b2783          	lw	a5,8(s6)
ffffffffc0209c40:	2785                	addiw	a5,a5,1
ffffffffc0209c42:	00fb2423          	sw	a5,8(s6)
ffffffffc0209c46:	4901                	li	s2,0
ffffffffc0209c48:	00098463          	beqz	s3,ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209c4c:	0149a023          	sw	s4,0(s3)
ffffffffc0209c50:	70a6                	ld	ra,104(sp)
ffffffffc0209c52:	7406                	ld	s0,96(sp)
ffffffffc0209c54:	64e6                	ld	s1,88(sp)
ffffffffc0209c56:	69a6                	ld	s3,72(sp)
ffffffffc0209c58:	6a06                	ld	s4,64(sp)
ffffffffc0209c5a:	7ae2                	ld	s5,56(sp)
ffffffffc0209c5c:	7b42                	ld	s6,48(sp)
ffffffffc0209c5e:	7ba2                	ld	s7,40(sp)
ffffffffc0209c60:	7c02                	ld	s8,32(sp)
ffffffffc0209c62:	6ce2                	ld	s9,24(sp)
ffffffffc0209c64:	854a                	mv	a0,s2
ffffffffc0209c66:	6946                	ld	s2,80(sp)
ffffffffc0209c68:	6165                	addi	sp,sp,112
ffffffffc0209c6a:	8082                	ret
ffffffffc0209c6c:	002c                	addi	a1,sp,8
ffffffffc0209c6e:	e55ff0ef          	jal	ra,ffffffffc0209ac2 <sfs_block_alloc>
ffffffffc0209c72:	892a                	mv	s2,a0
ffffffffc0209c74:	00c10c93          	addi	s9,sp,12
ffffffffc0209c78:	fd61                	bnez	a0,ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209c7a:	85e6                	mv	a1,s9
ffffffffc0209c7c:	8526                	mv	a0,s1
ffffffffc0209c7e:	e45ff0ef          	jal	ra,ffffffffc0209ac2 <sfs_block_alloc>
ffffffffc0209c82:	892a                	mv	s2,a0
ffffffffc0209c84:	e925                	bnez	a0,ffffffffc0209cf4 <sfs_bmap_load_nolock+0x18a>
ffffffffc0209c86:	46a2                	lw	a3,8(sp)
ffffffffc0209c88:	85e6                	mv	a1,s9
ffffffffc0209c8a:	8762                	mv	a4,s8
ffffffffc0209c8c:	4611                	li	a2,4
ffffffffc0209c8e:	8526                	mv	a0,s1
ffffffffc0209c90:	090010ef          	jal	ra,ffffffffc020ad20 <sfs_wbuf>
ffffffffc0209c94:	45b2                	lw	a1,12(sp)
ffffffffc0209c96:	892a                	mv	s2,a0
ffffffffc0209c98:	e939                	bnez	a0,ffffffffc0209cee <sfs_bmap_load_nolock+0x184>
ffffffffc0209c9a:	03cb2683          	lw	a3,60(s6)
ffffffffc0209c9e:	4722                	lw	a4,8(sp)
ffffffffc0209ca0:	c22e                	sw	a1,4(sp)
ffffffffc0209ca2:	f6d706e3          	beq	a4,a3,ffffffffc0209c0e <sfs_bmap_load_nolock+0xa4>
ffffffffc0209ca6:	eef1                	bnez	a3,ffffffffc0209d82 <sfs_bmap_load_nolock+0x218>
ffffffffc0209ca8:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209cac:	4705                	li	a4,1
ffffffffc0209cae:	00eab823          	sd	a4,16(s5)
ffffffffc0209cb2:	f00589e3          	beqz	a1,ffffffffc0209bc4 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209cb6:	bfa9                	j	ffffffffc0209c10 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209cb8:	00c10c93          	addi	s9,sp,12
ffffffffc0209cbc:	8762                	mv	a4,s8
ffffffffc0209cbe:	86d2                	mv	a3,s4
ffffffffc0209cc0:	4611                	li	a2,4
ffffffffc0209cc2:	85e6                	mv	a1,s9
ffffffffc0209cc4:	7dd000ef          	jal	ra,ffffffffc020aca0 <sfs_rbuf>
ffffffffc0209cc8:	892a                	mv	s2,a0
ffffffffc0209cca:	f159                	bnez	a0,ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209ccc:	45b2                	lw	a1,12(sp)
ffffffffc0209cce:	e995                	bnez	a1,ffffffffc0209d02 <sfs_bmap_load_nolock+0x198>
ffffffffc0209cd0:	fa8b85e3          	beq	s7,s0,ffffffffc0209c7a <sfs_bmap_load_nolock+0x110>
ffffffffc0209cd4:	03cb2703          	lw	a4,60(s6)
ffffffffc0209cd8:	47a2                	lw	a5,8(sp)
ffffffffc0209cda:	c202                	sw	zero,4(sp)
ffffffffc0209cdc:	eee784e3          	beq	a5,a4,ffffffffc0209bc4 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209ce0:	e34d                	bnez	a4,ffffffffc0209d82 <sfs_bmap_load_nolock+0x218>
ffffffffc0209ce2:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209ce6:	4785                	li	a5,1
ffffffffc0209ce8:	00fab823          	sd	a5,16(s5)
ffffffffc0209cec:	bde1                	j	ffffffffc0209bc4 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209cee:	8526                	mv	a0,s1
ffffffffc0209cf0:	bc1ff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc0209cf4:	45a2                	lw	a1,8(sp)
ffffffffc0209cf6:	f4ba0de3          	beq	s4,a1,ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209cfa:	8526                	mv	a0,s1
ffffffffc0209cfc:	bb5ff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc0209d00:	bf81                	j	ffffffffc0209c50 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d02:	03cb2683          	lw	a3,60(s6)
ffffffffc0209d06:	4722                	lw	a4,8(sp)
ffffffffc0209d08:	c22e                	sw	a1,4(sp)
ffffffffc0209d0a:	f8e69ee3          	bne	a3,a4,ffffffffc0209ca6 <sfs_bmap_load_nolock+0x13c>
ffffffffc0209d0e:	b709                	j	ffffffffc0209c10 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209d10:	00005697          	auipc	a3,0x5
ffffffffc0209d14:	24868693          	addi	a3,a3,584 # ffffffffc020ef58 <dev_node_ops+0x6a8>
ffffffffc0209d18:	00002617          	auipc	a2,0x2
ffffffffc0209d1c:	bf060613          	addi	a2,a2,-1040 # ffffffffc020b908 <commands+0x210>
ffffffffc0209d20:	16400593          	li	a1,356
ffffffffc0209d24:	00005517          	auipc	a0,0x5
ffffffffc0209d28:	14c50513          	addi	a0,a0,332 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209d2c:	f72f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d30:	872e                	mv	a4,a1
ffffffffc0209d32:	00005617          	auipc	a2,0x5
ffffffffc0209d36:	16e60613          	addi	a2,a2,366 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc0209d3a:	05300593          	li	a1,83
ffffffffc0209d3e:	00005517          	auipc	a0,0x5
ffffffffc0209d42:	13250513          	addi	a0,a0,306 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209d46:	f58f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d4a:	00005617          	auipc	a2,0x5
ffffffffc0209d4e:	23e60613          	addi	a2,a2,574 # ffffffffc020ef88 <dev_node_ops+0x6d8>
ffffffffc0209d52:	11e00593          	li	a1,286
ffffffffc0209d56:	00005517          	auipc	a0,0x5
ffffffffc0209d5a:	11a50513          	addi	a0,a0,282 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209d5e:	f40f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d62:	00005697          	auipc	a3,0x5
ffffffffc0209d66:	17668693          	addi	a3,a3,374 # ffffffffc020eed8 <dev_node_ops+0x628>
ffffffffc0209d6a:	00002617          	auipc	a2,0x2
ffffffffc0209d6e:	b9e60613          	addi	a2,a2,-1122 # ffffffffc020b908 <commands+0x210>
ffffffffc0209d72:	16b00593          	li	a1,363
ffffffffc0209d76:	00005517          	auipc	a0,0x5
ffffffffc0209d7a:	0fa50513          	addi	a0,a0,250 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209d7e:	f20f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d82:	00005697          	auipc	a3,0x5
ffffffffc0209d86:	1ee68693          	addi	a3,a3,494 # ffffffffc020ef70 <dev_node_ops+0x6c0>
ffffffffc0209d8a:	00002617          	auipc	a2,0x2
ffffffffc0209d8e:	b7e60613          	addi	a2,a2,-1154 # ffffffffc020b908 <commands+0x210>
ffffffffc0209d92:	11800593          	li	a1,280
ffffffffc0209d96:	00005517          	auipc	a0,0x5
ffffffffc0209d9a:	0da50513          	addi	a0,a0,218 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209d9e:	f00f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209da2:	00005697          	auipc	a3,0x5
ffffffffc0209da6:	21668693          	addi	a3,a3,534 # ffffffffc020efb8 <dev_node_ops+0x708>
ffffffffc0209daa:	00002617          	auipc	a2,0x2
ffffffffc0209dae:	b5e60613          	addi	a2,a2,-1186 # ffffffffc020b908 <commands+0x210>
ffffffffc0209db2:	12100593          	li	a1,289
ffffffffc0209db6:	00005517          	auipc	a0,0x5
ffffffffc0209dba:	0ba50513          	addi	a0,a0,186 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209dbe:	ee0f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209dc2 <sfs_io_nolock>:
ffffffffc0209dc2:	7175                	addi	sp,sp,-144
ffffffffc0209dc4:	f0d2                	sd	s4,96(sp)
ffffffffc0209dc6:	8a2e                	mv	s4,a1
ffffffffc0209dc8:	618c                	ld	a1,0(a1)
ffffffffc0209dca:	e506                	sd	ra,136(sp)
ffffffffc0209dcc:	e122                	sd	s0,128(sp)
ffffffffc0209dce:	0045d883          	lhu	a7,4(a1)
ffffffffc0209dd2:	fca6                	sd	s1,120(sp)
ffffffffc0209dd4:	f8ca                	sd	s2,112(sp)
ffffffffc0209dd6:	f4ce                	sd	s3,104(sp)
ffffffffc0209dd8:	ecd6                	sd	s5,88(sp)
ffffffffc0209dda:	e8da                	sd	s6,80(sp)
ffffffffc0209ddc:	e4de                	sd	s7,72(sp)
ffffffffc0209dde:	e0e2                	sd	s8,64(sp)
ffffffffc0209de0:	fc66                	sd	s9,56(sp)
ffffffffc0209de2:	f86a                	sd	s10,48(sp)
ffffffffc0209de4:	f46e                	sd	s11,40(sp)
ffffffffc0209de6:	4809                	li	a6,2
ffffffffc0209de8:	19088763          	beq	a7,a6,ffffffffc0209f76 <sfs_io_nolock+0x1b4>
ffffffffc0209dec:	00073a83          	ld	s5,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc0209df0:	8c3a                	mv	s8,a4
ffffffffc0209df2:	000c3023          	sd	zero,0(s8)
ffffffffc0209df6:	08000737          	lui	a4,0x8000
ffffffffc0209dfa:	84b6                	mv	s1,a3
ffffffffc0209dfc:	8d36                	mv	s10,a3
ffffffffc0209dfe:	9ab6                	add	s5,s5,a3
ffffffffc0209e00:	16e6f963          	bgeu	a3,a4,ffffffffc0209f72 <sfs_io_nolock+0x1b0>
ffffffffc0209e04:	16dac763          	blt	s5,a3,ffffffffc0209f72 <sfs_io_nolock+0x1b0>
ffffffffc0209e08:	892a                	mv	s2,a0
ffffffffc0209e0a:	4501                	li	a0,0
ffffffffc0209e0c:	0d568163          	beq	a3,s5,ffffffffc0209ece <sfs_io_nolock+0x10c>
ffffffffc0209e10:	8432                	mv	s0,a2
ffffffffc0209e12:	01577463          	bgeu	a4,s5,ffffffffc0209e1a <sfs_io_nolock+0x58>
ffffffffc0209e16:	08000ab7          	lui	s5,0x8000
ffffffffc0209e1a:	cbe9                	beqz	a5,ffffffffc0209eec <sfs_io_nolock+0x12a>
ffffffffc0209e1c:	00001797          	auipc	a5,0x1
ffffffffc0209e20:	f0478793          	addi	a5,a5,-252 # ffffffffc020ad20 <sfs_wbuf>
ffffffffc0209e24:	00001c97          	auipc	s9,0x1
ffffffffc0209e28:	e1cc8c93          	addi	s9,s9,-484 # ffffffffc020ac40 <sfs_wblock>
ffffffffc0209e2c:	e03e                	sd	a5,0(sp)
ffffffffc0209e2e:	6705                	lui	a4,0x1
ffffffffc0209e30:	40c4dd93          	srai	s11,s1,0xc
ffffffffc0209e34:	40cadb13          	srai	s6,s5,0xc
ffffffffc0209e38:	fff70b93          	addi	s7,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209e3c:	41bb07bb          	subw	a5,s6,s11
ffffffffc0209e40:	0174fbb3          	and	s7,s1,s7
ffffffffc0209e44:	8b3e                	mv	s6,a5
ffffffffc0209e46:	2d81                	sext.w	s11,s11
ffffffffc0209e48:	89de                	mv	s3,s7
ffffffffc0209e4a:	020b8b63          	beqz	s7,ffffffffc0209e80 <sfs_io_nolock+0xbe>
ffffffffc0209e4e:	409a89b3          	sub	s3,s5,s1
ffffffffc0209e52:	efd5                	bnez	a5,ffffffffc0209f0e <sfs_io_nolock+0x14c>
ffffffffc0209e54:	0874                	addi	a3,sp,28
ffffffffc0209e56:	866e                	mv	a2,s11
ffffffffc0209e58:	85d2                	mv	a1,s4
ffffffffc0209e5a:	854a                	mv	a0,s2
ffffffffc0209e5c:	e43e                	sd	a5,8(sp)
ffffffffc0209e5e:	d0dff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc0209e62:	e161                	bnez	a0,ffffffffc0209f22 <sfs_io_nolock+0x160>
ffffffffc0209e64:	46f2                	lw	a3,28(sp)
ffffffffc0209e66:	6782                	ld	a5,0(sp)
ffffffffc0209e68:	875e                	mv	a4,s7
ffffffffc0209e6a:	864e                	mv	a2,s3
ffffffffc0209e6c:	85a2                	mv	a1,s0
ffffffffc0209e6e:	854a                	mv	a0,s2
ffffffffc0209e70:	9782                	jalr	a5
ffffffffc0209e72:	e945                	bnez	a0,ffffffffc0209f22 <sfs_io_nolock+0x160>
ffffffffc0209e74:	67a2                	ld	a5,8(sp)
ffffffffc0209e76:	cf85                	beqz	a5,ffffffffc0209eae <sfs_io_nolock+0xec>
ffffffffc0209e78:	944e                	add	s0,s0,s3
ffffffffc0209e7a:	2d85                	addiw	s11,s11,1
ffffffffc0209e7c:	fffb079b          	addiw	a5,s6,-1
ffffffffc0209e80:	cfd5                	beqz	a5,ffffffffc0209f3c <sfs_io_nolock+0x17a>
ffffffffc0209e82:	01b78bbb          	addw	s7,a5,s11
ffffffffc0209e86:	6b05                	lui	s6,0x1
ffffffffc0209e88:	a821                	j	ffffffffc0209ea0 <sfs_io_nolock+0xde>
ffffffffc0209e8a:	4672                	lw	a2,28(sp)
ffffffffc0209e8c:	4685                	li	a3,1
ffffffffc0209e8e:	85a2                	mv	a1,s0
ffffffffc0209e90:	854a                	mv	a0,s2
ffffffffc0209e92:	9c82                	jalr	s9
ffffffffc0209e94:	ed09                	bnez	a0,ffffffffc0209eae <sfs_io_nolock+0xec>
ffffffffc0209e96:	2d85                	addiw	s11,s11,1
ffffffffc0209e98:	99da                	add	s3,s3,s6
ffffffffc0209e9a:	945a                	add	s0,s0,s6
ffffffffc0209e9c:	0b7d8163          	beq	s11,s7,ffffffffc0209f3e <sfs_io_nolock+0x17c>
ffffffffc0209ea0:	0874                	addi	a3,sp,28
ffffffffc0209ea2:	866e                	mv	a2,s11
ffffffffc0209ea4:	85d2                	mv	a1,s4
ffffffffc0209ea6:	854a                	mv	a0,s2
ffffffffc0209ea8:	cc3ff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc0209eac:	dd79                	beqz	a0,ffffffffc0209e8a <sfs_io_nolock+0xc8>
ffffffffc0209eae:	01348d33          	add	s10,s1,s3
ffffffffc0209eb2:	000a3783          	ld	a5,0(s4)
ffffffffc0209eb6:	013c3023          	sd	s3,0(s8)
ffffffffc0209eba:	0007e703          	lwu	a4,0(a5)
ffffffffc0209ebe:	01a77863          	bgeu	a4,s10,ffffffffc0209ece <sfs_io_nolock+0x10c>
ffffffffc0209ec2:	013484bb          	addw	s1,s1,s3
ffffffffc0209ec6:	c384                	sw	s1,0(a5)
ffffffffc0209ec8:	4785                	li	a5,1
ffffffffc0209eca:	00fa3823          	sd	a5,16(s4)
ffffffffc0209ece:	60aa                	ld	ra,136(sp)
ffffffffc0209ed0:	640a                	ld	s0,128(sp)
ffffffffc0209ed2:	74e6                	ld	s1,120(sp)
ffffffffc0209ed4:	7946                	ld	s2,112(sp)
ffffffffc0209ed6:	79a6                	ld	s3,104(sp)
ffffffffc0209ed8:	7a06                	ld	s4,96(sp)
ffffffffc0209eda:	6ae6                	ld	s5,88(sp)
ffffffffc0209edc:	6b46                	ld	s6,80(sp)
ffffffffc0209ede:	6ba6                	ld	s7,72(sp)
ffffffffc0209ee0:	6c06                	ld	s8,64(sp)
ffffffffc0209ee2:	7ce2                	ld	s9,56(sp)
ffffffffc0209ee4:	7d42                	ld	s10,48(sp)
ffffffffc0209ee6:	7da2                	ld	s11,40(sp)
ffffffffc0209ee8:	6149                	addi	sp,sp,144
ffffffffc0209eea:	8082                	ret
ffffffffc0209eec:	0005e783          	lwu	a5,0(a1)
ffffffffc0209ef0:	4501                	li	a0,0
ffffffffc0209ef2:	fcf4dee3          	bge	s1,a5,ffffffffc0209ece <sfs_io_nolock+0x10c>
ffffffffc0209ef6:	0357c863          	blt	a5,s5,ffffffffc0209f26 <sfs_io_nolock+0x164>
ffffffffc0209efa:	00001797          	auipc	a5,0x1
ffffffffc0209efe:	da678793          	addi	a5,a5,-602 # ffffffffc020aca0 <sfs_rbuf>
ffffffffc0209f02:	00001c97          	auipc	s9,0x1
ffffffffc0209f06:	cdec8c93          	addi	s9,s9,-802 # ffffffffc020abe0 <sfs_rblock>
ffffffffc0209f0a:	e03e                	sd	a5,0(sp)
ffffffffc0209f0c:	b70d                	j	ffffffffc0209e2e <sfs_io_nolock+0x6c>
ffffffffc0209f0e:	0874                	addi	a3,sp,28
ffffffffc0209f10:	866e                	mv	a2,s11
ffffffffc0209f12:	85d2                	mv	a1,s4
ffffffffc0209f14:	854a                	mv	a0,s2
ffffffffc0209f16:	417709b3          	sub	s3,a4,s7
ffffffffc0209f1a:	e43e                	sd	a5,8(sp)
ffffffffc0209f1c:	c4fff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc0209f20:	d131                	beqz	a0,ffffffffc0209e64 <sfs_io_nolock+0xa2>
ffffffffc0209f22:	4981                	li	s3,0
ffffffffc0209f24:	b779                	j	ffffffffc0209eb2 <sfs_io_nolock+0xf0>
ffffffffc0209f26:	8abe                	mv	s5,a5
ffffffffc0209f28:	00001797          	auipc	a5,0x1
ffffffffc0209f2c:	d7878793          	addi	a5,a5,-648 # ffffffffc020aca0 <sfs_rbuf>
ffffffffc0209f30:	00001c97          	auipc	s9,0x1
ffffffffc0209f34:	cb0c8c93          	addi	s9,s9,-848 # ffffffffc020abe0 <sfs_rblock>
ffffffffc0209f38:	e03e                	sd	a5,0(sp)
ffffffffc0209f3a:	bdd5                	j	ffffffffc0209e2e <sfs_io_nolock+0x6c>
ffffffffc0209f3c:	8bee                	mv	s7,s11
ffffffffc0209f3e:	1ad2                	slli	s5,s5,0x34
ffffffffc0209f40:	034adb13          	srli	s6,s5,0x34
ffffffffc0209f44:	000a9663          	bnez	s5,ffffffffc0209f50 <sfs_io_nolock+0x18e>
ffffffffc0209f48:	01348d33          	add	s10,s1,s3
ffffffffc0209f4c:	4501                	li	a0,0
ffffffffc0209f4e:	b795                	j	ffffffffc0209eb2 <sfs_io_nolock+0xf0>
ffffffffc0209f50:	0874                	addi	a3,sp,28
ffffffffc0209f52:	865e                	mv	a2,s7
ffffffffc0209f54:	85d2                	mv	a1,s4
ffffffffc0209f56:	854a                	mv	a0,s2
ffffffffc0209f58:	c13ff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc0209f5c:	f929                	bnez	a0,ffffffffc0209eae <sfs_io_nolock+0xec>
ffffffffc0209f5e:	46f2                	lw	a3,28(sp)
ffffffffc0209f60:	6782                	ld	a5,0(sp)
ffffffffc0209f62:	4701                	li	a4,0
ffffffffc0209f64:	865a                	mv	a2,s6
ffffffffc0209f66:	85a2                	mv	a1,s0
ffffffffc0209f68:	854a                	mv	a0,s2
ffffffffc0209f6a:	9782                	jalr	a5
ffffffffc0209f6c:	f129                	bnez	a0,ffffffffc0209eae <sfs_io_nolock+0xec>
ffffffffc0209f6e:	99da                	add	s3,s3,s6
ffffffffc0209f70:	bf3d                	j	ffffffffc0209eae <sfs_io_nolock+0xec>
ffffffffc0209f72:	5575                	li	a0,-3
ffffffffc0209f74:	bfa9                	j	ffffffffc0209ece <sfs_io_nolock+0x10c>
ffffffffc0209f76:	00005697          	auipc	a3,0x5
ffffffffc0209f7a:	06a68693          	addi	a3,a3,106 # ffffffffc020efe0 <dev_node_ops+0x730>
ffffffffc0209f7e:	00002617          	auipc	a2,0x2
ffffffffc0209f82:	98a60613          	addi	a2,a2,-1654 # ffffffffc020b908 <commands+0x210>
ffffffffc0209f86:	22b00593          	li	a1,555
ffffffffc0209f8a:	00005517          	auipc	a0,0x5
ffffffffc0209f8e:	ee650513          	addi	a0,a0,-282 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc0209f92:	d0cf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209f96 <sfs_read>:
ffffffffc0209f96:	7139                	addi	sp,sp,-64
ffffffffc0209f98:	f04a                	sd	s2,32(sp)
ffffffffc0209f9a:	06853903          	ld	s2,104(a0)
ffffffffc0209f9e:	fc06                	sd	ra,56(sp)
ffffffffc0209fa0:	f822                	sd	s0,48(sp)
ffffffffc0209fa2:	f426                	sd	s1,40(sp)
ffffffffc0209fa4:	ec4e                	sd	s3,24(sp)
ffffffffc0209fa6:	04090f63          	beqz	s2,ffffffffc020a004 <sfs_read+0x6e>
ffffffffc0209faa:	0b092783          	lw	a5,176(s2)
ffffffffc0209fae:	ebb9                	bnez	a5,ffffffffc020a004 <sfs_read+0x6e>
ffffffffc0209fb0:	4d38                	lw	a4,88(a0)
ffffffffc0209fb2:	6785                	lui	a5,0x1
ffffffffc0209fb4:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209fb8:	842a                	mv	s0,a0
ffffffffc0209fba:	06f71563          	bne	a4,a5,ffffffffc020a024 <sfs_read+0x8e>
ffffffffc0209fbe:	02050993          	addi	s3,a0,32
ffffffffc0209fc2:	854e                	mv	a0,s3
ffffffffc0209fc4:	84ae                	mv	s1,a1
ffffffffc0209fc6:	d9efa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0209fca:	0184b803          	ld	a6,24(s1)
ffffffffc0209fce:	6494                	ld	a3,8(s1)
ffffffffc0209fd0:	6090                	ld	a2,0(s1)
ffffffffc0209fd2:	85a2                	mv	a1,s0
ffffffffc0209fd4:	4781                	li	a5,0
ffffffffc0209fd6:	0038                	addi	a4,sp,8
ffffffffc0209fd8:	854a                	mv	a0,s2
ffffffffc0209fda:	e442                	sd	a6,8(sp)
ffffffffc0209fdc:	de7ff0ef          	jal	ra,ffffffffc0209dc2 <sfs_io_nolock>
ffffffffc0209fe0:	65a2                	ld	a1,8(sp)
ffffffffc0209fe2:	842a                	mv	s0,a0
ffffffffc0209fe4:	ed81                	bnez	a1,ffffffffc0209ffc <sfs_read+0x66>
ffffffffc0209fe6:	854e                	mv	a0,s3
ffffffffc0209fe8:	d78fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0209fec:	70e2                	ld	ra,56(sp)
ffffffffc0209fee:	8522                	mv	a0,s0
ffffffffc0209ff0:	7442                	ld	s0,48(sp)
ffffffffc0209ff2:	74a2                	ld	s1,40(sp)
ffffffffc0209ff4:	7902                	ld	s2,32(sp)
ffffffffc0209ff6:	69e2                	ld	s3,24(sp)
ffffffffc0209ff8:	6121                	addi	sp,sp,64
ffffffffc0209ffa:	8082                	ret
ffffffffc0209ffc:	8526                	mv	a0,s1
ffffffffc0209ffe:	c5afb0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020a002:	b7d5                	j	ffffffffc0209fe6 <sfs_read+0x50>
ffffffffc020a004:	00005697          	auipc	a3,0x5
ffffffffc020a008:	c8c68693          	addi	a3,a3,-884 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020a00c:	00002617          	auipc	a2,0x2
ffffffffc020a010:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020b908 <commands+0x210>
ffffffffc020a014:	29800593          	li	a1,664
ffffffffc020a018:	00005517          	auipc	a0,0x5
ffffffffc020a01c:	e5850513          	addi	a0,a0,-424 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a020:	c7ef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a024:	869ff0ef          	jal	ra,ffffffffc020988c <sfs_io.part.0>

ffffffffc020a028 <sfs_write>:
ffffffffc020a028:	7139                	addi	sp,sp,-64
ffffffffc020a02a:	f04a                	sd	s2,32(sp)
ffffffffc020a02c:	06853903          	ld	s2,104(a0)
ffffffffc020a030:	fc06                	sd	ra,56(sp)
ffffffffc020a032:	f822                	sd	s0,48(sp)
ffffffffc020a034:	f426                	sd	s1,40(sp)
ffffffffc020a036:	ec4e                	sd	s3,24(sp)
ffffffffc020a038:	04090f63          	beqz	s2,ffffffffc020a096 <sfs_write+0x6e>
ffffffffc020a03c:	0b092783          	lw	a5,176(s2)
ffffffffc020a040:	ebb9                	bnez	a5,ffffffffc020a096 <sfs_write+0x6e>
ffffffffc020a042:	4d38                	lw	a4,88(a0)
ffffffffc020a044:	6785                	lui	a5,0x1
ffffffffc020a046:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a04a:	842a                	mv	s0,a0
ffffffffc020a04c:	06f71563          	bne	a4,a5,ffffffffc020a0b6 <sfs_write+0x8e>
ffffffffc020a050:	02050993          	addi	s3,a0,32
ffffffffc020a054:	854e                	mv	a0,s3
ffffffffc020a056:	84ae                	mv	s1,a1
ffffffffc020a058:	d0cfa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a05c:	0184b803          	ld	a6,24(s1)
ffffffffc020a060:	6494                	ld	a3,8(s1)
ffffffffc020a062:	6090                	ld	a2,0(s1)
ffffffffc020a064:	85a2                	mv	a1,s0
ffffffffc020a066:	4785                	li	a5,1
ffffffffc020a068:	0038                	addi	a4,sp,8
ffffffffc020a06a:	854a                	mv	a0,s2
ffffffffc020a06c:	e442                	sd	a6,8(sp)
ffffffffc020a06e:	d55ff0ef          	jal	ra,ffffffffc0209dc2 <sfs_io_nolock>
ffffffffc020a072:	65a2                	ld	a1,8(sp)
ffffffffc020a074:	842a                	mv	s0,a0
ffffffffc020a076:	ed81                	bnez	a1,ffffffffc020a08e <sfs_write+0x66>
ffffffffc020a078:	854e                	mv	a0,s3
ffffffffc020a07a:	ce6fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a07e:	70e2                	ld	ra,56(sp)
ffffffffc020a080:	8522                	mv	a0,s0
ffffffffc020a082:	7442                	ld	s0,48(sp)
ffffffffc020a084:	74a2                	ld	s1,40(sp)
ffffffffc020a086:	7902                	ld	s2,32(sp)
ffffffffc020a088:	69e2                	ld	s3,24(sp)
ffffffffc020a08a:	6121                	addi	sp,sp,64
ffffffffc020a08c:	8082                	ret
ffffffffc020a08e:	8526                	mv	a0,s1
ffffffffc020a090:	bc8fb0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020a094:	b7d5                	j	ffffffffc020a078 <sfs_write+0x50>
ffffffffc020a096:	00005697          	auipc	a3,0x5
ffffffffc020a09a:	bfa68693          	addi	a3,a3,-1030 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020a09e:	00002617          	auipc	a2,0x2
ffffffffc020a0a2:	86a60613          	addi	a2,a2,-1942 # ffffffffc020b908 <commands+0x210>
ffffffffc020a0a6:	29800593          	li	a1,664
ffffffffc020a0aa:	00005517          	auipc	a0,0x5
ffffffffc020a0ae:	dc650513          	addi	a0,a0,-570 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a0b2:	becf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a0b6:	fd6ff0ef          	jal	ra,ffffffffc020988c <sfs_io.part.0>

ffffffffc020a0ba <sfs_dirent_read_nolock>:
ffffffffc020a0ba:	6198                	ld	a4,0(a1)
ffffffffc020a0bc:	7179                	addi	sp,sp,-48
ffffffffc020a0be:	f406                	sd	ra,40(sp)
ffffffffc020a0c0:	00475883          	lhu	a7,4(a4)
ffffffffc020a0c4:	f022                	sd	s0,32(sp)
ffffffffc020a0c6:	ec26                	sd	s1,24(sp)
ffffffffc020a0c8:	4809                	li	a6,2
ffffffffc020a0ca:	05089b63          	bne	a7,a6,ffffffffc020a120 <sfs_dirent_read_nolock+0x66>
ffffffffc020a0ce:	4718                	lw	a4,8(a4)
ffffffffc020a0d0:	87b2                	mv	a5,a2
ffffffffc020a0d2:	2601                	sext.w	a2,a2
ffffffffc020a0d4:	04e7f663          	bgeu	a5,a4,ffffffffc020a120 <sfs_dirent_read_nolock+0x66>
ffffffffc020a0d8:	84b6                	mv	s1,a3
ffffffffc020a0da:	0074                	addi	a3,sp,12
ffffffffc020a0dc:	842a                	mv	s0,a0
ffffffffc020a0de:	a8dff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc020a0e2:	c511                	beqz	a0,ffffffffc020a0ee <sfs_dirent_read_nolock+0x34>
ffffffffc020a0e4:	70a2                	ld	ra,40(sp)
ffffffffc020a0e6:	7402                	ld	s0,32(sp)
ffffffffc020a0e8:	64e2                	ld	s1,24(sp)
ffffffffc020a0ea:	6145                	addi	sp,sp,48
ffffffffc020a0ec:	8082                	ret
ffffffffc020a0ee:	45b2                	lw	a1,12(sp)
ffffffffc020a0f0:	4054                	lw	a3,4(s0)
ffffffffc020a0f2:	c5b9                	beqz	a1,ffffffffc020a140 <sfs_dirent_read_nolock+0x86>
ffffffffc020a0f4:	04d5f663          	bgeu	a1,a3,ffffffffc020a140 <sfs_dirent_read_nolock+0x86>
ffffffffc020a0f8:	7c08                	ld	a0,56(s0)
ffffffffc020a0fa:	ea9fe0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc020a0fe:	ed31                	bnez	a0,ffffffffc020a15a <sfs_dirent_read_nolock+0xa0>
ffffffffc020a100:	46b2                	lw	a3,12(sp)
ffffffffc020a102:	4701                	li	a4,0
ffffffffc020a104:	10400613          	li	a2,260
ffffffffc020a108:	85a6                	mv	a1,s1
ffffffffc020a10a:	8522                	mv	a0,s0
ffffffffc020a10c:	395000ef          	jal	ra,ffffffffc020aca0 <sfs_rbuf>
ffffffffc020a110:	f971                	bnez	a0,ffffffffc020a0e4 <sfs_dirent_read_nolock+0x2a>
ffffffffc020a112:	100481a3          	sb	zero,259(s1)
ffffffffc020a116:	70a2                	ld	ra,40(sp)
ffffffffc020a118:	7402                	ld	s0,32(sp)
ffffffffc020a11a:	64e2                	ld	s1,24(sp)
ffffffffc020a11c:	6145                	addi	sp,sp,48
ffffffffc020a11e:	8082                	ret
ffffffffc020a120:	00005697          	auipc	a3,0x5
ffffffffc020a124:	ee068693          	addi	a3,a3,-288 # ffffffffc020f000 <dev_node_ops+0x750>
ffffffffc020a128:	00001617          	auipc	a2,0x1
ffffffffc020a12c:	7e060613          	addi	a2,a2,2016 # ffffffffc020b908 <commands+0x210>
ffffffffc020a130:	18e00593          	li	a1,398
ffffffffc020a134:	00005517          	auipc	a0,0x5
ffffffffc020a138:	d3c50513          	addi	a0,a0,-708 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a13c:	b62f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a140:	872e                	mv	a4,a1
ffffffffc020a142:	00005617          	auipc	a2,0x5
ffffffffc020a146:	d5e60613          	addi	a2,a2,-674 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc020a14a:	05300593          	li	a1,83
ffffffffc020a14e:	00005517          	auipc	a0,0x5
ffffffffc020a152:	d2250513          	addi	a0,a0,-734 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a156:	b48f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a15a:	00005697          	auipc	a3,0x5
ffffffffc020a15e:	d7e68693          	addi	a3,a3,-642 # ffffffffc020eed8 <dev_node_ops+0x628>
ffffffffc020a162:	00001617          	auipc	a2,0x1
ffffffffc020a166:	7a660613          	addi	a2,a2,1958 # ffffffffc020b908 <commands+0x210>
ffffffffc020a16a:	19500593          	li	a1,405
ffffffffc020a16e:	00005517          	auipc	a0,0x5
ffffffffc020a172:	d0250513          	addi	a0,a0,-766 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a176:	b28f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a17a <sfs_getdirentry>:
ffffffffc020a17a:	715d                	addi	sp,sp,-80
ffffffffc020a17c:	ec56                	sd	s5,24(sp)
ffffffffc020a17e:	8aaa                	mv	s5,a0
ffffffffc020a180:	10400513          	li	a0,260
ffffffffc020a184:	e85a                	sd	s6,16(sp)
ffffffffc020a186:	e486                	sd	ra,72(sp)
ffffffffc020a188:	e0a2                	sd	s0,64(sp)
ffffffffc020a18a:	fc26                	sd	s1,56(sp)
ffffffffc020a18c:	f84a                	sd	s2,48(sp)
ffffffffc020a18e:	f44e                	sd	s3,40(sp)
ffffffffc020a190:	f052                	sd	s4,32(sp)
ffffffffc020a192:	e45e                	sd	s7,8(sp)
ffffffffc020a194:	e062                	sd	s8,0(sp)
ffffffffc020a196:	8b2e                	mv	s6,a1
ffffffffc020a198:	df7f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a19c:	cd61                	beqz	a0,ffffffffc020a274 <sfs_getdirentry+0xfa>
ffffffffc020a19e:	068abb83          	ld	s7,104(s5) # 8000068 <_binary_bin_sfs_img_size+0x7f8ad68>
ffffffffc020a1a2:	0c0b8b63          	beqz	s7,ffffffffc020a278 <sfs_getdirentry+0xfe>
ffffffffc020a1a6:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a1aa:	e7f9                	bnez	a5,ffffffffc020a278 <sfs_getdirentry+0xfe>
ffffffffc020a1ac:	058aa703          	lw	a4,88(s5)
ffffffffc020a1b0:	6785                	lui	a5,0x1
ffffffffc020a1b2:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a1b6:	0ef71163          	bne	a4,a5,ffffffffc020a298 <sfs_getdirentry+0x11e>
ffffffffc020a1ba:	008b3983          	ld	s3,8(s6) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020a1be:	892a                	mv	s2,a0
ffffffffc020a1c0:	0a09c163          	bltz	s3,ffffffffc020a262 <sfs_getdirentry+0xe8>
ffffffffc020a1c4:	0ff9f793          	zext.b	a5,s3
ffffffffc020a1c8:	efc9                	bnez	a5,ffffffffc020a262 <sfs_getdirentry+0xe8>
ffffffffc020a1ca:	000ab783          	ld	a5,0(s5)
ffffffffc020a1ce:	0089d993          	srli	s3,s3,0x8
ffffffffc020a1d2:	2981                	sext.w	s3,s3
ffffffffc020a1d4:	479c                	lw	a5,8(a5)
ffffffffc020a1d6:	0937eb63          	bltu	a5,s3,ffffffffc020a26c <sfs_getdirentry+0xf2>
ffffffffc020a1da:	020a8c13          	addi	s8,s5,32
ffffffffc020a1de:	8562                	mv	a0,s8
ffffffffc020a1e0:	b84fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a1e4:	000ab783          	ld	a5,0(s5)
ffffffffc020a1e8:	0087aa03          	lw	s4,8(a5)
ffffffffc020a1ec:	07405663          	blez	s4,ffffffffc020a258 <sfs_getdirentry+0xde>
ffffffffc020a1f0:	4481                	li	s1,0
ffffffffc020a1f2:	a811                	j	ffffffffc020a206 <sfs_getdirentry+0x8c>
ffffffffc020a1f4:	00092783          	lw	a5,0(s2)
ffffffffc020a1f8:	c781                	beqz	a5,ffffffffc020a200 <sfs_getdirentry+0x86>
ffffffffc020a1fa:	02098263          	beqz	s3,ffffffffc020a21e <sfs_getdirentry+0xa4>
ffffffffc020a1fe:	39fd                	addiw	s3,s3,-1
ffffffffc020a200:	2485                	addiw	s1,s1,1
ffffffffc020a202:	049a0b63          	beq	s4,s1,ffffffffc020a258 <sfs_getdirentry+0xde>
ffffffffc020a206:	86ca                	mv	a3,s2
ffffffffc020a208:	8626                	mv	a2,s1
ffffffffc020a20a:	85d6                	mv	a1,s5
ffffffffc020a20c:	855e                	mv	a0,s7
ffffffffc020a20e:	eadff0ef          	jal	ra,ffffffffc020a0ba <sfs_dirent_read_nolock>
ffffffffc020a212:	842a                	mv	s0,a0
ffffffffc020a214:	d165                	beqz	a0,ffffffffc020a1f4 <sfs_getdirentry+0x7a>
ffffffffc020a216:	8562                	mv	a0,s8
ffffffffc020a218:	b48fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a21c:	a831                	j	ffffffffc020a238 <sfs_getdirentry+0xbe>
ffffffffc020a21e:	8562                	mv	a0,s8
ffffffffc020a220:	b40fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a224:	4701                	li	a4,0
ffffffffc020a226:	4685                	li	a3,1
ffffffffc020a228:	10000613          	li	a2,256
ffffffffc020a22c:	00490593          	addi	a1,s2,4
ffffffffc020a230:	855a                	mv	a0,s6
ffffffffc020a232:	9bafb0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc020a236:	842a                	mv	s0,a0
ffffffffc020a238:	854a                	mv	a0,s2
ffffffffc020a23a:	e05f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a23e:	60a6                	ld	ra,72(sp)
ffffffffc020a240:	8522                	mv	a0,s0
ffffffffc020a242:	6406                	ld	s0,64(sp)
ffffffffc020a244:	74e2                	ld	s1,56(sp)
ffffffffc020a246:	7942                	ld	s2,48(sp)
ffffffffc020a248:	79a2                	ld	s3,40(sp)
ffffffffc020a24a:	7a02                	ld	s4,32(sp)
ffffffffc020a24c:	6ae2                	ld	s5,24(sp)
ffffffffc020a24e:	6b42                	ld	s6,16(sp)
ffffffffc020a250:	6ba2                	ld	s7,8(sp)
ffffffffc020a252:	6c02                	ld	s8,0(sp)
ffffffffc020a254:	6161                	addi	sp,sp,80
ffffffffc020a256:	8082                	ret
ffffffffc020a258:	8562                	mv	a0,s8
ffffffffc020a25a:	5441                	li	s0,-16
ffffffffc020a25c:	b04fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a260:	bfe1                	j	ffffffffc020a238 <sfs_getdirentry+0xbe>
ffffffffc020a262:	854a                	mv	a0,s2
ffffffffc020a264:	ddbf70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a268:	5475                	li	s0,-3
ffffffffc020a26a:	bfd1                	j	ffffffffc020a23e <sfs_getdirentry+0xc4>
ffffffffc020a26c:	dd3f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a270:	5441                	li	s0,-16
ffffffffc020a272:	b7f1                	j	ffffffffc020a23e <sfs_getdirentry+0xc4>
ffffffffc020a274:	5471                	li	s0,-4
ffffffffc020a276:	b7e1                	j	ffffffffc020a23e <sfs_getdirentry+0xc4>
ffffffffc020a278:	00005697          	auipc	a3,0x5
ffffffffc020a27c:	a1868693          	addi	a3,a3,-1512 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020a280:	00001617          	auipc	a2,0x1
ffffffffc020a284:	68860613          	addi	a2,a2,1672 # ffffffffc020b908 <commands+0x210>
ffffffffc020a288:	33c00593          	li	a1,828
ffffffffc020a28c:	00005517          	auipc	a0,0x5
ffffffffc020a290:	be450513          	addi	a0,a0,-1052 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a294:	a0af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a298:	00005697          	auipc	a3,0x5
ffffffffc020a29c:	ba068693          	addi	a3,a3,-1120 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020a2a0:	00001617          	auipc	a2,0x1
ffffffffc020a2a4:	66860613          	addi	a2,a2,1640 # ffffffffc020b908 <commands+0x210>
ffffffffc020a2a8:	33d00593          	li	a1,829
ffffffffc020a2ac:	00005517          	auipc	a0,0x5
ffffffffc020a2b0:	bc450513          	addi	a0,a0,-1084 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a2b4:	9eaf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a2b8 <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a2b8:	715d                	addi	sp,sp,-80
ffffffffc020a2ba:	f052                	sd	s4,32(sp)
ffffffffc020a2bc:	8a2a                	mv	s4,a0
ffffffffc020a2be:	8532                	mv	a0,a2
ffffffffc020a2c0:	f44e                	sd	s3,40(sp)
ffffffffc020a2c2:	e85a                	sd	s6,16(sp)
ffffffffc020a2c4:	e45e                	sd	s7,8(sp)
ffffffffc020a2c6:	e486                	sd	ra,72(sp)
ffffffffc020a2c8:	e0a2                	sd	s0,64(sp)
ffffffffc020a2ca:	fc26                	sd	s1,56(sp)
ffffffffc020a2cc:	f84a                	sd	s2,48(sp)
ffffffffc020a2ce:	ec56                	sd	s5,24(sp)
ffffffffc020a2d0:	e062                	sd	s8,0(sp)
ffffffffc020a2d2:	8b32                	mv	s6,a2
ffffffffc020a2d4:	89ae                	mv	s3,a1
ffffffffc020a2d6:	8bb6                	mv	s7,a3
ffffffffc020a2d8:	0aa010ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc020a2dc:	0ff00793          	li	a5,255
ffffffffc020a2e0:	06a7ef63          	bltu	a5,a0,ffffffffc020a35e <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a2e4:	10400513          	li	a0,260
ffffffffc020a2e8:	ca7f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a2ec:	892a                	mv	s2,a0
ffffffffc020a2ee:	c535                	beqz	a0,ffffffffc020a35a <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a2f0:	0009b783          	ld	a5,0(s3)
ffffffffc020a2f4:	0087aa83          	lw	s5,8(a5)
ffffffffc020a2f8:	05505a63          	blez	s5,ffffffffc020a34c <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a2fc:	4481                	li	s1,0
ffffffffc020a2fe:	00450c13          	addi	s8,a0,4
ffffffffc020a302:	a829                	j	ffffffffc020a31c <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a304:	00092783          	lw	a5,0(s2)
ffffffffc020a308:	c799                	beqz	a5,ffffffffc020a316 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a30a:	85e2                	mv	a1,s8
ffffffffc020a30c:	855a                	mv	a0,s6
ffffffffc020a30e:	0bc010ef          	jal	ra,ffffffffc020b3ca <strcmp>
ffffffffc020a312:	842a                	mv	s0,a0
ffffffffc020a314:	cd15                	beqz	a0,ffffffffc020a350 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a316:	2485                	addiw	s1,s1,1
ffffffffc020a318:	029a8a63          	beq	s5,s1,ffffffffc020a34c <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a31c:	86ca                	mv	a3,s2
ffffffffc020a31e:	8626                	mv	a2,s1
ffffffffc020a320:	85ce                	mv	a1,s3
ffffffffc020a322:	8552                	mv	a0,s4
ffffffffc020a324:	d97ff0ef          	jal	ra,ffffffffc020a0ba <sfs_dirent_read_nolock>
ffffffffc020a328:	842a                	mv	s0,a0
ffffffffc020a32a:	dd69                	beqz	a0,ffffffffc020a304 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a32c:	854a                	mv	a0,s2
ffffffffc020a32e:	d11f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a332:	60a6                	ld	ra,72(sp)
ffffffffc020a334:	8522                	mv	a0,s0
ffffffffc020a336:	6406                	ld	s0,64(sp)
ffffffffc020a338:	74e2                	ld	s1,56(sp)
ffffffffc020a33a:	7942                	ld	s2,48(sp)
ffffffffc020a33c:	79a2                	ld	s3,40(sp)
ffffffffc020a33e:	7a02                	ld	s4,32(sp)
ffffffffc020a340:	6ae2                	ld	s5,24(sp)
ffffffffc020a342:	6b42                	ld	s6,16(sp)
ffffffffc020a344:	6ba2                	ld	s7,8(sp)
ffffffffc020a346:	6c02                	ld	s8,0(sp)
ffffffffc020a348:	6161                	addi	sp,sp,80
ffffffffc020a34a:	8082                	ret
ffffffffc020a34c:	5441                	li	s0,-16
ffffffffc020a34e:	bff9                	j	ffffffffc020a32c <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a350:	00092783          	lw	a5,0(s2)
ffffffffc020a354:	00fba023          	sw	a5,0(s7)
ffffffffc020a358:	bfd1                	j	ffffffffc020a32c <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a35a:	5471                	li	s0,-4
ffffffffc020a35c:	bfd9                	j	ffffffffc020a332 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a35e:	00005697          	auipc	a3,0x5
ffffffffc020a362:	cf268693          	addi	a3,a3,-782 # ffffffffc020f050 <dev_node_ops+0x7a0>
ffffffffc020a366:	00001617          	auipc	a2,0x1
ffffffffc020a36a:	5a260613          	addi	a2,a2,1442 # ffffffffc020b908 <commands+0x210>
ffffffffc020a36e:	1ba00593          	li	a1,442
ffffffffc020a372:	00005517          	auipc	a0,0x5
ffffffffc020a376:	afe50513          	addi	a0,a0,-1282 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a37a:	924f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a37e <sfs_truncfile>:
ffffffffc020a37e:	7175                	addi	sp,sp,-144
ffffffffc020a380:	e506                	sd	ra,136(sp)
ffffffffc020a382:	e122                	sd	s0,128(sp)
ffffffffc020a384:	fca6                	sd	s1,120(sp)
ffffffffc020a386:	f8ca                	sd	s2,112(sp)
ffffffffc020a388:	f4ce                	sd	s3,104(sp)
ffffffffc020a38a:	f0d2                	sd	s4,96(sp)
ffffffffc020a38c:	ecd6                	sd	s5,88(sp)
ffffffffc020a38e:	e8da                	sd	s6,80(sp)
ffffffffc020a390:	e4de                	sd	s7,72(sp)
ffffffffc020a392:	e0e2                	sd	s8,64(sp)
ffffffffc020a394:	fc66                	sd	s9,56(sp)
ffffffffc020a396:	f86a                	sd	s10,48(sp)
ffffffffc020a398:	f46e                	sd	s11,40(sp)
ffffffffc020a39a:	080007b7          	lui	a5,0x8000
ffffffffc020a39e:	16b7e463          	bltu	a5,a1,ffffffffc020a506 <sfs_truncfile+0x188>
ffffffffc020a3a2:	06853c83          	ld	s9,104(a0)
ffffffffc020a3a6:	89aa                	mv	s3,a0
ffffffffc020a3a8:	160c8163          	beqz	s9,ffffffffc020a50a <sfs_truncfile+0x18c>
ffffffffc020a3ac:	0b0ca783          	lw	a5,176(s9)
ffffffffc020a3b0:	14079d63          	bnez	a5,ffffffffc020a50a <sfs_truncfile+0x18c>
ffffffffc020a3b4:	4d38                	lw	a4,88(a0)
ffffffffc020a3b6:	6405                	lui	s0,0x1
ffffffffc020a3b8:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a3bc:	16f71763          	bne	a4,a5,ffffffffc020a52a <sfs_truncfile+0x1ac>
ffffffffc020a3c0:	00053a83          	ld	s5,0(a0)
ffffffffc020a3c4:	147d                	addi	s0,s0,-1
ffffffffc020a3c6:	942e                	add	s0,s0,a1
ffffffffc020a3c8:	000ae783          	lwu	a5,0(s5)
ffffffffc020a3cc:	8031                	srli	s0,s0,0xc
ffffffffc020a3ce:	8a2e                	mv	s4,a1
ffffffffc020a3d0:	2401                	sext.w	s0,s0
ffffffffc020a3d2:	02b79763          	bne	a5,a1,ffffffffc020a400 <sfs_truncfile+0x82>
ffffffffc020a3d6:	008aa783          	lw	a5,8(s5)
ffffffffc020a3da:	4901                	li	s2,0
ffffffffc020a3dc:	18879763          	bne	a5,s0,ffffffffc020a56a <sfs_truncfile+0x1ec>
ffffffffc020a3e0:	60aa                	ld	ra,136(sp)
ffffffffc020a3e2:	640a                	ld	s0,128(sp)
ffffffffc020a3e4:	74e6                	ld	s1,120(sp)
ffffffffc020a3e6:	79a6                	ld	s3,104(sp)
ffffffffc020a3e8:	7a06                	ld	s4,96(sp)
ffffffffc020a3ea:	6ae6                	ld	s5,88(sp)
ffffffffc020a3ec:	6b46                	ld	s6,80(sp)
ffffffffc020a3ee:	6ba6                	ld	s7,72(sp)
ffffffffc020a3f0:	6c06                	ld	s8,64(sp)
ffffffffc020a3f2:	7ce2                	ld	s9,56(sp)
ffffffffc020a3f4:	7d42                	ld	s10,48(sp)
ffffffffc020a3f6:	7da2                	ld	s11,40(sp)
ffffffffc020a3f8:	854a                	mv	a0,s2
ffffffffc020a3fa:	7946                	ld	s2,112(sp)
ffffffffc020a3fc:	6149                	addi	sp,sp,144
ffffffffc020a3fe:	8082                	ret
ffffffffc020a400:	02050b13          	addi	s6,a0,32
ffffffffc020a404:	855a                	mv	a0,s6
ffffffffc020a406:	95efa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a40a:	008aa483          	lw	s1,8(s5)
ffffffffc020a40e:	0a84e663          	bltu	s1,s0,ffffffffc020a4ba <sfs_truncfile+0x13c>
ffffffffc020a412:	0c947163          	bgeu	s0,s1,ffffffffc020a4d4 <sfs_truncfile+0x156>
ffffffffc020a416:	4dad                	li	s11,11
ffffffffc020a418:	4b85                	li	s7,1
ffffffffc020a41a:	a09d                	j	ffffffffc020a480 <sfs_truncfile+0x102>
ffffffffc020a41c:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a420:	0009079b          	sext.w	a5,s2
ffffffffc020a424:	3ff00713          	li	a4,1023
ffffffffc020a428:	04f76563          	bltu	a4,a5,ffffffffc020a472 <sfs_truncfile+0xf4>
ffffffffc020a42c:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a430:	040c0163          	beqz	s8,ffffffffc020a472 <sfs_truncfile+0xf4>
ffffffffc020a434:	004ca783          	lw	a5,4(s9)
ffffffffc020a438:	18fc7963          	bgeu	s8,a5,ffffffffc020a5ca <sfs_truncfile+0x24c>
ffffffffc020a43c:	038cb503          	ld	a0,56(s9)
ffffffffc020a440:	85e2                	mv	a1,s8
ffffffffc020a442:	b61fe0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc020a446:	16051263          	bnez	a0,ffffffffc020a5aa <sfs_truncfile+0x22c>
ffffffffc020a44a:	02091793          	slli	a5,s2,0x20
ffffffffc020a44e:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a452:	86e2                	mv	a3,s8
ffffffffc020a454:	4611                	li	a2,4
ffffffffc020a456:	082c                	addi	a1,sp,24
ffffffffc020a458:	8566                	mv	a0,s9
ffffffffc020a45a:	e43a                	sd	a4,8(sp)
ffffffffc020a45c:	ce02                	sw	zero,28(sp)
ffffffffc020a45e:	043000ef          	jal	ra,ffffffffc020aca0 <sfs_rbuf>
ffffffffc020a462:	892a                	mv	s2,a0
ffffffffc020a464:	e141                	bnez	a0,ffffffffc020a4e4 <sfs_truncfile+0x166>
ffffffffc020a466:	47e2                	lw	a5,24(sp)
ffffffffc020a468:	6722                	ld	a4,8(sp)
ffffffffc020a46a:	e3c9                	bnez	a5,ffffffffc020a4ec <sfs_truncfile+0x16e>
ffffffffc020a46c:	008d2603          	lw	a2,8(s10)
ffffffffc020a470:	367d                	addiw	a2,a2,-1
ffffffffc020a472:	00cd2423          	sw	a2,8(s10)
ffffffffc020a476:	0179b823          	sd	s7,16(s3)
ffffffffc020a47a:	34fd                	addiw	s1,s1,-1
ffffffffc020a47c:	04940a63          	beq	s0,s1,ffffffffc020a4d0 <sfs_truncfile+0x152>
ffffffffc020a480:	0009bd03          	ld	s10,0(s3)
ffffffffc020a484:	008d2703          	lw	a4,8(s10)
ffffffffc020a488:	c369                	beqz	a4,ffffffffc020a54a <sfs_truncfile+0x1cc>
ffffffffc020a48a:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a48e:	0007861b          	sext.w	a2,a5
ffffffffc020a492:	f8cde5e3          	bltu	s11,a2,ffffffffc020a41c <sfs_truncfile+0x9e>
ffffffffc020a496:	02079713          	slli	a4,a5,0x20
ffffffffc020a49a:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a49e:	00fd0933          	add	s2,s10,a5
ffffffffc020a4a2:	00c92583          	lw	a1,12(s2)
ffffffffc020a4a6:	d5f1                	beqz	a1,ffffffffc020a472 <sfs_truncfile+0xf4>
ffffffffc020a4a8:	8566                	mv	a0,s9
ffffffffc020a4aa:	c06ff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc020a4ae:	00092623          	sw	zero,12(s2)
ffffffffc020a4b2:	008d2603          	lw	a2,8(s10)
ffffffffc020a4b6:	367d                	addiw	a2,a2,-1
ffffffffc020a4b8:	bf6d                	j	ffffffffc020a472 <sfs_truncfile+0xf4>
ffffffffc020a4ba:	4681                	li	a3,0
ffffffffc020a4bc:	8626                	mv	a2,s1
ffffffffc020a4be:	85ce                	mv	a1,s3
ffffffffc020a4c0:	8566                	mv	a0,s9
ffffffffc020a4c2:	ea8ff0ef          	jal	ra,ffffffffc0209b6a <sfs_bmap_load_nolock>
ffffffffc020a4c6:	892a                	mv	s2,a0
ffffffffc020a4c8:	ed11                	bnez	a0,ffffffffc020a4e4 <sfs_truncfile+0x166>
ffffffffc020a4ca:	2485                	addiw	s1,s1,1
ffffffffc020a4cc:	fe9417e3          	bne	s0,s1,ffffffffc020a4ba <sfs_truncfile+0x13c>
ffffffffc020a4d0:	008aa483          	lw	s1,8(s5)
ffffffffc020a4d4:	0a941b63          	bne	s0,s1,ffffffffc020a58a <sfs_truncfile+0x20c>
ffffffffc020a4d8:	014aa023          	sw	s4,0(s5)
ffffffffc020a4dc:	4785                	li	a5,1
ffffffffc020a4de:	00f9b823          	sd	a5,16(s3)
ffffffffc020a4e2:	4901                	li	s2,0
ffffffffc020a4e4:	855a                	mv	a0,s6
ffffffffc020a4e6:	87afa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a4ea:	bddd                	j	ffffffffc020a3e0 <sfs_truncfile+0x62>
ffffffffc020a4ec:	86e2                	mv	a3,s8
ffffffffc020a4ee:	4611                	li	a2,4
ffffffffc020a4f0:	086c                	addi	a1,sp,28
ffffffffc020a4f2:	8566                	mv	a0,s9
ffffffffc020a4f4:	02d000ef          	jal	ra,ffffffffc020ad20 <sfs_wbuf>
ffffffffc020a4f8:	892a                	mv	s2,a0
ffffffffc020a4fa:	f56d                	bnez	a0,ffffffffc020a4e4 <sfs_truncfile+0x166>
ffffffffc020a4fc:	45e2                	lw	a1,24(sp)
ffffffffc020a4fe:	8566                	mv	a0,s9
ffffffffc020a500:	bb0ff0ef          	jal	ra,ffffffffc02098b0 <sfs_block_free>
ffffffffc020a504:	b7a5                	j	ffffffffc020a46c <sfs_truncfile+0xee>
ffffffffc020a506:	5975                	li	s2,-3
ffffffffc020a508:	bde1                	j	ffffffffc020a3e0 <sfs_truncfile+0x62>
ffffffffc020a50a:	00004697          	auipc	a3,0x4
ffffffffc020a50e:	78668693          	addi	a3,a3,1926 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020a512:	00001617          	auipc	a2,0x1
ffffffffc020a516:	3f660613          	addi	a2,a2,1014 # ffffffffc020b908 <commands+0x210>
ffffffffc020a51a:	3ab00593          	li	a1,939
ffffffffc020a51e:	00005517          	auipc	a0,0x5
ffffffffc020a522:	95250513          	addi	a0,a0,-1710 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a526:	f79f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a52a:	00005697          	auipc	a3,0x5
ffffffffc020a52e:	90e68693          	addi	a3,a3,-1778 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020a532:	00001617          	auipc	a2,0x1
ffffffffc020a536:	3d660613          	addi	a2,a2,982 # ffffffffc020b908 <commands+0x210>
ffffffffc020a53a:	3ac00593          	li	a1,940
ffffffffc020a53e:	00005517          	auipc	a0,0x5
ffffffffc020a542:	93250513          	addi	a0,a0,-1742 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a546:	f59f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a54a:	00005697          	auipc	a3,0x5
ffffffffc020a54e:	b4668693          	addi	a3,a3,-1210 # ffffffffc020f090 <dev_node_ops+0x7e0>
ffffffffc020a552:	00001617          	auipc	a2,0x1
ffffffffc020a556:	3b660613          	addi	a2,a2,950 # ffffffffc020b908 <commands+0x210>
ffffffffc020a55a:	17b00593          	li	a1,379
ffffffffc020a55e:	00005517          	auipc	a0,0x5
ffffffffc020a562:	91250513          	addi	a0,a0,-1774 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a566:	f39f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a56a:	00005697          	auipc	a3,0x5
ffffffffc020a56e:	b0e68693          	addi	a3,a3,-1266 # ffffffffc020f078 <dev_node_ops+0x7c8>
ffffffffc020a572:	00001617          	auipc	a2,0x1
ffffffffc020a576:	39660613          	addi	a2,a2,918 # ffffffffc020b908 <commands+0x210>
ffffffffc020a57a:	3b300593          	li	a1,947
ffffffffc020a57e:	00005517          	auipc	a0,0x5
ffffffffc020a582:	8f250513          	addi	a0,a0,-1806 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a586:	f19f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a58a:	00005697          	auipc	a3,0x5
ffffffffc020a58e:	b5668693          	addi	a3,a3,-1194 # ffffffffc020f0e0 <dev_node_ops+0x830>
ffffffffc020a592:	00001617          	auipc	a2,0x1
ffffffffc020a596:	37660613          	addi	a2,a2,886 # ffffffffc020b908 <commands+0x210>
ffffffffc020a59a:	3cc00593          	li	a1,972
ffffffffc020a59e:	00005517          	auipc	a0,0x5
ffffffffc020a5a2:	8d250513          	addi	a0,a0,-1838 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a5a6:	ef9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a5aa:	00005697          	auipc	a3,0x5
ffffffffc020a5ae:	afe68693          	addi	a3,a3,-1282 # ffffffffc020f0a8 <dev_node_ops+0x7f8>
ffffffffc020a5b2:	00001617          	auipc	a2,0x1
ffffffffc020a5b6:	35660613          	addi	a2,a2,854 # ffffffffc020b908 <commands+0x210>
ffffffffc020a5ba:	12b00593          	li	a1,299
ffffffffc020a5be:	00005517          	auipc	a0,0x5
ffffffffc020a5c2:	8b250513          	addi	a0,a0,-1870 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a5c6:	ed9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a5ca:	8762                	mv	a4,s8
ffffffffc020a5cc:	86be                	mv	a3,a5
ffffffffc020a5ce:	00005617          	auipc	a2,0x5
ffffffffc020a5d2:	8d260613          	addi	a2,a2,-1838 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc020a5d6:	05300593          	li	a1,83
ffffffffc020a5da:	00005517          	auipc	a0,0x5
ffffffffc020a5de:	89650513          	addi	a0,a0,-1898 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a5e2:	ebdf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a5e6 <sfs_load_inode>:
ffffffffc020a5e6:	7139                	addi	sp,sp,-64
ffffffffc020a5e8:	fc06                	sd	ra,56(sp)
ffffffffc020a5ea:	f822                	sd	s0,48(sp)
ffffffffc020a5ec:	f426                	sd	s1,40(sp)
ffffffffc020a5ee:	f04a                	sd	s2,32(sp)
ffffffffc020a5f0:	84b2                	mv	s1,a2
ffffffffc020a5f2:	892a                	mv	s2,a0
ffffffffc020a5f4:	ec4e                	sd	s3,24(sp)
ffffffffc020a5f6:	e852                	sd	s4,16(sp)
ffffffffc020a5f8:	89ae                	mv	s3,a1
ffffffffc020a5fa:	e456                	sd	s5,8(sp)
ffffffffc020a5fc:	0d5000ef          	jal	ra,ffffffffc020aed0 <lock_sfs_fs>
ffffffffc020a600:	45a9                	li	a1,10
ffffffffc020a602:	8526                	mv	a0,s1
ffffffffc020a604:	0a893403          	ld	s0,168(s2)
ffffffffc020a608:	0e9000ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc020a60c:	02051793          	slli	a5,a0,0x20
ffffffffc020a610:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a614:	9722                	add	a4,a4,s0
ffffffffc020a616:	843a                	mv	s0,a4
ffffffffc020a618:	a029                	j	ffffffffc020a622 <sfs_load_inode+0x3c>
ffffffffc020a61a:	fc042783          	lw	a5,-64(s0)
ffffffffc020a61e:	10978863          	beq	a5,s1,ffffffffc020a72e <sfs_load_inode+0x148>
ffffffffc020a622:	6400                	ld	s0,8(s0)
ffffffffc020a624:	fe871be3          	bne	a4,s0,ffffffffc020a61a <sfs_load_inode+0x34>
ffffffffc020a628:	04000513          	li	a0,64
ffffffffc020a62c:	963f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a630:	8aaa                	mv	s5,a0
ffffffffc020a632:	16050563          	beqz	a0,ffffffffc020a79c <sfs_load_inode+0x1b6>
ffffffffc020a636:	00492683          	lw	a3,4(s2)
ffffffffc020a63a:	18048363          	beqz	s1,ffffffffc020a7c0 <sfs_load_inode+0x1da>
ffffffffc020a63e:	18d4f163          	bgeu	s1,a3,ffffffffc020a7c0 <sfs_load_inode+0x1da>
ffffffffc020a642:	03893503          	ld	a0,56(s2)
ffffffffc020a646:	85a6                	mv	a1,s1
ffffffffc020a648:	95bfe0ef          	jal	ra,ffffffffc0208fa2 <bitmap_test>
ffffffffc020a64c:	18051763          	bnez	a0,ffffffffc020a7da <sfs_load_inode+0x1f4>
ffffffffc020a650:	4701                	li	a4,0
ffffffffc020a652:	86a6                	mv	a3,s1
ffffffffc020a654:	04000613          	li	a2,64
ffffffffc020a658:	85d6                	mv	a1,s5
ffffffffc020a65a:	854a                	mv	a0,s2
ffffffffc020a65c:	644000ef          	jal	ra,ffffffffc020aca0 <sfs_rbuf>
ffffffffc020a660:	842a                	mv	s0,a0
ffffffffc020a662:	0e051563          	bnez	a0,ffffffffc020a74c <sfs_load_inode+0x166>
ffffffffc020a666:	006ad783          	lhu	a5,6(s5)
ffffffffc020a66a:	12078b63          	beqz	a5,ffffffffc020a7a0 <sfs_load_inode+0x1ba>
ffffffffc020a66e:	6405                	lui	s0,0x1
ffffffffc020a670:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a674:	8e8fd0ef          	jal	ra,ffffffffc020775c <__alloc_inode>
ffffffffc020a678:	8a2a                	mv	s4,a0
ffffffffc020a67a:	c961                	beqz	a0,ffffffffc020a74a <sfs_load_inode+0x164>
ffffffffc020a67c:	004ad683          	lhu	a3,4(s5)
ffffffffc020a680:	4785                	li	a5,1
ffffffffc020a682:	0cf69c63          	bne	a3,a5,ffffffffc020a75a <sfs_load_inode+0x174>
ffffffffc020a686:	864a                	mv	a2,s2
ffffffffc020a688:	00005597          	auipc	a1,0x5
ffffffffc020a68c:	b6858593          	addi	a1,a1,-1176 # ffffffffc020f1f0 <sfs_node_fileops>
ffffffffc020a690:	8e8fd0ef          	jal	ra,ffffffffc0207778 <inode_init>
ffffffffc020a694:	058a2783          	lw	a5,88(s4)
ffffffffc020a698:	23540413          	addi	s0,s0,565
ffffffffc020a69c:	0e879063          	bne	a5,s0,ffffffffc020a77c <sfs_load_inode+0x196>
ffffffffc020a6a0:	4785                	li	a5,1
ffffffffc020a6a2:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a6a6:	015a3023          	sd	s5,0(s4)
ffffffffc020a6aa:	009a2423          	sw	s1,8(s4)
ffffffffc020a6ae:	000a3823          	sd	zero,16(s4)
ffffffffc020a6b2:	4585                	li	a1,1
ffffffffc020a6b4:	020a0513          	addi	a0,s4,32
ffffffffc020a6b8:	ea3f90ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc020a6bc:	058a2703          	lw	a4,88(s4)
ffffffffc020a6c0:	6785                	lui	a5,0x1
ffffffffc020a6c2:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a6c6:	14f71663          	bne	a4,a5,ffffffffc020a812 <sfs_load_inode+0x22c>
ffffffffc020a6ca:	0a093703          	ld	a4,160(s2)
ffffffffc020a6ce:	038a0793          	addi	a5,s4,56
ffffffffc020a6d2:	008a2503          	lw	a0,8(s4)
ffffffffc020a6d6:	e31c                	sd	a5,0(a4)
ffffffffc020a6d8:	0af93023          	sd	a5,160(s2)
ffffffffc020a6dc:	09890793          	addi	a5,s2,152
ffffffffc020a6e0:	0a893403          	ld	s0,168(s2)
ffffffffc020a6e4:	45a9                	li	a1,10
ffffffffc020a6e6:	04ea3023          	sd	a4,64(s4)
ffffffffc020a6ea:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a6ee:	003000ef          	jal	ra,ffffffffc020aef0 <hash32>
ffffffffc020a6f2:	02051713          	slli	a4,a0,0x20
ffffffffc020a6f6:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a6fa:	97a2                	add	a5,a5,s0
ffffffffc020a6fc:	6798                	ld	a4,8(a5)
ffffffffc020a6fe:	048a0693          	addi	a3,s4,72
ffffffffc020a702:	e314                	sd	a3,0(a4)
ffffffffc020a704:	e794                	sd	a3,8(a5)
ffffffffc020a706:	04ea3823          	sd	a4,80(s4)
ffffffffc020a70a:	04fa3423          	sd	a5,72(s4)
ffffffffc020a70e:	854a                	mv	a0,s2
ffffffffc020a710:	7d0000ef          	jal	ra,ffffffffc020aee0 <unlock_sfs_fs>
ffffffffc020a714:	4401                	li	s0,0
ffffffffc020a716:	0149b023          	sd	s4,0(s3)
ffffffffc020a71a:	70e2                	ld	ra,56(sp)
ffffffffc020a71c:	8522                	mv	a0,s0
ffffffffc020a71e:	7442                	ld	s0,48(sp)
ffffffffc020a720:	74a2                	ld	s1,40(sp)
ffffffffc020a722:	7902                	ld	s2,32(sp)
ffffffffc020a724:	69e2                	ld	s3,24(sp)
ffffffffc020a726:	6a42                	ld	s4,16(sp)
ffffffffc020a728:	6aa2                	ld	s5,8(sp)
ffffffffc020a72a:	6121                	addi	sp,sp,64
ffffffffc020a72c:	8082                	ret
ffffffffc020a72e:	fb840a13          	addi	s4,s0,-72
ffffffffc020a732:	8552                	mv	a0,s4
ffffffffc020a734:	8a6fd0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc020a738:	4785                	li	a5,1
ffffffffc020a73a:	fcf51ae3          	bne	a0,a5,ffffffffc020a70e <sfs_load_inode+0x128>
ffffffffc020a73e:	fd042783          	lw	a5,-48(s0)
ffffffffc020a742:	2785                	addiw	a5,a5,1
ffffffffc020a744:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a748:	b7d9                	j	ffffffffc020a70e <sfs_load_inode+0x128>
ffffffffc020a74a:	5471                	li	s0,-4
ffffffffc020a74c:	8556                	mv	a0,s5
ffffffffc020a74e:	8f1f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a752:	854a                	mv	a0,s2
ffffffffc020a754:	78c000ef          	jal	ra,ffffffffc020aee0 <unlock_sfs_fs>
ffffffffc020a758:	b7c9                	j	ffffffffc020a71a <sfs_load_inode+0x134>
ffffffffc020a75a:	4789                	li	a5,2
ffffffffc020a75c:	08f69f63          	bne	a3,a5,ffffffffc020a7fa <sfs_load_inode+0x214>
ffffffffc020a760:	864a                	mv	a2,s2
ffffffffc020a762:	00005597          	auipc	a1,0x5
ffffffffc020a766:	a0e58593          	addi	a1,a1,-1522 # ffffffffc020f170 <sfs_node_dirops>
ffffffffc020a76a:	80efd0ef          	jal	ra,ffffffffc0207778 <inode_init>
ffffffffc020a76e:	058a2703          	lw	a4,88(s4)
ffffffffc020a772:	6785                	lui	a5,0x1
ffffffffc020a774:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a778:	f2f704e3          	beq	a4,a5,ffffffffc020a6a0 <sfs_load_inode+0xba>
ffffffffc020a77c:	00004697          	auipc	a3,0x4
ffffffffc020a780:	6bc68693          	addi	a3,a3,1724 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020a784:	00001617          	auipc	a2,0x1
ffffffffc020a788:	18460613          	addi	a2,a2,388 # ffffffffc020b908 <commands+0x210>
ffffffffc020a78c:	07700593          	li	a1,119
ffffffffc020a790:	00004517          	auipc	a0,0x4
ffffffffc020a794:	6e050513          	addi	a0,a0,1760 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a798:	d07f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a79c:	5471                	li	s0,-4
ffffffffc020a79e:	bf55                	j	ffffffffc020a752 <sfs_load_inode+0x16c>
ffffffffc020a7a0:	00005697          	auipc	a3,0x5
ffffffffc020a7a4:	95868693          	addi	a3,a3,-1704 # ffffffffc020f0f8 <dev_node_ops+0x848>
ffffffffc020a7a8:	00001617          	auipc	a2,0x1
ffffffffc020a7ac:	16060613          	addi	a2,a2,352 # ffffffffc020b908 <commands+0x210>
ffffffffc020a7b0:	0ad00593          	li	a1,173
ffffffffc020a7b4:	00004517          	auipc	a0,0x4
ffffffffc020a7b8:	6bc50513          	addi	a0,a0,1724 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a7bc:	ce3f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7c0:	8726                	mv	a4,s1
ffffffffc020a7c2:	00004617          	auipc	a2,0x4
ffffffffc020a7c6:	6de60613          	addi	a2,a2,1758 # ffffffffc020eea0 <dev_node_ops+0x5f0>
ffffffffc020a7ca:	05300593          	li	a1,83
ffffffffc020a7ce:	00004517          	auipc	a0,0x4
ffffffffc020a7d2:	6a250513          	addi	a0,a0,1698 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a7d6:	cc9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7da:	00004697          	auipc	a3,0x4
ffffffffc020a7de:	6fe68693          	addi	a3,a3,1790 # ffffffffc020eed8 <dev_node_ops+0x628>
ffffffffc020a7e2:	00001617          	auipc	a2,0x1
ffffffffc020a7e6:	12660613          	addi	a2,a2,294 # ffffffffc020b908 <commands+0x210>
ffffffffc020a7ea:	0a800593          	li	a1,168
ffffffffc020a7ee:	00004517          	auipc	a0,0x4
ffffffffc020a7f2:	68250513          	addi	a0,a0,1666 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a7f6:	ca9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7fa:	00004617          	auipc	a2,0x4
ffffffffc020a7fe:	68e60613          	addi	a2,a2,1678 # ffffffffc020ee88 <dev_node_ops+0x5d8>
ffffffffc020a802:	02e00593          	li	a1,46
ffffffffc020a806:	00004517          	auipc	a0,0x4
ffffffffc020a80a:	66a50513          	addi	a0,a0,1642 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a80e:	c91f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a812:	00004697          	auipc	a3,0x4
ffffffffc020a816:	62668693          	addi	a3,a3,1574 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020a81a:	00001617          	auipc	a2,0x1
ffffffffc020a81e:	0ee60613          	addi	a2,a2,238 # ffffffffc020b908 <commands+0x210>
ffffffffc020a822:	0b100593          	li	a1,177
ffffffffc020a826:	00004517          	auipc	a0,0x4
ffffffffc020a82a:	64a50513          	addi	a0,a0,1610 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a82e:	c71f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a832 <sfs_lookup>:
ffffffffc020a832:	7139                	addi	sp,sp,-64
ffffffffc020a834:	ec4e                	sd	s3,24(sp)
ffffffffc020a836:	06853983          	ld	s3,104(a0)
ffffffffc020a83a:	fc06                	sd	ra,56(sp)
ffffffffc020a83c:	f822                	sd	s0,48(sp)
ffffffffc020a83e:	f426                	sd	s1,40(sp)
ffffffffc020a840:	f04a                	sd	s2,32(sp)
ffffffffc020a842:	e852                	sd	s4,16(sp)
ffffffffc020a844:	0a098c63          	beqz	s3,ffffffffc020a8fc <sfs_lookup+0xca>
ffffffffc020a848:	0b09a783          	lw	a5,176(s3)
ffffffffc020a84c:	ebc5                	bnez	a5,ffffffffc020a8fc <sfs_lookup+0xca>
ffffffffc020a84e:	0005c783          	lbu	a5,0(a1)
ffffffffc020a852:	84ae                	mv	s1,a1
ffffffffc020a854:	c7c1                	beqz	a5,ffffffffc020a8dc <sfs_lookup+0xaa>
ffffffffc020a856:	02f00713          	li	a4,47
ffffffffc020a85a:	08e78163          	beq	a5,a4,ffffffffc020a8dc <sfs_lookup+0xaa>
ffffffffc020a85e:	842a                	mv	s0,a0
ffffffffc020a860:	8a32                	mv	s4,a2
ffffffffc020a862:	f79fc0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc020a866:	4c38                	lw	a4,88(s0)
ffffffffc020a868:	6785                	lui	a5,0x1
ffffffffc020a86a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a86e:	0af71763          	bne	a4,a5,ffffffffc020a91c <sfs_lookup+0xea>
ffffffffc020a872:	6018                	ld	a4,0(s0)
ffffffffc020a874:	4789                	li	a5,2
ffffffffc020a876:	00475703          	lhu	a4,4(a4)
ffffffffc020a87a:	04f71c63          	bne	a4,a5,ffffffffc020a8d2 <sfs_lookup+0xa0>
ffffffffc020a87e:	02040913          	addi	s2,s0,32
ffffffffc020a882:	854a                	mv	a0,s2
ffffffffc020a884:	ce1f90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a888:	8626                	mv	a2,s1
ffffffffc020a88a:	0054                	addi	a3,sp,4
ffffffffc020a88c:	85a2                	mv	a1,s0
ffffffffc020a88e:	854e                	mv	a0,s3
ffffffffc020a890:	a29ff0ef          	jal	ra,ffffffffc020a2b8 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a894:	84aa                	mv	s1,a0
ffffffffc020a896:	854a                	mv	a0,s2
ffffffffc020a898:	cc9f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a89c:	cc89                	beqz	s1,ffffffffc020a8b6 <sfs_lookup+0x84>
ffffffffc020a89e:	8522                	mv	a0,s0
ffffffffc020a8a0:	808fd0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020a8a4:	70e2                	ld	ra,56(sp)
ffffffffc020a8a6:	7442                	ld	s0,48(sp)
ffffffffc020a8a8:	7902                	ld	s2,32(sp)
ffffffffc020a8aa:	69e2                	ld	s3,24(sp)
ffffffffc020a8ac:	6a42                	ld	s4,16(sp)
ffffffffc020a8ae:	8526                	mv	a0,s1
ffffffffc020a8b0:	74a2                	ld	s1,40(sp)
ffffffffc020a8b2:	6121                	addi	sp,sp,64
ffffffffc020a8b4:	8082                	ret
ffffffffc020a8b6:	4612                	lw	a2,4(sp)
ffffffffc020a8b8:	002c                	addi	a1,sp,8
ffffffffc020a8ba:	854e                	mv	a0,s3
ffffffffc020a8bc:	d2bff0ef          	jal	ra,ffffffffc020a5e6 <sfs_load_inode>
ffffffffc020a8c0:	84aa                	mv	s1,a0
ffffffffc020a8c2:	8522                	mv	a0,s0
ffffffffc020a8c4:	fe5fc0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020a8c8:	fcf1                	bnez	s1,ffffffffc020a8a4 <sfs_lookup+0x72>
ffffffffc020a8ca:	67a2                	ld	a5,8(sp)
ffffffffc020a8cc:	00fa3023          	sd	a5,0(s4)
ffffffffc020a8d0:	bfd1                	j	ffffffffc020a8a4 <sfs_lookup+0x72>
ffffffffc020a8d2:	8522                	mv	a0,s0
ffffffffc020a8d4:	fd5fc0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020a8d8:	54b9                	li	s1,-18
ffffffffc020a8da:	b7e9                	j	ffffffffc020a8a4 <sfs_lookup+0x72>
ffffffffc020a8dc:	00005697          	auipc	a3,0x5
ffffffffc020a8e0:	83468693          	addi	a3,a3,-1996 # ffffffffc020f110 <dev_node_ops+0x860>
ffffffffc020a8e4:	00001617          	auipc	a2,0x1
ffffffffc020a8e8:	02460613          	addi	a2,a2,36 # ffffffffc020b908 <commands+0x210>
ffffffffc020a8ec:	3dd00593          	li	a1,989
ffffffffc020a8f0:	00004517          	auipc	a0,0x4
ffffffffc020a8f4:	58050513          	addi	a0,a0,1408 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a8f8:	ba7f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a8fc:	00004697          	auipc	a3,0x4
ffffffffc020a900:	39468693          	addi	a3,a3,916 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020a904:	00001617          	auipc	a2,0x1
ffffffffc020a908:	00460613          	addi	a2,a2,4 # ffffffffc020b908 <commands+0x210>
ffffffffc020a90c:	3dc00593          	li	a1,988
ffffffffc020a910:	00004517          	auipc	a0,0x4
ffffffffc020a914:	56050513          	addi	a0,a0,1376 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a918:	b87f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a91c:	00004697          	auipc	a3,0x4
ffffffffc020a920:	51c68693          	addi	a3,a3,1308 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020a924:	00001617          	auipc	a2,0x1
ffffffffc020a928:	fe460613          	addi	a2,a2,-28 # ffffffffc020b908 <commands+0x210>
ffffffffc020a92c:	3df00593          	li	a1,991
ffffffffc020a930:	00004517          	auipc	a0,0x4
ffffffffc020a934:	54050513          	addi	a0,a0,1344 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020a938:	b67f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a93c <sfs_namefile>:
ffffffffc020a93c:	6d98                	ld	a4,24(a1)
ffffffffc020a93e:	7175                	addi	sp,sp,-144
ffffffffc020a940:	e506                	sd	ra,136(sp)
ffffffffc020a942:	e122                	sd	s0,128(sp)
ffffffffc020a944:	fca6                	sd	s1,120(sp)
ffffffffc020a946:	f8ca                	sd	s2,112(sp)
ffffffffc020a948:	f4ce                	sd	s3,104(sp)
ffffffffc020a94a:	f0d2                	sd	s4,96(sp)
ffffffffc020a94c:	ecd6                	sd	s5,88(sp)
ffffffffc020a94e:	e8da                	sd	s6,80(sp)
ffffffffc020a950:	e4de                	sd	s7,72(sp)
ffffffffc020a952:	e0e2                	sd	s8,64(sp)
ffffffffc020a954:	fc66                	sd	s9,56(sp)
ffffffffc020a956:	f86a                	sd	s10,48(sp)
ffffffffc020a958:	f46e                	sd	s11,40(sp)
ffffffffc020a95a:	e42e                	sd	a1,8(sp)
ffffffffc020a95c:	4789                	li	a5,2
ffffffffc020a95e:	1ae7f363          	bgeu	a5,a4,ffffffffc020ab04 <sfs_namefile+0x1c8>
ffffffffc020a962:	89aa                	mv	s3,a0
ffffffffc020a964:	10400513          	li	a0,260
ffffffffc020a968:	e26f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a96c:	842a                	mv	s0,a0
ffffffffc020a96e:	18050b63          	beqz	a0,ffffffffc020ab04 <sfs_namefile+0x1c8>
ffffffffc020a972:	0689b483          	ld	s1,104(s3)
ffffffffc020a976:	1e048963          	beqz	s1,ffffffffc020ab68 <sfs_namefile+0x22c>
ffffffffc020a97a:	0b04a783          	lw	a5,176(s1)
ffffffffc020a97e:	1e079563          	bnez	a5,ffffffffc020ab68 <sfs_namefile+0x22c>
ffffffffc020a982:	0589ac83          	lw	s9,88(s3)
ffffffffc020a986:	6785                	lui	a5,0x1
ffffffffc020a988:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a98c:	1afc9e63          	bne	s9,a5,ffffffffc020ab48 <sfs_namefile+0x20c>
ffffffffc020a990:	6722                	ld	a4,8(sp)
ffffffffc020a992:	854e                	mv	a0,s3
ffffffffc020a994:	8ace                	mv	s5,s3
ffffffffc020a996:	6f1c                	ld	a5,24(a4)
ffffffffc020a998:	00073b03          	ld	s6,0(a4)
ffffffffc020a99c:	02098a13          	addi	s4,s3,32
ffffffffc020a9a0:	ffe78b93          	addi	s7,a5,-2
ffffffffc020a9a4:	9b3e                	add	s6,s6,a5
ffffffffc020a9a6:	00004d17          	auipc	s10,0x4
ffffffffc020a9aa:	78ad0d13          	addi	s10,s10,1930 # ffffffffc020f130 <dev_node_ops+0x880>
ffffffffc020a9ae:	e2dfc0ef          	jal	ra,ffffffffc02077da <inode_ref_inc>
ffffffffc020a9b2:	00440c13          	addi	s8,s0,4
ffffffffc020a9b6:	e066                	sd	s9,0(sp)
ffffffffc020a9b8:	8552                	mv	a0,s4
ffffffffc020a9ba:	babf90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a9be:	0854                	addi	a3,sp,20
ffffffffc020a9c0:	866a                	mv	a2,s10
ffffffffc020a9c2:	85d6                	mv	a1,s5
ffffffffc020a9c4:	8526                	mv	a0,s1
ffffffffc020a9c6:	8f3ff0ef          	jal	ra,ffffffffc020a2b8 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a9ca:	8daa                	mv	s11,a0
ffffffffc020a9cc:	8552                	mv	a0,s4
ffffffffc020a9ce:	b93f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a9d2:	020d8863          	beqz	s11,ffffffffc020aa02 <sfs_namefile+0xc6>
ffffffffc020a9d6:	854e                	mv	a0,s3
ffffffffc020a9d8:	ed1fc0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020a9dc:	8522                	mv	a0,s0
ffffffffc020a9de:	e60f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a9e2:	60aa                	ld	ra,136(sp)
ffffffffc020a9e4:	640a                	ld	s0,128(sp)
ffffffffc020a9e6:	74e6                	ld	s1,120(sp)
ffffffffc020a9e8:	7946                	ld	s2,112(sp)
ffffffffc020a9ea:	79a6                	ld	s3,104(sp)
ffffffffc020a9ec:	7a06                	ld	s4,96(sp)
ffffffffc020a9ee:	6ae6                	ld	s5,88(sp)
ffffffffc020a9f0:	6b46                	ld	s6,80(sp)
ffffffffc020a9f2:	6ba6                	ld	s7,72(sp)
ffffffffc020a9f4:	6c06                	ld	s8,64(sp)
ffffffffc020a9f6:	7ce2                	ld	s9,56(sp)
ffffffffc020a9f8:	7d42                	ld	s10,48(sp)
ffffffffc020a9fa:	856e                	mv	a0,s11
ffffffffc020a9fc:	7da2                	ld	s11,40(sp)
ffffffffc020a9fe:	6149                	addi	sp,sp,144
ffffffffc020aa00:	8082                	ret
ffffffffc020aa02:	4652                	lw	a2,20(sp)
ffffffffc020aa04:	082c                	addi	a1,sp,24
ffffffffc020aa06:	8526                	mv	a0,s1
ffffffffc020aa08:	bdfff0ef          	jal	ra,ffffffffc020a5e6 <sfs_load_inode>
ffffffffc020aa0c:	8daa                	mv	s11,a0
ffffffffc020aa0e:	f561                	bnez	a0,ffffffffc020a9d6 <sfs_namefile+0x9a>
ffffffffc020aa10:	854e                	mv	a0,s3
ffffffffc020aa12:	008aa903          	lw	s2,8(s5)
ffffffffc020aa16:	e93fc0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020aa1a:	6ce2                	ld	s9,24(sp)
ffffffffc020aa1c:	0b3c8463          	beq	s9,s3,ffffffffc020aac4 <sfs_namefile+0x188>
ffffffffc020aa20:	100c8463          	beqz	s9,ffffffffc020ab28 <sfs_namefile+0x1ec>
ffffffffc020aa24:	058ca703          	lw	a4,88(s9)
ffffffffc020aa28:	6782                	ld	a5,0(sp)
ffffffffc020aa2a:	0ef71f63          	bne	a4,a5,ffffffffc020ab28 <sfs_namefile+0x1ec>
ffffffffc020aa2e:	008ca703          	lw	a4,8(s9)
ffffffffc020aa32:	8ae6                	mv	s5,s9
ffffffffc020aa34:	0d270a63          	beq	a4,s2,ffffffffc020ab08 <sfs_namefile+0x1cc>
ffffffffc020aa38:	000cb703          	ld	a4,0(s9)
ffffffffc020aa3c:	4789                	li	a5,2
ffffffffc020aa3e:	00475703          	lhu	a4,4(a4)
ffffffffc020aa42:	0cf71363          	bne	a4,a5,ffffffffc020ab08 <sfs_namefile+0x1cc>
ffffffffc020aa46:	020c8a13          	addi	s4,s9,32
ffffffffc020aa4a:	8552                	mv	a0,s4
ffffffffc020aa4c:	b19f90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020aa50:	000cb703          	ld	a4,0(s9)
ffffffffc020aa54:	00872983          	lw	s3,8(a4)
ffffffffc020aa58:	01304963          	bgtz	s3,ffffffffc020aa6a <sfs_namefile+0x12e>
ffffffffc020aa5c:	a899                	j	ffffffffc020aab2 <sfs_namefile+0x176>
ffffffffc020aa5e:	4018                	lw	a4,0(s0)
ffffffffc020aa60:	01270e63          	beq	a4,s2,ffffffffc020aa7c <sfs_namefile+0x140>
ffffffffc020aa64:	2d85                	addiw	s11,s11,1
ffffffffc020aa66:	05b98663          	beq	s3,s11,ffffffffc020aab2 <sfs_namefile+0x176>
ffffffffc020aa6a:	86a2                	mv	a3,s0
ffffffffc020aa6c:	866e                	mv	a2,s11
ffffffffc020aa6e:	85e6                	mv	a1,s9
ffffffffc020aa70:	8526                	mv	a0,s1
ffffffffc020aa72:	e48ff0ef          	jal	ra,ffffffffc020a0ba <sfs_dirent_read_nolock>
ffffffffc020aa76:	872a                	mv	a4,a0
ffffffffc020aa78:	d17d                	beqz	a0,ffffffffc020aa5e <sfs_namefile+0x122>
ffffffffc020aa7a:	a82d                	j	ffffffffc020aab4 <sfs_namefile+0x178>
ffffffffc020aa7c:	8552                	mv	a0,s4
ffffffffc020aa7e:	ae3f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020aa82:	8562                	mv	a0,s8
ffffffffc020aa84:	0ff000ef          	jal	ra,ffffffffc020b382 <strlen>
ffffffffc020aa88:	00150793          	addi	a5,a0,1
ffffffffc020aa8c:	862a                	mv	a2,a0
ffffffffc020aa8e:	06fbe863          	bltu	s7,a5,ffffffffc020aafe <sfs_namefile+0x1c2>
ffffffffc020aa92:	fff64913          	not	s2,a2
ffffffffc020aa96:	995a                	add	s2,s2,s6
ffffffffc020aa98:	85e2                	mv	a1,s8
ffffffffc020aa9a:	854a                	mv	a0,s2
ffffffffc020aa9c:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020aaa0:	1d7000ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020aaa4:	02f00793          	li	a5,47
ffffffffc020aaa8:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020aaac:	89e6                	mv	s3,s9
ffffffffc020aaae:	8b4a                	mv	s6,s2
ffffffffc020aab0:	b721                	j	ffffffffc020a9b8 <sfs_namefile+0x7c>
ffffffffc020aab2:	5741                	li	a4,-16
ffffffffc020aab4:	8552                	mv	a0,s4
ffffffffc020aab6:	e03a                	sd	a4,0(sp)
ffffffffc020aab8:	aa9f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020aabc:	6702                	ld	a4,0(sp)
ffffffffc020aabe:	89e6                	mv	s3,s9
ffffffffc020aac0:	8dba                	mv	s11,a4
ffffffffc020aac2:	bf11                	j	ffffffffc020a9d6 <sfs_namefile+0x9a>
ffffffffc020aac4:	854e                	mv	a0,s3
ffffffffc020aac6:	de3fc0ef          	jal	ra,ffffffffc02078a8 <inode_ref_dec>
ffffffffc020aaca:	64a2                	ld	s1,8(sp)
ffffffffc020aacc:	85da                	mv	a1,s6
ffffffffc020aace:	6c98                	ld	a4,24(s1)
ffffffffc020aad0:	6088                	ld	a0,0(s1)
ffffffffc020aad2:	1779                	addi	a4,a4,-2
ffffffffc020aad4:	41770bb3          	sub	s7,a4,s7
ffffffffc020aad8:	865e                	mv	a2,s7
ffffffffc020aada:	0505                	addi	a0,a0,1
ffffffffc020aadc:	15b000ef          	jal	ra,ffffffffc020b436 <memmove>
ffffffffc020aae0:	02f00713          	li	a4,47
ffffffffc020aae4:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020aae8:	955e                	add	a0,a0,s7
ffffffffc020aaea:	00050023          	sb	zero,0(a0)
ffffffffc020aaee:	85de                	mv	a1,s7
ffffffffc020aaf0:	8526                	mv	a0,s1
ffffffffc020aaf2:	967fa0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020aaf6:	8522                	mv	a0,s0
ffffffffc020aaf8:	d46f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020aafc:	b5dd                	j	ffffffffc020a9e2 <sfs_namefile+0xa6>
ffffffffc020aafe:	89e6                	mv	s3,s9
ffffffffc020ab00:	5df1                	li	s11,-4
ffffffffc020ab02:	bdd1                	j	ffffffffc020a9d6 <sfs_namefile+0x9a>
ffffffffc020ab04:	5df1                	li	s11,-4
ffffffffc020ab06:	bdf1                	j	ffffffffc020a9e2 <sfs_namefile+0xa6>
ffffffffc020ab08:	00004697          	auipc	a3,0x4
ffffffffc020ab0c:	63068693          	addi	a3,a3,1584 # ffffffffc020f138 <dev_node_ops+0x888>
ffffffffc020ab10:	00001617          	auipc	a2,0x1
ffffffffc020ab14:	df860613          	addi	a2,a2,-520 # ffffffffc020b908 <commands+0x210>
ffffffffc020ab18:	2fb00593          	li	a1,763
ffffffffc020ab1c:	00004517          	auipc	a0,0x4
ffffffffc020ab20:	35450513          	addi	a0,a0,852 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020ab24:	97bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab28:	00004697          	auipc	a3,0x4
ffffffffc020ab2c:	31068693          	addi	a3,a3,784 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020ab30:	00001617          	auipc	a2,0x1
ffffffffc020ab34:	dd860613          	addi	a2,a2,-552 # ffffffffc020b908 <commands+0x210>
ffffffffc020ab38:	2fa00593          	li	a1,762
ffffffffc020ab3c:	00004517          	auipc	a0,0x4
ffffffffc020ab40:	33450513          	addi	a0,a0,820 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020ab44:	95bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab48:	00004697          	auipc	a3,0x4
ffffffffc020ab4c:	2f068693          	addi	a3,a3,752 # ffffffffc020ee38 <dev_node_ops+0x588>
ffffffffc020ab50:	00001617          	auipc	a2,0x1
ffffffffc020ab54:	db860613          	addi	a2,a2,-584 # ffffffffc020b908 <commands+0x210>
ffffffffc020ab58:	2e700593          	li	a1,743
ffffffffc020ab5c:	00004517          	auipc	a0,0x4
ffffffffc020ab60:	31450513          	addi	a0,a0,788 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020ab64:	93bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab68:	00004697          	auipc	a3,0x4
ffffffffc020ab6c:	12868693          	addi	a3,a3,296 # ffffffffc020ec90 <dev_node_ops+0x3e0>
ffffffffc020ab70:	00001617          	auipc	a2,0x1
ffffffffc020ab74:	d9860613          	addi	a2,a2,-616 # ffffffffc020b908 <commands+0x210>
ffffffffc020ab78:	2e600593          	li	a1,742
ffffffffc020ab7c:	00004517          	auipc	a0,0x4
ffffffffc020ab80:	2f450513          	addi	a0,a0,756 # ffffffffc020ee70 <dev_node_ops+0x5c0>
ffffffffc020ab84:	91bf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ab88 <sfs_rwblock_nolock>:
ffffffffc020ab88:	7139                	addi	sp,sp,-64
ffffffffc020ab8a:	f822                	sd	s0,48(sp)
ffffffffc020ab8c:	f426                	sd	s1,40(sp)
ffffffffc020ab8e:	fc06                	sd	ra,56(sp)
ffffffffc020ab90:	842a                	mv	s0,a0
ffffffffc020ab92:	84b6                	mv	s1,a3
ffffffffc020ab94:	e211                	bnez	a2,ffffffffc020ab98 <sfs_rwblock_nolock+0x10>
ffffffffc020ab96:	e715                	bnez	a4,ffffffffc020abc2 <sfs_rwblock_nolock+0x3a>
ffffffffc020ab98:	405c                	lw	a5,4(s0)
ffffffffc020ab9a:	02f67463          	bgeu	a2,a5,ffffffffc020abc2 <sfs_rwblock_nolock+0x3a>
ffffffffc020ab9e:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020aba2:	1682                	slli	a3,a3,0x20
ffffffffc020aba4:	6605                	lui	a2,0x1
ffffffffc020aba6:	9281                	srli	a3,a3,0x20
ffffffffc020aba8:	850a                	mv	a0,sp
ffffffffc020abaa:	839fa0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc020abae:	85aa                	mv	a1,a0
ffffffffc020abb0:	7808                	ld	a0,48(s0)
ffffffffc020abb2:	8626                	mv	a2,s1
ffffffffc020abb4:	7118                	ld	a4,32(a0)
ffffffffc020abb6:	9702                	jalr	a4
ffffffffc020abb8:	70e2                	ld	ra,56(sp)
ffffffffc020abba:	7442                	ld	s0,48(sp)
ffffffffc020abbc:	74a2                	ld	s1,40(sp)
ffffffffc020abbe:	6121                	addi	sp,sp,64
ffffffffc020abc0:	8082                	ret
ffffffffc020abc2:	00004697          	auipc	a3,0x4
ffffffffc020abc6:	6ae68693          	addi	a3,a3,1710 # ffffffffc020f270 <sfs_node_fileops+0x80>
ffffffffc020abca:	00001617          	auipc	a2,0x1
ffffffffc020abce:	d3e60613          	addi	a2,a2,-706 # ffffffffc020b908 <commands+0x210>
ffffffffc020abd2:	45d5                	li	a1,21
ffffffffc020abd4:	00004517          	auipc	a0,0x4
ffffffffc020abd8:	6d450513          	addi	a0,a0,1748 # ffffffffc020f2a8 <sfs_node_fileops+0xb8>
ffffffffc020abdc:	8c3f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020abe0 <sfs_rblock>:
ffffffffc020abe0:	7139                	addi	sp,sp,-64
ffffffffc020abe2:	ec4e                	sd	s3,24(sp)
ffffffffc020abe4:	89b6                	mv	s3,a3
ffffffffc020abe6:	f822                	sd	s0,48(sp)
ffffffffc020abe8:	f04a                	sd	s2,32(sp)
ffffffffc020abea:	e852                	sd	s4,16(sp)
ffffffffc020abec:	fc06                	sd	ra,56(sp)
ffffffffc020abee:	f426                	sd	s1,40(sp)
ffffffffc020abf0:	e456                	sd	s5,8(sp)
ffffffffc020abf2:	8a2a                	mv	s4,a0
ffffffffc020abf4:	892e                	mv	s2,a1
ffffffffc020abf6:	8432                	mv	s0,a2
ffffffffc020abf8:	2e0000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020abfc:	04098063          	beqz	s3,ffffffffc020ac3c <sfs_rblock+0x5c>
ffffffffc020ac00:	013409bb          	addw	s3,s0,s3
ffffffffc020ac04:	6a85                	lui	s5,0x1
ffffffffc020ac06:	a021                	j	ffffffffc020ac0e <sfs_rblock+0x2e>
ffffffffc020ac08:	9956                	add	s2,s2,s5
ffffffffc020ac0a:	02898963          	beq	s3,s0,ffffffffc020ac3c <sfs_rblock+0x5c>
ffffffffc020ac0e:	8622                	mv	a2,s0
ffffffffc020ac10:	85ca                	mv	a1,s2
ffffffffc020ac12:	4705                	li	a4,1
ffffffffc020ac14:	4681                	li	a3,0
ffffffffc020ac16:	8552                	mv	a0,s4
ffffffffc020ac18:	f71ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ac1c:	84aa                	mv	s1,a0
ffffffffc020ac1e:	2405                	addiw	s0,s0,1
ffffffffc020ac20:	d565                	beqz	a0,ffffffffc020ac08 <sfs_rblock+0x28>
ffffffffc020ac22:	8552                	mv	a0,s4
ffffffffc020ac24:	2c4000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020ac28:	70e2                	ld	ra,56(sp)
ffffffffc020ac2a:	7442                	ld	s0,48(sp)
ffffffffc020ac2c:	7902                	ld	s2,32(sp)
ffffffffc020ac2e:	69e2                	ld	s3,24(sp)
ffffffffc020ac30:	6a42                	ld	s4,16(sp)
ffffffffc020ac32:	6aa2                	ld	s5,8(sp)
ffffffffc020ac34:	8526                	mv	a0,s1
ffffffffc020ac36:	74a2                	ld	s1,40(sp)
ffffffffc020ac38:	6121                	addi	sp,sp,64
ffffffffc020ac3a:	8082                	ret
ffffffffc020ac3c:	4481                	li	s1,0
ffffffffc020ac3e:	b7d5                	j	ffffffffc020ac22 <sfs_rblock+0x42>

ffffffffc020ac40 <sfs_wblock>:
ffffffffc020ac40:	7139                	addi	sp,sp,-64
ffffffffc020ac42:	ec4e                	sd	s3,24(sp)
ffffffffc020ac44:	89b6                	mv	s3,a3
ffffffffc020ac46:	f822                	sd	s0,48(sp)
ffffffffc020ac48:	f04a                	sd	s2,32(sp)
ffffffffc020ac4a:	e852                	sd	s4,16(sp)
ffffffffc020ac4c:	fc06                	sd	ra,56(sp)
ffffffffc020ac4e:	f426                	sd	s1,40(sp)
ffffffffc020ac50:	e456                	sd	s5,8(sp)
ffffffffc020ac52:	8a2a                	mv	s4,a0
ffffffffc020ac54:	892e                	mv	s2,a1
ffffffffc020ac56:	8432                	mv	s0,a2
ffffffffc020ac58:	280000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020ac5c:	04098063          	beqz	s3,ffffffffc020ac9c <sfs_wblock+0x5c>
ffffffffc020ac60:	013409bb          	addw	s3,s0,s3
ffffffffc020ac64:	6a85                	lui	s5,0x1
ffffffffc020ac66:	a021                	j	ffffffffc020ac6e <sfs_wblock+0x2e>
ffffffffc020ac68:	9956                	add	s2,s2,s5
ffffffffc020ac6a:	02898963          	beq	s3,s0,ffffffffc020ac9c <sfs_wblock+0x5c>
ffffffffc020ac6e:	8622                	mv	a2,s0
ffffffffc020ac70:	85ca                	mv	a1,s2
ffffffffc020ac72:	4705                	li	a4,1
ffffffffc020ac74:	4685                	li	a3,1
ffffffffc020ac76:	8552                	mv	a0,s4
ffffffffc020ac78:	f11ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ac7c:	84aa                	mv	s1,a0
ffffffffc020ac7e:	2405                	addiw	s0,s0,1
ffffffffc020ac80:	d565                	beqz	a0,ffffffffc020ac68 <sfs_wblock+0x28>
ffffffffc020ac82:	8552                	mv	a0,s4
ffffffffc020ac84:	264000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020ac88:	70e2                	ld	ra,56(sp)
ffffffffc020ac8a:	7442                	ld	s0,48(sp)
ffffffffc020ac8c:	7902                	ld	s2,32(sp)
ffffffffc020ac8e:	69e2                	ld	s3,24(sp)
ffffffffc020ac90:	6a42                	ld	s4,16(sp)
ffffffffc020ac92:	6aa2                	ld	s5,8(sp)
ffffffffc020ac94:	8526                	mv	a0,s1
ffffffffc020ac96:	74a2                	ld	s1,40(sp)
ffffffffc020ac98:	6121                	addi	sp,sp,64
ffffffffc020ac9a:	8082                	ret
ffffffffc020ac9c:	4481                	li	s1,0
ffffffffc020ac9e:	b7d5                	j	ffffffffc020ac82 <sfs_wblock+0x42>

ffffffffc020aca0 <sfs_rbuf>:
ffffffffc020aca0:	7179                	addi	sp,sp,-48
ffffffffc020aca2:	f406                	sd	ra,40(sp)
ffffffffc020aca4:	f022                	sd	s0,32(sp)
ffffffffc020aca6:	ec26                	sd	s1,24(sp)
ffffffffc020aca8:	e84a                	sd	s2,16(sp)
ffffffffc020acaa:	e44e                	sd	s3,8(sp)
ffffffffc020acac:	e052                	sd	s4,0(sp)
ffffffffc020acae:	6785                	lui	a5,0x1
ffffffffc020acb0:	04f77863          	bgeu	a4,a5,ffffffffc020ad00 <sfs_rbuf+0x60>
ffffffffc020acb4:	84ba                	mv	s1,a4
ffffffffc020acb6:	9732                	add	a4,a4,a2
ffffffffc020acb8:	89b2                	mv	s3,a2
ffffffffc020acba:	04e7e363          	bltu	a5,a4,ffffffffc020ad00 <sfs_rbuf+0x60>
ffffffffc020acbe:	8936                	mv	s2,a3
ffffffffc020acc0:	842a                	mv	s0,a0
ffffffffc020acc2:	8a2e                	mv	s4,a1
ffffffffc020acc4:	214000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020acc8:	642c                	ld	a1,72(s0)
ffffffffc020acca:	864a                	mv	a2,s2
ffffffffc020accc:	4705                	li	a4,1
ffffffffc020acce:	4681                	li	a3,0
ffffffffc020acd0:	8522                	mv	a0,s0
ffffffffc020acd2:	eb7ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020acd6:	892a                	mv	s2,a0
ffffffffc020acd8:	cd09                	beqz	a0,ffffffffc020acf2 <sfs_rbuf+0x52>
ffffffffc020acda:	8522                	mv	a0,s0
ffffffffc020acdc:	20c000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020ace0:	70a2                	ld	ra,40(sp)
ffffffffc020ace2:	7402                	ld	s0,32(sp)
ffffffffc020ace4:	64e2                	ld	s1,24(sp)
ffffffffc020ace6:	69a2                	ld	s3,8(sp)
ffffffffc020ace8:	6a02                	ld	s4,0(sp)
ffffffffc020acea:	854a                	mv	a0,s2
ffffffffc020acec:	6942                	ld	s2,16(sp)
ffffffffc020acee:	6145                	addi	sp,sp,48
ffffffffc020acf0:	8082                	ret
ffffffffc020acf2:	642c                	ld	a1,72(s0)
ffffffffc020acf4:	864e                	mv	a2,s3
ffffffffc020acf6:	8552                	mv	a0,s4
ffffffffc020acf8:	95a6                	add	a1,a1,s1
ffffffffc020acfa:	77c000ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020acfe:	bff1                	j	ffffffffc020acda <sfs_rbuf+0x3a>
ffffffffc020ad00:	00004697          	auipc	a3,0x4
ffffffffc020ad04:	5c068693          	addi	a3,a3,1472 # ffffffffc020f2c0 <sfs_node_fileops+0xd0>
ffffffffc020ad08:	00001617          	auipc	a2,0x1
ffffffffc020ad0c:	c0060613          	addi	a2,a2,-1024 # ffffffffc020b908 <commands+0x210>
ffffffffc020ad10:	05500593          	li	a1,85
ffffffffc020ad14:	00004517          	auipc	a0,0x4
ffffffffc020ad18:	59450513          	addi	a0,a0,1428 # ffffffffc020f2a8 <sfs_node_fileops+0xb8>
ffffffffc020ad1c:	f82f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ad20 <sfs_wbuf>:
ffffffffc020ad20:	7139                	addi	sp,sp,-64
ffffffffc020ad22:	fc06                	sd	ra,56(sp)
ffffffffc020ad24:	f822                	sd	s0,48(sp)
ffffffffc020ad26:	f426                	sd	s1,40(sp)
ffffffffc020ad28:	f04a                	sd	s2,32(sp)
ffffffffc020ad2a:	ec4e                	sd	s3,24(sp)
ffffffffc020ad2c:	e852                	sd	s4,16(sp)
ffffffffc020ad2e:	e456                	sd	s5,8(sp)
ffffffffc020ad30:	6785                	lui	a5,0x1
ffffffffc020ad32:	06f77163          	bgeu	a4,a5,ffffffffc020ad94 <sfs_wbuf+0x74>
ffffffffc020ad36:	893a                	mv	s2,a4
ffffffffc020ad38:	9732                	add	a4,a4,a2
ffffffffc020ad3a:	8a32                	mv	s4,a2
ffffffffc020ad3c:	04e7ec63          	bltu	a5,a4,ffffffffc020ad94 <sfs_wbuf+0x74>
ffffffffc020ad40:	842a                	mv	s0,a0
ffffffffc020ad42:	89b6                	mv	s3,a3
ffffffffc020ad44:	8aae                	mv	s5,a1
ffffffffc020ad46:	192000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020ad4a:	642c                	ld	a1,72(s0)
ffffffffc020ad4c:	4705                	li	a4,1
ffffffffc020ad4e:	4681                	li	a3,0
ffffffffc020ad50:	864e                	mv	a2,s3
ffffffffc020ad52:	8522                	mv	a0,s0
ffffffffc020ad54:	e35ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ad58:	84aa                	mv	s1,a0
ffffffffc020ad5a:	cd11                	beqz	a0,ffffffffc020ad76 <sfs_wbuf+0x56>
ffffffffc020ad5c:	8522                	mv	a0,s0
ffffffffc020ad5e:	18a000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020ad62:	70e2                	ld	ra,56(sp)
ffffffffc020ad64:	7442                	ld	s0,48(sp)
ffffffffc020ad66:	7902                	ld	s2,32(sp)
ffffffffc020ad68:	69e2                	ld	s3,24(sp)
ffffffffc020ad6a:	6a42                	ld	s4,16(sp)
ffffffffc020ad6c:	6aa2                	ld	s5,8(sp)
ffffffffc020ad6e:	8526                	mv	a0,s1
ffffffffc020ad70:	74a2                	ld	s1,40(sp)
ffffffffc020ad72:	6121                	addi	sp,sp,64
ffffffffc020ad74:	8082                	ret
ffffffffc020ad76:	6428                	ld	a0,72(s0)
ffffffffc020ad78:	8652                	mv	a2,s4
ffffffffc020ad7a:	85d6                	mv	a1,s5
ffffffffc020ad7c:	954a                	add	a0,a0,s2
ffffffffc020ad7e:	6f8000ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020ad82:	642c                	ld	a1,72(s0)
ffffffffc020ad84:	4705                	li	a4,1
ffffffffc020ad86:	4685                	li	a3,1
ffffffffc020ad88:	864e                	mv	a2,s3
ffffffffc020ad8a:	8522                	mv	a0,s0
ffffffffc020ad8c:	dfdff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ad90:	84aa                	mv	s1,a0
ffffffffc020ad92:	b7e9                	j	ffffffffc020ad5c <sfs_wbuf+0x3c>
ffffffffc020ad94:	00004697          	auipc	a3,0x4
ffffffffc020ad98:	52c68693          	addi	a3,a3,1324 # ffffffffc020f2c0 <sfs_node_fileops+0xd0>
ffffffffc020ad9c:	00001617          	auipc	a2,0x1
ffffffffc020ada0:	b6c60613          	addi	a2,a2,-1172 # ffffffffc020b908 <commands+0x210>
ffffffffc020ada4:	06b00593          	li	a1,107
ffffffffc020ada8:	00004517          	auipc	a0,0x4
ffffffffc020adac:	50050513          	addi	a0,a0,1280 # ffffffffc020f2a8 <sfs_node_fileops+0xb8>
ffffffffc020adb0:	eeef50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020adb4 <sfs_sync_super>:
ffffffffc020adb4:	1101                	addi	sp,sp,-32
ffffffffc020adb6:	ec06                	sd	ra,24(sp)
ffffffffc020adb8:	e822                	sd	s0,16(sp)
ffffffffc020adba:	e426                	sd	s1,8(sp)
ffffffffc020adbc:	842a                	mv	s0,a0
ffffffffc020adbe:	11a000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020adc2:	6428                	ld	a0,72(s0)
ffffffffc020adc4:	6605                	lui	a2,0x1
ffffffffc020adc6:	4581                	li	a1,0
ffffffffc020adc8:	65c000ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc020adcc:	6428                	ld	a0,72(s0)
ffffffffc020adce:	85a2                	mv	a1,s0
ffffffffc020add0:	02c00613          	li	a2,44
ffffffffc020add4:	6a2000ef          	jal	ra,ffffffffc020b476 <memcpy>
ffffffffc020add8:	642c                	ld	a1,72(s0)
ffffffffc020adda:	4701                	li	a4,0
ffffffffc020addc:	4685                	li	a3,1
ffffffffc020adde:	4601                	li	a2,0
ffffffffc020ade0:	8522                	mv	a0,s0
ffffffffc020ade2:	da7ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ade6:	84aa                	mv	s1,a0
ffffffffc020ade8:	8522                	mv	a0,s0
ffffffffc020adea:	0fe000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020adee:	60e2                	ld	ra,24(sp)
ffffffffc020adf0:	6442                	ld	s0,16(sp)
ffffffffc020adf2:	8526                	mv	a0,s1
ffffffffc020adf4:	64a2                	ld	s1,8(sp)
ffffffffc020adf6:	6105                	addi	sp,sp,32
ffffffffc020adf8:	8082                	ret

ffffffffc020adfa <sfs_sync_freemap>:
ffffffffc020adfa:	7139                	addi	sp,sp,-64
ffffffffc020adfc:	ec4e                	sd	s3,24(sp)
ffffffffc020adfe:	e852                	sd	s4,16(sp)
ffffffffc020ae00:	00456983          	lwu	s3,4(a0)
ffffffffc020ae04:	8a2a                	mv	s4,a0
ffffffffc020ae06:	7d08                	ld	a0,56(a0)
ffffffffc020ae08:	67a1                	lui	a5,0x8
ffffffffc020ae0a:	17fd                	addi	a5,a5,-1
ffffffffc020ae0c:	4581                	li	a1,0
ffffffffc020ae0e:	f822                	sd	s0,48(sp)
ffffffffc020ae10:	fc06                	sd	ra,56(sp)
ffffffffc020ae12:	f426                	sd	s1,40(sp)
ffffffffc020ae14:	f04a                	sd	s2,32(sp)
ffffffffc020ae16:	e456                	sd	s5,8(sp)
ffffffffc020ae18:	99be                	add	s3,s3,a5
ffffffffc020ae1a:	a1cfe0ef          	jal	ra,ffffffffc0209036 <bitmap_getdata>
ffffffffc020ae1e:	00f9d993          	srli	s3,s3,0xf
ffffffffc020ae22:	842a                	mv	s0,a0
ffffffffc020ae24:	8552                	mv	a0,s4
ffffffffc020ae26:	0b2000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020ae2a:	04098163          	beqz	s3,ffffffffc020ae6c <sfs_sync_freemap+0x72>
ffffffffc020ae2e:	09b2                	slli	s3,s3,0xc
ffffffffc020ae30:	99a2                	add	s3,s3,s0
ffffffffc020ae32:	4909                	li	s2,2
ffffffffc020ae34:	6a85                	lui	s5,0x1
ffffffffc020ae36:	a021                	j	ffffffffc020ae3e <sfs_sync_freemap+0x44>
ffffffffc020ae38:	2905                	addiw	s2,s2,1
ffffffffc020ae3a:	02898963          	beq	s3,s0,ffffffffc020ae6c <sfs_sync_freemap+0x72>
ffffffffc020ae3e:	85a2                	mv	a1,s0
ffffffffc020ae40:	864a                	mv	a2,s2
ffffffffc020ae42:	4705                	li	a4,1
ffffffffc020ae44:	4685                	li	a3,1
ffffffffc020ae46:	8552                	mv	a0,s4
ffffffffc020ae48:	d41ff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020ae4c:	84aa                	mv	s1,a0
ffffffffc020ae4e:	9456                	add	s0,s0,s5
ffffffffc020ae50:	d565                	beqz	a0,ffffffffc020ae38 <sfs_sync_freemap+0x3e>
ffffffffc020ae52:	8552                	mv	a0,s4
ffffffffc020ae54:	094000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020ae58:	70e2                	ld	ra,56(sp)
ffffffffc020ae5a:	7442                	ld	s0,48(sp)
ffffffffc020ae5c:	7902                	ld	s2,32(sp)
ffffffffc020ae5e:	69e2                	ld	s3,24(sp)
ffffffffc020ae60:	6a42                	ld	s4,16(sp)
ffffffffc020ae62:	6aa2                	ld	s5,8(sp)
ffffffffc020ae64:	8526                	mv	a0,s1
ffffffffc020ae66:	74a2                	ld	s1,40(sp)
ffffffffc020ae68:	6121                	addi	sp,sp,64
ffffffffc020ae6a:	8082                	ret
ffffffffc020ae6c:	4481                	li	s1,0
ffffffffc020ae6e:	b7d5                	j	ffffffffc020ae52 <sfs_sync_freemap+0x58>

ffffffffc020ae70 <sfs_clear_block>:
ffffffffc020ae70:	7179                	addi	sp,sp,-48
ffffffffc020ae72:	f022                	sd	s0,32(sp)
ffffffffc020ae74:	e84a                	sd	s2,16(sp)
ffffffffc020ae76:	e44e                	sd	s3,8(sp)
ffffffffc020ae78:	f406                	sd	ra,40(sp)
ffffffffc020ae7a:	89b2                	mv	s3,a2
ffffffffc020ae7c:	ec26                	sd	s1,24(sp)
ffffffffc020ae7e:	892a                	mv	s2,a0
ffffffffc020ae80:	842e                	mv	s0,a1
ffffffffc020ae82:	056000ef          	jal	ra,ffffffffc020aed8 <lock_sfs_io>
ffffffffc020ae86:	04893503          	ld	a0,72(s2)
ffffffffc020ae8a:	6605                	lui	a2,0x1
ffffffffc020ae8c:	4581                	li	a1,0
ffffffffc020ae8e:	596000ef          	jal	ra,ffffffffc020b424 <memset>
ffffffffc020ae92:	02098d63          	beqz	s3,ffffffffc020aecc <sfs_clear_block+0x5c>
ffffffffc020ae96:	013409bb          	addw	s3,s0,s3
ffffffffc020ae9a:	a019                	j	ffffffffc020aea0 <sfs_clear_block+0x30>
ffffffffc020ae9c:	02898863          	beq	s3,s0,ffffffffc020aecc <sfs_clear_block+0x5c>
ffffffffc020aea0:	04893583          	ld	a1,72(s2)
ffffffffc020aea4:	8622                	mv	a2,s0
ffffffffc020aea6:	4705                	li	a4,1
ffffffffc020aea8:	4685                	li	a3,1
ffffffffc020aeaa:	854a                	mv	a0,s2
ffffffffc020aeac:	cddff0ef          	jal	ra,ffffffffc020ab88 <sfs_rwblock_nolock>
ffffffffc020aeb0:	84aa                	mv	s1,a0
ffffffffc020aeb2:	2405                	addiw	s0,s0,1
ffffffffc020aeb4:	d565                	beqz	a0,ffffffffc020ae9c <sfs_clear_block+0x2c>
ffffffffc020aeb6:	854a                	mv	a0,s2
ffffffffc020aeb8:	030000ef          	jal	ra,ffffffffc020aee8 <unlock_sfs_io>
ffffffffc020aebc:	70a2                	ld	ra,40(sp)
ffffffffc020aebe:	7402                	ld	s0,32(sp)
ffffffffc020aec0:	6942                	ld	s2,16(sp)
ffffffffc020aec2:	69a2                	ld	s3,8(sp)
ffffffffc020aec4:	8526                	mv	a0,s1
ffffffffc020aec6:	64e2                	ld	s1,24(sp)
ffffffffc020aec8:	6145                	addi	sp,sp,48
ffffffffc020aeca:	8082                	ret
ffffffffc020aecc:	4481                	li	s1,0
ffffffffc020aece:	b7e5                	j	ffffffffc020aeb6 <sfs_clear_block+0x46>

ffffffffc020aed0 <lock_sfs_fs>:
ffffffffc020aed0:	05050513          	addi	a0,a0,80
ffffffffc020aed4:	e90f906f          	j	ffffffffc0204564 <down>

ffffffffc020aed8 <lock_sfs_io>:
ffffffffc020aed8:	06850513          	addi	a0,a0,104
ffffffffc020aedc:	e88f906f          	j	ffffffffc0204564 <down>

ffffffffc020aee0 <unlock_sfs_fs>:
ffffffffc020aee0:	05050513          	addi	a0,a0,80
ffffffffc020aee4:	e7cf906f          	j	ffffffffc0204560 <up>

ffffffffc020aee8 <unlock_sfs_io>:
ffffffffc020aee8:	06850513          	addi	a0,a0,104
ffffffffc020aeec:	e74f906f          	j	ffffffffc0204560 <up>

ffffffffc020aef0 <hash32>:
ffffffffc020aef0:	9e3707b7          	lui	a5,0x9e370
ffffffffc020aef4:	2785                	addiw	a5,a5,1
ffffffffc020aef6:	02a7853b          	mulw	a0,a5,a0
ffffffffc020aefa:	02000793          	li	a5,32
ffffffffc020aefe:	9f8d                	subw	a5,a5,a1
ffffffffc020af00:	00f5553b          	srlw	a0,a0,a5
ffffffffc020af04:	8082                	ret

ffffffffc020af06 <printnum>:
ffffffffc020af06:	02071893          	slli	a7,a4,0x20
ffffffffc020af0a:	7139                	addi	sp,sp,-64
ffffffffc020af0c:	0208d893          	srli	a7,a7,0x20
ffffffffc020af10:	e456                	sd	s5,8(sp)
ffffffffc020af12:	0316fab3          	remu	s5,a3,a7
ffffffffc020af16:	f822                	sd	s0,48(sp)
ffffffffc020af18:	f426                	sd	s1,40(sp)
ffffffffc020af1a:	f04a                	sd	s2,32(sp)
ffffffffc020af1c:	ec4e                	sd	s3,24(sp)
ffffffffc020af1e:	fc06                	sd	ra,56(sp)
ffffffffc020af20:	e852                	sd	s4,16(sp)
ffffffffc020af22:	84aa                	mv	s1,a0
ffffffffc020af24:	89ae                	mv	s3,a1
ffffffffc020af26:	8932                	mv	s2,a2
ffffffffc020af28:	fff7841b          	addiw	s0,a5,-1
ffffffffc020af2c:	2a81                	sext.w	s5,s5
ffffffffc020af2e:	0516f163          	bgeu	a3,a7,ffffffffc020af70 <printnum+0x6a>
ffffffffc020af32:	8a42                	mv	s4,a6
ffffffffc020af34:	00805863          	blez	s0,ffffffffc020af44 <printnum+0x3e>
ffffffffc020af38:	347d                	addiw	s0,s0,-1
ffffffffc020af3a:	864e                	mv	a2,s3
ffffffffc020af3c:	85ca                	mv	a1,s2
ffffffffc020af3e:	8552                	mv	a0,s4
ffffffffc020af40:	9482                	jalr	s1
ffffffffc020af42:	f87d                	bnez	s0,ffffffffc020af38 <printnum+0x32>
ffffffffc020af44:	1a82                	slli	s5,s5,0x20
ffffffffc020af46:	00004797          	auipc	a5,0x4
ffffffffc020af4a:	3c278793          	addi	a5,a5,962 # ffffffffc020f308 <sfs_node_fileops+0x118>
ffffffffc020af4e:	020ada93          	srli	s5,s5,0x20
ffffffffc020af52:	9abe                	add	s5,s5,a5
ffffffffc020af54:	7442                	ld	s0,48(sp)
ffffffffc020af56:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020af5a:	70e2                	ld	ra,56(sp)
ffffffffc020af5c:	6a42                	ld	s4,16(sp)
ffffffffc020af5e:	6aa2                	ld	s5,8(sp)
ffffffffc020af60:	864e                	mv	a2,s3
ffffffffc020af62:	85ca                	mv	a1,s2
ffffffffc020af64:	69e2                	ld	s3,24(sp)
ffffffffc020af66:	7902                	ld	s2,32(sp)
ffffffffc020af68:	87a6                	mv	a5,s1
ffffffffc020af6a:	74a2                	ld	s1,40(sp)
ffffffffc020af6c:	6121                	addi	sp,sp,64
ffffffffc020af6e:	8782                	jr	a5
ffffffffc020af70:	0316d6b3          	divu	a3,a3,a7
ffffffffc020af74:	87a2                	mv	a5,s0
ffffffffc020af76:	f91ff0ef          	jal	ra,ffffffffc020af06 <printnum>
ffffffffc020af7a:	b7e9                	j	ffffffffc020af44 <printnum+0x3e>

ffffffffc020af7c <sprintputch>:
ffffffffc020af7c:	499c                	lw	a5,16(a1)
ffffffffc020af7e:	6198                	ld	a4,0(a1)
ffffffffc020af80:	6594                	ld	a3,8(a1)
ffffffffc020af82:	2785                	addiw	a5,a5,1
ffffffffc020af84:	c99c                	sw	a5,16(a1)
ffffffffc020af86:	00d77763          	bgeu	a4,a3,ffffffffc020af94 <sprintputch+0x18>
ffffffffc020af8a:	00170793          	addi	a5,a4,1
ffffffffc020af8e:	e19c                	sd	a5,0(a1)
ffffffffc020af90:	00a70023          	sb	a0,0(a4)
ffffffffc020af94:	8082                	ret

ffffffffc020af96 <vprintfmt>:
ffffffffc020af96:	7119                	addi	sp,sp,-128
ffffffffc020af98:	f4a6                	sd	s1,104(sp)
ffffffffc020af9a:	f0ca                	sd	s2,96(sp)
ffffffffc020af9c:	ecce                	sd	s3,88(sp)
ffffffffc020af9e:	e8d2                	sd	s4,80(sp)
ffffffffc020afa0:	e4d6                	sd	s5,72(sp)
ffffffffc020afa2:	e0da                	sd	s6,64(sp)
ffffffffc020afa4:	fc5e                	sd	s7,56(sp)
ffffffffc020afa6:	ec6e                	sd	s11,24(sp)
ffffffffc020afa8:	fc86                	sd	ra,120(sp)
ffffffffc020afaa:	f8a2                	sd	s0,112(sp)
ffffffffc020afac:	f862                	sd	s8,48(sp)
ffffffffc020afae:	f466                	sd	s9,40(sp)
ffffffffc020afb0:	f06a                	sd	s10,32(sp)
ffffffffc020afb2:	89aa                	mv	s3,a0
ffffffffc020afb4:	892e                	mv	s2,a1
ffffffffc020afb6:	84b2                	mv	s1,a2
ffffffffc020afb8:	8db6                	mv	s11,a3
ffffffffc020afba:	8aba                	mv	s5,a4
ffffffffc020afbc:	02500a13          	li	s4,37
ffffffffc020afc0:	5bfd                	li	s7,-1
ffffffffc020afc2:	00004b17          	auipc	s6,0x4
ffffffffc020afc6:	372b0b13          	addi	s6,s6,882 # ffffffffc020f334 <sfs_node_fileops+0x144>
ffffffffc020afca:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020afce:	001d8413          	addi	s0,s11,1
ffffffffc020afd2:	01450b63          	beq	a0,s4,ffffffffc020afe8 <vprintfmt+0x52>
ffffffffc020afd6:	c129                	beqz	a0,ffffffffc020b018 <vprintfmt+0x82>
ffffffffc020afd8:	864a                	mv	a2,s2
ffffffffc020afda:	85a6                	mv	a1,s1
ffffffffc020afdc:	0405                	addi	s0,s0,1
ffffffffc020afde:	9982                	jalr	s3
ffffffffc020afe0:	fff44503          	lbu	a0,-1(s0)
ffffffffc020afe4:	ff4519e3          	bne	a0,s4,ffffffffc020afd6 <vprintfmt+0x40>
ffffffffc020afe8:	00044583          	lbu	a1,0(s0)
ffffffffc020afec:	02000813          	li	a6,32
ffffffffc020aff0:	4d01                	li	s10,0
ffffffffc020aff2:	4301                	li	t1,0
ffffffffc020aff4:	5cfd                	li	s9,-1
ffffffffc020aff6:	5c7d                	li	s8,-1
ffffffffc020aff8:	05500513          	li	a0,85
ffffffffc020affc:	48a5                	li	a7,9
ffffffffc020affe:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b002:	0ff67613          	zext.b	a2,a2
ffffffffc020b006:	00140d93          	addi	s11,s0,1
ffffffffc020b00a:	04c56263          	bltu	a0,a2,ffffffffc020b04e <vprintfmt+0xb8>
ffffffffc020b00e:	060a                	slli	a2,a2,0x2
ffffffffc020b010:	965a                	add	a2,a2,s6
ffffffffc020b012:	4214                	lw	a3,0(a2)
ffffffffc020b014:	96da                	add	a3,a3,s6
ffffffffc020b016:	8682                	jr	a3
ffffffffc020b018:	70e6                	ld	ra,120(sp)
ffffffffc020b01a:	7446                	ld	s0,112(sp)
ffffffffc020b01c:	74a6                	ld	s1,104(sp)
ffffffffc020b01e:	7906                	ld	s2,96(sp)
ffffffffc020b020:	69e6                	ld	s3,88(sp)
ffffffffc020b022:	6a46                	ld	s4,80(sp)
ffffffffc020b024:	6aa6                	ld	s5,72(sp)
ffffffffc020b026:	6b06                	ld	s6,64(sp)
ffffffffc020b028:	7be2                	ld	s7,56(sp)
ffffffffc020b02a:	7c42                	ld	s8,48(sp)
ffffffffc020b02c:	7ca2                	ld	s9,40(sp)
ffffffffc020b02e:	7d02                	ld	s10,32(sp)
ffffffffc020b030:	6de2                	ld	s11,24(sp)
ffffffffc020b032:	6109                	addi	sp,sp,128
ffffffffc020b034:	8082                	ret
ffffffffc020b036:	882e                	mv	a6,a1
ffffffffc020b038:	00144583          	lbu	a1,1(s0)
ffffffffc020b03c:	846e                	mv	s0,s11
ffffffffc020b03e:	00140d93          	addi	s11,s0,1
ffffffffc020b042:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b046:	0ff67613          	zext.b	a2,a2
ffffffffc020b04a:	fcc572e3          	bgeu	a0,a2,ffffffffc020b00e <vprintfmt+0x78>
ffffffffc020b04e:	864a                	mv	a2,s2
ffffffffc020b050:	85a6                	mv	a1,s1
ffffffffc020b052:	02500513          	li	a0,37
ffffffffc020b056:	9982                	jalr	s3
ffffffffc020b058:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b05c:	8da2                	mv	s11,s0
ffffffffc020b05e:	f74786e3          	beq	a5,s4,ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b062:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b066:	1dfd                	addi	s11,s11,-1
ffffffffc020b068:	ff479de3          	bne	a5,s4,ffffffffc020b062 <vprintfmt+0xcc>
ffffffffc020b06c:	bfb9                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b06e:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b072:	00144583          	lbu	a1,1(s0)
ffffffffc020b076:	846e                	mv	s0,s11
ffffffffc020b078:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b07c:	0005861b          	sext.w	a2,a1
ffffffffc020b080:	02d8e463          	bltu	a7,a3,ffffffffc020b0a8 <vprintfmt+0x112>
ffffffffc020b084:	00144583          	lbu	a1,1(s0)
ffffffffc020b088:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b08c:	0196873b          	addw	a4,a3,s9
ffffffffc020b090:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b094:	9f31                	addw	a4,a4,a2
ffffffffc020b096:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b09a:	0405                	addi	s0,s0,1
ffffffffc020b09c:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b0a0:	0005861b          	sext.w	a2,a1
ffffffffc020b0a4:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b084 <vprintfmt+0xee>
ffffffffc020b0a8:	f40c5be3          	bgez	s8,ffffffffc020affe <vprintfmt+0x68>
ffffffffc020b0ac:	8c66                	mv	s8,s9
ffffffffc020b0ae:	5cfd                	li	s9,-1
ffffffffc020b0b0:	b7b9                	j	ffffffffc020affe <vprintfmt+0x68>
ffffffffc020b0b2:	fffc4693          	not	a3,s8
ffffffffc020b0b6:	96fd                	srai	a3,a3,0x3f
ffffffffc020b0b8:	00dc77b3          	and	a5,s8,a3
ffffffffc020b0bc:	00144583          	lbu	a1,1(s0)
ffffffffc020b0c0:	00078c1b          	sext.w	s8,a5
ffffffffc020b0c4:	846e                	mv	s0,s11
ffffffffc020b0c6:	bf25                	j	ffffffffc020affe <vprintfmt+0x68>
ffffffffc020b0c8:	000aac83          	lw	s9,0(s5)
ffffffffc020b0cc:	00144583          	lbu	a1,1(s0)
ffffffffc020b0d0:	0aa1                	addi	s5,s5,8
ffffffffc020b0d2:	846e                	mv	s0,s11
ffffffffc020b0d4:	bfd1                	j	ffffffffc020b0a8 <vprintfmt+0x112>
ffffffffc020b0d6:	4705                	li	a4,1
ffffffffc020b0d8:	008a8613          	addi	a2,s5,8
ffffffffc020b0dc:	00674463          	blt	a4,t1,ffffffffc020b0e4 <vprintfmt+0x14e>
ffffffffc020b0e0:	1c030c63          	beqz	t1,ffffffffc020b2b8 <vprintfmt+0x322>
ffffffffc020b0e4:	000ab683          	ld	a3,0(s5)
ffffffffc020b0e8:	4741                	li	a4,16
ffffffffc020b0ea:	8ab2                	mv	s5,a2
ffffffffc020b0ec:	2801                	sext.w	a6,a6
ffffffffc020b0ee:	87e2                	mv	a5,s8
ffffffffc020b0f0:	8626                	mv	a2,s1
ffffffffc020b0f2:	85ca                	mv	a1,s2
ffffffffc020b0f4:	854e                	mv	a0,s3
ffffffffc020b0f6:	e11ff0ef          	jal	ra,ffffffffc020af06 <printnum>
ffffffffc020b0fa:	bdc1                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b0fc:	000aa503          	lw	a0,0(s5)
ffffffffc020b100:	864a                	mv	a2,s2
ffffffffc020b102:	85a6                	mv	a1,s1
ffffffffc020b104:	0aa1                	addi	s5,s5,8
ffffffffc020b106:	9982                	jalr	s3
ffffffffc020b108:	b5c9                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b10a:	4705                	li	a4,1
ffffffffc020b10c:	008a8613          	addi	a2,s5,8
ffffffffc020b110:	00674463          	blt	a4,t1,ffffffffc020b118 <vprintfmt+0x182>
ffffffffc020b114:	18030d63          	beqz	t1,ffffffffc020b2ae <vprintfmt+0x318>
ffffffffc020b118:	000ab683          	ld	a3,0(s5)
ffffffffc020b11c:	4729                	li	a4,10
ffffffffc020b11e:	8ab2                	mv	s5,a2
ffffffffc020b120:	b7f1                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b122:	00144583          	lbu	a1,1(s0)
ffffffffc020b126:	4d05                	li	s10,1
ffffffffc020b128:	846e                	mv	s0,s11
ffffffffc020b12a:	bdd1                	j	ffffffffc020affe <vprintfmt+0x68>
ffffffffc020b12c:	864a                	mv	a2,s2
ffffffffc020b12e:	85a6                	mv	a1,s1
ffffffffc020b130:	02500513          	li	a0,37
ffffffffc020b134:	9982                	jalr	s3
ffffffffc020b136:	bd51                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b138:	00144583          	lbu	a1,1(s0)
ffffffffc020b13c:	2305                	addiw	t1,t1,1
ffffffffc020b13e:	846e                	mv	s0,s11
ffffffffc020b140:	bd7d                	j	ffffffffc020affe <vprintfmt+0x68>
ffffffffc020b142:	4705                	li	a4,1
ffffffffc020b144:	008a8613          	addi	a2,s5,8
ffffffffc020b148:	00674463          	blt	a4,t1,ffffffffc020b150 <vprintfmt+0x1ba>
ffffffffc020b14c:	14030c63          	beqz	t1,ffffffffc020b2a4 <vprintfmt+0x30e>
ffffffffc020b150:	000ab683          	ld	a3,0(s5)
ffffffffc020b154:	4721                	li	a4,8
ffffffffc020b156:	8ab2                	mv	s5,a2
ffffffffc020b158:	bf51                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b15a:	03000513          	li	a0,48
ffffffffc020b15e:	864a                	mv	a2,s2
ffffffffc020b160:	85a6                	mv	a1,s1
ffffffffc020b162:	e042                	sd	a6,0(sp)
ffffffffc020b164:	9982                	jalr	s3
ffffffffc020b166:	864a                	mv	a2,s2
ffffffffc020b168:	85a6                	mv	a1,s1
ffffffffc020b16a:	07800513          	li	a0,120
ffffffffc020b16e:	9982                	jalr	s3
ffffffffc020b170:	0aa1                	addi	s5,s5,8
ffffffffc020b172:	6802                	ld	a6,0(sp)
ffffffffc020b174:	4741                	li	a4,16
ffffffffc020b176:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b17a:	bf8d                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b17c:	000ab403          	ld	s0,0(s5)
ffffffffc020b180:	008a8793          	addi	a5,s5,8
ffffffffc020b184:	e03e                	sd	a5,0(sp)
ffffffffc020b186:	14040c63          	beqz	s0,ffffffffc020b2de <vprintfmt+0x348>
ffffffffc020b18a:	11805063          	blez	s8,ffffffffc020b28a <vprintfmt+0x2f4>
ffffffffc020b18e:	02d00693          	li	a3,45
ffffffffc020b192:	0cd81963          	bne	a6,a3,ffffffffc020b264 <vprintfmt+0x2ce>
ffffffffc020b196:	00044683          	lbu	a3,0(s0)
ffffffffc020b19a:	0006851b          	sext.w	a0,a3
ffffffffc020b19e:	ce8d                	beqz	a3,ffffffffc020b1d8 <vprintfmt+0x242>
ffffffffc020b1a0:	00140a93          	addi	s5,s0,1
ffffffffc020b1a4:	05e00413          	li	s0,94
ffffffffc020b1a8:	000cc563          	bltz	s9,ffffffffc020b1b2 <vprintfmt+0x21c>
ffffffffc020b1ac:	3cfd                	addiw	s9,s9,-1
ffffffffc020b1ae:	037c8363          	beq	s9,s7,ffffffffc020b1d4 <vprintfmt+0x23e>
ffffffffc020b1b2:	864a                	mv	a2,s2
ffffffffc020b1b4:	85a6                	mv	a1,s1
ffffffffc020b1b6:	100d0663          	beqz	s10,ffffffffc020b2c2 <vprintfmt+0x32c>
ffffffffc020b1ba:	3681                	addiw	a3,a3,-32
ffffffffc020b1bc:	10d47363          	bgeu	s0,a3,ffffffffc020b2c2 <vprintfmt+0x32c>
ffffffffc020b1c0:	03f00513          	li	a0,63
ffffffffc020b1c4:	9982                	jalr	s3
ffffffffc020b1c6:	000ac683          	lbu	a3,0(s5)
ffffffffc020b1ca:	3c7d                	addiw	s8,s8,-1
ffffffffc020b1cc:	0a85                	addi	s5,s5,1
ffffffffc020b1ce:	0006851b          	sext.w	a0,a3
ffffffffc020b1d2:	faf9                	bnez	a3,ffffffffc020b1a8 <vprintfmt+0x212>
ffffffffc020b1d4:	01805a63          	blez	s8,ffffffffc020b1e8 <vprintfmt+0x252>
ffffffffc020b1d8:	3c7d                	addiw	s8,s8,-1
ffffffffc020b1da:	864a                	mv	a2,s2
ffffffffc020b1dc:	85a6                	mv	a1,s1
ffffffffc020b1de:	02000513          	li	a0,32
ffffffffc020b1e2:	9982                	jalr	s3
ffffffffc020b1e4:	fe0c1ae3          	bnez	s8,ffffffffc020b1d8 <vprintfmt+0x242>
ffffffffc020b1e8:	6a82                	ld	s5,0(sp)
ffffffffc020b1ea:	b3c5                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b1ec:	4705                	li	a4,1
ffffffffc020b1ee:	008a8d13          	addi	s10,s5,8
ffffffffc020b1f2:	00674463          	blt	a4,t1,ffffffffc020b1fa <vprintfmt+0x264>
ffffffffc020b1f6:	0a030463          	beqz	t1,ffffffffc020b29e <vprintfmt+0x308>
ffffffffc020b1fa:	000ab403          	ld	s0,0(s5)
ffffffffc020b1fe:	0c044463          	bltz	s0,ffffffffc020b2c6 <vprintfmt+0x330>
ffffffffc020b202:	86a2                	mv	a3,s0
ffffffffc020b204:	8aea                	mv	s5,s10
ffffffffc020b206:	4729                	li	a4,10
ffffffffc020b208:	b5d5                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b20a:	000aa783          	lw	a5,0(s5)
ffffffffc020b20e:	46e1                	li	a3,24
ffffffffc020b210:	0aa1                	addi	s5,s5,8
ffffffffc020b212:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b216:	8fb9                	xor	a5,a5,a4
ffffffffc020b218:	40e7873b          	subw	a4,a5,a4
ffffffffc020b21c:	02e6c663          	blt	a3,a4,ffffffffc020b248 <vprintfmt+0x2b2>
ffffffffc020b220:	00371793          	slli	a5,a4,0x3
ffffffffc020b224:	00004697          	auipc	a3,0x4
ffffffffc020b228:	44468693          	addi	a3,a3,1092 # ffffffffc020f668 <error_string>
ffffffffc020b22c:	97b6                	add	a5,a5,a3
ffffffffc020b22e:	639c                	ld	a5,0(a5)
ffffffffc020b230:	cf81                	beqz	a5,ffffffffc020b248 <vprintfmt+0x2b2>
ffffffffc020b232:	873e                	mv	a4,a5
ffffffffc020b234:	00000697          	auipc	a3,0x0
ffffffffc020b238:	28468693          	addi	a3,a3,644 # ffffffffc020b4b8 <etext+0x2a>
ffffffffc020b23c:	8626                	mv	a2,s1
ffffffffc020b23e:	85ca                	mv	a1,s2
ffffffffc020b240:	854e                	mv	a0,s3
ffffffffc020b242:	0d4000ef          	jal	ra,ffffffffc020b316 <printfmt>
ffffffffc020b246:	b351                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b248:	00004697          	auipc	a3,0x4
ffffffffc020b24c:	0e068693          	addi	a3,a3,224 # ffffffffc020f328 <sfs_node_fileops+0x138>
ffffffffc020b250:	8626                	mv	a2,s1
ffffffffc020b252:	85ca                	mv	a1,s2
ffffffffc020b254:	854e                	mv	a0,s3
ffffffffc020b256:	0c0000ef          	jal	ra,ffffffffc020b316 <printfmt>
ffffffffc020b25a:	bb85                	j	ffffffffc020afca <vprintfmt+0x34>
ffffffffc020b25c:	00004417          	auipc	s0,0x4
ffffffffc020b260:	0c440413          	addi	s0,s0,196 # ffffffffc020f320 <sfs_node_fileops+0x130>
ffffffffc020b264:	85e6                	mv	a1,s9
ffffffffc020b266:	8522                	mv	a0,s0
ffffffffc020b268:	e442                	sd	a6,8(sp)
ffffffffc020b26a:	132000ef          	jal	ra,ffffffffc020b39c <strnlen>
ffffffffc020b26e:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b272:	01805c63          	blez	s8,ffffffffc020b28a <vprintfmt+0x2f4>
ffffffffc020b276:	6822                	ld	a6,8(sp)
ffffffffc020b278:	00080a9b          	sext.w	s5,a6
ffffffffc020b27c:	3c7d                	addiw	s8,s8,-1
ffffffffc020b27e:	864a                	mv	a2,s2
ffffffffc020b280:	85a6                	mv	a1,s1
ffffffffc020b282:	8556                	mv	a0,s5
ffffffffc020b284:	9982                	jalr	s3
ffffffffc020b286:	fe0c1be3          	bnez	s8,ffffffffc020b27c <vprintfmt+0x2e6>
ffffffffc020b28a:	00044683          	lbu	a3,0(s0)
ffffffffc020b28e:	00140a93          	addi	s5,s0,1
ffffffffc020b292:	0006851b          	sext.w	a0,a3
ffffffffc020b296:	daa9                	beqz	a3,ffffffffc020b1e8 <vprintfmt+0x252>
ffffffffc020b298:	05e00413          	li	s0,94
ffffffffc020b29c:	b731                	j	ffffffffc020b1a8 <vprintfmt+0x212>
ffffffffc020b29e:	000aa403          	lw	s0,0(s5)
ffffffffc020b2a2:	bfb1                	j	ffffffffc020b1fe <vprintfmt+0x268>
ffffffffc020b2a4:	000ae683          	lwu	a3,0(s5)
ffffffffc020b2a8:	4721                	li	a4,8
ffffffffc020b2aa:	8ab2                	mv	s5,a2
ffffffffc020b2ac:	b581                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b2ae:	000ae683          	lwu	a3,0(s5)
ffffffffc020b2b2:	4729                	li	a4,10
ffffffffc020b2b4:	8ab2                	mv	s5,a2
ffffffffc020b2b6:	bd1d                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b2b8:	000ae683          	lwu	a3,0(s5)
ffffffffc020b2bc:	4741                	li	a4,16
ffffffffc020b2be:	8ab2                	mv	s5,a2
ffffffffc020b2c0:	b535                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b2c2:	9982                	jalr	s3
ffffffffc020b2c4:	b709                	j	ffffffffc020b1c6 <vprintfmt+0x230>
ffffffffc020b2c6:	864a                	mv	a2,s2
ffffffffc020b2c8:	85a6                	mv	a1,s1
ffffffffc020b2ca:	02d00513          	li	a0,45
ffffffffc020b2ce:	e042                	sd	a6,0(sp)
ffffffffc020b2d0:	9982                	jalr	s3
ffffffffc020b2d2:	6802                	ld	a6,0(sp)
ffffffffc020b2d4:	8aea                	mv	s5,s10
ffffffffc020b2d6:	408006b3          	neg	a3,s0
ffffffffc020b2da:	4729                	li	a4,10
ffffffffc020b2dc:	bd01                	j	ffffffffc020b0ec <vprintfmt+0x156>
ffffffffc020b2de:	03805163          	blez	s8,ffffffffc020b300 <vprintfmt+0x36a>
ffffffffc020b2e2:	02d00693          	li	a3,45
ffffffffc020b2e6:	f6d81be3          	bne	a6,a3,ffffffffc020b25c <vprintfmt+0x2c6>
ffffffffc020b2ea:	00004417          	auipc	s0,0x4
ffffffffc020b2ee:	03640413          	addi	s0,s0,54 # ffffffffc020f320 <sfs_node_fileops+0x130>
ffffffffc020b2f2:	02800693          	li	a3,40
ffffffffc020b2f6:	02800513          	li	a0,40
ffffffffc020b2fa:	00140a93          	addi	s5,s0,1
ffffffffc020b2fe:	b55d                	j	ffffffffc020b1a4 <vprintfmt+0x20e>
ffffffffc020b300:	00004a97          	auipc	s5,0x4
ffffffffc020b304:	021a8a93          	addi	s5,s5,33 # ffffffffc020f321 <sfs_node_fileops+0x131>
ffffffffc020b308:	02800513          	li	a0,40
ffffffffc020b30c:	02800693          	li	a3,40
ffffffffc020b310:	05e00413          	li	s0,94
ffffffffc020b314:	bd51                	j	ffffffffc020b1a8 <vprintfmt+0x212>

ffffffffc020b316 <printfmt>:
ffffffffc020b316:	7139                	addi	sp,sp,-64
ffffffffc020b318:	02010313          	addi	t1,sp,32
ffffffffc020b31c:	f03a                	sd	a4,32(sp)
ffffffffc020b31e:	871a                	mv	a4,t1
ffffffffc020b320:	ec06                	sd	ra,24(sp)
ffffffffc020b322:	f43e                	sd	a5,40(sp)
ffffffffc020b324:	f842                	sd	a6,48(sp)
ffffffffc020b326:	fc46                	sd	a7,56(sp)
ffffffffc020b328:	e41a                	sd	t1,8(sp)
ffffffffc020b32a:	c6dff0ef          	jal	ra,ffffffffc020af96 <vprintfmt>
ffffffffc020b32e:	60e2                	ld	ra,24(sp)
ffffffffc020b330:	6121                	addi	sp,sp,64
ffffffffc020b332:	8082                	ret

ffffffffc020b334 <snprintf>:
ffffffffc020b334:	711d                	addi	sp,sp,-96
ffffffffc020b336:	15fd                	addi	a1,a1,-1
ffffffffc020b338:	03810313          	addi	t1,sp,56
ffffffffc020b33c:	95aa                	add	a1,a1,a0
ffffffffc020b33e:	f406                	sd	ra,40(sp)
ffffffffc020b340:	fc36                	sd	a3,56(sp)
ffffffffc020b342:	e0ba                	sd	a4,64(sp)
ffffffffc020b344:	e4be                	sd	a5,72(sp)
ffffffffc020b346:	e8c2                	sd	a6,80(sp)
ffffffffc020b348:	ecc6                	sd	a7,88(sp)
ffffffffc020b34a:	e01a                	sd	t1,0(sp)
ffffffffc020b34c:	e42a                	sd	a0,8(sp)
ffffffffc020b34e:	e82e                	sd	a1,16(sp)
ffffffffc020b350:	cc02                	sw	zero,24(sp)
ffffffffc020b352:	c515                	beqz	a0,ffffffffc020b37e <snprintf+0x4a>
ffffffffc020b354:	02a5e563          	bltu	a1,a0,ffffffffc020b37e <snprintf+0x4a>
ffffffffc020b358:	75dd                	lui	a1,0xffff7
ffffffffc020b35a:	86b2                	mv	a3,a2
ffffffffc020b35c:	00000517          	auipc	a0,0x0
ffffffffc020b360:	c2050513          	addi	a0,a0,-992 # ffffffffc020af7c <sprintputch>
ffffffffc020b364:	871a                	mv	a4,t1
ffffffffc020b366:	0030                	addi	a2,sp,8
ffffffffc020b368:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b36c:	c2bff0ef          	jal	ra,ffffffffc020af96 <vprintfmt>
ffffffffc020b370:	67a2                	ld	a5,8(sp)
ffffffffc020b372:	00078023          	sb	zero,0(a5)
ffffffffc020b376:	4562                	lw	a0,24(sp)
ffffffffc020b378:	70a2                	ld	ra,40(sp)
ffffffffc020b37a:	6125                	addi	sp,sp,96
ffffffffc020b37c:	8082                	ret
ffffffffc020b37e:	5575                	li	a0,-3
ffffffffc020b380:	bfe5                	j	ffffffffc020b378 <snprintf+0x44>

ffffffffc020b382 <strlen>:
ffffffffc020b382:	00054783          	lbu	a5,0(a0)
ffffffffc020b386:	872a                	mv	a4,a0
ffffffffc020b388:	4501                	li	a0,0
ffffffffc020b38a:	cb81                	beqz	a5,ffffffffc020b39a <strlen+0x18>
ffffffffc020b38c:	0505                	addi	a0,a0,1
ffffffffc020b38e:	00a707b3          	add	a5,a4,a0
ffffffffc020b392:	0007c783          	lbu	a5,0(a5)
ffffffffc020b396:	fbfd                	bnez	a5,ffffffffc020b38c <strlen+0xa>
ffffffffc020b398:	8082                	ret
ffffffffc020b39a:	8082                	ret

ffffffffc020b39c <strnlen>:
ffffffffc020b39c:	4781                	li	a5,0
ffffffffc020b39e:	e589                	bnez	a1,ffffffffc020b3a8 <strnlen+0xc>
ffffffffc020b3a0:	a811                	j	ffffffffc020b3b4 <strnlen+0x18>
ffffffffc020b3a2:	0785                	addi	a5,a5,1
ffffffffc020b3a4:	00f58863          	beq	a1,a5,ffffffffc020b3b4 <strnlen+0x18>
ffffffffc020b3a8:	00f50733          	add	a4,a0,a5
ffffffffc020b3ac:	00074703          	lbu	a4,0(a4)
ffffffffc020b3b0:	fb6d                	bnez	a4,ffffffffc020b3a2 <strnlen+0x6>
ffffffffc020b3b2:	85be                	mv	a1,a5
ffffffffc020b3b4:	852e                	mv	a0,a1
ffffffffc020b3b6:	8082                	ret

ffffffffc020b3b8 <strcpy>:
ffffffffc020b3b8:	87aa                	mv	a5,a0
ffffffffc020b3ba:	0005c703          	lbu	a4,0(a1)
ffffffffc020b3be:	0785                	addi	a5,a5,1
ffffffffc020b3c0:	0585                	addi	a1,a1,1
ffffffffc020b3c2:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b3c6:	fb75                	bnez	a4,ffffffffc020b3ba <strcpy+0x2>
ffffffffc020b3c8:	8082                	ret

ffffffffc020b3ca <strcmp>:
ffffffffc020b3ca:	00054783          	lbu	a5,0(a0)
ffffffffc020b3ce:	0005c703          	lbu	a4,0(a1)
ffffffffc020b3d2:	cb89                	beqz	a5,ffffffffc020b3e4 <strcmp+0x1a>
ffffffffc020b3d4:	0505                	addi	a0,a0,1
ffffffffc020b3d6:	0585                	addi	a1,a1,1
ffffffffc020b3d8:	fee789e3          	beq	a5,a4,ffffffffc020b3ca <strcmp>
ffffffffc020b3dc:	0007851b          	sext.w	a0,a5
ffffffffc020b3e0:	9d19                	subw	a0,a0,a4
ffffffffc020b3e2:	8082                	ret
ffffffffc020b3e4:	4501                	li	a0,0
ffffffffc020b3e6:	bfed                	j	ffffffffc020b3e0 <strcmp+0x16>

ffffffffc020b3e8 <strncmp>:
ffffffffc020b3e8:	c20d                	beqz	a2,ffffffffc020b40a <strncmp+0x22>
ffffffffc020b3ea:	962e                	add	a2,a2,a1
ffffffffc020b3ec:	a031                	j	ffffffffc020b3f8 <strncmp+0x10>
ffffffffc020b3ee:	0505                	addi	a0,a0,1
ffffffffc020b3f0:	00e79a63          	bne	a5,a4,ffffffffc020b404 <strncmp+0x1c>
ffffffffc020b3f4:	00b60b63          	beq	a2,a1,ffffffffc020b40a <strncmp+0x22>
ffffffffc020b3f8:	00054783          	lbu	a5,0(a0)
ffffffffc020b3fc:	0585                	addi	a1,a1,1
ffffffffc020b3fe:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b402:	f7f5                	bnez	a5,ffffffffc020b3ee <strncmp+0x6>
ffffffffc020b404:	40e7853b          	subw	a0,a5,a4
ffffffffc020b408:	8082                	ret
ffffffffc020b40a:	4501                	li	a0,0
ffffffffc020b40c:	8082                	ret

ffffffffc020b40e <strchr>:
ffffffffc020b40e:	00054783          	lbu	a5,0(a0)
ffffffffc020b412:	c799                	beqz	a5,ffffffffc020b420 <strchr+0x12>
ffffffffc020b414:	00f58763          	beq	a1,a5,ffffffffc020b422 <strchr+0x14>
ffffffffc020b418:	00154783          	lbu	a5,1(a0)
ffffffffc020b41c:	0505                	addi	a0,a0,1
ffffffffc020b41e:	fbfd                	bnez	a5,ffffffffc020b414 <strchr+0x6>
ffffffffc020b420:	4501                	li	a0,0
ffffffffc020b422:	8082                	ret

ffffffffc020b424 <memset>:
ffffffffc020b424:	ca01                	beqz	a2,ffffffffc020b434 <memset+0x10>
ffffffffc020b426:	962a                	add	a2,a2,a0
ffffffffc020b428:	87aa                	mv	a5,a0
ffffffffc020b42a:	0785                	addi	a5,a5,1
ffffffffc020b42c:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b430:	fec79de3          	bne	a5,a2,ffffffffc020b42a <memset+0x6>
ffffffffc020b434:	8082                	ret

ffffffffc020b436 <memmove>:
ffffffffc020b436:	02a5f263          	bgeu	a1,a0,ffffffffc020b45a <memmove+0x24>
ffffffffc020b43a:	00c587b3          	add	a5,a1,a2
ffffffffc020b43e:	00f57e63          	bgeu	a0,a5,ffffffffc020b45a <memmove+0x24>
ffffffffc020b442:	00c50733          	add	a4,a0,a2
ffffffffc020b446:	c615                	beqz	a2,ffffffffc020b472 <memmove+0x3c>
ffffffffc020b448:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b44c:	17fd                	addi	a5,a5,-1
ffffffffc020b44e:	177d                	addi	a4,a4,-1
ffffffffc020b450:	00d70023          	sb	a3,0(a4)
ffffffffc020b454:	fef59ae3          	bne	a1,a5,ffffffffc020b448 <memmove+0x12>
ffffffffc020b458:	8082                	ret
ffffffffc020b45a:	00c586b3          	add	a3,a1,a2
ffffffffc020b45e:	87aa                	mv	a5,a0
ffffffffc020b460:	ca11                	beqz	a2,ffffffffc020b474 <memmove+0x3e>
ffffffffc020b462:	0005c703          	lbu	a4,0(a1)
ffffffffc020b466:	0585                	addi	a1,a1,1
ffffffffc020b468:	0785                	addi	a5,a5,1
ffffffffc020b46a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b46e:	fed59ae3          	bne	a1,a3,ffffffffc020b462 <memmove+0x2c>
ffffffffc020b472:	8082                	ret
ffffffffc020b474:	8082                	ret

ffffffffc020b476 <memcpy>:
ffffffffc020b476:	ca19                	beqz	a2,ffffffffc020b48c <memcpy+0x16>
ffffffffc020b478:	962e                	add	a2,a2,a1
ffffffffc020b47a:	87aa                	mv	a5,a0
ffffffffc020b47c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b480:	0585                	addi	a1,a1,1
ffffffffc020b482:	0785                	addi	a5,a5,1
ffffffffc020b484:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b488:	fec59ae3          	bne	a1,a2,ffffffffc020b47c <memcpy+0x6>
ffffffffc020b48c:	8082                	ret
