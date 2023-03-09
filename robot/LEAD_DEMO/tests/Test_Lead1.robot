
# WETEAMI-240:
#   LEAD Test-case : To create a new LEAD and Validate the fields from it

*** Settings ***

Resource        cumulusci/robotframework/Salesforce.robot
Library         cumulusci.robotframework.PageObjects
Library         cumulusci.robotframework.Salesforce
Library         Screenshot
Library         SeleniumLibrary
Library    Collections
Resource        cumulusci/robotframework/SalesforcePlaywright.robot

# open Test Browser : Chrome
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser


*** Variables ***
${email}    xpath=//slot[@name='outputField']//emailui-formatted-email-lead
${phone}    xpath=//input[@name='Phone']
${test_drive}   xpath=//span[@class='slds-truncate' and @title='Test Drive']
${lead_status}  xpath=//label[text()='Lead Status']//ancestor::span[@class='test-id__field-value slds-size_1-of-1']//button
${in_routing}   xpath=//*[@data-value="In Routing"]
# *** Keywords ***

*** Test Cases ***

OpenCase
    Maximize Browser Window
    ${first_name} =           Get fake data  first_name
    ${last_name} =            Get fake data  last_name
    Select App Launcher App     Rocky Lead Management

    Current App Should Be    Rocky Lead Management      # validate the Opened App is


    Go to page  Home  Lead              # open LEAD Home Page
    
    Click Object Button   New
    Click Button          Next
    Take Screenshot

    Populate Form                       # Filling the Text value and input fields
    ...                 First Name=${first_name}
    ...                 Last Name=${last_name}
    Click element    ${lead_status}
    Click element    ${in_routing}
    ${ele}    Get WebElement    //label[text()='Brand']//ancestor::span[@class="test-id__field-value slds-size_1-of-1"]//button
    Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}
    Click Element    xpath=//span[@class='slds-truncate' and @title='Audi']

    ${ele}    Get WebElement    //label[text()='Lead Type']//ancestor::span[@class="test-id__field-value slds-size_1-of-1"]//button[.='--None--']
    Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}
    Click Element    ${test_drive}
    Input Text    ${phone}    012345678
    Click Modal Button    Save
        
    Wait Until Modal Is Closed

    ${lead_id} =       Get Current Record Id        # Record the ID for created Lead
    Store Session Record  Lead  ${lead_id}

    Go to page  Detail  Lead  ${lead_id}            # Using lookup parameters

    Page Should Contain    ${first_name}            # verify the fields on page
    Page Should Contain    012345678
    ${vishal_email}=    Get Text    ${email}
    IF    $vishal_email is ''
        Log    Email Field is Empty, as its not provided while input
    ELSE
        Log    Email id is present
    END
    
    Take Screenshot