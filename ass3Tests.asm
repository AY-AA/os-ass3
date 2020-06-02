
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
  11:	e8 6a 00 00 00       	call   80 <swap_test>
  seg_fault_test();
  16:	e8 95 02 00 00       	call   2b0 <seg_fault_test>
  exit();
  1b:	e8 e2 05 00 00       	call   602 <exit>

00000020 <test_number_of_pages>:
void test_number_of_pages(int expected) {
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	56                   	push   %esi
  24:	53                   	push   %ebx
  25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int actual = getNumberOfFreePages();
  28:	e8 75 06 00 00       	call   6a2 <getNumberOfFreePages>
  printf(1,"free pages test: ");
  2d:	83 ec 08             	sub    $0x8,%esp
  int actual = getNumberOfFreePages();
  30:	89 c6                	mov    %eax,%esi
  printf(1,"free pages test: ");
  32:	68 a8 0a 00 00       	push   $0xaa8
  37:	6a 01                	push   $0x1
  39:	e8 12 07 00 00       	call   750 <printf>
  if (actual == expected) {
  3e:	83 c4 10             	add    $0x10,%esp
  41:	39 de                	cmp    %ebx,%esi
  43:	74 1b                	je     60 <test_number_of_pages+0x40>
    printf(1, "failed\nexpected: %d\nactual: %d\n", expected, actual);
  45:	56                   	push   %esi
  46:	53                   	push   %ebx
  47:	68 54 0b 00 00       	push   $0xb54
  4c:	6a 01                	push   $0x1
  4e:	e8 fd 06 00 00       	call   750 <printf>
  53:	83 c4 10             	add    $0x10,%esp
}
  56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  59:	5b                   	pop    %ebx
  5a:	5e                   	pop    %esi
  5b:	5d                   	pop    %ebp
  5c:	c3                   	ret    
  5d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "success\n");
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 ba 0a 00 00       	push   $0xaba
  68:	6a 01                	push   $0x1
  6a:	e8 e1 06 00 00       	call   750 <printf>
  6f:	83 c4 10             	add    $0x10,%esp
}
  72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  75:	5b                   	pop    %ebx
  76:	5e                   	pop    %esi
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000080 <swap_test>:
void swap_test(){
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	57                   	push   %edi
  84:	56                   	push   %esi
  85:	53                   	push   %ebx
  86:	83 ec 1c             	sub    $0x1c,%esp
  int i, j1, j2, res = 1, expected_free_pages, num_of_free_pages = getNumberOfFreePages();
  89:	e8 14 06 00 00       	call   6a2 <getNumberOfFreePages>
  printf(1, "==================================\n");
  8e:	83 ec 08             	sub    $0x8,%esp
  int i, j1, j2, res = 1, expected_free_pages, num_of_free_pages = getNumberOfFreePages();
  91:	89 c3                	mov    %eax,%ebx
  printf(1, "==================================\n");
  93:	68 74 0b 00 00       	push   $0xb74
  98:	6a 01                	push   $0x1
  9a:	e8 b1 06 00 00       	call   750 <printf>
  printf(1, "Started swap and cow test\n\n");
  9f:	58                   	pop    %eax
  a0:	5a                   	pop    %edx
  a1:	68 d3 0a 00 00       	push   $0xad3
  a6:	6a 01                	push   $0x1
  a8:	e8 a3 06 00 00       	call   750 <printf>
  printf(1,"free pages: %d\n", num_of_free_pages);
  ad:	83 c4 0c             	add    $0xc,%esp
  b0:	53                   	push   %ebx
  b1:	68 ef 0a 00 00       	push   $0xaef
  b6:	6a 01                	push   $0x1
  b8:	e8 93 06 00 00       	call   750 <printf>
  expected_free_pages = num_of_free_pages - MAX_PSYC_PAGES + IGNORE_PGS;
  bd:	8d 43 f2             	lea    -0xe(%ebx),%eax
  buffer = malloc (BUFF_SIZE);
  c0:	c7 04 24 00 d0 01 00 	movl   $0x1d000,(%esp)
  expected_free_pages = num_of_free_pages - MAX_PSYC_PAGES + IGNORE_PGS;
  c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  buffer = malloc (BUFF_SIZE);
  ca:	e8 e1 08 00 00       	call   9b0 <malloc>
  cf:	8d b0 7c cc 01 00    	lea    0x1cc7c(%eax),%esi
  d5:	89 c3                	mov    %eax,%ebx
  d7:	8d 80 ae cc 01 00    	lea    0x1ccae(%eax),%eax
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	89 f2                	mov    %esi,%edx
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buffer[j1 + i] = '1';
  e8:	c6 02 31             	movb   $0x31,(%edx)
    buffer[j2 + i] = '2';
  eb:	c6 42 64 32          	movb   $0x32,0x64(%edx)
  ef:	83 c2 01             	add    $0x1,%edx
  for (i = 0; i < 50; i++) { 
  f2:	39 c2                	cmp    %eax,%edx
  f4:	75 f2                	jne    e8 <swap_test+0x68>
  buffer[j1 + i] = 0;
  f6:	c6 83 ae cc 01 00 00 	movb   $0x0,0x1ccae(%ebx)
  buffer[j2 + i] = 0;
  fd:	c6 83 12 cd 01 00 00 	movb   $0x0,0x1cd12(%ebx)
 104:	8d bb e0 cc 01 00    	lea    0x1cce0(%ebx),%edi
 10a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if (fork() == 0) {
 10d:	e8 e8 04 00 00       	call   5fa <fork>
 112:	85 c0                	test   %eax,%eax
 114:	8b 55 e0             	mov    -0x20(%ebp),%edx
 117:	0f 84 cf 00 00 00    	je     1ec <swap_test+0x16c>
    wait();
 11d:	e8 e8 04 00 00       	call   60a <wait>
    if (strcmp(&buffer[j1], expected_res_parent_1)) {
 122:	83 ec 08             	sub    $0x8,%esp
 125:	68 2c 0c 00 00       	push   $0xc2c
 12a:	56                   	push   %esi
 12b:	e8 b0 02 00 00       	call   3e0 <strcmp>
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	75 55                	jne    18c <swap_test+0x10c>
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
 137:	83 ec 08             	sub    $0x8,%esp
 13a:	68 8c 0c 00 00       	push   $0xc8c
 13f:	57                   	push   %edi
 140:	e8 9b 02 00 00       	call   3e0 <strcmp>
 145:	83 c4 10             	add    $0x10,%esp
 148:	85 c0                	test   %eax,%eax
 14a:	75 66                	jne    1b2 <swap_test+0x132>
    free(buffer);
 14c:	83 ec 0c             	sub    $0xc,%esp
 14f:	53                   	push   %ebx
 150:	e8 cb 07 00 00       	call   920 <free>
 155:	83 c4 10             	add    $0x10,%esp
    printf(1, "parent: result: %s\n", res ? "success" : "failure");
 158:	b8 c3 0a 00 00       	mov    $0xac3,%eax
 15d:	83 ec 04             	sub    $0x4,%esp
 160:	50                   	push   %eax
 161:	68 11 0b 00 00       	push   $0xb11
 166:	6a 01                	push   $0x1
 168:	e8 e3 05 00 00       	call   750 <printf>
  test_number_of_pages(expected_free_pages);
 16d:	5a                   	pop    %edx
 16e:	ff 75 e4             	pushl  -0x1c(%ebp)
 171:	e8 aa fe ff ff       	call   20 <test_number_of_pages>
  printf(1, "==================================\n");
 176:	59                   	pop    %ecx
 177:	5b                   	pop    %ebx
 178:	68 74 0b 00 00       	push   $0xb74
 17d:	6a 01                	push   $0x1
 17f:	e8 cc 05 00 00       	call   750 <printf>
}
 184:	8d 65 f4             	lea    -0xc(%ebp),%esp
 187:	5b                   	pop    %ebx
 188:	5e                   	pop    %esi
 189:	5f                   	pop    %edi
 18a:	5d                   	pop    %ebp
 18b:	c3                   	ret    
      printf(1, "parent: failure:\nexpected: %s\nactual: %s\n", expected_res_parent_1, &buffer[j1]);
 18c:	56                   	push   %esi
 18d:	68 2c 0c 00 00       	push   $0xc2c
 192:	68 60 0c 00 00       	push   $0xc60
 197:	6a 01                	push   $0x1
 199:	e8 b2 05 00 00       	call   750 <printf>
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
 19e:	5e                   	pop    %esi
 19f:	58                   	pop    %eax
 1a0:	68 8c 0c 00 00       	push   $0xc8c
 1a5:	57                   	push   %edi
 1a6:	e8 35 02 00 00       	call   3e0 <strcmp>
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	85 c0                	test   %eax,%eax
 1b0:	74 24                	je     1d6 <swap_test+0x156>
      printf(1, "parent: failure:\nexpected: %s\nactual: %s\n", expected_res_parent_2, &buffer[j2]);
 1b2:	57                   	push   %edi
 1b3:	68 8c 0c 00 00       	push   $0xc8c
 1b8:	68 60 0c 00 00       	push   $0xc60
 1bd:	6a 01                	push   $0x1
 1bf:	e8 8c 05 00 00       	call   750 <printf>
    free(buffer);
 1c4:	89 1c 24             	mov    %ebx,(%esp)
 1c7:	e8 54 07 00 00       	call   920 <free>
 1cc:	83 c4 10             	add    $0x10,%esp
    printf(1, "parent: result: %s\n", res ? "success" : "failure");
 1cf:	b8 cb 0a 00 00       	mov    $0xacb,%eax
 1d4:	eb 87                	jmp    15d <swap_test+0xdd>
    free(buffer);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	53                   	push   %ebx
 1da:	e8 41 07 00 00       	call   920 <free>
 1df:	83 c4 10             	add    $0x10,%esp
    printf(1, "parent: result: %s\n", res ? "success" : "failure");
 1e2:	b8 cb 0a 00 00       	mov    $0xacb,%eax
 1e7:	e9 71 ff ff ff       	jmp    15d <swap_test+0xdd>
 1ec:	8d 83 a4 cc 01 00    	lea    0x1cca4(%ebx),%eax
	    buffer[j1 + i] = '3';
 1f2:	c6 00 33             	movb   $0x33,(%eax)
	    buffer[j2 + i] = '4';
 1f5:	c6 40 64 34          	movb   $0x34,0x64(%eax)
 1f9:	83 c0 01             	add    $0x1,%eax
    for (i = 40; i < 50; i++) { 
 1fc:	39 c2                	cmp    %eax,%edx
 1fe:	75 f2                	jne    1f2 <swap_test+0x172>
    if (strcmp(&buffer[j1], expected_res_child_1)) {
 200:	50                   	push   %eax
 201:	50                   	push   %eax
 202:	68 98 0b 00 00       	push   $0xb98
 207:	56                   	push   %esi
 208:	e8 d3 01 00 00       	call   3e0 <strcmp>
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	75 38                	jne    24c <swap_test+0x1cc>
    if (strcmp(&buffer[j2], expected_res_child_2)) {
 214:	50                   	push   %eax
 215:	50                   	push   %eax
 216:	68 f8 0b 00 00       	push   $0xbf8
 21b:	57                   	push   %edi
 21c:	e8 bf 01 00 00       	call   3e0 <strcmp>
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 c0                	test   %eax,%eax
 226:	75 5d                	jne    285 <swap_test+0x205>
    free(buffer);
 228:	83 ec 0c             	sub    $0xc,%esp
 22b:	53                   	push   %ebx
 22c:	e8 ef 06 00 00       	call   920 <free>
 231:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 234:	b8 c3 0a 00 00       	mov    $0xac3,%eax
 239:	52                   	push   %edx
 23a:	50                   	push   %eax
 23b:	68 ff 0a 00 00       	push   $0xaff
 240:	6a 01                	push   $0x1
 242:	e8 09 05 00 00       	call   750 <printf>
    exit();
 247:	e8 b6 03 00 00       	call   602 <exit>
      printf(1, "child: failure:\nexpected: %s\nactual: %s\n", expected_res_child_1, &buffer[j1]);
 24c:	56                   	push   %esi
 24d:	68 98 0b 00 00       	push   $0xb98
 252:	68 cc 0b 00 00       	push   $0xbcc
 257:	6a 01                	push   $0x1
 259:	e8 f2 04 00 00       	call   750 <printf>
    if (strcmp(&buffer[j2], expected_res_child_2)) {
 25e:	59                   	pop    %ecx
 25f:	5e                   	pop    %esi
 260:	68 f8 0b 00 00       	push   $0xbf8
 265:	57                   	push   %edi
 266:	e8 75 01 00 00       	call   3e0 <strcmp>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	85 c0                	test   %eax,%eax
 270:	75 13                	jne    285 <swap_test+0x205>
    free(buffer);
 272:	83 ec 0c             	sub    $0xc,%esp
 275:	53                   	push   %ebx
 276:	e8 a5 06 00 00       	call   920 <free>
 27b:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 27e:	b8 cb 0a 00 00       	mov    $0xacb,%eax
 283:	eb b4                	jmp    239 <swap_test+0x1b9>
      printf(1, "child: failure:\nexpected: %s\nactual: %s\n", expected_res_child_2, &buffer[j2]);
 285:	57                   	push   %edi
 286:	68 f8 0b 00 00       	push   $0xbf8
 28b:	68 cc 0b 00 00       	push   $0xbcc
 290:	6a 01                	push   $0x1
 292:	e8 b9 04 00 00       	call   750 <printf>
    free(buffer);
 297:	89 1c 24             	mov    %ebx,(%esp)
 29a:	e8 81 06 00 00       	call   920 <free>
 29f:	83 c4 10             	add    $0x10,%esp
    printf(1, "child result: %s\n", res ? "success" : "failure");
 2a2:	b8 cb 0a 00 00       	mov    $0xacb,%eax
 2a7:	eb 90                	jmp    239 <swap_test+0x1b9>
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <seg_fault_test>:
void seg_fault_test(){
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "==================================\n");
 2b7:	68 74 0b 00 00       	push   $0xb74
 2bc:	6a 01                	push   $0x1
 2be:	e8 8d 04 00 00       	call   750 <printf>
  printf(1, "Started seg fault test\n\n");
 2c3:	58                   	pop    %eax
 2c4:	5a                   	pop    %edx
 2c5:	68 25 0b 00 00       	push   $0xb25
 2ca:	6a 01                	push   $0x1
 2cc:	e8 7f 04 00 00       	call   750 <printf>
  buffer = malloc (BUFF_SIZE);
 2d1:	c7 04 24 00 d0 01 00 	movl   $0x1d000,(%esp)
 2d8:	e8 d3 06 00 00       	call   9b0 <malloc>
  printf(1, "should panic now...\n");
 2dd:	59                   	pop    %ecx
  buffer = malloc (BUFF_SIZE);
 2de:	89 c3                	mov    %eax,%ebx
  printf(1, "should panic now...\n");
 2e0:	58                   	pop    %eax
 2e1:	68 3e 0b 00 00       	push   $0xb3e
 2e6:	6a 01                	push   $0x1
 2e8:	e8 63 04 00 00       	call   750 <printf>
  buffer[BUFF_SIZE + PGSIZE] = '5';
 2ed:	c6 83 00 e0 01 00 35 	movb   $0x35,0x1e000(%ebx)
  printf(1, "test failed! should panic seg fault\n");
 2f4:	58                   	pop    %eax
 2f5:	5a                   	pop    %edx
 2f6:	68 c0 0c 00 00       	push   $0xcc0
 2fb:	6a 01                	push   $0x1
 2fd:	e8 4e 04 00 00       	call   750 <printf>
  printf(1, "==================================\n");
 302:	59                   	pop    %ecx
 303:	5b                   	pop    %ebx
 304:	68 74 0b 00 00       	push   $0xb74
 309:	6a 01                	push   $0x1
 30b:	e8 40 04 00 00       	call   750 <printf>
}
 310:	83 c4 10             	add    $0x10,%esp
 313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 316:	c9                   	leave  
 317:	c3                   	ret    
 318:	90                   	nop
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <getRandNum>:
  next = next * 1103515245 + 12341;
 320:	69 05 64 10 00 00 6d 	imul   $0x41c64e6d,0x1064,%eax
 327:	4e c6 41 
int getRandNum() {
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
}
 32d:	5d                   	pop    %ebp
  next = next * 1103515245 + 12341;
 32e:	05 35 30 00 00       	add    $0x3035,%eax
 333:	a3 64 10 00 00       	mov    %eax,0x1064
  return (unsigned int)(next/65536) % BUFF_SIZE;
 338:	c1 e8 10             	shr    $0x10,%eax
}
 33b:	c3                   	ret    
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000340 <globalTest>:
void globalTest(){
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
	arr = malloc(BUFF_SIZE); //allocates 14 pages (sums to 17 - to allow more then one swapping in scfifo)
 345:	83 ec 0c             	sub    $0xc,%esp
 348:	68 00 d0 01 00       	push   $0x1d000
 34d:	e8 5e 06 00 00       	call   9b0 <malloc>
 352:	8b 15 64 10 00 00    	mov    0x1064,%edx
 358:	89 c3                	mov    %eax,%ebx
 35a:	83 c4 10             	add    $0x10,%esp
 35d:	b8 f4 01 00 00       	mov    $0x1f4,%eax
 362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  next = next * 1103515245 + 12341;
 368:	69 d2 6d 4e c6 41    	imul   $0x41c64e6d,%edx,%edx
 36e:	81 c2 35 30 00 00    	add    $0x3035,%edx
  return (unsigned int)(next/65536) % BUFF_SIZE;
 374:	89 d1                	mov    %edx,%ecx
 376:	c1 e9 10             	shr    $0x10,%ecx
		while (PGSIZE*10-8 < randNum && randNum < PGSIZE*10+PGSIZE/2-8)
 379:	8d b1 07 60 ff ff    	lea    -0x9ff9(%ecx),%esi
 37f:	81 fe fe 07 00 00    	cmp    $0x7fe,%esi
 385:	76 e1                	jbe    368 <globalTest+0x28>
	for (i = 0; i < TEST_POOL; i++) {
 387:	83 e8 01             	sub    $0x1,%eax
		arr[randNum] = 'X';				//write to memory
 38a:	c6 04 0b 58          	movb   $0x58,(%ebx,%ecx,1)
	for (i = 0; i < TEST_POOL; i++) {
 38e:	75 d8                	jne    368 <globalTest+0x28>
	free(arr);
 390:	83 ec 0c             	sub    $0xc,%esp
 393:	89 15 64 10 00 00    	mov    %edx,0x1064
 399:	53                   	push   %ebx
 39a:	e8 81 05 00 00       	call   920 <free>
}
 39f:	83 c4 10             	add    $0x10,%esp
 3a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a5:	5b                   	pop    %ebx
 3a6:	5e                   	pop    %esi
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ba:	89 c2                	mov    %eax,%edx
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3c0:	83 c1 01             	add    $0x1,%ecx
 3c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3c7:	83 c2 01             	add    $0x1,%edx
 3ca:	84 db                	test   %bl,%bl
 3cc:	88 5a ff             	mov    %bl,-0x1(%edx)
 3cf:	75 ef                	jne    3c0 <strcpy+0x10>
    ;
  return os;
}
 3d1:	5b                   	pop    %ebx
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
 3d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
 3e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ea:	0f b6 02             	movzbl (%edx),%eax
 3ed:	0f b6 19             	movzbl (%ecx),%ebx
 3f0:	84 c0                	test   %al,%al
 3f2:	75 1c                	jne    410 <strcmp+0x30>
 3f4:	eb 2a                	jmp    420 <strcmp+0x40>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 400:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 403:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 406:	83 c1 01             	add    $0x1,%ecx
 409:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 40c:	84 c0                	test   %al,%al
 40e:	74 10                	je     420 <strcmp+0x40>
 410:	38 d8                	cmp    %bl,%al
 412:	74 ec                	je     400 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 414:	29 d8                	sub    %ebx,%eax
}
 416:	5b                   	pop    %ebx
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 420:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 422:	29 d8                	sub    %ebx,%eax
}
 424:	5b                   	pop    %ebx
 425:	5d                   	pop    %ebp
 426:	c3                   	ret    
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <strlen>:

uint
strlen(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 436:	80 39 00             	cmpb   $0x0,(%ecx)
 439:	74 15                	je     450 <strlen+0x20>
 43b:	31 d2                	xor    %edx,%edx
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	83 c2 01             	add    $0x1,%edx
 443:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 447:	89 d0                	mov    %edx,%eax
 449:	75 f5                	jne    440 <strlen+0x10>
    ;
  return n;
}
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 450:	31 c0                	xor    %eax,%eax
}
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 45a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000460 <memset>:

void*
memset(void *dst, int c, uint n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 d7                	mov    %edx,%edi
 46f:	fc                   	cld    
 470:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 472:	89 d0                	mov    %edx,%eax
 474:	5f                   	pop    %edi
 475:	5d                   	pop    %ebp
 476:	c3                   	ret    
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <strchr>:

char*
strchr(const char *s, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 48a:	0f b6 10             	movzbl (%eax),%edx
 48d:	84 d2                	test   %dl,%dl
 48f:	74 1d                	je     4ae <strchr+0x2e>
    if(*s == c)
 491:	38 d3                	cmp    %dl,%bl
 493:	89 d9                	mov    %ebx,%ecx
 495:	75 0d                	jne    4a4 <strchr+0x24>
 497:	eb 17                	jmp    4b0 <strchr+0x30>
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a0:	38 ca                	cmp    %cl,%dl
 4a2:	74 0c                	je     4b0 <strchr+0x30>
  for(; *s; s++)
 4a4:	83 c0 01             	add    $0x1,%eax
 4a7:	0f b6 10             	movzbl (%eax),%edx
 4aa:	84 d2                	test   %dl,%dl
 4ac:	75 f2                	jne    4a0 <strchr+0x20>
      return (char*)s;
  return 0;
 4ae:	31 c0                	xor    %eax,%eax
}
 4b0:	5b                   	pop    %ebx
 4b1:	5d                   	pop    %ebp
 4b2:	c3                   	ret    
 4b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <gets>:

char*
gets(char *buf, int max)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c6:	31 f6                	xor    %esi,%esi
 4c8:	89 f3                	mov    %esi,%ebx
{
 4ca:	83 ec 1c             	sub    $0x1c,%esp
 4cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4d0:	eb 2f                	jmp    501 <gets+0x41>
 4d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4db:	83 ec 04             	sub    $0x4,%esp
 4de:	6a 01                	push   $0x1
 4e0:	50                   	push   %eax
 4e1:	6a 00                	push   $0x0
 4e3:	e8 32 01 00 00       	call   61a <read>
    if(cc < 1)
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	85 c0                	test   %eax,%eax
 4ed:	7e 1c                	jle    50b <gets+0x4b>
      break;
    buf[i++] = c;
 4ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4f3:	83 c7 01             	add    $0x1,%edi
 4f6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4f9:	3c 0a                	cmp    $0xa,%al
 4fb:	74 23                	je     520 <gets+0x60>
 4fd:	3c 0d                	cmp    $0xd,%al
 4ff:	74 1f                	je     520 <gets+0x60>
  for(i=0; i+1 < max; ){
 501:	83 c3 01             	add    $0x1,%ebx
 504:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 507:	89 fe                	mov    %edi,%esi
 509:	7c cd                	jl     4d8 <gets+0x18>
 50b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 510:	c6 03 00             	movb   $0x0,(%ebx)
}
 513:	8d 65 f4             	lea    -0xc(%ebp),%esp
 516:	5b                   	pop    %ebx
 517:	5e                   	pop    %esi
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret    
 51b:	90                   	nop
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 520:	8b 75 08             	mov    0x8(%ebp),%esi
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	01 de                	add    %ebx,%esi
 528:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 52a:	c6 03 00             	movb   $0x0,(%ebx)
}
 52d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 530:	5b                   	pop    %ebx
 531:	5e                   	pop    %esi
 532:	5f                   	pop    %edi
 533:	5d                   	pop    %ebp
 534:	c3                   	ret    
 535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000540 <stat>:

int
stat(const char *n, struct stat *st)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 545:	83 ec 08             	sub    $0x8,%esp
 548:	6a 00                	push   $0x0
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 f0 00 00 00       	call   642 <open>
  if(fd < 0)
 552:	83 c4 10             	add    $0x10,%esp
 555:	85 c0                	test   %eax,%eax
 557:	78 27                	js     580 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	ff 75 0c             	pushl  0xc(%ebp)
 55f:	89 c3                	mov    %eax,%ebx
 561:	50                   	push   %eax
 562:	e8 f3 00 00 00       	call   65a <fstat>
  close(fd);
 567:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 56a:	89 c6                	mov    %eax,%esi
  close(fd);
 56c:	e8 b9 00 00 00       	call   62a <close>
  return r;
 571:	83 c4 10             	add    $0x10,%esp
}
 574:	8d 65 f8             	lea    -0x8(%ebp),%esp
 577:	89 f0                	mov    %esi,%eax
 579:	5b                   	pop    %ebx
 57a:	5e                   	pop    %esi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 580:	be ff ff ff ff       	mov    $0xffffffff,%esi
 585:	eb ed                	jmp    574 <stat+0x34>
 587:	89 f6                	mov    %esi,%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000590 <atoi>:

int
atoi(const char *s)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 597:	0f be 11             	movsbl (%ecx),%edx
 59a:	8d 42 d0             	lea    -0x30(%edx),%eax
 59d:	3c 09                	cmp    $0x9,%al
  n = 0;
 59f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5a4:	77 1f                	ja     5c5 <atoi+0x35>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 5b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5b3:	83 c1 01             	add    $0x1,%ecx
 5b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 5ba:	0f be 11             	movsbl (%ecx),%edx
 5bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5c0:	80 fb 09             	cmp    $0x9,%bl
 5c3:	76 eb                	jbe    5b0 <atoi+0x20>
  return n;
}
 5c5:	5b                   	pop    %ebx
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	56                   	push   %esi
 5d4:	53                   	push   %ebx
 5d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5de:	85 db                	test   %ebx,%ebx
 5e0:	7e 14                	jle    5f6 <memmove+0x26>
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5f2:	39 d3                	cmp    %edx,%ebx
 5f4:	75 f2                	jne    5e8 <memmove+0x18>
  return vdst;
}
 5f6:	5b                   	pop    %ebx
 5f7:	5e                   	pop    %esi
 5f8:	5d                   	pop    %ebp
 5f9:	c3                   	ret    

000005fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5fa:	b8 01 00 00 00       	mov    $0x1,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <exit>:
SYSCALL(exit)
 602:	b8 02 00 00 00       	mov    $0x2,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <wait>:
SYSCALL(wait)
 60a:	b8 03 00 00 00       	mov    $0x3,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <pipe>:
SYSCALL(pipe)
 612:	b8 04 00 00 00       	mov    $0x4,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <read>:
SYSCALL(read)
 61a:	b8 05 00 00 00       	mov    $0x5,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <write>:
SYSCALL(write)
 622:	b8 10 00 00 00       	mov    $0x10,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <close>:
SYSCALL(close)
 62a:	b8 15 00 00 00       	mov    $0x15,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <kill>:
SYSCALL(kill)
 632:	b8 06 00 00 00       	mov    $0x6,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <exec>:
SYSCALL(exec)
 63a:	b8 07 00 00 00       	mov    $0x7,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <open>:
SYSCALL(open)
 642:	b8 0f 00 00 00       	mov    $0xf,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mknod>:
SYSCALL(mknod)
 64a:	b8 11 00 00 00       	mov    $0x11,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <unlink>:
SYSCALL(unlink)
 652:	b8 12 00 00 00       	mov    $0x12,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <fstat>:
SYSCALL(fstat)
 65a:	b8 08 00 00 00       	mov    $0x8,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <link>:
SYSCALL(link)
 662:	b8 13 00 00 00       	mov    $0x13,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <mkdir>:
SYSCALL(mkdir)
 66a:	b8 14 00 00 00       	mov    $0x14,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <chdir>:
SYSCALL(chdir)
 672:	b8 09 00 00 00       	mov    $0x9,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <dup>:
SYSCALL(dup)
 67a:	b8 0a 00 00 00       	mov    $0xa,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <getpid>:
SYSCALL(getpid)
 682:	b8 0b 00 00 00       	mov    $0xb,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <sbrk>:
SYSCALL(sbrk)
 68a:	b8 0c 00 00 00       	mov    $0xc,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <sleep>:
SYSCALL(sleep)
 692:	b8 0d 00 00 00       	mov    $0xd,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <uptime>:
SYSCALL(uptime)
 69a:	b8 0e 00 00 00       	mov    $0xe,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
 6a2:	b8 16 00 00 00       	mov    $0x16,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    
 6aa:	66 90                	xchg   %ax,%ax
 6ac:	66 90                	xchg   %ax,%ax
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6b9:	85 d2                	test   %edx,%edx
{
 6bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6be:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6c0:	79 76                	jns    738 <printint+0x88>
 6c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6c6:	74 70                	je     738 <printint+0x88>
    x = -xx;
 6c8:	f7 d8                	neg    %eax
    neg = 1;
 6ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6d1:	31 f6                	xor    %esi,%esi
 6d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6d6:	eb 0a                	jmp    6e2 <printint+0x32>
 6d8:	90                   	nop
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6e0:	89 fe                	mov    %edi,%esi
 6e2:	31 d2                	xor    %edx,%edx
 6e4:	8d 7e 01             	lea    0x1(%esi),%edi
 6e7:	f7 f1                	div    %ecx
 6e9:	0f b6 92 f0 0c 00 00 	movzbl 0xcf0(%edx),%edx
  }while((x /= base) != 0);
 6f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 6f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 6f5:	75 e9                	jne    6e0 <printint+0x30>
  if(neg)
 6f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6fa:	85 c0                	test   %eax,%eax
 6fc:	74 08                	je     706 <printint+0x56>
    buf[i++] = '-';
 6fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 703:	8d 7e 02             	lea    0x2(%esi),%edi
 706:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 70a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
 710:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
 716:	83 ee 01             	sub    $0x1,%esi
 719:	6a 01                	push   $0x1
 71b:	53                   	push   %ebx
 71c:	57                   	push   %edi
 71d:	88 45 d7             	mov    %al,-0x29(%ebp)
 720:	e8 fd fe ff ff       	call   622 <write>

  while(--i >= 0)
 725:	83 c4 10             	add    $0x10,%esp
 728:	39 de                	cmp    %ebx,%esi
 72a:	75 e4                	jne    710 <printint+0x60>
    putc(fd, buf[i]);
}
 72c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72f:	5b                   	pop    %ebx
 730:	5e                   	pop    %esi
 731:	5f                   	pop    %edi
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 738:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 73f:	eb 90                	jmp    6d1 <printint+0x21>
 741:	eb 0d                	jmp    750 <printf>
 743:	90                   	nop
 744:	90                   	nop
 745:	90                   	nop
 746:	90                   	nop
 747:	90                   	nop
 748:	90                   	nop
 749:	90                   	nop
 74a:	90                   	nop
 74b:	90                   	nop
 74c:	90                   	nop
 74d:	90                   	nop
 74e:	90                   	nop
 74f:	90                   	nop

