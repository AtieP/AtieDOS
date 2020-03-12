; AtieDOS 2.10 Command System Calls
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder

; os_command_init
; Use this at the start of a command/program.
; IN: Nothing
; OUT: Nothing
os_command_init:

    pusha

    call os_print_new_line

    popa

    ret

; os_command_finish
; Use this at the end of a program/command.
; IN: Nothing
; OUT: Nothing
os_command_finish:

    pusha

    call os_print_new_line
    jmp get_input

    popa
    
    ret