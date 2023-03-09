
# LEAD Test-Case : WETEAMI-281
# Brand Search for created Leads

*** Settings ***

Resource        cumulusci/robotframework/Salesforce.robot
Resource        cumulusci/robotframework/SalesforcePlaywright.robot
Resource        cumulusci/robotframework/tests/salesforce/classic.robot
Library         cumulusci.robotframework.PageObjects
Library         cumulusci.robotframework.Salesforce
Library         Screenshot
Library         SeleniumLibrary

# open Test Browser : Chrome
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser


*** Variables ***
# variables with xpath for respective fields
${email}    xpath=//slot[@name='outputField']//emailui-formatted-email-lead
${phone}    xpath=//input[@name='Phone']
${test_drive}   xpath=//span[@class='slds-truncate' and @title='Test Drive']
${lead_status}  xpath=//label[text()='Lead Status']//ancestor::span[@class='test-id__field-value slds-size_1-of-1']//button
${in_routing}   xpath=//*[@data-value="In Routing"]
@{brand_list}=   Audi    SKODA   Volkswagen     Volkswagen CV


# *** Keywords ***

*** Test Cases ***

OpenCase
    Maximize Browser Window
    Select App Launcher App     Rocky Lead Management

    Current App Should Be    Rocky Lead Management      # validate the Opened App is

    FOR    ${counter}    IN    @{brand_list}
            Go to page  Home  Lead              # open LEAD Home Page
            Click Object Button   New
            Click Button          Next
            ${first_name} =           Get fake data  first_name
            ${last_name} =            Get fake data  last_name

            Populate Form                       # Filling the Text value and input fields
            ...                 First Name=${first_name}
            ...                 Last Name=${last_name}
            Click element    ${lead_status}
            Click element    ${in_routing}
            ${ele}    Get WebElement    //label[text()='Brand']//ancestor::span[@class="test-id__field-value slds-size_1-of-1"]//button
            Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}
            Click Element    xpath=//span[@class='slds-truncate' and @title='${counter}']

            ${ele}    Get WebElement    //label[text()='Lead Type']//ancestor::span[@class="test-id__field-value slds-size_1-of-1"]//button[.='--None--']
            Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}
            Click Element    ${test_drive}
            Input Text    ${phone}    012345678
            Click Modal Button    Save
            log     ${counter}

            Wait Until Modal Is Closed

            Take Screenshot

    END

    Go to page  Home  Lead              # open LEAD Home Page
    FOR    ${search_brnad}    IN    @{brand_list}
        Input Text    xpath=//input[@name='Lead-search-input']    ${search_brnad}
        Press Keys    xpath=//input[@name='Lead-search-input']    ENTER
        Wait Until Loading Is Complete
    END
