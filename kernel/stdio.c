#include "include/stdio.h"

#define IO_REDIRECT_SCREEN
#define IO_REDIRECT_SERIAL


#ifdef IO_REDIRECT_SERIAL
#include "include/serial.h"
#endif

#ifdef IO_REDIRECT_SCREEN
static int posX = 0;
static int posY = 0;
#endif


void puts(char *str)
{
    while (*str != 0)
    {
        putc(*str);
        str++;
    }
}

void putc(char c)
{
    #ifdef IO_REDIRECT_SERIAL
    write_serial(c);
    #endif
    
    #ifdef IO_REDIRECT_SCREEN
    if (c == '\n')
    {
        posY++;
        posX = 0;
        return;
    }

    volatile short *text_mem = (short *)0xb8000;
    text_mem[posY * 80 + posX] = 0x0F00 | c;

    posX++;
    #endif
}

void put_hexdigit(byte digit)
{
    if (digit > 9)
        putc('A' + digit - 10);
    else
        putc('0' + digit);
}

void put_hexbyte(byte data)
{
    char upper = (data & 0xF0) >> 4;
    char lower = data & 0x0F;

    put_hexdigit(upper);
    put_hexdigit(lower);
}

void put_hexword(short word)
{
    char first = (word & 0xFF00) >> 8;
    char second = (word & 0xFF);

    put_hexbyte(first);
    put_hexbyte(second);
}
