; AtieDOS 2.10 String System Calls
; Copyright (c) 2020 AtieSoftware.
; See LICENSE in root folder

; os_string_compare_and_junp
; Compares two strings and jumps if equal.
; IN: SI = Pointer to the first strings, 
;     DI = Pointer to the second
;     CX = Label to jump
; OUT: Nothing

os_string_compare_and_jump:

    xor bx, bx                      ; set bx to 0

.check_char_by_char:

    mov al, [si + bx]               ; we move to al the byte of SI
    cmp al, [di + bx]               ; we compare the SI byte of DI
    jne .mismatch                   ; if theyre not the same = mismatch
          
    cmp al, 0                       ; if al = 0
    je .end                         ; go to the end

    inc bx                          ; increase bx
    jmp .check_char_by_char

.mismatch:
    ret

.end:

    jmp cx                          ; jumps to the label we've put in CX

; os_string_to_lowercase
; Converts a string to lowercase.
; IN: AX = Pointer to the string
; OUT: Nothing

os_string_to_lowercase:

    pusha                       ; pushes all to stack

    mov si, ax                  ; moves what we've input to ax to si

.loop:

    cmp byte [si], 0            ; if the byte is 0 = jump to end
    je .end

    cmp byte [si], 'A'          ; if its lower than A:
    jb .not_a_to_z              ; jump to .not_a_to_z

    cmp byte [si], 'Z'          ; but if its higher than Z:
    ja .not_a_to_z              ; jump to .not_a_to_z

    add byte [si], 20h          ; we add a SHIFT

    inc si                      ; read next byte of SI
    jmp .loop

.not_a_to_z:

    inc si                      ; read next byte of SI
    jmp .loop

.end:

    popa                        ; pops al
    ret                         ; returns to the point we've been called