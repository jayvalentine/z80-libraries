    ; CRT0 for modularz80 platform.
    ; For running code in user-memory.
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
    jp    _user_main
