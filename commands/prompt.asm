; AtieDOS 2.10 Change prompt command
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_prompt:


    xor ax, ax
    mov ds, ax
    mov es, ax

    call .null_prompt

    call os_command_init

    ; I use SI as an index for DI array

    mov si, 1
    xor di, di
    mov di, PROMPT

.get_input:

    cmp si, 26
    je get_input.get_chars_error

    xor ax, ax
    int 16h

    cmp ah, [KEY_ENTER]
    je os_command_finish

    cmp ah, [KEY_BACKSPACE]
    je .handle_backspace

    inc si

    mov ah, 0x0e
    int 10h

    stosb

    jmp .get_input

.handle_backspace:

    cmp si, 1
    je .handle_backspace_no_backspace

    dec di
    dec si

    call os_get_cursor_position

    mov ah, 0x02
    dec dl
    mov bh, 0
    int 10h

    mov ah, 0x0e
    mov al, ' '
    int 10h


    mov ah, 0x02
    dec dl
    mov bh, 0
    int 10h

    mov ah, 0x02
    inc dl
    mov bh, 0
    int 10h

.handle_backspace_no_backspace:

    jmp .get_input

.null_prompt:

    xor di, di
    mov di, PROMPT
    mov si, 25

.null_prompt_loop:

    cmp si, 0
    je .null_prompt_done
    mov al, 0
    stosb
    dec si
    jmp .null_prompt_loop

.null_prompt_done:

    ret