    .globl  _memset
    
    ; void * memset(void * s, int c, size_t n)
_memset:
    push    IX

    ld      HL, #4
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC.
    ld      C, 4(IX)
    ld      B, 5(IX)

    ; c cast into unsigned char in E.
    ld      E, 2(IX)

    ; s into HL.
    ld      L, 0(IX)
    ld      H, 1(IX)

__memset_loop:
    ld      (HL), E
    inc     HL

    ; Decrement BC, loop if not 0.
    dec     BC
    ld      A, B
    or      C
    jp      nz, __memset_loop

__memset_done:
    pop     IX
    ret
