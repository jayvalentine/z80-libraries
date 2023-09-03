#include <stdio.h>
#include <stdint.h>
#include <string.h>

int syscall_fopen(const char * filename, uint8_t mode)
{
    return 0;
}

char buf[1000];
size_t i = 0;

size_t syscall_fread(char * ptr, size_t n, int fd)
{
    size_t c = 0;
    while (n > 0)
    {
        *ptr = buf[i];
        i++; c++; n--;
    }

    return c;
}

void syscall_fclose(int fd)
{

}

int test_fgets()
{
    strcpy(buf, "this is one line\nthis is the second\r\nthis is the third");

    FILE * f = fopen("test.exe", "r");

    char test[100];

    if (fgets(test, 100, f) != test) return 0;
    if (strcmp(test, "this is one line\n") != 0) return 0;

    if (fgets(test, 100, f) != test) return 0;
    if (strcmp(test, "this is the second\n") != 0) return 0;
    
    if (fgets(test, 100, f) != test) return 0;
    if (strcmp(test, "this is the third") != 0) return 0;

    return 1;
}

int main(void)
{
    if (test_fgets())
    {
        putchar('.');
    }
    else
    {
        putchar('X');
    }

    printf("\ndone\n");

    return 0;
}
