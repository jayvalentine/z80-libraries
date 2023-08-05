/* Syscall wrappers. */
/* Not all syscalls are represented here - just the ones that need to be called from C programs. */

#ifndef _SYSCALL_H
#define _SYSCALL_H

#include <stdint.h>
#include <stddef.h>

#define SMODE_BINARY 0x01

#define FMODE_READ 0x01
#define FMODE_WRITE 0x02

#define FATTR_SYS 0b00000100
#define FATTR_HID 0b00000010
#define FATTR_RO  0b00000001

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

/* Information about a particular file. */
typedef struct _FINFO
{
    uint8_t attr;

    uint32_t size;

    uint16_t created_year;
    uint8_t created_month;
    uint8_t created_day;
} FINFO;

typedef enum
{
    E_FILENOTFOUND = -1,
    E_FILELIMIT = -2,
    E_INVALIDDESCRIPTOR = -3,
    E_INVALIDFILENAME = -4,
    E_ACCESSMODE = -5,
    E_DISKFULL = -6,
    E_FILEEXIST = -7,
    E_DIRFULL = -8,
    E_INVALIDMODE = -9,
    E_INVALIDPAGE = -10,
    E_INVALIDHEADER = -11
} FileError_T;

typedef int Signal_T;
#define SIG_CANCEL 0x00
#define SIG_BREAK 0x01

typedef struct _SysInfo_T
{
    char * version;
    uint16_t numbanks;
} SysInfo_T;

/* Signal handler function pointer type. */
typedef void (*SIGHANDLER_T)(uint16_t);

void syscall_smode(uint8_t mode);

void syscall_dwrite(char * buf, uint32_t sector);
void syscall_dread(char * buf, uint32_t sector);
const DiskInfo_T * syscall_dinfo(void);

int syscall_fopen(const char * filename, uint8_t mode);
size_t syscall_fread(char * ptr, size_t n, int fd);
size_t syscall_fwrite(char * ptr, size_t n, int fd);
void syscall_fclose(int fd);
int syscall_fdelete(const char * filename);

int syscall_finfo(const char * filename, FINFO * finfo);

uint16_t syscall_fentries(void);
int syscall_fentry(char * s, uint16_t entry);

int syscall_pspawn(int pd, char ** argv, size_t argc);
int syscall_pexec(int pd, char ** argv, size_t argc);
int syscall_pload(const char * filename);
int8_t syscall_pstate(int pid);
void syscall_pexit(int exitcode);
int syscall_pexitcode(int pid);
void syscall_pblock(int event);

void syscall_sighandle(SIGHANDLER_T handle, Signal_T sig);

const SysInfo_T * syscall_sysinfo(void);

#endif /* _SYSCALL_H */
