
_ass3Tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	}
	free(arr);
}


int main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
//   globalTest();			//for testing each policy efficiency
  swap_test();
  11:	e8 0a 00 00 00       	call   20 <swap_test>
  seg_fault_test();
  16:	e8 05 02 00 00       	call   220 <seg_fault_test>
  exit();
  1b:	e8 52 05 00 00       	call   572 <exit>

00000020 <swap_test>:
void swap_test(){
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	57                   	push   %edi
  24:	56                   	push   %esi
  25:	53                   	push   %ebx
  26:	83 ec 24             	sub    $0x24,%esp
  printf(1, "==================================\n");
  29:	68 98 0a 00 00       	push   $0xa98
  2e:	6a 01                	push   $0x1
  30:	e8 8b 06 00 00       	call   6c0 <printf>
  printf(1, "Started swap and cow test\n\n");
  35:	58                   	pop    %eax
  36:	5a                   	pop    %edx
  37:	68 28 0a 00 00       	push   $0xa28
  3c:	6a 01                	push   $0x1
  3e:	e8 7d 06 00 00       	call   6c0 <printf>
  buffer = malloc (BUFF_SIZE);
  43:	c7 04 24 00 f0 01 00 	movl   $0x1f000,(%esp)
  4a:	e8 d1 08 00 00       	call   920 <malloc>
  4f:	8d b0 7c ec 01 00    	lea    0x1ec7c(%eax),%esi
  55:	89 c3                	mov    %eax,%ebx
  57:	8d 80 ae ec 01 00    	lea    0x1ecae(%eax),%eax
  5d:	83 c4 10             	add    $0x10,%esp
  60:	89 f2                	mov    %esi,%edx
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buffer[j1 + i] = '1';
  68:	c6 02 31             	movb   $0x31,(%edx)
    buffer[j2 + i] = '2';
  6b:	c6 42 64 32          	movb   $0x32,0x64(%edx)
  6f:	83 c2 01             	add    $0x1,%edx
  for (i = 0; i < 50; i++) { 
  72:	39 d0                	cmp    %edx,%eax
  74:	75 f2                	jne    68 <swap_test+0x48>
  buffer[j1 + i] = 0;
  76:	c6 83 ae ec 01 00 00 	movb   $0x0,0x1ecae(%ebx)
  buffer[j2 + i] = 0;
  7d:	c6 83 12 ed 01 00 00 	movb   $0x0,0x1ed12(%ebx)
  84:	8d bb e0 ec 01 00    	lea    0x1ece0(%ebx),%edi
  8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if (fork() == 0) {
  8d:	e8 d8 04 00 00       	call   56a <fork>
  92:	85 c0                	test   %eax,%eax
  94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  97:	0f 84 ba 00 00 00    	je     157 <swap_test+0x137>
    wait();
  9d:	e8 d8 04 00 00       	call   57a <wait>
    if (strcmp(&buffer[j1], expected_res_parent_1)) {
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	68 4c 0b 00 00       	push   $0xb4c
  aa:	56                   	push   %esi
  ab:	e8 a0 02 00 00       	call   350 <strcmp>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	85 c0                	test   %eax,%eax
  b5:	75 6a                	jne    121 <swap_test+0x101>
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 80 0b 00 00       	push   $0xb80
  bf:	57                   	push   %edi
  c0:	e8 8b 02 00 00       	call   350 <strcmp>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	85 c0                	test   %eax,%eax
    printf(1, "parent result: %s\n", res ? "success" : "failure");
  ca:	ba 18 0a 00 00       	mov    $0xa18,%edx
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
  cf:	75 2e                	jne    ff <swap_test+0xdf>
    printf(1, "parent result: %s\n", res ? "success" : "failure");
  d1:	83 ec 04             	sub    $0x4,%esp
  d4:	52                   	push   %edx
  d5:	68 56 0a 00 00       	push   $0xa56
  da:	6a 01                	push   $0x1
  dc:	e8 df 05 00 00       	call   6c0 <printf>
    free(buffer);
  e1:	89 1c 24             	mov    %ebx,(%esp)
  e4:	e8 a7 07 00 00       	call   890 <free>
  printf(1, "==================================\n");
  e9:	5a                   	pop    %edx
  ea:	59                   	pop    %ecx
  eb:	68 98 0a 00 00       	push   $0xa98
  f0:	6a 01                	push   $0x1
  f2:	e8 c9 05 00 00       	call   6c0 <printf>
}
  f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  fa:	5b                   	pop    %ebx
  fb:	5e                   	pop    %esi
  fc:	5f                   	pop    %edi
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    
      printf(1, "parent failure:\nexpected: %s\nactual: %s\n", expected_res_parent_2, &buffer[45200]);
  ff:	8d 83 90 b0 00 00    	lea    0xb090(%ebx),%eax
 105:	50                   	push   %eax
 106:	68 80 0b 00 00       	push   $0xb80
 10b:	68 b4 0b 00 00       	push   $0xbb4
 110:	6a 01                	push   $0x1
 112:	e8 a9 05 00 00       	call   6c0 <printf>
 117:	83 c4 10             	add    $0x10,%esp
    printf(1, "parent result: %s\n", res ? "success" : "failure");
 11a:	ba 20 0a 00 00       	mov    $0xa20,%edx
 11f:	eb b0                	jmp    d1 <swap_test+0xb1>
      printf(1, "parent failure:\nexpected: %s\nactual: %s\n", expected_res_parent_1, &buffer[49100]);
 121:	8d 83 cc bf 00 00    	lea    0xbfcc(%ebx),%eax
 127:	50                   	push   %eax
 128:	68 4c 0b 00 00       	push   $0xb4c
 12d:	68 b4 0b 00 00       	push   $0xbb4
 132:	6a 01                	push   $0x1
 134:	e8 87 05 00 00       	call   6c0 <printf>
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
 139:	5e                   	pop    %esi
 13a:	58                   	pop    %eax
 13b:	68 80 0b 00 00       	push   $0xb80
 140:	57                   	push   %edi
 141:	e8 0a 02 00 00       	call   350 <strcmp>
 146:	83 c4 10             	add    $0x10,%esp
 149:	85 c0                	test   %eax,%eax
 14b:	75 b2                	jne    ff <swap_test+0xdf>
    printf(1, "parent result: %s\n", res ? "success" : "failure");
 14d:	ba 20 0a 00 00       	mov    $0xa20,%edx
 152:	e9 7a ff ff ff       	jmp    d1 <swap_test+0xb1>
 157:	8d 83 a4 ec 01 00    	lea    0x1eca4(%ebx),%eax
	    buffer[j1 + i] = '3';
 15d:	c6 00 33             	movb   $0x33,(%eax)
	    buffer[j2 + i] = '4';
 160:	c6 40 64 34          	movb   $0x34,0x64(%eax)
 164:	83 c0 01             	add    $0x1,%eax
    for (i = 40; i < 50; i++) { 
 167:	39 c2                	cmp    %eax,%edx
 169:	75 f2                	jne    15d <swap_test+0x13d>
    if (strcmp(&buffer[j1], expected_res_child_1)) {
 16b:	50                   	push   %eax
 16c:	50                   	push   %eax
 16d:	68 bc 0a 00 00       	push   $0xabc
 172:	56                   	push   %esi
 173:	e8 d8 01 00 00       	call   350 <strcmp>
 178:	83 c4 10             	add    $0x10,%esp
 17b:	85 c0                	test   %eax,%eax
 17d:	75 38                	jne    1b7 <swap_test+0x197>
    if (strcmp(&buffer[j2], expected_res_child_2)) {
 17f:	50                   	push   %eax
 180:	50                   	push   %eax
 181:	68 18 0b 00 00       	push   $0xb18
 186:	57                   	push   %edi
 187:	e8 c4 01 00 00       	call   350 <strcmp>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	85 c0                	test   %eax,%eax
 191:	75 63                	jne    1f6 <swap_test+0x1d6>
    free(buffer);
 193:	83 ec 0c             	sub    $0xc,%esp
 196:	53                   	push   %ebx
 197:	e8 f4 06 00 00       	call   890 <free>
 19c:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 19f:	b8 18 0a 00 00       	mov    $0xa18,%eax
 1a4:	52                   	push   %edx
 1a5:	50                   	push   %eax
 1a6:	68 44 0a 00 00       	push   $0xa44
 1ab:	6a 01                	push   $0x1
 1ad:	e8 0e 05 00 00       	call   6c0 <printf>
    exit();
 1b2:	e8 bb 03 00 00       	call   572 <exit>
      printf(1, "child failure:\nexpected: %s\nactual: %s\n", expected_res_child_1, &buffer[49100]);
 1b7:	8d 83 cc bf 00 00    	lea    0xbfcc(%ebx),%eax
 1bd:	50                   	push   %eax
 1be:	68 bc 0a 00 00       	push   $0xabc
 1c3:	68 f0 0a 00 00       	push   $0xaf0
 1c8:	6a 01                	push   $0x1
 1ca:	e8 f1 04 00 00       	call   6c0 <printf>
    if (strcmp(&buffer[j2], expected_res_child_2)) {
 1cf:	59                   	pop    %ecx
 1d0:	5e                   	pop    %esi
 1d1:	68 18 0b 00 00       	push   $0xb18
 1d6:	57                   	push   %edi
 1d7:	e8 74 01 00 00       	call   350 <strcmp>
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	85 c0                	test   %eax,%eax
 1e1:	75 13                	jne    1f6 <swap_test+0x1d6>
    free(buffer);
 1e3:	83 ec 0c             	sub    $0xc,%esp
 1e6:	53                   	push   %ebx
 1e7:	e8 a4 06 00 00       	call   890 <free>
 1ec:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 1ef:	b8 20 0a 00 00       	mov    $0xa20,%eax
 1f4:	eb ae                	jmp    1a4 <swap_test+0x184>
      printf(1, "child failure:\nexpected: %s\nactual: %s\n", expected_res_child_2, &buffer[45200]);
 1f6:	8d 83 90 b0 00 00    	lea    0xb090(%ebx),%eax
 1fc:	50                   	push   %eax
 1fd:	68 18 0b 00 00       	push   $0xb18
 202:	68 f0 0a 00 00       	push   $0xaf0
 207:	6a 01                	push   $0x1
 209:	e8 b2 04 00 00       	call   6c0 <printf>
    free(buffer);
 20e:	89 1c 24             	mov    %ebx,(%esp)
 211:	e8 7a 06 00 00       	call   890 <free>
 216:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 219:	b8 20 0a 00 00       	mov    $0xa20,%eax
 21e:	eb 84                	jmp    1a4 <swap_test+0x184>

00000220 <seg_fault_test>:
void seg_fault_test(){
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "==================================\n");
 227:	68 98 0a 00 00       	push   $0xa98
 22c:	6a 01                	push   $0x1
 22e:	e8 8d 04 00 00       	call   6c0 <printf>
  printf(1, "Started seg fault test\n\n");
 233:	58                   	pop    %eax
 234:	5a                   	pop    %edx
 235:	68 69 0a 00 00       	push   $0xa69
 23a:	6a 01                	push   $0x1
 23c:	e8 7f 04 00 00       	call   6c0 <printf>
  buffer = malloc (BUFF_SIZE);
 241:	c7 04 24 00 f0 01 00 	movl   $0x1f000,(%esp)
 248:	e8 d3 06 00 00       	call   920 <malloc>
  printf(1, "should panic now...\n");
 24d:	59                   	pop    %ecx
  buffer = malloc (BUFF_SIZE);
 24e:	89 c3                	mov    %eax,%ebx
  printf(1, "should panic now...\n");
 250:	58                   	pop    %eax
 251:	68 82 0a 00 00       	push   $0xa82
 256:	6a 01                	push   $0x1
 258:	e8 63 04 00 00       	call   6c0 <printf>
  buffer[BUFF_SIZE + PGSIZE] = '5';
 25d:	c6 83 00 00 02 00 35 	movb   $0x35,0x20000(%ebx)
  printf(1, "test failed! should panic seg fault\n");
 264:	58                   	pop    %eax
 265:	5a                   	pop    %edx
 266:	68 e0 0b 00 00       	push   $0xbe0
 26b:	6a 01                	push   $0x1
 26d:	e8 4e 04 00 00       	call   6c0 <printf>
  printf(1, "==================================\n");
 272:	59                   	pop    %ecx
 273:	5b                   	pop    %ebx
 274:	68 98 0a 00 00       	push   $0xa98
 279:	6a 01                	push   $0x1
 27b:	e8 40 04 00 00       	call   6c0 <printf>
}
 280:	83 c4 10             	add    $0x10,%esp
 283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 286:	c9                   	leave  
 287:	c3                   	ret    
 288:	90                   	nop
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <getRandNum>:
  next = next * 1103515245 + 12341;
 290:	69 05 50 0f 00 00 6d 	imul   $0x41c64e6d,0xf50,%eax
 297:	4e c6 41 
int getRandNum() {
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
}
 29d:	5d                   	pop    %ebp
  next = next * 1103515245 + 12341;
 29e:	05 35 30 00 00       	add    $0x3035,%eax
 2a3:	a3 50 0f 00 00       	mov    %eax,0xf50
  return (unsigned int)(next/65536) % BUFF_SIZE;
 2a8:	c1 e8 10             	shr    $0x10,%eax
}
 2ab:	c3                   	ret    
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <globalTest>:
void globalTest(){
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	56                   	push   %esi
 2b4:	53                   	push   %ebx
	arr = malloc(BUFF_SIZE); //allocates 14 pages (sums to 17 - to allow more then one swapping in scfifo)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	68 00 f0 01 00       	push   $0x1f000
 2bd:	e8 5e 06 00 00       	call   920 <malloc>
 2c2:	8b 15 50 0f 00 00    	mov    0xf50,%edx
 2c8:	89 c3                	mov    %eax,%ebx
 2ca:	83 c4 10             	add    $0x10,%esp
 2cd:	b8 f4 01 00 00       	mov    $0x1f4,%eax
 2d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  next = next * 1103515245 + 12341;
 2d8:	69 d2 6d 4e c6 41    	imul   $0x41c64e6d,%edx,%edx
 2de:	81 c2 35 30 00 00    	add    $0x3035,%edx
  return (unsigned int)(next/65536) % BUFF_SIZE;
 2e4:	89 d1                	mov    %edx,%ecx
 2e6:	c1 e9 10             	shr    $0x10,%ecx
		while (PGSIZE*10-8 < randNum && randNum < PGSIZE*10+PGSIZE/2-8)
 2e9:	8d b1 07 60 ff ff    	lea    -0x9ff9(%ecx),%esi
 2ef:	81 fe fe 07 00 00    	cmp    $0x7fe,%esi
 2f5:	76 e1                	jbe    2d8 <globalTest+0x28>
	for (i = 0; i < TEST_POOL; i++) {
 2f7:	83 e8 01             	sub    $0x1,%eax
		arr[randNum] = 'X';				//write to memory
 2fa:	c6 04 0b 58          	movb   $0x58,(%ebx,%ecx,1)
	for (i = 0; i < TEST_POOL; i++) {
 2fe:	75 d8                	jne    2d8 <globalTest+0x28>
	free(arr);
 300:	83 ec 0c             	sub    $0xc,%esp
 303:	89 15 50 0f 00 00    	mov    %edx,0xf50
 309:	53                   	push   %ebx
 30a:	e8 81 05 00 00       	call   890 <free>
}
 30f:	83 c4 10             	add    $0x10,%esp
 312:	8d 65 f8             	lea    -0x8(%ebp),%esp
 315:	5b                   	pop    %ebx
 316:	5e                   	pop    %esi
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 32a:	89 c2                	mov    %eax,%edx
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 330:	83 c1 01             	add    $0x1,%ecx
 333:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 337:	83 c2 01             	add    $0x1,%edx
 33a:	84 db                	test   %bl,%bl
 33c:	88 5a ff             	mov    %bl,-0x1(%edx)
 33f:	75 ef                	jne    330 <strcpy+0x10>
    ;
  return os;
}
 341:	5b                   	pop    %ebx
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    
 344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 34a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000350 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 35a:	0f b6 02             	movzbl (%edx),%eax
 35d:	0f b6 19             	movzbl (%ecx),%ebx
 360:	84 c0                	test   %al,%al
 362:	75 1c                	jne    380 <strcmp+0x30>
 364:	eb 2a                	jmp    390 <strcmp+0x40>
 366:	8d 76 00             	lea    0x0(%esi),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 370:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 373:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 376:	83 c1 01             	add    $0x1,%ecx
 379:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 37c:	84 c0                	test   %al,%al
 37e:	74 10                	je     390 <strcmp+0x40>
 380:	38 d8                	cmp    %bl,%al
 382:	74 ec                	je     370 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 384:	29 d8                	sub    %ebx,%eax
}
 386:	5b                   	pop    %ebx
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 392:	29 d8                	sub    %ebx,%eax
}
 394:	5b                   	pop    %ebx
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	89 f6                	mov    %esi,%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3a6:	80 39 00             	cmpb   $0x0,(%ecx)
 3a9:	74 15                	je     3c0 <strlen+0x20>
 3ab:	31 d2                	xor    %edx,%edx
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
 3b0:	83 c2 01             	add    $0x1,%edx
 3b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3b7:	89 d0                	mov    %edx,%eax
 3b9:	75 f5                	jne    3b0 <strlen+0x10>
    ;
  return n;
}
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3c0:	31 c0                	xor    %eax,%eax
}
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld    
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	5f                   	pop    %edi
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	74 1d                	je     41e <strchr+0x2e>
    if(*s == c)
 401:	38 d3                	cmp    %dl,%bl
 403:	89 d9                	mov    %ebx,%ecx
 405:	75 0d                	jne    414 <strchr+0x24>
 407:	eb 17                	jmp    420 <strchr+0x30>
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 410:	38 ca                	cmp    %cl,%dl
 412:	74 0c                	je     420 <strchr+0x30>
  for(; *s; s++)
 414:	83 c0 01             	add    $0x1,%eax
 417:	0f b6 10             	movzbl (%eax),%edx
 41a:	84 d2                	test   %dl,%dl
 41c:	75 f2                	jne    410 <strchr+0x20>
      return (char*)s;
  return 0;
 41e:	31 c0                	xor    %eax,%eax
}
 420:	5b                   	pop    %ebx
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    
 423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 436:	31 f6                	xor    %esi,%esi
 438:	89 f3                	mov    %esi,%ebx
{
 43a:	83 ec 1c             	sub    $0x1c,%esp
 43d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 440:	eb 2f                	jmp    471 <gets+0x41>
 442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 448:	8d 45 e7             	lea    -0x19(%ebp),%eax
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	6a 01                	push   $0x1
 450:	50                   	push   %eax
 451:	6a 00                	push   $0x0
 453:	e8 32 01 00 00       	call   58a <read>
    if(cc < 1)
 458:	83 c4 10             	add    $0x10,%esp
 45b:	85 c0                	test   %eax,%eax
 45d:	7e 1c                	jle    47b <gets+0x4b>
      break;
    buf[i++] = c;
 45f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 463:	83 c7 01             	add    $0x1,%edi
 466:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 469:	3c 0a                	cmp    $0xa,%al
 46b:	74 23                	je     490 <gets+0x60>
 46d:	3c 0d                	cmp    $0xd,%al
 46f:	74 1f                	je     490 <gets+0x60>
  for(i=0; i+1 < max; ){
 471:	83 c3 01             	add    $0x1,%ebx
 474:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 477:	89 fe                	mov    %edi,%esi
 479:	7c cd                	jl     448 <gets+0x18>
 47b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 480:	c6 03 00             	movb   $0x0,(%ebx)
}
 483:	8d 65 f4             	lea    -0xc(%ebp),%esp
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5f                   	pop    %edi
 489:	5d                   	pop    %ebp
 48a:	c3                   	ret    
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	8b 75 08             	mov    0x8(%ebp),%esi
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	01 de                	add    %ebx,%esi
 498:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 49a:	c6 03 00             	movb   $0x0,(%ebx)
}
 49d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    
 4a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	56                   	push   %esi
 4b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	6a 00                	push   $0x0
 4ba:	ff 75 08             	pushl  0x8(%ebp)
 4bd:	e8 f0 00 00 00       	call   5b2 <open>
  if(fd < 0)
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	85 c0                	test   %eax,%eax
 4c7:	78 27                	js     4f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	pushl  0xc(%ebp)
 4cf:	89 c3                	mov    %eax,%ebx
 4d1:	50                   	push   %eax
 4d2:	e8 f3 00 00 00       	call   5ca <fstat>
  close(fd);
 4d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4da:	89 c6                	mov    %eax,%esi
  close(fd);
 4dc:	e8 b9 00 00 00       	call   59a <close>
  return r;
 4e1:	83 c4 10             	add    $0x10,%esp
}
 4e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4e7:	89 f0                	mov    %esi,%eax
 4e9:	5b                   	pop    %ebx
 4ea:	5e                   	pop    %esi
 4eb:	5d                   	pop    %ebp
 4ec:	c3                   	ret    
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4f5:	eb ed                	jmp    4e4 <stat+0x34>
 4f7:	89 f6                	mov    %esi,%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000500 <atoi>:

