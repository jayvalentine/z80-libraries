    .globl  _puts

    .globl  _strlen

    ; String pointer in HL.
_puts:
    push    HL

    ; Get string length in DE.
    call    _strlen

    pop     HL ; String pointer.

    ; Write to serial port.
    ; HL - string pointer
    ; DE - length
    ld      A, #0
    rst     48

    ; Successful, return 0.
    ld      DE, #0
    ret
