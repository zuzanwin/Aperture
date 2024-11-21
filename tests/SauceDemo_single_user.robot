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


Suite Setup       Get Test Data

*** Variables ***
@{ITEM_INDEXES}   0    1    2
@{EXPECTED_COUNT}    3
@{EXPECTED_ITEMS}    
@{cart_prices}    
@{EXPECTED_PRICES} 

*** Test Cases ***
Test Shopping Cart Functionality
    [Documentation]    Tests login, adding items, and verifying cart contents
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Take Custom Screenshot    Login Page Loaded

    Login To Application    ${USERNAME}    ${PASSWORD}
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
    Scroll Down  2000
    Take Custom Screenshot    Verified Price Totals

    Click Finish Button
    Take Custom Screenshot    Order Completion Page Loaded

    Verify Successful Page
    Take Custom Screenshot    Verified Successful Checkout Page

    [Teardown]    Close Browser








