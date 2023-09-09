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

    thefile.bytes_read = 0;
    thefile.buf_pos = 0;
    thefile.eof = 0;

    return &thefile;
}

/* Helper method.
 *
 * Fills file buf with data for use by file API functions.
 * Sets EOF if the full file has been read.
 */
static void file_readblock(void)
{
    size_t read = syscall_fread(thefile.buf, FILE_BLOCK_SIZE, thefile.fd);

    thefile.bytes_read = read;
    thefile.buf_pos = 0;

    if (read < FILE_BLOCK_SIZE) thefile.eof = 1;
}

/* Helper method.
 *
 * Returns the next byte from the file, or -1 if EOF.
 */
inline static int file_readbyte(void)
{
    if (thefile.buf_pos < thefile.bytes_read)
    {
        int c = (int)(thefile.buf[thefile.buf_pos]);
        thefile.buf_pos++;
        return c;
    }
    else
    {
        /* If we've hit the end of the current block and EOF is set,
         * then we've reached the end of the file.
         */
        if (thefile.eof) return -1;

        /* Otherwise read the first byte from the next block. */
        file_readblock();

        /* If no bytes were read then we've reached EOF. */
        if (thefile.bytes_read == 0) return -1;

        /* Otherwise we can read a byte. */
        int c = (int)(thefile.buf[0]);
        thefile.buf_pos = 1;
        return c;
    }
}

int fclose(FILE * stream)
{
    syscall_fclose(stream->fd);
    return 0;
}

char * fgets(char * str, int n, FILE * stream)
{
    stream;
    char * str_orig = str;

    for (int i = 0; i < n; i++)
    {
        int c = file_readbyte();
        if (c == -1) break;

        *str = c;
        str++;

        if (c == '\n' || c == '\r') break;
    }
    
    if (str_orig == str) return NULL;
    *str = '\0';
    return str_orig;
}