// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import ballerina/mime;

# SCIM2 Client object.
# + baseUrl - The base URL of the SCIM2 API
# + scimClient - HTTP client endpoint
public type Client client object {

    public http:Client scimClient;
    public string baseUrl;

    public remote function __init(Scim2Configuration scim2Config) {
        self.scimClient = new(scim2Config.baseUrl, config = scim2Config.clientConfig);
        self.baseUrl = scim2Config.baseUrl;
    }

    # Returns a list of user records if found or error if any error occured.
    # + return - If success, returns list of User objects, else returns error
    public remote function getListOfUsers() returns (User[]|error);

    # Returns a list of group records if found or error if any error occured.
    # + return - If success, returns list of Group objects, else returns error
    public remote function getListOfGroups() returns (Group[]|error);

    # Returns the user that is currently authenticated.
    # + return - If success, returns User object, else returns error
    public remote function getMe() returns (User|error);

    # Returns a group record with the specified group name if found.
    # + groupName - Name of the group
    # + return - If success, returns Group object, else returns error
    public remote function getGroupByName(string groupName) returns (Group|error);

    # Returns a user record with the specified username if found.
    # + userName - User name of the user
    # + return - If success, returns User object, else returns error
    public remote function getUserByUsername(string userName) returns (User|error);

    # Create a group in the user store.
    # + crtGroup - Group record with the group details
    # + return - If success, returns string message with status, else returns error
    public remote function createGroup(Group crtGroup) returns (string|error);

    # Create a user in the user store.
    # + user - User record with the user details
    # + return - If success, returns string message with status, else returns error
    public remote function createUser(User user) returns (string|error);

    # Add a user specified by username to the group specified by group name.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns string message with status, else returns error
    public remote function addUserToGroup(string userName, string groupName) returns (string|error);
    # Remove a user specified by username from the group specified by group name.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns string message with status, else returns error
    public remote function removeUserFromGroup(string userName, string groupName) returns (string|error);

    # Returns whether the user specified by username belongs to the group specified by groupname.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns boolean value, else returns error
    public remote function isUserInGroup(string userName, string groupName) returns (boolean|error);

    # Delete a user from user store.
    # + userName - User name of the user
    # + return - If success, returns string message with status, else returns error
    public remote function deleteUserByUsername(string userName) returns (string|error);

    # Delete a group from user store.
    # + groupName - User name of the user
    # + return - String message with status
    public remote function deleteGroupByName(string groupName) returns (string|error);

    # Update a simple attribute of user.
    # + id - ID of the user
    # + valueType - The attribute name to be updated
    # + newValue - The new value of the attribute
    # + return - If success, returns string message with status, else returns error
    public remote function updateSimpleUserValue(string id, string valueType, string newValue) returns (string|error);

    # Update emails addresses of a user.
    # + id - ID of the user
    # + emails - List of new emails of the user
    # + return - If success, returns string message with status, else returns error
    public remote function updateEmails(string id, Email[] emails) returns (string|error);

    # Update addresses of a user.
    # + id - ID of the user
    # + addresses - List of new addresses of the user
    # + return - If success, returns string message with status, else returns error
    public remote function updateAddresses(string id, Address[] addresses) returns (string|error);

    # Update a user.
    # + user - User record with new user values
    # + return - If success, returns string message with status, else returns error
    public remote function updateUser(User user) returns (string|error);
};

# Twitter Connector configurations can be setup here.
# + baseUrl - The base URL of the REST API
# + accessToken - The
# + clientId - The
# + refreshToken - The
# + refreshUrl - The
# + clientSecret - The
# + clientConfig - Client endpoint configurations provided by the user
public type Scim2Configuration record {
    string baseUrl = "";
    string accessToken = "";
    string clientId = "";
    string clientSecret = "";
    string refreshToken = "";
    string refreshUrl = "";
    http:ClientEndpointConfig clientConfig = {};
};

