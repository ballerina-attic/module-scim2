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
import wso2/oauth2;

@Description {value:"SCIM2 Client Connector"}
public type ScimConnector object {
    public {
        string baseUrl;
        oauth2:Client oauthEP;
    }

    public function getListOfUsers () returns (User[]|error);
    public function getListOfGroups () returns (Group[]|error);
    public function getMe() returns (User|error);
    public function getGroupByName (string groupName) returns (Group|error);
    public function getUserByUsername (string userName) returns (User|error);
    public function createGroup (Group crtGroup) returns (string|error);
    public function createUser (User user) returns (string|error);
    public function addUserToGroup (string userName, string groupName) returns (string|error);
    public function removeUserFromGroup (string userName, string groupName) returns (string|error);
    public function isUserInGroup (string userName, string groupName) returns (string|error);
    public function deleteUserByUsername (string userName) returns (string|error);
    public function deleteGroupByName (string groupName) returns (string|error);
    public function updateSimpleUserValue (string id, string valueType, string newValue) returns
                                                                                        (string|error);
    public function updateEmails (string id, Email[] emails) returns (string|error);
    public function updateAddresses (string id, Address[] addresses) returns (string|error);
    public function updateUser (User user) returns (string|error);
};

@Description {value:"Get the whole list of users in the user store"}
@Return {value:"User[]: Array of User structs"}
@Return {value:"error: Error"}
public function ScimConnector::getListOfUsers () returns (User[]|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Listing users failed. ";

    var res = oauthEP_temp -> get(SCIM_USER_END_POINT, request);
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
                        var noOfResults = payload[SCIM_TOTAL_RESULTS].toString() ?: "";
                        if (noOfResults.equalsIgnoreCase("0")) {
                            Error = {message:"There are no users"};
                            return Error;
                        } else {
                            User[] userList = [];
                            payload = payload["Resources"];
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

@Description {value:"Get the whole list of groups"}
@Return {value:"Group[]: Array of Group structs"}
@Return {value:"error: Error"}
public function ScimConnector::getListOfGroups () returns (Group[]|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage = "Listing groups failed. ";

    var res = oauthEP_temp -> get(SCIM_GROUP_END_POINT, request);
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
                        var noOfResults = payload[SCIM_TOTAL_RESULTS].toString() ?: "";
                        if (noOfResults.equalsIgnoreCase("0")) {
                            Error = {message:"There are no Groups"};
                            return Error;
                        } else {
                            Group[] groupList = [];
                            payload = payload["Resources"];
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

@Description {value:"Get the user that is currently authenticated"}
@Return {value:"User: User struct"}
@Return {value:"error: Error"}
public function ScimConnector::getMe () returns (User|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    User user = {};

    string failedMessage = "Getting currently authenticated user failed. ";

    var res = oauthEP_temp -> get(SCIM_ME_ENDPOINT, request);
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

@Description {value:"Get a group in the user store by name"}
@Param {value:"groupName: The display Name of the group"}
@Return {value:"Group: Group struct"}
@Return {value:"error: Error"}
public function ScimConnector::getGroupByName (string groupName) returns (Group|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var res = oauthEP_temp -> get(s, request);
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

@Description {value:"Get a user in the user store by his user name"}
@Param {value:"userName: User name of the user"}
@Return {value:"User: User struct"}
@Return {value:"error: Error"}
public function ScimConnector::getUserByUsername (string userName) returns (User|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    var res = oauthEP_temp -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request);
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

@Description {value:"Create a group in the user store"}
@Param {value:"crtGroup: Group struct with group details"}
@Return {value:"string: String literal"}
@Return {value:"error: Error"}
public function ScimConnector::createGroup (Group crtGroup) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Creating group:" + crtGroup.displayName + " failed. ";

    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);

    json jsonPayload = convertGroupToJson(crtGroup);
    request.setJsonPayload(jsonPayload);
    var res = oauthEP_temp -> post(SCIM_GROUP_END_POINT, request);
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
                        Error = {message:failedMessage + (payload.detail.toString() ?: "")};
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

@Description {value:"Create a user in the user store"}
@Param {value:"user: user struct with user details"}
@Return {value:"string: string indicating whether user creation was successful or failed"}
@Return {value:"error: Error"}
public function ScimConnector::createUser (User user) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Creating user:" + user.userName + " failed. ";

    if (user.emails != null) {
        foreach email in user.emails {
            if (!email["type"].equalsIgnoreCase("work") && !email["type"].equalsIgnoreCase("home")
                                                            && !email["type"].equalsIgnoreCase("other")) {
                Error = {message:failedMessage + "Email should either be home or work"};
                return Error;
            }
        }
    }
    if (user.addresses != null) {
        foreach address in user.addresses {
            if (!address["type"].equalsIgnoreCase("work") && !address["type"].equalsIgnoreCase("home")
                                                              && !address["type"].equalsIgnoreCase("other")) {
                Error = {message:failedMessage + "Address type should either be work or home"};
                return Error;
            }
        }
    }
    if (user.phoneNumbers != null) {
        foreach phone in user.phoneNumbers {
            if (!phone["type"].equalsIgnoreCase("work") && !phone["type"].equalsIgnoreCase("home")
                                                            && !phone["type"].equalsIgnoreCase("mobile")
                                                                && !phone["type"].equalsIgnoreCase("fax")
                                                                    && !phone["type"].equalsIgnoreCase("pager")
                                                                        && !phone["type"].equalsIgnoreCase("other")) {
                Error = {message:failedMessage + "Phone number type should be work,mobile,fax,pager,home or other"};
                return Error;
            }
        }
    }
    if (user.photos != null) {
        foreach photo in user.photos {
            if (!photo["type"].equalsIgnoreCase("photo") && !photo["type"].equalsIgnoreCase("thumbnail")) {
                Error = {message:failedMessage + "Photo type should either be photo or thumbnail"};
                return Error;
            }
        }
    }

    json jsonPayload = convertUserToJson(user, "create");

    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
    request.setJsonPayload(jsonPayload);
    var res = oauthEP_temp -> post(SCIM_USER_END_POINT, request);
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
                        Error = {message:failedMessage + (payload.detail.toString() ?: "")};
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

@Description {value:"Add an user in the user store to a existing group"}
@Param {value:"userName: User name of the user"}
@Param {value:"groupName: Display name of the group"}
@Return {value:"string: String literal"}
@Return {value:"error: Error"}
public function ScimConnector::addUserToGroup (string userName, string groupName) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Adding user:" + userName + " to group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var resUser = oauthEP_temp -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, requestUser);
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
    var resGroup = oauthEP_temp -> get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName, requestGroup);
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
    string ref = baseUrl + SCIM_USER_END_POINT + "/" + value;
    string url = SCIM_GROUP_END_POINT + "/" + gro.id;

    json body = SCIM_GROUP_PATCH_ADD_BODY;
    body.Operations[0].value.members[0].display = userName;
    body.Operations[0].value.members[0]["$ref"] = ref;
    body.Operations[0].value.members[0].value = value;

    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
    request.setJsonPayload(body);
    var res = oauthEP_temp -> patch(url, request);
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
                        Error = {message:failedMessage + (payload.detail.toString() ?: "")};
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

@Description {value:"Remove an user from a group"}
@Param {value:"userName: User name of the user"}
@Param {value:"groupName: Display name of the group"}
@Return {value:"string: String literal"}
@Return {value:"error: Error"}
public function ScimConnector::removeUserFromGroup (string userName, string groupName) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Removing user:" + userName + " from group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var resUser = oauthEP_temp -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME +
                                 userName, requestUser);
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
    var resGroup = oauthEP_temp -> get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME +
                                  groupName, groupRequest);
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
    string url = SCIM_GROUP_END_POINT + "/" + gro.id;

    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
    request.setJsonPayload(body);
    var res = oauthEP_temp -> patch(url, request);
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
                        Error = {message:failedMessage + (payload.detail.toString() ?: "")};
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

@Description {value:"Check whether an user is in a certain group"}
@Param {value:"userName: User name of the user"}
@Param {value:"groupName: Display name of the group"}
@Return {value:"boolean: true/false"}
@Return {value:"error: Error"}
public function ScimConnector::isUserInGroup (string userName, string groupName) returns (boolean|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};
    User user = {};

    var res = oauthEP_temp -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request);
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

