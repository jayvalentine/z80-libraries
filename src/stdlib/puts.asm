    .globl  _puts

    .globl  _putchar
    
    .macro  zsys
    ld      A, #(1 << \1)
    rst     48
    .endm

    .equ    SWRITE, 0
    .equ    SREAD,  1

    .globl  _strlen

_puts:
    push    HL

    ; Get string length (in HL).
    call    _strlen

    ; Move length into BC.
    push    HL
    pop     BC

    pop     DE ; String pointer.

    ; Write to serial port.
    ; DE - string pointer
    ; BC - length
    zsys    SWRITE

    ; Successful, return 0.
    ld      HL, #0
    ret
