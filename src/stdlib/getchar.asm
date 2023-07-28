    .globl  _getchar

_getchar:
    push    AF
    push    IX
    ld      A, #2
    rst     48
    ld      H, #0
    ld      L, A
    pop     IX
    pop     AF
    ret
