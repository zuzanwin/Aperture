***Keywords***
Calculate Total Amount
    [Documentation]    Calculates the total amount from cart prices
    ${total}=    Set Variable    ${0}
    @{price_elements}=    Get WebElements    css:.inventory_item_price
    
    FOR    ${price_element}    IN    @{price_elements}
        ${price_text}=    Get Text    ${price_element}
        ${price_number}=    Convert Price To Number    ${price_text}
        ${total}=    Evaluate    ${total} + ${price_number}
    END
    ${total}=    Evaluate    round(${total}, 2)
    [Return]    ${total}

Calculate Tax Amount
    [Arguments]    ${total_amount}
    ${tax_amount}=    Evaluate    ${total_amount} * ${TAX_RATE}
    ${tax_amount}=    Evaluate    round(${tax_amount}, 2)
    [Return]    ${tax_amount}

Convert Price To Number
    [Arguments]    ${price_string}
    ${price_number}=    Remove String    ${price_string}    $    ,
    ${price_number}=    Convert To Number    ${price_number}
    [Return]    ${price_number}

Calculate Total With Tax
    # Calculate total amount
    ${item_total}=    Calculate Total Amount
    Log    Total amount: $${item_total}
    
    # Calculate tax
    ${tax}=    Calculate Tax Amount    ${item_total}
    Log    Tax amount: $${tax}
    
    # Calculate final amount with tax
    ${final_total}=    Evaluate    ${item_total} + ${tax}
    ${final_total}=    Evaluate    round(${final_total}, 2)
    Log    Final amount with tax: $${final_total}
    
    [Return]    ${item_total}    ${tax}    ${final_total}

Verify Price Totals
    # Get all calculated values at once
    ${expected_item_total}    ${expected_tax}    ${expected_final_total}=    Calculate Total With Tax
    
    # Format the expected values with $ symbol
    ${formatted_item_total}=    Set Variable    $${expected_item_total}
    ${formatted_tax}=    Set Variable    $${expected_tax}
    ${formatted_final_total}=    Set Variable    $${expected_final_total}
    
    # Verify item total
    Wait Until Element Is Visible    css:.summary_subtotal_label    timeout=10s
    ${item_total}=    Get Text    css:.summary_subtotal_label
    Should Contain    ${item_total}    ${formatted_item_total}
    Log    Verified Item Total: ${item_total}
    
    # Verify tax amount
    ${tax_amount}=    Get Text    css:.summary_tax_label
    Should Contain    ${tax_amount}    ${formatted_tax}
    Log    Verified Tax Amount: ${tax_amount}
    
    # Verify final total
    ${final_total}=    Get Text    css:.summary_total_label
    Should Contain    ${final_total}    ${formatted_final_total}
    Log    Verified Final Total: ${final_total}
    
    # Additional verification: Check if tax calculation is correct
    ${calculated_total}=    Evaluate    ${expected_item_total} + ${expected_tax}
    ${calculated_total}=    Evaluate    round(${calculated_total}, 2)
    
    Should Be Equal As Numbers    ${calculated_total}    ${expected_final_total}
    Log    Verified Total Calculation: ${formatted_item_total} + ${formatted_tax} = ${formatted_final_total}