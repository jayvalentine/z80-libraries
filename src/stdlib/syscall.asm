    ; Wrappers for OS syscalls.
    
    .globl  _syscall_dwrite
    .globl  _syscall_dread
    .globl  _syscall_fopen
    .globl  _syscall_fread
    .globl  _syscall_fwrite
    .globl  _syscall_fclose
    .globl  _syscall_dinfo
    .globl  _syscall_finfo
    .globl  _syscall_fentries
    .globl  _syscall_fentry
    .globl  _syscall_pspawn
    .globl  _syscall_sighandle
    .globl  _syscall_fdelete
    .globl  _syscall_pload
    .globl  _syscall_smode
    .globl  _syscall_sysinfo
    .globl  _syscall_pstate
    .globl  _syscall_pexit
    .globl  _syscall_pexitcode
    .globl  _syscall_pblock

    .equ    DWRITE, 4
    .equ    DREAD, 6

    .equ    FOPEN, 8
    .equ    FREAD, 10
    .equ    FWRITE, 12
    .equ    FCLOSE, 14

    .equ    DINFO, 16
    .equ    FINFO, 18
    .equ    FENTRIES, 20
    .equ    FENTRY, 22

    .equ    PSPAWN, 24

    .equ    SIGHANDLE, 26

    .equ    FDELETE, 28

    .equ    PLOAD, 30

    .equ    SMODE, 32

    .equ    SYSINFO, 34

    .equ    PSTATE, 36
    .equ    PEXIT, 38
    .equ    PEXITCODE, 40
    .equ    PBLOCK, 42

    ; void syscall_smode(uint8_t mode)
_syscall_smode:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    ; Mode in C.
    ld      C, (HL)

    ld      A, #SMODE
    rst     48

    pop     IX

    ret

    ; void syscall_dwrite(char * buf, #uint32_t sector)
_syscall_dwrite:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; Sector number, #little-endian.
    ; Lowest 16 bytes is at the top of the stack.
    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)

    ; Pointer to write buffer.
    ld      L, 4(IX)
    ld      H, 5(IX)

    ; Call dwrite syscall.
    ld      A, #DWRITE
    rst     48

    pop     IX

    ret

    ; void syscall_dread(char * buf, #uint32_t sector)
_syscall_dread:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; Sector number, #little-endian.
    ; Lowest 16 bytes is at the top of the stack.
    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)

    ; Pointer to read buffer.
    ld      L, 4(IX)
    ld      H, 5(IX)

    ; Call dread syscall.
    ld      A, #DREAD
    rst     48

    pop     IX

    ret

    ; DiskInfo_T * syscall_dinfo(void)
_syscall_dinfo:
    push    IX

    ; Call dinfo syscall.
    ld      A, #DINFO
    rst     48

    pop     IX

    ret

    ; int syscall_fopen(const char * filename, #uint8_t mode)
_syscall_fopen:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; mode in E.
    ld      E, 2(IX)

    ; filename in BC
    ld      C, 0(IX)
    ld      B, 1(IX)

    ; fopen syscall.
    ld      A, #FOPEN
    rst     48

    pop     IX
    ret

    ; size_t syscall_fread(char * ptr, #size_t n, #int fd)
_syscall_fread:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; ptr in BC
    ld      C, 0(IX)
    ld      B, 1(IX)

    ; n in DE
    ld      E, 2(IX)
    ld      D, 3(IX)

    ; fd in HL
    ld      L, 4(IX)
    ld      H, 5(IX)

    ; fread syscall.
    ld      A, #FREAD
    rst     48

    pop     IX
    ret

    ; size_t syscall_fwrite(char * ptr, #size_t n, #int fd)
_syscall_fwrite:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; ptr in BC
    ld      C, 0(IX)
    ld      B, 1(IX)

    ; n in DE
    ld      E, 2(IX)
    ld      D, 3(IX)

    ; fd in HL
    ld      L, 4(IX)
    ld      H, 5(IX)

    ; fwrite syscall.
    ld      A, #FWRITE
    rst     48

    pop     IX
    ret

    ; void syscall_fclose(int fd)
_syscall_fclose:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #FCLOSE
    rst     48

    pop     IX

    ret

    ; int syscall_finfo(const char * filename, #FINFO * finfo)
_syscall_finfo:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)

    ld      A, #FINFO
    rst     48

    pop     IX

    ret

    ; int syscall_fentries(void)
_syscall_fentries:
    push    IX

    ld      A, #FENTRIES
    rst     48

    pop     IX

    ret

    ; int syscall_fentry(char * s, int entry)
_syscall_fentry:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)

    ld      A, #FENTRY
    rst     48
    
    pop     IX

    ret

    ; int syscall_pspawn(int pd, char ** argv, size_t argc)
_syscall_pspawn:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)
    ld      L, 4(IX)
    ld      H, 5(IX)

    ld      A, #PSPAWN
    rst     48
    
    pop     IX
    ret

    ; void syscall_sighandle(SIGHANDLE_T handle, #int sig)
_syscall_sighandle:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)
    ld      E, 2(IX)
    ld      D, 3(IX)

    ld      A, #SIGHANDLE
    rst     48

    pop     IX
    ret

    ; void syscall_fdelete(const char * filename)
_syscall_fdelete:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #FDELETE
    rst     48

    pop     IX
    ret

    ; int syscall_pload(const char * filename)
_syscall_pload:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #PLOAD
    rst     48

    pop     IX
    ret

    ; const SysInfo_T * syscall_sysinfo(void)
_syscall_sysinfo:
    ld      A, #SYSINFO
    rst     48

    ret

    ; int syscall_pstate(int pid)
_syscall_pstate:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #PSTATE
    rst     48

    pop     IX
    ret

    ; void syscall_pexit(int pid)
_syscall_pexit:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #PEXIT
    rst     48

    pop     IX
    ret

    ; int syscall_pexitcode(int pid)
_syscall_pexitcode:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #PEXITCODE
    rst     48

    pop     IX
    ret

    ; void syscall_pblock(int event)
_syscall_pblock:
    push    IX

    ; Get parameters. Skip return value and IX on stack.
    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ld      C, 0(IX)
    ld      B, 1(IX)

    ld      A, #PBLOCK
    rst     48

    pop     IX
    ret