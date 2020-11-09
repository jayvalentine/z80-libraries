    PUBLIC  __setjmp

    ; int _setjmp(jmp_buf * env)
    ; Internal setjmp implementation
__setjmp:
    ; Get return address into HL.
    pop     HL
    push    HL

    ; Save stack pointer.
    ld      (__setjmp_env_tmp_sp), SP

    ; Save registers.
    ld      SP, __setjmp_env_tmp_sp

    push    IY
    push    IX

    push    DE
    push    BC
    push    AF

    ; Save return address.
    push    HL

    ; Restore stack pointer and get arg into HL.
    ld      SP, (__setjmp_env_tmp_sp)
    ld      HL, 2
    add     HL, SP
    ld      A, (HL)
    inc     HL
    ld      H, (HL)
    ld      L, A

    ; Copy our temp buffer into the one provided.
    ex      DE, HL
    ld      HL, __setjmp_env_tmp
    ld      BC, 14
    ldir

    ; Return value of 0.
    ld      HL, 0
    ret

__setjmp_env_tmp:
__setjmp_env_tmp_address:
    defs    2

__setjmp_env_tmp_af:
    defs    2
__setjmp_env_tmp_bc:
    defs    2
__setjmp_env_tmp_de:
    defs    2

__setjmp_env_tmp_ix:
    defs    2
__setjmp_env_tmp_iy:
    defs    2

__setjmp_env_tmp_sp:
    defs    2
