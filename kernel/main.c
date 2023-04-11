#include "include/serial.h"
#include "include/stdio.h"

void doStuff()
{
    puts("hi from c!");
}

int main()
{
    putc('\n');
    putc('\n');
    putc('\n');
    putc('\n');
    puts("Welcome to second stage! - To exit (qemu) press Ctrl+A X\n");

    puts("Load serial config from BIOS Data Area: ");
    volatile short* biosDataArea = 0x0400;
    for(int i=0; i<4;i++){
        put_hexword(*(biosDataArea+i));
        putc(' ');
    }
    putc('\n');
    
    puts("Init serial...");
    init_serial();
    puts("success\n");

    puts("Nr of hard disks: ");
    put_hexbyte(*(unsigned char*)(0x0475));
    putc('\n');

    puts("Nr of hard disks: ");
    char x = read_serial();
    write_serial('h');
    write_serial(x);
    write_serial(x);

    doStuff();
    for (;;)
        ;
}