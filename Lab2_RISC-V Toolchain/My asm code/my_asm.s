.global main

.data
arr1:    .byte 7, 1, 5, 3, 6, 4
arr2:    .byte 1, 1, 3, 4
arr3:    .byte 7, 5, 4, 3, 2

.text
main:  
arr_1:  
        la     a1, arr1        # load arr1 address of prices in a1
        addi   a2, x0, 6       # store the size of prices in a2
	jal    ra, maxProfit   # next instruction store in rd register 
	
	# mv     a2, a0
	# jal    ra, printf 
arr_2:  
        la     a1, arr2        # load arr2 address of prices in a1
        addi   a2, x0, 4       # store the size of prices in a2
        jal    ra, maxProfit   # next instruction store in rd register 

	# mv     a2, a0
	# jal    ra, printf

arr_3:
        la     a1, arr3        # load arr3 address of prices in a1
        addi   a2, x0, 5       # store the size of prices in a2
        jal    ra, maxProfit   # next instruction store in rd register 

	# mv     a2, a0
	# jal    ra, printf
end:
        addi    a7, x0, 93	# "exit" syscall is 93 in rv32emu
        addi	a0, x0, 0	# set ret to 0
        ecall                  # program stop

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
# t0: i'th price currently, (t1, t4): buy price(1 word 4 byte, 1 byte), 
# t2: price[i], t3: temp
# s1: bitmask 0x000000ff
maxProfit: 
        lw     t1, 0(a1)       # load the prices[0:3] into t1 
        addi   s1, x0, 0xff    # bitmask to get the first byte later
        and    t4, t1, s1      # get the first byte of t1 (little endian)
        addi   a0, x0, 0       # set profit = 0
        addi   t0, x0, 0       # set iter i = 0, that is, start from prices[0]
for_loop: 
        addi   t0, t0, 1       # i'th for the next byte
        and    t2, t1, s1      # get the first byte of t1 (little endian)
        blt    a2, t0, end_maxProfit  # a2 < t0 jump end
        bge    t4, t2, else    # (buy >= price[i]), jump to else
        sub    t3, t2, t4      # temp = price[i] - buy
        bge    a0, t3, l2      # profit >= temp, jump to iter
        mv     a0, t3          # else, profit = temp
        j l2
else:
        addi   t4, t2, 0       # buy = prices[i]
l2:                            # unrolling 2
        srli   t1, t1, 8       # shift right 1 byte (8 bits)
        addi   t0, t0, 1       # i'th for the next byte
        and    t2, t1, s1      # get the second byte of t1 (little endian)
        blt    a2, t0, end_maxProfit  # a2 < t0 jump end
        bge    t4, t2, else2   # (buy >= price[i]), jump to else
        sub    t3, t2, t4      # temp = price[i] - buy
        bge    a0, t3, l3      # profit >= temp, jump to iter
        mv     a0, t3          # else, profit = temp
        j l3
else2:
        addi   t4, t2, 0       # buy = prices[i]
l3:                            # unrolling 3
        srli   t1, t1, 8
        addi   t0, t0, 1
        and    t2, t1, s1
        blt    a2, t0, end_maxProfit  # a2 < t0 jump end
        bge    t4, t2, else3   # (buy >= price[i]), jump to else
        sub    t3, t2, t4      # temp = price[i] - buy
        bge    a0, t3, l4      # profit >= temp, jump to iter
        mv     a0, t3          # else, profit = temp
        j l4
else3:
        addi   t4, t2, 0       # buy = prices[i]
l4:                            # unrolling 4
        srli   t1, t1, 8
        addi   t0, t0, 1
        and    t2, t1, s1
        blt    a2, t0, end_maxProfit  # a2 < t0 jump end
        bge    t4, t2, else4   # (buy >= price[i]), jump to else
        sub    t3, t2, t4      # temp = price[i] - buy
        bge    a0, t3, iter      # profit >= temp, jump to iter
        mv     a0, t3          # else, profit = temp
        j iter
else4:
        addi   t4, t2, 0       # buy = prices[i]
iter: 
        addi   a1, a1, 4       # price += 4 
        lw     t1, 0(a1)        # load 4 byte in once
        j      for_loop
end_maxProfit: 
        mv     a2, a0              
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
        ret

