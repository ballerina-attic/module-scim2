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

package scimclient;

import ballerina/net.http;
import ballerina/mime;
import oauth2;
import ballerina/io;
import ballerina/util;


////string baseURL;
//string AccessToken = "dfadaf";
//string BaseUrl="https://localhost:9443";
//string ClientId;
//string ClientSecret;
//string RefreshToken;
//string RefreshTokenEP;
//string RefreshTokenPath;
//http:ClientEndpointConfiguration ClientConfig = {};
//
//endpoint oauth2:OAuth2Endpoint ep {
//    accessToken: AccessToken,
//    baseUrl: BaseUrl,
//    clientId: ClientId,
//    clientSecret: ClientSecret,
//    refreshToken: RefreshToken,
//    refreshTokenEP: RefreshTokenEP,
//    refreshTokenPath: RefreshTokenPath,
//    clientConfig: ClientConfig
//};



public struct ScimConnector {
    string baseUrl;
    oauth2:OAuth2Endpoint ep;
}

@Description {value:"Get the whole list of users in the user store"}
@Param {value:"User[]: Array of User structs"}
@Param {value:"error: Error"}
public function <ScimConnector scimCon> getListOfUsers () returns User[]|error {
    endpoint oauth2:OAuth2Endpoint oauthep = scimCon.ep;
    http:Request request = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Listing users failed. ";
    //io:println(AccessToken);

    var res = oauthep -> get(SCIM_USER_END_POINT, request);
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
                        if (noOfResults.equalsIgnoreCase("0")) {
                            Error = {message:"There are no users"};
                            return Error;
                        } else {
                            User[] userList = [];
                            payload = payload["Resources"];
                            int k = 0;
                            foreach element in payload {
                                User user = {};
                                user = <User, convertJsonToUser()>element;
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
//
//@Description {value:"Get the whole list of groups"}
//@Param {value:"Group[]: Array of Group structs"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> getListOfGroups () returns Group[]|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage = "Listing groups failed. ";
//
//    var res = oauthCon.get(SCIM_GROUP_END_POINT, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            if (response.statusCode == HTTP_OK) {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        var noOfResults = payload[SCIM_TOTAL_RESULTS].toString();
//                        if (noOfResults.equalsIgnoreCase("0")) {
//                            Error = {message:"There are no Groups"};
//                            return Error;
//                        } else {
//                            Group[] groupList = [];
//                            payload = payload["Resources"];
//                            int k = 0;
//                            foreach element in payload {
//                                Group group1 = {};
//                                group1 = <Group, convertJsonToGroup()>element;
//                                groupList[k] = group1;
//                                k = k + 1;
//                            }
//                            return groupList;
//                        }
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            } else {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            }
//        }
//    }
//}
//
//@Description {value:"Get the user that is currently authenticated"}
//@Param {value:"User: User struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> getMe () returns User|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//    User user = {};
//
//    string failedMessage = "Getting currently authenticated user failed. ";
//
//    var res = oauthCon.get(SCIM_ME_ENDPOINT, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            if (response.statusCode == HTTP_OK) {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        user = <User, convertJsonToUser()>payload;
//                        return user;
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            } else {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            }
//        }
//    }
//}
//
//@Description {value:"Get a group in the user store by name"}
//@Param {value:"groupName: The display Name of the group"}
//@Param {value:"Group: Group struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> getGroupByName (string groupName) returns Group|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
//    var res = oauthCon.get(s, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get Group " + groupName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedGroup = resolveGroup(groupName, response);
//            return receivedGroup;
//        }
//    }
//}
//
//@Description {value:"Get a user in the user store by his user name"}
//@Param {value:"userName: User name of the user"}
//@Param {value:"User: User struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> getUserByUsername (string userName) returns User|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    var res = oauthCon.get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get User " + userName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedUser = resolveUser(userName, response);
//            return receivedUser;
//        }
//    }
//}
//
//@Description {value:"Create a group in the user store"}
//@Param {value:"group: Group struct with group details"}
//@Param {value:"Group: Group struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> createGroup (Group crtGroup) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Creating group:" + crtGroup.displayName + " failed. ";
//
//    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
//
//    json jsonPayload = <json, convertGroupToJson()>crtGroup;
//    request.setJsonPayload(jsonPayload);
//    var res = oauthCon.post(SCIM_GROUP_END_POINT, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            int statusCode = response.statusCode;
//            if (statusCode == HTTP_CREATED) {
//                return "Group Created";
//            }
//            else if (statusCode == HTTP_UNAUTHORIZED) {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            } else {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        Error = {message:failedMessage + payload.detail.toString()};
//                        return Error;
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Create a user in the user store"}
//@Param {value:"user: user struct with user details"}
//@Param {value:"string: string indicating whether user creation was successful or failed"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> createUser (User user) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Creating user:" + user.userName + " failed. ";
//
//    if (user.emails != null) {
//        foreach email in user.emails {
//            if (!email["type"].equalsIgnoreCase("work") && !email["type"].equalsIgnoreCase("home")
//                                                            && !email["type"].equalsIgnoreCase("other")) {
//                Error = {message:failedMessage + "Email should either be home or work"};
//                return Error;
//            }
//        }
//    }
//    if (user.addresses != null) {
//        foreach address in user.addresses {
//            if (!address["type"].equalsIgnoreCase("work") && !address["type"].equalsIgnoreCase("home")
//                                                              && !address["type"].equalsIgnoreCase("other")) {
//                Error = {message:failedMessage + "Address type should either be work or home"};
//                return Error;
//            }
//        }
//    }
//    if (user.phoneNumbers != null) {
//        foreach phone in user.phoneNumbers {
//            if (!phone["type"].equalsIgnoreCase("work") && !phone["type"].equalsIgnoreCase("home")
//                                                            && !phone["type"].equalsIgnoreCase("mobile")
//                                                                && !phone["type"].equalsIgnoreCase("fax")
//                                                                    && !phone["type"].equalsIgnoreCase("pager")
//                                                                        && !phone["type"].equalsIgnoreCase("other")) {
//                Error = {message:failedMessage + "Phone number type should be work,mobile,fax,pager,home or other"};
//                return Error;
//            }
//        }
//    }
//    if (user.photos != null) {
//        foreach photo in user.photos {
//            if (!photo["type"].equalsIgnoreCase("photo") && !photo["type"].equalsIgnoreCase("thumbnail")) {
//                Error = {message:failedMessage + "Photo type should either be photo or thumbnail"};
//                return Error;
//            }
//        }
//    }
//
//    json jsonPayload = <json, convertUserToJson()>user;
//
//    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
//    request.setJsonPayload(jsonPayload);
//    var res = oauthCon.post(SCIM_USER_END_POINT, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            int statusCode = response.statusCode;
//            if (statusCode == HTTP_CREATED) {
//                return "User Created";
//            }
//            else if (statusCode == HTTP_UNAUTHORIZED) {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            } else {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        Error = {message:failedMessage + payload.detail.toString()};
//                        return Error;
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Add an user in the user store to a existing group"}
//@Param {value:"userName: User name of the user"}
//@Param {value:"groupName: Display name of the group"}
//@Param {value:"Group: Group struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> addUserToGroup (string userName, string groupName) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Adding user:" + userName + " to group:" + groupName + " failed.";
//
//    //check if user valid
//    http:Request requestUser = {};
//    User user = {};
//    var resUser = oauthCon.get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, requestUser);
//    match resUser {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get User " + userName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedUser = resolveUser(userName, response);
//            match receivedUser {
//                User usr => {
//                    user = usr;
//                }
//                error userError => {
//                    Error = {message:failedMessage + userError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//    //check if group valid
//    http:Request requestGroup = {};
//    Group gro = {};
//    var resGroup = oauthCon.get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName, requestGroup);
//    match resGroup {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get Group " + groupName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedGroup = resolveGroup(groupName, response);
//            match receivedGroup {
//                Group grp => {
//                    gro = grp;
//                }
//                error groupError => {
//                    Error = {message:failedMessage + groupError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//    //create request body
//    string value = user.id;
//    string ref = scimConn.baseUrl + SCIM_USER_END_POINT + "/" + value;
//    string url = SCIM_GROUP_END_POINT + "/" + gro.id;
//
//    var body =? util:parseJson(SCIM_GROUP_PATCH_ADD_BODY);
//    body.Operations[0].value.members[0].display = userName;
//    body.Operations[0].value.members[0]["$ref"] = ref;
//    body.Operations[0].value.members[0].value = value;
//
//    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
//    request.setJsonPayload(body);
//    var res = oauthCon.patch(url, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            int statusCode = response.statusCode;
//            if (statusCode == HTTP_OK) {
//                return "User Added";
//            }
//            else if (statusCode == HTTP_UNAUTHORIZED) {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            } else {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        Error = {message:failedMessage + payload.detail.toString()};
//                        return Error;
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Remove an user from a group"}
//@Param {value:"userName: User name of the user"}
//@Param {value:"groupName: Display name of the group"}
//@Param {value:"Group: Group struct"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> removeUserFromGroup (string userName, string groupName) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Removing user:" + userName + " from group:" + groupName + " failed.";
//
//    //check if user valid
//    http:Request requestUser = {};
//    User user = {};
//    var resUser = oauthCon.get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME +
//                               userName, requestUser);
//    match resUser {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get User " + userName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedUser = resolveUser(userName, response);
//            match receivedUser {
//                User usr => {
//                    user = usr;
//                }
//                error userError => {
//                    Error = {message:failedMessage + userError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//
//    //check if group valid
//    Group gro = {};
//    http:Request groupRequest = {};
//    var resGroup = oauthCon.get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME +
//                                groupName, groupRequest);
//    match resGroup {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get Group " + groupName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedGroup = resolveGroup(groupName, response);
//            match receivedGroup {
//                Group grp => {
//                    gro = grp;
//                }
//                error groupError => {
//                    Error = {message:failedMessage + groupError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//    //create request body
//    var body =? util:parseJson(SCIM_GROUP_PATCH_REMOVE_BODY);
//    string path = "members[display eq " + userName + "]";
//    body.Operations[0].path = path;
//    string url = SCIM_GROUP_END_POINT + "/" + gro.id;
//
//    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
//    request.setJsonPayload(body);
//    var res = oauthCon.patch(url, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            int statusCode = response.statusCode;
//            if (statusCode == HTTP_OK) {
//                return "User Removed";
//            }
//            else if (statusCode == HTTP_UNAUTHORIZED) {
//                Error = {message:failedMessage + response.reasonPhrase};
//                return Error;
//            } else {
//                var received = response.getJsonPayload();
//                match received {
//                    json payload => {
//                        Error = {message:failedMessage + payload.detail.toString()};
//                        return Error;
//                    }
//                    mime:EntityError e => {
//                        Error = {message:failedMessage + e.message, cause:e.cause};
//                        return Error;
//                    }
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Check whether an user is in a certain group"}
//@Param {value:"userName: User name of the user"}
//@Param {value:"groupName: Display name of the group"}
//@Param {value:"boolean: true/false"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> isUserInGroup (string userName, string groupName) returns boolean|error {
//
//    http:Request request = {};
//    error Error = {};
//    User user = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    var res = oauthCon.get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, request);
//    match res {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get User " + userName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedUser = resolveUser(userName, response);
//            match receivedUser {
//                User usr => {
//                    user = usr;
//                    foreach gro in user.groups {
//                        if (gro.displayName.equalsIgnoreCase(groupName)) {
//                            return true;
//                        }
//                    }
//                    return false;
//                }
//                error userError => {
//                    Error = {message:"failed to resolve user " + userError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Delete an user from user store using his user name"}
//@Param {value:"userName: User name of the user"}
//@Param {value:"string: string literal"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> deleteUserByUsername (string userName) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Deleting user:" + userName + " failed. ";
//
//    //get user
//    http:Request userRequest = {};
//    User user = {};
//    var resUser = oauthCon.get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, userRequest);
//    match resUser {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get User " + userName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedUser = resolveUser(userName, response);
//            match receivedUser {
//                User usr => {
//                    user = usr;
//                    string userId = user.id;
//                    var res = oauthCon.delete(SCIM_USER_END_POINT + "/" + userId, request);
//                    match res {
//                        http:HttpConnectorError connectorError => {
//                            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//                            return Error;
//                        }
//                        http:Response resp => {
//                            if (resp.statusCode == HTTP_NO_CONTENT) {
//                                return "deleted";
//                            }
//                            Error = {message:failedMessage + response.reasonPhrase};
//                            return Error;
//                        }
//                    }
//                }
//                error userError => {
//                    Error = {message:failedMessage + userError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//}
//
//@Description {value:"Delete group using its name"}
//@Param {value:"groupName: Display name of the group"}
//@Param {value:"string: string literal"}
//@Param {value:"error: Error"}
//public function <ScimConnector scimConn> deleteGroupByName (string groupName) returns string|error {
//
//    http:Request request = {};
//    error Error = {};
//
//    if (!isConnectorInitialized) {
//        Error = {message:"error: Connector not initialized"};
//        return Error;
//    }
//
//    string failedMessage;
//    failedMessage = "Deleting group:" + groupName + " failed. ";
//
//    //get the group
//    http:Request groupRequest = {};
//    Group gro = {};
//    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
//    var resGroup = oauthCon.get(s, groupRequest);
//    match resGroup {
//        http:HttpConnectorError connectorError => {
//            Error = {message:"Failed to get Group " + groupName + "." + connectorError.message, cause:connectorError.cause};
//            return Error;
//        }
//        http:Response response => {
//            var receivedGroup = resolveGroup(groupName, response);
//            match receivedGroup {
//                Group grp => {
//                    gro = grp;
//                    string groupId = gro.id;
//                    var res = oauthCon.delete(SCIM_GROUP_END_POINT + "/" + groupId, request);
//                    match res {
//                        http:HttpConnectorError connectorError => {
//                            Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
//                            return Error;
//                        }
//                        http:Response resp => {
//                            if (resp.statusCode == HTTP_NO_CONTENT) {
//                                return "deleted";
//                            }
//                            Error = {message:failedMessage + response.reasonPhrase};
//                            return Error;
//                        }
//                    }
//                }
//                error groupError => {
//                    Error = {message:failedMessage + groupError.message};
//                    return Error;
//                }
//            }
//        }
//    }
//}
//
