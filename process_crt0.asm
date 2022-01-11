    ; CRT0 for ZEBRA multitasking platform.
    ; For running code as a process in user-memory.
    ;
    ; NOTE: The label _user_main is used because
    ; z88dk forces the main() function to use
    ; the stdc calling convention.
    ;
    ; Naming the function something different
    ; allows us to use the normal calling
    ; convention.
    EXTERN  _user_main

start:
    ; Return address is TOS.
    pop     HL
    ld      HL, _exit
    push    HL

    jp    _user_main

    EXTERN  _syscall_pexit

_exit:
    ; Return value from main is in HL.
    push    HL
    call    _syscall_pexit
