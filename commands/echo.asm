; AtieDOS 2.10 Echo Command
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_echo:


    xor ax, ax
    mov ds, ax
    mov es, ax

    call os_command_init
    
    mov si, 1
    xor di, di
    mov di, .MSG

.get_input:

    cmp si, 99
    je .no_more

    call os_keystroke

    cmp ah, [KEY_ENTER]
    je .done

    cmp ah, [KEY_BACKSPACE]
    je .handle_backspace

    mov ah, 0x0e
    int 10h

    inc si

    stosb
    jmp .get_input

.done:

    push .MSG

    call os_print_new_line

    mov bx, .MSG
    call os_print_string

    call os_print_new_line

    call .null_echo_msg

    jmp get_input

.handle_backspace:

    cmp si, 1
    je .get_input

    dec di
    dec si

    call os_get_cursor_position

    mov ah, 0x02
    dec dl
    xor bh, bh
    int 10h

    mov ah, 0x0e
    mov al, ' '
    int 10h


    mov ah, 0x02
    dec dl
    xor bh, bh
    int 10h

    mov ah, 0x02
    inc dl
    xor bh, bh
    int 10h


    jmp .get_input

.no_more:

    mov bx, .NO_MORE_CHARS
    call os_print_string
    call os_command_finish

.NO_MORE_CHARS: db 13,10,"You cannot write more chars to avoid overwritting. Sorry.", 0
.null_echo_msg:

    xor di, di
    mov di, .MSG
    mov si, 50
    
.null_echo_loop:

    cmp si, 0
    je .null_echo_end
    xor al, al
    stosb
    dec si
    jmp .null_echo_loop

.null_echo_end:
    ret


.MSG: times 100 db 0
.AVOID_MSG_BELOW: db 0

.ECHO_INVALID_USE: db "Incorrect usage of echo command",13,10,"Usage: echo <message>", 0