;[org 0x7e00]   ; add 0x7E00 to label addresses - second stage boot loader is loaded there from stage 1
[bits 32]      ; tell the assembler we want 32 bit code
global start
extern main

start:
   call main

infinity:
   jmp infinity

; Here is the definition of our BSS section. Right now, we'll use
; it just to store the stack. Remember that a stack actually grows
; downwards, so we declare the size of the data before declaring
; the identifier '_sys_stack'
SECTION .bss
   resb 8192               ; This reserves 8KBytes of memory here
_sys_stack: