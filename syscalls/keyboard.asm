; AtieDOS 2.10 Keyboard system calls
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder

; os_keystroke_echo
; Waits for keystroke and prints the char.
; IN: Nothing
; OUT: AH = BIOS Scan code, AL = ASCII Key
os_keystroke_echo:

    xor ax, ax
    int 16h

    push ax             ; we push ax to avoid the lose
    mov ah, 0x0e        ; of the out registers
    int 10h
    pop ax

    ret

; os_keystroke
; Waits for keystroke but it doesn't print the character.
; IN: Nothing
; OUT: AH = BIOS Scan code, AL = ASCII Key
os_keystroke:

    xor ax, ax
    int 16h

    ret
