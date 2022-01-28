    .globl  _memcpy
    
    ; void * memcpy(char * dest, const char * src, size_t n)
_memcpy:
    ld      HL, #2
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC
    ld      C, 0(IX)
    ld      B, 1(IX)

    ; src into HL
    ld      L, 2(IX)
    ld      H, 3(IX)

    ; dest into DE
    ld      E, 4(IX)
    ld      D, 5(IX)

    ; Do the copy.
    ldir

    ; Return value is dest.
    ld      L, 4(IX)
    ld      H, 5(IX)

    ret
