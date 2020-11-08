    PUBLIC  _strtok
    
    ; char * strtok(char * s1, const char * s2)
    ;
    ; A sequence of calls to strtok() breaks the string pointed
    ; to by s1 into a sequence of tokens, each of which is delimited
    ; by a byte from the string pointed to by s2.
    ;
    ; The first call in the sequence has s1 as its first argument,
    ; and is followed by calls with a null pointer as the first argument.
_strtok:
    ld      HL, 2
    add     HL, SP

    push    HL
    pop     IX

    ; s2 into DE
    ld      E, (IX+0)
    ld      D, (IX+1)

    ; s1 into HL
    ld      L, (IX+2)
    ld      H, (IX+3)

    ; Is HL NULL (0)? If so, load the saved pointer instead.
    ld      A, L
    or      H
    jp      nz, __strtok_find_start

    ; Load saved pointer into HL.
    ld      HL, (__strtok_saved_ptr)

    ; Find first character in s1 that is not in s2.
__strtok_find_start:
    ld      A, (HL)
    inc     HL

    ; If we hit a null, we've reached the end of the string
    ; without finding a token.
    cp      0
    jp      z, __strtok_done_notok

    ; Is this a separator character?
    ld      B, A
    call    __strtok_is_sep

    ; Keep searching until we hit a character not in the string.
    cp      0
    jp      nz, __strtok_find_start

    ; If we hit this point, we've found a non-separator
    ; character. Save HL for later use.
    ;
    ; HL will point to the character _after_ the first
    ; in the token, so we need to decrement it first.
    dec     HL
    push    HL

__strtok_find_end:
    ld      A, (HL)
    inc     HL

    ; If we hit a null, we've found a token, in HL.
    ; We don't need to place a null terminator because
    ; it's already here.
    cp      0
    jp      z, __strtok_done_tok_null

    ; Is this a separator?
    ld      B, A
    call    __strtok_is_sep

    ; Keep searching until we hit a character that is a separator.
    cp      1
    jp      nz, __strtok_find_end

    ; If we hit this point, we've found a separator,
    ; and HL points to the byte _after_ that separator.
    ;
    ; Set a null-terminator at this point, then
    ; store the current value of HL for the next call.
__strtok_done_tok:
    dec     HL
    ld      A, 0
    ld      (HL), A
    inc     HL

    ld      (__strtok_saved_ptr), HL

    ; Return token start, which is on stack.
    pop     HL
    ret

    ; We've reached the end of the string.
    ; Set the saved pointer to point to the null-terminator
    ; and return the token on the top of the stack.
__strtok_done_tok_null:
    dec     HL
    ld      (__strtok_saved_ptr), HL

    pop     HL
    ret

__strtok_done_notok:
    ; Return null.
    ld      HL, 0
    ret

    ; Helper function.
    ; Returns 0 if character in B is not in the string
    ; pointed to by DE, otherwise returns 1.
__strtok_is_sep:
    push    DE

__strtok_is_sep_loop:
    ld      A, (DE)
    inc     DE

    ; We've hit null, so we've searched the string and not
    ; found a match.
    cp      0
    jp      z, __strtok_is_sep_done

    ; Compare to B.
    ; If equal we've found a match, otherwise keep searching.
    cp      B
    jp      nz, __strtok_is_sep_loop

    ; Return 1 because we've found a match.
    ld      A, 1

__strtok_is_sep_done:
    pop     DE
    ret

__strtok_saved_ptr:
    defs    2
