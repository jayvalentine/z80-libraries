    ; Wrappers for OS syscalls.
    
    PUBLIC  _syscall_dwrite
    PUBLIC  _syscall_dread
    PUBLIC  _syscall_fopen
    PUBLIC  _syscall_fread
    PUBLIC  _syscall_fwrite
    PUBLIC  _syscall_fclose
    PUBLIC  _syscall_dinfo
    PUBLIC  _syscall_finfo
    PUBLIC  _syscall_fentries
    PUBLIC  _syscall_fentry
    PUBLIC  _syscall_pexec
    PUBLIC  _syscall_sighandle

    defc    DWRITE = 4
    defc    DREAD = 6

    defc    FOPEN = 8
    defc    FREAD = 10
    defc    FWRITE = 12
    defc    FCLOSE = 14

    defc    DINFO = 16
    defc    FINFO = 18
    defc    FENTRIES = 20
    defc    FENTRY = 22

    defc    PEXEC = 24

    defc    SIGHANDLE = 26

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

    ; DiskInfo_T * syscall_dinfo(void)
_syscall_dinfo:
    ; Call dinfo syscall.
    ld      A, DINFO
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

    ; filename in DE
    ld      E, (IX+2)
    ld      D, (IX+3)

    ; fopen syscall.
    ld      A, FOPEN
    rst     48

    ret

    ; size_t syscall_fread(char * ptr, size_t n, int fd)
_syscall_fread:
    ; Get parameters
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; fd in BC
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; n in DE
    ld      E, (IX+2)
    ld      D, (IX+3)

    ; ptr in HL
    ld      L, (IX+4)
    ld      H, (IX+5)

    ; fread syscall.
    ld      A, FREAD
    rst     48

    ret

    ; size_t syscall_fwrite(char * ptr, size_t n, int fd)
_syscall_fwrite:
    ; Get parameters
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; fd in BC
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; n in DE
    ld      E, (IX+2)
    ld      D, (IX+3)

    ; ptr in HL
    ld      L, (IX+4)
    ld      H, (IX+5)

    ; fwrite syscall.
    ld      A, FWRITE
    rst     48

    ret

    ; void syscall_fclose(int fd)
_syscall_fclose:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ld      C, (IX+0)
    ld      B, (IX+1)

    ld      A, FCLOSE
    rst     48

    ret

    ; int syscall_finfo(const char * filename, FINFO * finfo)
_syscall_finfo:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ld      A, FINFO
    rst     48

    ret

    ; int syscall_fentries(void)
_syscall_fentries:
    ld      A, FENTRIES
    rst     48
    ret

    ; int syscall_fentry(char * s, int entry)
_syscall_fentry:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ld      A, FENTRY
    rst     48
    
    ret

    ; int syscall_pexec(char ** argv, size_t argc)
_syscall_pexec:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ld      A, PEXEC
    rst     48
    
    ret

    ; void syscall_sighandle(SIGHANDLE_T handle, int sig)
_syscall_sighandle:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ld      C, (IX+0)
    ld      B, (IX+1)
    ld      E, (IX+2)
    ld      D, (IX+3)

    ld      A, SIGHANDLE
    rst     48

    ret
