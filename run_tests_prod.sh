#!/bin/bash

# Run Robot Framework tests against PRODUCTION environment
# Usage: ./run_tests_prod.sh [test_file] [additional_options]

# Activate virtual environment
source venv/bin/activate

# Set production environment URL
PROD_URL="https://bookad.co/"

echo "=========================================="
echo "Running tests against PRODUCTION environment"
echo "URL: ${PROD_URL}"
echo "WARNING: You are testing against PRODUCTION!"
echo "=========================================="

# Check if test file is provided
if [ -z "$1" ]; then
    echo "Running all tests on PRODUCTION..."
    robot --variable BASE_URL:${PROD_URL} tests/
else
    echo "Running: $1 on PRODUCTION..."
    robot --variable BASE_URL:${PROD_URL} "$@"
fi
