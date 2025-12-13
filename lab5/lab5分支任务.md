# <center>Lab5——分支任务</center>

#### <center>李胜林		张肇秋		杨中秀</center>

## 一、调试流程

### makefile
qemu改为我们重新编译的带有调试信息的qemu

```makefile
QEMU := /home/lsl/桌面/qemu-4.1.1/riscv64-softmmu/qemu-system-riscv64
```

下面就可以在终端进行调试了

### 终端1

第一个终端，输入命令

	make debug

### 终端2

第二个终端，命令如下：

- 获取PID

```
pgrep -f qemu-system-riscv64
```
- 启动qemu的调试

```
sudo gdb /home/lsl/桌面/qemu-4.1.1/riscv64-softmmu/qemu-system-riscv64
```
- 绑定PID	

```
(gdb)attach (查到的PID)
(gdb)c
```

### 终端3

第三个终端，命令如下：

```
make gdb
```

启动uCore的GDB调试

```assembly
(gdb) set remotetimeout unlimited  #防止error
(gdb) add-symbol-file obj/__user_exit.out  #加载用户程序符号表
(gdb) b user/libs/syscall.c:18  #ecall附近加断点
(gdb) c
```

### 执行ecall

会停止在断点位置，如图

![屏幕截图 2025-12-14 004604](C:\Users\Dell\Pictures\Screenshots\屏幕截图 2025-12-14 004604.png)

这个是内联汇编语句的入口，`ecall`就在附近，我们可以先显示接下来的几条指令，看`ecall`指令在哪里

```c++
(gdb) x/10i $pc
```

![image-20251214005022085](C:\Users\Dell\AppData\Roaming\Typora\typora-user-images\image-20251214005022085.png)

可以看到`ecall`的位置，执行几次单步就可以达到`ecall`了，执行6次

``````
(gdb) si
``````

![image-20251214011707992](C:\Users\Dell\AppData\Roaming\Typora\typora-user-images\image-20251214011707992.png)

确定了下一条就是`ecall`，我们在终端2中打断点，`riscv_cpu_do_interrupt`是QEMU 模拟器中处理 RISC-V CPU 所有异常的核心函数，也是包括`ecall`的

``````
(gdb) b riscv_cpu_do_interrupt
(gdb) c
``````

![image-20251214011316501](C:\Users\Dell\AppData\Roaming\Typora\typora-user-images\image-20251214011316501.png)

在终端3中输入`si`继续执行下一条，可以看到停在了`/home/lsl/桌面/qemu-4.1.1/target/riscv/cpu_helper.c:507`这个位置，

![屏幕截图 2025-12-13 142950](C:\Users\Dell\Pictures\Screenshots\屏幕截图 2025-12-13 142950.png)

这时候可以看一下`riscv_cpu_do_interrupt`函数的源码，了解一下关键的流程

- 识别异常类型

```c
bool async = !!(cs->exception_index & RISCV_EXCP_INT_FLAG);
target_ulong cause = cs->exception_index & RISCV_EXCP_INT_MASK;
```

`ecall` 是同步异常 → `async = false`

`cause = 8`（即 `RISCV_EXCP_U_ECALL`）

- 将通用 `ecall` 映射到具体特权级

```c
if (cause == RISCV_EXCP_U_ECALL) {
    assert(env->priv <= 3);
    cause = ecall_cause_map[env->priv]; // U-mode → RISCV_EXCP_U_ECALL (8)
}
```

- 判断是否委托给 S 模式

```c
if (env->priv <= PRV_S && cause < TARGET_LONG_BITS && ((deleg >> cause) & 1)) {
    // 委托给 S 模式（uCore 运行在 S 模式）
```

- 保存现场并跳转

```c
// 保存当前中断使能和特权级
s = set_field(s, MSTATUS_SPIE, get_field(s, MSTATUS_SIE));
s = set_field(s, MSTATUS_SPP, env->priv);   // ← 保存 U-mode
s = set_field(s, MSTATUS_SIE, 0);           // ← 关中断
env->mstatus = s;

// 设置 trap 原因和返回地址
env->scause = cause | ((target_ulong)async << (TARGET_LONG_BITS - 1)); // cause=8
env->sepc = env->pc;   // ← ecall 指令地址

// 跳转到 stvec（内核入口）
env->pc = (env->stvec >> 2 << 2) + ((async && (env->stvec & 3) == 1) ? cause * 4 : 0);

// 切换到 S 模式
riscv_cpu_set_mode(env, PRV_S);
```

---

### 执行`sret`

终端2输入`c`继续调试

终端3中加断点在`kern/trap/trapentry.S:133`，这是`sret`所在的位置

```
(gdb) break kern/trap/trapentry.S:133
(gdb) c
```

`sret` 是一条特权指令，QEMU 不会直接模拟它，而是通过 TCG 调用一个 helper 函数来实现其语义。可以寻找一下`helper_sret`函数的位置

```
(gdb) info functions helper_sret
All functions matching regular expression "helper_sret":

File /home/lsl/桌面/qemu-4.1.1/target/riscv/helper.h:
74:     static void gen_helper_sret(TCGv_i64, TCGv_ptr, TCGv_i64);

File /home/lsl/桌面/qemu-4.1.1/target/riscv/op_helper.c:
74:     target_ulong helper_sret(CPURISCVState *, target_ulong);
```

在`/home/lsl/桌面/qemu-4.1.1/target/riscv/op_helper.c:74`中

直接在此处加断点，并继续

```
(gdb) b /home/lsl/桌面/qemu-4.1.1/target/riscv/op_helper.c:74
(gdb) c
```

