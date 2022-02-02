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
    push    IX

    ld      HL, #4
    add     HL, SP
    push    HL
    pop     IX

    ld      L, 0(IX)
    ld      H, 1(IX)

    ; Get string length.
    push    HL
    call    _strlen

    ; Move length into BC.
    push    HL
    pop     DE

    pop     BC ; String pointer.

    ; Write to serial port.
    ; DE - string pointer
    ; BC - length
    zsys    SWRITE

    ; Successful, return 0.
    ld      HL, #0
    pop     IX
    ret
