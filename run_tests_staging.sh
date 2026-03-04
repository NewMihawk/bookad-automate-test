#!/bin/bash

# Run Robot Framework tests against STAGING environment
# Usage: ./run_tests_staging.sh [test_file] [additional_options]

# Activate virtual environment
source venv/bin/activate

# Set staging environment URL
STAGING_URL="https://staging.bookad.co/"

echo "=========================================="
echo "Running tests against STAGING environment"
echo "URL: ${STAGING_URL}"
echo "=========================================="

# Check if test file is provided
if [ -z "$1" ]; then
    echo "Running all tests on STAGING..."
    robot --variable BASE_URL:${STAGING_URL} tests/
else
    echo "Running: $1 on STAGING..."
    robot --variable BASE_URL:${STAGING_URL} "$@"
fi
