cmake_minimum_required(VERSION 3.21)

project(
    my-test
    VERSION 0.1.0
    DESCRIPTION "My test project"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES C
)

set(MAIN_SOURCES
    ${CMAKE_CURRENT_LIST_DIR}/source/main.c
    ${CMAKE_CURRENT_LIST_DIR}/source/file_using_lib.c
    ${CMAKE_CURRENT_LIST_DIR}/source/lib.c
)

add_executable(my-test_exe ${MAIN_SOURCES})

set_property(TARGET my-test_exe PROPERTY OUTPUT_NAME my-test)

target_compile_features(my-test_exe PRIVATE c_std_99)

include_directories(${CMAKE_CURRENT_LIST_DIR}/include)

add_subdirectory(test)
