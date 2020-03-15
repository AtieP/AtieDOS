@echo off
:: You need NASM to compile this

echo This program assumes that you have NASM and it's in your PATH.
nasm -f bin -o atiedos-2-10.iso bootloader.asm