此时可以看到终端3已经执行到了断点处，下一条就是`sret`

![image-20251214021423768](C:\Users\Dell\AppData\Roaming\Typora\typora-user-images\image-20251214021423768.png)

那终端3直接执行`si`下一条，可以看到终端2中执行到了断点处，说明正在处理`sret`

![image-20251214021659601](C:\Users\Dell\AppData\Roaming\Typora\typora-user-images\image-20251214021659601.png)

可以看一看qemu执行的源代码，关键流程如下:

##### 权限检查：只能在 S 模式或更高执行

```c
if (!(env->priv >= PRV_S)) {
    riscv_raise_exception(env, RISCV_EXCP_ILLEGAL_INST, GETPC());
}
```

- `sret` 是特权指令，**U 模式不能执行**。
- 若当前特权级 < S（即 U 模式），触发 **非法指令异常**。

##### 获取返回地址（sepc）并检查对齐

```c
target_ulong retpc = env->sepc;
if (!riscv_has_ext(env, RVC) && (retpc & 0x3)) {
    riscv_raise_exception(env, RISCV_EXCP_INST_ADDR_MIS, GETPC());
}
```

- `sepc`：由 `ecall`/中断时保存的 **下一条用户指令地址**。
- 若不支持 **RVC（压缩指令扩展）**，则地址必须 **4 字节对齐**（最低两位为 0）。
- 否则触发 **指令地址不对齐异常**。

##### TSR 位检查（安全扩展）

```c
if (env->priv_ver >= PRIV_VERSION_1_10_0 &&
    get_field(env->mstatus, MSTATUS_TSR)) {
    riscv_raise_exception(env, RISCV_EXCP_ILLEGAL_INST, GETPC());
}
```

- **TSR（Trap SRET）位**：若置 1，则禁止在 S 模式执行 `sret`（用于调试或安全隔离）。
- 这是 **Privilege Spec v1.10+ 的特性**。

##### 恢复中断使能状态（核心！）

```c
target_ulong mstatus = env->mstatus;
target_ulong prev_priv = get_field(mstatus, MSTATUS_SPP); // ← 原来的特权级（通常是 U）

// 将 SPIE → SIE（恢复中断使能）
mstatus = set_field(mstatus,
    env->priv_ver >= PRIV_VERSION_1_10_0 ?
        MSTATUS_SIE : MSTATUS_UIE << prev_priv,
    get_field(mstatus, MSTATUS_SPIE));

// 清除 SPIE（设为 0）
mstatus = set_field(mstatus, MSTATUS_SPIE, 0);
```

- **SPIE**：进入 trap 前的 **S 模式中断使能状态**（由 `ecall` 时保存）。
- **SIE**：当前 S 模式的中断使能位。
- `sret` 要把 **SPIE 的值移回 SIE**，从而恢复中断状态。
- 然后 **清零 SPIE**（规范要求）。

#####恢复原始特权级

```c
mstatus = set_field(mstatus, MSTATUS_SPP, PRV_U); // SPP 默认设回 U（惯例）
riscv_cpu_set_mode(env, prev_priv);               // ← 切换回 U 模式！
env->mstatus = mstatus;
```

- `prev_priv = SPP`：记录的是 **陷入前的特权级**（对 `ecall` 来说是 `PRV_U`）。
- `riscv_cpu_set_mode(env, prev_priv)`：**真正切换 CPU 模式**（U/S/M）。
- 同时将 `SPP` 重置为 `PRV_U`（标准做法，避免信息泄露）。

##### 返回目标地址

```c
return retpc;  // TCG 会把这个值赋给 PC
```

- QEMU 的 TCG 框架会捕获这个返回值，并设置 `env->pc = retpc`。
- 下一次取指就从 **用户态下一条指令** 开始！

---

## 二、调试要求

#### 指令翻译（TCG Translation）

**TCG（Tiny Code Generator）** 是 QEMU 实现 动态二进制翻译的核心机制。它的作用是：将 Guest（目标机）的 CPU 指令，动态翻译成 Host（宿主机）能执行的代码，并高效运行。 它不模拟每条指令，而是把一段 Guest 指令翻译成等效的 Host 代码块，然后直接运行。

假设在 x86 电脑上用 QEMU 运行 RISC-V 程序：

- RISC-V 的 `ecall`、`add`、`ld` 指令，x86 CPU 根本看不懂
- 如果逐条解释执行（interpret），速度极慢
- **TCG 的解决方案**：
  把一段 RISC-V 指令 → 翻译成 x86 指令 → 缓存 → 直接运行

这样可以实现接近原生速度的跨架构虚拟化

#### 调试过程细节与知识

之前都是直接在qemu模拟的risc-V环境中跑，但是并不知道qemu到底是如何运作的，通过本次调试，了解到了QEMU 的一些结构和运行逻辑，如qemu结构和功能

- **前端（translate.c）**：只关心“这条指令做什么”（如 `ecall → gen_exception`）。
- **中间层（TCG IR）**：用虚拟汇编描述行为（跨架构）。
- **后端（host codegen）**：生成 x86/ARM 实际代码。
- **Helper 函数**：处理无法翻译的复杂逻辑（如 `sret`）。

#### 大模型使用

​	刚开始使用三个终端的时候，并不是很熟悉三个终端的操作顺序，尤其是终端2和终端3，有时候某个终端卡住不知道是正常现象还是真的阻塞，需要请教大模型；对于`ecall`和`sret`在终端2中需要加什么断点，以及qemu处理过程的源码，这些还是需要大模型来帮助理解的

