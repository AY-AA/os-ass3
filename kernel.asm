
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
8010002d:	b8 20 34 10 80       	mov    $0x80103420,%eax
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
8010004c:	68 60 81 10 80       	push   $0x80108160
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
80100092:	68 67 81 10 80       	push   $0x80108167
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
80100193:	68 6e 81 10 80       	push   $0x8010816e
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
801001cc:	68 7f 81 10 80       	push   $0x8010817f
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
80100264:	68 86 81 10 80       	push   $0x80108186
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
801002db:	e8 e0 3a 00 00       	call   80103dc0 <myproc>
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
801003a9:	e8 02 29 00 00       	call   80102cb0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 81 10 80       	push   $0x8010818d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 41 8c 10 80 	movl   $0x80108c41,(%esp)
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
801003e8:	68 a1 81 10 80       	push   $0x801081a1
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
8010043a:	e8 11 5f 00 00       	call   80106350 <uartputc>
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
801004ec:	e8 5f 5e 00 00       	call   80106350 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 5e 00 00       	call   80106350 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 5e 00 00       	call   80106350 <uartputc>
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
80100551:	68 a5 81 10 80       	push   $0x801081a5
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
801005b1:	0f b6 92 d0 81 10 80 	movzbl -0x7fef7e30(%edx),%edx
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
801007d0:	ba b8 81 10 80       	mov    $0x801081b8,%edx
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
80100800:	68 bf 81 10 80       	push   $0x801081bf
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
801009c6:	68 c8 81 10 80       	push   $0x801081c8
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
80100a1c:	e8 9f 33 00 00       	call   80103dc0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 f4 26 00 00       	call   80103120 <begin_op>

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
80100a6f:	e8 1c 27 00 00       	call   80103190 <end_op>
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
80100a94:	e8 17 6f 00 00       	call   801079b0 <setupkvm>
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
80100ab9:	0f 84 cd 02 00 00    	je     80100d8c <exec+0x37c>
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
80100af6:	e8 35 6c 00 00       	call   80107730 <allocuvm>
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
80100b28:	e8 33 66 00 00       	call   80107160 <loaduvm>
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
80100b72:	e8 b9 6d 00 00       	call   80107930 <freevm>
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
80100b9a:	e8 f1 25 00 00       	call   80103190 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 6b 00 00       	call   80107730 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 6a 6d 00 00       	call   80107930 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 b8 25 00 00       	call   80103190 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 81 10 80       	push   $0x801081e1
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
80100c06:	e8 45 6e 00 00       	call   80107a50 <clearpteu>
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
80100c5d:	e8 5e 70 00 00       	call   80107cc0 <copyout>
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
80100cc7:	e8 f4 6f 00 00       	call   80107cc0 <copyout>
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
  if (check_policy()) {
80100d0d:	e8 3e 65 00 00       	call   80107250 <check_policy>
80100d12:	83 c4 10             	add    $0x10,%esp
80100d15:	85 c0                	test   %eax,%eax
80100d17:	74 32                	je     80100d4b <exec+0x33b>
80100d19:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d1f:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80100d25:	8d 97 c0 01 00 00    	lea    0x1c0(%edi),%edx
      if (curproc->memory_pages[i].is_used)
80100d2b:	8b b8 4c 01 00 00    	mov    0x14c(%eax),%edi
80100d31:	85 ff                	test   %edi,%edi
80100d33:	74 06                	je     80100d3b <exec+0x32b>
        curproc->memory_pages[i].pgdir = pgdir;
80100d35:	89 88 40 01 00 00    	mov    %ecx,0x140(%eax)
      if (curproc->file_pages[i].is_used)
80100d3b:	8b 78 0c             	mov    0xc(%eax),%edi
80100d3e:	85 ff                	test   %edi,%edi
80100d40:	74 02                	je     80100d44 <exec+0x334>
        curproc->file_pages[i].pgdir = pgdir; 
80100d42:	89 08                	mov    %ecx,(%eax)
80100d44:	83 c0 14             	add    $0x14,%eax
      for (i=0; i < MAX_PSYC_PAGES; i++) {
80100d47:	39 c2                	cmp    %eax,%edx
80100d49:	75 e0                	jne    80100d2b <exec+0x31b>
  oldpgdir = curproc->pgdir;
80100d4b:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  curproc->pgdir = pgdir;
80100d51:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  switchuvm(curproc);
80100d57:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80100d5a:	8b 79 04             	mov    0x4(%ecx),%edi
  curproc->sz = sz;
80100d5d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d5f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d62:	8b 41 18             	mov    0x18(%ecx),%eax
80100d65:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d6b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d6e:	8b 41 18             	mov    0x18(%ecx),%eax
80100d71:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d74:	51                   	push   %ecx
80100d75:	e8 56 62 00 00       	call   80106fd0 <switchuvm>
  freevm(oldpgdir);
80100d7a:	89 3c 24             	mov    %edi,(%esp)
80100d7d:	e8 ae 6b 00 00       	call   80107930 <freevm>
  return 0;
80100d82:	83 c4 10             	add    $0x10,%esp
80100d85:	31 c0                	xor    %eax,%eax
80100d87:	e9 f0 fc ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d8c:	be 00 20 00 00       	mov    $0x2000,%esi
80100d91:	e9 fb fd ff ff       	jmp    80100b91 <exec+0x181>
80100d96:	66 90                	xchg   %ax,%ax
80100d98:	66 90                	xchg   %ax,%ax
80100d9a:	66 90                	xchg   %ax,%ax
80100d9c:	66 90                	xchg   %ax,%ax
80100d9e:	66 90                	xchg   %ax,%ax

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
80100da6:	68 ed 81 10 80       	push   $0x801081ed
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
80100e6b:	68 f4 81 10 80       	push   $0x801081f4
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
80100f11:	e8 ba 29 00 00       	call   801038d0 <pipeclose>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb df                	jmp    80100efa <fileclose+0x7a>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f20:	e8 fb 21 00 00       	call   80103120 <begin_op>
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
80100f3a:	e9 51 22 00 00       	jmp    80103190 <end_op>
    panic("fileclose");
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	68 fc 81 10 80       	push   $0x801081fc
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
8010100d:	e9 6e 2a 00 00       	jmp    80103a80 <piperead>
80101012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101018:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010101d:	eb d7                	jmp    80100ff6 <fileread+0x56>
  panic("fileread");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 06 82 10 80       	push   $0x80108206
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
80101089:	e8 02 21 00 00       	call   80103190 <end_op>
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
801010b6:	e8 65 20 00 00       	call   80103120 <begin_op>
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
801010ed:	e8 9e 20 00 00       	call   80103190 <end_op>
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
8010112d:	e9 3e 28 00 00       	jmp    80103970 <pipewrite>
        panic("short filewrite");
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	68 0f 82 10 80       	push   $0x8010820f
8010113a:	e8 51 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 15 82 10 80       	push   $0x80108215
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
80101199:	e8 52 21 00 00       	call   801032f0 <log_write>
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
801011b3:	68 1f 82 10 80       	push   $0x8010821f
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
80101264:	68 32 82 10 80       	push   $0x80108232
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
8010127d:	e8 6e 20 00 00       	call   801032f0 <log_write>
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
801012ad:	e8 3e 20 00 00       	call   801032f0 <log_write>
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
80101392:	68 48 82 10 80       	push   $0x80108248
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
8010140e:	e8 dd 1e 00 00       	call   801032f0 <log_write>
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
80101467:	68 58 82 10 80       	push   $0x80108258
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
801014cc:	68 6b 82 10 80       	push   $0x8010826b
801014d1:	68 00 3a 11 80       	push   $0x80113a00
801014d6:	e8 35 35 00 00       	call   80104a10 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 72 82 10 80       	push   $0x80108272
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
80101539:	68 1c 83 10 80       	push   $0x8010831c
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
801015e0:	e8 0b 1d 00 00       	call   801032f0 <log_write>
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
80101603:	68 78 82 10 80       	push   $0x80108278
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
80101679:	e8 72 1c 00 00       	call   801032f0 <log_write>
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
8010177d:	68 90 82 10 80       	push   $0x80108290
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 8a 82 10 80       	push   $0x8010828a
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
801017d7:	68 9f 82 10 80       	push   $0x8010829f
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
80101b4b:	e8 a0 17 00 00       	call   801032f0 <log_write>
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
80101c82:	68 b9 82 10 80       	push   $0x801082b9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 a7 82 10 80       	push   $0x801082a7
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
80101cb9:	e8 02 21 00 00       	call   80103dc0 <myproc>
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
80101efb:	68 c8 82 10 80       	push   $0x801082c8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 b1 89 10 80       	push   $0x801089b1
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
80102001:	68 d5 82 10 80       	push   $0x801082d5
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
80102034:	e8 e7 10 00 00       	call   80103120 <begin_op>
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
80102062:	68 dd 82 10 80       	push   $0x801082dd
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
8010207d:	68 dc 82 10 80       	push   $0x801082dc
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
8010212d:	e8 5e 10 00 00       	call   80103190 <end_op>

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
80102181:	e8 0a 10 00 00       	call   80103190 <end_op>
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
801021ba:	e8 d1 0f 00 00       	call   80103190 <end_op>
    return -1;
801021bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c4:	e9 6e ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    panic("unlink: writei");
801021c9:	83 ec 0c             	sub    $0xc,%esp
801021cc:	68 f1 82 10 80       	push   $0x801082f1
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 df 82 10 80       	push   $0x801082df
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
80102200:	68 d5 82 10 80       	push   $0x801082d5
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
80102219:	e8 02 0f 00 00       	call   80103120 <begin_op>
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
80102268:	e8 23 0f 00 00       	call   80103190 <end_op>

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
80102279:	68 00 83 10 80       	push   $0x80108300
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
801023ab:	68 78 83 10 80       	push   $0x80108378
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 6f 83 10 80       	push   $0x8010836f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 8a 83 10 80       	push   $0x8010838a
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
801025ca:	68 a4 83 10 80       	push   $0x801083a4
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 8e 83 10 80       	push   $0x8010838e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 b9 83 10 80       	push   $0x801083b9
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
80102637:	68 d8 83 10 80       	push   $0x801083d8
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
free_pages(void)
{
801027e0:	55                   	push   %ebp
  // if(kmem.use_lock)
  //   release(&kmem.lock);

  // return free_p;
  return free_pages_counter;
}
801027e1:	a1 00 90 10 80       	mov    0x80109000,%eax
{
801027e6:	89 e5                	mov    %esp,%ebp
}
801027e8:	5d                   	pop    %ebp
801027e9:	c3                   	ret    
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
801027f5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027f8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801027fe:	0f 85 b9 00 00 00    	jne    801028bd <kfree+0xcd>
80102804:	81 fe c8 a8 15 80    	cmp    $0x8015a8c8,%esi
8010280a:	0f 82 ad 00 00 00    	jb     801028bd <kfree+0xcd>
80102810:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80102816:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010281c:	0f 87 9b 00 00 00    	ja     801028bd <kfree+0xcd>
    panic("kfree");

  if(kmem.use_lock)
80102822:	8b 15 94 56 11 80    	mov    0x80115694,%edx
80102828:	85 d2                	test   %edx,%edx
8010282a:	75 7c                	jne    801028a8 <kfree+0xb8>
    acquire(&kmem.lock);

  if (kmem.references_count[V2P(v) >> PTXSHIFT] > 0) {
8010282c:	c1 eb 0c             	shr    $0xc,%ebx
8010282f:	83 c3 0c             	add    $0xc,%ebx
80102832:	8b 04 9d 6c 56 11 80 	mov    -0x7feea994(,%ebx,4),%eax
80102839:	85 c0                	test   %eax,%eax
8010283b:	75 3b                	jne    80102878 <kfree+0x88>
    if(kmem.use_lock)
      release(&kmem.lock);
    return;
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010283d:	83 ec 04             	sub    $0x4,%esp
80102840:	68 00 10 00 00       	push   $0x1000
80102845:	6a 01                	push   $0x1
80102847:	56                   	push   %esi
80102848:	e8 13 24 00 00       	call   80104c60 <memset>

  r = (struct run*)v;
  r->next = kmem.freelist;
8010284d:	a1 98 56 11 80       	mov    0x80115698,%eax
  kmem.freelist = r;
  free_pages_counter ++;
  if(kmem.use_lock)
80102852:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
80102855:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
80102857:	a1 94 56 11 80       	mov    0x80115694,%eax
  free_pages_counter ++;
8010285c:	83 05 00 90 10 80 01 	addl   $0x1,0x80109000
  kmem.freelist = r;
80102863:	89 35 98 56 11 80    	mov    %esi,0x80115698
  if(kmem.use_lock)
80102869:	85 c0                	test   %eax,%eax
8010286b:	75 22                	jne    8010288f <kfree+0x9f>
    release(&kmem.lock);
}
8010286d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102870:	5b                   	pop    %ebx
80102871:	5e                   	pop    %esi
80102872:	5d                   	pop    %ebp
80102873:	c3                   	ret    
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kmem.references_count[V2P(v) >> PTXSHIFT] --;
80102878:	83 e8 01             	sub    $0x1,%eax
  if (kmem.references_count[V2P(v) >> PTXSHIFT] != 0) {
8010287b:	85 c0                	test   %eax,%eax
    kmem.references_count[V2P(v) >> PTXSHIFT] --;
8010287d:	89 04 9d 6c 56 11 80 	mov    %eax,-0x7feea994(,%ebx,4)
  if (kmem.references_count[V2P(v) >> PTXSHIFT] != 0) {
80102884:	74 b7                	je     8010283d <kfree+0x4d>
  if(kmem.use_lock)
80102886:	a1 94 56 11 80       	mov    0x80115694,%eax
8010288b:	85 c0                	test   %eax,%eax
8010288d:	74 de                	je     8010286d <kfree+0x7d>
      release(&kmem.lock);
8010288f:	c7 45 08 60 56 11 80 	movl   $0x80115660,0x8(%ebp)
}
80102896:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102899:	5b                   	pop    %ebx
8010289a:	5e                   	pop    %esi
8010289b:	5d                   	pop    %ebp
      release(&kmem.lock);
8010289c:	e9 6f 23 00 00       	jmp    80104c10 <release>
801028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801028a8:	83 ec 0c             	sub    $0xc,%esp
801028ab:	68 60 56 11 80       	push   $0x80115660
801028b0:	e8 9b 22 00 00       	call   80104b50 <acquire>
801028b5:	83 c4 10             	add    $0x10,%esp
801028b8:	e9 6f ff ff ff       	jmp    8010282c <kfree+0x3c>
    panic("kfree");
801028bd:	83 ec 0c             	sub    $0xc,%esp
801028c0:	68 0a 84 10 80       	push   $0x8010840a
801028c5:	e8 c6 da ff ff       	call   80100390 <panic>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <freerange>:
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
801028d3:	56                   	push   %esi
801028d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801028e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028ed:	39 de                	cmp    %ebx,%esi
801028ef:	72 37                	jb     80102928 <freerange+0x58>
801028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
801028f8:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801028fe:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102901:	c1 e8 0c             	shr    $0xc,%eax
80102904:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
8010290b:	00 00 00 00 
    kfree(p);
8010290f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102915:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010291b:	50                   	push   %eax
8010291c:	e8 cf fe ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102921:	83 c4 10             	add    $0x10,%esp
80102924:	39 f3                	cmp    %esi,%ebx
80102926:	76 d0                	jbe    801028f8 <freerange+0x28>
}
80102928:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010292b:	5b                   	pop    %ebx
8010292c:	5e                   	pop    %esi
8010292d:	5d                   	pop    %ebp
8010292e:	c3                   	ret    
8010292f:	90                   	nop

80102930 <kinit1>:
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	56                   	push   %esi
80102934:	53                   	push   %ebx
80102935:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102938:	83 ec 08             	sub    $0x8,%esp
8010293b:	68 10 84 10 80       	push   $0x80108410
80102940:	68 60 56 11 80       	push   $0x80115660
80102945:	e8 c6 20 00 00       	call   80104a10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010294a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
8010294d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102950:	c7 05 94 56 11 80 00 	movl   $0x0,0x80115694
80102957:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010295a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102960:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102966:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010296c:	39 de                	cmp    %ebx,%esi
8010296e:	72 30                	jb     801029a0 <kinit1+0x70>
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102970:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
80102976:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
80102979:	c1 e8 0c             	shr    $0xc,%eax
8010297c:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
80102983:	00 00 00 00 
    kfree(p);
80102987:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
8010298d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102993:	50                   	push   %eax
80102994:	e8 57 fe ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102999:	83 c4 10             	add    $0x10,%esp
8010299c:	39 de                	cmp    %ebx,%esi
8010299e:	73 d0                	jae    80102970 <kinit1+0x40>
}
801029a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029a3:	5b                   	pop    %ebx
801029a4:	5e                   	pop    %esi
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	89 f6                	mov    %esi,%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kinit2>:
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	56                   	push   %esi
801029b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801029bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801029c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029cd:	39 de                	cmp    %ebx,%esi
801029cf:	72 37                	jb     80102a08 <kinit2+0x58>
801029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
801029d8:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801029de:	83 ec 0c             	sub    $0xc,%esp
    kmem.references_count[V2P(p) >> PTXSHIFT] = 0;
801029e1:	c1 e8 0c             	shr    $0xc,%eax
801029e4:	c7 04 85 9c 56 11 80 	movl   $0x0,-0x7feea964(,%eax,4)
801029eb:	00 00 00 00 
    kfree(p);
801029ef:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801029f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029fb:	50                   	push   %eax
801029fc:	e8 ef fd ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a01:	83 c4 10             	add    $0x10,%esp
80102a04:	39 de                	cmp    %ebx,%esi
80102a06:	73 d0                	jae    801029d8 <kinit2+0x28>
  kmem.use_lock = 1;
80102a08:	c7 05 94 56 11 80 01 	movl   $0x1,0x80115694
80102a0f:	00 00 00 
}
80102a12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a15:	5b                   	pop    %ebx
80102a16:	5e                   	pop    %esi
80102a17:	5d                   	pop    %ebp
80102a18:	c3                   	ret    
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  // cprintf("HERE\n");
  if(kmem.use_lock)
80102a26:	8b 15 94 56 11 80    	mov    0x80115694,%edx
80102a2c:	85 d2                	test   %edx,%edx
80102a2e:	75 50                	jne    80102a80 <kalloc+0x60>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a30:	a1 98 56 11 80       	mov    0x80115698,%eax
  if(r) {
80102a35:	85 c0                	test   %eax,%eax
80102a37:	74 27                	je     80102a60 <kalloc+0x40>
    kmem.freelist = r->next;
80102a39:	8b 08                	mov    (%eax),%ecx
    kmem.references_count[V2P(r) >> PTXSHIFT] = 1;
    free_pages_counter --;
80102a3b:	83 2d 00 90 10 80 01 	subl   $0x1,0x80109000
    kmem.freelist = r->next;
80102a42:	89 0d 98 56 11 80    	mov    %ecx,0x80115698
    kmem.references_count[V2P(r) >> PTXSHIFT] = 1;
80102a48:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80102a4e:	c1 e9 0c             	shr    $0xc,%ecx
80102a51:	c7 04 8d 9c 56 11 80 	movl   $0x1,-0x7feea964(,%ecx,4)
80102a58:	01 00 00 00 
  }

  if(kmem.use_lock)
80102a5c:	85 d2                	test   %edx,%edx
80102a5e:	75 08                	jne    80102a68 <kalloc+0x48>
    release(&kmem.lock);
  return (char*)r;
}
80102a60:	c9                   	leave  
80102a61:	c3                   	ret    
80102a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102a68:	83 ec 0c             	sub    $0xc,%esp
80102a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a6e:	68 60 56 11 80       	push   $0x80115660
80102a73:	e8 98 21 00 00       	call   80104c10 <release>
  return (char*)r;
80102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a7b:	83 c4 10             	add    $0x10,%esp
}
80102a7e:	c9                   	leave  
80102a7f:	c3                   	ret    
    acquire(&kmem.lock);
80102a80:	83 ec 0c             	sub    $0xc,%esp
80102a83:	68 60 56 11 80       	push   $0x80115660
80102a88:	e8 c3 20 00 00       	call   80104b50 <acquire>
  r = kmem.freelist;
80102a8d:	a1 98 56 11 80       	mov    0x80115698,%eax
  if(r) {
80102a92:	83 c4 10             	add    $0x10,%esp
80102a95:	8b 15 94 56 11 80    	mov    0x80115694,%edx
80102a9b:	85 c0                	test   %eax,%eax
80102a9d:	75 9a                	jne    80102a39 <kalloc+0x19>
80102a9f:	eb bb                	jmp    80102a5c <kalloc+0x3c>
80102aa1:	66 90                	xchg   %ax,%ax
80102aa3:	66 90                	xchg   %ax,%ax
80102aa5:	66 90                	xchg   %ax,%ax
80102aa7:	66 90                	xchg   %ax,%ax
80102aa9:	66 90                	xchg   %ax,%ax
80102aab:	66 90                	xchg   %ax,%ax
80102aad:	66 90                	xchg   %ax,%ax
80102aaf:	90                   	nop

80102ab0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ab5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ab6:	a8 01                	test   $0x1,%al
80102ab8:	0f 84 c2 00 00 00    	je     80102b80 <kbdgetc+0xd0>
80102abe:	ba 60 00 00 00       	mov    $0x60,%edx
80102ac3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102ac4:	0f b6 d0             	movzbl %al,%edx
80102ac7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102acd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102ad3:	0f 84 7f 00 00 00    	je     80102b58 <kbdgetc+0xa8>
{
80102ad9:	55                   	push   %ebp
80102ada:	89 e5                	mov    %esp,%ebp
80102adc:	53                   	push   %ebx
80102add:	89 cb                	mov    %ecx,%ebx
80102adf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ae2:	84 c0                	test   %al,%al
80102ae4:	78 4a                	js     80102b30 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ae6:	85 db                	test   %ebx,%ebx
80102ae8:	74 09                	je     80102af3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102aea:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102aed:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102af0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102af3:	0f b6 82 40 85 10 80 	movzbl -0x7fef7ac0(%edx),%eax
80102afa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102afc:	0f b6 82 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%eax
80102b03:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b05:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102b07:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102b0d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102b10:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b13:	8b 04 85 20 84 10 80 	mov    -0x7fef7be0(,%eax,4),%eax
80102b1a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102b1e:	74 31                	je     80102b51 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102b20:	8d 50 9f             	lea    -0x61(%eax),%edx
80102b23:	83 fa 19             	cmp    $0x19,%edx
80102b26:	77 40                	ja     80102b68 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102b28:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102b2b:	5b                   	pop    %ebx
80102b2c:	5d                   	pop    %ebp
80102b2d:	c3                   	ret    
80102b2e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102b30:	83 e0 7f             	and    $0x7f,%eax
80102b33:	85 db                	test   %ebx,%ebx
80102b35:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102b38:	0f b6 82 40 85 10 80 	movzbl -0x7fef7ac0(%edx),%eax
80102b3f:	83 c8 40             	or     $0x40,%eax
80102b42:	0f b6 c0             	movzbl %al,%eax
80102b45:	f7 d0                	not    %eax
80102b47:	21 c1                	and    %eax,%ecx
    return 0;
80102b49:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102b4b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102b51:	5b                   	pop    %ebx
80102b52:	5d                   	pop    %ebp
80102b53:	c3                   	ret    
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102b58:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102b5b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b5d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102b63:	c3                   	ret    
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102b68:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b6b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b6e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102b6f:	83 f9 1a             	cmp    $0x1a,%ecx
80102b72:	0f 42 c2             	cmovb  %edx,%eax
}
80102b75:	5d                   	pop    %ebp
80102b76:	c3                   	ret    
80102b77:	89 f6                	mov    %esi,%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b85:	c3                   	ret    
80102b86:	8d 76 00             	lea    0x0(%esi),%esi
80102b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b90 <kbdintr>:

void
kbdintr(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b96:	68 b0 2a 10 80       	push   $0x80102ab0
80102b9b:	e8 70 dc ff ff       	call   80100810 <consoleintr>
}
80102ba0:	83 c4 10             	add    $0x10,%esp
80102ba3:	c9                   	leave  
80102ba4:	c3                   	ret    
80102ba5:	66 90                	xchg   %ax,%ax
80102ba7:	66 90                	xchg   %ax,%ax
80102ba9:	66 90                	xchg   %ax,%ax
80102bab:	66 90                	xchg   %ax,%ax
80102bad:	66 90                	xchg   %ax,%ax
80102baf:	90                   	nop

80102bb0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102bb0:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
{
80102bb5:	55                   	push   %ebp
80102bb6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102bb8:	85 c0                	test   %eax,%eax
80102bba:	0f 84 c8 00 00 00    	je     80102c88 <lapicinit+0xd8>
  lapic[index] = value;
80102bc0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102bc7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bcd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102bd4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bda:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102be1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102be4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102be7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bf4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102bfb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c01:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102c08:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102c0e:	8b 50 30             	mov    0x30(%eax),%edx
80102c11:	c1 ea 10             	shr    $0x10,%edx
80102c14:	80 fa 03             	cmp    $0x3,%dl
80102c17:	77 77                	ja     80102c90 <lapicinit+0xe0>
  lapic[index] = value;
80102c19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102c20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c23:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c64:	8b 50 20             	mov    0x20(%eax),%edx
80102c67:	89 f6                	mov    %esi,%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c76:	80 e6 10             	and    $0x10,%dh
80102c79:	75 f5                	jne    80102c70 <lapicinit+0xc0>
  lapic[index] = value;
80102c7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c85:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c88:	5d                   	pop    %ebp
80102c89:	c3                   	ret    
80102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102c90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9a:	8b 50 20             	mov    0x20(%eax),%edx
80102c9d:	e9 77 ff ff ff       	jmp    80102c19 <lapicinit+0x69>
80102ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102cb0:	8b 15 9c d6 14 80    	mov    0x8014d69c,%edx
{
80102cb6:	55                   	push   %ebp
80102cb7:	31 c0                	xor    %eax,%eax
80102cb9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102cbb:	85 d2                	test   %edx,%edx
80102cbd:	74 06                	je     80102cc5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102cbf:	8b 42 20             	mov    0x20(%edx),%eax
80102cc2:	c1 e8 18             	shr    $0x18,%eax
}
80102cc5:	5d                   	pop    %ebp
80102cc6:	c3                   	ret    
80102cc7:	89 f6                	mov    %esi,%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102cd0:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
{
80102cd5:	55                   	push   %ebp
80102cd6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102cd8:	85 c0                	test   %eax,%eax
80102cda:	74 0d                	je     80102ce9 <lapiceoi+0x19>
  lapic[index] = value;
80102cdc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ce3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ce9:	5d                   	pop    %ebp
80102cea:	c3                   	ret    
80102ceb:	90                   	nop
80102cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
}
80102cf3:	5d                   	pop    %ebp
80102cf4:	c3                   	ret    
80102cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102d00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102d06:	ba 70 00 00 00       	mov    $0x70,%edx
80102d0b:	89 e5                	mov    %esp,%ebp
80102d0d:	53                   	push   %ebx
80102d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d14:	ee                   	out    %al,(%dx)
80102d15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102d1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102d20:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102d22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102d25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102d2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d2d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102d30:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102d33:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d3e:	a1 9c d6 14 80       	mov    0x8014d69c,%eax
80102d43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d8a:	5b                   	pop    %ebx
80102d8b:	5d                   	pop    %ebp
80102d8c:	c3                   	ret    
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi

80102d90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d90:	55                   	push   %ebp
80102d91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d96:	ba 70 00 00 00       	mov    $0x70,%edx
80102d9b:	89 e5                	mov    %esp,%ebp
80102d9d:	57                   	push   %edi
80102d9e:	56                   	push   %esi
80102d9f:	53                   	push   %ebx
80102da0:	83 ec 4c             	sub    $0x4c,%esp
80102da3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da4:	ba 71 00 00 00       	mov    $0x71,%edx
80102da9:	ec                   	in     (%dx),%al
80102daa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dad:	bb 70 00 00 00       	mov    $0x70,%ebx
80102db2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
80102db8:	31 c0                	xor    %eax,%eax
80102dba:	89 da                	mov    %ebx,%edx
80102dbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102dc2:	89 ca                	mov    %ecx,%edx
80102dc4:	ec                   	in     (%dx),%al
80102dc5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc8:	89 da                	mov    %ebx,%edx
80102dca:	b8 02 00 00 00       	mov    $0x2,%eax
80102dcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd0:	89 ca                	mov    %ecx,%edx
80102dd2:	ec                   	in     (%dx),%al
80102dd3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd6:	89 da                	mov    %ebx,%edx
80102dd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ddd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dde:	89 ca                	mov    %ecx,%edx
80102de0:	ec                   	in     (%dx),%al
80102de1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de4:	89 da                	mov    %ebx,%edx
80102de6:	b8 07 00 00 00       	mov    $0x7,%eax
80102deb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dec:	89 ca                	mov    %ecx,%edx
80102dee:	ec                   	in     (%dx),%al
80102def:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df2:	89 da                	mov    %ebx,%edx
80102df4:	b8 08 00 00 00       	mov    $0x8,%eax
80102df9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dfa:	89 ca                	mov    %ecx,%edx
80102dfc:	ec                   	in     (%dx),%al
80102dfd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dff:	89 da                	mov    %ebx,%edx
80102e01:	b8 09 00 00 00       	mov    $0x9,%eax
80102e06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e07:	89 ca                	mov    %ecx,%edx
80102e09:	ec                   	in     (%dx),%al
80102e0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e0c:	89 da                	mov    %ebx,%edx
80102e0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e14:	89 ca                	mov    %ecx,%edx
80102e16:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e17:	84 c0                	test   %al,%al
80102e19:	78 9d                	js     80102db8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102e1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102e1f:	89 fa                	mov    %edi,%edx
80102e21:	0f b6 fa             	movzbl %dl,%edi
80102e24:	89 f2                	mov    %esi,%edx
80102e26:	0f b6 f2             	movzbl %dl,%esi
80102e29:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e2c:	89 da                	mov    %ebx,%edx
80102e2e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e31:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e34:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e38:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e3b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e49:	31 c0                	xor    %eax,%eax
80102e4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4c:	89 ca                	mov    %ecx,%edx
80102e4e:	ec                   	in     (%dx),%al
80102e4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e52:	89 da                	mov    %ebx,%edx
80102e54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e57:	b8 02 00 00 00       	mov    $0x2,%eax
80102e5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e5d:	89 ca                	mov    %ecx,%edx
80102e5f:	ec                   	in     (%dx),%al
80102e60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e63:	89 da                	mov    %ebx,%edx
80102e65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e68:	b8 04 00 00 00       	mov    $0x4,%eax
80102e6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6e:	89 ca                	mov    %ecx,%edx
80102e70:	ec                   	in     (%dx),%al
80102e71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e74:	89 da                	mov    %ebx,%edx
80102e76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e79:	b8 07 00 00 00       	mov    $0x7,%eax
80102e7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7f:	89 ca                	mov    %ecx,%edx
80102e81:	ec                   	in     (%dx),%al
80102e82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e85:	89 da                	mov    %ebx,%edx
80102e87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e90:	89 ca                	mov    %ecx,%edx
80102e92:	ec                   	in     (%dx),%al
80102e93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e96:	89 da                	mov    %ebx,%edx
80102e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102ea0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea1:	89 ca                	mov    %ecx,%edx
80102ea3:	ec                   	in     (%dx),%al
80102ea4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ea7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102eaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ead:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102eb0:	6a 18                	push   $0x18
80102eb2:	50                   	push   %eax
80102eb3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102eb6:	50                   	push   %eax
80102eb7:	e8 f4 1d 00 00       	call   80104cb0 <memcmp>
80102ebc:	83 c4 10             	add    $0x10,%esp
80102ebf:	85 c0                	test   %eax,%eax
80102ec1:	0f 85 f1 fe ff ff    	jne    80102db8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ec7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ecb:	75 78                	jne    80102f45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ecd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ed0:	89 c2                	mov    %eax,%edx
80102ed2:	83 e0 0f             	and    $0xf,%eax
80102ed5:	c1 ea 04             	shr    $0x4,%edx
80102ed8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102edb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ede:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ee1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ee4:	89 c2                	mov    %eax,%edx
80102ee6:	83 e0 0f             	and    $0xf,%eax
80102ee9:	c1 ea 04             	shr    $0x4,%edx
80102eec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ef2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ef5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ef8:	89 c2                	mov    %eax,%edx
80102efa:	83 e0 0f             	and    $0xf,%eax
80102efd:	c1 ea 04             	shr    $0x4,%edx
80102f00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102f09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f0c:	89 c2                	mov    %eax,%edx
80102f0e:	83 e0 0f             	and    $0xf,%eax
80102f11:	c1 ea 04             	shr    $0x4,%edx
80102f14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102f1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f20:	89 c2                	mov    %eax,%edx
80102f22:	83 e0 0f             	and    $0xf,%eax
80102f25:	c1 ea 04             	shr    $0x4,%edx
80102f28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f34:	89 c2                	mov    %eax,%edx
80102f36:	83 e0 0f             	and    $0xf,%eax
80102f39:	c1 ea 04             	shr    $0x4,%edx
80102f3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f45:	8b 75 08             	mov    0x8(%ebp),%esi
80102f48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f4b:	89 06                	mov    %eax,(%esi)
80102f4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f50:	89 46 04             	mov    %eax,0x4(%esi)
80102f53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f56:	89 46 08             	mov    %eax,0x8(%esi)
80102f59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f62:	89 46 10             	mov    %eax,0x10(%esi)
80102f65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f75:	5b                   	pop    %ebx
80102f76:	5e                   	pop    %esi
80102f77:	5f                   	pop    %edi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	66 90                	xchg   %ax,%ax
80102f7c:	66 90                	xchg   %ax,%ax
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f80:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
80102f86:	85 c9                	test   %ecx,%ecx
80102f88:	0f 8e 8a 00 00 00    	jle    80103018 <install_trans+0x98>
{
80102f8e:	55                   	push   %ebp
80102f8f:	89 e5                	mov    %esp,%ebp
80102f91:	57                   	push   %edi
80102f92:	56                   	push   %esi
80102f93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f94:	31 db                	xor    %ebx,%ebx
{
80102f96:	83 ec 0c             	sub    $0xc,%esp
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102fa0:	a1 d4 d6 14 80       	mov    0x8014d6d4,%eax
80102fa5:	83 ec 08             	sub    $0x8,%esp
80102fa8:	01 d8                	add    %ebx,%eax
80102faa:	83 c0 01             	add    $0x1,%eax
80102fad:	50                   	push   %eax
80102fae:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
80102fb4:	e8 17 d1 ff ff       	call   801000d0 <bread>
80102fb9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fbb:	58                   	pop    %eax
80102fbc:	5a                   	pop    %edx
80102fbd:	ff 34 9d ec d6 14 80 	pushl  -0x7feb2914(,%ebx,4)
80102fc4:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fcd:	e8 fe d0 ff ff       	call   801000d0 <bread>
80102fd2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fd4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102fd7:	83 c4 0c             	add    $0xc,%esp
80102fda:	68 00 02 00 00       	push   $0x200
80102fdf:	50                   	push   %eax
80102fe0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fe3:	50                   	push   %eax
80102fe4:	e8 27 1d 00 00       	call   80104d10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fe9:	89 34 24             	mov    %esi,(%esp)
80102fec:	e8 af d1 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ff1:	89 3c 24             	mov    %edi,(%esp)
80102ff4:	e8 e7 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ff9:	89 34 24             	mov    %esi,(%esp)
80102ffc:	e8 df d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	39 1d e8 d6 14 80    	cmp    %ebx,0x8014d6e8
8010300a:	7f 94                	jg     80102fa0 <install_trans+0x20>
  }
}
8010300c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010300f:	5b                   	pop    %ebx
80103010:	5e                   	pop    %esi
80103011:	5f                   	pop    %edi
80103012:	5d                   	pop    %ebp
80103013:	c3                   	ret    
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103018:	f3 c3                	repz ret 
8010301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103020 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	56                   	push   %esi
80103024:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	ff 35 d4 d6 14 80    	pushl  0x8014d6d4
8010302e:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103039:	8b 1d e8 d6 14 80    	mov    0x8014d6e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010303f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103042:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103044:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103046:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103049:	7e 16                	jle    80103061 <write_head+0x41>
8010304b:	c1 e3 02             	shl    $0x2,%ebx
8010304e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103050:	8b 8a ec d6 14 80    	mov    -0x7feb2914(%edx),%ecx
80103056:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010305a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010305d:	39 da                	cmp    %ebx,%edx
8010305f:	75 ef                	jne    80103050 <write_head+0x30>
  }
  bwrite(buf);
80103061:	83 ec 0c             	sub    $0xc,%esp
80103064:	56                   	push   %esi
80103065:	e8 36 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010306a:	89 34 24             	mov    %esi,(%esp)
8010306d:	e8 6e d1 ff ff       	call   801001e0 <brelse>
}
80103072:	83 c4 10             	add    $0x10,%esp
80103075:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103078:	5b                   	pop    %ebx
80103079:	5e                   	pop    %esi
8010307a:	5d                   	pop    %ebp
8010307b:	c3                   	ret    
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103080 <initlog>:
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 2c             	sub    $0x2c,%esp
80103087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010308a:	68 40 86 10 80       	push   $0x80108640
8010308f:	68 a0 d6 14 80       	push   $0x8014d6a0
80103094:	e8 77 19 00 00       	call   80104a10 <initlock>
  readsb(dev, &sb);
