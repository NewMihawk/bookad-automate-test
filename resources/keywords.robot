*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource    variables.robot
Resource    page_objects.robot

*** Keywords ***
Open BookAd Website
    [Documentation]    Opens the BookAd website in the browser
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${TIMEOUT}
    Sleep    2s
    # Wait for page to load
    ${status}=    Run Keyword And Return Status    Wait Until Page Contains    BookAd    timeout=${TIMEOUT}
    Run Keyword If    not ${status}    Wait Until Location Contains    bookad    timeout=${TIMEOUT}

Close BookAd Website
    [Documentation]    Closes the browser
    Close All Browsers

Navigate To Login Page
    [Documentation]    Navigates to the login page
    Click Element    ${LOGIN_BUTTON}
    # Wait for login form or any input field to appear
    ${form_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${LOGIN_FORM}    timeout=${TIMEOUT}
    ${input_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    //input    timeout=${TIMEOUT}
    Run Keyword If    not ${form_visible} and not ${input_visible}    Sleep    2s

Login With Credentials
    [Arguments]    ${username}    ${password}
    [Documentation]    Performs login with provided credentials
    # Wait for page to be ready
    Sleep    0.5s
    # Wait for and find email/username input field
    ${email_found}=    Wait For Email Input
    Run Keyword If    not ${email_found}    Debug Login Page Elements
    Should Be True    ${email_found}    Email/Username input field not found. Please check the login page structure.
    
    # Scroll to email input and ensure it's visible
    Scroll Element Into View    ${EMAIL_INPUT_FOUND}
    Wait Until Element Is Visible    ${EMAIL_INPUT_FOUND}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${EMAIL_INPUT_FOUND}    timeout=${TIMEOUT}
    
    # Clear and input email (only if not empty)
    Clear Element Text    ${EMAIL_INPUT_FOUND}
    Run Keyword If    '${username}' != '${EMPTY}'    Input Text    ${EMAIL_INPUT_FOUND}    ${username}
    
    # Wait for and find password input field
    ${password_found}=    Wait For Password Input
    Should Be True    ${password_found}    Password input field not found. Please check the login page structure.
    
    # Scroll to password input and ensure it's visible
    Scroll Element Into View    ${PASSWORD_INPUT_FOUND}
    Wait Until Element Is Visible    ${PASSWORD_INPUT_FOUND}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${PASSWORD_INPUT_FOUND}    timeout=${TIMEOUT}
    
    # Clear and input password (only if not empty)
    Clear Element Text    ${PASSWORD_INPUT_FOUND}
    Run Keyword If    '${password}' != '${EMPTY}'    Input Text    ${PASSWORD_INPUT_FOUND}    ${password}
    
    # Click submit button
    ${submit_found}=    Wait For Submit Button
    Should Be True    ${submit_found}    Submit button not found. Please check the login page structure.
    
    # Scroll to submit button
    Scroll Element Into View    ${SUBMIT_BUTTON_FOUND}
    Wait Until Element Is Visible    ${SUBMIT_BUTTON_FOUND}    timeout=${TIMEOUT}
    
    # Check if button is enabled before clicking
    # If credentials are empty, button may be disabled (form validation)
    ${is_enabled}=    Run Keyword And Return Status    Element Should Be Enabled    ${SUBMIT_BUTTON_FOUND}
    Run Keyword If    ${is_enabled}    Click Element    ${SUBMIT_BUTTON_FOUND}
    ...    ELSE    Log    Submit button is disabled - form validation preventing submission (expected for empty credentials)    level=INFO    
    Sleep    0.5s

Wait For Email Input
    [Documentation]    Waits for email/username input field and stores the found locator
    ${locators}=    Create List
    ...    //input[@type='email']
    ...    //input[@name='email']
    ...    //input[@name='username']
    ...    //input[@name='user_email']
    ...    //input[@id='email']
    ...    //input[@id='username']
    ...    //input[@id='user_email']
    ...    //input[@id='user-email']
    ...    //input[contains(@placeholder, 'email') or contains(@placeholder, 'Email') or contains(@placeholder, 'อีเมล')]
    ...    //input[contains(@placeholder, 'username') or contains(@placeholder, 'Username')]
    ...    //input[contains(@class, 'email') or contains(@class, 'username')]
    ...    //form//input[@type='text'][1]
    ...    //form//input[not(@type='password')][1]
    ...    (//input[@type='text'])[1]
    ...    (//input[not(@type='password')])[1]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${EMAIL_INPUT_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Wait For Password Input
    [Documentation]    Waits for password input field and stores the found locator
    ${locators}=    Create List
    ...    //input[@type='password']
    ...    //input[@name='password']
    ...    //input[@name='user_password']
    ...    //input[@id='password']
    ...    //input[@id='user_password']
    ...    //input[@id='user-password']
    ...    //input[contains(@placeholder, 'password') or contains(@placeholder, 'Password') or contains(@placeholder, 'รหัสผ่าน')]
    ...    //input[contains(@class, 'password')]
    ...    //form//input[@type='password']
    ...    (//input[@type='password'])[1]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${PASSWORD_INPUT_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Wait For Submit Button
    [Documentation]    Waits for submit button and stores the found locator
    ${locators}=    Create List
    ...    //button[@type='submit']
    ...    //button[contains(text(), 'เข้าสู่ระบบ')]
    ...    //button[contains(text(), 'Login')]
    ...    //button[contains(text(), 'Sign in')]
    ...    //button[contains(text(), 'Log in')]
    ...    //button[contains(@class, 'login') or contains(@class, 'submit')]
    ...    //input[@type='submit']
    ...    //form//button[last()]
    ...    //form//button[@type='submit']
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${SUBMIT_BUTTON_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Verify Login Success
    [Documentation]    Verifies that login was successful by checking multiple conditions quickly
    # Check if login form is gone (with shorter timeout for faster response)
    ${form_gone}=    Run Keyword And Return Status    Wait Until Page Does Not Contain Element    ${LOGIN_FORM}    timeout=3s
    Run Keyword If    ${form_gone}    Return From Keyword
    
    # Quick check: verify we're no longer on login page (text check)
    ${not_login_text}=    Run Keyword And Return Status    Page Should Not Contain    เข้าสู่ระบบ
    Run Keyword If    ${not_login_text}    Return From Keyword
    
    # Check if URL changed (indicates redirect after login)
    ${current_url}=    Get Location
    ${url_changed}=    Evaluate    'login' not in '${current_url}'.lower() and 'เข้าสู่ระบบ' not in '${current_url}'
    Run Keyword If    ${url_changed}    Return From Keyword
    
    # Final verification - if form still exists, login may have failed
    ${form_still_exists}=    Run Keyword And Return Status    Page Should Contain Element    ${LOGIN_FORM}
    Should Not Be True    ${form_still_exists}    Login form is still visible. Login may have failed.

Verify Login Failed
    [Documentation]    Verifies that login failed by checking for error modal/message or disabled submit button
    # First check for error message element (fastest - most common failure case)
    ${error_message_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${ERROR_MESSAGE}    timeout=3s
    Run Keyword If    ${error_message_visible}    Return From Keyword
    
    # Check for error modal element (if message element not found, check modal)
    ${error_modal_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${ERROR_MODAL}    timeout=2s
    Run Keyword If    ${error_modal_visible}    Return From Keyword
    
    # Check for error text on the page (quick text check)
    ${error_text_visible}=    Run Keyword And Return Status    Page Should Contain    The email or password provided is incorrect
    Run Keyword If    ${error_text_visible}    Return From Keyword
    
    # Check for partial error text
    ${error_text_partial}=    Run Keyword And Return Status    Page Should Contain    email or password
    Run Keyword If    ${error_text_partial}    Return From Keyword
    
    # Check if submit button is disabled (form validation - common for empty fields)
    ${submit_found}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${SUBMIT_BUTTON_FOUND}    timeout=2s
    ${button_disabled}=    Run Keyword If    ${submit_found}    Run Keyword And Return Status    Element Should Be Disabled    ${SUBMIT_BUTTON_FOUND}
    ...    ELSE    Set Variable    ${False}
    Run Keyword If    ${button_disabled}    Return From Keyword
    
    # Check for other error indicators (fallback)
    ${error_text_incorrect}=    Run Keyword And Return Status    Page Should Contain    incorrect
    ${validation_visible}=    Run Keyword And Return Status    Page Should Contain    required
    ${validation_visible_thai}=    Run Keyword And Return Status    Page Should Contain    กรุณา
    
    # Verify that at least one error/validation indicator is present
    ${result}=    Evaluate    ${error_modal_visible} or ${error_message_visible} or ${error_text_visible} or ${error_text_partial} or ${error_text_incorrect} or ${validation_visible} or ${validation_visible_thai} or ${button_disabled}
    Should Be True    ${result}    Expected error message, validation, or disabled button not found. Login may have succeeded or error message format changed.

Add Item To Cart
    [Documentation]    Verifies that an item was successfully added to the cart: find GoodDay Official, click view details, select Kodey, choose a non-disabled date from the datepicker, select advertisement option, and add to cart.
    # Wait for the cart/item area to be visible
    Sleep    ${DELAY}
    
    # Step 1: Try to find and click "GoodDay Official" text (optional - continue if fails)
    ${goodday_clicked}=    Run Keyword And Return Status    Run Keywords
    ...    Wait Until Page Contains Element    ${GOODDAY_OFFICIAL_TEXT}    timeout=${CART_TIMEOUT}
    ...    AND    Wait Until Element Is Visible    ${GOODDAY_OFFICIAL_TEXT}    timeout=${CART_TIMEOUT}
    ...    AND    Element Should Be Visible    ${GOODDAY_OFFICIAL_TEXT}
    ...    AND    Click Element    ${GOODDAY_OFFICIAL_TEXT}
    Run Keyword If    ${goodday_clicked}    Log    Found and clicked "GoodDay Official" text in cart
    ...    ELSE    Log    "GoodDay Official" not found or click failed, continuing to Kodey
    Run Keyword If    ${goodday_clicked}    Sleep    ${DELAY}
    
    # Step 2: Open details (ดูรายละเอียดช่อง) then select first program
    # Avoid Mouse Over on off-screen elements (causes MoveTargetOutOfBoundsException). Use JS to scroll card into view and trigger hover; then click via Selenium or JS.
    ${details_present}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${GOODDAY_VIEW_DETAILS_BUTTON}    timeout=${CART_TIMEOUT}
    Run Keyword If    ${details_present}    Execute JavaScript
    ...    (function(){ var btn = Array.from(document.querySelectorAll('button')).find(b => b.textContent && b.textContent.trim().includes('ดูรายละเอียดช่อง')); if (!btn) return; var card = btn.closest('div[class*="absolute"]') || btn.closest('div[class*="relative"]') || btn.parentElement; if (card) { card.scrollIntoView({block: 'center', behavior: 'instant'}); card.dispatchEvent(new MouseEvent('mouseover', { bubbles: true })); card.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true })); } btn.scrollIntoView({block: 'center', behavior: 'instant'}); })();
    Run Keyword If    ${details_present}    Sleep    0.5s
    ${details_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${GOODDAY_VIEW_DETAILS_BUTTON}    timeout=2s
    Run Keyword If    ${details_visible}    Click Element    ${GOODDAY_VIEW_DETAILS_BUTTON}
    ...    ELSE IF    ${details_present}    Execute JavaScript    Array.from(document.querySelectorAll('button')).find(b => b.textContent && b.textContent.trim().includes('ดูรายละเอียดช่อง'))?.click();
    Sleep    ${DELAY}

    # Step 2b: Click the first program card in the grid (not searching for specific Kodey text)
    Wait Until Page Contains Element    ${PROGRAM_GRID}    timeout=${CART_TIMEOUT}
    Wait Until Element Is Visible    ${FIRST_PROGRAM_CARD}    timeout=${CART_TIMEOUT}
    Click Element    ${FIRST_PROGRAM_CARD}
    Log    Clicked first program card in grid
    Sleep    ${DELAY}
    
    # Step 3: Open datepicker and select a non-disabled date (click next until one is found)
    Select Available Date From Datepicker
    
    # Step 4: Select advertisement option and add to cart
    Select Advertisement And Add To Cart

Select Available Date From Datepicker
    [Documentation]    Clicks the datepicker trigger, then selects a non-disabled date from the on-air list. If all are disabled, clicks next until an enabled one is found.
    Wait Until Element Is Visible    ${ON_AIR_DATE_LIST}    timeout=${CART_TIMEOUT}
    Set Test Variable    ${date_selected}    False
    FOR    ${i}    IN RANGE    12
        # Wait a moment for the list to stabilize (especially after clicking next)
        Sleep    0.5s
        # Get all date items (both enabled and disabled)
        ${all_elements}=    Get WebElements    ${ON_AIR_DATE_ITEM_ALL}
        ${all_count}=    Get Length    ${all_elements}
        # Get only enabled date items (not disabled)
        ${enabled_elements}=    Get WebElements    ${ON_AIR_DATE_ITEM_ENABLED}
        ${enabled_count}=    Get Length    ${enabled_elements}
        Log    Iteration ${i+1}/12: Found ${all_count} total date items, ${enabled_count} enabled date(s)
        
        # STEP 1: If we have enabled dates, click the first one and exit loop
        Run Keyword If    ${enabled_count} > 0    Run Keywords
        ...    Scroll Element Into View    ${ON_AIR_DATE_ITEM_ENABLED}
        ...    AND    Click Element    ${ON_AIR_DATE_ITEM_ENABLED}
        ...    AND    Set Test Variable    ${date_selected}    True
        ...    AND    Log    ✓ Successfully selected enabled date!
        ...    AND    Exit For Loop
        
        # STEP 2: If no enabled elements found (all disabled or empty), click next button and loop again
        Run Keyword If    ${enabled_count} == 0    Go To Next Month In Datepicker    ${all_count}
    END
    Should Be True    ${date_selected}    No enabled date found in datepicker after 12 next clicks
    Log    Selected an enabled date from datepicker
    Sleep    ${DELAY}

Go To Next Month In Datepicker
    [Arguments]    ${all_count}
    [Documentation]    Clicks the next-month button (with JS click fallback) and waits for the on-air date list to update.
    Log    ✗ No enabled dates found (${all_count} total dates, all disabled)
    Wait Until Element Is Visible    ${DATEPICKER_NEXT_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${DATEPICKER_NEXT_BUTTON}
    ${next_clicked}=    Run Keyword And Return Status    Click Element    ${DATEPICKER_NEXT_BUTTON}
    Run Keyword If    not ${next_clicked}    Run Keyword And Ignore Error    Click Next Month Via JS    ${DATEPICKER_NEXT_BUTTON}
    Run Keyword If    ${next_clicked}    Log    → Clicked next button, waiting for next month's dates to load...
    Run Keyword If    not ${next_clicked}    Log    → Attempted to click next button (normal click failed, tried JS fallback), waiting for next month's dates to load...
    Sleep    1.5s
    Wait Until Element Is Visible    ${ON_AIR_DATE_LIST}    timeout=${CART_TIMEOUT}
    Log    → Date list updated, will check for enabled dates in next iteration

Click Next Month Via JS
    [Arguments]    ${locator}
    [Documentation]    Fallback JS click for next-month button. Finds element by class and chevron image.
    Execute JavaScript    (function() { var divs = document.querySelectorAll('div.cursor-pointer.rounded-full'); for (var i = 0; i < divs.length; i++) { var img = divs[i].querySelector('img[src*=\"chevron\"]'); var hasRotate270 = divs[i].className.includes('rotate-[270deg]'); if (img && hasRotate270) { divs[i].click(); return true; } } return false; })();

Select Advertisement And Add To Cart
    [Documentation]    Selects the 60-Second Advertisement Spot option and clicks the "เพิ่มไปยังตะกร้า" button
    Wait Until Element Is Visible    ${ADVERTISMENT_OPTION}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${ADVERTISMENT_OPTION}
    Wait Until Element Is Enabled    ${ADVERTISMENT_OPTION}    timeout=${CART_TIMEOUT}
    Click Element    ${ADVERTISMENT_OPTION}
    Log    Selected 60-Second Advertisement Spot
    Sleep    ${DELAY}
    
    Wait Until Element Is Visible    ${ADD_TO_CART_FINAL_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${ADD_TO_CART_FINAL_BUTTON}
    Wait Until Element Is Enabled    ${ADD_TO_CART_FINAL_BUTTON}    timeout=${CART_TIMEOUT}
    Click Element    ${ADD_TO_CART_FINAL_BUTTON}
    Log    Clicked "เพิ่มไปยังตะกร้า" button
    Sleep    ${DELAY}

Verify Item Added To Cart And Delete
    [Documentation]    Opens cart, asserts item count = 1, deletes the item (ลบ), and verifies cart is empty.
    Wait Until Element Is Visible    ${CART_ICON}    timeout=${CART_TIMEOUT}
    Click Element    ${CART_ICON}
    Sleep    ${DELAY}
    # Some flows open cart in a new tab/window
    Run Keyword And Ignore Error    Switch Window    NEW
    Sleep    0.5s

    # Assert cart item count == 1
    Wait Until Element Is Visible    ${CART_ITEM}    timeout=${CART_TIMEOUT}
    ${items}=    Get WebElements    ${CART_ITEM}
    ${count}=    Get Length    ${items}
    Should Be Equal As Integers    ${count}    1
    Log    Cart item count is 1 (as expected)

    # Delete item (click "ลบ")
    Wait Until Page Contains Element    ${CART_DELETE_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${CART_DELETE_BUTTON}
    Wait Until Element Is Visible    ${CART_DELETE_BUTTON}    timeout=${CART_TIMEOUT}
    Sleep    ${DELAY}
    Click Element    ${CART_DELETE_BUTTON}
    Sleep    ${DELAY}
    
    # Confirm deletion in modal (click "ยืนยัน")
    Wait Until Element Is Visible    ${DELETE_CONFIRM_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${DELETE_CONFIRM_BUTTON}
    Click Element    ${DELETE_CONFIRM_BUTTON}
    Sleep    ${DELAY}

    # Verify deletion success (cart item count == 0)
    Wait Until Keyword Succeeds    ${CART_TIMEOUT}    1s    Cart Should Be Empty
    Log    Delete item success (cart is empty)

Cart Should Be Empty
    ${items}=    Get WebElements    ${CART_ITEM}
    ${count}=    Get Length    ${items}
    Should Be Equal As Integers    ${count}    0

Navigate To Cart
    [Documentation]    Navigates to the cart page
    Click Element    ${CART_ICON}
    ${status1}=    Run Keyword And Return Status    Wait Until Page Contains    ตะกร้า    timeout=${TIMEOUT}
    ${status2}=    Run Keyword And Return Status    Wait Until Page Contains    Cart    timeout=${TIMEOUT}
    ${result}=    Evaluate    ${status1} or ${status2}
    Should Be True    ${result}    Cart page did not load

Select Cart Item
    [Documentation]    Selects the first cart item (checkbox/card).
    Wait Until Page Contains Element    ${CART_ITEM}    timeout=${CART_TIMEOUT}
    ${selected}=    Run Keyword And Return Status    Click Element    ${CART_SELECT_ITEM}
    Run Keyword If    not ${selected}    Click Element    ${CART_ITEM}
    Sleep    ${DELAY}

Book Queue Select Brief And Confirm
    [Documentation]    Clicks จองคิว, selects a brief, and confirms (ยืนยัน).
    Wait Until Element Is Visible    ${BOOK_QUEUE_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${BOOK_QUEUE_BUTTON}
    Click Element    ${BOOK_QUEUE_BUTTON}
    Sleep    ${DELAY}

    # Select brief (choose first available option)
    Wait Until Element Is Visible    ${BRIEF_SELECT_TRIGGER}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${BRIEF_SELECT_TRIGGER}
    Click Element    ${BRIEF_SELECT_TRIGGER}
    Sleep    0.5s
    Wait Until Element Is Visible    ${BRIEF_OPTION_FIRST}    timeout=${CART_TIMEOUT}
    Click Element    ${BRIEF_OPTION_FIRST}
    Sleep    0.5s

    # Confirm
    Wait Until Element Is Visible    ${BRIEF_CONFIRM_BUTTON}    timeout=${CART_TIMEOUT}
    Scroll Element Into View    ${BRIEF_CONFIRM_BUTTON}
    Click Element    ${BRIEF_CONFIRM_BUTTON}
    Sleep    ${DELAY}

Proceed To Checkout
    [Documentation]    Proceeds to checkout from the cart
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=${TIMEOUT}
    Click Button    ${CHECKOUT_BUTTON}
    Sleep    ${DELAY}

Complete Order
    [Documentation]    Completes the order process
    ${status1}=    Run Keyword And Return Status    Wait Until Page Contains    สั่งซื้อ    timeout=${TIMEOUT}
    ${status2}=    Run Keyword And Return Status    Wait Until Page Contains    Order    timeout=${TIMEOUT}
    ${status3}=    Run Keyword And Return Status    Wait Until Page Contains    Checkout    timeout=${TIMEOUT}
    ${result}=    Evaluate    ${status1} or ${status2} or ${status3}
    Should Be True    ${result}    Order page did not load
    Run Keyword If    '${PLACE_ORDER_BUTTON}' != '${EMPTY}'    Click Button    ${PLACE_ORDER_BUTTON}
    Sleep    ${DELAY}

Verify Order Success
    [Documentation]    Verifies that the order was placed successfully
    ${status1}=    Run Keyword And Return Status    Wait Until Page Contains    สำเร็จ    timeout=${TIMEOUT}
    ${status2}=    Run Keyword And Return Status    Wait Until Page Contains    Success    timeout=${TIMEOUT}
    ${status3}=    Run Keyword And Return Status    Wait Until Page Contains    ขอบคุณ    timeout=${TIMEOUT}
    ${status4}=    Run Keyword And Return Status    Wait Until Page Contains    Thank you    timeout=${TIMEOUT}
    ${result}=    Evaluate    ${status1} or ${status2} or ${status3} or ${status4}
    Should Be True    ${result}    Order was not successful

Take Screenshot On Failure
    [Documentation]    Takes a screenshot when a test fails
    Run Keyword If Test Failed    Capture Page Screenshot    screenshots/failure-{index}.png

Debug Login Page Elements
    [Documentation]    Debug helper to find all input elements on the login page
    ...    Use this keyword if login is failing to see what elements are available
    Log    === DEBUG: Searching for input elements ===    level=INFO
    ${all_inputs}=    Get WebElements    //input
    ${input_count}=    Get Length    ${all_inputs}
    Log    Found ${input_count} input elements on the page    level=INFO
    FOR    ${index}    ${input}    IN ENUMERATE    @{all_inputs}
        ${type_attr}=    Get Element Attribute    ${input}    type
        ${name_attr}=    Get Element Attribute    ${input}    name
        ${id_attr}=    Get Element Attribute    ${input}    id
        ${placeholder_attr}=    Get Element Attribute    ${input}    placeholder
        Log    Input #${index}: type="${type_attr}", name="${name_attr}", id="${id_attr}", placeholder="${placeholder_attr}"    level=INFO
    END
    Log    === DEBUG: Searching for button elements ===    level=INFO
    ${all_buttons}=    Get WebElements    //button
    ${button_count}=    Get Length    ${all_buttons}
    Log    Found ${button_count} button elements on the page    level=INFO
    FOR    ${index}    ${button}    IN ENUMERATE    @{all_buttons}
        ${text_attr}=    Get Text    ${button}
        ${type_attr}=    Get Element Attribute    ${button}    type
        ${id_attr}=    Get Element Attribute    ${button}    id
        Log    Button #${index}: text="${text_attr}", type="${type_attr}", id="${id_attr}"    level=INFO
    END

Navigate To Create Brief
    [Documentation]    Navigates to create brief page or opens create brief modal
    ${create_button_found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CREATE_BRIEF_BUTTON}    timeout=${TIMEOUT}
    Should Be True    ${create_button_found}    Create Brief button not found
    Click Element    ${CREATE_BRIEF_BUTTON}
    Sleep    1s
    # Wait for modal to appear
    ${modal_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${BRIEF_MODAL}    timeout=${TIMEOUT}
    Run Keyword If    not ${modal_visible}    Sleep    2s

Fill Brief Form
    [Arguments]    ${campaign_name}    ${product_name}    ${category}    ${description}
    [Documentation]    Fills the brief creation form with provided data (optimized for speed)
    # Wait for and find campaign name input (optimized - reduced timeouts)
    ${campaign_found}=    Wait For Campaign Name Input
    Should Be True    ${campaign_found}    Campaign name input field not found
    Scroll Element Into View    ${CAMPAIGN_NAME_INPUT_FOUND}
    Wait Until Element Is Visible    ${CAMPAIGN_NAME_INPUT_FOUND}    timeout=2s
    Wait Until Element Is Enabled    ${CAMPAIGN_NAME_INPUT_FOUND}    timeout=2s
    Clear Element Text    ${CAMPAIGN_NAME_INPUT_FOUND}
    Input Text    ${CAMPAIGN_NAME_INPUT_FOUND}    ${campaign_name}
    
    # Wait for and find product name input (optimized - reduced timeouts)
    ${product_found}=    Wait For Product Name Input
    Should Be True    ${product_found}    Product name input field not found
    Scroll Element Into View    ${PRODUCT_NAME_INPUT_FOUND}
    Wait Until Element Is Visible    ${PRODUCT_NAME_INPUT_FOUND}    timeout=2s
    Wait Until Element Is Enabled    ${PRODUCT_NAME_INPUT_FOUND}    timeout=2s
    Clear Element Text    ${PRODUCT_NAME_INPUT_FOUND}
    Input Text    ${PRODUCT_NAME_INPUT_FOUND}    ${product_name}
    
    # Wait for and find category dropdown
    ${category_found}=    Wait For Category Dropdown
    Should Be True    ${category_found}    Category dropdown not found
    Scroll Element Into View    ${CATEGORY_DROPDOWN_FOUND}
    Wait Until Element Is Visible    ${CATEGORY_DROPDOWN_FOUND}    timeout=2s
    Wait Until Element Is Enabled    ${CATEGORY_DROPDOWN_FOUND}    timeout=2s
    # Click to open dropdown
    Click Element    ${CATEGORY_DROPDOWN_FOUND}
    # Select category from custom dropdown (React component)
    Select Category From Custom Dropdown    ${category}
    
    # Wait for and find description input (optimized - check immediately after category selection)
    ${description_found}=    Wait For Description Input
    Should Be True    ${description_found}    Description input field not found
    Scroll Element Into View    ${DESCRIPTION_INPUT_FOUND}
    Wait Until Element Is Visible    ${DESCRIPTION_INPUT_FOUND}    timeout=2s
    Wait Until Element Is Enabled    ${DESCRIPTION_INPUT_FOUND}    timeout=2s
    Clear Element Text    ${DESCRIPTION_INPUT_FOUND}
    Input Text    ${DESCRIPTION_INPUT_FOUND}    ${description}

Wait For Campaign Name Input
    [Documentation]    Waits for campaign name input field and stores the found locator (optimized)
    ${locators}=    Create List
    ...    //input[@name='campaignName']
    ...    //input[contains(@placeholder, 'ชื่อแคมเปญ')]
    ...    //input[@name='campaign_name']
    ...    //input[@name='campaignName']
    ...    //input[@id='campaign_name']
    ...    //input[@id='campaignName']
    ...    //input[contains(@placeholder, 'Campaign Name')]
    ...    //input[contains(@placeholder, 'ชื่อแคมเปญ')]
    ...    //input[contains(@class, 'campaign')]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=1s
        Run Keyword If    ${found}    Set Test Variable    ${CAMPAIGN_NAME_INPUT_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Wait For Product Name Input
    [Documentation]    Waits for product name input field and stores the found locator (optimized)
    ${locators}=    Create List
    ...    //input[contains(@placeholder, 'ชื่อสินค้า')]
    ...    //input[@name='product_name']
    ...    //input[@name='productName']
    ...    //input[@id='product_name']
    ...    //input[@id='productName']
    ...    //input[contains(@placeholder, 'Product Name')]
    ...    //input[contains(@placeholder, 'ชื่อผลิตภัณฑ์')]
    ...    //input[contains(@class, 'product')]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=1s
        Run Keyword If    ${found}    Set Test Variable    ${PRODUCT_NAME_INPUT_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Wait For Category Dropdown
    [Documentation]    Waits for category dropdown button/trigger and stores the found locator
    ${locators}=    Create List
    ...    //button[@data-slot='trigger'][@aria-haspopup='listbox']
    ...    //button[@data-slot='trigger'][contains(., 'หมวดหมู่สินค้า')]
    ...    //button[@type='button'][@aria-haspopup='listbox']
    ...    //button[contains(., 'หมวดหมู่สินค้า')]
    ...    //button[contains(@aria-label, 'category')]
    ...    //button[contains(@aria-labelledby, 'category')]
    ...    //*[@id='category']//button
    ...    //*[contains(@class, 'category')]//button
    ...    //div[contains(@class, 'category')]//button
    ...    //select[@name='category']
    ...    //select[@id='category']
    ...    //*[@id='category']
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${CATEGORY_DROPDOWN_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Select Category From Custom Dropdown
    [Arguments]    ${category_name}
    [Documentation]    Selects a category from the custom React dropdown component
    # Wait for listbox to appear (optimized timeout)
    ${listbox_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${CATEGORY_LISTBOX}    timeout=2s
    Should Be True    ${listbox_visible}    Category dropdown listbox did not appear
    
    # Try to find option by text - check most common first (optimized order)
    ${locators}=    Create List
    ...    //li[@role='option']//span[@data-label='true'][contains(text(), '${category_name}')]
    ...    //li[@role='option'][contains(., '${category_name}')]
    ...    //li[@role='option']//span[contains(text(), '${category_name}')]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=1s
        Run Keyword If    ${found}    Click Element    ${locator}
        Return From Keyword If    ${found}
    END
    
    # If not found by text, try by data-key (convert category name to key format)
    # Examples: "Food & Beverage" -> "food-beverage", "Electronics & Technology" -> "electronics-technology"
    ${category_key}=    Evaluate    '${category_name}'.lower().replace(' & ', '-').replace(' &amp; ', '-').replace(' ', '-').replace('&', '').replace('amp;', '').replace('--', '-').strip('-')
    ${key_locator}=    Set Variable    //li[@role='option'][@data-key='${category_key}']
    ${found_by_key}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${key_locator}    timeout=1s
    Run Keyword If    ${found_by_key}    Click Element    ${key_locator}
    ...    ELSE    Fail    Category "${category_name}" not found in dropdown. Available options: Food & Beverage, Electronics & Technology, Healthcare & Pharmaceuticals, Fashion & Beauty, Automotive

Wait For Description Input
    [Documentation]    Waits for description input field and stores the found locator (optimized)
    ${locators}=    Create List
    ...    //textarea[@name='productInfo']
    ...    //textarea[contains(@placeholder, 'รายละเอียดเบื้องต้นและเงื่อนไข')]
    ...    //textarea[@name='description']
    ...    //textarea[@id='description']
    ...    //textarea[contains(@placeholder, 'Description')]
    ...    //textarea[contains(@placeholder, 'รายละเอียด')]
    ...    //textarea[@data-slot='input']
    ...    //input[@name='description']
    ...    //input[@id='description']
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=1s
        Run Keyword If    ${found}    Set Test Variable    ${DESCRIPTION_INPUT_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Submit Brief As Draft
    [Documentation]    Submits the brief form as draft
    ${draft_found}=    Wait For Draft Button
    Should Be True    ${draft_found}    Draft button not found
    Scroll Element Into View    ${DRAFT_BUTTON_FOUND}
    Wait Until Element Is Visible    ${DRAFT_BUTTON_FOUND}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${DRAFT_BUTTON_FOUND}    timeout=${TIMEOUT}
    Click Element    ${DRAFT_BUTTON_FOUND}
    Sleep    ${DELAY}

Submit Brief As Save
    [Documentation]    Submits the brief form as save
    ${save_found}=    Wait For Save Button
    Should Be True    ${save_found}    Save button not found
    Scroll Element Into View    ${SAVE_BUTTON_FOUND}
    Wait Until Element Is Visible    ${SAVE_BUTTON_FOUND}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${SAVE_BUTTON_FOUND}    timeout=${TIMEOUT}
    Click Element    ${SAVE_BUTTON_FOUND}
    Sleep    ${DELAY}

Wait For Draft Button
    [Documentation]    Waits for draft button and stores the found locator
    ${locators}=    Create List
    ...    //button[contains(text(), 'Draft')]
    ...    //button[contains(text(), 'บันทึกแบบร่าง')]
    ...    //button[@type='button'][contains(text(), 'Draft')]
    ...    //button[contains(@class, 'draft')]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${DRAFT_BUTTON_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Wait For Save Button
    [Documentation]    Waits for save button and stores the found locator
    ${locators}=    Create List
    ...    //button[contains(text(), 'Save')]
    ...    //button[contains(text(), 'บันทึก')]
    ...    //button[@type='submit'][contains(text(), 'Save')]
    ...    //button[contains(text(), 'Submit')]
    ...    //button[contains(@class, 'save')]
    
    FOR    ${locator}    IN    @{locators}
        ${found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
        Run Keyword If    ${found}    Set Test Variable    ${SAVE_BUTTON_FOUND}    ${locator}
        Return From Keyword If    ${found}    ${found}
    END
    Return From Keyword    ${False}

Verify Brief Created Successfully
    [Documentation]    Verifies that the brief was created successfully (optimized for speed)
    # Check for modal close first (fastest check - most common success indicator)
    ${modal_closed}=    Run Keyword And Return Status    Wait Until Page Does Not Contain Element    ${BRIEF_MODAL}    timeout=3s
    Run Keyword If    ${modal_closed}    Return From Keyword
    
    # Check for success message (if modal still visible)
    ${success_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${BRIEF_SUCCESS_MESSAGE}    timeout=2s
    Run Keyword If    ${success_visible}    Return From Keyword
    
    # Check for success text on page
    ${success_text}=    Run Keyword And Return Status    Page Should Contain    success
    ${success_text_thai}=    Run Keyword And Return Status    Page Should Contain    สำเร็จ
    ${created_text}=    Run Keyword And Return Status    Page Should Contain    created
    ${created_text_thai}=    Run Keyword And Return Status    Page Should Contain    สร้างแล้ว
    
    # Final verification
    ${result}=    Evaluate    ${modal_closed} or ${success_visible} or ${success_text} or ${success_text_thai} or ${created_text} or ${created_text_thai}
    Should Be True    ${result}    Brief creation may have failed. Success message or modal close not detected.
