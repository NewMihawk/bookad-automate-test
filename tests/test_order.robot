*** Settings ***
Documentation    Test cases for order functionality
Library          SeleniumLibrary
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Test Setup       Run Keywords    Open BookAd Website    AND    Navigate To Login Page    AND    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}    AND    Add Item To Cart
Test Teardown    Run Keywords    Take Screenshot On Failure    AND    Close BookAd Website

*** Test Cases ***
Test Complete Order Flow
    [Documentation]    Test order flow: go to cart, select item, book queue, select brief, confirm
    [Tags]    order    smoke    e2e
    Navigate To Cart
    Select Cart Item
    Book Queue Select Brief And Confirm

Test Order With Multiple Items
    [Documentation]    Test order flow with multiple items in cart
    [Tags]    order
    Add Item To Cart
    Navigate To Cart
    Select Cart Item
    Book Queue Select Brief And Confirm

