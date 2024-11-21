*** Settings ***
Documentation     Test suite for Sauce Demo shopping functionality
Library           SeleniumLibrary
Library           Collections
Library           String
Library           BuiltIn
Library           DateTime
Library           OperatingSystem


Resource          ../resources/keywords/common_keywords.robot
Resource          ../resources/keywords/cart_keywords.robot
Resource          ../resources/keywords/checkout_keywords.robot
Resource          ../resources/keywords/calculation_keywords.robot
Resource          ../resources/keywords/success_keywords.robot
Resource          ../resources/csv_data_reader.resource
Resource          ../resources/item_selection_strategy.resource


*** Variables ***
@{ITEM_INDEXES}   0    1    2
@{EXPECTED_COUNT}    3
@{EXPECTED_ITEMS}    
@{cart_prices}    
@{EXPECTED_PRICES} 



*** Test Cases ***
Test Multiple Users
    [Documentation]    Tests login with multiple users from CSV
    
    ${users_data}=    Get Multiple Test Data
    
    FOR    ${user_data}    IN    @{users_data}
        Log    Running test for user: ${user_data}[2]

        # Assign suite variables dynamically for each user
        Set Suite Variable    ${URL}                   ${user_data}[0]
        Set Suite Variable    ${SCREENSHOT_PATH}       ${user_data}[1]
        Set Suite Variable    ${USERNAME}             ${user_data}[2]
        Set Suite Variable    ${PASSWORD}             ${user_data}[3]
        Set Suite Variable    ${FIRST_NAME}           ${user_data}[4]
        Set Suite Variable    ${LAST_NAME}            ${user_data}[5]
        Set Suite Variable    ${POSTAL_CODE}          ${user_data}[6]
        Set Suite Variable    ${TAX_RATE}             ${user_data}[7]
        Set Suite Variable    ${COMPLETE_HEADER}      ${user_data}[8]
        Set Suite Variable    ${COMPLETE_TEXT}        ${user_data}[9]
        Set Suite Variable    ${BACKHOME_BUTTON_LABEL}  ${user_data}[10]

        Open Browser    ${URL}    chrome
        Maximize Browser Window
        Take Custom Screenshot    Login Page Loaded

        Run Keyword And Continue On Failure    Login To Application    ${USERNAME}    ${PASSWORD}
        Take Custom Screenshot    After Login

        FOR    ${index}    IN    @{ITEM_INDEXES}
            Add Item To Cart    ${index}
            Take Custom Screenshot    After Adding Item Index ${index}
        END

        Go To Shopping Cart
        Take Custom Screenshot    Shopping Cart Page Loaded

        Verify Cart Items Count    @{EXPECTED_COUNT}
        Verify Cart Contents
        Verify the Visible Buttons in the Cart Screen

        Click Checkout Button
        Take Custom Screenshot    Checkout Page Loaded

        Fill Checkout Info
        Take Custom Screenshot    Checkout Overview Page Loaded
        Verify Cart Contents

        Verify Price Totals
        Scroll Down    2000
        Take Custom Screenshot    Verified Price Totals

        Click Finish Button
        Take Custom Screenshot    Order Completion Page Loaded

        Verify Successful Page
        Take Custom Screenshot    Verified Successful Checkout Page

        Close Browser
    END
