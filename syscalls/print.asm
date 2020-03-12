; AtieDOS 2.10 Print System Calls
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder

; os_print_string
; Prints a string terminated in 0.
; IN: BX = Pointer to the string
; OUT: Nothing
os_print_string:

    pusha

.print_each_char:

    mov al, [bx]
    cmp al, 0
    je .done
    mov ah, 0x0e
    int 10h
    add bx, 1
    jmp .print_each_char

.done:

    popa
    ret

; os_print_new_line
; Prints a carriage return and linefeed: a newline.
; IN: Nothing
; OUT: Nothing
os_print_new_line:

    pusha
    mov ah, 0x0e
    mov al, 0x0a
    int 10h
    mov al, 0x0d
    int 10h
    popa
    ret

; os_print_hex
; Prints a hexadecimal number
; IN: DX = Pointer or register to the hex number
; OUT: Nothing
os_print_hex:

  pusha

  xor cx, cx

.r:

  cmp cx, 4
  je .d

  mov ax, dx
  and ax, 0x000f
  add al, 0x30
  cmp al, 0x30
  jle .n
  add al, 7

.n:

  mov bx, HEX_OUT
  sub bx, cx
  mov [bx], al
  ror dx, 4

  add cx, 1
  jmp .r

.d:

  mov bx, HEX_OUT
  call bootloader_print

  popa
  ret

HEX_OUT: db "0x0000", 0
