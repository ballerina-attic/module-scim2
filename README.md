[![Build Status](https://travis-ci.org/wso2-ballerina/module-scim2.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-scim2)

# SCIM2 Connector
 
Connects to SCIM2 API from Ballerina.
 
SCIM2 Connector provides an optimized way to use SCIM2 REST API from your Ballerina programs.
It provides user management by allowing to create, delete, read, update users and groups, and manage
user's groups. It handles OAuth 2.0 and provides auto completion and type conversions.

## Compatibility
| Ballerina Language Version| SCIM API Version                                          |
| :------------------------:| :--------------------------------------------------------:|
| 1.0.0                     | [SCIM2.0](https://tools.ietf.org/html/rfc7643#section-8.3)|

![Ballerina SCIM2 Endpoint Overview](./docs/resources/SCIM2.png)

## Getting Started
 1. Refer https://ballerina.io/learn/getting-started/ to download Ballerina and install tools.
 2. To use SCIM2 endpoint, you need to provide the following:
     - Client Id
     - Client Secret
     - Access Token
     - Refresh Token
     - Refresh Url

    *Please note that, providing ClientId, Client Secret, Refresh Token are optional if you are only providing a valid
     Access Token vise versa.*

 3. Create a new Ballerina project by executing the following command.

       `<PROJECT_ROOT_DIRECTORY>$ ballerina init`

 4. Import the scim2 module to your Ballerina program as follows.

```ballerina
import wso2/scim2;
import ballerina/config;
import ballerina/io;

// Create a scim2 confuguration
scim2:Scim2Configuration scim2Config = {
    baseUrl: "BASE_URL,
    clientConfig: {

        accessToken: "ACCESS_TOKEN",
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshToken: config:getAsString("REFRESH_TOKEN"),
            refreshUrl: config:getAsString("REFRESH_URL")
        }
    },
    secureSocketConfig: {
        trustStore: {
            path: "KEY_STORE_PATH",
            password: "KEY_STORE_PATH"
        }
    }

};

// Defining a new client
scim2:Client scimEP = new (scim2Config);


public function main() {

    scim2:User user1 = {};
    //create user Peter
    user1.userName = "Peter";
    user1.password = "peter123";
    var response = scimEP->createUser(user1);

    if (response is string) {
        io:println(<string>response.toString());
    } else {
        io:println("Error");
    }
}

```
