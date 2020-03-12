; AtieDOS 2.10 Restart command
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_exit:

    call os_command_init
    
    mov bx, .AREYOUSURE_EXIT_MSG
    call os_print_string

    call os_keystroke_echo

    cmp ah, [KEY_Y]
    je .restart

    jmp .exit

.exit:
    call os_command_finish

.restart:

    call os_print_new_line
    int 19h

    call os_print_new_line
    
    mov bx, .RESTART_ERROR
    call os_print_string

    jmp .exit

.AREYOUSURE_EXIT_MSG: db "Are you sure that you want to restart? [y/n] ", 0
.RESTART_ERROR: db "Could not restart.", 0