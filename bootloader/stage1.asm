[org 0x7C00]   ; add 0x7C00 to label addresses
[bits 16]      ; tell the assembler we want 16 bit code

start:
   ;;
   ;; setup segment register
   ;; initialize stack
   ;;
   mov ax, 0  

   ; reset segment registers
   ; do not reset segment register cs! mov cs, ax
   
   mov ds, ax     ; data segment
   mov es, ax     ; data segment
   mov fs, ax     ; data segment
   mov gs, ax     ; data segment

   ; initialize stack
   mov ss, ax     ; stack segment
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00

   ;
   ; real mode execution
   ;
   mov ax, welcome
   push ax
   call print16
   sub esp, 2

   ;
   ; load second stage 32 bit bootloader using bios functions
   ;
   mov ax, info_load_stage2
   push ax
   call print16
   sub esp, 2

   call load_2nd_stage

   mov ax, info_success
   push ax
   call print16
   pop ax

   ;;
   ;; switch to protected (32-bit) mode - from there on bios functions won't be available anymore
   ;;
   ; disable interrupts
   cli

   ; switch to protected mode
   ; Note: No more bios functions via interrupts from here!
   mov eax, cr0
   or al, 0x01
   mov cr0, eax

   ; setup gdt and segments
   lgdt [gdtinfo]

   mov ax, 0x10; 0x08;DATA_SEG        ; 5. update segment registers
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax
   
   ; initialize stack
   mov ebp, 0x90000
   mov esp, ebp
   ;mov esp, 0x7C00 ; stack grows downwards from 0x7C00

   ; setup code segment
   jmp 0x08:flush_gdt
flush_gdt:
   jmp run_2nd_stage

%include "print_mem16.asm"
%include "load_2nd_stage_real.asm"

;;;;;;;
[bits 32]

run_2nd_stage:
   jmp STAGE2_OFFSET

;;;;;;;

welcome db `Welcome! - To exit (qemu) press Ctrl+A X\n`, 0
info_load_stage2 db 'Loading Stage 2 from second sector...', 0
info_success db `success\n`, 0

gdtinfo:
   ;dw gdt_end - gdt - 1   ;last byte in table
   dw 8*3-1
   dd gdt         ;start of table

gdt:
dd 0x00000000, 0x00000000  ; entry 0 is always unused

;               LIMIT 15..0: 0xffff
;               BASE 15..0 : 0, 0 
;               BASE 23..16: 0
;               flags      : 1001 0010b
;               flags+LIMIT: 1100 1111b
;               BASE 31..24: 0
os_code_pdpl0type equ  10011010b  ;0x9A
os_code_flags     equ 11001111b   ;0xCF

oscode db 0xff, 0xff, 0x00, 0x00, 0x00, os_code_pdpl0type, os_code_flags, 0x00

os_data_pdpl0type equ 10010010b ; 0x92
os_data_flags     equ 11001111b ; 0xCF

osdata db 0xff, 0xff, 0x00, 0x00, 0x00, os_data_pdpl0type, os_data_flags, 0x00

gdt_end:

times 510-($-$$) db 0
dw 0AA55h ; some BIOSes require this signature
