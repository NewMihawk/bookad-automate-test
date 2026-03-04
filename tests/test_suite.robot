*** Settings ***
Documentation    Complete test suite for BookAd website
Library          SeleniumLibrary
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Suite Setup      Open BookAd Website
Suite Teardown   Close BookAd Website

*** Test Cases ***
Test Complete User Journey
    [Documentation]    End-to-end test: Login -> Add to Cart -> Order
    [Tags]    e2e    smoke
    # Login
    Navigate To Login Page
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Success

    # Create Brief
    Navigate To Create Brief
    Fill Brief Form    ${TEST_CAMPAIGN_NAME_WITH_DRAFT}    ${TEST_PRODUCT_NAME_WITH_DRAFT}    ${TEST_CATEGORY}    ${TEST_DESCRIPTION_WITH_DRAFT}
    Submit Brief As Draft
    Verify Brief Created Successfully

    # Create Brief
    Navigate To Create Brief
    Fill Brief Form    ${TEST_CAMPAIGN_NAME_WITH_SAVE}    ${TEST_PRODUCT_NAME_WITH_SAVE}    ${TEST_CATEGORY}    ${TEST_DESCRIPTION_WITH_SAVE}
    Submit Brief As Save
    Verify Brief Created Successfully

    # # Add to Cart
    # Add Item To Cart
    # Verify Item Added To Cart
    
    # # Order
    # Navigate To Cart
    # Proceed To Checkout
    # Complete Order
    # Verify Order Success

