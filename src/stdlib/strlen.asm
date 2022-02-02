    .globl  _strlen
    
    ; size_t strlen(const char * s)
_strlen:
    push    IX

    ld      HL, #2
    add     HL, SP
    push    HL
    pop     IX

    ; Get string length into DE.
    ld      E, 0(IX)
    ld      D, 1(IX)

    ld      HL, #0
__strlen_loop:
    ; Check if null-terminator.
    ld      A, (DE)
    inc     DE
    cp      #0
    jp      z, __strlen_done

    ; Not null-terminator, so increment HL and loop.
    inc     HL
    jp      __strlen_loop

__strlen_done:
    pop     IX
    ret
