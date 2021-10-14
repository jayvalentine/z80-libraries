// string.h
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

#include <stddef.h>

#define NULL 0

int strcmp(const char *s1, const char *s2);

#ifdef Z88DK
size_t strlen(const char * s) __z88dk_fastcall;
#else
size_t strlen(const char * s);
#endif

char * strtok(char * s1, const char * s2);
char * strchr(const char * s, int c);
char * strcpy(char * s1, const char * s2);

void * memcpy(char * dst, const char * src, size_t n);
void * memset(void * s, int c, size_t n);
