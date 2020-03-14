# you will need nasm to compile this
# and qemu to run it, but if you want you can use another emulator

nasm -f bin -o ../disk-images/atiedos-2-10.iso ../bootloader.asm
