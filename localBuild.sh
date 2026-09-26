#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define directories
BUILD_DIR="build"

# Clean previous build artifacts if they exist
if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning previous build directory..."
    rm -rf "$BUILD_DIR"
fi

# Create a fresh build folder
echo "Creating fresh build directory..."
mkdir "$BUILD_DIR"

# Navigate into the build directory
cd "$BUILD_DIR"

# Configure the project using CMake
echo "Configuring project with CMake..."
cmake ..

# Build the project
echo "Building project..."
cmake --build .
