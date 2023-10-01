    .globl  _getchar

    ; int getchar(void);
_getchar:
    ld      A, #2
    rst     48

    ; sread syscall returns -1 if no character available.
    ld      A, D
    cp      #0xff
    jp      z, _getchar

    ; otherwise returned character is in DE.
    ret
