*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}         http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_Key}        ROADTOSDET
${req_url}          /user/search?

*** Test Cases ***
TC:1 Get Customer 1 Details
    Create Session    mysession     ${base_url}
    ${json_obj}       load json from file    ${json_file_path}
    ${token}          get value from json    ${json_obj}        $.token
    ${id}=            get value from json    ${json_obj}        customer_1_id
    ${header}=        create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${param}=         create dictionary    id=${id[0]}
    ${response}=      get request    mysession      ${req_url}      params=${param}     headers=${header}

    #Extracting values from json response
    ${customer_1_id}=       get value from json    ${response.json()}       user.id
    log to console    ${response.json()}

    #Validation
    should be equal as strings    ${customer_1_id[0]}       ${id[0]}
    should be equal as strings    ${response.status_code}   200
