    .globl  _putchar

    .macro  zsys
    ld      A, #(1 << \1)
    rst     48
    .endm

    .equ    SWRITE, 0
    .equ    SREAD, 1
    
_putchar:
    push    AF
    push    BC
    push    DE
    push    HL

    ld      HL, #0
    add     HL, SP
    push    HL
    pop     DE
    
    ; Writing single byte.
    ld      BC, #1

    zsys    SWRITE
    
    pop     HL
    pop     DE
    pop     BC
    pop     AF
    ret