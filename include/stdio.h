// stdio.h.
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

#ifndef _STDIO_H
#define _STDIO_H

#include <stdint.h>
#include <stddef.h>

typedef struct _IO_FILE
{
    uint32_t size;
    uint32_t fpos; /* Not actually used for indexing the file, just for keeping track of size. */
    
    uint16_t start_cluster;
    uint16_t current_cluster;

    uint8_t sector; /* Limitation - can't handle more than 256 sectors per cluster. */
    uint16_t fpos_within_sector;
} FILE;

#define NULL 0
#define EOF -1

// puts
// Prints a string to standard output (serial port).
int     puts(const char *s) __z88dk_fastcall;

// putchar
// Prints a character to standard output (serial port).
char     putchar(char c) __z88dk_fastcall;

// getchar
// Returns a character from standard input (serial port).
char     getchar(void);

// gets
// Gets a newline-terminated string of input from standard input (serial port).
char *   gets(char *s) __z88dk_fastcall;

// printf
// Prints a formatted string to standard output.
// Currently only the most basic %u (unsigned integer) format is provided,
// with no provision for spacing/padding.
int     printf(const char *format, ...);

/* fopen
 * Opens a file in the given mode.
 * Returns a handle to that file.
 */
FILE * fopen(const char * filename, const char * mode);

/* fclose
 * Closes an open file.
 */
int fclose(FILE * stream);

/* fread
 * Reads a number of generic data items from a stream.
 * Returns the number of items read.
 */
size_t fread(void * ptr, size_t size, size_t n, FILE * stream);

#endif /* STDIO_H */