80103099:	58                   	pop    %eax
8010309a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010309d:	5a                   	pop    %edx
8010309e:	50                   	push   %eax
8010309f:	53                   	push   %ebx
801030a0:	e8 db e3 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
801030a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801030a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801030ab:	59                   	pop    %ecx
  log.dev = dev;
801030ac:	89 1d e4 d6 14 80    	mov    %ebx,0x8014d6e4
  log.size = sb.nlog;
801030b2:	89 15 d8 d6 14 80    	mov    %edx,0x8014d6d8
  log.start = sb.logstart;
801030b8:	a3 d4 d6 14 80       	mov    %eax,0x8014d6d4
  struct buf *buf = bread(log.dev, log.start);
801030bd:	5a                   	pop    %edx
801030be:	50                   	push   %eax
801030bf:	53                   	push   %ebx
801030c0:	e8 0b d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801030c5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801030c8:	83 c4 10             	add    $0x10,%esp
801030cb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801030cd:	89 1d e8 d6 14 80    	mov    %ebx,0x8014d6e8
  for (i = 0; i < log.lh.n; i++) {
801030d3:	7e 1c                	jle    801030f1 <initlog+0x71>
801030d5:	c1 e3 02             	shl    $0x2,%ebx
801030d8:	31 d2                	xor    %edx,%edx
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801030e0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801030e4:	83 c2 04             	add    $0x4,%edx
801030e7:	89 8a e8 d6 14 80    	mov    %ecx,-0x7feb2918(%edx)
  for (i = 0; i < log.lh.n; i++) {
801030ed:	39 d3                	cmp    %edx,%ebx
801030ef:	75 ef                	jne    801030e0 <initlog+0x60>
  brelse(buf);
801030f1:	83 ec 0c             	sub    $0xc,%esp
801030f4:	50                   	push   %eax
801030f5:	e8 e6 d0 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030fa:	e8 81 fe ff ff       	call   80102f80 <install_trans>
  log.lh.n = 0;
801030ff:	c7 05 e8 d6 14 80 00 	movl   $0x0,0x8014d6e8
80103106:	00 00 00 
  write_head(); // clear the log
80103109:	e8 12 ff ff ff       	call   80103020 <write_head>
}
8010310e:	83 c4 10             	add    $0x10,%esp
80103111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103114:	c9                   	leave  
80103115:	c3                   	ret    
80103116:	8d 76 00             	lea    0x0(%esi),%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103120 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103126:	68 a0 d6 14 80       	push   $0x8014d6a0
8010312b:	e8 20 1a 00 00       	call   80104b50 <acquire>
80103130:	83 c4 10             	add    $0x10,%esp
80103133:	eb 18                	jmp    8010314d <begin_op+0x2d>
80103135:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103138:	83 ec 08             	sub    $0x8,%esp
8010313b:	68 a0 d6 14 80       	push   $0x8014d6a0
80103140:	68 a0 d6 14 80       	push   $0x8014d6a0
80103145:	e8 f6 13 00 00       	call   80104540 <sleep>
8010314a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010314d:	a1 e0 d6 14 80       	mov    0x8014d6e0,%eax
80103152:	85 c0                	test   %eax,%eax
80103154:	75 e2                	jne    80103138 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103156:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
8010315b:	8b 15 e8 d6 14 80    	mov    0x8014d6e8,%edx
80103161:	83 c0 01             	add    $0x1,%eax
80103164:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103167:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010316a:	83 fa 1e             	cmp    $0x1e,%edx
8010316d:	7f c9                	jg     80103138 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010316f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103172:	a3 dc d6 14 80       	mov    %eax,0x8014d6dc
      release(&log.lock);
80103177:	68 a0 d6 14 80       	push   $0x8014d6a0
8010317c:	e8 8f 1a 00 00       	call   80104c10 <release>
      break;
    }
  }
}
80103181:	83 c4 10             	add    $0x10,%esp
80103184:	c9                   	leave  
80103185:	c3                   	ret    
80103186:	8d 76 00             	lea    0x0(%esi),%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103190 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103199:	68 a0 d6 14 80       	push   $0x8014d6a0
8010319e:	e8 ad 19 00 00       	call   80104b50 <acquire>
  log.outstanding -= 1;
801031a3:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
  if(log.committing)
801031a8:	8b 35 e0 d6 14 80    	mov    0x8014d6e0,%esi
801031ae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801031b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801031b4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801031b6:	89 1d dc d6 14 80    	mov    %ebx,0x8014d6dc
  if(log.committing)
801031bc:	0f 85 1a 01 00 00    	jne    801032dc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801031c2:	85 db                	test   %ebx,%ebx
801031c4:	0f 85 ee 00 00 00    	jne    801032b8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801031ca:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801031cd:	c7 05 e0 d6 14 80 01 	movl   $0x1,0x8014d6e0
801031d4:	00 00 00 
  release(&log.lock);
801031d7:	68 a0 d6 14 80       	push   $0x8014d6a0
801031dc:	e8 2f 1a 00 00       	call   80104c10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031e1:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
801031e7:	83 c4 10             	add    $0x10,%esp
801031ea:	85 c9                	test   %ecx,%ecx
801031ec:	0f 8e 85 00 00 00    	jle    80103277 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031f2:	a1 d4 d6 14 80       	mov    0x8014d6d4,%eax
801031f7:	83 ec 08             	sub    $0x8,%esp
801031fa:	01 d8                	add    %ebx,%eax
801031fc:	83 c0 01             	add    $0x1,%eax
801031ff:	50                   	push   %eax
80103200:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
80103206:	e8 c5 ce ff ff       	call   801000d0 <bread>
8010320b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010320d:	58                   	pop    %eax
8010320e:	5a                   	pop    %edx
8010320f:	ff 34 9d ec d6 14 80 	pushl  -0x7feb2914(,%ebx,4)
80103216:	ff 35 e4 d6 14 80    	pushl  0x8014d6e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010321c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010321f:	e8 ac ce ff ff       	call   801000d0 <bread>
80103224:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103226:	8d 40 5c             	lea    0x5c(%eax),%eax
80103229:	83 c4 0c             	add    $0xc,%esp
8010322c:	68 00 02 00 00       	push   $0x200
80103231:	50                   	push   %eax
80103232:	8d 46 5c             	lea    0x5c(%esi),%eax
80103235:	50                   	push   %eax
80103236:	e8 d5 1a 00 00       	call   80104d10 <memmove>
    bwrite(to);  // write the log
8010323b:	89 34 24             	mov    %esi,(%esp)
8010323e:	e8 5d cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103243:	89 3c 24             	mov    %edi,(%esp)
80103246:	e8 95 cf ff ff       	call   801001e0 <brelse>
    brelse(to);
8010324b:	89 34 24             	mov    %esi,(%esp)
8010324e:	e8 8d cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103253:	83 c4 10             	add    $0x10,%esp
80103256:	3b 1d e8 d6 14 80    	cmp    0x8014d6e8,%ebx
8010325c:	7c 94                	jl     801031f2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010325e:	e8 bd fd ff ff       	call   80103020 <write_head>
    install_trans(); // Now install writes to home locations
80103263:	e8 18 fd ff ff       	call   80102f80 <install_trans>
    log.lh.n = 0;
80103268:	c7 05 e8 d6 14 80 00 	movl   $0x0,0x8014d6e8
8010326f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103272:	e8 a9 fd ff ff       	call   80103020 <write_head>
    acquire(&log.lock);
80103277:	83 ec 0c             	sub    $0xc,%esp
8010327a:	68 a0 d6 14 80       	push   $0x8014d6a0
8010327f:	e8 cc 18 00 00       	call   80104b50 <acquire>
    wakeup(&log);
80103284:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
    log.committing = 0;
8010328b:	c7 05 e0 d6 14 80 00 	movl   $0x0,0x8014d6e0
80103292:	00 00 00 
    wakeup(&log);
80103295:	e8 96 14 00 00       	call   80104730 <wakeup>
    release(&log.lock);
8010329a:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
801032a1:	e8 6a 19 00 00       	call   80104c10 <release>
801032a6:	83 c4 10             	add    $0x10,%esp
}
801032a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5f                   	pop    %edi
801032af:	5d                   	pop    %ebp
801032b0:	c3                   	ret    
801032b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	68 a0 d6 14 80       	push   $0x8014d6a0
801032c0:	e8 6b 14 00 00       	call   80104730 <wakeup>
  release(&log.lock);
801032c5:	c7 04 24 a0 d6 14 80 	movl   $0x8014d6a0,(%esp)
801032cc:	e8 3f 19 00 00       	call   80104c10 <release>
801032d1:	83 c4 10             	add    $0x10,%esp
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d7:	5b                   	pop    %ebx
801032d8:	5e                   	pop    %esi
801032d9:	5f                   	pop    %edi
801032da:	5d                   	pop    %ebp
801032db:	c3                   	ret    
    panic("log.committing");
801032dc:	83 ec 0c             	sub    $0xc,%esp
801032df:	68 44 86 10 80       	push   $0x80108644
801032e4:	e8 a7 d0 ff ff       	call   80100390 <panic>
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032f7:	8b 15 e8 d6 14 80    	mov    0x8014d6e8,%edx
{
801032fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103300:	83 fa 1d             	cmp    $0x1d,%edx
80103303:	0f 8f 9d 00 00 00    	jg     801033a6 <log_write+0xb6>
80103309:	a1 d8 d6 14 80       	mov    0x8014d6d8,%eax
8010330e:	83 e8 01             	sub    $0x1,%eax
80103311:	39 c2                	cmp    %eax,%edx
80103313:	0f 8d 8d 00 00 00    	jge    801033a6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103319:	a1 dc d6 14 80       	mov    0x8014d6dc,%eax
8010331e:	85 c0                	test   %eax,%eax
80103320:	0f 8e 8d 00 00 00    	jle    801033b3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	68 a0 d6 14 80       	push   $0x8014d6a0
8010332e:	e8 1d 18 00 00       	call   80104b50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103333:	8b 0d e8 d6 14 80    	mov    0x8014d6e8,%ecx
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	83 f9 00             	cmp    $0x0,%ecx
8010333f:	7e 57                	jle    80103398 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103341:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103344:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103346:	3b 15 ec d6 14 80    	cmp    0x8014d6ec,%edx
8010334c:	75 0b                	jne    80103359 <log_write+0x69>
8010334e:	eb 38                	jmp    80103388 <log_write+0x98>
80103350:	39 14 85 ec d6 14 80 	cmp    %edx,-0x7feb2914(,%eax,4)
80103357:	74 2f                	je     80103388 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103359:	83 c0 01             	add    $0x1,%eax
8010335c:	39 c1                	cmp    %eax,%ecx
8010335e:	75 f0                	jne    80103350 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103360:	89 14 85 ec d6 14 80 	mov    %edx,-0x7feb2914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103367:	83 c0 01             	add    $0x1,%eax
8010336a:	a3 e8 d6 14 80       	mov    %eax,0x8014d6e8
  b->flags |= B_DIRTY; // prevent eviction
8010336f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103372:	c7 45 08 a0 d6 14 80 	movl   $0x8014d6a0,0x8(%ebp)
}
80103379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010337c:	c9                   	leave  
  release(&log.lock);
8010337d:	e9 8e 18 00 00       	jmp    80104c10 <release>
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103388:	89 14 85 ec d6 14 80 	mov    %edx,-0x7feb2914(,%eax,4)
8010338f:	eb de                	jmp    8010336f <log_write+0x7f>
80103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103398:	8b 43 08             	mov    0x8(%ebx),%eax
8010339b:	a3 ec d6 14 80       	mov    %eax,0x8014d6ec
  if (i == log.lh.n)
801033a0:	75 cd                	jne    8010336f <log_write+0x7f>
801033a2:	31 c0                	xor    %eax,%eax
801033a4:	eb c1                	jmp    80103367 <log_write+0x77>
    panic("too big a transaction");
801033a6:	83 ec 0c             	sub    $0xc,%esp
801033a9:	68 53 86 10 80       	push   $0x80108653
801033ae:	e8 dd cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801033b3:	83 ec 0c             	sub    $0xc,%esp
801033b6:	68 69 86 10 80       	push   $0x80108669
801033bb:	e8 d0 cf ff ff       	call   80100390 <panic>

801033c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	53                   	push   %ebx
801033c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801033c7:	e8 d4 09 00 00       	call   80103da0 <cpuid>
801033cc:	89 c3                	mov    %eax,%ebx
801033ce:	e8 cd 09 00 00       	call   80103da0 <cpuid>
801033d3:	83 ec 04             	sub    $0x4,%esp
801033d6:	53                   	push   %ebx
801033d7:	50                   	push   %eax
801033d8:	68 84 86 10 80       	push   $0x80108684
801033dd:	e8 7e d2 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801033e2:	e8 49 2b 00 00       	call   80105f30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033e7:	e8 34 09 00 00       	call   80103d20 <mycpu>
801033ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033ee:	b8 01 00 00 00       	mov    $0x1,%eax
801033f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033fa:	e8 31 0e 00 00       	call   80104230 <scheduler>
801033ff:	90                   	nop

80103400 <mpenter>:
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103406:	e8 a5 3b 00 00       	call   80106fb0 <switchkvm>
  seginit();
8010340b:	e8 10 3b 00 00       	call   80106f20 <seginit>
  lapicinit();
80103410:	e8 9b f7 ff ff       	call   80102bb0 <lapicinit>
  mpmain();
80103415:	e8 a6 ff ff ff       	call   801033c0 <mpmain>
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <main>:
{
80103420:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103424:	83 e4 f0             	and    $0xfffffff0,%esp
80103427:	ff 71 fc             	pushl  -0x4(%ecx)
8010342a:	55                   	push   %ebp
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	53                   	push   %ebx
8010342e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010342f:	83 ec 08             	sub    $0x8,%esp
80103432:	68 00 00 40 80       	push   $0x80400000
80103437:	68 c8 a8 15 80       	push   $0x8015a8c8
8010343c:	e8 ef f4 ff ff       	call   80102930 <kinit1>
  kvmalloc();      // kernel page table
80103441:	e8 ea 45 00 00       	call   80107a30 <kvmalloc>
  mpinit();        // detect other processors
80103446:	e8 75 01 00 00       	call   801035c0 <mpinit>
  lapicinit();     // interrupt controller
8010344b:	e8 60 f7 ff ff       	call   80102bb0 <lapicinit>
  seginit();       // segment descriptors
80103450:	e8 cb 3a 00 00       	call   80106f20 <seginit>
  picinit();       // disable pic
80103455:	e8 46 03 00 00       	call   801037a0 <picinit>
  ioapicinit();    // another interrupt controller
8010345a:	e8 91 f1 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
8010345f:	e8 5c d5 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103464:	e8 27 2e 00 00       	call   80106290 <uartinit>
  pinit();         // process table
80103469:	e8 92 08 00 00       	call   80103d00 <pinit>
  tvinit();        // trap vectors
8010346e:	e8 3d 2a 00 00       	call   80105eb0 <tvinit>
  binit();         // buffer cache
80103473:	e8 c8 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103478:	e8 23 d9 ff ff       	call   80100da0 <fileinit>
  ideinit();       // disk 
8010347d:	e8 4e ef ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103482:	83 c4 0c             	add    $0xc,%esp
80103485:	68 8a 00 00 00       	push   $0x8a
8010348a:	68 8c b4 10 80       	push   $0x8010b48c
8010348f:	68 00 70 00 80       	push   $0x80007000
80103494:	e8 77 18 00 00       	call   80104d10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103499:	69 05 20 dd 14 80 b0 	imul   $0xb0,0x8014dd20,%eax
801034a0:	00 00 00 
801034a3:	83 c4 10             	add    $0x10,%esp
801034a6:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
801034ab:	3d a0 d7 14 80       	cmp    $0x8014d7a0,%eax
801034b0:	76 71                	jbe    80103523 <main+0x103>
801034b2:	bb a0 d7 14 80       	mov    $0x8014d7a0,%ebx
801034b7:	89 f6                	mov    %esi,%esi
801034b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801034c0:	e8 5b 08 00 00       	call   80103d20 <mycpu>
801034c5:	39 d8                	cmp    %ebx,%eax
801034c7:	74 41                	je     8010350a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034c9:	e8 52 f5 ff ff       	call   80102a20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801034ce:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801034d3:	c7 05 f8 6f 00 80 00 	movl   $0x80103400,0x80006ff8
801034da:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034dd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801034e4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034e7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801034ec:	0f b6 03             	movzbl (%ebx),%eax
801034ef:	83 ec 08             	sub    $0x8,%esp
801034f2:	68 00 70 00 00       	push   $0x7000
801034f7:	50                   	push   %eax
801034f8:	e8 03 f8 ff ff       	call   80102d00 <lapicstartap>
801034fd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103500:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103506:	85 c0                	test   %eax,%eax
80103508:	74 f6                	je     80103500 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010350a:	69 05 20 dd 14 80 b0 	imul   $0xb0,0x8014dd20,%eax
80103511:	00 00 00 
80103514:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010351a:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
8010351f:	39 c3                	cmp    %eax,%ebx
80103521:	72 9d                	jb     801034c0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103523:	83 ec 08             	sub    $0x8,%esp
80103526:	68 00 00 00 8e       	push   $0x8e000000
8010352b:	68 00 00 40 80       	push   $0x80400000
80103530:	e8 7b f4 ff ff       	call   801029b0 <kinit2>
  userinit();      // first user process
80103535:	e8 b6 08 00 00       	call   80103df0 <userinit>
  mpmain();        // finish this processor's setup
8010353a:	e8 81 fe ff ff       	call   801033c0 <mpmain>
8010353f:	90                   	nop

80103540 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103545:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010354b:	53                   	push   %ebx
  e = addr+len;
8010354c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010354f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103552:	39 de                	cmp    %ebx,%esi
80103554:	72 10                	jb     80103566 <mpsearch1+0x26>
80103556:	eb 50                	jmp    801035a8 <mpsearch1+0x68>
80103558:	90                   	nop
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103560:	39 fb                	cmp    %edi,%ebx
80103562:	89 fe                	mov    %edi,%esi
80103564:	76 42                	jbe    801035a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103566:	83 ec 04             	sub    $0x4,%esp
80103569:	8d 7e 10             	lea    0x10(%esi),%edi
8010356c:	6a 04                	push   $0x4
8010356e:	68 98 86 10 80       	push   $0x80108698
80103573:	56                   	push   %esi
80103574:	e8 37 17 00 00       	call   80104cb0 <memcmp>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	85 c0                	test   %eax,%eax
8010357e:	75 e0                	jne    80103560 <mpsearch1+0x20>
80103580:	89 f1                	mov    %esi,%ecx
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103588:	0f b6 11             	movzbl (%ecx),%edx
8010358b:	83 c1 01             	add    $0x1,%ecx
8010358e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103590:	39 f9                	cmp    %edi,%ecx
80103592:	75 f4                	jne    80103588 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103594:	84 c0                	test   %al,%al
80103596:	75 c8                	jne    80103560 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010359b:	89 f0                	mov    %esi,%eax
8010359d:	5b                   	pop    %ebx
8010359e:	5e                   	pop    %esi
8010359f:	5f                   	pop    %edi
801035a0:	5d                   	pop    %ebp
801035a1:	c3                   	ret    
801035a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ab:	31 f6                	xor    %esi,%esi
}
801035ad:	89 f0                	mov    %esi,%eax
801035af:	5b                   	pop    %ebx
801035b0:	5e                   	pop    %esi
801035b1:	5f                   	pop    %edi
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
801035b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801035c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035d7:	c1 e0 08             	shl    $0x8,%eax
801035da:	09 d0                	or     %edx,%eax
801035dc:	c1 e0 04             	shl    $0x4,%eax
801035df:	85 c0                	test   %eax,%eax
801035e1:	75 1b                	jne    801035fe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035f1:	c1 e0 08             	shl    $0x8,%eax
801035f4:	09 d0                	or     %edx,%eax
801035f6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035f9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103603:	e8 38 ff ff ff       	call   80103540 <mpsearch1>
80103608:	85 c0                	test   %eax,%eax
8010360a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010360d:	0f 84 3d 01 00 00    	je     80103750 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103616:	8b 58 04             	mov    0x4(%eax),%ebx
80103619:	85 db                	test   %ebx,%ebx
8010361b:	0f 84 4f 01 00 00    	je     80103770 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103621:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103627:	83 ec 04             	sub    $0x4,%esp
8010362a:	6a 04                	push   $0x4
8010362c:	68 b5 86 10 80       	push   $0x801086b5
80103631:	56                   	push   %esi
80103632:	e8 79 16 00 00       	call   80104cb0 <memcmp>
80103637:	83 c4 10             	add    $0x10,%esp
8010363a:	85 c0                	test   %eax,%eax
8010363c:	0f 85 2e 01 00 00    	jne    80103770 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103642:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103649:	3c 01                	cmp    $0x1,%al
8010364b:	0f 95 c2             	setne  %dl
8010364e:	3c 04                	cmp    $0x4,%al
80103650:	0f 95 c0             	setne  %al
80103653:	20 c2                	and    %al,%dl
80103655:	0f 85 15 01 00 00    	jne    80103770 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010365b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103662:	66 85 ff             	test   %di,%di
80103665:	74 1a                	je     80103681 <mpinit+0xc1>
80103667:	89 f0                	mov    %esi,%eax
80103669:	01 f7                	add    %esi,%edi
  sum = 0;
8010366b:	31 d2                	xor    %edx,%edx
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103670:	0f b6 08             	movzbl (%eax),%ecx
80103673:	83 c0 01             	add    $0x1,%eax
80103676:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103678:	39 c7                	cmp    %eax,%edi
8010367a:	75 f4                	jne    80103670 <mpinit+0xb0>
8010367c:	84 d2                	test   %dl,%dl
8010367e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103681:	85 f6                	test   %esi,%esi
80103683:	0f 84 e7 00 00 00    	je     80103770 <mpinit+0x1b0>
80103689:	84 d2                	test   %dl,%dl
8010368b:	0f 85 df 00 00 00    	jne    80103770 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103691:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103697:	a3 9c d6 14 80       	mov    %eax,0x8014d69c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010369c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801036a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801036a9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036ae:	01 d6                	add    %edx,%esi
801036b0:	39 c6                	cmp    %eax,%esi
801036b2:	76 23                	jbe    801036d7 <mpinit+0x117>
    switch(*p){
801036b4:	0f b6 10             	movzbl (%eax),%edx
801036b7:	80 fa 04             	cmp    $0x4,%dl
801036ba:	0f 87 ca 00 00 00    	ja     8010378a <mpinit+0x1ca>
801036c0:	ff 24 95 dc 86 10 80 	jmp    *-0x7fef7924(,%edx,4)
801036c7:	89 f6                	mov    %esi,%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801036d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036d3:	39 c6                	cmp    %eax,%esi
801036d5:	77 dd                	ja     801036b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801036d7:	85 db                	test   %ebx,%ebx
801036d9:	0f 84 9e 00 00 00    	je     8010377d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801036df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801036e6:	74 15                	je     801036fd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036e8:	b8 70 00 00 00       	mov    $0x70,%eax
801036ed:	ba 22 00 00 00       	mov    $0x22,%edx
801036f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036f3:	ba 23 00 00 00       	mov    $0x23,%edx
801036f8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801036f9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036fc:	ee                   	out    %al,(%dx)
  }
}
801036fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103700:	5b                   	pop    %ebx
80103701:	5e                   	pop    %esi
80103702:	5f                   	pop    %edi
80103703:	5d                   	pop    %ebp
80103704:	c3                   	ret    
80103705:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103708:	8b 0d 20 dd 14 80    	mov    0x8014dd20,%ecx
8010370e:	83 f9 07             	cmp    $0x7,%ecx
80103711:	7f 19                	jg     8010372c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103713:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103717:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010371d:	83 c1 01             	add    $0x1,%ecx
80103720:	89 0d 20 dd 14 80    	mov    %ecx,0x8014dd20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103726:	88 97 a0 d7 14 80    	mov    %dl,-0x7feb2860(%edi)
      p += sizeof(struct mpproc);
8010372c:	83 c0 14             	add    $0x14,%eax
      continue;
8010372f:	e9 7c ff ff ff       	jmp    801036b0 <mpinit+0xf0>
80103734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103738:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010373c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010373f:	88 15 80 d7 14 80    	mov    %dl,0x8014d780
      continue;
80103745:	e9 66 ff ff ff       	jmp    801036b0 <mpinit+0xf0>
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103750:	ba 00 00 01 00       	mov    $0x10000,%edx
80103755:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010375a:	e8 e1 fd ff ff       	call   80103540 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010375f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103764:	0f 85 a9 fe ff ff    	jne    80103613 <mpinit+0x53>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	68 9d 86 10 80       	push   $0x8010869d
80103778:	e8 13 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010377d:	83 ec 0c             	sub    $0xc,%esp
80103780:	68 bc 86 10 80       	push   $0x801086bc
80103785:	e8 06 cc ff ff       	call   80100390 <panic>
      ismp = 0;
8010378a:	31 db                	xor    %ebx,%ebx
8010378c:	e9 26 ff ff ff       	jmp    801036b7 <mpinit+0xf7>
80103791:	66 90                	xchg   %ax,%ax
80103793:	66 90                	xchg   %ax,%ax
80103795:	66 90                	xchg   %ax,%ax
80103797:	66 90                	xchg   %ax,%ax
80103799:	66 90                	xchg   %ax,%ax
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801037a0:	55                   	push   %ebp
801037a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037a6:	ba 21 00 00 00       	mov    $0x21,%edx
801037ab:	89 e5                	mov    %esp,%ebp
801037ad:	ee                   	out    %al,(%dx)
801037ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801037b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
801037b6:	66 90                	xchg   %ax,%ax
801037b8:	66 90                	xchg   %ax,%ax
801037ba:	66 90                	xchg   %ax,%ax
801037bc:	66 90                	xchg   %ax,%ax
801037be:	66 90                	xchg   %ax,%ax

801037c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801037cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801037d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801037db:	e8 e0 d5 ff ff       	call   80100dc0 <filealloc>
801037e0:	85 c0                	test   %eax,%eax
801037e2:	89 03                	mov    %eax,(%ebx)
801037e4:	74 22                	je     80103808 <pipealloc+0x48>
801037e6:	e8 d5 d5 ff ff       	call   80100dc0 <filealloc>
801037eb:	85 c0                	test   %eax,%eax
801037ed:	89 06                	mov    %eax,(%esi)
801037ef:	74 3f                	je     80103830 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037f1:	e8 2a f2 ff ff       	call   80102a20 <kalloc>
801037f6:	85 c0                	test   %eax,%eax
801037f8:	89 c7                	mov    %eax,%edi
801037fa:	75 54                	jne    80103850 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801037fc:	8b 03                	mov    (%ebx),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 34                	jne    80103836 <pipealloc+0x76>
80103802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103808:	8b 06                	mov    (%esi),%eax
8010380a:	85 c0                	test   %eax,%eax
8010380c:	74 0c                	je     8010381a <pipealloc+0x5a>
    fileclose(*f1);
8010380e:	83 ec 0c             	sub    $0xc,%esp
80103811:	50                   	push   %eax
80103812:	e8 69 d6 ff ff       	call   80100e80 <fileclose>
80103817:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010381a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010381d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5f                   	pop    %edi
80103825:	5d                   	pop    %ebp
80103826:	c3                   	ret    
80103827:	89 f6                	mov    %esi,%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103830:	8b 03                	mov    (%ebx),%eax
80103832:	85 c0                	test   %eax,%eax
80103834:	74 e4                	je     8010381a <pipealloc+0x5a>
    fileclose(*f0);
80103836:	83 ec 0c             	sub    $0xc,%esp
80103839:	50                   	push   %eax
8010383a:	e8 41 d6 ff ff       	call   80100e80 <fileclose>
  if(*f1)
8010383f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103841:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103844:	85 c0                	test   %eax,%eax
80103846:	75 c6                	jne    8010380e <pipealloc+0x4e>
80103848:	eb d0                	jmp    8010381a <pipealloc+0x5a>
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103850:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103853:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010385a:	00 00 00 
  p->writeopen = 1;
8010385d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103864:	00 00 00 
  p->nwrite = 0;
80103867:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010386e:	00 00 00 
  p->nread = 0;
80103871:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103878:	00 00 00 
  initlock(&p->lock, "pipe");
8010387b:	68 f0 86 10 80       	push   $0x801086f0
80103880:	50                   	push   %eax
80103881:	e8 8a 11 00 00       	call   80104a10 <initlock>
  (*f0)->type = FD_PIPE;
80103886:	8b 03                	mov    (%ebx),%eax
  return 0;
80103888:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010388b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103891:	8b 03                	mov    (%ebx),%eax
80103893:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103897:	8b 03                	mov    (%ebx),%eax
80103899:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010389d:	8b 03                	mov    (%ebx),%eax
8010389f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801038a2:	8b 06                	mov    (%esi),%eax
801038a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801038aa:	8b 06                	mov    (%esi),%eax
801038ac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801038b0:	8b 06                	mov    (%esi),%eax
801038b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801038b6:	8b 06                	mov    (%esi),%eax
801038b8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801038bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801038be:	31 c0                	xor    %eax,%eax
}
801038c0:	5b                   	pop    %ebx
801038c1:	5e                   	pop    %esi
801038c2:	5f                   	pop    %edi
801038c3:	5d                   	pop    %ebp
801038c4:	c3                   	ret    
801038c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801038db:	83 ec 0c             	sub    $0xc,%esp
801038de:	53                   	push   %ebx
801038df:	e8 6c 12 00 00       	call   80104b50 <acquire>
  if(writable){
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	85 f6                	test   %esi,%esi
801038e9:	74 45                	je     80103930 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801038eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038f1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801038f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038fb:	00 00 00 
    wakeup(&p->nread);
801038fe:	50                   	push   %eax
801038ff:	e8 2c 0e 00 00       	call   80104730 <wakeup>
80103904:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103907:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010390d:	85 d2                	test   %edx,%edx
8010390f:	75 0a                	jne    8010391b <pipeclose+0x4b>
80103911:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103917:	85 c0                	test   %eax,%eax
80103919:	74 35                	je     80103950 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010391b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010391e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5d                   	pop    %ebp
    release(&p->lock);
80103924:	e9 e7 12 00 00       	jmp    80104c10 <release>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103930:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103936:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103939:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103940:	00 00 00 
    wakeup(&p->nwrite);
80103943:	50                   	push   %eax
80103944:	e8 e7 0d 00 00       	call   80104730 <wakeup>
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	eb b9                	jmp    80103907 <pipeclose+0x37>
8010394e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	53                   	push   %ebx
80103954:	e8 b7 12 00 00       	call   80104c10 <release>
    kfree((char*)p);
80103959:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010395c:	83 c4 10             	add    $0x10,%esp
}
8010395f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103962:	5b                   	pop    %ebx
80103963:	5e                   	pop    %esi
80103964:	5d                   	pop    %ebp
    kfree((char*)p);
