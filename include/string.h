// string.h
// Implementation for Modular-Z80 platform.
// Copyright (c) Jay Valentine 2020.

#define NULL 0

typedef unsigned int size_t;

int strcmp(const char *s1, const char *s2);
void * memcpy(char * dst, const char * src, size_t n);
char * strtok(char * s1, const char * s2);
