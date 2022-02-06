    .globl  __setjmp
    .globl  __longjmp

    ; int _setjmp(jmp_buf * env)
    ; Internal setjmp implementation
__setjmp:
    ; Get return address into HL.
    pop     HL
    push    HL

    ; Save stack pointer.
    ld      (__setjmp_env_tmp_sp), SP

    ; Save registers.
    ld      SP, #__setjmp_env_tmp_sp

    push    IY
    push    IX

    push    DE
    push    BC
    push    AF

    ; Save return address.
    push    HL

    ; Restore stack pointer and get arg into HL.
    ld      SP, (__setjmp_env_tmp_sp)
    ld      HL, #2
    add     HL, SP
    ld      A, (HL)
    inc     HL
    ld      H, (HL)
    ld      L, A

    ; Copy our temp buffer into the one provided.
    ex      DE, HL
    ld      HL, #__setjmp_env_tmp
    ld      BC, #14
    ldir

    ; Return value of 0.
    ld      HL, #0
    ret

    ; void _longjmp(jmp_env * env, int value)
    ; Internal implementation of longjmp.
__longjmp:
    ld      HL, #2
    add     HL, SP
    push    HL
    pop     IX
    
    ld      L, 2(IX)
    ld      H, 3(IX)

    ld      (__longjmp_tmp_value), HL

    ld      L, 0(IX)
    ld      H, 1(IX)

    ld      (__longjmp_tmp_env), HL

    ; Copy provided buffer into the temporary one.
    ld      DE, #__setjmp_env_tmp
    ld      BC, #14
    ldir

    ld      SP, #__setjmp_env_tmp
    
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
    .ds     2

__setjmp_env_tmp_af:
    .ds     2
__setjmp_env_tmp_bc:
    .ds     2
__setjmp_env_tmp_de:
    .ds     2

__setjmp_env_tmp_ix:
    .ds     2
__setjmp_env_tmp_iy:
    .ds     2

__setjmp_env_tmp_sp:
    .ds     2

__longjmp_tmp_env:
    .ds     2

__longjmp_tmp_value:
    .ds     2
