; AtieDOS 2.10 Screen System Calls
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder


; Clears the screen
; IN: Nothing
; OUT: Nothing
os_clear_screen:

    pusha

    mov ax, 0x03
    int 10h

    popa
    ret


; Gets cursor position
; IN: Nothing
; OUT: AX = 0, CH = Start of the scan line, CL = End of the scan line,
; DH: Row, DL: Column
os_get_cursor_position:

    mov ah, 0x03
    xor bh, bh
    int 10h

    ret

; Changes the color of the background (only in text mode)
; IN: Color in BL
; OUT: Nothing

os_change_color:

    mov ah, 0Bh
    xor bh, bh
    int 10h

    ret