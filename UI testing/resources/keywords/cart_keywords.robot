***Keywords***
Add Item To Cart
    [Arguments]    ${index}
    ${item_container}=    Set Variable    css:.inventory_item:nth-child(${${index} + 1})
    ${item_name}=    Get Text    ${item_container} .inventory_item_name
    ${item_price}=    Get Text    ${item_container} .inventory_item_price
    
    # Get the add to cart button directly
    ${add_to_cart_button}=    Get WebElement    ${item_container} button[id^='add-to-cart']
    Click Button    ${add_to_cart_button}

    # Create a dictionary for the current item
    ${item_details}=    Create Dictionary
    ...    name=${item_name}
    ...    price=${item_price}
    ...    index=${index}
    
    # Append the item details to the cart items list
    Append To List    ${EXPECTED_ITEMS}    ${item_details}
    
    Log    Added item: ${item_name}, Price: ${item_price}
    Log    Current cart items: ${EXPECTED_ITEMS}
Get Cart Items
    [Return]    ${EXPECTED_ITEMS}

Clear Cart Items
    Create List    ${EXPECTED_ITEMS}
Go To Shopping Cart
    Click Element    css:.shopping_cart_link
    Wait Until Element Is Visible    css:.cart_list    timeout=20s
    Page Should Contain Element    css:.cart_item

Verify Cart Items Count
    [Arguments]    ${expected_count}
    ${cart_badge}=    Get Text    css:.shopping_cart_badge
    Should Be Equal As Numbers    ${cart_badge}    ${expected_count}

Verify Cart Contents
    # Get all item names and prices from cart
    @{cart_items}=    Get WebElements    css:.inventory_item_name
    @{cart_prices}=    Get WebElements    css:.inventory_item_price
    ${total}=    Set Variable    ${0}
    
    # Verify each item name
    FOR    ${index}    ${item}    IN ENUMERATE    @{cart_items}
        ${item_name}=    Get Text    ${item}
        ${expected_item}=    Get From List    ${EXPECTED_ITEMS}    ${index}
        ${expected_name}=    Get From Dictionary    ${expected_item}    name
        Should Be Equal    ${item_name}    ${expected_name}
        Log    Verified item name: ${item_name}
    END
    
    # Verify each price
    FOR    ${index}    ${price}    IN ENUMERATE    @{cart_prices}
        ${item_price}=    Get Text    ${price}
        ${expected_item}=    Get From List    ${EXPECTED_ITEMS}    ${index}
        ${expected_price}=    Get From Dictionary    ${expected_item}    price
        Should Be Equal    ${item_price}    ${expected_price}
        Log    Verified price: ${item_price}
    END
Verify the Visible Buttons in the Cart Screen
    # Verify Continue Shopping button exists
    Page Should Contain Element    css:button[data-test="continue-shopping"]
    
    # Verify Checkout button exists
    Page Should Contain Element    css:button[data-test="checkout"]