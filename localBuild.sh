#!/bin/bash

# Exit immediately if any command fails
set -e

CLEAN=false

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--clean) CLEAN=true; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done

# 1. Clean if requested
if [ "$CLEAN" = true ]; then
    echo "Cleaning build dirs"
    rm -rf build
fi

# 2. Configure (CMake is smart enough to skip work if nothing changed in the CMakeLists)
echo "Configuring project"
cmake -S . -B build

# 3. Build (Using all available CPU cores)
echo "Building project"
# $(nproc) dynamically gets the number of CPU cores on Linux/WSL
cmake --build build -j$(nproc)

# 4. Test
echo "Running tests"
ctest --test-dir build --output-on-failure