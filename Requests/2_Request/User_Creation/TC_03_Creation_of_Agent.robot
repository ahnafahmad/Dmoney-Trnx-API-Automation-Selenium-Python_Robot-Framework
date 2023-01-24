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
Creation of Customer 1
    create session    mysession     ${base_url}
    ${random_number}=       generate random string    8     [NUMBERS]
    ${random_name}=         generate random string    8-15
    ${random_email}=        convert to string         ${random_name}123@gmail.com
    ${random_password}=     convert to string         1234
    ${random_phoneNumber}=  convert to string         016${random_number}
    ${random_nid}=          convert to string         456${random_number}
    ${role}=                convert to string         Agent

    ${user_data}=           create dictionary       name=${random_name}     email=${random_email}           password=${random_password}         phone_number=${random_phoneNumber}          nid=${random_nid}           role=${role}
    #converting dictonary to json
    ${user_info_json}=      evaluate    json.dumps(${user_data},indent=4)
    log to console      ${user_info_json}

    ${json_obj}=    load json from file    ${json_file_path}
    ${token}=       get value from json    ${json_obj}      token
    ${header}=      create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_Key}
    ${response}=    POST On Session    mysession    /user/create        data=${user_info_json}      headers=${header}
    log to console    ${response.content}

    ${message}=     get value from json     ${response.json()}      message
    ${agent_id}=     get value from json    ${response.json()}       user.id
    set to dictionary    ${json_obj}        Agent_id=${agent_id[0]}
    ${agent_phone_number}=       get value from json    ${response.json()}       user.phone_number
    set to dictionary    ${json_obj}        Agent_phone_number=${agent_phone_number[0]}
    dump json to file    ${json_file_path}      ${json_obj}

    #Validation
        should be equal    ${message[0]}    User created successfully
        should be equal as strings    ${response.status_code}       201
