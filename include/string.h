// string.h
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

#include <stddef.h>

#define NULL 0

int strcmp(const char *s1, const char *s2);

size_t strlen(const char * s);

char * strchr(const char * s, int c);
char * strcpy(char * s1, const char * s2);

void * memcpy(char * dst, const char * src, size_t n);
void * memset(void * s, int c, size_t n);
