; AtieDOS 2.10 Bootloader
; Copyright (c) 2020 AtieSoftware & midn.
; See LICENSE in root folder

[bits 16]                 ; we tell to the compiler (NASM) that we're in 16 bit mode
[org 0x7c00]


  jmp 0x00:start ; Sets cs to 0.

start:
  xor ax, ax     ; "XORing" the same register/segment/pointer sets that register/segment/pointer to 0, to we set ax as 0.
  mov es, ax     ; we set ES to 0, because AX has the same value
  mov ds, ax     ; set ds to 0
  mov ss, ax     ; set ss to 0

  mov bp, 0x7c00 ; Right before the bootloader.
  mov sp, bp     ; we set sp to 0x7C00

  ; dl is given by the BIOS.
  mov bx, 0x7e00                                    ; we're moving to BX where we want to code jumps
  mov dh, (KERNEL_END - KERNEL_START + 511) / 512   ; calculating how many sectors we need
  call disk_load                                    ; calls DISK_LOAD subroutine
  mov ax, 0x7e00                                    ; if everyting went ok in DISK_LOAD, we set ax to 0x7e00
  jmp ax                                            ; and we jump there

disk_load:

  pusha                                             ; pushes all general registers
  push dx                                           ; and also dx
  
  mov si, 8 ; number of tries
  mov al, dh                                        ; remember that calculation we made in DH? now we're moving the value of DH to AL, to compare it later

.try:
  mov ah, 0                      ; ah = 0: reset disk
  int 13h                        ; interrupt to do that

  mov ah, 0x02                   ; ah = 2: read sectors
  mov cx, 0x02
  mov ch, 0x00
  mov dh, 0x00
  int 13h                        ; interrupt to do that

  jnc .itworked                  ; if there was an error, int 13h sets carry flag. But if int 13h didnt set carry flag, this means that everything went ok
  
  dec si                         ; remember when we set the number of tries? now we decrease si, that means, SI = SI - 1 or SI -= 1
  jnz .try                       ; if si isnt 0, we try again to read the disk
  jmp disk_error                 ; if si is zero, we jump to DISK_ERROR
.itworked:

  pop dx                        ; remember we push dx? now we pop it

  cmp al, dh                    ; remember we set al as dh to compare it later? now we compare it
  jne sectors_error             ; if they are not the same, there was a error with the sectors and we jump to SECTORS_ERROR

  popa                           ; remember we pusha? now we popa
  ret                            ; we return to the moment we've call disk_load

disk_error:                     ; if there was a disk error, code ends here

  mov bx, BOOTLOADER_DISK_ERROR_MSG   ; we move BOOTLOADER_DISK_ERROR_MSG to bx to print it
  call bootloader_print               ; using bootloader_print.
  call bootloader_nl                  ; bootloader_nl prints a new line.
  mov dh, ah                          ; we set DH as AH to print it as hex
  call bootloader_phex                ; calling this functions to see where's the error.
  jmp disk_loop                       ; we jump to the label "disk_loop"

sectors_error:                  ; if there was a sectors error, code goes here.

  mov bx, BOOTLOADER_SECTORS_ERROR_MSG    ; we move to bx this
  call bootloader_print                   ; to print it with this.

disk_loop:

  jmp disk_loop     ; this is to hang

bootloader_print:     ; this prints strings

  pusha               ; we push all registers

.r:                   ; while loop that ends when a string ends with ,0

  mov al, [bx]        ; moves to al the string in bx
  cmp al, 0           ; if there's a 0
  je .d               ; printing ends
  mov ah, 0x0e        ; we tell to int 10h that we want to print chars
  int 10h             ; video interrupt
  add bx, 1           ; add to bx 1, this means we're reading next char
  jmp .r              ; jmp to .r label

.d:                   ; printing ends
  popa                ; we "pusha", so now we "popa"
  ret                 ; go back to the moment we've called bootloader_print

bootloader_phex:

  pusha

  mov cx, 0

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

  mov bx, BOOTLOADER_HEX_OUT
  sub bx, cx
  mov [bx], al
  ror dx, 4

  add cx, 1
  jmp .r

.d:

  mov bx, BOOTLOADER_HEX_OUT
  call bootloader_print

  popa
  ret

bootloader_nl:

  pusha
  mov ah, 0x0e
  mov al, 0x0a
  int 10h
  mov al, 0x0d
  int 10h
  popa
  ret

; strings

BOOTLOADER_HEX_OUT: db "0x0000", 0                            
BOOTLOADER_DISK_ERROR_MSG: db "Disk read error", 0
BOOTLOADER_SECTORS_ERROR_MSG: db "Sectors read error", 0


; a bootloader's size is exactly 512 bytes, so we convert all this code to 510 bytes of compiled code
times 510 - ($ - $$) db 0
dw 0xaa55   ; why 510 and not 512 bytes? we need 2 bytes to put this "magic number", that tells to the BIOS
            ; we're bootable
KERNEL_START:         ; remember we did "mov ax, 0x7e00" and then "jmp ax"? 0x7e00 is here

%include "kernel.asm"      
                      
times (512 - (($ - $$ + 0x7c00) & 511) + 1) / 2 dw 0xad21   ; 0xad21: AtieDOS 2.10
; ^ magic padding
KERNEL_END: