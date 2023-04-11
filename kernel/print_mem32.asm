; ; eax is callee saved

print32:
print32bit:

   push edi
   push esi

  mov esi, [esp + 8+4]

.print32bit.reposition_index:
  movzx eax, byte [print32bit.ypos]
  mov edx, 80*2   ; 2 bytes (char/attrib)
  mul edx         ; for 80 columns
  movzx ecx, byte [print32bit.xpos]
  shl ecx, 1      ; times 2 to skip attrib
 
  mov edi, 0xb8000  ; start of video memory
  add edi, eax      ; add y offset
  add edi, ecx      ; add x offset

  mov ah,0x0F        ; The color: white(F) on black(0)

.print32bit.print_more:
  lodsb      ; grab a byte from SI
  or al, al  ; logical or AL by itself
  jz .print32bit.done   ; if the result is zero, get out
  
  cmp al, `\n`
  je .print32bit.new_line ; if we saw \n go to next line

  ;mov [es:di], ax
  mov [edi], ax

  add byte [print32bit.xpos], 1   ;move right
  add edi, 2
  jmp .print32bit.print_more

.print32bit.new_line:
  add byte [print32bit.ypos], 1   ;down one row
  mov byte [print32bit.xpos], 0   ;back to left

  jmp .print32bit.reposition_index

.print32bit.done:

  pop esi
  pop edi

  ret

print32bit.xpos   db 0
print32bit.ypos   db 4