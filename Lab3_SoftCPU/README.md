# [Lab3: SoftCPU](https://hackmd.io/@maromaSamsa/ByLKE_VDj)
###### tags: `computer-arch`, `jserv`
:::warning
[GitHub Link](https://github.com/maromaSamsa/Computer_Arch2022/tree/main/Lab3_SoftCPU) 
If you want to make these file exacutable, it **MUST** be placed at the project **srv32**, which is the 3-stage pipeline simulater we will use in this Lab.

Copy all of the folder to the path:
~/srv32/sw/
:::

## Aim of this lab
[Assignment3: SoftCPU](https://hackmd.io/@sysprog/2022-arch-homework3)

## Prepare for the enviroment
```shell=
$ uname -a
Linux maromasamsa-UX430UQ 5.15.0-53-generic #59-Ubuntu SMP Mon Oct 17 18:53:30 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```
The following tools are be used in this project:
### [GNU Toolchain for RISC-V](https://xpack.github.io/riscv-none-elf-gcc/)
This toolchain we had already used in [Lab2: RISC-V Toolchain](https://hackmd.io/@maromaSamsa/rJFkoUiNj), follow the install instruction [here](https://hackmd.io/c4wvImoLTiacYOdzACuZ7g?view)

Simply set and check `$PATH` before demo this project:
```shell=
$ cd $HOME
$ source riscv-none-elf-gcc/setenv
$ riscv-none-elf-gcc -v
gcc version 12.2.0 (xPack GNU RISC-V Embedded GCC x86_64)
```

### [Verilator](https://github.com/verilator/verilator) ( version >= 5.002)
**Make form source**
```shell=
$ cd $HOME
$ git clone https://github.com/verilator/verilator
$ cd verilator
$ git checkout stable
$ export VERILATOR_ROOT=`pwd`
$ ./configure
$ make
```

**Set environment path and check**
```shell 
$ export VERILATOR_ROOT=$HOME/verilator
$ export PATH=$VERILATOR_ROOT/bin:$PATH
$ verilator --version
Verilator 5.002 2022-10-29 rev v5.002-29-gdb39d70c7
```

### [srv32](https://github.com/sysprog21/srv32)
**Get source**
```shell=
$ cd $HOME/Desktop
$ git clone https://github.com/sysprog21/srv32
```

### [GTKWave](https://gtkwave.sourceforge.net/)
**Install the application**
```shell=
## follow its README file
## download and extract the package
$ ./configure
checking for Tcl configuration... configure: error: Can't find Tcl configuration definitions. Use --with-tcl to specify a directory containing tclConfig.sh
$ sudo apt-get install tcl-dev tk-dev mesa-common-dev libjpeg-dev libtogl-dev
No package 'gtk+-2.0' found
$ sudo apt install libgtk2.0-dev libglib2.0-dev
$ make
$ sudo make install
## successfully installed, 
## it will show on the applications panel
```

:::success
**In conclusion, besides installing all essential tools, we have to set environment varibles every time when we open a new terminal:**
```shell=
$ source $HOME/riscv-none-elf-gcc/setenv
$ export CROSS_COMPILE=riscv-none-elf-
$ export VERILATOR_ROOT=$HOME/verilator
$ export PATH=$VERILATOR_ROOT/bin:$PATH
```
:::

### Check for `srv32` can operate properly
Go to the path of `srv32`, type `make` in terminal to access the imformation:
```shell=
## make sure you have already setup the environment varibles:
## $ source $HOME/riscv-none-elf-gcc/setenv
## $ export CROSS_COMPILE=riscv-none-elf-
## $ export VERILATOR_ROOT=$HOME/verilator
## $ export PATH=$VERILATOR_ROOT/bin:$PATH

$ cd srv32
$ cd make

make all         build all diags and run the RTL sim
make all-sw      build all diags and run the ISS sim
make tests-all   run all diags and compliance test
make coverage    generate code coverage report
make build       build all diags and the RTL
make dhrystone   build Dhrystone diag and run the RTL sim
make coremark    build Coremark diag and run the RTL sim
make clean       clean
make distclean   clean all

rv32c=1          enable RV32C (default off)
debug=1          enable waveform dump (default off)
coverage=1       enable coverage test (default off)
test_v=[1|2]     run test compliance v1 or v2 (default)

For example

make tests-all             run all tests with test compliance v1
make test_v=2 tests-all    run all tests with test compliance v2
make coverage=1 tests-all  run all tests with code coverage report
make debug=1 hello         run hello with waveform dump
```

According to the instruction from makefile script, try to run the program `hello` in path: `srv32/sw/hello`

```shell=
$ make hello
make[2]: Leaving directory '/home/maromasamsa/Desktop/srv32/sim/sim_cc'
mv sim_cc/sim .
hello world!

Excuting 1155 instructions, 1557 cycles, 1.348 CPI
Program terminate
- ../rtl/../testbench/testbench.v:434: Verilog $finish

Simulation statistics
=====================
Simulation time  : 0.091 s
Simulation cycles: 1568
Simulation speed : 0.0172308 MHz

make[1]: Leaving directory '/home/maromasamsa/Desktop/srv32/sim'
make[1]: Entering directory '/home/maromasamsa/Desktop/srv32/tools'
gcc -c -o rvsim.o rvsim.c -O3 -g -Wall
gcc -c -o decompress.o decompress.c -O3 -g -Wall
gcc -c -o syscall.o syscall.c -O3 -g -Wall
gcc -c -o elfread.o elfread.c -O3 -g -Wall
gcc -c -o getch.o getch.c -O3 -g -Wall
gcc -O3 -g -Wall  -o rvsim rvsim.o decompress.o syscall.o elfread.o getch.o
./rvsim --memsize 128 -l trace.log ../sw/hello/hello.elf
hello world!

Excuting 1155 instructions, 1557 cycles, 1.348 CPI
Program terminate

Simulation statistics
=====================
Simulation time  : 0.003 s
Simulation cycles: 1557
Simulation speed : 0.578 MHz

make[1]: Leaving directory '/home/maromasamsa/Desktop/srv32/tools'
Compare the trace between RTL and ISS simulator
=== Simulation passed ===
```

Two of the simulation result would show:

|          | RTL      | ISS      |
| -------- | -------- | -------- |
| cycles   | 1568     | 1557     |

:::success
There have only two files in `srv32/sw/hello`: `Makefile` and `hello.c` After checking the content of the target directory `srv32/sw/hello` I know some tips of using `srv32`:
1. Create a folder in `srv32/sw`, giving **the same name** of your program
2. Copy the Makefile from `srv32/sw/hello` , and giving some changes.
```
## Makefile
include ../common/Makefile.common

EXE      = .elf
SRC      = hello.c ---> [yourProgramName].c
CFLAGS  += -L../common
LDFLAGS += -T ../common/default.ld
TARGET   = hello ----> [yourProgramName]
OUTPUT   = $(TARGET)$(EXE)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(SRC) $(LDFLAGS)
	$(OBJCOPY) -j .text -O binary $(OUTPUT) imem.bin
	$(OBJCOPY) -j .data -O binary $(OUTPUT) dmem.bin
	$(OBJCOPY) -O binary $(OUTPUT) memory.bin
	$(OBJDUMP) -d $(OUTPUT) > $(TARGET).dis
	$(READELF) -a $(OUTPUT) > $(TARGET).symbol

clean:
	$(RM) *.o $(OUTPUT) $(TARGET).dis $(TARGET).symbol [id]mem.bin memory.bin
```
3. Import your program (C resource code) into the new folder
4. back to path `srv32`
5. `$ make [your program's name]`
:::

By observing the command generate by Makefile and reading srv32 README file, I know few machanism how `srv32` simulate both in RTL and ISS:

RTL simulation process:
```shell=
## some complex process
## generate *.bin file in srv32/sw/hello
## in path srv32/sim
$ cp ../sw/hello/*.bin .
$ stdbuf -o0 -e0 ./sim +trace  +dump | awk -f checkcode.awk
hello world!

Excuting 1155 instructions, 1557 cycles, 1.348 CPI
Program terminate
- ../rtl/../testbench/testbench.v:434: Verilog $finish

Simulation statistics
=====================
Simulation time  : 0.079 s
Simulation cycles: 1568
Simulation speed : 0.0198481 MHz

```

ISS simulation process:
```shell=
## some complex process
## generate .elf file in srv32/sw/hello
## in path srv32/tools
$ gcc -c -o rvsim.o rvsim.c -O3 -g -Wall
$ gcc -c -o decompress.o decompress.c -O3 -g -Wall
$ gcc -c -o syscall.o syscall.c -O3 -g -Wall
$ gcc -c -o elfread.o elfread.c -O3 -g -Wall
$ gcc -c -o getch.o getch.c -O3 -g -Wall
$ gcc -O3 -g -Wall  -o rvsim rvsim.o decompress.o syscall.o elfread.o getch.o
$ ./rvsim --memsize 128 -l trace.log ../sw/hello/hello.elf
hello world!

Excuting 1155 instructions, 1557 cycles, 1.348 CPI
Program terminate

Simulation statistics
=====================
Simulation time  : 0.002 s
Simulation cycles: 1557
Simulation speed : 0.729 MHz
```



## Requirement 1-1 (run Lab2 program in `srv32`)
> You shall modify the assembly programs used/done with Assignment2 and another LeetCode problem with medium difficulty for srv32 Simulation with Verilator. 

### Import Programs (source code in C) from Lab2
[Leetcode 121. Best Time to Buy and Sell Stock](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/)

### Original C Code
The objective of this program we have mention it in Lab2 note 
> Simple expain: assume you can procast the short period of future of stock market, pick two day (i.e. buy stock at A price in one day and sell at B price in the other day) that has the highest profit (profit = B - A)
```c=
#include<stdio.h>

int maxProfit(int *prices, int pricesSize)
{
    int i, temp = prices[0], target = 0;
    for (i = 1; i < pricesSize; i++) 
    {
        if (prices[i] > temp) {
            target = (prices[i] - temp > target) ? (prices[i] - temp) : target;
        } else
            temp = prices[i];
    }
    return target;
}

int main(){
	int prices_1[6] = {7, 1, 5, 3, 6, 4};
	int prices_2[4] = {1, 1, 3, 4};
	int prices_3[5] = {7, 5, 4, 3, 2};
	int pricesSize_1 = 6;
	int pricesSize_2 = 4;
	int pricesSize_3 = 5;
	printf("%d\n", maxProfit(prices_1,pricesSize_1));
	printf("%d\n", maxProfit(prices_2,pricesSize_2));
	printf("%d\n", maxProfit(prices_3,pricesSize_3));
	return 0;
}
```



### RISC-V code generate by gcc

#### Makefile
I do some modification of the Makefile let me can inspect `.s file` that generate by gcc in `-O3`
```
include ../common/Makefile.common

EXE      = .elf
SRC      = BestTimeToBuyAndSellStock.c
ASM	 = .s
CFLAGS  += -L../common
LDFLAGS += -T ../common/default.ld
TARGET   = BestTimeToBuyAndSellStock
MID	 = $(TARGET)$(ASM)
OUTPUT   = $(TARGET)$(EXE)

.PHONY: all clean

all: $(TARGET)

$(MID): $(SRC)
	$(CC) $(CFLAGS) -o $(MID) -S $(SRC) $(LDFLAGS)
	
$(TARGET): $(MID)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(MID) $(LDFLAGS)
	$(OBJCOPY) -j .text -O binary $(OUTPUT) imem.bin
	$(OBJCOPY) -j .data -O binary $(OUTPUT) dmem.bin
	$(OBJCOPY) -O binary $(OUTPUT) memory.bin
	$(OBJDUMP) -d $(OUTPUT) > $(TARGET).dis
	$(READELF) -a $(OUTPUT) > $(TARGET).symbol

clean:
	$(RM) *.s *.o $(OUTPUT) $(TARGET).dis $(TARGET).symbol [id]mem.bin memory.bin
```

#### BestTimeToBuyAndSellStock.s
```rust=
	.file	"BestTimeToBuyAndSellStock.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	maxProfit
	.type	maxProfit, @function
maxProfit:
	li	a5,1
	lw	a3,0(a0)
	ble	a1,a5,.L6
	slli	a1,a1,2
	addi	a5,a0,4
	add	a2,a0,a1
	li	a0,0
	j	.L5
.L11:
	bge	a0,a1,.L3
	mv	a0,a1
.L3:
	addi	a5,a5,4
	beq	a5,a2,.L10
.L5:
	lw	a4,0(a5)
	sub	a1,a4,a3
	blt	a3,a4,.L11
	addi	a5,a5,4
	mv	a3,a4
	bne	a5,a2,.L5
.L10:
	ret
.L6:
	li	a0,0
	ret
	.size	maxProfit, .-maxProfit
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC3:
	.string	"%d\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	s0,8(sp)
	lui	s0,%hi(.LC3)
	li	a1,5
	addi	a0,s0,%lo(.LC3)
	sw	ra,12(sp)
	call	printf
	li	a1,3
	addi	a0,s0,%lo(.LC3)
	call	printf
	addi	a0,s0,%lo(.LC3)
	li	a1,0
	call	printf
	lw	ra,12(sp)
	lw	s0,8(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 12.2.0"
```

:::success
Due to the compiler optimization, the result of `maxProfit` in each test cases had already been computed, the only task in this program is: **call syscall printf to print the exsisting result**
```rust=
        ...

.LC3:
	.string	"%d\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
# -------------- test case 1, ans = 5 ------------------
	lui	s0,%hi(.LC3)            # load upper half word to s0
	li	a1,5                    # load imm 5 into a1
	addi	a0,s0,%lo(.LC3)         # add address (s0 + lower half word) of .LC3 into a0
	sw	ra,12(sp)               # push return register into stack
	call	printf
# -------------- test case 2, ans = 3 ------------------
        li	a1,3                    # load imm 3 into a1
	addi	a0,s0,%lo(.LC3)
	call	printf
# -------------- test case 3, ans = 0 ------------------
	addi	a0,s0,%lo(.LC3)
	li	a1,0                    # load imm 0 into a1
	call	printf
```
The following code reveals this behaviour, also there is no indication that `main` ever called `maxPorfit`
:::

### RISC-V code by hand writing
Copy the source code I had made in [Lab2](), but do some modification to let the assembly run on `srv32`
 - Store `ra` in the begining
 - `printf` syscall

#### my_asm.s
```rust=
.global main

.data
arr1:    
	.word 7,1,5,3,6,4
arr2:    
	.word 1,1,3,4
arr3:    
	.word 7,5,4,3,2
newline:    
	.string "\n"
iformat:    
	.string "%d"

.text
main: 
        addi   sp, sp, -4
        sw     ra, 0(sp)
arr_1:  
        la     a1, arr1        # load arr1 address of prices in a1
        addi   a2, x0, 6       # store the size of prices in a2
	jal    ra, maxProfit   # next instruction store in rd register 
	
        mv     a1, a0
	la     a0, iformat
	call   printf 
	la     a0, newline
	call   printf
arr_2:  
        la     a1, arr2        # load arr2 address of prices in a1
        addi   a2, x0, 4       # store the size of prices in a2
        jal    ra, maxProfit   # next instruction store in rd register 

	mv     a1, a0
	la     a0, iformat
	call   printf 
	la     a0, newline
	call   printf 

arr_3:
        la     a1, arr3        # load arr3 address of prices in a1
        addi   a2, x0, 5       # store the size of prices in a2
        jal    ra, maxProfit   # next instruction store in rd register 

	mv     a1, a0
	la     a0, iformat
	call   printf 
	la     a0, newline
	call   printf
end:
        lw     ra, 0(sp)
        addi   sp, sp, 4
        ret

# int maxProfit(int *prices, int)
# algo {
#       init var buy = prices[0]
#       init var profit = 0
#       iter prices[i]{
#               if prices[i] > buy {
#                      var temp = prices[i] - buy
#                      profit =  (temp > profit) ? temp : (nop)
#               } else {
#                       buy = price[i]
#               }
#       }
#       return profit
# }
# a0: ret profit, a1: *prices, a2: length of prices
# t0: i'th price currently, t1: buy price, t2: price[i], t3: temp
maxProfit: 
        lw     t1, 0(a1)       # load the prices[0] in t1 
        addi   a0, x0, 0       # set profit = 0
        addi   t0, x0, 1       # set iter i = 1, that is, start from prices[1]
        addi   a1, a1, 4       # *(prices++)
        lw     t2, 0(a1)       # load the prices[i] in t2
for_loop: 
        bge    t0, a2, end_maxProfit  # t0 >= a2 jump end
        bge    t1, t2, else    # (buy >= price[i]), jump to else
        sub    t3, t2, t1      # temp = price[i] - buy
        bge    a0, t3, iter    # profit >= temp, jump to iter
        mv     a0, t3          # else, profit = temp
        j iter                 # 
else:
        addi   t1, t2, 0       # buy = prices[i]
iter: 
        addi   t0, t0, 1       # ++i
        addi   a1,a1,4         # *(prices++)   
        lw     t2,0(a1)        # load the prices[i] in t2
        j      for_loop   
end_maxProfit: 
        ret
```

### Compare the performence and try to improve
```shell=
$ cd srv32
$ make BestTimeToBuyAndSellStock
(gcc -O3 result)
## copy my_asm.s code into BestTimeToBuyAndSellStock.s file
$ make BestTimeToBuyAndSellStock
(hand write result)
```
|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  | 4907     | 5904     |
| ISS cycle  | 4896     | 5893     |
> It is **imposible** for me to beat `gcc -O3` by improving anything in `maxProfit` function since `gcc -O3` has already skip this process

:::warning
To prove my idea, I wrote this [commit](https://github.com/maromaSamsa/Computer_Arch2022/commit/4f074b27b8cf278607cea185486625a4a624a92c) to compare the CSR, this program's task only print the result not do any calculation.
|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  | 4907     | 4906     |
| ISS cycle  | 4896     | 4895     |

Although I can't do better than `gcc -O3`, I still made the following changes to the `maxProfit` function to improve performance
|            | gcc -O3  | [unrolling perf](https://github.com/maromaSamsa/Computer_Arch2022/commit/e8ed34f87f7b4a227140f2a5dbe053f112ddaad0) |
| ---------- | -------- | -------- |
| RTL cycle  | 4907     | 5073     |
| ISS cycle  | 4896     | 5062     |
:::

:::success
The final optimization, I mimic the behavior of the compiler and reduce the number of system calls to `printf`
|            | gcc -O3  | [Perf](https://github.com/maromaSamsa/Computer_Arch2022/commit/20fa633fb577e24abc3f1e552cae840c9d5eee32)     |
| ---------- | -------- | -------- |
| RTL cycle  | 4907     | 4189     |
| ISS cycle  | 4896     | 4178     |
:::

## Requirement 1-2 (pick another medium Leetcode problem)
> We need a medium-difficulty LeetCode problem because we are ready to make aggressive optimizations.

[Leetcode 19. Remove Nth Node From End of List
](https://leetcode.com/problems/remove-nth-node-from-end-of-list/)
> Given the head of a linked list, remove the nth node from the end of the list and return its head.

### RemoveNthNodeFromEndofList.c (exacuteble)
```c=
#include <stdlib.h>
#include <stdio.h>

struct ListNode {
      int val;
      struct ListNode *next;
 };

void printList(struct ListNode *head, int rm_msg){
    printf("[ ");
    while (head){
        printf("%d ", head->val);
        head = head->next;
    }
    if(rm_msg == 0){
    	printf("]\n"); 
    }else{
    	printf("] --> remove %d'th node from the end of list\n", rm_msg); 
    }
}

/*1 <= n <= 30*/
struct ListNode* initList(int n){
    struct ListNode* head = (struct ListNode*)malloc(sizeof(struct ListNode));
    struct ListNode* tmp = head;
    head->val = 1;
    head->next = NULL;

    for(int i = 2; i<=n; ++i, tmp = tmp->next){
        struct ListNode* newNode = (struct ListNode*)malloc(sizeof(struct ListNode));
        newNode->val = i;
        newNode->next = NULL;
        tmp->next = newNode;
    }
    return head;
}


struct ListNode* removeNthFromEnd(struct ListNode *head, int n){
    struct ListNode *table[30] = { [0 ... 29] = NULL };
    int len = 0;
    struct ListNode *iter = head;
    while(iter){
        table[len++] = iter;
        iter = iter->next;
    }

    if(n == len){
        return head->next;
    }else if(n > len || n < 0){
        printf("out of range ... NOP\n");
    }else{
        iter = table[len - n - 1];
        iter->next = iter->next->next;
    }
    return head;

}

int main(void){
    struct ListNode* head = initList(7);
    printList(head, 0);
    int rm = 2;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    rm = 4;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    rm = 1;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    return 0;
}
```

### run
```shell=
$ cd srv32
$ make RemoveNthNodeFromEndofList
...
## (RTL simulation)
[ 1 2 3 4 5 6 7 ]
[ 1 2 3 4 5 7 ] --> remove 2'th node from the end of list
[ 1 2 4 5 7 ] --> remove 4'th node from the end of list
[ 1 2 4 5 ] --> remove 1'th node from the end of list

Excuting 27239 instructions, 36351 cycles, 1.334 CPI
Program terminate
- ../rtl/../testbench/testbench.v:434: Verilog $finish

Simulation statistics
=====================
Simulation time  : 0.999 s
Simulation cycles: 36362
Simulation speed : 0.0363984 MHz

...
## (ISS simulation)
[ 1 2 3 4 5 6 7 ]
[ 1 2 3 4 5 7 ] --> remove 2'th node from the end of list
[ 1 2 4 5 7 ] --> remove 4'th node from the end of list
[ 1 2 4 5 ] --> remove 1'th node from the end of list

Excuting 27239 instructions, 36351 cycles, 1.335 CPI
Program terminate

Simulation statistics
=====================
Simulation time  : 0.049 s
Simulation cycles: 36351
Simulation speed : 0.749 MHz
```

### Hand write RISC-V code
#### .data store message
```rust=
.data
LC0:
	.string	"[ "
LC1:
	.string	"%d "
LC2:
	.string	"]\n"
LC3:
	.string	"] --> remove %d'th node from the end of list\n"
```
#### Initialize the single linked list
```rust=
initList:
    addi    sp, sp, -4  
    sw      ra, 0(sp)

    mv      s1, a1              # put length of List to s1
    addi    t0, zero, 1         # current val, also is for loop index i

    li      a0, 8
    call    malloc
    sw      t0, 0(a0)           # head->val = 1;
    mv      s2, a0              # head get address
    mv      s3, a0              # tmp get head address

loop_add_node:
    beq     s1, t0, end_initList
    addi    t0, t0, 1           # i++

    li      a0, 8
    call    malloc              # malloc newNode
    sw      t0, 0(a0)           # newNode->next = i

    sw      a0, 4(s3)           # tmp->next = newNode
    mv      s3, a0              # tmp = tmp->next
	
    j       loop_add_node
end_initList:
    sw	    zero, 4(s3)         # last_node->next = NULL
    mv      a0, s2              # return head address
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
```
Since the structure of `ListNode` below
```c=
struct ListNode {
      int val;
      struct ListNode *next;
 };
```
In 32-bit environment, size of the two varible are both 4 bytes, we can simply get each varible address by offset
```c=
    int val                   # *(&ListNode + 0), 4 bytes
    struct ListNode *next;    # *(&ListNode + 4), 4 bytes 
```
Therefore, we can locate the target address in RISC-V: 
```rust=
loop_add_node:
    # a0 for new node head address we get from syscall `malloc`
    ...
    sw      t0, 0(a0)           # newNode->next = i
    sw      a0, 4(s3)           # tmp->next = newNode
    ...
```

#### Print list
 - `a0`: As a parameter to pass address of node into this function
 - `a1`: As a parameter to present which node had been removed
 - `s1`: pointer that iterate all nodes of the linked list
 - `s2`: store the i'th of the node thatis going to be removed, just for illustrating the result
```rust=
printList:
    addi    sp, sp, -12 
    sw      ra, 0(sp)
    sw	    s1, 4(sp)
    sw	    s2, 8(sp)

    mv      s1, a0        # we are going to use a0, a1 reg //
    mv	    s2, a1        # for calling syscall printf
    
    la      a0, LC0
    call    printf        # printf("[ ")
loop_print_node:
    beq		s1, zero, end_printList

    lw		a1, 0(s1)     # a1 = curr_node->val
    la		a0, LC1
    call	printf        # printf("%d ", current_node->val)

    lw		s1, 4(s1)     # curr_node = curr_node->next    

    j		loop_print_node
end_printList:
    # print i'th node was removed, if i == 0 then don't care
    mv		a1, s2        
    la		a0, LC3        # LC3 is "] --> remove %d'th node from the end of list\n"
    bne		a1, zero, printList_else
    la          a0, LC2        # LC2 is "]\n"
printList_else:
    call    printf

    lw      ra, 0(sp)
    lw	    s1, 4(sp)
    lw	    s2, 8(sp)
    addi    sp, sp, 12
    ret
```

#### Remove Nth From End of list (Objective method for the problem)
```rust=
## removeNthFromEnd(head, rm)
## head ---> a0
## rm ---> a1
## len ---> t0
## *iter ---> t1
## *table[30] ---> n(sp) to n+4*30(sp)
removeNthFromEnd:
    addi    sp, sp, -124     # 4(sp)~120(sp) ---> *table[30]
    sw      ra, 0(sp)        

    li	    t0, 0            # calculate list length
    mv	    t1, a0           # pointer to iterate list nodes
    addi    t2, sp, 4        # pointer of pointer to 4(sp), //
                             # that is, t2 = &table[0]

while_iter:                  # compute list length, and //
                             # store each node address into table[len]
    beq	    t1, zero, remove_node

    sw	    t1, 0(t2)        # store current node address into table[len]

    lw	    t1, 4(t1)        # t1 points to next node
    addi    t2, t2, 4        # point to the next block, t2 = &table[len+1]
    addi    t0, t0, 1        # len++

    j	    while_iter

remove_node:
    beq	    a1, t0, else    # if rm == len, remove //
                            # the first node, goto else

    sub	    t0, t0, a1
    li	    t1, 4
    mul	    t0, t0, t1      # offset = 4 * (len - rm)

    add	    t0, t0, sp      # t0 = &table[rm - 1]
    lw	    t1, 8(t0)       # t1 = table[rm + 1]
    lw	    t0, 0(t0)       # t0 = table[rm - 1]

    sw	    t1, 4(t0)       # table[rm - 1]->next = table[rm + 1]

    j end_removeNthFromEnd
else:	
    lw	    a0, 8(sp)       # return the second node's address
end_removeNthFromEnd:
    lw      ra, 0(sp)
    addi    sp, sp, 124
    ret
```

#### Compare the performence
|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  |**36362** | 36428     |
| ISS cycle  |**36351** | 36417     |

**Check each function's cycle**
 - **Initialize the single linked list (length = 7)**

|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  | 2077     | **2063** |
| ISS cycle  | 2066     | **2051** |
 - **Print list** 

|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  | **8063** | 8280     |
| ISS cycle  | **8063** | 8281     |
> There still have some space to improve my RISC-V code.
 
 - **Remove Nth From End of list (Objective method for the problem)**

|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  |   182    |  **85**  |
| ISS cycle  |   182    |  **85**  |

#### 
:::success
This [commit](https://github.com/maromaSamsa/Computer_Arch2022/commit/ff027ec374f795083ff212f42f85a419a540ad33) implement 4 times unrolling of loops, reduce 3/4
branch penalty.

|            | gcc -O3  | hand write |
| ---------- | -------- | -------- |
| RTL cycle  | 36362    | **36314**|
| ISS cycle  | 36351    | **36303**|
:::

## GTKWave
The sample code I wrote down at `panaty_test.s`, although `srv32` has already claim that only branch instruction would cause pipeline hazard (when branch is taken), I  still want to check the simulation in RTL.
```rust=
.global main
.text
main:
    addi        sp, sp, -8
    sw          ra, 0(sp)

test_load_use_hazard:
    li			t0, 2
    sw			t0, 4(sp)
    lw			t0, 4(sp)
    slli		t0, t0, 1
test_data_hazard:
    li			t1, 5
    addi		t1, t1, 5
    snez		t1, t1

test_branch_hazard_jmp:
    bne			t1, zero,jmp	
jmp:
    mv			t1, zero	
    nop

    lw          ra, 0(sp)
    addi        sp, sp, 8
    ret
```
### SRV32 - Simple 3-stage pipeline RISC-V processor Architecture
 - SRV32 is a 3-stage pipeline with IF/ID,EX,WB stages
 - The picture is orianted from [here](https://hackmd.io/@_UHs74UQS7uNne9_7SwQFQ/S113vvkct#SRV32---Simple-3-stage-pipeline-RISC-V-processor-Architecture), shows the pipeline architecture and some important signals of SRV32
 - Its Hardware description language (HDL) is at `srv32/rtl/risv.v`

![](https://i.imgur.com/mweY9p4.png)


Make the program, then export `srv32/sim/wave.fst` into **GTKWave**:
![](https://i.imgur.com/BNA1YxG.png)
![](https://i.imgur.com/83fbLVz.png)




### Trace log with instruction
After make the program, `trace.log.dis` would be generate in srv32/tools, this is the readable trace log including RISC-V instruction comment
```rust=
 1 00000000 00000297 x05 (t0) <= 0x00000000                       ; auipc	t0,0x0
...
14 00000034 008000ef x01 (ra) <= 0x00000038                       ; jal	ra,3c <main>
17 0000003c ff810113 x02 (sp) <= 0x0003fff8                       ; addi	sp,sp,-8
18 00000040 00112023 write 0x0003fff8 <= 0x00000038               ; sw	ra,0(sp)
19 00000044 00200293 x05 (t0) <= 0x00000002                       ; li	t0,2
20 00000048 00512223 write 0x0003fffc <= 0x00000002               ; sw	t0,4(sp)
21 0000004c 00412283 read 0x0003fffc, x05 (t0) <= 0x00000002      ; lw	t0,4(sp)
22 00000050 00129293 x05 (t0) <= 0x00000004                       ; slli	t0,t0,0x1
23 00000054 00500313 x06 (t1) <= 0x00000005                       ; li	t1,5
24 00000058 00530313 x06 (t1) <= 0x0000000a                       ; addi	t1,t1,5
25 0000005c 00603333 x06 (t1) <= 0x00000001                       ; snez	t1,t1
26 00000060 00031263                                              ; bnez	t1,64 <jmp>
29 00000064 00000313 x06 (t1) <= 0x00000000                       ; li	t1,0
30 00000068 00000013 x00 (zero) <= 0x00000000                     ; nop
31 0000006c 00012083 read 0x0003fff8, x01 (ra) <= 0x00000038      ; lw	ra,0(sp)
32 00000070 00810113 x02 (sp) <= 0x00040000                       ; addi	sp,sp,8
33 00000074 00008067 x00 (zero) <= 0x00000078                     ; ret
36 00000038 3540006f x00 (zero) <= 0x0000003c                     ; j	38c <exit>
...
```

### Test: data hazard (not a hazard in srv32)
> Data hazards occur if an instruction reads a Register that a previous instruction overwrites in a future cycle

> `srv32` supports full forwarding, which indicates RAW data hazard can be resolved WITHOUT stalling the processor.

```rust=
# clk    pc       instr code
  23     00000054 00500313    ; li          t1,5
  24     00000058 00530313    ; addi        t1,t1,5
  25     0000005c 00603333    ; snez        t1,t1
```
Illustrate each wire state in **GTKWave**



## Reference
1. Unfamiliar instrction or expression when I inspecting RISC-V code generate from gcc:
[RISC-V Assembly Programmer's Manual](https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md)
[ GNU 的 as 手冊](https://web.eecs.umich.edu/~prabal/teaching/resources/eecs373/Assembler.pdf)

2. [srv32](https://github.com/sysprog21/srv32)

3. How gcc do optimization (i.e. Requirement 1: Best time To Buy And Sell Stock):
[你所不知道的 C 語言：編譯器和最佳化原理篇](https://hackmd.io/@sysprog/c-compiler-optimization)




