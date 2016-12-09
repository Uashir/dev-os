# Ответы на вопросы для ЛР №2

1. To prevent overlapping of kernel stack and user's page table.
2. KERNBASE maps at 0xF0000000 - 256MB of physical memory (old GDT). Attempting to use lower address may result in pointing to negative address.
3. We need to byte-align starting address of n-byte allocation.
4. Virtual address.
5. After kernel code in VA. Just -KERNBASE it.
6. Free page list is used for simplifying allocation/deallocation procedures. If page reference counter reaches zero, page must be put into free page list.
7. Pages at the IO hole [IOPHYSMEM, EXTPHYSMEM) and pages of 0xF0100000 (start of kernel) to boot_freemem (end of page allocation). Plus zero page.
8. 4096 B = 4 kB (PGSIZE at mmu.h).
9. Physical page descriptor (memlayout.h). 
10. 4 kB * 1024 = 4 MB (PTSIZE at mmu.h).
11. Page directory entries must be aligned for proper indexing. Therefore, all page tables must be alligned in memory.
12. No, it can't, because, as said in (11), page tables must be aligned. To fix it, offset must increment by one byte instead.
13. Fields pp_link (link to free list) and pp_ref (number of pointers to page).
14. At address 0x00117000.
15. Faster, and to prevent addressing pages from (7). NEVER use boot_alloc().
16. It doesn't, all free pages in list are initialized separately.
17. At address 0xF0117000 (or address 0xEF000000, UPAGES).
18. First time - for mapping KERNBASE VA (first 4 MB), before turning on paging (we map VA KERNBASE+x => LA x). Second time we accomodate for newly created GDT (we map VA KERNBASE+x => LA KERNBASE+x and pgdir[0] no longer needed).
19. 4 MB * 1024 = 4 GB (NPDENTRIES at mmu.h).
20. No. The caller must do so manually, if desired.
21. In page tables below UTOP (non-kernel references only).
22. If a page present at page table was removed (only if the page tables being edited are the ones currently in use by the processor, which they currently always are).
23. pmap.c (and GTD structure above)
struct Segdesc gdt[] =
{
	// 0x0 - unused (always faults -- for trapping NULL far pointers)
	SEG_NULL,

	// 0x8 - kernel code segment
	[GD_KT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 0),

	// 0x10 - kernel data segment
	[GD_KD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 0),

	// 0x18 - user code segment
	[GD_UT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 3),

	// 0x20 - user data segment
	[GD_UD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 3),

	// 0x28 - tss, initialized in idt_init()
	[GD_TSS >> 3] = SEG_NULL
};
