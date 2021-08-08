[org 0x7e00]

jmp EnterProtectedMode

%include "gdt.asm"
%include "Print_16bit.asm"

EnterProtectedMode:
    call EnableA20
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:StartProtectedMode

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]

StartProtectedMode:

    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebx, Message
    call PrintString

    %include "Print_32bit.asm"

    jmp $

Message:
    dw "Hello World!!", 0
times 2048-($-$$) db 0
