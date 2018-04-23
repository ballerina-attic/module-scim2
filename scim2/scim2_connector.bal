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
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDI   TIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
import ballerina/http;
import ballerina/mime;

documentation {Object for SCIM2 endpoint.
    F{{baseUrl}} base url of the REST API
    F{{httpClient}} HTTP client endpoint
}
public type ScimConnector object {
    public {
        string baseUrl;
        http:Client httpClient;
    }

    documentation {Returns a list of user records if found or error if any error occured
        R{{}} - List of User records
    }
    public function getListOfUsers () returns (User[]|error);

    documentation {Returns a list of group records if found or error if any error occured
        R{{}} - List of Group records
    }
    public function getListOfGroups () returns (Group[]|error);

    documentation {Returns the user that is currently authenticated
        R{{}} - User Record
    }
    public function getMe() returns (User|error);

    documentation {Returns a group record with the specified group name if found
        P{{groupName}} Name of the group
        R{{}} - Group record
    }
    public function getGroupByName (string groupName) returns (Group|error);

    documentation {Returns a user record with the specified username if found
        P{{userName}} User name of the user
        R{{}} - User record
    }
    public function getUserByUsername (string userName) returns (User|error);

    documentation {Create a group in the user store
        P{{crtGroup}} Group record with the group details
        R{{}} - String message with status
    }
    public function createGroup (Group crtGroup) returns (string|error);

    documentation {Create a user in the user store
        P{{user}} User record with the user details
        R{{}} - String message with status
    }
    public function createUser (User user) returns (string|error);

    documentation {Add a user specified by username to the group specified by group name
        P{{userName}} User name of the user
        P{{groupName}} Name of the group
        R{{}} - String message with status
    }
    public function addUserToGroup (string userName, string groupName) returns (string|error);

    documentation {Remove a user specified by username from the group specified by group name
        P{{userName}} User name of the user
        P{{groupName}} Name of the group
        R{{}} - String message with status
    }
    public function removeUserFromGroup (string userName, string groupName) returns (string|error);

    documentation {Returns whether the user specified by username belongs to the group specified by groupname
        P{{userName}} User name of the user
        P{{groupName}} Name of the group
        R{{}} - True or False
    }
    public function isUserInGroup (string userName, string groupName) returns (boolean|error);

    documentation {Delete a user from user store
        P{{userName}} User name of the user
        R{{}} - String message with status
    }
    public function deleteUserByUsername (string userName) returns (string|error);

    documentation {Delete a group from user store
        P{{groupName}} User name of the user
        R{{}} - String message with status
    }
    public function deleteGroupByName (string groupName) returns (string|error);

    documentation {Update a simple attribute of user
        P{{id}} ID of the user
        P{{valueType}} The attribute name to be updated
        P{{newValue}} The new value of the attribute
        R{{}} - String message with status
    }
    public function updateSimpleUserValue (string id, string valueType, string newValue) returns
                                                                                        (string|error);

    documentation {Update emails addresses of a user
        P{{id}} ID of the user
        P{{emails}} List of new emails of the user
        R{{}} - String message with status
        R{{}} - Error
    }
    public function updateEmails (string id, Email[] emails) returns (string|error);

    documentation {Update addresses of a user
        P{{id}} ID of the user
        P{{addresses}} List of new addresses of the user
        R{{}} - String message with status
    }
    public function updateAddresses (string id, Address[] addresses) returns (string|error);

    documentation {Update a user
        P{{user}} User record with new user values
        R{{}} - String message with status
    }
    public function updateUser (User user) returns (string|error);
};

public function ScimConnector::getListOfUsers () returns (User[]|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Listing users failed. ";

    var res = httpEP -> get(SCIM_USER_END_POINT, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message,
                        cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        var noOfResults = payload[SCIM_TOTAL_RESULTS].toString();
                        User[] userList = [];
                        if (noOfResults.equalsIgnoreCase("0")) {
                            return userList;
                        } else {
                            payload = payload[SCIM_RESOURCES];
                            int k = 0;
                            foreach element in payload {
                                User user = {};
                                user = convertJsonToUser(element);
                                userList[k] = user;
                                k = k + 1;
                            }
                            return userList;
                        }
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            } else {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            }
        }
    }
}