80103965:	e9 86 ee ff ff       	jmp    801027f0 <kfree>
8010396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103970 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 28             	sub    $0x28,%esp
80103979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010397c:	53                   	push   %ebx
8010397d:	e8 ce 11 00 00       	call   80104b50 <acquire>
  for(i = 0; i < n; i++){
80103982:	8b 45 10             	mov    0x10(%ebp),%eax
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	85 c0                	test   %eax,%eax
8010398a:	0f 8e c9 00 00 00    	jle    80103a59 <pipewrite+0xe9>
80103990:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103993:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103999:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010399f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801039a2:	03 4d 10             	add    0x10(%ebp),%ecx
801039a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801039ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801039b4:	39 d0                	cmp    %edx,%eax
801039b6:	75 71                	jne    80103a29 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801039b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	74 4e                	je     80103a10 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801039c8:	eb 3a                	jmp    80103a04 <pipewrite+0x94>
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	57                   	push   %edi
801039d4:	e8 57 0d 00 00       	call   80104730 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039d9:	5a                   	pop    %edx
801039da:	59                   	pop    %ecx
801039db:	53                   	push   %ebx
801039dc:	56                   	push   %esi
801039dd:	e8 5e 0b 00 00       	call   80104540 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039ee:	83 c4 10             	add    $0x10,%esp
801039f1:	05 00 02 00 00       	add    $0x200,%eax
801039f6:	39 c2                	cmp    %eax,%edx
801039f8:	75 36                	jne    80103a30 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801039fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a00:	85 c0                	test   %eax,%eax
80103a02:	74 0c                	je     80103a10 <pipewrite+0xa0>
80103a04:	e8 b7 03 00 00       	call   80103dc0 <myproc>
80103a09:	8b 40 24             	mov    0x24(%eax),%eax
80103a0c:	85 c0                	test   %eax,%eax
80103a0e:	74 c0                	je     801039d0 <pipewrite+0x60>
        release(&p->lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	53                   	push   %ebx
80103a14:	e8 f7 11 00 00       	call   80104c10 <release>
        return -1;
80103a19:	83 c4 10             	add    $0x10,%esp
80103a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a24:	5b                   	pop    %ebx
80103a25:	5e                   	pop    %esi
80103a26:	5f                   	pop    %edi
80103a27:	5d                   	pop    %ebp
80103a28:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a29:	89 c2                	mov    %eax,%edx
80103a2b:	90                   	nop
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a30:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a33:	8d 42 01             	lea    0x1(%edx),%eax
80103a36:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a3c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103a42:	83 c6 01             	add    $0x1,%esi
80103a45:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103a49:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a4c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a4f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a53:	0f 85 4f ff ff ff    	jne    801039a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a59:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	50                   	push   %eax
80103a63:	e8 c8 0c 00 00       	call   80104730 <wakeup>
  release(&p->lock);
80103a68:	89 1c 24             	mov    %ebx,(%esp)
80103a6b:	e8 a0 11 00 00       	call   80104c10 <release>
  return n;
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	8b 45 10             	mov    0x10(%ebp),%eax
80103a76:	eb a9                	jmp    80103a21 <pipewrite+0xb1>
80103a78:	90                   	nop
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 18             	sub    $0x18,%esp
80103a89:	8b 75 08             	mov    0x8(%ebp),%esi
80103a8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a8f:	56                   	push   %esi
80103a90:	e8 bb 10 00 00       	call   80104b50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a9e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103aa4:	75 6a                	jne    80103b10 <piperead+0x90>
80103aa6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103aac:	85 db                	test   %ebx,%ebx
80103aae:	0f 84 c4 00 00 00    	je     80103b78 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ab4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103aba:	eb 2d                	jmp    80103ae9 <piperead+0x69>
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac0:	83 ec 08             	sub    $0x8,%esp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	e8 76 0a 00 00       	call   80104540 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103aca:	83 c4 10             	add    $0x10,%esp
80103acd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ad3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ad9:	75 35                	jne    80103b10 <piperead+0x90>
80103adb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103ae1:	85 d2                	test   %edx,%edx
80103ae3:	0f 84 8f 00 00 00    	je     80103b78 <piperead+0xf8>
    if(myproc()->killed){
80103ae9:	e8 d2 02 00 00       	call   80103dc0 <myproc>
80103aee:	8b 48 24             	mov    0x24(%eax),%ecx
80103af1:	85 c9                	test   %ecx,%ecx
80103af3:	74 cb                	je     80103ac0 <piperead+0x40>
      release(&p->lock);
80103af5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103af8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103afd:	56                   	push   %esi
80103afe:	e8 0d 11 00 00       	call   80104c10 <release>
      return -1;
80103b03:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b09:	89 d8                	mov    %ebx,%eax
80103b0b:	5b                   	pop    %ebx
80103b0c:	5e                   	pop    %esi
80103b0d:	5f                   	pop    %edi
80103b0e:	5d                   	pop    %ebp
80103b0f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b10:	8b 45 10             	mov    0x10(%ebp),%eax
80103b13:	85 c0                	test   %eax,%eax
80103b15:	7e 61                	jle    80103b78 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103b17:	31 db                	xor    %ebx,%ebx
80103b19:	eb 13                	jmp    80103b2e <piperead+0xae>
80103b1b:	90                   	nop
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b20:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b26:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b2c:	74 1f                	je     80103b4d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103b2e:	8d 41 01             	lea    0x1(%ecx),%eax
80103b31:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103b37:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103b3d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103b42:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b45:	83 c3 01             	add    $0x1,%ebx
80103b48:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103b4b:	75 d3                	jne    80103b20 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b4d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b53:	83 ec 0c             	sub    $0xc,%esp
80103b56:	50                   	push   %eax
80103b57:	e8 d4 0b 00 00       	call   80104730 <wakeup>
  release(&p->lock);
80103b5c:	89 34 24             	mov    %esi,(%esp)
80103b5f:	e8 ac 10 00 00       	call   80104c10 <release>
  return i;
80103b64:	83 c4 10             	add    $0x10,%esp
}
80103b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b6a:	89 d8                	mov    %ebx,%eax
80103b6c:	5b                   	pop    %ebx
80103b6d:	5e                   	pop    %esi
80103b6e:	5f                   	pop    %edi
80103b6f:	5d                   	pop    %ebp
80103b70:	c3                   	ret    
80103b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b78:	31 db                	xor    %ebx,%ebx
80103b7a:	eb d1                	jmp    80103b4d <piperead+0xcd>
80103b7c:	66 90                	xchg   %ax,%ax
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b85:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
  acquire(&ptable.lock);
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	68 40 dd 14 80       	push   $0x8014dd40
80103b92:	e8 b9 0f 00 00       	call   80104b50 <acquire>
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	eb 16                	jmp    80103bb2 <allocproc+0x32>
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ba0:	81 c3 0c 03 00 00    	add    $0x30c,%ebx
80103ba6:	81 fb 74 a0 15 80    	cmp    $0x8015a074,%ebx
80103bac:	0f 83 ce 00 00 00    	jae    80103c80 <allocproc+0x100>
    if(p->state == UNUSED)
80103bb2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103bb5:	85 c0                	test   %eax,%eax
80103bb7:	75 e7                	jne    80103ba0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103bb9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->timestamp = 0;

  release(&ptable.lock);
80103bbe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103bc1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->timestamp = 0;
80103bc8:	c7 83 04 03 00 00 00 	movl   $0x0,0x304(%ebx)
80103bcf:	00 00 00 
  p->pid = nextpid++;
80103bd2:	8d 50 01             	lea    0x1(%eax),%edx
80103bd5:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103bd8:	68 40 dd 14 80       	push   $0x8014dd40
  p->pid = nextpid++;
80103bdd:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103be3:	e8 28 10 00 00       	call   80104c10 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103be8:	e8 33 ee ff ff       	call   80102a20 <kalloc>
80103bed:	83 c4 10             	add    $0x10,%esp
80103bf0:	85 c0                	test   %eax,%eax
80103bf2:	89 c6                	mov    %eax,%esi
80103bf4:	89 43 08             	mov    %eax,0x8(%ebx)
80103bf7:	0f 84 9e 00 00 00    	je     80103c9b <allocproc+0x11b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103bfd:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  p->tf = (struct trapframe*)sp;

  // Page support
  p->swapFile = 0;
80103c03:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->page_faults = 0;
80103c0a:	c7 83 00 03 00 00 00 	movl   $0x0,0x300(%ebx)
80103c11:	00 00 00 
  sp -= sizeof *p->tf;
80103c14:	89 43 18             	mov    %eax,0x18(%ebx)
  if (check_policy() && p->pid > 2 && createSwapFile(p) != 0)     // ignore shell & init procs
80103c17:	e8 34 36 00 00       	call   80107250 <check_policy>
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	74 06                	je     80103c26 <allocproc+0xa6>
80103c20:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103c24:	7f 3a                	jg     80103c60 <allocproc+0xe0>
  

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103c26:	c7 86 b0 0f 00 00 a1 	movl   $0x80105ea1,0xfb0(%esi)
80103c2d:	5e 10 80 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103c30:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103c33:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  p->context = (struct context*)sp;
80103c39:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103c3c:	6a 14                	push   $0x14
80103c3e:	6a 00                	push   $0x0
80103c40:	56                   	push   %esi
80103c41:	e8 1a 10 00 00       	call   80104c60 <memset>
  p->context->eip = (uint)forkret;
80103c46:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103c49:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103c4c:	c7 40 10 b0 3c 10 80 	movl   $0x80103cb0,0x10(%eax)
}
80103c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c56:	89 d8                	mov    %ebx,%eax
80103c58:	5b                   	pop    %ebx
80103c59:	5e                   	pop    %esi
80103c5a:	5d                   	pop    %ebp
80103c5b:	c3                   	ret    
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (check_policy() && p->pid > 2 && createSwapFile(p) != 0)     // ignore shell & init procs
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	53                   	push   %ebx
80103c64:	e8 87 e5 ff ff       	call   801021f0 <createSwapFile>
80103c69:	83 c4 10             	add    $0x10,%esp
80103c6c:	85 c0                	test   %eax,%eax
80103c6e:	74 b6                	je     80103c26 <allocproc+0xa6>
    panic("allocproc: createSwapFile failed\n");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 f8 86 10 80       	push   $0x801086f8
80103c78:	e8 13 c7 ff ff       	call   80100390 <panic>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103c80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c85:	68 40 dd 14 80       	push   $0x8014dd40
80103c8a:	e8 81 0f 00 00       	call   80104c10 <release>
  return 0;
80103c8f:	83 c4 10             	add    $0x10,%esp
}
80103c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c95:	89 d8                	mov    %ebx,%eax
80103c97:	5b                   	pop    %ebx
80103c98:	5e                   	pop    %esi
80103c99:	5d                   	pop    %ebp
80103c9a:	c3                   	ret    
    p->state = UNUSED;
80103c9b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ca2:	31 db                	xor    %ebx,%ebx
80103ca4:	eb ad                	jmp    80103c53 <allocproc+0xd3>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103cb6:	68 40 dd 14 80       	push   $0x8014dd40
80103cbb:	e8 50 0f 00 00       	call   80104c10 <release>

  if (first) {
80103cc0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	75 04                	jne    80103cd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ccc:	c9                   	leave  
80103ccd:	c3                   	ret    
80103cce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103cd3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103cda:	00 00 00 
    iinit(ROOTDEV);
80103cdd:	6a 01                	push   $0x1
80103cdf:	e8 dc d7 ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103ce4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ceb:	e8 90 f3 ff ff       	call   80103080 <initlog>
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	c9                   	leave  
80103cf4:	c3                   	ret    
80103cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <pinit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d06:	68 89 87 10 80       	push   $0x80108789
80103d0b:	68 40 dd 14 80       	push   $0x8014dd40
80103d10:	e8 fb 0c 00 00       	call   80104a10 <initlock>
}
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	c9                   	leave  
80103d19:	c3                   	ret    
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d20 <mycpu>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d25:	9c                   	pushf  
80103d26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d27:	f6 c4 02             	test   $0x2,%ah
80103d2a:	75 5e                	jne    80103d8a <mycpu+0x6a>
  apicid = lapicid();
80103d2c:	e8 7f ef ff ff       	call   80102cb0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d31:	8b 35 20 dd 14 80    	mov    0x8014dd20,%esi
80103d37:	85 f6                	test   %esi,%esi
80103d39:	7e 42                	jle    80103d7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d3b:	0f b6 15 a0 d7 14 80 	movzbl 0x8014d7a0,%edx
80103d42:	39 d0                	cmp    %edx,%eax
80103d44:	74 30                	je     80103d76 <mycpu+0x56>
80103d46:	b9 50 d8 14 80       	mov    $0x8014d850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103d4b:	31 d2                	xor    %edx,%edx
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
80103d50:	83 c2 01             	add    $0x1,%edx
80103d53:	39 f2                	cmp    %esi,%edx
80103d55:	74 26                	je     80103d7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d57:	0f b6 19             	movzbl (%ecx),%ebx
80103d5a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d60:	39 c3                	cmp    %eax,%ebx
80103d62:	75 ec                	jne    80103d50 <mycpu+0x30>
80103d64:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d6a:	05 a0 d7 14 80       	add    $0x8014d7a0,%eax
}
80103d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d72:	5b                   	pop    %ebx
80103d73:	5e                   	pop    %esi
80103d74:	5d                   	pop    %ebp
80103d75:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103d76:	b8 a0 d7 14 80       	mov    $0x8014d7a0,%eax
      return &cpus[i];
80103d7b:	eb f2                	jmp    80103d6f <mycpu+0x4f>
  panic("unknown apicid\n");
80103d7d:	83 ec 0c             	sub    $0xc,%esp
80103d80:	68 90 87 10 80       	push   $0x80108790
80103d85:	e8 06 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 1c 87 10 80       	push   $0x8010871c
80103d92:	e8 f9 c5 ff ff       	call   80100390 <panic>
80103d97:	89 f6                	mov    %esi,%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <cpuid>:
cpuid() {
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103da6:	e8 75 ff ff ff       	call   80103d20 <mycpu>
80103dab:	2d a0 d7 14 80       	sub    $0x8014d7a0,%eax
}
80103db0:	c9                   	leave  
  return mycpu()-cpus;
80103db1:	c1 f8 04             	sar    $0x4,%eax
80103db4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103dba:	c3                   	ret    
80103dbb:	90                   	nop
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <myproc>:
myproc(void) {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	53                   	push   %ebx
80103dc4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103dc7:	e8 b4 0c 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103dcc:	e8 4f ff ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80103dd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd7:	e8 e4 0c 00 00       	call   80104ac0 <popcli>
}
80103ddc:	83 c4 04             	add    $0x4,%esp
80103ddf:	89 d8                	mov    %ebx,%eax
80103de1:	5b                   	pop    %ebx
80103de2:	5d                   	pop    %ebp
80103de3:	c3                   	ret    
80103de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103df0 <userinit>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103df7:	e8 84 fd ff ff       	call   80103b80 <allocproc>
80103dfc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103dfe:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  if((p->pgdir = setupkvm()) == 0)
80103e03:	e8 a8 3b 00 00       	call   801079b0 <setupkvm>
80103e08:	85 c0                	test   %eax,%eax
80103e0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e0d:	0f 84 bd 00 00 00    	je     80103ed0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e13:	83 ec 04             	sub    $0x4,%esp
80103e16:	68 2c 00 00 00       	push   $0x2c
80103e1b:	68 60 b4 10 80       	push   $0x8010b460
80103e20:	50                   	push   %eax
80103e21:	e8 ba 32 00 00       	call   801070e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e2f:	6a 4c                	push   $0x4c
80103e31:	6a 00                	push   $0x0
80103e33:	ff 73 18             	pushl  0x18(%ebx)
80103e36:	e8 25 0e 00 00       	call   80104c60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e56:	8b 43 18             	mov    0x18(%ebx),%eax
80103e59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e61:	8b 43 18             	mov    0x18(%ebx),%eax
80103e64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e76:	8b 43 18             	mov    0x18(%ebx),%eax
80103e79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e80:	8b 43 18             	mov    0x18(%ebx),%eax
80103e83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	68 b9 87 10 80       	push   $0x801087b9
80103e94:	50                   	push   %eax
80103e95:	e8 a6 0f 00 00       	call   80104e40 <safestrcpy>
  p->cwd = namei("/");
80103e9a:	c7 04 24 c2 87 10 80 	movl   $0x801087c2,(%esp)
80103ea1:	e8 7a e0 ff ff       	call   80101f20 <namei>
80103ea6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ea9:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80103eb0:	e8 9b 0c 00 00       	call   80104b50 <acquire>
  p->state = RUNNABLE;
80103eb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ebc:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
80103ec3:	e8 48 0d 00 00       	call   80104c10 <release>
}
80103ec8:	83 c4 10             	add    $0x10,%esp
80103ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ece:	c9                   	leave  
80103ecf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 a0 87 10 80       	push   $0x801087a0
80103ed8:	e8 b3 c4 ff ff       	call   80100390 <panic>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <growproc>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
80103ee5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ee8:	e8 93 0b 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103eed:	e8 2e fe ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80103ef2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef8:	e8 c3 0b 00 00       	call   80104ac0 <popcli>
  if(n > 0){
80103efd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f02:	7f 1c                	jg     80103f20 <growproc+0x40>
  } else if(n < 0){
80103f04:	75 3a                	jne    80103f40 <growproc+0x60>
  switchuvm(curproc);
80103f06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f0b:	53                   	push   %ebx
80103f0c:	e8 bf 30 00 00       	call   80106fd0 <switchuvm>
  return 0;
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	31 c0                	xor    %eax,%eax
}
80103f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f19:	5b                   	pop    %ebx
80103f1a:	5e                   	pop    %esi
80103f1b:	5d                   	pop    %ebp
80103f1c:	c3                   	ret    
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f20:	83 ec 04             	sub    $0x4,%esp
80103f23:	01 c6                	add    %eax,%esi
80103f25:	56                   	push   %esi
80103f26:	50                   	push   %eax
80103f27:	ff 73 04             	pushl  0x4(%ebx)
80103f2a:	e8 01 38 00 00       	call   80107730 <allocuvm>
80103f2f:	83 c4 10             	add    $0x10,%esp
80103f32:	85 c0                	test   %eax,%eax
80103f34:	75 d0                	jne    80103f06 <growproc+0x26>
      return -1;
80103f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f3b:	eb d9                	jmp    80103f16 <growproc+0x36>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f40:	83 ec 04             	sub    $0x4,%esp
80103f43:	01 c6                	add    %eax,%esi
80103f45:	56                   	push   %esi
80103f46:	50                   	push   %eax
80103f47:	ff 73 04             	pushl  0x4(%ebx)
80103f4a:	e8 f1 36 00 00       	call   80107640 <deallocuvm>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	85 c0                	test   %eax,%eax
80103f54:	75 b0                	jne    80103f06 <growproc+0x26>
80103f56:	eb de                	jmp    80103f36 <growproc+0x56>
80103f58:	90                   	nop
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f60 <fork>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	57                   	push   %edi
80103f64:	56                   	push   %esi
80103f65:	53                   	push   %ebx
80103f66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f69:	e8 12 0b 00 00       	call   80104a80 <pushcli>
  c = mycpu();
