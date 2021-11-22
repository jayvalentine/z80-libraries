#include <stdio.h>
#include <stdint.h>
#include <string.h>

extern char padding_char;

void printf_char(int16_t c, uint8_t padding)
{
    if (padding != 0)
    {
        for (uint8_t i = 0; i < padding-1; i++) putchar(' ');
    }

    putchar(c);
}

char printf_hex_digit(uint8_t d)
{
    char c;

    /* Invalid hex digit - must be 0-15. */
    if (d > 15) c = '!';

    /* 0-9. */
    else if (d < 10) c = d+'0';

    /* a-f. */
    else c = (d - 10) + 'a';

    putchar(c);
}

void printf_hex(uint16_t h, uint8_t padding)
{
    uint8_t strsize = 1;
    if (h > 0x000f) strsize++;
    if (h > 0x00ff) strsize++;
    if (h > 0x0fff) strsize++;

    if (padding > strsize)
    {
        for (uint8_t i = 0; i < padding-strsize; i++) putchar(padding_char);
    }

    if (strsize == 4) printf_hex_digit((h >> 12) & 0x0f);
    if (strsize >= 3) printf_hex_digit((h >> 8) & 0x0f);
    if (strsize >= 2) printf_hex_digit((h >> 4) & 0x0f);
    printf_hex_digit(h & 0x0f);
}

uint16_t printf_unsigned_digit(uint16_t u, uint16_t n)
{
    char c = '0';

    while (u >= n)
    {
        u -= n;
        c++;
    }

    putchar(c);

    return u;
}

uint8_t uint_strsize(uint16_t u)
{
    uint8_t strsize = 1;
    if (u >= 10) strsize++;
    if (u >= 100) strsize++;
    if (u >= 1000) strsize++;
    if (u >= 10000) strsize++;

    return strsize;
}

void printf_unsigned(uint16_t u, uint8_t padding)
{
    uint8_t strsize = uint_strsize(u);

    if (padding > strsize)
    {
        for (uint8_t i = 0; i < padding-strsize; i++) putchar(padding_char);
    }

    if (strsize == 5) u = printf_unsigned_digit(u, 10000);
    if (strsize >= 4) u = printf_unsigned_digit(u, 1000);
    if (strsize >= 3) u = printf_unsigned_digit(u, 100);
    if (strsize >= 2) u = printf_unsigned_digit(u, 10);

    /* u now < 10. Just add 0! */
    putchar(u + '0');
}

void printf_signed(int16_t d, uint8_t padding)
{
    uint16_t abs;
    if (d < 0) abs = -d;
    else abs = d;

    uint8_t strsize = uint_strsize(abs) + 1;

    if (padding > strsize)
    {
        for (uint8_t i = 0; i < padding-strsize; i++) putchar(padding_char);
    }

    if (d < 0) putchar('-');
    printf_unsigned(abs, 0);
}


void printf_string(char * s, uint8_t padding)
{
    size_t len = strlen(s);

    if (padding > len)
    {
        for (uint8_t i = 0; i < padding-strlen(s); i++) putchar(' ');
    }

    puts(s);
}
