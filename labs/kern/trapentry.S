/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

 TRAPHANDLER_NOEC(trap_handle_divide_error, T_DIVIDE);
 TRAPHANDLER_NOEC(trap_handle_debug_exception, T_DEBUG);
 TRAPHANDLER_NOEC(trap_handle_non_maskable_interrupt, T_NMI);
 TRAPHANDLER_NOEC(trap_handle_breakpoint, T_BRKPT);
 TRAPHANDLER_NOEC(trap_handle_overflow, T_OFLOW);
 TRAPHANDLER_NOEC(trap_handle_bounds_check, T_BOUND);
 TRAPHANDLER_NOEC(trap_handle_illegal_opcode, T_ILLOP);
 TRAPHANDLER_NOEC(trap_handle_device_not_available, T_DEVICE);
 TRAPHANDLER(trap_handle_double_fault, T_DBLFLT);
 TRAPHANDLER(trap_handle_invalid_task_switch_segment, T_TSS);
 TRAPHANDLER(trap_handle_segment_not_present, T_SEGNP);
 TRAPHANDLER(trap_handle_stack_exception, T_STACK);
 TRAPHANDLER(trap_handle_general_protection_fault, T_GPFLT);
 TRAPHANDLER(trap_handle_page_fault, T_PGFLT);
 TRAPHANDLER_NOEC(trap_handle_floating_point_error, T_FPERR);
 TRAPHANDLER(trap_handle_aligment_check, T_ALIGN);
 TRAPHANDLER_NOEC(trap_handle_machine_check, T_MCHK);
 TRAPHANDLER_NOEC(trap_handle_simd_floating_point_error, T_SIMDERR);

 TRAPHANDLER_NOEC(trap_handle_system_call, T_SYSCALL);


/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	pushl %ds
	pushl %es
	pushal

	movl $GD_KD, %eax
	movw %ax, %ds
	movw %ax, %es
	pushl %esp

	call trap
