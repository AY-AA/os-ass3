// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld
// int used_pages_counter = 0;

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  uint references_count[PHYSTOP >> PGSHIFT];
  uint free_pages;
} kmem;

void
set_counter(uint v, int i)
{
  if(kmem.use_lock)
    acquire(&kmem.lock);
  kmem.references_count[v >> PGSHIFT] = i;
  // ((struct run*)v)->ref_count = 1;
  // cprintf("get_ref_counter : %x: %d\n",v,counter);
  if(kmem.use_lock)
    release(&kmem.lock);
}

int
get_ref_counter(uint v)
{
  int counter;
  if(kmem.use_lock)
    acquire(&kmem.lock);
  counter = kmem.references_count[v >> PGSHIFT];
  // counter = ((struct run*)v)->ref_count;
  // cprintf("get_ref_counter original: %x, deref: %x, value: %d\n",v, (int)*v, kmem.references_count[(int)*v]);
  if(kmem.use_lock)
    release(&kmem.lock);
  return counter;
}

void
inc_counter(uint v)
{
  if(kmem.use_lock)
    acquire(&kmem.lock);
  // cprintf("[%x] increased from: %d ", v, kmem.references_count[v >> PGSHIFT]);
  kmem.references_count[v >> PGSHIFT]++;
  // cprintf("to: %d\n", kmem.references_count[v >> PGSHIFT]);
  if(kmem.use_lock)
    release(&kmem.lock);
}

void
dec_counter(uint v)
{
  if(kmem.use_lock)
    acquire(&kmem.lock);
  kmem.references_count[v >> PGSHIFT]--;
  if(kmem.use_lock)
    release(&kmem.lock);
}

int
total_pages(void)
{
  int total_addresses = PHYSTOP - V2P((uint)end);
  return PGROUNDDOWN(total_addresses) / PGSIZE;
}

int
free_pages(void)
{
  int free_pages;
  if(kmem.use_lock)
    acquire(&kmem.lock);

  free_pages = kmem.free_pages;

  if(kmem.use_lock)
    release(&kmem.lock);
  
  return free_pages;
  // return used_pages_counter;
}

int
used_pages(void)
{
  return total_pages() - free_pages();
}

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  kmem.free_pages = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}


void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
    kmem.references_count[V2P(p) >> PGSHIFT] = 0;
    kfree(p);
  }
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  if(kmem.use_lock)
    acquire(&kmem.lock);

  if (kmem.references_count[V2P(v) >> PGSHIFT] > 0) {
    kmem.references_count[V2P(v) >> PGSHIFT] --;
    // cprintf("kfree: [%x]: (refs:%d)\n", v, kmem.references_count[V2P(v) >> PGSHIFT]);
  }
  kmem.free_pages++;

  if (kmem.references_count[V2P(v) >> PGSHIFT] != 0) {
    if(kmem.use_lock)
      release(&kmem.lock);
    return;
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  // used_pages_counter ++;
  if(kmem.use_lock)
    release(&kmem.lock);
}



// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  // cprintf("HERE\n");
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    kmem.references_count[V2P(r) >> PGSHIFT] = 1;
    kmem.free_pages--;
    // used_pages_counter --;
  }

  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

