#include <syscall.h>

int syscall_pexec(int pd, char ** argv, size_t argc)
{
    syscall_pspawn(pd, argv, argc);
}
