    .globl  _putchar
    
    ; putchar(int c)
    ;
    ; c will be in HL.
    ;
    ; NOT REENTRANT!
_putchar:
    ld      (__putchar_tempchar), HL
    ld      HL, #__putchar_tempchar
    ld      DE, #1

    ld      A, #0
    rst     48
    
    ret

__putchar_tempchar:
    .byte   0
