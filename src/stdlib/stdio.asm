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
    push    AF
    push    DE

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
    pop     DE
    pop     AF

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
    push    AF
    push    HL

    ; Get a char from serial port and test
    ; to see if it's a newline.
    zsys(SREAD)
    cp      $0a
    jp      z, __gets_done

    ; Not newline, so load into buffer.
    ld      (HL), A
    inc     HL

__gets_done:
    ; Terminating null character.
    ld      (HL), 0

    ; Return.
    pop     HL
    pop     AF
    ret

_printf:
    push    BC
    push    AF

    ; Initially not in "formatting" state.
    ld      B, 0

    ; A holds number of variadic args, apparently?

    ; Calculate number of bytes of variadic args.
    ; This is 2*A.
    ld      H, 0
    sla     A ; FIXME: Won't work for more than 127 arguments.
    add     6 ; Also skip past return value and saved AF/BC.
    ld      L, A

    ; Add to stack pointer.
    add     HL, SP

    ; HL now points to first parameter (format string pointer).
    ; Load into DE.
    push    DE
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
    jp      nz, __printf_putchar

    ld      B, 1 ; Enter "formatting" state.
    jp      __printf_loop

__printf_putchar:
    bit     0, B
    jp      z, __printf_noformat

    ; Formatting mode.
    ; Get next argument into BC.
    push    BC
    dec     HL
    ld      B, (HL)
    dec     HL
    ld      C, (HL)

    ; FIXME: Padding?

    ; Type of format?
    cp      'c'
    jp      z, __printf_char

    cp      'u'
    jp      z, __printf_unsigned_decimal

    cp      'x'
    jp      z, __printf_unsigned_hex_lower

    push    HL
    ld      L, '!'
    zsys(SWRITE)
    pop     HL

    jp      __printf_formatdone

__printf_char:
    push    HL
    
    ld      L, C
    zsys(SWRITE)

    pop     HL
    jp      __printf_formatdone

__printf_unsigned_decimal:
    push    HL

    ; FIXME: Only handles values <=255 atm.
    ld      A, C

    ld      C, -100
    call    __printdigit
    ld      C, -10
    call    __printdigit
    ld      C, -1
    call    __printdigit_always ; Don't want to omit 0 for final digit.

    pop     HL
    jp      __printf_formatdone

__printf_unsigned_hex_lower:
    push    HL

    ; Print top digit
    ; FIXME: Only handles values <=255 atm.
    ld      A, C

    srl     A
    srl     A
    srl     A
    srl     A
    call    __printhex

    ; Print lower digit
    ld      A, C
    and     A, $0f
    call    __printhex

    pop     HL
    jp      __printf_formatdone

__printf_formatdone:
    pop     BC

    ; No longer in format mode.
    ld      B, 0

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

    pop     DE
    pop     AF
    pop     BC
    ret

__printdigit:
    ld      L, '0'-1
__printdigit2:
    inc     L
    add     A, C
    jr      c, __printdigit2
    sub     C

    push    AF
    ld      A, L
    cp      '0'
    jp      z, __printdigit3

    ; Decimal representation now in L.
    zsys(SWRITE)

__printdigit3:
    pop     AF
    ret

__printdigit_always:
    ld      L, '0'-1
__printdigit_always2:
    inc     L
    add     A, C
    jr      c, __printdigit_always2
    sub     C

    push    AF
    ; Decimal representation now in L.
    zsys(SWRITE)
    pop     AF
    ret

__printhex:
    ; 0-9?
    cp      10
    jp      nc, __printhex_af

    add     A, '0'
    ld      L, A
    zsys(SWRITE)
    ret

__printhex_af:
    sub     A, 10 ; Map 10-15 to 0-5 range.
    add     A, 'a'
    ld      L, A
    zsys(SWRITE)
    ret
