//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
import ballerina/http;

# Returns a user record if the input http:Response contains a user.
# + userName - User name of the user
# + response - http:Response with the received response from the SCIM2 API
# + return - If success returns User object, else returns error
function resolveUser(string userName, http:Response response) returns User|error {
    User user = {};

    string failedMessage = "";
    failedMessage = "Resolving user:" + userName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        if (received is json) {
            if (received.Resources == null) {
                error Error = error(SCIM2_ERROR_CODE
                , { message: failedMessage + "No User with user name " + userName });
                return Error;
            } else {
                user = convertReceivedPayloadToUser(received);
                return user;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE
            , { message: "Error occurred while accessing the JSON payload of the response." });
            return err;
        }
    } else {
        error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
        return Error;
    }
}

# Returns a group record if the input http:Response contains a group.
# + groupName - Name of the group
# + response - http:Response with the received response from the SCIM2 API
# + return - If success returns Group object, else returns error
function resolveGroup(string groupName, http:Response response) returns Group|error {
    Group receivedGroup = {};

    string failedMessage = "";
    failedMessage = "Resolving group:" + groupName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        if(received is json) {
            if (received.Resources == null) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + "No Group named " + groupName });
                return Error;
            } else {
                receivedGroup = convertReceivedPayloadToGroup(received);
                return receivedGroup;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE 
            , { message: "Error occurred while accessing the JSON payload of the response." });
            return err;
        }
    } else {
        error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
        return Error;
    }
}

# Returns a http:Request with the json attached to its body.
# + body - JSON Object which should be attached to the body of the request
# + return - returns http Request
function createRequest(json body) returns http:Request {
    http:Request request = new();
    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(body);
    return request;
}

# Returns a `json` object that should be attached to the http:Request to update a user.
# + valueType - The name of the user attribute
# + newValue - The new value of the attribute
# + return - If success returns `json` object, else returns error
function createUpdateBody(string valueType, string newValue) returns json|error {
    json body = SCIM_PATCH_ADD_BODY;

    if (valueType.equalsIgnoreCase(SCIM_NICKNAME)) {
        body.Operations[0].value = { SCIM_NICKNAME: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_PREFERRED_LANGUAGE)) {
        body.Operations[0].value = { SCIM_PREFERRED_LANGUAGE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_TITLE)) {
        body.Operations[0].value = { SCIM_TITLE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_PASSWORD)) {
        body.Operations[0].value = { SCIM_PASSWORD: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_PROFILE_URL)) {
        body.Operations[0].value = { SCIM_PROFILE_URL: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_LOCALE)) {
        body.Operations[0].value = { SCIM_LOCALE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_TIMEZONE)) {
        body.Operations[0].value = { SCIM_TIMEZONE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_ACTIVE)) {
        body.Operations[0].value = { SCIM_ACTIVE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_USERTYPE)) {
        body.Operations[0].value = { SCIM_USERTYPE: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_DISPLAYNAME)) {
        body.Operations[0].value = { SCIM_DISPLAYNAME: newValue };
        return body;
    }
    if (valueType.equalsIgnoreCase(SCIM_EXTERNALID)) {
        body.Operations[0].value = { SCIM_EXTERNALID: newValue };
        return body;
    } else {
        error Error = error(SCIM2_ERROR_CODE, { message: "No matching value as " + valueType });
        return Error;
    }
}
