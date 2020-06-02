
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 e5 10 80       	mov    $0x8010e5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 34 10 80       	mov    $0x801034a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 e6 10 80       	mov    $0x8010e614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7f 10 80       	push   $0x80107f80
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 b5 49 00 00       	call   80104a10 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 2d 11 80 dc 	movl   $0x80112cdc,0x80112d2c
80100062:	2c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 2d 11 80 dc 	movl   $0x80112cdc,0x80112d30
8010006c:	2c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 2c 11 80       	mov    $0x80112cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 2c 11 80 	movl   $0x80112cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7f 10 80       	push   $0x80107f87
80100097:	50                   	push   %eax
80100098:	e8 43 48 00 00       	call   801048e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 2d 11 80       	mov    0x80112d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 2d 11 80    	mov    %ebx,0x80112d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 2c 11 80       	cmp    $0x80112cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 e5 10 80       	push   $0x8010e5e0
801000e4:	e8 67 4a 00 00       	call   80104b50 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 2d 11 80    	mov    0x80112d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 2d 11 80    	mov    0x80112d2c,%ebx
80100126:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 e5 10 80       	push   $0x8010e5e0
80100162:	e8 a9 4a 00 00       	call   80104c10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 47 00 00       	call   80104920 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 23 00 00       	call   801024f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 7f 10 80       	push   $0x80107f8e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 0d 48 00 00       	call   801049c0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 23 00 00       	jmp    801024f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 7f 10 80       	push   $0x80107f9f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 cc 47 00 00       	call   801049c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 47 00 00       	call   80104980 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 40 49 00 00       	call   80104b50 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 2d 11 80       	mov    0x80112d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 2c 11 80 	movl   $0x80112cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 2d 11 80       	mov    0x80112d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 2d 11 80    	mov    %ebx,0x80112d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 e5 10 80 	movl   $0x8010e5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 49 00 00       	jmp    80104c10 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 7f 10 80       	push   $0x80107fa6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 48 00 00       	call   80104b50 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002a7:	39 15 c4 2f 11 80    	cmp    %edx,0x80112fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 2f 11 80       	push   $0x80112fc0
801002c5:	e8 76 42 00 00       	call   80104540 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 2f 11 80    	cmp    0x80112fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 50 3b 00 00       	call   80103e30 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 1c 49 00 00       	call   80104c10 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 2f 11 80       	mov    %eax,0x80112fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 2f 11 80 	movsbl -0x7feed0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 be 48 00 00       	call   80104c10 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 2f 11 80    	mov    %edx,0x80112fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 29 00 00       	call   80102d30 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 7f 10 80       	push   $0x80107fad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 f7 89 10 80 	movl   $0x801089f7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 46 00 00       	call   80104a30 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 7f 10 80       	push   $0x80107fc1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 5e 00 00       	call   80106330 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 5e 00 00       	call   80106330 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 5e 00 00       	call   80106330 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 5e 00 00       	call   80106330 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 e7 47 00 00       	call   80104d10 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 1a 47 00 00       	call   80104c60 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 7f 10 80       	push   $0x80107fc5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 f0 7f 10 80 	movzbl -0x7fef8010(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 45 00 00       	call   80104b50 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 c4 45 00 00       	call   80104c10 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 ec 44 00 00       	call   80104c10 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba d8 7f 10 80       	mov    $0x80107fd8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 5b 43 00 00       	call   80104b50 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 7f 10 80       	push   $0x80107fdf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 28 43 00 00       	call   80104b50 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
80100856:	3b 05 c4 2f 11 80    	cmp    0x80112fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 2f 11 80       	mov    %eax,0x80112fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 83 43 00 00       	call   80104c10 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 2f 11 80    	sub    0x80112fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 2f 11 80    	mov    %edx,0x80112fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 2f 11 80    	mov    %cl,-0x7feed0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 2f 11 80       	mov    0x80112fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 2f 11 80    	cmp    %eax,0x80112fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 2f 11 80       	mov    %eax,0x80112fc4
          wakeup(&input.r);
80100911:	68 c0 2f 11 80       	push   $0x80112fc0
80100916:	e8 15 3e 00 00       	call   80104730 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
8010093d:	39 05 c4 2f 11 80    	cmp    %eax,0x80112fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 2f 11 80       	mov    %eax,0x80112fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
80100964:	3b 05 c4 2f 11 80    	cmp    0x80112fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 2f 11 80 0a 	cmpb   $0xa,-0x7feed0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 74 3e 00 00       	jmp    80104810 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 2f 11 80 0a 	movb   $0xa,-0x7feed0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 e8 7f 10 80       	push   $0x80107fe8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 3b 40 00 00       	call   80104a10 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 39 11 80 00 	movl   $0x80100600,0x8011398c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 39 11 80 70 	movl   $0x80100270,0x80113988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 a2 1c 00 00       	call   801026a0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 0f 34 00 00       	call   80103e30 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 27 00 00       	call   801031a0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 e9 14 00 00       	call   80101f20 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 73 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 42 0f 00 00       	call   801019a0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 e1 0e 00 00       	call   80101950 <iunlockput>
    end_op();
80100a6f:	e8 9c 27 00 00       	call   80103210 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 47 6d 00 00       	call   801077e0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 ca 02 00 00    	je     80100d89 <exec+0x379>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 75 6a 00 00       	call   80107570 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 13 66 00 00       	call   80107140 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 43 0e 00 00       	call   801019a0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 e9 6b 00 00       	call   80107760 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 b6 0d 00 00       	call   80101950 <iunlockput>
  end_op();
80100b9a:	e8 71 26 00 00       	call   80103210 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 69 00 00       	call   80107570 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 9a 6b 00 00       	call   80107760 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 26 00 00       	call   80103210 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 80 10 80       	push   $0x80108001
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 75 6c 00 00       	call   80107880 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 42 42 00 00       	call   80104e80 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	58                   	pop    %eax
80100c43:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 2f 42 00 00       	call   80104e80 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 de 6e 00 00       	call   80107b40 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 74 6e 00 00       	call   80107b40 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d07:	50                   	push   %eax
80100d08:	e8 33 41 00 00       	call   80104e40 <safestrcpy>
80100d0d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d13:	89 fa                	mov    %edi,%edx
80100d15:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80100d1b:	81 c2 80 01 00 00    	add    $0x180,%edx
80100d21:	83 c4 10             	add    $0x10,%esp
80100d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->memory_pages[i].is_used)
80100d28:	8b b8 0c 01 00 00    	mov    0x10c(%eax),%edi
80100d2e:	85 ff                	test   %edi,%edi
80100d30:	74 06                	je     80100d38 <exec+0x328>
      curproc->memory_pages[i].pgdir = pgdir;
80100d32:	89 88 00 01 00 00    	mov    %ecx,0x100(%eax)
    if (curproc->file_pages[i].is_used)
80100d38:	8b 78 0c             	mov    0xc(%eax),%edi
80100d3b:	85 ff                	test   %edi,%edi
80100d3d:	74 02                	je     80100d41 <exec+0x331>
      curproc->file_pages[i].pgdir = pgdir; 
80100d3f:	89 08                	mov    %ecx,(%eax)
80100d41:	83 c0 10             	add    $0x10,%eax
  for (i=0; i < MAX_PSYC_PAGES; i++) {
80100d44:	39 c2                	cmp    %eax,%edx
80100d46:	75 e0                	jne    80100d28 <exec+0x318>
  oldpgdir = curproc->pgdir;
80100d48:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  curproc->pgdir = pgdir;
80100d4e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  switchuvm(curproc);
80100d54:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80100d57:	8b 79 04             	mov    0x4(%ecx),%edi
  curproc->sz = sz;
80100d5a:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d5c:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d5f:	8b 41 18             	mov    0x18(%ecx),%eax
80100d62:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d68:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d6b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d6e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d71:	51                   	push   %ecx
80100d72:	e8 39 62 00 00       	call   80106fb0 <switchuvm>
  freevm(oldpgdir);
80100d77:	89 3c 24             	mov    %edi,(%esp)
80100d7a:	e8 e1 69 00 00       	call   80107760 <freevm>
  return 0;
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	31 c0                	xor    %eax,%eax
80100d84:	e9 f3 fc ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d89:	be 00 20 00 00       	mov    $0x2000,%esi
80100d8e:	e9 fe fd ff ff       	jmp    80100b91 <exec+0x181>
80100d93:	66 90                	xchg   %ax,%ax
80100d95:	66 90                	xchg   %ax,%ax
80100d97:	66 90                	xchg   %ax,%ax
80100d99:	66 90                	xchg   %ax,%ax
80100d9b:	66 90                	xchg   %ax,%ax
80100d9d:	66 90                	xchg   %ax,%ax
80100d9f:	90                   	nop

80100da0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100da6:	68 0d 80 10 80       	push   $0x8010800d
80100dab:	68 e0 2f 11 80       	push   $0x80112fe0
80100db0:	e8 5b 3c 00 00       	call   80104a10 <initlock>
}
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	c9                   	leave  
80100db9:	c3                   	ret    
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100dc0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc4:	bb 14 30 11 80       	mov    $0x80113014,%ebx
{
80100dc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dcc:	68 e0 2f 11 80       	push   $0x80112fe0
80100dd1:	e8 7a 3d 00 00       	call   80104b50 <acquire>
80100dd6:	83 c4 10             	add    $0x10,%esp
80100dd9:	eb 10                	jmp    80100deb <filealloc+0x2b>
80100ddb:	90                   	nop
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100de0:	83 c3 18             	add    $0x18,%ebx
80100de3:	81 fb 74 39 11 80    	cmp    $0x80113974,%ebx
80100de9:	73 25                	jae    80100e10 <filealloc+0x50>
    if(f->ref == 0){
80100deb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dee:	85 c0                	test   %eax,%eax
80100df0:	75 ee                	jne    80100de0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100df2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100df5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dfc:	68 e0 2f 11 80       	push   $0x80112fe0
80100e01:	e8 0a 3e 00 00       	call   80104c10 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e06:	89 d8                	mov    %ebx,%eax
      return f;
80100e08:	83 c4 10             	add    $0x10,%esp
}
80100e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e0e:	c9                   	leave  
80100e0f:	c3                   	ret    
  release(&ftable.lock);
80100e10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e15:	68 e0 2f 11 80       	push   $0x80112fe0
80100e1a:	e8 f1 3d 00 00       	call   80104c10 <release>
}
80100e1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e21:	83 c4 10             	add    $0x10,%esp
}
80100e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e27:	c9                   	leave  
80100e28:	c3                   	ret    
80100e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
80100e34:	83 ec 10             	sub    $0x10,%esp
80100e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e3a:	68 e0 2f 11 80       	push   $0x80112fe0
80100e3f:	e8 0c 3d 00 00       	call   80104b50 <acquire>
  if(f->ref < 1)
80100e44:	8b 43 04             	mov    0x4(%ebx),%eax
80100e47:	83 c4 10             	add    $0x10,%esp
80100e4a:	85 c0                	test   %eax,%eax
80100e4c:	7e 1a                	jle    80100e68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e57:	68 e0 2f 11 80       	push   $0x80112fe0
80100e5c:	e8 af 3d 00 00       	call   80104c10 <release>
  return f;
}
80100e61:	89 d8                	mov    %ebx,%eax
80100e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e66:	c9                   	leave  
80100e67:	c3                   	ret    
    panic("filedup");
80100e68:	83 ec 0c             	sub    $0xc,%esp
80100e6b:	68 14 80 10 80       	push   $0x80108014
80100e70:	e8 1b f5 ff ff       	call   80100390 <panic>
80100e75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	57                   	push   %edi
80100e84:	56                   	push   %esi
80100e85:	53                   	push   %ebx
80100e86:	83 ec 28             	sub    $0x28,%esp
80100e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e8c:	68 e0 2f 11 80       	push   $0x80112fe0
80100e91:	e8 ba 3c 00 00       	call   80104b50 <acquire>
  if(f->ref < 1)
80100e96:	8b 43 04             	mov    0x4(%ebx),%eax
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	85 c0                	test   %eax,%eax
80100e9e:	0f 8e 9b 00 00 00    	jle    80100f3f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ea4:	83 e8 01             	sub    $0x1,%eax
80100ea7:	85 c0                	test   %eax,%eax
80100ea9:	89 43 04             	mov    %eax,0x4(%ebx)
80100eac:	74 1a                	je     80100ec8 <fileclose+0x48>
    release(&ftable.lock);
80100eae:	c7 45 08 e0 2f 11 80 	movl   $0x80112fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ebc:	e9 4f 3d 00 00       	jmp    80104c10 <release>
80100ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ec8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ecc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ece:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ed1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ed4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eda:	88 45 e7             	mov    %al,-0x19(%ebp)
80100edd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ee0:	68 e0 2f 11 80       	push   $0x80112fe0
  ff = *f;
80100ee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ee8:	e8 23 3d 00 00       	call   80104c10 <release>
  if(ff.type == FD_PIPE)
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	83 ff 01             	cmp    $0x1,%edi
80100ef3:	74 13                	je     80100f08 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ef5:	83 ff 02             	cmp    $0x2,%edi
80100ef8:	74 26                	je     80100f20 <fileclose+0xa0>
}
80100efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100efd:	5b                   	pop    %ebx
80100efe:	5e                   	pop    %esi
80100eff:	5f                   	pop    %edi
80100f00:	5d                   	pop    %ebp
80100f01:	c3                   	ret    
80100f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f08:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f0c:	83 ec 08             	sub    $0x8,%esp
80100f0f:	53                   	push   %ebx
80100f10:	56                   	push   %esi
80100f11:	e8 3a 2a 00 00       	call   80103950 <pipeclose>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb df                	jmp    80100efa <fileclose+0x7a>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f20:	e8 7b 22 00 00       	call   801031a0 <begin_op>
    iput(ff.ip);
80100f25:	83 ec 0c             	sub    $0xc,%esp
80100f28:	ff 75 e0             	pushl  -0x20(%ebp)
80100f2b:	e8 c0 08 00 00       	call   801017f0 <iput>
    end_op();
80100f30:	83 c4 10             	add    $0x10,%esp
}
80100f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f36:	5b                   	pop    %ebx
80100f37:	5e                   	pop    %esi
80100f38:	5f                   	pop    %edi
80100f39:	5d                   	pop    %ebp
    end_op();
80100f3a:	e9 d1 22 00 00       	jmp    80103210 <end_op>
    panic("fileclose");
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	68 1c 80 10 80       	push   $0x8010801c
80100f47:	e8 44 f4 ff ff       	call   80100390 <panic>
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
80100f54:	83 ec 04             	sub    $0x4,%esp
80100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f5a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f5d:	75 31                	jne    80100f90 <filestat+0x40>
    ilock(f->ip);
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	ff 73 10             	pushl  0x10(%ebx)
80100f65:	e8 56 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f6a:	58                   	pop    %eax
80100f6b:	5a                   	pop    %edx
80100f6c:	ff 75 0c             	pushl  0xc(%ebp)
80100f6f:	ff 73 10             	pushl  0x10(%ebx)
80100f72:	e8 f9 09 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f77:	59                   	pop    %ecx
80100f78:	ff 73 10             	pushl  0x10(%ebx)
80100f7b:	e8 20 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f80:	83 c4 10             	add    $0x10,%esp
80100f83:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f88:	c9                   	leave  
80100f89:	c3                   	ret    
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f95:	eb ee                	jmp    80100f85 <filestat+0x35>
80100f97:	89 f6                	mov    %esi,%esi
80100f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fa0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;
  if(f->readable == 0)
80100fb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fb6:	74 60                	je     80101018 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fb8:	8b 03                	mov    (%ebx),%eax
80100fba:	83 f8 01             	cmp    $0x1,%eax
80100fbd:	74 41                	je     80101000 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fbf:	83 f8 02             	cmp    $0x2,%eax
80100fc2:	75 5b                	jne    8010101f <fileread+0x7f>
    ilock(f->ip);
80100fc4:	83 ec 0c             	sub    $0xc,%esp
80100fc7:	ff 73 10             	pushl  0x10(%ebx)
80100fca:	e8 f1 06 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcf:	57                   	push   %edi
80100fd0:	ff 73 14             	pushl  0x14(%ebx)
80100fd3:	56                   	push   %esi
80100fd4:	ff 73 10             	pushl  0x10(%ebx)
80100fd7:	e8 c4 09 00 00       	call   801019a0 <readi>
80100fdc:	83 c4 20             	add    $0x20,%esp
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	89 c6                	mov    %eax,%esi
80100fe3:	7e 03                	jle    80100fe8 <fileread+0x48>
      f->off += r;
80100fe5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	ff 73 10             	pushl  0x10(%ebx)
80100fee:	e8 ad 07 00 00       	call   801017a0 <iunlock>
    return r;
80100ff3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	89 f0                	mov    %esi,%eax
80100ffb:	5b                   	pop    %ebx
80100ffc:	5e                   	pop    %esi
80100ffd:	5f                   	pop    %edi
80100ffe:	5d                   	pop    %ebp
80100fff:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101000:	8b 43 0c             	mov    0xc(%ebx),%eax
80101003:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101009:	5b                   	pop    %ebx
8010100a:	5e                   	pop    %esi
8010100b:	5f                   	pop    %edi
8010100c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010100d:	e9 ee 2a 00 00       	jmp    80103b00 <piperead>
80101012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101018:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010101d:	eb d7                	jmp    80100ff6 <fileread+0x56>
  panic("fileread");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 26 80 10 80       	push   $0x80108026
80101027:	e8 64 f3 ff ff       	call   80100390 <panic>
8010102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101030 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 1c             	sub    $0x1c,%esp
80101039:	8b 75 08             	mov    0x8(%ebp),%esi
8010103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010103f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101043:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101046:	8b 45 10             	mov    0x10(%ebp),%eax
80101049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010104c:	0f 84 aa 00 00 00    	je     801010fc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101052:	8b 06                	mov    (%esi),%eax
80101054:	83 f8 01             	cmp    $0x1,%eax
80101057:	0f 84 c3 00 00 00    	je     80101120 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105d:	83 f8 02             	cmp    $0x2,%eax
80101060:	0f 85 d9 00 00 00    	jne    8010113f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101069:	31 ff                	xor    %edi,%edi
    while(i < n){
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 34                	jg     801010a3 <filewrite+0x73>
8010106f:	e9 9c 00 00 00       	jmp    80101110 <filewrite+0xe0>
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101078:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101081:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101084:	e8 17 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101089:	e8 82 21 00 00       	call   80103210 <end_op>
8010108e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101091:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101094:	39 c3                	cmp    %eax,%ebx
80101096:	0f 85 96 00 00 00    	jne    80101132 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010109c:	01 df                	add    %ebx,%edi
    while(i < n){
8010109e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010a1:	7e 6d                	jle    80101110 <filewrite+0xe0>
      int n1 = n - i;
801010a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010a6:	b8 00 06 00 00       	mov    $0x600,%eax
801010ab:	29 fb                	sub    %edi,%ebx
801010ad:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010b3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010b6:	e8 e5 20 00 00       	call   801031a0 <begin_op>
      ilock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
801010c1:	e8 fa 05 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c9:	53                   	push   %ebx
801010ca:	ff 76 14             	pushl  0x14(%esi)
801010cd:	01 f8                	add    %edi,%eax
801010cf:	50                   	push   %eax
801010d0:	ff 76 10             	pushl  0x10(%esi)
801010d3:	e8 c8 09 00 00       	call   80101aa0 <writei>
801010d8:	83 c4 20             	add    $0x20,%esp
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 99                	jg     80101078 <filewrite+0x48>
      iunlock(f->ip);
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	ff 76 10             	pushl  0x10(%esi)
801010e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010e8:	e8 b3 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010ed:	e8 1e 21 00 00       	call   80103210 <end_op>
      if(r < 0)
801010f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f5:	83 c4 10             	add    $0x10,%esp
801010f8:	85 c0                	test   %eax,%eax
801010fa:	74 98                	je     80101094 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101104:	89 f8                	mov    %edi,%eax
80101106:	5b                   	pop    %ebx
80101107:	5e                   	pop    %esi
80101108:	5f                   	pop    %edi
80101109:	5d                   	pop    %ebp
8010110a:	c3                   	ret    
8010110b:	90                   	nop
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101110:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101113:	75 e7                	jne    801010fc <filewrite+0xcc>
}
80101115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101118:	89 f8                	mov    %edi,%eax
8010111a:	5b                   	pop    %ebx
8010111b:	5e                   	pop    %esi
8010111c:	5f                   	pop    %edi
8010111d:	5d                   	pop    %ebp
8010111e:	c3                   	ret    
8010111f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101120:	8b 46 0c             	mov    0xc(%esi),%eax
80101123:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	5b                   	pop    %ebx
8010112a:	5e                   	pop    %esi
8010112b:	5f                   	pop    %edi
8010112c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010112d:	e9 be 28 00 00       	jmp    801039f0 <pipewrite>
        panic("short filewrite");
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	68 2f 80 10 80       	push   $0x8010802f
8010113a:	e8 51 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 35 80 10 80       	push   $0x80108035
80101147:	e8 44 f2 ff ff       	call   80100390 <panic>
8010114c:	66 90                	xchg   %ax,%ax
8010114e:	66 90                	xchg   %ax,%ax

80101150 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	56                   	push   %esi
80101154:	53                   	push   %ebx
80101155:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101157:	c1 ea 0c             	shr    $0xc,%edx
8010115a:	03 15 f8 39 11 80    	add    0x801139f8,%edx
80101160:	83 ec 08             	sub    $0x8,%esp
80101163:	52                   	push   %edx
80101164:	50                   	push   %eax
80101165:	e8 66 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010116a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010116c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010116f:	ba 01 00 00 00       	mov    $0x1,%edx
80101174:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101177:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010117d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101180:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101182:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101187:	85 d1                	test   %edx,%ecx
80101189:	74 25                	je     801011b0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010118b:	f7 d2                	not    %edx
8010118d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101192:	21 ca                	and    %ecx,%edx
80101194:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101198:	56                   	push   %esi
80101199:	e8 d2 21 00 00       	call   80103370 <log_write>
  brelse(bp);
8010119e:	89 34 24             	mov    %esi,(%esp)
801011a1:	e8 3a f0 ff ff       	call   801001e0 <brelse>
}
801011a6:	83 c4 10             	add    $0x10,%esp
801011a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011ac:	5b                   	pop    %ebx
801011ad:	5e                   	pop    %esi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret    
    panic("freeing free block");
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	68 3f 80 10 80       	push   $0x8010803f
801011b8:	e8 d3 f1 ff ff       	call   80100390 <panic>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi

801011c0 <balloc>:
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d e0 39 11 80    	mov    0x801139e0,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 f8 39 11 80    	add    0x801139f8,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	pushl  -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fe:	a1 e0 39 11 80       	mov    0x801139e0,%eax
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101215:	bb 01 00 00 00       	mov    $0x1,%ebx
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	85 df                	test   %ebx,%edi
8010122b:	89 fa                	mov    %edi,%edx
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	pushl  -0x1c(%ebp)
80101247:	e8 94 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 e0 39 11 80    	cmp    %eax,0x801139e0
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 52 80 10 80       	push   $0x80108052
80101269:	e8 22 f1 ff ff       	call   80100390 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 ee 20 00 00       	call   80103370 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	pushl  -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101297:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129a:	83 c4 0c             	add    $0xc,%esp
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 b6 39 00 00       	call   80104c60 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 be 20 00 00       	call   80103370 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 34 3a 11 80       	mov    $0x80113a34,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 00 3a 11 80       	push   $0x80113a00
801012ea:	e8 61 38 00 00       	call   80104b50 <acquire>
801012ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f5:	eb 17                	jmp    8010130e <iget+0x3e>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101306:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
8010130c:	73 22                	jae    80101330 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101311:	85 c9                	test   %ecx,%ecx
80101313:	7e 04                	jle    80101319 <iget+0x49>
80101315:	39 3b                	cmp    %edi,(%ebx)
80101317:	74 4f                	je     80101368 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e3                	jne    80101300 <iget+0x30>
8010131d:	85 c9                	test   %ecx,%ecx
8010131f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101322:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101328:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
8010132e:	72 de                	jb     8010130e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 5b                	je     8010138f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 00 3a 11 80       	push   $0x80113a00
8010134f:	e8 bc 38 00 00       	call   80104c10 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101368:	39 53 04             	cmp    %edx,0x4(%ebx)
8010136b:	75 ac                	jne    80101319 <iget+0x49>
      release(&icache.lock);
8010136d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101370:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101373:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101375:	68 00 3a 11 80       	push   $0x80113a00
      ip->ref++;
8010137a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010137d:	e8 8e 38 00 00       	call   80104c10 <release>
      return ip;
80101382:	83 c4 10             	add    $0x10,%esp
}
80101385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
    panic("iget: no inodes");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 68 80 10 80       	push   $0x80108068
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	89 c6                	mov    %eax,%esi
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	77 18                	ja     801013c8 <bmap+0x28>
801013b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013b6:	85 db                	test   %ebx,%ebx
801013b8:	74 76                	je     80101430 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013cb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ce:	0f 87 90 00 00 00    	ja     80101464 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013da:	8b 00                	mov    (%eax),%eax
801013dc:	85 d2                	test   %edx,%edx
801013de:	74 70                	je     80101450 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 e6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013f3:	8b 1a                	mov    (%edx),%ebx
801013f5:	85 db                	test   %ebx,%ebx
801013f7:	75 1d                	jne    80101416 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013f9:	8b 06                	mov    (%esi),%eax
801013fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fe:	e8 bd fd ff ff       	call   801011c0 <balloc>
80101403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101409:	89 c3                	mov    %eax,%ebx
8010140b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140d:	57                   	push   %edi
8010140e:	e8 5d 1f 00 00       	call   80103370 <log_write>
80101413:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101416:	83 ec 0c             	sub    $0xc,%esp
80101419:	57                   	push   %edi
8010141a:	e8 c1 ed ff ff       	call   801001e0 <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	89 d8                	mov    %ebx,%eax
80101427:	5b                   	pop    %ebx
80101428:	5e                   	pop    %esi
80101429:	5f                   	pop    %edi
8010142a:	5d                   	pop    %ebp
8010142b:	c3                   	ret    
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101430:	8b 00                	mov    (%eax),%eax
80101432:	e8 89 fd ff ff       	call   801011c0 <balloc>
80101437:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010143d:	89 c3                	mov    %eax,%ebx
}
8010143f:	89 d8                	mov    %ebx,%eax
80101441:	5b                   	pop    %ebx
80101442:	5e                   	pop    %esi
80101443:	5f                   	pop    %edi
80101444:	5d                   	pop    %ebp
80101445:	c3                   	ret    
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101450:	e8 6b fd ff ff       	call   801011c0 <balloc>
80101455:	89 c2                	mov    %eax,%edx
80101457:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010145d:	8b 06                	mov    (%esi),%eax
8010145f:	e9 7c ff ff ff       	jmp    801013e0 <bmap+0x40>
  panic("bmap: out of range");
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	68 78 80 10 80       	push   $0x80108078
8010146c:	e8 1f ef ff ff       	call   80100390 <panic>
80101471:	eb 0d                	jmp    80101480 <readsb>
80101473:	90                   	nop
80101474:	90                   	nop
80101475:	90                   	nop
80101476:	90                   	nop
80101477:	90                   	nop
80101478:	90                   	nop
80101479:	90                   	nop
8010147a:	90                   	nop
8010147b:	90                   	nop
8010147c:	90                   	nop
8010147d:	90                   	nop
8010147e:	90                   	nop
8010147f:	90                   	nop

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 6a 38 00 00       	call   80104d10 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 40 3a 11 80       	mov    $0x80113a40,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 8b 80 10 80       	push   $0x8010808b
801014d1:	68 00 3a 11 80       	push   $0x80113a00
801014d6:	e8 35 35 00 00       	call   80104a10 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 92 80 10 80       	push   $0x80108092
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 ec 33 00 00       	call   801048e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 60 56 11 80    	cmp    $0x80115660,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 e0 39 11 80       	push   $0x801139e0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 71 ff ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 f8 39 11 80    	pushl  0x801139f8
80101515:	ff 35 f4 39 11 80    	pushl  0x801139f4
8010151b:	ff 35 f0 39 11 80    	pushl  0x801139f0
80101521:	ff 35 ec 39 11 80    	pushl  0x801139ec
80101527:	ff 35 e8 39 11 80    	pushl  0x801139e8
8010152d:	ff 35 e4 39 11 80    	pushl  0x801139e4
80101533:	ff 35 e0 39 11 80    	pushl  0x801139e0
80101539:	68 3c 81 10 80       	push   $0x8010813c
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	83 3d e8 39 11 80 01 	cmpl   $0x1,0x801139e8
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d e8 39 11 80    	cmp    %ebx,0x801139e8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 f4 39 11 80    	add    0x801139f4,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 8d 36 00 00       	call   80104c60 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 8b 1d 00 00       	call   80103370 <log_write>
      brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fb:	e9 d0 fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 98 80 10 80       	push   $0x80108098
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 f4 39 11 80    	add    0x801139f4,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 9a 36 00 00       	call   80104d10 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 f2 1c 00 00       	call   80103370 <log_write>
  brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
  brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	68 00 3a 11 80       	push   $0x80113a00
8010169f:	e8 ac 34 00 00       	call   80104b50 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
801016af:	e8 5c 35 00 00       	call   80104c10 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 39 32 00 00       	call   80104920 <acquiresleep>
  if(ip->valid == 0){
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 f4 39 11 80    	add    0x801139f4,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 b3 35 00 00       	call   80104d10 <memmove>
    brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
      panic("ilock: no type");
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 b0 80 10 80       	push   $0x801080b0
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 aa 80 10 80       	push   $0x801080aa
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 08 32 00 00       	call   801049c0 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017cf:	e9 ac 31 00 00       	jmp    80104980 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 bf 80 10 80       	push   $0x801080bf
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 1b 31 00 00       	call   80104920 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
  releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 61 31 00 00       	call   80104980 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80101826:	e8 25 33 00 00       	call   80104b50 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 00 3a 11 80 	movl   $0x80113a00,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 cb 33 00 00       	jmp    80104c10 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 00 3a 11 80       	push   $0x80113a00
80101850:	e8 fb 32 00 00       	call   80104b50 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
8010185f:	e8 ac 33 00 00       	call   80104c10 <release>
    if(r == 1){
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 bc f8 ff ff       	call   80101150 <bfree>
      ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
      if(a[j])
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
        bfree(ip->dev, a[j]);
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 34 f8 ff ff       	call   80101150 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
    brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 17 f8 ff ff       	call   80101150 <bfree>
    ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 91 f9 ff ff       	call   801013a0 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a47:	e8 c4 32 00 00       	call   80104d10 <memmove>
    brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
  }
  return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 80 39 11 80 	mov    -0x7feec680(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
      return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 91 f8 ff ff       	call   801013a0 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 c8 31 00 00       	call   80104d10 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 20 18 00 00       	call   80103370 <log_write>
    brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 84 39 11 80 	mov    -0x7feec67c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 9d 31 00 00       	call   80104d80 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 3e 31 00 00       	call   80104d80 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
        *poff = off;
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 59 f6 ff ff       	call   801012d0 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
      panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 d9 80 10 80       	push   $0x801080d9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 c7 80 10 80       	push   $0x801080c7
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 72 21 00 00       	call   80103e30 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 00 3a 11 80       	push   $0x80113a00
80101cc9:	e8 82 2e 00 00       	call   80104b50 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80101cd9:	e8 32 2f 00 00       	call   80104c10 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
  if(*path == 0)
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
    path++;
80101d14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 d6 2f 00 00       	call   80104d10 <memmove>
    path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
  iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 43 2f 00 00       	call   80104d10 <memmove>
    name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
      return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 a1 f4 ff ff       	call   801012d0 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
      iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
      return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
    iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
    return 0;
80101e50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 1e 2f 00 00       	call   80104de0 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 e8 80 10 80       	push   $0x801080e8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 ad 87 10 80       	push   $0x801087ad
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f60 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f60:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f61:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f66:	89 e5                	mov    %esp,%ebp
80101f68:	57                   	push   %edi
80101f69:	56                   	push   %esi
80101f6a:	53                   	push   %ebx
80101f6b:	83 ec 10             	sub    $0x10,%esp
80101f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f71:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f78:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f7f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f83:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f87:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f8a:	85 c9                	test   %ecx,%ecx
80101f8c:	79 0a                	jns    80101f98 <itoa+0x38>
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f93:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f95:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f98:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f9a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f9f:	90                   	nop
80101fa0:	89 d8                	mov    %ebx,%eax
80101fa2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101fa5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101fa8:	f7 ef                	imul   %edi
80101faa:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101fad:	29 da                	sub    %ebx,%edx
80101faf:	89 d3                	mov    %edx,%ebx
80101fb1:	75 ed                	jne    80101fa0 <itoa+0x40>
    *p = '\0';
80101fb3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fb6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101fbb:	90                   	nop
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc0:	89 c8                	mov    %ecx,%eax
80101fc2:	83 ee 01             	sub    $0x1,%esi
80101fc5:	f7 eb                	imul   %ebx
80101fc7:	89 c8                	mov    %ecx,%eax
80101fc9:	c1 f8 1f             	sar    $0x1f,%eax
80101fcc:	c1 fa 02             	sar    $0x2,%edx
80101fcf:	29 c2                	sub    %eax,%edx
80101fd1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fd4:	01 c0                	add    %eax,%eax
80101fd6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fd8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101fda:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101fdf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fe1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fe3:	75 db                	jne    80101fc0 <itoa+0x60>
    return b;
}
80101fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5f                   	pop    %edi
80101fee:	5d                   	pop    %ebp
80101fef:	c3                   	ret    

80101ff0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101ff6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101ff9:	83 ec 40             	sub    $0x40,%esp
80101ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fff:	6a 06                	push   $0x6
80102001:	68 f5 80 10 80       	push   $0x801080f5
80102006:	56                   	push   %esi
80102007:	e8 04 2d 00 00       	call   80104d10 <memmove>
  itoa(p->pid, path+ 6);
8010200c:	58                   	pop    %eax
8010200d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102010:	5a                   	pop    %edx
80102011:	50                   	push   %eax
80102012:	ff 73 10             	pushl  0x10(%ebx)
80102015:	e8 46 ff ff ff       	call   80101f60 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010201a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010201d:	83 c4 10             	add    $0x10,%esp
80102020:	85 c0                	test   %eax,%eax
80102022:	0f 84 88 01 00 00    	je     801021b0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102028:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010202b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010202e:	50                   	push   %eax
8010202f:	e8 4c ee ff ff       	call   80100e80 <fileclose>

  begin_op();
80102034:	e8 67 11 00 00       	call   801031a0 <begin_op>
  return namex(path, 1, name);
80102039:	89 f0                	mov    %esi,%eax
8010203b:	89 d9                	mov    %ebx,%ecx
8010203d:	ba 01 00 00 00       	mov    $0x1,%edx
80102042:	e8 59 fc ff ff       	call   80101ca0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010204c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010204e:	0f 84 66 01 00 00    	je     801021ba <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	50                   	push   %eax
80102058:	e8 63 f6 ff ff       	call   801016c0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010205d:	83 c4 0c             	add    $0xc,%esp
80102060:	6a 0e                	push   $0xe
80102062:	68 fd 80 10 80       	push   $0x801080fd
80102067:	53                   	push   %ebx
80102068:	e8 13 2d 00 00       	call   80104d80 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 fc 80 10 80       	push   $0x801080fc
80102082:	53                   	push   %ebx
80102083:	e8 f8 2c 00 00       	call   80104d80 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	0f 84 dd 00 00 00    	je     80102170 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102093:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102096:	83 ec 04             	sub    $0x4,%esp
80102099:	50                   	push   %eax
8010209a:	53                   	push   %ebx
8010209b:	56                   	push   %esi
8010209c:	e8 4f fb ff ff       	call   80101bf0 <dirlookup>
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	85 c0                	test   %eax,%eax
801020a6:	89 c3                	mov    %eax,%ebx
801020a8:	0f 84 c2 00 00 00    	je     80102170 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801020ae:	83 ec 0c             	sub    $0xc,%esp
801020b1:	50                   	push   %eax
801020b2:	e8 09 f6 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020bf:	0f 8e 11 01 00 00    	jle    801021d6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020ca:	74 74                	je     80102140 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020cc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020cf:	83 ec 04             	sub    $0x4,%esp
801020d2:	6a 10                	push   $0x10
801020d4:	6a 00                	push   $0x0
801020d6:	57                   	push   %edi
801020d7:	e8 84 2b 00 00       	call   80104c60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020dc:	6a 10                	push   $0x10
801020de:	ff 75 b8             	pushl  -0x48(%ebp)
801020e1:	57                   	push   %edi
801020e2:	56                   	push   %esi
801020e3:	e8 b8 f9 ff ff       	call   80101aa0 <writei>
801020e8:	83 c4 20             	add    $0x20,%esp
801020eb:	83 f8 10             	cmp    $0x10,%eax
801020ee:	0f 85 d5 00 00 00    	jne    801021c9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020f4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020f9:	0f 84 91 00 00 00    	je     80102190 <removeSwapFile+0x1a0>
  iunlock(ip);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	56                   	push   %esi
80102103:	e8 98 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102108:	89 34 24             	mov    %esi,(%esp)
8010210b:	e8 e0 f6 ff ff       	call   801017f0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102110:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102115:	89 1c 24             	mov    %ebx,(%esp)
80102118:	e8 f3 f4 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010211d:	89 1c 24             	mov    %ebx,(%esp)
80102120:	e8 7b f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102125:	89 1c 24             	mov    %ebx,(%esp)
80102128:	e8 c3 f6 ff ff       	call   801017f0 <iput>
  iunlockput(ip);

  end_op();
8010212d:	e8 de 10 00 00       	call   80103210 <end_op>

  return 0;
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102137:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213a:	5b                   	pop    %ebx
8010213b:	5e                   	pop    %esi
8010213c:	5f                   	pop    %edi
8010213d:	5d                   	pop    %ebp
8010213e:	c3                   	ret    
8010213f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	53                   	push   %ebx
80102144:	e8 f7 32 00 00       	call   80105440 <isdirempty>
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	85 c0                	test   %eax,%eax
8010214e:	0f 85 78 ff ff ff    	jne    801020cc <removeSwapFile+0xdc>
  iunlock(ip);
80102154:	83 ec 0c             	sub    $0xc,%esp
80102157:	53                   	push   %ebx
80102158:	e8 43 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
8010215d:	89 1c 24             	mov    %ebx,(%esp)
80102160:	e8 8b f6 ff ff       	call   801017f0 <iput>
80102165:	83 c4 10             	add    $0x10,%esp
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	56                   	push   %esi
80102174:	e8 27 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102179:	89 34 24             	mov    %esi,(%esp)
8010217c:	e8 6f f6 ff ff       	call   801017f0 <iput>
    end_op();
80102181:	e8 8a 10 00 00       	call   80103210 <end_op>
    return -1;
80102186:	83 c4 10             	add    $0x10,%esp
80102189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218e:	eb a7                	jmp    80102137 <removeSwapFile+0x147>
    dp->nlink--;
80102190:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	56                   	push   %esi
80102199:	e8 72 f4 ff ff       	call   80101610 <iupdate>
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	e9 59 ff ff ff       	jmp    801020ff <removeSwapFile+0x10f>
801021a6:	8d 76 00             	lea    0x0(%esi),%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	e9 7d ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    end_op();
801021ba:	e8 51 10 00 00       	call   80103210 <end_op>
    return -1;
801021bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c4:	e9 6e ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    panic("unlink: writei");
801021c9:	83 ec 0c             	sub    $0xc,%esp
801021cc:	68 11 81 10 80       	push   $0x80108111
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 ff 80 10 80       	push   $0x801080ff
801021de:	e8 ad e1 ff ff       	call   80100390 <panic>
801021e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021f5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801021f8:	83 ec 14             	sub    $0x14,%esp
801021fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021fe:	6a 06                	push   $0x6
80102200:	68 f5 80 10 80       	push   $0x801080f5
80102205:	56                   	push   %esi
80102206:	e8 05 2b 00 00       	call   80104d10 <memmove>
  itoa(p->pid, path+ 6);
8010220b:	58                   	pop    %eax
8010220c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010220f:	5a                   	pop    %edx
80102210:	50                   	push   %eax
80102211:	ff 73 10             	pushl  0x10(%ebx)
80102214:	e8 47 fd ff ff       	call   80101f60 <itoa>

    begin_op();
80102219:	e8 82 0f 00 00       	call   801031a0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010221e:	6a 00                	push   $0x0
80102220:	6a 00                	push   $0x0
80102222:	6a 02                	push   $0x2
80102224:	56                   	push   %esi
80102225:	e8 26 34 00 00       	call   80105650 <create>
  iunlock(in);
8010222a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010222d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010222f:	50                   	push   %eax
80102230:	e8 6b f5 ff ff       	call   801017a0 <iunlock>

  p->swapFile = filealloc();
80102235:	e8 86 eb ff ff       	call   80100dc0 <filealloc>
  if (p->swapFile == 0)
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010223f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102242:	74 32                	je     80102276 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102244:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102247:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010224a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102250:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102253:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010225a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010225d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102261:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102264:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102268:	e8 a3 0f 00 00       	call   80103210 <end_op>

    return 0;
}
8010226d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102270:	31 c0                	xor    %eax,%eax
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	c3                   	ret    
    panic("no slot for files on /store");
80102276:	83 ec 0c             	sub    $0xc,%esp
80102279:	68 20 81 10 80       	push   $0x80108120
8010227e:	e8 0d e1 ff ff       	call   80100390 <panic>
80102283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022ab:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801022ac:	e9 7f ed ff ff       	jmp    80101030 <filewrite>
801022b1:	eb 0d                	jmp    801022c0 <readFromSwapFile>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022c9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022cc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022cf:	8b 55 14             	mov    0x14(%ebp),%edx
801022d2:	89 55 10             	mov    %edx,0x10(%ebp)
801022d5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022d8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022db:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022dc:	e9 bf ec ff ff       	jmp    80100fa0 <fileread>
801022e1:	66 90                	xchg   %ax,%ax
801022e3:	66 90                	xchg   %ax,%ax
801022e5:	66 90                	xchg   %ax,%ax
801022e7:	66 90                	xchg   %ax,%ax
801022e9:	66 90                	xchg   %ax,%ax
801022eb:	66 90                	xchg   %ax,%ax
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022f9:	85 c0                	test   %eax,%eax
801022fb:	0f 84 b4 00 00 00    	je     801023b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102301:	8b 58 08             	mov    0x8(%eax),%ebx
80102304:	89 c6                	mov    %eax,%esi
80102306:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010230c:	0f 87 96 00 00 00    	ja     801023a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102312:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102317:	89 f6                	mov    %esi,%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102320:	89 ca                	mov    %ecx,%edx
80102322:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102323:	83 e0 c0             	and    $0xffffffc0,%eax
80102326:	3c 40                	cmp    $0x40,%al
80102328:	75 f6                	jne    80102320 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	31 ff                	xor    %edi,%edi
8010232c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102331:	89 f8                	mov    %edi,%eax
80102333:	ee                   	out    %al,(%dx)
80102334:	b8 01 00 00 00       	mov    $0x1,%eax
80102339:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010233e:	ee                   	out    %al,(%dx)
8010233f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102344:	89 d8                	mov    %ebx,%eax
80102346:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102347:	89 d8                	mov    %ebx,%eax
80102349:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010234e:	c1 f8 08             	sar    $0x8,%eax
80102351:	ee                   	out    %al,(%dx)
80102352:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102357:	89 f8                	mov    %edi,%eax
80102359:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010235a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010235e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102363:	c1 e0 04             	shl    $0x4,%eax
80102366:	83 e0 10             	and    $0x10,%eax
80102369:	83 c8 e0             	or     $0xffffffe0,%eax
8010236c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010236d:	f6 06 04             	testb  $0x4,(%esi)
80102370:	75 16                	jne    80102388 <idestart+0x98>
80102372:	b8 20 00 00 00       	mov    $0x20,%eax
80102377:	89 ca                	mov    %ecx,%edx
80102379:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010237a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237d:	5b                   	pop    %ebx
8010237e:	5e                   	pop    %esi
8010237f:	5f                   	pop    %edi
80102380:	5d                   	pop    %ebp
80102381:	c3                   	ret    
80102382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102388:	b8 30 00 00 00       	mov    $0x30,%eax
8010238d:	89 ca                	mov    %ecx,%edx
8010238f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102390:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102395:	83 c6 5c             	add    $0x5c,%esi
80102398:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010239d:	fc                   	cld    
8010239e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a3:	5b                   	pop    %ebx
801023a4:	5e                   	pop    %esi
801023a5:	5f                   	pop    %edi
801023a6:	5d                   	pop    %ebp
801023a7:	c3                   	ret    
    panic("incorrect blockno");
801023a8:	83 ec 0c             	sub    $0xc,%esp
801023ab:	68 98 81 10 80       	push   $0x80108198
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 8f 81 10 80       	push   $0x8010818f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 aa 81 10 80       	push   $0x801081aa
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 2b 26 00 00       	call   80104a10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023e5:	58                   	pop    %eax
801023e6:	a1 20 dd 14 80       	mov    0x8014dd20,%eax
801023eb:	5a                   	pop    %edx
801023ec:	83 e8 01             	sub    $0x1,%eax
801023ef:	50                   	push   %eax
801023f0:	6a 0e                	push   $0xe
801023f2:	e8 a9 02 00 00       	call   801026a0 <ioapicenable>
801023f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ff:	90                   	nop
80102400:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102401:	83 e0 c0             	and    $0xffffffc0,%eax
80102404:	3c 40                	cmp    $0x40,%al
80102406:	75 f8                	jne    80102400 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102408:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010240d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102412:	ee                   	out    %al,(%dx)
80102413:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102418:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241d:	eb 06                	jmp    80102425 <ideinit+0x55>
8010241f:	90                   	nop
  for(i=0; i<1000; i++){
80102420:	83 e9 01             	sub    $0x1,%ecx
80102423:	74 0f                	je     80102434 <ideinit+0x64>
80102425:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102426:	84 c0                	test   %al,%al
80102428:	74 f6                	je     80102420 <ideinit+0x50>
      havedisk1 = 1;
8010242a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102431:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102434:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102439:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010243e:	ee                   	out    %al,(%dx)
}
8010243f:	c9                   	leave  
80102440:	c3                   	ret    
80102441:	eb 0d                	jmp    80102450 <ideintr>
80102443:	90                   	nop
80102444:	90                   	nop
80102445:	90                   	nop
80102446:	90                   	nop
80102447:	90                   	nop
80102448:	90                   	nop
80102449:	90                   	nop
8010244a:	90                   	nop
8010244b:	90                   	nop
8010244c:	90                   	nop
8010244d:	90                   	nop
8010244e:	90                   	nop
8010244f:	90                   	nop

80102450 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102459:	68 80 b5 10 80       	push   $0x8010b580
8010245e:	e8 ed 26 00 00       	call   80104b50 <acquire>

  if((b = idequeue) == 0){
80102463:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 db                	test   %ebx,%ebx
8010246e:	74 67                	je     801024d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102470:	8b 43 58             	mov    0x58(%ebx),%eax
80102473:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102478:	8b 3b                	mov    (%ebx),%edi
8010247a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102480:	75 31                	jne    801024b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102482:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102487:	89 f6                	mov    %esi,%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102490:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102491:	89 c6                	mov    %eax,%esi
80102493:	83 e6 c0             	and    $0xffffffc0,%esi
80102496:	89 f1                	mov    %esi,%ecx
80102498:	80 f9 40             	cmp    $0x40,%cl
8010249b:	75 f3                	jne    80102490 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010249d:	a8 21                	test   $0x21,%al
8010249f:	75 12                	jne    801024b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801024a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024ae:	fc                   	cld    
801024af:	f3 6d                	rep insl (%dx),%es:(%edi)
801024b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801024b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024b9:	89 f9                	mov    %edi,%ecx
801024bb:	83 c9 02             	or     $0x2,%ecx
801024be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801024c0:	53                   	push   %ebx
801024c1:	e8 6a 22 00 00       	call   80104730 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024c6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024cb:	83 c4 10             	add    $0x10,%esp
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 05                	je     801024d7 <ideintr+0x87>
    idestart(idequeue);
801024d2:	e8 19 fe ff ff       	call   801022f0 <idestart>
    release(&idelock);
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 80 b5 10 80       	push   $0x8010b580
801024df:	e8 2c 27 00 00       	call   80104c10 <release>

  release(&idelock);
}
801024e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e7:	5b                   	pop    %ebx
801024e8:	5e                   	pop    %esi
801024e9:	5f                   	pop    %edi
801024ea:	5d                   	pop    %ebp
801024eb:	c3                   	ret    
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 10             	sub    $0x10,%esp
801024f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801024fd:	50                   	push   %eax
801024fe:	e8 bd 24 00 00       	call   801049c0 <holdingsleep>
80102503:	83 c4 10             	add    $0x10,%esp
80102506:	85 c0                	test   %eax,%eax
80102508:	0f 84 c6 00 00 00    	je     801025d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	0f 84 ab 00 00 00    	je     801025c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010251c:	8b 53 04             	mov    0x4(%ebx),%edx
8010251f:	85 d2                	test   %edx,%edx
80102521:	74 0d                	je     80102530 <iderw+0x40>
80102523:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102528:	85 c0                	test   %eax,%eax
8010252a:	0f 84 b1 00 00 00    	je     801025e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 80 b5 10 80       	push   $0x8010b580
80102538:	e8 13 26 00 00       	call   80104b50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010253d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102543:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102546:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254d:	85 d2                	test   %edx,%edx
8010254f:	75 09                	jne    8010255a <iderw+0x6a>
80102551:	eb 6d                	jmp    801025c0 <iderw+0xd0>
80102553:	90                   	nop
80102554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102558:	89 c2                	mov    %eax,%edx
8010255a:	8b 42 58             	mov    0x58(%edx),%eax
8010255d:	85 c0                	test   %eax,%eax
8010255f:	75 f7                	jne    80102558 <iderw+0x68>
80102561:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102564:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102566:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010256c:	74 42                	je     801025b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010256e:	8b 03                	mov    (%ebx),%eax
80102570:	83 e0 06             	and    $0x6,%eax
80102573:	83 f8 02             	cmp    $0x2,%eax
80102576:	74 23                	je     8010259b <iderw+0xab>
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102580:	83 ec 08             	sub    $0x8,%esp
80102583:	68 80 b5 10 80       	push   $0x8010b580
80102588:	53                   	push   %ebx
80102589:	e8 b2 1f 00 00       	call   80104540 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	83 e0 06             	and    $0x6,%eax
80102596:	83 f8 02             	cmp    $0x2,%eax
80102599:	75 e5                	jne    80102580 <iderw+0x90>
  }


  release(&idelock);
8010259b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a5:	c9                   	leave  
  release(&idelock);
801025a6:	e9 65 26 00 00       	jmp    80104c10 <release>
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801025b0:	89 d8                	mov    %ebx,%eax
801025b2:	e8 39 fd ff ff       	call   801022f0 <idestart>
801025b7:	eb b5                	jmp    8010256e <iderw+0x7e>
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025c5:	eb 9d                	jmp    80102564 <iderw+0x74>
    panic("iderw: nothing to do");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 c4 81 10 80       	push   $0x801081c4
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 ae 81 10 80       	push   $0x801081ae
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 d9 81 10 80       	push   $0x801081d9
801025e9:	e8 a2 dd ff ff       	call   80100390 <panic>
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025f1:	c7 05 54 56 11 80 00 	movl   $0xfec00000,0x80115654
801025f8:	00 c0 fe 
{
801025fb:	89 e5                	mov    %esp,%ebp
801025fd:	56                   	push   %esi
801025fe:	53                   	push   %ebx
  ioapic->reg = reg;
801025ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102606:	00 00 00 
  return ioapic->data;
80102609:	a1 54 56 11 80       	mov    0x80115654,%eax
8010260e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102617:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010261d:	0f b6 15 80 d7 14 80 	movzbl 0x8014d780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102624:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102627:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010262a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010262d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102630:	39 c2                	cmp    %eax,%edx
80102632:	74 16                	je     8010264a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 f8 81 10 80       	push   $0x801081f8
8010263c:	e8 1f e0 ff ff       	call   80100660 <cprintf>
80102641:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	83 c3 21             	add    $0x21,%ebx
{
8010264d:	ba 10 00 00 00       	mov    $0x10,%edx
80102652:	b8 20 00 00 00       	mov    $0x20,%eax
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102660:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102662:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102668:	89 c6                	mov    %eax,%esi
8010266a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102670:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102673:	89 71 10             	mov    %esi,0x10(%ecx)
80102676:	8d 72 01             	lea    0x1(%edx),%esi
80102679:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010267c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010267e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102680:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
80102686:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010268d:	75 d1                	jne    80102660 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010268f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102692:	5b                   	pop    %ebx
80102693:	5e                   	pop    %esi
80102694:	5d                   	pop    %ebp
80102695:	c3                   	ret    
80102696:	8d 76 00             	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026a0:	55                   	push   %ebp
  ioapic->reg = reg;
801026a1:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
{
801026a7:	89 e5                	mov    %esp,%ebp
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026ac:	8d 50 20             	lea    0x20(%eax),%edx
801026af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026b5:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c6:	a1 54 56 11 80       	mov    0x80115654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	66 90                	xchg   %ax,%ax
801026d5:	66 90                	xchg   %ax,%ax
801026d7:	66 90                	xchg   %ax,%ax
801026d9:	66 90                	xchg   %ax,%ax
801026db:	66 90                	xchg   %ax,%ax
801026dd:	66 90                	xchg   %ax,%ax
801026df:	90                   	nop

801026e0 <set_counter>:
  uint references_count[PHYSTOP >> PTXSHIFT];
} kmem;

void
set_counter(uint v, int i)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
801026e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801026e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&kmem.lock);
801026eb:	83 ec 0c             	sub    $0xc,%esp
801026ee:	68 60 56 11 80       	push   $0x80115660
  kmem.references_count[v >> PTXSHIFT] = i;
801026f3:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
801026f6:	e8 55 24 00 00       	call   80104b50 <acquire>
  kmem.references_count[v >> PTXSHIFT] = i;
801026fb:	89 34 9d 9c 56 11 80 	mov    %esi,-0x7feea964(,%ebx,4)
  // ((struct run*)v)->ref_count = 1;
  // cprintf("get_ref_counter : %x: %d\n",v,counter);
  release(&kmem.lock);
80102702:	c7 45 08 60 56 11 80 	movl   $0x80115660,0x8(%ebp)
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010270f:	5b                   	pop    %ebx
80102710:	5e                   	pop    %esi
80102711:	5d                   	pop    %ebp
  release(&kmem.lock);
80102712:	e9 f9 24 00 00       	jmp    80104c10 <release>
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <get_ref_counter>:

int
get_ref_counter(uint v)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	53                   	push   %ebx
80102724:	83 ec 10             	sub    $0x10,%esp
  int counter;
  acquire(&kmem.lock);
80102727:	68 60 56 11 80       	push   $0x80115660
8010272c:	e8 1f 24 00 00       	call   80104b50 <acquire>
  counter = kmem.references_count[v >> PTXSHIFT];
80102731:	8b 45 08             	mov    0x8(%ebp),%eax
  // counter = ((struct run*)v)->ref_count;
  // cprintf("get_ref_counter original: %x, deref: %x, value: %d\n",v, (int)*v, kmem.references_count[(int)*v]);
  release(&kmem.lock);
80102734:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
  counter = kmem.references_count[v >> PTXSHIFT];
8010273b:	c1 e8 0c             	shr    $0xc,%eax
8010273e:	8b 1c 85 9c 56 11 80 	mov    -0x7feea964(,%eax,4),%ebx
  release(&kmem.lock);
80102745:	e8 c6 24 00 00       	call   80104c10 <release>
  return counter;
}
8010274a:	89 d8                	mov    %ebx,%eax
8010274c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010274f:	c9                   	leave  
80102750:	c3                   	ret    
80102751:	eb 0d                	jmp    80102760 <inc_counter>
80102753:	90                   	nop
80102754:	90                   	nop
80102755:	90                   	nop
80102756:	90                   	nop
80102757:	90                   	nop
80102758:	90                   	nop
80102759:	90                   	nop
8010275a:	90                   	nop
8010275b:	90                   	nop
8010275c:	90                   	nop
8010275d:	90                   	nop
8010275e:	90                   	nop
8010275f:	90                   	nop

80102760 <inc_counter>:


void
inc_counter(uint v)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 10             	sub    $0x10,%esp
80102767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
8010276a:	68 60 56 11 80       	push   $0x80115660
8010276f:	e8 dc 23 00 00       	call   80104b50 <acquire>
  // cprintf("[%x] increased from: %d ", v, kmem.references_count[v >> PTXSHIFT]);
  kmem.references_count[v >> PTXSHIFT]++;
80102774:	89 d8                	mov    %ebx,%eax
  // cprintf("to: %d\n", kmem.references_count[v >> PTXSHIFT]);
  release(&kmem.lock);
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	c7 45 08 60 56 11 80 	movl   $0x80115660,0x8(%ebp)
  kmem.references_count[v >> PTXSHIFT]++;
80102780:	c1 e8 0c             	shr    $0xc,%eax
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  kmem.references_count[v >> PTXSHIFT]++;
80102786:	83 04 85 9c 56 11 80 	addl   $0x1,-0x7feea964(,%eax,4)
8010278d:	01 
}
8010278e:	c9                   	leave  
  release(&kmem.lock);
8010278f:	e9 7c 24 00 00       	jmp    80104c10 <release>
80102794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010279a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801027a0 <dec_counter>:

void
dec_counter(uint v)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 10             	sub    $0x10,%esp
801027a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
801027aa:	68 60 56 11 80       	push   $0x80115660
801027af:	e8 9c 23 00 00       	call   80104b50 <acquire>
  kmem.references_count[v >> PTXSHIFT]--;
801027b4:	89 d8                	mov    %ebx,%eax
  release(&kmem.lock);
801027b6:	83 c4 10             	add    $0x10,%esp
801027b9:	c7 45 08 60 56 11 80 	movl   $0x80115660,0x8(%ebp)
  kmem.references_count[v >> PTXSHIFT]--;
801027c0:	c1 e8 0c             	shr    $0xc,%eax
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  kmem.references_count[v >> PTXSHIFT]--;
801027c6:	83 2c 85 9c 56 11 80 	subl   $0x1,-0x7feea964(,%eax,4)
801027cd:	01 
}
801027ce:	c9                   	leave  
  release(&kmem.lock);
801027cf:	e9 3c 24 00 00       	jmp    80104c10 <release>
801027d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801027e0 <free_pages>:

int
free_pages()
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  int free_p = 0;

  if(kmem.use_lock)
801027e6:	8b 0d 94 56 11 80    	mov    0x80115694,%ecx
801027ec:	85 c9                	test   %ecx,%ecx
801027ee:	75 40                	jne    80102830 <free_pages+0x50>
    acquire(&kmem.lock);

  r = kmem.freelist;
801027f0:	8b 15 98 56 11 80    	mov    0x80115698,%edx
  while (r) {
801027f6:	85 d2                	test   %edx,%edx
801027f8:	74 5e                	je     80102858 <free_pages+0x78>
{
801027fa:	31 c0                	xor    %eax,%eax
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    free_p++;
    r = r->next;
80102800:	8b 12                	mov    (%edx),%edx
    free_p++;
80102802:	83 c0 01             	add    $0x1,%eax
  while (r) {
80102805:	85 d2                	test   %edx,%edx
80102807:	75 f7                	jne    80102800 <free_pages+0x20>
  }

  if(kmem.use_lock)
80102809:	85 c9                	test   %ecx,%ecx
8010280b:	75 03                	jne    80102810 <free_pages+0x30>
    release(&kmem.lock);

  return free_p;
}
8010280d:	c9                   	leave  
8010280e:	c3                   	ret    
8010280f:	90                   	nop
    release(&kmem.lock);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102816:	68 60 56 11 80       	push   $0x80115660
8010281b:	e8 f0 23 00 00       	call   80104c10 <release>
  return free_p;
80102820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102823:	83 c4 10             	add    $0x10,%esp
}
80102826:	c9                   	leave  
80102827:	c3                   	ret    
80102828:	90                   	nop
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	68 60 56 11 80       	push   $0x80115660
80102838:	e8 13 23 00 00       	call   80104b50 <acquire>
  r = kmem.freelist;
8010283d:	8b 15 98 56 11 80    	mov    0x80115698,%edx
  while (r) {
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	8b 0d 94 56 11 80    	mov    0x80115694,%ecx
8010284c:	85 d2                	test   %edx,%edx
8010284e:	75 aa                	jne    801027fa <free_pages+0x1a>
  int free_p = 0;
80102850:	31 c0                	xor    %eax,%eax
80102852:	eb b5                	jmp    80102809 <free_pages+0x29>
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102858:	31 c0                	xor    %eax,%eax
}
8010285a:	c9                   	leave  
8010285b:	c3                   	ret    
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	56                   	push   %esi
80102864:	53                   	push   %ebx
80102865:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102868:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
8010286e:	0f 85 b1 00 00 00    	jne    80102925 <kfree+0xc5>
80102874:	81 fe c8 86 15 80    	cmp    $0x801586c8,%esi
8010287a:	0f 82 a5 00 00 00    	jb     80102925 <kfree+0xc5>
80102880:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80102886:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010288c:	0f 87 93 00 00 00    	ja     80102925 <kfree+0xc5>
    panic("kfree");

  if(kmem.use_lock)
80102892:	8b 15 94 56 11 80    	mov    0x80115694,%edx
80102898:	85 d2                	test   %edx,%edx
8010289a:	75 74                	jne    80102910 <kfree+0xb0>
    acquire(&kmem.lock);

  if (kmem.references_count[V2P(v) >> PTXSHIFT] > 0) {
8010289c:	c1 eb 0c             	shr    $0xc,%ebx
8010289f:	83 c3 0c             	add    $0xc,%ebx
801028a2:	8b 04 9d 6c 56 11 80 	mov    -0x7feea994(,%ebx,4),%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	75 33                	jne    801028e0 <kfree+0x80>
    if(kmem.use_lock)
      release(&kmem.lock);
    return;
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801028ad:	83 ec 04             	sub    $0x4,%esp
801028b0:	68 00 10 00 00       	push   $0x1000
801028b5:	6a 01                	push   $0x1
801028b7:	56                   	push   %esi
801028b8:	e8 a3 23 00 00       	call   80104c60 <memset>

  r = (struct run*)v;
  r->next = kmem.freelist;
801028bd:	a1 98 56 11 80       	mov    0x80115698,%eax
  kmem.freelist = r;
  if(kmem.use_lock)
801028c2:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
801028c5:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
801028c7:	a1 94 56 11 80       	mov    0x80115694,%eax
  kmem.freelist = r;
801028cc:	89 35 98 56 11 80    	mov    %esi,0x80115698
  if(kmem.use_lock)
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 21                	jne    801028f7 <kfree+0x97>
    release(&kmem.lock);
}
801028d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028d9:	5b                   	pop    %ebx
801028da:	5e                   	pop    %esi
801028db:	5d                   	pop    %ebp
801028dc:	c3                   	ret    
801028dd:	8d 76 00             	lea    0x0(%esi),%esi
    kmem.references_count[V2P(v) >> PTXSHIFT] --;
801028e0:	83 e8 01             	sub    $0x1,%eax
  if (kmem.references_count[V2P(v) >> PTXSHIFT] != 0) {
801028e3:	85 c0                	test   %eax,%eax
    kmem.references_count[V2P(v) >> PTXSHIFT] --;
801028e5:	89 04 9d 6c 56 11 80 	mov    %eax,-0x7feea994(,%ebx,4)
  if (kmem.references_count[V2P(v) >> PTXSHIFT] != 0) {
801028ec:	74 bf                	je     801028ad <kfree+0x4d>
  if(kmem.use_lock)
801028ee:	a1 94 56 11 80       	mov    0x80115694,%eax
801028f3:	85 c0                	test   %eax,%eax
801028f5:	74 df                	je     801028d6 <kfree+0x76>
      release(&kmem.lock);
801028f7:	c7 45 08 60 56 11 80 	movl   $0x80115660,0x8(%ebp)
}
801028fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102901:	5b                   	pop    %ebx
80102902:	5e                   	pop    %esi
80102903:	5d                   	pop    %ebp
      release(&kmem.lock);
80102904:	e9 07 23 00 00       	jmp    80104c10 <release>
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	68 60 56 11 80       	push   $0x80115660
80102918:	e8 33 22 00 00       	call   80104b50 <acquire>
8010291d:	83 c4 10             	add    $0x10,%esp
80102920:	e9 77 ff ff ff       	jmp    8010289c <kfree+0x3c>
    panic("kfree");
80102925:	83 ec 0c             	sub    $0xc,%esp
80102928:	68 2a 82 10 80       	push   $0x8010822a
8010292d:	e8 5e da ff ff       	call   80100390 <panic>
80102932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <freerange>:
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	56                   	push   %esi
80102944:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102945:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102948:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010294b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102951:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102957:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010295d:	39 de                	cmp    %ebx,%esi
8010295f:	72 37                	jb     80102998 <freerange+0x58>
80102961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102968:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
8010296e:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102971:	c1 e8 0c             	shr    $0xc,%eax
80102974:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
8010297b:	00 00 00 00 
    kfree(p);
8010297f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102985:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010298b:	50                   	push   %eax
8010298c:	e8 cf fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102991:	83 c4 10             	add    $0x10,%esp
80102994:	39 f3                	cmp    %esi,%ebx
80102996:	76 d0                	jbe    80102968 <freerange+0x28>
}
80102998:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010299b:	5b                   	pop    %ebx
8010299c:	5e                   	pop    %esi
8010299d:	5d                   	pop    %ebp
8010299e:	c3                   	ret    
8010299f:	90                   	nop

801029a0 <kinit1>:
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	56                   	push   %esi
801029a4:	53                   	push   %ebx
801029a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801029a8:	83 ec 08             	sub    $0x8,%esp
801029ab:	68 30 82 10 80       	push   $0x80108230
801029b0:	68 60 56 11 80       	push   $0x80115660
801029b5:	e8 56 20 00 00       	call   80104a10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801029bd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801029c0:	c7 05 94 56 11 80 00 	movl   $0x0,0x80115694
801029c7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801029ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801029d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029dc:	39 de                	cmp    %ebx,%esi
801029de:	72 30                	jb     80102a10 <kinit1+0x70>
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
801029e0:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801029e6:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
801029e9:	c1 e8 0c             	shr    $0xc,%eax
801029ec:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
801029f3:	00 00 00 00 
    kfree(p);
801029f7:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801029fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a03:	50                   	push   %eax
80102a04:	e8 57 fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a09:	83 c4 10             	add    $0x10,%esp
80102a0c:	39 de                	cmp    %ebx,%esi
80102a0e:	73 d0                	jae    801029e0 <kinit1+0x40>
}
80102a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a13:	5b                   	pop    %ebx
80102a14:	5e                   	pop    %esi
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <kinit2>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a3d:	39 de                	cmp    %ebx,%esi
80102a3f:	72 37                	jb     80102a78 <kinit2+0x58>
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102a48:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
80102a4e:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102a51:	c1 e8 0c             	shr    $0xc,%eax
80102a54:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
80102a5b:	00 00 00 00 
    kfree(p);
80102a5f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a65:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a6b:	50                   	push   %eax
80102a6c:	e8 ef fd ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a71:	83 c4 10             	add    $0x10,%esp
80102a74:	39 de                	cmp    %ebx,%esi
80102a76:	73 d0                	jae    80102a48 <kinit2+0x28>
  kmem.use_lock = 1;
80102a78:	c7 05 94 56 11 80 01 	movl   $0x1,0x80115694
80102a7f:	00 00 00 
}
80102a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a85:	5b                   	pop    %ebx
80102a86:	5e                   	pop    %esi
80102a87:	5d                   	pop    %ebp
80102a88:	c3                   	ret    
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a90 <kalloc>:
char*
kalloc(void)
{
  struct run *r;
  // cprintf("HERE\n");
  if(kmem.use_lock)
80102a90:	a1 94 56 11 80       	mov    0x80115694,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	75 2f                	jne    80102ac8 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a99:	a1 98 56 11 80       	mov    0x80115698,%eax
  if(r) {
80102a9e:	85 c0                	test   %eax,%eax
80102aa0:	74 1e                	je     80102ac0 <kalloc+0x30>
    kmem.freelist = r->next;
80102aa2:	8b 10                	mov    (%eax),%edx
80102aa4:	89 15 98 56 11 80    	mov    %edx,0x80115698
    kmem.references_count[V2P(r) >> PTXSHIFT] = 1;
80102aaa:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102ab0:	c1 ea 0c             	shr    $0xc,%edx
80102ab3:	c7 04 95 9c 56 11 80 	movl   $0x1,-0x7feea964(,%edx,4)
80102aba:	01 00 00 00 
80102abe:	c3                   	ret    
80102abf:	90                   	nop
  }

  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102ac0:	f3 c3                	repz ret 
80102ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102ac8:	55                   	push   %ebp
80102ac9:	89 e5                	mov    %esp,%ebp
80102acb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102ace:	68 60 56 11 80       	push   $0x80115660
80102ad3:	e8 78 20 00 00       	call   80104b50 <acquire>
  r = kmem.freelist;
80102ad8:	a1 98 56 11 80       	mov    0x80115698,%eax
  if(r) {
80102add:	83 c4 10             	add    $0x10,%esp
80102ae0:	8b 0d 94 56 11 80    	mov    0x80115694,%ecx
80102ae6:	85 c0                	test   %eax,%eax
80102ae8:	74 1c                	je     80102b06 <kalloc+0x76>
    kmem.freelist = r->next;
80102aea:	8b 10                	mov    (%eax),%edx
80102aec:	89 15 98 56 11 80    	mov    %edx,0x80115698
    kmem.references_count[V2P(r) >> PTXSHIFT] = 1;
80102af2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102af8:	c1 ea 0c             	shr    $0xc,%edx
80102afb:	c7 04 95 9c 56 11 80 	movl   $0x1,-0x7feea964(,%edx,4)
80102b02:	01 00 00 00 
  if(kmem.use_lock)
80102b06:	85 c9                	test   %ecx,%ecx
80102b08:	74 16                	je     80102b20 <kalloc+0x90>
    release(&kmem.lock);
80102b0a:	83 ec 0c             	sub    $0xc,%esp
80102b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b10:	68 60 56 11 80       	push   $0x80115660
80102b15:	e8 f6 20 00 00       	call   80104c10 <release>
  return (char*)r;
80102b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b1d:	83 c4 10             	add    $0x10,%esp
}
80102b20:	c9                   	leave  
80102b21:	c3                   	ret    
80102b22:	66 90                	xchg   %ax,%ax
80102b24:	66 90                	xchg   %ax,%ax
80102b26:	66 90                	xchg   %ax,%ax
80102b28:	66 90                	xchg   %ax,%ax
80102b2a:	66 90                	xchg   %ax,%ax
80102b2c:	66 90                	xchg   %ax,%ax
80102b2e:	66 90                	xchg   %ax,%ax

80102b30 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	ba 64 00 00 00       	mov    $0x64,%edx
80102b35:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b36:	a8 01                	test   $0x1,%al
80102b38:	0f 84 c2 00 00 00    	je     80102c00 <kbdgetc+0xd0>
80102b3e:	ba 60 00 00 00       	mov    $0x60,%edx
80102b43:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b44:	0f b6 d0             	movzbl %al,%edx
80102b47:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102b4d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102b53:	0f 84 7f 00 00 00    	je     80102bd8 <kbdgetc+0xa8>
{
80102b59:	55                   	push   %ebp
80102b5a:	89 e5                	mov    %esp,%ebp
80102b5c:	53                   	push   %ebx
80102b5d:	89 cb                	mov    %ecx,%ebx
80102b5f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b62:	84 c0                	test   %al,%al
80102b64:	78 4a                	js     80102bb0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b66:	85 db                	test   %ebx,%ebx
80102b68:	74 09                	je     80102b73 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b6a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b6d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102b70:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102b73:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
80102b7a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102b7c:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
80102b83:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b85:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102b87:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102b8d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102b90:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b93:	8b 04 85 40 82 10 80 	mov    -0x7fef7dc0(,%eax,4),%eax
80102b9a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102b9e:	74 31                	je     80102bd1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102ba0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102ba3:	83 fa 19             	cmp    $0x19,%edx
80102ba6:	77 40                	ja     80102be8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ba8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bab:	5b                   	pop    %ebx
80102bac:	5d                   	pop    %ebp
80102bad:	c3                   	ret    
80102bae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102bb0:	83 e0 7f             	and    $0x7f,%eax
80102bb3:	85 db                	test   %ebx,%ebx
80102bb5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102bb8:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
80102bbf:	83 c8 40             	or     $0x40,%eax
80102bc2:	0f b6 c0             	movzbl %al,%eax
80102bc5:	f7 d0                	not    %eax
80102bc7:	21 c1                	and    %eax,%ecx
    return 0;
80102bc9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bcb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102bd1:	5b                   	pop    %ebx
80102bd2:	5d                   	pop    %ebp
80102bd3:	c3                   	ret    
80102bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102bd8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102bdb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102bdd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102be3:	c3                   	ret    
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102be8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102beb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102bee:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102bef:	83 f9 1a             	cmp    $0x1a,%ecx
80102bf2:	0f 42 c2             	cmovb  %edx,%eax
}
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    
80102bf7:	89 f6                	mov    %esi,%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <kbdintr>:

void
kbdintr(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c16:	68 30 2b 10 80       	push   $0x80102b30
80102c1b:	e8 f0 db ff ff       	call   80100810 <consoleintr>
}
80102c20:	83 c4 10             	add    $0x10,%esp
80102c23:	c9                   	leave  
80102c24:	c3                   	ret    
80102c25:	66 90                	xchg   %ax,%ax
80102c27:	66 90                	xchg   %ax,%ax
80102c29:	66 90                	xchg   %ax,%ax
80102c2b:	66 90                	xchg   %ax,%ax
80102c2d:	66 90                	xchg   %ax,%ax
80102c2f:	90                   	nop

80102c30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c30:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
{
80102c35:	55                   	push   %ebp
80102c36:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102c38:	85 c0                	test   %eax,%eax
80102c3a:	0f 84 c8 00 00 00    	je     80102d08 <lapicinit+0xd8>
  lapic[index] = value;
80102c40:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c47:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c4d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c5a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c61:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c67:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c6e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102c71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c74:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102c7b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c81:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102c88:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102c8e:	8b 50 30             	mov    0x30(%eax),%edx
80102c91:	c1 ea 10             	shr    $0x10,%edx
80102c94:	80 fa 03             	cmp    $0x3,%dl
80102c97:	77 77                	ja     80102d10 <lapicinit+0xe0>
  lapic[index] = value;
80102c99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ca0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cc7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ccd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102cd4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cda:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ce1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce4:	8b 50 20             	mov    0x20(%eax),%edx
80102ce7:	89 f6                	mov    %esi,%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102cf0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102cf6:	80 e6 10             	and    $0x10,%dh
80102cf9:	75 f5                	jne    80102cf0 <lapicinit+0xc0>
  lapic[index] = value;
80102cfb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d08:	5d                   	pop    %ebp
80102d09:	c3                   	ret    
80102d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102d10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1a:	8b 50 20             	mov    0x20(%eax),%edx
80102d1d:	e9 77 ff ff ff       	jmp    80102c99 <lapicinit+0x69>
80102d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d30:	8b 15 9c d6 14 80    	mov    0x8014d69c,%edx
{
80102d36:	55                   	push   %ebp
80102d37:	31 c0                	xor    %eax,%eax
80102d39:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102d3b:	85 d2                	test   %edx,%edx
80102d3d:	74 06                	je     80102d45 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102d3f:	8b 42 20             	mov    0x20(%edx),%eax
80102d42:	c1 e8 18             	shr    $0x18,%eax
}
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
80102d47:	89 f6                	mov    %esi,%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102d50:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
{
80102d55:	55                   	push   %ebp
80102d56:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102d58:	85 c0                	test   %eax,%eax
80102d5a:	74 0d                	je     80102d69 <lapiceoi+0x19>
  lapic[index] = value;
80102d5c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d63:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d66:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d69:	5d                   	pop    %ebp
80102d6a:	c3                   	ret    
80102d6b:	90                   	nop
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
}
80102d73:	5d                   	pop    %ebp
80102d74:	c3                   	ret    
80102d75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102d80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102d86:	ba 70 00 00 00       	mov    $0x70,%edx
80102d8b:	89 e5                	mov    %esp,%ebp
80102d8d:	53                   	push   %ebx
80102d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d94:	ee                   	out    %al,(%dx)
80102d95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102d9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102da0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102da2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102da5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102dab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102dad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102db0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102db3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102db5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102db8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dbe:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
80102dc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dcc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102dd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dd6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102de0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102de6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102def:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102df5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102df8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e0a:	5b                   	pop    %ebx
80102e0b:	5d                   	pop    %ebp
80102e0c:	c3                   	ret    
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi

80102e10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e10:	55                   	push   %ebp
80102e11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e16:	ba 70 00 00 00       	mov    $0x70,%edx
80102e1b:	89 e5                	mov    %esp,%ebp
80102e1d:	57                   	push   %edi
80102e1e:	56                   	push   %esi
80102e1f:	53                   	push   %ebx
80102e20:	83 ec 4c             	sub    $0x4c,%esp
80102e23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e24:	ba 71 00 00 00       	mov    $0x71,%edx
80102e29:	ec                   	in     (%dx),%al
80102e2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e35:	8d 76 00             	lea    0x0(%esi),%esi
80102e38:	31 c0                	xor    %eax,%eax
80102e3a:	89 da                	mov    %ebx,%edx
80102e3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e42:	89 ca                	mov    %ecx,%edx
80102e44:	ec                   	in     (%dx),%al
80102e45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e48:	89 da                	mov    %ebx,%edx
80102e4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e50:	89 ca                	mov    %ecx,%edx
80102e52:	ec                   	in     (%dx),%al
80102e53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e56:	89 da                	mov    %ebx,%edx
80102e58:	b8 04 00 00 00       	mov    $0x4,%eax
80102e5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e5e:	89 ca                	mov    %ecx,%edx
80102e60:	ec                   	in     (%dx),%al
80102e61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e64:	89 da                	mov    %ebx,%edx
80102e66:	b8 07 00 00 00       	mov    $0x7,%eax
80102e6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6c:	89 ca                	mov    %ecx,%edx
80102e6e:	ec                   	in     (%dx),%al
80102e6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e72:	89 da                	mov    %ebx,%edx
80102e74:	b8 08 00 00 00       	mov    $0x8,%eax
80102e79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7a:	89 ca                	mov    %ecx,%edx
80102e7c:	ec                   	in     (%dx),%al
80102e7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e7f:	89 da                	mov    %ebx,%edx
80102e81:	b8 09 00 00 00       	mov    $0x9,%eax
80102e86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e87:	89 ca                	mov    %ecx,%edx
80102e89:	ec                   	in     (%dx),%al
80102e8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e8c:	89 da                	mov    %ebx,%edx
80102e8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e94:	89 ca                	mov    %ecx,%edx
80102e96:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e97:	84 c0                	test   %al,%al
80102e99:	78 9d                	js     80102e38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102e9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102e9f:	89 fa                	mov    %edi,%edx
80102ea1:	0f b6 fa             	movzbl %dl,%edi
80102ea4:	89 f2                	mov    %esi,%edx
80102ea6:	0f b6 f2             	movzbl %dl,%esi
80102ea9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eac:	89 da                	mov    %ebx,%edx
80102eae:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102eb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102eb4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102eb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ebb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102ebf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ec2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ec6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ec9:	31 c0                	xor    %eax,%eax
80102ecb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ecc:	89 ca                	mov    %ecx,%edx
80102ece:	ec                   	in     (%dx),%al
80102ecf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed2:	89 da                	mov    %ebx,%edx
80102ed4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ed7:	b8 02 00 00 00       	mov    $0x2,%eax
80102edc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102edd:	89 ca                	mov    %ecx,%edx
80102edf:	ec                   	in     (%dx),%al
80102ee0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee3:	89 da                	mov    %ebx,%edx
80102ee5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ee8:	b8 04 00 00 00       	mov    $0x4,%eax
80102eed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eee:	89 ca                	mov    %ecx,%edx
80102ef0:	ec                   	in     (%dx),%al
80102ef1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef4:	89 da                	mov    %ebx,%edx
80102ef6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ef9:	b8 07 00 00 00       	mov    $0x7,%eax
80102efe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eff:	89 ca                	mov    %ecx,%edx
80102f01:	ec                   	in     (%dx),%al
80102f02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f05:	89 da                	mov    %ebx,%edx
80102f07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f10:	89 ca                	mov    %ecx,%edx
80102f12:	ec                   	in     (%dx),%al
80102f13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f16:	89 da                	mov    %ebx,%edx
80102f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f21:	89 ca                	mov    %ecx,%edx
80102f23:	ec                   	in     (%dx),%al
80102f24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f30:	6a 18                	push   $0x18
80102f32:	50                   	push   %eax
80102f33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f36:	50                   	push   %eax
80102f37:	e8 74 1d 00 00       	call   80104cb0 <memcmp>
80102f3c:	83 c4 10             	add    $0x10,%esp
80102f3f:	85 c0                	test   %eax,%eax
80102f41:	0f 85 f1 fe ff ff    	jne    80102e38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f4b:	75 78                	jne    80102fc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f50:	89 c2                	mov    %eax,%edx
80102f52:	83 e0 0f             	and    $0xf,%eax
80102f55:	c1 ea 04             	shr    $0x4,%edx
80102f58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f64:	89 c2                	mov    %eax,%edx
80102f66:	83 e0 0f             	and    $0xf,%eax
80102f69:	c1 ea 04             	shr    $0x4,%edx
80102f6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102f75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f78:	89 c2                	mov    %eax,%edx
80102f7a:	83 e0 0f             	and    $0xf,%eax
80102f7d:	c1 ea 04             	shr    $0x4,%edx
80102f80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102f89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f8c:	89 c2                	mov    %eax,%edx
80102f8e:	83 e0 0f             	and    $0xf,%eax
80102f91:	c1 ea 04             	shr    $0x4,%edx
80102f94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102f9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fa0:	89 c2                	mov    %eax,%edx
80102fa2:	83 e0 0f             	and    $0xf,%eax
80102fa5:	c1 ea 04             	shr    $0x4,%edx
80102fa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fb4:	89 c2                	mov    %eax,%edx
80102fb6:	83 e0 0f             	and    $0xf,%eax
80102fb9:	c1 ea 04             	shr    $0x4,%edx
80102fbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102fc5:	8b 75 08             	mov    0x8(%ebp),%esi
80102fc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fcb:	89 06                	mov    %eax,(%esi)
80102fcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fd0:	89 46 04             	mov    %eax,0x4(%esi)
80102fd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fd6:	89 46 08             	mov    %eax,0x8(%esi)
80102fd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fdc:	89 46 0c             	mov    %eax,0xc(%esi)
80102fdf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fe2:	89 46 10             	mov    %eax,0x10(%esi)
80102fe5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fe8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102feb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ff5:	5b                   	pop    %ebx
80102ff6:	5e                   	pop    %esi
80102ff7:	5f                   	pop    %edi
80102ff8:	5d                   	pop    %ebp
80102ff9:	c3                   	ret    
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103000:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
80103006:	85 c9                	test   %ecx,%ecx
80103008:	0f 8e 8a 00 00 00    	jle    80103098 <install_trans+0x98>
{
8010300e:	55                   	push   %ebp
8010300f:	89 e5                	mov    %esp,%ebp
80103011:	57                   	push   %edi
80103012:	56                   	push   %esi
80103013:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103014:	31 db                	xor    %ebx,%ebx
{
80103016:	83 ec 0c             	sub    $0xc,%esp
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103020:	a1 d4 d6 14 80       	mov    0x8014d6d4,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 d8                	add    %ebx,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 9d ec d6 14 80 	pushl  -0x7feb2914(,%ebx,4)
80103044:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010304a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010304d:	e8 7e d0 ff ff       	call   801000d0 <bread>
80103052:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103054:	8d 47 5c             	lea    0x5c(%edi),%eax
80103057:	83 c4 0c             	add    $0xc,%esp
8010305a:	68 00 02 00 00       	push   $0x200
8010305f:	50                   	push   %eax
80103060:	8d 46 5c             	lea    0x5c(%esi),%eax
80103063:	50                   	push   %eax
80103064:	e8 a7 1c 00 00       	call   80104d10 <memmove>
    bwrite(dbuf);  // write dst to disk
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 2f d1 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103071:	89 3c 24             	mov    %edi,(%esp)
80103074:	e8 67 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 5f d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	39 1d e8 d6 14 80    	cmp    %ebx,0x8014d6e8
8010308a:	7f 94                	jg     80103020 <install_trans+0x20>
  }
}
8010308c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308f:	5b                   	pop    %ebx
80103090:	5e                   	pop    %esi
80103091:	5f                   	pop    %edi
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103098:	f3 c3                	repz ret 
8010309a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	56                   	push   %esi
801030a4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	ff 35 d4 d6 14 80    	pushl  0x8014d6d4
801030ae:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
801030b4:	e8 17 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801030b9:	8b 1d e8 d6 14 80    	mov    0x8014d6e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801030bf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030c2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
801030c4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
801030c6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801030c9:	7e 16                	jle    801030e1 <write_head+0x41>
801030cb:	c1 e3 02             	shl    $0x2,%ebx
801030ce:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
801030d0:	8b 8a ec d6 14 80    	mov    -0x7feb2914(%edx),%ecx
801030d6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
801030da:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
801030dd:	39 da                	cmp    %ebx,%edx
801030df:	75 ef                	jne    801030d0 <write_head+0x30>
  }
  bwrite(buf);
801030e1:	83 ec 0c             	sub    $0xc,%esp
801030e4:	56                   	push   %esi
801030e5:	e8 b6 d0 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801030ea:	89 34 24             	mov    %esi,(%esp)
801030ed:	e8 ee d0 ff ff       	call   801001e0 <brelse>
}
801030f2:	83 c4 10             	add    $0x10,%esp
801030f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030f8:	5b                   	pop    %ebx
801030f9:	5e                   	pop    %esi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    
801030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103100 <initlog>:
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 2c             	sub    $0x2c,%esp
80103107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010310a:	68 60 84 10 80       	push   $0x80108460
8010310f:	68 a0 d6 14 80       	push   $0x8014d6a0
80103114:	e8 f7 18 00 00       	call   80104a10 <initlock>
  readsb(dev, &sb);
80103119:	58                   	pop    %eax
8010311a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010311d:	5a                   	pop    %edx
8010311e:	50                   	push   %eax
8010311f:	53                   	push   %ebx
80103120:	e8 5b e3 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80103125:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010312b:	59                   	pop    %ecx
  log.dev = dev;
8010312c:	89 1d e4 d6 14 80    	mov    %ebx,0x8014d6e4
  log.size = sb.nlog;
80103132:	89 15 d8 d6 14 80    	mov    %edx,0x8014d6d8
  log.start = sb.logstart;
80103138:	a3 d4 d6 14 80       	mov    %eax,0x8014d6d4
  struct buf *buf = bread(log.dev, log.start);
8010313d:	5a                   	pop    %edx
8010313e:	50                   	push   %eax
8010313f:	53                   	push   %ebx
80103140:	e8 8b cf ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103145:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103148:	83 c4 10             	add    $0x10,%esp
8010314b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010314d:	89 1d e8 d6 14 80    	mov    %ebx,0x8014d6e8
  for (i = 0; i < log.lh.n; i++) {
80103153:	7e 1c                	jle    80103171 <initlog+0x71>
80103155:	c1 e3 02             	shl    $0x2,%ebx
80103158:	31 d2                	xor    %edx,%edx
8010315a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103160:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103164:	83 c2 04             	add    $0x4,%edx
80103167:	89 8a e8 d6 14 80    	mov    %ecx,-0x7feb2918(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010316d:	39 d3                	cmp    %edx,%ebx
8010316f:	75 ef                	jne    80103160 <initlog+0x60>
  brelse(buf);
80103171:	83 ec 0c             	sub    $0xc,%esp
80103174:	50                   	push   %eax
80103175:	e8 66 d0 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010317a:	e8 81 fe ff ff       	call   80103000 <install_trans>
  log.lh.n = 0;
8010317f:	c7 05 e8 d6 14 80 00 	movl   $0x0,0x8014d6e8
80103186:	00 00 00 
  write_head(); // clear the log
80103189:	e8 12 ff ff ff       	call   801030a0 <write_head>
}
8010318e:	83 c4 10             	add    $0x10,%esp
80103191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103194:	c9                   	leave  
80103195:	c3                   	ret    
80103196:	8d 76 00             	lea    0x0(%esi),%esi
80103199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031a6:	68 a0 d6 14 80       	push   $0x8014d6a0
801031ab:	e8 a0 19 00 00       	call   80104b50 <acquire>
801031b0:	83 c4 10             	add    $0x10,%esp
801031b3:	eb 18                	jmp    801031cd <begin_op+0x2d>
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031b8:	83 ec 08             	sub    $0x8,%esp
801031bb:	68 a0 d6 14 80       	push   $0x8014d6a0
801031c0:	68 a0 d6 14 80       	push   $0x8014d6a0
801031c5:	e8 76 13 00 00       	call   80104540 <sleep>
801031ca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801031cd:	a1 e0 d6 14 80       	mov    0x8014d6e0,%eax
801031d2:	85 c0                	test   %eax,%eax
801031d4:	75 e2                	jne    801031b8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801031d6:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
801031db:	8b 15 e8 d6 14 80    	mov    0x8014d6e8,%edx
801031e1:	83 c0 01             	add    $0x1,%eax
801031e4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801031e7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801031ea:	83 fa 1e             	cmp    $0x1e,%edx
801031ed:	7f c9                	jg     801031b8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801031ef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801031f2:	a3 dc d6 14 80       	mov    %eax,0x8014d6dc
      release(&log.lock);
801031f7:	68 a0 d6 14 80       	push   $0x8014d6a0
801031fc:	e8 0f 1a 00 00       	call   80104c10 <release>
      break;
    }
  }
}
80103201:	83 c4 10             	add    $0x10,%esp
80103204:	c9                   	leave  
80103205:	c3                   	ret    
80103206:	8d 76 00             	lea    0x0(%esi),%esi
80103209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103210 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103219:	68 a0 d6 14 80       	push   $0x8014d6a0
8010321e:	e8 2d 19 00 00       	call   80104b50 <acquire>
  log.outstanding -= 1;
80103223:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
  if(log.committing)
80103228:	8b 35 e0 d6 14 80    	mov    0x8014d6e0,%esi
8010322e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103231:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103234:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103236:	89 1d dc d6 14 80    	mov    %ebx,0x8014d6dc
  if(log.committing)
8010323c:	0f 85 1a 01 00 00    	jne    8010335c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103242:	85 db                	test   %ebx,%ebx
80103244:	0f 85 ee 00 00 00    	jne    80103338 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010324a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010324d:	c7 05 e0 d6 14 80 01 	movl   $0x1,0x8014d6e0
80103254:	00 00 00 
  release(&log.lock);
80103257:	68 a0 d6 14 80       	push   $0x8014d6a0
8010325c:	e8 af 19 00 00       	call   80104c10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103261:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
80103267:	83 c4 10             	add    $0x10,%esp
8010326a:	85 c9                	test   %ecx,%ecx
8010326c:	0f 8e 85 00 00 00    	jle    801032f7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103272:	a1 d4 d6 14 80       	mov    0x8014d6d4,%eax
80103277:	83 ec 08             	sub    $0x8,%esp
8010327a:	01 d8                	add    %ebx,%eax
8010327c:	83 c0 01             	add    $0x1,%eax
8010327f:	50                   	push   %eax
80103280:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
80103286:	e8 45 ce ff ff       	call   801000d0 <bread>
8010328b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010328d:	58                   	pop    %eax
8010328e:	5a                   	pop    %edx
8010328f:	ff 34 9d ec d6 14 80 	pushl  -0x7feb2914(,%ebx,4)
80103296:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010329c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010329f:	e8 2c ce ff ff       	call   801000d0 <bread>
801032a4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801032a6:	8d 40 5c             	lea    0x5c(%eax),%eax
801032a9:	83 c4 0c             	add    $0xc,%esp
801032ac:	68 00 02 00 00       	push   $0x200
801032b1:	50                   	push   %eax
801032b2:	8d 46 5c             	lea    0x5c(%esi),%eax
801032b5:	50                   	push   %eax
801032b6:	e8 55 1a 00 00       	call   80104d10 <memmove>
    bwrite(to);  // write the log
801032bb:	89 34 24             	mov    %esi,(%esp)
801032be:	e8 dd ce ff ff       	call   801001a0 <bwrite>
    brelse(from);
801032c3:	89 3c 24             	mov    %edi,(%esp)
801032c6:	e8 15 cf ff ff       	call   801001e0 <brelse>
    brelse(to);
801032cb:	89 34 24             	mov    %esi,(%esp)
801032ce:	e8 0d cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	3b 1d e8 d6 14 80    	cmp    0x8014d6e8,%ebx
801032dc:	7c 94                	jl     80103272 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801032de:	e8 bd fd ff ff       	call   801030a0 <write_head>
    install_trans(); // Now install writes to home locations
801032e3:	e8 18 fd ff ff       	call   80103000 <install_trans>
    log.lh.n = 0;
801032e8:	c7 05 e8 d6 14 80 00 	movl   $0x0,0x8014d6e8
801032ef:	00 00 00 
    write_head();    // Erase the transaction from the log
801032f2:	e8 a9 fd ff ff       	call   801030a0 <write_head>
    acquire(&log.lock);
801032f7:	83 ec 0c             	sub    $0xc,%esp
801032fa:	68 a0 d6 14 80       	push   $0x8014d6a0
801032ff:	e8 4c 18 00 00       	call   80104b50 <acquire>
    wakeup(&log);
80103304:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
    log.committing = 0;
8010330b:	c7 05 e0 d6 14 80 00 	movl   $0x0,0x8014d6e0
80103312:	00 00 00 
    wakeup(&log);
80103315:	e8 16 14 00 00       	call   80104730 <wakeup>
    release(&log.lock);
8010331a:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
80103321:	e8 ea 18 00 00       	call   80104c10 <release>
80103326:	83 c4 10             	add    $0x10,%esp
}
80103329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010332c:	5b                   	pop    %ebx
8010332d:	5e                   	pop    %esi
8010332e:	5f                   	pop    %edi
8010332f:	5d                   	pop    %ebp
80103330:	c3                   	ret    
80103331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103338:	83 ec 0c             	sub    $0xc,%esp
8010333b:	68 a0 d6 14 80       	push   $0x8014d6a0
80103340:	e8 eb 13 00 00       	call   80104730 <wakeup>
  release(&log.lock);
80103345:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
8010334c:	e8 bf 18 00 00       	call   80104c10 <release>
80103351:	83 c4 10             	add    $0x10,%esp
}
80103354:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103357:	5b                   	pop    %ebx
80103358:	5e                   	pop    %esi
80103359:	5f                   	pop    %edi
8010335a:	5d                   	pop    %ebp
8010335b:	c3                   	ret    
    panic("log.committing");
8010335c:	83 ec 0c             	sub    $0xc,%esp
8010335f:	68 64 84 10 80       	push   $0x80108464
80103364:	e8 27 d0 ff ff       	call   80100390 <panic>
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103370 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	53                   	push   %ebx
80103374:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103377:	8b 15 e8 d6 14 80    	mov    0x8014d6e8,%edx
{
8010337d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103380:	83 fa 1d             	cmp    $0x1d,%edx
80103383:	0f 8f 9d 00 00 00    	jg     80103426 <log_write+0xb6>
80103389:	a1 d8 d6 14 80       	mov    0x8014d6d8,%eax
8010338e:	83 e8 01             	sub    $0x1,%eax
80103391:	39 c2                	cmp    %eax,%edx
80103393:	0f 8d 8d 00 00 00    	jge    80103426 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103399:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
8010339e:	85 c0                	test   %eax,%eax
801033a0:	0f 8e 8d 00 00 00    	jle    80103433 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033a6:	83 ec 0c             	sub    $0xc,%esp
801033a9:	68 a0 d6 14 80       	push   $0x8014d6a0
801033ae:	e8 9d 17 00 00       	call   80104b50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033b3:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	83 f9 00             	cmp    $0x0,%ecx
801033bf:	7e 57                	jle    80103418 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033c1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801033c4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033c6:	3b 15 ec d6 14 80    	cmp    0x8014d6ec,%edx
801033cc:	75 0b                	jne    801033d9 <log_write+0x69>
801033ce:	eb 38                	jmp    80103408 <log_write+0x98>
801033d0:	39 14 85 ec d6 14 80 	cmp    %edx,-0x7feb2914(,%eax,4)
801033d7:	74 2f                	je     80103408 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801033d9:	83 c0 01             	add    $0x1,%eax
801033dc:	39 c1                	cmp    %eax,%ecx
801033de:	75 f0                	jne    801033d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801033e0:	89 14 85 ec d6 14 80 	mov    %edx,-0x7feb2914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801033e7:	83 c0 01             	add    $0x1,%eax
801033ea:	a3 e8 d6 14 80       	mov    %eax,0x8014d6e8
  b->flags |= B_DIRTY; // prevent eviction
801033ef:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801033f2:	c7 45 08 a0 d6 14 80 	movl   $0x8014d6a0,0x8(%ebp)
}
801033f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033fc:	c9                   	leave  
  release(&log.lock);
801033fd:	e9 0e 18 00 00       	jmp    80104c10 <release>
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103408:	89 14 85 ec d6 14 80 	mov    %edx,-0x7feb2914(,%eax,4)
8010340f:	eb de                	jmp    801033ef <log_write+0x7f>
80103411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103418:	8b 43 08             	mov    0x8(%ebx),%eax
8010341b:	a3 ec d6 14 80       	mov    %eax,0x8014d6ec
  if (i == log.lh.n)
80103420:	75 cd                	jne    801033ef <log_write+0x7f>
80103422:	31 c0                	xor    %eax,%eax
80103424:	eb c1                	jmp    801033e7 <log_write+0x77>
    panic("too big a transaction");
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	68 73 84 10 80       	push   $0x80108473
8010342e:	e8 5d cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103433:	83 ec 0c             	sub    $0xc,%esp
80103436:	68 89 84 10 80       	push   $0x80108489
8010343b:	e8 50 cf ff ff       	call   80100390 <panic>

80103440 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	53                   	push   %ebx
80103444:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103447:	e8 c4 09 00 00       	call   80103e10 <cpuid>
8010344c:	89 c3                	mov    %eax,%ebx
8010344e:	e8 bd 09 00 00       	call   80103e10 <cpuid>
80103453:	83 ec 04             	sub    $0x4,%esp
80103456:	53                   	push   %ebx
80103457:	50                   	push   %eax
80103458:	68 a4 84 10 80       	push   $0x801084a4
8010345d:	e8 fe d1 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103462:	e8 b9 2a 00 00       	call   80105f20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103467:	e8 24 09 00 00       	call   80103d90 <mycpu>
8010346c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010346e:	b8 01 00 00 00       	mov    $0x1,%eax
80103473:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010347a:	e8 c1 0d 00 00       	call   80104240 <scheduler>
8010347f:	90                   	nop

80103480 <mpenter>:
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103486:	e8 05 3b 00 00       	call   80106f90 <switchkvm>
  seginit();
8010348b:	e8 70 3a 00 00       	call   80106f00 <seginit>
  lapicinit();
80103490:	e8 9b f7 ff ff       	call   80102c30 <lapicinit>
  mpmain();
80103495:	e8 a6 ff ff ff       	call   80103440 <mpmain>
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <main>:
{
801034a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034a4:	83 e4 f0             	and    $0xfffffff0,%esp
801034a7:	ff 71 fc             	pushl  -0x4(%ecx)
801034aa:	55                   	push   %ebp
801034ab:	89 e5                	mov    %esp,%ebp
801034ad:	53                   	push   %ebx
801034ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034af:	83 ec 08             	sub    $0x8,%esp
801034b2:	68 00 00 40 80       	push   $0x80400000
801034b7:	68 c8 86 15 80       	push   $0x801586c8
801034bc:	e8 df f4 ff ff       	call   801029a0 <kinit1>
  kvmalloc();      // kernel page table
801034c1:	e8 9a 43 00 00       	call   80107860 <kvmalloc>
  mpinit();        // detect other processors
801034c6:	e8 75 01 00 00       	call   80103640 <mpinit>
  lapicinit();     // interrupt controller
801034cb:	e8 60 f7 ff ff       	call   80102c30 <lapicinit>
  seginit();       // segment descriptors
801034d0:	e8 2b 3a 00 00       	call   80106f00 <seginit>
  picinit();       // disable pic
801034d5:	e8 46 03 00 00       	call   80103820 <picinit>
  ioapicinit();    // another interrupt controller
801034da:	e8 11 f1 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
801034df:	e8 dc d4 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801034e4:	e8 87 2d 00 00       	call   80106270 <uartinit>
  pinit();         // process table
801034e9:	e8 82 08 00 00       	call   80103d70 <pinit>
  tvinit();        // trap vectors
801034ee:	e8 ad 29 00 00       	call   80105ea0 <tvinit>
  binit();         // buffer cache
801034f3:	e8 48 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
801034f8:	e8 a3 d8 ff ff       	call   80100da0 <fileinit>
  ideinit();       // disk 
801034fd:	e8 ce ee ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103502:	83 c4 0c             	add    $0xc,%esp
80103505:	68 8a 00 00 00       	push   $0x8a
8010350a:	68 8c b4 10 80       	push   $0x8010b48c
8010350f:	68 00 70 00 80       	push   $0x80007000
80103514:	e8 f7 17 00 00       	call   80104d10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103519:	69 05 20 dd 14 80 b0 	imul   $0xb0,0x8014dd20,%eax
80103520:	00 00 00 
80103523:	83 c4 10             	add    $0x10,%esp
80103526:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
8010352b:	3d a0 d7 14 80       	cmp    $0x8014d7a0,%eax
80103530:	76 71                	jbe    801035a3 <main+0x103>
80103532:	bb a0 d7 14 80       	mov    $0x8014d7a0,%ebx
80103537:	89 f6                	mov    %esi,%esi
80103539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103540:	e8 4b 08 00 00       	call   80103d90 <mycpu>
80103545:	39 d8                	cmp    %ebx,%eax
80103547:	74 41                	je     8010358a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103549:	e8 42 f5 ff ff       	call   80102a90 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010354e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103553:	c7 05 f8 6f 00 80 80 	movl   $0x80103480,0x80006ff8
8010355a:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010355d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103564:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103567:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010356c:	0f b6 03             	movzbl (%ebx),%eax
8010356f:	83 ec 08             	sub    $0x8,%esp
80103572:	68 00 70 00 00       	push   $0x7000
80103577:	50                   	push   %eax
80103578:	e8 03 f8 ff ff       	call   80102d80 <lapicstartap>
8010357d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103580:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103586:	85 c0                	test   %eax,%eax
80103588:	74 f6                	je     80103580 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010358a:	69 05 20 dd 14 80 b0 	imul   $0xb0,0x8014dd20,%eax
80103591:	00 00 00 
80103594:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010359a:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
8010359f:	39 c3                	cmp    %eax,%ebx
801035a1:	72 9d                	jb     80103540 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035a3:	83 ec 08             	sub    $0x8,%esp
801035a6:	68 00 00 00 8e       	push   $0x8e000000
801035ab:	68 00 00 40 80       	push   $0x80400000
801035b0:	e8 6b f4 ff ff       	call   80102a20 <kinit2>
  userinit();      // first user process
801035b5:	e8 a6 08 00 00       	call   80103e60 <userinit>
  mpmain();        // finish this processor's setup
801035ba:	e8 81 fe ff ff       	call   80103440 <mpmain>
801035bf:	90                   	nop

801035c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801035c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801035cb:	53                   	push   %ebx
  e = addr+len;
801035cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801035cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801035d2:	39 de                	cmp    %ebx,%esi
801035d4:	72 10                	jb     801035e6 <mpsearch1+0x26>
801035d6:	eb 50                	jmp    80103628 <mpsearch1+0x68>
801035d8:	90                   	nop
801035d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035e0:	39 fb                	cmp    %edi,%ebx
801035e2:	89 fe                	mov    %edi,%esi
801035e4:	76 42                	jbe    80103628 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035e6:	83 ec 04             	sub    $0x4,%esp
801035e9:	8d 7e 10             	lea    0x10(%esi),%edi
801035ec:	6a 04                	push   $0x4
801035ee:	68 b8 84 10 80       	push   $0x801084b8
801035f3:	56                   	push   %esi
801035f4:	e8 b7 16 00 00       	call   80104cb0 <memcmp>
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	85 c0                	test   %eax,%eax
801035fe:	75 e0                	jne    801035e0 <mpsearch1+0x20>
80103600:	89 f1                	mov    %esi,%ecx
80103602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103608:	0f b6 11             	movzbl (%ecx),%edx
8010360b:	83 c1 01             	add    $0x1,%ecx
8010360e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103610:	39 f9                	cmp    %edi,%ecx
80103612:	75 f4                	jne    80103608 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103614:	84 c0                	test   %al,%al
80103616:	75 c8                	jne    801035e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361b:	89 f0                	mov    %esi,%eax
8010361d:	5b                   	pop    %ebx
8010361e:	5e                   	pop    %esi
8010361f:	5f                   	pop    %edi
80103620:	5d                   	pop    %ebp
80103621:	c3                   	ret    
80103622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010362b:	31 f6                	xor    %esi,%esi
}
8010362d:	89 f0                	mov    %esi,%eax
8010362f:	5b                   	pop    %ebx
80103630:	5e                   	pop    %esi
80103631:	5f                   	pop    %edi
80103632:	5d                   	pop    %ebp
80103633:	c3                   	ret    
80103634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010363a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103640 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103649:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103650:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103657:	c1 e0 08             	shl    $0x8,%eax
8010365a:	09 d0                	or     %edx,%eax
8010365c:	c1 e0 04             	shl    $0x4,%eax
8010365f:	85 c0                	test   %eax,%eax
80103661:	75 1b                	jne    8010367e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103663:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010366a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103671:	c1 e0 08             	shl    $0x8,%eax
80103674:	09 d0                	or     %edx,%eax
80103676:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103679:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010367e:	ba 00 04 00 00       	mov    $0x400,%edx
80103683:	e8 38 ff ff ff       	call   801035c0 <mpsearch1>
80103688:	85 c0                	test   %eax,%eax
8010368a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010368d:	0f 84 3d 01 00 00    	je     801037d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103696:	8b 58 04             	mov    0x4(%eax),%ebx
80103699:	85 db                	test   %ebx,%ebx
8010369b:	0f 84 4f 01 00 00    	je     801037f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801036a7:	83 ec 04             	sub    $0x4,%esp
801036aa:	6a 04                	push   $0x4
801036ac:	68 d5 84 10 80       	push   $0x801084d5
801036b1:	56                   	push   %esi
801036b2:	e8 f9 15 00 00       	call   80104cb0 <memcmp>
801036b7:	83 c4 10             	add    $0x10,%esp
801036ba:	85 c0                	test   %eax,%eax
801036bc:	0f 85 2e 01 00 00    	jne    801037f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801036c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801036c9:	3c 01                	cmp    $0x1,%al
801036cb:	0f 95 c2             	setne  %dl
801036ce:	3c 04                	cmp    $0x4,%al
801036d0:	0f 95 c0             	setne  %al
801036d3:	20 c2                	and    %al,%dl
801036d5:	0f 85 15 01 00 00    	jne    801037f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801036db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801036e2:	66 85 ff             	test   %di,%di
801036e5:	74 1a                	je     80103701 <mpinit+0xc1>
801036e7:	89 f0                	mov    %esi,%eax
801036e9:	01 f7                	add    %esi,%edi
  sum = 0;
801036eb:	31 d2                	xor    %edx,%edx
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801036f0:	0f b6 08             	movzbl (%eax),%ecx
801036f3:	83 c0 01             	add    $0x1,%eax
801036f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801036f8:	39 c7                	cmp    %eax,%edi
801036fa:	75 f4                	jne    801036f0 <mpinit+0xb0>
801036fc:	84 d2                	test   %dl,%dl
801036fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103701:	85 f6                	test   %esi,%esi
80103703:	0f 84 e7 00 00 00    	je     801037f0 <mpinit+0x1b0>
80103709:	84 d2                	test   %dl,%dl
8010370b:	0f 85 df 00 00 00    	jne    801037f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103711:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103717:	a3 9c d6 14 80       	mov    %eax,0x8014d69c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010371c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103723:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103729:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010372e:	01 d6                	add    %edx,%esi
80103730:	39 c6                	cmp    %eax,%esi
80103732:	76 23                	jbe    80103757 <mpinit+0x117>
    switch(*p){
80103734:	0f b6 10             	movzbl (%eax),%edx
80103737:	80 fa 04             	cmp    $0x4,%dl
8010373a:	0f 87 ca 00 00 00    	ja     8010380a <mpinit+0x1ca>
80103740:	ff 24 95 fc 84 10 80 	jmp    *-0x7fef7b04(,%edx,4)
80103747:	89 f6                	mov    %esi,%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103750:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103753:	39 c6                	cmp    %eax,%esi
80103755:	77 dd                	ja     80103734 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103757:	85 db                	test   %ebx,%ebx
80103759:	0f 84 9e 00 00 00    	je     801037fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010375f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103762:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103766:	74 15                	je     8010377d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103768:	b8 70 00 00 00       	mov    $0x70,%eax
8010376d:	ba 22 00 00 00       	mov    $0x22,%edx
80103772:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103773:	ba 23 00 00 00       	mov    $0x23,%edx
80103778:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103779:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010377c:	ee                   	out    %al,(%dx)
  }
}
8010377d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103780:	5b                   	pop    %ebx
80103781:	5e                   	pop    %esi
80103782:	5f                   	pop    %edi
80103783:	5d                   	pop    %ebp
80103784:	c3                   	ret    
80103785:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103788:	8b 0d 20 dd 14 80    	mov    0x8014dd20,%ecx
8010378e:	83 f9 07             	cmp    $0x7,%ecx
80103791:	7f 19                	jg     801037ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103793:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103797:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010379d:	83 c1 01             	add    $0x1,%ecx
801037a0:	89 0d 20 dd 14 80    	mov    %ecx,0x8014dd20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037a6:	88 97 a0 d7 14 80    	mov    %dl,-0x7feb2860(%edi)
      p += sizeof(struct mpproc);
801037ac:	83 c0 14             	add    $0x14,%eax
      continue;
801037af:	e9 7c ff ff ff       	jmp    80103730 <mpinit+0xf0>
801037b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801037bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037bf:	88 15 80 d7 14 80    	mov    %dl,0x8014d780
      continue;
801037c5:	e9 66 ff ff ff       	jmp    80103730 <mpinit+0xf0>
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801037d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801037d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801037da:	e8 e1 fd ff ff       	call   801035c0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801037e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037e4:	0f 85 a9 fe ff ff    	jne    80103693 <mpinit+0x53>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	68 bd 84 10 80       	push   $0x801084bd
801037f8:	e8 93 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801037fd:	83 ec 0c             	sub    $0xc,%esp
80103800:	68 dc 84 10 80       	push   $0x801084dc
80103805:	e8 86 cb ff ff       	call   80100390 <panic>
      ismp = 0;
8010380a:	31 db                	xor    %ebx,%ebx
8010380c:	e9 26 ff ff ff       	jmp    80103737 <mpinit+0xf7>
80103811:	66 90                	xchg   %ax,%ax
80103813:	66 90                	xchg   %ax,%ax
80103815:	66 90                	xchg   %ax,%ax
80103817:	66 90                	xchg   %ax,%ax
80103819:	66 90                	xchg   %ax,%ax
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103820:	55                   	push   %ebp
80103821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103826:	ba 21 00 00 00       	mov    $0x21,%edx
8010382b:	89 e5                	mov    %esp,%ebp
8010382d:	ee                   	out    %al,(%dx)
8010382e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103833:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103834:	5d                   	pop    %ebp
80103835:	c3                   	ret    
80103836:	66 90                	xchg   %ax,%ax
80103838:	66 90                	xchg   %ax,%ax
8010383a:	66 90                	xchg   %ax,%ax
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 0c             	sub    $0xc,%esp
80103849:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010384c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010384f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103855:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010385b:	e8 60 d5 ff ff       	call   80100dc0 <filealloc>
80103860:	85 c0                	test   %eax,%eax
80103862:	89 03                	mov    %eax,(%ebx)
80103864:	74 22                	je     80103888 <pipealloc+0x48>
80103866:	e8 55 d5 ff ff       	call   80100dc0 <filealloc>
8010386b:	85 c0                	test   %eax,%eax
8010386d:	89 06                	mov    %eax,(%esi)
8010386f:	74 3f                	je     801038b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103871:	e8 1a f2 ff ff       	call   80102a90 <kalloc>
80103876:	85 c0                	test   %eax,%eax
80103878:	89 c7                	mov    %eax,%edi
8010387a:	75 54                	jne    801038d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010387c:	8b 03                	mov    (%ebx),%eax
8010387e:	85 c0                	test   %eax,%eax
80103880:	75 34                	jne    801038b6 <pipealloc+0x76>
80103882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103888:	8b 06                	mov    (%esi),%eax
8010388a:	85 c0                	test   %eax,%eax
8010388c:	74 0c                	je     8010389a <pipealloc+0x5a>
    fileclose(*f1);
8010388e:	83 ec 0c             	sub    $0xc,%esp
80103891:	50                   	push   %eax
80103892:	e8 e9 d5 ff ff       	call   80100e80 <fileclose>
80103897:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010389a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010389d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5f                   	pop    %edi
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    
801038a7:	89 f6                	mov    %esi,%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801038b0:	8b 03                	mov    (%ebx),%eax
801038b2:	85 c0                	test   %eax,%eax
801038b4:	74 e4                	je     8010389a <pipealloc+0x5a>
    fileclose(*f0);
801038b6:	83 ec 0c             	sub    $0xc,%esp
801038b9:	50                   	push   %eax
801038ba:	e8 c1 d5 ff ff       	call   80100e80 <fileclose>
  if(*f1)
801038bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801038c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801038c4:	85 c0                	test   %eax,%eax
801038c6:	75 c6                	jne    8010388e <pipealloc+0x4e>
801038c8:	eb d0                	jmp    8010389a <pipealloc+0x5a>
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801038d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801038d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801038da:	00 00 00 
  p->writeopen = 1;
801038dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801038e4:	00 00 00 
  p->nwrite = 0;
801038e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801038ee:	00 00 00 
  p->nread = 0;
801038f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801038f8:	00 00 00 
  initlock(&p->lock, "pipe");
801038fb:	68 10 85 10 80       	push   $0x80108510
80103900:	50                   	push   %eax
80103901:	e8 0a 11 00 00       	call   80104a10 <initlock>
  (*f0)->type = FD_PIPE;
80103906:	8b 03                	mov    (%ebx),%eax
  return 0;
80103908:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010390b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103911:	8b 03                	mov    (%ebx),%eax
80103913:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103917:	8b 03                	mov    (%ebx),%eax
80103919:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010391d:	8b 03                	mov    (%ebx),%eax
8010391f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103922:	8b 06                	mov    (%esi),%eax
80103924:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010392a:	8b 06                	mov    (%esi),%eax
8010392c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103930:	8b 06                	mov    (%esi),%eax
80103932:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103936:	8b 06                	mov    (%esi),%eax
80103938:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010393b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010393e:	31 c0                	xor    %eax,%eax
}
80103940:	5b                   	pop    %ebx
80103941:	5e                   	pop    %esi
80103942:	5f                   	pop    %edi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret    
80103945:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103950 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
80103955:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103958:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010395b:	83 ec 0c             	sub    $0xc,%esp
8010395e:	53                   	push   %ebx
8010395f:	e8 ec 11 00 00       	call   80104b50 <acquire>
  if(writable){
80103964:	83 c4 10             	add    $0x10,%esp
80103967:	85 f6                	test   %esi,%esi
80103969:	74 45                	je     801039b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010396b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103971:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103974:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010397b:	00 00 00 
    wakeup(&p->nread);
8010397e:	50                   	push   %eax
8010397f:	e8 ac 0d 00 00       	call   80104730 <wakeup>
80103984:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103987:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010398d:	85 d2                	test   %edx,%edx
8010398f:	75 0a                	jne    8010399b <pipeclose+0x4b>
80103991:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103997:	85 c0                	test   %eax,%eax
80103999:	74 35                	je     801039d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010399b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010399e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a1:	5b                   	pop    %ebx
801039a2:	5e                   	pop    %esi
801039a3:	5d                   	pop    %ebp
    release(&p->lock);
801039a4:	e9 67 12 00 00       	jmp    80104c10 <release>
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801039b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801039b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801039c0:	00 00 00 
    wakeup(&p->nwrite);
801039c3:	50                   	push   %eax
801039c4:	e8 67 0d 00 00       	call   80104730 <wakeup>
801039c9:	83 c4 10             	add    $0x10,%esp
801039cc:	eb b9                	jmp    80103987 <pipeclose+0x37>
801039ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	53                   	push   %ebx
801039d4:	e8 37 12 00 00       	call   80104c10 <release>
    kfree((char*)p);
801039d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801039dc:	83 c4 10             	add    $0x10,%esp
}
801039df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039e2:	5b                   	pop    %ebx
801039e3:	5e                   	pop    %esi
801039e4:	5d                   	pop    %ebp
    kfree((char*)p);
801039e5:	e9 76 ee ff ff       	jmp    80102860 <kfree>
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 28             	sub    $0x28,%esp
801039f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801039fc:	53                   	push   %ebx
801039fd:	e8 4e 11 00 00       	call   80104b50 <acquire>
  for(i = 0; i < n; i++){
80103a02:	8b 45 10             	mov    0x10(%ebp),%eax
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	0f 8e c9 00 00 00    	jle    80103ad9 <pipewrite+0xe9>
80103a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a13:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a19:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a1f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103a22:	03 4d 10             	add    0x10(%ebp),%ecx
80103a25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a28:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103a2e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103a34:	39 d0                	cmp    %edx,%eax
80103a36:	75 71                	jne    80103aa9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103a38:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a3e:	85 c0                	test   %eax,%eax
80103a40:	74 4e                	je     80103a90 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a42:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103a48:	eb 3a                	jmp    80103a84 <pipewrite+0x94>
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	57                   	push   %edi
80103a54:	e8 d7 0c 00 00       	call   80104730 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a59:	5a                   	pop    %edx
80103a5a:	59                   	pop    %ecx
80103a5b:	53                   	push   %ebx
80103a5c:	56                   	push   %esi
80103a5d:	e8 de 0a 00 00       	call   80104540 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a62:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103a68:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103a6e:	83 c4 10             	add    $0x10,%esp
80103a71:	05 00 02 00 00       	add    $0x200,%eax
80103a76:	39 c2                	cmp    %eax,%edx
80103a78:	75 36                	jne    80103ab0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103a7a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a80:	85 c0                	test   %eax,%eax
80103a82:	74 0c                	je     80103a90 <pipewrite+0xa0>
80103a84:	e8 a7 03 00 00       	call   80103e30 <myproc>
80103a89:	8b 40 24             	mov    0x24(%eax),%eax
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	74 c0                	je     80103a50 <pipewrite+0x60>
        release(&p->lock);
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	53                   	push   %ebx
80103a94:	e8 77 11 00 00       	call   80104c10 <release>
        return -1;
80103a99:	83 c4 10             	add    $0x10,%esp
80103a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa4:	5b                   	pop    %ebx
80103aa5:	5e                   	pop    %esi
80103aa6:	5f                   	pop    %edi
80103aa7:	5d                   	pop    %ebp
80103aa8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aa9:	89 c2                	mov    %eax,%edx
80103aab:	90                   	nop
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ab0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ab3:	8d 42 01             	lea    0x1(%edx),%eax
80103ab6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103abc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103ac2:	83 c6 01             	add    $0x1,%esi
80103ac5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103ac9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103acc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103acf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ad3:	0f 85 4f ff ff ff    	jne    80103a28 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ad9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	50                   	push   %eax
80103ae3:	e8 48 0c 00 00       	call   80104730 <wakeup>
  release(&p->lock);
80103ae8:	89 1c 24             	mov    %ebx,(%esp)
80103aeb:	e8 20 11 00 00       	call   80104c10 <release>
  return n;
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	8b 45 10             	mov    0x10(%ebp),%eax
80103af6:	eb a9                	jmp    80103aa1 <pipewrite+0xb1>
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b00 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 18             	sub    $0x18,%esp
80103b09:	8b 75 08             	mov    0x8(%ebp),%esi
80103b0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b0f:	56                   	push   %esi
80103b10:	e8 3b 10 00 00       	call   80104b50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b15:	83 c4 10             	add    $0x10,%esp
80103b18:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b1e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b24:	75 6a                	jne    80103b90 <piperead+0x90>
80103b26:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103b2c:	85 db                	test   %ebx,%ebx
80103b2e:	0f 84 c4 00 00 00    	je     80103bf8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b34:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b3a:	eb 2d                	jmp    80103b69 <piperead+0x69>
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b40:	83 ec 08             	sub    $0x8,%esp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	e8 f6 09 00 00       	call   80104540 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b4a:	83 c4 10             	add    $0x10,%esp
80103b4d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b53:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b59:	75 35                	jne    80103b90 <piperead+0x90>
80103b5b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103b61:	85 d2                	test   %edx,%edx
80103b63:	0f 84 8f 00 00 00    	je     80103bf8 <piperead+0xf8>
    if(myproc()->killed){
80103b69:	e8 c2 02 00 00       	call   80103e30 <myproc>
80103b6e:	8b 48 24             	mov    0x24(%eax),%ecx
80103b71:	85 c9                	test   %ecx,%ecx
80103b73:	74 cb                	je     80103b40 <piperead+0x40>
      release(&p->lock);
80103b75:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103b78:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103b7d:	56                   	push   %esi
80103b7e:	e8 8d 10 00 00       	call   80104c10 <release>
      return -1;
80103b83:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b89:	89 d8                	mov    %ebx,%eax
80103b8b:	5b                   	pop    %ebx
80103b8c:	5e                   	pop    %esi
80103b8d:	5f                   	pop    %edi
80103b8e:	5d                   	pop    %ebp
80103b8f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b90:	8b 45 10             	mov    0x10(%ebp),%eax
80103b93:	85 c0                	test   %eax,%eax
80103b95:	7e 61                	jle    80103bf8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103b97:	31 db                	xor    %ebx,%ebx
80103b99:	eb 13                	jmp    80103bae <piperead+0xae>
80103b9b:	90                   	nop
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ba0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ba6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103bac:	74 1f                	je     80103bcd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bae:	8d 41 01             	lea    0x1(%ecx),%eax
80103bb1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103bb7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103bbd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103bc2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bc5:	83 c3 01             	add    $0x1,%ebx
80103bc8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103bcb:	75 d3                	jne    80103ba0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103bcd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103bd3:	83 ec 0c             	sub    $0xc,%esp
80103bd6:	50                   	push   %eax
80103bd7:	e8 54 0b 00 00       	call   80104730 <wakeup>
  release(&p->lock);
80103bdc:	89 34 24             	mov    %esi,(%esp)
80103bdf:	e8 2c 10 00 00       	call   80104c10 <release>
  return i;
80103be4:	83 c4 10             	add    $0x10,%esp
}
80103be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bea:	89 d8                	mov    %ebx,%eax
80103bec:	5b                   	pop    %ebx
80103bed:	5e                   	pop    %esi
80103bee:	5f                   	pop    %edi
80103bef:	5d                   	pop    %ebp
80103bf0:	c3                   	ret    
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	31 db                	xor    %ebx,%ebx
80103bfa:	eb d1                	jmp    80103bcd <piperead+0xcd>
80103bfc:	66 90                	xchg   %ax,%ax
80103bfe:	66 90                	xchg   %ax,%ax

80103c00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c05:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
  acquire(&ptable.lock);
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 40 dd 14 80       	push   $0x8014dd40
80103c12:	e8 39 0f 00 00       	call   80104b50 <acquire>
80103c17:	83 c4 10             	add    $0x10,%esp
80103c1a:	eb 16                	jmp    80103c32 <allocproc+0x32>
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c20:	81 c3 84 02 00 00    	add    $0x284,%ebx
80103c26:	81 fb 74 7e 15 80    	cmp    $0x80157e74,%ebx
80103c2c:	0f 83 be 00 00 00    	jae    80103cf0 <allocproc+0xf0>
    if(p->state == UNUSED)
80103c32:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c35:	85 c0                	test   %eax,%eax
80103c37:	75 e7                	jne    80103c20 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c39:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c3e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c41:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c48:	8d 50 01             	lea    0x1(%eax),%edx
80103c4b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103c4e:	68 40 dd 14 80       	push   $0x8014dd40
  p->pid = nextpid++;
80103c53:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103c59:	e8 b2 0f 00 00       	call   80104c10 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c5e:	e8 2d ee ff ff       	call   80102a90 <kalloc>
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	85 c0                	test   %eax,%eax
80103c68:	89 c6                	mov    %eax,%esi
80103c6a:	89 43 08             	mov    %eax,0x8(%ebx)
80103c6d:	0f 84 98 00 00 00    	je     80103d0b <allocproc+0x10b>
  p->tf = (struct trapframe*)sp;

  // Page support
  p->swapFile = 0;
  p->page_faults = 0;
  if (p->pid > 2 && createSwapFile(p) != 0)     // ignore shell & init procs
80103c73:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  sp -= sizeof *p->tf;
80103c77:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  p->swapFile = 0;
80103c7d:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->page_faults = 0;
80103c84:	c7 83 80 02 00 00 00 	movl   $0x0,0x280(%ebx)
80103c8b:	00 00 00 
  sp -= sizeof *p->tf;
80103c8e:	89 43 18             	mov    %eax,0x18(%ebx)
  if (p->pid > 2 && createSwapFile(p) != 0)     // ignore shell & init procs
80103c91:	7f 3d                	jg     80103cd0 <allocproc+0xd0>
  

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103c93:	c7 86 b0 0f 00 00 92 	movl   $0x80105e92,0xfb0(%esi)
80103c9a:	5e 10 80 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103c9d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103ca0:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  p->context = (struct context*)sp;
80103ca6:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ca9:	6a 14                	push   $0x14
80103cab:	6a 00                	push   $0x0
80103cad:	56                   	push   %esi
80103cae:	e8 ad 0f 00 00       	call   80104c60 <memset>
  p->context->eip = (uint)forkret;
80103cb3:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cb6:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cb9:	c7 40 10 20 3d 10 80 	movl   $0x80103d20,0x10(%eax)
}
80103cc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc3:	89 d8                	mov    %ebx,%eax
80103cc5:	5b                   	pop    %ebx
80103cc6:	5e                   	pop    %esi
80103cc7:	5d                   	pop    %ebp
80103cc8:	c3                   	ret    
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (p->pid > 2 && createSwapFile(p) != 0)     // ignore shell & init procs
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	53                   	push   %ebx
80103cd4:	e8 17 e5 ff ff       	call   801021f0 <createSwapFile>
80103cd9:	83 c4 10             	add    $0x10,%esp
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 b3                	je     80103c93 <allocproc+0x93>
    panic("allocproc: createSwapFile failed\n");
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	68 18 85 10 80       	push   $0x80108518
80103ce8:	e8 a3 c6 ff ff       	call   80100390 <panic>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103cf3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103cf5:	68 40 dd 14 80       	push   $0x8014dd40
80103cfa:	e8 11 0f 00 00       	call   80104c10 <release>
  return 0;
80103cff:	83 c4 10             	add    $0x10,%esp
}
80103d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d05:	89 d8                	mov    %ebx,%eax
80103d07:	5b                   	pop    %ebx
80103d08:	5e                   	pop    %esi
80103d09:	5d                   	pop    %ebp
80103d0a:	c3                   	ret    
    p->state = UNUSED;
80103d0b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d12:	31 db                	xor    %ebx,%ebx
80103d14:	eb aa                	jmp    80103cc0 <allocproc+0xc0>
80103d16:	8d 76 00             	lea    0x0(%esi),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d26:	68 40 dd 14 80       	push   $0x8014dd40
80103d2b:	e8 e0 0e 00 00       	call   80104c10 <release>

  if (first) {
80103d30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	85 c0                	test   %eax,%eax
80103d3a:	75 04                	jne    80103d40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d3c:	c9                   	leave  
80103d3d:	c3                   	ret    
80103d3e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103d40:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103d43:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d4a:	00 00 00 
    iinit(ROOTDEV);
80103d4d:	6a 01                	push   $0x1
80103d4f:	e8 6c d7 ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103d54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d5b:	e8 a0 f3 ff ff       	call   80103100 <initlog>
80103d60:	83 c4 10             	add    $0x10,%esp
}
80103d63:	c9                   	leave  
80103d64:	c3                   	ret    
80103d65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <pinit>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d76:	68 a9 85 10 80       	push   $0x801085a9
80103d7b:	68 40 dd 14 80       	push   $0x8014dd40
80103d80:	e8 8b 0c 00 00       	call   80104a10 <initlock>
}
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	c9                   	leave  
80103d89:	c3                   	ret    
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <mycpu>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d95:	9c                   	pushf  
80103d96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d97:	f6 c4 02             	test   $0x2,%ah
80103d9a:	75 5e                	jne    80103dfa <mycpu+0x6a>
  apicid = lapicid();
80103d9c:	e8 8f ef ff ff       	call   80102d30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103da1:	8b 35 20 dd 14 80    	mov    0x8014dd20,%esi
80103da7:	85 f6                	test   %esi,%esi
80103da9:	7e 42                	jle    80103ded <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103dab:	0f b6 15 a0 d7 14 80 	movzbl 0x8014d7a0,%edx
80103db2:	39 d0                	cmp    %edx,%eax
80103db4:	74 30                	je     80103de6 <mycpu+0x56>
80103db6:	b9 50 d8 14 80       	mov    $0x8014d850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103dbb:	31 d2                	xor    %edx,%edx
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
80103dc0:	83 c2 01             	add    $0x1,%edx
80103dc3:	39 f2                	cmp    %esi,%edx
80103dc5:	74 26                	je     80103ded <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103dc7:	0f b6 19             	movzbl (%ecx),%ebx
80103dca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103dd0:	39 c3                	cmp    %eax,%ebx
80103dd2:	75 ec                	jne    80103dc0 <mycpu+0x30>
80103dd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103dda:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
}
80103ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de2:	5b                   	pop    %ebx
80103de3:	5e                   	pop    %esi
80103de4:	5d                   	pop    %ebp
80103de5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103de6:	b8 a0 d7 14 80       	mov    $0x8014d7a0,%eax
      return &cpus[i];
80103deb:	eb f2                	jmp    80103ddf <mycpu+0x4f>
  panic("unknown apicid\n");
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	68 b0 85 10 80       	push   $0x801085b0
80103df5:	e8 96 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 3c 85 10 80       	push   $0x8010853c
80103e02:	e8 89 c5 ff ff       	call   80100390 <panic>
80103e07:	89 f6                	mov    %esi,%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <cpuid>:
cpuid() {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e16:	e8 75 ff ff ff       	call   80103d90 <mycpu>
80103e1b:	2d a0 d7 14 80       	sub    $0x8014d7a0,%eax
}
80103e20:	c9                   	leave  
  return mycpu()-cpus;
80103e21:	c1 f8 04             	sar    $0x4,%eax
80103e24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e2a:	c3                   	ret    
80103e2b:	90                   	nop
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e30 <myproc>:
myproc(void) {
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e37:	e8 44 0c 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103e3c:	e8 4f ff ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103e41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e47:	e8 74 0c 00 00       	call   80104ac0 <popcli>
}
80103e4c:	83 c4 04             	add    $0x4,%esp
80103e4f:	89 d8                	mov    %ebx,%eax
80103e51:	5b                   	pop    %ebx
80103e52:	5d                   	pop    %ebp
80103e53:	c3                   	ret    
80103e54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e60 <userinit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e67:	e8 94 fd ff ff       	call   80103c00 <allocproc>
80103e6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e6e:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  if((p->pgdir = setupkvm()) == 0)
80103e73:	e8 68 39 00 00       	call   801077e0 <setupkvm>
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7d:	0f 84 bd 00 00 00    	je     80103f40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e83:	83 ec 04             	sub    $0x4,%esp
80103e86:	68 2c 00 00 00       	push   $0x2c
80103e8b:	68 60 b4 10 80       	push   $0x8010b460
80103e90:	50                   	push   %eax
80103e91:	e8 2a 32 00 00       	call   801070c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e9f:	6a 4c                	push   $0x4c
80103ea1:	6a 00                	push   $0x0
80103ea3:	ff 73 18             	pushl  0x18(%ebx)
80103ea6:	e8 b5 0d 00 00       	call   80104c60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103eab:	8b 43 18             	mov    0x18(%ebx),%eax
80103eae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eb3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eb8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ebf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ec6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ecd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ed1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ed8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103edc:	8b 43 18             	mov    0x18(%ebx),%eax
80103edf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ee6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ef0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103efa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103efd:	6a 10                	push   $0x10
80103eff:	68 d9 85 10 80       	push   $0x801085d9
80103f04:	50                   	push   %eax
80103f05:	e8 36 0f 00 00       	call   80104e40 <safestrcpy>
  p->cwd = namei("/");
80103f0a:	c7 04 24 e2 85 10 80 	movl   $0x801085e2,(%esp)
80103f11:	e8 0a e0 ff ff       	call   80101f20 <namei>
80103f16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f19:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80103f20:	e8 2b 0c 00 00       	call   80104b50 <acquire>
  p->state = RUNNABLE;
80103f25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f2c:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80103f33:	e8 d8 0c 00 00       	call   80104c10 <release>
}
80103f38:	83 c4 10             	add    $0x10,%esp
80103f3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3e:	c9                   	leave  
80103f3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	68 c0 85 10 80       	push   $0x801085c0
80103f48:	e8 43 c4 ff ff       	call   80100390 <panic>
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <growproc>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
80103f55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f58:	e8 23 0b 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103f5d:	e8 2e fe ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103f62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f68:	e8 53 0b 00 00       	call   80104ac0 <popcli>
  if(n > 0){
80103f6d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f70:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f72:	7f 1c                	jg     80103f90 <growproc+0x40>
  } else if(n < 0){
80103f74:	75 3a                	jne    80103fb0 <growproc+0x60>
  switchuvm(curproc);
80103f76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f79:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f7b:	53                   	push   %ebx
80103f7c:	e8 2f 30 00 00       	call   80106fb0 <switchuvm>
  return 0;
80103f81:	83 c4 10             	add    $0x10,%esp
80103f84:	31 c0                	xor    %eax,%eax
}
80103f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret    
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f90:	83 ec 04             	sub    $0x4,%esp
80103f93:	01 c6                	add    %eax,%esi
80103f95:	56                   	push   %esi
80103f96:	50                   	push   %eax
80103f97:	ff 73 04             	pushl  0x4(%ebx)
80103f9a:	e8 d1 35 00 00       	call   80107570 <allocuvm>
80103f9f:	83 c4 10             	add    $0x10,%esp
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	75 d0                	jne    80103f76 <growproc+0x26>
      return -1;
80103fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fab:	eb d9                	jmp    80103f86 <growproc+0x36>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 c6                	add    %eax,%esi
80103fb5:	56                   	push   %esi
80103fb6:	50                   	push   %eax
80103fb7:	ff 73 04             	pushl  0x4(%ebx)
80103fba:	e8 c1 34 00 00       	call   80107480 <deallocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 b0                	jne    80103f76 <growproc+0x26>
80103fc6:	eb de                	jmp    80103fa6 <growproc+0x56>
80103fc8:	90                   	nop
80103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fd0 <fork>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fd9:	e8 a2 0a 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103fde:	e8 ad fd ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103fe3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe9:	e8 d2 0a 00 00       	call   80104ac0 <popcli>
  if((np = allocproc()) == 0){
80103fee:	e8 0d fc ff ff       	call   80103c00 <allocproc>
80103ff3:	85 c0                	test   %eax,%eax
80103ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ff8:	0f 84 ec 01 00 00    	je     801041ea <fork+0x21a>
  if((np->pgdir = copyonwriteuvm(curproc->pgdir, curproc->sz)) == 0){
80103ffe:	83 ec 08             	sub    $0x8,%esp
80104001:	ff 33                	pushl  (%ebx)
80104003:	ff 73 04             	pushl  0x4(%ebx)
80104006:	e8 e5 39 00 00       	call   801079f0 <copyonwriteuvm>
8010400b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010400e:	83 c4 10             	add    $0x10,%esp
80104011:	85 c0                	test   %eax,%eax
80104013:	89 42 04             	mov    %eax,0x4(%edx)
80104016:	0f 84 d8 01 00 00    	je     801041f4 <fork+0x224>
  np->sz = curproc->sz;
8010401c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
8010401e:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80104023:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104026:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
80104029:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010402b:	8b 73 18             	mov    0x18(%ebx),%esi
8010402e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->page_faults = 0;
80104030:	c7 82 80 02 00 00 00 	movl   $0x0,0x280(%edx)
80104037:	00 00 00 
  if (curproc->pid > 2) {
8010403a:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010403e:	0f 8f 94 00 00 00    	jg     801040d8 <fork+0x108>
  np->tf->eax = 0;
80104044:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80104047:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104049:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104050:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104054:	85 c0                	test   %eax,%eax
80104056:	74 16                	je     8010406e <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010405e:	50                   	push   %eax
8010405f:	e8 cc cd ff ff       	call   80100e30 <filedup>
80104064:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104067:	83 c4 10             	add    $0x10,%esp
8010406a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010406e:	83 c6 01             	add    $0x1,%esi
80104071:	83 fe 10             	cmp    $0x10,%esi
80104074:	75 da                	jne    80104050 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104076:	83 ec 0c             	sub    $0xc,%esp
80104079:	ff 73 68             	pushl  0x68(%ebx)
8010407c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010407f:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104082:	e8 09 d6 ff ff       	call   80101690 <idup>
80104087:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010408a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010408d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104090:	8d 42 6c             	lea    0x6c(%edx),%eax
80104093:	6a 10                	push   $0x10
80104095:	53                   	push   %ebx
80104096:	50                   	push   %eax
80104097:	e8 a4 0d 00 00       	call   80104e40 <safestrcpy>
  pid = np->pid;
8010409c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010409f:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
801040a2:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
801040a9:	e8 a2 0a 00 00       	call   80104b50 <acquire>
  np->state = RUNNABLE;
801040ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040b1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801040b8:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
801040bf:	e8 4c 0b 00 00       	call   80104c10 <release>
  return pid;
801040c4:	83 c4 10             	add    $0x10,%esp
}
801040c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ca:	89 d8                	mov    %ebx,%eax
801040cc:	5b                   	pop    %ebx
801040cd:	5e                   	pop    %esi
801040ce:	5f                   	pop    %edi
801040cf:	5d                   	pop    %ebp
801040d0:	c3                   	ret    
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040d8:	31 f6                	xor    %esi,%esi
801040da:	eb 13                	jmp    801040ef <fork+0x11f>
801040dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e0:	83 c6 10             	add    $0x10,%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++) {
801040e3:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801040e9:	0f 84 55 ff ff ff    	je     80104044 <fork+0x74>
      np->memory_pages[i] = curproc->memory_pages[i];
801040ef:	8b 84 33 80 01 00 00 	mov    0x180(%ebx,%esi,1),%eax
801040f6:	89 84 32 80 01 00 00 	mov    %eax,0x180(%edx,%esi,1)
801040fd:	8b 84 33 84 01 00 00 	mov    0x184(%ebx,%esi,1),%eax
80104104:	89 84 32 84 01 00 00 	mov    %eax,0x184(%edx,%esi,1)
8010410b:	8b 84 33 88 01 00 00 	mov    0x188(%ebx,%esi,1),%eax
80104112:	89 84 32 88 01 00 00 	mov    %eax,0x188(%edx,%esi,1)
80104119:	8b 84 33 8c 01 00 00 	mov    0x18c(%ebx,%esi,1),%eax
80104120:	89 84 32 8c 01 00 00 	mov    %eax,0x18c(%edx,%esi,1)
      np->memory_pages[i].pgdir = np->pgdir;
80104127:	8b 42 04             	mov    0x4(%edx),%eax
8010412a:	89 84 32 80 01 00 00 	mov    %eax,0x180(%edx,%esi,1)
      np->file_pages[i] = curproc->file_pages[i];
80104131:	8b 8c 33 80 00 00 00 	mov    0x80(%ebx,%esi,1),%ecx
80104138:	89 8c 32 80 00 00 00 	mov    %ecx,0x80(%edx,%esi,1)
8010413f:	8b 8c 33 84 00 00 00 	mov    0x84(%ebx,%esi,1),%ecx
80104146:	89 8c 32 84 00 00 00 	mov    %ecx,0x84(%edx,%esi,1)
8010414d:	8b 8c 33 88 00 00 00 	mov    0x88(%ebx,%esi,1),%ecx
80104154:	89 8c 32 88 00 00 00 	mov    %ecx,0x88(%edx,%esi,1)
8010415b:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
      np->file_pages[i].pgdir = np->pgdir;
80104162:	89 84 32 80 00 00 00 	mov    %eax,0x80(%edx,%esi,1)
      np->file_pages[i] = curproc->file_pages[i];
80104169:	89 8c 32 8c 00 00 00 	mov    %ecx,0x8c(%edx,%esi,1)
      if (curproc->file_pages[i].is_used && readFromSwapFile(curproc, fork_buffer, PGSIZE*i, PGSIZE) != PGSIZE)
80104170:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
80104177:	85 c9                	test   %ecx,%ecx
80104179:	0f 84 61 ff ff ff    	je     801040e0 <fork+0x110>
8010417f:	89 f7                	mov    %esi,%edi
80104181:	68 00 10 00 00       	push   $0x1000
80104186:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104189:	c1 e7 08             	shl    $0x8,%edi
8010418c:	57                   	push   %edi
8010418d:	68 c0 b5 10 80       	push   $0x8010b5c0
80104192:	53                   	push   %ebx
80104193:	e8 28 e1 ff ff       	call   801022c0 <readFromSwapFile>
80104198:	83 c4 10             	add    $0x10,%esp
8010419b:	3d 00 10 00 00       	cmp    $0x1000,%eax
801041a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041a3:	0f 85 82 00 00 00    	jne    8010422b <fork+0x25b>
      if (curproc->file_pages[i].is_used && writeToSwapFile(np, fork_buffer, PGSIZE*i, PGSIZE) != PGSIZE)
801041a9:	8b 84 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%eax
801041b0:	85 c0                	test   %eax,%eax
801041b2:	0f 84 28 ff ff ff    	je     801040e0 <fork+0x110>
801041b8:	68 00 10 00 00       	push   $0x1000
801041bd:	57                   	push   %edi
801041be:	68 c0 b5 10 80       	push   $0x8010b5c0
801041c3:	52                   	push   %edx
801041c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801041c7:	e8 c4 e0 ff ff       	call   80102290 <writeToSwapFile>
801041cc:	83 c4 10             	add    $0x10,%esp
801041cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
801041d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041d7:	0f 84 03 ff ff ff    	je     801040e0 <fork+0x110>
        panic("fork: writeToSwapFile != PGSIZE\n");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 88 85 10 80       	push   $0x80108588
801041e5:	e8 a6 c1 ff ff       	call   80100390 <panic>
    return -1;
801041ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041ef:	e9 d3 fe ff ff       	jmp    801040c7 <fork+0xf7>
    cprintf("fork: copyonwriteuvm failed\n");
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	68 e4 85 10 80       	push   $0x801085e4
801041fc:	e8 5f c4 ff ff       	call   80100660 <cprintf>
    kfree(np->kstack);
80104201:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104204:	5b                   	pop    %ebx
    return -1;
80104205:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010420a:	ff 72 08             	pushl  0x8(%edx)
8010420d:	e8 4e e6 ff ff       	call   80102860 <kfree>
    np->kstack = 0;
80104212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104215:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104218:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010421f:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104226:	e9 9c fe ff ff       	jmp    801040c7 <fork+0xf7>
        panic("fork: readFromSwapFile != PGSIZE\n");
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	68 64 85 10 80       	push   $0x80108564
80104233:	e8 58 c1 ff ff       	call   80100390 <panic>
80104238:	90                   	nop
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104240 <scheduler>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104249:	e8 42 fb ff ff       	call   80103d90 <mycpu>
8010424e:	8d 78 04             	lea    0x4(%eax),%edi
80104251:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104253:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010425a:	00 00 00 
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104260:	fb                   	sti    
    acquire(&ptable.lock);
80104261:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104264:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
    acquire(&ptable.lock);
80104269:	68 40 dd 14 80       	push   $0x8014dd40
8010426e:	e8 dd 08 00 00       	call   80104b50 <acquire>
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	8d 76 00             	lea    0x0(%esi),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104280:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104284:	75 33                	jne    801042b9 <scheduler+0x79>
      switchuvm(p);
80104286:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104289:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010428f:	53                   	push   %ebx
80104290:	e8 1b 2d 00 00       	call   80106fb0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104295:	58                   	pop    %eax
80104296:	5a                   	pop    %edx
80104297:	ff 73 1c             	pushl  0x1c(%ebx)
8010429a:	57                   	push   %edi
      p->state = RUNNING;
8010429b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801042a2:	e8 f4 0b 00 00       	call   80104e9b <swtch>
      switchkvm();
801042a7:	e8 e4 2c 00 00       	call   80106f90 <switchkvm>
      c->proc = 0;
801042ac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801042b3:	00 00 00 
801042b6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b9:	81 c3 84 02 00 00    	add    $0x284,%ebx
801042bf:	81 fb 74 7e 15 80    	cmp    $0x80157e74,%ebx
801042c5:	72 b9                	jb     80104280 <scheduler+0x40>
    release(&ptable.lock);
801042c7:	83 ec 0c             	sub    $0xc,%esp
801042ca:	68 40 dd 14 80       	push   $0x8014dd40
801042cf:	e8 3c 09 00 00       	call   80104c10 <release>
    sti();
801042d4:	83 c4 10             	add    $0x10,%esp
801042d7:	eb 87                	jmp    80104260 <scheduler+0x20>
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042e0 <sched>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
  pushcli();
801042e5:	e8 96 07 00 00       	call   80104a80 <pushcli>
  c = mycpu();
801042ea:	e8 a1 fa ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801042ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042f5:	e8 c6 07 00 00       	call   80104ac0 <popcli>
  if(!holding(&ptable.lock))
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	68 40 dd 14 80       	push   $0x8014dd40
80104302:	e8 19 08 00 00       	call   80104b20 <holding>
80104307:	83 c4 10             	add    $0x10,%esp
8010430a:	85 c0                	test   %eax,%eax
8010430c:	74 4f                	je     8010435d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010430e:	e8 7d fa ff ff       	call   80103d90 <mycpu>
80104313:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010431a:	75 68                	jne    80104384 <sched+0xa4>
  if(p->state == RUNNING)
8010431c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104320:	74 55                	je     80104377 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104322:	9c                   	pushf  
80104323:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104324:	f6 c4 02             	test   $0x2,%ah
80104327:	75 41                	jne    8010436a <sched+0x8a>
  intena = mycpu()->intena;
80104329:	e8 62 fa ff ff       	call   80103d90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010432e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104331:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104337:	e8 54 fa ff ff       	call   80103d90 <mycpu>
8010433c:	83 ec 08             	sub    $0x8,%esp
8010433f:	ff 70 04             	pushl  0x4(%eax)
80104342:	53                   	push   %ebx
80104343:	e8 53 0b 00 00       	call   80104e9b <swtch>
  mycpu()->intena = intena;
80104348:	e8 43 fa ff ff       	call   80103d90 <mycpu>
}
8010434d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104350:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104356:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104359:	5b                   	pop    %ebx
8010435a:	5e                   	pop    %esi
8010435b:	5d                   	pop    %ebp
8010435c:	c3                   	ret    
    panic("sched ptable.lock");
8010435d:	83 ec 0c             	sub    $0xc,%esp
80104360:	68 01 86 10 80       	push   $0x80108601
80104365:	e8 26 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010436a:	83 ec 0c             	sub    $0xc,%esp
8010436d:	68 2d 86 10 80       	push   $0x8010862d
80104372:	e8 19 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
80104377:	83 ec 0c             	sub    $0xc,%esp
8010437a:	68 1f 86 10 80       	push   $0x8010861f
8010437f:	e8 0c c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104384:	83 ec 0c             	sub    $0xc,%esp
80104387:	68 13 86 10 80       	push   $0x80108613
8010438c:	e8 ff bf ff ff       	call   80100390 <panic>
80104391:	eb 0d                	jmp    801043a0 <exit>
80104393:	90                   	nop
80104394:	90                   	nop
80104395:	90                   	nop
80104396:	90                   	nop
80104397:	90                   	nop
80104398:	90                   	nop
80104399:	90                   	nop
8010439a:	90                   	nop
8010439b:	90                   	nop
8010439c:	90                   	nop
8010439d:	90                   	nop
8010439e:	90                   	nop
8010439f:	90                   	nop

801043a0 <exit>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801043a9:	e8 d2 06 00 00       	call   80104a80 <pushcli>
  c = mycpu();
801043ae:	e8 dd f9 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801043b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b9:	e8 02 07 00 00       	call   80104ac0 <popcli>
  if(curproc == initproc)
801043be:	39 1d c0 c5 10 80    	cmp    %ebx,0x8010c5c0
801043c4:	8d 73 28             	lea    0x28(%ebx),%esi
801043c7:	8d 7b 68             	lea    0x68(%ebx),%edi
801043ca:	0f 84 11 01 00 00    	je     801044e1 <exit+0x141>
    if(curproc->ofile[fd]){
801043d0:	8b 06                	mov    (%esi),%eax
801043d2:	85 c0                	test   %eax,%eax
801043d4:	74 12                	je     801043e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	50                   	push   %eax
801043da:	e8 a1 ca ff ff       	call   80100e80 <fileclose>
      curproc->ofile[fd] = 0;
801043df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801043eb:	39 fe                	cmp    %edi,%esi
801043ed:	75 e1                	jne    801043d0 <exit+0x30>
  if (curproc->pid > 2)
801043ef:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801043f3:	7e 0c                	jle    80104401 <exit+0x61>
    removeSwapFile(curproc);
801043f5:	83 ec 0c             	sub    $0xc,%esp
801043f8:	53                   	push   %ebx
801043f9:	e8 f2 db ff ff       	call   80101ff0 <removeSwapFile>
801043fe:	83 c4 10             	add    $0x10,%esp
  begin_op();
80104401:	e8 9a ed ff ff       	call   801031a0 <begin_op>
  iput(curproc->cwd);
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	ff 73 68             	pushl  0x68(%ebx)
8010440c:	e8 df d3 ff ff       	call   801017f0 <iput>
  end_op();
80104411:	e8 fa ed ff ff       	call   80103210 <end_op>
  curproc->cwd = 0;
80104416:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010441d:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80104424:	e8 27 07 00 00       	call   80104b50 <acquire>
  wakeup1(curproc->parent);
80104429:	8b 53 14             	mov    0x14(%ebx),%edx
8010442c:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442f:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
80104434:	eb 16                	jmp    8010444c <exit+0xac>
80104436:	8d 76 00             	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104440:	05 84 02 00 00       	add    $0x284,%eax
80104445:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
8010444a:	73 1e                	jae    8010446a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010444c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104450:	75 ee                	jne    80104440 <exit+0xa0>
80104452:	3b 50 20             	cmp    0x20(%eax),%edx
80104455:	75 e9                	jne    80104440 <exit+0xa0>
      p->state = RUNNABLE;
80104457:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010445e:	05 84 02 00 00       	add    $0x284,%eax
80104463:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
80104468:	72 e2                	jb     8010444c <exit+0xac>
      p->parent = initproc;
8010446a:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104470:	ba 74 dd 14 80       	mov    $0x8014dd74,%edx
80104475:	eb 17                	jmp    8010448e <exit+0xee>
80104477:	89 f6                	mov    %esi,%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104480:	81 c2 84 02 00 00    	add    $0x284,%edx
80104486:	81 fa 74 7e 15 80    	cmp    $0x80157e74,%edx
8010448c:	73 3a                	jae    801044c8 <exit+0x128>
    if(p->parent == curproc){
8010448e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104491:	75 ed                	jne    80104480 <exit+0xe0>
      if(p->state == ZOMBIE)
80104493:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104497:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010449a:	75 e4                	jne    80104480 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449c:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
801044a1:	eb 11                	jmp    801044b4 <exit+0x114>
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	05 84 02 00 00       	add    $0x284,%eax
801044ad:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
801044b2:	73 cc                	jae    80104480 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
801044b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044b8:	75 ee                	jne    801044a8 <exit+0x108>
801044ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801044bd:	75 e9                	jne    801044a8 <exit+0x108>
      p->state = RUNNABLE;
801044bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044c6:	eb e0                	jmp    801044a8 <exit+0x108>
  curproc->state = ZOMBIE;
801044c8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044cf:	e8 0c fe ff ff       	call   801042e0 <sched>
  panic("zombie exit");
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	68 4e 86 10 80       	push   $0x8010864e
801044dc:	e8 af be ff ff       	call   80100390 <panic>
    panic("init exiting");
801044e1:	83 ec 0c             	sub    $0xc,%esp
801044e4:	68 41 86 10 80       	push   $0x80108641
801044e9:	e8 a2 be ff ff       	call   80100390 <panic>
801044ee:	66 90                	xchg   %ax,%ax

801044f0 <yield>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044f7:	68 40 dd 14 80       	push   $0x8014dd40
801044fc:	e8 4f 06 00 00       	call   80104b50 <acquire>
  pushcli();
80104501:	e8 7a 05 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80104506:	e8 85 f8 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010450b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104511:	e8 aa 05 00 00       	call   80104ac0 <popcli>
  myproc()->state = RUNNABLE;
80104516:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010451d:	e8 be fd ff ff       	call   801042e0 <sched>
  release(&ptable.lock);
80104522:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80104529:	e8 e2 06 00 00       	call   80104c10 <release>
}
8010452e:	83 c4 10             	add    $0x10,%esp
80104531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104534:	c9                   	leave  
80104535:	c3                   	ret    
80104536:	8d 76 00             	lea    0x0(%esi),%esi
80104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104540 <sleep>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	83 ec 0c             	sub    $0xc,%esp
80104549:	8b 7d 08             	mov    0x8(%ebp),%edi
8010454c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010454f:	e8 2c 05 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80104554:	e8 37 f8 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104559:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010455f:	e8 5c 05 00 00       	call   80104ac0 <popcli>
  if(p == 0)
80104564:	85 db                	test   %ebx,%ebx
80104566:	0f 84 87 00 00 00    	je     801045f3 <sleep+0xb3>
  if(lk == 0)
8010456c:	85 f6                	test   %esi,%esi
8010456e:	74 76                	je     801045e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104570:	81 fe 40 dd 14 80    	cmp    $0x8014dd40,%esi
80104576:	74 50                	je     801045c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 40 dd 14 80       	push   $0x8014dd40
80104580:	e8 cb 05 00 00       	call   80104b50 <acquire>
    release(lk);
80104585:	89 34 24             	mov    %esi,(%esp)
80104588:	e8 83 06 00 00       	call   80104c10 <release>
  p->chan = chan;
8010458d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104590:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104597:	e8 44 fd ff ff       	call   801042e0 <sched>
  p->chan = 0;
8010459c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801045a3:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
801045aa:	e8 61 06 00 00       	call   80104c10 <release>
    acquire(lk);
801045af:	89 75 08             	mov    %esi,0x8(%ebp)
801045b2:	83 c4 10             	add    $0x10,%esp
}
801045b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b8:	5b                   	pop    %ebx
801045b9:	5e                   	pop    %esi
801045ba:	5f                   	pop    %edi
801045bb:	5d                   	pop    %ebp
    acquire(lk);
801045bc:	e9 8f 05 00 00       	jmp    80104b50 <acquire>
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801045c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045d2:	e8 09 fd ff ff       	call   801042e0 <sched>
  p->chan = 0;
801045d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801045de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e1:	5b                   	pop    %ebx
801045e2:	5e                   	pop    %esi
801045e3:	5f                   	pop    %edi
801045e4:	5d                   	pop    %ebp
801045e5:	c3                   	ret    
    panic("sleep without lk");
801045e6:	83 ec 0c             	sub    $0xc,%esp
801045e9:	68 60 86 10 80       	push   $0x80108660
801045ee:	e8 9d bd ff ff       	call   80100390 <panic>
    panic("sleep");
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	68 5a 86 10 80       	push   $0x8010865a
801045fb:	e8 90 bd ff ff       	call   80100390 <panic>

80104600 <wait>:
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
  pushcli();
80104605:	e8 76 04 00 00       	call   80104a80 <pushcli>
  c = mycpu();
8010460a:	e8 81 f7 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010460f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104615:	e8 a6 04 00 00       	call   80104ac0 <popcli>
  acquire(&ptable.lock);
8010461a:	83 ec 0c             	sub    $0xc,%esp
8010461d:	68 40 dd 14 80       	push   $0x8014dd40
80104622:	e8 29 05 00 00       	call   80104b50 <acquire>
80104627:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010462a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010462c:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
80104631:	eb 13                	jmp    80104646 <wait+0x46>
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104638:	81 c3 84 02 00 00    	add    $0x284,%ebx
8010463e:	81 fb 74 7e 15 80    	cmp    $0x80157e74,%ebx
80104644:	73 1e                	jae    80104664 <wait+0x64>
      if(p->parent != curproc)
80104646:	39 73 14             	cmp    %esi,0x14(%ebx)
80104649:	75 ed                	jne    80104638 <wait+0x38>
      if(p->state == ZOMBIE){
8010464b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010464f:	74 3f                	je     80104690 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104651:	81 c3 84 02 00 00    	add    $0x284,%ebx
      havekids = 1;
80104657:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465c:	81 fb 74 7e 15 80    	cmp    $0x80157e74,%ebx
80104662:	72 e2                	jb     80104646 <wait+0x46>
    if(!havekids || curproc->killed){
80104664:	85 c0                	test   %eax,%eax
80104666:	0f 84 a5 00 00 00    	je     80104711 <wait+0x111>
8010466c:	8b 46 24             	mov    0x24(%esi),%eax
8010466f:	85 c0                	test   %eax,%eax
80104671:	0f 85 9a 00 00 00    	jne    80104711 <wait+0x111>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104677:	83 ec 08             	sub    $0x8,%esp
8010467a:	68 40 dd 14 80       	push   $0x8014dd40
8010467f:	56                   	push   %esi
80104680:	e8 bb fe ff ff       	call   80104540 <sleep>
    havekids = 0;
80104685:	83 c4 10             	add    $0x10,%esp
80104688:	eb a0                	jmp    8010462a <wait+0x2a>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104696:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104699:	e8 c2 e1 ff ff       	call   80102860 <kfree>
        freevm(p->pgdir);
8010469e:	5a                   	pop    %edx
8010469f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801046a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801046a9:	e8 b2 30 00 00       	call   80107760 <freevm>
801046ae:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801046b4:	8d 93 8c 01 00 00    	lea    0x18c(%ebx),%edx
        p->pid = 0;
801046ba:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
801046c1:	83 c4 10             	add    $0x10,%esp
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          p->memory_pages[i].is_used = 0;
801046c8:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
801046cf:	00 00 00 
          p->file_pages[i].is_used = 0;
801046d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046d8:	83 c0 10             	add    $0x10,%eax
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
801046db:	39 c2                	cmp    %eax,%edx
801046dd:	75 e9                	jne    801046c8 <wait+0xc8>
        release(&ptable.lock);
801046df:	83 ec 0c             	sub    $0xc,%esp
        p->parent = 0;
801046e2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046e9:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        release(&ptable.lock);
801046ed:	68 40 dd 14 80       	push   $0x8014dd40
        p->killed = 0;
801046f2:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801046f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104700:	e8 0b 05 00 00       	call   80104c10 <release>
        return pid;
80104705:	83 c4 10             	add    $0x10,%esp
}
80104708:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010470b:	89 f0                	mov    %esi,%eax
8010470d:	5b                   	pop    %ebx
8010470e:	5e                   	pop    %esi
8010470f:	5d                   	pop    %ebp
80104710:	c3                   	ret    
      release(&ptable.lock);
80104711:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104714:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104719:	68 40 dd 14 80       	push   $0x8014dd40
8010471e:	e8 ed 04 00 00       	call   80104c10 <release>
      return -1;
80104723:	83 c4 10             	add    $0x10,%esp
80104726:	eb e0                	jmp    80104708 <wait+0x108>
80104728:	90                   	nop
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104730 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 10             	sub    $0x10,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010473a:	68 40 dd 14 80       	push   $0x8014dd40
8010473f:	e8 0c 04 00 00       	call   80104b50 <acquire>
80104744:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104747:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
8010474c:	eb 0e                	jmp    8010475c <wakeup+0x2c>
8010474e:	66 90                	xchg   %ax,%ax
80104750:	05 84 02 00 00       	add    $0x284,%eax
80104755:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
8010475a:	73 1e                	jae    8010477a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010475c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104760:	75 ee                	jne    80104750 <wakeup+0x20>
80104762:	3b 58 20             	cmp    0x20(%eax),%ebx
80104765:	75 e9                	jne    80104750 <wakeup+0x20>
      p->state = RUNNABLE;
80104767:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010476e:	05 84 02 00 00       	add    $0x284,%eax
80104773:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
80104778:	72 e2                	jb     8010475c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010477a:	c7 45 08 40 dd 14 80 	movl   $0x8014dd40,0x8(%ebp)
}
80104781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104784:	c9                   	leave  
  release(&ptable.lock);
80104785:	e9 86 04 00 00       	jmp    80104c10 <release>
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 10             	sub    $0x10,%esp
80104797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010479a:	68 40 dd 14 80       	push   $0x8014dd40
8010479f:	e8 ac 03 00 00       	call   80104b50 <acquire>
801047a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a7:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
801047ac:	eb 0e                	jmp    801047bc <kill+0x2c>
801047ae:	66 90                	xchg   %ax,%ax
801047b0:	05 84 02 00 00       	add    $0x284,%eax
801047b5:	3d 74 7e 15 80       	cmp    $0x80157e74,%eax
801047ba:	73 34                	jae    801047f0 <kill+0x60>
    if(p->pid == pid){
801047bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801047bf:	75 ef                	jne    801047b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801047c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801047c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801047cc:	75 07                	jne    801047d5 <kill+0x45>
        p->state = RUNNABLE;
801047ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801047d5:	83 ec 0c             	sub    $0xc,%esp
801047d8:	68 40 dd 14 80       	push   $0x8014dd40
801047dd:	e8 2e 04 00 00       	call   80104c10 <release>
      return 0;
801047e2:	83 c4 10             	add    $0x10,%esp
801047e5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801047e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ea:	c9                   	leave  
801047eb:	c3                   	ret    
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	68 40 dd 14 80       	push   $0x8014dd40
801047f8:	e8 13 04 00 00       	call   80104c10 <release>
  return -1;
801047fd:	83 c4 10             	add    $0x10,%esp
80104800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104808:	c9                   	leave  
80104809:	c3                   	ret    
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104819:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
{
8010481e:	83 ec 3c             	sub    $0x3c,%esp
80104821:	eb 27                	jmp    8010484a <procdump+0x3a>
80104823:	90                   	nop
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 f7 89 10 80       	push   $0x801089f7
80104830:	e8 2b be ff ff       	call   80100660 <cprintf>
80104835:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104838:	81 c3 84 02 00 00    	add    $0x284,%ebx
8010483e:	81 fb 74 7e 15 80    	cmp    $0x80157e74,%ebx
80104844:	0f 83 86 00 00 00    	jae    801048d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010484a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010484d:	85 c0                	test   %eax,%eax
8010484f:	74 e7                	je     80104838 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104851:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104854:	ba 71 86 10 80       	mov    $0x80108671,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104859:	77 11                	ja     8010486c <procdump+0x5c>
8010485b:	8b 14 85 a8 86 10 80 	mov    -0x7fef7958(,%eax,4),%edx
      state = "???";
80104862:	b8 71 86 10 80       	mov    $0x80108671,%eax
80104867:	85 d2                	test   %edx,%edx
80104869:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010486c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010486f:	50                   	push   %eax
80104870:	52                   	push   %edx
80104871:	ff 73 10             	pushl  0x10(%ebx)
80104874:	68 75 86 10 80       	push   $0x80108675
80104879:	e8 e2 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010487e:	83 c4 10             	add    $0x10,%esp
80104881:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104885:	75 a1                	jne    80104828 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104887:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010488a:	83 ec 08             	sub    $0x8,%esp
8010488d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104890:	50                   	push   %eax
80104891:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104894:	8b 40 0c             	mov    0xc(%eax),%eax
80104897:	83 c0 08             	add    $0x8,%eax
8010489a:	50                   	push   %eax
8010489b:	e8 90 01 00 00       	call   80104a30 <getcallerpcs>
801048a0:	83 c4 10             	add    $0x10,%esp
801048a3:	90                   	nop
801048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801048a8:	8b 17                	mov    (%edi),%edx
801048aa:	85 d2                	test   %edx,%edx
801048ac:	0f 84 76 ff ff ff    	je     80104828 <procdump+0x18>
        cprintf(" %p", pc[i]);
801048b2:	83 ec 08             	sub    $0x8,%esp
801048b5:	83 c7 04             	add    $0x4,%edi
801048b8:	52                   	push   %edx
801048b9:	68 c1 7f 10 80       	push   $0x80107fc1
801048be:	e8 9d bd ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801048c3:	83 c4 10             	add    $0x10,%esp
801048c6:	39 fe                	cmp    %edi,%esi
801048c8:	75 de                	jne    801048a8 <procdump+0x98>
801048ca:	e9 59 ff ff ff       	jmp    80104828 <procdump+0x18>
801048cf:	90                   	nop
  }
}
801048d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048d3:	5b                   	pop    %ebx
801048d4:	5e                   	pop    %esi
801048d5:	5f                   	pop    %edi
801048d6:	5d                   	pop    %ebp
801048d7:	c3                   	ret    
801048d8:	66 90                	xchg   %ax,%ax
801048da:	66 90                	xchg   %ax,%ax
801048dc:	66 90                	xchg   %ax,%ax
801048de:	66 90                	xchg   %ax,%ax

801048e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048ea:	68 c0 86 10 80       	push   $0x801086c0
801048ef:	8d 43 04             	lea    0x4(%ebx),%eax
801048f2:	50                   	push   %eax
801048f3:	e8 18 01 00 00       	call   80104a10 <initlock>
  lk->name = name;
801048f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104901:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104904:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010490b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010490e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104911:	c9                   	leave  
80104912:	c3                   	ret    
80104913:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	8d 73 04             	lea    0x4(%ebx),%esi
8010492e:	56                   	push   %esi
8010492f:	e8 1c 02 00 00       	call   80104b50 <acquire>
  while (lk->locked) {
80104934:	8b 13                	mov    (%ebx),%edx
80104936:	83 c4 10             	add    $0x10,%esp
80104939:	85 d2                	test   %edx,%edx
8010493b:	74 16                	je     80104953 <acquiresleep+0x33>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104940:	83 ec 08             	sub    $0x8,%esp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	e8 f6 fb ff ff       	call   80104540 <sleep>
  while (lk->locked) {
8010494a:	8b 03                	mov    (%ebx),%eax
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	85 c0                	test   %eax,%eax
80104951:	75 ed                	jne    80104940 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104953:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104959:	e8 d2 f4 ff ff       	call   80103e30 <myproc>
8010495e:	8b 40 10             	mov    0x10(%eax),%eax
80104961:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104964:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104967:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010496a:	5b                   	pop    %ebx
8010496b:	5e                   	pop    %esi
8010496c:	5d                   	pop    %ebp
  release(&lk->lk);
8010496d:	e9 9e 02 00 00       	jmp    80104c10 <release>
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 bc 01 00 00       	call   80104b50 <acquire>
  lk->locked = 0;
80104994:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010499a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049a1:	89 1c 24             	mov    %ebx,(%esp)
801049a4:	e8 87 fd ff ff       	call   80104730 <wakeup>
  release(&lk->lk);
801049a9:	89 75 08             	mov    %esi,0x8(%ebp)
801049ac:	83 c4 10             	add    $0x10,%esp
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
  release(&lk->lk);
801049b5:	e9 56 02 00 00       	jmp    80104c10 <release>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	53                   	push   %ebx
801049c6:	31 ff                	xor    %edi,%edi
801049c8:	83 ec 18             	sub    $0x18,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049ce:	8d 73 04             	lea    0x4(%ebx),%esi
801049d1:	56                   	push   %esi
801049d2:	e8 79 01 00 00       	call   80104b50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049d7:	8b 03                	mov    (%ebx),%eax
801049d9:	83 c4 10             	add    $0x10,%esp
801049dc:	85 c0                	test   %eax,%eax
801049de:	74 13                	je     801049f3 <holdingsleep+0x33>
801049e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049e3:	e8 48 f4 ff ff       	call   80103e30 <myproc>
801049e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049eb:	0f 94 c0             	sete   %al
801049ee:	0f b6 c0             	movzbl %al,%eax
801049f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	56                   	push   %esi
801049f7:	e8 14 02 00 00       	call   80104c10 <release>
  return r;
}
801049fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049ff:	89 f8                	mov    %edi,%eax
80104a01:	5b                   	pop    %ebx
80104a02:	5e                   	pop    %esi
80104a03:	5f                   	pop    %edi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
80104a06:	66 90                	xchg   %ax,%ax
80104a08:	66 90                	xchg   %ax,%ax
80104a0a:	66 90                	xchg   %ax,%ax
80104a0c:	66 90                	xchg   %ax,%ax
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a30:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a31:	31 d2                	xor    %edx,%edx
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a3c:	83 e8 08             	sub    $0x8,%eax
80104a3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a4c:	77 1a                	ja     80104a68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a54:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a57:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a59:	83 fa 0a             	cmp    $0xa,%edx
80104a5c:	75 e2                	jne    80104a40 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a5e:	5b                   	pop    %ebx
80104a5f:	5d                   	pop    %ebp
80104a60:	c3                   	ret    
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a6b:	83 c1 28             	add    $0x28,%ecx
80104a6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a76:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a79:	39 c1                	cmp    %eax,%ecx
80104a7b:	75 f3                	jne    80104a70 <getcallerpcs+0x40>
}
80104a7d:	5b                   	pop    %ebx
80104a7e:	5d                   	pop    %ebp
80104a7f:	c3                   	ret    

80104a80 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	9c                   	pushf  
80104a88:	5b                   	pop    %ebx
  asm volatile("cli");
80104a89:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a8a:	e8 01 f3 ff ff       	call   80103d90 <mycpu>
80104a8f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a95:	85 c0                	test   %eax,%eax
80104a97:	75 11                	jne    80104aaa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a99:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a9f:	e8 ec f2 ff ff       	call   80103d90 <mycpu>
80104aa4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104aaa:	e8 e1 f2 ff ff       	call   80103d90 <mycpu>
80104aaf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ab6:	83 c4 04             	add    $0x4,%esp
80104ab9:	5b                   	pop    %ebx
80104aba:	5d                   	pop    %ebp
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <popcli>:

void
popcli(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ac6:	9c                   	pushf  
80104ac7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ac8:	f6 c4 02             	test   $0x2,%ah
80104acb:	75 35                	jne    80104b02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104acd:	e8 be f2 ff ff       	call   80103d90 <mycpu>
80104ad2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ad9:	78 34                	js     80104b0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104adb:	e8 b0 f2 ff ff       	call   80103d90 <mycpu>
80104ae0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ae6:	85 d2                	test   %edx,%edx
80104ae8:	74 06                	je     80104af0 <popcli+0x30>
    sti();
}
80104aea:	c9                   	leave  
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104af0:	e8 9b f2 ff ff       	call   80103d90 <mycpu>
80104af5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104afb:	85 c0                	test   %eax,%eax
80104afd:	74 eb                	je     80104aea <popcli+0x2a>
  asm volatile("sti");
80104aff:	fb                   	sti    
}
80104b00:	c9                   	leave  
80104b01:	c3                   	ret    
    panic("popcli - interruptible");
80104b02:	83 ec 0c             	sub    $0xc,%esp
80104b05:	68 cb 86 10 80       	push   $0x801086cb
80104b0a:	e8 81 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	68 e2 86 10 80       	push   $0x801086e2
80104b17:	e8 74 b8 ff ff       	call   80100390 <panic>
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <holding>:
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 75 08             	mov    0x8(%ebp),%esi
80104b28:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b2a:	e8 51 ff ff ff       	call   80104a80 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b2f:	8b 06                	mov    (%esi),%eax
80104b31:	85 c0                	test   %eax,%eax
80104b33:	74 10                	je     80104b45 <holding+0x25>
80104b35:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b38:	e8 53 f2 ff ff       	call   80103d90 <mycpu>
80104b3d:	39 c3                	cmp    %eax,%ebx
80104b3f:	0f 94 c3             	sete   %bl
80104b42:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104b45:	e8 76 ff ff ff       	call   80104ac0 <popcli>
}
80104b4a:	89 d8                	mov    %ebx,%eax
80104b4c:	5b                   	pop    %ebx
80104b4d:	5e                   	pop    %esi
80104b4e:	5d                   	pop    %ebp
80104b4f:	c3                   	ret    

80104b50 <acquire>:
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b55:	e8 26 ff ff ff       	call   80104a80 <pushcli>
  if(holding(lk))
80104b5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b5d:	83 ec 0c             	sub    $0xc,%esp
80104b60:	53                   	push   %ebx
80104b61:	e8 ba ff ff ff       	call   80104b20 <holding>
80104b66:	83 c4 10             	add    $0x10,%esp
80104b69:	85 c0                	test   %eax,%eax
80104b6b:	0f 85 83 00 00 00    	jne    80104bf4 <acquire+0xa4>
80104b71:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b73:	ba 01 00 00 00       	mov    $0x1,%edx
80104b78:	eb 09                	jmp    80104b83 <acquire+0x33>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b83:	89 d0                	mov    %edx,%eax
80104b85:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b88:	85 c0                	test   %eax,%eax
80104b8a:	75 f4                	jne    80104b80 <acquire+0x30>
  __sync_synchronize();
80104b8c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b94:	e8 f7 f1 ff ff       	call   80103d90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b99:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104b9c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b9f:	89 e8                	mov    %ebp,%eax
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ba8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104bae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104bb4:	77 1a                	ja     80104bd0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104bb6:	8b 48 04             	mov    0x4(%eax),%ecx
80104bb9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104bbc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104bbf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bc1:	83 fe 0a             	cmp    $0xa,%esi
80104bc4:	75 e2                	jne    80104ba8 <acquire+0x58>
}
80104bc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5d                   	pop    %ebp
80104bcc:	c3                   	ret    
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104bd3:	83 c2 28             	add    $0x28,%edx
80104bd6:	8d 76 00             	lea    0x0(%esi),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104be6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104be9:	39 d0                	cmp    %edx,%eax
80104beb:	75 f3                	jne    80104be0 <acquire+0x90>
}
80104bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf0:	5b                   	pop    %ebx
80104bf1:	5e                   	pop    %esi
80104bf2:	5d                   	pop    %ebp
80104bf3:	c3                   	ret    
    panic("acquire");
80104bf4:	83 ec 0c             	sub    $0xc,%esp
80104bf7:	68 e9 86 10 80       	push   $0x801086e9
80104bfc:	e8 8f b7 ff ff       	call   80100390 <panic>
80104c01:	eb 0d                	jmp    80104c10 <release>
80104c03:	90                   	nop
80104c04:	90                   	nop
80104c05:	90                   	nop
80104c06:	90                   	nop
80104c07:	90                   	nop
80104c08:	90                   	nop
80104c09:	90                   	nop
80104c0a:	90                   	nop
80104c0b:	90                   	nop
80104c0c:	90                   	nop
80104c0d:	90                   	nop
80104c0e:	90                   	nop
80104c0f:	90                   	nop

80104c10 <release>:
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 10             	sub    $0x10,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c1a:	53                   	push   %ebx
80104c1b:	e8 00 ff ff ff       	call   80104b20 <holding>
80104c20:	83 c4 10             	add    $0x10,%esp
80104c23:	85 c0                	test   %eax,%eax
80104c25:	74 22                	je     80104c49 <release+0x39>
  lk->pcs[0] = 0;
80104c27:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c35:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c3a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c43:	c9                   	leave  
  popcli();
80104c44:	e9 77 fe ff ff       	jmp    80104ac0 <popcli>
    panic("release");
80104c49:	83 ec 0c             	sub    $0xc,%esp
80104c4c:	68 f1 86 10 80       	push   $0x801086f1
80104c51:	e8 3a b7 ff ff       	call   80100390 <panic>
80104c56:	66 90                	xchg   %ax,%ax
80104c58:	66 90                	xchg   %ax,%ax
80104c5a:	66 90                	xchg   %ax,%ax
80104c5c:	66 90                	xchg   %ax,%ax
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	53                   	push   %ebx
80104c65:	8b 55 08             	mov    0x8(%ebp),%edx
80104c68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c6b:	f6 c2 03             	test   $0x3,%dl
80104c6e:	75 05                	jne    80104c75 <memset+0x15>
80104c70:	f6 c1 03             	test   $0x3,%cl
80104c73:	74 13                	je     80104c88 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104c75:	89 d7                	mov    %edx,%edi
80104c77:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c7a:	fc                   	cld    
80104c7b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c7d:	5b                   	pop    %ebx
80104c7e:	89 d0                	mov    %edx,%eax
80104c80:	5f                   	pop    %edi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	90                   	nop
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104c88:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c8c:	c1 e9 02             	shr    $0x2,%ecx
80104c8f:	89 f8                	mov    %edi,%eax
80104c91:	89 fb                	mov    %edi,%ebx
80104c93:	c1 e0 18             	shl    $0x18,%eax
80104c96:	c1 e3 10             	shl    $0x10,%ebx
80104c99:	09 d8                	or     %ebx,%eax
80104c9b:	09 f8                	or     %edi,%eax
80104c9d:	c1 e7 08             	shl    $0x8,%edi
80104ca0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ca2:	89 d7                	mov    %edx,%edi
80104ca4:	fc                   	cld    
80104ca5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ca7:	5b                   	pop    %ebx
80104ca8:	89 d0                	mov    %edx,%eax
80104caa:	5f                   	pop    %edi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
80104cb5:	53                   	push   %ebx
80104cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cbf:	85 db                	test   %ebx,%ebx
80104cc1:	74 29                	je     80104cec <memcmp+0x3c>
    if(*s1 != *s2)
80104cc3:	0f b6 16             	movzbl (%esi),%edx
80104cc6:	0f b6 0f             	movzbl (%edi),%ecx
80104cc9:	38 d1                	cmp    %dl,%cl
80104ccb:	75 2b                	jne    80104cf8 <memcmp+0x48>
80104ccd:	b8 01 00 00 00       	mov    $0x1,%eax
80104cd2:	eb 14                	jmp    80104ce8 <memcmp+0x38>
80104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104cdc:	83 c0 01             	add    $0x1,%eax
80104cdf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ce4:	38 ca                	cmp    %cl,%dl
80104ce6:	75 10                	jne    80104cf8 <memcmp+0x48>
  while(n-- > 0){
80104ce8:	39 d8                	cmp    %ebx,%eax
80104cea:	75 ec                	jne    80104cd8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104cec:	5b                   	pop    %ebx
  return 0;
80104ced:	31 c0                	xor    %eax,%eax
}
80104cef:	5e                   	pop    %esi
80104cf0:	5f                   	pop    %edi
80104cf1:	5d                   	pop    %ebp
80104cf2:	c3                   	ret    
80104cf3:	90                   	nop
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104cf8:	0f b6 c2             	movzbl %dl,%eax
}
80104cfb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104cfc:	29 c8                	sub    %ecx,%eax
}
80104cfe:	5e                   	pop    %esi
80104cff:	5f                   	pop    %edi
80104d00:	5d                   	pop    %ebp
80104d01:	c3                   	ret    
80104d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	8b 45 08             	mov    0x8(%ebp),%eax
80104d18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d1b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d1e:	39 c3                	cmp    %eax,%ebx
80104d20:	73 26                	jae    80104d48 <memmove+0x38>
80104d22:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d25:	39 c8                	cmp    %ecx,%eax
80104d27:	73 1f                	jae    80104d48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d29:	85 f6                	test   %esi,%esi
80104d2b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d2e:	74 0f                	je     80104d3f <memmove+0x2f>
      *--d = *--s;
80104d30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d37:	83 ea 01             	sub    $0x1,%edx
80104d3a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d3d:	75 f1                	jne    80104d30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d3f:	5b                   	pop    %ebx
80104d40:	5e                   	pop    %esi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	90                   	nop
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d48:	31 d2                	xor    %edx,%edx
80104d4a:	85 f6                	test   %esi,%esi
80104d4c:	74 f1                	je     80104d3f <memmove+0x2f>
80104d4e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d57:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d5a:	39 d6                	cmp    %edx,%esi
80104d5c:	75 f2                	jne    80104d50 <memmove+0x40>
}
80104d5e:	5b                   	pop    %ebx
80104d5f:	5e                   	pop    %esi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d73:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104d74:	eb 9a                	jmp    80104d10 <memmove>
80104d76:	8d 76 00             	lea    0x0(%esi),%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	8b 7d 10             	mov    0x10(%ebp),%edi
80104d88:	53                   	push   %ebx
80104d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d8f:	85 ff                	test   %edi,%edi
80104d91:	74 2f                	je     80104dc2 <strncmp+0x42>
80104d93:	0f b6 01             	movzbl (%ecx),%eax
80104d96:	0f b6 1e             	movzbl (%esi),%ebx
80104d99:	84 c0                	test   %al,%al
80104d9b:	74 37                	je     80104dd4 <strncmp+0x54>
80104d9d:	38 c3                	cmp    %al,%bl
80104d9f:	75 33                	jne    80104dd4 <strncmp+0x54>
80104da1:	01 f7                	add    %esi,%edi
80104da3:	eb 13                	jmp    80104db8 <strncmp+0x38>
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
80104da8:	0f b6 01             	movzbl (%ecx),%eax
80104dab:	84 c0                	test   %al,%al
80104dad:	74 21                	je     80104dd0 <strncmp+0x50>
80104daf:	0f b6 1a             	movzbl (%edx),%ebx
80104db2:	89 d6                	mov    %edx,%esi
80104db4:	38 d8                	cmp    %bl,%al
80104db6:	75 1c                	jne    80104dd4 <strncmp+0x54>
    n--, p++, q++;
80104db8:	8d 56 01             	lea    0x1(%esi),%edx
80104dbb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dbe:	39 fa                	cmp    %edi,%edx
80104dc0:	75 e6                	jne    80104da8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104dc2:	5b                   	pop    %ebx
    return 0;
80104dc3:	31 c0                	xor    %eax,%eax
}
80104dc5:	5e                   	pop    %esi
80104dc6:	5f                   	pop    %edi
80104dc7:	5d                   	pop    %ebp
80104dc8:	c3                   	ret    
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104dd4:	29 d8                	sub    %ebx,%eax
}
80104dd6:	5b                   	pop    %ebx
80104dd7:	5e                   	pop    %esi
80104dd8:	5f                   	pop    %edi
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	90                   	nop
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 45 08             	mov    0x8(%ebp),%eax
80104de8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104deb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104dee:	89 c2                	mov    %eax,%edx
80104df0:	eb 19                	jmp    80104e0b <strncpy+0x2b>
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df8:	83 c3 01             	add    $0x1,%ebx
80104dfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104dff:	83 c2 01             	add    $0x1,%edx
80104e02:	84 c9                	test   %cl,%cl
80104e04:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e07:	74 09                	je     80104e12 <strncpy+0x32>
80104e09:	89 f1                	mov    %esi,%ecx
80104e0b:	85 c9                	test   %ecx,%ecx
80104e0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e10:	7f e6                	jg     80104df8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e12:	31 c9                	xor    %ecx,%ecx
80104e14:	85 f6                	test   %esi,%esi
80104e16:	7e 17                	jle    80104e2f <strncpy+0x4f>
80104e18:	90                   	nop
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e24:	89 f3                	mov    %esi,%ebx
80104e26:	83 c1 01             	add    $0x1,%ecx
80104e29:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e2b:	85 db                	test   %ebx,%ebx
80104e2d:	7f f1                	jg     80104e20 <strncpy+0x40>
  return os;
}
80104e2f:	5b                   	pop    %ebx
80104e30:	5e                   	pop    %esi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e48:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e4e:	85 c9                	test   %ecx,%ecx
80104e50:	7e 26                	jle    80104e78 <safestrcpy+0x38>
80104e52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e56:	89 c1                	mov    %eax,%ecx
80104e58:	eb 17                	jmp    80104e71 <safestrcpy+0x31>
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e60:	83 c2 01             	add    $0x1,%edx
80104e63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e67:	83 c1 01             	add    $0x1,%ecx
80104e6a:	84 db                	test   %bl,%bl
80104e6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e6f:	74 04                	je     80104e75 <safestrcpy+0x35>
80104e71:	39 f2                	cmp    %esi,%edx
80104e73:	75 eb                	jne    80104e60 <safestrcpy+0x20>
    ;
  *s = 0;
80104e75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e78:	5b                   	pop    %ebx
80104e79:	5e                   	pop    %esi
80104e7a:	5d                   	pop    %ebp
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <strlen>:

int
strlen(const char *s)
{
80104e80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e88:	80 3a 00             	cmpb   $0x0,(%edx)
80104e8b:	74 0c                	je     80104e99 <strlen+0x19>
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
80104e90:	83 c0 01             	add    $0x1,%eax
80104e93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e97:	75 f7                	jne    80104e90 <strlen+0x10>
    ;
  return n;
}
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    

80104e9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ea3:	55                   	push   %ebp
  pushl %ebx
80104ea4:	53                   	push   %ebx
  pushl %esi
80104ea5:	56                   	push   %esi
  pushl %edi
80104ea6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ea7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ea9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104eab:	5f                   	pop    %edi
  popl %esi
80104eac:	5e                   	pop    %esi
  popl %ebx
80104ead:	5b                   	pop    %ebx
  popl %ebp
80104eae:	5d                   	pop    %ebp
  ret
80104eaf:	c3                   	ret    

80104eb0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	53                   	push   %ebx
80104eb4:	83 ec 04             	sub    $0x4,%esp
80104eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104eba:	e8 71 ef ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ebf:	8b 00                	mov    (%eax),%eax
80104ec1:	39 d8                	cmp    %ebx,%eax
80104ec3:	76 1b                	jbe    80104ee0 <fetchint+0x30>
80104ec5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ec8:	39 d0                	cmp    %edx,%eax
80104eca:	72 14                	jb     80104ee0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ecf:	8b 13                	mov    (%ebx),%edx
80104ed1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ed3:	31 c0                	xor    %eax,%eax
}
80104ed5:	83 c4 04             	add    $0x4,%esp
80104ed8:	5b                   	pop    %ebx
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    
80104edb:	90                   	nop
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb ee                	jmp    80104ed5 <fetchint+0x25>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104efa:	e8 31 ef ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
80104eff:	39 18                	cmp    %ebx,(%eax)
80104f01:	76 29                	jbe    80104f2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f06:	89 da                	mov    %ebx,%edx
80104f08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f0c:	39 c3                	cmp    %eax,%ebx
80104f0e:	73 1c                	jae    80104f2c <fetchstr+0x3c>
    if(*s == 0)
80104f10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f13:	75 10                	jne    80104f25 <fetchstr+0x35>
80104f15:	eb 39                	jmp    80104f50 <fetchstr+0x60>
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f20:	80 3a 00             	cmpb   $0x0,(%edx)
80104f23:	74 1b                	je     80104f40 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f25:	83 c2 01             	add    $0x1,%edx
80104f28:	39 d0                	cmp    %edx,%eax
80104f2a:	77 f4                	ja     80104f20 <fetchstr+0x30>
    return -1;
80104f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f31:	83 c4 04             	add    $0x4,%esp
80104f34:	5b                   	pop    %ebx
80104f35:	5d                   	pop    %ebp
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f40:	83 c4 04             	add    $0x4,%esp
80104f43:	89 d0                	mov    %edx,%eax
80104f45:	29 d8                	sub    %ebx,%eax
80104f47:	5b                   	pop    %ebx
80104f48:	5d                   	pop    %ebp
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f50:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f52:	eb dd                	jmp    80104f31 <fetchstr+0x41>
80104f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f65:	e8 c6 ee ff ff       	call   80103e30 <myproc>
80104f6a:	8b 40 18             	mov    0x18(%eax),%eax
80104f6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f70:	8b 40 44             	mov    0x44(%eax),%eax
80104f73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f76:	e8 b5 ee ff ff       	call   80103e30 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f7b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f7d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f80:	39 c6                	cmp    %eax,%esi
80104f82:	73 1c                	jae    80104fa0 <argint+0x40>
80104f84:	8d 53 08             	lea    0x8(%ebx),%edx
80104f87:	39 d0                	cmp    %edx,%eax
80104f89:	72 15                	jb     80104fa0 <argint+0x40>
  *ip = *(int*)(addr);
80104f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f91:	89 10                	mov    %edx,(%eax)
  return 0;
80104f93:	31 c0                	xor    %eax,%eax
}
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret    
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	eb ee                	jmp    80104f95 <argint+0x35>
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	83 ec 10             	sub    $0x10,%esp
80104fb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104fbb:	e8 70 ee ff ff       	call   80103e30 <myproc>
80104fc0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104fc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fc5:	83 ec 08             	sub    $0x8,%esp
80104fc8:	50                   	push   %eax
80104fc9:	ff 75 08             	pushl  0x8(%ebp)
80104fcc:	e8 8f ff ff ff       	call   80104f60 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	78 28                	js     80105000 <argptr+0x50>
80104fd8:	85 db                	test   %ebx,%ebx
80104fda:	78 24                	js     80105000 <argptr+0x50>
80104fdc:	8b 16                	mov    (%esi),%edx
80104fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe1:	39 c2                	cmp    %eax,%edx
80104fe3:	76 1b                	jbe    80105000 <argptr+0x50>
80104fe5:	01 c3                	add    %eax,%ebx
80104fe7:	39 da                	cmp    %ebx,%edx
80104fe9:	72 15                	jb     80105000 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104feb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fee:	89 02                	mov    %eax,(%edx)
  return 0;
80104ff0:	31 c0                	xor    %eax,%eax
}
80104ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb eb                	jmp    80104ff2 <argptr+0x42>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105016:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105019:	50                   	push   %eax
8010501a:	ff 75 08             	pushl  0x8(%ebp)
8010501d:	e8 3e ff ff ff       	call   80104f60 <argint>
80105022:	83 c4 10             	add    $0x10,%esp
80105025:	85 c0                	test   %eax,%eax
80105027:	78 17                	js     80105040 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105029:	83 ec 08             	sub    $0x8,%esp
8010502c:	ff 75 0c             	pushl  0xc(%ebp)
8010502f:	ff 75 f4             	pushl  -0xc(%ebp)
80105032:	e8 b9 fe ff ff       	call   80104ef0 <fetchstr>
80105037:	83 c4 10             	add    $0x10,%esp
}
8010503a:	c9                   	leave  
8010503b:	c3                   	ret    
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105057:	e8 d4 ed ff ff       	call   80103e30 <myproc>
8010505c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010505e:	8b 40 18             	mov    0x18(%eax),%eax
80105061:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105064:	8d 50 ff             	lea    -0x1(%eax),%edx
80105067:	83 fa 14             	cmp    $0x14,%edx
8010506a:	77 1c                	ja     80105088 <syscall+0x38>
8010506c:	8b 14 85 20 87 10 80 	mov    -0x7fef78e0(,%eax,4),%edx
80105073:	85 d2                	test   %edx,%edx
80105075:	74 11                	je     80105088 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105077:	ff d2                	call   *%edx
80105079:	8b 53 18             	mov    0x18(%ebx),%edx
8010507c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010507f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105082:	c9                   	leave  
80105083:	c3                   	ret    
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105088:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105089:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010508c:	50                   	push   %eax
8010508d:	ff 73 10             	pushl  0x10(%ebx)
80105090:	68 f9 86 10 80       	push   $0x801086f9
80105095:	e8 c6 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010509a:	8b 43 18             	mov    0x18(%ebx),%eax
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050aa:	c9                   	leave  
801050ab:	c3                   	ret    
801050ac:	66 90                	xchg   %ax,%ax
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
801050b5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050ba:	89 d6                	mov    %edx,%esi
801050bc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050bf:	50                   	push   %eax
801050c0:	6a 00                	push   $0x0
801050c2:	e8 99 fe ff ff       	call   80104f60 <argint>
801050c7:	83 c4 10             	add    $0x10,%esp
801050ca:	85 c0                	test   %eax,%eax
801050cc:	78 2a                	js     801050f8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050d2:	77 24                	ja     801050f8 <argfd.constprop.0+0x48>
801050d4:	e8 57 ed ff ff       	call   80103e30 <myproc>
801050d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050dc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050e0:	85 c0                	test   %eax,%eax
801050e2:	74 14                	je     801050f8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801050e4:	85 db                	test   %ebx,%ebx
801050e6:	74 02                	je     801050ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801050e8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801050ea:	89 06                	mov    %eax,(%esi)
  return 0;
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret    
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <argfd.constprop.0+0x3e>
801050ff:	90                   	nop

80105100 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105100:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105101:	31 c0                	xor    %eax,%eax
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	56                   	push   %esi
80105106:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105107:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010510a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010510d:	e8 9e ff ff ff       	call   801050b0 <argfd.constprop.0>
80105112:	85 c0                	test   %eax,%eax
80105114:	78 42                	js     80105158 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105116:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105119:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010511b:	e8 10 ed ff ff       	call   80103e30 <myproc>
80105120:	eb 0e                	jmp    80105130 <sys_dup+0x30>
80105122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	74 28                	je     80105158 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105130:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105134:	85 d2                	test   %edx,%edx
80105136:	75 f0                	jne    80105128 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105138:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	ff 75 f4             	pushl  -0xc(%ebp)
80105142:	e8 e9 bc ff ff       	call   80100e30 <filedup>
  return fd;
80105147:	83 c4 10             	add    $0x10,%esp
}
8010514a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010514d:	89 d8                	mov    %ebx,%eax
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	90                   	nop
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105158:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010515b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105160:	89 d8                	mov    %ebx,%eax
80105162:	5b                   	pop    %ebx
80105163:	5e                   	pop    %esi
80105164:	5d                   	pop    %ebp
80105165:	c3                   	ret    
80105166:	8d 76 00             	lea    0x0(%esi),%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <sys_read>:

int
sys_read(void)
{
80105170:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105171:	31 c0                	xor    %eax,%eax
{
80105173:	89 e5                	mov    %esp,%ebp
80105175:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105178:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010517b:	e8 30 ff ff ff       	call   801050b0 <argfd.constprop.0>
80105180:	85 c0                	test   %eax,%eax
80105182:	78 4c                	js     801051d0 <sys_read+0x60>
80105184:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	50                   	push   %eax
8010518b:	6a 02                	push   $0x2
8010518d:	e8 ce fd ff ff       	call   80104f60 <argint>
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	85 c0                	test   %eax,%eax
80105197:	78 37                	js     801051d0 <sys_read+0x60>
80105199:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010519c:	83 ec 04             	sub    $0x4,%esp
8010519f:	ff 75 f0             	pushl  -0x10(%ebp)
801051a2:	50                   	push   %eax
801051a3:	6a 01                	push   $0x1
801051a5:	e8 06 fe ff ff       	call   80104fb0 <argptr>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	85 c0                	test   %eax,%eax
801051af:	78 1f                	js     801051d0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801051b1:	83 ec 04             	sub    $0x4,%esp
801051b4:	ff 75 f0             	pushl  -0x10(%ebp)
801051b7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ba:	ff 75 ec             	pushl  -0x14(%ebp)
801051bd:	e8 de bd ff ff       	call   80100fa0 <fileread>
801051c2:	83 c4 10             	add    $0x10,%esp
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <sys_write>:

int
sys_write(void)
{
801051e0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e1:	31 c0                	xor    %eax,%eax
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051eb:	e8 c0 fe ff ff       	call   801050b0 <argfd.constprop.0>
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 4c                	js     80105240 <sys_write+0x60>
801051f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f7:	83 ec 08             	sub    $0x8,%esp
801051fa:	50                   	push   %eax
801051fb:	6a 02                	push   $0x2
801051fd:	e8 5e fd ff ff       	call   80104f60 <argint>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	78 37                	js     80105240 <sys_write+0x60>
80105209:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520c:	83 ec 04             	sub    $0x4,%esp
8010520f:	ff 75 f0             	pushl  -0x10(%ebp)
80105212:	50                   	push   %eax
80105213:	6a 01                	push   $0x1
80105215:	e8 96 fd ff ff       	call   80104fb0 <argptr>
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	85 c0                	test   %eax,%eax
8010521f:	78 1f                	js     80105240 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105221:	83 ec 04             	sub    $0x4,%esp
80105224:	ff 75 f0             	pushl  -0x10(%ebp)
80105227:	ff 75 f4             	pushl  -0xc(%ebp)
8010522a:	ff 75 ec             	pushl  -0x14(%ebp)
8010522d:	e8 fe bd ff ff       	call   80101030 <filewrite>
80105232:	83 c4 10             	add    $0x10,%esp
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_close>:

int
sys_close(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105256:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105259:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010525c:	e8 4f fe ff ff       	call   801050b0 <argfd.constprop.0>
80105261:	85 c0                	test   %eax,%eax
80105263:	78 2b                	js     80105290 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105265:	e8 c6 eb ff ff       	call   80103e30 <myproc>
8010526a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010526d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105270:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105277:	00 
  fileclose(f);
80105278:	ff 75 f4             	pushl  -0xc(%ebp)
8010527b:	e8 00 bc ff ff       	call   80100e80 <fileclose>
  return 0;
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	31 c0                	xor    %eax,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <sys_fstat>:

int
sys_fstat(void)
{
801052a0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052a1:	31 c0                	xor    %eax,%eax
{
801052a3:	89 e5                	mov    %esp,%ebp
801052a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052ab:	e8 00 fe ff ff       	call   801050b0 <argfd.constprop.0>
801052b0:	85 c0                	test   %eax,%eax
801052b2:	78 2c                	js     801052e0 <sys_fstat+0x40>
801052b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b7:	83 ec 04             	sub    $0x4,%esp
801052ba:	6a 14                	push   $0x14
801052bc:	50                   	push   %eax
801052bd:	6a 01                	push   $0x1
801052bf:	e8 ec fc ff ff       	call   80104fb0 <argptr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	78 15                	js     801052e0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801052cb:	83 ec 08             	sub    $0x8,%esp
801052ce:	ff 75 f4             	pushl  -0xc(%ebp)
801052d1:	ff 75 f0             	pushl  -0x10(%ebp)
801052d4:	e8 77 bc ff ff       	call   80100f50 <filestat>
801052d9:	83 c4 10             	add    $0x10,%esp
}
801052dc:	c9                   	leave  
801052dd:	c3                   	ret    
801052de:	66 90                	xchg   %ax,%ax
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052fc:	50                   	push   %eax
801052fd:	6a 00                	push   $0x0
801052ff:	e8 0c fd ff ff       	call   80105010 <argstr>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	0f 88 fb 00 00 00    	js     8010540a <sys_link+0x11a>
8010530f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105312:	83 ec 08             	sub    $0x8,%esp
80105315:	50                   	push   %eax
80105316:	6a 01                	push   $0x1
80105318:	e8 f3 fc ff ff       	call   80105010 <argstr>
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	85 c0                	test   %eax,%eax
80105322:	0f 88 e2 00 00 00    	js     8010540a <sys_link+0x11a>
    return -1;

  begin_op();
80105328:	e8 73 de ff ff       	call   801031a0 <begin_op>
  if((ip = namei(old)) == 0){
8010532d:	83 ec 0c             	sub    $0xc,%esp
80105330:	ff 75 d4             	pushl  -0x2c(%ebp)
80105333:	e8 e8 cb ff ff       	call   80101f20 <namei>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	0f 84 ea 00 00 00    	je     8010542f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105345:	83 ec 0c             	sub    $0xc,%esp
80105348:	50                   	push   %eax
80105349:	e8 72 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105356:	0f 84 bb 00 00 00    	je     80105417 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010535c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105361:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105364:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105367:	53                   	push   %ebx
80105368:	e8 a3 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010536d:	89 1c 24             	mov    %ebx,(%esp)
80105370:	e8 2b c4 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105375:	58                   	pop    %eax
80105376:	5a                   	pop    %edx
80105377:	57                   	push   %edi
80105378:	ff 75 d0             	pushl  -0x30(%ebp)
8010537b:	e8 c0 cb ff ff       	call   80101f40 <nameiparent>
80105380:	83 c4 10             	add    $0x10,%esp
80105383:	85 c0                	test   %eax,%eax
80105385:	89 c6                	mov    %eax,%esi
80105387:	74 5b                	je     801053e4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105389:	83 ec 0c             	sub    $0xc,%esp
8010538c:	50                   	push   %eax
8010538d:	e8 2e c3 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	8b 03                	mov    (%ebx),%eax
80105397:	39 06                	cmp    %eax,(%esi)
80105399:	75 3d                	jne    801053d8 <sys_link+0xe8>
8010539b:	83 ec 04             	sub    $0x4,%esp
8010539e:	ff 73 04             	pushl  0x4(%ebx)
801053a1:	57                   	push   %edi
801053a2:	56                   	push   %esi
801053a3:	e8 b8 ca ff ff       	call   80101e60 <dirlink>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	85 c0                	test   %eax,%eax
801053ad:	78 29                	js     801053d8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801053af:	83 ec 0c             	sub    $0xc,%esp
801053b2:	56                   	push   %esi
801053b3:	e8 98 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
801053b8:	89 1c 24             	mov    %ebx,(%esp)
801053bb:	e8 30 c4 ff ff       	call   801017f0 <iput>

  end_op();
801053c0:	e8 4b de ff ff       	call   80103210 <end_op>

  return 0;
801053c5:	83 c4 10             	add    $0x10,%esp
801053c8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801053ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053cd:	5b                   	pop    %ebx
801053ce:	5e                   	pop    %esi
801053cf:	5f                   	pop    %edi
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    
801053d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053d8:	83 ec 0c             	sub    $0xc,%esp
801053db:	56                   	push   %esi
801053dc:	e8 6f c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
801053e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	53                   	push   %ebx
801053e8:	e8 d3 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801053ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053f2:	89 1c 24             	mov    %ebx,(%esp)
801053f5:	e8 16 c2 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801053fa:	89 1c 24             	mov    %ebx,(%esp)
801053fd:	e8 4e c5 ff ff       	call   80101950 <iunlockput>
  end_op();
80105402:	e8 09 de ff ff       	call   80103210 <end_op>
  return -1;
80105407:	83 c4 10             	add    $0x10,%esp
}
8010540a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010540d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105412:	5b                   	pop    %ebx
80105413:	5e                   	pop    %esi
80105414:	5f                   	pop    %edi
80105415:	5d                   	pop    %ebp
80105416:	c3                   	ret    
    iunlockput(ip);
80105417:	83 ec 0c             	sub    $0xc,%esp
8010541a:	53                   	push   %ebx
8010541b:	e8 30 c5 ff ff       	call   80101950 <iunlockput>
    end_op();
80105420:	e8 eb dd ff ff       	call   80103210 <end_op>
    return -1;
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542d:	eb 9b                	jmp    801053ca <sys_link+0xda>
    end_op();
8010542f:	e8 dc dd ff ff       	call   80103210 <end_op>
    return -1;
80105434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105439:	eb 8f                	jmp    801053ca <sys_link+0xda>
8010543b:	90                   	nop
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
80105446:	83 ec 1c             	sub    $0x1c,%esp
80105449:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010544c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105450:	76 3e                	jbe    80105490 <isdirempty+0x50>
80105452:	bb 20 00 00 00       	mov    $0x20,%ebx
80105457:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010545a:	eb 0c                	jmp    80105468 <isdirempty+0x28>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105460:	83 c3 10             	add    $0x10,%ebx
80105463:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105466:	73 28                	jae    80105490 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105468:	6a 10                	push   $0x10
8010546a:	53                   	push   %ebx
8010546b:	57                   	push   %edi
8010546c:	56                   	push   %esi
8010546d:	e8 2e c5 ff ff       	call   801019a0 <readi>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	75 23                	jne    8010549d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010547a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010547f:	74 df                	je     80105460 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105481:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105484:	31 c0                	xor    %eax,%eax
}
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105493:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105498:	5b                   	pop    %ebx
80105499:	5e                   	pop    %esi
8010549a:	5f                   	pop    %edi
8010549b:	5d                   	pop    %ebp
8010549c:	c3                   	ret    
      panic("isdirempty: readi");
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	68 78 87 10 80       	push   $0x80108778
801054a5:	e8 e6 ae ff ff       	call   80100390 <panic>
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054b0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
801054b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801054bc:	50                   	push   %eax
801054bd:	6a 00                	push   $0x0
801054bf:	e8 4c fb ff ff       	call   80105010 <argstr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	0f 88 51 01 00 00    	js     80105620 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801054cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801054d2:	e8 c9 dc ff ff       	call   801031a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054d7:	83 ec 08             	sub    $0x8,%esp
801054da:	53                   	push   %ebx
801054db:	ff 75 c0             	pushl  -0x40(%ebp)
801054de:	e8 5d ca ff ff       	call   80101f40 <nameiparent>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	89 c6                	mov    %eax,%esi
801054ea:	0f 84 37 01 00 00    	je     80105627 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	50                   	push   %eax
801054f4:	e8 c7 c1 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054f9:	58                   	pop    %eax
801054fa:	5a                   	pop    %edx
801054fb:	68 fd 80 10 80       	push   $0x801080fd
80105500:	53                   	push   %ebx
80105501:	e8 ca c6 ff ff       	call   80101bd0 <namecmp>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	0f 84 d7 00 00 00    	je     801055e8 <sys_unlink+0x138>
80105511:	83 ec 08             	sub    $0x8,%esp
80105514:	68 fc 80 10 80       	push   $0x801080fc
80105519:	53                   	push   %ebx
8010551a:	e8 b1 c6 ff ff       	call   80101bd0 <namecmp>
8010551f:	83 c4 10             	add    $0x10,%esp
80105522:	85 c0                	test   %eax,%eax
80105524:	0f 84 be 00 00 00    	je     801055e8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010552a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010552d:	83 ec 04             	sub    $0x4,%esp
80105530:	50                   	push   %eax
80105531:	53                   	push   %ebx
80105532:	56                   	push   %esi
80105533:	e8 b8 c6 ff ff       	call   80101bf0 <dirlookup>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	89 c3                	mov    %eax,%ebx
8010553f:	0f 84 a3 00 00 00    	je     801055e8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105545:	83 ec 0c             	sub    $0xc,%esp
80105548:	50                   	push   %eax
80105549:	e8 72 c1 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105556:	0f 8e e4 00 00 00    	jle    80105640 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010555c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105561:	74 65                	je     801055c8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105563:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105566:	83 ec 04             	sub    $0x4,%esp
80105569:	6a 10                	push   $0x10
8010556b:	6a 00                	push   $0x0
8010556d:	57                   	push   %edi
8010556e:	e8 ed f6 ff ff       	call   80104c60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105573:	6a 10                	push   $0x10
80105575:	ff 75 c4             	pushl  -0x3c(%ebp)
80105578:	57                   	push   %edi
80105579:	56                   	push   %esi
8010557a:	e8 21 c5 ff ff       	call   80101aa0 <writei>
8010557f:	83 c4 20             	add    $0x20,%esp
80105582:	83 f8 10             	cmp    $0x10,%eax
80105585:	0f 85 a8 00 00 00    	jne    80105633 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010558b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105590:	74 6e                	je     80105600 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	56                   	push   %esi
80105596:	e8 b5 c3 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
8010559b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a0:	89 1c 24             	mov    %ebx,(%esp)
801055a3:	e8 68 c0 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801055a8:	89 1c 24             	mov    %ebx,(%esp)
801055ab:	e8 a0 c3 ff ff       	call   80101950 <iunlockput>

  end_op();
801055b0:	e8 5b dc ff ff       	call   80103210 <end_op>

  return 0;
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801055ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055bd:	5b                   	pop    %ebx
801055be:	5e                   	pop    %esi
801055bf:	5f                   	pop    %edi
801055c0:	5d                   	pop    %ebp
801055c1:	c3                   	ret    
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	53                   	push   %ebx
801055cc:	e8 6f fe ff ff       	call   80105440 <isdirempty>
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	75 8b                	jne    80105563 <sys_unlink+0xb3>
    iunlockput(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	53                   	push   %ebx
801055dc:	e8 6f c3 ff ff       	call   80101950 <iunlockput>
    goto bad;
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801055e8:	83 ec 0c             	sub    $0xc,%esp
801055eb:	56                   	push   %esi
801055ec:	e8 5f c3 ff ff       	call   80101950 <iunlockput>
  end_op();
801055f1:	e8 1a dc ff ff       	call   80103210 <end_op>
  return -1;
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fe:	eb ba                	jmp    801055ba <sys_unlink+0x10a>
    dp->nlink--;
80105600:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	56                   	push   %esi
80105609:	e8 02 c0 ff ff       	call   80101610 <iupdate>
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	e9 7c ff ff ff       	jmp    80105592 <sys_unlink+0xe2>
80105616:	8d 76 00             	lea    0x0(%esi),%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb 93                	jmp    801055ba <sys_unlink+0x10a>
    end_op();
80105627:	e8 e4 db ff ff       	call   80103210 <end_op>
    return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 87                	jmp    801055ba <sys_unlink+0x10a>
    panic("unlink: writei");
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	68 11 81 10 80       	push   $0x80108111
8010563b:	e8 50 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 ff 80 10 80       	push   $0x801080ff
80105648:	e8 43 ad ff ff       	call   80100390 <panic>
8010564d:	8d 76 00             	lea    0x0(%esi),%esi

80105650 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
80105655:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105656:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105659:	83 ec 34             	sub    $0x34,%esp
8010565c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565f:	8b 55 10             	mov    0x10(%ebp),%edx
80105662:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105665:	56                   	push   %esi
80105666:	ff 75 08             	pushl  0x8(%ebp)
{
80105669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010566c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010566f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105672:	e8 c9 c8 ff ff       	call   80101f40 <nameiparent>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	0f 84 4e 01 00 00    	je     801057d0 <create+0x180>
    return 0;
  ilock(dp);
80105682:	83 ec 0c             	sub    $0xc,%esp
80105685:	89 c3                	mov    %eax,%ebx
80105687:	50                   	push   %eax
80105688:	e8 33 c0 ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010568d:	83 c4 0c             	add    $0xc,%esp
80105690:	6a 00                	push   $0x0
80105692:	56                   	push   %esi
80105693:	53                   	push   %ebx
80105694:	e8 57 c5 ff ff       	call   80101bf0 <dirlookup>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	89 c7                	mov    %eax,%edi
801056a0:	74 3e                	je     801056e0 <create+0x90>
    iunlockput(dp);
801056a2:	83 ec 0c             	sub    $0xc,%esp
801056a5:	53                   	push   %ebx
801056a6:	e8 a5 c2 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
801056ab:	89 3c 24             	mov    %edi,(%esp)
801056ae:	e8 0d c0 ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056bb:	0f 85 9f 00 00 00    	jne    80105760 <create+0x110>
801056c1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801056c6:	0f 85 94 00 00 00    	jne    80105760 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056cf:	89 f8                	mov    %edi,%eax
801056d1:	5b                   	pop    %ebx
801056d2:	5e                   	pop    %esi
801056d3:	5f                   	pop    %edi
801056d4:	5d                   	pop    %ebp
801056d5:	c3                   	ret    
801056d6:	8d 76 00             	lea    0x0(%esi),%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
801056e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	50                   	push   %eax
801056e8:	ff 33                	pushl  (%ebx)
801056ea:	e8 61 be ff ff       	call   80101550 <ialloc>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	89 c7                	mov    %eax,%edi
801056f6:	0f 84 e8 00 00 00    	je     801057e4 <create+0x194>
  ilock(ip);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	50                   	push   %eax
80105700:	e8 bb bf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105705:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105709:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010570d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105711:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105715:	b8 01 00 00 00       	mov    $0x1,%eax
8010571a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010571e:	89 3c 24             	mov    %edi,(%esp)
80105721:	e8 ea be ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010572e:	74 50                	je     80105780 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105730:	83 ec 04             	sub    $0x4,%esp
80105733:	ff 77 04             	pushl  0x4(%edi)
80105736:	56                   	push   %esi
80105737:	53                   	push   %ebx
80105738:	e8 23 c7 ff ff       	call   80101e60 <dirlink>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	0f 88 8f 00 00 00    	js     801057d7 <create+0x187>
  iunlockput(dp);
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	53                   	push   %ebx
8010574c:	e8 ff c1 ff ff       	call   80101950 <iunlockput>
  return ip;
80105751:	83 c4 10             	add    $0x10,%esp
}
80105754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105757:	89 f8                	mov    %edi,%eax
80105759:	5b                   	pop    %ebx
8010575a:	5e                   	pop    %esi
8010575b:	5f                   	pop    %edi
8010575c:	5d                   	pop    %ebp
8010575d:	c3                   	ret    
8010575e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	57                   	push   %edi
    return 0;
80105764:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105766:	e8 e5 c1 ff ff       	call   80101950 <iunlockput>
    return 0;
8010576b:	83 c4 10             	add    $0x10,%esp
}
8010576e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105771:	89 f8                	mov    %edi,%eax
80105773:	5b                   	pop    %ebx
80105774:	5e                   	pop    %esi
80105775:	5f                   	pop    %edi
80105776:	5d                   	pop    %ebp
80105777:	c3                   	ret    
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105780:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	53                   	push   %ebx
80105789:	e8 82 be ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010578e:	83 c4 0c             	add    $0xc,%esp
80105791:	ff 77 04             	pushl  0x4(%edi)
80105794:	68 fd 80 10 80       	push   $0x801080fd
80105799:	57                   	push   %edi
8010579a:	e8 c1 c6 ff ff       	call   80101e60 <dirlink>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 1c                	js     801057c2 <create+0x172>
801057a6:	83 ec 04             	sub    $0x4,%esp
801057a9:	ff 73 04             	pushl  0x4(%ebx)
801057ac:	68 fc 80 10 80       	push   $0x801080fc
801057b1:	57                   	push   %edi
801057b2:	e8 a9 c6 ff ff       	call   80101e60 <dirlink>
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	85 c0                	test   %eax,%eax
801057bc:	0f 89 6e ff ff ff    	jns    80105730 <create+0xe0>
      panic("create dots");
801057c2:	83 ec 0c             	sub    $0xc,%esp
801057c5:	68 99 87 10 80       	push   $0x80108799
801057ca:	e8 c1 ab ff ff       	call   80100390 <panic>
801057cf:	90                   	nop
    return 0;
801057d0:	31 ff                	xor    %edi,%edi
801057d2:	e9 f5 fe ff ff       	jmp    801056cc <create+0x7c>
    panic("create: dirlink");
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	68 a5 87 10 80       	push   $0x801087a5
801057df:	e8 ac ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	68 8a 87 10 80       	push   $0x8010878a
801057ec:	e8 9f ab ff ff       	call   80100390 <panic>
801057f1:	eb 0d                	jmp    80105800 <sys_open>
801057f3:	90                   	nop
801057f4:	90                   	nop
801057f5:	90                   	nop
801057f6:	90                   	nop
801057f7:	90                   	nop
801057f8:	90                   	nop
801057f9:	90                   	nop
801057fa:	90                   	nop
801057fb:	90                   	nop
801057fc:	90                   	nop
801057fd:	90                   	nop
801057fe:	90                   	nop
801057ff:	90                   	nop

80105800 <sys_open>:

int
sys_open(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105806:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105809:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010580c:	50                   	push   %eax
8010580d:	6a 00                	push   $0x0
8010580f:	e8 fc f7 ff ff       	call   80105010 <argstr>
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	85 c0                	test   %eax,%eax
80105819:	0f 88 1d 01 00 00    	js     8010593c <sys_open+0x13c>
8010581f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105822:	83 ec 08             	sub    $0x8,%esp
80105825:	50                   	push   %eax
80105826:	6a 01                	push   $0x1
80105828:	e8 33 f7 ff ff       	call   80104f60 <argint>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	85 c0                	test   %eax,%eax
80105832:	0f 88 04 01 00 00    	js     8010593c <sys_open+0x13c>
    return -1;

  begin_op();
80105838:	e8 63 d9 ff ff       	call   801031a0 <begin_op>

  if(omode & O_CREATE){
8010583d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105841:	0f 85 a9 00 00 00    	jne    801058f0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105847:	83 ec 0c             	sub    $0xc,%esp
8010584a:	ff 75 e0             	pushl  -0x20(%ebp)
8010584d:	e8 ce c6 ff ff       	call   80101f20 <namei>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	89 c6                	mov    %eax,%esi
80105859:	0f 84 ac 00 00 00    	je     8010590b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010585f:	83 ec 0c             	sub    $0xc,%esp
80105862:	50                   	push   %eax
80105863:	e8 58 be ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105868:	83 c4 10             	add    $0x10,%esp
8010586b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105870:	0f 84 aa 00 00 00    	je     80105920 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105876:	e8 45 b5 ff ff       	call   80100dc0 <filealloc>
8010587b:	85 c0                	test   %eax,%eax
8010587d:	89 c7                	mov    %eax,%edi
8010587f:	0f 84 a6 00 00 00    	je     8010592b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105885:	e8 a6 e5 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010588a:	31 db                	xor    %ebx,%ebx
8010588c:	eb 0e                	jmp    8010589c <sys_open+0x9c>
8010588e:	66 90                	xchg   %ax,%ax
80105890:	83 c3 01             	add    $0x1,%ebx
80105893:	83 fb 10             	cmp    $0x10,%ebx
80105896:	0f 84 ac 00 00 00    	je     80105948 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010589c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058a0:	85 d2                	test   %edx,%edx
801058a2:	75 ec                	jne    80105890 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058a4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058a7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801058ab:	56                   	push   %esi
801058ac:	e8 ef be ff ff       	call   801017a0 <iunlock>
  end_op();
801058b1:	e8 5a d9 ff ff       	call   80103210 <end_op>

  f->type = FD_INODE;
801058b6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058bf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801058c2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801058c5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058cc:	89 d0                	mov    %edx,%eax
801058ce:	f7 d0                	not    %eax
801058d0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058d3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058d6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058d9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e0:	89 d8                	mov    %ebx,%eax
801058e2:	5b                   	pop    %ebx
801058e3:	5e                   	pop    %esi
801058e4:	5f                   	pop    %edi
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801058f0:	6a 00                	push   $0x0
801058f2:	6a 00                	push   $0x0
801058f4:	6a 02                	push   $0x2
801058f6:	ff 75 e0             	pushl  -0x20(%ebp)
801058f9:	e8 52 fd ff ff       	call   80105650 <create>
    if(ip == 0){
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105903:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105905:	0f 85 6b ff ff ff    	jne    80105876 <sys_open+0x76>
      end_op();
8010590b:	e8 00 d9 ff ff       	call   80103210 <end_op>
      return -1;
80105910:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105915:	eb c6                	jmp    801058dd <sys_open+0xdd>
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105920:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105923:	85 c9                	test   %ecx,%ecx
80105925:	0f 84 4b ff ff ff    	je     80105876 <sys_open+0x76>
    iunlockput(ip);
8010592b:	83 ec 0c             	sub    $0xc,%esp
8010592e:	56                   	push   %esi
8010592f:	e8 1c c0 ff ff       	call   80101950 <iunlockput>
    end_op();
80105934:	e8 d7 d8 ff ff       	call   80103210 <end_op>
    return -1;
80105939:	83 c4 10             	add    $0x10,%esp
8010593c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105941:	eb 9a                	jmp    801058dd <sys_open+0xdd>
80105943:	90                   	nop
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	57                   	push   %edi
8010594c:	e8 2f b5 ff ff       	call   80100e80 <fileclose>
80105951:	83 c4 10             	add    $0x10,%esp
80105954:	eb d5                	jmp    8010592b <sys_open+0x12b>
80105956:	8d 76 00             	lea    0x0(%esi),%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105960 <sys_mkdir>:

int
sys_mkdir(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105966:	e8 35 d8 ff ff       	call   801031a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010596b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010596e:	83 ec 08             	sub    $0x8,%esp
80105971:	50                   	push   %eax
80105972:	6a 00                	push   $0x0
80105974:	e8 97 f6 ff ff       	call   80105010 <argstr>
80105979:	83 c4 10             	add    $0x10,%esp
8010597c:	85 c0                	test   %eax,%eax
8010597e:	78 30                	js     801059b0 <sys_mkdir+0x50>
80105980:	6a 00                	push   $0x0
80105982:	6a 00                	push   $0x0
80105984:	6a 01                	push   $0x1
80105986:	ff 75 f4             	pushl  -0xc(%ebp)
80105989:	e8 c2 fc ff ff       	call   80105650 <create>
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	85 c0                	test   %eax,%eax
80105993:	74 1b                	je     801059b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105995:	83 ec 0c             	sub    $0xc,%esp
80105998:	50                   	push   %eax
80105999:	e8 b2 bf ff ff       	call   80101950 <iunlockput>
  end_op();
8010599e:	e8 6d d8 ff ff       	call   80103210 <end_op>
  return 0;
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	31 c0                	xor    %eax,%eax
}
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801059b0:	e8 5b d8 ff ff       	call   80103210 <end_op>
    return -1;
801059b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ba:	c9                   	leave  
801059bb:	c3                   	ret    
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_mknod>:

int
sys_mknod(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059c6:	e8 d5 d7 ff ff       	call   801031a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 37 f6 ff ff       	call   80105010 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 60                	js     80105a40 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801059e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059e3:	83 ec 08             	sub    $0x8,%esp
801059e6:	50                   	push   %eax
801059e7:	6a 01                	push   $0x1
801059e9:	e8 72 f5 ff ff       	call   80104f60 <argint>
  if((argstr(0, &path)) < 0 ||
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	78 4b                	js     80105a40 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801059f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f8:	83 ec 08             	sub    $0x8,%esp
801059fb:	50                   	push   %eax
801059fc:	6a 02                	push   $0x2
801059fe:	e8 5d f5 ff ff       	call   80104f60 <argint>
     argint(1, &major) < 0 ||
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	85 c0                	test   %eax,%eax
80105a08:	78 36                	js     80105a40 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a0e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a0f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a13:	50                   	push   %eax
80105a14:	6a 03                	push   $0x3
80105a16:	ff 75 ec             	pushl  -0x14(%ebp)
80105a19:	e8 32 fc ff ff       	call   80105650 <create>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	85 c0                	test   %eax,%eax
80105a23:	74 1b                	je     80105a40 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a25:	83 ec 0c             	sub    $0xc,%esp
80105a28:	50                   	push   %eax
80105a29:	e8 22 bf ff ff       	call   80101950 <iunlockput>
  end_op();
80105a2e:	e8 dd d7 ff ff       	call   80103210 <end_op>
  return 0;
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	31 c0                	xor    %eax,%eax
}
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a40:	e8 cb d7 ff ff       	call   80103210 <end_op>
    return -1;
80105a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a4a:	c9                   	leave  
80105a4b:	c3                   	ret    
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_chdir>:

int
sys_chdir(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	53                   	push   %ebx
80105a55:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a58:	e8 d3 e3 ff ff       	call   80103e30 <myproc>
80105a5d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a5f:	e8 3c d7 ff ff       	call   801031a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a67:	83 ec 08             	sub    $0x8,%esp
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 9e f5 ff ff       	call   80105010 <argstr>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	78 77                	js     80105af0 <sys_chdir+0xa0>
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a7f:	e8 9c c4 ff ff       	call   80101f20 <namei>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	89 c3                	mov    %eax,%ebx
80105a8b:	74 63                	je     80105af0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	50                   	push   %eax
80105a91:	e8 2a bc ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a9e:	75 30                	jne    80105ad0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	53                   	push   %ebx
80105aa4:	e8 f7 bc ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105aa9:	58                   	pop    %eax
80105aaa:	ff 76 68             	pushl  0x68(%esi)
80105aad:	e8 3e bd ff ff       	call   801017f0 <iput>
  end_op();
80105ab2:	e8 59 d7 ff ff       	call   80103210 <end_op>
  curproc->cwd = ip;
80105ab7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	31 c0                	xor    %eax,%eax
}
80105abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ac2:	5b                   	pop    %ebx
80105ac3:	5e                   	pop    %esi
80105ac4:	5d                   	pop    %ebp
80105ac5:	c3                   	ret    
80105ac6:	8d 76 00             	lea    0x0(%esi),%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	53                   	push   %ebx
80105ad4:	e8 77 be ff ff       	call   80101950 <iunlockput>
    end_op();
80105ad9:	e8 32 d7 ff ff       	call   80103210 <end_op>
    return -1;
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae6:	eb d7                	jmp    80105abf <sys_chdir+0x6f>
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105af0:	e8 1b d7 ff ff       	call   80103210 <end_op>
    return -1;
80105af5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afa:	eb c3                	jmp    80105abf <sys_chdir+0x6f>
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_exec>:

int
sys_exec(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b06:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b12:	50                   	push   %eax
80105b13:	6a 00                	push   $0x0
80105b15:	e8 f6 f4 ff ff       	call   80105010 <argstr>
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	0f 88 87 00 00 00    	js     80105bac <sys_exec+0xac>
80105b25:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b2b:	83 ec 08             	sub    $0x8,%esp
80105b2e:	50                   	push   %eax
80105b2f:	6a 01                	push   $0x1
80105b31:	e8 2a f4 ff ff       	call   80104f60 <argint>
80105b36:	83 c4 10             	add    $0x10,%esp
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	78 6f                	js     80105bac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b3d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b43:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105b46:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b48:	68 80 00 00 00       	push   $0x80
80105b4d:	6a 00                	push   $0x0
80105b4f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b55:	50                   	push   %eax
80105b56:	e8 05 f1 ff ff       	call   80104c60 <memset>
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	eb 2c                	jmp    80105b8c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105b60:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b66:	85 c0                	test   %eax,%eax
80105b68:	74 56                	je     80105bc0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b6a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b70:	83 ec 08             	sub    $0x8,%esp
80105b73:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b76:	52                   	push   %edx
80105b77:	50                   	push   %eax
80105b78:	e8 73 f3 ff ff       	call   80104ef0 <fetchstr>
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	85 c0                	test   %eax,%eax
80105b82:	78 28                	js     80105bac <sys_exec+0xac>
  for(i=0;; i++){
80105b84:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b87:	83 fb 20             	cmp    $0x20,%ebx
80105b8a:	74 20                	je     80105bac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b8c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b92:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b99:	83 ec 08             	sub    $0x8,%esp
80105b9c:	57                   	push   %edi
80105b9d:	01 f0                	add    %esi,%eax
80105b9f:	50                   	push   %eax
80105ba0:	e8 0b f3 ff ff       	call   80104eb0 <fetchint>
80105ba5:	83 c4 10             	add    $0x10,%esp
80105ba8:	85 c0                	test   %eax,%eax
80105baa:	79 b4                	jns    80105b60 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bb4:	5b                   	pop    %ebx
80105bb5:	5e                   	pop    %esi
80105bb6:	5f                   	pop    %edi
80105bb7:	5d                   	pop    %ebp
80105bb8:	c3                   	ret    
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105bc0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bc6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105bc9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bd0:	00 00 00 00 
  return exec(path, argv);
80105bd4:	50                   	push   %eax
80105bd5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bdb:	e8 30 ae ff ff       	call   80100a10 <exec>
80105be0:	83 c4 10             	add    $0x10,%esp
}
80105be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be6:	5b                   	pop    %ebx
80105be7:	5e                   	pop    %esi
80105be8:	5f                   	pop    %edi
80105be9:	5d                   	pop    %ebp
80105bea:	c3                   	ret    
80105beb:	90                   	nop
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_pipe>:

int
sys_pipe(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bf6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105bf9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bfc:	6a 08                	push   $0x8
80105bfe:	50                   	push   %eax
80105bff:	6a 00                	push   $0x0
80105c01:	e8 aa f3 ff ff       	call   80104fb0 <argptr>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	0f 88 ae 00 00 00    	js     80105cbf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	50                   	push   %eax
80105c18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c1b:	50                   	push   %eax
80105c1c:	e8 1f dc ff ff       	call   80103840 <pipealloc>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	0f 88 93 00 00 00    	js     80105cbf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c2f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c31:	e8 fa e1 ff ff       	call   80103e30 <myproc>
80105c36:	eb 10                	jmp    80105c48 <sys_pipe+0x58>
80105c38:	90                   	nop
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c40:	83 c3 01             	add    $0x1,%ebx
80105c43:	83 fb 10             	cmp    $0x10,%ebx
80105c46:	74 60                	je     80105ca8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105c48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c4c:	85 f6                	test   %esi,%esi
80105c4e:	75 f0                	jne    80105c40 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105c50:	8d 73 08             	lea    0x8(%ebx),%esi
80105c53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c5a:	e8 d1 e1 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c5f:	31 d2                	xor    %edx,%edx
80105c61:	eb 0d                	jmp    80105c70 <sys_pipe+0x80>
80105c63:	90                   	nop
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c68:	83 c2 01             	add    $0x1,%edx
80105c6b:	83 fa 10             	cmp    $0x10,%edx
80105c6e:	74 28                	je     80105c98 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105c70:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c74:	85 c9                	test   %ecx,%ecx
80105c76:	75 f0                	jne    80105c68 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105c78:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c7f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c81:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c84:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c87:	31 c0                	xor    %eax,%eax
}
80105c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8c:	5b                   	pop    %ebx
80105c8d:	5e                   	pop    %esi
80105c8e:	5f                   	pop    %edi
80105c8f:	5d                   	pop    %ebp
80105c90:	c3                   	ret    
80105c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c98:	e8 93 e1 ff ff       	call   80103e30 <myproc>
80105c9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ca4:	00 
80105ca5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ca8:	83 ec 0c             	sub    $0xc,%esp
80105cab:	ff 75 e0             	pushl  -0x20(%ebp)
80105cae:	e8 cd b1 ff ff       	call   80100e80 <fileclose>
    fileclose(wf);
80105cb3:	58                   	pop    %eax
80105cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cb7:	e8 c4 b1 ff ff       	call   80100e80 <fileclose>
    return -1;
80105cbc:	83 c4 10             	add    $0x10,%esp
80105cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc4:	eb c3                	jmp    80105c89 <sys_pipe+0x99>
80105cc6:	66 90                	xchg   %ax,%ax
80105cc8:	66 90                	xchg   %ax,%ax
80105cca:	66 90                	xchg   %ax,%ax
80105ccc:	66 90                	xchg   %ax,%ax
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105cd3:	5d                   	pop    %ebp
  return fork();
80105cd4:	e9 f7 e2 ff ff       	jmp    80103fd0 <fork>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_exit>:

int
sys_exit(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ce6:	e8 b5 e6 ff ff       	call   801043a0 <exit>
  return 0;  // not reached
}
80105ceb:	31 c0                	xor    %eax,%eax
80105ced:	c9                   	leave  
80105cee:	c3                   	ret    
80105cef:	90                   	nop

80105cf0 <sys_wait>:

int
sys_wait(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105cf3:	5d                   	pop    %ebp
  return wait();
80105cf4:	e9 07 e9 ff ff       	jmp    80104600 <wait>
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_kill>:

int
sys_kill(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d09:	50                   	push   %eax
80105d0a:	6a 00                	push   $0x0
80105d0c:	e8 4f f2 ff ff       	call   80104f60 <argint>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 18                	js     80105d30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d18:	83 ec 0c             	sub    $0xc,%esp
80105d1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1e:	e8 6d ea ff ff       	call   80104790 <kill>
80105d23:	83 c4 10             	add    $0x10,%esp
}
80105d26:	c9                   	leave  
80105d27:	c3                   	ret    
80105d28:	90                   	nop
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <sys_getpid>:

int
sys_getpid(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d46:	e8 e5 e0 ff ff       	call   80103e30 <myproc>
80105d4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d4e:	c9                   	leave  
80105d4f:	c3                   	ret    

80105d50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d5a:	50                   	push   %eax
80105d5b:	6a 00                	push   $0x0
80105d5d:	e8 fe f1 ff ff       	call   80104f60 <argint>
80105d62:	83 c4 10             	add    $0x10,%esp
80105d65:	85 c0                	test   %eax,%eax
80105d67:	78 27                	js     80105d90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d69:	e8 c2 e0 ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
80105d6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d73:	ff 75 f4             	pushl  -0xc(%ebp)
80105d76:	e8 d5 e1 ff ff       	call   80103f50 <growproc>
80105d7b:	83 c4 10             	add    $0x10,%esp
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	78 0e                	js     80105d90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d82:	89 d8                	mov    %ebx,%eax
80105d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d87:	c9                   	leave  
80105d88:	c3                   	ret    
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d95:	eb eb                	jmp    80105d82 <sys_sbrk+0x32>
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_sleep>:

int
sys_sleep(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105da7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105daa:	50                   	push   %eax
80105dab:	6a 00                	push   $0x0
80105dad:	e8 ae f1 ff ff       	call   80104f60 <argint>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	0f 88 8a 00 00 00    	js     80105e47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105dbd:	83 ec 0c             	sub    $0xc,%esp
80105dc0:	68 80 7e 15 80       	push   $0x80157e80
80105dc5:	e8 86 ed ff ff       	call   80104b50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dcd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105dd0:	8b 1d c0 86 15 80    	mov    0x801586c0,%ebx
  while(ticks - ticks0 < n){
80105dd6:	85 d2                	test   %edx,%edx
80105dd8:	75 27                	jne    80105e01 <sys_sleep+0x61>
80105dda:	eb 54                	jmp    80105e30 <sys_sleep+0x90>
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105de0:	83 ec 08             	sub    $0x8,%esp
80105de3:	68 80 7e 15 80       	push   $0x80157e80
80105de8:	68 c0 86 15 80       	push   $0x801586c0
80105ded:	e8 4e e7 ff ff       	call   80104540 <sleep>
  while(ticks - ticks0 < n){
80105df2:	a1 c0 86 15 80       	mov    0x801586c0,%eax
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	29 d8                	sub    %ebx,%eax
80105dfc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105dff:	73 2f                	jae    80105e30 <sys_sleep+0x90>
    if(myproc()->killed){
80105e01:	e8 2a e0 ff ff       	call   80103e30 <myproc>
80105e06:	8b 40 24             	mov    0x24(%eax),%eax
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	74 d3                	je     80105de0 <sys_sleep+0x40>
      release(&tickslock);
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	68 80 7e 15 80       	push   $0x80157e80
80105e15:	e8 f6 ed ff ff       	call   80104c10 <release>
      return -1;
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e25:	c9                   	leave  
80105e26:	c3                   	ret    
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	68 80 7e 15 80       	push   $0x80157e80
80105e38:	e8 d3 ed ff ff       	call   80104c10 <release>
  return 0;
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	31 c0                	xor    %eax,%eax
}
80105e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
    return -1;
80105e47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4c:	eb f4                	jmp    80105e42 <sys_sleep+0xa2>
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	53                   	push   %ebx
80105e54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e57:	68 80 7e 15 80       	push   $0x80157e80
80105e5c:	e8 ef ec ff ff       	call   80104b50 <acquire>
  xticks = ticks;
80105e61:	8b 1d c0 86 15 80    	mov    0x801586c0,%ebx
  release(&tickslock);
80105e67:	c7 04 24 80 7e 15 80 	movl   $0x80157e80,(%esp)
80105e6e:	e8 9d ed ff ff       	call   80104c10 <release>
  return xticks;
}
80105e73:	89 d8                	mov    %ebx,%eax
80105e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e78:	c9                   	leave  
80105e79:	c3                   	ret    

80105e7a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e7a:	1e                   	push   %ds
  pushl %es
80105e7b:	06                   	push   %es
  pushl %fs
80105e7c:	0f a0                	push   %fs
  pushl %gs
80105e7e:	0f a8                	push   %gs
  pushal
80105e80:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e81:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e85:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e87:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e89:	54                   	push   %esp
  call trap
80105e8a:	e8 c1 00 00 00       	call   80105f50 <trap>
  addl $4, %esp
80105e8f:	83 c4 04             	add    $0x4,%esp

80105e92 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e92:	61                   	popa   
  popl %gs
80105e93:	0f a9                	pop    %gs
  popl %fs
80105e95:	0f a1                	pop    %fs
  popl %es
80105e97:	07                   	pop    %es
  popl %ds
80105e98:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e99:	83 c4 08             	add    $0x8,%esp
  iret
80105e9c:	cf                   	iret   
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ea0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ea1:	31 c0                	xor    %eax,%eax
{
80105ea3:	89 e5                	mov    %esp,%ebp
80105ea5:	83 ec 08             	sub    $0x8,%esp
80105ea8:	90                   	nop
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105eb0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105eb7:	c7 04 c5 c2 7e 15 80 	movl   $0x8e000008,-0x7fea813e(,%eax,8)
80105ebe:	08 00 00 8e 
80105ec2:	66 89 14 c5 c0 7e 15 	mov    %dx,-0x7fea8140(,%eax,8)
80105ec9:	80 
80105eca:	c1 ea 10             	shr    $0x10,%edx
80105ecd:	66 89 14 c5 c6 7e 15 	mov    %dx,-0x7fea813a(,%eax,8)
80105ed4:	80 
  for(i = 0; i < 256; i++)
80105ed5:	83 c0 01             	add    $0x1,%eax
80105ed8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105edd:	75 d1                	jne    80105eb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105edf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ee4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ee7:	c7 05 c2 80 15 80 08 	movl   $0xef000008,0x801580c2
80105eee:	00 00 ef 
  initlock(&tickslock, "time");
80105ef1:	68 b5 87 10 80       	push   $0x801087b5
80105ef6:	68 80 7e 15 80       	push   $0x80157e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105efb:	66 a3 c0 80 15 80    	mov    %ax,0x801580c0
80105f01:	c1 e8 10             	shr    $0x10,%eax
80105f04:	66 a3 c6 80 15 80    	mov    %ax,0x801580c6
  initlock(&tickslock, "time");
80105f0a:	e8 01 eb ff ff       	call   80104a10 <initlock>
}
80105f0f:	83 c4 10             	add    $0x10,%esp
80105f12:	c9                   	leave  
80105f13:	c3                   	ret    
80105f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f20 <idtinit>:

void
idtinit(void)
{
80105f20:	55                   	push   %ebp
  pd[0] = size-1;
80105f21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f26:	89 e5                	mov    %esp,%ebp
80105f28:	83 ec 10             	sub    $0x10,%esp
80105f2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f2f:	b8 c0 7e 15 80       	mov    $0x80157ec0,%eax
80105f34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f38:	c1 e8 10             	shr    $0x10,%eax
80105f3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	57                   	push   %edi
80105f54:	56                   	push   %esi
80105f55:	53                   	push   %ebx
80105f56:	83 ec 1c             	sub    $0x1c,%esp
80105f59:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f5c:	8b 47 30             	mov    0x30(%edi),%eax
80105f5f:	83 f8 40             	cmp    $0x40,%eax
80105f62:	0f 84 f0 00 00 00    	je     80106058 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f68:	83 e8 0e             	sub    $0xe,%eax
80105f6b:	83 f8 31             	cmp    $0x31,%eax
80105f6e:	77 10                	ja     80105f80 <trap+0x30>
80105f70:	ff 24 85 78 88 10 80 	jmp    *-0x7fef7788(,%eax,4)
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    else if (myproc()->pid > 2)
      panic("trap: segmentation fault\n");
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f80:	e8 ab de ff ff       	call   80103e30 <myproc>
80105f85:	85 c0                	test   %eax,%eax
80105f87:	0f 84 37 02 00 00    	je     801061c4 <trap+0x274>
80105f8d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f91:	0f 84 2d 02 00 00    	je     801061c4 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f97:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f9a:	8b 57 38             	mov    0x38(%edi),%edx
80105f9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105fa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105fa3:	e8 68 de ff ff       	call   80103e10 <cpuid>
80105fa8:	8b 77 34             	mov    0x34(%edi),%esi
80105fab:	8b 5f 30             	mov    0x30(%edi),%ebx
80105fae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fb1:	e8 7a de ff ff       	call   80103e30 <myproc>
80105fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fb9:	e8 72 de ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fc4:	51                   	push   %ecx
80105fc5:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fc9:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fcc:	56                   	push   %esi
80105fcd:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80105fce:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fd1:	52                   	push   %edx
80105fd2:	ff 70 10             	pushl  0x10(%eax)
80105fd5:	68 34 88 10 80       	push   $0x80108834
80105fda:	e8 81 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fdf:	83 c4 20             	add    $0x20,%esp
80105fe2:	e8 49 de ff ff       	call   80103e30 <myproc>
80105fe7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105fee:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff0:	e8 3b de ff ff       	call   80103e30 <myproc>
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	74 1d                	je     80106016 <trap+0xc6>
80105ff9:	e8 32 de ff ff       	call   80103e30 <myproc>
80105ffe:	8b 50 24             	mov    0x24(%eax),%edx
80106001:	85 d2                	test   %edx,%edx
80106003:	74 11                	je     80106016 <trap+0xc6>
80106005:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106009:	83 e0 03             	and    $0x3,%eax
8010600c:	66 83 f8 03          	cmp    $0x3,%ax
80106010:	0f 84 6a 01 00 00    	je     80106180 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106016:	e8 15 de ff ff       	call   80103e30 <myproc>
8010601b:	85 c0                	test   %eax,%eax
8010601d:	74 0b                	je     8010602a <trap+0xda>
8010601f:	e8 0c de ff ff       	call   80103e30 <myproc>
80106024:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106028:	74 66                	je     80106090 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010602a:	e8 01 de ff ff       	call   80103e30 <myproc>
8010602f:	85 c0                	test   %eax,%eax
80106031:	74 19                	je     8010604c <trap+0xfc>
80106033:	e8 f8 dd ff ff       	call   80103e30 <myproc>
80106038:	8b 40 24             	mov    0x24(%eax),%eax
8010603b:	85 c0                	test   %eax,%eax
8010603d:	74 0d                	je     8010604c <trap+0xfc>
8010603f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106043:	83 e0 03             	and    $0x3,%eax
80106046:	66 83 f8 03          	cmp    $0x3,%ax
8010604a:	74 35                	je     80106081 <trap+0x131>
    exit();
}
8010604c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604f:	5b                   	pop    %ebx
80106050:	5e                   	pop    %esi
80106051:	5f                   	pop    %edi
80106052:	5d                   	pop    %ebp
80106053:	c3                   	ret    
80106054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106058:	e8 d3 dd ff ff       	call   80103e30 <myproc>
8010605d:	8b 58 24             	mov    0x24(%eax),%ebx
80106060:	85 db                	test   %ebx,%ebx
80106062:	0f 85 08 01 00 00    	jne    80106170 <trap+0x220>
    myproc()->tf = tf;
80106068:	e8 c3 dd ff ff       	call   80103e30 <myproc>
8010606d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106070:	e8 db ef ff ff       	call   80105050 <syscall>
    if(myproc()->killed)
80106075:	e8 b6 dd ff ff       	call   80103e30 <myproc>
8010607a:	8b 48 24             	mov    0x24(%eax),%ecx
8010607d:	85 c9                	test   %ecx,%ecx
8010607f:	74 cb                	je     8010604c <trap+0xfc>
}
80106081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
      exit();
80106088:	e9 13 e3 ff ff       	jmp    801043a0 <exit>
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106090:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106094:	75 94                	jne    8010602a <trap+0xda>
    yield();
80106096:	e8 55 e4 ff ff       	call   801044f0 <yield>
8010609b:	eb 8d                	jmp    8010602a <trap+0xda>
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc()->pid > 2 && handle_pf())
801060a0:	e8 8b dd ff ff       	call   80103e30 <myproc>
801060a5:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801060a9:	7e 0d                	jle    801060b8 <trap+0x168>
801060ab:	e8 30 1b 00 00       	call   80107be0 <handle_pf>
801060b0:	85 c0                	test   %eax,%eax
801060b2:	0f 85 38 ff ff ff    	jne    80105ff0 <trap+0xa0>
    else if (handle_cow())
801060b8:	e8 c3 1d 00 00       	call   80107e80 <handle_cow>
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 85 2b ff ff ff    	jne    80105ff0 <trap+0xa0>
    else if (myproc()->pid > 2)
801060c5:	e8 66 dd ff ff       	call   80103e30 <myproc>
801060ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801060ce:	0f 8e 1c ff ff ff    	jle    80105ff0 <trap+0xa0>
      panic("trap: segmentation fault\n");
801060d4:	83 ec 0c             	sub    $0xc,%esp
801060d7:	68 ba 87 10 80       	push   $0x801087ba
801060dc:	e8 af a2 ff ff       	call   80100390 <panic>
801060e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801060e8:	e8 23 dd ff ff       	call   80103e10 <cpuid>
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 84 9b 00 00 00    	je     80106190 <trap+0x240>
    lapiceoi();
801060f5:	e8 56 cc ff ff       	call   80102d50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060fa:	e8 31 dd ff ff       	call   80103e30 <myproc>
801060ff:	85 c0                	test   %eax,%eax
80106101:	0f 85 f2 fe ff ff    	jne    80105ff9 <trap+0xa9>
80106107:	e9 0a ff ff ff       	jmp    80106016 <trap+0xc6>
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106110:	e8 4b 02 00 00       	call   80106360 <uartintr>
    lapiceoi();
80106115:	e8 36 cc ff ff       	call   80102d50 <lapiceoi>
    break;
8010611a:	e9 d1 fe ff ff       	jmp    80105ff0 <trap+0xa0>
8010611f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106120:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106124:	8b 77 38             	mov    0x38(%edi),%esi
80106127:	e8 e4 dc ff ff       	call   80103e10 <cpuid>
8010612c:	56                   	push   %esi
8010612d:	53                   	push   %ebx
8010612e:	50                   	push   %eax
8010612f:	68 dc 87 10 80       	push   $0x801087dc
80106134:	e8 27 a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106139:	e8 12 cc ff ff       	call   80102d50 <lapiceoi>
    break;
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	e9 aa fe ff ff       	jmp    80105ff0 <trap+0xa0>
80106146:	8d 76 00             	lea    0x0(%esi),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106150:	e8 fb c2 ff ff       	call   80102450 <ideintr>
80106155:	eb 9e                	jmp    801060f5 <trap+0x1a5>
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106160:	e8 ab ca ff ff       	call   80102c10 <kbdintr>
    lapiceoi();
80106165:	e8 e6 cb ff ff       	call   80102d50 <lapiceoi>
    break;
8010616a:	e9 81 fe ff ff       	jmp    80105ff0 <trap+0xa0>
8010616f:	90                   	nop
      exit();
80106170:	e8 2b e2 ff ff       	call   801043a0 <exit>
80106175:	e9 ee fe ff ff       	jmp    80106068 <trap+0x118>
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106180:	e8 1b e2 ff ff       	call   801043a0 <exit>
80106185:	e9 8c fe ff ff       	jmp    80106016 <trap+0xc6>
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	68 80 7e 15 80       	push   $0x80157e80
80106198:	e8 b3 e9 ff ff       	call   80104b50 <acquire>
      wakeup(&ticks);
8010619d:	c7 04 24 c0 86 15 80 	movl   $0x801586c0,(%esp)
      ticks++;
801061a4:	83 05 c0 86 15 80 01 	addl   $0x1,0x801586c0
      wakeup(&ticks);
801061ab:	e8 80 e5 ff ff       	call   80104730 <wakeup>
      release(&tickslock);
801061b0:	c7 04 24 80 7e 15 80 	movl   $0x80157e80,(%esp)
801061b7:	e8 54 ea ff ff       	call   80104c10 <release>
801061bc:	83 c4 10             	add    $0x10,%esp
801061bf:	e9 31 ff ff ff       	jmp    801060f5 <trap+0x1a5>
801061c4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801061ca:	e8 41 dc ff ff       	call   80103e10 <cpuid>
801061cf:	83 ec 0c             	sub    $0xc,%esp
801061d2:	56                   	push   %esi
801061d3:	53                   	push   %ebx
801061d4:	50                   	push   %eax
801061d5:	ff 77 30             	pushl  0x30(%edi)
801061d8:	68 00 88 10 80       	push   $0x80108800
801061dd:	e8 7e a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
801061e2:	83 c4 14             	add    $0x14,%esp
801061e5:	68 d4 87 10 80       	push   $0x801087d4
801061ea:	e8 a1 a1 ff ff       	call   80100390 <panic>
801061ef:	90                   	nop

801061f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801061f0:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
{
801061f5:	55                   	push   %ebp
801061f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061f8:	85 c0                	test   %eax,%eax
801061fa:	74 1c                	je     80106218 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106201:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106202:	a8 01                	test   $0x1,%al
80106204:	74 12                	je     80106218 <uartgetc+0x28>
80106206:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010620b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010620c:	0f b6 c0             	movzbl %al,%eax
}
8010620f:	5d                   	pop    %ebp
80106210:	c3                   	ret    
80106211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010621d:	5d                   	pop    %ebp
8010621e:	c3                   	ret    
8010621f:	90                   	nop

80106220 <uartputc.part.0>:
uartputc(int c)
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	57                   	push   %edi
80106224:	56                   	push   %esi
80106225:	53                   	push   %ebx
80106226:	89 c7                	mov    %eax,%edi
80106228:	bb 80 00 00 00       	mov    $0x80,%ebx
8010622d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106232:	83 ec 0c             	sub    $0xc,%esp
80106235:	eb 1b                	jmp    80106252 <uartputc.part.0+0x32>
80106237:	89 f6                	mov    %esi,%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	6a 0a                	push   $0xa
80106245:	e8 26 cb ff ff       	call   80102d70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010624a:	83 c4 10             	add    $0x10,%esp
8010624d:	83 eb 01             	sub    $0x1,%ebx
80106250:	74 07                	je     80106259 <uartputc.part.0+0x39>
80106252:	89 f2                	mov    %esi,%edx
80106254:	ec                   	in     (%dx),%al
80106255:	a8 20                	test   $0x20,%al
80106257:	74 e7                	je     80106240 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106259:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010625e:	89 f8                	mov    %edi,%eax
80106260:	ee                   	out    %al,(%dx)
}
80106261:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106264:	5b                   	pop    %ebx
80106265:	5e                   	pop    %esi
80106266:	5f                   	pop    %edi
80106267:	5d                   	pop    %ebp
80106268:	c3                   	ret    
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106270 <uartinit>:
{
80106270:	55                   	push   %ebp
80106271:	31 c9                	xor    %ecx,%ecx
80106273:	89 c8                	mov    %ecx,%eax
80106275:	89 e5                	mov    %esp,%ebp
80106277:	57                   	push   %edi
80106278:	56                   	push   %esi
80106279:	53                   	push   %ebx
8010627a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010627f:	89 da                	mov    %ebx,%edx
80106281:	83 ec 0c             	sub    $0xc,%esp
80106284:	ee                   	out    %al,(%dx)
80106285:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010628a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010628f:	89 fa                	mov    %edi,%edx
80106291:	ee                   	out    %al,(%dx)
80106292:	b8 0c 00 00 00       	mov    $0xc,%eax
80106297:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629c:	ee                   	out    %al,(%dx)
8010629d:	be f9 03 00 00       	mov    $0x3f9,%esi
801062a2:	89 c8                	mov    %ecx,%eax
801062a4:	89 f2                	mov    %esi,%edx
801062a6:	ee                   	out    %al,(%dx)
801062a7:	b8 03 00 00 00       	mov    $0x3,%eax
801062ac:	89 fa                	mov    %edi,%edx
801062ae:	ee                   	out    %al,(%dx)
801062af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062b4:	89 c8                	mov    %ecx,%eax
801062b6:	ee                   	out    %al,(%dx)
801062b7:	b8 01 00 00 00       	mov    $0x1,%eax
801062bc:	89 f2                	mov    %esi,%edx
801062be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801062c5:	3c ff                	cmp    $0xff,%al
801062c7:	74 5a                	je     80106323 <uartinit+0xb3>
  uart = 1;
801062c9:	c7 05 c4 c5 10 80 01 	movl   $0x1,0x8010c5c4
801062d0:	00 00 00 
801062d3:	89 da                	mov    %ebx,%edx
801062d5:	ec                   	in     (%dx),%al
801062d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801062dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801062df:	bb 40 89 10 80       	mov    $0x80108940,%ebx
  ioapicenable(IRQ_COM1, 0);
801062e4:	6a 00                	push   $0x0
801062e6:	6a 04                	push   $0x4
801062e8:	e8 b3 c3 ff ff       	call   801026a0 <ioapicenable>
801062ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801062f0:	b8 78 00 00 00       	mov    $0x78,%eax
801062f5:	eb 13                	jmp    8010630a <uartinit+0x9a>
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106300:	83 c3 01             	add    $0x1,%ebx
80106303:	0f be 03             	movsbl (%ebx),%eax
80106306:	84 c0                	test   %al,%al
80106308:	74 19                	je     80106323 <uartinit+0xb3>
  if(!uart)
8010630a:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
80106310:	85 d2                	test   %edx,%edx
80106312:	74 ec                	je     80106300 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106314:	83 c3 01             	add    $0x1,%ebx
80106317:	e8 04 ff ff ff       	call   80106220 <uartputc.part.0>
8010631c:	0f be 03             	movsbl (%ebx),%eax
8010631f:	84 c0                	test   %al,%al
80106321:	75 e7                	jne    8010630a <uartinit+0x9a>
}
80106323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106326:	5b                   	pop    %ebx
80106327:	5e                   	pop    %esi
80106328:	5f                   	pop    %edi
80106329:	5d                   	pop    %ebp
8010632a:	c3                   	ret    
8010632b:	90                   	nop
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106330 <uartputc>:
  if(!uart)
80106330:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
{
80106336:	55                   	push   %ebp
80106337:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106339:	85 d2                	test   %edx,%edx
{
8010633b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010633e:	74 10                	je     80106350 <uartputc+0x20>
}
80106340:	5d                   	pop    %ebp
80106341:	e9 da fe ff ff       	jmp    80106220 <uartputc.part.0>
80106346:	8d 76 00             	lea    0x0(%esi),%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106350:	5d                   	pop    %ebp
80106351:	c3                   	ret    
80106352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106360 <uartintr>:

void
uartintr(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106366:	68 f0 61 10 80       	push   $0x801061f0
8010636b:	e8 a0 a4 ff ff       	call   80100810 <consoleintr>
}
80106370:	83 c4 10             	add    $0x10,%esp
80106373:	c9                   	leave  
80106374:	c3                   	ret    

80106375 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $0
80106377:	6a 00                	push   $0x0
  jmp alltraps
80106379:	e9 fc fa ff ff       	jmp    80105e7a <alltraps>

8010637e <vector1>:
.globl vector1
vector1:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $1
80106380:	6a 01                	push   $0x1
  jmp alltraps
80106382:	e9 f3 fa ff ff       	jmp    80105e7a <alltraps>

80106387 <vector2>:
.globl vector2
vector2:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $2
80106389:	6a 02                	push   $0x2
  jmp alltraps
8010638b:	e9 ea fa ff ff       	jmp    80105e7a <alltraps>

80106390 <vector3>:
.globl vector3
vector3:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $3
80106392:	6a 03                	push   $0x3
  jmp alltraps
80106394:	e9 e1 fa ff ff       	jmp    80105e7a <alltraps>

80106399 <vector4>:
.globl vector4
vector4:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $4
8010639b:	6a 04                	push   $0x4
  jmp alltraps
8010639d:	e9 d8 fa ff ff       	jmp    80105e7a <alltraps>

801063a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $5
801063a4:	6a 05                	push   $0x5
  jmp alltraps
801063a6:	e9 cf fa ff ff       	jmp    80105e7a <alltraps>

801063ab <vector6>:
.globl vector6
vector6:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $6
801063ad:	6a 06                	push   $0x6
  jmp alltraps
801063af:	e9 c6 fa ff ff       	jmp    80105e7a <alltraps>

801063b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $7
801063b6:	6a 07                	push   $0x7
  jmp alltraps
801063b8:	e9 bd fa ff ff       	jmp    80105e7a <alltraps>

801063bd <vector8>:
.globl vector8
vector8:
  pushl $8
801063bd:	6a 08                	push   $0x8
  jmp alltraps
801063bf:	e9 b6 fa ff ff       	jmp    80105e7a <alltraps>

801063c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $9
801063c6:	6a 09                	push   $0x9
  jmp alltraps
801063c8:	e9 ad fa ff ff       	jmp    80105e7a <alltraps>

801063cd <vector10>:
.globl vector10
vector10:
  pushl $10
801063cd:	6a 0a                	push   $0xa
  jmp alltraps
801063cf:	e9 a6 fa ff ff       	jmp    80105e7a <alltraps>

801063d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063d4:	6a 0b                	push   $0xb
  jmp alltraps
801063d6:	e9 9f fa ff ff       	jmp    80105e7a <alltraps>

801063db <vector12>:
.globl vector12
vector12:
  pushl $12
801063db:	6a 0c                	push   $0xc
  jmp alltraps
801063dd:	e9 98 fa ff ff       	jmp    80105e7a <alltraps>

801063e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801063e2:	6a 0d                	push   $0xd
  jmp alltraps
801063e4:	e9 91 fa ff ff       	jmp    80105e7a <alltraps>

801063e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801063e9:	6a 0e                	push   $0xe
  jmp alltraps
801063eb:	e9 8a fa ff ff       	jmp    80105e7a <alltraps>

801063f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $15
801063f2:	6a 0f                	push   $0xf
  jmp alltraps
801063f4:	e9 81 fa ff ff       	jmp    80105e7a <alltraps>

801063f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $16
801063fb:	6a 10                	push   $0x10
  jmp alltraps
801063fd:	e9 78 fa ff ff       	jmp    80105e7a <alltraps>

80106402 <vector17>:
.globl vector17
vector17:
  pushl $17
80106402:	6a 11                	push   $0x11
  jmp alltraps
80106404:	e9 71 fa ff ff       	jmp    80105e7a <alltraps>

80106409 <vector18>:
.globl vector18
vector18:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $18
8010640b:	6a 12                	push   $0x12
  jmp alltraps
8010640d:	e9 68 fa ff ff       	jmp    80105e7a <alltraps>

80106412 <vector19>:
.globl vector19
vector19:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $19
80106414:	6a 13                	push   $0x13
  jmp alltraps
80106416:	e9 5f fa ff ff       	jmp    80105e7a <alltraps>

8010641b <vector20>:
.globl vector20
vector20:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $20
8010641d:	6a 14                	push   $0x14
  jmp alltraps
8010641f:	e9 56 fa ff ff       	jmp    80105e7a <alltraps>

80106424 <vector21>:
.globl vector21
vector21:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $21
80106426:	6a 15                	push   $0x15
  jmp alltraps
80106428:	e9 4d fa ff ff       	jmp    80105e7a <alltraps>

8010642d <vector22>:
.globl vector22
vector22:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $22
8010642f:	6a 16                	push   $0x16
  jmp alltraps
80106431:	e9 44 fa ff ff       	jmp    80105e7a <alltraps>

80106436 <vector23>:
.globl vector23
vector23:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $23
80106438:	6a 17                	push   $0x17
  jmp alltraps
8010643a:	e9 3b fa ff ff       	jmp    80105e7a <alltraps>

8010643f <vector24>:
.globl vector24
vector24:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $24
80106441:	6a 18                	push   $0x18
  jmp alltraps
80106443:	e9 32 fa ff ff       	jmp    80105e7a <alltraps>

80106448 <vector25>:
.globl vector25
vector25:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $25
8010644a:	6a 19                	push   $0x19
  jmp alltraps
8010644c:	e9 29 fa ff ff       	jmp    80105e7a <alltraps>

80106451 <vector26>:
.globl vector26
vector26:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $26
80106453:	6a 1a                	push   $0x1a
  jmp alltraps
80106455:	e9 20 fa ff ff       	jmp    80105e7a <alltraps>

8010645a <vector27>:
.globl vector27
vector27:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $27
8010645c:	6a 1b                	push   $0x1b
  jmp alltraps
8010645e:	e9 17 fa ff ff       	jmp    80105e7a <alltraps>

80106463 <vector28>:
.globl vector28
vector28:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $28
80106465:	6a 1c                	push   $0x1c
  jmp alltraps
80106467:	e9 0e fa ff ff       	jmp    80105e7a <alltraps>

8010646c <vector29>:
.globl vector29
vector29:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $29
8010646e:	6a 1d                	push   $0x1d
  jmp alltraps
80106470:	e9 05 fa ff ff       	jmp    80105e7a <alltraps>

80106475 <vector30>:
.globl vector30
vector30:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $30
80106477:	6a 1e                	push   $0x1e
  jmp alltraps
80106479:	e9 fc f9 ff ff       	jmp    80105e7a <alltraps>

8010647e <vector31>:
.globl vector31
vector31:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $31
80106480:	6a 1f                	push   $0x1f
  jmp alltraps
80106482:	e9 f3 f9 ff ff       	jmp    80105e7a <alltraps>

80106487 <vector32>:
.globl vector32
vector32:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $32
80106489:	6a 20                	push   $0x20
  jmp alltraps
8010648b:	e9 ea f9 ff ff       	jmp    80105e7a <alltraps>

80106490 <vector33>:
.globl vector33
vector33:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $33
80106492:	6a 21                	push   $0x21
  jmp alltraps
80106494:	e9 e1 f9 ff ff       	jmp    80105e7a <alltraps>

80106499 <vector34>:
.globl vector34
vector34:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $34
8010649b:	6a 22                	push   $0x22
  jmp alltraps
8010649d:	e9 d8 f9 ff ff       	jmp    80105e7a <alltraps>

801064a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $35
801064a4:	6a 23                	push   $0x23
  jmp alltraps
801064a6:	e9 cf f9 ff ff       	jmp    80105e7a <alltraps>

801064ab <vector36>:
.globl vector36
vector36:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $36
801064ad:	6a 24                	push   $0x24
  jmp alltraps
801064af:	e9 c6 f9 ff ff       	jmp    80105e7a <alltraps>

801064b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $37
801064b6:	6a 25                	push   $0x25
  jmp alltraps
801064b8:	e9 bd f9 ff ff       	jmp    80105e7a <alltraps>

801064bd <vector38>:
.globl vector38
vector38:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $38
801064bf:	6a 26                	push   $0x26
  jmp alltraps
801064c1:	e9 b4 f9 ff ff       	jmp    80105e7a <alltraps>

801064c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $39
801064c8:	6a 27                	push   $0x27
  jmp alltraps
801064ca:	e9 ab f9 ff ff       	jmp    80105e7a <alltraps>

801064cf <vector40>:
.globl vector40
vector40:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $40
801064d1:	6a 28                	push   $0x28
  jmp alltraps
801064d3:	e9 a2 f9 ff ff       	jmp    80105e7a <alltraps>

801064d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $41
801064da:	6a 29                	push   $0x29
  jmp alltraps
801064dc:	e9 99 f9 ff ff       	jmp    80105e7a <alltraps>

801064e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $42
801064e3:	6a 2a                	push   $0x2a
  jmp alltraps
801064e5:	e9 90 f9 ff ff       	jmp    80105e7a <alltraps>

801064ea <vector43>:
.globl vector43
vector43:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $43
801064ec:	6a 2b                	push   $0x2b
  jmp alltraps
801064ee:	e9 87 f9 ff ff       	jmp    80105e7a <alltraps>

801064f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $44
801064f5:	6a 2c                	push   $0x2c
  jmp alltraps
801064f7:	e9 7e f9 ff ff       	jmp    80105e7a <alltraps>

801064fc <vector45>:
.globl vector45
vector45:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $45
801064fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106500:	e9 75 f9 ff ff       	jmp    80105e7a <alltraps>

80106505 <vector46>:
.globl vector46
vector46:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $46
80106507:	6a 2e                	push   $0x2e
  jmp alltraps
80106509:	e9 6c f9 ff ff       	jmp    80105e7a <alltraps>

8010650e <vector47>:
.globl vector47
vector47:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $47
80106510:	6a 2f                	push   $0x2f
  jmp alltraps
80106512:	e9 63 f9 ff ff       	jmp    80105e7a <alltraps>

80106517 <vector48>:
.globl vector48
vector48:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $48
80106519:	6a 30                	push   $0x30
  jmp alltraps
8010651b:	e9 5a f9 ff ff       	jmp    80105e7a <alltraps>

80106520 <vector49>:
.globl vector49
vector49:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $49
80106522:	6a 31                	push   $0x31
  jmp alltraps
80106524:	e9 51 f9 ff ff       	jmp    80105e7a <alltraps>

80106529 <vector50>:
.globl vector50
vector50:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $50
8010652b:	6a 32                	push   $0x32
  jmp alltraps
8010652d:	e9 48 f9 ff ff       	jmp    80105e7a <alltraps>

80106532 <vector51>:
.globl vector51
vector51:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $51
80106534:	6a 33                	push   $0x33
  jmp alltraps
80106536:	e9 3f f9 ff ff       	jmp    80105e7a <alltraps>

8010653b <vector52>:
.globl vector52
vector52:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $52
8010653d:	6a 34                	push   $0x34
  jmp alltraps
8010653f:	e9 36 f9 ff ff       	jmp    80105e7a <alltraps>

80106544 <vector53>:
.globl vector53
vector53:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $53
80106546:	6a 35                	push   $0x35
  jmp alltraps
80106548:	e9 2d f9 ff ff       	jmp    80105e7a <alltraps>

8010654d <vector54>:
.globl vector54
vector54:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $54
8010654f:	6a 36                	push   $0x36
  jmp alltraps
80106551:	e9 24 f9 ff ff       	jmp    80105e7a <alltraps>

80106556 <vector55>:
.globl vector55
vector55:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $55
80106558:	6a 37                	push   $0x37
  jmp alltraps
8010655a:	e9 1b f9 ff ff       	jmp    80105e7a <alltraps>

8010655f <vector56>:
.globl vector56
vector56:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $56
80106561:	6a 38                	push   $0x38
  jmp alltraps
80106563:	e9 12 f9 ff ff       	jmp    80105e7a <alltraps>

80106568 <vector57>:
.globl vector57
vector57:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $57
8010656a:	6a 39                	push   $0x39
  jmp alltraps
8010656c:	e9 09 f9 ff ff       	jmp    80105e7a <alltraps>

80106571 <vector58>:
.globl vector58
vector58:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $58
80106573:	6a 3a                	push   $0x3a
  jmp alltraps
80106575:	e9 00 f9 ff ff       	jmp    80105e7a <alltraps>

8010657a <vector59>:
.globl vector59
vector59:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $59
8010657c:	6a 3b                	push   $0x3b
  jmp alltraps
8010657e:	e9 f7 f8 ff ff       	jmp    80105e7a <alltraps>

80106583 <vector60>:
.globl vector60
vector60:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $60
80106585:	6a 3c                	push   $0x3c
  jmp alltraps
80106587:	e9 ee f8 ff ff       	jmp    80105e7a <alltraps>

8010658c <vector61>:
.globl vector61
vector61:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $61
8010658e:	6a 3d                	push   $0x3d
  jmp alltraps
80106590:	e9 e5 f8 ff ff       	jmp    80105e7a <alltraps>

80106595 <vector62>:
.globl vector62
vector62:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $62
80106597:	6a 3e                	push   $0x3e
  jmp alltraps
80106599:	e9 dc f8 ff ff       	jmp    80105e7a <alltraps>

8010659e <vector63>:
.globl vector63
vector63:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $63
801065a0:	6a 3f                	push   $0x3f
  jmp alltraps
801065a2:	e9 d3 f8 ff ff       	jmp    80105e7a <alltraps>

801065a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $64
801065a9:	6a 40                	push   $0x40
  jmp alltraps
801065ab:	e9 ca f8 ff ff       	jmp    80105e7a <alltraps>

801065b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $65
801065b2:	6a 41                	push   $0x41
  jmp alltraps
801065b4:	e9 c1 f8 ff ff       	jmp    80105e7a <alltraps>

801065b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $66
801065bb:	6a 42                	push   $0x42
  jmp alltraps
801065bd:	e9 b8 f8 ff ff       	jmp    80105e7a <alltraps>

801065c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $67
801065c4:	6a 43                	push   $0x43
  jmp alltraps
801065c6:	e9 af f8 ff ff       	jmp    80105e7a <alltraps>

801065cb <vector68>:
.globl vector68
vector68:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $68
801065cd:	6a 44                	push   $0x44
  jmp alltraps
801065cf:	e9 a6 f8 ff ff       	jmp    80105e7a <alltraps>

801065d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $69
801065d6:	6a 45                	push   $0x45
  jmp alltraps
801065d8:	e9 9d f8 ff ff       	jmp    80105e7a <alltraps>

801065dd <vector70>:
.globl vector70
vector70:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $70
801065df:	6a 46                	push   $0x46
  jmp alltraps
801065e1:	e9 94 f8 ff ff       	jmp    80105e7a <alltraps>

801065e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $71
801065e8:	6a 47                	push   $0x47
  jmp alltraps
801065ea:	e9 8b f8 ff ff       	jmp    80105e7a <alltraps>

801065ef <vector72>:
.globl vector72
vector72:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $72
801065f1:	6a 48                	push   $0x48
  jmp alltraps
801065f3:	e9 82 f8 ff ff       	jmp    80105e7a <alltraps>

801065f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $73
801065fa:	6a 49                	push   $0x49
  jmp alltraps
801065fc:	e9 79 f8 ff ff       	jmp    80105e7a <alltraps>

80106601 <vector74>:
.globl vector74
vector74:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $74
80106603:	6a 4a                	push   $0x4a
  jmp alltraps
80106605:	e9 70 f8 ff ff       	jmp    80105e7a <alltraps>

8010660a <vector75>:
.globl vector75
vector75:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $75
8010660c:	6a 4b                	push   $0x4b
  jmp alltraps
8010660e:	e9 67 f8 ff ff       	jmp    80105e7a <alltraps>

80106613 <vector76>:
.globl vector76
vector76:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $76
80106615:	6a 4c                	push   $0x4c
  jmp alltraps
80106617:	e9 5e f8 ff ff       	jmp    80105e7a <alltraps>

8010661c <vector77>:
.globl vector77
vector77:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $77
8010661e:	6a 4d                	push   $0x4d
  jmp alltraps
80106620:	e9 55 f8 ff ff       	jmp    80105e7a <alltraps>

80106625 <vector78>:
.globl vector78
vector78:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $78
80106627:	6a 4e                	push   $0x4e
  jmp alltraps
80106629:	e9 4c f8 ff ff       	jmp    80105e7a <alltraps>

8010662e <vector79>:
.globl vector79
vector79:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $79
80106630:	6a 4f                	push   $0x4f
  jmp alltraps
80106632:	e9 43 f8 ff ff       	jmp    80105e7a <alltraps>

80106637 <vector80>:
.globl vector80
vector80:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $80
80106639:	6a 50                	push   $0x50
  jmp alltraps
8010663b:	e9 3a f8 ff ff       	jmp    80105e7a <alltraps>

80106640 <vector81>:
.globl vector81
vector81:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $81
80106642:	6a 51                	push   $0x51
  jmp alltraps
80106644:	e9 31 f8 ff ff       	jmp    80105e7a <alltraps>

80106649 <vector82>:
.globl vector82
vector82:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $82
8010664b:	6a 52                	push   $0x52
  jmp alltraps
8010664d:	e9 28 f8 ff ff       	jmp    80105e7a <alltraps>

80106652 <vector83>:
.globl vector83
vector83:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $83
80106654:	6a 53                	push   $0x53
  jmp alltraps
80106656:	e9 1f f8 ff ff       	jmp    80105e7a <alltraps>

8010665b <vector84>:
.globl vector84
vector84:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $84
8010665d:	6a 54                	push   $0x54
  jmp alltraps
8010665f:	e9 16 f8 ff ff       	jmp    80105e7a <alltraps>

80106664 <vector85>:
.globl vector85
vector85:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $85
80106666:	6a 55                	push   $0x55
  jmp alltraps
80106668:	e9 0d f8 ff ff       	jmp    80105e7a <alltraps>

8010666d <vector86>:
.globl vector86
vector86:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $86
8010666f:	6a 56                	push   $0x56
  jmp alltraps
80106671:	e9 04 f8 ff ff       	jmp    80105e7a <alltraps>

80106676 <vector87>:
.globl vector87
vector87:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $87
80106678:	6a 57                	push   $0x57
  jmp alltraps
8010667a:	e9 fb f7 ff ff       	jmp    80105e7a <alltraps>

8010667f <vector88>:
.globl vector88
vector88:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $88
80106681:	6a 58                	push   $0x58
  jmp alltraps
80106683:	e9 f2 f7 ff ff       	jmp    80105e7a <alltraps>

80106688 <vector89>:
.globl vector89
vector89:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $89
8010668a:	6a 59                	push   $0x59
  jmp alltraps
8010668c:	e9 e9 f7 ff ff       	jmp    80105e7a <alltraps>

80106691 <vector90>:
.globl vector90
vector90:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $90
80106693:	6a 5a                	push   $0x5a
  jmp alltraps
80106695:	e9 e0 f7 ff ff       	jmp    80105e7a <alltraps>

8010669a <vector91>:
.globl vector91
vector91:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $91
8010669c:	6a 5b                	push   $0x5b
  jmp alltraps
8010669e:	e9 d7 f7 ff ff       	jmp    80105e7a <alltraps>

801066a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $92
801066a5:	6a 5c                	push   $0x5c
  jmp alltraps
801066a7:	e9 ce f7 ff ff       	jmp    80105e7a <alltraps>

801066ac <vector93>:
.globl vector93
vector93:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $93
801066ae:	6a 5d                	push   $0x5d
  jmp alltraps
801066b0:	e9 c5 f7 ff ff       	jmp    80105e7a <alltraps>

801066b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $94
801066b7:	6a 5e                	push   $0x5e
  jmp alltraps
801066b9:	e9 bc f7 ff ff       	jmp    80105e7a <alltraps>

801066be <vector95>:
.globl vector95
vector95:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $95
801066c0:	6a 5f                	push   $0x5f
  jmp alltraps
801066c2:	e9 b3 f7 ff ff       	jmp    80105e7a <alltraps>

801066c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $96
801066c9:	6a 60                	push   $0x60
  jmp alltraps
801066cb:	e9 aa f7 ff ff       	jmp    80105e7a <alltraps>

801066d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $97
801066d2:	6a 61                	push   $0x61
  jmp alltraps
801066d4:	e9 a1 f7 ff ff       	jmp    80105e7a <alltraps>

801066d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $98
801066db:	6a 62                	push   $0x62
  jmp alltraps
801066dd:	e9 98 f7 ff ff       	jmp    80105e7a <alltraps>

801066e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $99
801066e4:	6a 63                	push   $0x63
  jmp alltraps
801066e6:	e9 8f f7 ff ff       	jmp    80105e7a <alltraps>

801066eb <vector100>:
.globl vector100
vector100:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $100
801066ed:	6a 64                	push   $0x64
  jmp alltraps
801066ef:	e9 86 f7 ff ff       	jmp    80105e7a <alltraps>

801066f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $101
801066f6:	6a 65                	push   $0x65
  jmp alltraps
801066f8:	e9 7d f7 ff ff       	jmp    80105e7a <alltraps>

801066fd <vector102>:
.globl vector102
vector102:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $102
801066ff:	6a 66                	push   $0x66
  jmp alltraps
80106701:	e9 74 f7 ff ff       	jmp    80105e7a <alltraps>

80106706 <vector103>:
.globl vector103
vector103:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $103
80106708:	6a 67                	push   $0x67
  jmp alltraps
8010670a:	e9 6b f7 ff ff       	jmp    80105e7a <alltraps>

8010670f <vector104>:
.globl vector104
vector104:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $104
80106711:	6a 68                	push   $0x68
  jmp alltraps
80106713:	e9 62 f7 ff ff       	jmp    80105e7a <alltraps>

80106718 <vector105>:
.globl vector105
vector105:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $105
8010671a:	6a 69                	push   $0x69
  jmp alltraps
8010671c:	e9 59 f7 ff ff       	jmp    80105e7a <alltraps>

80106721 <vector106>:
.globl vector106
vector106:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $106
80106723:	6a 6a                	push   $0x6a
  jmp alltraps
80106725:	e9 50 f7 ff ff       	jmp    80105e7a <alltraps>

8010672a <vector107>:
.globl vector107
vector107:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $107
8010672c:	6a 6b                	push   $0x6b
  jmp alltraps
8010672e:	e9 47 f7 ff ff       	jmp    80105e7a <alltraps>

80106733 <vector108>:
.globl vector108
vector108:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $108
80106735:	6a 6c                	push   $0x6c
  jmp alltraps
80106737:	e9 3e f7 ff ff       	jmp    80105e7a <alltraps>

8010673c <vector109>:
.globl vector109
vector109:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $109
8010673e:	6a 6d                	push   $0x6d
  jmp alltraps
80106740:	e9 35 f7 ff ff       	jmp    80105e7a <alltraps>

80106745 <vector110>:
.globl vector110
vector110:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $110
80106747:	6a 6e                	push   $0x6e
  jmp alltraps
80106749:	e9 2c f7 ff ff       	jmp    80105e7a <alltraps>

8010674e <vector111>:
.globl vector111
vector111:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $111
80106750:	6a 6f                	push   $0x6f
  jmp alltraps
80106752:	e9 23 f7 ff ff       	jmp    80105e7a <alltraps>

80106757 <vector112>:
.globl vector112
vector112:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $112
80106759:	6a 70                	push   $0x70
  jmp alltraps
8010675b:	e9 1a f7 ff ff       	jmp    80105e7a <alltraps>

80106760 <vector113>:
.globl vector113
vector113:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $113
80106762:	6a 71                	push   $0x71
  jmp alltraps
80106764:	e9 11 f7 ff ff       	jmp    80105e7a <alltraps>

80106769 <vector114>:
.globl vector114
vector114:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $114
8010676b:	6a 72                	push   $0x72
  jmp alltraps
8010676d:	e9 08 f7 ff ff       	jmp    80105e7a <alltraps>

80106772 <vector115>:
.globl vector115
vector115:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $115
80106774:	6a 73                	push   $0x73
  jmp alltraps
80106776:	e9 ff f6 ff ff       	jmp    80105e7a <alltraps>

8010677b <vector116>:
.globl vector116
vector116:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $116
8010677d:	6a 74                	push   $0x74
  jmp alltraps
8010677f:	e9 f6 f6 ff ff       	jmp    80105e7a <alltraps>

80106784 <vector117>:
.globl vector117
vector117:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $117
80106786:	6a 75                	push   $0x75
  jmp alltraps
80106788:	e9 ed f6 ff ff       	jmp    80105e7a <alltraps>

8010678d <vector118>:
.globl vector118
vector118:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $118
8010678f:	6a 76                	push   $0x76
  jmp alltraps
80106791:	e9 e4 f6 ff ff       	jmp    80105e7a <alltraps>

80106796 <vector119>:
.globl vector119
vector119:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $119
80106798:	6a 77                	push   $0x77
  jmp alltraps
8010679a:	e9 db f6 ff ff       	jmp    80105e7a <alltraps>

8010679f <vector120>:
.globl vector120
vector120:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $120
801067a1:	6a 78                	push   $0x78
  jmp alltraps
801067a3:	e9 d2 f6 ff ff       	jmp    80105e7a <alltraps>

801067a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $121
801067aa:	6a 79                	push   $0x79
  jmp alltraps
801067ac:	e9 c9 f6 ff ff       	jmp    80105e7a <alltraps>

801067b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $122
801067b3:	6a 7a                	push   $0x7a
  jmp alltraps
801067b5:	e9 c0 f6 ff ff       	jmp    80105e7a <alltraps>

801067ba <vector123>:
.globl vector123
vector123:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $123
801067bc:	6a 7b                	push   $0x7b
  jmp alltraps
801067be:	e9 b7 f6 ff ff       	jmp    80105e7a <alltraps>

801067c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $124
801067c5:	6a 7c                	push   $0x7c
  jmp alltraps
801067c7:	e9 ae f6 ff ff       	jmp    80105e7a <alltraps>

801067cc <vector125>:
.globl vector125
vector125:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $125
801067ce:	6a 7d                	push   $0x7d
  jmp alltraps
801067d0:	e9 a5 f6 ff ff       	jmp    80105e7a <alltraps>

801067d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $126
801067d7:	6a 7e                	push   $0x7e
  jmp alltraps
801067d9:	e9 9c f6 ff ff       	jmp    80105e7a <alltraps>

801067de <vector127>:
.globl vector127
vector127:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $127
801067e0:	6a 7f                	push   $0x7f
  jmp alltraps
801067e2:	e9 93 f6 ff ff       	jmp    80105e7a <alltraps>

801067e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $128
801067e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067ee:	e9 87 f6 ff ff       	jmp    80105e7a <alltraps>

801067f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $129
801067f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801067fa:	e9 7b f6 ff ff       	jmp    80105e7a <alltraps>

801067ff <vector130>:
.globl vector130
vector130:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $130
80106801:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106806:	e9 6f f6 ff ff       	jmp    80105e7a <alltraps>

8010680b <vector131>:
.globl vector131
vector131:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $131
8010680d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106812:	e9 63 f6 ff ff       	jmp    80105e7a <alltraps>

80106817 <vector132>:
.globl vector132
vector132:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $132
80106819:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010681e:	e9 57 f6 ff ff       	jmp    80105e7a <alltraps>

80106823 <vector133>:
.globl vector133
vector133:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $133
80106825:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010682a:	e9 4b f6 ff ff       	jmp    80105e7a <alltraps>

8010682f <vector134>:
.globl vector134
vector134:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $134
80106831:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106836:	e9 3f f6 ff ff       	jmp    80105e7a <alltraps>

8010683b <vector135>:
.globl vector135
vector135:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $135
8010683d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106842:	e9 33 f6 ff ff       	jmp    80105e7a <alltraps>

80106847 <vector136>:
.globl vector136
vector136:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $136
80106849:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010684e:	e9 27 f6 ff ff       	jmp    80105e7a <alltraps>

80106853 <vector137>:
.globl vector137
vector137:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $137
80106855:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010685a:	e9 1b f6 ff ff       	jmp    80105e7a <alltraps>

8010685f <vector138>:
.globl vector138
vector138:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $138
80106861:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106866:	e9 0f f6 ff ff       	jmp    80105e7a <alltraps>

8010686b <vector139>:
.globl vector139
vector139:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $139
8010686d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106872:	e9 03 f6 ff ff       	jmp    80105e7a <alltraps>

80106877 <vector140>:
.globl vector140
vector140:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $140
80106879:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010687e:	e9 f7 f5 ff ff       	jmp    80105e7a <alltraps>

80106883 <vector141>:
.globl vector141
vector141:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $141
80106885:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010688a:	e9 eb f5 ff ff       	jmp    80105e7a <alltraps>

8010688f <vector142>:
.globl vector142
vector142:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $142
80106891:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106896:	e9 df f5 ff ff       	jmp    80105e7a <alltraps>

8010689b <vector143>:
.globl vector143
vector143:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $143
8010689d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068a2:	e9 d3 f5 ff ff       	jmp    80105e7a <alltraps>

801068a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $144
801068a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068ae:	e9 c7 f5 ff ff       	jmp    80105e7a <alltraps>

801068b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $145
801068b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068ba:	e9 bb f5 ff ff       	jmp    80105e7a <alltraps>

801068bf <vector146>:
.globl vector146
vector146:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $146
801068c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068c6:	e9 af f5 ff ff       	jmp    80105e7a <alltraps>

801068cb <vector147>:
.globl vector147
vector147:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $147
801068cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068d2:	e9 a3 f5 ff ff       	jmp    80105e7a <alltraps>

801068d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $148
801068d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068de:	e9 97 f5 ff ff       	jmp    80105e7a <alltraps>

801068e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $149
801068e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068ea:	e9 8b f5 ff ff       	jmp    80105e7a <alltraps>

801068ef <vector150>:
.globl vector150
vector150:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $150
801068f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801068f6:	e9 7f f5 ff ff       	jmp    80105e7a <alltraps>

801068fb <vector151>:
.globl vector151
vector151:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $151
801068fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106902:	e9 73 f5 ff ff       	jmp    80105e7a <alltraps>

80106907 <vector152>:
.globl vector152
vector152:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $152
80106909:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010690e:	e9 67 f5 ff ff       	jmp    80105e7a <alltraps>

80106913 <vector153>:
.globl vector153
vector153:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $153
80106915:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010691a:	e9 5b f5 ff ff       	jmp    80105e7a <alltraps>

8010691f <vector154>:
.globl vector154
vector154:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $154
80106921:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106926:	e9 4f f5 ff ff       	jmp    80105e7a <alltraps>

8010692b <vector155>:
.globl vector155
vector155:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $155
8010692d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106932:	e9 43 f5 ff ff       	jmp    80105e7a <alltraps>

80106937 <vector156>:
.globl vector156
vector156:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $156
80106939:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010693e:	e9 37 f5 ff ff       	jmp    80105e7a <alltraps>

80106943 <vector157>:
.globl vector157
vector157:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $157
80106945:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010694a:	e9 2b f5 ff ff       	jmp    80105e7a <alltraps>

8010694f <vector158>:
.globl vector158
vector158:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $158
80106951:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106956:	e9 1f f5 ff ff       	jmp    80105e7a <alltraps>

8010695b <vector159>:
.globl vector159
vector159:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $159
8010695d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106962:	e9 13 f5 ff ff       	jmp    80105e7a <alltraps>

80106967 <vector160>:
.globl vector160
vector160:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $160
80106969:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010696e:	e9 07 f5 ff ff       	jmp    80105e7a <alltraps>

80106973 <vector161>:
.globl vector161
vector161:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $161
80106975:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010697a:	e9 fb f4 ff ff       	jmp    80105e7a <alltraps>

8010697f <vector162>:
.globl vector162
vector162:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $162
80106981:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106986:	e9 ef f4 ff ff       	jmp    80105e7a <alltraps>

8010698b <vector163>:
.globl vector163
vector163:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $163
8010698d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106992:	e9 e3 f4 ff ff       	jmp    80105e7a <alltraps>

80106997 <vector164>:
.globl vector164
vector164:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $164
80106999:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010699e:	e9 d7 f4 ff ff       	jmp    80105e7a <alltraps>

801069a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $165
801069a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069aa:	e9 cb f4 ff ff       	jmp    80105e7a <alltraps>

801069af <vector166>:
.globl vector166
vector166:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $166
801069b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069b6:	e9 bf f4 ff ff       	jmp    80105e7a <alltraps>

801069bb <vector167>:
.globl vector167
vector167:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $167
801069bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069c2:	e9 b3 f4 ff ff       	jmp    80105e7a <alltraps>

801069c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $168
801069c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069ce:	e9 a7 f4 ff ff       	jmp    80105e7a <alltraps>

801069d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $169
801069d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069da:	e9 9b f4 ff ff       	jmp    80105e7a <alltraps>

801069df <vector170>:
.globl vector170
vector170:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $170
801069e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069e6:	e9 8f f4 ff ff       	jmp    80105e7a <alltraps>

801069eb <vector171>:
.globl vector171
vector171:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $171
801069ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801069f2:	e9 83 f4 ff ff       	jmp    80105e7a <alltraps>

801069f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $172
801069f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801069fe:	e9 77 f4 ff ff       	jmp    80105e7a <alltraps>

80106a03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $173
80106a05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a0a:	e9 6b f4 ff ff       	jmp    80105e7a <alltraps>

80106a0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $174
80106a11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a16:	e9 5f f4 ff ff       	jmp    80105e7a <alltraps>

80106a1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $175
80106a1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a22:	e9 53 f4 ff ff       	jmp    80105e7a <alltraps>

80106a27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $176
80106a29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a2e:	e9 47 f4 ff ff       	jmp    80105e7a <alltraps>

80106a33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $177
80106a35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a3a:	e9 3b f4 ff ff       	jmp    80105e7a <alltraps>

80106a3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $178
80106a41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a46:	e9 2f f4 ff ff       	jmp    80105e7a <alltraps>

80106a4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $179
80106a4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a52:	e9 23 f4 ff ff       	jmp    80105e7a <alltraps>

80106a57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $180
80106a59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a5e:	e9 17 f4 ff ff       	jmp    80105e7a <alltraps>

80106a63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $181
80106a65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a6a:	e9 0b f4 ff ff       	jmp    80105e7a <alltraps>

80106a6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $182
80106a71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a76:	e9 ff f3 ff ff       	jmp    80105e7a <alltraps>

80106a7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $183
80106a7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a82:	e9 f3 f3 ff ff       	jmp    80105e7a <alltraps>

80106a87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $184
80106a89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a8e:	e9 e7 f3 ff ff       	jmp    80105e7a <alltraps>

80106a93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $185
80106a95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a9a:	e9 db f3 ff ff       	jmp    80105e7a <alltraps>

80106a9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $186
80106aa1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106aa6:	e9 cf f3 ff ff       	jmp    80105e7a <alltraps>

80106aab <vector187>:
.globl vector187
vector187:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $187
80106aad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ab2:	e9 c3 f3 ff ff       	jmp    80105e7a <alltraps>

80106ab7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $188
80106ab9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106abe:	e9 b7 f3 ff ff       	jmp    80105e7a <alltraps>

80106ac3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $189
80106ac5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106aca:	e9 ab f3 ff ff       	jmp    80105e7a <alltraps>

80106acf <vector190>:
.globl vector190
vector190:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $190
80106ad1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ad6:	e9 9f f3 ff ff       	jmp    80105e7a <alltraps>

80106adb <vector191>:
.globl vector191
vector191:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $191
80106add:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ae2:	e9 93 f3 ff ff       	jmp    80105e7a <alltraps>

80106ae7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $192
80106ae9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106aee:	e9 87 f3 ff ff       	jmp    80105e7a <alltraps>

80106af3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $193
80106af5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106afa:	e9 7b f3 ff ff       	jmp    80105e7a <alltraps>

80106aff <vector194>:
.globl vector194
vector194:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $194
80106b01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b06:	e9 6f f3 ff ff       	jmp    80105e7a <alltraps>

80106b0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $195
80106b0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b12:	e9 63 f3 ff ff       	jmp    80105e7a <alltraps>

80106b17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $196
80106b19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b1e:	e9 57 f3 ff ff       	jmp    80105e7a <alltraps>

80106b23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $197
80106b25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b2a:	e9 4b f3 ff ff       	jmp    80105e7a <alltraps>

80106b2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $198
80106b31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b36:	e9 3f f3 ff ff       	jmp    80105e7a <alltraps>

80106b3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $199
80106b3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b42:	e9 33 f3 ff ff       	jmp    80105e7a <alltraps>

80106b47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $200
80106b49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b4e:	e9 27 f3 ff ff       	jmp    80105e7a <alltraps>

80106b53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $201
80106b55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b5a:	e9 1b f3 ff ff       	jmp    80105e7a <alltraps>

80106b5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $202
80106b61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b66:	e9 0f f3 ff ff       	jmp    80105e7a <alltraps>

80106b6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $203
80106b6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b72:	e9 03 f3 ff ff       	jmp    80105e7a <alltraps>

80106b77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $204
80106b79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b7e:	e9 f7 f2 ff ff       	jmp    80105e7a <alltraps>

80106b83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $205
80106b85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b8a:	e9 eb f2 ff ff       	jmp    80105e7a <alltraps>

80106b8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $206
80106b91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b96:	e9 df f2 ff ff       	jmp    80105e7a <alltraps>

80106b9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $207
80106b9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ba2:	e9 d3 f2 ff ff       	jmp    80105e7a <alltraps>

80106ba7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $208
80106ba9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bae:	e9 c7 f2 ff ff       	jmp    80105e7a <alltraps>

80106bb3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $209
80106bb5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bba:	e9 bb f2 ff ff       	jmp    80105e7a <alltraps>

80106bbf <vector210>:
.globl vector210
vector210:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $210
80106bc1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106bc6:	e9 af f2 ff ff       	jmp    80105e7a <alltraps>

80106bcb <vector211>:
.globl vector211
vector211:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $211
80106bcd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106bd2:	e9 a3 f2 ff ff       	jmp    80105e7a <alltraps>

80106bd7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $212
80106bd9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bde:	e9 97 f2 ff ff       	jmp    80105e7a <alltraps>

80106be3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $213
80106be5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bea:	e9 8b f2 ff ff       	jmp    80105e7a <alltraps>

80106bef <vector214>:
.globl vector214
vector214:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $214
80106bf1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106bf6:	e9 7f f2 ff ff       	jmp    80105e7a <alltraps>

80106bfb <vector215>:
.globl vector215
vector215:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $215
80106bfd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c02:	e9 73 f2 ff ff       	jmp    80105e7a <alltraps>

80106c07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $216
80106c09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c0e:	e9 67 f2 ff ff       	jmp    80105e7a <alltraps>

80106c13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $217
80106c15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c1a:	e9 5b f2 ff ff       	jmp    80105e7a <alltraps>

80106c1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $218
80106c21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c26:	e9 4f f2 ff ff       	jmp    80105e7a <alltraps>

80106c2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $219
80106c2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c32:	e9 43 f2 ff ff       	jmp    80105e7a <alltraps>

80106c37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $220
80106c39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c3e:	e9 37 f2 ff ff       	jmp    80105e7a <alltraps>

80106c43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $221
80106c45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c4a:	e9 2b f2 ff ff       	jmp    80105e7a <alltraps>

80106c4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $222
80106c51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c56:	e9 1f f2 ff ff       	jmp    80105e7a <alltraps>

80106c5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $223
80106c5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c62:	e9 13 f2 ff ff       	jmp    80105e7a <alltraps>

80106c67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $224
80106c69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c6e:	e9 07 f2 ff ff       	jmp    80105e7a <alltraps>

80106c73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $225
80106c75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c7a:	e9 fb f1 ff ff       	jmp    80105e7a <alltraps>

80106c7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $226
80106c81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c86:	e9 ef f1 ff ff       	jmp    80105e7a <alltraps>

80106c8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $227
80106c8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c92:	e9 e3 f1 ff ff       	jmp    80105e7a <alltraps>

80106c97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $228
80106c99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c9e:	e9 d7 f1 ff ff       	jmp    80105e7a <alltraps>

80106ca3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $229
80106ca5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106caa:	e9 cb f1 ff ff       	jmp    80105e7a <alltraps>

80106caf <vector230>:
.globl vector230
vector230:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $230
80106cb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cb6:	e9 bf f1 ff ff       	jmp    80105e7a <alltraps>

80106cbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $231
80106cbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106cc2:	e9 b3 f1 ff ff       	jmp    80105e7a <alltraps>

80106cc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $232
80106cc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cce:	e9 a7 f1 ff ff       	jmp    80105e7a <alltraps>

80106cd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $233
80106cd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cda:	e9 9b f1 ff ff       	jmp    80105e7a <alltraps>

80106cdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $234
80106ce1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ce6:	e9 8f f1 ff ff       	jmp    80105e7a <alltraps>

80106ceb <vector235>:
.globl vector235
vector235:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $235
80106ced:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106cf2:	e9 83 f1 ff ff       	jmp    80105e7a <alltraps>

80106cf7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $236
80106cf9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106cfe:	e9 77 f1 ff ff       	jmp    80105e7a <alltraps>

80106d03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $237
80106d05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d0a:	e9 6b f1 ff ff       	jmp    80105e7a <alltraps>

80106d0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $238
80106d11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d16:	e9 5f f1 ff ff       	jmp    80105e7a <alltraps>

80106d1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $239
80106d1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d22:	e9 53 f1 ff ff       	jmp    80105e7a <alltraps>

80106d27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $240
80106d29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d2e:	e9 47 f1 ff ff       	jmp    80105e7a <alltraps>

80106d33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $241
80106d35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d3a:	e9 3b f1 ff ff       	jmp    80105e7a <alltraps>

80106d3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $242
80106d41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d46:	e9 2f f1 ff ff       	jmp    80105e7a <alltraps>

80106d4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $243
80106d4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d52:	e9 23 f1 ff ff       	jmp    80105e7a <alltraps>

80106d57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $244
80106d59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d5e:	e9 17 f1 ff ff       	jmp    80105e7a <alltraps>

80106d63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $245
80106d65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d6a:	e9 0b f1 ff ff       	jmp    80105e7a <alltraps>

80106d6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $246
80106d71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d76:	e9 ff f0 ff ff       	jmp    80105e7a <alltraps>

80106d7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $247
80106d7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d82:	e9 f3 f0 ff ff       	jmp    80105e7a <alltraps>

80106d87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $248
80106d89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d8e:	e9 e7 f0 ff ff       	jmp    80105e7a <alltraps>

80106d93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $249
80106d95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d9a:	e9 db f0 ff ff       	jmp    80105e7a <alltraps>

80106d9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $250
80106da1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106da6:	e9 cf f0 ff ff       	jmp    80105e7a <alltraps>

80106dab <vector251>:
.globl vector251
vector251:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $251
80106dad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106db2:	e9 c3 f0 ff ff       	jmp    80105e7a <alltraps>

80106db7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $252
80106db9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dbe:	e9 b7 f0 ff ff       	jmp    80105e7a <alltraps>

80106dc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $253
80106dc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dca:	e9 ab f0 ff ff       	jmp    80105e7a <alltraps>

80106dcf <vector254>:
.globl vector254
vector254:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $254
80106dd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106dd6:	e9 9f f0 ff ff       	jmp    80105e7a <alltraps>

80106ddb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $255
80106ddd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106de2:	e9 93 f0 ff ff       	jmp    80105e7a <alltraps>
80106de7:	66 90                	xchg   %ax,%ax
80106de9:	66 90                	xchg   %ax,%ax
80106deb:	66 90                	xchg   %ax,%ax
80106ded:	66 90                	xchg   %ax,%ax
80106def:	90                   	nop

80106df0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106df6:	89 d3                	mov    %edx,%ebx
{
80106df8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106dfa:	c1 eb 16             	shr    $0x16,%ebx
80106dfd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e00:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e03:	8b 06                	mov    (%esi),%eax
80106e05:	a8 01                	test   $0x1,%al
80106e07:	74 27                	je     80106e30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e14:	c1 ef 0a             	shr    $0xa,%edi
}
80106e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e1a:	89 fa                	mov    %edi,%edx
80106e1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e30:	85 c9                	test   %ecx,%ecx
80106e32:	74 2c                	je     80106e60 <walkpgdir+0x70>
80106e34:	e8 57 bc ff ff       	call   80102a90 <kalloc>
80106e39:	85 c0                	test   %eax,%eax
80106e3b:	89 c3                	mov    %eax,%ebx
80106e3d:	74 21                	je     80106e60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e3f:	83 ec 04             	sub    $0x4,%esp
80106e42:	68 00 10 00 00       	push   $0x1000
80106e47:	6a 00                	push   $0x0
80106e49:	50                   	push   %eax
80106e4a:	e8 11 de ff ff       	call   80104c60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e55:	83 c4 10             	add    $0x10,%esp
80106e58:	83 c8 07             	or     $0x7,%eax
80106e5b:	89 06                	mov    %eax,(%esi)
80106e5d:	eb b5                	jmp    80106e14 <walkpgdir+0x24>
80106e5f:	90                   	nop
}
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e63:	31 c0                	xor    %eax,%eax
}
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e76:	89 d3                	mov    %edx,%ebx
80106e78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e7e:	83 ec 1c             	sub    $0x1c,%esp
80106e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e96:	29 df                	sub    %ebx,%edi
80106e98:	83 c8 01             	or     $0x1,%eax
80106e9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e9e:	eb 15                	jmp    80106eb5 <mappages+0x45>
    if(*pte & PTE_P)
80106ea0:	f6 00 01             	testb  $0x1,(%eax)
80106ea3:	75 45                	jne    80106eea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ea5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ea8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106eab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ead:	74 31                	je     80106ee0 <mappages+0x70>
      break;
    a += PGSIZE;
80106eaf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ebd:	89 da                	mov    %ebx,%edx
80106ebf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ec2:	e8 29 ff ff ff       	call   80106df0 <walkpgdir>
80106ec7:	85 c0                	test   %eax,%eax
80106ec9:	75 d5                	jne    80106ea0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ed3:	5b                   	pop    %ebx
80106ed4:	5e                   	pop    %esi
80106ed5:	5f                   	pop    %edi
80106ed6:	5d                   	pop    %ebp
80106ed7:	c3                   	ret    
80106ed8:	90                   	nop
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
      panic("remap");
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	68 48 89 10 80       	push   $0x80108948
80106ef2:	e8 99 94 ff ff       	call   80100390 <panic>
80106ef7:	89 f6                	mov    %esi,%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <seginit>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f06:	e8 05 cf ff ff       	call   80103e10 <cpuid>
80106f0b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f11:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f1a:	c7 80 18 d8 14 80 ff 	movl   $0xffff,-0x7feb27e8(%eax)
80106f21:	ff 00 00 
80106f24:	c7 80 1c d8 14 80 00 	movl   $0xcf9a00,-0x7feb27e4(%eax)
80106f2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f2e:	c7 80 20 d8 14 80 ff 	movl   $0xffff,-0x7feb27e0(%eax)
80106f35:	ff 00 00 
80106f38:	c7 80 24 d8 14 80 00 	movl   $0xcf9200,-0x7feb27dc(%eax)
80106f3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f42:	c7 80 28 d8 14 80 ff 	movl   $0xffff,-0x7feb27d8(%eax)
80106f49:	ff 00 00 
80106f4c:	c7 80 2c d8 14 80 00 	movl   $0xcffa00,-0x7feb27d4(%eax)
80106f53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f56:	c7 80 30 d8 14 80 ff 	movl   $0xffff,-0x7feb27d0(%eax)
80106f5d:	ff 00 00 
80106f60:	c7 80 34 d8 14 80 00 	movl   $0xcff200,-0x7feb27cc(%eax)
80106f67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f6a:	05 10 d8 14 80       	add    $0x8014d810,%eax
  pd[1] = (uint)p;
80106f6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f73:	c1 e8 10             	shr    $0x10,%eax
80106f76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f7d:	0f 01 10             	lgdtl  (%eax)
}
80106f80:	c9                   	leave  
80106f81:	c3                   	ret    
80106f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f90:	a1 c4 86 15 80       	mov    0x801586c4,%eax
{
80106f95:	55                   	push   %ebp
80106f96:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f98:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f9d:	0f 22 d8             	mov    %eax,%cr3
}
80106fa0:	5d                   	pop    %ebp
80106fa1:	c3                   	ret    
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106fbc:	85 db                	test   %ebx,%ebx
80106fbe:	0f 84 cb 00 00 00    	je     8010708f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106fc4:	8b 43 08             	mov    0x8(%ebx),%eax
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	0f 84 da 00 00 00    	je     801070a9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106fcf:	8b 43 04             	mov    0x4(%ebx),%eax
80106fd2:	85 c0                	test   %eax,%eax
80106fd4:	0f 84 c2 00 00 00    	je     8010709c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106fda:	e8 a1 da ff ff       	call   80104a80 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fdf:	e8 ac cd ff ff       	call   80103d90 <mycpu>
80106fe4:	89 c6                	mov    %eax,%esi
80106fe6:	e8 a5 cd ff ff       	call   80103d90 <mycpu>
80106feb:	89 c7                	mov    %eax,%edi
80106fed:	e8 9e cd ff ff       	call   80103d90 <mycpu>
80106ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ff5:	83 c7 08             	add    $0x8,%edi
80106ff8:	e8 93 cd ff ff       	call   80103d90 <mycpu>
80106ffd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107000:	83 c0 08             	add    $0x8,%eax
80107003:	ba 67 00 00 00       	mov    $0x67,%edx
80107008:	c1 e8 18             	shr    $0x18,%eax
8010700b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107012:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107019:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010701f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107024:	83 c1 08             	add    $0x8,%ecx
80107027:	c1 e9 10             	shr    $0x10,%ecx
8010702a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107030:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107035:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010703c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107041:	e8 4a cd ff ff       	call   80103d90 <mycpu>
80107046:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010704d:	e8 3e cd ff ff       	call   80103d90 <mycpu>
80107052:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107056:	8b 73 08             	mov    0x8(%ebx),%esi
80107059:	e8 32 cd ff ff       	call   80103d90 <mycpu>
8010705e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107064:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107067:	e8 24 cd ff ff       	call   80103d90 <mycpu>
8010706c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107070:	b8 28 00 00 00       	mov    $0x28,%eax
80107075:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107078:	8b 43 04             	mov    0x4(%ebx),%eax
8010707b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107080:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	5e                   	pop    %esi
80107088:	5f                   	pop    %edi
80107089:	5d                   	pop    %ebp
  popcli();
8010708a:	e9 31 da ff ff       	jmp    80104ac0 <popcli>
    panic("switchuvm: no process");
8010708f:	83 ec 0c             	sub    $0xc,%esp
80107092:	68 4e 89 10 80       	push   $0x8010894e
80107097:	e8 f4 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	68 79 89 10 80       	push   $0x80108979
801070a4:	e8 e7 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801070a9:	83 ec 0c             	sub    $0xc,%esp
801070ac:	68 64 89 10 80       	push   $0x80108964
801070b1:	e8 da 92 ff ff       	call   80100390 <panic>
801070b6:	8d 76 00             	lea    0x0(%esi),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 75 10             	mov    0x10(%ebp),%esi
801070cc:	8b 45 08             	mov    0x8(%ebp),%eax
801070cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801070d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801070d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070db:	77 49                	ja     80107126 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801070dd:	e8 ae b9 ff ff       	call   80102a90 <kalloc>
  memset(mem, 0, PGSIZE);
801070e2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801070e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070e7:	68 00 10 00 00       	push   $0x1000
801070ec:	6a 00                	push   $0x0
801070ee:	50                   	push   %eax
801070ef:	e8 6c db ff ff       	call   80104c60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070f4:	58                   	pop    %eax
801070f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107100:	5a                   	pop    %edx
80107101:	6a 06                	push   $0x6
80107103:	50                   	push   %eax
80107104:	31 d2                	xor    %edx,%edx
80107106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107109:	e8 62 fd ff ff       	call   80106e70 <mappages>
  memmove(mem, init, sz);
8010710e:	89 75 10             	mov    %esi,0x10(%ebp)
80107111:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107114:	83 c4 10             	add    $0x10,%esp
80107117:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010711a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107121:	e9 ea db ff ff       	jmp    80104d10 <memmove>
    panic("inituvm: more than a page");
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 8d 89 10 80       	push   $0x8010898d
8010712e:	e8 5d 92 ff ff       	call   80100390 <panic>
80107133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107149:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107150:	0f 85 91 00 00 00    	jne    801071e7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107156:	8b 75 18             	mov    0x18(%ebp),%esi
80107159:	31 db                	xor    %ebx,%ebx
8010715b:	85 f6                	test   %esi,%esi
8010715d:	75 1a                	jne    80107179 <loaduvm+0x39>
8010715f:	eb 6f                	jmp    801071d0 <loaduvm+0x90>
80107161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107168:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010716e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107174:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107177:	76 57                	jbe    801071d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010717c:	8b 45 08             	mov    0x8(%ebp),%eax
8010717f:	31 c9                	xor    %ecx,%ecx
80107181:	01 da                	add    %ebx,%edx
80107183:	e8 68 fc ff ff       	call   80106df0 <walkpgdir>
80107188:	85 c0                	test   %eax,%eax
8010718a:	74 4e                	je     801071da <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010718c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010718e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107191:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010719b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071a1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071a4:	01 d9                	add    %ebx,%ecx
801071a6:	05 00 00 00 80       	add    $0x80000000,%eax
801071ab:	57                   	push   %edi
801071ac:	51                   	push   %ecx
801071ad:	50                   	push   %eax
801071ae:	ff 75 10             	pushl  0x10(%ebp)
801071b1:	e8 ea a7 ff ff       	call   801019a0 <readi>
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	39 f8                	cmp    %edi,%eax
801071bb:	74 ab                	je     80107168 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071d3:	31 c0                	xor    %eax,%eax
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801071da:	83 ec 0c             	sub    $0xc,%esp
801071dd:	68 a7 89 10 80       	push   $0x801089a7
801071e2:	e8 a9 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801071e7:	83 ec 0c             	sub    $0xc,%esp
801071ea:	68 78 8a 10 80       	push   $0x80108a78
801071ef:	e8 9c 91 ff ff       	call   80100390 <panic>
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <find_pa>:

// find physical address by virtual address
int
find_pa(pde_t *pgdir, int va)
{
80107200:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107201:	31 c9                	xor    %ecx,%ecx
{
80107203:	89 e5                	mov    %esp,%ebp
80107205:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107208:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720b:	8b 45 08             	mov    0x8(%ebp),%eax
8010720e:	e8 dd fb ff ff       	call   80106df0 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
80107213:	85 c0                	test   %eax,%eax
80107215:	74 09                	je     80107220 <find_pa+0x20>
80107217:	8b 00                	mov    (%eax),%eax
}
80107219:	c9                   	leave  
  return !pte ? -1 : PTE_ADDR(*pte);
8010721a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
8010721f:	c3                   	ret    
  return !pte ? -1 : PTE_ADDR(*pte);
80107220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107225:	c9                   	leave  
80107226:	c3                   	ret    
80107227:	89 f6                	mov    %esi,%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <next_i_in_mem_to_remove>:

// find next page to remove from memory
int
next_i_in_mem_to_remove(struct proc *p)
{
80107230:	55                   	push   %ebp
  return 0;
}
80107231:	31 c0                	xor    %eax,%eax
{
80107233:	89 e5                	mov    %esp,%ebp
}
80107235:	5d                   	pop    %ebp
80107236:	c3                   	ret    
80107237:	89 f6                	mov    %esi,%esi
80107239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107240 <next_free_i_in_mem>:

// find free space in ram
int
next_free_i_in_mem(struct proc *p)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	8b 45 08             	mov    0x8(%ebp),%eax
80107246:	8d 90 8c 01 00 00    	lea    0x18c(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010724c:	31 c0                	xor    %eax,%eax
8010724e:	eb 0b                	jmp    8010725b <next_free_i_in_mem+0x1b>
80107250:	83 c0 01             	add    $0x1,%eax
80107253:	83 c2 10             	add    $0x10,%edx
80107256:	83 f8 10             	cmp    $0x10,%eax
80107259:	74 0d                	je     80107268 <next_free_i_in_mem+0x28>
    if (!p->memory_pages[i].is_used)
8010725b:	8b 0a                	mov    (%edx),%ecx
8010725d:	85 c9                	test   %ecx,%ecx
8010725f:	75 ef                	jne    80107250 <next_free_i_in_mem+0x10>
      return i;
  }
  return -1;
}
80107261:	5d                   	pop    %ebp
80107262:	c3                   	ret    
80107263:	90                   	nop
80107264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010726d:	5d                   	pop    %ebp
8010726e:	c3                   	ret    
8010726f:	90                   	nop

80107270 <get_i_of_va_in_mem>:

// find index of va in mem
int
get_i_of_va_in_mem(struct proc *p, uint va)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	8b 45 08             	mov    0x8(%ebp),%eax
80107276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107279:	8d 90 84 01 00 00    	lea    0x184(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010727f:	31 c0                	xor    %eax,%eax
80107281:	eb 10                	jmp    80107293 <get_i_of_va_in_mem+0x23>
80107283:	90                   	nop
80107284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107288:	83 c0 01             	add    $0x1,%eax
8010728b:	83 c2 10             	add    $0x10,%edx
8010728e:	83 f8 10             	cmp    $0x10,%eax
80107291:	74 0d                	je     801072a0 <get_i_of_va_in_mem+0x30>
    if (p->memory_pages[i].va == va)
80107293:	39 0a                	cmp    %ecx,(%edx)
80107295:	75 f1                	jne    80107288 <get_i_of_va_in_mem+0x18>
      return i;
  }
  return -1;
}
80107297:	5d                   	pop    %ebp
80107298:	c3                   	ret    
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
801072a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072a5:	5d                   	pop    %ebp
801072a6:	c3                   	ret    
801072a7:	89 f6                	mov    %esi,%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <next_free_i_in_file>:

// find free space in file
int
next_free_i_in_file(struct proc *p)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	8b 45 08             	mov    0x8(%ebp),%eax
801072b6:	8d 90 8c 00 00 00    	lea    0x8c(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801072bc:	31 c0                	xor    %eax,%eax
801072be:	eb 0b                	jmp    801072cb <next_free_i_in_file+0x1b>
801072c0:	83 c0 01             	add    $0x1,%eax
801072c3:	83 c2 10             	add    $0x10,%edx
801072c6:	83 f8 10             	cmp    $0x10,%eax
801072c9:	74 0d                	je     801072d8 <next_free_i_in_file+0x28>
    if (!p->file_pages[i].is_used)
801072cb:	8b 0a                	mov    (%edx),%ecx
801072cd:	85 c9                	test   %ecx,%ecx
801072cf:	75 ef                	jne    801072c0 <next_free_i_in_file+0x10>
      return i;
  }
  return -1;
}
801072d1:	5d                   	pop    %ebp
801072d2:	c3                   	ret    
801072d3:	90                   	nop
801072d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
801072d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072dd:	5d                   	pop    %ebp
801072de:	c3                   	ret    
801072df:	90                   	nop

801072e0 <get_i_of_va_in_file>:

// find index of va in file
int
get_i_of_va_in_file(struct proc *p, uint va)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	8b 45 08             	mov    0x8(%ebp),%eax
801072e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072e9:	8d 90 84 00 00 00    	lea    0x84(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801072ef:	31 c0                	xor    %eax,%eax
801072f1:	eb 10                	jmp    80107303 <get_i_of_va_in_file+0x23>
801072f3:	90                   	nop
801072f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072f8:	83 c0 01             	add    $0x1,%eax
801072fb:	83 c2 10             	add    $0x10,%edx
801072fe:	83 f8 10             	cmp    $0x10,%eax
80107301:	74 0d                	je     80107310 <get_i_of_va_in_file+0x30>
    if (p->file_pages[i].va == va)
80107303:	39 0a                	cmp    %ecx,(%edx)
80107305:	75 f1                	jne    801072f8 <get_i_of_va_in_file+0x18>
      return i;
  }
  return -1;
}
80107307:	5d                   	pop    %ebp
80107308:	c3                   	ret    
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107315:	5d                   	pop    %ebp
80107316:	c3                   	ret    
80107317:	89 f6                	mov    %esi,%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <set_page_flags_in_mem>:

void
set_page_flags_in_mem(pde_t *pgdir, uint va, uint pa)
{
80107320:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107321:	31 c9                	xor    %ecx,%ecx
{
80107323:	89 e5                	mov    %esp,%ebp
80107325:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732b:	8b 45 08             	mov    0x8(%ebp),%eax
8010732e:	e8 bd fa ff ff       	call   80106df0 <walkpgdir>
  if (!pte)
80107333:	85 c0                	test   %eax,%eax
80107335:	74 11                	je     80107348 <set_page_flags_in_mem+0x28>
    panic("failed setting PTE flags when handling trap\n");
  
  *pte |= PTE_P | PTE_W | PTE_U;   // PTE is in mem, writable and user's
  *pte &= ~PTE_PG;   // PTE is NOT in disk
  *pte |= pa;
80107337:	8b 10                	mov    (%eax),%edx
80107339:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010733c:	80 e6 fd             	and    $0xfd,%dh
8010733f:	83 c9 07             	or     $0x7,%ecx
80107342:	09 ca                	or     %ecx,%edx
80107344:	89 10                	mov    %edx,(%eax)
}
80107346:	c9                   	leave  
80107347:	c3                   	ret    
    panic("failed setting PTE flags when handling trap\n");
80107348:	83 ec 0c             	sub    $0xc,%esp
8010734b:	68 9c 8a 10 80       	push   $0x80108a9c
80107350:	e8 3b 90 ff ff       	call   80100390 <panic>
80107355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107360 <set_page_flags_in_disk>:

void
set_page_flags_in_disk(pde_t *pgdir, uint va)
{
80107360:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107361:	31 c9                	xor    %ecx,%ecx
{
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736b:	8b 45 08             	mov    0x8(%ebp),%eax
8010736e:	e8 7d fa ff ff       	call   80106df0 <walkpgdir>
  if (!pte)
80107373:	85 c0                	test   %eax,%eax
80107375:	74 0c                	je     80107383 <set_page_flags_in_disk+0x23>
    panic("failed setting PTE flags after writing to file\n");
  
  *pte |= PTE_PG;   // PTE is in file
  *pte &= ~PTE_P;   // PTE is NOT in memory
80107377:	8b 10                	mov    (%eax),%edx
80107379:	83 e2 fe             	and    $0xfffffffe,%edx
8010737c:	80 ce 02             	or     $0x2,%dh
8010737f:	89 10                	mov    %edx,(%eax)
}
80107381:	c9                   	leave  
80107382:	c3                   	ret    
    panic("failed setting PTE flags after writing to file\n");
80107383:	83 ec 0c             	sub    $0xc,%esp
80107386:	68 cc 8a 10 80       	push   $0x80108acc
8010738b:	e8 00 90 ff ff       	call   80100390 <panic>

80107390 <swap>:

int
swap(struct proc *p)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	56                   	push   %esi
80107394:	53                   	push   %ebx
80107395:	8b 75 08             	mov    0x8(%ebp),%esi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107398:	31 db                	xor    %ebx,%ebx
  int i_in_mem_to_remove, next_free_i_file, pa;

  p->page_faults++;
8010739a:	83 86 80 02 00 00 01 	addl   $0x1,0x280(%esi)
801073a1:	8d 86 8c 00 00 00    	lea    0x8c(%esi),%eax
801073a7:	eb 16                	jmp    801073bf <swap+0x2f>
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801073b0:	83 c3 01             	add    $0x1,%ebx
801073b3:	83 c0 10             	add    $0x10,%eax
801073b6:	83 fb 10             	cmp    $0x10,%ebx
801073b9:	0f 84 b1 00 00 00    	je     80107470 <swap+0xe0>
    if (!p->file_pages[i].is_used)
801073bf:	8b 08                	mov    (%eax),%ecx
801073c1:	85 c9                	test   %ecx,%ecx
801073c3:	75 eb                	jne    801073b0 <swap+0x20>
801073c5:	89 d8                	mov    %ebx,%eax
801073c7:	c1 e0 0c             	shl    $0xc,%eax

  i_in_mem_to_remove = next_i_in_mem_to_remove(p);
  next_free_i_file = next_free_i_in_file(p);

  if (writeToSwapFile(p, (char*) p->memory_pages[i_in_mem_to_remove].va, next_free_i_file*PGSIZE, PGSIZE) == -1)
801073ca:	68 00 10 00 00       	push   $0x1000
801073cf:	50                   	push   %eax
801073d0:	ff b6 84 01 00 00    	pushl  0x184(%esi)
801073d6:	56                   	push   %esi
801073d7:	e8 b4 ae ff ff       	call   80102290 <writeToSwapFile>
801073dc:	83 c4 10             	add    $0x10,%esp
801073df:	83 f8 ff             	cmp    $0xffffffff,%eax
801073e2:	74 7b                	je     8010745f <swap+0xcf>
    return -1;

  // swap from memory to file
  p->file_pages[next_free_i_file].pgdir = p->memory_pages[i_in_mem_to_remove].pgdir;
801073e4:	8b 86 80 01 00 00    	mov    0x180(%esi),%eax
801073ea:	c1 e3 04             	shl    $0x4,%ebx
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801073ed:	31 c9                	xor    %ecx,%ecx
801073ef:	01 f3                	add    %esi,%ebx
  p->file_pages[next_free_i_file].pgdir = p->memory_pages[i_in_mem_to_remove].pgdir;
801073f1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  p->file_pages[next_free_i_file].va = p->memory_pages[i_in_mem_to_remove].va;
801073f7:	8b 96 84 01 00 00    	mov    0x184(%esi),%edx
  p->file_pages[next_free_i_file].is_used = 1;
801073fd:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80107404:	00 00 00 
  p->file_pages[next_free_i_file].va = p->memory_pages[i_in_mem_to_remove].va;
80107407:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
8010740d:	e8 de f9 ff ff       	call   80106df0 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
80107412:	85 c0                	test   %eax,%eax
80107414:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
80107419:	74 0e                	je     80107429 <swap+0x99>
8010741b:	8b 10                	mov    (%eax),%edx
8010741d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107423:	81 c2 00 00 00 80    	add    $0x80000000,%edx

  pa = find_pa(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
  kfree(P2V(pa));
80107429:	83 ec 0c             	sub    $0xc,%esp
8010742c:	52                   	push   %edx
8010742d:	e8 2e b4 ff ff       	call   80102860 <kfree>
  p->memory_pages[i_in_mem_to_remove].is_used = 0;
80107432:	c7 86 8c 01 00 00 00 	movl   $0x0,0x18c(%esi)
80107439:	00 00 00 
  set_page_flags_in_disk(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
8010743c:	58                   	pop    %eax
8010743d:	5a                   	pop    %edx
8010743e:	ff b6 84 01 00 00    	pushl  0x184(%esi)
80107444:	ff b6 80 01 00 00    	pushl  0x180(%esi)
8010744a:	e8 11 ff ff ff       	call   80107360 <set_page_flags_in_disk>
  lcr3(V2P(p->pgdir));      // flush TLB
8010744f:	8b 46 04             	mov    0x4(%esi),%eax
80107452:	05 00 00 00 80       	add    $0x80000000,%eax
80107457:	0f 22 d8             	mov    %eax,%cr3

  return i_in_mem_to_remove;
8010745a:	31 c0                	xor    %eax,%eax
8010745c:	83 c4 10             	add    $0x10,%esp
}
8010745f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107462:	5b                   	pop    %ebx
80107463:	5e                   	pop    %esi
80107464:	5d                   	pop    %ebp
80107465:	c3                   	ret    
80107466:	8d 76 00             	lea    0x0(%esi),%esi
80107469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107470:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80107475:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010747a:	e9 4b ff ff ff       	jmp    801073ca <swap+0x3a>
8010747f:	90                   	nop

80107480 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
80107489:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010748c:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;
  pte_t *pte;
  uint a, pa;
  struct proc *p = myproc();
8010748f:	e8 9c c9 ff ff       	call   80103e30 <myproc>

  if(newsz >= oldsz)
80107494:	39 7d 10             	cmp    %edi,0x10(%ebp)
  struct proc *p = myproc();
80107497:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldsz;
8010749a:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
8010749c:	73 4d                	jae    801074eb <deallocuvm+0x6b>

  a = PGROUNDUP(newsz);
8010749e:	8b 45 10             	mov    0x10(%ebp),%eax
801074a1:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801074a7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801074ad:	39 df                	cmp    %ebx,%edi
801074af:	77 18                	ja     801074c9 <deallocuvm+0x49>
801074b1:	eb 35                	jmp    801074e8 <deallocuvm+0x68>
801074b3:	90                   	nop
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte) 
      // a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
      a += (NPDENTRIES-1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
801074b8:	8b 10                	mov    (%eax),%edx
801074ba:	f6 c2 01             	test   $0x1,%dl
801074bd:	75 39                	jne    801074f8 <deallocuvm+0x78>
  for(; a  < oldsz; a += PGSIZE){
801074bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074c5:	39 df                	cmp    %ebx,%edi
801074c7:	76 1f                	jbe    801074e8 <deallocuvm+0x68>
    pte = walkpgdir(pgdir, (char*)a, 0);
801074c9:	31 c9                	xor    %ecx,%ecx
801074cb:	89 da                	mov    %ebx,%edx
801074cd:	89 f0                	mov    %esi,%eax
801074cf:	e8 1c f9 ff ff       	call   80106df0 <walkpgdir>
    if(!pte) 
801074d4:	85 c0                	test   %eax,%eax
801074d6:	75 e0                	jne    801074b8 <deallocuvm+0x38>
      a += (NPDENTRIES-1) * PGSIZE;
801074d8:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801074de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074e4:	39 df                	cmp    %ebx,%edi
801074e6:	77 e1                	ja     801074c9 <deallocuvm+0x49>
        // }
      }
      *pte = 0;
    }
  }
  return newsz;
801074e8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801074eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ee:	5b                   	pop    %ebx
801074ef:	5e                   	pop    %esi
801074f0:	5f                   	pop    %edi
801074f1:	5d                   	pop    %ebp
801074f2:	c3                   	ret    
801074f3:	90                   	nop
801074f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801074f8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074fe:	74 58                	je     80107558 <deallocuvm+0xd8>
      kfree(v);
80107500:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107503:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010750c:	52                   	push   %edx
8010750d:	e8 4e b3 ff ff       	call   80102860 <kfree>
80107512:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107515:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107518:	31 c9                	xor    %ecx,%ecx
8010751a:	8d 90 80 01 00 00    	lea    0x180(%eax),%edx
80107520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107523:	eb 0e                	jmp    80107533 <deallocuvm+0xb3>
80107525:	8d 76 00             	lea    0x0(%esi),%esi
80107528:	83 c1 01             	add    $0x1,%ecx
8010752b:	83 c2 10             	add    $0x10,%edx
8010752e:	83 f9 10             	cmp    $0x10,%ecx
80107531:	74 1a                	je     8010754d <deallocuvm+0xcd>
          if (//p->memory_pages[i].is_used && 
80107533:	39 32                	cmp    %esi,(%edx)
80107535:	75 f1                	jne    80107528 <deallocuvm+0xa8>
              p->memory_pages[i].pgdir == pgdir && p->memory_pages[i].va == a) {
80107537:	39 5a 04             	cmp    %ebx,0x4(%edx)
8010753a:	75 ec                	jne    80107528 <deallocuvm+0xa8>
            p->memory_pages[i].is_used = 0;
8010753c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010753f:	83 c1 18             	add    $0x18,%ecx
80107542:	c1 e1 04             	shl    $0x4,%ecx
80107545:	c7 44 0a 0c 00 00 00 	movl   $0x0,0xc(%edx,%ecx,1)
8010754c:	00 
      *pte = 0;
8010754d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107553:	e9 67 ff ff ff       	jmp    801074bf <deallocuvm+0x3f>
        panic("kfree");
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	68 2a 82 10 80       	push   $0x8010822a
80107560:	e8 2b 8e ff ff       	call   80100390 <panic>
80107565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107570 <allocuvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80107579:	e8 b2 c8 ff ff       	call   80103e30 <myproc>
8010757e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107580:	8b 45 10             	mov    0x10(%ebp),%eax
80107583:	85 c0                	test   %eax,%eax
80107585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107588:	0f 88 42 01 00 00    	js     801076d0 <allocuvm+0x160>
  if(newsz < oldsz)
8010758e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107591:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107594:	0f 82 06 01 00 00    	jb     801076a0 <allocuvm+0x130>
8010759a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801075a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if (p->pid > 2 && (PGROUNDUP(newsz) - PGROUNDUP(oldsz))/ PGSIZE > MAX_TOTAL_PAGES) { // space needed is bigger than max num of pages
801075a6:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801075aa:	0f 8f 38 01 00 00    	jg     801076e8 <allocuvm+0x178>
  for(; a < newsz; a += PGSIZE){
801075b0:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801075b3:	0f 83 ea 00 00 00    	jae    801076a3 <allocuvm+0x133>
    mem = kalloc();
801075b9:	e8 d2 b4 ff ff       	call   80102a90 <kalloc>
    if(mem == 0){
801075be:	85 c0                	test   %eax,%eax
    mem = kalloc();
801075c0:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801075c2:	0f 84 9b 00 00 00    	je     80107663 <allocuvm+0xf3>
801075c8:	90                   	nop
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075d0:	83 ec 04             	sub    $0x4,%esp
801075d3:	68 00 10 00 00       	push   $0x1000
801075d8:	6a 00                	push   $0x0
801075da:	50                   	push   %eax
801075db:	e8 80 d6 ff ff       	call   80104c60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075e0:	58                   	pop    %eax
801075e1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075e7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075ec:	5a                   	pop    %edx
801075ed:	6a 06                	push   $0x6
801075ef:	50                   	push   %eax
801075f0:	89 da                	mov    %ebx,%edx
801075f2:	8b 45 08             	mov    0x8(%ebp),%eax
801075f5:	e8 76 f8 ff ff       	call   80106e70 <mappages>
801075fa:	83 c4 10             	add    $0x10,%esp
801075fd:	85 c0                	test   %eax,%eax
801075ff:	0f 88 1f 01 00 00    	js     80107724 <allocuvm+0x1b4>
80107605:	8d 97 8c 01 00 00    	lea    0x18c(%edi),%edx
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010760b:	31 c0                	xor    %eax,%eax
8010760d:	eb 10                	jmp    8010761f <allocuvm+0xaf>
8010760f:	90                   	nop
80107610:	83 c0 01             	add    $0x1,%eax
80107613:	83 c2 10             	add    $0x10,%edx
80107616:	83 f8 10             	cmp    $0x10,%eax
80107619:	0f 84 91 00 00 00    	je     801076b0 <allocuvm+0x140>
    if (!p->memory_pages[i].is_used)
8010761f:	8b 0a                	mov    (%edx),%ecx
80107621:	85 c9                	test   %ecx,%ecx
80107623:	75 eb                	jne    80107610 <allocuvm+0xa0>
    if (p->pid > 2) {
80107625:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107629:	7e 1e                	jle    80107649 <allocuvm+0xd9>
      p->memory_pages[next_free_i_mem].pgdir = pgdir;
8010762b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010762e:	c1 e0 04             	shl    $0x4,%eax
80107631:	01 f8                	add    %edi,%eax
      p->memory_pages[next_free_i_mem].is_used = 1;
80107633:	c7 80 8c 01 00 00 01 	movl   $0x1,0x18c(%eax)
8010763a:	00 00 00 
      p->memory_pages[next_free_i_mem].va = a;
8010763d:	89 98 84 01 00 00    	mov    %ebx,0x184(%eax)
      p->memory_pages[next_free_i_mem].pgdir = pgdir;
80107643:	89 88 80 01 00 00    	mov    %ecx,0x180(%eax)
  for(; a < newsz; a += PGSIZE){
80107649:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010764f:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107652:	76 4f                	jbe    801076a3 <allocuvm+0x133>
    mem = kalloc();
80107654:	e8 37 b4 ff ff       	call   80102a90 <kalloc>
    if(mem == 0){
80107659:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010765b:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010765d:	0f 85 6d ff ff ff    	jne    801075d0 <allocuvm+0x60>
      cprintf("allocuvm out of memory\n");
80107663:	83 ec 0c             	sub    $0xc,%esp
80107666:	68 c5 89 10 80       	push   $0x801089c5
8010766b:	e8 f0 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107670:	83 c4 0c             	add    $0xc,%esp
80107673:	ff 75 0c             	pushl  0xc(%ebp)
80107676:	ff 75 10             	pushl  0x10(%ebp)
80107679:	ff 75 08             	pushl  0x8(%ebp)
8010767c:	e8 ff fd ff ff       	call   80107480 <deallocuvm>
      return 0;
80107681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107688:	83 c4 10             	add    $0x10,%esp
}
8010768b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107691:	5b                   	pop    %ebx
80107692:	5e                   	pop    %esi
80107693:	5f                   	pop    %edi
80107694:	5d                   	pop    %ebp
80107695:	c3                   	ret    
80107696:	8d 76 00             	lea    0x0(%esi),%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
801076a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801076a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a9:	5b                   	pop    %ebx
801076aa:	5e                   	pop    %esi
801076ab:	5f                   	pop    %edi
801076ac:	5d                   	pop    %ebp
801076ad:	c3                   	ret    
801076ae:	66 90                	xchg   %ax,%ax
    if (p->pid > 2 && next_free_i_mem == -1) {
801076b0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801076b4:	7e 93                	jle    80107649 <allocuvm+0xd9>
      next_free_i_mem = swap(p);
801076b6:	83 ec 0c             	sub    $0xc,%esp
801076b9:	57                   	push   %edi
801076ba:	e8 d1 fc ff ff       	call   80107390 <swap>
801076bf:	83 c4 10             	add    $0x10,%esp
801076c2:	e9 5e ff ff ff       	jmp    80107625 <allocuvm+0xb5>
801076c7:	89 f6                	mov    %esi,%esi
801076c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return 0;
801076d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret    
801076e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (p->pid > 2 && (PGROUNDUP(newsz) - PGROUNDUP(oldsz))/ PGSIZE > MAX_TOTAL_PAGES) { // space needed is bigger than max num of pages
801076e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076eb:	05 ff 0f 00 00       	add    $0xfff,%eax
801076f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076f5:	29 d8                	sub    %ebx,%eax
801076f7:	3d ff 0f 02 00       	cmp    $0x20fff,%eax
801076fc:	0f 86 ae fe ff ff    	jbe    801075b0 <allocuvm+0x40>
    cprintf("alloc uvm: space requested(%d) is bigger than max allowed(%d)\n", PGROUNDUP(newsz) - PGROUNDUP(oldsz), PGSIZE * MAX_TOTAL_PAGES);
80107702:	83 ec 04             	sub    $0x4,%esp
80107705:	68 00 00 02 00       	push   $0x20000
8010770a:	50                   	push   %eax
8010770b:	68 fc 8a 10 80       	push   $0x80108afc
80107710:	e8 4b 8f ff ff       	call   80100660 <cprintf>
    return 0;
80107715:	83 c4 10             	add    $0x10,%esp
80107718:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010771f:	e9 7f ff ff ff       	jmp    801076a3 <allocuvm+0x133>
      cprintf("allocuvm out of memory (2)\n");
80107724:	83 ec 0c             	sub    $0xc,%esp
80107727:	68 dd 89 10 80       	push   $0x801089dd
8010772c:	e8 2f 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107731:	83 c4 0c             	add    $0xc,%esp
80107734:	ff 75 0c             	pushl  0xc(%ebp)
80107737:	ff 75 10             	pushl  0x10(%ebp)
8010773a:	ff 75 08             	pushl  0x8(%ebp)
8010773d:	e8 3e fd ff ff       	call   80107480 <deallocuvm>
      kfree(mem);
80107742:	89 34 24             	mov    %esi,(%esp)
80107745:	e8 16 b1 ff ff       	call   80102860 <kfree>
      return 0;
8010774a:	83 c4 10             	add    $0x10,%esp
8010774d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107754:	e9 4a ff ff ff       	jmp    801076a3 <allocuvm+0x133>
80107759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107760 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
80107766:	83 ec 0c             	sub    $0xc,%esp
80107769:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010776c:	85 f6                	test   %esi,%esi
8010776e:	74 59                	je     801077c9 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107770:	83 ec 04             	sub    $0x4,%esp
80107773:	89 f3                	mov    %esi,%ebx
80107775:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010777b:	6a 00                	push   $0x0
8010777d:	68 00 00 00 80       	push   $0x80000000
80107782:	56                   	push   %esi
80107783:	e8 f8 fc ff ff       	call   80107480 <deallocuvm>
80107788:	83 c4 10             	add    $0x10,%esp
8010778b:	eb 0a                	jmp    80107797 <freevm+0x37>
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
80107790:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107793:	39 fb                	cmp    %edi,%ebx
80107795:	74 23                	je     801077ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107797:	8b 03                	mov    (%ebx),%eax
80107799:	a8 01                	test   $0x1,%al
8010779b:	74 f3                	je     80107790 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010779d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801077a2:	83 ec 0c             	sub    $0xc,%esp
801077a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801077ad:	50                   	push   %eax
801077ae:	e8 ad b0 ff ff       	call   80102860 <kfree>
801077b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077b6:	39 fb                	cmp    %edi,%ebx
801077b8:	75 dd                	jne    80107797 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801077ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c0:	5b                   	pop    %ebx
801077c1:	5e                   	pop    %esi
801077c2:	5f                   	pop    %edi
801077c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077c4:	e9 97 b0 ff ff       	jmp    80102860 <kfree>
    panic("freevm: no pgdir");
801077c9:	83 ec 0c             	sub    $0xc,%esp
801077cc:	68 f9 89 10 80       	push   $0x801089f9
801077d1:	e8 ba 8b ff ff       	call   80100390 <panic>
801077d6:	8d 76 00             	lea    0x0(%esi),%esi
801077d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077e0 <setupkvm>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	56                   	push   %esi
801077e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077e5:	e8 a6 b2 ff ff       	call   80102a90 <kalloc>
801077ea:	85 c0                	test   %eax,%eax
801077ec:	89 c6                	mov    %eax,%esi
801077ee:	74 42                	je     80107832 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077f8:	68 00 10 00 00       	push   $0x1000
801077fd:	6a 00                	push   $0x0
801077ff:	50                   	push   %eax
80107800:	e8 5b d4 ff ff       	call   80104c60 <memset>
80107805:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107808:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010780b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010780e:	83 ec 08             	sub    $0x8,%esp
80107811:	8b 13                	mov    (%ebx),%edx
80107813:	ff 73 0c             	pushl  0xc(%ebx)
80107816:	50                   	push   %eax
80107817:	29 c1                	sub    %eax,%ecx
80107819:	89 f0                	mov    %esi,%eax
8010781b:	e8 50 f6 ff ff       	call   80106e70 <mappages>
80107820:	83 c4 10             	add    $0x10,%esp
80107823:	85 c0                	test   %eax,%eax
80107825:	78 19                	js     80107840 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107827:	83 c3 10             	add    $0x10,%ebx
8010782a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107830:	75 d6                	jne    80107808 <setupkvm+0x28>
}
80107832:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107835:	89 f0                	mov    %esi,%eax
80107837:	5b                   	pop    %ebx
80107838:	5e                   	pop    %esi
80107839:	5d                   	pop    %ebp
8010783a:	c3                   	ret    
8010783b:	90                   	nop
8010783c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107840:	83 ec 0c             	sub    $0xc,%esp
80107843:	56                   	push   %esi
      return 0;
80107844:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107846:	e8 15 ff ff ff       	call   80107760 <freevm>
      return 0;
8010784b:	83 c4 10             	add    $0x10,%esp
}
8010784e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107851:	89 f0                	mov    %esi,%eax
80107853:	5b                   	pop    %ebx
80107854:	5e                   	pop    %esi
80107855:	5d                   	pop    %ebp
80107856:	c3                   	ret    
80107857:	89 f6                	mov    %esi,%esi
80107859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107860 <kvmalloc>:
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107866:	e8 75 ff ff ff       	call   801077e0 <setupkvm>
8010786b:	a3 c4 86 15 80       	mov    %eax,0x801586c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107870:	05 00 00 00 80       	add    $0x80000000,%eax
80107875:	0f 22 d8             	mov    %eax,%cr3
}
80107878:	c9                   	leave  
80107879:	c3                   	ret    
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107880 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107880:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107881:	31 c9                	xor    %ecx,%ecx
{
80107883:	89 e5                	mov    %esp,%ebp
80107885:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107888:	8b 55 0c             	mov    0xc(%ebp),%edx
8010788b:	8b 45 08             	mov    0x8(%ebp),%eax
8010788e:	e8 5d f5 ff ff       	call   80106df0 <walkpgdir>
  if(pte == 0)
80107893:	85 c0                	test   %eax,%eax
80107895:	74 05                	je     8010789c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107897:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010789a:	c9                   	leave  
8010789b:	c3                   	ret    
    panic("clearpteu");
8010789c:	83 ec 0c             	sub    $0xc,%esp
8010789f:	68 0a 8a 10 80       	push   $0x80108a0a
801078a4:	e8 e7 8a ff ff       	call   80100390 <panic>
801078a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	57                   	push   %edi
801078b4:	56                   	push   %esi
801078b5:	53                   	push   %ebx
801078b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  struct proc *p = myproc();
801078b9:	e8 72 c5 ff ff       	call   80103e30 <myproc>
801078be:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if((d = setupkvm()) == 0)
801078c1:	e8 1a ff ff ff       	call   801077e0 <setupkvm>
801078c6:	85 c0                	test   %eax,%eax
801078c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078cb:	0f 84 ba 00 00 00    	je     8010798b <copyuvm+0xdb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078d4:	85 c9                	test   %ecx,%ecx
801078d6:	0f 84 af 00 00 00    	je     8010798b <copyuvm+0xdb>
801078dc:	31 ff                	xor    %edi,%edi
801078de:	eb 69                	jmp    80107949 <copyuvm+0x99>
    if(*pte & PTE_PG) {
      set_page_flags_in_disk(d, i);
      lcr3(V2P(p->pgdir));
      continue;
    }
    if(!(*pte & PTE_P))
801078e0:	a8 01                	test   $0x1,%al
801078e2:	0f 84 f1 00 00 00    	je     801079d9 <copyuvm+0x129>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078e8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801078ea:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801078ef:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801078f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801078f8:	e8 93 b1 ff ff       	call   80102a90 <kalloc>
801078fd:	85 c0                	test   %eax,%eax
801078ff:	89 c6                	mov    %eax,%esi
80107901:	0f 84 a5 00 00 00    	je     801079ac <copyuvm+0xfc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107907:	83 ec 04             	sub    $0x4,%esp
8010790a:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107910:	68 00 10 00 00       	push   $0x1000
80107915:	53                   	push   %ebx
80107916:	50                   	push   %eax
80107917:	e8 f4 d3 ff ff       	call   80104d10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010791c:	58                   	pop    %eax
8010791d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107923:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107928:	5a                   	pop    %edx
80107929:	ff 75 e4             	pushl  -0x1c(%ebp)
8010792c:	50                   	push   %eax
8010792d:	89 fa                	mov    %edi,%edx
8010792f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107932:	e8 39 f5 ff ff       	call   80106e70 <mappages>
80107937:	83 c4 10             	add    $0x10,%esp
8010793a:	85 c0                	test   %eax,%eax
8010793c:	78 62                	js     801079a0 <copyuvm+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
8010793e:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107944:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107947:	76 42                	jbe    8010798b <copyuvm+0xdb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107949:	8b 45 08             	mov    0x8(%ebp),%eax
8010794c:	31 c9                	xor    %ecx,%ecx
8010794e:	89 fa                	mov    %edi,%edx
80107950:	e8 9b f4 ff ff       	call   80106df0 <walkpgdir>
80107955:	85 c0                	test   %eax,%eax
80107957:	74 73                	je     801079cc <copyuvm+0x11c>
    if(*pte & PTE_PG) {
80107959:	8b 00                	mov    (%eax),%eax
8010795b:	f6 c4 02             	test   $0x2,%ah
8010795e:	74 80                	je     801078e0 <copyuvm+0x30>
      set_page_flags_in_disk(d, i);
80107960:	83 ec 08             	sub    $0x8,%esp
80107963:	57                   	push   %edi
80107964:	ff 75 e0             	pushl  -0x20(%ebp)
80107967:	e8 f4 f9 ff ff       	call   80107360 <set_page_flags_in_disk>
      lcr3(V2P(p->pgdir));
8010796c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010796f:	8b 40 04             	mov    0x4(%eax),%eax
80107972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107975:	05 00 00 00 80       	add    $0x80000000,%eax
8010797a:	0f 22 d8             	mov    %eax,%cr3
      continue;
8010797d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107980:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107986:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107989:	77 be                	ja     80107949 <copyuvm+0x99>
  return d;

bad:
  freevm(d);
  return 0;
}
8010798b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107991:	5b                   	pop    %ebx
80107992:	5e                   	pop    %esi
80107993:	5f                   	pop    %edi
80107994:	5d                   	pop    %ebp
80107995:	c3                   	ret    
80107996:	8d 76 00             	lea    0x0(%esi),%esi
80107999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      kfree(mem);
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	56                   	push   %esi
801079a4:	e8 b7 ae ff ff       	call   80102860 <kfree>
      goto bad;
801079a9:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801079ac:	83 ec 0c             	sub    $0xc,%esp
801079af:	ff 75 e0             	pushl  -0x20(%ebp)
801079b2:	e8 a9 fd ff ff       	call   80107760 <freevm>
  return 0;
801079b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079be:	83 c4 10             	add    $0x10,%esp
}
801079c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079c7:	5b                   	pop    %ebx
801079c8:	5e                   	pop    %esi
801079c9:	5f                   	pop    %edi
801079ca:	5d                   	pop    %ebp
801079cb:	c3                   	ret    
      panic("copyuvm: pte should exist");
801079cc:	83 ec 0c             	sub    $0xc,%esp
801079cf:	68 14 8a 10 80       	push   $0x80108a14
801079d4:	e8 b7 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801079d9:	83 ec 0c             	sub    $0xc,%esp
801079dc:	68 2e 8a 10 80       	push   $0x80108a2e
801079e1:	e8 aa 89 ff ff       	call   80100390 <panic>
801079e6:	8d 76 00             	lea    0x0(%esi),%esi
801079e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079f0 <copyonwriteuvm>:

pde_t*
copyonwriteuvm(pde_t *pgdir, uint sz)
{
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	57                   	push   %edi
801079f4:	56                   	push   %esi
801079f5:	53                   	push   %ebx
801079f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  struct proc *p = myproc();
801079f9:	e8 32 c4 ff ff       	call   80103e30 <myproc>
801079fe:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // if (p->pid <= 2)
  //   return copyuvm(pgdir, sz);

  if((d = setupkvm()) == 0)
80107a01:	e8 da fd ff ff       	call   801077e0 <setupkvm>
80107a06:	85 c0                	test   %eax,%eax
80107a08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a0b:	0f 84 bd 00 00 00    	je     80107ace <copyonwriteuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a14:	85 c9                	test   %ecx,%ecx
80107a16:	0f 84 a4 00 00 00    	je     80107ac0 <copyonwriteuvm+0xd0>
80107a1c:	31 db                	xor    %ebx,%ebx
80107a1e:	eb 57                	jmp    80107a77 <copyonwriteuvm+0x87>
    if(*pte & PTE_PG) {
      set_page_flags_in_disk(d, i);
      lcr3(V2P(p->pgdir));
      continue;
    }
    if(!(*pte & PTE_P))
80107a20:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107a26:	0f 84 c7 00 00 00    	je     80107af3 <copyonwriteuvm+0x103>
      panic("copyonwriteuvm: page not present");


    *pte |= PTE_COW;    // copy on write
    *pte &= ~PTE_W;     // pte is NOT writable -> need to handle in trap!
80107a2c:	89 f1                	mov    %esi,%ecx
80107a2e:	89 f7                	mov    %esi,%edi
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    inc_counter(pa);
80107a30:	83 ec 0c             	sub    $0xc,%esp
    *pte &= ~PTE_W;     // pte is NOT writable -> need to handle in trap!
80107a33:	83 e1 fd             	and    $0xfffffffd,%ecx
80107a36:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107a3c:	80 cd 04             	or     $0x4,%ch
80107a3f:	89 08                	mov    %ecx,(%eax)
    inc_counter(pa);
80107a41:	57                   	push   %edi
80107a42:	e8 19 ad ff ff       	call   80102760 <inc_counter>
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107a47:	58                   	pop    %eax
80107a48:	5a                   	pop    %edx
    flags = PTE_FLAGS(*pte);
80107a49:	89 f2                	mov    %esi,%edx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
    flags = PTE_FLAGS(*pte);
80107a53:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
80107a59:	80 ce 04             	or     $0x4,%dh
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107a5c:	52                   	push   %edx
80107a5d:	57                   	push   %edi
80107a5e:	89 da                	mov    %ebx,%edx
80107a60:	e8 0b f4 ff ff       	call   80106e70 <mappages>
80107a65:	83 c4 10             	add    $0x10,%esp
80107a68:	85 c0                	test   %eax,%eax
80107a6a:	78 7a                	js     80107ae6 <copyonwriteuvm+0xf6>
  for(i = 0; i < sz; i += PGSIZE){
80107a6c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a72:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107a75:	76 49                	jbe    80107ac0 <copyonwriteuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a77:	8b 45 08             	mov    0x8(%ebp),%eax
80107a7a:	31 c9                	xor    %ecx,%ecx
80107a7c:	89 da                	mov    %ebx,%edx
80107a7e:	e8 6d f3 ff ff       	call   80106df0 <walkpgdir>
80107a83:	85 c0                	test   %eax,%eax
80107a85:	74 52                	je     80107ad9 <copyonwriteuvm+0xe9>
    if(*pte & PTE_PG) {
80107a87:	8b 30                	mov    (%eax),%esi
80107a89:	f7 c6 00 02 00 00    	test   $0x200,%esi
80107a8f:	74 8f                	je     80107a20 <copyonwriteuvm+0x30>
      set_page_flags_in_disk(d, i);
80107a91:	83 ec 08             	sub    $0x8,%esp
80107a94:	53                   	push   %ebx
80107a95:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a98:	e8 c3 f8 ff ff       	call   80107360 <set_page_flags_in_disk>
      lcr3(V2P(p->pgdir));
80107a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107aa0:	8b 40 04             	mov    0x4(%eax),%eax
80107aa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107aa6:	05 00 00 00 80       	add    $0x80000000,%eax
80107aab:	0f 22 d8             	mov    %eax,%cr3
      continue;
80107aae:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107ab1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ab7:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107aba:	77 bb                	ja     80107a77 <copyonwriteuvm+0x87>
80107abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      goto bad;
  }
  lcr3(V2P(p->pgdir));
80107ac0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ac3:	8b 40 04             	mov    0x4(%eax),%eax
80107ac6:	05 00 00 00 80       	add    $0x80000000,%eax
80107acb:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  panic("copyonwriteuvm: should not happen\n");
  return 0;
}
80107ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad4:	5b                   	pop    %ebx
80107ad5:	5e                   	pop    %esi
80107ad6:	5f                   	pop    %edi
80107ad7:	5d                   	pop    %ebp
80107ad8:	c3                   	ret    
      panic("copyonwriteuvm: pte should exist");
80107ad9:	83 ec 0c             	sub    $0xc,%esp
80107adc:	68 3c 8b 10 80       	push   $0x80108b3c
80107ae1:	e8 aa 88 ff ff       	call   80100390 <panic>
  panic("copyonwriteuvm: should not happen\n");
80107ae6:	83 ec 0c             	sub    $0xc,%esp
80107ae9:	68 84 8b 10 80       	push   $0x80108b84
80107aee:	e8 9d 88 ff ff       	call   80100390 <panic>
      panic("copyonwriteuvm: page not present");
80107af3:	83 ec 0c             	sub    $0xc,%esp
80107af6:	68 60 8b 10 80       	push   $0x80108b60
80107afb:	e8 90 88 ff ff       	call   80100390 <panic>

80107b00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b01:	31 c9                	xor    %ecx,%ecx
{
80107b03:	89 e5                	mov    %esp,%ebp
80107b05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b0e:	e8 dd f2 ff ff       	call   80106df0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b15:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b16:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b1d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b20:	05 00 00 00 80       	add    $0x80000000,%eax
80107b25:	83 fa 05             	cmp    $0x5,%edx
80107b28:	ba 00 00 00 00       	mov    $0x0,%edx
80107b2d:	0f 45 c2             	cmovne %edx,%eax
}
80107b30:	c3                   	ret    
80107b31:	eb 0d                	jmp    80107b40 <copyout>
80107b33:	90                   	nop
80107b34:	90                   	nop
80107b35:	90                   	nop
80107b36:	90                   	nop
80107b37:	90                   	nop
80107b38:	90                   	nop
80107b39:	90                   	nop
80107b3a:	90                   	nop
80107b3b:	90                   	nop
80107b3c:	90                   	nop
80107b3d:	90                   	nop
80107b3e:	90                   	nop
80107b3f:	90                   	nop

80107b40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	56                   	push   %esi
80107b45:	53                   	push   %ebx
80107b46:	83 ec 1c             	sub    $0x1c,%esp
80107b49:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b52:	85 db                	test   %ebx,%ebx
80107b54:	75 40                	jne    80107b96 <copyout+0x56>
80107b56:	eb 70                	jmp    80107bc8 <copyout+0x88>
80107b58:	90                   	nop
80107b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b63:	89 f1                	mov    %esi,%ecx
80107b65:	29 d1                	sub    %edx,%ecx
80107b67:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107b6d:	39 d9                	cmp    %ebx,%ecx
80107b6f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b72:	29 f2                	sub    %esi,%edx
80107b74:	83 ec 04             	sub    $0x4,%esp
80107b77:	01 d0                	add    %edx,%eax
80107b79:	51                   	push   %ecx
80107b7a:	57                   	push   %edi
80107b7b:	50                   	push   %eax
80107b7c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b7f:	e8 8c d1 ff ff       	call   80104d10 <memmove>
    len -= n;
    buf += n;
80107b84:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107b87:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107b8a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107b90:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107b92:	29 cb                	sub    %ecx,%ebx
80107b94:	74 32                	je     80107bc8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107b96:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b98:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107b9e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba4:	56                   	push   %esi
80107ba5:	ff 75 08             	pushl  0x8(%ebp)
80107ba8:	e8 53 ff ff ff       	call   80107b00 <uva2ka>
    if(pa0 == 0)
80107bad:	83 c4 10             	add    $0x10,%esp
80107bb0:	85 c0                	test   %eax,%eax
80107bb2:	75 ac                	jne    80107b60 <copyout+0x20>
  }
  return 0;
}
80107bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bbc:	5b                   	pop    %ebx
80107bbd:	5e                   	pop    %esi
80107bbe:	5f                   	pop    %edi
80107bbf:	5d                   	pop    %ebp
80107bc0:	c3                   	ret    
80107bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bcb:	31 c0                	xor    %eax,%eax
}
80107bcd:	5b                   	pop    %ebx
80107bce:	5e                   	pop    %esi
80107bcf:	5f                   	pop    %edi
80107bd0:	5d                   	pop    %ebp
80107bd1:	c3                   	ret    
80107bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107be0 <handle_pf>:

static char buffer[PGSIZE];

int
handle_pf(void) 
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
  struct page old_page;
  uint old_pa, va, va_rounded;
  int new_page_i_in_mem, new_page_i_in_file, i_of_rounded_va, is_need_swap;
  char *pa;
  pte_t *pte;
  struct proc *p = myproc();
80107be9:	e8 42 c2 ff ff       	call   80103e30 <myproc>
80107bee:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107bf0:	0f 20 d6             	mov    %cr2,%esi

  va = rcr2();
  if ((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0) {
80107bf3:	8b 40 04             	mov    0x4(%eax),%eax
80107bf6:	31 c9                	xor    %ecx,%ecx
80107bf8:	89 f2                	mov    %esi,%edx
80107bfa:	e8 f1 f1 ff ff       	call   80106df0 <walkpgdir>
80107bff:	85 c0                	test   %eax,%eax
80107c01:	0f 84 48 02 00 00    	je     80107e4f <handle_pf+0x26f>
    panic("handle_pf: walkdir failed\n");
  }
  if ((*pte & PTE_PG) == 0) { // not paged out to secondary storage
80107c07:	8b 00                	mov    (%eax),%eax
    return 0;
80107c09:	31 ff                	xor    %edi,%edi
  if ((*pte & PTE_PG) == 0) { // not paged out to secondary storage
80107c0b:	f6 c4 02             	test   $0x2,%ah
80107c0e:	75 10                	jne    80107c20 <handle_pf+0x40>
  }
  else
    memmove((char*)va_rounded, buffer, PGSIZE);

  return 1;
}
80107c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c13:	89 f8                	mov    %edi,%eax
80107c15:	5b                   	pop    %ebx
80107c16:	5e                   	pop    %esi
80107c17:	5f                   	pop    %edi
80107c18:	5d                   	pop    %ebp
80107c19:	c3                   	ret    
80107c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  p->page_faults++;
80107c20:	83 83 80 02 00 00 01 	addl   $0x1,0x280(%ebx)
  va_rounded = PGROUNDDOWN(va);
80107c27:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  pa = kalloc();
80107c2d:	e8 5e ae ff ff       	call   80102a90 <kalloc>
80107c32:	8d 93 8c 01 00 00    	lea    0x18c(%ebx),%edx
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107c38:	31 c9                	xor    %ecx,%ecx
80107c3a:	eb 13                	jmp    80107c4f <handle_pf+0x6f>
80107c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c40:	83 c1 01             	add    $0x1,%ecx
80107c43:	83 c2 10             	add    $0x10,%edx
80107c46:	83 f9 10             	cmp    $0x10,%ecx
80107c49:	0f 84 d9 01 00 00    	je     80107e28 <handle_pf+0x248>
    if (!p->memory_pages[i].is_used)
80107c4f:	8b 3a                	mov    (%edx),%edi
80107c51:	85 ff                	test   %edi,%edi
80107c53:	75 eb                	jne    80107c40 <handle_pf+0x60>
80107c55:	8d 51 18             	lea    0x18(%ecx),%edx
  is_need_swap = 0;
80107c58:	31 ff                	xor    %edi,%edi
80107c5a:	c1 e2 04             	shl    $0x4,%edx
  old_page = p->memory_pages[new_page_i_in_mem];
80107c5d:	01 da                	add    %ebx,%edx
80107c5f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107c62:	83 ec 04             	sub    $0x4,%esp
  old_page = p->memory_pages[new_page_i_in_mem];
80107c65:	8b 0a                	mov    (%edx),%ecx
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107c67:	05 00 00 00 80       	add    $0x80000000,%eax
  old_page = p->memory_pages[new_page_i_in_mem];
80107c6c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80107c6f:	8b 4a 04             	mov    0x4(%edx),%ecx
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107c72:	50                   	push   %eax
80107c73:	56                   	push   %esi
80107c74:	ff 73 04             	pushl  0x4(%ebx)
  old_page = p->memory_pages[new_page_i_in_mem];
80107c77:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107c7a:	e8 a1 f6 ff ff       	call   80107320 <set_page_flags_in_mem>
  lcr3(V2P(p->pgdir));      // flush changes
80107c7f:	8b 43 04             	mov    0x4(%ebx),%eax
80107c82:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c87:	0f 22 d8             	mov    %eax,%cr3
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107c8a:	31 d2                	xor    %edx,%edx
80107c8c:	8d 83 84 00 00 00    	lea    0x84(%ebx),%eax
80107c92:	83 c4 10             	add    $0x10,%esp
80107c95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107c98:	eb 15                	jmp    80107caf <handle_pf+0xcf>
80107c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ca0:	83 c2 01             	add    $0x1,%edx
80107ca3:	83 c0 10             	add    $0x10,%eax
80107ca6:	83 fa 10             	cmp    $0x10,%edx
80107ca9:	0f 84 69 01 00 00    	je     80107e18 <handle_pf+0x238>
    if (p->file_pages[i].va == va)
80107caf:	3b 30                	cmp    (%eax),%esi
80107cb1:	75 ed                	jne    80107ca0 <handle_pf+0xc0>
  if (readFromSwapFile(p, buffer, i_of_rounded_va*PGSIZE, PGSIZE) != PGSIZE)
80107cb3:	89 d0                	mov    %edx,%eax
80107cb5:	68 00 10 00 00       	push   $0x1000
80107cba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80107cbd:	c1 e0 0c             	shl    $0xc,%eax
80107cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107cc3:	50                   	push   %eax
80107cc4:	68 e0 c5 10 80       	push   $0x8010c5e0
80107cc9:	53                   	push   %ebx
80107cca:	e8 f1 a5 ff ff       	call   801022c0 <readFromSwapFile>
80107ccf:	83 c4 10             	add    $0x10,%esp
80107cd2:	3d 00 10 00 00       	cmp    $0x1000,%eax
80107cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107cda:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80107cdd:	0f 85 79 01 00 00    	jne    80107e5c <handle_pf+0x27c>
  p->memory_pages[new_page_i_in_mem] = p->file_pages[i_of_rounded_va];
80107ce3:	83 c2 08             	add    $0x8,%edx
80107ce6:	83 c1 18             	add    $0x18,%ecx
80107ce9:	c1 e2 04             	shl    $0x4,%edx
80107cec:	c1 e1 04             	shl    $0x4,%ecx
80107cef:	01 da                	add    %ebx,%edx
80107cf1:	01 d9                	add    %ebx,%ecx
  if (is_need_swap) {
80107cf3:	85 ff                	test   %edi,%edi
  p->memory_pages[new_page_i_in_mem] = p->file_pages[i_of_rounded_va];
80107cf5:	8b 02                	mov    (%edx),%eax
80107cf7:	89 01                	mov    %eax,(%ecx)
80107cf9:	8b 42 04             	mov    0x4(%edx),%eax
80107cfc:	89 41 04             	mov    %eax,0x4(%ecx)
80107cff:	8b 42 08             	mov    0x8(%edx),%eax
80107d02:	89 41 08             	mov    %eax,0x8(%ecx)
80107d05:	8b 42 0c             	mov    0xc(%edx),%eax
80107d08:	89 41 0c             	mov    %eax,0xc(%ecx)
  p->file_pages[i_of_rounded_va].is_used = 0;
80107d0b:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
  if (is_need_swap) {
80107d12:	0f 84 d8 00 00 00    	je     80107df0 <handle_pf+0x210>
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107d18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107d1e:	31 c9                	xor    %ecx,%ecx
80107d20:	e8 cb f0 ff ff       	call   80106df0 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
80107d25:	85 c0                	test   %eax,%eax
80107d27:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80107d2e:	74 0a                	je     80107d3a <handle_pf+0x15a>
80107d30:	8b 00                	mov    (%eax),%eax
80107d32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d3a:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107d40:	31 d2                	xor    %edx,%edx
80107d42:	eb 13                	jmp    80107d57 <handle_pf+0x177>
80107d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d48:	83 c2 01             	add    $0x1,%edx
80107d4b:	83 c0 10             	add    $0x10,%eax
80107d4e:	83 fa 10             	cmp    $0x10,%edx
80107d51:	0f 84 e9 00 00 00    	je     80107e40 <handle_pf+0x260>
    if (!p->file_pages[i].is_used)
80107d57:	8b 08                	mov    (%eax),%ecx
80107d59:	85 c9                	test   %ecx,%ecx
80107d5b:	75 eb                	jne    80107d48 <handle_pf+0x168>
80107d5d:	89 d0                	mov    %edx,%eax
80107d5f:	c1 e0 0c             	shl    $0xc,%eax
    if (writeToSwapFile(p, (char*)old_page.va, new_page_i_in_file*PGSIZE, PGSIZE) == -1)
80107d62:	68 00 10 00 00       	push   $0x1000
80107d67:	50                   	push   %eax
80107d68:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d6b:	53                   	push   %ebx
80107d6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107d6f:	e8 1c a5 ff ff       	call   80102290 <writeToSwapFile>
80107d74:	83 c4 10             	add    $0x10,%esp
80107d77:	83 f8 ff             	cmp    $0xffffffff,%eax
80107d7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107d7d:	0f 84 e6 00 00 00    	je     80107e69 <handle_pf+0x289>
    p->file_pages[new_page_i_in_file].pgdir = old_page.pgdir;
80107d83:	8b 45 d8             	mov    -0x28(%ebp),%eax
    p->file_pages[new_page_i_in_file].va = old_page.va;
80107d86:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107d89:	c1 e2 04             	shl    $0x4,%edx
80107d8c:	01 da                	add    %ebx,%edx
    set_page_flags_in_disk(old_page.pgdir, old_page.va);
80107d8e:	83 ec 08             	sub    $0x8,%esp
    p->file_pages[new_page_i_in_file].is_used = 1;
80107d91:	c7 82 8c 00 00 00 01 	movl   $0x1,0x8c(%edx)
80107d98:	00 00 00 
    p->file_pages[new_page_i_in_file].pgdir = old_page.pgdir;
80107d9b:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    p->file_pages[new_page_i_in_file].va = old_page.va;
80107da1:	89 8a 84 00 00 00    	mov    %ecx,0x84(%edx)
    set_page_flags_in_disk(old_page.pgdir, old_page.va);
80107da7:	51                   	push   %ecx
80107da8:	50                   	push   %eax
80107da9:	e8 b2 f5 ff ff       	call   80107360 <set_page_flags_in_disk>
    lcr3(V2P(p->pgdir));
80107dae:	8b 43 04             	mov    0x4(%ebx),%eax
80107db1:	05 00 00 00 80       	add    $0x80000000,%eax
80107db6:	0f 22 d8             	mov    %eax,%cr3
    kfree(P2V(old_pa));
80107db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dbc:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc1:	89 04 24             	mov    %eax,(%esp)
80107dc4:	e8 97 aa ff ff       	call   80102860 <kfree>
    memmove((char*)va_rounded, buffer, PGSIZE);
80107dc9:	83 c4 0c             	add    $0xc,%esp
80107dcc:	68 00 10 00 00       	push   $0x1000
80107dd1:	68 e0 c5 10 80       	push   $0x8010c5e0
80107dd6:	56                   	push   %esi
80107dd7:	e8 34 cf ff ff       	call   80104d10 <memmove>
80107ddc:	83 c4 10             	add    $0x10,%esp
}
80107ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107de2:	89 f8                	mov    %edi,%eax
80107de4:	5b                   	pop    %ebx
80107de5:	5e                   	pop    %esi
80107de6:	5f                   	pop    %edi
80107de7:	5d                   	pop    %ebp
80107de8:	c3                   	ret    
80107de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove((char*)va_rounded, buffer, PGSIZE);
80107df0:	83 ec 04             	sub    $0x4,%esp
  return 1;
80107df3:	bf 01 00 00 00       	mov    $0x1,%edi
    memmove((char*)va_rounded, buffer, PGSIZE);
80107df8:	68 00 10 00 00       	push   $0x1000
80107dfd:	68 e0 c5 10 80       	push   $0x8010c5e0
80107e02:	56                   	push   %esi
80107e03:	e8 08 cf ff ff       	call   80104d10 <memmove>
80107e08:	83 c4 10             	add    $0x10,%esp
}
80107e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e0e:	89 f8                	mov    %edi,%eax
80107e10:	5b                   	pop    %ebx
80107e11:	5e                   	pop    %esi
80107e12:	5f                   	pop    %edi
80107e13:	5d                   	pop    %ebp
80107e14:	c3                   	ret    
80107e15:	8d 76 00             	lea    0x0(%esi),%esi
    panic("handle PF: cannot find rounded VA\n");
80107e18:	83 ec 0c             	sub    $0xc,%esp
80107e1b:	68 f0 8b 10 80       	push   $0x80108bf0
80107e20:	e8 6b 85 ff ff       	call   80100390 <panic>
80107e25:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107e28:	ba 80 01 00 00       	mov    $0x180,%edx
    is_need_swap = 1;
80107e2d:	bf 01 00 00 00       	mov    $0x1,%edi
    new_page_i_in_mem = next_i_in_mem_to_remove(p);
80107e32:	31 c9                	xor    %ecx,%ecx
80107e34:	e9 24 fe ff ff       	jmp    80107c5d <handle_pf+0x7d>
80107e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107e40:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80107e45:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107e4a:	e9 13 ff ff ff       	jmp    80107d62 <handle_pf+0x182>
    panic("handle_pf: walkdir failed\n");
80107e4f:	83 ec 0c             	sub    $0xc,%esp
80107e52:	68 48 8a 10 80       	push   $0x80108a48
80107e57:	e8 34 85 ff ff       	call   80100390 <panic>
    panic("handle PF: readFromSwapFile failed\n");
80107e5c:	83 ec 0c             	sub    $0xc,%esp
80107e5f:	68 a8 8b 10 80       	push   $0x80108ba8
80107e64:	e8 27 85 ff ff       	call   80100390 <panic>
      panic("handle PF: writeToSwapFile failed\n");
80107e69:	83 ec 0c             	sub    $0xc,%esp
80107e6c:	68 cc 8b 10 80       	push   $0x80108bcc
80107e71:	e8 1a 85 ff ff       	call   80100390 <panic>
80107e76:	8d 76 00             	lea    0x0(%esi),%esi
80107e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e80 <handle_cow>:


int
handle_cow(void) 
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 1c             	sub    $0x1c,%esp
  uint va, pa;
  char *mem;
  pte_t *pte;
  struct proc *p = myproc();
80107e89:	e8 a2 bf ff ff       	call   80103e30 <myproc>
80107e8e:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107e90:	0f 20 d3             	mov    %cr2,%ebx

  // cprintf("handling cow: ");

  va = rcr2();
  pte = walkpgdir(p->pgdir, (char*)va, 0);
80107e93:	8b 40 04             	mov    0x4(%eax),%eax
80107e96:	31 c9                	xor    %ecx,%ecx
80107e98:	89 da                	mov    %ebx,%edx
80107e9a:	e8 51 ef ff ff       	call   80106df0 <walkpgdir>
  if ((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0) {
80107e9f:	8b 46 04             	mov    0x4(%esi),%eax
80107ea2:	31 c9                	xor    %ecx,%ecx
80107ea4:	89 da                	mov    %ebx,%edx
80107ea6:	e8 45 ef ff ff       	call   80106df0 <walkpgdir>
80107eab:	85 c0                	test   %eax,%eax
80107ead:	0f 84 a3 00 00 00    	je     80107f56 <handle_cow+0xd6>
    panic("handle_pf: walkdir failed\n");
  }
  if ((*pte & PTE_W) || !(*pte & PTE_COW)) { // not COW or writable
80107eb3:	8b 10                	mov    (%eax),%edx
80107eb5:	89 c3                	mov    %eax,%ebx
    // cprintf("NOT cow\n");
    return 0;
80107eb7:	31 c0                	xor    %eax,%eax
  if ((*pte & PTE_W) || !(*pte & PTE_COW)) { // not COW or writable
80107eb9:	89 d1                	mov    %edx,%ecx
80107ebb:	81 e1 02 04 00 00    	and    $0x402,%ecx
80107ec1:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
80107ec7:	74 0f                	je     80107ed8 <handle_cow+0x58>
    *pte |= PTE_W;
  }

  lcr3(V2P(p->pgdir));
  return 1;
80107ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ecc:	5b                   	pop    %ebx
80107ecd:	5e                   	pop    %esi
80107ece:	5f                   	pop    %edi
80107ecf:	5d                   	pop    %ebp
80107ed0:	c3                   	ret    
80107ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pa = PTE_ADDR(*pte);
80107ed8:	89 d7                	mov    %edx,%edi
  if (get_ref_counter(pa) > 1) {  // handling copy
80107eda:	83 ec 0c             	sub    $0xc,%esp
  pa = PTE_ADDR(*pte);
80107edd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if (get_ref_counter(pa) > 1) {  // handling copy
80107ee3:	57                   	push   %edi
80107ee4:	e8 37 a8 ff ff       	call   80102720 <get_ref_counter>
80107ee9:	83 c4 10             	add    $0x10,%esp
80107eec:	83 f8 01             	cmp    $0x1,%eax
80107eef:	7f 27                	jg     80107f18 <handle_cow+0x98>
    *pte &= ~PTE_COW;     // not COW anymore
80107ef1:	8b 03                	mov    (%ebx),%eax
80107ef3:	80 e4 fb             	and    $0xfb,%ah
    *pte |= PTE_W;
80107ef6:	83 c8 02             	or     $0x2,%eax
80107ef9:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(p->pgdir));
80107efb:	8b 46 04             	mov    0x4(%esi),%eax
80107efe:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f03:	0f 22 d8             	mov    %eax,%cr3
80107f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80107f09:	b8 01 00 00 00       	mov    $0x1,%eax
80107f0e:	5b                   	pop    %ebx
80107f0f:	5e                   	pop    %esi
80107f10:	5f                   	pop    %edi
80107f11:	5d                   	pop    %ebp
80107f12:	c3                   	ret    
80107f13:	90                   	nop
80107f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((mem = kalloc()) == 0) {
80107f18:	e8 73 ab ff ff       	call   80102a90 <kalloc>
80107f1d:	85 c0                	test   %eax,%eax
80107f1f:	89 c2                	mov    %eax,%edx
80107f21:	74 40                	je     80107f63 <handle_cow+0xe3>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f23:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107f29:	83 ec 04             	sub    $0x4,%esp
80107f2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f2f:	68 00 10 00 00       	push   $0x1000
80107f34:	50                   	push   %eax
80107f35:	52                   	push   %edx
80107f36:	e8 d5 cd ff ff       	call   80104d10 <memmove>
    dec_counter(pa);
80107f3b:	89 3c 24             	mov    %edi,(%esp)
80107f3e:	e8 5d a8 ff ff       	call   801027a0 <dec_counter>
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
80107f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f46:	83 c4 10             	add    $0x10,%esp
80107f49:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107f4f:	83 ca 07             	or     $0x7,%edx
80107f52:	89 13                	mov    %edx,(%ebx)
80107f54:	eb a5                	jmp    80107efb <handle_cow+0x7b>
    panic("handle_pf: walkdir failed\n");
80107f56:	83 ec 0c             	sub    $0xc,%esp
80107f59:	68 48 8a 10 80       	push   $0x80108a48
80107f5e:	e8 2d 84 ff ff       	call   80100390 <panic>
      panic("COW: kalloc failed\n");
80107f63:	83 ec 0c             	sub    $0xc,%esp
80107f66:	68 63 8a 10 80       	push   $0x80108a63
80107f6b:	e8 20 84 ff ff       	call   80100390 <panic>
