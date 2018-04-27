# Ballerina SCIM Connector - Tests

 Connects to SCIM2 API from Ballerina.
 
 SCIM2 Connector provides an optimized way to use SCIM2 REST API from your Ballerina programs.
 It provides user management by allowing to create, delete, read, update users and groups, and manage 
 user's groups. It handles OAuth 2.0 and provides auto completion and type conversions.

The following sections provide you with information on how to use the Ballerina SCIM Endpoint.

 
 ## Compatibility
 | Ballerina Language Version | SCIM API Version                                          |
 | :-------------------------:| :--------------------------------------------------------:|
 | 0.970.0                    | [SCIM2.0](https://tools.ietf.org/html/rfc7643#section-8.3)|

The source code of the SCIM2 endpoint can be found at [package-scim2](https://github.com/wso2-ballerina/package-scim2)

#### Prerequisites for tests
To test this connector with WSO2 Identity Server you need to have the following resources.

1. Download and deploy the wso2 Identity Server by following the installation guide 
which can be found at 
https://docs.wso2.com/display/IS540/Installation+Guide/.
2. Follow the steps given in https://docs.wso2.com/display/ISCONNECTORS/Configuring+SCIM+2.0+Provisioning+Connector
to enable the SCIM2 connector with WSO2 Identity Server. 
3. Identify the URL for SCIM2. (By default it should be `https://localhost:9443/scim2/`)
4. Create the truststore.p12 file using the client-truststore.jks file which is located at `IS_HOME/repository/resources/security`. Follow
 https://www.tbs-certificates.co.uk/FAQ/en/627.html
 document to create the truststore.p12 file.
5. [Obtain OAuth2 Tokens](#obtain-oauth2-tokens)
6. Note that the refresh endpoint is 
https://localhost:9443/oauth2/token

#### Obtain OAuth2 Tokens
1. Log into the Identity server admin portal.
2. Create a new service provider
    - Give a name and then register
3. Click on Inbound Authentication Configuration.
4. Configure OAuth/OpenId connect configuration by giving a call back url.
5. The Client ID and Client Secret would be given to you.
6. You can obtain the access_token and the refresh_token through terminal by using the curl
command 
`curl -X POST --basic -u <client_id>:<client_secret> -H 'Content-Type: application/x-www-form-urlencoded;
charset=UTF-8' -k -d 'grant_type=password&username=admin&password=admin' https://localhost:9443/oauth2/token
` 
## Running Tests

1. Initialize a ballerina project 

    `ballerina init`

2. Create a ballerina config file (`.conf`) with following details.
    ```
    ###HTTP:Client configurations###
    ENDPOINT = "<......>"
    ACCESS_TOKEN = "<......>"
    CLIENT_ID = "<......>"
    CLIENT_SECRET = "<......>"
    REFRESH_TOKEN = "<......>"
    REFRESH_URL = "<......>"
    
    ###Keystore configurations###
    KEYSTORE = "<......>"
    KEYSTORE_PASSWORD = "<......>"
    ``` 

3. Test the SCIM2 endpoint functions by executing the command 
    `ballerina test scim2 --config <path_of_.conf>/<file_name>.conf`.