int
atoi(const char *s)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 507:	0f be 11             	movsbl (%ecx),%edx
 50a:	8d 42 d0             	lea    -0x30(%edx),%eax
 50d:	3c 09                	cmp    $0x9,%al
  n = 0;
 50f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 514:	77 1f                	ja     535 <atoi+0x35>
 516:	8d 76 00             	lea    0x0(%esi),%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 520:	8d 04 80             	lea    (%eax,%eax,4),%eax
 523:	83 c1 01             	add    $0x1,%ecx
 526:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 52a:	0f be 11             	movsbl (%ecx),%edx
 52d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 530:	80 fb 09             	cmp    $0x9,%bl
 533:	76 eb                	jbe    520 <atoi+0x20>
  return n;
}
 535:	5b                   	pop    %ebx
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
 538:	90                   	nop
 539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000540 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
 545:	8b 5d 10             	mov    0x10(%ebp),%ebx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 54e:	85 db                	test   %ebx,%ebx
 550:	7e 14                	jle    566 <memmove+0x26>
 552:	31 d2                	xor    %edx,%edx
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 558:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 55c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 55f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 562:	39 d3                	cmp    %edx,%ebx
 564:	75 f2                	jne    558 <memmove+0x18>
  return vdst;
}
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5d                   	pop    %ebp
 569:	c3                   	ret    

