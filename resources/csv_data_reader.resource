*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String

*** Variables ***
${DATA_FILE}    ${CURDIR}${/}../resources/data_info.csv

*** Keywords ***
Read Test Data From CSV
    [Documentation]    Reads test data from CSV file and returns it as a list
    Verify CSV File Exists
    ${file_content}=    Get File    ${DATA_FILE}
    @{csv_data}=    Split To Lines    ${file_content}
    [Return]    ${csv_data}

Get Test Data
    [Documentation]    Reads and sets test variables from CSV
    @{all_data}=    Read Test Data From CSV
    
    # Split the second line (index 1) into variables
    @{data_row}=    Split String    ${all_data}[1]    separator=;
    
    # Set all variables from CSV
    Set Suite Variable    ${URL}                   ${data_row}[0]
    Set Suite Variable    ${SCREENSHOT_PATH}       ${data_row}[1]
    Set Suite Variable    ${USERNAME}             ${data_row}[2]
    Set Suite Variable    ${PASSWORD}             ${data_row}[3]
    Set Suite Variable    ${FIRST_NAME}           ${data_row}[4]
    Set Suite Variable    ${LAST_NAME}            ${data_row}[5]
    Set Suite Variable    ${POSTAL_CODE}          ${data_row}[6]
    Set Suite Variable    ${TAX_RATE}             ${data_row}[7]
    Set Suite Variable    ${COMPLETE_HEADER}       ${data_row}[8]
    Set Suite Variable    ${COMPLETE_TEXT}         ${data_row}[9]
    Set Suite Variable    ${BACKHOME_BUTTON_LABEL}      ${data_row}[10]
    
    # Log the loaded data for verification
    Log    Test Data Loaded Successfully
    Log List    ${data_row}

Verify CSV File Exists
    [Documentation]    Verifies that the CSV file exists before attempting to read it
    File Should Exist    ${DATA_FILE}    msg=CSV file not found at ${DATA_FILE}

Get Multiple Test Data
    [Documentation]    Returns all rows from CSV file (useful for data-driven testing)
    @{all_data}=    Read Test Data From CSV
    @{data_rows}=    Create List
    
    # Skip header row and iterate through data rows
    FOR    ${index}    IN RANGE    1    ${all_data.__len__()}
        @{row_data}=    Split String    ${all_data}[${index}]    separator=;
        Append To List    ${data_rows}    ${row_data}
    END
    
    [Return]    ${data_rows}

Get User Specific Data
    [Arguments]    ${target_username}
    [Documentation]    Retrieves data for a specific user
    @{all_data}=    Read Test Data From CSV
    
    # Skip header row and iterate through data rows
    FOR    ${index}    IN RANGE    1    ${all_data.__len__()}
        @{row_data}=    Split String    ${all_data}[${index}]    separator=;
        
        # Check if username matches
        Run Keyword If    '${row_data}[2]' == '${target_username}'    
        ...    Return From Keyword    ${row_data}
    END
    
    Fail    User '${target_username}' not found in test data

Prepare Multiple User Test Data
    [Documentation]    Prepares test data for multiple users
    @{all_data}=    Read Multiple Test Data
    Set Suite Variable    @{MULTIPLE_USERS}    ${all_data}