80103f6e:	e8 ad fd ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80103f73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f79:	e8 42 0b 00 00       	call   80104ac0 <popcli>
  if((np = allocproc()) == 0){
80103f7e:	e8 fd fb ff ff       	call   80103b80 <allocproc>
80103f83:	85 c0                	test   %eax,%eax
80103f85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f88:	0f 84 73 02 00 00    	je     80104201 <fork+0x2a1>
  if (!check_policy()) {      // NONE
80103f8e:	e8 bd 32 00 00       	call   80107250 <check_policy>
80103f93:	85 c0                	test   %eax,%eax
80103f95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f98:	0f 84 7a 01 00 00    	je     80104118 <fork+0x1b8>
  else if((np->pgdir = copyonwriteuvm(curproc->pgdir, curproc->sz)) == 0){
80103f9e:	83 ec 08             	sub    $0x8,%esp
80103fa1:	ff 33                	pushl  (%ebx)
80103fa3:	ff 73 04             	pushl  0x4(%ebx)
80103fa6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103fa9:	e8 c2 3b 00 00       	call   80107b70 <copyonwriteuvm>
80103fae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fb1:	83 c4 10             	add    $0x10,%esp
80103fb4:	85 c0                	test   %eax,%eax
80103fb6:	89 42 04             	mov    %eax,0x4(%edx)
80103fb9:	0f 84 49 02 00 00    	je     80104208 <fork+0x2a8>
  np->sz = curproc->sz;
80103fbf:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103fc1:	8b 7a 18             	mov    0x18(%edx),%edi
80103fc4:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103fc9:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->timestamp = curproc->timestamp;
80103fcc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->sz = curproc->sz;
80103fcf:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103fd1:	8b 73 18             	mov    0x18(%ebx),%esi
80103fd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->page_faults = 0;
80103fd6:	c7 82 00 03 00 00 00 	movl   $0x0,0x300(%edx)
80103fdd:	00 00 00 
  np->timestamp = curproc->timestamp;
80103fe0:	8b 83 04 03 00 00    	mov    0x304(%ebx),%eax
80103fe6:	89 82 04 03 00 00    	mov    %eax,0x304(%edx)
  if (check_policy() && curproc->pid > 2) {
80103fec:	e8 5f 32 00 00       	call   80107250 <check_policy>
80103ff1:	85 c0                	test   %eax,%eax
80103ff3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ff6:	0f 84 74 01 00 00    	je     80104170 <fork+0x210>
80103ffc:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104000:	0f 8e 6a 01 00 00    	jle    80104170 <fork+0x210>
80104006:	be 80 00 00 00       	mov    $0x80,%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++) {
8010400b:	31 ff                	xor    %edi,%edi
8010400d:	eb 10                	jmp    8010401f <fork+0xbf>
8010400f:	90                   	nop
80104010:	83 c7 01             	add    $0x1,%edi
80104013:	83 c6 14             	add    $0x14,%esi
80104016:	83 ff 10             	cmp    $0x10,%edi
80104019:	0f 84 51 01 00 00    	je     80104170 <fork+0x210>
      np->memory_pages[i] = curproc->memory_pages[i];
8010401f:	8b 84 33 40 01 00 00 	mov    0x140(%ebx,%esi,1),%eax
80104026:	89 84 32 40 01 00 00 	mov    %eax,0x140(%edx,%esi,1)
8010402d:	8b 84 33 44 01 00 00 	mov    0x144(%ebx,%esi,1),%eax
80104034:	89 84 32 44 01 00 00 	mov    %eax,0x144(%edx,%esi,1)
8010403b:	8b 84 33 48 01 00 00 	mov    0x148(%ebx,%esi,1),%eax
80104042:	89 84 32 48 01 00 00 	mov    %eax,0x148(%edx,%esi,1)
80104049:	8b 84 33 4c 01 00 00 	mov    0x14c(%ebx,%esi,1),%eax
80104050:	89 84 32 4c 01 00 00 	mov    %eax,0x14c(%edx,%esi,1)
80104057:	8b 84 33 50 01 00 00 	mov    0x150(%ebx,%esi,1),%eax
8010405e:	89 84 32 50 01 00 00 	mov    %eax,0x150(%edx,%esi,1)
      np->memory_pages[i].pgdir = np->pgdir;
80104065:	8b 42 04             	mov    0x4(%edx),%eax
80104068:	89 84 32 40 01 00 00 	mov    %eax,0x140(%edx,%esi,1)
      np->file_pages[i] = curproc->file_pages[i];
8010406f:	8b 0c 33             	mov    (%ebx,%esi,1),%ecx
80104072:	89 0c 32             	mov    %ecx,(%edx,%esi,1)
80104075:	8b 4c 33 04          	mov    0x4(%ebx,%esi,1),%ecx
80104079:	89 4c 32 04          	mov    %ecx,0x4(%edx,%esi,1)
8010407d:	8b 4c 33 08          	mov    0x8(%ebx,%esi,1),%ecx
80104081:	89 4c 32 08          	mov    %ecx,0x8(%edx,%esi,1)
80104085:	8b 4c 33 0c          	mov    0xc(%ebx,%esi,1),%ecx
80104089:	89 4c 32 0c          	mov    %ecx,0xc(%edx,%esi,1)
8010408d:	8b 4c 33 10          	mov    0x10(%ebx,%esi,1),%ecx
      np->file_pages[i].pgdir = np->pgdir;
80104091:	89 04 32             	mov    %eax,(%edx,%esi,1)
      np->file_pages[i] = curproc->file_pages[i];
80104094:	89 4c 32 10          	mov    %ecx,0x10(%edx,%esi,1)
      if (curproc->file_pages[i].is_used && readFromSwapFile(curproc, fork_buffer, PGSIZE*i, PGSIZE) != PGSIZE)
80104098:	8b 4c 33 0c          	mov    0xc(%ebx,%esi,1),%ecx
8010409c:	85 c9                	test   %ecx,%ecx
8010409e:	0f 84 6c ff ff ff    	je     80104010 <fork+0xb0>
801040a4:	89 f9                	mov    %edi,%ecx
801040a6:	68 00 10 00 00       	push   $0x1000
801040ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801040ae:	c1 e1 0c             	shl    $0xc,%ecx
801040b1:	51                   	push   %ecx
801040b2:	68 c0 b5 10 80       	push   $0x8010b5c0
801040b7:	53                   	push   %ebx
801040b8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801040bb:	e8 00 e2 ff ff       	call   801022c0 <readFromSwapFile>
801040c0:	83 c4 10             	add    $0x10,%esp
801040c3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801040c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801040ce:	0f 85 41 01 00 00    	jne    80104215 <fork+0x2b5>
      if (curproc->file_pages[i].is_used && writeToSwapFile(np, fork_buffer, PGSIZE*i, PGSIZE) != PGSIZE)
801040d4:	8b 44 33 0c          	mov    0xc(%ebx,%esi,1),%eax
801040d8:	85 c0                	test   %eax,%eax
801040da:	0f 84 30 ff ff ff    	je     80104010 <fork+0xb0>
801040e0:	68 00 10 00 00       	push   $0x1000
801040e5:	51                   	push   %ecx
801040e6:	68 c0 b5 10 80       	push   $0x8010b5c0
801040eb:	52                   	push   %edx
801040ec:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040ef:	e8 9c e1 ff ff       	call   80102290 <writeToSwapFile>
801040f4:	83 c4 10             	add    $0x10,%esp
801040f7:	3d 00 10 00 00       	cmp    $0x1000,%eax
801040fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040ff:	0f 84 0b ff ff ff    	je     80104010 <fork+0xb0>
        panic("fork: writeToSwapFile != PGSIZE\n");
80104105:	83 ec 0c             	sub    $0xc,%esp
80104108:	68 68 87 10 80       	push   $0x80108768
8010410d:	e8 7e c2 ff ff       	call   80100390 <panic>
80104112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104118:	83 ec 08             	sub    $0x8,%esp
8010411b:	ff 33                	pushl  (%ebx)
8010411d:	ff 73 04             	pushl  0x4(%ebx)
80104120:	e8 5b 39 00 00       	call   80107a80 <copyuvm>
80104125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	85 c0                	test   %eax,%eax
8010412d:	89 42 04             	mov    %eax,0x4(%edx)
80104130:	0f 85 89 fe ff ff    	jne    80103fbf <fork+0x5f>
      cprintf("fork: copyuvm failed\n");
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 c4 87 10 80       	push   $0x801087c4
    cprintf("fork: copyonwriteuvm failed\n");
8010413e:	e8 1d c5 ff ff       	call   80100660 <cprintf>
    kfree(np->kstack);
80104143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104146:	5b                   	pop    %ebx
    return -1;
80104147:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010414c:	ff 72 08             	pushl  0x8(%edx)
8010414f:	e8 9c e6 ff ff       	call   801027f0 <kfree>
    np->kstack = 0;
80104154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104157:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010415a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104161:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104168:	e9 8a 00 00 00       	jmp    801041f7 <fork+0x297>
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
  np->tf->eax = 0;
80104170:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80104173:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104175:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104180:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104184:	85 c0                	test   %eax,%eax
80104186:	74 16                	je     8010419e <fork+0x23e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010418e:	50                   	push   %eax
8010418f:	e8 9c cc ff ff       	call   80100e30 <filedup>
80104194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010419e:	83 c6 01             	add    $0x1,%esi
801041a1:	83 fe 10             	cmp    $0x10,%esi
801041a4:	75 da                	jne    80104180 <fork+0x220>
  np->cwd = idup(curproc->cwd);
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	ff 73 68             	pushl  0x68(%ebx)
801041ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041af:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801041b2:	e8 d9 d4 ff ff       	call   80101690 <idup>
801041b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041ba:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801041bd:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041c0:	8d 42 6c             	lea    0x6c(%edx),%eax
801041c3:	6a 10                	push   $0x10
801041c5:	53                   	push   %ebx
801041c6:	50                   	push   %eax
801041c7:	e8 74 0c 00 00       	call   80104e40 <safestrcpy>
  pid = np->pid;
801041cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041cf:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
801041d2:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
801041d9:	e8 72 09 00 00       	call   80104b50 <acquire>
  np->state = RUNNABLE;
801041de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041e1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801041e8:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
801041ef:	e8 1c 0a 00 00       	call   80104c10 <release>
  return pid;
801041f4:	83 c4 10             	add    $0x10,%esp
}
801041f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041fa:	89 d8                	mov    %ebx,%eax
801041fc:	5b                   	pop    %ebx
801041fd:	5e                   	pop    %esi
801041fe:	5f                   	pop    %edi
801041ff:	5d                   	pop    %ebp
80104200:	c3                   	ret    
    return -1;
80104201:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104206:	eb ef                	jmp    801041f7 <fork+0x297>
    cprintf("fork: copyonwriteuvm failed\n");
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 da 87 10 80       	push   $0x801087da
80104210:	e9 29 ff ff ff       	jmp    8010413e <fork+0x1de>
        panic("fork: readFromSwapFile != PGSIZE\n");
80104215:	83 ec 0c             	sub    $0xc,%esp
80104218:	68 44 87 10 80       	push   $0x80108744
8010421d:	e8 6e c1 ff ff       	call   80100390 <panic>
80104222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <scheduler>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104239:	e8 e2 fa ff ff       	call   80103d20 <mycpu>
8010423e:	8d 78 04             	lea    0x4(%eax),%edi
80104241:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104243:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010424a:	00 00 00 
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104250:	fb                   	sti    
    acquire(&ptable.lock);
80104251:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104254:	bb 74 dd 14 80       	mov    $0x8014dd74,%ebx
    acquire(&ptable.lock);
80104259:	68 40 dd 14 80       	push   $0x8014dd40
8010425e:	e8 ed 08 00 00       	call   80104b50 <acquire>
80104263:	83 c4 10             	add    $0x10,%esp
80104266:	8d 76 00             	lea    0x0(%esi),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104270:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104274:	75 33                	jne    801042a9 <scheduler+0x79>
      switchuvm(p);
80104276:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104279:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010427f:	53                   	push   %ebx
80104280:	e8 4b 2d 00 00       	call   80106fd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104285:	58                   	pop    %eax
80104286:	5a                   	pop    %edx
80104287:	ff 73 1c             	pushl  0x1c(%ebx)
8010428a:	57                   	push   %edi
      p->state = RUNNING;
8010428b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104292:	e8 04 0c 00 00       	call   80104e9b <swtch>
      switchkvm();
80104297:	e8 14 2d 00 00       	call   80106fb0 <switchkvm>
      c->proc = 0;
8010429c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801042a3:	00 00 00 
801042a6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a9:	81 c3 0c 03 00 00    	add    $0x30c,%ebx
801042af:	81 fb 74 a0 15 80    	cmp    $0x8015a074,%ebx
801042b5:	72 b9                	jb     80104270 <scheduler+0x40>
    release(&ptable.lock);
801042b7:	83 ec 0c             	sub    $0xc,%esp
801042ba:	68 40 dd 14 80       	push   $0x8014dd40
801042bf:	e8 4c 09 00 00       	call   80104c10 <release>
    sti();
801042c4:	83 c4 10             	add    $0x10,%esp
801042c7:	eb 87                	jmp    80104250 <scheduler+0x20>
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <sched>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
  pushcli();
801042d5:	e8 a6 07 00 00       	call   80104a80 <pushcli>
  c = mycpu();
801042da:	e8 41 fa ff ff       	call   80103d20 <mycpu>
  p = c->proc;
801042df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e5:	e8 d6 07 00 00       	call   80104ac0 <popcli>
  if(!holding(&ptable.lock))
801042ea:	83 ec 0c             	sub    $0xc,%esp
801042ed:	68 40 dd 14 80       	push   $0x8014dd40
801042f2:	e8 29 08 00 00       	call   80104b20 <holding>
801042f7:	83 c4 10             	add    $0x10,%esp
801042fa:	85 c0                	test   %eax,%eax
801042fc:	74 4f                	je     8010434d <sched+0x7d>
  if(mycpu()->ncli != 1)
801042fe:	e8 1d fa ff ff       	call   80103d20 <mycpu>
80104303:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010430a:	75 68                	jne    80104374 <sched+0xa4>
  if(p->state == RUNNING)
8010430c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104310:	74 55                	je     80104367 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104312:	9c                   	pushf  
80104313:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104314:	f6 c4 02             	test   $0x2,%ah
80104317:	75 41                	jne    8010435a <sched+0x8a>
  intena = mycpu()->intena;
80104319:	e8 02 fa ff ff       	call   80103d20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010431e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104321:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104327:	e8 f4 f9 ff ff       	call   80103d20 <mycpu>
8010432c:	83 ec 08             	sub    $0x8,%esp
8010432f:	ff 70 04             	pushl  0x4(%eax)
80104332:	53                   	push   %ebx
80104333:	e8 63 0b 00 00       	call   80104e9b <swtch>
  mycpu()->intena = intena;
80104338:	e8 e3 f9 ff ff       	call   80103d20 <mycpu>
}
8010433d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104340:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104346:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104349:	5b                   	pop    %ebx
8010434a:	5e                   	pop    %esi
8010434b:	5d                   	pop    %ebp
8010434c:	c3                   	ret    
    panic("sched ptable.lock");
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	68 f7 87 10 80       	push   $0x801087f7
80104355:	e8 36 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 23 88 10 80       	push   $0x80108823
80104362:	e8 29 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 15 88 10 80       	push   $0x80108815
8010436f:	e8 1c c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	68 09 88 10 80       	push   $0x80108809
8010437c:	e8 0f c0 ff ff       	call   80100390 <panic>
80104381:	eb 0d                	jmp    80104390 <exit>
80104383:	90                   	nop
80104384:	90                   	nop
80104385:	90                   	nop
80104386:	90                   	nop
80104387:	90                   	nop
80104388:	90                   	nop
80104389:	90                   	nop
8010438a:	90                   	nop
8010438b:	90                   	nop
8010438c:	90                   	nop
8010438d:	90                   	nop
8010438e:	90                   	nop
8010438f:	90                   	nop

80104390 <exit>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
80104396:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104399:	e8 e2 06 00 00       	call   80104a80 <pushcli>
  c = mycpu();
8010439e:	e8 7d f9 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
801043a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043a9:	e8 12 07 00 00       	call   80104ac0 <popcli>
  if(curproc == initproc)
801043ae:	39 1d c0 c5 10 80    	cmp    %ebx,0x8010c5c0
801043b4:	8d 73 28             	lea    0x28(%ebx),%esi
801043b7:	8d 7b 68             	lea    0x68(%ebx),%edi
801043ba:	0f 84 1c 01 00 00    	je     801044dc <exit+0x14c>
    if(curproc->ofile[fd]){
801043c0:	8b 06                	mov    (%esi),%eax
801043c2:	85 c0                	test   %eax,%eax
801043c4:	74 12                	je     801043d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	50                   	push   %eax
801043ca:	e8 b1 ca ff ff       	call   80100e80 <fileclose>
      curproc->ofile[fd] = 0;
801043cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801043d5:	83 c4 10             	add    $0x10,%esp
801043d8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801043db:	39 fe                	cmp    %edi,%esi
801043dd:	75 e1                	jne    801043c0 <exit+0x30>
  if (check_policy() && curproc->pid > 2)
801043df:	e8 6c 2e 00 00       	call   80107250 <check_policy>
801043e4:	85 c0                	test   %eax,%eax
801043e6:	0f 85 d5 00 00 00    	jne    801044c1 <exit+0x131>
  begin_op();
801043ec:	e8 2f ed ff ff       	call   80103120 <begin_op>
  iput(curproc->cwd);
801043f1:	83 ec 0c             	sub    $0xc,%esp
801043f4:	ff 73 68             	pushl  0x68(%ebx)
801043f7:	e8 f4 d3 ff ff       	call   801017f0 <iput>
  end_op();
801043fc:	e8 8f ed ff ff       	call   80103190 <end_op>
  curproc->cwd = 0;
80104401:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104408:	c7 04 24 40 dd 14 80 	movl   $0x8014dd40,(%esp)
8010440f:	e8 3c 07 00 00       	call   80104b50 <acquire>
  wakeup1(curproc->parent);
80104414:	8b 53 14             	mov    0x14(%ebx),%edx
80104417:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441a:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
8010441f:	eb 13                	jmp    80104434 <exit+0xa4>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104428:	05 0c 03 00 00       	add    $0x30c,%eax
8010442d:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
80104432:	73 1e                	jae    80104452 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104434:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104438:	75 ee                	jne    80104428 <exit+0x98>
8010443a:	3b 50 20             	cmp    0x20(%eax),%edx
8010443d:	75 e9                	jne    80104428 <exit+0x98>
      p->state = RUNNABLE;
8010443f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104446:	05 0c 03 00 00       	add    $0x30c,%eax
8010444b:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
80104450:	72 e2                	jb     80104434 <exit+0xa4>
      p->parent = initproc;
80104452:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	ba 74 dd 14 80       	mov    $0x8014dd74,%edx
8010445d:	eb 0f                	jmp    8010446e <exit+0xde>
8010445f:	90                   	nop
80104460:	81 c2 0c 03 00 00    	add    $0x30c,%edx
80104466:	81 fa 74 a0 15 80    	cmp    $0x8015a074,%edx
8010446c:	73 3a                	jae    801044a8 <exit+0x118>
    if(p->parent == curproc){
8010446e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104471:	75 ed                	jne    80104460 <exit+0xd0>
      if(p->state == ZOMBIE)
80104473:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104477:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010447a:	75 e4                	jne    80104460 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447c:	b8 74 dd 14 80       	mov    $0x8014dd74,%eax
80104481:	eb 11                	jmp    80104494 <exit+0x104>
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104488:	05 0c 03 00 00       	add    $0x30c,%eax
8010448d:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
80104492:	73 cc                	jae    80104460 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104494:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104498:	75 ee                	jne    80104488 <exit+0xf8>
8010449a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010449d:	75 e9                	jne    80104488 <exit+0xf8>
      p->state = RUNNABLE;
8010449f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044a6:	eb e0                	jmp    80104488 <exit+0xf8>
  curproc->state = ZOMBIE;
801044a8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044af:	e8 1c fe ff ff       	call   801042d0 <sched>
  panic("zombie exit");
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	68 44 88 10 80       	push   $0x80108844
801044bc:	e8 cf be ff ff       	call   80100390 <panic>
  if (check_policy() && curproc->pid > 2)
801044c1:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801044c5:	0f 8e 21 ff ff ff    	jle    801043ec <exit+0x5c>
    removeSwapFile(curproc);
801044cb:	83 ec 0c             	sub    $0xc,%esp
801044ce:	53                   	push   %ebx
801044cf:	e8 1c db ff ff       	call   80101ff0 <removeSwapFile>
801044d4:	83 c4 10             	add    $0x10,%esp
801044d7:	e9 10 ff ff ff       	jmp    801043ec <exit+0x5c>
    panic("init exiting");
801044dc:	83 ec 0c             	sub    $0xc,%esp
801044df:	68 37 88 10 80       	push   $0x80108837
801044e4:	e8 a7 be ff ff       	call   80100390 <panic>
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
80104506:	e8 15 f8 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
8010450b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104511:	e8 aa 05 00 00       	call   80104ac0 <popcli>
  myproc()->state = RUNNABLE;
80104516:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010451d:	e8 ae fd ff ff       	call   801042d0 <sched>
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
80104554:	e8 c7 f7 ff ff       	call   80103d20 <mycpu>
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
80104597:	e8 34 fd ff ff       	call   801042d0 <sched>
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
801045d2:	e8 f9 fc ff ff       	call   801042d0 <sched>
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
801045e9:	68 56 88 10 80       	push   $0x80108856
801045ee:	e8 9d bd ff ff       	call   80100390 <panic>
    panic("sleep");
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	68 50 88 10 80       	push   $0x80108850
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
8010460a:	e8 11 f7 ff ff       	call   80103d20 <mycpu>
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
80104638:	81 c3 0c 03 00 00    	add    $0x30c,%ebx
8010463e:	81 fb 74 a0 15 80    	cmp    $0x8015a074,%ebx
80104644:	73 1e                	jae    80104664 <wait+0x64>
      if(p->parent != curproc)
80104646:	39 73 14             	cmp    %esi,0x14(%ebx)
80104649:	75 ed                	jne    80104638 <wait+0x38>
      if(p->state == ZOMBIE){
8010464b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010464f:	74 3f                	je     80104690 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104651:	81 c3 0c 03 00 00    	add    $0x30c,%ebx
      havekids = 1;
80104657:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465c:	81 fb 74 a0 15 80    	cmp    $0x8015a074,%ebx
80104662:	72 e2                	jb     80104646 <wait+0x46>
    if(!havekids || curproc->killed){
80104664:	85 c0                	test   %eax,%eax
80104666:	0f 84 ad 00 00 00    	je     80104719 <wait+0x119>
8010466c:	8b 46 24             	mov    0x24(%esi),%eax
8010466f:	85 c0                	test   %eax,%eax
80104671:	0f 85 a2 00 00 00    	jne    80104719 <wait+0x119>
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
80104699:	e8 52 e1 ff ff       	call   801027f0 <kfree>
        freevm(p->pgdir);
8010469e:	5a                   	pop    %edx
8010469f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801046a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801046a9:	e8 82 32 00 00       	call   80107930 <freevm>
        p->pid = 0;
801046ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        if (check_policy()) {
801046b5:	e8 96 2b 00 00       	call   80107250 <check_policy>
801046ba:	83 c4 10             	add    $0x10,%esp
801046bd:	85 c0                	test   %eax,%eax
801046bf:	74 26                	je     801046e7 <wait+0xe7>
801046c1:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801046c7:	8d 93 cc 01 00 00    	lea    0x1cc(%ebx),%edx
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
            p->memory_pages[i].is_used = 0;
801046d0:	c7 80 40 01 00 00 00 	movl   $0x0,0x140(%eax)
801046d7:	00 00 00 
            p->file_pages[i].is_used = 0;
801046da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046e0:	83 c0 14             	add    $0x14,%eax
          for (i = 0; i < MAX_PSYC_PAGES; i++) {
801046e3:	39 d0                	cmp    %edx,%eax
801046e5:	75 e9                	jne    801046d0 <wait+0xd0>
        release(&ptable.lock);
801046e7:	83 ec 0c             	sub    $0xc,%esp
        p->parent = 0;
801046ea:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046f1:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        release(&ptable.lock);
801046f5:	68 40 dd 14 80       	push   $0x8014dd40
        p->killed = 0;
801046fa:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104701:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104708:	e8 03 05 00 00       	call   80104c10 <release>
        return pid;
8010470d:	83 c4 10             	add    $0x10,%esp
}
80104710:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104713:	89 f0                	mov    %esi,%eax
80104715:	5b                   	pop    %ebx
80104716:	5e                   	pop    %esi
80104717:	5d                   	pop    %ebp
80104718:	c3                   	ret    
      release(&ptable.lock);
80104719:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010471c:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104721:	68 40 dd 14 80       	push   $0x8014dd40
80104726:	e8 e5 04 00 00       	call   80104c10 <release>
      return -1;
8010472b:	83 c4 10             	add    $0x10,%esp
8010472e:	eb e0                	jmp    80104710 <wait+0x110>

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
80104750:	05 0c 03 00 00       	add    $0x30c,%eax
80104755:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
8010475a:	73 1e                	jae    8010477a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010475c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104760:	75 ee                	jne    80104750 <wakeup+0x20>
80104762:	3b 58 20             	cmp    0x20(%eax),%ebx
80104765:	75 e9                	jne    80104750 <wakeup+0x20>
      p->state = RUNNABLE;
80104767:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010476e:	05 0c 03 00 00       	add    $0x30c,%eax
80104773:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
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
801047b0:	05 0c 03 00 00       	add    $0x30c,%eax
801047b5:	3d 74 a0 15 80       	cmp    $0x8015a074,%eax
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
8010482b:	68 41 8c 10 80       	push   $0x80108c41
80104830:	e8 2b be ff ff       	call   80100660 <cprintf>
80104835:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104838:	81 c3 0c 03 00 00    	add    $0x30c,%ebx
8010483e:	81 fb 74 a0 15 80    	cmp    $0x8015a074,%ebx
80104844:	0f 83 86 00 00 00    	jae    801048d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010484a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010484d:	85 c0                	test   %eax,%eax
8010484f:	74 e7                	je     80104838 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104851:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104854:	ba 67 88 10 80       	mov    $0x80108867,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104859:	77 11                	ja     8010486c <procdump+0x5c>
8010485b:	8b 14 85 a0 88 10 80 	mov    -0x7fef7760(,%eax,4),%edx
      state = "???";
80104862:	b8 67 88 10 80       	mov    $0x80108867,%eax
80104867:	85 d2                	test   %edx,%edx
80104869:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010486c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010486f:	50                   	push   %eax
80104870:	52                   	push   %edx
80104871:	ff 73 10             	pushl  0x10(%ebx)
80104874:	68 6b 88 10 80       	push   $0x8010886b
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
801048b9:	68 a1 81 10 80       	push   $0x801081a1
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
801048ea:	68 b8 88 10 80       	push   $0x801088b8
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
80104959:	e8 62 f4 ff ff       	call   80103dc0 <myproc>
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
801049e3:	e8 d8 f3 ff ff       	call   80103dc0 <myproc>
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
80104a8a:	e8 91 f2 ff ff       	call   80103d20 <mycpu>
80104a8f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a95:	85 c0                	test   %eax,%eax
80104a97:	75 11                	jne    80104aaa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a99:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a9f:	e8 7c f2 ff ff       	call   80103d20 <mycpu>
80104aa4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104aaa:	e8 71 f2 ff ff       	call   80103d20 <mycpu>
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
80104acd:	e8 4e f2 ff ff       	call   80103d20 <mycpu>
80104ad2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ad9:	78 34                	js     80104b0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104adb:	e8 40 f2 ff ff       	call   80103d20 <mycpu>
80104ae0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ae6:	85 d2                	test   %edx,%edx
80104ae8:	74 06                	je     80104af0 <popcli+0x30>
    sti();
}
80104aea:	c9                   	leave  
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104af0:	e8 2b f2 ff ff       	call   80103d20 <mycpu>
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
80104b05:	68 c3 88 10 80       	push   $0x801088c3
80104b0a:	e8 81 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	68 da 88 10 80       	push   $0x801088da
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
80104b38:	e8 e3 f1 ff ff       	call   80103d20 <mycpu>
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
80104b94:	e8 87 f1 ff ff       	call   80103d20 <mycpu>
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
80104bf7:	68 e1 88 10 80       	push   $0x801088e1
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
80104c4c:	68 e9 88 10 80       	push   $0x801088e9
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
80104eba:	e8 01 ef ff ff       	call   80103dc0 <myproc>

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
80104efa:	e8 c1 ee ff ff       	call   80103dc0 <myproc>

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
80104f65:	e8 56 ee ff ff       	call   80103dc0 <myproc>
80104f6a:	8b 40 18             	mov    0x18(%eax),%eax
80104f6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f70:	8b 40 44             	mov    0x44(%eax),%eax
80104f73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f76:	e8 45 ee ff ff       	call   80103dc0 <myproc>
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
80104fbb:	e8 00 ee ff ff       	call   80103dc0 <myproc>
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
[SYS_getNumberOfFreePages]  sys_getNumberOfFreePages,
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
80105057:	e8 64 ed ff ff       	call   80103dc0 <myproc>
8010505c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010505e:	8b 40 18             	mov    0x18(%eax),%eax
80105061:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105064:	8d 50 ff             	lea    -0x1(%eax),%edx
80105067:	83 fa 15             	cmp    $0x15,%edx
8010506a:	77 1c                	ja     80105088 <syscall+0x38>
8010506c:	8b 14 85 20 89 10 80 	mov    -0x7fef76e0(,%eax,4),%edx
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
80105090:	68 f1 88 10 80       	push   $0x801088f1
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
801050d4:	e8 e7 ec ff ff       	call   80103dc0 <myproc>
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
8010511b:	e8 a0 ec ff ff       	call   80103dc0 <myproc>
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
80105265:	e8 56 eb ff ff       	call   80103dc0 <myproc>
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
80105328:	e8 f3 dd ff ff       	call   80103120 <begin_op>
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
801053c0:	e8 cb dd ff ff       	call   80103190 <end_op>

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
80105402:	e8 89 dd ff ff       	call   80103190 <end_op>
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
80105420:	e8 6b dd ff ff       	call   80103190 <end_op>
    return -1;
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542d:	eb 9b                	jmp    801053ca <sys_link+0xda>
    end_op();
8010542f:	e8 5c dd ff ff       	call   80103190 <end_op>
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
801054a0:	68 7c 89 10 80       	push   $0x8010897c
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
801054d2:	e8 49 dc ff ff       	call   80103120 <begin_op>
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
801054fb:	68 dd 82 10 80       	push   $0x801082dd
80105500:	53                   	push   %ebx
80105501:	e8 ca c6 ff ff       	call   80101bd0 <namecmp>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	0f 84 d7 00 00 00    	je     801055e8 <sys_unlink+0x138>
80105511:	83 ec 08             	sub    $0x8,%esp
80105514:	68 dc 82 10 80       	push   $0x801082dc
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
801055b0:	e8 db db ff ff       	call   80103190 <end_op>

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
801055f1:	e8 9a db ff ff       	call   80103190 <end_op>
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
80105627:	e8 64 db ff ff       	call   80103190 <end_op>
    return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 87                	jmp    801055ba <sys_unlink+0x10a>
    panic("unlink: writei");
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	68 f1 82 10 80       	push   $0x801082f1
8010563b:	e8 50 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 df 82 10 80       	push   $0x801082df
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
80105794:	68 dd 82 10 80       	push   $0x801082dd
80105799:	57                   	push   %edi
8010579a:	e8 c1 c6 ff ff       	call   80101e60 <dirlink>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 1c                	js     801057c2 <create+0x172>
801057a6:	83 ec 04             	sub    $0x4,%esp
801057a9:	ff 73 04             	pushl  0x4(%ebx)
801057ac:	68 dc 82 10 80       	push   $0x801082dc
801057b1:	57                   	push   %edi
801057b2:	e8 a9 c6 ff ff       	call   80101e60 <dirlink>
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	85 c0                	test   %eax,%eax
801057bc:	0f 89 6e ff ff ff    	jns    80105730 <create+0xe0>
      panic("create dots");
801057c2:	83 ec 0c             	sub    $0xc,%esp
801057c5:	68 9d 89 10 80       	push   $0x8010899d
801057ca:	e8 c1 ab ff ff       	call   80100390 <panic>
801057cf:	90                   	nop
    return 0;
801057d0:	31 ff                	xor    %edi,%edi
801057d2:	e9 f5 fe ff ff       	jmp    801056cc <create+0x7c>
    panic("create: dirlink");
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	68 a9 89 10 80       	push   $0x801089a9
801057df:	e8 ac ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	68 8e 89 10 80       	push   $0x8010898e
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
80105838:	e8 e3 d8 ff ff       	call   80103120 <begin_op>

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
80105885:	e8 36 e5 ff ff       	call   80103dc0 <myproc>
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
801058b1:	e8 da d8 ff ff       	call   80103190 <end_op>

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
8010590b:	e8 80 d8 ff ff       	call   80103190 <end_op>
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
80105934:	e8 57 d8 ff ff       	call   80103190 <end_op>
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
80105966:	e8 b5 d7 ff ff       	call   80103120 <begin_op>
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
8010599e:	e8 ed d7 ff ff       	call   80103190 <end_op>
  return 0;
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	31 c0                	xor    %eax,%eax
}
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801059b0:	e8 db d7 ff ff       	call   80103190 <end_op>
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
801059c6:	e8 55 d7 ff ff       	call   80103120 <begin_op>
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
80105a2e:	e8 5d d7 ff ff       	call   80103190 <end_op>
  return 0;
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	31 c0                	xor    %eax,%eax
}
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a40:	e8 4b d7 ff ff       	call   80103190 <end_op>
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
80105a58:	e8 63 e3 ff ff       	call   80103dc0 <myproc>
80105a5d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a5f:	e8 bc d6 ff ff       	call   80103120 <begin_op>
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
80105ab2:	e8 d9 d6 ff ff       	call   80103190 <end_op>
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
80105ad9:	e8 b2 d6 ff ff       	call   80103190 <end_op>
    return -1;
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae6:	eb d7                	jmp    80105abf <sys_chdir+0x6f>
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105af0:	e8 9b d6 ff ff       	call   80103190 <end_op>
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
80105c1c:	e8 9f db ff ff       	call   801037c0 <pipealloc>
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
80105c31:	e8 8a e1 ff ff       	call   80103dc0 <myproc>
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
80105c5a:	e8 61 e1 ff ff       	call   80103dc0 <myproc>
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
80105c98:	e8 23 e1 ff ff       	call   80103dc0 <myproc>
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
80105cd4:	e9 87 e2 ff ff       	jmp    80103f60 <fork>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_exit>:

int
sys_exit(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ce6:	e8 a5 e6 ff ff       	call   80104390 <exit>
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
80105d46:	e8 75 e0 ff ff       	call   80103dc0 <myproc>
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
80105d69:	e8 52 e0 ff ff       	call   80103dc0 <myproc>
  if(growproc(n) < 0)
80105d6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d73:	ff 75 f4             	pushl  -0xc(%ebp)
80105d76:	e8 65 e1 ff ff       	call   80103ee0 <growproc>
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
80105dc0:	68 80 a0 15 80       	push   $0x8015a080
80105dc5:	e8 86 ed ff ff       	call   80104b50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dcd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105dd0:	8b 1d c0 a8 15 80    	mov    0x8015a8c0,%ebx
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
80105de3:	68 80 a0 15 80       	push   $0x8015a080
80105de8:	68 c0 a8 15 80       	push   $0x8015a8c0
80105ded:	e8 4e e7 ff ff       	call   80104540 <sleep>
  while(ticks - ticks0 < n){
80105df2:	a1 c0 a8 15 80       	mov    0x8015a8c0,%eax
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	29 d8                	sub    %ebx,%eax
80105dfc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105dff:	73 2f                	jae    80105e30 <sys_sleep+0x90>
    if(myproc()->killed){
80105e01:	e8 ba df ff ff       	call   80103dc0 <myproc>
80105e06:	8b 40 24             	mov    0x24(%eax),%eax
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	74 d3                	je     80105de0 <sys_sleep+0x40>
      release(&tickslock);
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	68 80 a0 15 80       	push   $0x8015a080
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
80105e33:	68 80 a0 15 80       	push   $0x8015a080
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
80105e57:	68 80 a0 15 80       	push   $0x8015a080
80105e5c:	e8 ef ec ff ff       	call   80104b50 <acquire>
  xticks = ticks;
80105e61:	8b 1d c0 a8 15 80    	mov    0x8015a8c0,%ebx
  release(&tickslock);
80105e67:	c7 04 24 80 a0 15 80 	movl   $0x8015a080,(%esp)
80105e6e:	e8 9d ed ff ff       	call   80104c10 <release>
  return xticks;
}
80105e73:	89 d8                	mov    %ebx,%eax
80105e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e78:	c9                   	leave  
80105e79:	c3                   	ret    
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e80 <sys_getNumberOfFreePages>:

int sys_getNumberOfFreePages(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
  return free_pages();
}
80105e83:	5d                   	pop    %ebp
  return free_pages();
80105e84:	e9 57 c9 ff ff       	jmp    801027e0 <free_pages>

80105e89 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e89:	1e                   	push   %ds
  pushl %es
80105e8a:	06                   	push   %es
  pushl %fs
80105e8b:	0f a0                	push   %fs
  pushl %gs
80105e8d:	0f a8                	push   %gs
  pushal
80105e8f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e90:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e94:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e96:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e98:	54                   	push   %esp
  call trap
80105e99:	e8 c2 00 00 00       	call   80105f60 <trap>
  addl $4, %esp
80105e9e:	83 c4 04             	add    $0x4,%esp

80105ea1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ea1:	61                   	popa   
  popl %gs
80105ea2:	0f a9                	pop    %gs
  popl %fs
80105ea4:	0f a1                	pop    %fs
  popl %es
80105ea6:	07                   	pop    %es
  popl %ds
80105ea7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ea8:	83 c4 08             	add    $0x8,%esp
  iret
80105eab:	cf                   	iret   
80105eac:	66 90                	xchg   %ax,%ax
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105eb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105eb1:	31 c0                	xor    %eax,%eax
{
80105eb3:	89 e5                	mov    %esp,%ebp
80105eb5:	83 ec 08             	sub    $0x8,%esp
80105eb8:	90                   	nop
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ec0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ec7:	c7 04 c5 c2 a0 15 80 	movl   $0x8e000008,-0x7fea5f3e(,%eax,8)
80105ece:	08 00 00 8e 
80105ed2:	66 89 14 c5 c0 a0 15 	mov    %dx,-0x7fea5f40(,%eax,8)
80105ed9:	80 
80105eda:	c1 ea 10             	shr    $0x10,%edx
80105edd:	66 89 14 c5 c6 a0 15 	mov    %dx,-0x7fea5f3a(,%eax,8)
80105ee4:	80 
  for(i = 0; i < 256; i++)
80105ee5:	83 c0 01             	add    $0x1,%eax
80105ee8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105eed:	75 d1                	jne    80105ec0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105eef:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ef4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ef7:	c7 05 c2 a2 15 80 08 	movl   $0xef000008,0x8015a2c2
80105efe:	00 00 ef 
  initlock(&tickslock, "time");
80105f01:	68 b9 89 10 80       	push   $0x801089b9
80105f06:	68 80 a0 15 80       	push   $0x8015a080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f0b:	66 a3 c0 a2 15 80    	mov    %ax,0x8015a2c0
80105f11:	c1 e8 10             	shr    $0x10,%eax
80105f14:	66 a3 c6 a2 15 80    	mov    %ax,0x8015a2c6
  initlock(&tickslock, "time");
80105f1a:	e8 f1 ea ff ff       	call   80104a10 <initlock>
}
80105f1f:	83 c4 10             	add    $0x10,%esp
80105f22:	c9                   	leave  
80105f23:	c3                   	ret    
80105f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f30 <idtinit>:

void
idtinit(void)
{
80105f30:	55                   	push   %ebp
  pd[0] = size-1;
80105f31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f36:	89 e5                	mov    %esp,%ebp
80105f38:	83 ec 10             	sub    $0x10,%esp
80105f3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f3f:	b8 c0 a0 15 80       	mov    $0x8015a0c0,%eax
80105f44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f48:	c1 e8 10             	shr    $0x10,%eax
80105f4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	57                   	push   %edi
80105f64:	56                   	push   %esi
80105f65:	53                   	push   %ebx
80105f66:	83 ec 1c             	sub    $0x1c,%esp
80105f69:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f6c:	8b 47 30             	mov    0x30(%edi),%eax
80105f6f:	83 f8 40             	cmp    $0x40,%eax
80105f72:	0f 84 f8 00 00 00    	je     80106070 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f78:	83 e8 0e             	sub    $0xe,%eax
80105f7b:	83 f8 31             	cmp    $0x31,%eax
80105f7e:	77 1d                	ja     80105f9d <trap+0x3d>
80105f80:	ff 24 85 7c 8a 10 80 	jmp    *-0x7fef7584(,%eax,4)
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT:
    if (check_policy()) {
80105f90:	e8 bb 12 00 00       	call   80107250 <check_policy>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	0f 85 c3 01 00 00    	jne    80106160 <trap+0x200>
        panic("trap: segmentation fault\n");
      // break;
    }
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f9d:	e8 1e de ff ff       	call   80103dc0 <myproc>
80105fa2:	85 c0                	test   %eax,%eax
80105fa4:	8b 5f 38             	mov    0x38(%edi),%ebx
80105fa7:	0f 84 2f 02 00 00    	je     801061dc <trap+0x27c>
80105fad:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fb1:	0f 84 25 02 00 00    	je     801061dc <trap+0x27c>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fb7:	0f 20 d1             	mov    %cr2,%ecx
80105fba:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fbd:	e8 de dd ff ff       	call   80103da0 <cpuid>
80105fc2:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105fc5:	8b 47 34             	mov    0x34(%edi),%eax
80105fc8:	8b 77 30             	mov    0x30(%edi),%esi
80105fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fce:	e8 ed dd ff ff       	call   80103dc0 <myproc>
80105fd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fd6:	e8 e5 dd ff ff       	call   80103dc0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fdb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fde:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fe1:	51                   	push   %ecx
80105fe2:	53                   	push   %ebx
80105fe3:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fe4:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fe7:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105feb:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fee:	52                   	push   %edx
80105fef:	ff 70 10             	pushl  0x10(%eax)
80105ff2:	68 38 8a 10 80       	push   $0x80108a38
80105ff7:	e8 64 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105ffc:	83 c4 20             	add    $0x20,%esp
80105fff:	e8 bc dd ff ff       	call   80103dc0 <myproc>
80106004:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010600b:	e8 b0 dd ff ff       	call   80103dc0 <myproc>
80106010:	85 c0                	test   %eax,%eax
80106012:	74 1d                	je     80106031 <trap+0xd1>
80106014:	e8 a7 dd ff ff       	call   80103dc0 <myproc>
80106019:	8b 50 24             	mov    0x24(%eax),%edx
8010601c:	85 d2                	test   %edx,%edx
8010601e:	74 11                	je     80106031 <trap+0xd1>
80106020:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106024:	83 e0 03             	and    $0x3,%eax
80106027:	66 83 f8 03          	cmp    $0x3,%ax
8010602b:	0f 84 1f 01 00 00    	je     80106150 <trap+0x1f0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106031:	e8 8a dd ff ff       	call   80103dc0 <myproc>
80106036:	85 c0                	test   %eax,%eax
80106038:	74 0b                	je     80106045 <trap+0xe5>
8010603a:	e8 81 dd ff ff       	call   80103dc0 <myproc>
8010603f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106043:	74 63                	je     801060a8 <trap+0x148>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106045:	e8 76 dd ff ff       	call   80103dc0 <myproc>
8010604a:	85 c0                	test   %eax,%eax
8010604c:	74 19                	je     80106067 <trap+0x107>
8010604e:	e8 6d dd ff ff       	call   80103dc0 <myproc>
80106053:	8b 40 24             	mov    0x24(%eax),%eax
80106056:	85 c0                	test   %eax,%eax
80106058:	74 0d                	je     80106067 <trap+0x107>
8010605a:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010605e:	83 e0 03             	and    $0x3,%eax
80106061:	66 83 f8 03          	cmp    $0x3,%ax
80106065:	74 32                	je     80106099 <trap+0x139>
    exit();
}
80106067:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010606a:	5b                   	pop    %ebx
8010606b:	5e                   	pop    %esi
8010606c:	5f                   	pop    %edi
8010606d:	5d                   	pop    %ebp
8010606e:	c3                   	ret    
8010606f:	90                   	nop
    if(myproc()->killed)
80106070:	e8 4b dd ff ff       	call   80103dc0 <myproc>
80106075:	8b 58 24             	mov    0x24(%eax),%ebx
80106078:	85 db                	test   %ebx,%ebx
8010607a:	0f 85 c0 00 00 00    	jne    80106140 <trap+0x1e0>
    myproc()->tf = tf;
80106080:	e8 3b dd ff ff       	call   80103dc0 <myproc>
80106085:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106088:	e8 c3 ef ff ff       	call   80105050 <syscall>
    if(myproc()->killed)
8010608d:	e8 2e dd ff ff       	call   80103dc0 <myproc>
80106092:	8b 48 24             	mov    0x24(%eax),%ecx
80106095:	85 c9                	test   %ecx,%ecx
80106097:	74 ce                	je     80106067 <trap+0x107>
}
80106099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609c:	5b                   	pop    %ebx
8010609d:	5e                   	pop    %esi
8010609e:	5f                   	pop    %edi
8010609f:	5d                   	pop    %ebp
      exit();
801060a0:	e9 eb e2 ff ff       	jmp    80104390 <exit>
801060a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801060a8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060ac:	75 97                	jne    80106045 <trap+0xe5>
    yield();
801060ae:	e8 3d e4 ff ff       	call   801044f0 <yield>
801060b3:	eb 90                	jmp    80106045 <trap+0xe5>
801060b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801060b8:	e8 e3 dc ff ff       	call   80103da0 <cpuid>
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 84 e3 00 00 00    	je     801061a8 <trap+0x248>
    lapiceoi();
801060c5:	e8 06 cc ff ff       	call   80102cd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ca:	e8 f1 dc ff ff       	call   80103dc0 <myproc>
801060cf:	85 c0                	test   %eax,%eax
801060d1:	0f 85 3d ff ff ff    	jne    80106014 <trap+0xb4>
801060d7:	e9 55 ff ff ff       	jmp    80106031 <trap+0xd1>
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801060e0:	e8 ab ca ff ff       	call   80102b90 <kbdintr>
    lapiceoi();
801060e5:	e8 e6 cb ff ff       	call   80102cd0 <lapiceoi>
    break;
801060ea:	e9 1c ff ff ff       	jmp    8010600b <trap+0xab>
801060ef:	90                   	nop
    uartintr();
801060f0:	e8 8b 02 00 00       	call   80106380 <uartintr>
    lapiceoi();
801060f5:	e8 d6 cb ff ff       	call   80102cd0 <lapiceoi>
    break;
801060fa:	e9 0c ff ff ff       	jmp    8010600b <trap+0xab>
801060ff:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106100:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106104:	8b 77 38             	mov    0x38(%edi),%esi
80106107:	e8 94 dc ff ff       	call   80103da0 <cpuid>
8010610c:	56                   	push   %esi
8010610d:	53                   	push   %ebx
8010610e:	50                   	push   %eax
8010610f:	68 e0 89 10 80       	push   $0x801089e0
80106114:	e8 47 a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106119:	e8 b2 cb ff ff       	call   80102cd0 <lapiceoi>
    break;
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	e9 e5 fe ff ff       	jmp    8010600b <trap+0xab>
80106126:	8d 76 00             	lea    0x0(%esi),%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106130:	e8 1b c3 ff ff       	call   80102450 <ideintr>
80106135:	eb 8e                	jmp    801060c5 <trap+0x165>
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106140:	e8 4b e2 ff ff       	call   80104390 <exit>
80106145:	e9 36 ff ff ff       	jmp    80106080 <trap+0x120>
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106150:	e8 3b e2 ff ff       	call   80104390 <exit>
80106155:	e9 d7 fe ff ff       	jmp    80106031 <trap+0xd1>
8010615a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (myproc()->pid > 2 && handle_pf())
80106160:	e8 5b dc ff ff       	call   80103dc0 <myproc>
80106165:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106169:	7e 0d                	jle    80106178 <trap+0x218>
8010616b:	e8 f0 1b 00 00       	call   80107d60 <handle_pf>
80106170:	85 c0                	test   %eax,%eax
80106172:	0f 85 93 fe ff ff    	jne    8010600b <trap+0xab>
      else if (handle_cow())
80106178:	e8 e3 1e 00 00       	call   80108060 <handle_cow>
8010617d:	85 c0                	test   %eax,%eax
8010617f:	0f 85 86 fe ff ff    	jne    8010600b <trap+0xab>
      else if (myproc()->pid > 2)
80106185:	e8 36 dc ff ff       	call   80103dc0 <myproc>
8010618a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010618e:	0f 8e 09 fe ff ff    	jle    80105f9d <trap+0x3d>
        panic("trap: segmentation fault\n");
80106194:	83 ec 0c             	sub    $0xc,%esp
80106197:	68 be 89 10 80       	push   $0x801089be
8010619c:	e8 ef a1 ff ff       	call   80100390 <panic>
801061a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      acquire(&tickslock);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	68 80 a0 15 80       	push   $0x8015a080
801061b0:	e8 9b e9 ff ff       	call   80104b50 <acquire>
      wakeup(&ticks);
801061b5:	c7 04 24 c0 a8 15 80 	movl   $0x8015a8c0,(%esp)
      ticks++;
801061bc:	83 05 c0 a8 15 80 01 	addl   $0x1,0x8015a8c0
      wakeup(&ticks);
801061c3:	e8 68 e5 ff ff       	call   80104730 <wakeup>
      release(&tickslock);
801061c8:	c7 04 24 80 a0 15 80 	movl   $0x8015a080,(%esp)
801061cf:	e8 3c ea ff ff       	call   80104c10 <release>
801061d4:	83 c4 10             	add    $0x10,%esp
801061d7:	e9 e9 fe ff ff       	jmp    801060c5 <trap+0x165>
801061dc:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061df:	e8 bc db ff ff       	call   80103da0 <cpuid>
801061e4:	83 ec 0c             	sub    $0xc,%esp
801061e7:	56                   	push   %esi
801061e8:	53                   	push   %ebx
801061e9:	50                   	push   %eax
801061ea:	ff 77 30             	pushl  0x30(%edi)
801061ed:	68 04 8a 10 80       	push   $0x80108a04
801061f2:	e8 69 a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
801061f7:	83 c4 14             	add    $0x14,%esp
801061fa:	68 d8 89 10 80       	push   $0x801089d8
801061ff:	e8 8c a1 ff ff       	call   80100390 <panic>
80106204:	66 90                	xchg   %ax,%ax
80106206:	66 90                	xchg   %ax,%ax
80106208:	66 90                	xchg   %ax,%ax
8010620a:	66 90                	xchg   %ax,%ax
8010620c:	66 90                	xchg   %ax,%ax
8010620e:	66 90                	xchg   %ax,%ax

80106210 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106210:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
{
80106215:	55                   	push   %ebp
80106216:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106218:	85 c0                	test   %eax,%eax
8010621a:	74 1c                	je     80106238 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010621c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106221:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106222:	a8 01                	test   $0x1,%al
80106224:	74 12                	je     80106238 <uartgetc+0x28>
80106226:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010622b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010622c:	0f b6 c0             	movzbl %al,%eax
}
8010622f:	5d                   	pop    %ebp
80106230:	c3                   	ret    
80106231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010623d:	5d                   	pop    %ebp
8010623e:	c3                   	ret    
8010623f:	90                   	nop

80106240 <uartputc.part.0>:
uartputc(int c)
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	57                   	push   %edi
80106244:	56                   	push   %esi
80106245:	53                   	push   %ebx
80106246:	89 c7                	mov    %eax,%edi
80106248:	bb 80 00 00 00       	mov    $0x80,%ebx
8010624d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106252:	83 ec 0c             	sub    $0xc,%esp
80106255:	eb 1b                	jmp    80106272 <uartputc.part.0+0x32>
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106260:	83 ec 0c             	sub    $0xc,%esp
80106263:	6a 0a                	push   $0xa
80106265:	e8 86 ca ff ff       	call   80102cf0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010626a:	83 c4 10             	add    $0x10,%esp
8010626d:	83 eb 01             	sub    $0x1,%ebx
80106270:	74 07                	je     80106279 <uartputc.part.0+0x39>
80106272:	89 f2                	mov    %esi,%edx
80106274:	ec                   	in     (%dx),%al
80106275:	a8 20                	test   $0x20,%al
80106277:	74 e7                	je     80106260 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106279:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627e:	89 f8                	mov    %edi,%eax
80106280:	ee                   	out    %al,(%dx)
}
80106281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106284:	5b                   	pop    %ebx
80106285:	5e                   	pop    %esi
80106286:	5f                   	pop    %edi
80106287:	5d                   	pop    %ebp
80106288:	c3                   	ret    
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106290 <uartinit>:
{
80106290:	55                   	push   %ebp
80106291:	31 c9                	xor    %ecx,%ecx
80106293:	89 c8                	mov    %ecx,%eax
80106295:	89 e5                	mov    %esp,%ebp
80106297:	57                   	push   %edi
80106298:	56                   	push   %esi
80106299:	53                   	push   %ebx
8010629a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010629f:	89 da                	mov    %ebx,%edx
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	ee                   	out    %al,(%dx)
801062a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062af:	89 fa                	mov    %edi,%edx
801062b1:	ee                   	out    %al,(%dx)
801062b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bc:	ee                   	out    %al,(%dx)
801062bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801062c2:	89 c8                	mov    %ecx,%eax
801062c4:	89 f2                	mov    %esi,%edx
801062c6:	ee                   	out    %al,(%dx)
801062c7:	b8 03 00 00 00       	mov    $0x3,%eax
801062cc:	89 fa                	mov    %edi,%edx
801062ce:	ee                   	out    %al,(%dx)
801062cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062d4:	89 c8                	mov    %ecx,%eax
801062d6:	ee                   	out    %al,(%dx)
801062d7:	b8 01 00 00 00       	mov    $0x1,%eax
801062dc:	89 f2                	mov    %esi,%edx
801062de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801062e5:	3c ff                	cmp    $0xff,%al
801062e7:	74 5a                	je     80106343 <uartinit+0xb3>
  uart = 1;
801062e9:	c7 05 c4 c5 10 80 01 	movl   $0x1,0x8010c5c4
801062f0:	00 00 00 
801062f3:	89 da                	mov    %ebx,%edx
801062f5:	ec                   	in     (%dx),%al
801062f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801062fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801062ff:	bb 44 8b 10 80       	mov    $0x80108b44,%ebx
  ioapicenable(IRQ_COM1, 0);
80106304:	6a 00                	push   $0x0
80106306:	6a 04                	push   $0x4
80106308:	e8 93 c3 ff ff       	call   801026a0 <ioapicenable>
8010630d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106310:	b8 78 00 00 00       	mov    $0x78,%eax
80106315:	eb 13                	jmp    8010632a <uartinit+0x9a>
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106320:	83 c3 01             	add    $0x1,%ebx
80106323:	0f be 03             	movsbl (%ebx),%eax
80106326:	84 c0                	test   %al,%al
80106328:	74 19                	je     80106343 <uartinit+0xb3>
  if(!uart)
8010632a:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
80106330:	85 d2                	test   %edx,%edx
80106332:	74 ec                	je     80106320 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106334:	83 c3 01             	add    $0x1,%ebx
80106337:	e8 04 ff ff ff       	call   80106240 <uartputc.part.0>
8010633c:	0f be 03             	movsbl (%ebx),%eax
8010633f:	84 c0                	test   %al,%al
80106341:	75 e7                	jne    8010632a <uartinit+0x9a>
}
80106343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106346:	5b                   	pop    %ebx
80106347:	5e                   	pop    %esi
80106348:	5f                   	pop    %edi
80106349:	5d                   	pop    %ebp
8010634a:	c3                   	ret    
8010634b:	90                   	nop
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106350 <uartputc>:
  if(!uart)
80106350:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
{
80106356:	55                   	push   %ebp
80106357:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106359:	85 d2                	test   %edx,%edx
{
8010635b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010635e:	74 10                	je     80106370 <uartputc+0x20>
}
80106360:	5d                   	pop    %ebp
80106361:	e9 da fe ff ff       	jmp    80106240 <uartputc.part.0>
80106366:	8d 76 00             	lea    0x0(%esi),%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106370:	5d                   	pop    %ebp
80106371:	c3                   	ret    
80106372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106380 <uartintr>:

void
uartintr(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106386:	68 10 62 10 80       	push   $0x80106210
8010638b:	e8 80 a4 ff ff       	call   80100810 <consoleintr>
}
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	c9                   	leave  
80106394:	c3                   	ret    

80106395 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $0
80106397:	6a 00                	push   $0x0
  jmp alltraps
80106399:	e9 eb fa ff ff       	jmp    80105e89 <alltraps>

8010639e <vector1>:
.globl vector1
vector1:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $1
801063a0:	6a 01                	push   $0x1
  jmp alltraps
801063a2:	e9 e2 fa ff ff       	jmp    80105e89 <alltraps>

801063a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $2
801063a9:	6a 02                	push   $0x2
  jmp alltraps
801063ab:	e9 d9 fa ff ff       	jmp    80105e89 <alltraps>

801063b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $3
801063b2:	6a 03                	push   $0x3
  jmp alltraps
801063b4:	e9 d0 fa ff ff       	jmp    80105e89 <alltraps>

801063b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $4
801063bb:	6a 04                	push   $0x4
  jmp alltraps
801063bd:	e9 c7 fa ff ff       	jmp    80105e89 <alltraps>

801063c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $5
801063c4:	6a 05                	push   $0x5
  jmp alltraps
801063c6:	e9 be fa ff ff       	jmp    80105e89 <alltraps>

801063cb <vector6>:
.globl vector6
vector6:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $6
801063cd:	6a 06                	push   $0x6
  jmp alltraps
801063cf:	e9 b5 fa ff ff       	jmp    80105e89 <alltraps>

801063d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $7
801063d6:	6a 07                	push   $0x7
  jmp alltraps
801063d8:	e9 ac fa ff ff       	jmp    80105e89 <alltraps>

801063dd <vector8>:
.globl vector8
vector8:
  pushl $8
801063dd:	6a 08                	push   $0x8
  jmp alltraps
801063df:	e9 a5 fa ff ff       	jmp    80105e89 <alltraps>

801063e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $9
801063e6:	6a 09                	push   $0x9
  jmp alltraps
801063e8:	e9 9c fa ff ff       	jmp    80105e89 <alltraps>

801063ed <vector10>:
.globl vector10
vector10:
  pushl $10
801063ed:	6a 0a                	push   $0xa
  jmp alltraps
801063ef:	e9 95 fa ff ff       	jmp    80105e89 <alltraps>

801063f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063f4:	6a 0b                	push   $0xb
  jmp alltraps
801063f6:	e9 8e fa ff ff       	jmp    80105e89 <alltraps>

801063fb <vector12>:
.globl vector12
vector12:
  pushl $12
801063fb:	6a 0c                	push   $0xc
  jmp alltraps
801063fd:	e9 87 fa ff ff       	jmp    80105e89 <alltraps>

80106402 <vector13>:
.globl vector13
vector13:
  pushl $13
80106402:	6a 0d                	push   $0xd
  jmp alltraps
80106404:	e9 80 fa ff ff       	jmp    80105e89 <alltraps>

80106409 <vector14>:
.globl vector14
vector14:
  pushl $14
80106409:	6a 0e                	push   $0xe
  jmp alltraps
8010640b:	e9 79 fa ff ff       	jmp    80105e89 <alltraps>

80106410 <vector15>:
.globl vector15
vector15:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $15
80106412:	6a 0f                	push   $0xf
  jmp alltraps
80106414:	e9 70 fa ff ff       	jmp    80105e89 <alltraps>

80106419 <vector16>:
.globl vector16
vector16:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $16
8010641b:	6a 10                	push   $0x10
  jmp alltraps
8010641d:	e9 67 fa ff ff       	jmp    80105e89 <alltraps>

80106422 <vector17>:
.globl vector17
vector17:
  pushl $17
80106422:	6a 11                	push   $0x11
  jmp alltraps
80106424:	e9 60 fa ff ff       	jmp    80105e89 <alltraps>

80106429 <vector18>:
.globl vector18
vector18:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $18
8010642b:	6a 12                	push   $0x12
  jmp alltraps
8010642d:	e9 57 fa ff ff       	jmp    80105e89 <alltraps>

80106432 <vector19>:
.globl vector19
vector19:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $19
80106434:	6a 13                	push   $0x13
  jmp alltraps
80106436:	e9 4e fa ff ff       	jmp    80105e89 <alltraps>

8010643b <vector20>:
.globl vector20
vector20:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $20
8010643d:	6a 14                	push   $0x14
  jmp alltraps
8010643f:	e9 45 fa ff ff       	jmp    80105e89 <alltraps>

80106444 <vector21>:
.globl vector21
vector21:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $21
80106446:	6a 15                	push   $0x15
  jmp alltraps
80106448:	e9 3c fa ff ff       	jmp    80105e89 <alltraps>

8010644d <vector22>:
.globl vector22
vector22:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $22
8010644f:	6a 16                	push   $0x16
  jmp alltraps
80106451:	e9 33 fa ff ff       	jmp    80105e89 <alltraps>

80106456 <vector23>:
.globl vector23
vector23:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $23
80106458:	6a 17                	push   $0x17
  jmp alltraps
8010645a:	e9 2a fa ff ff       	jmp    80105e89 <alltraps>

8010645f <vector24>:
.globl vector24
vector24:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $24
80106461:	6a 18                	push   $0x18
  jmp alltraps
80106463:	e9 21 fa ff ff       	jmp    80105e89 <alltraps>

80106468 <vector25>:
.globl vector25
vector25:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $25
8010646a:	6a 19                	push   $0x19
  jmp alltraps
8010646c:	e9 18 fa ff ff       	jmp    80105e89 <alltraps>

80106471 <vector26>:
.globl vector26
vector26:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $26
80106473:	6a 1a                	push   $0x1a
  jmp alltraps
80106475:	e9 0f fa ff ff       	jmp    80105e89 <alltraps>

8010647a <vector27>:
.globl vector27
vector27:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $27
8010647c:	6a 1b                	push   $0x1b
  jmp alltraps
8010647e:	e9 06 fa ff ff       	jmp    80105e89 <alltraps>

80106483 <vector28>:
.globl vector28
vector28:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $28
80106485:	6a 1c                	push   $0x1c
  jmp alltraps
80106487:	e9 fd f9 ff ff       	jmp    80105e89 <alltraps>

8010648c <vector29>:
.globl vector29
vector29:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $29
8010648e:	6a 1d                	push   $0x1d
  jmp alltraps
80106490:	e9 f4 f9 ff ff       	jmp    80105e89 <alltraps>

80106495 <vector30>:
.globl vector30
vector30:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $30
80106497:	6a 1e                	push   $0x1e
  jmp alltraps
80106499:	e9 eb f9 ff ff       	jmp    80105e89 <alltraps>

8010649e <vector31>:
.globl vector31
vector31:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $31
801064a0:	6a 1f                	push   $0x1f
  jmp alltraps
801064a2:	e9 e2 f9 ff ff       	jmp    80105e89 <alltraps>

801064a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $32
801064a9:	6a 20                	push   $0x20
  jmp alltraps
801064ab:	e9 d9 f9 ff ff       	jmp    80105e89 <alltraps>

801064b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $33
801064b2:	6a 21                	push   $0x21
  jmp alltraps
801064b4:	e9 d0 f9 ff ff       	jmp    80105e89 <alltraps>

801064b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $34
801064bb:	6a 22                	push   $0x22
  jmp alltraps
801064bd:	e9 c7 f9 ff ff       	jmp    80105e89 <alltraps>

801064c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $35
801064c4:	6a 23                	push   $0x23
  jmp alltraps
801064c6:	e9 be f9 ff ff       	jmp    80105e89 <alltraps>

801064cb <vector36>:
.globl vector36
vector36:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $36
801064cd:	6a 24                	push   $0x24
  jmp alltraps
801064cf:	e9 b5 f9 ff ff       	jmp    80105e89 <alltraps>

801064d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $37
801064d6:	6a 25                	push   $0x25
  jmp alltraps
801064d8:	e9 ac f9 ff ff       	jmp    80105e89 <alltraps>

801064dd <vector38>:
.globl vector38
vector38:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $38
801064df:	6a 26                	push   $0x26
  jmp alltraps
801064e1:	e9 a3 f9 ff ff       	jmp    80105e89 <alltraps>

801064e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $39
801064e8:	6a 27                	push   $0x27
  jmp alltraps
801064ea:	e9 9a f9 ff ff       	jmp    80105e89 <alltraps>

801064ef <vector40>:
.globl vector40
vector40:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $40
801064f1:	6a 28                	push   $0x28
  jmp alltraps
801064f3:	e9 91 f9 ff ff       	jmp    80105e89 <alltraps>

801064f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $41
801064fa:	6a 29                	push   $0x29
  jmp alltraps
801064fc:	e9 88 f9 ff ff       	jmp    80105e89 <alltraps>

80106501 <vector42>:
.globl vector42
vector42:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $42
80106503:	6a 2a                	push   $0x2a
  jmp alltraps
80106505:	e9 7f f9 ff ff       	jmp    80105e89 <alltraps>

8010650a <vector43>:
.globl vector43
vector43:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $43
8010650c:	6a 2b                	push   $0x2b
  jmp alltraps
8010650e:	e9 76 f9 ff ff       	jmp    80105e89 <alltraps>

80106513 <vector44>:
.globl vector44
vector44:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $44
80106515:	6a 2c                	push   $0x2c
  jmp alltraps
80106517:	e9 6d f9 ff ff       	jmp    80105e89 <alltraps>

8010651c <vector45>:
.globl vector45
vector45:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $45
8010651e:	6a 2d                	push   $0x2d
  jmp alltraps
80106520:	e9 64 f9 ff ff       	jmp    80105e89 <alltraps>

80106525 <vector46>:
.globl vector46
vector46:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $46
80106527:	6a 2e                	push   $0x2e
  jmp alltraps
80106529:	e9 5b f9 ff ff       	jmp    80105e89 <alltraps>

8010652e <vector47>:
.globl vector47
vector47:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $47
80106530:	6a 2f                	push   $0x2f
  jmp alltraps
80106532:	e9 52 f9 ff ff       	jmp    80105e89 <alltraps>

80106537 <vector48>:
.globl vector48
vector48:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $48
80106539:	6a 30                	push   $0x30
  jmp alltraps
8010653b:	e9 49 f9 ff ff       	jmp    80105e89 <alltraps>

80106540 <vector49>:
.globl vector49
vector49:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $49
80106542:	6a 31                	push   $0x31
  jmp alltraps
80106544:	e9 40 f9 ff ff       	jmp    80105e89 <alltraps>

80106549 <vector50>:
.globl vector50
vector50:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $50
8010654b:	6a 32                	push   $0x32
  jmp alltraps
8010654d:	e9 37 f9 ff ff       	jmp    80105e89 <alltraps>

80106552 <vector51>:
.globl vector51
vector51:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $51
80106554:	6a 33                	push   $0x33
  jmp alltraps
80106556:	e9 2e f9 ff ff       	jmp    80105e89 <alltraps>

8010655b <vector52>:
.globl vector52
vector52:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $52
8010655d:	6a 34                	push   $0x34
  jmp alltraps
8010655f:	e9 25 f9 ff ff       	jmp    80105e89 <alltraps>

80106564 <vector53>:
.globl vector53
vector53:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $53
80106566:	6a 35                	push   $0x35
  jmp alltraps
80106568:	e9 1c f9 ff ff       	jmp    80105e89 <alltraps>

8010656d <vector54>:
.globl vector54
vector54:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $54
8010656f:	6a 36                	push   $0x36
  jmp alltraps
80106571:	e9 13 f9 ff ff       	jmp    80105e89 <alltraps>

80106576 <vector55>:
.globl vector55
vector55:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $55
80106578:	6a 37                	push   $0x37
  jmp alltraps
8010657a:	e9 0a f9 ff ff       	jmp    80105e89 <alltraps>

8010657f <vector56>:
.globl vector56
vector56:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $56
80106581:	6a 38                	push   $0x38
  jmp alltraps
80106583:	e9 01 f9 ff ff       	jmp    80105e89 <alltraps>

80106588 <vector57>:
.globl vector57
vector57:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $57
8010658a:	6a 39                	push   $0x39
  jmp alltraps
8010658c:	e9 f8 f8 ff ff       	jmp    80105e89 <alltraps>

80106591 <vector58>:
.globl vector58
vector58:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $58
80106593:	6a 3a                	push   $0x3a
  jmp alltraps
80106595:	e9 ef f8 ff ff       	jmp    80105e89 <alltraps>

8010659a <vector59>:
.globl vector59
vector59:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $59
8010659c:	6a 3b                	push   $0x3b
  jmp alltraps
8010659e:	e9 e6 f8 ff ff       	jmp    80105e89 <alltraps>

801065a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $60
801065a5:	6a 3c                	push   $0x3c
  jmp alltraps
801065a7:	e9 dd f8 ff ff       	jmp    80105e89 <alltraps>

801065ac <vector61>:
.globl vector61
vector61:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $61
801065ae:	6a 3d                	push   $0x3d
  jmp alltraps
801065b0:	e9 d4 f8 ff ff       	jmp    80105e89 <alltraps>

801065b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $62
801065b7:	6a 3e                	push   $0x3e
  jmp alltraps
801065b9:	e9 cb f8 ff ff       	jmp    80105e89 <alltraps>

801065be <vector63>:
.globl vector63
vector63:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $63
801065c0:	6a 3f                	push   $0x3f
  jmp alltraps
801065c2:	e9 c2 f8 ff ff       	jmp    80105e89 <alltraps>

801065c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $64
801065c9:	6a 40                	push   $0x40
  jmp alltraps
801065cb:	e9 b9 f8 ff ff       	jmp    80105e89 <alltraps>

801065d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $65
801065d2:	6a 41                	push   $0x41
  jmp alltraps
801065d4:	e9 b0 f8 ff ff       	jmp    80105e89 <alltraps>

801065d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $66
801065db:	6a 42                	push   $0x42
  jmp alltraps
801065dd:	e9 a7 f8 ff ff       	jmp    80105e89 <alltraps>

801065e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $67
801065e4:	6a 43                	push   $0x43
  jmp alltraps
801065e6:	e9 9e f8 ff ff       	jmp    80105e89 <alltraps>

801065eb <vector68>:
.globl vector68
vector68:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $68
801065ed:	6a 44                	push   $0x44
  jmp alltraps
801065ef:	e9 95 f8 ff ff       	jmp    80105e89 <alltraps>

801065f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $69
801065f6:	6a 45                	push   $0x45
  jmp alltraps
801065f8:	e9 8c f8 ff ff       	jmp    80105e89 <alltraps>

801065fd <vector70>:
.globl vector70
vector70:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $70
801065ff:	6a 46                	push   $0x46
  jmp alltraps
80106601:	e9 83 f8 ff ff       	jmp    80105e89 <alltraps>

80106606 <vector71>:
.globl vector71
vector71:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $71
80106608:	6a 47                	push   $0x47
  jmp alltraps
8010660a:	e9 7a f8 ff ff       	jmp    80105e89 <alltraps>

8010660f <vector72>:
.globl vector72
vector72:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $72
80106611:	6a 48                	push   $0x48
  jmp alltraps
80106613:	e9 71 f8 ff ff       	jmp    80105e89 <alltraps>

80106618 <vector73>:
.globl vector73
vector73:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $73
8010661a:	6a 49                	push   $0x49
  jmp alltraps
8010661c:	e9 68 f8 ff ff       	jmp    80105e89 <alltraps>

80106621 <vector74>:
.globl vector74
vector74:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $74
80106623:	6a 4a                	push   $0x4a
  jmp alltraps
80106625:	e9 5f f8 ff ff       	jmp    80105e89 <alltraps>

8010662a <vector75>:
.globl vector75
vector75:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $75
8010662c:	6a 4b                	push   $0x4b
  jmp alltraps
8010662e:	e9 56 f8 ff ff       	jmp    80105e89 <alltraps>

80106633 <vector76>:
.globl vector76
vector76:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $76
80106635:	6a 4c                	push   $0x4c
  jmp alltraps
80106637:	e9 4d f8 ff ff       	jmp    80105e89 <alltraps>

8010663c <vector77>:
.globl vector77
vector77:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $77
8010663e:	6a 4d                	push   $0x4d
  jmp alltraps
80106640:	e9 44 f8 ff ff       	jmp    80105e89 <alltraps>

80106645 <vector78>:
.globl vector78
vector78:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $78
80106647:	6a 4e                	push   $0x4e
  jmp alltraps
80106649:	e9 3b f8 ff ff       	jmp    80105e89 <alltraps>

8010664e <vector79>:
.globl vector79
vector79:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $79
80106650:	6a 4f                	push   $0x4f
  jmp alltraps
80106652:	e9 32 f8 ff ff       	jmp    80105e89 <alltraps>

80106657 <vector80>:
.globl vector80
vector80:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $80
80106659:	6a 50                	push   $0x50
  jmp alltraps
8010665b:	e9 29 f8 ff ff       	jmp    80105e89 <alltraps>

80106660 <vector81>:
.globl vector81
vector81:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $81
80106662:	6a 51                	push   $0x51
  jmp alltraps
80106664:	e9 20 f8 ff ff       	jmp    80105e89 <alltraps>

80106669 <vector82>:
.globl vector82
vector82:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $82
8010666b:	6a 52                	push   $0x52
  jmp alltraps
8010666d:	e9 17 f8 ff ff       	jmp    80105e89 <alltraps>

80106672 <vector83>:
.globl vector83
vector83:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $83
80106674:	6a 53                	push   $0x53
  jmp alltraps
80106676:	e9 0e f8 ff ff       	jmp    80105e89 <alltraps>

8010667b <vector84>:
.globl vector84
vector84:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $84
8010667d:	6a 54                	push   $0x54
  jmp alltraps
8010667f:	e9 05 f8 ff ff       	jmp    80105e89 <alltraps>

80106684 <vector85>:
.globl vector85
vector85:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $85
80106686:	6a 55                	push   $0x55
  jmp alltraps
80106688:	e9 fc f7 ff ff       	jmp    80105e89 <alltraps>

8010668d <vector86>:
.globl vector86
vector86:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $86
8010668f:	6a 56                	push   $0x56
  jmp alltraps
80106691:	e9 f3 f7 ff ff       	jmp    80105e89 <alltraps>

80106696 <vector87>:
.globl vector87
vector87:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $87
80106698:	6a 57                	push   $0x57
  jmp alltraps
8010669a:	e9 ea f7 ff ff       	jmp    80105e89 <alltraps>

8010669f <vector88>:
.globl vector88
vector88:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $88
801066a1:	6a 58                	push   $0x58
  jmp alltraps
801066a3:	e9 e1 f7 ff ff       	jmp    80105e89 <alltraps>

801066a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $89
801066aa:	6a 59                	push   $0x59
  jmp alltraps
801066ac:	e9 d8 f7 ff ff       	jmp    80105e89 <alltraps>

801066b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $90
801066b3:	6a 5a                	push   $0x5a
  jmp alltraps
801066b5:	e9 cf f7 ff ff       	jmp    80105e89 <alltraps>

801066ba <vector91>:
.globl vector91
vector91:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $91
801066bc:	6a 5b                	push   $0x5b
  jmp alltraps
801066be:	e9 c6 f7 ff ff       	jmp    80105e89 <alltraps>

801066c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $92
801066c5:	6a 5c                	push   $0x5c
  jmp alltraps
801066c7:	e9 bd f7 ff ff       	jmp    80105e89 <alltraps>

801066cc <vector93>:
.globl vector93
vector93:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $93
801066ce:	6a 5d                	push   $0x5d
  jmp alltraps
801066d0:	e9 b4 f7 ff ff       	jmp    80105e89 <alltraps>

801066d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $94
801066d7:	6a 5e                	push   $0x5e
  jmp alltraps
801066d9:	e9 ab f7 ff ff       	jmp    80105e89 <alltraps>

801066de <vector95>:
.globl vector95
vector95:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $95
801066e0:	6a 5f                	push   $0x5f
  jmp alltraps
801066e2:	e9 a2 f7 ff ff       	jmp    80105e89 <alltraps>

801066e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $96
801066e9:	6a 60                	push   $0x60
  jmp alltraps
801066eb:	e9 99 f7 ff ff       	jmp    80105e89 <alltraps>

801066f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $97
801066f2:	6a 61                	push   $0x61
  jmp alltraps
801066f4:	e9 90 f7 ff ff       	jmp    80105e89 <alltraps>

801066f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $98
801066fb:	6a 62                	push   $0x62
  jmp alltraps
801066fd:	e9 87 f7 ff ff       	jmp    80105e89 <alltraps>

80106702 <vector99>:
.globl vector99
vector99:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $99
80106704:	6a 63                	push   $0x63
  jmp alltraps
80106706:	e9 7e f7 ff ff       	jmp    80105e89 <alltraps>

8010670b <vector100>:
.globl vector100
vector100:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $100
8010670d:	6a 64                	push   $0x64
  jmp alltraps
8010670f:	e9 75 f7 ff ff       	jmp    80105e89 <alltraps>

80106714 <vector101>:
.globl vector101
vector101:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $101
80106716:	6a 65                	push   $0x65
  jmp alltraps
80106718:	e9 6c f7 ff ff       	jmp    80105e89 <alltraps>

8010671d <vector102>:
.globl vector102
vector102:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $102
8010671f:	6a 66                	push   $0x66
  jmp alltraps
80106721:	e9 63 f7 ff ff       	jmp    80105e89 <alltraps>

80106726 <vector103>:
.globl vector103
vector103:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $103
80106728:	6a 67                	push   $0x67
  jmp alltraps
8010672a:	e9 5a f7 ff ff       	jmp    80105e89 <alltraps>

8010672f <vector104>:
.globl vector104
vector104:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $104
80106731:	6a 68                	push   $0x68
  jmp alltraps
80106733:	e9 51 f7 ff ff       	jmp    80105e89 <alltraps>

80106738 <vector105>:
.globl vector105
vector105:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $105
8010673a:	6a 69                	push   $0x69
  jmp alltraps
8010673c:	e9 48 f7 ff ff       	jmp    80105e89 <alltraps>

80106741 <vector106>:
.globl vector106
vector106:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $106
80106743:	6a 6a                	push   $0x6a
  jmp alltraps
80106745:	e9 3f f7 ff ff       	jmp    80105e89 <alltraps>

8010674a <vector107>:
.globl vector107
vector107:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $107
8010674c:	6a 6b                	push   $0x6b
  jmp alltraps
8010674e:	e9 36 f7 ff ff       	jmp    80105e89 <alltraps>

80106753 <vector108>:
.globl vector108
vector108:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $108
80106755:	6a 6c                	push   $0x6c
  jmp alltraps
80106757:	e9 2d f7 ff ff       	jmp    80105e89 <alltraps>

8010675c <vector109>:
.globl vector109
vector109:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $109
8010675e:	6a 6d                	push   $0x6d
  jmp alltraps
80106760:	e9 24 f7 ff ff       	jmp    80105e89 <alltraps>

80106765 <vector110>:
.globl vector110
vector110:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $110
80106767:	6a 6e                	push   $0x6e
  jmp alltraps
80106769:	e9 1b f7 ff ff       	jmp    80105e89 <alltraps>

8010676e <vector111>:
.globl vector111
vector111:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $111
80106770:	6a 6f                	push   $0x6f
  jmp alltraps
80106772:	e9 12 f7 ff ff       	jmp    80105e89 <alltraps>

80106777 <vector112>:
.globl vector112
vector112:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $112
80106779:	6a 70                	push   $0x70
  jmp alltraps
8010677b:	e9 09 f7 ff ff       	jmp    80105e89 <alltraps>

80106780 <vector113>:
.globl vector113
vector113:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $113
80106782:	6a 71                	push   $0x71
  jmp alltraps
80106784:	e9 00 f7 ff ff       	jmp    80105e89 <alltraps>

80106789 <vector114>:
.globl vector114
vector114:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $114
8010678b:	6a 72                	push   $0x72
  jmp alltraps
8010678d:	e9 f7 f6 ff ff       	jmp    80105e89 <alltraps>

80106792 <vector115>:
.globl vector115
vector115:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $115
80106794:	6a 73                	push   $0x73
  jmp alltraps
80106796:	e9 ee f6 ff ff       	jmp    80105e89 <alltraps>

8010679b <vector116>:
.globl vector116
vector116:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $116
8010679d:	6a 74                	push   $0x74
  jmp alltraps
8010679f:	e9 e5 f6 ff ff       	jmp    80105e89 <alltraps>

801067a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $117
801067a6:	6a 75                	push   $0x75
  jmp alltraps
801067a8:	e9 dc f6 ff ff       	jmp    80105e89 <alltraps>

801067ad <vector118>:
.globl vector118
vector118:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $118
801067af:	6a 76                	push   $0x76
  jmp alltraps
801067b1:	e9 d3 f6 ff ff       	jmp    80105e89 <alltraps>

801067b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $119
801067b8:	6a 77                	push   $0x77
  jmp alltraps
801067ba:	e9 ca f6 ff ff       	jmp    80105e89 <alltraps>

801067bf <vector120>:
.globl vector120
vector120:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $120
801067c1:	6a 78                	push   $0x78
  jmp alltraps
801067c3:	e9 c1 f6 ff ff       	jmp    80105e89 <alltraps>

801067c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $121
801067ca:	6a 79                	push   $0x79
  jmp alltraps
801067cc:	e9 b8 f6 ff ff       	jmp    80105e89 <alltraps>

801067d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $122
801067d3:	6a 7a                	push   $0x7a
  jmp alltraps
801067d5:	e9 af f6 ff ff       	jmp    80105e89 <alltraps>

801067da <vector123>:
.globl vector123
vector123:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $123
801067dc:	6a 7b                	push   $0x7b
  jmp alltraps
801067de:	e9 a6 f6 ff ff       	jmp    80105e89 <alltraps>

801067e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $124
801067e5:	6a 7c                	push   $0x7c
  jmp alltraps
801067e7:	e9 9d f6 ff ff       	jmp    80105e89 <alltraps>

801067ec <vector125>:
.globl vector125
vector125:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $125
801067ee:	6a 7d                	push   $0x7d
  jmp alltraps
801067f0:	e9 94 f6 ff ff       	jmp    80105e89 <alltraps>

801067f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $126
801067f7:	6a 7e                	push   $0x7e
  jmp alltraps
801067f9:	e9 8b f6 ff ff       	jmp    80105e89 <alltraps>

801067fe <vector127>:
.globl vector127
vector127:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $127
80106800:	6a 7f                	push   $0x7f
  jmp alltraps
80106802:	e9 82 f6 ff ff       	jmp    80105e89 <alltraps>

80106807 <vector128>:
.globl vector128
vector128:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $128
80106809:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010680e:	e9 76 f6 ff ff       	jmp    80105e89 <alltraps>

80106813 <vector129>:
.globl vector129
vector129:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $129
80106815:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010681a:	e9 6a f6 ff ff       	jmp    80105e89 <alltraps>

8010681f <vector130>:
.globl vector130
vector130:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $130
80106821:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106826:	e9 5e f6 ff ff       	jmp    80105e89 <alltraps>

8010682b <vector131>:
.globl vector131
vector131:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $131
8010682d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106832:	e9 52 f6 ff ff       	jmp    80105e89 <alltraps>

80106837 <vector132>:
.globl vector132
vector132:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $132
80106839:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010683e:	e9 46 f6 ff ff       	jmp    80105e89 <alltraps>

80106843 <vector133>:
.globl vector133
vector133:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $133
80106845:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010684a:	e9 3a f6 ff ff       	jmp    80105e89 <alltraps>

8010684f <vector134>:
.globl vector134
vector134:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $134
80106851:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106856:	e9 2e f6 ff ff       	jmp    80105e89 <alltraps>

8010685b <vector135>:
.globl vector135
vector135:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $135
8010685d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106862:	e9 22 f6 ff ff       	jmp    80105e89 <alltraps>

80106867 <vector136>:
.globl vector136
vector136:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $136
80106869:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010686e:	e9 16 f6 ff ff       	jmp    80105e89 <alltraps>

80106873 <vector137>:
.globl vector137
vector137:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $137
80106875:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010687a:	e9 0a f6 ff ff       	jmp    80105e89 <alltraps>

8010687f <vector138>:
.globl vector138
vector138:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $138
80106881:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106886:	e9 fe f5 ff ff       	jmp    80105e89 <alltraps>

8010688b <vector139>:
.globl vector139
vector139:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $139
8010688d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106892:	e9 f2 f5 ff ff       	jmp    80105e89 <alltraps>

80106897 <vector140>:
.globl vector140
vector140:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $140
80106899:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010689e:	e9 e6 f5 ff ff       	jmp    80105e89 <alltraps>

801068a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $141
801068a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068aa:	e9 da f5 ff ff       	jmp    80105e89 <alltraps>

801068af <vector142>:
.globl vector142
vector142:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $142
801068b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068b6:	e9 ce f5 ff ff       	jmp    80105e89 <alltraps>

801068bb <vector143>:
.globl vector143
vector143:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $143
801068bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068c2:	e9 c2 f5 ff ff       	jmp    80105e89 <alltraps>

801068c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $144
801068c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068ce:	e9 b6 f5 ff ff       	jmp    80105e89 <alltraps>

801068d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $145
801068d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068da:	e9 aa f5 ff ff       	jmp    80105e89 <alltraps>

801068df <vector146>:
.globl vector146
vector146:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $146
801068e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068e6:	e9 9e f5 ff ff       	jmp    80105e89 <alltraps>

801068eb <vector147>:
.globl vector147
vector147:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $147
801068ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068f2:	e9 92 f5 ff ff       	jmp    80105e89 <alltraps>

801068f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $148
801068f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068fe:	e9 86 f5 ff ff       	jmp    80105e89 <alltraps>

80106903 <vector149>:
.globl vector149
vector149:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $149
80106905:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010690a:	e9 7a f5 ff ff       	jmp    80105e89 <alltraps>

8010690f <vector150>:
.globl vector150
vector150:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $150
80106911:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106916:	e9 6e f5 ff ff       	jmp    80105e89 <alltraps>

8010691b <vector151>:
.globl vector151
vector151:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $151
8010691d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106922:	e9 62 f5 ff ff       	jmp    80105e89 <alltraps>

80106927 <vector152>:
.globl vector152
vector152:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $152
80106929:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010692e:	e9 56 f5 ff ff       	jmp    80105e89 <alltraps>

80106933 <vector153>:
.globl vector153
vector153:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $153
80106935:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010693a:	e9 4a f5 ff ff       	jmp    80105e89 <alltraps>

8010693f <vector154>:
.globl vector154
vector154:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $154
80106941:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106946:	e9 3e f5 ff ff       	jmp    80105e89 <alltraps>

8010694b <vector155>:
.globl vector155
vector155:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $155
8010694d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106952:	e9 32 f5 ff ff       	jmp    80105e89 <alltraps>

80106957 <vector156>:
.globl vector156
vector156:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $156
80106959:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010695e:	e9 26 f5 ff ff       	jmp    80105e89 <alltraps>

80106963 <vector157>:
.globl vector157
vector157:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $157
80106965:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010696a:	e9 1a f5 ff ff       	jmp    80105e89 <alltraps>

8010696f <vector158>:
.globl vector158
vector158:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $158
80106971:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106976:	e9 0e f5 ff ff       	jmp    80105e89 <alltraps>

8010697b <vector159>:
.globl vector159
vector159:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $159
8010697d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106982:	e9 02 f5 ff ff       	jmp    80105e89 <alltraps>

80106987 <vector160>:
.globl vector160
vector160:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $160
80106989:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010698e:	e9 f6 f4 ff ff       	jmp    80105e89 <alltraps>

80106993 <vector161>:
.globl vector161
vector161:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $161
80106995:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010699a:	e9 ea f4 ff ff       	jmp    80105e89 <alltraps>

8010699f <vector162>:
.globl vector162
vector162:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $162
801069a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069a6:	e9 de f4 ff ff       	jmp    80105e89 <alltraps>

801069ab <vector163>:
.globl vector163
vector163:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $163
801069ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069b2:	e9 d2 f4 ff ff       	jmp    80105e89 <alltraps>

801069b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $164
801069b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069be:	e9 c6 f4 ff ff       	jmp    80105e89 <alltraps>

801069c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $165
801069c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069ca:	e9 ba f4 ff ff       	jmp    80105e89 <alltraps>

801069cf <vector166>:
.globl vector166
vector166:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $166
801069d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069d6:	e9 ae f4 ff ff       	jmp    80105e89 <alltraps>

801069db <vector167>:
.globl vector167
vector167:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $167
801069dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069e2:	e9 a2 f4 ff ff       	jmp    80105e89 <alltraps>

801069e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $168
801069e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069ee:	e9 96 f4 ff ff       	jmp    80105e89 <alltraps>

801069f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $169
801069f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069fa:	e9 8a f4 ff ff       	jmp    80105e89 <alltraps>

801069ff <vector170>:
.globl vector170
vector170:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $170
80106a01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a06:	e9 7e f4 ff ff       	jmp    80105e89 <alltraps>

80106a0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $171
80106a0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a12:	e9 72 f4 ff ff       	jmp    80105e89 <alltraps>

80106a17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $172
80106a19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a1e:	e9 66 f4 ff ff       	jmp    80105e89 <alltraps>

80106a23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $173
80106a25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a2a:	e9 5a f4 ff ff       	jmp    80105e89 <alltraps>

80106a2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $174
80106a31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a36:	e9 4e f4 ff ff       	jmp    80105e89 <alltraps>

80106a3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $175
80106a3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a42:	e9 42 f4 ff ff       	jmp    80105e89 <alltraps>

80106a47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $176
80106a49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a4e:	e9 36 f4 ff ff       	jmp    80105e89 <alltraps>

80106a53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $177
80106a55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a5a:	e9 2a f4 ff ff       	jmp    80105e89 <alltraps>

80106a5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $178
80106a61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a66:	e9 1e f4 ff ff       	jmp    80105e89 <alltraps>

80106a6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $179
80106a6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a72:	e9 12 f4 ff ff       	jmp    80105e89 <alltraps>

80106a77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $180
80106a79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a7e:	e9 06 f4 ff ff       	jmp    80105e89 <alltraps>

80106a83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $181
80106a85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a8a:	e9 fa f3 ff ff       	jmp    80105e89 <alltraps>

80106a8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $182
80106a91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a96:	e9 ee f3 ff ff       	jmp    80105e89 <alltraps>

80106a9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $183
80106a9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106aa2:	e9 e2 f3 ff ff       	jmp    80105e89 <alltraps>

80106aa7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $184
80106aa9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106aae:	e9 d6 f3 ff ff       	jmp    80105e89 <alltraps>

80106ab3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $185
80106ab5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aba:	e9 ca f3 ff ff       	jmp    80105e89 <alltraps>

80106abf <vector186>:
.globl vector186
vector186:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $186
80106ac1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ac6:	e9 be f3 ff ff       	jmp    80105e89 <alltraps>

80106acb <vector187>:
.globl vector187
vector187:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $187
80106acd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ad2:	e9 b2 f3 ff ff       	jmp    80105e89 <alltraps>

80106ad7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $188
80106ad9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ade:	e9 a6 f3 ff ff       	jmp    80105e89 <alltraps>

80106ae3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $189
80106ae5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106aea:	e9 9a f3 ff ff       	jmp    80105e89 <alltraps>

80106aef <vector190>:
.globl vector190
vector190:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $190
80106af1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106af6:	e9 8e f3 ff ff       	jmp    80105e89 <alltraps>

80106afb <vector191>:
.globl vector191
vector191:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $191
80106afd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b02:	e9 82 f3 ff ff       	jmp    80105e89 <alltraps>

80106b07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $192
80106b09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b0e:	e9 76 f3 ff ff       	jmp    80105e89 <alltraps>

80106b13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $193
80106b15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b1a:	e9 6a f3 ff ff       	jmp    80105e89 <alltraps>

80106b1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $194
80106b21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b26:	e9 5e f3 ff ff       	jmp    80105e89 <alltraps>

80106b2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $195
80106b2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b32:	e9 52 f3 ff ff       	jmp    80105e89 <alltraps>

80106b37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $196
80106b39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b3e:	e9 46 f3 ff ff       	jmp    80105e89 <alltraps>

80106b43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $197
80106b45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b4a:	e9 3a f3 ff ff       	jmp    80105e89 <alltraps>

80106b4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $198
80106b51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b56:	e9 2e f3 ff ff       	jmp    80105e89 <alltraps>

80106b5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $199
80106b5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b62:	e9 22 f3 ff ff       	jmp    80105e89 <alltraps>

80106b67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $200
80106b69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b6e:	e9 16 f3 ff ff       	jmp    80105e89 <alltraps>

80106b73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $201
80106b75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b7a:	e9 0a f3 ff ff       	jmp    80105e89 <alltraps>

80106b7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $202
80106b81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b86:	e9 fe f2 ff ff       	jmp    80105e89 <alltraps>

80106b8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $203
80106b8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b92:	e9 f2 f2 ff ff       	jmp    80105e89 <alltraps>

80106b97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $204
80106b99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b9e:	e9 e6 f2 ff ff       	jmp    80105e89 <alltraps>

80106ba3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $205
80106ba5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106baa:	e9 da f2 ff ff       	jmp    80105e89 <alltraps>

80106baf <vector206>:
.globl vector206
vector206:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $206
80106bb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bb6:	e9 ce f2 ff ff       	jmp    80105e89 <alltraps>

80106bbb <vector207>:
.globl vector207
vector207:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $207
80106bbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bc2:	e9 c2 f2 ff ff       	jmp    80105e89 <alltraps>

80106bc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $208
80106bc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bce:	e9 b6 f2 ff ff       	jmp    80105e89 <alltraps>

80106bd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $209
80106bd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bda:	e9 aa f2 ff ff       	jmp    80105e89 <alltraps>

80106bdf <vector210>:
.globl vector210
vector210:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $210
80106be1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106be6:	e9 9e f2 ff ff       	jmp    80105e89 <alltraps>

80106beb <vector211>:
.globl vector211
vector211:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $211
80106bed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106bf2:	e9 92 f2 ff ff       	jmp    80105e89 <alltraps>

80106bf7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $212
80106bf9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bfe:	e9 86 f2 ff ff       	jmp    80105e89 <alltraps>

80106c03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $213
80106c05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c0a:	e9 7a f2 ff ff       	jmp    80105e89 <alltraps>

80106c0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $214
80106c11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c16:	e9 6e f2 ff ff       	jmp    80105e89 <alltraps>

80106c1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $215
80106c1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c22:	e9 62 f2 ff ff       	jmp    80105e89 <alltraps>

80106c27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $216
80106c29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c2e:	e9 56 f2 ff ff       	jmp    80105e89 <alltraps>

80106c33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $217
80106c35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c3a:	e9 4a f2 ff ff       	jmp    80105e89 <alltraps>

80106c3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $218
80106c41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c46:	e9 3e f2 ff ff       	jmp    80105e89 <alltraps>

80106c4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $219
80106c4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c52:	e9 32 f2 ff ff       	jmp    80105e89 <alltraps>

80106c57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $220
80106c59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c5e:	e9 26 f2 ff ff       	jmp    80105e89 <alltraps>

80106c63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $221
80106c65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c6a:	e9 1a f2 ff ff       	jmp    80105e89 <alltraps>

80106c6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $222
80106c71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c76:	e9 0e f2 ff ff       	jmp    80105e89 <alltraps>

80106c7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $223
80106c7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c82:	e9 02 f2 ff ff       	jmp    80105e89 <alltraps>

80106c87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $224
80106c89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c8e:	e9 f6 f1 ff ff       	jmp    80105e89 <alltraps>

80106c93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $225
80106c95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c9a:	e9 ea f1 ff ff       	jmp    80105e89 <alltraps>

80106c9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $226
80106ca1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ca6:	e9 de f1 ff ff       	jmp    80105e89 <alltraps>

80106cab <vector227>:
.globl vector227
vector227:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $227
80106cad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cb2:	e9 d2 f1 ff ff       	jmp    80105e89 <alltraps>

80106cb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $228
80106cb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cbe:	e9 c6 f1 ff ff       	jmp    80105e89 <alltraps>

80106cc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $229
80106cc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cca:	e9 ba f1 ff ff       	jmp    80105e89 <alltraps>

80106ccf <vector230>:
.globl vector230
vector230:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $230
80106cd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cd6:	e9 ae f1 ff ff       	jmp    80105e89 <alltraps>

80106cdb <vector231>:
.globl vector231
vector231:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $231
80106cdd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ce2:	e9 a2 f1 ff ff       	jmp    80105e89 <alltraps>

80106ce7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $232
80106ce9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cee:	e9 96 f1 ff ff       	jmp    80105e89 <alltraps>

80106cf3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $233
80106cf5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cfa:	e9 8a f1 ff ff       	jmp    80105e89 <alltraps>

80106cff <vector234>:
.globl vector234
vector234:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $234
80106d01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d06:	e9 7e f1 ff ff       	jmp    80105e89 <alltraps>

80106d0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $235
80106d0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d12:	e9 72 f1 ff ff       	jmp    80105e89 <alltraps>

80106d17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $236
80106d19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d1e:	e9 66 f1 ff ff       	jmp    80105e89 <alltraps>

80106d23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $237
80106d25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d2a:	e9 5a f1 ff ff       	jmp    80105e89 <alltraps>

80106d2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $238
80106d31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d36:	e9 4e f1 ff ff       	jmp    80105e89 <alltraps>

80106d3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $239
80106d3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d42:	e9 42 f1 ff ff       	jmp    80105e89 <alltraps>

80106d47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $240
80106d49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d4e:	e9 36 f1 ff ff       	jmp    80105e89 <alltraps>

80106d53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $241
80106d55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d5a:	e9 2a f1 ff ff       	jmp    80105e89 <alltraps>

80106d5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $242
80106d61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d66:	e9 1e f1 ff ff       	jmp    80105e89 <alltraps>

80106d6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $243
80106d6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d72:	e9 12 f1 ff ff       	jmp    80105e89 <alltraps>

80106d77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $244
80106d79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d7e:	e9 06 f1 ff ff       	jmp    80105e89 <alltraps>

80106d83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $245
80106d85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d8a:	e9 fa f0 ff ff       	jmp    80105e89 <alltraps>

80106d8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $246
80106d91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d96:	e9 ee f0 ff ff       	jmp    80105e89 <alltraps>

80106d9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $247
80106d9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106da2:	e9 e2 f0 ff ff       	jmp    80105e89 <alltraps>

80106da7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $248
80106da9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dae:	e9 d6 f0 ff ff       	jmp    80105e89 <alltraps>

80106db3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $249
80106db5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dba:	e9 ca f0 ff ff       	jmp    80105e89 <alltraps>

80106dbf <vector250>:
.globl vector250
vector250:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $250
80106dc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106dc6:	e9 be f0 ff ff       	jmp    80105e89 <alltraps>

80106dcb <vector251>:
.globl vector251
vector251:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $251
80106dcd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106dd2:	e9 b2 f0 ff ff       	jmp    80105e89 <alltraps>

80106dd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $252
80106dd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dde:	e9 a6 f0 ff ff       	jmp    80105e89 <alltraps>

80106de3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $253
80106de5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dea:	e9 9a f0 ff ff       	jmp    80105e89 <alltraps>

80106def <vector254>:
.globl vector254
vector254:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $254
80106df1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106df6:	e9 8e f0 ff ff       	jmp    80105e89 <alltraps>

80106dfb <vector255>:
.globl vector255
vector255:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $255
80106dfd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e02:	e9 82 f0 ff ff       	jmp    80105e89 <alltraps>
80106e07:	66 90                	xchg   %ax,%ax
80106e09:	66 90                	xchg   %ax,%ax
80106e0b:	66 90                	xchg   %ax,%ax
80106e0d:	66 90                	xchg   %ax,%ax
80106e0f:	90                   	nop

80106e10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e16:	89 d3                	mov    %edx,%ebx
{
80106e18:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e1a:	c1 eb 16             	shr    $0x16,%ebx
80106e1d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e20:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e23:	8b 06                	mov    (%esi),%eax
80106e25:	a8 01                	test   $0x1,%al
80106e27:	74 27                	je     80106e50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e2e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e34:	c1 ef 0a             	shr    $0xa,%edi
}
80106e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e3a:	89 fa                	mov    %edi,%edx
80106e3c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e42:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e45:	5b                   	pop    %ebx
80106e46:	5e                   	pop    %esi
80106e47:	5f                   	pop    %edi
80106e48:	5d                   	pop    %ebp
80106e49:	c3                   	ret    
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e50:	85 c9                	test   %ecx,%ecx
80106e52:	74 2c                	je     80106e80 <walkpgdir+0x70>
80106e54:	e8 c7 bb ff ff       	call   80102a20 <kalloc>
80106e59:	85 c0                	test   %eax,%eax
80106e5b:	89 c3                	mov    %eax,%ebx
80106e5d:	74 21                	je     80106e80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e5f:	83 ec 04             	sub    $0x4,%esp
80106e62:	68 00 10 00 00       	push   $0x1000
80106e67:	6a 00                	push   $0x0
80106e69:	50                   	push   %eax
80106e6a:	e8 f1 dd ff ff       	call   80104c60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e75:	83 c4 10             	add    $0x10,%esp
80106e78:	83 c8 07             	or     $0x7,%eax
80106e7b:	89 06                	mov    %eax,(%esi)
80106e7d:	eb b5                	jmp    80106e34 <walkpgdir+0x24>
80106e7f:	90                   	nop
}
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e96:	89 d3                	mov    %edx,%ebx
80106e98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e9e:	83 ec 1c             	sub    $0x1c,%esp
80106ea1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ea4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ea8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eb6:	29 df                	sub    %ebx,%edi
80106eb8:	83 c8 01             	or     $0x1,%eax
80106ebb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ebe:	eb 15                	jmp    80106ed5 <mappages+0x45>
    if(*pte & PTE_P)
80106ec0:	f6 00 01             	testb  $0x1,(%eax)
80106ec3:	75 45                	jne    80106f0a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ec5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ec8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106ecb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ecd:	74 31                	je     80106f00 <mappages+0x70>
      break;
    a += PGSIZE;
80106ecf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ed5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106edd:	89 da                	mov    %ebx,%edx
80106edf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ee2:	e8 29 ff ff ff       	call   80106e10 <walkpgdir>
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	75 d5                	jne    80106ec0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ef3:	5b                   	pop    %ebx
80106ef4:	5e                   	pop    %esi
80106ef5:	5f                   	pop    %edi
80106ef6:	5d                   	pop    %ebp
80106ef7:	c3                   	ret    
80106ef8:	90                   	nop
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f03:	31 c0                	xor    %eax,%eax
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
      panic("remap");
80106f0a:	83 ec 0c             	sub    $0xc,%esp
80106f0d:	68 4c 8b 10 80       	push   $0x80108b4c
80106f12:	e8 79 94 ff ff       	call   80100390 <panic>
80106f17:	89 f6                	mov    %esi,%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <seginit>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f26:	e8 75 ce ff ff       	call   80103da0 <cpuid>
80106f2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f3a:	c7 80 18 d8 14 80 ff 	movl   $0xffff,-0x7feb27e8(%eax)
80106f41:	ff 00 00 
80106f44:	c7 80 1c d8 14 80 00 	movl   $0xcf9a00,-0x7feb27e4(%eax)
80106f4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f4e:	c7 80 20 d8 14 80 ff 	movl   $0xffff,-0x7feb27e0(%eax)
80106f55:	ff 00 00 
80106f58:	c7 80 24 d8 14 80 00 	movl   $0xcf9200,-0x7feb27dc(%eax)
80106f5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f62:	c7 80 28 d8 14 80 ff 	movl   $0xffff,-0x7feb27d8(%eax)
80106f69:	ff 00 00 
80106f6c:	c7 80 2c d8 14 80 00 	movl   $0xcffa00,-0x7feb27d4(%eax)
80106f73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f76:	c7 80 30 d8 14 80 ff 	movl   $0xffff,-0x7feb27d0(%eax)
80106f7d:	ff 00 00 
80106f80:	c7 80 34 d8 14 80 00 	movl   $0xcff200,-0x7feb27cc(%eax)
80106f87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f8a:	05 10 d8 14 80       	add    $0x8014d810,%eax
  pd[1] = (uint)p;
80106f8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f93:	c1 e8 10             	shr    $0x10,%eax
80106f96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f9d:	0f 01 10             	lgdtl  (%eax)
}
80106fa0:	c9                   	leave  
80106fa1:	c3                   	ret    
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb0:	a1 c4 a8 15 80       	mov    0x8015a8c4,%eax
{
80106fb5:	55                   	push   %ebp
80106fb6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fbd:	0f 22 d8             	mov    %eax,%cr3
}
80106fc0:	5d                   	pop    %ebp
80106fc1:	c3                   	ret    
80106fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fd0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106fdc:	85 db                	test   %ebx,%ebx
80106fde:	0f 84 cb 00 00 00    	je     801070af <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106fe4:	8b 43 08             	mov    0x8(%ebx),%eax
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	0f 84 da 00 00 00    	je     801070c9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106fef:	8b 43 04             	mov    0x4(%ebx),%eax
80106ff2:	85 c0                	test   %eax,%eax
80106ff4:	0f 84 c2 00 00 00    	je     801070bc <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106ffa:	e8 81 da ff ff       	call   80104a80 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fff:	e8 1c cd ff ff       	call   80103d20 <mycpu>
80107004:	89 c6                	mov    %eax,%esi
80107006:	e8 15 cd ff ff       	call   80103d20 <mycpu>
8010700b:	89 c7                	mov    %eax,%edi
8010700d:	e8 0e cd ff ff       	call   80103d20 <mycpu>
80107012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107015:	83 c7 08             	add    $0x8,%edi
80107018:	e8 03 cd ff ff       	call   80103d20 <mycpu>
8010701d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107020:	83 c0 08             	add    $0x8,%eax
80107023:	ba 67 00 00 00       	mov    $0x67,%edx
80107028:	c1 e8 18             	shr    $0x18,%eax
8010702b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107032:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107039:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010703f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107044:	83 c1 08             	add    $0x8,%ecx
80107047:	c1 e9 10             	shr    $0x10,%ecx
8010704a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107050:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107055:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010705c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107061:	e8 ba cc ff ff       	call   80103d20 <mycpu>
80107066:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010706d:	e8 ae cc ff ff       	call   80103d20 <mycpu>
80107072:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107076:	8b 73 08             	mov    0x8(%ebx),%esi
80107079:	e8 a2 cc ff ff       	call   80103d20 <mycpu>
8010707e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107084:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107087:	e8 94 cc ff ff       	call   80103d20 <mycpu>
8010708c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107090:	b8 28 00 00 00       	mov    $0x28,%eax
80107095:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107098:	8b 43 04             	mov    0x4(%ebx),%eax
8010709b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070a0:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801070a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a6:	5b                   	pop    %ebx
801070a7:	5e                   	pop    %esi
801070a8:	5f                   	pop    %edi
801070a9:	5d                   	pop    %ebp
  popcli();
801070aa:	e9 11 da ff ff       	jmp    80104ac0 <popcli>
    panic("switchuvm: no process");
801070af:	83 ec 0c             	sub    $0xc,%esp
801070b2:	68 52 8b 10 80       	push   $0x80108b52
801070b7:	e8 d4 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	68 7d 8b 10 80       	push   $0x80108b7d
801070c4:	e8 c7 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801070c9:	83 ec 0c             	sub    $0xc,%esp
801070cc:	68 68 8b 10 80       	push   $0x80108b68
801070d1:	e8 ba 92 ff ff       	call   80100390 <panic>
801070d6:	8d 76 00             	lea    0x0(%esi),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 10             	mov    0x10(%ebp),%esi
801070ec:	8b 45 08             	mov    0x8(%ebp),%eax
801070ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801070f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801070f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070fb:	77 49                	ja     80107146 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801070fd:	e8 1e b9 ff ff       	call   80102a20 <kalloc>
  memset(mem, 0, PGSIZE);
80107102:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107105:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107107:	68 00 10 00 00       	push   $0x1000
8010710c:	6a 00                	push   $0x0
8010710e:	50                   	push   %eax
8010710f:	e8 4c db ff ff       	call   80104c60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107114:	58                   	pop    %eax
80107115:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010711b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107120:	5a                   	pop    %edx
80107121:	6a 06                	push   $0x6
80107123:	50                   	push   %eax
80107124:	31 d2                	xor    %edx,%edx
80107126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107129:	e8 62 fd ff ff       	call   80106e90 <mappages>
  memmove(mem, init, sz);
8010712e:	89 75 10             	mov    %esi,0x10(%ebp)
80107131:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107134:	83 c4 10             	add    $0x10,%esp
80107137:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010713a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010713d:	5b                   	pop    %ebx
8010713e:	5e                   	pop    %esi
8010713f:	5f                   	pop    %edi
80107140:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107141:	e9 ca db ff ff       	jmp    80104d10 <memmove>
    panic("inituvm: more than a page");
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	68 91 8b 10 80       	push   $0x80108b91
8010714e:	e8 3d 92 ff ff       	call   80100390 <panic>
80107153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107169:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107170:	0f 85 91 00 00 00    	jne    80107207 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107176:	8b 75 18             	mov    0x18(%ebp),%esi
80107179:	31 db                	xor    %ebx,%ebx
8010717b:	85 f6                	test   %esi,%esi
8010717d:	75 1a                	jne    80107199 <loaduvm+0x39>
8010717f:	eb 6f                	jmp    801071f0 <loaduvm+0x90>
80107181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107188:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107194:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107197:	76 57                	jbe    801071f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107199:	8b 55 0c             	mov    0xc(%ebp),%edx
8010719c:	8b 45 08             	mov    0x8(%ebp),%eax
8010719f:	31 c9                	xor    %ecx,%ecx
801071a1:	01 da                	add    %ebx,%edx
801071a3:	e8 68 fc ff ff       	call   80106e10 <walkpgdir>
801071a8:	85 c0                	test   %eax,%eax
801071aa:	74 4e                	je     801071fa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801071ac:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801071b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071c4:	01 d9                	add    %ebx,%ecx
801071c6:	05 00 00 00 80       	add    $0x80000000,%eax
801071cb:	57                   	push   %edi
801071cc:	51                   	push   %ecx
801071cd:	50                   	push   %eax
801071ce:	ff 75 10             	pushl  0x10(%ebp)
801071d1:	e8 ca a7 ff ff       	call   801019a0 <readi>
801071d6:	83 c4 10             	add    $0x10,%esp
801071d9:	39 f8                	cmp    %edi,%eax
801071db:	74 ab                	je     80107188 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071f3:	31 c0                	xor    %eax,%eax
}
801071f5:	5b                   	pop    %ebx
801071f6:	5e                   	pop    %esi
801071f7:	5f                   	pop    %edi
801071f8:	5d                   	pop    %ebp
801071f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801071fa:	83 ec 0c             	sub    $0xc,%esp
801071fd:	68 ab 8b 10 80       	push   $0x80108bab
80107202:	e8 89 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107207:	83 ec 0c             	sub    $0xc,%esp
8010720a:	68 c4 8c 10 80       	push   $0x80108cc4
8010720f:	e8 7c 91 ff ff       	call   80100390 <panic>
80107214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010721a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107220 <find_pa>:

// find physical address by virtual address
int
find_pa(pde_t *pgdir, int va)
{
80107220:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107221:	31 c9                	xor    %ecx,%ecx
{
80107223:	89 e5                	mov    %esp,%ebp
80107225:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010722b:	8b 45 08             	mov    0x8(%ebp),%eax
8010722e:	e8 dd fb ff ff       	call   80106e10 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
80107233:	85 c0                	test   %eax,%eax
80107235:	74 09                	je     80107240 <find_pa+0x20>
80107237:	8b 00                	mov    (%eax),%eax
}
80107239:	c9                   	leave  
  return !pte ? -1 : PTE_ADDR(*pte);
8010723a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
8010723f:	c3                   	ret    
  return !pte ? -1 : PTE_ADDR(*pte);
80107240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107245:	c9                   	leave  
80107246:	c3                   	ret    
80107247:	89 f6                	mov    %esi,%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <check_policy>:

int
check_policy()
{
80107250:	55                   	push   %ebp
  #if NONE
		return 0;
	#endif
	return 1;
}
80107251:	b8 01 00 00 00       	mov    $0x1,%eax
{
80107256:	89 e5                	mov    %esp,%ebp
}
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107260 <NFUA_next>:

int
NFUA_next(struct proc *p)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	53                   	push   %ebx
80107264:	83 ec 10             	sub    $0x10,%esp
80107267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("NFUA_next\n");
8010726a:	68 c9 8b 10 80       	push   $0x80108bc9
8010726f:	e8 ec 93 ff ff       	call   80100660 <cprintf>
  p->r_robin++;
80107274:	8b 83 08 03 00 00    	mov    0x308(%ebx),%eax
8010727a:	83 c0 01             	add    $0x1,%eax
8010727d:	89 83 08 03 00 00    	mov    %eax,0x308(%ebx)
  return p->r_robin%MAX_PSYC_PAGES;
80107283:	83 e0 0f             	and    $0xf,%eax
}
80107286:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107289:	c9                   	leave  
8010728a:	c3                   	ret    
8010728b:	90                   	nop
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <LAPA_next>:

int
LAPA_next(struct proc *p)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	53                   	push   %ebx
80107294:	83 ec 10             	sub    $0x10,%esp
80107297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("LAPA_next\n");
8010729a:	68 d4 8b 10 80       	push   $0x80108bd4
8010729f:	e8 bc 93 ff ff       	call   80100660 <cprintf>
  p->r_robin++;
801072a4:	8b 83 08 03 00 00    	mov    0x308(%ebx),%eax
801072aa:	83 c0 01             	add    $0x1,%eax
801072ad:	89 83 08 03 00 00    	mov    %eax,0x308(%ebx)
  return p->r_robin%MAX_PSYC_PAGES;
801072b3:	83 e0 0f             	and    $0xf,%eax
}
801072b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801072b9:	c9                   	leave  
801072ba:	c3                   	ret    
801072bb:	90                   	nop
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072c0 <SCFIFO_next>:

int
SCFIFO_next(struct proc *p)
{
801072c0:	55                   	push   %ebp
  int i, next_i = -1;
  pte_t *pte;
  uint min_timestap = 4294967295;

  // find oldest
  for (i = 0; i < MAX_PSYC_PAGES ; i++) {
801072c1:	31 d2                	xor    %edx,%edx
{
801072c3:	89 e5                	mov    %esp,%ebp
801072c5:	57                   	push   %edi
801072c6:	56                   	push   %esi
801072c7:	53                   	push   %ebx
  uint min_timestap = 4294967295;
801072c8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  int i, next_i = -1;
801072cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
{
801072d2:	83 ec 0c             	sub    $0xc,%esp
801072d5:	8b 75 08             	mov    0x8(%ebp),%esi
801072d8:	8d 86 cc 01 00 00    	lea    0x1cc(%esi),%eax
801072de:	66 90                	xchg   %ax,%ax
    if (p->memory_pages[i].is_used && p->memory_pages[i].time_loaded <= min_timestap) {
801072e0:	8b 08                	mov    (%eax),%ecx
801072e2:	85 c9                	test   %ecx,%ecx
801072e4:	74 0b                	je     801072f1 <SCFIFO_next+0x31>
801072e6:	8b 48 04             	mov    0x4(%eax),%ecx
801072e9:	39 f9                	cmp    %edi,%ecx
801072eb:	77 04                	ja     801072f1 <SCFIFO_next+0x31>
801072ed:	89 cf                	mov    %ecx,%edi
801072ef:	89 d3                	mov    %edx,%ebx
  for (i = 0; i < MAX_PSYC_PAGES ; i++) {
801072f1:	83 c2 01             	add    $0x1,%edx
801072f4:	83 c0 14             	add    $0x14,%eax
801072f7:	83 fa 10             	cmp    $0x10,%edx
801072fa:	75 e4                	jne    801072e0 <SCFIFO_next+0x20>
      next_i = i;
      min_timestap = p->memory_pages[i].time_loaded;
    }
  }

  if (next_i == -1)
801072fc:	83 fb ff             	cmp    $0xffffffff,%ebx
801072ff:	74 5c                	je     8010735d <SCFIFO_next+0x9d>
    panic("SCFIFO: next i == -1\n");

  if ((pte = walkpgdir(p->memory_pages[next_i].pgdir, (char*)p->memory_pages[next_i].va, 0)) == 0)
80107301:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80107304:	31 c9                	xor    %ecx,%ecx
80107306:	8d 3c 86             	lea    (%esi,%eax,4),%edi
80107309:	8b 97 c4 01 00 00    	mov    0x1c4(%edi),%edx
8010730f:	8b 87 c0 01 00 00    	mov    0x1c0(%edi),%eax
80107315:	e8 f6 fa ff ff       	call   80106e10 <walkpgdir>
8010731a:	85 c0                	test   %eax,%eax
8010731c:	74 32                	je     80107350 <SCFIFO_next+0x90>
    panic("SCFIFO: walkpgdir failed\n");
    
  if (*pte & PTE_A) { // will get 2nd chance
8010731e:	8b 10                	mov    (%eax),%edx
80107320:	f6 c2 20             	test   $0x20,%dl
80107323:	75 0a                	jne    8010732f <SCFIFO_next+0x6f>
    *pte &= ~PTE_A;
    p->memory_pages[next_i].time_loaded = p->timestamp++;
    next_i = -1;
  }
  return next_i;
}
80107325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107328:	89 d8                	mov    %ebx,%eax
8010732a:	5b                   	pop    %ebx
8010732b:	5e                   	pop    %esi
8010732c:	5f                   	pop    %edi
8010732d:	5d                   	pop    %ebp
8010732e:	c3                   	ret    
    *pte &= ~PTE_A;
8010732f:	83 e2 df             	and    $0xffffffdf,%edx
    next_i = -1;
80107332:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    *pte &= ~PTE_A;
80107337:	89 10                	mov    %edx,(%eax)
    p->memory_pages[next_i].time_loaded = p->timestamp++;
80107339:	8b 86 04 03 00 00    	mov    0x304(%esi),%eax
8010733f:	8d 50 01             	lea    0x1(%eax),%edx
80107342:	89 96 04 03 00 00    	mov    %edx,0x304(%esi)
80107348:	89 87 d0 01 00 00    	mov    %eax,0x1d0(%edi)
  return next_i;
8010734e:	eb d5                	jmp    80107325 <SCFIFO_next+0x65>
    panic("SCFIFO: walkpgdir failed\n");
80107350:	83 ec 0c             	sub    $0xc,%esp
80107353:	68 f5 8b 10 80       	push   $0x80108bf5
80107358:	e8 33 90 ff ff       	call   80100390 <panic>
    panic("SCFIFO: next i == -1\n");
8010735d:	83 ec 0c             	sub    $0xc,%esp
80107360:	68 df 8b 10 80       	push   $0x80108bdf
80107365:	e8 26 90 ff ff       	call   80100390 <panic>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107370 <AQ_next>:

int
AQ_next(struct proc *p)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	8b 55 08             	mov    0x8(%ebp),%edx
  p->r_robin++;
80107376:	8b 82 08 03 00 00    	mov    0x308(%edx),%eax
8010737c:	83 c0 01             	add    $0x1,%eax
8010737f:	89 82 08 03 00 00    	mov    %eax,0x308(%edx)
  return p->r_robin%MAX_PSYC_PAGES;
80107385:	83 e0 0f             	and    $0xf,%eax
}
80107388:	5d                   	pop    %ebp
80107389:	c3                   	ret    
8010738a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107390 <next_i_in_mem_to_remove>:

// find next page to remove from memory
int
next_i_in_mem_to_remove(struct proc *p)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	53                   	push   %ebx
80107394:	83 ec 04             	sub    $0x4,%esp
80107397:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("LAPA!\n");
      next_i = LAPA_next(p);
    } while(next_i == -1);
  #elif SCFIFO
    do {
      next_i = SCFIFO_next(p);
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	53                   	push   %ebx
801073a4:	e8 17 ff ff ff       	call   801072c0 <SCFIFO_next>
      // cprintf("SCFIFO: i selected: %d, timestamp: %d, va: %x\n", next_i, p->memory_pages[next_i].time_loaded, p->memory_pages[next_i].va);
    } while(next_i == -1);
801073a9:	83 c4 10             	add    $0x10,%esp
801073ac:	83 f8 ff             	cmp    $0xffffffff,%eax
801073af:	74 ef                	je     801073a0 <next_i_in_mem_to_remove+0x10>
    } while(next_i == -1);
  #endif
  if (next_i == -1)
    panic("next i == -1\n");
  return next_i;
}
801073b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073b4:	c9                   	leave  
801073b5:	c3                   	ret    
801073b6:	8d 76 00             	lea    0x0(%esi),%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <next_free_i_in_mem>:

