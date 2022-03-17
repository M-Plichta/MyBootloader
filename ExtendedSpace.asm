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

%include "CPUID.asm"
%include "SimplePaging.asm"

StartProtectedMode:

    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ;mov ebx, Message
    ;call PrintString

    ;%include "Print_32bit.asm"

    ; ----------------- DELETE - Just for testing :)
    mov al, 0x20
    mov ecx, 0x0

    VIDEO_MEMORY equ 0xb8000
    WHITE_ON_BLACK equ 0x1f

    ; Prints a null-terminated string pointed to by EDX
    PrintString:
        pusha
        mov edx, VIDEO_MEMORY       ; Set edx to the start of vid mem

        SomeLoop:
            mov ah, WHITE_ON_BLACK  ; Store the attributes in AH

            mov [edx], ax   ; Store char and attributes at current 
                            ; character cell.
            
            cmp ecx, 1999
            je SomeDone

            add ecx, 1
            add edx, 2

            jmp SomeLoop

        SomeDone:
            popa
            ret
    ; -----------------

    call DetectCPUID
    call DetectLongMode

    ; Enable identity paging
    call SetUpIdentityPaging
    call EditGDT
    jmp CODE_SEG:Start64Bit

[bits 64]

Start64Bit:
    
    jmp $

Message:
    dw "Hello World!!", 0
times 2048-($-$$) db 0