0000056a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 56a:	b8 01 00 00 00       	mov    $0x1,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <exit>:
SYSCALL(exit)
 572:	b8 02 00 00 00       	mov    $0x2,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <wait>:
SYSCALL(wait)
 57a:	b8 03 00 00 00       	mov    $0x3,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <pipe>:
SYSCALL(pipe)
 582:	b8 04 00 00 00       	mov    $0x4,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <read>:
SYSCALL(read)
 58a:	b8 05 00 00 00       	mov    $0x5,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <write>:
SYSCALL(write)
 592:	b8 10 00 00 00       	mov    $0x10,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <close>:
SYSCALL(close)
 59a:	b8 15 00 00 00       	mov    $0x15,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <kill>:
SYSCALL(kill)
 5a2:	b8 06 00 00 00       	mov    $0x6,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <exec>:
SYSCALL(exec)
 5aa:	b8 07 00 00 00       	mov    $0x7,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <open>:
SYSCALL(open)
 5b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mknod>:
SYSCALL(mknod)
 5ba:	b8 11 00 00 00       	mov    $0x11,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <unlink>:
SYSCALL(unlink)
 5c2:	b8 12 00 00 00       	mov    $0x12,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <fstat>:
SYSCALL(fstat)
 5ca:	b8 08 00 00 00       	mov    $0x8,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <link>:
