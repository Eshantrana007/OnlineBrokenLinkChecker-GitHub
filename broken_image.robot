*** Settings ***
Library           SeleniumLibrary
Library           RequestsLibrary
Library           Collections

*** Variables ***
${URL}           https://www.ecample.com  # Enter Website URL
${browser}       Chrome

*** Test Cases ***
Check For Broken Images
    [Documentation]    This test case checks all images on the web page for broken links.
    Open Browser    ${URL}    ${browser}
    ${images}    Get WebElements    xpath://img
    ${broken_images}    Create List

    FOR    ${image}    IN    @{images}
        ${src}    Get Element Attribute    ${image}    src
        ${status_code}=    Get Image Status Code    ${src}
        Run Keyword If    ${status_code} != ${200}    Append To List    ${broken_images}    ${src}
    END

    ${total_images}=    Get Length    ${images}
    Log     Total Images: ${total_images}
    Log To Console    Total Images: ${total_images}
    ${broken_count}=    Get Length    ${broken_images}
    Log    Broken Images: ${broken_count}
    Log To Console    Broken Images: ${broken_count}
    Run Keyword If    ${broken_count} > 0    Log To Console    Broken images found: ${broken_images}

    [Teardown]    Close Browser


*** Keywords ***
Get Image Status Code
    [Arguments]    ${url}
    ${response}=    Run Keyword And Ignore Error    GET    ${url}
    ${status}=    Set Variable    ${response}[0]
    IF    '${status}' == 'FAIL'
        ${code}=    Set Variable    404
    ELSE
        ${code}=    Set Variable    ${response[1].status_code}
    END
    RETURN    ${code}
