    PUBLIC  _memcpy
    
    ; void * memcpy(char * dest, const char * src, size_t n)
_memcpy:
    ld      HL, 2
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; src into HL
    ld      L, (IX+2)
    ld      H, (IX+3)

    ; dest into DE
    ld      E, (IX+4)
    ld      D, (IX+5)

    ; Do the copy.
    ldir

    ; Return value is dest.
    ld      L, (IX+4)
    ld      H, (IX+5)

    ret
