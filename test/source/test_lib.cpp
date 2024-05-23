#include <gtest/gtest.h>

#ifndef NO_EXTERN
extern "C" {
#endif
  #include "../../source/lib.c"
#ifndef NO_EXTERN
}
#endif

TEST(test_lib, int_add)
{
  int a = 1;
  int b = 2;
  int expected = 3;

  int actual = int_add(a, b);
  EXPECT_EQ(actual, expected);
}


TEST(test_lib, float_add)
{
  float a = 1.0;
  float b = 2.5;
  float expected = 3.5;

  float actual = float_add(a, b);
  EXPECT_FLOAT_EQ(actual, expected);
}
