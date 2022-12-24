#include <stdint.h>

#define Q (8)
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

/* addition of Q format value, also check overflow*/
static inline q_fmt q_add_sat(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a + (q_buf)b;
    if(tmp > (q_buf)QFMT_MAX) return (q_fmt)QFMT_MAX;
    if(tmp * -1 >= (q_buf)QFMT_MIN) return (q_fmt)QFMT_MIN;
    return (q_fmt)tmp;
};

/* multiplication of Q format value */
static inline q_fmt q_mul(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a * (q_buf)b;

    // rounding
    tmp += (q_buf)(1<<(Q-1));
    
    // check overflow
    if(tmp > (q_buf)QFMT_MAX) return (q_fmt)QFMT_MAX;
    if(tmp * -1 >= (q_buf)QFMT_MIN) return (q_fmt)QFMT_MIN;
    return (q_fmt)tmp >> Q;
}

/* division of Q format value, no support rounding for now */
static inline q_fmt q_div(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a << Q;
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

