/* Syscall wrappers. */
/* Not all syscalls are represented here - just the ones that need to be called from C programs. */

#ifndef _SYSCALL_H
#define _SYSCALL_H

#include <stdint.h>

void dwrite(char * buf, uint32_t sector);
void dread(char * buf, uint32_t sector);

#endif _SYSCALL_H
