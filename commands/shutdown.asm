; AtieDOS 2.10 Shutdown Command
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_shutdown:

    call os_command_init

    mov bx, .ARE_YOU_SURE_SHUTDOWN_MSG
    call os_print_string

    call os_keystroke_echo
    
    cmp ah, [KEY_Y]
    je .shutdown

    jmp .exit

.shutdown:

    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

    call os_print_new_line
    
    mov bx, .SHUTDOWN_ERROR
    call os_print_string

.exit:
    call os_command_finish

    .ARE_YOU_SURE_SHUTDOWN_MSG: db "Are you sure that you want to shutdown the computer? [y/n] ", 0
    .SHUTDOWN_ERROR: db "Could not shutdown the computer.", 0