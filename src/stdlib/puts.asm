    .globl  _puts

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
    ld      A, #0
    rst     48

    ; Successful, return 0.
    ld      HL, #0
    pop     IX
    ret
