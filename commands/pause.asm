; AtieDOS 2.10 Pause Command
; Copyright (c) 2020 AtieSoftware. All rights reserved.
; See LICENSE in the root folder

command_pause:

    call os_command_init

    mov bx, .PRESS_ANY_KEY
    call os_print_string

    call os_keystroke_echo

    call os_command_finish

    .PRESS_ANY_KEY: db "Press any key to continue...", 0