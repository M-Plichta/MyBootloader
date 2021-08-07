[org 0x7e00]

mov bx, MSG
call PrintString_16

jmp $

%include "Print_16bit.asm"

MSG:
    db "Extended Space", 0

times 2048-($-$$) db 0