public function ScimConnector::getListOfGroups () returns (Group[]|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage = "Listing groups failed. ";

    var res = httpEP -> get(SCIM_GROUP_END_POINT, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        var noOfResults = payload[SCIM_TOTAL_RESULTS].toString();
                        Group[] groupList = [];
                        if (noOfResults.equalsIgnoreCase("0")) {
                            return groupList;
                        } else {
                            payload = payload[SCIM_RESOURCES];
                            int k = 0;
                            foreach element in payload {
                                Group group1 = {};
                                group1 = convertJsonToGroup(element);
                                groupList[k] = group1;
                                k = k + 1;
                            }
                            return groupList;
                        }
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            } else {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            }
        }
    }
}

public function ScimConnector::getMe () returns (User|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    User user = {};

    string failedMessage = "Getting currently authenticated user failed. ";

    var res = httpEP -> get(SCIM_ME_ENDPOINT, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        user = convertJsonToUser(payload);
                        return user;
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            } else {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            }
        }
    }
}

public function ScimConnector::getGroupByName (string groupName) returns (Group|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var res = httpEP -> get(s, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get Group " + groupName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedGroup = resolveGroup(groupName, response);
            return receivedGroup;
        }
    }
}

public function ScimConnector::getUserByUsername (string userName) returns (User|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    var res = httpEP -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get User " + userName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedUser = resolveUser(userName, response);
            return receivedUser;
        }
    }
}

public function ScimConnector::createGroup (Group crtGroup) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Creating group:" + crtGroup.displayName + " failed. ";

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);

    json jsonPayload = convertGroupToJson(crtGroup);
    request.setJsonPayload(jsonPayload);
    var res = httpEP -> post(SCIM_GROUP_END_POINT, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == HTTP_CREATED) {
                return "Group Created";
            }
            else if (statusCode == HTTP_UNAUTHORIZED) {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            } else {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        Error = {message:failedMessage + (payload.detail.toString())};
                        return Error;
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            }
        }
    }
}

public function ScimConnector::createUser (User user) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Creating user:" + user.userName + " failed. ";

    if (user.emails != null) {
        foreach email in user.emails {
            if (!email["type"].equalsIgnoreCase(SCIM_WORK) && !email["type"].equalsIgnoreCase(SCIM_HOME)
                                                            && !email["type"].equalsIgnoreCase(SCIM_OTHER)) {
                Error = {message:failedMessage + "Email should either be home or work"};
                return Error;
            }
        }
    }
    if (user.addresses != null) {
        foreach address in user.addresses {
            if (!address["type"].equalsIgnoreCase(SCIM_WORK) && !address["type"].equalsIgnoreCase(SCIM_HOME)
                                                              && !address["type"].equalsIgnoreCase(SCIM_OTHER)) {
                Error = {message:failedMessage + "Address type should either be work or home"};
                return Error;
            }
        }
    }
    if (user.phoneNumbers != null) {
        foreach phone in user.phoneNumbers {
            if (!phone["type"].equalsIgnoreCase(SCIM_WORK) && !phone["type"].equalsIgnoreCase(SCIM_HOME)
                                                            && !phone["type"].equalsIgnoreCase(SCIM_MOBILE)
                                                                && !phone["type"].equalsIgnoreCase(SCIM_FAX)
                                                                    && !phone["type"].equalsIgnoreCase(SCIM_PAGER)
                                                                        && !phone["type"].equalsIgnoreCase(SCIM_OTHER)) {
                Error = {message:failedMessage + "Phone number type should be work,mobile,fax,pager,home or other"};
                return Error;
            }
        }
    }
    if (user.photos != null) {
        foreach photo in user.photos {
            if (!photo["type"].equalsIgnoreCase(SCIM_PHOTO) && !photo["type"].equalsIgnoreCase(SCIM_THUMBNAIL)) {
                Error = {message:failedMessage + "Photo type should either be photo or thumbnail"};
                return Error;
            }
        }
    }

    json jsonPayload = convertUserToJson(user, "create");

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(jsonPayload);
    var res = httpEP -> post(SCIM_USER_END_POINT, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == HTTP_CREATED) {
                return "User Created";
            }
            else if (statusCode == HTTP_UNAUTHORIZED) {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            } else {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        Error = {message:failedMessage + (payload.detail.toString())};
                        return Error;
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            }
        }
    }
}

