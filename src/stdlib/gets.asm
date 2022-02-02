    .globl  _gets

    .globl  _putchar
    .globl  _puts

_gets:
    push    HL
    pop     DE

__gets_loop:
    ; Get a char from serial port and test
    ; to see if it's a newline.
    ld      A, #2
    rst     48

    cp      #0x0a
    jp      z, __gets_done
    cp      #0x0d
    jp      z, __gets_done

    ; Is it a backspace?
    cp      #0x7f
    jp      z, __gets_backspace
    cp      #0x08
    jp      z, __gets_backspace

    ; Not newline or backspace, so load into buffer.
    ld      (DE), A
    inc     DE

    push    HL
    ld      L, A
    call    _putchar
    pop     HL

    jp      __gets_loop

__gets_backspace:
    ; Skip if we're already at the start of the buffer.
    ld      A, H
    cp      D
    jp      nz, __gets_backspace_send
    ld      A, L
    cp      E
    jp      nz, __gets_backspace_send

    jp      __gets_loop

__gets_backspace_send:
    ; Delete previous character from screen.
    push    HL
    push    DE
    ld      HL, #__backspace_str
    call    _puts
    pop     DE
    pop     HL

    ; Decrement pointer.
    dec     DE

    jp      __gets_loop

__gets_done:
    ; Terminating null character.
    ld      A, #0
    ld      (DE), A

    ld      HL, #__newline
    call    _puts

    ret

    ; Implements a backspace.
    ; Moves cursor back to previous character, emits a space to erase it,
    ; then moves cursor back again.
__backspace_str:
    .asciz  "\033[D \033[D"

__newline:
    .asciz  "\n\r"
