#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P) {
      cprintf("[in panic] is PRESENT? %s \n", perm & PTE_P ? "TRUE" : "FALSE");
      panic("remap");
    }
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// find physical address by virtual address
int
find_pa(pde_t *pgdir, uint va)
{
  pte_t *pte = walkpgdir(pgdir, (char*) va, 0);
  return !pte ? -1 : PTE_ADDR(*pte);
}

int
check_policy()
{
  #if NONE
		return 0;
	#endif
	return 1;
}

int
NFUA_next()
{
  struct proc *curproc = myproc();
  int i, next_i = 0;
  int min = curproc->memory_pages[0].age;
  for(i = 1; i < MAX_PSYC_PAGES; i++) {
    if(curproc->memory_pages[i].is_used && curproc->memory_pages[i].age < min){
      next_i = i;
      min = curproc->memory_pages[i].age;
    }
  }

  return next_i;
}

int
LAPA_next(struct proc *p)
{
  p->r_robin++;
  return p->r_robin%MAX_PSYC_PAGES;
}

int
SCFIFO_next(struct proc *p)
{
  int i, next_i = -1;
  pte_t *pte;
  uint min_timestap = 4294967295;

  // find oldest
  for (i = 0; i < MAX_PSYC_PAGES ; i++) {
    if (p->memory_pages[i].is_used && p->memory_pages[i].time_loaded < min_timestap) {
      next_i = i;
      min_timestap = p->memory_pages[i].time_loaded;
    }
  }

  if (next_i == -1)
    panic("SCFIFO: next i == -1\n");

  if ((pte = walkpgdir(p->memory_pages[next_i].pgdir, (char*)p->memory_pages[next_i].va, 0)) == 0)
    panic("SCFIFO: walkpgdir failed\n");
    
  if (*pte & PTE_A) { // will get 2nd chance
    *pte &= ~PTE_A;
    p->memory_pages[next_i].time_loaded = p->timestamp++;
    next_i = -1;
  }
  return next_i;
}

int
AQ_next(struct proc *p)
{
  p->r_robin++;
  return p->r_robin%MAX_PSYC_PAGES;
}

// find next page to remove from memory
int
next_i_in_mem_to_remove(struct proc *p)
{
  int next_i = -1;
  #if NFUA
    do {
      next_i = NFUA_next(p);
      // cprintf("NFUA_next: [PID: %d] i selected: %d, timestamp: %d, va: %x\n", p->pid, next_i, p->memory_pages[next_i].time_loaded, p->memory_pages[next_i].va);
    } while(next_i == -1);
  #elif LAPA
    do {
      next_i = LAPA_next(p);
    } while(next_i == -1);
  #elif SCFIFO
    do {
      next_i = SCFIFO_next(p);
      // cprintf("SCFIFO: [PID: %d] i selected: %d, timestamp: %d, va: %x\n", p->pid, next_i, p->memory_pages[next_i].time_loaded, p->memory_pages[next_i].va);
    } while(next_i == -1);
  #elif AQ
    do {
      next_i = AQ_next(p);
      cprintf("AQ: i selected: %d, timestamp: %d, va: %x\n", next_i, p->memory_pages[next_i].timestamp, p->memory_pages[next_i].va);
    } while(next_i == -1);
  #endif
  if (next_i == -1)
    panic("next i == -1\n");
  return next_i;
}

// find free space in ram
int
next_free_i_in_mem(struct proc *p)
{
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (!p->memory_pages[i].is_used)
      return i;
  }
  return -1;
}

// find index of va in mem
int
get_i_of_va_in_mem(struct proc *p, uint va)
{
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (p->memory_pages[i].va == va)
      return i;
  }
  return -1;
}

// find free space in file
int
next_free_i_in_file(struct proc *p)
{
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (!p->file_pages[i].is_used)
      return i;
  }
  return -1;
}

// find index of va in file
int
get_i_of_va_in_file(struct proc *p, uint va)
{
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (p->file_pages[i].va == va)
      return i;
  }
  return -1;
}

void
set_page_flags_in_mem(pde_t *pgdir, uint va, uint pa)
{
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
  if (!pte)
    panic("failed setting PTE flags when handling trap\n");
  
  *pte |= PTE_P | PTE_W | PTE_U;   // PTE is in mem, writable and user's
  *pte &= ~PTE_PG;   // PTE is NOT in disk
  *pte |= pa;
}

