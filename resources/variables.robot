*** Variables ***
${BASE_URL}              https://staging.bookad.co/
${BROWSER}               chrome
${TIMEOUT}               2s
${DELAY}                 2s

# Login credentials (update with actual test credentials)
${VALID_USERNAME}        auto_test@mail.com
${VALID_PASSWORD}        Muze6565

# Test data
${CART_TIMEOUT}          15s

# Brief creation test data
${TEST_CAMPAIGN_NAME_WITH_DRAFT}        Test Campaign Draft
${TEST_CAMPAIGN_NAME_WITH_SAVE}        Test Campaign Save
${TEST_PRODUCT_NAME_WITH_DRAFT}         Test Product Draft
${TEST_PRODUCT_NAME_WITH_SAVE}         Test Product Save
${TEST_CATEGORY}             Electronics & Technology
${TEST_DESCRIPTION_WITH_DRAFT}          This is a test description for the brief draft
${TEST_DESCRIPTION_WITH_SAVE}          This is a test description for the brief save
