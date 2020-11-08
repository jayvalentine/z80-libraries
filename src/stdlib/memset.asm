    PUBLIC  _memset
    
    ; void * memset(void * s, int c, size_t n)
_memset:
    ld      HL, 2
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC.
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; c cast into unsigned char in E.
    ld      E, (IX+3)

    ; s into HL.
    ld      L, (IX+4)
    ld      H, (IX+5)

__memset_loop:
    ld      (HL), E
    inc     HL

    ; Decrement BC, loop if not 0.
    dec     BC
    ld      A, B
    or      C
    jp      nz, __memset_loop

__memset_done:
    ret
