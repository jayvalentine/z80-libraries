    .globl  _puts

    .globl  _strlen

    ; String pointer in HL.
_puts:
    push    HL

    ; Get string length in DE.
    call    _strlen

    pop     BC ; String pointer.

    ; Write to serial port.
    ; BC - string pointer
    ; DE - length
    ld      A, #0
    rst     48

    ; Successful, return 0.
    ld      DE, #0
    ret
