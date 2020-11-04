    ; Wrappers for OS syscalls.
    
    PUBLIC  _dwrite
    PUBLIC  _dread

    defc    DWRITE = 4
    defc    DREAD = 6

    ; void dwrite(char * buf, uint32_t sector)
_dwrite:
    ; Get parameters.
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; Sector number, little-endian.
    ; Lowest 16 bytes is at the top of the stack.
    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ; Pointer to write buffer.
    ld      L, (IX+4)
    ld      H, (IX+5)

    ; Call dwrite syscall.
    ld      A, DWRITE
    rst     48

    ret

    ; void dread(char * buf, uint32_t sector)
_dread:
    ; Get parameters.
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; Sector number, little-endian.
    ; Lowest 16 bytes is at the top of the stack.
    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ; Pointer to read buffer.
    ld      L, (IX+4)
    ld      H, (IX+5)

    ; Call dread syscall.
    ld      A, DREAD
    rst     48

    ret
