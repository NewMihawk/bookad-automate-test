*** Settings ***
Documentation    Test cases for login functionality
Library          SeleniumLibrary
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Test Setup       Open BookAd Website
Test Teardown    Run Keywords    Take Screenshot On Failure    AND    Close BookAd Website

*** Test Cases ***
Test Login With Valid Credentials
    [Documentation]    Test login with valid username and password
    [Tags]    login    smoke
    Navigate To Login Page
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Success

Test Login With Invalid Credentials
    [Documentation]    Test login with invalid username and password
    [Tags]    login
    Navigate To Login Page
    Login With Credentials    invalid@example.com    wrongpassword
    Verify Login Failed


