    .globl  _strcmp

    ; int strcmp(const char *s1, const char *s2)
_strcmp:
    push    BC
    push    DE
    push    AF

    ; Skip over return address.
    ld      HL, #8
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
    ret
