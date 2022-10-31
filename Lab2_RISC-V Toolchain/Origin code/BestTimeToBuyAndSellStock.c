#include<stdio.h>

int maxProfit(int *prices, int pricesSize)
{
    int i, temp = prices[0], target = 0;
    for (i = 1; i < pricesSize; i++) 
    {
        if (prices[i] > temp) {
            target = (prices[i] - temp > target) ? (prices[i] - temp) : target;
        } else
            temp = prices[i];
    }
    return target;
}

int main(){
	int prices_1[5] = {7,6,4,3,1};
	int prices_2[6] = {7,1,5,3,6,4};
	int prices_3[4] = {1,1,8,2};
	int pricesSize_1 = 5;
	int pricesSize_2 = 6;
	int pricesSize_3 = 4;
	printf("%d\n", maxProfit(prices_1,pricesSize_1));
	printf("%d\n", maxProfit(prices_2,pricesSize_2));
	printf("%d\n", maxProfit(prices_3,pricesSize_3));
	return 0;
}
