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

# numJewelsInStones(char * jewels, char * stones) -> int
# [varible definition]:
# a0 -> reg of return ans
# a1 -> pointer holds jewels
# a2 -> pointer holds stones
# s1 -> pointer holds currStones
# ===============================
# [in function scope we use 3 reg]:
# s1 -> pointer holds currStones
# t0 -> current char in jewels
# t1 -> current char in 4 stones
# t3 -> current char in stones
numJewelsInStones:
# push save reg (s0) into stack
    addi sp, sp , -4
    sw s1, 0(sp)

    addi a0, x0, 0      # ans = 0
    addi s1, a2, 0      # currStones = &stones
    addi t6, x0, 0b11111111 # byte mask

iterJewels: 
    lb t0, 0(a1)        # t0 = *jewels
    lw t1, 0(s1)        # t1 = *currStones[1:4]
    beq t0, x0, end_iterJewels
iterStones:
    and t3, t6, t1       # t3 = *currStones[1]
    beq t3, x0, end_iterStones
    bne t0, t3, skip1    # if (*jewels != *currStones), skip
    addi a0, a0, 1       # ++ans
skip1:
    srli t1, t1, 8
    and t3, t6, t1
    beq t3, x0, end_iterStones
    bne t0, t3, skip2
    addi a0, a0, 1
skip2:
    srli t1, t1, 8
    and t3, t6, t1
    beq t3, x0, end_iterStones
    bne t0, t3, skip3
    addi a0, a0, 1
skip3:
    srli t1, t1, 8
    and t3, t6, t1
    beq t3, x0, end_iterStones
    bne t0, t3, skip
    addi a0, a0, 1
skip:
    addi s1, s1, 4      # s1 = &(++currStones)
    lw t1, 0(s1)        # t1 = *currStones
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
    
end_main:
# check case 1, 2, 3 answers by stored value in reg s3, s4, s5
    nop
	
