build-bootloader:
	nasm bootloader/stage1.asm -Ibootloader -f bin -o bootloader.bin
	
clean-bootloader:
	rm bootloader.bin
	
build-kernel:
	nasm -Ikernel -f elf -o start.o kernel/start.asm
	gcc -m32 -Wall -fomit-frame-pointer -fno-pic -nostdinc -fno-builtin -I./kernel/include -c -o main.o kernel/main.c
	gcc -m32 -Wall -fomit-frame-pointer -fno-pic -nostdinc -fno-builtin -I./kernel/include -c -o serial.o kernel/serial.c
	gcc -m32 -Wall -fomit-frame-pointer -fno-pic -nostdinc -fno-builtin -I./kernel/include -c -o stdio.o kernel/stdio.c
	gcc -m32 -Wall -fomit-frame-pointer -fno-pic -nostdinc -fno-builtin -I./kernel/include -c -o string.o kernel/string.c
	gcc -m32 -Wall -fomit-frame-pointer -fno-pic -nostdinc -fno-builtin -I./kernel/include -c -o init.o kernel/arch/x86/gdt.c
	ld  -m elf_i386 -T kernel/link.ld -o kernel.bin start.o main.o serial.o stdio.o string.o init.o

clean-kernel:
	rm start.o main.o serial.o stdio.o kernel.bin

run: build-bootloader build-kernel
	qemu-system-x86_64 -fda bootloader.bin -hda kernel.bin -serial stdio
	
all: run

clean: clean-bootloader clean-kernel

inspect:
	hexdump bootloader.bin
	hexdump kernel.bin
	

