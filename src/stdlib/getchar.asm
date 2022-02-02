    .globl  _getchar

_getchar:
    push    AF
    ld      A, #2
    rst     48
    ld      H, #0
    ld      L, A
    pop     AF
    ret
