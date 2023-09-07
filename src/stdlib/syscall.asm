    ; Wrappers for OS syscalls.
    
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
    ; TODO: Calling convention uses A!
_syscall_smode:
    ld      A, #SMODE
    jp     48

    ; DiskInfo_T * syscall_dinfo(void)
_syscall_dinfo:
    ; Call dinfo syscall.
    ld      A, #DINFO
    jp      48

    ; int syscall_fopen(const char * filename, #uint8_t mode)
_syscall_fopen:
    ; fopen syscall.
    ld      A, #FOPEN
    jp      48

    ; size_t syscall_fread(char * ptr, #size_t n, #int fd)
_syscall_fread:
    ; fread syscall.
    ld      A, #FREAD
    jp      48

    ; size_t syscall_fwrite(char * ptr, #size_t n, #int fd)
_syscall_fwrite:
    ; fwrite syscall.
    ld      A, #FWRITE
    jp      48

    ; void syscall_fclose(int fd)
_syscall_fclose:
    ld      A, #FCLOSE
    jp      48

    ; int syscall_finfo(const char * filename, #FINFO * finfo)
_syscall_finfo:
    ld      A, #FINFO
    jp      48

    ; int syscall_fentries(void)
_syscall_fentries:
    ld      A, #FENTRIES
    jp      48

    ; int syscall_fentry(char * s, int entry)
_syscall_fentry:
    ld      A, #FENTRY
    jp      48

    ; int syscall_pspawn(int pd, char ** argv, size_t argc)
_syscall_pspawn:
    ld      A, #PSPAWN
    jp      48

    ; void syscall_sighandle(SIGHANDLE_T handle, #int sig)
_syscall_sighandle:
    ld      A, #SIGHANDLE
    jp      48

    ; void syscall_fdelete(const char * filename)
_syscall_fdelete:
    ld      A, #FDELETE
    jp      48

    ; int syscall_pload(const char * filename)
_syscall_pload:
    ld      A, #PLOAD
    jp      48

    ; const SysInfo_T * syscall_sysinfo(void)
_syscall_sysinfo:
    ld      A, #SYSINFO
    jp      48

    ; int syscall_pstate(int pid)
_syscall_pstate:
    ld      A, #PSTATE
    jp      48

    ; void syscall_pexit(int pid)
_syscall_pexit:
    ld      A, #PEXIT
    jp      48

    ; int syscall_pexitcode(int pid)
_syscall_pexitcode:
    ld      A, #PEXITCODE
    jp      48

    ; void syscall_pblock(int event)
_syscall_pblock:
    ld      A, #PBLOCK
    jp      48
