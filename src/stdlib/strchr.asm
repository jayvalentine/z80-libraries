    .globl  _strchr
    
    ; char * strchr(const char * s, int c);
    ;
    ; Returns the first occurance of char c in s, or NULL if no occurance.
_strchr:
    push    IX

    ld      HL, #4
    add     HL, SP

    push    HL
    pop     IX

    ; (char)c into C. We discard the upper half.
    ld      C, 2(IX)
    
    ; s into HL.
    ld      L, 0(IX)
    ld      H, 1(IX)

__strchr_loop:
    ld      A, (HL)
    cp      C
    jp      z, __strchr_found

    cp      #0
    jp      z, __strchr_end

    inc     HL
    jp      __strchr_loop

__strchr_found:
    pop     IX
    ret

__strchr_end:
    ; Not found; return NULL.
    ld      HL, #0
    pop     IX
    ret
