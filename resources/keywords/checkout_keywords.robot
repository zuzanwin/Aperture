***Keywords***
Click Checkout Button
    Click Button    css:button[data-test="checkout"]
    # Wait for the checkout page to load
    Wait Until Element Is Visible    css:.checkout_info_container    timeout=10s
    Page Should Contain    Checkout: Your Information

Fill Checkout Info
    Input Text    css:input[data-test="firstName"]    ${FIRST_NAME}
    Input Text    css:input[data-test="lastName"]    ${LAST_NAME}
    Input Text    css:input[data-test="postalCode"]    ${POSTAL_CODE}
    Take Custom Screenshot  Checkout Info Filled
    Click Button    css:input[data-test="continue"]
    Wait Until Element Is Visible   css:.checkout_summary_container     timeout=10s
    Page Should Contain    Checkout: Overview