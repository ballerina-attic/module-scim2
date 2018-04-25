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

documentation {Returns a user record if the input http:Response contains a user
    P{{userName}} User name of the user
    P{{response}} http:Response with the received response from the SCIM2 API
}
function resolveUser(string userName, http:Response response) returns User|error {
    User user = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving user:" + userName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        match received {
            json payload => {
                if (payload.Resources == null) {
                    Error = {message:failedMessage + "No User with user name " + userName};
                    return Error;
                }
                user = convertReceivedPayloadToUser(payload);
                return user;
            }
            error e => {
                Error = {message:failedMessage + e.message, cause:e.cause};
                return Error;
            }
        }
    }
    Error = {message:failedMessage + response.reasonPhrase};
    return Error;
}

documentation {Returns a group record if the input http:Response contains a group
    P{{groupName}} Name of the group
    P{{response}} http:Response with the received response from the SCIM2 API
}
function resolveGroup(string groupName, http:Response response) returns Group|error {
    Group receivedGroup = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving group:" + groupName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        match received {
            json payload => {
                if (payload.Resources == null) {
                    Error = {message:failedMessage + "No Group named " + groupName};
                    return Error;
                }
                receivedGroup = convertReceivedPayloadToGroup(payload);
                return receivedGroup;
            }
            error e => {
                Error = {message:failedMessage + e.message, cause:e.cause};
                return Error;
            }
        }
    }
    Error = {message:failedMessage + response.reasonPhrase};
    return Error;
}

documentation {Returns a http:Request with the json attached to its body
    P{{body}} Json Object which should be attached to the body of the request
}
function createRequest(json body) returns http:Request {
    http:Request request = new();
    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(body);
    return request;
}

documentation {Returns a json object that should be attached to the http:Request to update a user
    P{{valueType}} The name of the user attribute
    P{{newValue}} The new value of the attribute
}
function createUpdateBody(string valueType, string newValue) returns json|error {
    json body = SCIM_PATCH_ADD_BODY;
    error Error = {};

    if (valueType.equalsIgnoreCase(SCIM_NICKNAME)) {
        body.Operations[0].value = {SCIM_NICKNAME:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_PREFERRED_LANGUAGE)) {
        body.Operations[0].value = {SCIM_PREFERRED_LANGUAGE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_TITLE)) {
        body.Operations[0].value = {SCIM_TITLE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_PASSWORD)) {
        body.Operations[0].value = {SCIM_PASSWORD:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_PROFILE_URL)) {
        body.Operations[0].value = {SCIM_PROFILE_URL:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_LOCALE)) {
        body.Operations[0].value = {SCIM_LOCALE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_TIMEZONE)) {
        body.Operations[0].value = {SCIM_TIMEZONE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_ACTIVE)) {
        body.Operations[0].value = {SCIM_ACTIVE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_USERTYPE)) {
        body.Operations[0].value = {SCIM_USERTYPE:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_DISPLAYNAME)) {
        body.Operations[0].value = {SCIM_DISPLAYNAME:newValue};
        return body;
    } if (valueType.equalsIgnoreCase(SCIM_EXTERNALID)) {
        body.Operations[0].value = {SCIM_EXTERNALID:newValue};
        return body;
    } else {
        Error = {message:"No matching value as " + valueType};
        return Error;
    }

}