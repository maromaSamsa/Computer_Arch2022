.global main

.data
arr1:    .word 7,1,5,3,6,4
arr2:    .word 1,1,3,4
arr3:    .word 7,5,4,3,2

.text
#t0 = i
#t1 = temp
#t2 = arr_count=3
#t3 = arr[i] t3
#t4 = arr[i]-temp t4
#t5 = arr_2
#t6= arr_3
#a1 =size
#a2 =target 

main:  
        addi   t2, t2, 3       #arr_1
        addi   t5, t5, 2       #arr_2
        addi   t6, t6, 1       #arr_3
arr_1:  
        la     s1, arr1        # load arr1 address of prices in s1
        addi   t0, x0, 0       # initialize t0
        addi   a2, x0, 0       # initialize a2
        addi   a1, x0, 6       # store the size of prices in a1
        jal    x1, maxProfit   # next instruction store in rd register 
arr_2:  
        la     s1, arr2        # load arr2 address of prices in s1
        addi   t0, x0, 0       # initialize t0
        addi   a2, x0, 0       # initialize a2
        addi   a1, x0, 4       # store the size of prices in a1
        jal    x1, maxProfit    # next instruction store in rd register  
arr_3:
        la     s1, arr3        # load arr2 address of prices in s1
        addi   t0, x0, 0       # initialize t0
        addi   a2, x0, 0       # initialize a2
        addi   a1, x0, 5       # store the size of prices in a1
        jal    x1, maxProfit    # next instruction store in rd register 
maxProfit: 
        addi   t0, t0,1        # store the 1 in t0
        lw     t1, 0(s1)       # load the prices[0] in t1 
        addi   s1,s1,4         # *(prices++)
        lw     t3, 0(s1)       # load the arr[1] in t3 
        jal    for_loop
for_loop: 
        bge    t0, a1, printf  # t0>=a1 jump end
        blt    t1, t3, if      # t3 > t1 jump to if
        addi   t1, t3, 0       # else temp = arr[i]
        addi   t0, t0, 1       # i++
        addi   s1,s1,4         # *(prices++)   
        lw     t3,0(s1)        # load the arr[i]
        j      for_loop
if:
        sub    t4,t3,t1        # arr[i]-temp
        bge    t4,a2,Target    # t4 >= a2 jump to Target
        addi   t4,t4,0         # else target=target
       
count: 
        addi   t0, t0, 1       # i++
        addi   s1,s1,4         # *(prices++)   
        lw     t3,0(s1)        # load the arr[i]  
        j      for_loop
Target:
        addi   a2,t4,0         # store the prices[i]-temp in t2
        j      count             
printf:
	addi a0, x0, 1	        # stdout output = 1
	addi sp, sp, -4
	addi a2, a2, 48         # ascii code convert int to char
	addi t0, x0, 10         # set t0 a bit mask
	slli t0, t0, 8          # next byte of string is '\n'
	or a2,a2,t0	        # masking
	sw a2, 0(sp)
	mv a1, sp	        # a1 is an int we want to print
        addi    a2, x0, 2       # length of the string (char with newline)      
        li      a7, 64	        # "print string" syscall is 64 in rv32emu
        ecall                   # printf integer
        addi sp, sp, 4
end:
        addi    t2,t2,-1       # arr_count--
        beq     t2,t5,arr_2    # t2!=t5 jump to arr_2
        beq     t2,t6,arr_3    # t2!=t6 jump to arr_3
        addi    a7,x0,93	# "exit" syscall is 93 in rv32emu
        addi	a0, x0, 0	# set ret to 0
        ecall                  # program stop