public function ScimConnector::addUserToGroup (string userName, string groupName) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Adding user:" + userName + " to group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var resUser = httpEP -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName,
                                request = requestUser);
    match resUser {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get User " + userName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedUser = resolveUser(userName, response);
            match receivedUser {
                User usr => {
                    user = usr;
                }
                error userError => {
                    Error = {message:failedMessage + userError.message};
                    return Error;
                }
            }
        }
    }
    //check if group valid
    http:Request requestGroup = new();
    Group gro = {};
    var resGroup = httpEP -> get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName,
                                 request = requestGroup);
    match resGroup {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get Group " + groupName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedGroup = resolveGroup(groupName, response);
            match receivedGroup {
                Group grp => {
                    gro = grp;
                }
                error groupError => {
                    Error = {message:failedMessage + groupError.message};
                    return Error;
                }
            }
        }
    }
    //create request body
    string value = user.id;
    string ref = self.baseUrl + SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + value;
    string url = SCIM_GROUP_END_POINT + SCIM_FILE_SEPERATOR + gro.id;

    json body = SCIM_GROUP_PATCH_ADD_BODY;
    body.Operations[0].value.members[0].display = userName;
    body.Operations[0].value.members[0][SCIM_REF] = ref;
    body.Operations[0].value.members[0].value = value;

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(body);
    var res = httpEP -> patch(url, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == HTTP_OK) {
                return "User Added";
            }
            else if (statusCode == HTTP_UNAUTHORIZED) {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            } else {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        Error = {message:failedMessage + (payload.detail.toString())};
                        return Error;
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            }
        }
    }
}

public function ScimConnector::removeUserFromGroup (string userName, string groupName) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Removing user:" + userName + " from group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var resUser = httpEP -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME +
                                 userName, request = requestUser);
    match resUser {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get User " + userName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedUser = resolveUser(userName, response);
            match receivedUser {
                User usr => {
                    user = usr;
                }
                error userError => {
                    Error = {message:failedMessage + userError.message};
                    return Error;
                }
            }
        }
    }

    //check if group valid
    Group gro = {};
    http:Request groupRequest = new();
    var resGroup = httpEP -> get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME +
                                  groupName, request = groupRequest);
    match resGroup {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get Group " + groupName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedGroup = resolveGroup(groupName, response);
            match receivedGroup {
                Group grp => {
                    gro = grp;
                }
                error groupError => {
                    Error = {message:failedMessage + groupError.message};
                    return Error;
                }
            }
        }
    }
    //create request body
    json body = SCIM_GROUP_PATCH_REMOVE_BODY;
    string path = "members[display eq " + userName + "]";
    body.Operations[0].path = path;
    string url = SCIM_GROUP_END_POINT + SCIM_FILE_SEPERATOR + gro.id;

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(body);
    var res = httpEP -> patch(url, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == HTTP_OK) {
                return "User Removed";
            }
            else if (statusCode == HTTP_UNAUTHORIZED) {
                Error = {message:failedMessage + response.reasonPhrase};
                return Error;
            } else {
                var received = response.getJsonPayload();
                match received {
                    json payload => {
                        Error = {message:failedMessage + (payload.detail.toString())};
                        return Error;
                    }
                    mime:EntityError e => {
                        Error = {message:failedMessage + e.message, cause:e.cause};
                        return Error;
                    }
                }
            }
        }
    }
}

public function ScimConnector::isUserInGroup (string userName, string groupName) returns (boolean|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};
    User user = {};

    var res = httpEP -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get User " + userName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedUser = resolveUser(userName, response);
            match receivedUser {
                User usr => {
                    user = usr;
                    foreach gro in user.groups {
                        if (gro.displayName.equalsIgnoreCase(groupName)) {
                            return true;
                        }
                    }
                    return false;
                }
                error userError => {
                    Error = {message:"failed to resolve user " + userError.message};
                    return Error;
                }
            }
        }
    }
}

public function ScimConnector::deleteUserByUsername (string userName) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();

    string failedMessage;
    failedMessage = "Deleting user:" + userName + " failed. ";

    //get user
    http:Request userRequest = new();
    User user = {};
    error Error = {};
    var resUser = httpEP -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName,
                                request = userRequest);
    match resUser {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get User " + userName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedUser = resolveUser(userName, response);
            match receivedUser {
                User usr => {
                    user = usr;
                    string userId = user.id;
                    var res = httpEP -> delete(SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + userId, request = request);
                    match res {
                        http:HttpConnectorError connectorError => {
                            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
                            return Error;
                        }
                        http:Response resp => {
                            if (resp.statusCode == HTTP_NO_CONTENT) {
                                return "deleted";
                            }
                            Error = {message:failedMessage + response.reasonPhrase};
                            return Error;
                        }
                    }
                }
                error userError => {
                    Error = {message:failedMessage + userError.message};
                    return Error;
                }
            }
        }
    }
}