@Description {value:"Delete an user from user store using his user name"}
@Param {value:"userName: User name of the user"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::deleteUserByUsername (string userName) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();

    string failedMessage;
    failedMessage = "Deleting user:" + userName + " failed. ";

    //get user
    http:Request userRequest = new();
    User user = {};
    error Error = {};
    var resUser = oauthEP_temp -> get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, userRequest);
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
                    var res = oauthEP_temp -> delete(SCIM_USER_END_POINT + "/" + userId, request);
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

@Description {value:"Delete group using its name"}
@Param {value:"groupName: Display name of the group"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::deleteGroupByName (string groupName) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    http:Request request = new();
    error Error = {};

    string failedMessage;
    failedMessage = "Deleting group:" + groupName + " failed. ";

    //get the group
    http:Request groupRequest = new();
    Group gro = {};
    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var resGroup = oauthEP_temp -> get(s, groupRequest);
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
                    var res = oauthEP_temp -> delete(SCIM_GROUP_END_POINT + "/" + groupId, request);
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

@Description {value:"Update the nick name of the user"}
@Param {value:"id: ID of the user"}
@Param {value:"valueType: Type of the field that you want to update"}
@Param {value:"newValue: The new value of the the relevent field"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::updateSimpleUserValue (string id, string valueType, string newValue) returns
    (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    error Error = {};

    if (id.equalsIgnoreCase("") || newValue == "") {
        Error = {message:"User and new " + valueType + " should be valid"};
        return Error;
    }

    http:Request request = new();
    json body = check createUpdateBody(valueType, newValue);
    request = createRequest(body);

    string url = SCIM_USER_END_POINT + "/" + id;
    var res = oauthEP_temp -> patch(url, request);
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


@Description {value:"Update the email addresses of the user"}
@Param {value:"id: ID of the user"}
@Param {value:"emails: List of new email address structs"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::updateEmails (string id, Email[] emails) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
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
        if (!emailAddress.^"type".equalsIgnoreCase("work") && !emailAddress.^"type".equalsIgnoreCase("home")) {
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

    string url = SCIM_USER_END_POINT + "/" + id;
    var res = oauthEP_temp -> patch(url, request);
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

@Description {value:"Update the addresses of the user"}
@Param {value:"id: ID of the User"}
@Param {value:"addresses: List of new Address structs"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::updateAddresses (string id, Address[] addresses) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
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
        if (!address.^"type".equalsIgnoreCase("work") && !address.^"type".equalsIgnoreCase("home")) {
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

    string url = SCIM_USER_END_POINT + "/" + id;
    var res = oauthEP_temp -> patch(url, request);
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


@Description {value:"Update the user"}
@Param {value:"user: User struct with the new user attributes"}
@Return {value:"string: string literal"}
@Return {value:"error: Error"}
public function ScimConnector::updateUser (User user) returns (string|error) {
    endpoint oauth2:Client oauthEP_temp = oauthEP;
    error Error = {};
    http:Request request = new();

    json body = convertUserToJson(user, "update");
    request = createRequest(body);
    string url = SCIM_USER_END_POINT + "/" + user.id;
    var res = oauthEP_temp -> put(url, request);
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