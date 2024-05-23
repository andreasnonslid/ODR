#include "file_using_lib.h"
#include "lib.h"
#include <stdio.h>

int print_int_add(int a, int b) {
  int result = int_add(a, b);
  printf("%d\n", result);
  return result;
}

float print_float_add(float a, float b) {
  float result = float_add(a, b);
  printf("%f\n", result);
  return result;
}
