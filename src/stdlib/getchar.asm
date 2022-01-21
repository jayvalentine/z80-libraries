    public  _getchar

    ; Syscall macro.
define(zsys, `ld      A, $1 << 1
    rst     48')

    defc    SREAD  = 1
    
    _getchar:
    push    AF
    zsys(SREAD)
    ld      H, 0
    ld      L, A
    pop     AF
    ret