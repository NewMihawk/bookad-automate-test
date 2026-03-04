#!/bin/bash

# Activate virtual environment and run Robot Framework tests
# Usage: ./run_tests.sh [test_file] [options]

# Activate virtual environment
source venv/bin/activate

# Check if test file is provided
if [ -z "$1" ]; then
    echo "Running all tests..."
    robot tests/
else
    echo "Running: $1"
    robot "$@"
fi