// find free space in ram
int
next_free_i_in_mem(struct proc *p)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	8b 45 08             	mov    0x8(%ebp),%eax
801073c6:	8d 90 cc 01 00 00    	lea    0x1cc(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801073cc:	31 c0                	xor    %eax,%eax
801073ce:	eb 0b                	jmp    801073db <next_free_i_in_mem+0x1b>
801073d0:	83 c0 01             	add    $0x1,%eax
801073d3:	83 c2 14             	add    $0x14,%edx
801073d6:	83 f8 10             	cmp    $0x10,%eax
801073d9:	74 0d                	je     801073e8 <next_free_i_in_mem+0x28>
    if (!p->memory_pages[i].is_used)
801073db:	8b 0a                	mov    (%edx),%ecx
801073dd:	85 c9                	test   %ecx,%ecx
801073df:	75 ef                	jne    801073d0 <next_free_i_in_mem+0x10>
      return i;
  }
  return -1;
}
801073e1:	5d                   	pop    %ebp
801073e2:	c3                   	ret    
801073e3:	90                   	nop
801073e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
801073e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073ed:	5d                   	pop    %ebp
801073ee:	c3                   	ret    
801073ef:	90                   	nop

801073f0 <get_i_of_va_in_mem>:

// find index of va in mem
int
get_i_of_va_in_mem(struct proc *p, uint va)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	8b 45 08             	mov    0x8(%ebp),%eax
801073f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073f9:	8d 90 c4 01 00 00    	lea    0x1c4(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801073ff:	31 c0                	xor    %eax,%eax
80107401:	eb 10                	jmp    80107413 <get_i_of_va_in_mem+0x23>
80107403:	90                   	nop
80107404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107408:	83 c0 01             	add    $0x1,%eax
8010740b:	83 c2 14             	add    $0x14,%edx
8010740e:	83 f8 10             	cmp    $0x10,%eax
80107411:	74 0d                	je     80107420 <get_i_of_va_in_mem+0x30>
    if (p->memory_pages[i].va == va)
80107413:	39 0a                	cmp    %ecx,(%edx)
80107415:	75 f1                	jne    80107408 <get_i_of_va_in_mem+0x18>
      return i;
  }
  return -1;
}
80107417:	5d                   	pop    %ebp
80107418:	c3                   	ret    
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107425:	5d                   	pop    %ebp
80107426:	c3                   	ret    
80107427:	89 f6                	mov    %esi,%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <next_free_i_in_file>:

