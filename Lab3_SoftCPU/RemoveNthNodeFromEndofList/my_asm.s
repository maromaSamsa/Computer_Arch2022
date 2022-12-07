.data
LC0:
	.string	"[ "
LC1:
	.string	"%d "
LC2:
	.string	"]\n"
LC3:
	.string	"] --> remove %d'th node from the end of list\n"
LC4:
	.string	"out of range ... NOP"

.text
# int n --> s1
# sizeof(List) --> 8
# struct ListNode* head = (struct ListNode*)malloc(sizeof(struct ListNode)); --> s2
# struct ListNode* tmp = head; --> s3
# head->val = 1;
# head->next = NULL;

# int i -> t0
# struct ListNode* newNode = (struct ListNode*)malloc(sizeof(struct ListNode)); --> a0
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
	sw		zero, 4(s3)
    mv      a0, s2
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

## printList(head):
printList:
    addi    sp, sp, -12 
    sw      ra, 0(sp)
	sw		s1, 4(sp)
	sw		s2, 8(sp)

    mv      s1, a0
	mv		s2, a1
    

    la      a0, LC0
    call    printf
loop_print_node:
	beq		s1, zero, end_printList

	lw		a1, 0(s1)
	la		a0, LC1
	call	printf

	lw		s1, 4(s1)

	j		loop_print_node
end_printList:
	mv		a1, s2
	la		a0, LC3
	bne		a1, zero, printList_else
	la      a0, LC2
printList_else:
    call    printf

    lw      ra, 0(sp)
	lw		s1, 4(sp)
    lw		s2, 8(sp)
    addi    sp, sp, 12
    ret

## removeNthFromEnd(head, rm)
## head ---> a0
## rm ---> a1
## len ---> t0
## *iter ---> t1
## *table[30] ---> n(sp) to n+12+4*30(sp) ---> t2
removeNthFromEnd:
	addi    sp, sp, -124 
    sw      ra, 0(sp)

	li		t0, 0
	mv		t1, a0
	addi	t2, sp, 4

while_iter:
	beq		t1, zero, remove_node

	sw		t1, 0(t2)

	lw		t1, 4(t1)
	addi	t2, t2, 4
	addi	t0, t0, 1
	
	j		while_iter
remove_node:
	beq		a1, t0, else
	
	sub		t0, t0, a1
	li		t1, 4
	mul		t0, t0, t1

	add		t0, t0, sp
	lw		t1, 8(t0)
	lw		t0, 0(t0)
	
	sw		t1, 4(t0)

	j end_removeNthFromEnd
else:	
	lw		a0, 8(sp)
end_removeNthFromEnd:
	lw      ra, 0(sp)
    addi    sp, sp, 124
	ret


.global main
main:
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s1, 4(sp)

    addi    a1, zero, 7
    jal     initList	# ret a0 as head address 
	mv		s1, a0

	li		a1, 0
    jal     printList

    li	    a1, 2
	mv	    a0, s1
	call	removeNthFromEnd

	li		a1, 2
    jal     printList

	li	    a1, 4
	mv	    a0, s1
	call	removeNthFromEnd

	li		a1, 4
    jal     printList

	li	    a1, 1
	mv	    a0, s1
	call	removeNthFromEnd

	li		a1, 1
    jal     printList

    sw      s1, 4(sp)
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret