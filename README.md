# Оветы на вопросы для ЛР №1

1. First command is "jmp far f000e05b". Jumps to beginning of the BIOS Power-on Reset Code.
2. Because real mode can't access memory above 1 Mb. It's required for loading kernel. Virtual addresses start from f0000000.
3. All interruptions only in real mode. Can't interrupt during protected mode.
4. By command "movl $start, %esp". Stack is located at zero, since SS register is zeroed.
5. By command "movl %eax, %cr0" which sets PE flag in CR0 register.
6. Like this (courtesy of boot.S)

        gdt:
    	SEG_NULL				# null seg
    	SEG(STA_X|STA_R, 0x0, 0xffffffff)	# code seg
    	SEG(STA_W, 0x0, 0xffffffff)	        # data seg

7. Kernel is located at 0x00100000, but first ELF header is loaded at 0x00000000.
8. 8 sectors by 512 bytes each.
9. Addresses located at Addr column of "readelf" output. Same as real addresses, although they might be encoded.
10. Through parameter located at Al (alignment) column of "readelf" output.
11. There is no stack section. We implement our own, before loading kernel ("movl $(bootstacktop),%esp").
12. Kernel is located at 0x00100000. Upon loading first bytes are being zeroed, so the linking is at 0x00100000.
13. Overall 134 sectors. All sectors are read to initiated ELF structure.
14. Elf structure is initiated by macro "#define ELFHDR ((struct Elf *) 0x10000)", courtesy of main.c.
15. All of those
 
          [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
          [ 1] .text             PROGBITS        f0100000 001000 0020c1 00  AX  0   0 16
          [ 2] .rodata           PROGBITS        f01020c4 0030c4 0004d3 00   A  0   0  4
          [ 3] .stab             PROGBITS        f0102598 003598 00405d 0c   A  4   0  4
          [ 4] .stabstr          STRTAB          f01065f5 0075f5 001940 00   A  0   0  1
          [ 5] .data             PROGBITS        f0108000 009000 008564 00  WA  0   0 4096
          [ 6] .bss              NOBITS          f0110580 011564 000660 00  WA  0   0 32
  
16. It just records size and address of .bss section, since it would be zeroed anyway.
17. Command "call eax" which launches code located at entry.S (kernel's entry).
18. Command "mov word ptr ds:0x472, 0x1234" (or "movw $0x1234,0x472", courtesy of entry.S).
    The BIOS reads this on booting to tell it to "Bypass memory test (also warm boot)".
19. By command "lgdt ds:0x110018" (or "lgdt RELOC(mygdtdesc)", courtesy of entry.S)
        
        mygdt:
    	SEG_NULL				# null seg
    	SEG(STA_X|STA_R, -KERNBASE, 0xffffffff)	# code seg
    	SEG(STA_W, -KERNBASE, 0xffffffff)	# data seg
    	
20. Theoretically, yes, but we need to match kernel's link address with its virtual address. Kernel loading could also overwrite bootstrap GDT.
21. GDT of kernel - at 0xF0100000. GDT of bootloader - at 0x00007C00.
22. Virtual, at 0xF0100000. Our machine may have too little physical memory to store at 0xF0100000, so the real physical address is 0x00100000.
23. Stack memory is allocated using following structure (KSTKSIZE is a size of stack, defined in memlayout.h)
    Address (virtual) is 0xF0110000.

    ```    .p2align	PGSHIFT		# force page alignment
    	.globl		bootstack
    bootstack:
    	.space		KSTKSIZE
    	.globl		bootstacktop
    bootstacktop:
    ```
    After command "movl $(bootstacktop),%esp" stack pointer will be placed at the top of the stack (at the end of allocated memory).
24. Difference between each ebp of test_backtrace is 20h = 32 -> each call puts one 32-bit word.
25. By comparing ebp register with 0. Since we empty ebp in kernel ("xorl %ebp,%ebp", courtesy of entry.S) before making the first call, function will hit 0 eventually.
26. No, since it can't differentiate between argument data and garbage data, and there is no argument count.
27. The leftmost element, as evident by test_backtrace output.
28. Address of instruction where control will return to after function return. Usually located exactly after function call point address. Since we don't know the exact number of variables, tough luck.
