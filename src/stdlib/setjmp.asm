    .globl  __setjmp
    .globl  __longjmp

    ; int _setjmp(jmp_buf * env)
    ;
    ; Internal setjmp implementation
    ;
    ; env will be passed in HL.
__setjmp:
    ; Get return address into DE.
    pop     DE
    push    DE

    ; Save stack pointer.
    ld      (__setjmp_env_tmp_sp), SP

    ; Save registers.
    ld      SP, #__setjmp_env_tmp_sp

    push    IY
    push    IX

    push    HL
    push    BC
    push    AF

    ; Save return address.
    push    DE

    ; Restore stack pointer.
    ; Buffer pointer will still be in HL.
    ld      SP, (__setjmp_env_tmp_sp)

    ; Copy our temp buffer into the one provided.
    ex      DE, HL
    ld      HL, #__setjmp_env_tmp
    ld      BC, #14
    ldir

    ; Return value of 0.
    ld      DE, #0
    ret

    ; void _longjmp(jmp_env * env, int value)
    ;
    ; Internal implementation of longjmp.
    ;
    ; env   will be passed in HL.
    ; value will be passed in DE.
__longjmp:
    ld      (__longjmp_tmp_value), DE
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
    ld      DE, (__longjmp_tmp_value)

    ; Return. This should be to the caller of setjmp.
    ret

__setjmp_env_tmp:
__setjmp_env_tmp_address:
    .ds     2

__setjmp_env_tmp_af:
    .ds     2
__setjmp_env_tmp_bc:
    .ds     2
__setjmp_env_tmp_hl:
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
