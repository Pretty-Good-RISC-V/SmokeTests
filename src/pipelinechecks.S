#include "include/riscv_test.h"
#include "include/test_macros.h"

#undef RVTEST_PASS
#define RVTEST_PASS                                                     \
        fence;                                                          \
        li TESTNUM, 1;                                                  \
        j write_tohost;                                                 

#undef RVTEST_FAIL
#define RVTEST_FAIL                                                     \
        fence;                                                          \
        sll TESTNUM, TESTNUM, 1;                                                  \
        or TESTNUM, TESTNUM, 1;                                         \
        j write_tohost;                                                 

RVTEST_RV32M

    .section .text.init;
    .align  6;
    .globl _start, write_tohost;

   
_start:         
    csrwi mscratch, 0;

    li TESTNUM, 1;

    li t0, 25;
    li t1, 12;
    add t2, t0, t1;
    li t3, 37;
    bne t2, t3, fail;

    li TESTNUM, 2;
    // Make sure mscratch contains 0
    csrr t0, mscratch;
    bnez t0, fail;

    // Write 999 into mscratch and immediately read it back
    li t3, 999;
    csrw mscratch, t3;
    csrr t1, mscratch;

    // Make sure what we read was what was written
    bne t3, t1, fail;

    li TESTNUM, 3;
    li t1, 0
    csrw tselect, t1;   // tselect is unsupported so writing it with zero should always return non-0.
    csrr t2, tselect;
    beq t1, t2, fail;

    j pass;

write_tohost:
    sw TESTNUM, tohost, t5;
    j write_tohost;

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
