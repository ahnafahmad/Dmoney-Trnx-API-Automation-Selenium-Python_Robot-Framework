*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}         http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_Key}        ROADTOSDET
${req_url}          /transaction/balance/

*** Test Cases ***
TC:1 Check Agent Balance
    Create Session    mysession     ${base_url}
    ${json_obj}       load json from file    ${json_file_path}
    ${token}          get value from json    ${json_obj}        $.token
    ${header}=        create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${Customer_1_phone_number}=      get value from json    ${json_obj}      $.customer_1_phone_number
    ${response}=      GET On Session    mysession      ${req_url}${customer_1_phone_number[0]}      headers=${header}

    log to console    ${response.json()}

    ${customer_1_balance}=       get value from json    ${response.json()}       balance
    set to dictionary    ${json_obj}        Customer_1_balance=${customer_1_balance[0]}
    dump json to file    ${json_file_path}      ${json_obj}

    #Validation
    should be equal as strings    ${response.status_code}   200
    ${message}=     get value from json    ${response.json()}       message
    should be equal as strings    ${message[0]}        User balance