public function ScimConnector::deleteGroupByName (string groupName) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Deleting group:" + groupName + " failed. ";

    //get the group
    http:Request groupRequest = new();
    Group gro = {};
    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var resGroup = httpEP -> get(s, request = groupRequest);
    match resGroup {
        http:HttpConnectorError connectorError => {
            Error = {message:"Failed to get Group " + groupName + "." +
                             connectorError.message, cause:connectorError.cause};
            return Error;
        }
        http:Response response => {
            var receivedGroup = resolveGroup(groupName, response);
            match receivedGroup {
                Group grp => {
                    gro = grp;
                    string groupId = gro.id;
                    var res = httpEP -> delete(SCIM_GROUP_END_POINT + SCIM_FILE_SEPERATOR + groupId, request = request);
                    match res {
                        http:HttpConnectorError connectorError => {
                            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
                            return Error;
                        }
                        http:Response resp => {
                            if (resp.statusCode == HTTP_NO_CONTENT) {
                                return "deleted";
                            }
                            Error = {message:failedMessage + response.reasonPhrase};
                            return Error;
                        }
                    }
                }
                error groupError => {
                    Error = {message:failedMessage + groupError.message};
                    return Error;
                }
            }
        }
    }
}

public function ScimConnector::updateSimpleUserValue (string id, string valueType, string newValue) returns
    (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    error Error = {};

    if (id.equalsIgnoreCase("") || newValue == "") {
        Error = {message:"User and new " + valueType + " should be valid"};
        return Error;
    }

    http:Request request = new();
    var bodyOrError = createUpdateBody(valueType, newValue);
    match bodyOrError {
        json body => {
            request = createRequest(body);

            string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
            var res = httpEP -> patch(url, request = request);
            match res {
                http:HttpConnectorError connectorError => {
                    Error = {message:connectorError.message};
                    return Error;
                }
                http:Response response => {
                    if (response.statusCode == HTTP_OK) {
                        return valueType + " updated";
                    }
                    Error = {message:response.reasonPhrase};
                    return Error;
                }
            }
        }
        error err => {
            Error = {message:"Updating " + valueType + " of user failed. " + err.message};
            return Error;
        }
    }
}

public function ScimConnector::updateEmails (string id, Email[] emails) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    error Error = {};

    if (id.equalsIgnoreCase("")) {
        Error = {message:"User should be valid"};
        return Error;
    }

    http:Request request = new();

    json[] emailList = [];
    json email;
    int i;
    foreach emailAddress in emails {
        if (!emailAddress.^"type".equalsIgnoreCase(SCIM_WORK) && !emailAddress.^"type".equalsIgnoreCase(SCIM_HOME)) {
            Error = {message:"Email type should be defiend as either home or work"};
            return Error;
        }
        email = convertEmailToJson(emailAddress);
        emailList[i] = email;
        i = i + 1;
    }
    json body = SCIM_PATCH_ADD_BODY;
    body.Operations[0].value = {"emails":emailList};

    request = createRequest(body);

    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
    var res = httpEP -> patch(url, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:connectorError.message};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                return "Email updated";
            }
            Error = {message:response.reasonPhrase};
            return Error;
        }
    }
}

public function ScimConnector::updateAddresses (string id, Address[] addresses) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    error Error = {};

    if (id.equalsIgnoreCase("")) {
        Error = {message:"User should be valid"};
        return Error;
    }

    http:Request request = new();

    json[] addressList = [];
    json element;
    int i;
    foreach address in addresses {
        if (!address.^"type".equalsIgnoreCase(SCIM_WORK) && !address.^"type".equalsIgnoreCase(SCIM_HOME)) {
            Error = {message:"Address type is required and it should either be work or home"};
            return Error;
        }
        element = convertAddressToJson(address);
        addressList[i] = element;
        i = i + 1;
    }
    json body = SCIM_PATCH_ADD_BODY;
    body.Operations[0].value = {"addresses":addressList};

    request = createRequest(body);

    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
    var res = httpEP -> patch(url, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:connectorError.message};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                return "Address updated";
            }
            Error = {message:response.reasonPhrase};
            return Error;
        }
    }
}

public function ScimConnector::updateUser (User user) returns (string|error) {
    endpoint http:Client httpEP = self.httpClient;
    error Error = {};
    http:Request request = new();

    json body = convertUserToJson(user, "update");
    request = createRequest(body);
    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + user.id;
    var res = httpEP -> put(url, request = request);
    match res {
        http:HttpConnectorError connectorError => {
            Error = {message:connectorError.message};
            return Error;
        }
        http:Response response => {
            if (response.statusCode == HTTP_OK) {
                return "User updated";
            }
            Error = {message:response.reasonPhrase};
            return Error;
        }
    }
}