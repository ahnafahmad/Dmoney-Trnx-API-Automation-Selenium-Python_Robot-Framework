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
Update of Customer 1
    create session    mysession     ${base_url}
    ${random_number}=       generate random string    8     [NUMBERS]
    ${random_password}=     convert to string         1234
    ${random_nid}=          convert to string         456${random_number}
    ${role}=                convert to string         Customer

    ${user_data}=           create dictionary       name=Ahnaf Ahmad     email=ahnaf.ahmad@gmail.com           password=${random_password}         phone_number=01874829304          nid=${random_nid}           role=${role}
    #converting dictonary to json
    ${user_info_json}=      evaluate    json.dumps(${user_data},indent=4)
    log to console      ${user_info_json}

    ${json_obj}=    load json from file    ${json_file_path}
    ${token}=       get value from json    ${json_obj}      token
    ${customer_1_id}=      get value from json    ${json_obj}      $.customer_1_id
    ${header}=      create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${response}=    PUT On Session    mysession    /user/update/${customer_1_id[0]}        data=${user_info_json}      headers=${header}
    log to console    ${response.content}

    ${message}=     get value from json     ${response.json()}      message

    #Validation
        should be equal    ${message[0]}    User updated successfully
        should be equal as strings    ${response.status_code}       200