// find free space in file
int
next_free_i_in_file(struct proc *p)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	8b 45 08             	mov    0x8(%ebp),%eax
80107436:	8d 90 8c 00 00 00    	lea    0x8c(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010743c:	31 c0                	xor    %eax,%eax
8010743e:	eb 0b                	jmp    8010744b <next_free_i_in_file+0x1b>
80107440:	83 c0 01             	add    $0x1,%eax
80107443:	83 c2 14             	add    $0x14,%edx
80107446:	83 f8 10             	cmp    $0x10,%eax
80107449:	74 0d                	je     80107458 <next_free_i_in_file+0x28>
    if (!p->file_pages[i].is_used)
8010744b:	8b 0a                	mov    (%edx),%ecx
8010744d:	85 c9                	test   %ecx,%ecx
8010744f:	75 ef                	jne    80107440 <next_free_i_in_file+0x10>
      return i;
  }
  return -1;
}
80107451:	5d                   	pop    %ebp
80107452:	c3                   	ret    
80107453:	90                   	nop
80107454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010745d:	5d                   	pop    %ebp
8010745e:	c3                   	ret    
8010745f:	90                   	nop

80107460 <get_i_of_va_in_file>:

// find index of va in file
int
get_i_of_va_in_file(struct proc *p, uint va)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	8b 45 08             	mov    0x8(%ebp),%eax
80107466:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107469:	8d 90 84 00 00 00    	lea    0x84(%eax),%edx
  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010746f:	31 c0                	xor    %eax,%eax
