; AtieDOS 2.10 Stra Interpreter
; Based on Brainfuck, but this is for string manipulation.
; Copyright (c) 2020 AtieSoftware. All rights reserved.
; See LICENSE in the root folder


command_stra:

    call os_command_init

    mov bx, .STRA_HEADER 
    call os_print_string

    call os_print_new_line

    mov bx, .STRA_COPYRIGHT
    call os_print_string    

    call os_print_new_line

    mov bx, .STRA_COMMANDS
    call os_print_string
    
    call os_print_new_line

.restart:

    call os_print_new_line

    mov bx, .STRA_PROMPT
    call os_print_string

    call .null_stra_buffer
    call .null_stra_output

    mov si, 1
    xor ax, ax                          ; sets ax = 0
    mov di, .STRA_BUFFER                ; mov .STRA_BUFFER to di
    push ax                             ; pushes ax
    push di                             ; pushes di

.get_input:

    call os_keystroke              ; waits for keystroke and displays it

    cmp ah, [KEY_ENTER]                 ; if key is enter
    je .interpret                       ; interpret the code

    cmp ah, [KEY_ESC]                   ; if key is ESC
    je .exit                            ; jumps to .exit

    cmp al, '*'                         ; if key is *
    je .star_symbol_add                 ; jumps to .star_symbol_add

    cmp al, '+'                         ; if key is +
    je .add_symbol_add                  ; jumps to .add_symbol_add

    cmp al, '-'                         ; if key is -
    je .sub_symbol_add                  ; jumps to .sub_symbol_add

    cmp al, '.'                         ; if key is .
    je .post_symbol_add                 ; jumps to .post_symbol_add

    cmp al, '/'                         ; if key is /
    je .slash_symbol_add                ; jumps to .slash_symbol_add

    cmp ah, [KEY_BACKSPACE]
    je .handle_backspace

    jmp .get_input                      ; else: goes to .get_input

.star_symbol_add:

    mov al, 42                          ; moves * to al
    stosb                               ; stosb = moves al to di

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    inc si

    jmp .get_input

.add_symbol_add:

    mov al, 43                          ; moves + to al
    stosb                               ; stosb = moves al to di

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    inc si

    jmp .get_input                      ; goes to .get_input

.sub_symbol_add:

    mov al, 45                          ; moves - to al
    stosb                               ; stosb = moves al to di

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    inc si

    jmp .get_input                      ; goes to .get_input 

.post_symbol_add:

    mov al, 46                          ; moves . to al
    stosb                               ; stosb = mov al to di

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    inc si

    jmp .get_input                      ; goes to .get_input

.slash_symbol_add:

    mov al, 47                          ; moves / to al
    stosb                               ; stosb = mov al to di

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    inc si

    jmp .get_input                      ; goes to .get_input

.interpret:

    mov al, 0                           ; moves 0 to al         - we do this to indicate the end of the code
    stosb                               ; stosb = mov al to di

    mov bx, .STRA_BUFFER                ; moves .STRA_BUFFER to bx

.loop:

    mov al, [bx]                        ; moves the byte of bx to al

    cmp al, 42                          ; if the byte is *
    je .add_ten                         ; perform ten add

    cmp al, 43                          ; if the byte is +
    je .add                             ; perform add

    cmp al, 45                          ; if the byte is -
    je .sub                             ; perform sub

    cmp al, 46                          ; if the byte is .
    je .post                            ; perform post

    cmp al, 47                          ; if the byte is /
    je .sub_ten                         ; perform ten sub

    cmp al, 0                           ; if the byte is 0
    je .output                          ; shows the output

    add bx, 1                           ; adds bx to 1 to read next byte

    jmp .loop                           ; jumps to .loop

.add:

    pop di                              ; pops di
    pop ax                              ; pops ax

    inc ax                              ; increases ax
    stosb                               ; stosb = move al to di (ax is ah and al)

    push ax                             ; pushes ax
    push di                             ; pushes di

    add bx, 1                           ; read next byte of .STRA_BUFFER
    
    jmp .loop                           ; jumps to .loop

.sub:

    pop di                              ; pops di
    pop ax                              ; pops ax

    dec ax                              ; decreases ax
    stosb                               ; stosb = move al to di (ax is ah and al)

    push ax                             ; pushes ax
    push di                             ; pushes di

    add bx, 1                           ; read next byte of .STRA_BUFFER
    jmp .loop                           ; jumps to .loop

.post:

    pop di                              ; pops di
    pop ax                              ; pops ax

    mov di, .STRA_OUTPUT                ; moves .STRA_OUTPUT to di
    stosb                               ; stosb = moves al to di

    push ax                             ; pushes ax
    push di                             ; pushes di

    add bx, 1                           ; read next byte of .STRA_BUFFER

    jmp .loop                           ; jumps to .loop

.add_ten:


    ; increase ax 10 times
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    inc ax
    stosb

    push ax                             ; pushes ax
    push di                             ; pushes di

    add bx, 1                           ; read next byte of .STRA_BUFFEr
    jmp .loop                           ; jumps to .loop

.sub_ten:

    pop di                              ; pops di
    pop ax                              ; pops ax

    ; decreases AX 10 times
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax
    dec ax

    push ax                             ; pushes ax
    push di                             ; pushes di

    add bx, 1                           ; read next byte of .STRA_BUFFER
    jmp .loop                           ; jumps to .loop

.output:

    pop di                              ; pops di
    pop ax                              ; pops ax

    call os_print_new_line

    mov bx, .STRA_OUTPUT
    call os_print_string

    jmp .restart


.exit:

    pop di
    pop ax

    call os_command_finish
    hlt

.null_stra_buffer:

    xor di, di                          ; sets di to 0
    mov di, .STRA_BUFFER                ; moves .STRA_BUFFER to 0
    mov si, 250                         ; si will be in this case Number of times

.null_stra_buffer_loop:

    cmp si, 0                           ; if Number of times = 0
    je .null_stra_buffer_done           ; jumps to the end

    mov al, 0                           ; moves 0 (empty) to al
    stosb                               ; stosb = moves al to di

    dec si                              ; decreases the Number of times

    jmp .null_stra_buffer_loop          ; repeat

.null_stra_buffer_done:
    ret                                 ; returns to the point that was called

.null_stra_output:                      ; same as null_stra_buffer

    xor di, di
    mov di, .STRA_OUTPUT
    mov si, 250

.null_stra_output_loop:

    cmp si, 0
    je .null_stra_output_done

    mov al, 0
    stosb

    dec si

    jmp .null_stra_output_loop

.null_stra_output_done:
    ret

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
.STRA_HEADER: db "Stra Interpreter", 0
.STRA_COPYRIGHT: db "Copyright (c) 2020 AtieSoftware. All rights reserved.", 0
.STRA_COMMANDS: db "Valid symbols: + - * / .",13,10,"Press ENTER to execute or ESC to exit.",13,10,13,10,"Use less than 250 symbols to avoid bugs!", 0
.STRA_PROMPT: db "- ", 0

.STRA_BUFFER: times 250 db 0
.STRA_OUTPUT: times 250 db 0