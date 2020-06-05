#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define EXEC_PGS 2
#define GROWPROC_PGS 8
#define IGNORE_PGS 12
#define MAX_PSYC_PAGES 16
#define MAX_TOTAL_PAGES 32
#define PGSIZE 4096
#define FILESIZE 1
#define BUFF_SIZE (PGSIZE * (MAX_TOTAL_PAGES - GROWPROC_PGS - FILESIZE))

void test_number_of_pages(int expected) {
  int actual = getNumberOfFreePages();
  printf(1,"free pages test: ");
  if (actual == expected) {
    printf(1, "SUCCESS\n");
  }
  else {
    printf(1, "FAILURE\nexpected: %d\nactual: %d\n", expected, actual);
  }
}

void test_number_of_page_faults(int expected, int is_child) {
  int actual = page_faults();
  printf(1, "%s", is_child ? "[child]: " : "[parent]: ");
  printf(1,"pages faults test: ");
  if (actual == expected) {
    printf(1, "SUCCESS\n");
    printf(1, "(total pages faults: %d)\n", page_faults());
  }
  else {
    printf(1, "FAILURE\nexpected: %d\nactual: %d\n", expected, actual);
  }
}


void swap_test(){
  int i, j1, j2, res = 1, expected_free_pages, num_of_pf_before , num_of_free_pages_before;
  printf(1, "==================================\n");
  printf(1, "Started swap and cow test\n\n");
  printf(1,"free pages: %d\n", num_of_free_pages_before = getNumberOfFreePages());
  printf(1,"used pages: %d\n", get_used_pages());

  char *buffer;
  char *expected_res_parent_1 = "11111111111111111111111111111111111111111111111111";
  char *expected_res_parent_2 = "22222222222222222222222222222222222222222222222222";
  char *expected_res_child_1 = "11111111111111111111111111111111111111113333333333";
  char *expected_res_child_2 = "22222222222222222222222222222222222222224444444444";
  int expected_pf_child = 10;
  int expected_pf_parent = 5;

  printf(1,"allocating buffer with size: %d\n", BUFF_SIZE);
  buffer = malloc(BUFF_SIZE);
  printf(1,"free pages affter allocation: %d\n", getNumberOfFreePages());
  printf(1, "page faults before test: %d\n", num_of_pf_before = page_faults());

  j1 = BUFF_SIZE-900;
  j2 = BUFF_SIZE-800;

  // TODO: this is a very beautiful bug we need to fix :)
  // TODO: after running with this code, try ls twice
  // num_of_pf_before = page_faults();
  // for (i = 1; i <= expected_pf_parent; i++)
  //   buffer[PGSIZE*i + 1] = '2';
  // test_number_of_page_faults(num_of_pf_before + expected_pf_parent, 0);

  for (i = 0; i < 50; i++) { 
    buffer[j1 + i] = '1';
    buffer[j2 + i] = '2';
    // buffer[i] = '1';
  }
  
  // delimeter
  buffer[j1 + i] = 0;
  buffer[j2 + i] = 0;
  
  if (fork() == 0) {
    for (i = 40; i < 50; i++) { 
	    buffer[j1 + i] = '3';
	    buffer[j2 + i] = '4';
  	}
    for (i = 1; i <= expected_pf_child; i++)
      buffer[PGSIZE*i + 1] = '2';

    if (strcmp(&buffer[j1], expected_res_child_1)) {
      res = 0;
      printf(1, "[child] FAILURE:\nexpected: %s\nactual: %s\n", expected_res_child_1, &buffer[j1]);
    }
    if (strcmp(&buffer[j2], expected_res_child_2)) {
      res = 0;
      printf(1, "[child] FAILURE:\nexpected: %s\nactual: %s\n", expected_res_child_2, &buffer[j2]);
    }
    free(buffer);
    test_number_of_page_faults(expected_pf_child, 1);
    printf(1, "[child] result: %s\n", res ? "SUCCESS" : "FAILURE");
    exit();
  } 
  else { // parent
    wait();

    if (strcmp(&buffer[j1], expected_res_parent_1)) {
      res = 0;
      printf(1, "[parent]: FAILURE:\nexpected: %s\nactual: %s\n", expected_res_parent_1, &buffer[j1]);
    }
    if (strcmp(&buffer[j2], expected_res_parent_2)) {
      res = 0;
      printf(1, "[parent]: FAILURE:\nexpected: %s\nactual: %s\n", expected_res_parent_2, &buffer[j2]);
    }
    free(buffer);
    printf(1, "[parent]: total page faults: %d\n", page_faults());
    printf(1, "[parent]: result: %s\n", res ? "SUCCESS" : "FAILURE");
  }

  expected_free_pages = num_of_free_pages_before - IGNORE_PGS;
  test_number_of_pages(expected_free_pages);

  printf(1, "==================================\n");
}

void seg_fault_test(){
  printf(1, "==================================\n");
  printf(1, "Started seg fault test\n\n");

  char *buffer;
  buffer = malloc (BUFF_SIZE);
  
  printf(1, "should panic now...\n");
  buffer[BUFF_SIZE + PGSIZE] = '5';
  
  printf(1, "test failed! should panic seg fault\n");
  printf(1, "==================================\n");
}

static unsigned long int next = 1;
int getRandNum() {
  next = next * 1103515245 + 12341;
  return (unsigned int)(next/65536) % BUFF_SIZE;
}

#define PAGE_NUM(addr) ((uint)(addr) & ~0xFFF)
#define TEST_POOL 500
/*
Global Test:
Allocates 17 pages (1 code, 1 space, 1 stack, 14 malloc)
Using pseudoRNG to access a single cell in the array and put a number in it.
Idea behind the algorithm:
	Space page will be swapped out sooner or later with scfifo or lap.
	Since no one calls the space page, an extra page is needed to play with swapping (hence the #17).
	We selected a single page and reduced its page calls to see if scfifo and lap will become more efficient.
Results (for TEST_POOL = 500):
LIFO: 42 Page faults
LAP: 18 Page faults
SCFIFO: 35 Page faults
*/
void globalTest(){
	char * arr;
	int i;
	int randNum;
	arr = malloc(BUFF_SIZE); //allocates 14 pages (sums to 17 - to allow more then one swapping in scfifo)
	for (i = 0; i < TEST_POOL; i++) {
		randNum = getRandNum();	//generates a pseudo random number between 0 and ARR_SIZE
		while (PGSIZE*10-8 < randNum && randNum < PGSIZE*10+PGSIZE/2-8)
			randNum = getRandNum(); //gives page #13 50% less chance of being selected
															//(redraw number if randNum is in the first half of page #13)
		arr[randNum] = 'X';				//write to memory
	}
	free(arr);
}


int main(int argc, char *argv[]){
//   globalTest();			//for testing each policy efficiency
  swap_test();
  // seg_fault_test();
  exit();
}