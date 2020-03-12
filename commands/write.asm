; AtieDOS 2.10 Writer
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


command_write:

    call os_clear_screen

    call os_command_init

    mov bx, .WRITE_HEADER
    call os_print_string

    call os_print_new_line
    call os_print_new_line

    mov bx, .WRITE_MSG
    call os_print_string
    call os_print_new_line

    mov bx, .WRITE_MSG_NEXT
    call os_print_string
    call os_print_new_line
    call os_print_new_line

.readkey:

    mov ax, 0x00
    int 16h
	
    cmp ah, [KEY_TAB]
    je .tab
	
    cmp ah, [KEY_ESC]
    je .done

    cmp ah, [KEY_UP]
    je .go_up

    cmp ah, [KEY_DOWN]
    je .go_down

    cmp ah, [KEY_LEFT]
    je .go_left

    cmp ah, [KEY_RIGHT]
    je .go_right

    cmp ah, [KEY_DELETE]
    je .clear_screen

    push ax
    mov ah, 0x0e
    int 10h
    pop ax

    cmp ah, [KEY_BACKSPACE]
    je .backspace

    cmp ah, [KEY_ENTER]
    je .newline

    jmp .readkey

.tab:

    mov ah, 0x0e
    mov al, ' '
    int 10h
    int 10h
    int 10h
    int 10h
    jmp .readkey
    
.newline:

    call os_print_new_line
    jmp .readkey

.go_up:

    mov ah, 0x03
    mov bh, 0
    int 10h

    mov ah, 0x02
    dec dh
    mov bh, 0
    int 10h

    jmp .readkey

.go_down:

    mov ah, 0x03
    mov bh, 0
    int 10h

    mov ah, 0x02
    inc dh
    mov bh, 0
    int 10h

    jmp .readkey

.go_left:

    mov ah, 0x03
    mov bh, 0
    int 10h

    mov ah, 0x02
    dec dl
    mov bh, 0
    int 10h

    jmp .readkey

.go_right:

    mov ah, 0x03
    mov bh, 0
    int 10h

    mov ah, 0x02
    inc dl
    mov bh, 0
    int 10h

    jmp .readkey

.clear_screen:

    call os_clear_screen

    jmp .readkey

.backspace:

    mov ah, 0x03
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

    jmp .readkey
.done:

    call os_command_finish

.WRITE_HEADER: db "----- AtieDOS Writer -----", 0
.WRITE_MSG: db "Press ESC at any time to exit. Press TAB to write 4 spaces. Press ENTER to ", 0
.WRITE_MSG_NEXT: db "write on a new line. And press DEL to clear the screen.", 0