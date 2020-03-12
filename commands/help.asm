; AtieDOS 2.10 Help Command
; Copyright (c) 2020 AtieSoftware. All rights reserved.
; See LICENSE in the root folder

command_help:

    call os_command_init

    mov bx, .HELP_COMMANDS
    call os_print_string


    call os_command_finish

.HELP_COMMANDS: db "about chset clear echo help pause prompt restart shutdown stra write",0
