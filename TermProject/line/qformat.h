#include <stdint.h>

#define Q (10)
#define PI_Q (1686629713>>(29-Q))

typedef int32_t q_fmt;
typedef int64_t q_buf;

/* format convertion: float to Q format */
#define f2Q(x) ((q_fmt)((x)*(1<<Q)))

/* format convertion: Q format to float */
#define Q2f(x) (((float)(x))/(1<<Q))

/* format convertion: Q format to int */
#define Q2I(x) ((int)((x) >> Q))

/* format convertion: int format to Q */
#define I2Q(x) ((q_fmt)((x) << Q))

#define QFMT_MAX 0x7FFFFFFF
#define QFMT_MIN 0x80000000


/* addition of Q format value*/
static inline q_fmt q_add(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a + (q_buf)b;
    if(tmp > (q_buf)QFMT_MAX) return (q_fmt)QFMT_MAX;
    if(tmp * -1 >= (q_buf)QFMT_MIN) return (q_fmt)QFMT_MIN;
    return (q_fmt)tmp;
};

/* multiplication of Q format value */
static inline q_fmt q_mul(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a * (q_buf)b;

    // rounding and resize
    tmp += (q_buf)(1<<(Q-1));
    tmp >>= Q;
    
    // check overflow
    if(tmp > (q_buf)QFMT_MAX) return (q_fmt)QFMT_MAX;
    if(tmp * -1 >= (q_buf)QFMT_MIN) return (q_fmt)QFMT_MIN;
    return (q_fmt)tmp;
}

/* division of Q format value */
static inline q_fmt q_div(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a << Q;
    if ((tmp >= 0 && b >= 0) || (tmp < 0 && b < 0)) {   
        tmp += (b >> 1);  
    } else {
        tmp -= (b >> 1);
    }
    return (q_fmt)(tmp / b);
}

/* return the largest integral value that is not greater than x */
static inline q_fmt floorq(q_fmt x){
    q_fmt mask = (0xFFFFFFFF >> Q) << Q;
    q_fmt delta = x & ~mask;
    return x & mask;
}

/* return the smallest integral value that is not less than x */
static inline q_fmt ceilq(q_fmt x){
    q_fmt mask = (0xFFFFFFFF >> Q) << Q;
    q_fmt delta = x & ~mask;
    x = x & mask;
    return delta? q_add(x, 1<<Q): x;
}

/* return the nonnegative square root of x */
static inline q_fmt sqrtq(q_fmt x){
    if(x <= 0) return 0;
    q_fmt res = 0;
    q_fmt bit = 1<<15;

    int offset = 0;
    for(q_fmt i = x; !(0x40000000 & i); i <<= 1){
        ++offset;
    }
    offset = (offset & ~1);
    x <<= offset;

    // shift bit to the highest bit 1' in x
    while(bit > x){
        bit >>= 1;
    }

    for(bit; bit > 0; bit >>= 1){
        int tmp = bit + res;
        // check overflow: 46341^2 > 2^31 - 1, which is the maximun value
        if(tmp > 46340) continue; 
        int square = tmp*tmp;
        if(square <= x){
            res = tmp;
            if(square == x) break;
        }
        // iter: goto next lower bit to get more precise sqrt value
    }
    offset >>= 1;
    offset -= (Q >> 1);
    return (offset >= 0)? res >> offset : res << (-offset) ;
}

