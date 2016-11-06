#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>


// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

	// LAB 4: Your code here.
	int start_idx = curenv ? ENVX(curenv->env_id) : 0;
	int i;
	for (i = 0; i < NENV; ++i) {
		int idx = (start_idx + i + 1) % NENV;

		if (idx == 0 || envs[idx].env_status != ENV_RUNNABLE)
			continue;

		env_run(&envs[idx]);

		assert(0); // this code shouldn't be run
	}

	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
		env_run(&envs[0]);
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
		while (1)
			monitor(NULL);
	}
}
