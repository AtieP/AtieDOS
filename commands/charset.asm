; AtieDOS 2.10 Charset Command
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_charset:

    call os_command_init

.ss1:

    mov ax, 0x03
    int 10h
    
    mov ax, 0xb800
    mov ds, ax
    mov es, ax
    cld
    mov di, 0x0020
    mov cx, 16
    mov ax, 0x0700

.ss3:
    push cx
    mov cx, 16

.ss2:

    stosw
    inc al
    loop .ss2
    pop cx
    add di, 0x00a0-0x0020
    loop .ss3
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    cld
    xor di, di
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    call os_print_new_line
    mov bx, .CHSET_STR
    call os_print_string
    mov ah, 0x00
    int 16h



    call os_clear_screen

    call os_command_finish

.CHSET_STR: db "Charset (Extended ASCII)",13,10,"The square is 16 chars x 16 chars, in total 256 chars.",13,10,"Press any key to exit...", 0