#include "include/riscv_test.h"
#include "include/test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

    .align 2

    li TESTNUM, 2

    li t0, 25
    li t1, 12
    add t2, t0, t1
    li t3, 37
    bne t2, t3, fail

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
