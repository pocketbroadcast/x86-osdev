STAGE2_OFFSET equ 0x2000

load_2nd_stage:
    ; read 512 bytes from disk
    mov ah, 0x02 ; cmd: read sectors in memory

    mov al, 16 ; nr of sectors to read (1 sector =~ 512bytes)
    mov ch, 0    ; cylinder number (low eight bits)
    ;mov cl, 2    ; sector nr 1-63 (bits 0-5) - wrong sector! -error
    mov cl, 1    ; sector nr 1-63 (bits 0-5)
    mov dh, 0    ; head number
    mov dl, 0x80 ; drive: first harddisk

    xor bx, bx
    mov es, bx
    mov bx, STAGE2_OFFSET ; copy after current code -> 512bytes from origin address 7c00h

    int 0x13

;;;;;;;;;;;;
;    ; ah holds return value
;    mov ch, ah
;
;    ; print msb
;    mov al, ch
;    and al, 0xF0
;    shr al, 4
;    cmp al, 0x09
;    jge .add_a1
;    add al, '0'
;    jmp .print_it1
; .add_a1:
;    add al, 'A'-10
; .print_it1:
;    mov ah, 0x0E
;    int 0x10
;
;
;    ; print lsb
;    mov al, ch
;    and al, 0x0F
;    cmp al, 0x09
;    jge .add_a2
;    add al, '0'
;    jmp .print_it2
; .add_a2:
;    add al, 'A'-10
; .print_it2:
;    mov ah, 0x0E
;    int 0x10
;;;;;;;;;;;;

    or ch, ch
    jnz load_2nd_stage   ; retry

    ret

