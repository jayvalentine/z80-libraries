    .globl  _strcpy
    
    ; char * strcpy(char * s1, const char * s2)
_strcpy:
    ld      HL, #2
    add     HL, SP

    push    HL
    pop     IX

    ; s2 into HL
    ld      L, 0(IX)
    ld      H, 1(IX)

    ; s1 into DE
    ld      E, 2(IX)
    ld      D, 3(IX)

__strcpy_loop:
    ld      A, (HL)
    cp      #0
    jp      z, __strcpy_done

    ; Copy byte in A into DE.
    ld      (DE), A

    ; Increment both pointers.
    inc     DE
    inc     HL
    
    jp      __strcpy_loop

__strcpy_done:
    ; Don't forget the null-terminator! :)
    ld      A, #0
    ld      (DE), A
    
    ; Return value is s1.
    ; IX still points to the parameter region, so we can load off that.
    ld      L, 2(IX)
    ld      H, 3(IX)
    ret
