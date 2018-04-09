# Ballerina SCIM Connector

*The system for Cross-domain Identity Management (SCIM) specification
 is designed to make managing user identities in cloud-based applications 
 and services easier.*
 
 The Ballerina SCIM2 connector allows users to access Rest API of any service that implements 
 SCIM2 specification.  
 
 
 ## Compatibility
 | Language Version        | Connector Version          | API Versions  |
 | ------------- |:-------------:| -----:|
 | ballerina-0.970.0-alpha1-SNAPSHOT     | 0.9 | SCIM2.0 |
 
 
 ![alt_text](../SCIM2.png)
 
 
## Getting started

1. Clone and build Ballerina from the source by following the steps given in the README.md 
file at
 https://github.com/ballerina-lang/ballerina
2. Extract the Ballerina distribution created at
 `distribution/zip/ballerina/target/ballerina-<version>-SNAPSHOT.zip` and set the 
 PATH environment variable to the bin directory.
 
 
## Working with SCIM connector actions

In order for you to use the SCIM connector, first you need to create a SCIM2 client 
endpoint. 

```ballerina
endpoint scim2:Client scimEP {
    oauthClientConfig:{
                          accessToken:"",
                          baseUrl:"",
                          clientId:"",
                          clientSecret:"",
                          refreshToken:"",
                          refreshTokenEP:"",
                          refreshTokenPath:"",
                          setCredentialsInHeader:true
                      }
};
```