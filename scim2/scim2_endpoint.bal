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
import wso2/oauth2;

@Description {value:"SCIM2 connector configuration should be setup when initializing the endpoint. The User needs to
provide the necessary OAuth2 credentials."}
public type Scim2Configuration {
    oauth2:OAuth2ClientEndpointConfiguration oauthClientConfig;
};

@Description {value:"SCIM2 client endpoint object"}
@Field {value:"oauthEP: OAuth2 client endpoint"}
@Field {value:"scim2Config: SCIM2 Configuration record"}
@Field {value:"scim2Connector: SCIM2 connector object"}
public type SCIM2Client object {
    public {
        oauth2:OAuth2Client oauthEP;
        Scim2Configuration scim2Config;
        ScimConnector scim2Connector;
    }

    public function init (Scim2Configuration scim2Config);
    public function register (typedesc serviceType);
    public function start ();
    public function getClient () returns ScimConnector;
    public function stop ();
};

@Description {value: "SCIM2 client endpoint initialization function"}
@Param {value: "scim2Config: SCIM2 connector configuration"}
public function SCIM2Client::init (Scim2Configuration scim2Config) {
    oauthEP.init(scim2Config.oauthClientConfig);
    scim2Connector.oauthEP = oauthEP;
    scim2Connector.baseUrl = scim2Config.oauthClientConfig.baseUrl;
}

@Description {value: "Register SCIM2 client endpoint"}
public function SCIM2Client::register (typedesc serviceType) {

}

public function SCIM2Client::start () {

}

@Description {value:"Returns the connector that client code uses"}
@Return {value:"The connector that client code uses"}
public function SCIM2Client::getClient () returns ScimConnector {
    return scim2Connector;
}

@Description {value:"Stops the registered service"}
@Return {value:"Error occured during registration"}
public function SCIM2Client::stop () {

}