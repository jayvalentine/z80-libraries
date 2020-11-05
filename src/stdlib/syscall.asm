    ; Wrappers for OS syscalls.
    
    PUBLIC  _syscall_dwrite
    PUBLIC  _syscall_dread
    PUBLIC  _syscall_fopen

    defc    DWRITE = 4
    defc    DREAD = 6

    defc    FOPEN = 8
    defc    FREAD = 10
    defc    FCLOSE = 12

    ; void syscall_dwrite(char * buf, uint32_t sector)
_syscall_dwrite:
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

    ; void syscall_dread(char * buf, uint32_t sector)
_syscall_dread:
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

    ; int syscall_fopen(const char * filename, uint8_t mode)
_syscall_fopen:
    ; Get parameters.
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; mode in C.
    ld      C, (IX+0)

    ; filename in HL
    ld      L, (IX+2)
    ld      H, (IX+3)

    ; fopen syscall.
    ld      A, FOPEN
    rst     48

    ret
