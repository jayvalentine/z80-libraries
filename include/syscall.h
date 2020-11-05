/* Syscall wrappers. */
/* Not all syscalls are represented here - just the ones that need to be called from C programs. */

#ifndef _SYSCALL_H
#define _SYSCALL_H

#include <stdint.h>
#include <stddef.h>

#define FMODE_READ 0x01

/* Information about the disk. Needed for filesystem interaction. */
typedef struct _DiskInfo
{
    /* Region start sectors. */
    uint32_t fat_region;
    uint32_t root_region;
    uint32_t data_region;

    /* Other info. */
    uint16_t bytes_per_sector;
    uint8_t sectors_per_cluster;
    uint16_t bytes_per_cluster;
    uint32_t num_sectors;
} DiskInfo_T;

typedef enum
{
    E_FILENOTFOUND = -1,
    E_FILELIMIT = -2
} FileError_T;

void syscall_dwrite(char * buf, uint32_t sector);
void syscall_dread(char * buf, uint32_t sector);
const DiskInfo_T * syscall_dinfo(void);

int syscall_fopen(const char * filename, uint8_t mode);
size_t syscall_fread(char * ptr, size_t n, int fd);
void syscall_fclose(int fd);

#endif /* _SYSCALL_H */
