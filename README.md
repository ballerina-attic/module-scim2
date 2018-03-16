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

The following sections provide you with information on how to use the Ballerina SCIM connector.

## Compatibility
| Language Version        | Connector Version          | API Versions  |
| ------------- |:-------------:| -----:|
| ballerina-0.963.1-SNAPSHOT     | 0.1 | SCIM2.0 |

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
3. Create a server-config-file-name.conf file with truststore.p12 file location and password
in the following format.

| Credential       | Description | 
| ------------- |:----------------:|
| truststoreLocation    |Your truststore.p12 file location|
| trustStorePassword  |password of the truststore   |

4. Obtain the base URL, client_id, client_secret, access_token, refresh_token, refresh_token_endpoint
and the refresh_token path related to your Server.


##### Prerequisites
To test this connector with WSO2 Identity Server you need to have the following resources.

1. Download and deploy the wso2 Identity Server by following the installation guide 
which can be found at 
https://docs.wso2.com/display/IS540/Installation+Guide/.
2. Follow the steps given in https://docs.wso2.com/display/ISCONNECTORS/Configuring+SCIM+2.0+Provisioning+Connector
to deploy the SCIM2 connector with WSO2 Identity Server. 
3. Identify the URL for the SCIM2 connector. 
(By default it should be `https://localhost:9443/scim2/`)
4. Create the truststore.p12 file using the client-truststore.jks file which is located at
`/home/tharindu/Documents/IS_HOME/repository/resources/security`. Follow 
 https://www.tbs-certificates.co.uk/FAQ/en/627.html
 document to create the truststore.p12 file.
5. Log into the Identity server and add a new service provider and obtain the client_id and 
client_secret.
6. You can obtain the access_token and the refresh_token through terminal by using the curl
command 
`curl -X POST --basic -u <client_id>:<client_secret> -H 'Content-Type: application/x-www-form-urlencoded;
charset=UTF-8' -k -d 'grant_type=password&username=admin&password=admin' https://localhost:9443/oauth2/token
` 
7. Note that the refresh endpoint is 
https://localhost:9443/oauth2/token

## Running Samples

You can easily test the SCIM2 connector actions by running the `sample.bal` file.
 - Run `ballerina run /samples/scimclient Bballerina.conf=path/to/conf/file/server-config-file-name.conf`

## Working with SCIM connector actions

In order for you to use the SCIM connector, first you need to create a ScimConnector 
endpoint and then initialize it.

```ballerina
endpoint<scimclient:ScimConnector> userAdminConnector {
        create scimclient:ScimConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken,
                                               refreshTokenEndpoint, refreshTokenPath);
}
userAdminConnector.iniit();
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
    phone.|type| = "work";
    phone.value = "0777777777";
    user.phoneNumbers = [phone];

    scimclient:Name name = {};
    name.givenName = "Leo";
    name.familyName = "Messi";
    name.formatted = "Lionel Messi";
    user.name = name;

    user.addresses = [address];

    user.userName = "leoMessi";
    user.password = "greatest";

    scimclient:Email email1 = {};
    email1.value = "messi@barca.com";
    email1.|type| = "work";

    scimclient:Email email2 = {};
    email2.value = "messi@gg.com";
    email2.|type| = "home";

    user.emails = [email1, email2];

    error Error;
    Error = userAdminConnector.createUser(user);
    io:println("creating user " + user.userName);
    io:println(Error);
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
    scimclient:Group group = {};
    group.displayName = "Captain";
    Error = userAdminConnector.createGroup(group);
    io:println(Error);
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
    error Error;
    scimclient:User getUser = {};
    string userName = "iniesta";
    getUser, Error = userAdminConnector.getUserByUsername(userName);
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
    error Error;
    scimclient:Group getGroup = {};
    getGroup, Error = userAdminConnector.getGroupByName("Captain");
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
    userName = "leoMessi";
    string groupName = "Captain";
    Error = userAdminConnector.addUserToGroup(userName, groupName);
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
    userName = "iniesta";
    groupName = "Captain";

    Error = userAdminConnector.removeUserFromGroup(userName, groupName);
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
    userName = "leoMessi";
    groupName = "Captain";
    boolean x;
    x, Error = userAdminConnector.isUserInGroup(userName, groupName);
````

## deleteUserByUserName

Delete an user in the user store using his user name.

#### Parameters
 1. `string` - userName
 
#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    userName = "leoMessi";
    Error = userAdminConnector.deleteUserByUsername(userName);
````

## deleteGroupByName

Delete an group using its group name

#### Parameters
 1. `string` - groupName
 
#### Returns
- `error` struct with the status message.

#### Examples

````ballerina
    groupName = "Captain";
    Error = userAdminConnector.deleteGroupByName(groupName);
````

## getListOfUsers

Get the list of users in the user store.

#### Returns
- `User[]` struct list
- `error` struct with status message

#### Examples

````ballerina
    scimclient:User[] userList;
    userList, Error = userAdminConnector.getListOfUsers();
````

## getListOfGroups

Get the list of groups.

#### Returns
- `Group[]` struct list
- `error` struct with status message

#### Examples

````ballerina
    scimclient:Group[] groupList;
    groupList, Error = userAdminConnector.getListOfGroups();
````

## getMe

Get the currently authenticated user.

#### Returns
- `User` struct with the response.
- `error` struct with status message.

#### Example

````ballerina
user,Error = userAdminConnector.getMe();
````

## Using User struct bound functions

First get a user using connector action `getUserByUsername`.

```ballerina
    userName = "tnm";
    user , Error = userAdminConnector.getUserByUsername(userName);

