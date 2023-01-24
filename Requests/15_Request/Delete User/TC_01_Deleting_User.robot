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
${req_url}          /user/delete/

*** Test Cases ***
TC:1 Delete Customer 1
    Create Session    mysession     ${base_url}
    ${json_obj}       load json from file    ${json_file_path}
    ${token}          get value from json    ${json_obj}        $.token
    ${cutomer_1_id}=            get value from json    ${json_obj}        customer_1_id
    ${header}=        create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${response}=      DELETE On Session    mysession      ${req_url}${cutomer_1_id[0]}     headers=${header}


    log to console    ${response.json()}

    #Validation
      ${message}=     get value from json     ${response.json()}      message
      should be equal    ${message[0]}    User deleted successfully
      should be equal as strings    ${response.status_code}   200
