#!/bin/sh

output_image=bin/floppy.img

# TODO: Replace this script with proper `Makefile`.
# TODO: Perform tool checks before building.

# We check if the `bin` directory exists & create it if that's not the case
# FIXME: Do out-of-source build instead.
mkdir -p bin;

# We build the boot sector
nasm -f bin -o bin/boot.bin bootloader.asm;
printf " - Built boot sector\n";

# We generate a blank floppy disk image
dd if=/dev/zero of="$output_image" bs=512 count=2880 status=none;
printf " - Generated floppy disk image\n";

# We copy the bootsector to the floppy disk image
dd if=bin/boot.bin of="$output_image" bs=512 count=1 conv=notrunc status=none;
# We copy the remaining sectors needed to the floppy disk image
# TODO: Format your disk to FAT12, program the bootsector to load a "KERNEL.BIN" file instead. That way
#       it'll be much easier to read/write files and folders, and you can even see them on DOS!
dd if=bin/boot.bin of="$output_image" bs=512 skip=1 seek=1 conv=notrunc status=none;
printf " - Copied system to floppy disk image\n";

printf "$0: generated floppy disk image to \"$output_image\"\n";

