#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  // cprintf("exec: \n");
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  // uint pf_backup = 0, pagedout_backup = 0, timestamp_backup = 0;
  // struct page mem_backup[MAX_PSYC_PAGES], file_backup[MAX_PSYC_PAGES];
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // if (check_policy() && curproc->pid > 2) {
  //   for (i = 0; i < MAX_PSYC_PAGES; i++) {
  //     mem_backup[i].is_used = curproc->memory_pages[i].is_used;
  //     mem_backup[i].offset = curproc->memory_pages[i].offset;
  //     mem_backup[i].va = curproc->memory_pages[i].va;
  //     mem_backup[i].time_loaded = curproc->memory_pages[i].time_loaded;
  //     mem_backup[i].age = curproc->memory_pages[i].age;

  //     file_backup[i].is_used = curproc->file_pages[i].is_used;
  //     file_backup[i].offset = curproc->file_pages[i].offset;
  //     file_backup[i].va = curproc->file_pages[i].va;
  //     file_backup[i].time_loaded = curproc->file_pages[i].time_loaded;
  //     file_backup[i].age = curproc->file_pages[i].age;

  //     pf_backup = curproc->page_faults;
  //     pagedout_backup = curproc->paged_out;
  //     timestamp_backup = curproc->timestamp;
  //   }
  // }

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  if (check_policy() && curproc->pid > 2) {
      // removeSwapFile(curproc);
      // createSwapFile(curproc);
    //   for (i=0; i < MAX_PSYC_PAGES; i++) {
    //   if (curproc->memory_pages[i].is_used)
    //     curproc->memory_pages[i].pgdir = pgdir;
    //   if (curproc->file_pages[i].is_used)
    //     curproc->file_pages[i].pgdir = pgdir; 
    // }
  }
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;
  switchuvm(curproc);
  freevm(oldpgdir);
  // cprintf("exec: finished successfully \n");
  return 0;

 bad:
  panic("EXEC FAILED!\n");
  // if (check_policy() && curproc->pid > 2) {
  //   for (i = 0; i < MAX_PSYC_PAGES; i++) {
  //     curproc->memory_pages[i].is_used = mem_backup[i].is_used;
  //     curproc->memory_pages[i].offset = mem_backup[i].offset;
  //     curproc->memory_pages[i].va = mem_backup[i].va;
  //     curproc->memory_pages[i].time_loaded = mem_backup[i].time_loaded;
  //     curproc->memory_pages[i].age = mem_backup[i].age;

  //     curproc->file_pages[i].is_used = file_backup[i].is_used;
  //     curproc->file_pages[i].offset = file_backup[i].offset;
  //     curproc->file_pages[i].va = file_backup[i].va;
  //     curproc->file_pages[i].time_loaded = file_backup[i].time_loaded;
  //     curproc->file_pages[i].age = file_backup[i].age;

  //     curproc->page_faults = pf_backup;
  //     curproc->paged_out = pagedout_backup;
  //     curproc->timestamp = timestamp_backup;
  //   }
  // }

  // cprintf("EXEC: BAD!\n");
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
