*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String

*** Variables ***
${base_url}         http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_Key}        ROADTOSDET

*** Test Cases ***
TC1: Deposit to Agent number
    create session    mysession     ${base_url}
    ${json_obj}       load json from file    ${json_file_path}
    ${token}          get value from json    ${json_obj}        $.token
    ${agent_phone_number}=      get value from json    ${json_obj}      $.Agent_phone_number
    ${amount}=      convert to integer    1000
    ${user_info}=       create dictionary    from_account=SYSTEM        to_account=${agent_phone_number[0]}     amount=${amount}

    #Converting to dictionary to JSON
    ${user_info_json}=      evaluate    json.dumps(${user_info}, indent=4)
    log to console    ${user_info_json}
    ${header}=        create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${response}=        POST On Session    mysession        /transaction/deposit        data=${user_info_json}      headers=${header}
    log to console    ${response.json()}

    ${rest_amount}=     get value from json    ${response.json()}       currentBalance
    set to dictionary    ${json_obj}        System_amount=${rest_amount[0]}
    dump json to file    ${json_file_path}      ${json_obj}

    #Validations
    ${message}=     get value from json    ${response.json()}       message
    should be equal as strings    ${message[0]}        Deposit successful
    should be equal as strings    ${response.status_code}       201