00000750 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 759:	8b 75 0c             	mov    0xc(%ebp),%esi
 75c:	0f b6 1e             	movzbl (%esi),%ebx
 75f:	84 db                	test   %bl,%bl
 761:	0f 84 b3 00 00 00    	je     81a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 767:	8d 45 10             	lea    0x10(%ebp),%eax
 76a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 76d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 76f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 772:	eb 2f                	jmp    7a3 <printf+0x53>
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 778:	83 f8 25             	cmp    $0x25,%eax
 77b:	0f 84 a7 00 00 00    	je     828 <printf+0xd8>
  write(fd, &c, 1);
 781:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 784:	83 ec 04             	sub    $0x4,%esp
 787:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 78a:	6a 01                	push   $0x1
 78c:	50                   	push   %eax
 78d:	ff 75 08             	pushl  0x8(%ebp)
 790:	e8 8d fe ff ff       	call   622 <write>
 795:	83 c4 10             	add    $0x10,%esp
 798:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 79b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 79f:	84 db                	test   %bl,%bl
 7a1:	74 77                	je     81a <printf+0xca>
    if(state == 0){
 7a3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7a5:	0f be cb             	movsbl %bl,%ecx
 7a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7ab:	74 cb                	je     778 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7ad:	83 ff 25             	cmp    $0x25,%edi
 7b0:	75 e6                	jne    798 <printf+0x48>
      if(c == 'd'){
 7b2:	83 f8 64             	cmp    $0x64,%eax
 7b5:	0f 84 05 01 00 00    	je     8c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7c1:	83 f9 70             	cmp    $0x70,%ecx
 7c4:	74 72                	je     838 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7c6:	83 f8 73             	cmp    $0x73,%eax
 7c9:	0f 84 99 00 00 00    	je     868 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7cf:	83 f8 63             	cmp    $0x63,%eax
 7d2:	0f 84 08 01 00 00    	je     8e0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7d8:	83 f8 25             	cmp    $0x25,%eax
 7db:	0f 84 ef 00 00 00    	je     8d0 <printf+0x180>
  write(fd, &c, 1);
 7e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7e4:	83 ec 04             	sub    $0x4,%esp
 7e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7eb:	6a 01                	push   $0x1
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	pushl  0x8(%ebp)
 7f1:	e8 2c fe ff ff       	call   622 <write>
 7f6:	83 c4 0c             	add    $0xc,%esp
 7f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ff:	6a 01                	push   $0x1
 801:	50                   	push   %eax
 802:	ff 75 08             	pushl  0x8(%ebp)
 805:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 808:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 80a:	e8 13 fe ff ff       	call   622 <write>
  for(i = 0; fmt[i]; i++){
 80f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 813:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 816:	84 db                	test   %bl,%bl
 818:	75 89                	jne    7a3 <printf+0x53>
    }
  }
}
 81a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 81d:	5b                   	pop    %ebx
 81e:	5e                   	pop    %esi
 81f:	5f                   	pop    %edi
 820:	5d                   	pop    %ebp
 821:	c3                   	ret    
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 828:	bf 25 00 00 00       	mov    $0x25,%edi
 82d:	e9 66 ff ff ff       	jmp    798 <printf+0x48>
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 838:	83 ec 0c             	sub    $0xc,%esp
 83b:	b9 10 00 00 00       	mov    $0x10,%ecx
 840:	6a 00                	push   $0x0
 842:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	8b 17                	mov    (%edi),%edx
 84a:	e8 61 fe ff ff       	call   6b0 <printint>
        ap++;
 84f:	89 f8                	mov    %edi,%eax
 851:	83 c4 10             	add    $0x10,%esp
      state = 0;
 854:	31 ff                	xor    %edi,%edi
        ap++;
 856:	83 c0 04             	add    $0x4,%eax
 859:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 85c:	e9 37 ff ff ff       	jmp    798 <printf+0x48>
 861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 86b:	8b 08                	mov    (%eax),%ecx
        ap++;
 86d:	83 c0 04             	add    $0x4,%eax
 870:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 873:	85 c9                	test   %ecx,%ecx
 875:	0f 84 8e 00 00 00    	je     909 <printf+0x1b9>
        while(*s != 0){
 87b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 87e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 880:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 882:	84 c0                	test   %al,%al
 884:	0f 84 0e ff ff ff    	je     798 <printf+0x48>
 88a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 88d:	89 de                	mov    %ebx,%esi
 88f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 892:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 895:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 898:	83 ec 04             	sub    $0x4,%esp
          s++;
 89b:	83 c6 01             	add    $0x1,%esi
 89e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8a1:	6a 01                	push   $0x1
 8a3:	57                   	push   %edi
 8a4:	53                   	push   %ebx
 8a5:	e8 78 fd ff ff       	call   622 <write>
        while(*s != 0){
 8aa:	0f b6 06             	movzbl (%esi),%eax
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	84 c0                	test   %al,%al
 8b2:	75 e4                	jne    898 <printf+0x148>
 8b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8b7:	31 ff                	xor    %edi,%edi
 8b9:	e9 da fe ff ff       	jmp    798 <printf+0x48>
 8be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8c0:	83 ec 0c             	sub    $0xc,%esp
 8c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8c8:	6a 01                	push   $0x1
 8ca:	e9 73 ff ff ff       	jmp    842 <printf+0xf2>
 8cf:	90                   	nop
  write(fd, &c, 1);
 8d0:	83 ec 04             	sub    $0x4,%esp
 8d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8d9:	6a 01                	push   $0x1
 8db:	e9 21 ff ff ff       	jmp    801 <printf+0xb1>
        putc(fd, *ap);
 8e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8e6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8e8:	6a 01                	push   $0x1
        ap++;
 8ea:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 8f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8f3:	50                   	push   %eax
 8f4:	ff 75 08             	pushl  0x8(%ebp)
 8f7:	e8 26 fd ff ff       	call   622 <write>
        ap++;
 8fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 902:	31 ff                	xor    %edi,%edi
 904:	e9 8f fe ff ff       	jmp    798 <printf+0x48>
          s = "(null)";
 909:	bb e8 0c 00 00       	mov    $0xce8,%ebx
        while(*s != 0){
 90e:	b8 28 00 00 00       	mov    $0x28,%eax
 913:	e9 72 ff ff ff       	jmp    88a <printf+0x13a>
 918:	66 90                	xchg   %ax,%ax
 91a:	66 90                	xchg   %ax,%ax
 91c:	66 90                	xchg   %ax,%ax
 91e:	66 90                	xchg   %ax,%ax

00000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	a1 68 10 00 00       	mov    0x1068,%eax
{
 926:	89 e5                	mov    %esp,%ebp
 928:	57                   	push   %edi
 929:	56                   	push   %esi
 92a:	53                   	push   %ebx
 92b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 92e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	39 c8                	cmp    %ecx,%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	73 32                	jae    970 <free+0x50>
 93e:	39 d1                	cmp    %edx,%ecx
 940:	72 04                	jb     946 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	39 d0                	cmp    %edx,%eax
 944:	72 32                	jb     978 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 946:	8b 73 fc             	mov    -0x4(%ebx),%esi
 949:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 94c:	39 fa                	cmp    %edi,%edx
 94e:	74 30                	je     980 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 950:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 953:	8b 50 04             	mov    0x4(%eax),%edx
 956:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 959:	39 f1                	cmp    %esi,%ecx
 95b:	74 3a                	je     997 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 95d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 95f:	a3 68 10 00 00       	mov    %eax,0x1068
}
 964:	5b                   	pop    %ebx
 965:	5e                   	pop    %esi
 966:	5f                   	pop    %edi
 967:	5d                   	pop    %ebp
 968:	c3                   	ret    
 969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	39 d0                	cmp    %edx,%eax
 972:	72 04                	jb     978 <free+0x58>
 974:	39 d1                	cmp    %edx,%ecx
 976:	72 ce                	jb     946 <free+0x26>
{
 978:	89 d0                	mov    %edx,%eax
 97a:	eb bc                	jmp    938 <free+0x18>
 97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 980:	03 72 04             	add    0x4(%edx),%esi
 983:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 12                	mov    (%edx),%edx
 98a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 98d:	8b 50 04             	mov    0x4(%eax),%edx
 990:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 993:	39 f1                	cmp    %esi,%ecx
 995:	75 c6                	jne    95d <free+0x3d>
    p->s.size += bp->s.size;
 997:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 99a:	a3 68 10 00 00       	mov    %eax,0x1068
    p->s.size += bp->s.size;
 99f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9a5:	89 10                	mov    %edx,(%eax)
}
 9a7:	5b                   	pop    %ebx
 9a8:	5e                   	pop    %esi
 9a9:	5f                   	pop    %edi
 9aa:	5d                   	pop    %ebp
 9ab:	c3                   	ret    
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	57                   	push   %edi
 9b4:	56                   	push   %esi
 9b5:	53                   	push   %ebx
 9b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9bc:	8b 15 68 10 00 00    	mov    0x1068,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c2:	8d 78 07             	lea    0x7(%eax),%edi
 9c5:	c1 ef 03             	shr    $0x3,%edi
 9c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9cb:	85 d2                	test   %edx,%edx
 9cd:	0f 84 9d 00 00 00    	je     a70 <malloc+0xc0>
 9d3:	8b 02                	mov    (%edx),%eax
 9d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9d8:	39 cf                	cmp    %ecx,%edi
 9da:	76 6c                	jbe    a48 <malloc+0x98>
 9dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9f1:	eb 0e                	jmp    a01 <malloc+0x51>
 9f3:	90                   	nop
 9f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9fa:	8b 48 04             	mov    0x4(%eax),%ecx
 9fd:	39 f9                	cmp    %edi,%ecx
 9ff:	73 47                	jae    a48 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a01:	39 05 68 10 00 00    	cmp    %eax,0x1068
 a07:	89 c2                	mov    %eax,%edx
 a09:	75 ed                	jne    9f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a0b:	83 ec 0c             	sub    $0xc,%esp
 a0e:	56                   	push   %esi
 a0f:	e8 76 fc ff ff       	call   68a <sbrk>
  if(p == (char*)-1)
 a14:	83 c4 10             	add    $0x10,%esp
 a17:	83 f8 ff             	cmp    $0xffffffff,%eax
 a1a:	74 1c                	je     a38 <malloc+0x88>
  hp->s.size = nu;
 a1c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a1f:	83 ec 0c             	sub    $0xc,%esp
 a22:	83 c0 08             	add    $0x8,%eax
 a25:	50                   	push   %eax
 a26:	e8 f5 fe ff ff       	call   920 <free>
  return freep;
 a2b:	8b 15 68 10 00 00    	mov    0x1068,%edx
      if((p = morecore(nunits)) == 0)
 a31:	83 c4 10             	add    $0x10,%esp
 a34:	85 d2                	test   %edx,%edx
 a36:	75 c0                	jne    9f8 <malloc+0x48>
        return 0;
  }
}
 a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a3b:	31 c0                	xor    %eax,%eax
}
 a3d:	5b                   	pop    %ebx
 a3e:	5e                   	pop    %esi
 a3f:	5f                   	pop    %edi
 a40:	5d                   	pop    %ebp
 a41:	c3                   	ret    
 a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a48:	39 cf                	cmp    %ecx,%edi
 a4a:	74 54                	je     aa0 <malloc+0xf0>
        p->s.size -= nunits;
 a4c:	29 f9                	sub    %edi,%ecx
 a4e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a51:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a54:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a57:	89 15 68 10 00 00    	mov    %edx,0x1068
}
 a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a60:	83 c0 08             	add    $0x8,%eax
}
 a63:	5b                   	pop    %ebx
 a64:	5e                   	pop    %esi
 a65:	5f                   	pop    %edi
 a66:	5d                   	pop    %ebp
 a67:	c3                   	ret    
 a68:	90                   	nop
 a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a70:	c7 05 68 10 00 00 6c 	movl   $0x106c,0x1068
 a77:	10 00 00 
 a7a:	c7 05 6c 10 00 00 6c 	movl   $0x106c,0x106c
 a81:	10 00 00 
    base.s.size = 0;
 a84:	b8 6c 10 00 00       	mov    $0x106c,%eax
 a89:	c7 05 70 10 00 00 00 	movl   $0x0,0x1070
 a90:	00 00 00 
 a93:	e9 44 ff ff ff       	jmp    9dc <malloc+0x2c>
 a98:	90                   	nop
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 aa0:	8b 08                	mov    (%eax),%ecx
 aa2:	89 0a                	mov    %ecx,(%edx)
 aa4:	eb b1                	jmp    a57 <malloc+0xa7>
