***Keywords***
Take Custom Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d_%H-%M-%S
    ${filename}=     Set Variable    ${SCREENSHOT_PATH}/${timestamp}_${step_name.replace(" ", "_")}.png
    Create Directory    ${SCREENSHOT_PATH}
    Capture Page Screenshot    ${filename}
    Log    Saved screenshot: ${filename}


Login To Application
    [Arguments]    ${username}    ${password}
    Input Text    id:user-name    ${username}
    Input Text    id:password    ${password}
    Take Custom Screenshot  Login Info
    Click Button    id:login-button
    Wait Until Element Is Visible    css:.app_logo    timeout=20s
    Page Should Contain Element    css:.inventory_list

Scroll Down
    [Arguments]    ${scroll_height}
    Execute JavaScript    window.scrollBy(0, ${scroll_height})