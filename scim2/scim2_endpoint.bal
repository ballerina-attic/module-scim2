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


package scim2;

import ballerina/net.http;
import oauth2;

@Description {value:"Struct to define the OAuth2 configuration."}
public struct Scim2Configuration {
    oauth2:OAuth2Configuration oauthClientConfig;
}

@Description {value:"OAuth2 Endpoint struct."}
public struct Scim2Endpoint {
    oauth2:OAuth2Endpoint oauthEP;
    Scim2Configuration scim2Config;
    ScimConnector scim2Connector;
}

public function <Scim2Endpoint scimEP> init (Scim2Configuration scim2Config) {
    scimEP.oauthEP.init(scim2Config.oauthClientConfig);
    scimEP.scim2Connector.oauthEP = scimEP.oauthEP;
    scimEP.scim2Connector.baseUrl = scim2Config.oauthClientConfig.baseUrl;
}

public function <Scim2Endpoint scimEP> register(typedesc serviceType) {

}

public function <Scim2Endpoint scimEP> start() {

}

@Description { value:"Returns the connector that client code uses"}
@Return { value:"The connector that client code uses" }
public function <Scim2Endpoint scimEP> getClient() returns ScimConnector {
    return scimEP.scim2Connector;
}

@Description { value:"Stops the registered service"}
@Return { value:"Error occured during registration" }
public function <Scim2Endpoint scimEP> stop() {

}