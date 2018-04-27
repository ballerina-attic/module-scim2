Connects to SCIM2 API from Ballerina.

# Package Overview
 
The SCIM2 package provides user management capabilities by allowing you to create, delete, read, and update users and groups and manage a user's groups through the SCIM2 REST API. It handles OAuth 2.0 authentication and provides prebuilt types for SCIM2 objects that comply with the SCIM2 standards.

**User Operations**

The `wso2/scim2` package contains operations that manage users. It can create, list, update, and delete users.

**Group Operations**

The `wso2/scim2` package contains operations to manage groups. It can create, list, update, and delete groups.

## Compatibility

|                                 |       Version                  |
|  :---------------------------:  |  :---------------------------: |
|  Ballerina Language             |   0.970.0                 |
|  SCIM API                       |   [SCIM2.0](https://tools.ietf.org/html/rfc7643#section-8.3)|

## Sample
First, import the `wso2/scim2` package into the Ballerina project.

```ballerina
import wso2/scim2;
```

Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for BasicAuth and OAuth 2.0. The SCIM2 connector can be minimally instantiated using the access token or using the client ID, client secret, and refresh token in the HTTP client config or BasicAuth configuration.

```ballerina
endpoint Client scimEP {
   clientConfig:{
       auth:{
           scheme:"oauth",
           accessToken:accessToken,
           clientId:clientId,
           clientSecret:clientSecret,
           refreshToken:refreshToken,
           refreshUrl:refreshUrl
       },
       url:url,
       secureSocket:{
           trustStore:{
               path:keystore,
               password:password
           }
       }
   }
};
```

The `getUserByUsername` function retrieves a user and returns a `User` struct with the user’s attributes.

```ballerina
var response = scimEP->getUserByUsername(userName);
match response {
    User usr => io:println(usr);
    error er => io:println(er);
}
```

The `createUser` function creates the user. `User` is a structure that contains all the data mentioned in the SCIM2 specification. The response is either a `string` message (if successful) or an `error`.

```ballerina
User user = {};
user.userName = "userName";
user.password = "password";
var response = scimEP->createUser(user);
match response {
    string msg => io:println(msg);
    error er => io:println(er);
}
```

The `getGroupByName` function reads a group and returns the `Group` struct (if successful) or an `error`.
```ballerina
    string groupName = "groupName";
    var response = scimEP->getGroupByName(groupName);
    match response {
        Group grp => io:println(grp);
        error er => io:println(er);
    }
```
