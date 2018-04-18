# Ballerina SCIM Endpoint

*The system for Cross-domain Identity Management (SCIM) specification
 is designed to make managing user identities in cloud-based applications 
 and services easier.*

### Why do you need SCIM

The SCIM protocol is an application-level HTTP-based protocol for provisioning and managing 
identity data on the web and in cross-domain environments such as enterprise-to-cloud 
service providers or inter-cloud scenarios.  The protocol provides RESTful APIs for easier
creation, modification, retrieval, and discovery of core identity resources such as Users
and Groups, as well as custom resources and resource extensions. 

### Why would you use a Ballerina Endpoint for SCIM

Ballerina makes integration with data sources, services, or network-connect APIs much easier than
ever before. Ballerina can be used to easily integrate the SCIM REST API with other endpoints.
The SCIM connector enables you to access the SCIM REST API through Ballerina. The actions of the
SCIM Endpoint are invoked using a Ballerina main function. 

WSO2 Identity Server uses SCIM for identity provisioning and therefore you can deploay the wso2 
Identity Server and use it to run the samples. 


The following sections provide you with information on how to use the Ballerina SCIM connector.

## Compatibility
| Language Version        | Endpoint Version          | API Versions  |
| ------------- |:-------------:| -----:|
| ballerina-0.970.0-beta1-SNAPSHOT     | 0.9.6 | SCIM2.0 |


## Contribute To Develop

Clone the repository by running the following command

`git clone http://github.com/wso2-ballerina/package-scim2`

## Working with SCIM Endpoint actions

In order for you to use the SCIM Endpoint, first you need to create a SCIM2 Client 
endpoint.

```ballerina
import wso2/scim2;

endpoint scim2:Client scimEP {
    baseUrl:"https://localhost:9443",
    clientConfig:{
        auth:{
            scheme:"oauth",
            accessToken:"<......>",
            clientId:"<......>",
            clientSecret:"<......>",
            refreshToken:"<......>",
            refreshUrl:"<......>"
        },
        targets:[{url:"https://localhost:9443",
            secureSocket:{
                trustStore:{
                    filePath:"<......>",
                    password:"<......>"
                }
            }
        }]
    }
};
```
Then use the following syntax to call endpoint functions

```ballerina
var response = scimEP -> <name_of_the_function>(arg...);
```