```

### addToGroup

Add the user to group specified by the groupName;

#### Parameters
1. `string` - groupName

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    groupName = "BOSS";
    Error = user.addToGroup(groupName);
````

### removeFromGroup

Remove the user from the group specified by the groupName;

#### Parameters
1. `string` - groupName

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    groupName = "BOSS";
    Error = user.removeFromGroup(groupName);
````

### updateActive

Update active status of the user

#### Parameters
1. `boolean` - active

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    boolean active = true;
    Error = user.updateActive(active);
````

### updateAddress

Update addresses of of the user

#### Parameters
1. `Address[]` - addresses

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    Address address1 = {};
    Address address2 = {};
    address1.formatted = "no-123,st.peters',colombo";
    address1.|type| = "home"
    address2.streetAddress = "2/4,avenue";
    address2.|type| = "work";
    
    Address[] addresses = [address1,address2];
    Error = user.updateAddress(addresses);
````

### updateDisplayName

Update the display name of the user

#### Parameters
1. `string` - displayName

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string displayName = "Lionel Messi";
    Error = user.updateDisplayName(displayName);
````

### updateEmails

Update the emails of the user

#### Parameters
1. `Email[]` - emails

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    Email email1 = {};
    Email email2 = {};
    email1.value = "mail.com";
    email1.|type| = "home";
    email2.value = "email@cc.org";
    email2.|type| = "work";
    
    Email[] emails = [email1,email2];
    Error = user.updateAddress(emails);
````

### updateExternalId

Update the external id of the user

#### Parameters
1. `string` - externalId

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string externalId = "12321313ddddd";
    Error = user.updateExternalId(externalId);
````````
### updateLocale

Update locale of the user

#### Parameters
1. `string` - locale

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string locale = "Colombo";
    Error = user.updateLocale("locale");
````
### updateNickname

Update the nick name of the user

#### Parameters
1. `string` - nickName

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string nickName = "leo";
    Error = user.updateNickname(nickName);
````

### updatePassword

Update the password of the user

#### Parameters
1. `string` - password

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string password = "password";
    Error = user.updatePassword(password);
````

### updatePrefferedLanguage

Update the preferred language of the user

#### Parameters
1. `string` - preferredLanguage

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string preferredLanguage = "English";
    Error = user.updateDisplayName(preferredLanguage);
````

### updateProfileUrl

Update the profile URL of the user

#### Parameters
1. `string` - profileUrl

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string profileUrl = "1.1.1.1";
    Error = user.updateProfileUrl(profileUrl);
````

### updateTimezone

Update the timezone of the user

#### Parameters
1. `string` - timezone

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string timezone = "Indian";
    Error = user.updateTimezone(timezone);
````

### updateTitle

Update the title of the user

#### Parameters
1. `string` - title

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string title = "GOAT";
    Error = user.updateTitle(title);
````

### updateUserType

Update the user type of the user

#### Parameters
1. `string` - userType

#### Returns
- `error` struct with the status message.

#### Example

````ballerina
    string userType = "Lionel Messi";
    Error = user.updateUserType(userType);
````