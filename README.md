# What is this?
I have built a simple example project with the intent to show how combining test files into one executable can cause issues for isolation of tests.

# Project setup
I have three source files and some test files in a test dir testing them. Let's focus on the source files to set the stage for how to understand the point of this.

1. `lib.c` which adds very naive add functions for integers and floats, where the float function has a mistake.
2. `file_using_lib.c` is just a file which uses these naive add functions, and prints their result before returning it again. This has no mistakes, but won't work as expected if you use the implementations from `lib.c`
3. `main.c` which is a file you can run if you want, which is supposed to be the end product. It is currently not "working as expected", due to the mistake in `lib.c`. 

To figure out where the issue occurs one might want to check out unit-tests and see where a test fails. One would want tests testing `lib.c` to fail, but any other test file/suite should pass still.

# The executables in this example
I created these executables in the test directory's `CMakeLists.txt` to highlight how different configurations would work/not work.

```
add_gtest(all_tests)
add_gtest(all_tests_w_mock)
add_gtest(all_tests_w_mock_in_sourcelist)
add_gtest(all_tests_w_mock_first_in_sourcelist)
add_gtest(all_tests_w_mock_in_sourcelist_no_extern)
add_gtest(all_tests_w_mock_first_in_sourcelist_no_extern)
add_gtest(test_file_using_lib)
add_gtest(test_lib)
```

The two test files are `test_lib.cpp` and `test_file_using_lib.cpp`. These include the file they are testing directly. The `test_file_using_lib.cpp` also may include a mock file mocking the `lib.c` functions.

- `all_tests`: includes both test files
- `all_tests_w_mock`: includes both test files and defines `MOCK_LIB` thus including the `mock_lib.cpp` file in the `test_file_using_lib.cpp` tests
- `all_tests_w_mock_in_sourcelist`: includes both test files and adds `mock_lib.cpp` to the source list directly
- `all_tests_w_mock_first_in_sourcelist`: includes both test files and adds `mock_lib.cpp` to the source list but first
- `all_tests_w_mock_in_sourcelist_no_extern`: same as `all_tests_w_mock_in_sourcelist` but does not use `extern "C"`
- `all_tests_w_mock_first_in_sourcelist_no_extern`: same as `all_tests_w_mock_first_in_sourcelist` but does not use `extern "C"`
- `test_file_using_lib`: tests using only `test_file_using_lib` as source and defining `MOCK_LIB` to use mock function
- `test_lib`: same as `test_file_using_lib` but for `lib.c`

# Results from trying to build/run this
To see the output of this, clone this or download the output.txt file which is in the root of this repo, and open it with `cat`;

`cat output.txt`.

This will show how some builds fail, some builds succeed but work in quite odd ways, and some work as expected.

## Results summarized
When both test files are compiled into the same executable it fails in both test suites due to them using the function definitions of `lib.c` OR fails building if we don't use the `extern` keyword. (read: https://en.cppreference.com/w/cpp/language/definition).

This means that you are stuck with the implementation from `lib.c` if you are testing a `C` file and can use `extern`, but can't even build with a mock implementation as it would break the ODR. Obviously, this is a result of the functions not being static, but that is exactly the point. Sometimes functions just are not static but would still be nice to test or will be used in something you want to test. It will then violate YOU before you are allowed to violate the ODR.

Another perspective is that in **every** executable which had `test_file_using_lib.cpp` as a TU, only the targets which did not also have the `test_lib.cpp` as a TU correctly passed all tests.

# Final thoughts
Having many TU's in a single unit test executable causes more harm than good, and should not be done. 

## Idea for possible way to still have all in the same executable (idk though)
Perhaps there is a clean way to do it via the use of compiling source files as static libraries or something like that though.