80107471:	eb 10                	jmp    80107483 <get_i_of_va_in_file+0x23>
80107473:	90                   	nop
80107474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107478:	83 c0 01             	add    $0x1,%eax
8010747b:	83 c2 14             	add    $0x14,%edx
8010747e:	83 f8 10             	cmp    $0x10,%eax
80107481:	74 0d                	je     80107490 <get_i_of_va_in_file+0x30>
    if (p->file_pages[i].va == va)
80107483:	39 0a                	cmp    %ecx,(%edx)
80107485:	75 f1                	jne    80107478 <get_i_of_va_in_file+0x18>
      return i;
  }
  return -1;
}
80107487:	5d                   	pop    %ebp
80107488:	c3                   	ret    
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107495:	5d                   	pop    %ebp
80107496:	c3                   	ret    
80107497:	89 f6                	mov    %esi,%esi
80107499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074a0 <set_page_flags_in_mem>:

void
set_page_flags_in_mem(pde_t *pgdir, uint va, uint pa)
{
801074a0:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801074a1:	31 c9                	xor    %ecx,%ecx
{
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801074a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ab:	8b 45 08             	mov    0x8(%ebp),%eax
801074ae:	e8 5d f9 ff ff       	call   80106e10 <walkpgdir>
  if (!pte)
801074b3:	85 c0                	test   %eax,%eax
801074b5:	74 11                	je     801074c8 <set_page_flags_in_mem+0x28>
    panic("failed setting PTE flags when handling trap\n");
  
  *pte |= PTE_P | PTE_W | PTE_U;   // PTE is in mem, writable and user's
  *pte &= ~PTE_PG;   // PTE is NOT in disk
  *pte |= pa;
801074b7:	8b 10                	mov    (%eax),%edx
801074b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074bc:	80 e6 fd             	and    $0xfd,%dh
801074bf:	83 c9 07             	or     $0x7,%ecx
801074c2:	09 ca                	or     %ecx,%edx
801074c4:	89 10                	mov    %edx,(%eax)
}
801074c6:	c9                   	leave  
801074c7:	c3                   	ret    
    panic("failed setting PTE flags when handling trap\n");
801074c8:	83 ec 0c             	sub    $0xc,%esp
801074cb:	68 e8 8c 10 80       	push   $0x80108ce8
801074d0:	e8 bb 8e ff ff       	call   80100390 <panic>
801074d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <set_page_flags_in_disk>:

void
set_page_flags_in_disk(pde_t *pgdir, uint va)
{
801074e0:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801074e1:	31 c9                	xor    %ecx,%ecx
{
801074e3:	89 e5                	mov    %esp,%ebp
801074e5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801074e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074eb:	8b 45 08             	mov    0x8(%ebp),%eax
801074ee:	e8 1d f9 ff ff       	call   80106e10 <walkpgdir>
  if (!pte)
801074f3:	85 c0                	test   %eax,%eax
801074f5:	74 0c                	je     80107503 <set_page_flags_in_disk+0x23>
    panic("failed setting PTE flags after writing to file\n");
  
  *pte |= PTE_PG;   // PTE is in file
  *pte &= ~PTE_P;   // PTE is NOT in memory
801074f7:	8b 10                	mov    (%eax),%edx
801074f9:	83 e2 fe             	and    $0xfffffffe,%edx
801074fc:	80 ce 02             	or     $0x2,%dh
801074ff:	89 10                	mov    %edx,(%eax)
}
80107501:	c9                   	leave  
80107502:	c3                   	ret    
    panic("failed setting PTE flags after writing to file\n");
80107503:	83 ec 0c             	sub    $0xc,%esp
80107506:	68 18 8d 10 80       	push   $0x80108d18
8010750b:	e8 80 8e ff ff       	call   80100390 <panic>

80107510 <swap>:

int
swap(struct proc *p)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 1c             	sub    $0x1c,%esp
80107519:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i_in_mem_to_remove, next_free_i_file, pa;

  p->page_faults++;
8010751c:	83 87 00 03 00 00 01 	addl   $0x1,0x300(%edi)
80107523:	90                   	nop
80107524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      next_i = SCFIFO_next(p);
80107528:	83 ec 0c             	sub    $0xc,%esp
8010752b:	57                   	push   %edi
8010752c:	e8 8f fd ff ff       	call   801072c0 <SCFIFO_next>
    } while(next_i == -1);
80107531:	83 c4 10             	add    $0x10,%esp
80107534:	83 f8 ff             	cmp    $0xffffffff,%eax
      next_i = SCFIFO_next(p);
80107537:	89 c6                	mov    %eax,%esi
    } while(next_i == -1);
80107539:	74 ed                	je     80107528 <swap+0x18>
8010753b:	8d 87 8c 00 00 00    	lea    0x8c(%edi),%eax
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107541:	31 db                	xor    %ebx,%ebx
80107543:	eb 12                	jmp    80107557 <swap+0x47>
80107545:	8d 76 00             	lea    0x0(%esi),%esi
80107548:	83 c3 01             	add    $0x1,%ebx
8010754b:	83 c0 14             	add    $0x14,%eax
8010754e:	83 fb 10             	cmp    $0x10,%ebx
80107551:	0f 84 c9 00 00 00    	je     80107620 <swap+0x110>
    if (!p->file_pages[i].is_used)
80107557:	8b 10                	mov    (%eax),%edx
80107559:	85 d2                	test   %edx,%edx
8010755b:	75 eb                	jne    80107548 <swap+0x38>
8010755d:	89 d8                	mov    %ebx,%eax
8010755f:	c1 e0 0c             	shl    $0xc,%eax

  i_in_mem_to_remove = next_i_in_mem_to_remove(p);
  next_free_i_file = next_free_i_in_file(p);

  if (writeToSwapFile(p, (char*) p->memory_pages[i_in_mem_to_remove].va, next_free_i_file*PGSIZE, PGSIZE) == -1)
80107562:	68 00 10 00 00       	push   $0x1000
80107567:	50                   	push   %eax
80107568:	8d 04 b6             	lea    (%esi,%esi,4),%eax
8010756b:	8d 14 87             	lea    (%edi,%eax,4),%edx
8010756e:	ff b2 c4 01 00 00    	pushl  0x1c4(%edx)
80107574:	57                   	push   %edi
80107575:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107578:	e8 13 ad ff ff       	call   80102290 <writeToSwapFile>
8010757d:	83 c4 10             	add    $0x10,%esp
80107580:	83 f8 ff             	cmp    $0xffffffff,%eax
80107583:	0f 84 a6 00 00 00    	je     8010762f <swap+0x11f>
    return -1;

  // swap from memory to file
  p->file_pages[next_free_i_file].pgdir = p->memory_pages[i_in_mem_to_remove].pgdir;
80107589:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010758c:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
8010758f:	8d 0c 8f             	lea    (%edi,%ecx,4),%ecx
80107592:	8b 82 c0 01 00 00    	mov    0x1c0(%edx),%eax
80107598:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  p->file_pages[next_free_i_file].va = p->memory_pages[i_in_mem_to_remove].va;
8010759e:	8b 92 c4 01 00 00    	mov    0x1c4(%edx),%edx
  p->file_pages[next_free_i_file].is_used = 1;
801075a4:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
801075ab:	00 00 00 
  p->file_pages[next_free_i_file].va = p->memory_pages[i_in_mem_to_remove].va;
801075ae:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
801075b4:	31 c9                	xor    %ecx,%ecx
801075b6:	e8 55 f8 ff ff       	call   80106e10 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
801075bb:	85 c0                	test   %eax,%eax
801075bd:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
801075c2:	74 0e                	je     801075d2 <swap+0xc2>
801075c4:	8b 10                	mov    (%eax),%edx
801075c6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801075cc:	81 c2 00 00 00 80    	add    $0x80000000,%edx

  pa = find_pa(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
  kfree(P2V(pa));
801075d2:	83 ec 0c             	sub    $0xc,%esp
801075d5:	52                   	push   %edx
801075d6:	e8 15 b2 ff ff       	call   801027f0 <kfree>
  p->memory_pages[i_in_mem_to_remove].is_used = 0;
801075db:	8d 04 b6             	lea    (%esi,%esi,4),%eax
801075de:	8d 04 87             	lea    (%edi,%eax,4),%eax
801075e1:	c7 80 cc 01 00 00 00 	movl   $0x0,0x1cc(%eax)
801075e8:	00 00 00 
  set_page_flags_in_disk(p->memory_pages[i_in_mem_to_remove].pgdir, p->memory_pages[i_in_mem_to_remove].va);
801075eb:	5a                   	pop    %edx
801075ec:	59                   	pop    %ecx
801075ed:	ff b0 c4 01 00 00    	pushl  0x1c4(%eax)
801075f3:	ff b0 c0 01 00 00    	pushl  0x1c0(%eax)
801075f9:	e8 e2 fe ff ff       	call   801074e0 <set_page_flags_in_disk>
  lcr3(V2P(p->pgdir));      // flush TLB
801075fe:	8b 47 04             	mov    0x4(%edi),%eax
80107601:	05 00 00 00 80       	add    $0x80000000,%eax
80107606:	0f 22 d8             	mov    %eax,%cr3

  return i_in_mem_to_remove;
80107609:	83 c4 10             	add    $0x10,%esp
}
8010760c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010760f:	89 f0                	mov    %esi,%eax
80107611:	5b                   	pop    %ebx
80107612:	5e                   	pop    %esi
80107613:	5f                   	pop    %edi
80107614:	5d                   	pop    %ebp
80107615:	c3                   	ret    
80107616:	8d 76 00             	lea    0x0(%esi),%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107620:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80107625:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010762a:	e9 33 ff ff ff       	jmp    80107562 <swap+0x52>
    return -1;
8010762f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80107634:	eb d6                	jmp    8010760c <swap+0xfc>
80107636:	8d 76 00             	lea    0x0(%esi),%esi
80107639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107640 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 1c             	sub    $0x1c,%esp
80107649:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010764c:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;
  pte_t *pte;
  uint a, pa;
  struct proc *p = myproc();
8010764f:	e8 6c c7 ff ff       	call   80103dc0 <myproc>

  if(newsz >= oldsz)
80107654:	39 7d 10             	cmp    %edi,0x10(%ebp)
  struct proc *p = myproc();
80107657:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldsz;
8010765a:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
8010765c:	73 4d                	jae    801076ab <deallocuvm+0x6b>

  a = PGROUNDUP(newsz);
8010765e:	8b 45 10             	mov    0x10(%ebp),%eax
80107661:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107667:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010766d:	39 df                	cmp    %ebx,%edi
8010766f:	77 18                	ja     80107689 <deallocuvm+0x49>
80107671:	eb 35                	jmp    801076a8 <deallocuvm+0x68>
80107673:	90                   	nop
80107674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte) 
      // a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
      a += (NPDENTRIES-1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80107678:	8b 10                	mov    (%eax),%edx
8010767a:	f6 c2 01             	test   $0x1,%dl
8010767d:	75 39                	jne    801076b8 <deallocuvm+0x78>
  for(; a  < oldsz; a += PGSIZE){
8010767f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107685:	39 df                	cmp    %ebx,%edi
80107687:	76 1f                	jbe    801076a8 <deallocuvm+0x68>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107689:	31 c9                	xor    %ecx,%ecx
8010768b:	89 da                	mov    %ebx,%edx
8010768d:	89 f0                	mov    %esi,%eax
8010768f:	e8 7c f7 ff ff       	call   80106e10 <walkpgdir>
    if(!pte) 
80107694:	85 c0                	test   %eax,%eax
80107696:	75 e0                	jne    80107678 <deallocuvm+0x38>
      a += (NPDENTRIES-1) * PGSIZE;
80107698:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010769e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076a4:	39 df                	cmp    %ebx,%edi
801076a6:	77 e1                	ja     80107689 <deallocuvm+0x49>
        }
      }
      *pte = 0;
    }
  }
  return newsz;
801076a8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801076ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ae:	5b                   	pop    %ebx
801076af:	5e                   	pop    %esi
801076b0:	5f                   	pop    %edi
801076b1:	5d                   	pop    %ebp
801076b2:	c3                   	ret    
801076b3:	90                   	nop
801076b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801076b8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076be:	74 58                	je     80107718 <deallocuvm+0xd8>
      kfree(v);
801076c0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076c3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801076cc:	52                   	push   %edx
801076cd:	e8 1e b1 ff ff       	call   801027f0 <kfree>
801076d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076d5:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
801076d8:	31 c9                	xor    %ecx,%ecx
801076da:	8d 90 c0 01 00 00    	lea    0x1c0(%eax),%edx
801076e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076e3:	eb 0e                	jmp    801076f3 <deallocuvm+0xb3>
801076e5:	8d 76 00             	lea    0x0(%esi),%esi
801076e8:	83 c1 01             	add    $0x1,%ecx
801076eb:	83 c2 14             	add    $0x14,%edx
801076ee:	83 f9 10             	cmp    $0x10,%ecx
801076f1:	74 1a                	je     8010770d <deallocuvm+0xcd>
          if (//p->memory_pages[i].is_used && 
801076f3:	39 32                	cmp    %esi,(%edx)
801076f5:	75 f1                	jne    801076e8 <deallocuvm+0xa8>
              p->memory_pages[i].pgdir == pgdir && p->memory_pages[i].va == a) {
801076f7:	39 5a 04             	cmp    %ebx,0x4(%edx)
801076fa:	75 ec                	jne    801076e8 <deallocuvm+0xa8>
            p->memory_pages[i].is_used = 0;
801076fc:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801076ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107702:	c7 84 91 cc 01 00 00 	movl   $0x0,0x1cc(%ecx,%edx,4)
80107709:	00 00 00 00 
      *pte = 0;
8010770d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107713:	e9 67 ff ff ff       	jmp    8010767f <deallocuvm+0x3f>
        panic("kfree");
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	68 0a 84 10 80       	push   $0x8010840a
80107720:	e8 6b 8c ff ff       	call   80100390 <panic>
80107725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107730 <allocuvm>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	57                   	push   %edi
80107734:	56                   	push   %esi
80107735:	53                   	push   %ebx
80107736:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80107739:	e8 82 c6 ff ff       	call   80103dc0 <myproc>
8010773e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107740:	8b 45 10             	mov    0x10(%ebp),%eax
80107743:	85 c0                	test   %eax,%eax
80107745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107748:	0f 88 02 01 00 00    	js     80107850 <allocuvm+0x120>
  if(newsz < oldsz)
8010774e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107751:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107754:	0f 82 de 00 00 00    	jb     80107838 <allocuvm+0x108>
8010775a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107760:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if (check_policy() && p->pid > 2 && (PGROUNDUP(newsz) - PGROUNDUP(oldsz))/ PGSIZE > MAX_TOTAL_PAGES) { // space needed is bigger than max num of pages
80107766:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010776a:	0f 8f 10 01 00 00    	jg     80107880 <allocuvm+0x150>
  for(; a < newsz; a += PGSIZE){
80107770:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107773:	77 1a                	ja     8010778f <allocuvm+0x5f>
80107775:	e9 c1 00 00 00       	jmp    8010783b <allocuvm+0x10b>
8010777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107780:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107786:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107789:	0f 86 ac 00 00 00    	jbe    8010783b <allocuvm+0x10b>
    mem = kalloc();
8010778f:	e8 8c b2 ff ff       	call   80102a20 <kalloc>
    if(mem == 0){
80107794:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107796:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107798:	0f 84 22 01 00 00    	je     801078c0 <allocuvm+0x190>
    memset(mem, 0, PGSIZE);
8010779e:	83 ec 04             	sub    $0x4,%esp
801077a1:	68 00 10 00 00       	push   $0x1000
801077a6:	6a 00                	push   $0x0
801077a8:	50                   	push   %eax
801077a9:	e8 b2 d4 ff ff       	call   80104c60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801077ae:	58                   	pop    %eax
801077af:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801077b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077ba:	5a                   	pop    %edx
801077bb:	6a 06                	push   $0x6
801077bd:	50                   	push   %eax
801077be:	89 da                	mov    %ebx,%edx
801077c0:	8b 45 08             	mov    0x8(%ebp),%eax
801077c3:	e8 c8 f6 ff ff       	call   80106e90 <mappages>
801077c8:	83 c4 10             	add    $0x10,%esp
801077cb:	85 c0                	test   %eax,%eax
801077cd:	0f 88 25 01 00 00    	js     801078f8 <allocuvm+0x1c8>
    if (check_policy() && p->pid > 2) {
801077d3:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801077d7:	7e a7                	jle    80107780 <allocuvm+0x50>
801077d9:	8d 97 cc 01 00 00    	lea    0x1cc(%edi),%edx
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801077df:	31 c0                	xor    %eax,%eax
801077e1:	eb 10                	jmp    801077f3 <allocuvm+0xc3>
801077e3:	90                   	nop
801077e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077e8:	83 c0 01             	add    $0x1,%eax
801077eb:	83 c2 14             	add    $0x14,%edx
801077ee:	83 f8 10             	cmp    $0x10,%eax
801077f1:	74 75                	je     80107868 <allocuvm+0x138>
    if (!p->memory_pages[i].is_used)
801077f3:	8b 0a                	mov    (%edx),%ecx
801077f5:	85 c9                	test   %ecx,%ecx
801077f7:	75 ef                	jne    801077e8 <allocuvm+0xb8>
      p->memory_pages[next_free_i_mem].pgdir = pgdir;
801077f9:	8d 04 80             	lea    (%eax,%eax,4),%eax
801077fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
801077ff:	8d 04 87             	lea    (%edi,%eax,4),%eax
80107802:	89 88 c0 01 00 00    	mov    %ecx,0x1c0(%eax)
      p->memory_pages[next_free_i_mem].is_used = 1;
80107808:	c7 80 cc 01 00 00 01 	movl   $0x1,0x1cc(%eax)
8010780f:	00 00 00 
      p->memory_pages[next_free_i_mem].va = a;
80107812:	89 98 c4 01 00 00    	mov    %ebx,0x1c4(%eax)
      p->memory_pages[next_free_i_mem].time_loaded = p->timestamp++;
80107818:	8b 97 04 03 00 00    	mov    0x304(%edi),%edx
8010781e:	8d 4a 01             	lea    0x1(%edx),%ecx
80107821:	89 8f 04 03 00 00    	mov    %ecx,0x304(%edi)
80107827:	89 90 d0 01 00 00    	mov    %edx,0x1d0(%eax)
8010782d:	e9 4e ff ff ff       	jmp    80107780 <allocuvm+0x50>
80107832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
80107838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
8010783b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010783e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107841:	5b                   	pop    %ebx
80107842:	5e                   	pop    %esi
80107843:	5f                   	pop    %edi
80107844:	5d                   	pop    %ebp
80107845:	c3                   	ret    
80107846:	8d 76 00             	lea    0x0(%esi),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return 0;
80107850:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010785a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785d:	5b                   	pop    %ebx
8010785e:	5e                   	pop    %esi
8010785f:	5f                   	pop    %edi
80107860:	5d                   	pop    %ebp
80107861:	c3                   	ret    
80107862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      next_free_i_mem = next_free_i_mem == -1 ? swap(p) : next_free_i_mem;
80107868:	83 ec 0c             	sub    $0xc,%esp
8010786b:	57                   	push   %edi
8010786c:	e8 9f fc ff ff       	call   80107510 <swap>
80107871:	83 c4 10             	add    $0x10,%esp
80107874:	eb 83                	jmp    801077f9 <allocuvm+0xc9>
80107876:	8d 76 00             	lea    0x0(%esi),%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if (check_policy() && p->pid > 2 && (PGROUNDUP(newsz) - PGROUNDUP(oldsz))/ PGSIZE > MAX_TOTAL_PAGES) { // space needed is bigger than max num of pages
80107880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107883:	05 ff 0f 00 00       	add    $0xfff,%eax
80107888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010788d:	29 d8                	sub    %ebx,%eax
8010788f:	3d ff 0f 02 00       	cmp    $0x20fff,%eax
80107894:	0f 86 d6 fe ff ff    	jbe    80107770 <allocuvm+0x40>
    cprintf("alloc uvm: space requested(%d) is bigger than max allowed(%d)\n", PGROUNDUP(newsz) - PGROUNDUP(oldsz), PGSIZE * MAX_TOTAL_PAGES);
8010789a:	83 ec 04             	sub    $0x4,%esp
8010789d:	68 00 00 02 00       	push   $0x20000
801078a2:	50                   	push   %eax
801078a3:	68 48 8d 10 80       	push   $0x80108d48
801078a8:	e8 b3 8d ff ff       	call   80100660 <cprintf>
    return 0;
801078ad:	83 c4 10             	add    $0x10,%esp
801078b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801078b7:	eb 82                	jmp    8010783b <allocuvm+0x10b>
801078b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	68 0f 8c 10 80       	push   $0x80108c0f
801078c8:	e8 93 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801078cd:	83 c4 0c             	add    $0xc,%esp
801078d0:	ff 75 0c             	pushl  0xc(%ebp)
801078d3:	ff 75 10             	pushl  0x10(%ebp)
801078d6:	ff 75 08             	pushl  0x8(%ebp)
801078d9:	e8 62 fd ff ff       	call   80107640 <deallocuvm>
      return 0;
801078de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801078e5:	83 c4 10             	add    $0x10,%esp
}
801078e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ee:	5b                   	pop    %ebx
801078ef:	5e                   	pop    %esi
801078f0:	5f                   	pop    %edi
801078f1:	5d                   	pop    %ebp
801078f2:	c3                   	ret    
801078f3:	90                   	nop
801078f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801078f8:	83 ec 0c             	sub    $0xc,%esp
801078fb:	68 27 8c 10 80       	push   $0x80108c27
80107900:	e8 5b 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107905:	83 c4 0c             	add    $0xc,%esp
80107908:	ff 75 0c             	pushl  0xc(%ebp)
8010790b:	ff 75 10             	pushl  0x10(%ebp)
8010790e:	ff 75 08             	pushl  0x8(%ebp)
80107911:	e8 2a fd ff ff       	call   80107640 <deallocuvm>
      kfree(mem);
80107916:	89 34 24             	mov    %esi,(%esp)
80107919:	e8 d2 ae ff ff       	call   801027f0 <kfree>
      return 0;
8010791e:	83 c4 10             	add    $0x10,%esp
80107921:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107928:	e9 0e ff ff ff       	jmp    8010783b <allocuvm+0x10b>
8010792d:	8d 76 00             	lea    0x0(%esi),%esi

80107930 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010793c:	85 f6                	test   %esi,%esi
8010793e:	74 59                	je     80107999 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107940:	83 ec 04             	sub    $0x4,%esp
80107943:	89 f3                	mov    %esi,%ebx
80107945:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010794b:	6a 00                	push   $0x0
8010794d:	68 00 00 00 80       	push   $0x80000000
80107952:	56                   	push   %esi
80107953:	e8 e8 fc ff ff       	call   80107640 <deallocuvm>
80107958:	83 c4 10             	add    $0x10,%esp
8010795b:	eb 0a                	jmp    80107967 <freevm+0x37>
8010795d:	8d 76 00             	lea    0x0(%esi),%esi
80107960:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107963:	39 fb                	cmp    %edi,%ebx
80107965:	74 23                	je     8010798a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107967:	8b 03                	mov    (%ebx),%eax
80107969:	a8 01                	test   $0x1,%al
8010796b:	74 f3                	je     80107960 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010796d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107978:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010797d:	50                   	push   %eax
8010797e:	e8 6d ae ff ff       	call   801027f0 <kfree>
80107983:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107986:	39 fb                	cmp    %edi,%ebx
80107988:	75 dd                	jne    80107967 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010798a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010798d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107990:	5b                   	pop    %ebx
80107991:	5e                   	pop    %esi
80107992:	5f                   	pop    %edi
80107993:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107994:	e9 57 ae ff ff       	jmp    801027f0 <kfree>
    panic("freevm: no pgdir");
80107999:	83 ec 0c             	sub    $0xc,%esp
8010799c:	68 43 8c 10 80       	push   $0x80108c43
801079a1:	e8 ea 89 ff ff       	call   80100390 <panic>
801079a6:	8d 76 00             	lea    0x0(%esi),%esi
801079a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079b0 <setupkvm>:
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	56                   	push   %esi
801079b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801079b5:	e8 66 b0 ff ff       	call   80102a20 <kalloc>
801079ba:	85 c0                	test   %eax,%eax
801079bc:	89 c6                	mov    %eax,%esi
801079be:	74 42                	je     80107a02 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801079c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801079c8:	68 00 10 00 00       	push   $0x1000
801079cd:	6a 00                	push   $0x0
801079cf:	50                   	push   %eax
801079d0:	e8 8b d2 ff ff       	call   80104c60 <memset>
801079d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801079d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801079db:	8b 4b 08             	mov    0x8(%ebx),%ecx
801079de:	83 ec 08             	sub    $0x8,%esp
801079e1:	8b 13                	mov    (%ebx),%edx
801079e3:	ff 73 0c             	pushl  0xc(%ebx)
801079e6:	50                   	push   %eax
801079e7:	29 c1                	sub    %eax,%ecx
801079e9:	89 f0                	mov    %esi,%eax
801079eb:	e8 a0 f4 ff ff       	call   80106e90 <mappages>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	85 c0                	test   %eax,%eax
801079f5:	78 19                	js     80107a10 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079f7:	83 c3 10             	add    $0x10,%ebx
801079fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107a00:	75 d6                	jne    801079d8 <setupkvm+0x28>
}
80107a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a05:	89 f0                	mov    %esi,%eax
80107a07:	5b                   	pop    %ebx
80107a08:	5e                   	pop    %esi
80107a09:	5d                   	pop    %ebp
80107a0a:	c3                   	ret    
80107a0b:	90                   	nop
80107a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107a10:	83 ec 0c             	sub    $0xc,%esp
80107a13:	56                   	push   %esi
      return 0;
80107a14:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107a16:	e8 15 ff ff ff       	call   80107930 <freevm>
      return 0;
80107a1b:	83 c4 10             	add    $0x10,%esp
}
80107a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a21:	89 f0                	mov    %esi,%eax
80107a23:	5b                   	pop    %ebx
80107a24:	5e                   	pop    %esi
80107a25:	5d                   	pop    %ebp
80107a26:	c3                   	ret    
80107a27:	89 f6                	mov    %esi,%esi
80107a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a30 <kvmalloc>:
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a36:	e8 75 ff ff ff       	call   801079b0 <setupkvm>
80107a3b:	a3 c4 a8 15 80       	mov    %eax,0x8015a8c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a40:	05 00 00 00 80       	add    $0x80000000,%eax
80107a45:	0f 22 d8             	mov    %eax,%cr3
}
80107a48:	c9                   	leave  
80107a49:	c3                   	ret    
80107a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a51:	31 c9                	xor    %ecx,%ecx
{
80107a53:	89 e5                	mov    %esp,%ebp
80107a55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a5e:	e8 ad f3 ff ff       	call   80106e10 <walkpgdir>
  if(pte == 0)
80107a63:	85 c0                	test   %eax,%eax
80107a65:	74 05                	je     80107a6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107a67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a6a:	c9                   	leave  
80107a6b:	c3                   	ret    
    panic("clearpteu");
80107a6c:	83 ec 0c             	sub    $0xc,%esp
80107a6f:	68 54 8c 10 80       	push   $0x80108c54
80107a74:	e8 17 89 ff ff       	call   80100390 <panic>
80107a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
80107a86:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  // struct proc *p = myproc();

  if((d = setupkvm()) == 0)
80107a89:	e8 22 ff ff ff       	call   801079b0 <setupkvm>
80107a8e:	85 c0                	test   %eax,%eax
80107a90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a93:	0f 84 9f 00 00 00    	je     80107b38 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a9c:	85 c9                	test   %ecx,%ecx
80107a9e:	0f 84 94 00 00 00    	je     80107b38 <copyuvm+0xb8>
80107aa4:	31 ff                	xor    %edi,%edi
80107aa6:	eb 4a                	jmp    80107af2 <copyuvm+0x72>
80107aa8:	90                   	nop
80107aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ab0:	83 ec 04             	sub    $0x4,%esp
80107ab3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107ab9:	68 00 10 00 00       	push   $0x1000
80107abe:	53                   	push   %ebx
80107abf:	50                   	push   %eax
80107ac0:	e8 4b d2 ff ff       	call   80104d10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107ac5:	58                   	pop    %eax
80107ac6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107acc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ad1:	5a                   	pop    %edx
80107ad2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ad5:	50                   	push   %eax
80107ad6:	89 fa                	mov    %edi,%edx
80107ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107adb:	e8 b0 f3 ff ff       	call   80106e90 <mappages>
80107ae0:	83 c4 10             	add    $0x10,%esp
80107ae3:	85 c0                	test   %eax,%eax
80107ae5:	78 61                	js     80107b48 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107ae7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107aed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107af0:	76 46                	jbe    80107b38 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107af2:	8b 45 08             	mov    0x8(%ebp),%eax
80107af5:	31 c9                	xor    %ecx,%ecx
80107af7:	89 fa                	mov    %edi,%edx
80107af9:	e8 12 f3 ff ff       	call   80106e10 <walkpgdir>
80107afe:	85 c0                	test   %eax,%eax
80107b00:	74 61                	je     80107b63 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107b02:	8b 00                	mov    (%eax),%eax
80107b04:	a8 01                	test   $0x1,%al
80107b06:	74 4e                	je     80107b56 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107b08:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107b0a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107b0f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107b18:	e8 03 af ff ff       	call   80102a20 <kalloc>
80107b1d:	85 c0                	test   %eax,%eax
80107b1f:	89 c6                	mov    %eax,%esi
80107b21:	75 8d                	jne    80107ab0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107b23:	83 ec 0c             	sub    $0xc,%esp
80107b26:	ff 75 e0             	pushl  -0x20(%ebp)
80107b29:	e8 02 fe ff ff       	call   80107930 <freevm>
  return 0;
80107b2e:	83 c4 10             	add    $0x10,%esp
80107b31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b3e:	5b                   	pop    %ebx
80107b3f:	5e                   	pop    %esi
80107b40:	5f                   	pop    %edi
80107b41:	5d                   	pop    %ebp
80107b42:	c3                   	ret    
80107b43:	90                   	nop
80107b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107b48:	83 ec 0c             	sub    $0xc,%esp
80107b4b:	56                   	push   %esi
80107b4c:	e8 9f ac ff ff       	call   801027f0 <kfree>
      goto bad;
80107b51:	83 c4 10             	add    $0x10,%esp
80107b54:	eb cd                	jmp    80107b23 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107b56:	83 ec 0c             	sub    $0xc,%esp
80107b59:	68 78 8c 10 80       	push   $0x80108c78
80107b5e:	e8 2d 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107b63:	83 ec 0c             	sub    $0xc,%esp
80107b66:	68 5e 8c 10 80       	push   $0x80108c5e
80107b6b:	e8 20 88 ff ff       	call   80100390 <panic>

80107b70 <copyonwriteuvm>:

pde_t*
copyonwriteuvm(pde_t *pgdir, uint sz)
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	57                   	push   %edi
80107b74:	56                   	push   %esi
80107b75:	53                   	push   %ebx
80107b76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  struct proc *p = myproc();
80107b79:	e8 42 c2 ff ff       	call   80103dc0 <myproc>
80107b7e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // if (p->pid <= 2)
  //   return copyuvm(pgdir, sz);

  if((d = setupkvm()) == 0)
80107b81:	e8 2a fe ff ff       	call   801079b0 <setupkvm>
80107b86:	85 c0                	test   %eax,%eax
80107b88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b8b:	0f 84 bd 00 00 00    	je     80107c4e <copyonwriteuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b94:	85 c9                	test   %ecx,%ecx
80107b96:	0f 84 a4 00 00 00    	je     80107c40 <copyonwriteuvm+0xd0>
80107b9c:	31 db                	xor    %ebx,%ebx
80107b9e:	eb 57                	jmp    80107bf7 <copyonwriteuvm+0x87>
    if(*pte & PTE_PG) {
      set_page_flags_in_disk(d, i);
      lcr3(V2P(p->pgdir));
      continue;
    }
    if(!(*pte & PTE_P))
80107ba0:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107ba6:	0f 84 c7 00 00 00    	je     80107c73 <copyonwriteuvm+0x103>
      panic("copyonwriteuvm: page not present");


    *pte |= PTE_COW;    // copy on write
    *pte &= ~PTE_W;     // pte is NOT writable -> need to handle in trap!
80107bac:	89 f1                	mov    %esi,%ecx
80107bae:	89 f7                	mov    %esi,%edi
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    inc_counter(pa);
80107bb0:	83 ec 0c             	sub    $0xc,%esp
    *pte &= ~PTE_W;     // pte is NOT writable -> need to handle in trap!
80107bb3:	83 e1 fd             	and    $0xfffffffd,%ecx
80107bb6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107bbc:	80 cd 04             	or     $0x4,%ch
80107bbf:	89 08                	mov    %ecx,(%eax)
    inc_counter(pa);
80107bc1:	57                   	push   %edi
80107bc2:	e8 99 ab ff ff       	call   80102760 <inc_counter>
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107bc7:	58                   	pop    %eax
80107bc8:	5a                   	pop    %edx
    flags = PTE_FLAGS(*pte);
80107bc9:	89 f2                	mov    %esi,%edx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bce:	b9 00 10 00 00       	mov    $0x1000,%ecx
    flags = PTE_FLAGS(*pte);
80107bd3:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
80107bd9:	80 ce 04             	or     $0x4,%dh
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107bdc:	52                   	push   %edx
80107bdd:	57                   	push   %edi
80107bde:	89 da                	mov    %ebx,%edx
80107be0:	e8 ab f2 ff ff       	call   80106e90 <mappages>
80107be5:	83 c4 10             	add    $0x10,%esp
80107be8:	85 c0                	test   %eax,%eax
80107bea:	78 7a                	js     80107c66 <copyonwriteuvm+0xf6>
  for(i = 0; i < sz; i += PGSIZE){
80107bec:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bf2:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107bf5:	76 49                	jbe    80107c40 <copyonwriteuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfa:	31 c9                	xor    %ecx,%ecx
80107bfc:	89 da                	mov    %ebx,%edx
80107bfe:	e8 0d f2 ff ff       	call   80106e10 <walkpgdir>
80107c03:	85 c0                	test   %eax,%eax
80107c05:	74 52                	je     80107c59 <copyonwriteuvm+0xe9>
    if(*pte & PTE_PG) {
80107c07:	8b 30                	mov    (%eax),%esi
80107c09:	f7 c6 00 02 00 00    	test   $0x200,%esi
80107c0f:	74 8f                	je     80107ba0 <copyonwriteuvm+0x30>
      set_page_flags_in_disk(d, i);
80107c11:	83 ec 08             	sub    $0x8,%esp
80107c14:	53                   	push   %ebx
80107c15:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c18:	e8 c3 f8 ff ff       	call   801074e0 <set_page_flags_in_disk>
      lcr3(V2P(p->pgdir));
80107c1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c20:	8b 40 04             	mov    0x4(%eax),%eax
80107c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c26:	05 00 00 00 80       	add    $0x80000000,%eax
80107c2b:	0f 22 d8             	mov    %eax,%cr3
      continue;
80107c2e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107c31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c37:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107c3a:	77 bb                	ja     80107bf7 <copyonwriteuvm+0x87>
80107c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      goto bad;
  }
  lcr3(V2P(p->pgdir));
80107c40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c43:	8b 40 04             	mov    0x4(%eax),%eax
80107c46:	05 00 00 00 80       	add    $0x80000000,%eax
80107c4b:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  panic("copyonwriteuvm: should not happen\n");
  return 0;
}
80107c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c54:	5b                   	pop    %ebx
80107c55:	5e                   	pop    %esi
80107c56:	5f                   	pop    %edi
80107c57:	5d                   	pop    %ebp
80107c58:	c3                   	ret    
      panic("copyonwriteuvm: pte should exist");
80107c59:	83 ec 0c             	sub    $0xc,%esp
80107c5c:	68 88 8d 10 80       	push   $0x80108d88
80107c61:	e8 2a 87 ff ff       	call   80100390 <panic>
  panic("copyonwriteuvm: should not happen\n");
80107c66:	83 ec 0c             	sub    $0xc,%esp
80107c69:	68 d0 8d 10 80       	push   $0x80108dd0
80107c6e:	e8 1d 87 ff ff       	call   80100390 <panic>
      panic("copyonwriteuvm: page not present");
80107c73:	83 ec 0c             	sub    $0xc,%esp
80107c76:	68 ac 8d 10 80       	push   $0x80108dac
80107c7b:	e8 10 87 ff ff       	call   80100390 <panic>

80107c80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c81:	31 c9                	xor    %ecx,%ecx
{
80107c83:	89 e5                	mov    %esp,%ebp
80107c85:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107c88:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8e:	e8 7d f1 ff ff       	call   80106e10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107c93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107c95:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107c96:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107c98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107c9d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ca0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ca5:	83 fa 05             	cmp    $0x5,%edx
80107ca8:	ba 00 00 00 00       	mov    $0x0,%edx
80107cad:	0f 45 c2             	cmovne %edx,%eax
}
80107cb0:	c3                   	ret    
80107cb1:	eb 0d                	jmp    80107cc0 <copyout>
80107cb3:	90                   	nop
80107cb4:	90                   	nop
80107cb5:	90                   	nop
80107cb6:	90                   	nop
80107cb7:	90                   	nop
80107cb8:	90                   	nop
80107cb9:	90                   	nop
80107cba:	90                   	nop
80107cbb:	90                   	nop
80107cbc:	90                   	nop
80107cbd:	90                   	nop
80107cbe:	90                   	nop
80107cbf:	90                   	nop

80107cc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
80107cc6:	83 ec 1c             	sub    $0x1c,%esp
80107cc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ccf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107cd2:	85 db                	test   %ebx,%ebx
80107cd4:	75 40                	jne    80107d16 <copyout+0x56>
80107cd6:	eb 70                	jmp    80107d48 <copyout+0x88>
80107cd8:	90                   	nop
80107cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ce0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ce3:	89 f1                	mov    %esi,%ecx
80107ce5:	29 d1                	sub    %edx,%ecx
80107ce7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107ced:	39 d9                	cmp    %ebx,%ecx
80107cef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107cf2:	29 f2                	sub    %esi,%edx
80107cf4:	83 ec 04             	sub    $0x4,%esp
80107cf7:	01 d0                	add    %edx,%eax
80107cf9:	51                   	push   %ecx
80107cfa:	57                   	push   %edi
80107cfb:	50                   	push   %eax
80107cfc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107cff:	e8 0c d0 ff ff       	call   80104d10 <memmove>
    len -= n;
    buf += n;
80107d04:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107d07:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107d0a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107d10:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107d12:	29 cb                	sub    %ecx,%ebx
80107d14:	74 32                	je     80107d48 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107d16:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d18:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107d1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107d1e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d24:	56                   	push   %esi
80107d25:	ff 75 08             	pushl  0x8(%ebp)
80107d28:	e8 53 ff ff ff       	call   80107c80 <uva2ka>
    if(pa0 == 0)
80107d2d:	83 c4 10             	add    $0x10,%esp
80107d30:	85 c0                	test   %eax,%eax
80107d32:	75 ac                	jne    80107ce0 <copyout+0x20>
  }
  return 0;
}
80107d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d3c:	5b                   	pop    %ebx
80107d3d:	5e                   	pop    %esi
80107d3e:	5f                   	pop    %edi
80107d3f:	5d                   	pop    %ebp
80107d40:	c3                   	ret    
80107d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d4b:	31 c0                	xor    %eax,%eax
}
80107d4d:	5b                   	pop    %ebx
80107d4e:	5e                   	pop    %esi
80107d4f:	5f                   	pop    %edi
80107d50:	5d                   	pop    %ebp
80107d51:	c3                   	ret    
80107d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d60 <handle_pf>:

