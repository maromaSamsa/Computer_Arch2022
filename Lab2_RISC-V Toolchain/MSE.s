.data
arr1:
	.byte 48, 49, 50
	#.byte 48, 49, 50, 51 # check this
arr2:
	.byte 51, 52, 53, 54

.global main
.text
main:
	addi sp, sp , -4
	
	la   s1, arr1
	lw   t1, 0(s1)
	jal  ra, print_four_byte
	
	la   s1, arr2
	lw   t1, 0(s1)
	jal  ra, print_four_byte
	
	j    end

print_four_byte:
	addi s3, zero, 4
	addi s2, zero, 0xff	
loop:
	beq  s3, zero, end_print_four_byte
	addi s3, s3, -1
	mv   t2, zero
	and  t2, t1, s2
	
	sw   t2, 0(sp)
printf:
	addi a0, zero, 1	# stdout output = 1
	mv   a1, sp		# a1 is what we want to print
	addi a2, zero, 1	# length of the byte stream
	li   a7, 64		# print string syscall in rv32emu
	ecall
next_byte:
	srli t1, t1, 8	
	j    loop
end_print_four_byte:
	ret

end:
	addi sp, sp, 4
	addi a7, zero, 93
	addi a0, x0, 0
	ecall