SYSCALL(link)
 5d2:	b8 13 00 00 00       	mov    $0x13,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mkdir>:
SYSCALL(mkdir)
 5da:	b8 14 00 00 00       	mov    $0x14,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <chdir>:
SYSCALL(chdir)
 5e2:	b8 09 00 00 00       	mov    $0x9,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <dup>:
SYSCALL(dup)
 5ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <getpid>:
SYSCALL(getpid)
 5f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <sbrk>:
SYSCALL(sbrk)
 5fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <sleep>:
SYSCALL(sleep)
 602:	b8 0d 00 00 00       	mov    $0xd,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <uptime>:
SYSCALL(uptime)
 60a:	b8 0e 00 00 00       	mov    $0xe,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    
 612:	66 90                	xchg   %ax,%ax
 614:	66 90                	xchg   %ax,%ax
 616:	66 90                	xchg   %ax,%ax
 618:	66 90                	xchg   %ax,%ax
 61a:	66 90                	xchg   %ax,%ax
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 629:	85 d2                	test   %edx,%edx
{
 62b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 62e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 630:	79 76                	jns    6a8 <printint+0x88>
 632:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 636:	74 70                	je     6a8 <printint+0x88>
    x = -xx;
 638:	f7 d8                	neg    %eax
    neg = 1;
 63a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 641:	31 f6                	xor    %esi,%esi
 643:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 646:	eb 0a                	jmp    652 <printint+0x32>
 648:	90                   	nop
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 650:	89 fe                	mov    %edi,%esi
 652:	31 d2                	xor    %edx,%edx
 654:	8d 7e 01             	lea    0x1(%esi),%edi
 657:	f7 f1                	div    %ecx
 659:	0f b6 92 10 0c 00 00 	movzbl 0xc10(%edx),%edx
  }while((x /= base) != 0);
 660:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 662:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 665:	75 e9                	jne    650 <printint+0x30>
  if(neg)
 667:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 66a:	85 c0                	test   %eax,%eax
 66c:	74 08                	je     676 <printint+0x56>
    buf[i++] = '-';
 66e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 673:	8d 7e 02             	lea    0x2(%esi),%edi
 676:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 67a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
 680:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 683:	83 ec 04             	sub    $0x4,%esp
 686:	83 ee 01             	sub    $0x1,%esi
 689:	6a 01                	push   $0x1
 68b:	53                   	push   %ebx
 68c:	57                   	push   %edi
 68d:	88 45 d7             	mov    %al,-0x29(%ebp)
 690:	e8 fd fe ff ff       	call   592 <write>

  while(--i >= 0)
 695:	83 c4 10             	add    $0x10,%esp
 698:	39 de                	cmp    %ebx,%esi
 69a:	75 e4                	jne    680 <printint+0x60>
    putc(fd, buf[i]);
}
 69c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6af:	eb 90                	jmp    641 <printint+0x21>
 6b1:	eb 0d                	jmp    6c0 <printf>
 6b3:	90                   	nop
 6b4:	90                   	nop
 6b5:	90                   	nop
 6b6:	90                   	nop
 6b7:	90                   	nop
 6b8:	90                   	nop
 6b9:	90                   	nop
 6ba:	90                   	nop
 6bb:	90                   	nop
 6bc:	90                   	nop
 6bd:	90                   	nop
 6be:	90                   	nop
 6bf:	90                   	nop

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	8b 75 0c             	mov    0xc(%ebp),%esi
 6cc:	0f b6 1e             	movzbl (%esi),%ebx
 6cf:	84 db                	test   %bl,%bl
 6d1:	0f 84 b3 00 00 00    	je     78a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 6d7:	8d 45 10             	lea    0x10(%ebp),%eax
 6da:	83 c6 01             	add    $0x1,%esi
  state = 0;
 6dd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 6df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6e2:	eb 2f                	jmp    713 <printf+0x53>
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6e8:	83 f8 25             	cmp    $0x25,%eax
 6eb:	0f 84 a7 00 00 00    	je     798 <printf+0xd8>
  write(fd, &c, 1);
 6f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6f4:	83 ec 04             	sub    $0x4,%esp
 6f7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 6fa:	6a 01                	push   $0x1
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 8d fe ff ff       	call   592 <write>
 705:	83 c4 10             	add    $0x10,%esp
 708:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 70b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 70f:	84 db                	test   %bl,%bl
 711:	74 77                	je     78a <printf+0xca>
    if(state == 0){
 713:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 715:	0f be cb             	movsbl %bl,%ecx
 718:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 71b:	74 cb                	je     6e8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71d:	83 ff 25             	cmp    $0x25,%edi
 720:	75 e6                	jne    708 <printf+0x48>
      if(c == 'd'){
 722:	83 f8 64             	cmp    $0x64,%eax
 725:	0f 84 05 01 00 00    	je     830 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 72b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 731:	83 f9 70             	cmp    $0x70,%ecx
 734:	74 72                	je     7a8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 736:	83 f8 73             	cmp    $0x73,%eax
 739:	0f 84 99 00 00 00    	je     7d8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 73f:	83 f8 63             	cmp    $0x63,%eax
 742:	0f 84 08 01 00 00    	je     850 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	0f 84 ef 00 00 00    	je     840 <printf+0x180>
  write(fd, &c, 1);
 751:	8d 45 e7             	lea    -0x19(%ebp),%eax
 754:	83 ec 04             	sub    $0x4,%esp
 757:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 75b:	6a 01                	push   $0x1
 75d:	50                   	push   %eax
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 2c fe ff ff       	call   592 <write>
 766:	83 c4 0c             	add    $0xc,%esp
 769:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 76c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 76f:	6a 01                	push   $0x1
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 778:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 77a:	e8 13 fe ff ff       	call   592 <write>
  for(i = 0; fmt[i]; i++){
 77f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 783:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 786:	84 db                	test   %bl,%bl
 788:	75 89                	jne    713 <printf+0x53>
    }
  }
}
 78a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78d:	5b                   	pop    %ebx
 78e:	5e                   	pop    %esi
 78f:	5f                   	pop    %edi
 790:	5d                   	pop    %ebp
 791:	c3                   	ret    
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 798:	bf 25 00 00 00       	mov    $0x25,%edi
 79d:	e9 66 ff ff ff       	jmp    708 <printf+0x48>
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7a8:	83 ec 0c             	sub    $0xc,%esp
 7ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 7b0:	6a 00                	push   $0x0
 7b2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	8b 17                	mov    (%edi),%edx
 7ba:	e8 61 fe ff ff       	call   620 <printint>
        ap++;
 7bf:	89 f8                	mov    %edi,%eax
 7c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c4:	31 ff                	xor    %edi,%edi
        ap++;
 7c6:	83 c0 04             	add    $0x4,%eax
 7c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7cc:	e9 37 ff ff ff       	jmp    708 <printf+0x48>
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7db:	8b 08                	mov    (%eax),%ecx
        ap++;
 7dd:	83 c0 04             	add    $0x4,%eax
 7e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 7e3:	85 c9                	test   %ecx,%ecx
 7e5:	0f 84 8e 00 00 00    	je     879 <printf+0x1b9>
        while(*s != 0){
 7eb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 7ee:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 7f0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 7f2:	84 c0                	test   %al,%al
 7f4:	0f 84 0e ff ff ff    	je     708 <printf+0x48>
 7fa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 7fd:	89 de                	mov    %ebx,%esi
 7ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 802:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 805:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 808:	83 ec 04             	sub    $0x4,%esp
          s++;
 80b:	83 c6 01             	add    $0x1,%esi
 80e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 811:	6a 01                	push   $0x1
 813:	57                   	push   %edi
 814:	53                   	push   %ebx
 815:	e8 78 fd ff ff       	call   592 <write>
        while(*s != 0){
 81a:	0f b6 06             	movzbl (%esi),%eax
 81d:	83 c4 10             	add    $0x10,%esp
 820:	84 c0                	test   %al,%al
 822:	75 e4                	jne    808 <printf+0x148>
 824:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 827:	31 ff                	xor    %edi,%edi
 829:	e9 da fe ff ff       	jmp    708 <printf+0x48>
 82e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	b9 0a 00 00 00       	mov    $0xa,%ecx
 838:	6a 01                	push   $0x1
 83a:	e9 73 ff ff ff       	jmp    7b2 <printf+0xf2>
 83f:	90                   	nop
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
 843:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 846:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 849:	6a 01                	push   $0x1
 84b:	e9 21 ff ff ff       	jmp    771 <printf+0xb1>
        putc(fd, *ap);
 850:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 853:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 856:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 858:	6a 01                	push   $0x1
        ap++;
 85a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 85d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 860:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 863:	50                   	push   %eax
 864:	ff 75 08             	pushl  0x8(%ebp)
 867:	e8 26 fd ff ff       	call   592 <write>
        ap++;
 86c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 86f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 872:	31 ff                	xor    %edi,%edi
 874:	e9 8f fe ff ff       	jmp    708 <printf+0x48>
          s = "(null)";
 879:	bb 08 0c 00 00       	mov    $0xc08,%ebx
        while(*s != 0){
 87e:	b8 28 00 00 00       	mov    $0x28,%eax
 883:	e9 72 ff ff ff       	jmp    7fa <printf+0x13a>
 888:	66 90                	xchg   %ax,%ax
 88a:	66 90                	xchg   %ax,%ax
 88c:	66 90                	xchg   %ax,%ax
 88e:	66 90                	xchg   %ax,%ax

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	a1 54 0f 00 00       	mov    0xf54,%eax
{
 896:	89 e5                	mov    %esp,%ebp
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	53                   	push   %ebx
 89b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 89e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	39 c8                	cmp    %ecx,%eax
 8aa:	8b 10                	mov    (%eax),%edx
 8ac:	73 32                	jae    8e0 <free+0x50>
 8ae:	39 d1                	cmp    %edx,%ecx
 8b0:	72 04                	jb     8b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	39 d0                	cmp    %edx,%eax
 8b4:	72 32                	jb     8e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8bc:	39 fa                	cmp    %edi,%edx
 8be:	74 30                	je     8f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8c3:	8b 50 04             	mov    0x4(%eax),%edx
 8c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8c9:	39 f1                	cmp    %esi,%ecx
 8cb:	74 3a                	je     907 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8cd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8cf:	a3 54 0f 00 00       	mov    %eax,0xf54
}
 8d4:	5b                   	pop    %ebx
 8d5:	5e                   	pop    %esi
 8d6:	5f                   	pop    %edi
 8d7:	5d                   	pop    %ebp
 8d8:	c3                   	ret    
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 04                	jb     8e8 <free+0x58>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	72 ce                	jb     8b6 <free+0x26>
{
 8e8:	89 d0                	mov    %edx,%eax
 8ea:	eb bc                	jmp    8a8 <free+0x18>
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 8f0:	03 72 04             	add    0x4(%edx),%esi
 8f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	8b 10                	mov    (%eax),%edx
 8f8:	8b 12                	mov    (%edx),%edx
 8fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	75 c6                	jne    8cd <free+0x3d>
    p->s.size += bp->s.size;
 907:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 90a:	a3 54 0f 00 00       	mov    %eax,0xf54
    p->s.size += bp->s.size;
 90f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 912:	8b 53 f8             	mov    -0x8(%ebx),%edx
 915:	89 10                	mov    %edx,(%eax)
}
 917:	5b                   	pop    %ebx
 918:	5e                   	pop    %esi
 919:	5f                   	pop    %edi
 91a:	5d                   	pop    %ebp
 91b:	c3                   	ret    
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	57                   	push   %edi
 924:	56                   	push   %esi
 925:	53                   	push   %ebx
 926:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 92c:	8b 15 54 0f 00 00    	mov    0xf54,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 932:	8d 78 07             	lea    0x7(%eax),%edi
 935:	c1 ef 03             	shr    $0x3,%edi
 938:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 93b:	85 d2                	test   %edx,%edx
 93d:	0f 84 9d 00 00 00    	je     9e0 <malloc+0xc0>
 943:	8b 02                	mov    (%edx),%eax
 945:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 948:	39 cf                	cmp    %ecx,%edi
 94a:	76 6c                	jbe    9b8 <malloc+0x98>
 94c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 952:	bb 00 10 00 00       	mov    $0x1000,%ebx
 957:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 95a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 961:	eb 0e                	jmp    971 <malloc+0x51>
 963:	90                   	nop
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 96a:	8b 48 04             	mov    0x4(%eax),%ecx
 96d:	39 f9                	cmp    %edi,%ecx
 96f:	73 47                	jae    9b8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 971:	39 05 54 0f 00 00    	cmp    %eax,0xf54
 977:	89 c2                	mov    %eax,%edx
 979:	75 ed                	jne    968 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 97b:	83 ec 0c             	sub    $0xc,%esp
 97e:	56                   	push   %esi
 97f:	e8 76 fc ff ff       	call   5fa <sbrk>
  if(p == (char*)-1)
 984:	83 c4 10             	add    $0x10,%esp
 987:	83 f8 ff             	cmp    $0xffffffff,%eax
 98a:	74 1c                	je     9a8 <malloc+0x88>
  hp->s.size = nu;
 98c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 98f:	83 ec 0c             	sub    $0xc,%esp
 992:	83 c0 08             	add    $0x8,%eax
 995:	50                   	push   %eax
 996:	e8 f5 fe ff ff       	call   890 <free>
  return freep;
 99b:	8b 15 54 0f 00 00    	mov    0xf54,%edx
      if((p = morecore(nunits)) == 0)
 9a1:	83 c4 10             	add    $0x10,%esp
 9a4:	85 d2                	test   %edx,%edx
 9a6:	75 c0                	jne    968 <malloc+0x48>
        return 0;
  }
}
 9a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9ab:	31 c0                	xor    %eax,%eax
}
 9ad:	5b                   	pop    %ebx
 9ae:	5e                   	pop    %esi
 9af:	5f                   	pop    %edi
 9b0:	5d                   	pop    %ebp
 9b1:	c3                   	ret    
 9b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9b8:	39 cf                	cmp    %ecx,%edi
 9ba:	74 54                	je     a10 <malloc+0xf0>
        p->s.size -= nunits;
 9bc:	29 f9                	sub    %edi,%ecx
 9be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9c4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9c7:	89 15 54 0f 00 00    	mov    %edx,0xf54
}
 9cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9d0:	83 c0 08             	add    $0x8,%eax
}
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	c3                   	ret    
 9d8:	90                   	nop
 9d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 9e0:	c7 05 54 0f 00 00 58 	movl   $0xf58,0xf54
 9e7:	0f 00 00 
 9ea:	c7 05 58 0f 00 00 58 	movl   $0xf58,0xf58
 9f1:	0f 00 00 
    base.s.size = 0;
 9f4:	b8 58 0f 00 00       	mov    $0xf58,%eax
 9f9:	c7 05 5c 0f 00 00 00 	movl   $0x0,0xf5c
 a00:	00 00 00 
 a03:	e9 44 ff ff ff       	jmp    94c <malloc+0x2c>
 a08:	90                   	nop
 a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a10:	8b 08                	mov    (%eax),%ecx
 a12:	89 0a                	mov    %ecx,(%edx)
 a14:	eb b1                	jmp    9c7 <malloc+0xa7>
