    .globl  _putchar

    ; Syscall macro.
define(zsys, `ld      A, #(0x1 << 1)
    rst     48')

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

    zsys(SWRITE)
    
    pop     HL
    pop     DE
    pop     BC
    pop     AF
    ret