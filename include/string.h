// string.h
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

#include <stdint.h>

#define NULL 0

typedef uint16_t size_t;

int strcmp(const char *s1, const char *s2);
char * strtok(char * s1, const char * s2);

void * memcpy(char * dst, const char * src, size_t n);
void * memset(void * s, int c, size_t n);
