#include <stdint.h>

#define Q (8)

/* format convertion: float to Q format */
#define f2Q(x) ((int32_t)(x*(1<<Q)))

/* format convertion: Q format to float */
#define Q2f(x) (((float)(x))/(1<<Q))

typedef int32_t q_fmt;
typedef int64_t q_buf;
#define QFMT_MAX 0x7FFFFFFF
#define QFMT_MIN 0x80000000


/* addition of Q format value*/
static inline q_fmt q_add(q_fmt a, q_fmt b){
    return a + b;
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
    char round = (tmp >> (Q*2-3)) & 0b111;
    if(round >= 5){
        tmp += (q_buf)(1<<Q*2);
    }
    // check overflow
    if(tmp > (q_buf)QFMT_MAX) return (q_fmt)QFMT_MAX;
    if(tmp * -1 >= (q_buf)QFMT_MIN) return (q_fmt)QFMT_MIN;
    return (q_fmt)tmp;
}

/* division of Q format value, no support rounding for now*/
static inline q_fmt q_div(q_fmt a, q_fmt b){
    q_buf tmp = (q_buf)a << Q;
    return (q_fmt)(tmp / b);
}

