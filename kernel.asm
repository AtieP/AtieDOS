; AtieDOS 2.10 Kernel
; Copyright (c) 2020 AtieSoftware
; See LICENSE in root folder


; KERNEL STARTS HERE


kernel_main:


    call os_print_new_line              ; calls new line function
	
    mov bx, STARTED_SUCCESS_MSG         ; prints "AtieDOS started successfully."
    call os_print_string

    call os_print_new_line

    mov word[PROMPT], word "> "         ; moves "> " to prompt

get_input:
    
    call os_print_new_line

    mov bx, PROMPT
    call os_print_string

    call null_input_string
    
    ; I am using SI as an index for the DI array of chars.
    ; I'm making this to handle backspaces well.
    ; postdata: this time the array starts at 1 because there's no negative
    ; numbers

    mov si, 1
    xor di, di
    mov di, INPUT

.get_chars:

    cmp si, 26
    je .get_chars_error

    call os_keystroke

    cmp ah, [KEY_ENTER]
    je .compare

    cmp ah, [KEY_BACKSPACE]
    je .handle_backspace


    inc si

    mov ah, 0x0e
    int 10h

    stosb

    jmp .get_chars

.compare:

    xor al, al
    stosb

    mov ax, INPUT
    call os_string_to_lowercase

    mov si, ABOUT_STR
    mov di, INPUT
    mov cx, command_about
    call os_string_compare_and_jump

    mov si, STRA_STR
    mov di, INPUT
    mov cx, command_stra
    call os_string_compare_and_jump

    mov si, CLEAR_STR
    mov di, INPUT
    mov cx, command_clear
    call os_string_compare_and_jump

    mov si, CHSET_STR
    mov di, INPUT
    mov cx, command_charset
    call os_string_compare_and_jump

    mov si, ECHO_STR
    mov di, INPUT
    mov cx, command_echo
    call os_string_compare_and_jump

    mov si, HELP_STR
    mov di, INPUT
    mov cx, command_help
    call os_string_compare_and_jump

    mov si, PROMPT_STR
    mov di, INPUT
    mov cx, command_prompt
    call os_string_compare_and_jump

    mov si, PAUSE_STR
    mov di, INPUT
    mov cx, command_pause
    call os_string_compare_and_jump

    mov si, RESTART_STR
    mov di, INPUT
    mov cx, command_exit
    call os_string_compare_and_jump


    mov si, SHUTDOWN_STR
    mov di, INPUT
    mov cx, command_shutdown
    call os_string_compare_and_jump


    mov si, WRITE_STR
    mov di, INPUT
    mov cx, command_write
    call os_string_compare_and_jump

    call os_print_new_line

    mov bx, INVALID_CMD_MSG
    call os_print_string

    mov bx, QUOTE
    call os_print_string

    mov bx, di
    call os_print_string

    mov bx, QUOTE
    call os_print_string

    call os_print_new_line

    jmp get_input

.get_chars_error:

    call os_print_new_line

    mov bx, .GET_CHARS_ERROR
    call os_print_string

    jmp get_input

    .GET_CHARS_ERROR: db "You cannot write something larger than 25 chars to avoid bugs. Sorry.",0

.handle_backspace:

    cmp si, 1
    je .handle_backspace_no_backspace

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

    jmp .get_chars

.handle_backspace_no_backspace:

    jmp .get_chars

null_input_string:

    xor di, di
    mov di, INPUT
    mov si, 25

.null_input_string_loop:

    cmp si, 0
    je .null_input_string_done
    mov al, 0
    stosb
    dec si
    jmp .null_input_string_loop

.null_input_string_done:
    ret

    STARTED_SUCCESS_MSG: db "AtieDOS started successfully.", 0
    INVALID_CMD_MSG: db "Invalid command: ", 0
    QUOTE: db '"', 0
    PROMPT: times 25 db 0
    INPUT: times 25 db 0

    ABOUT_STR: db "about", 0
    STRA_STR: db "stra", 0
    CLEAR_STR: db "clear", 0
    CHSET_STR: db "chset", 0
    ECHO_STR: db "echo", 0
    HELP_STR: db "help", 0
    PROMPT_STR: db "prompt", 0
    PAUSE_STR: db "pause", 0
    RESTART_STR: db "restart", 0
    SHUTDOWN_STR: db "shutdown", 0
    WRITE_STR: db "write", 0


%include "syscalls/_syscalls.asm"
%include "commands/_commands.asm"
%include "data/keys.asm"
