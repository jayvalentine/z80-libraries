    .globl  _getchar

_getchar:
    push    AF
    push    IX
    ld      A, #2
    rst     48
    ld      D, #0
    ld      E, A
    pop     IX
    pop     AF
    ret
