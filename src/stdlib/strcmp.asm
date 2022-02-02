    .globl  _strcmp

    ; int strcmp(const char *s1, const char *s2)
_strcmp:
    push    IX

    push    BC
    push    DE
    push    AF

    ; Skip over return address.
    ld      HL, #10
    add     HL, SP
    push    HL
    pop     IX

    ; Load s2 into DE (second param).
    ld      E, 2(IX)
    ld      D, 3(IX)

    ; Load s1 into HL (first param).
    ld      L, 0(IX)
    ld      H, 1(IX)

__strcmp_compare:
    ld      A, (DE)
    ld      C, (HL)
    cp      C

    ; If non-zero, the strings are different.
    jp      nz, __strcmp_neq

    ; Otherwise, if null they are equal.
    cp      #0
    jp      z, __strcmp_eq

    ; Not reached end of string, equal so far.
    ; Increment pointers and loop.
    inc     HL
    inc     DE
    jp      __strcmp_compare

__strcmp_eq:
    ld      HL, #0
    jp      __strcmp_done

__strcmp_neq:
    ld      HL, #1

__strcmp_done:
    pop     AF
    pop     DE
    pop     BC

    pop     IX
    ret
