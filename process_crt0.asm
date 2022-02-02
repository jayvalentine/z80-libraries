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
    .globl  _user_main

    .globl  _syscall_pexit

start:
    ; argc at 0xf800.
    ld      HL, (0xf800)
    push    HL
    
    ; argv at 0xf810
    ld      HL, #0xf810
    push    HL

    call    _user_main
    push    HL
    call    _syscall_pexit
