#ifndef EXTERNAL_H
#define EXTERNAL_H

unsigned char inb(unsigned short _port);
void outb(unsigned short _port, unsigned char _data);

// Reading from the I/O ports to get data
// from devices such as the keyboard. We are using what is called
// 'inline assembly' in these routines to actually do the work
inline unsigned char inb(unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__("inb %1, %0"
                         : "=a"(rv)
                         : "dN"(_port));
    return rv;
}

/* We will use this to write to I/O ports to send bytes to devices. This
 *  will be used in the next tutorial for changing the textmode cursor
 *  position. Again, we use some inline assembly for the stuff that simply
 *  cannot be done in C */
inline void outb(unsigned short _port, unsigned char _data)
{
    __asm__ __volatile__("outb %1, %0"
                         :
                         : "dN"(_port), "a"(_data));
}

#endif