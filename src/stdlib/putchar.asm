    .globl  _putchar
    
_putchar:
    push    IX

    ld      HL, #4
    add     HL, SP
    push    HL

    ; Address of byte to write on stack.
    pop     BC
    
    ; Writing single byte.
    ld      DE, #1

    ld      A, #0
    rst     48
    
    pop     IX
    ret
