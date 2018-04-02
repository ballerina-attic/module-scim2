package tests;

import ballerina/test;
import scim2;

endpoint scim2:Scim2Endpoint scimEP {
    oauthClientConfig:{
                          accessToken:"b5b7aa96-ad43-316f-a912-094d2622561",
                          baseUrl:"https://localhost:9443",
                          clientId:"QZdeB7jgs2ulcDM2a70YlWEAzcAa",
                          clientSecret:"3V6V1_xLUmHNSGJ7_q7um6AvJMka",
                          refreshToken:"93bb7d60-c370-35a1-9cca-91f959906fbd",
                          refreshTokenEP:"https://localhost:9443",
                          refreshTokenPath:"/oauth2/token",
                          useUriParams:false,
                          clientConfig:{targets:[{uri:"https://localhost:9443",
                                                     secureSocket:{
                                                                      trustStore:{
                                                                                     filePath:"/home/tharindu/Documents/IS_HOME/repository/resources/security/truststore.p12",
                                                                                     password:"wso2carbon"
                                                                                 }
                                                                  }
                                                 }
                                                ]}
                      }
};

@test:BeforeEach
function createFewUsersAndGroup () {
    scim2:User user1 = {};
    //create user iniesta
    user1.userName = "iniesta";
    user1.password = "iniesta123";
    var response1 = scimEP -> createUser(user1);

    //create user tnm
    user1.userName = "tnm";
    user1.password = "tnm123";
    var response2 = scimEP -> createUser(user1);

    //create Group BOSS
    scim2:Group gro = {};
    gro.displayName = "BOSS";
    var response3 = scimEP -> createGroup(gro);
}

@test:Config
function testCreateUser () {
    string message;
    //create user=======================================================================================================
    scim2:User user = {};

    scim2:PhonePhotoIms phone = {};
    phone.^"type" = "work";
    phone.value = "0777777777";
    user.phoneNumbers = [phone];

    scim2:Name name = {};
    name.givenName = "Leo";
    name.familyName = "Messi";
    name.formatted = "Lionel Messi";
    user.name = name;

    scim2:Address address = {};
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

    scim2:Email email1 = {};
    email1.value = "messi@barca.com";
    email1.^"type" = "work";

    scim2:Email email2 = {};
    email2.value = "messi@gg.com";
    email2.^"type" = "home";

    user.emails = [email1, email2];
    var response = scimEP -> createUser(user);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "User Created", msg = "createUser function failed");
}

@test:Config
function testGetUserByUserName () {
    string message;
    string userName = "iniesta";
    var response = scimEP -> getUserByUsername(userName);
    match response {
        scim2:User usr => {
            message = usr.userName;
        }
        error er => message = er.message;
    }
    test:assertEquals(message, "iniesta", msg = "getUserByUserName function failed");
}

@test:Config
function testCreateGroup () {
    string message;
    scim2:User getUser = {};
    string userName = "iniesta";
    var res = scimEP -> getUserByUsername(userName);
    match res {
        scim2:User usr => {
            getUser = usr;
        }
        error er => message = er.message;
    }

    scim2:Group gro = {};
    gro.displayName = "Captain";

    scim2:Member member = {};
    member.display = getUser.userName;
    member.value = getUser.id;
    gro.members = [member];

    var response = scimEP -> createGroup(gro);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "Group Created", msg = "createGroup function failed");
}

@test:Config {
    dependsOn:["testCreateGroup"]
}
function testGetGroupByName () {
    string message;
    string groupName = "Captain";
    var response = scimEP -> getGroupByName(groupName);
    match response {
        scim2:Group grp => message = grp.members[0].display;
        error er => message = er.message;
    }
    test:assertEquals(message, "iniesta", msg = "getGroupByName function failed");
}

@test:Config {
    dependsOn:["testGetGroupByName", "testCreateGroup", "testCreateUser"]
}
function testAddUserToGroup () {
    string message;
    string userName = "leoMessi";
    string groupName = "Captain";
    var response = scimEP -> addUserToGroup(userName, groupName);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "User Added", msg = "addUserToGroup function Failed");
}

@test:Config {
    dependsOn:["testCreateGroup", "testCreateUser", "testGetGroupByName"]
}
function testRemoveUserFromGroup () {
    string message;
    string userName = "iniesta";
    string groupName = "Captain";
    var response = scimEP -> removeUserFromGroup(userName, groupName);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "User Removed", msg = "removeUserFromGroup function failed");
}

@test:Config {
    dependsOn:["testCreateGroup", "testCreateUser", "testAddUserToGroup"]
}
function testIsUserInGroup () {
    boolean message;
    string userName = "leoMessi";
    string groupName = "Captain";
    var response = scimEP -> isUserInGroup(userName, groupName);
    match response {
        boolean x => message = x;
        error er => message = false;
    }
    test:assertEquals(message, true, msg = "isUserInGroup function failed");
}


@test:Config {
    dependsOn:["testCreateGroup", "testCreateUser", "testAddUserToGroup", "testIsUserInGroup", "testRemoveUserFromGroup"]
}
function testDeleteUser () {
    string message;
    string userName = "leoMessi";
    var response = scimEP -> deleteUserByUsername(userName);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "deleted", msg = "deleteUser function failed");
}

@test:Config {
    dependsOn:["testCreateGroup", "testCreateUser", "testAddUserToGroup", "testIsUserInGroup", "testRemoveUserFromGroup"]
}
function testDeleteGroup () {
    string message;
    string groupName = "Captain";
    var response = scimEP -> deleteGroupByName(groupName);
    match response {
        string msg => message = msg;
        error er => message = er.message;
    }
    test:assertEquals(message, "deleted", msg = "deleteGroup function failed");
}

@test:Config
function testUpdateUser () {
    string message;
    scim2:User getUser = {};
    string userName = "iniesta";
    var response = scimEP -> getUserByUsername(userName);
    match response {
        scim2:User usr => getUser = usr;
        error er => message = er.message;
    }
    getUser.nickName = "legend of barca";
    getUser.title = "hero";
    var res = scimEP -> updateUser(getUser);
    var response2 = scimEP -> getUserByUsername(userName);
    match response2 {
        scim2:User usr => message = usr.nickName;
        error er => message = er.message;
    }
    test:assertEquals(message, "legend of barca", msg = "updateUser function failed");
}

@test:Config {
    dependsOn:["testDeleteUser"]
}
function testGetListOfUsers () {
    int length = 0;
    var response = scimEP -> getListOfUsers();
    match response {
        scim2:User[] lst => length = lengthof lst;
        error er => length = -1;
    }
    test:assertEquals(length, 3, msg = "getListOfUsers function failed");
}

@test:Config {
    dependsOn:["testDeleteGroup"]
}
function testGetListOfGroups () {
    int length = 0;
    var response = scimEP -> getListOfGroups();
    match response {
        scim2:Group[] lst => length = lengthof lst;
        error er => length = -1;
    }
    test:assertEquals(length, 2, msg = "getListOfGroups function failed");
}
