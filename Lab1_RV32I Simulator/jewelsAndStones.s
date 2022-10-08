.data
jewels1:
    .string "aA"
    .byte 0 # end of string
stones1: 
    .string "aaAAbB"
    .byte 0 # end of string
jewels2:
    .string "and"
    .byte 0 # end of string
stones2: 
    .string "35678andy"
    .byte 0 # end of string
jewels3:
    .string "fSBEOL"
    .byte 0 # end of string
stones3: 
    .string "ZTAaoLXyENVpuTpMDVKZFyDafTJhyGiVCfobBDtfyLhHgAKKYn"
    .byte 0 # end of string

.text
main:
    la s1, jewels1
    la s2, stones1

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s3, s3, a0
    
    la s1, jewels2
    la s2, stones2

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s4, s4, a0
    
    la s1, jewels3
    la s2, stones3

    addi a1, s1, 0
    addi a2, s2, 0
    jal ra, numJewelsInStones
    add s5, s5, a0
    
    nop

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
    
end_main:
# check case 1, 2, 3 answers by stored value in reg s3, s4, s5
    nop
	
