

; eax is callee saved
print16:
print16bit:
  push di
  push esi
  push es

  ; in real mode only the lower 16 bit of the registers are used
  mov si, [esp + 8 + 2]
;   mov eax, welcome
;   mov esi, eax
  ;mov esi, [esp + 8 + 2]

  ; setup datasegment to point to video memory 0xb800 x 0x10 -> 0xb8000 (physical)
  mov ax, 0xb800
  mov es, ax

.print16bit.reposition_index:
  movzx ax, byte [print16bit.ypos]
  mov dx, 80*2   ; 2 bytes (char/attrib)
  mul dx         ; for 80 columns
  movzx cx, byte [print16bit.xpos]
  shl cx, 1      ; times 2 to skip attrib
 
  mov di, 0        ; start of video memory
  add di, ax      ; add y offset
  add di, cx      ; add x offset

  mov ah,0x0F        ; The color: white(F) on black(0)

.print16bit.print_more:
  lodsb      ; grab a byte from SI
  or al, al  ; logical or AL by itself
  jz .print16bit.done   ; if the result is zero, get out
  
  cmp al, `\n`
  je .print16bit.new_line ; if we saw \n go to next line

  mov [es:di], ax

  add byte [print16bit.xpos], 1   ;move right
  add di, 2
  jmp .print16bit.print_more

.print16bit.new_line:
  add byte [print16bit.ypos], 1   ;down one row
  mov byte [print16bit.xpos], 0   ;back to left

  jmp .print16bit.reposition_index

.print16bit.done:

  pop es
  pop esi
  pop di

  ret

print16bit.xpos   db 0
print16bit.ypos   db 0