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

![alt text](../SCIM2.png)

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
                          refreshTokenEP:"h",
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
## createUser

Create a user in the user store.

#### Parameters

 1. `User` - User struct with the details of the user

#### Returns

- `error` - error struct with the status message.

#### Example

```ballerina
        scimclient:User user = {};
    
        scimclient:PhonePhotoIms phone = {};
        phone.^"type" = "work";
        phone.value = "0777777777";
        user.phoneNumbers = [phone];
    
        scimclient:Name name = {};
        name.givenName = "Leo";
        name.familyName = "Messi";
        name.formatted = "Lionel Messi";
        user.name = name;
    
        scimclient:Address address = {};
        address.postalCode = "23433";
        address.streetAddress = "no/2";
        address.region = "Catalunia";
        address.locality = "Barcelona";
        address.country = "Spain";
        address.formatted = "no/2,Barcelona/Catalunia/Spain";
        address.primary = "true";
        address.^"type" = "work";
    
        user.addresses = [address];
    
        user.userName = "leoMessi";
        user.password = "greatest";
    
        scimclient:Email email1 = {};
        email1.value = "messi@barca.com";
        email1.^"type" = "work";
    
        scimclient:Email email2 = {};
        email2.value = "messi@gg.com";
        email2.^"type" = "home";
    
        user.emails = [email1, email2];
        var response1 = scimCon.createUser(user);
        match response1 {
            string message => io:println(message);
            error er => io:println(er);
        }

```

`creating user leoMessi
 {message:"Created", cause:null}
`

## createGroup

Create a group in the user store.

#### Parameters

 1. `Group` - group struct with the group details

#### Returns

- `error` struct with the status message.

#### Example

```ballerina
scimclient:Group gro = {};
    gro.displayName = "Captain";

    var response = scimCon.createGroup(gro);
    match response {
        string msg => io:println(msg);
        error er => io:println(er);
    }
```

if successfull `{message:"Created", cause:null}`

## getUser 

Get an user from the user store using the userName.

#### Parameters
 1. `string` - userName

#### Returns
- `User` struct with the resolved user
- `error` struct with the status message. Null if valid user found.

#### Example


````ballerina
        string userName = "iniesta";
        var response = scimCon.getUserByUsername(userName);
        match response {
            scimclient:User usr => {
                io:println(usr);
            }
            error er => io:println(er);
        }         
`````

## getGroup

Get a group from the user store using groupName.

#### Parameters
 1. `string` - groupName

#### Returns
- `Group` struct with the resolved group
- `error` struct with the status message. Null if valid group found.

#### Example

````ballerina
    string groupName = "Captain";
    var response = scimCon.getGroupByName(groupName);
    match response {
        scimclient:Group grp => io:println(grp.members);
        error er => io:println(er);
    }
   
````

## addUserToGroup

Add a user specified by user name to a group specified by group name. 

#### Parameters
 1. `string` - userName
 2. `string` - groupName
 
#### Returns
- `error` struct with status message.

#### Example

````ballerina
        var response = scimCon.addUserToGroup(userName, groupName);
        match response {
            string msg => io:println(msg);
            error er => io:println(er);
        }
````
 
## removeUserFromGroup

Remove an user specifed by user name from a group specified by group name.

#### Parameters
 1. `string` - userName
 2. `string` - groupName
 
#### Returns
- `error` struct with status message.

#### Example

````ballerina
    var response = scimCon.removeUserFromGroup(userName, groupName);
    match response {
        string msg => io:println(msg);
        error er => io:println(er);
    }
````

## isUserInGroup

Check whether the specified user is in the specified group.

#### Parameters
 1. `string` - userName
 2. `string` - groupName
 
#### Returns
- `boolean` value indicating whether the user is in the group or not.
- `error` struct with the status message.

#### Example

````ballerina
        var response = scimCon.isUserInGroup(userName, groupName);
        match response {
            boolean x => io:println(x);
            error er => io:println(er);
        }
````

## deleteUserByUserName

Delete an user in the user store using his user name.

#### Parameters
 1. `string` - userName
 
#### Returns
- `error` struct with the status message.

#### Example

````ballerina
        var response = scimCon.deleteUserByUsername(userName);
        match response {
            string msg => io:println(msg);
            error er => io:println(er);
        }
````

## deleteGroupByName

Delete an group using its group name

#### Parameters
 1. `string` - groupName
 
#### Returns
- `error` struct with the status message.

#### Examples

````ballerina
    var response = scimCon.deleteGroupByName(groupName);
    match response {
        string msg => io:println(msg);
        error er => io:println(er);
    }
````

## getListOfUsers

Get the list of users in the user store.

#### Returns
- `User[]` struct list
- `error` struct with status message

#### Examples

````ballerina
    var response = scimCon.getListOfUsers();
    match response {
        scimclient:User[] lst => io:println(lst);
        error er => io:println(er);
    }
````

## getListOfGroups

Get the list of groups.

#### Returns
- `Group[]` struct list
- `error` struct with status message

#### Examples

````ballerina
        var response = scimCon.getListOfGroups();
        match response {
            scimclient:Group[] lst => io:println(lst);
            error er => io:println(er);
        }
````

## getMe

Get the currently authenticated user.

#### Returns
- `User` struct with the response.
- `error` struct with status message.

#### Example

````ballerina
    var response = scimCon.getMe();
    match response {
        scimclient:User usr => io:println(usr);
        error er => io:println(er);
    }
````