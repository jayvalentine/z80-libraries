#include <syscall.h>

int syscall_pexec(int pd, char ** argv, size_t argc)
{
    syscall_pspawn(pd, argv, argc);

    /* Block current task on the child and then wait
     * until child is finished.
     */
    syscall_pblock(1);
    while (syscall_pstate(pd) != 2) {}

    return syscall_pexitcode(pd);
}
