#include <gtest/gtest.h>

extern "C" {
  #include "../../source/file_using_lib.c"
}

#ifdef MOCK_LIB
  #include "mock_lib.cpp"
#endif

TEST(test_file_using_lib, int_add)
{
  int a = 1;
  int b = 2;
  int expected = 3;

  int actual = print_int_add(a, b);
  EXPECT_EQ(actual, expected);
}


TEST(test_file_using_lib, float_add)
{
  float a = 1.0;
  float b = 2.5;
  float expected = 3.5;

  float actual = print_float_add(a, b);
  EXPECT_FLOAT_EQ(actual, expected);
}
