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

# SCIM2 Client object.
#
# + scim2Connector - scim2Connector Connector object
public type Client client object {

    public ScimConnector scim2Connector;

    public function __init(Scim2Configuration scim2Config) {
        //self.init(scim2Config);
        self.scim2Connector = new(scim2Config.baseUrl, scim2Config);
    }

    # Returns a list of user records if found or error if any error occured.
    # + return - If success, returns list of User objects, else returns error
    remote function getListOfUsers() returns (User[]|error) {
        return self.scim2Connector->getListOfUsers();
    }

    # Returns a list of group records if found or error if any error occured.
    # + return - If success, returns list of Group objects, else returns error
    remote function getListOfGroups() returns (Group[]|error) {
        return self.scim2Connector->getListOfGroups();
    }

    # Returns the user that is currently authenticated.
    # + return - If success, returns User object, else returns error
    remote function getMe() returns (User|error) {
        return self.scim2Connector->getMe();
    }

    # Returns a group record with the specified group name if found.
    # + groupName - Name of the group
    # + return - If success, returns Group object, else returns error
    remote function getGroupByName(string groupName) returns (Group|error) {
        return self.scim2Connector->getGroupByName(groupName);
    }

    # Returns a user record with the specified username if found.
    # + userName - User name of the user
    # + return - If success, returns User object, else returns error
    remote function getUserByUsername(string userName) returns (User|error) {
        return self.scim2Connector->getUserByUsername(userName);
    }

    # Create a group in the user store.
    # + crtGroup - Group record with the group details
    # + return - If success, returns string message with status, else returns error
    remote function createGroup(Group crtGroup) returns (string|error) {
        return self.scim2Connector->createGroup(crtGroup);
    }

    # Create a user in the user store.
    # + user - User record with the user details
    # + return - If success, returns string message with status, else returns error
    remote function createUser(User user) returns (string|error) {
        return self.scim2Connector->createUser(user);
    }

    # Add a user specified by username to the group specified by group name.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns string message with status, else returns error
    remote function addUserToGroup(string userName, string groupName) returns (string|error) {
        return self.scim2Connector->addUserToGroup(userName, groupName);
    }

    # Remove a user specified by username from the group specified by group name.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns string message with status, else returns error
    remote function removeUserFromGroup(string userName, string groupName) returns (string|error) {
        return self.scim2Connector->removeUserFromGroup(userName, groupName);
    }

    # Returns whether the user specified by username belongs to the group specified by groupname.
    # + userName - User name of the user
    # + groupName - Name of the group
    # + return - If success, returns boolean value, else returns error
    remote function isUserInGroup(string userName, string groupName) returns (boolean|error) {
        return self.scim2Connector->isUserInGroup(userName, groupName);
    }

    # Delete a user from user store.
    # + userName - User name of the user
    # + return - If success, returns string message with status, else returns error
    remote function deleteUserByUsername(string userName) returns (string|error) {
        return self.scim2Connector->deleteUserByUsername(userName);
    }

    # Delete a group from user store.
    # + groupName - User name of the user
    # + return - String message with status
    remote function deleteGroupByName(string groupName) returns (string|error){
        return self.scim2Connector->deleteGroupByName(groupName);
    }

    # Update a simple attribute of user.
    # + id - ID of the user
    # + valueType - The attribute name to be updated
    # + newValue - The new value of the attribute
    # + return - If success, returns string message with status, else returns error
    remote function updateSimpleUserValue(string id, string valueType, string newValue) returns
    (string|error) {
        return self.scim2Connector->updateSimpleUserValue(id, valueType, newValue);
    }

    # Update emails addresses of a user.
    # + id - ID of the user
    # + emails - List of new emails of the user
    # + return - If success, returns string message with status, else returns error
    remote function updateEmails(string id, Email[] emails) returns (string|error) {
        return self.scim2Connector->updateEmails(id, emails);
    }

    # Update addresses of a user.
    # + id - ID of the user
    # + addresses - List of new addresses of the user
    # + return - If success, returns string message with status, else returns error
    remote function updateAddresses(string id, Address[] addresses) returns (string|error) {
        return self.scim2Connector->updateAddresses(id, addresses);
    }

    # Update a user.
    # + user - User record with new user values
    # + return - If success, returns string message with status, else returns error
    remote function updateUser(User user) returns (string|error) {
        return self.scim2Connector->updateUser(user);
    }
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
