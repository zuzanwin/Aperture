*** Settings ***
Library    Collections
Library    String

*** Keywords ***
Select Items By Price Range
    [Arguments]    ${min_price}=0    ${max_price}=100
    @{all_items}=    Get Multiple Test Data
    @{selected_items}=    Create List

    FOR    ${index}    IN RANGE    len(${all_items})
        ${price}=    Remove String    ${all_items}[${index}][2]    $
        ${price_float}=    Convert To Number    ${price}
        
        Run Keyword If    ${min_price} <= ${price_float} <= ${max_price}    
        ...    Append To List    ${selected_items}    ${index}
    END

    [Return]    ${selected_items}

Select Random Items
    [Arguments]    ${count}=3
    @{all_items}=    Get Multiple Test Data
    @{random_items}=    Evaluate    random.sample(range(len(${all_items})), ${count})    random

    [Return]    ${random_items}

Filter Items By Category
    [Arguments]    ${category}
    @{all_items}=    Get Multiple Test Data
    @{category_items}=    Create List

    FOR    ${index}    IN RANGE    len(${all_items})
        Run Keyword If    '${all_items}[${index}][3]' == '${category}'    
        ...    Append To List    ${category_items}    ${index}
    END

    [Return]    ${category_items}