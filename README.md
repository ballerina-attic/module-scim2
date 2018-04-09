# Ballerina SCIM Connector

*The system for Cross-domain Identity Management (SCIM) specification
 is designed to make managing user identities in cloud-based applications 
 and services easier.*

### Why do you need SCIM

The SCIM protocol is an application-level HTTP-based protocol for provisioning and managing 
identity data on the web and in cross-domain environments such as enterprise-to-cloud 
service providers or inter-cloud scenarios.  The protocol provides RESTful APIs for easier
creation, modification, retrieval, and discovery of core identity resources such as Users
and Groups, as well as custom resources and resource extensions. 

### Why would you use a Ballerina connector for SCIM

Ballerina makes integration with data sources, services, or network-connect APIs much easier than
ever before. Ballerina can be used to easily integrate the SCIM REST API with other endpoints.
The SCIM connector enables you to access the SCIM REST API through Ballerina. The actions of the
SCIM connector are invoked using a Ballerina main function. 

WSO2 Identity Server uses SCIM for identity provisioning and therefore you can deploay the wso2 
Identity Server and use it to run the samples. 

![alt_text](../SCIM2.png)

The following sections provide you with information on how to use the Ballerina SCIM connector.

## Compatibility
| Language Version        | Connector Version          | API Versions  |
| ------------- |:-------------:| -----:|
| ballerina-0.970-alpha-1-SNAPSHOT     | 0.2 | SCIM2.0 |

- [Getting started](#getting-started)
- [Running Samples](#running-samples)
- [Working with SCIM connector actions](#working-with-SCIM-connector-actions)

## Getting started

1. Clone and build Ballerina from the source by following the steps given in the README.md 
file at
 https://github.com/ballerina-lang/ballerina
2. Extract the Ballerina distribution created at
 `distribution/zip/ballerina/target/ballerina-<version>-SNAPSHOT.zip` and set the 
 PATH environment variable to the bin directory.

#### Prerequisites
To test this connector with WSO2 Identity Server you need to have the following resources.

1. Download and deploy the wso2 Identity Server by following the installation guide 
which can be found at 
https://docs.wso2.com/display/IS540/Installation+Guide/.
2. Follow the steps given in https://docs.wso2.com/display/ISCONNECTORS/Configuring+SCIM+2.0+Provisioning+Connector
to enable the SCIM2 connector with WSO2 Identity Server. 
3. Identify the URL for SCIM2. (By default it should be `https://localhost:9443/scim2/`)
4. Create the truststore.p12 file using the client-truststore.jks file which is located at
`/home/tharindu/Documents/IS_HOME/repository/resources/security`. Follow 
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
2. You can obtain the access_token and the refresh_token through terminal by using the curl
command 
`curl -X POST --basic -u <client_id>:<client_secret> -H 'Content-Type: application/x-www-form-urlencoded;
charset=UTF-8' -k -d 'grant_type=password&username=admin&password=admin' https://localhost:9443/oauth2/token
` 
## Running Samples

You can easily test the SCIM2 connector endpoint functions by executing the command 
`ballerina test tests`.

## Working with SCIM connector actions

In order for you to use the SCIM connector, first you need to create a ScimConnector 
endpoint.

```ballerina
endpoint scim2:Scim2Endpoint scimEP {
    oauthClientConfig:{
                          accessToken:"",
                          baseUrl:"",
                          clientId:"",
                          clientSecret:"",
                          refreshToken:"",
                          refreshTokenEP:"",
                          refreshTokenPath:"",
                          useUriParams:false,
                          clientConfig:{targets:[{uri:"",
                                                     secureSocket:{
                                                                      trustStore:{
                                                                                     filePath:"",
                                                                                     password:""
                                                                                 }
                                                                  }
                                                 }
                                                ]}
                      }
};
```