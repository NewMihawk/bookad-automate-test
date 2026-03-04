*** Settings ***
Documentation    Test cases for creating brief after login
Library          SeleniumLibrary
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Test Setup       Run Keywords    Open BookAd Website    AND    Navigate To Login Page    AND    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}    AND    Verify Login Success
Test Teardown    Run Keywords    Take Screenshot On Failure    AND    Close BookAd Website

*** Test Cases ***
Test Create Brief As Draft
    [Documentation]    Test creating a brief and saving as draft
    [Tags]    brief    draft    smoke
    Navigate To Create Brief
    Fill Brief Form    ${TEST_CAMPAIGN_NAME_WITH_DRAFT}    ${TEST_PRODUCT_NAME_WITH_DRAFT}    ${TEST_CATEGORY}    ${TEST_DESCRIPTION_WITH_DRAFT}
    Submit Brief As Draft
    Verify Brief Created Successfully

Test Create Brief As Save
    [Documentation]    Test creating a brief and saving it
    [Tags]    brief    save    smoke
    Navigate To Create Brief
    Fill Brief Form    ${TEST_CAMPAIGN_NAME_WITH_SAVE}    ${TEST_PRODUCT_NAME_WITH_SAVE}    ${TEST_CATEGORY}    ${TEST_DESCRIPTION_WITH_SAVE}
    Submit Brief As Save
    Verify Brief Created Successfully

