# BookAd Robot Framework Test Suite

This project contains automated tests for the BookAd website using Robot Framework. Tests can be run against both **staging** (https://staging.bookad.co/) and **production** (https://bookad.co/) environments.

## Features

- **Login Testing**: Test login functionality with valid/invalid credentials
- **Add to Cart**: Test adding items to the shopping cart
- **Order Processing**: Test the complete order flow from cart to confirmation
- **Multi-Environment Support**: Run tests against staging or production environments

## Quick Start

```bash
# Setup (first time only)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run tests on STAGING
./run_tests_staging.sh

# Run tests on PRODUCTION
./run_tests_prod.sh

# Run specific test on staging
./run_tests_staging.sh tests/test_login.robot
```

## Prerequisites

- Python 3.7 or higher
- pip (Python package manager)
- Chrome browser installed (for Chrome tests)

## Installation

1. Clone or navigate to this project directory:

   ```bash
   cd bookad-robot
   ```

2. Create a virtual environment (recommended):

   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Configuration

Before running tests, update the login credentials in `resources/variables.robot`:

```robot
${VALID_USERNAME}        your_username@example.com
${VALID_PASSWORD}        your_password
```

## Running Tests

### Option 1: Using the helper script (Recommended)

```bash
# Activate virtual environment first
source venv/bin/activate

# Then use the script
./run_tests.sh                    # Run all tests
./run_tests.sh tests/test_login.robot  # Run specific test
```

### Option 2: Direct Robot Framework command

```bash
# Activate virtual environment first
source venv/bin/activate

# Run all tests:
robot tests/

# Run specific test suite:
robot tests/test_login.robot
robot tests/test_add_to_cart.robot
robot tests/test_order.robot

# Run end-to-end test:
robot tests/test_suite.robot
```

### Option 3: Run tests by tags:

```bash
source venv/bin/activate
robot --include smoke tests/
robot --include login tests/
robot --include cart tests/
robot --include order tests/
robot --include e2e tests/
```

### Option 4: Run with specific browser:

```bash
source venv/bin/activate
robot --variable BROWSER:firefox tests/
robot --variable BROWSER:headlesschrome tests/
```

### Option 5: Run tests for specific environments (STAGING/PRODUCTION)

The project includes dedicated scripts for running tests against different environments:

#### Running Tests on STAGING Environment

**Using the staging script (Recommended):**

```bash
# Make sure scripts are executable (first time only)
chmod +x run_tests_staging.sh

# Run all tests on staging
./run_tests_staging.sh

# Run specific test file on staging
./run_tests_staging.sh tests/test_login.robot

# Run tests with additional options (e.g., specific tags)
./run_tests_staging.sh --include smoke tests/
```

**Using Robot Framework directly:**

```bash
source venv/bin/activate

# Run all tests on staging
robot --variable BASE_URL:https://staging.bookad.co/ tests/

# Run specific test on staging
robot --variable BASE_URL:https://staging.bookad.co/ tests/test_login.robot

# Run with tags on staging
robot --variable BASE_URL:https://staging.bookad.co/ --include smoke tests/
```

#### Running Tests on PRODUCTION Environment

⚠️ **WARNING**: Be cautious when running tests against production. Make sure you have proper authorization and that tests won't affect real user data.

**Using the production script (Recommended):**

```bash
# Make sure scripts are executable (first time only)
chmod +x run_tests_prod.sh

# Run all tests on production
./run_tests_prod.sh

# Run specific test file on production
./run_tests_prod.sh tests/test_login.robot

# Run tests with additional options
./run_tests_prod.sh --include smoke tests/
```

**Using Robot Framework directly:**

```bash
source venv/bin/activate

# Run all tests on production
robot --variable BASE_URL:https://bookad.co/ tests/

# Run specific test on production
robot --variable BASE_URL:https://bookad.co/ tests/test_login.robot

# Run with tags on production
robot --variable BASE_URL:https://bookad.co/ --include smoke tests/
```

#### Environment URLs

- **Staging**: `https://staging.bookad.co/`
- **Production**: `https://bookad.co/`

> **Note**: The default BASE_URL in `resources/variables.robot` is set to staging. When using the environment-specific scripts or passing `--variable BASE_URL`, the URL is overridden for that test run only.

#### Combining Environment and Other Options

You can combine environment selection with other Robot Framework options:

```bash
# Run smoke tests on staging with headless browser
robot --variable BASE_URL:https://staging.bookad.co/ --variable BROWSER:headlesschrome --include smoke tests/

# Run specific test on production with Firefox
robot --variable BASE_URL:https://bookad.co/ --variable BROWSER:firefox tests/test_login.robot

# Run tests on staging with custom output directory
robot --variable BASE_URL:https://staging.bookad.co/ --outputdir results/staging tests/
```

### Generate reports:

Reports are automatically generated in the current directory:

- `log.html` - Detailed test execution log
- `report.html` - Test execution report
- `output.xml` - XML output for CI/CD integration

> **Tip**: For better organization, you can specify different output directories for different environments:
> ```bash
> robot --variable BASE_URL:https://staging.bookad.co/ --outputdir results/staging tests/
> robot --variable BASE_URL:https://bookad.co/ --outputdir results/production tests/
> ```

## Project Structure

```
bookad-robot/
├── resources/
│   ├── variables.robot      # Test variables and configuration
│   ├── keywords.robot       # Reusable keywords
│   └── page_objects.robot   # Page object locators
├── tests/
│   ├── test_login.robot     # Login test cases
│   ├── test_add_to_cart.robot  # Add to cart test cases
│   ├── test_order.robot    # Order test cases
│   └── test_suite.robot    # End-to-end test suite
├── screenshots/             # Screenshots on test failures
├── requirements.txt         # Python dependencies
├── run_tests.sh            # Helper script to run tests (default/staging)
├── run_tests_staging.sh    # Helper script to run tests on staging
├── run_tests_prod.sh       # Helper script to run tests on production
├── .gitignore              # Git ignore file
└── README.md               # This file
```

## Customization

### Updating Element Locators

The page object locators in `resources/page_objects.robot` use XPath and CSS selectors. You may need to update these based on the actual HTML structure of the website:

1. Inspect the website elements using browser developer tools
2. Update the locators in `resources/page_objects.robot`
3. Test the updated locators

### Adding New Test Cases

1. Create a new test file in `tests/` directory
2. Import necessary resources
3. Use existing keywords from `resources/keywords.robot` or create new ones

## Troubleshooting

### Browser Driver Issues

If you encounter browser driver issues:

- Make sure Chrome browser is installed
- The webdriver-manager package should automatically download the correct ChromeDriver
- If issues persist, you can manually download ChromeDriver from https://chromedriver.chromium.org/

### Element Not Found Errors

If tests fail with "Element not found" errors:

1. Check if the website structure has changed
2. Update the locators in `resources/page_objects.robot`
3. Verify the website is accessible at https://staging.bookad.co/
4. Use browser developer tools to inspect elements and get correct selectors

### Timeout Issues

If tests timeout, you can increase the timeout values in `resources/variables.robot`:

```robot
${TIMEOUT}    20s
```

### Command Not Found Error

If you get `robot: command not found`, make sure you:

1. Have activated the virtual environment: `source venv/bin/activate`
2. Have installed dependencies: `pip install -r requirements.txt`

## Notes

- Screenshots are automatically captured on test failures
- Tests are designed to be independent and can run in any order
- The test suite uses implicit waits for better stability
- Make sure to update element locators based on the actual website structure

## License

This project is for testing purposes only.
