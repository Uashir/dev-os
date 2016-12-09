# Ответы на вопросы для ЛР №5

1. Idle task is used for scheduling purposes: it is scheduled when there are no available running environments. It is not strictly necessary in multitask systems, but is used in majority of them, since knowing that there is always one process active is making task scheduling easier.
2. By using round-robin algorithm through envs starting from current process. It skips the idle process (env[0]) until there is no more runnable processes.
3. There is none. To find the runnable process we must cycle through envs looking for set status ENV_RUNNABLE.
4. It would pass the check (va >= UTOP) and subsequently returned with code -E_INVAL.
5. No, everything above UTOP must be mapped identically. 
6. A changing process must have the same env_id as changed process's parent (env_parent_id), or be the same process (when process changes itself).
7. Yes, process that initiates sys_page_map must have permission to source/destination processes as described above. Permission is checked in envid2env().
8. Dumbfork first allocates a new environment for its child, then copies its entire address space to child (that includes copying physical memory) and its user stack, and finally marks child environment as runnable. Since we hardcopy ALL address space pages, this approach requires an excessive amount of both virtual and physical memory, and is unefficient.
9. Everything above UTOP (UENV) is mapped identically on all environments.
10. ss/eip and cs/esp are mandatory. All others are not (eax must be 0 for child process).
11. No, look at question 30. Even if we add "finit", we don't save FPU register values before switching tasks, so either values will be overwritten by "finit" or we may cause an exception.
12. By "duppage(envid, ROUNDDOWN(&addr, PGSIZE))" command.
13. By command "env = &envs[ENVX(sys_getenvid())]", when dumbfork is returned to in child process.
14. Yes, if it's neither source nor destination.
