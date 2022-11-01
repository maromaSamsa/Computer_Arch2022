# [Lab1: RV32I Simulator](https://hackmd.io/@maromaSamsa/B1O9CmKzj)
###### tags: `computer-arch`, `jserv`
[GitHub Link](https://github.com/maromaSamsa/Computer_Arch2022/tree/main/Lab1_RV32I%20Simulator)

## Aim of this lab
[Assignment1: RISC-V Assembly and Instruction Pipeline](https://hackmd.io/@sysprog/2022-arch-homework1)

1. Following the instructions of [Lab1: RV32I Simulator](/@sysprog/H1TpVYMdB), you shall write RISC-V assembly programs ([RV32I](https://en.wikipedia.org/wiki/RISC-V) ISA) and output to the console with environment calls.
    
2. You have to explain how each instruction works along with [Ripes](https://github.com/mortbopet/Ripes) simulator.
    

## Problem 
[leetcode 771. Jewels and Stones](https://leetcode.com/problems/jewels-and-stones/description/)

>You're given strings jewels representing the types of stones that are jewels, and stones representing the stones you have. Each character in stones is a type of stone you have. You want to know how many of the stones you have are also jewels.

>Letters are case sensitive, so "a" is considered a different type of stone from "A".

## Solution

### C code
```c=
int numJewelsInStones(char * jewels, char * stones){
    int ans = 0;
    char *currStones = stones;
    while(*jewels != '\0'){
        while(*currStones != '\0'){
            if(*jewels == *currStones){
                ++ans;
            }
            ++currStones;
        }
        ++jewels;
        currStones = stones;
    }
    return ans;
}
```
**Use double-nest loop to check current jewel and current stone is the same value or not. If length of jewels and stones are $n$ and $m$ respectively**

**Time Complexity will be** : **$O(n*m)$**



### RISC-V assembly code
```ruby=
# numJewelsInStones(char * jewels, char * stones) -> int
# [varible definition]:
# a0 -> reg of return ans
# a1 -> pointer holds jewels
# a2 -> pointer holds stones
# ===============================
# [in function scope we use 3 reg]:
# s1 -> pointer holds currStones
# t0 -> current char in jewels
# t1 -> current char in stones
numJewelsInStones:
# push save reg (s0) into stack
    addi sp, sp , -4
    sw s1, 0(sp)

    addi a0, x0, 0      # ans = 0
    addi s1, a2, 0      # currStones = &stones

iterJewels: 
    lb t0, 0(a1)        # t0 = *jewels
    beq t0, x0, end_iterJewels
iterStones:
    lb t1, 0(s1)        # t1 = *currStones
    beq t1, x0, end_iterStones
    bne t0, t1, skip    # if (*jewels != *currStones), skip the next line
    addi a0, a0, 1      # ++ans
skip:
    addi s1, s1, 1      # s1 = &(++currStones)
    j  iterStones
end_iterStones:
    addi a1, a1, 1      # a1 = &(++jewels)
    addi s1, a2, 0      # currStones = &stones 
    j iterJewels
end_iterJewels:
# finish the function, pop save reg (s0) from stack
    lw s1, 0(sp)
    addi sp, sp , 4
    ret
```
Follow the c code, I've writen down the corrosponding assembly code by passing the arguments into register `a1` and `a2`.
In the final, the return value would be stored in register `a0`.

Definition of function **callee** and **caller** gave me an idea which register should be push into stack pointer `sp`:

![](https://i.imgur.com/sw198wQ.png)

For save register `s1`, since it will be used in the **callee** function `numJewelsInStones`, it should be push into stack first to ensure we still can access the old value after return back to **caller** function `main`.

## Analysis instruction code with pipeline in [Ripes](https://github.com/mortbopet/Ripes)

That's prepare the main function and the test data first:
### Test data
```ruby=
.data
# ****************** ans_1 = 4 *******************
jewels1:
    .string "aA"
    .byte 0 # end of string
stones1: 
    .string "aaAAbB"
    .byte 0 # end of string

# ****************** ans_2 = 3 *******************
jewels2:
    .string "and"
    .byte 0 # end of string
stones2: 
    .string "35678andy"
    .byte 0 # end of string

# ****************** ans_3 = 7 *******************
jewels3:
    .string "fSBEOL"
    .byte 0 # end of string
stones3: 
    .string "ZTAaoLXyENVpuTpMDVKZFyDafTJhyGiVCfobBDtfyLhHgAKKYn"
    .byte 0 # end of string
```


### Main test function
```ruby=
.text
main:
# test 1
    la s1, jewels1
    la s2, stones1

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s3, x0, a0

# test 2
    la s1, jewels2
    la s2, stones2

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s4, x0, a0
    
# test 3   
    la s1, jewels3
    la s2, stones3

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s5, x0, a0

# end of main 
    j end_main
... ...
end_main:
# check case 1, 2, 3 answers by stored value in reg s3, s4, s5
    nop  
```

For test data and main functon, store their information into the memery `.data` and `.text` address section, also show it's address in Ripes:

![](https://i.imgur.com/9Qsty9r.png)

That make us convenient to manage the instructions code.

### Test result
![](https://i.imgur.com/eU8rF8s.png)
This figure is the indicator that we optimize the program, the topic will be disccussed later.

![](https://i.imgur.com/OWC6L28.png)
The output answers are all correct.


### Pipeline 
The concept of pipeline is we can split each instruction into different processing stages. In this way, the next of the instruction would not have to wait unyil the previous instruction had fully finished its execution. 

![](https://i.imgur.com/hIjPFSz.png)

Ripes had implemented 5-stages pipeline architecture into its RISC-V processor simulator, each stage would be briefly mention below. Notice the first 4 lines of instructions in `main:`

```ruby=
# main:
#     la s1, jewels1
#     la s2, stones1
#     addi a1, s1, 0
#     addi a2, s2, 0
# (Turn into exacutable instruction)

00000000 <main>:
       0:       10000497        auipc x9 0x10000
       4:       00048493        addi x9 x9 0
       8:       10000917        auipc x18 0x10000
       c:       ffc90913        addi x18 x18 -4
      10:       00048593        addi x11 x9 0
      14:       00090613        addi x12 x18 0
```
![](https://i.imgur.com/pcuy2tj.png)

Multi-task had been done in each clock cycle, there are at most 5 instructions being processing in the same time.

#### IF (Instruction Fetch)
In IF stage, CPU simply fetch instruction form instruction memory according to program counter `pc`.

```ruby=
address    |    machine code    |    instruction code
00000000:       10000497             auipc x9 0x10000
```
![](https://i.imgur.com/TpicuX1.png)
![](https://i.imgur.com/HyJWDtu.png)

In this picture, current `pc` value is `0x00000000` and the corresponding value at that address is `0x10000497`, after the end of the operation, this value will be stored into `IFID` buffer temporarily.

The next `pc` value is going to be fetch is `0x00000004`, mutilplexer in the first left will switch for branch operation.

#### ID (Instruction Decode)
In ID stage, CPU will decode the instruction fetched by previous stage **(value stored in `IFID` buffer)**. The value of instruction is `0x10000497`, which can be decoded into `auipc x9 0x10000`. And decoder will based on this result select two register to become input for next stage.

The immediate value `0x10000` will shift left by 12 bits to fit in upper 20 bits (`auipc` = **add upper immediate[31:12] to program counte**r), so it becomes `0x10000000` after decode.
![](https://i.imgur.com/YnBkvvS.png)


#### EX (Execute)
In EX stage, the instruction will be executed. There are four multiplexer to decide input value of ALU. 

![](https://i.imgur.com/JgjvhGY.png)

:::danger
未解問題
1. 如何決定多工器要開啟那一個通道？
2. 不同運算式下 ALU 的行為
:::

#### MEM (Memory access)
In MEM stage, instruction that **modify main memory** such as load instruction (`lw`, `lb`, *etc*) and save instruction (`sw`,`sb`, *etc*) will be operated.

Discuss the behaviour of **writing into main memory** first, observing this situation:

![](https://i.imgur.com/fjm5Xlv.png)
![](https://i.imgur.com/wSdZV3O.png)

```ruby=
# push a word into stack
source code        |    instruction code
-----------------------------------------
addi sp, sp, -4         addi x2, x2, -4  # already in WB stage
sw   s1, 0(sp)          sw   x9, 0 , x2  # in MEM stage
```

Initially, address that `sp` holds is `0x7ffffff0`, previous instruction `addi sp, sp, -4` tells the processer that you should store `s1` value into `0x7fffffec`, although in this time register `sp` is still hold `0x7ffffff0`. 

Since `EX/MEM` buffer, proccessor do know the actual writing address (by switching multiplexer channel in EX stage), but in this moment, write operation **has not** been done yet, the data memory just access address `0x7fffffec` and value `0x100000000`, if you check the value in main memory address `0x7fffffec`, value still be zero. 

![](https://i.imgur.com/ZIxtZe8.png)
![](https://i.imgur.com/EuyZ8gD.png)

> Write value form register into main memory (save operation)
> - access particular main memory address and value in register in MEM stage.
> - save into main memory at next clock cycle

Now discuss the behaviour of **load value from main memory**, observing this situation:

![](https://i.imgur.com/FyLqB8l.png)
![](https://i.imgur.com/jqeyeh1.png)

```ruby=
source code        |    instruction code
-----------------------------------------
lb t0, 0(a1)            lb x5, 0, x11 
```
![](https://i.imgur.com/f34WS51.png)
![](https://i.imgur.com/Lszyb1r.png)

It seems that there have another signal which is not shown in Ripes, since data memory do know when it should read out a word or whether a byte with sign extension. 

value `0x00000061` will store in `MEM/WB` buffer temporarily in next clock cycle, and for now `x5`'s value is unchanged. 


#### WB (Write Back)
In WB stage, the result get from EXE stage or MEM stage should be writed back to register file.

Continue discuss the last instruction:
![](https://i.imgur.com/FyLqB8l.png)
![](https://i.imgur.com/jqeyeh1.png)
```ruby=
source code        |    instruction code
-----------------------------------------
lb t0, 0(a1)            lb x5, 0, x11  # now in WB stage
```
![](https://i.imgur.com/SnwSDnS.png)
![](https://i.imgur.com/Lszyb1r.png)

> Write value form main memory into register (load operation)
> - access value of particular main memory address in MEM stage.
> - store value in `MEM/WB` buffer temporarily in WB stage 
> - Registers file access target register and value going to write in
>  - save into the register at next clock cycle


### [Pipeline Hazards](https://www.cs.umd.edu/~meesh/411/CA-online/chapter/pipeline-hazards/index.html)
[Also sees in wikipedia](https://en.wikipedia.org/wiki/Pipeline_stall)

Ther are some situations would cause pipeline must insert some `NOP` operation in order to resolve a hazard. two types of situations are shown below.

#### Stall
Observe the source code in chapter: **RISC-V assembly code**

```ruby=
# numJewelsInStones(char * jewels, char * stones) -> int
...
iterJewels: 
    lb t0, 0(a1)        # t0 = *jewels
    beq t0, x0, end_iterJewels
...
```
![](https://i.imgur.com/hYWiobK.png)
Processor will branches depends on reg `x5`(`t0`), but the previous instruction would modify the value in `x5`, that would cause processor compare the wrong value in EX stage, therefore, we need to "on hold" the process of `beq` for one cycle, make sure the multiplexer in EX stage can get the new value of `x5` before making a branch decision.

![](https://i.imgur.com/TPdVpzY.png)


This "on hold" behaviour is so called **stall**, causes **one** `NOP` idle.

![](https://i.imgur.com/K7rLxez.png)

> Although only one `NOP` occurrs, both `beq` and the next instruction `lb` in IF stage are affected.

#### Flush
Observe the source code in chapter: **RISC-V assembly code** again
```ruby=
# numJewelsInStones(char * jewels, char * stones) -> int
...
    addi a0, a0, 1      # ++ans
skip:
    addi s1, s1, 1      # s1 = &(++currStones)
    j  iterStones
end_iterStones:
    addi a1, a1, 1      # a1 = &(++jewels)
    addi s1, a2, 0      # currStones = &stones 
...
```
Since `j iterStones`, `pc` will be modified when `j iterStone` in EX stage.

![](https://i.imgur.com/IZFh1fW.png)

So the next two instructions "burned out", cannot be execute. This is called `flush`, causes **two** `NOP` idle.

![](https://i.imgur.com/eUx2DZO.png)

![](https://i.imgur.com/9A64Qhz.png)
> After EX in 24th clock cycle, **new `pc`** was no longer **old `pc` + 4**, this makes processor have to clear the wrong instruction in IF stage and ID stage in the next clock cycle and fetch the correct instruction according to new `pc`. Same with **stall**, **flush** eventually waste two stage resource.





### Optimization
![](https://i.imgur.com/eU8rF8s.png)
 - Better algorithm 
     - like sort the jewels and stones before comparing -> $O(nlogn + mlogm + n + m)$
     - or set jewels into hashmap -> $O(n + m)$
 - Avoid pipeline hazard
     - avoid modify register right before conditional jump
     - decrease use of jump instruction

:::success
[This commit](https://github.com/maromaSamsa/Computer_Arch2022/commit/368aca757150bae474fbfb4dce22863800e4e51c) avoid modify the compare-use register right before conditional jump, total clock cycles decrease.
![](https://i.imgur.com/GtpeybQ.png)
:::

:::success
[This commit](https://github.com/maromaSamsa/Computer_Arch2022/commit/2ce8aae213e03344c27d1c5112ff4e6a53f06e1f) load a word of stones in each time, reduce 3/4
`iterStones` jumps.
![](https://i.imgur.com/tD3bNFi.png)
:::

:::danger
Would it possible to avoid hazard?
We have `slt` (set bit less than), but seems dont have `seq` setbit equal?
```ruby=
...
# a0 += 1 if (t0 == t3)
    bne t0, t3, skip 
    addi a0, a0, 1
skip:
...
```
:::


### Question: speed compare between CPU and Memory in Ripes
No stall happend when execute the code below:
```ruby=
addi s1, zero, 100
sw s1, -4(sp)
addi s1, zero, 101
sw s1, -4(sp)
addi s1, zero, 102
sw s1, -4(sp)
addi s1, zero, 103
sw s1, -4(sp)
addi s1, zero, 104
sw s1, -4(sp)
addi s1, zero, 105
sw s1, -4(sp)
addi s1, zero, 106
sw s1, -4(sp)
addi s1, zero, 107
sw s1, -4(sp)
addi s1, zero, 108
sw s1, -4(sp)
addi s1, zero, 109
sw s1, -4(sp)
addi s1, zero, 110
sw s1, -4(sp)
```
:::warning
Possible reason:
1. there have a buffer between CPU and main memory
2. Ripes doesn't implement this
3. other reason?

:::




