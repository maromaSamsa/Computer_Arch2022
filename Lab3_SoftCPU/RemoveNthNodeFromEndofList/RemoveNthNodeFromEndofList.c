#include <stdlib.h>
#include <stdio.h>

struct ListNode {
      int val;
      struct ListNode *next;
 };

void printList(struct ListNode *head, int rm_msg){
    printf("[ ");
    while (head){
        printf("%d ", head->val);
        head = head->next;
    }
    if(rm_msg == 0){
    	printf("]\n"); 
    }else{
    	printf("] --> remove %d'th node from the end of list\n", rm_msg); 
    }
}

/*1 <= n <= 30*/
struct ListNode* initList(int n){
    struct ListNode* head = (struct ListNode*)malloc(sizeof(struct ListNode*));
    struct ListNode* tmp = head;
    head->val = 1;
    head->next = NULL;

    for(int i = 2; i<=n; ++i, tmp = tmp->next){
        struct ListNode* newNode = (struct ListNode*)malloc(sizeof(struct ListNode*));
        newNode->val = i;
        newNode->next = NULL;
        tmp->next = newNode;
    }
    return head;
}


struct ListNode* removeNthFromEnd(struct ListNode *head, int n){
    struct ListNode *table[30] = { [0 ... 29] = NULL };
    int len = 0;
    struct ListNode *iter = head;
    while(iter){
        table[len++] = iter;
        iter = iter->next;
    }

    if(n == len){
        return head->next;
    }else if(n > len || n < 0){
        printf("out of range ... NOP\n");
    }else{
        iter = table[len - n - 1];
        iter->next = iter->next->next;
    }
    return head;

}

int main(void){
    struct ListNode* head = initList(7);
    printList(head, 0);
    int rm = 2;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    rm = 4;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    rm = 1;
    head = removeNthFromEnd(head, rm);
    printList(head, rm);
    return 0;
}