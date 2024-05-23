cmake_minimum_required(VERSION 3.15)
project(my-testTests LANGUAGES CXX)

# ---- Dependencies ----
# Find the GTest package provided by Conan
find_package(GTest REQUIRED)

# ---- Test Sources ----
set(ALL_TESTS
    ${CMAKE_CURRENT_LIST_DIR}/source/test_file_using_lib.cpp
    ${CMAKE_CURRENT_LIST_DIR}/source/test_lib.cpp
)

set(ALL_TESTS_W_MOCK
    ${ALL_TESTS}
    ${CMAKE_CURRENT_LIST_DIR}/source/mock_lib.cpp
)

set(ALL_TESTS_W_MOCK_FIRST
    ${CMAKE_CURRENT_LIST_DIR}/source/mock_lib.cpp
    ${ALL_TESTS}
)

add_executable(all_tests ${ALL_TESTS})
add_executable(all_tests_w_mock ${ALL_TESTS})
add_executable(all_tests_w_mock_in_sourcelist ${ALL_TESTS_W_MOCK}) # Here mock is a different translation unit
add_executable(all_tests_w_mock_first_in_sourcelist ${ALL_TESTS_W_MOCK})
add_executable(all_tests_w_mock_in_sourcelist_no_extern ${ALL_TESTS_W_MOCK}) # Here mock is a different translation unit
add_executable(all_tests_w_mock_first_in_sourcelist_no_extern ${ALL_TESTS_W_MOCK})
add_executable(test_file_using_lib source/test_file_using_lib.cpp)
add_executable(test_lib source/test_lib.cpp)

# this is done to simulate the case where we include the c file directly
# but do ensure it can still build the all_tests when mocking is not needed
# so we can see the difference in test results
target_compile_definitions(all_tests_w_mock PRIVATE
    MOCK_LIB
)
target_compile_definitions(test_file_using_lib PRIVATE
    MOCK_LIB
)

# this is done to show that it fails if extern c is not encapsulating the c
# include, thus breaking ODR. I do not really understand how it manage to ignore
# the ODR. My guess is that it relates to name mangling in C++ and the lack of it
# in C.

#It should fail, but regardless, having something only work due to
# extern is not good.
target_compile_definitions(all_tests_w_mock_in_sourcelist_no_extern PRIVATE
    NO_EXTERN
)
target_compile_definitions(all_tests_w_mock_first_in_sourcelist_no_extern PRIVATE
    NO_EXTERN
)

macro(add_gtest TARGET)
    target_link_libraries(${TARGET} PRIVATE gtest::gtest)
endmacro()

add_gtest(all_tests)
add_gtest(all_tests_w_mock)
add_gtest(all_tests_w_mock_in_sourcelist)
add_gtest(all_tests_w_mock_first_in_sourcelist)
add_gtest(all_tests_w_mock_in_sourcelist_no_extern)
add_gtest(all_tests_w_mock_first_in_sourcelist_no_extern)
add_gtest(test_file_using_lib)
add_gtest(test_lib)
