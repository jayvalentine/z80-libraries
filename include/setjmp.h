#ifndef _SETJMP_H
#define _SETJMP_H

#include <stdint.h>

typedef struct _SETJMP_ENV
{
    uint16_t address;

    uint16_t af;
    uint16_t bc;
    uint16_t de;
    uint16_t hl;

    uint16_t ix;
    uint16_t iy;

    uint16_t sp;
} jmp_buf;

int _setjmp(jmp_buf * env);

#define setjmp(env) _setjmp(&env)

#endif /* _SETJMP_H */
