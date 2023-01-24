*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}         http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_Key}        ROADTOSDET
${req_url}          /transaction/balance/SYSTEM

*** Test Cases ***
TC:1 Check System Balance
    Create Session    mysession     ${base_url}
    ${json_obj}       load json from file    ${json_file_path}
    ${token}          get value from json    ${json_obj}        $.token
    ${header}=        create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${response}=      get request    mysession      ${req_url}      headers=${header}

    log to console    ${response.json()}

    #Validation
    should be equal as strings    ${response.status_code}   200
    ${actual_balance}=       get value from json    ${response.json()}      balance
    ${expected_balance}=    get value from json    ${json_obj}        $.System_amount
    should be equal as strings      ${expected_balance}     ${actual_balance}

