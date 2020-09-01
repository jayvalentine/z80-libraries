// stdio.h.
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

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
