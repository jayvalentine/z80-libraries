    PUBLIC  _putchar

    ; Syscall macro.
define(zsys, `ld      A, $1 << 1
    rst     48')

    defc    SWRITE = 0
    defc    SREAD  = 1
    
_putchar:
    push    AF
    push    BC
    push    DE
    push    HL

    ld      HL, SP
    push    HL
    pop     DE
    
    ; Writing single byte.
    ld      BC, 1

    zsys(SWRITE)
    
    pop     HL
    pop     DE
    pop     BC
    pop     AF
    ret