static char buffer[PGSIZE];

int
handle_pf(void) 
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	57                   	push   %edi
80107d64:	56                   	push   %esi
80107d65:	53                   	push   %ebx
80107d66:	83 ec 2c             	sub    $0x2c,%esp
  struct page old_page;
  uint old_pa, va, va_rounded;
  int new_page_i_in_mem, new_page_i_in_file, i_of_rounded_va, is_need_swap;
  char *pa;
  pte_t *pte;
  struct proc *p = myproc();
80107d69:	e8 52 c0 ff ff       	call   80103dc0 <myproc>
80107d6e:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107d70:	0f 20 d7             	mov    %cr2,%edi

  va = rcr2();
  if ((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0) {
80107d73:	8b 40 04             	mov    0x4(%eax),%eax
80107d76:	31 c9                	xor    %ecx,%ecx
80107d78:	89 fa                	mov    %edi,%edx
80107d7a:	e8 91 f0 ff ff       	call   80106e10 <walkpgdir>
80107d7f:	85 c0                	test   %eax,%eax
80107d81:	0f 84 b5 02 00 00    	je     8010803c <handle_pf+0x2dc>
    panic("handle_pf: walkdir failed\n");
  }
  if ((*pte & PTE_PG) == 0) { // not paged out to secondary storage
80107d87:	8b 00                	mov    (%eax),%eax
    return 0;
80107d89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if ((*pte & PTE_PG) == 0) { // not paged out to secondary storage
80107d90:	f6 c4 02             	test   $0x2,%ah
80107d93:	75 0b                	jne    80107da0 <handle_pf+0x40>
  }
  else
    memmove((char*)va_rounded, buffer, PGSIZE);

  return 1;
}
80107d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d9b:	5b                   	pop    %ebx
80107d9c:	5e                   	pop    %esi
80107d9d:	5f                   	pop    %edi
80107d9e:	5d                   	pop    %ebp
80107d9f:	c3                   	ret    
  p->page_faults++;
80107da0:	83 86 00 03 00 00 01 	addl   $0x1,0x300(%esi)
  va_rounded = PGROUNDDOWN(va);
80107da7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pa = kalloc();
80107dad:	e8 6e ac ff ff       	call   80102a20 <kalloc>
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107db2:	31 d2                	xor    %edx,%edx
  pa = kalloc();
80107db4:	89 c3                	mov    %eax,%ebx
80107db6:	8d 86 cc 01 00 00    	lea    0x1cc(%esi),%eax
80107dbc:	eb 11                	jmp    80107dcf <handle_pf+0x6f>
80107dbe:	66 90                	xchg   %ax,%ax
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107dc0:	83 c2 01             	add    $0x1,%edx
80107dc3:	83 c0 14             	add    $0x14,%eax
80107dc6:	83 fa 10             	cmp    $0x10,%edx
80107dc9:	0f 84 e9 01 00 00    	je     80107fb8 <handle_pf+0x258>
    if (!p->memory_pages[i].is_used)
80107dcf:	8b 08                	mov    (%eax),%ecx
80107dd1:	85 c9                	test   %ecx,%ecx
80107dd3:	75 eb                	jne    80107dc0 <handle_pf+0x60>
  is_need_swap = 0;
80107dd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  old_page = p->memory_pages[new_page_i_in_mem];
80107ddc:	8d 04 92             	lea    (%edx,%edx,4),%eax
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107ddf:	83 ec 04             	sub    $0x4,%esp
80107de2:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  old_page = p->memory_pages[new_page_i_in_mem];
80107de8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107deb:	8d 84 86 c0 01 00 00 	lea    0x1c0(%esi,%eax,4),%eax
80107df2:	8b 08                	mov    (%eax),%ecx
80107df4:	8b 40 04             	mov    0x4(%eax),%eax
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107df7:	53                   	push   %ebx
80107df8:	57                   	push   %edi
80107df9:	ff 76 04             	pushl  0x4(%esi)
  old_page = p->memory_pages[new_page_i_in_mem];
80107dfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107dff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  set_page_flags_in_mem(p->pgdir, va_rounded, V2P(pa));
80107e02:	e8 99 f6 ff ff       	call   801074a0 <set_page_flags_in_mem>
  lcr3(V2P(p->pgdir));      // flush changes
80107e07:	8b 46 04             	mov    0x4(%esi),%eax
80107e0a:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e0f:	0f 22 d8             	mov    %eax,%cr3
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107e12:	31 db                	xor    %ebx,%ebx
80107e14:	8d 86 84 00 00 00    	lea    0x84(%esi),%eax
80107e1a:	83 c4 10             	add    $0x10,%esp
80107e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e20:	eb 15                	jmp    80107e37 <handle_pf+0xd7>
80107e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e28:	83 c3 01             	add    $0x1,%ebx
80107e2b:	83 c0 14             	add    $0x14,%eax
80107e2e:	83 fb 10             	cmp    $0x10,%ebx
80107e31:	0f 84 d9 01 00 00    	je     80108010 <handle_pf+0x2b0>
    if (p->file_pages[i].va == va)
80107e37:	3b 38                	cmp    (%eax),%edi
80107e39:	75 ed                	jne    80107e28 <handle_pf+0xc8>
  if (readFromSwapFile(p, buffer, i_of_rounded_va*PGSIZE, PGSIZE) != PGSIZE)
80107e3b:	89 d8                	mov    %ebx,%eax
80107e3d:	68 00 10 00 00       	push   $0x1000
80107e42:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107e45:	c1 e0 0c             	shl    $0xc,%eax
80107e48:	50                   	push   %eax
80107e49:	68 e0 c5 10 80       	push   $0x8010c5e0
80107e4e:	56                   	push   %esi
80107e4f:	e8 6c a4 ff ff       	call   801022c0 <readFromSwapFile>
80107e54:	83 c4 10             	add    $0x10,%esp
80107e57:	3d 00 10 00 00       	cmp    $0x1000,%eax
80107e5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e5f:	0f 85 ca 01 00 00    	jne    8010802f <handle_pf+0x2cf>
  p->memory_pages[new_page_i_in_mem] = p->file_pages[i_of_rounded_va];
80107e65:	8d 04 92             	lea    (%edx,%edx,4),%eax
80107e68:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
80107e6b:	8d 04 86             	lea    (%esi,%eax,4),%eax
80107e6e:	8d 1c 96             	lea    (%esi,%edx,4),%ebx
80107e71:	8d 88 c0 01 00 00    	lea    0x1c0(%eax),%ecx
80107e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e7a:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80107e80:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80107e83:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107e86:	89 81 c0 01 00 00    	mov    %eax,0x1c0(%ecx)
80107e8c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107e8f:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80107e95:	89 41 04             	mov    %eax,0x4(%ecx)
80107e98:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80107e9e:	89 41 08             	mov    %eax,0x8(%ecx)
80107ea1:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80107ea7:	89 41 0c             	mov    %eax,0xc(%ecx)
80107eaa:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
80107eb0:	89 51 10             	mov    %edx,0x10(%ecx)
  p->file_pages[i_of_rounded_va].is_used = 0;
80107eb3:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80107eba:	00 00 00 
  p->memory_pages[new_page_i_in_mem].time_loaded = p->timestamp++;
80107ebd:	8b 86 04 03 00 00    	mov    0x304(%esi),%eax
  if (is_need_swap) {
80107ec3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  p->memory_pages[new_page_i_in_mem].time_loaded = p->timestamp++;
80107ec6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107ec9:	8d 50 01             	lea    0x1(%eax),%edx
  if (is_need_swap) {
80107ecc:	85 db                	test   %ebx,%ebx
  p->memory_pages[new_page_i_in_mem].time_loaded = p->timestamp++;
80107ece:	89 96 04 03 00 00    	mov    %edx,0x304(%esi)
80107ed4:	89 81 d0 01 00 00    	mov    %eax,0x1d0(%ecx)
  if (is_need_swap) {
80107eda:	0f 84 00 01 00 00    	je     80107fe0 <handle_pf+0x280>
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107ee0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107ee3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107ee6:	31 c9                	xor    %ecx,%ecx
  return !pte ? -1 : PTE_ADDR(*pte);
80107ee8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  pte_t *pte = walkpgdir(pgdir, (int*) va, 0);
80107eed:	e8 1e ef ff ff       	call   80106e10 <walkpgdir>
  return !pte ? -1 : PTE_ADDR(*pte);
80107ef2:	85 c0                	test   %eax,%eax
80107ef4:	74 08                	je     80107efe <handle_pf+0x19e>
80107ef6:	8b 18                	mov    (%eax),%ebx
80107ef8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107efe:	8d 86 8c 00 00 00    	lea    0x8c(%esi),%eax
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107f04:	31 d2                	xor    %edx,%edx
80107f06:	eb 17                	jmp    80107f1f <handle_pf+0x1bf>
80107f08:	90                   	nop
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f10:	83 c2 01             	add    $0x1,%edx
80107f13:	83 c0 14             	add    $0x14,%eax
80107f16:	83 fa 10             	cmp    $0x10,%edx
80107f19:	0f 84 01 01 00 00    	je     80108020 <handle_pf+0x2c0>
    if (!p->file_pages[i].is_used)
80107f1f:	8b 08                	mov    (%eax),%ecx
80107f21:	85 c9                	test   %ecx,%ecx
80107f23:	75 eb                	jne    80107f10 <handle_pf+0x1b0>
80107f25:	89 d0                	mov    %edx,%eax
80107f27:	c1 e0 0c             	shl    $0xc,%eax
    if (writeToSwapFile(p, (char*)old_page.va, new_page_i_in_file*PGSIZE, PGSIZE) == -1)
80107f2a:	68 00 10 00 00       	push   $0x1000
80107f2f:	50                   	push   %eax
80107f30:	ff 75 dc             	pushl  -0x24(%ebp)
80107f33:	56                   	push   %esi
80107f34:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107f37:	e8 54 a3 ff ff       	call   80102290 <writeToSwapFile>
80107f3c:	83 c4 10             	add    $0x10,%esp
80107f3f:	83 f8 ff             	cmp    $0xffffffff,%eax
80107f42:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107f45:	0f 84 fe 00 00 00    	je     80108049 <handle_pf+0x2e9>
    p->file_pages[new_page_i_in_file].is_used = 1;
80107f4b:	8d 04 92             	lea    (%edx,%edx,4),%eax
    p->file_pages[new_page_i_in_file].pgdir = old_page.pgdir;
80107f4e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    p->file_pages[new_page_i_in_file].va = old_page.va;
80107f51:	8b 55 dc             	mov    -0x24(%ebp),%edx
    set_page_flags_in_disk(old_page.pgdir, old_page.va);
80107f54:	83 ec 08             	sub    $0x8,%esp
    p->file_pages[new_page_i_in_file].is_used = 1;
80107f57:	8d 04 86             	lea    (%esi,%eax,4),%eax
    p->file_pages[new_page_i_in_file].pgdir = old_page.pgdir;
80107f5a:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
    p->file_pages[new_page_i_in_file].va = old_page.va;
80107f60:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    p->file_pages[new_page_i_in_file].is_used = 1;
80107f66:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80107f6d:	00 00 00 
    set_page_flags_in_disk(old_page.pgdir, old_page.va);
80107f70:	52                   	push   %edx
80107f71:	51                   	push   %ecx
80107f72:	e8 69 f5 ff ff       	call   801074e0 <set_page_flags_in_disk>
    lcr3(V2P(p->pgdir));
80107f77:	8b 46 04             	mov    0x4(%esi),%eax
80107f7a:	05 00 00 00 80       	add    $0x80000000,%eax
80107f7f:	0f 22 d8             	mov    %eax,%cr3
    kfree(P2V(old_pa));
80107f82:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107f88:	89 1c 24             	mov    %ebx,(%esp)
80107f8b:	e8 60 a8 ff ff       	call   801027f0 <kfree>
    memmove((char*)va_rounded, buffer, PGSIZE);
80107f90:	83 c4 0c             	add    $0xc,%esp
80107f93:	68 00 10 00 00       	push   $0x1000
80107f98:	68 e0 c5 10 80       	push   $0x8010c5e0
80107f9d:	57                   	push   %edi
80107f9e:	e8 6d cd ff ff       	call   80104d10 <memmove>
}
80107fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fa6:	83 c4 10             	add    $0x10,%esp
80107fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fac:	5b                   	pop    %ebx
80107fad:	5e                   	pop    %esi
80107fae:	5f                   	pop    %edi
80107faf:	5d                   	pop    %ebp
80107fb0:	c3                   	ret    
80107fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      next_i = SCFIFO_next(p);
80107fb8:	83 ec 0c             	sub    $0xc,%esp
80107fbb:	56                   	push   %esi
80107fbc:	e8 ff f2 ff ff       	call   801072c0 <SCFIFO_next>
    } while(next_i == -1);
80107fc1:	83 c4 10             	add    $0x10,%esp
80107fc4:	83 f8 ff             	cmp    $0xffffffff,%eax
80107fc7:	74 ef                	je     80107fb8 <handle_pf+0x258>
80107fc9:	89 c2                	mov    %eax,%edx
    is_need_swap = 1;
80107fcb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80107fd2:	e9 05 fe ff ff       	jmp    80107ddc <handle_pf+0x7c>
80107fd7:	89 f6                	mov    %esi,%esi
80107fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    memmove((char*)va_rounded, buffer, PGSIZE);
80107fe0:	83 ec 04             	sub    $0x4,%esp
80107fe3:	68 00 10 00 00       	push   $0x1000
80107fe8:	68 e0 c5 10 80       	push   $0x8010c5e0
80107fed:	57                   	push   %edi
80107fee:	e8 1d cd ff ff       	call   80104d10 <memmove>
  return 1;
80107ff3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    memmove((char*)va_rounded, buffer, PGSIZE);
80107ffa:	83 c4 10             	add    $0x10,%esp
}
80107ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108003:	5b                   	pop    %ebx
80108004:	5e                   	pop    %esi
80108005:	5f                   	pop    %edi
80108006:	5d                   	pop    %ebp
80108007:	c3                   	ret    
80108008:	90                   	nop
80108009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("handle PF: cannot find rounded VA\n");
80108010:	83 ec 0c             	sub    $0xc,%esp
80108013:	68 3c 8e 10 80       	push   $0x80108e3c
80108018:	e8 73 83 ff ff       	call   80100390 <panic>
8010801d:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80108020:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80108025:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010802a:	e9 fb fe ff ff       	jmp    80107f2a <handle_pf+0x1ca>
    panic("handle PF: readFromSwapFile failed\n");
8010802f:	83 ec 0c             	sub    $0xc,%esp
80108032:	68 f4 8d 10 80       	push   $0x80108df4
80108037:	e8 54 83 ff ff       	call   80100390 <panic>
    panic("handle_pf: walkdir failed\n");
8010803c:	83 ec 0c             	sub    $0xc,%esp
8010803f:	68 92 8c 10 80       	push   $0x80108c92
80108044:	e8 47 83 ff ff       	call   80100390 <panic>
      panic("handle PF: writeToSwapFile failed\n");
80108049:	83 ec 0c             	sub    $0xc,%esp
8010804c:	68 18 8e 10 80       	push   $0x80108e18
80108051:	e8 3a 83 ff ff       	call   80100390 <panic>
80108056:	8d 76 00             	lea    0x0(%esi),%esi
80108059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108060 <handle_cow>:


int
handle_cow(void) 
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 1c             	sub    $0x1c,%esp
  uint va, pa;
  char *mem;
  pte_t *pte;
  struct proc *p = myproc();
80108069:	e8 52 bd ff ff       	call   80103dc0 <myproc>
8010806e:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108070:	0f 20 d3             	mov    %cr2,%ebx

  // cprintf("handling cow: ");

  va = rcr2();
  pte = walkpgdir(p->pgdir, (char*)va, 0);
80108073:	8b 40 04             	mov    0x4(%eax),%eax
80108076:	31 c9                	xor    %ecx,%ecx
80108078:	89 da                	mov    %ebx,%edx
8010807a:	e8 91 ed ff ff       	call   80106e10 <walkpgdir>
  if ((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0) {
8010807f:	8b 46 04             	mov    0x4(%esi),%eax
80108082:	31 c9                	xor    %ecx,%ecx
80108084:	89 da                	mov    %ebx,%edx
80108086:	e8 85 ed ff ff       	call   80106e10 <walkpgdir>
8010808b:	85 c0                	test   %eax,%eax
8010808d:	0f 84 a3 00 00 00    	je     80108136 <handle_cow+0xd6>
    panic("handle_pf: walkdir failed\n");
  }
  if ((*pte & PTE_W) || !(*pte & PTE_COW)) { // not COW or writable
80108093:	8b 10                	mov    (%eax),%edx
80108095:	89 c3                	mov    %eax,%ebx
    // cprintf("NOT cow\n");
    return 0;
80108097:	31 c0                	xor    %eax,%eax
  if ((*pte & PTE_W) || !(*pte & PTE_COW)) { // not COW or writable
80108099:	89 d1                	mov    %edx,%ecx
8010809b:	81 e1 02 04 00 00    	and    $0x402,%ecx
801080a1:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
801080a7:	74 0f                	je     801080b8 <handle_cow+0x58>
    *pte |= PTE_W;
  }

  lcr3(V2P(p->pgdir));
  return 1;
801080a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080ac:	5b                   	pop    %ebx
801080ad:	5e                   	pop    %esi
801080ae:	5f                   	pop    %edi
801080af:	5d                   	pop    %ebp
801080b0:	c3                   	ret    
801080b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pa = PTE_ADDR(*pte);
801080b8:	89 d7                	mov    %edx,%edi
  if (get_ref_counter(pa) > 1) {  // handling copy
801080ba:	83 ec 0c             	sub    $0xc,%esp
  pa = PTE_ADDR(*pte);
801080bd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if (get_ref_counter(pa) > 1) {  // handling copy
801080c3:	57                   	push   %edi
801080c4:	e8 57 a6 ff ff       	call   80102720 <get_ref_counter>
801080c9:	83 c4 10             	add    $0x10,%esp
801080cc:	83 f8 01             	cmp    $0x1,%eax
801080cf:	7f 27                	jg     801080f8 <handle_cow+0x98>
    *pte &= ~PTE_COW;     // not COW anymore
801080d1:	8b 03                	mov    (%ebx),%eax
801080d3:	80 e4 fb             	and    $0xfb,%ah
    *pte |= PTE_W;
801080d6:	83 c8 02             	or     $0x2,%eax
801080d9:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(p->pgdir));
801080db:	8b 46 04             	mov    0x4(%esi),%eax
801080de:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801080e3:	0f 22 d8             	mov    %eax,%cr3
801080e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801080e9:	b8 01 00 00 00       	mov    $0x1,%eax
801080ee:	5b                   	pop    %ebx
801080ef:	5e                   	pop    %esi
801080f0:	5f                   	pop    %edi
801080f1:	5d                   	pop    %ebp
801080f2:	c3                   	ret    
801080f3:	90                   	nop
801080f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((mem = kalloc()) == 0) {
801080f8:	e8 23 a9 ff ff       	call   80102a20 <kalloc>
801080fd:	85 c0                	test   %eax,%eax
801080ff:	89 c2                	mov    %eax,%edx
80108101:	74 40                	je     80108143 <handle_cow+0xe3>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108103:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80108109:	83 ec 04             	sub    $0x4,%esp
8010810c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010810f:	68 00 10 00 00       	push   $0x1000
80108114:	50                   	push   %eax
80108115:	52                   	push   %edx
80108116:	e8 f5 cb ff ff       	call   80104d10 <memmove>
    dec_counter(pa);
8010811b:	89 3c 24             	mov    %edi,(%esp)
8010811e:	e8 7d a6 ff ff       	call   801027a0 <dec_counter>
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
80108123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108126:	83 c4 10             	add    $0x10,%esp
80108129:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010812f:	83 ca 07             	or     $0x7,%edx
80108132:	89 13                	mov    %edx,(%ebx)
80108134:	eb a5                	jmp    801080db <handle_cow+0x7b>
    panic("handle_pf: walkdir failed\n");
80108136:	83 ec 0c             	sub    $0xc,%esp
80108139:	68 92 8c 10 80       	push   $0x80108c92
8010813e:	e8 4d 82 ff ff       	call   80100390 <panic>
      panic("COW: kalloc failed\n");
80108143:	83 ec 0c             	sub    $0xc,%esp
80108146:	68 ad 8c 10 80       	push   $0x80108cad
8010814b:	e8 40 82 ff ff       	call   80100390 <panic>
