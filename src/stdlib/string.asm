    PUBLIC  _strcmp
    PUBLIC  _strlen
    PUBLIC  _strchr
    PUBLIC  _strcpy

    PUBLIC  _memcpy
    PUBLIC  _memset
    
    ; int strcmp(const char *s1, const char *s2)
_strcmp:
    push    BC
    push    DE
    push    AF

    ; Skip over return address.
    ld      HL, 8
    add     HL, SP

    ; Load s2 into DE (second param).
    ld      E, (HL)
    inc     HL
    ld      D, (HL)
    inc     HL

    ; Load s1 into HL (first param).
    ld      C, (HL)
    inc     HL
    ld      B, (HL)

    ld      H, B
    ld      L, C

__strcmp_compare:
    ld      A, (DE)
    ld      C, (HL)
    cp      C

    ; If non-zero, the strings are different.
    jp      nz, __strcmp_neq

    ; Otherwise, if null they are equal.
    cp      0
    jp      z, __strcmp_eq

    ; Not reached end of string, equal so far.
    ; Increment pointers and loop.
    inc     HL
    inc     DE
    jp      __strcmp_compare

__strcmp_eq:
    ld      HL, 0
    jp      __strcmp_done

__strcmp_neq:
    ld      HL, 1

__strcmp_done:
    pop     AF
    pop     DE
    pop     BC
    ret

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

    ; char * strchr(const char * s, int c);
    ;
    ; Returns the first occurance of char c in s, or NULL if no occurance.
_strchr:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; (char)c into C. We discard the upper half.
    ld      C, (IX+0)
    
    ; s into HL.
    ld      L, (IX+2)
    ld      H, (IX+3)

__strchr_loop:
    ld      A, (HL)
    cp      C
    jp      z, __strchr_found

    cp      0
    jp      z, __strchr_end

    inc     HL
    jp      __strchr_loop

__strchr_found:
    ret

__strchr_end:
    ; Not found; return NULL.
    ld      HL, 0
    ret


    ; char * strcpy(char * s1, const char * s2)
_strcpy:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; s2 into HL
    ld      L, (IX+0)
    ld      H, (IX+1)

    ; s1 into DE
    ld      E, (IX+2)
    ld      D, (IX+3)

__strcpy_loop:
    ld      A, (HL)
    cp      0
    jp      z, __strcpy_done

    ; Copy byte in A into DE.
    ld      (DE), A

    ; Increment both pointers.
    inc     DE
    inc     HL
    
    jp      __strcpy_loop

__strcpy_done:
    ; Don't forget the null-terminator! :)
    ld      A, 0
    ld      (DE), A
    
    ; Return value is s1.
    ; IX still points to the parameter region, so we can load off that.
    ld      L, (IX+2)
    ld      H, (IX+3)
    ret

    ; void * memcpy(char * dest, const char * src, size_t n)
_memcpy:
    ld      HL, 2
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; src into HL
    ld      L, (IX+2)
    ld      H, (IX+3)

    ; dest into DE
    ld      E, (IX+4)
    ld      D, (IX+5)

    ; Do the copy.
    ldir

    ; Return value is dest.
    ld      L, (IX+4)
    ld      H, (IX+5)

    ret

    ; void * memset(void * s, int c, size_t n)
_memset:
    ld      HL, 2
    add     HL, SP

    ; Set IX to start of parameter region.
    push    HL
    pop     IX

    ; n into BC.
    ld      C, (IX+0)
    ld      B, (IX+1)

    ; c cast into unsigned char in E.
    ld      E, (IX+3)

    ; s into HL.
    ld      L, (IX+4)
    ld      H, (IX+5)

__memset_loop:
    ld      (HL), E
    inc     HL

    ; Decrement BC, loop if not 0.
    dec     BC
    ld      A, B
    or      C
    jp      nz, __memset_loop

__memset_done:
    ret
