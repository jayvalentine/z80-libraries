    .globl  _putchar
    
    ; putchar(int c)
    ;
    ; c will be in HL.
    ;
    ; NOT REENTRANT!
_putchar:
    ld      A, L
    ld      (__putchar_tempchar), A
    ld      HL, #__putchar_tempchar
    ld      DE, #1

    ld      A, #0
    rst     48
    
    ld      A, (__putchar_tempchar)
    ld      L, A
    ld      H, #0
    ret

__putchar_tempchar:
    .byte   0
