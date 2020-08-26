    PUBLIC  strcmp
    
    ; int strcmp(const char *s1, const char *s2)
strcmp:
    push    BC
    push    DE
    push    AF

    ; Skip over return address.
    ld      HL, 8
    add     HL, SP

    ; Load s2 into DE (second param).
    ld      E, (HL)
    inc     HL
    ld      D, (HL)
    inc     HL

    ; Load s1 into HL (first param).
    ld      C, (HL)
    inc     HL
    ld      B, (HL)

    ld      H, B
    ld      L, C

_strcmp_compare:
    ld      A, (DE)
    ld      C, (HL)
    cp      C

    ; If non-zero, the strings are different.
    jp      nz, _strcmp_neq

    ; Otherwise, if null they are equal.
    cp      0
    jp      z, _strcmp_eq

    ; Not reached end of string, equal so far.
    ; Increment pointers and loop.
    inc     HL
    inc     DE
    jp      _strcmp_compare

_strcmp_eq:
    ld      HL, 0
    jp      _strcmp_done

_strcmp_neq:
    ld      HL, 1

_strcmp_done:
    pop     AF
    pop     DE
    pop     BC
    ret
