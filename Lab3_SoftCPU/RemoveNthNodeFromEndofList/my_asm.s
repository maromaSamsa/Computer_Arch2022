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
    sw      zero, 4(a0)         # head->next = NULL;
    mv      s2, a0              # head get address
    mv      s3, a0              # tmp get head address

loop_add_node:
    beq     s1, t0, end_initList
    addi    t0, t0, 1           # i++

    li      a0, 8
    call    malloc              # malloc newNode
    sw      t0, 0(a0)           # newNode->next = i
    sw      zero, 4(a0)         # head->next = NULL;

    sw      a0, 4(s3)           # tmp->next = newNode
    mv      s3, a0              # tmp = tmp->next

    j       loop_add_node
end_initList:
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

##	removeNthFromEnd(head, rm)
removeNthFromEnd:
	
end_removeNthFromEnd:
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

    sw      s1, 4(sp)
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret