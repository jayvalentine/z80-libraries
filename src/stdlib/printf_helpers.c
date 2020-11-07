#include <stdio.h>
#include <stdint.h>
#include <string.h>

void printf_char(int16_t c, uint8_t padding)
{
    for (uint8_t i = 0; i < padding-1; i++) putchar(' ');
    putchar(c);
}

void printf_hex(uint16_t h, uint8_t padding)
{

}

uint16_t printf_unsigned_digit(uint16_t u, uint16_t n)
{
    char c = '0';

    while (u > 0)
    {
        u -= n;
        c++;
    }

    putchar(c);

    return u+n;
}

void printf_unsigned(uint16_t u, uint8_t padding)
{
    uint8_t strsize = 1;
    if (u >= 10) strsize++;
    if (u >= 100) strsize++;
    if (u >= 1000) strsize++;
    if (u >= 10000) strsize++;

    for (uint8_t i = 0; i < padding-strsize; i++) putchar(' ');

    if (strsize == 5) u = printf_unsigned_digit(u, 10000);
    if (strsize >= 4) u = printf_unsigned_digit(u, 1000);
    if (strsize >= 3) u = printf_unsigned_digit(u, 100);
    if (strsize >= 2) u = printf_unsigned_digit(u, 10);

    /* u now < 10. Just add 0! */
    putchar(u + '0');
}

void printf_string(char * s, uint8_t padding)
{
    for (uint8_t i = 0; i < padding-strlen(s); i++) putchar(' ');
    puts(s);
}
