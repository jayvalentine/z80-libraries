    .globl  _putchar

    .macro  zsys
    ld      A, #(1 << \1)
    rst     48
    .endm

    .equ    SWRITE, 0
    .equ    SREAD, 1
    
_putchar:
    push    IX

    ld      HL, #4
    add     HL, SP
    push    HL

    ; Address of byte to write on stack.
    pop     BC
    
    ; Writing single byte.
    ld      DE, #1

    zsys    SWRITE
    
    pop     IX
    ret
