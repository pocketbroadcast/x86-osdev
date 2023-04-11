#ifndef STDIO_H
#define STDIO_H

void puts(char *str);
void putc(char c);

void put_hexbyte(char byte);
void put_hexword(short word);

#define byte char

#endif