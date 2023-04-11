#include <stdint.h>
#include <string.h>
#include "include/init.h"

struct gdtr {
    uint16_t limit;
    uint32_t base;
} __attribute__ ((packed));

struct gdtdesc {
    uint16_t lim0_15;
    uint16_t base0_15;
    uint8_t base16_23;
    uint8_t acces;
    uint8_t lim16_19:4;
    uint8_t other:4;
    uint8_t base24_31;
} __attribute__ ((packed));


#define GDTBASE 0x00000800
#define GDTSIZE 3

struct gdtdesc 	kgdt[GDTSIZE];		/* GDT */
struct gdtr 		kgdtr;		

void init_gdt_desc(uint32_t base, uint32_t limit, uint8_t acces, uint8_t other, struct gdtdesc *desc)
{
    desc->lim0_15 = (limit & 0xffff);
    desc->base0_15 = (base & 0xffff);
    desc->base16_23 = (base & 0xff0000) >> 16;
    desc->acces = acces;
    desc->lim16_19 = (limit & 0xf0000) >> 16;
    desc->other = (other & 0xf);
    desc->base24_31 = (base & 0xff000000) >> 24;
    return;
}


void init_gdt(void)
{
    /* initialize gdt segments */
    init_gdt_desc(0x0, 0x0, 0x0, 0x0, &kgdt[0]);
    init_gdt_desc(0x0, 0xFFFFFFFF, 0x9A, 0xCF, &kgdt[1]);    /* code */
    init_gdt_desc(0x0, 0xFFFFFFFF, 0x92, 0xCF, &kgdt[2]);    /* data */

    /* initialize the gdtr structure */
    kgdtr.limit = GDTSIZE * 8;
    kgdtr.base = GDTBASE;

    /* copy the gdtr to its memory area */
    memcpy((char *) kgdtr.base, (char *) kgdt, kgdtr.limit);

    /* load the gdtr registry */
    asm("lgdtl (kgdtr)");

    /* initiliaz the segments */
    asm("   movw $0x10, %ax    \n \
            movw %ax, %ds    \n \
            movw %ax, %es    \n \
            movw %ax, %fs    \n \
            movw %ax, %gs    \n \
            ljmp $0x08, $next    \n \
            next:        \n");
}