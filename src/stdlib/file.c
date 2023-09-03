#include "file.h"
#include "syscall.h"

#include <stdlib.h>
#include <stdio.h>

extern FILE thefile;

FILE * fopen(const char * filename, const char * mode)
{
    mode;
    
    int fd = syscall_fopen(filename, FMODE_READ);
    
    thefile.fd = fd;
    return &thefile;
}

int fclose(FILE * stream)
{
    syscall_fclose(stream->fd);
    return 0;
}

char * fgets(char * str, int n, FILE * stream)
{
    char * str_orig = str;

    for (int i = 0; i < n; i++)
    {
        char c;
        size_t read = syscall_fread(&c, 1, stream->fd);
        if (read != 1) break;

        *str = c;
        str++;

        if (c == '\n') break;
    }
    
    if (str_orig == str) return NULL;
    *str = '\0';
    return str_orig;
}