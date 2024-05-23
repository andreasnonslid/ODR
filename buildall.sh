#!/bin/bash

# Define build directory
BUILD_DIR="build"

# Remove the build directory if it exists
if [ -d "$BUILD_DIR" ]; then
	echo "Removing existing build directory..."
	rm -rf "$BUILD_DIR"
fi

# Create the build directory
echo "Creating build directory..."
mkdir "$BUILD_DIR"

# Navigate to the build directory
cd "$BUILD_DIR" || exit

# Install Conan dependencies
echo "Installing Conan dependencies..."
conan install .. --profile debug --build=missing

# Configure the project with CMake
echo "Configuring project with CMake..."
cmake .. -DCMAKE_TOOLCHAIN_FILE=build/Debug/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug

# Build the project
echo "Building the project..."
# all_files_w_mock will fail due to multiple definitions in linking stage
cmake --build . -- -k

# Optionally, run the tests
echo "Running tests..."

echo ""
echo ""
echo "ALL TESTS"
echo ""
./test/all_tests

echo ""
echo ""
echo "ALL TESTS WITH MOCK"
echo ""
./test/all_tests_w_mock

echo ""
echo ""
echo "ALL TESTS WITH MOCK IN SOURCELIST"
echo ""
./test/all_tests_w_mock_in_sourcelist

echo ""
echo ""
echo "ALL TESTS WITH MOCK FIRST IN SOURCELIST"
echo ""
./test/all_tests_w_mock_first_in_sourcelist

echo ""
echo ""
echo "ALL TESTS WITH MOCK IN SOURCELIST WITHOUT EXTERN"
echo ""
./test/all_tests_w_mock_in_sourcelist_no_extern

echo ""
echo ""
echo "ALL TESTS WITH MOCK FIRST IN SOURCELIST WITHOUT EXTERN"
echo ""
./test/all_tests_w_mock_first_in_sourcelist_no_extern

echo ""
echo ""
echo "FILE USING LIB SOLO TARGET"
echo ""
./test/test_file_using_lib

echo ""
echo ""
echo "LIB SOLO TARGET"
echo ""
./test/test_lib

# Return to the original directory
cd ..

echo "Read more: https://learn.microsoft.com/en-us/cpp/cpp/program-and-linkage-cpp?view=msvc-170"
