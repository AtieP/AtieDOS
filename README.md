# AtieDOS

A 16 bit operating system made by enthusiasts to enthusiasts with love.
Current version: 2.10

# How to Build

## Linux

Run the script file `build-linux.sh` at the root folder of this project.
You may be required to run `chmod +x ./build-linux.sh` before running the actual script.

## Windows

Run the batch file `build-windows.bat` at the root folder of this project.

# How to Run

## QEMU

We assume that you have the binary path of QEMU set in the `$PATH` environment variable.
Run `qemu-system-x86_64 -fda bin/floppy.img`.

# Commands

Here is a list of available commands:
- `about`: Shows an "about" message to the screen
- `chset`: Shows a grid of the current VGA character set
- `clear`: Clears the screen
- `echo`: Echoes a message
- `help`: Shows a list of commands
- `pause`: Pauses the prompt
- `prompt`: Changes the prompt
- `restart`: Restarts the computer
- `shutdown`: Shutdowns the computer
- `stra`: String command interpreter

# Screenshot

![AtieDOS 2.10 Screenshot](/atiedos2.10.png)

# What's Stra?

Stra is an esoteric language created by SuperLeaf1995 and me based on Brainfuck. It is used for string manupulation.
A Stra example: +++.

# How can I collaborate?

Contact me on Discord. I am AteMellow-P#5173. My server: https://discord.gg/26Dfm5e

# Acknowledgements

Thanks to Midn this operating system works. He made the bootloader.
And also I got inspired to made Stra thanks to SuperLeaf1995.
Their Discord servers, respectively: https://discord.gg/BX6RBYx, https://discord.gg/ShmmEXP
