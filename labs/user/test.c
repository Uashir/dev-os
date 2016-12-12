#include <inc/lib.h>

void umain(void) {
    envid_t who;
    void *va;

    if ((who = fork()) < 0)
        panic("fork failed: %e", who);

    if (who == 0) {
        cprintf("I am a child! \n");
        va = (void *)(0x00980000);
        sys_page_alloc(env->env_id, va, PTE_P | PTE_U | PTE_W);
        ipc_recv(0, va, 0);
        // number
        /*cprintf("Child recive %d\n", *(int *)va);*/
        // string
        cprintf("Child recive \"%s\"\n", (char *)va);
        cprintf("Child say NOOOOOO!\n");
        exit();
    } else {
        cprintf("I am a parent! \n");
        va = (void *)(0x00990000);
        sys_page_alloc(env->env_id, va, PTE_P | PTE_U | PTE_W);
        // number
        *(int *)va = 42;
        // string
        snprintf((char *) va, 20, "I am your father!");

        ipc_send(who, 0, va, PTE_U);

        // string
        cprintf("Parent send \"%s\"\n", (char *)va);
        // number
        /*cprintf("Parent send %d\n", *(int *)va);*/
    }
}
