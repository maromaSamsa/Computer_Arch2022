int numJewelsInStones(char * jewels, char * stones){
    int ans = 0;
    char *currStones = stones;
    while(*jewels != '\0'){
        while(*currStones != '\0'){
            if(*jewels == *currStones){
                ++ans;
            }
            ++currStones;
        }
        ++jewels;
        currStones = stones;
    }
    return ans;
}
