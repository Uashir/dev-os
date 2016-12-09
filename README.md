# Ответы на вопросы для ЛР №4

1. GD_KT + name (as offset) for trap entry. GD_KD + KSTACKTOP for stack top (kernel side).
2. Syscall requires CPL of 3, pagefault - 0 (softint tries to do it with 3, but fails)
3. Proper protection (kernel-only interrupts) and error saving (some interrupts must put error code into stack themselves).
4. Linear address.
5. Task State Segment is used in JOS only for saving stack address (ss-esp) for kernel (for interrupt handling).
6. Everything up until tf_err (tf_err and tf_trapno in unique handlers, registers and es/ds in _alltraps).
7. No, kernel just pushes another Trapframe on top of previous one (for nested interrupts, like double fault). No saving ss and esp values.
8. Trapframe is used for saving environment values (registers and es/ds) before calling trap. Also for saving syscall results.
9. At the beginning of trap handler (only those traps defined by TRAPHANDLER_NOEC) through "pushl $0".
10. curenv->env_tf = *tf. *tf is esp value from _alltraps.
11. esp parameter (_alltraps), which points at our Trapframe. Probably yes, but we should preserve our stack (also, sending esp is easier).
12. Memory protection issues. User should not be able to tamper with memory.
13. es register might be used during some machine instructions (like stos), so we should save it.
14. They are not changed by machine instructions, since they have no processor-defined purpose.
15. Environment could become corrupted during single or nested interruptions.
16. ebp register was changed during c function calls, so we need to zero it again.
17. Via syscall interrupt:
		asm volatile("int %1\n"
		: "=a" (ret)
		: "i" (T_SYSCALL),
		  "a" (num),
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
18. Five - edx, ecx, ebx, edi, esi (eax is used as syscallno and return value).
19. Save the value of ebp - needed for called function sequence.
20. On some architectures (i386), yes, eax is mandatory. No, number just needs to be higher than 31.
21. Through eax value saved in stack (mov    0x8(%ebp),%eax).
22. Only access permissions - anything above UTOP (UENVS) is identical for all envs.
23. cprintf functions are identical in code, but they are called by different privilege levels, so vcprintf on kernel side just outputs the string, while
	vcprintf on user side fills string into struct printbuf and then calls sys_cputs, which calls cprintf on kernel side.
24. Yes, since both user and kernel are located at the same address space.
25. Via user_mem_check/user_mem_assert functions (pmap.c)
26. No, we won't check the permissions of pages between addresses then.
27. From invalid addresses (like null pointer) or addresses with invalid permissions (write on read-only page and etc).
28. 0 pointer. Anything above KERNBASE.
29. Nothing above ULIM can be read/written by user, so we save on page directory (page table) walking time.
30. No, since kernel doesn't clear FPU registers by "finit" ASM command, which causes invalid operation exception at FPU. Adding "finit" will mitigate such problem. 
31. So that new environment couldn't tamper with children of his predecessor from envs[] (they share the same ENVX).
