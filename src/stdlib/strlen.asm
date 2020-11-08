    PUBLIC  _strlen
    
    ; size_t strlen(const char * s) __z88dk_fastcall
_strlen:
    ; Parameter is in HL. Move into DE.
    ex      DE, HL

    ld      HL, 0
__strlen_loop:
    ; Check if null-terminator.
    ld      A, (DE)
    inc     DE
    cp      0
    jp      z, __strlen_done

    ; Not null-terminator, so increment HL and loop.
    inc     HL
    jp      __strlen_loop

__strlen_done:
    ret
