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

