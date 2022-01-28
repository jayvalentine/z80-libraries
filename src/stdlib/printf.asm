    .globl  _printf

    .globl  _putchar

    ; Syscall macro.
define(zsys, `ld      A, #(0x1 << 1)
    rst     48')

    .equ    SREAD, 1

    .globl  _printf_char
    .globl  _printf_hex
    .globl  _printf_unsigned
    .globl  _printf_signed
    .globl  _printf_string
    .globl  _puts

_printf:
    ; A holds number of variadic args, apparently?

    ; Calculate number of bytes of variadic args.
    ; This is 2*A.
    ld      H, #0
    sla     A ; FIXME: Won't work for more than 127 arguments.
    add     #2 ; Also skip past return value.
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
    cp      #0
    jp      z, __printf_done

    ; Is it %?
    cp      #'%'
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

    ld      A, #' '
    ld      (_padding_char), A

    ; Any flags?
    ; So far we just handle zero-padding.
    ld      A, (DE)

    cp      #'0'
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

    cp      #'c'
    jp      nz, __printf_not_char

    call    _printf_char
    jp      __printf_formatdone

__printf_not_char:
    cp      #'u'
    jp      nz, __printf_not_unsigned

    call    _printf_unsigned
    jp      __printf_formatdone

__printf_not_unsigned:
    cp      #'d'
    jp      nz, __printf_not_signed

    call    _printf_signed
    jp      __printf_formatdone

__printf_not_signed:
    cp      #'x'
    jp      nz, __printf_not_hex_lower

    call    _printf_hex
    jp      __printf_formatdone

__printf_not_hex_lower:
    cp      #'s'
    jp      nz, __printf_unrecognized

    call    _printf_string
    jp      __printf_formatdone

__printf_unrecognized:
    ld      L, #'!'
    call    _putchar
    ld      L, #'!'
    call    _putchar
    ld      L, #'!'
    call    _putchar

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
    call    _putchar
    pop     HL

    jp      __printf_loop

__printf_done:
    ; Some arbitrary return value.
    ld      HL, #1
    ret

__printf_get_padding:
    ld      L, #0

    ld      A, (DE)

    ; First character of padding must be 1-9.
    cp      #'1'
    jp      c, __printf_get_padding_done
    cp      #':'
    jp      nc, __printf_get_padding_done

    inc     DE

    ; Convert _character_ 1-9 to _value_ 1-9 and add to our padding value.
    sub     #'0'
    add     L
    ld      L, A

__printf_get_padding_loop:
    ld      A, (DE)

    ; Loop while character between '0' and '9'
    cp      #'0'
    jp      c, __printf_get_padding_done
    cp      #':'
    jp      nc, __printf_get_padding_done

    ; It is padding!
    inc     DE

    ; Multiply L by 10.
    call    __l_times_10

    ; Convert _character_ 1-9 to _value_ 1-9 and add to our padding value.
    sub     #'0'
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
    ld      H, #0
    ret

    .globl  _padding_char
_padding_char:
    .ds     1
