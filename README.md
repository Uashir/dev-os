# Ответы на вопросы для ЛР №8

NOTE: only 971 environments could be created in user_primes. Only 7848 pages can be allocated (68 for kernel needs, 13 for idle, 15 for user_primes, and 8 for any user_primes fork [1002 - 13ca]).

1.  sys_ipc_recv sets env_ipc_recving field as 1, which means process is expecting a message. If sys_ipc_try_send tries to send a message to not-expecting process, ipc_send panics.
2.  The latter. The context is received from envoironment's trapframe, where cs-eip are pointing to command after sys_ipc_recv.
3.	By setting EAX field in envoironment's trapframe register stack structure, and then giving control to another process. After returning, EAX will be recovered from register stack as return value.
4.	Yes, since only sys_ipc_try_send can set receiving env's status as ENV_RUNNABLE. No, however, ipc_send is kinda.
5.	No, since it can and will get its process time. Yes, since it won't return till data is sent.
6.	Yes, which is exactly what pingpong does. [?]
7.	Yes, if multiple processes get stuck on receiving from each other, since sys_ipc_recv is blocking.
8.	Not really, considering we have weird position-based round-robin scheduling algorithm. [?]
9.	For limiting access to page. One process can send another a page marked as read-only, so that receiving process would be unable to modify data.
10.	Synchronous, kind of. Receive is synchronous system-wise, but send is synchronous only user-wise, with sys_ipc_try_send not halting sending process.
11.	One process hangs to receive and returns control. Other tries to send (if it fails, it returns control). Then first process can access data. 3 processor tacts minimum.
12.	To receive, process has to enter ENV_NOT_RUNNABLE status, so no. Unless it forks, then it's fair game.
13.	Yes, if it knows envid (or ENVX) of receiving process. (&envs[ENVX(envid)])->env_ipc_value is fair game. envid2env is also fair game, but requires specific permissions.
14.	Actually, only 971 primes will be found due to physical space limitations.
15.	Image 10.1.
16.	No. It loops in sys_ipc_try_send/sys_yield, but it still gets its share of processor time.
17.	No, APIC is needed. We need to rewrite "picirq.c" and whole IRQ handling. Also we need to make kernel reenterable.
18.	No, there is no queue.
19.	No, unless first process gets freed by an error or is forced to give up his processor time.
