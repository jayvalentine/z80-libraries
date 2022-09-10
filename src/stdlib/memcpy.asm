    .globl  _memcpy
    
    ; void * memcpy(char * dest, const char * src, size_t n)
_memcpy:
    push    IX

    ld      HL, #4
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC
    ld      C, 4(IX)
    ld      B, 5(IX)

    ; src into HL
    ld      L, 2(IX)
    ld      H, 3(IX)

    ; dest into DE
    ld      E, 0(IX)
    ld      D, 1(IX)

    ; Do the copy.
    ldir

    ; Return value is dest.
    ld      L, 0(IX)
    ld      H, 1(IX)

    pop     IX
    ret
