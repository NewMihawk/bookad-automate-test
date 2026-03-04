*** Settings ***
Documentation    Test cases for add to cart functionality
Library          SeleniumLibrary
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Test Setup       Run Keywords    Open BookAd Website    AND    Navigate To Login Page    AND    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
Test Teardown    Run Keywords    Take Screenshot On Failure    AND    Close BookAd Website

*** Test Cases ***
Test Add Item To Cart And Delete
    [Documentation]    Test adding an item to the cart
    [Tags]    cart    smoke
    Add Item To Cart
    Verify Item Added To Cart And Delete

