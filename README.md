# Ответы на вопросы для ЛР №3

1. Environment status (Env.env_status => ENV_RUNNABLE (1), ENV_NOT_RUNNABLE (2)). Running environment is in curenv.
2. No need for ENV_RUNNING, because only one environment can run at any give point. This environment is located at curenv.
3. Free environment list is used for simplifying environment's initilization/destruction procedures.
4. Easier to control unique environmnet IDs, as shown in /inc/env.h. Dynamic list may cause IDs to overlap.
5. In order (after kernel boot)
	start (kern/entry.S);
	i386_init (kern/init.c);
	cons_init (kern/console.c);
	i386_detect_memory (kern/pmap.c);
	i386_vm_init (kern/pmap.c);
	page_init (kern/pmap.c);
	env_init (kern/env.c);
	idt_init (kern/trap.c);
	env_create (kern/env.c);
	env_run (kern/env.c);
	env_pop_tf (kern/env.c);
6. env_run function. cr3 register (pgdir kernel address), all segment registers (ss is important), and eip/esp for iret. 
7. 0 is kernel, 3 is user. 1 and 2 are unused. By CPL part of SS register (lower 2 bits).
8. Just zeroes it. memset((void*)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);
9. This command would just flush current TLB.
10. memmove(e->env_pgdir + PDX(UTOP), boot_pgdir + PDX(UTOP), NPDENTRIES - PDX(UTOP));
11. page_insert(e->env_pgdir, p, (void*)(USTACKTOP - PGSIZE), PTE_U | PTE_W) (or e->env_tf.tf_esp = USTACKTOP)
12. Instruction int 0x30. System call interruption. Causes triple fault and reboot since system can't handle ints yet.
13. They are used as a padding (duh) for 16-bit segments (16 + 16 = 32). For stack purposes.
14. We need to save for other use, but it will be rewritten, so no need for cleaning.
15. Page reference counter is automatic only for page tables below UTOP.
16. Since we did `memmove((void*)ph->p_va, (void*)(binary + ph->p_offset), ph->p_filesz);` in environment's pagedir, freeing pages removed this data.
17. Like this (env_free in kern/env.c)
	```for (pteno = 0; pteno <= PTX(~0); pteno++) {
		if (pt[pteno] & PTE_P)
			page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
	}```
