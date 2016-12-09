# Ответы на вопросы для ЛР №6

1.	32. That means all IRQs are located right after reserved exceptions 0-31, and after 16 IRQs (32-47) goes syscall at 48.
2.	Through setting FL_IF bit in environment's eflags (env->env_tf->tf_eflags). Through setting all gates as interrupt gates (automatic FL_IF clearing), since exceptions/syscalls/interrupts are the only times we switch to kernel mode.
3.	The function of the 8259 PIC is to manage hardware interrupts and send them to the appropriate system interrupt. This allows the system to respond to devices needs without loss of time (from polling the device, for instance).
4.	IRQ 2, since second pin of PIC is used to receive signal from second PIC (cascade interrupt IRQ 9 -> IRQ 2).
5.	Through ICW (Initialization Common Word), specifically, ICW 2, which contains the offset of ISRs. ICWs are generated by CPU via outb command in pic_init function.
6.	EOI signal is issued to PIC chip(s) to indicate the completion of interrupt processing for a given interrupt, and allow new PIC interrupts to be generated. Usually is sent at the end of ISR (Interrupt Service Routine), right before IRET. If automatic EOI mode is set, EOI signal is issued at the start of ISR.
7.	Right after EOI signal has been issued, since that clears the IS (In Service) bit in PIC register.
8.	No, they can't, since that behavior can lead to errors.
9.	Still no, question 11. 
10.	Only major difference is that in round-robin scheduler newest tasks are put into the end, but in our implementation they might be placed anywhere (relatively to start).
11.	Two: env[0] is the lowest, all others are highest.
12.	Into env during trap function execution (entire Trapframe is copied). They are restored during env_pop_tf function execution
13.	Timer is reset before process gets the processor time (EOI is sent during processor-side interrupt handling), so no.