void
set_page_flags_in_disk(pde_t *pgdir, uint va)
{
  pte_t *pte = walkpgdir(pgdir, (char *) va, 0);
  if (!pte)
    panic("failed setting PTE flags after writing to file\n");
  
  *pte |= PTE_PG;   // PTE is in file
  *pte &= ~PTE_P;   // PTE is NOT in memory
  *pte &= PTE_FLAGS(*pte);   // clear pa
}

int
swap(struct proc *p)
{
  int i_in_mem_to_remove, next_free_i_file, pa;

  p->page_faults++;

  i_in_mem_to_remove = next_i_in_mem_to_remove(p);
  next_free_i_file = next_free_i_in_file(p);

  if (writeToSwapFile(p, (char*) p->memory_pages[i_in_mem_to_remove].va, next_free_i_file*PGSIZE, PGSIZE) == -1)
    return -1;
  p->paged_out++;

  // swap from memory to file
  p->file_pages[next_free_i_file].pgdir = p->memory_pages[i_in_mem_to_remove].pgdir;
  p->file_pages[next_free_i_file].va = p->memory_pages[i_in_mem_to_remove].va;
  p->file_pages[next_free_i_file].is_used = 1;

  pa = find_pa(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
  kfree(P2V(pa));
  p->memory_pages[i_in_mem_to_remove].is_used = 0;
  set_page_flags_in_disk(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
  lcr3(V2P(p->pgdir));      // flush TLB

  return i_in_mem_to_remove;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;
  int next_free_i_mem;
  struct proc *p = myproc();

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  if (check_policy() && p->pid > 2 && (PGROUNDUP(newsz) - PGROUNDUP(oldsz))/ PGSIZE > MAX_TOTAL_PAGES) { // space needed is bigger than max num of pages
    // panic("alloc uvm: space needed is bigger than max num of pages");//todo:remove panic
    cprintf("alloc uvm: space requested(%d) is bigger than max allowed(%d)\n", PGROUNDUP(newsz) - PGROUNDUP(oldsz), PGSIZE * MAX_TOTAL_PAGES);
    return 0;
  }

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
    
    if (check_policy() && p->pid > 2) {
      next_free_i_mem = next_free_i_in_mem(p);
      next_free_i_mem = next_free_i_mem == -1 ? swap(p) : next_free_i_mem;
      p->memory_pages[next_free_i_mem].pgdir = pgdir;
      p->memory_pages[next_free_i_mem].is_used = 1;
      p->memory_pages[next_free_i_mem].va = a;
      p->memory_pages[next_free_i_mem].time_loaded = p->timestamp++;
      p->memory_pages[next_free_i_mem].age = 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  int i;
  pte_t *pte;
  uint a, pa;
  struct proc *p = myproc();

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte) 
      // a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
      a += (NPDENTRIES-1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      *pte &= ~PTE_P;   // PTE is NOT in memory
      *pte &= ~PTE_FLAGS(*pte);   // clear pa
      if (check_policy()) {
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
          if (p->memory_pages[i].is_used && 
              p->memory_pages[i].pgdir == pgdir && p->memory_pages[i].va == a) {
            p->memory_pages[i].is_used = 0;
            break;
          }
        }
      }
      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
      pgdir[i] &= ~PTE_P;   // PTE is NOT in memory
      pgdir[i] &= ~PTE_FLAGS(pgdir[i]);   // clear pa
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  // struct proc *p = myproc();

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    // if(*pte & PTE_PG) {
    //   set_page_flags_in_disk(d, i);
    //   lcr3(V2P(p->pgdir));
    //   continue;
    // }
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

pde_t*
copyonwriteuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  struct proc *p = myproc();

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyonwriteuvm: pte should exist");
    if(*pte & PTE_PG) {
      set_page_flags_in_disk(d, i);
      lcr3(V2P(p->pgdir));
      continue;
    }
    if(!(*pte & PTE_P))
      panic("copyonwriteuvm: page not present");

    *pte |= PTE_COW;    // copy on write
    *pte &= ~PTE_W;     // pte is NOT writable -> need to handle in trap!
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    inc_counter(pa);
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
      goto bad;
  }
  lcr3(V2P(p->pgdir));
  return d;

bad:
  panic("copyonwriteuvm: should not happen\n");
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

static char buffer[PGSIZE];

int
handle_pf(void) 
{
  struct page old_page;
  uint old_pa, va, va_rounded;
  int new_page_i_in_mem, i_of_rounded_va, is_need_swap;
  // int new_page_i_in_file;
  char *pa;
  pte_t *pte;
  struct proc *p = myproc();

  va = rcr2();
  va_rounded = PGROUNDDOWN(va);

  if ((pte = walkpgdir(p->pgdir, (char*)va_rounded, 0)) == 0) {
    panic("handle_pf: walkdir failed\n");
  }
  if ((*pte & PTE_P) || !(*pte & PTE_PG)) { // present or not paged out to secondary storage
    return 0;
  }

  p->page_faults++;
  pa = kalloc();

  new_page_i_in_mem = next_free_i_in_mem(p);
  
  is_need_swap = 0;
  if (new_page_i_in_mem == -1) {
    is_need_swap = 1;
    new_page_i_in_mem = next_i_in_mem_to_remove(p);
    old_page = p->memory_pages[new_page_i_in_mem];
  }
  
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
  lcr3(V2P(p->pgdir));      // flush changes

  i_of_rounded_va = get_i_of_va_in_file(p, va_rounded);

  if (i_of_rounded_va == -1)
    panic("handle PF: cannot find rounded VA\n");
  
  if (readFromSwapFile(p, buffer, i_of_rounded_va*PGSIZE, PGSIZE) != PGSIZE)
    panic("handle PF: readFromSwapFile failed\n");

  p->memory_pages[new_page_i_in_mem] = p->file_pages[i_of_rounded_va];
  p->file_pages[i_of_rounded_va].is_used = 0;
  p->file_pages[i_of_rounded_va].age = 0;
  p->memory_pages[new_page_i_in_mem].time_loaded = p->timestamp++;
  // p->memory_pages[new_page_i_in_mem].is_used = 1;

  if (is_need_swap) {
    old_pa = find_pa(old_page.pgdir, old_page.va);
    // new_page_i_in_file = next_free_i_in_file(p);
    if (writeToSwapFile(p, (char*)old_page.va, i_of_rounded_va*PGSIZE, PGSIZE) == -1)
      panic("handle PF: writeToSwapFile failed\n");

    p->paged_out++;
    p->file_pages[i_of_rounded_va].is_used = 1;
    p->file_pages[i_of_rounded_va].pgdir = old_page.pgdir;
    p->file_pages[i_of_rounded_va].va = old_page.va;

    set_page_flags_in_disk(old_page.pgdir, old_page.va);
    lcr3(V2P(p->pgdir));
    kfree(P2V(old_pa));

    memmove((char*)va_rounded, buffer, PGSIZE);
    // memmove(pa, buffer, PGSIZE);
  }
  else {
    memmove((char*)va_rounded, buffer, PGSIZE);
  }

  return 1;
}


int
handle_cow(void) 
{
  
  char *mem;
  pte_t *pte;
  struct proc *p = myproc();
  uint pa, va = rcr2();

  pte = walkpgdir(p->pgdir, (char*)va, 0);
  if ((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0) 
    panic("handle_cow: walkdir failed\n");

  if ((*pte & PTE_W) || !(*pte & PTE_COW)) // not COW or writable
    return 0;

  pa = PTE_ADDR(*pte);

  if (get_ref_counter(pa) > 1) {  // copy
    if((mem = kalloc()) == 0) {
      panic("COW: kalloc failed\n");
    }
    memmove(mem, (char*)P2V(pa), PGSIZE);
    dec_counter(pa);
    *pte &= ~PTE_COW;     // not COW anymore
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
  }
  else {  // remove flags
    *pte &= ~PTE_COW;     // not COW anymore
    *pte |= PTE_W;
  }

  lcr3(V2P(p->pgdir));
  return 1;
}

void 
NFU_update_age() {
  int i;
  pte_t *pte;
  struct proc *curproc = myproc();

//TODO:: check if need to run MAX_PSYC_PAGES or MAX_TOTAL_PAGES times
//TODO:: define in defs so its accessible from proc.c
  for(i = 0; i < MAX_PSYC_PAGES; i++) { 
      if(curproc->memory_pages[i].is_used == 1) {
        curproc->memory_pages[i].age = curproc->memory_pages[i].age >> 1;
        pte = walkpgdir(curproc->pgdir, (void*)curproc->memory_pages[i].va, 0);
        if(*pte & PTE_A) {
          curproc->memory_pages[i].age = curproc->memory_pages[i].age | 0x80000000;
          *pte &= ~PTE_A;     // turn off accessed bit
        }
      }
  }
}