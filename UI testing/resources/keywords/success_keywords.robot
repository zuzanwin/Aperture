***Keywords***
Click Finish Button
    Click Button    css:button[data-test="finish"]
    # Wait for the checkout page to load
    Wait Until Element Is Visible    css:.checkout_complete_container    timeout=10s
    Page Should Contain    Checkout: Complete!

Verify Successful Page
    Element Text Should Be    css:h2.complete-header    ${COMPLETE_HEADER}
    Element Text Should Be    css:div.complete-text    ${COMPLETE_TEXT}
    Element Text Should Be    id:back-to-products       ${BACKHOME_BUTTON_LABEL} 
    Verify Shopping Cart Is Empty
    Click Button    id:back-to-products

Verify Shopping Cart Is Empty
    ${cart_value}=    Get Text    css:.shopping_cart_link  
    Should Be Empty    ${cart_value}