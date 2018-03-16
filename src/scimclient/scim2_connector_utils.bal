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

package src.scimclient;

import ballerina.net.http;
import ballerina.config;


@Description {value:"Get the http:Option with the trust store file location to provide the http connector
 with the public certificate for ssl"}
function getConnectionConfigs () (http:Options) {
    string password = config:getGlobalValue("trustStorePassword");
    string location = config:getGlobalValue("truststoreLocation");
    http:Options option = {
                              ssl:{
                                      trustStoreFile:location,
                                      trustStorePassword:password
                                  },
                              followRedirects:{}

                          };
    return option;
}

@Description {value:"Obtain User from the received http response"}
@Param {value:"userName: User name of the user"}
@Param {value:"response: The received http response"}
@Param {value:"connectorError: Received httpConnectorError object"}
@Param {value:"User: User struct"}
@Param {value:"error: Error"}
function resolveUser (string userName, http:InResponse response, http:HttpConnectorError connectorError) (User, error) {
    User user;
    error Error;

    string failedMessage;
    failedMessage = "Resolving user:" + userName + " failed. ";

    if (connectorError != null) {
        Error = {message:failedMessage + connectorError.message, cause:connectorError.cause};
        return null, Error;
    }
    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        try {
            var receivedBinaryPayload, _ = response.getBinaryPayload();
            string receivedPayload = receivedBinaryPayload.toString("UTF-8");
            var payload, _ = <json>receivedPayload;
            user = <User, convertReceivedPayloadToUser()>payload;
            if (user == null) {
                Error = {message:failedMessage + "No User named " + userName, cause:null};
                return user, Error;
            } else {
                return user, Error;
            }
        } catch (error e) {
            Error = {message:failedMessage + e.message, cause:e.cause};
            return user, Error;
        }
    }
    Error = {message:failedMessage + response.reasonPhrase};
    return user, Error;
}

@Description {value:"Obtain Group from the received http response"}
@Param {value:"groupName: Name of the group"}
@Param {value:"response: The received http response"}
@Param {value:"connectorError: Received httpConnectorError object"}
@Param {value:"User: Group struct"}
@Param {value:"error: Error"}
function resolveGroup (string groupName, http:InResponse response, http:HttpConnectorError connectorE) (Group, error) {
    Group receivedGroup;
    error Error;

    string failedMessage;
    failedMessage = "Resolving group:" + groupName + " failed. ";

    if (connectorE != null) {
        Error = {message:failedMessage + connectorE.message, cause:connectorE.cause};
        return null, Error;
    }
    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        try {
            var receivedBinaryPayload, _ = response.getBinaryPayload();
            string receivedPayload = receivedBinaryPayload.toString("UTF-8");
            var payload, _ = <json>receivedPayload;
            receivedGroup = <Group, convertReceivedPayloadToGroup()>payload;
            if (receivedGroup == null) {
                Error = {message:failedMessage + "No Group named " + groupName, cause:null};
                return receivedGroup, Error;
            } else {
                return receivedGroup, Error;
            }
        } catch (error e) {
            Error = {message:failedMessage + e.message, cause:e.cause};
            return null, Error;
        }
    }
    Error = {message:failedMessage + response.reasonPhrase};
    return receivedGroup, Error;
}

@Description {value:"Add the necessary headers and body to the request"}
@Param {value:"body: the json payload to be sent"}
@Param {value:"OutRequest: http:OutRequest"}
function createRequest (json body) (http:OutRequest) {
    http:OutRequest request = {};
    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
    request.setJsonPayload(body);
    return request;
}
