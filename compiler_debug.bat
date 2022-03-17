nasm myOS.asm -f bin -o bootloader.bin

nasm ExtendedSpace.asm -f bin -o ExtendedSpace.bin

copy /b bootloader.bin+ExtendedSpace.bin bootloader.bin

pause