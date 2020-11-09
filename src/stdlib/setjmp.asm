    PUBLIC  __setjmp
    PUBLIC  __longjmp

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

    ; void _longjmp(jmp_env * env, int value)
    ; Internal implementation of longjmp.
__longjmp:
    ld      HL, 2
    add     HL, SP
    push    HL
    pop     IX
    
    ld      L, (IX+0)
    ld      H, (IX+1)

    ld      (__longjmp_tmp_value), HL

    ld      L, (IX+2)
    ld      H, (IX+3)

    ld      (__longjmp_tmp_env), HL

    ; Copy provided buffer into the temporary one.
    ld      DE, __setjmp_env_tmp
    ld      BC, 14
    ldir

    ld      SP, __setjmp_env_tmp
    
    ; Return address into HL.
    pop     HL

    ; Restore registers
    pop     AF
    pop     BC
    pop     DE
    pop     IX
    pop     IY

    ; Restore stack pointer of setjmp caller, overwrite return address.
    ld      SP, (__setjmp_env_tmp_sp)
    ex      (SP), HL

    ; Get return value into HL.
    ld      HL, (__longjmp_tmp_value)

    ; Return. This should be to the caller of setjmp.
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

__longjmp_tmp_env:
    defs    2

__longjmp_tmp_value:
    defs    2
