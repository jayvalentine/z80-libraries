    ; Implementation of stdio portion of standard library.

    PUBLIC  _puts
    PUBLIC  _gets
    PUBLIC  _putchar
    PUBLIC  _getchar
    PUBLIC  _printf

    ; Syscall macro.
define(zsys, `ld      A, $1 << 1
    rst     48')

    defc    SWRITE = 0
    defc    SREAD  = 1

_puts:
    push    HL
    pop     DE

__puts_loop:
    ; src in DE.
    ld      A, (DE)
    inc     DE
    cp      0
    jp      z, __puts_done

    ; Not null, print to serial port.
    ld      L, A
    zsys(SWRITE)

    ; Loop.
    jp      __puts_loop

__puts_done:
    ; Successful, return 0.
    ld      HL, 0
    ret

_putchar:
    push    AF

    ; Character to send is in HL.
    ; Because it's a character, we can ignore H.
    zsys(SWRITE)
    
    pop     AF
    ret

_getchar:
    push    AF
    zsys(SREAD)
    ld      H, 0
    ld      L, A
    pop     AF
    ret

_gets:
    push    HL
    pop     DE

__gets_loop:
    ; Get a char from serial port and test
    ; to see if it's a newline.
    zsys(SREAD)
    cp      $0a
    jp      z, __gets_done
    cp      $0d
    jp      z, __gets_done

    ; Not newline, so load into buffer.
    ld      (DE), A
    inc     DE
    ld      L, A
    call    _putchar
    jp      __gets_loop

__gets_done:
    ; Terminating null character.
    ld      A, 0
    ld      (DE), A

    ld      HL, __newline
    call    _puts

    ret

    EXTERN  _printf_char
    EXTERN  _printf_hex
    EXTERN  _printf_unsigned
    EXTERN  _printf_string

_printf:
    ; A holds number of variadic args, apparently?

    ; Calculate number of bytes of variadic args.
    ; This is 2*A.
    ld      H, 0
    sla     A ; FIXME: Won't work for more than 127 arguments.
    add     2 ; Also skip past return value.
    ld      L, A

    ; Add to stack pointer.
    add     HL, SP

    ; HL now points to first parameter (format string pointer).
    ; Load into DE.
    dec     HL
    ld      D, (HL)
    dec     HL
    ld      E, (HL)

    ; DE now points to format string,
    ; HL points to first variadic arg.
__printf_loop:
    ; Load character.
    ld      A, (DE)
    inc     DE
    
    ; Is it null?
    cp      0
    jp      z, __printf_done

    ; Is it %?
    cp      '%'
    jp      nz, __printf_noformat

__printf_format:
    ; Formatting mode.
    ; Get next argument into BC.
    push    BC
    dec     HL
    ld      B, (HL)
    dec     HL
    ld      C, (HL)

    push    HL

    ld      A, ' '
    ld      (_padding_char), A

    ; Any flags?
    ; So far we just handle zero-padding.
    ld      A, (DE)

    cp      '0'
    jp      nz, __printf_flags_done

    ld      (_padding_char), A
    inc     DE

__printf_flags_done:
    ; Get padding in HL.
    call    __printf_get_padding

    ld      A, (DE)
    inc     DE
    push    DE

    ; Type of format?
    ;
    ; Put args on stack.
    push    BC
    push    HL

    cp      'c'
    jp      nz, __printf_not_char

    call    _printf_char
    jp      __printf_formatdone

__printf_not_char:
    cp      'u'
    jp      nz, __printf_not_unsigned

    call    _printf_unsigned
    jp      __printf_formatdone

__printf_not_unsigned:
    cp      'x'
    jp      nz, __printf_not_hex_lower

    call    _printf_hex
    jp      __printf_formatdone

__printf_not_hex_lower:
    cp      's'
    jp      nz, __printf_unrecognized

    call    _printf_string
    jp      __printf_formatdone

__printf_unrecognized:
    ld      L, '!'
    zsys(SWRITE)
    ld      L, '!'
    zsys(SWRITE)
    ld      L, '!'
    zsys(SWRITE)

__printf_formatdone:
    ; Discard arguments.
    pop     BC
    pop     BC

    ; Restore saved registers.
    pop     DE
    pop     HL
    pop     BC

    jp      __printf_loop

__printf_noformat:
    ; Non-formatting mode. Character is in A.
    push    HL
    ld      L, A
    zsys(SWRITE)
    pop     HL

    jp      __printf_loop

__printf_done:
    ; Some arbitrary return value.
    ld      HL, 1
    ret

__printf_get_padding:
    ld      L, 0

    ld      A, (DE)

    ; First character of padding must be 1-9.
    cp      '1'
    jp      c, __printf_get_padding_done
    cp      ':'
    jp      nc, __printf_get_padding_done

    inc     DE

    ; Convert _character_ 1-9 to _value_ 1-9 and add to our padding value.
    sub     '0'
    add     L
    ld      L, A

__printf_get_padding_loop:
    ld      A, (DE)

    ; Loop while character between '0' and '9'
    cp      '0'
    jp      c, __printf_get_padding_done
    cp      ':'
    jp      nc, __printf_get_padding_done

    ; It is padding!
    inc     DE

    ; Multiply L by 10.
    call    __l_times_10

    ; Convert _character_ 1-9 to _value_ 1-9 and add to our padding value.
    sub     '0'
    add     L
    ld      L, A

    ; Loop.
    jp      __printf_get_padding_loop

__printf_get_padding_done:
    ret

__l_times_10:
    ld      H, A
    ld      A, L

    ; Multiply by 8.
    sla     A
    sla     A
    sla     A

    ; Add 2*L
    add     A, L
    add     A, L

    ld      L, A
    ld      A, H
    ld      H, 0
    ret

    PUBLIC  _padding_char
_padding_char:
    defs    1

__newline:
    defm    "\n\r"
    defb    0
