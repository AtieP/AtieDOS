@echo off
set /p nasmdir="Type here the directory that has NASM (please use double quotes) If you already have it on your PATH put nasm: "
if %nasmdir% == nasm goto yes
set path=%path%;%nasmdir%
:yes

nasm -f bin -o atiedos-2-10.iso bootloader.asm