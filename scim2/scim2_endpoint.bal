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

documentation {SCIM2 Client Endpoint configuration object
    F{{clientConfig}} HTTP client endpoint configuration object
}
public type Scim2Configuration {
    string baseUrl;
    http:ClientEndpointConfig clientConfig;
};

documentation {SCIM2 Client Endpoint
    F{{scim2Config}} SCIM2 client endpoint configuration object
    F{{scim2Connector}} SCIM2 connector object
}
public type Client object {
    public {
        Scim2Configuration scim2Config = {};
        ScimConnector scim2Connector = new;
    }

    documentation {Initialize the SCiM2 endpoint
        P{{scim2Config}} SCIM2 configuration object
    }
    public function init (Scim2Configuration scim2Config);

    documentation {Returns the connector that client code uses}
    public function getClient () returns ScimConnector;
};

public function Client::init (Scim2Configuration scim2Config) {
    self.scim2Connector.baseUrl = scim2Config.baseUrl;
    self.scim2Connector.httpClient.init(scim2Config.clientConfig);
}

public function Client::getClient () returns ScimConnector {
    return self.scim2Connector;
}
