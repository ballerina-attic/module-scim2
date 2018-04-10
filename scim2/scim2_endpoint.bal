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

import ballerina/http;
import wso2/oauth2;

documentation {SCIM2 Client Endpoint configuration object
    F{{oauthClientConfig}} OAuth2 client endpoint configuration object
}
public type Scim2Configuration {
    oauth2:OAuth2ClientEndpointConfiguration oauthClientConfig;
};

documentation {SCIM2 Client Endpoint
    F{{oauthEP}} OAuth2 client endpoint
    F{{scim2Config}} SCIM2 client endpoint configuration object
    F{{scim2Connector}} SCIM2 connector object
}
public type Client object {
    public {
        oauth2:Client oauthEP;
        Scim2Configuration scim2Config;
        ScimConnector scim2Connector;
    }

    documentation {Initialize the SCiM2 endpoint
        P{{scim2Config}} SCIM2 configuration object
    }
    public function init (Scim2Configuration scim2Config);

    documentation {Register SCIM2 client endpoint}
    public function register (typedesc serviceType);

    documentation {Start the registered service}
    public function start ();

    documentation {Returns the connector that client code uses}
    public function getClient () returns ScimConnector;

    documentation {Stops the registered service}
    public function stop ();
};

public function Client::init (Scim2Configuration scim2Config) {
    oauthEP.init(scim2Config.oauthClientConfig);
    scim2Connector.oauthEP = oauthEP;
    scim2Connector.baseUrl = scim2Config.oauthClientConfig.baseUrl;
}

public function Client::register (typedesc serviceType) {

}

public function Client::start () {

}

public function Client::getClient () returns ScimConnector {
    return scim2Connector;
}

public function Client::stop () {

}