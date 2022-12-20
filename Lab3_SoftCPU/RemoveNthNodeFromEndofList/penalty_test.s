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

test_branch_hazard_nojmp:
	beq			t1, zero,no_jmp
	nop	
no_jmp:
	nop

test_branch_hazard_jmp:
	bne			t1, zero,jmp	# IF ->EXE-> WB 
jmp:
	nop							#      IF -> EXE(flush)->IF ->EXE->WB 
	nop							#         -> IF (flush)->   ->IF ->EXE->WB 

    lw          ra, 0(sp)
    addi        sp, sp, 8
    ret