remote function Client.getListOfUsers() returns (User[]|error) {
    http:Request request = new();

    string failedMessage;
    failedMessage = "Listing users failed. ";

    var response = self.scimClient->get(SCIM_USER_END_POINT, message = request);
    if (response is http:Response) {
        if (response.statusCode == HTTP_OK) {
            var received = response.getJsonPayload();
            if (received is json)  {
                var noOfResults = received[SCIM_TOTAL_RESULTS].toString();
                User[] userList = [];
                if (noOfResults.equalsIgnoreCase("0")) {
                    return userList;
                } else {
                    json[] data = <json[]>received[SCIM_RESOURCES];
                    int k = 0;
                    foreach json element in data {
                        User user = {};
                        user = convertJsonToUser(element);
                        userList[k] = user;
                        k = k + 1;
                    }
                    return userList;
                }
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the JSON payload of the response." });
                return err;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API." });
        return err;
    }
}

remote function Client.getListOfGroups() returns (Group[]|error) {
    http:Request request = new();

    string failedMessage = "Listing groups failed. ";

    var response = self.scimClient->get(SCIM_GROUP_END_POINT, message = request);
    if (response is http:Response) {
        if (response.statusCode == HTTP_OK) {
            var received = response.getJsonPayload();
            if (received is json) {
                var noOfResults = received[SCIM_TOTAL_RESULTS].toString();
                Group[] groupList = [];
                if (noOfResults.equalsIgnoreCase("0")) {
                    return groupList;
                } else {
                    json[] data = <json[]>received[SCIM_RESOURCES];
                    int k = 0;
                    foreach var element in data {
                        Group group1 = {};
                        group1 = convertJsonToGroup(element);
                        groupList[k] = group1;
                        k = k +1;
                    }
                    return groupList;
                }
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the JSON payload of the response." });
                return err;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE , { message: failedMessage + response.reasonPhrase });
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.getMe() returns (User|error) {
    http:Request request = new();

    User user = {};

    string failedMessage = "Getting currently authenticated user failed. ";

    var response = self.scimClient->get(SCIM_ME_ENDPOINT, message = request);
    if (response is http:Response) {
        if (response.statusCode == HTTP_OK) {
        var received = response.getJsonPayload();
            if (received is json)  {
                user = convertJsonToUser(received);
                return user;
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the JSON payload of the response." });
                return err;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.getGroupByName(string groupName) returns (Group|error) {
    http:Request request = new();

    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var response = self.scimClient->get(s, message = request);
    if (response is http:Response) {
        var receivedGroup = resolveGroup(groupName, response);
        return receivedGroup;
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.getUserByUsername(string userName) returns (User|error) {
    http:Request request = new();

    var response = self.scimClient->get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName, message = request);
    if (response is http:Response) {
        var receivedUser = resolveUser(userName, response);
        return receivedUser;
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.createGroup(Group crtGroup) returns (string|error) {
    http:Request request = new();

    string failedMessage;
    failedMessage = "Creating group:" + crtGroup.displayName + " failed. ";

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);

    json jsonPayload = convertGroupToJson(crtGroup);
    request.setJsonPayload(jsonPayload);
    var response = self.scimClient->post(SCIM_GROUP_END_POINT, request);
    if (response is http:Response) {
        int statusCode = response.statusCode;
        if (statusCode == HTTP_CREATED) {
            return "Group Created";
        } else if (statusCode == HTTP_UNAUTHORIZED) {
            error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
            return Error;
        } else {
            var payload = response.getJsonPayload();
            if (payload is json) {
                error Error = error(SCIM2_ERROR_CODE , { message: failedMessage + (payload.detail.toString())});
                return Error;
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the payload of the response." });
                return err;
            }
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.createUser(User user) returns (string|error) {
    http:Request request = new();

    string failedMessage;
    failedMessage = "Creating user:" + user.userName + " failed. ";

    if (user.emails.length() > 0) {
        foreach var email in user.emails {
            boolean isEmailTypeWork = email["type"].equalsIgnoreCase(SCIM_WORK) ?: false;
            boolean isEmailTypeHome = email["type"].equalsIgnoreCase(SCIM_HOME) ?: false;
            boolean isEmailTypeOther = email["type"].equalsIgnoreCase(SCIM_OTHER) ?: false;
            if (!isEmailTypeWork && !isEmailTypeHome && !isEmailTypeOther) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage
                + "Email should either be home or work" });
                return Error;
            }
        }
    }
    if (user.addresses.length() > 0) {
        foreach var address in user.addresses {
            boolean isAddressTypeWork = address["type"].equalsIgnoreCase(SCIM_WORK) ?: false;
            boolean isAddressTypeHome = address["type"].equalsIgnoreCase(SCIM_HOME) ?: false;
            boolean isAddressTypeOther = address["type"].equalsIgnoreCase(SCIM_OTHER) ?: false;
            if (!isAddressTypeWork && !isAddressTypeHome && !isAddressTypeOther) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage
                + "Address type should either be work or home" });
                return Error;
            }
        }
    }
    if (user.phoneNumbers.length() > 0) {
        foreach var phone in user.phoneNumbers {
            boolean isPhoneTypeWork = phone["type"].equalsIgnoreCase(SCIM_WORK) ?: false;
            boolean isPhoneTypeHome = phone["type"].equalsIgnoreCase(SCIM_HOME) ?: false;
            boolean isPhoneTypeMobile = phone["type"].equalsIgnoreCase(SCIM_MOBILE) ?: false;
            boolean isPhoneTypeFax = phone["type"].equalsIgnoreCase(SCIM_FAX) ?: false;
            boolean isPhoneTypePager = phone["type"].equalsIgnoreCase(SCIM_PAGER) ?: false;
            boolean isPhoneTypeOther = phone["type"].equalsIgnoreCase(SCIM_OTHER) ?: false;
            if (!isPhoneTypeWork && !isPhoneTypeHome && !isPhoneTypeMobile && !isPhoneTypeFax && !isPhoneTypePager
            && !isPhoneTypeOther) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage
                + "Phone number type should be work,mobile,fax,pager,home or other."});
                return Error;
            }
        }
    }
    if (user.photos.length() > 0) {
        foreach var photo in user.photos {
        boolean isPhotoTypePhoto = photo["type"].equalsIgnoreCase(SCIM_PHOTO) ?: false;
        boolean isPhotoTypeThumbnail = photo["type"].equalsIgnoreCase(SCIM_THUMBNAIL) ?: false;
            if (!isPhotoTypePhoto && !isPhotoTypeThumbnail) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage
                + "Photo type should either be photo or thumbnail."});
                return Error;
            }
        }
    }

    json jsonPayload = convertUserToJson(user, "create");

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(jsonPayload);
    var response = self.scimClient->post(SCIM_USER_END_POINT, request);
    if (response is http:Response) {
        int statusCode = response.statusCode;
        if (statusCode == HTTP_CREATED) {
            return "User Created";
        } else if (statusCode == HTTP_UNAUTHORIZED) {
            error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + response.reasonPhrase });
            return Error;
        } else {
            var payload = response.getJsonPayload();
            if (payload is json) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + (payload.detail.toString())});
                return Error;
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the payload of the response." });
                return err;
            }
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.addUserToGroup(string userName, string groupName) returns (string|error) {
    http:Request request = new();

    string failedMessage;
    failedMessage = "Adding user:" + userName + " to group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var response = self.scimClient->get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName,
    message = requestUser);
    if (response is http:Response) {
        var receivedUser = resolveUser(userName, response);
        if (receivedUser is User) {
            user = receivedUser;
        } else {
            error err = error(SCIM2_ERROR_CODE, { message :
            "Error occured while getting the user record which associate with the given userName :" + userName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }


    //check if group valid
    http:Request requestGroup = new();
    Group gro = {};
    var resGroup = self.scimClient->get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName,
    message = requestGroup);
    if (resGroup is http:Response) {
        var receivedGroup = resolveGroup(groupName, resGroup);
        if (receivedGroup is Group) {
            gro = receivedGroup;
        } else {
            error err = error(SCIM2_ERROR_CODE
            , { message : "Error occured while adding the user record under the given groupname :" + groupName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
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
    request.setJsonPayload(untaint body);
    var res = self.scimClient->patch(untaint url, request);
    if (res is http:Response) {
        int statusCode = res.statusCode;
        if (statusCode == HTTP_OK) {
            return "User Added";
        } else if (statusCode == HTTP_UNAUTHORIZED) {
            error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + res.reasonPhrase });
            return Error;
        } else {
            var received = res.getJsonPayload();
            if (received is json) {
                error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + (received.detail.toString())});
                return Error;
            } else {
                error err = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the payload of the response." });
                return err;
            }
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.removeUserFromGroup(string userName, string groupName) returns (string|error) {

    http:Request request = new();

    string failedMessage;
    failedMessage = "Removing user:" + userName + " from group:" + groupName + " failed.";

    //check if user valid
    http:Request requestUser = new();
    User user = {};
    var response = self.scimClient->get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME +
    userName, message = requestUser);
    if (response is http:Response) {
        var receivedUser = resolveUser(userName, response);
        if (receivedUser is User) {
            user = receivedUser;
        } else {
            error err =  error(SCIM2_ERROR_CODE, { message : "Unable to get the given userName :"
            + userName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }

    //check if group valid
    Group gro = {};
    http:Request groupRequest = new();
    var resGroup = self.scimClient->get(SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME +
    groupName, message = groupRequest);
    if (resGroup is http:Response) {
        var receivedGroup = resolveGroup(groupName, resGroup);
        if (receivedGroup is Group) {
            gro = receivedGroup;
        } else {
            error err = error(SCIM2_ERROR_CODE, { message : "Unable to get the given groupname : " + groupName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
    //create request body
    json body = SCIM_GROUP_PATCH_REMOVE_BODY;
    string path = "members[display eq " + userName + "]";
    body.Operations[0].path = path;
    string url = SCIM_GROUP_END_POINT + SCIM_FILE_SEPERATOR + gro.id;

    request.addHeader(mime:CONTENT_TYPE, mime:APPLICATION_JSON);
    request.setJsonPayload(body);
    var res = self.scimClient->patch(untaint url, request);
    if (res is http:Response) {
        int statusCode = res.statusCode;
        if (statusCode == HTTP_OK) {
            return "User Removed";
        } else if (statusCode == HTTP_UNAUTHORIZED) {
            error Error = error(SCIM2_ERROR_CODE, { message: "failedMessage" + res.reasonPhrase });
            return Error;
        } else {
            var received = res.getJsonPayload();
            if (received is json) {
                error Error = error(SCIM2_ERROR_CODE, { message: "failedMessage" + (received.detail.toString())});
                return Error;
            } else {
                error e = error(SCIM2_ERROR_CODE
                , { message: "Error occurred while accessing the payload of the response." });
                return e;
            }
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.isUserInGroup(string userName, string groupName) returns boolean|error {
    http:Request request = new();
    User user = {};

    var res = self.scimClient->get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName
    , message = request);
    if (res is http:Response) {
        var receivedUser = resolveUser(userName, res);
        if (receivedUser is User) {
            user = receivedUser;
            foreach var gro in user.groups {
                if (gro.displayName.equalsIgnoreCase(groupName)) {
                    return true;
                }
            }
            return false;
        } else {
            error err =  error(SCIM2_ERROR_CODE, { message : "Unable to get the given userName :" + userName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.deleteUserByUsername(string userName) returns string|error {

    http:Request request = new();

    string failedMessage;
    failedMessage = "Deleting user:" + userName + " failed. ";

    //get user
    http:Request userRequest = new();
    User user = {};
    var resUser = self.scimClient->get(SCIM_USER_END_POINT + "?" + SCIM_FILTER_USER_BY_USERNAME + userName,
    message = userRequest);
    if (resUser is http:Response) {
        var receivedUser = resolveUser(userName, resUser);
        if (receivedUser is User) {
            user = receivedUser;
            string userId = user.id;
            var res = self.scimClient->delete(SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + untaint userId, request);
            if (res is http:Response) {
                if (res.statusCode == HTTP_NO_CONTENT) {
                    return "deleted";
                } else {
                    error Error = error(SCIM2_ERROR_CODE, { message: failedMessage + res.reasonPhrase });
                        return Error;
                    }
            } else {
                error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
                return err;
            }
        } else {
            error err =  error(SCIM2_ERROR_CODE
            , { message : "Unable to get the given userName : " + userName});
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.deleteGroupByName(string groupName) returns string|error {

    http:Request request = new();

    string failedMessage;
    failedMessage = "Deleting group:" + groupName + " failed. ";

    //get the group
    http:Request groupRequest = new();
    Group gro = {};
    string s = SCIM_GROUP_END_POINT + "?" + SCIM_FILTER_GROUP_BY_NAME + groupName;
    var resGroup = self.scimClient->get(s, message = groupRequest);
    if (resGroup is http:Response) {
        var receivedGroup = resolveGroup(groupName, resGroup);
        if (receivedGroup is Group) {
            gro = receivedGroup;
            string groupId = gro.id;
            var res = self.scimClient->delete(SCIM_GROUP_END_POINT + SCIM_FILE_SEPERATOR + untaint groupId, request);
            if (res is http:Response) {
                if (res.statusCode == HTTP_NO_CONTENT) {
                    return "deleted";
                } else {
                    error Error = error(SCIM2_ERROR_CODE, { message: failedMessage });
                    return Error;
                }
            } else {
                error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
                return err;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE,
            { message : "Unable to get the given groupname :" + groupName});
            return err;
        }

    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}

remote function Client.updateSimpleUserValue(string id, string valueType, string newValue) returns string|error {

    if (id.equalsIgnoreCase("") || newValue == "") {
        error Error = error(SCIM2_ERROR_CODE, { message: "User and new " + valueType + " should be valid" });
        return Error;
    }

    http:Request request = new();
    var bodyOrError = createUpdateBody(valueType, newValue);
    if (bodyOrError is json) {
        request = createRequest(bodyOrError);
        string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
        var res = self.scimClient->patch( untaint url, request);
        if (res is http:Response) {
            if (res.statusCode == HTTP_OK) {
                return valueType + " updated";
            } else {
                error Error = error( SCIM2_ERROR_CODE, { message: res.reasonPhrase });
                return Error;
            }
        } else {
            error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
            return err;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE , { message: "Error occurred while accessing the payload
                        of the response." });
        return err;
    }
}

remote function Client.updateEmails(string id, Email[] emails) returns string|error {

    if (id.equalsIgnoreCase("")) {
        error Error = error(SCIM2_ERROR_CODE, { message: "User should be valid" });
        return Error;
    }

    http:Request request = new();

    json[] emailList = [];
    json email;
    int i = 0;
    foreach var emailAddress in emails {
        if (!emailAddress.^"type".equalsIgnoreCase(SCIM_WORK) && !emailAddress.^"type".equalsIgnoreCase(SCIM_HOME)) {
            error Error = error(SCIM2_ERROR_CODE, { message: "Email type should be defiend as either home or work" });
            return Error;
        }
        email = convertEmailToJson(emailAddress);
        emailList[i] = email;
        i = i + 1;
    }
    json body = SCIM_PATCH_ADD_BODY;
    body.Operations[0].value = { "emails": emailList };

    request = createRequest(untaint body);

    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
    var res = self.scimClient->patch(url, request);
    if (res is http:Response) {
        if (res.statusCode == HTTP_OK) {
            return "Email updated";
        } else {
            error Error = error(SCIM2_ERROR_CODE, { message: res.reasonPhrase });
            return Error;
        }
    } else {
        error Error = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return Error;
    }
}

remote function Client.updateAddresses(string id, Address[] addresses) returns string|error {

    if (id.equalsIgnoreCase("")) {
        error Error = error(SCIM2_ERROR_CODE, { message: "User should be valid" });
        return Error;
    }

    http:Request request = new();

    json[] addressList = [];
    json element;
    int i = 0;
    foreach var address in addresses {
        if (!address.^"type".equalsIgnoreCase(SCIM_WORK) && !address.^"type".equalsIgnoreCase(SCIM_HOME)) {
            error Error = error(SCIM2_ERROR_CODE
            , { message: "Address type is required and it should either be work or home" });
            return Error;
        }
        element = convertAddressToJson(address);
        addressList[i] = element;
        i = i + 1;
    }

    json body = SCIM_PATCH_ADD_BODY;
    body.Operations[0].value = { "addresses": addressList };

    request = createRequest(untaint body);

    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + id;
    var res = self.scimClient->patch(url, request);
    if (res is http:Response) {
        if (res.statusCode == HTTP_OK) {
            return "Address updated";
        } else {
            error Error = error(SCIM2_ERROR_CODE, { message: res.reasonPhrase });
            return Error;
        }
    } else {
        error Error = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return Error;
    }

}

remote function Client.updateUser(User user) returns string|error {
    http:Request request = new();

    json body = convertUserToJson(user, "update");
    request = createRequest(body);
    string url = SCIM_USER_END_POINT + SCIM_FILE_SEPERATOR + user.id;
    var res = self.scimClient->put(url, request);
    if (res is http:Response) {
        if (res.statusCode == HTTP_OK) {
            return "User updated";
        } else {
            error Error = error(SCIM2_ERROR_CODE, { message: res.reasonPhrase });
            return Error;
        }
    } else {
        error err = error(SCIM2_ERROR_CODE, { message: "Error occurred while invoking the SCIM2 API" });
        return err;
    }
}
