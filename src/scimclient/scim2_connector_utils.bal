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

@Description {value:"Obtain User from the received http response"}
@Param {value:"userName: User name of the user"}
@Param {value:"response: The received http response"}
@Param {value:"connectorError: Received httpConnectorError object"}
@Param {value:"User: User struct"}
@Param {value:"error: Error"}
function resolveUser (string userName, http:Response response) returns User|error {
    User user = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving user:" + userName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var receivedBinaryPayload = response.getBinaryPayload();
        match receivedBinaryPayload {
            blob b => {
                string receivedPayload = b.toString("UTF-8");
                var payload, conversionEr = <json>receivedPayload;
                if (conversionEr == null){
                    match payload {
                        json j => {
                            user = <User, convertReceivedPayloadToUser()>payload;
                            if (user.id.equalsIgnoreCase("")) {
                                Error = {message:failedMessage + "No User with user name " + userName};
                                return Error;
                            } else {
                                return user;
                            }
                        }
                    } 
                } else {
                    Error = {message:failedMessage + "Authentication failed", cause:conversionEr.cause};
                    return Error;
                }
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

@Description {value:"Obtain Group from the received http response"}
@Param {value:"groupName: Name of the group"}
@Param {value:"response: The received http response"}
@Param {value:"connectorError: Received httpConnectorError object"}
@Param {value:"User: Group struct"}
@Param {value:"error: Error"}
function resolveGroup (string groupName, http:Response response) returns Group|error {
    Group receivedGroup = {};
    error Error = {};

    string failedMessage;
    failedMessage = "Resolving group:" + groupName + " failed. ";

    int statusCode = response.statusCode;
    if (statusCode == HTTP_OK) {
        var receivedBinaryPayload = response.getBinaryPayload();
        match receivedBinaryPayload {
            blob b => {
                string receivedPayload = b.toString("UTF-8");
                var payload, conversionEr = <json>receivedPayload;
                if (conversionEr == null){
                    match payload {
                        json j => {
                            receivedGroup = <Group, convertReceivedPayloadToGroup()>payload;
                            if (receivedGroup.id.equalsIgnoreCase("")) {
                                Error = {message:failedMessage + "No Group named " + groupName};
                                return Error;
                            } else {
                                return receivedGroup;
                            }
                        }
                    } 
                } else {
                    Error = {message:failedMessage + "Authentication failed", cause:conversionEr.cause};
                    return Error;
                }
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

//@Description {value:"Add the necessary headers and body to the request"}
//@Param {value:"body: the json payload to be sent"}
//@Param {value:"OutRequest: http:OutRequest"}
//function createRequest (json body) (http:Request) {
//    http:Request request = {};
//    request.addHeader(SCIM_CONTENT_TYPE, SCIM_JSON);
//    request.setJsonPayload(body);
//    return request;
//}
