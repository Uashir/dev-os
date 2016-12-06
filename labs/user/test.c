#include <inc/lib.h>

char message[256];

void
umain(void)
{
    void *paddr = message;
    envid_t who;
    int r;

    if ((who = fork()) < 0)
        panic("fork failed: %e", who);

    if (who == 0) {
        char *page = ROUNDDOWN(paddr, PGSIZE);
        char *msg = page + ((char *)message - (char *)ROUNDDOWN(paddr, PGSIZE));
        int perms;

        if ((r = ipc_recv(NULL, page, &perms)) != 0)
            panic("ipc_recv failed: %e", r);

        cprintf("got message: '%s'\n", msg);
        exit();
    }

    // parent
    strcpy(message, "i am parent");
    ipc_send(who, 0, ROUNDDOWN(paddr, PGSIZE), PTE_U);

    cprintf("parent: send '%s' to child (%d)\n", message, who);
}