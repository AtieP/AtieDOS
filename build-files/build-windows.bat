@echo off
echo This program assumes that you have installed NASM and you have it in
echo your path.

nasm -f bin -o ../disk-images/atiedos-2-10.iso ../bootloader.asm
