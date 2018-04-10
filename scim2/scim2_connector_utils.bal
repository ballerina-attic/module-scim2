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
function resolveUser (string userName, http:Response response) returns User|error {
    User user = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving user:" + userName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        match received {
            json payload => {
                user = convertReceivedPayloadToUser(payload);
                if (user.id.equalsIgnoreCase("")) {
                    Error = {message:failedMessage + "No User with user name " + userName};
                    return Error;
                } else {
                    return user;
                }
            }
            mime:EntityError e => {
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
function resolveGroup (string groupName, http:Response response) returns Group|error {
    Group receivedGroup = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving group:" + groupName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
        match received {
            json payload => {
                receivedGroup = convertReceivedPayloadToGroup(payload);
                if (receivedGroup.id.equalsIgnoreCase("")) {
                    Error = {message:failedMessage + "No Group named " + groupName};
                    return Error;
                } else {
                    return receivedGroup;
                }
            }
            mime:EntityError e => {
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
function createRequest (json body) returns http:Request {
    http:Request request =new();
    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
    request.setJsonPayload(body);
    return request;
}

documentation {Returns a json object that should be attached to the http:Request to update a user
    P{{valueType}} The name of the user attribute
    P{{newValue}} The new value of the attribute
}
function createUpdateBody (string valueType, string newValue) returns json|error {
    json body = SCIM_PATCH_ADD_BODY;
    error Error = {};

    if (valueType.equalsIgnoreCase("nickName")) {
        body.Operations[0].value = {"nickName":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("preferredLanguage")) {
        body.Operations[0].value = {"preferredLanguage":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("title")) {
        body.Operations[0].value = {"title":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("password")) {
        body.Operations[0].value = {"password":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("profileUrl")) {
        body.Operations[0].value = {"profileUrl":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("locale")) {
        body.Operations[0].value = {"locale":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("timezone")) {
        body.Operations[0].value = {"timezone":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("active")) {
        body.Operations[0].value = {"active":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("userType")) {
        body.Operations[0].value = {"userType":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("displayName")) {
        body.Operations[0].value = {"displayName":newValue};
        return body;
    } if (valueType.equalsIgnoreCase("externalId")) {
        body.Operations[0].value = {"externalId":newValue};
        return body;
    } else {
        Error = {message:"No matching value"};
        return Error;
    }

}