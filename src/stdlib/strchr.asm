    .globl  _strchr
    
    ; char * strchr(const char * s, int c);
    ;
    ; Returns the first occurance of char c in s, or NULL if no occurance.
_strchr:
    ld      HL, #2
    add     HL, SP

    push    HL
    pop     IX

    ; (char)c into C. We discard the upper half.
    ld      C, 0(IX)
    
    ; s into HL.
    ld      L, 2(IX)
    ld      H, 3(IX)

__strchr_loop:
    ld      A, (HL)
    cp      C
    jp      z, __strchr_found

    cp      #0
    jp      z, __strchr_end

    inc     HL
    jp      __strchr_loop

__strchr_found:
    ret

__strchr_end:
    ; Not found; return NULL.
    ld      HL, #0
    ret
