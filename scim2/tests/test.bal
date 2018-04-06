package tests;

import ballerina/test;

endpoint SCIM2Endpoint scimEP {
    oauthClientConfig:{
                          accessToken:"43bf08d9-bb63-3507-913e-5927dafb95e6",
                          baseUrl:"https://localhost:9443",
                          clientId:"hZiPwHli0AQSlN4bvbAyrs4CEaMa",
                          clientSecret:"fRJ1CpYtuc147s4b1gc5CR6DdZoa",
                          refreshToken:"de4c3823-5ea4-354e-ab0d-a5376dcde288",
                          refreshTokenEP:"https://localhost:9443",
                          refreshTokenPath:"/oauth2/token",
                          setCredentialsInHeader:true,
                          clientConfig:{targets:[{url:"https://localhost:9443",
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
    User user1 = {};
    //create user iniesta
    user1.userName = "iniesta";
    user1.password = "iniesta123";
    var response1 = scimEP -> createUser(user1);

    //create user tnm
    user1.userName = "tnm";
    user1.password = "tnm123";
    var response2 = scimEP -> createUser(user1);

    //create Group BOSS
    Group gro = {};
    gro.displayName = "BOSS";
    var response3 = scimEP -> createGroup(gro);
}

@test:Config
function testCreateUser () {
    string message;
    //create user=======================================================================================================
    User user = {};

    PhonePhotoIms phone = {};
    phone.^"type" = "work";
    phone.value = "0777777777";
    user.phoneNumbers = [phone];

    Name name = {};
    name.givenName = "Leo";
    name.familyName = "Messi";
    name.formatted = "Lionel Messi";
    user.name = name;

    Address address = {};
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

    Email email1 = {};
    email1.value = "messi@barca.com";
    email1.^"type" = "work";

    Email email2 = {};
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
        User usr => message = usr.userName;
        error er => test:assertFail(msg = er.message);
    }
    test:assertEquals(message, "iniesta", msg = "getUserByUserName function failed");
}

@test:Config
function testCreateGroup () {
    string message;
    User getUser = {};
    string userName = "iniesta";
    var res = scimEP -> getUserByUsername(userName);
    match res {
        User usr => getUser = usr;
        error er => test:assertFail(msg = er.message);
    }

    Group gro = {};
    gro.displayName = "Captain";

    Member member = {};
    member.display = getUser.userName;
    member.value = getUser.id;
    gro.members = [member];

    var response = scimEP -> createGroup(gro);
    match response {
        string msg => message = msg;
        error er => test:assertFail(msg = er.message);
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
        Group grp => message = grp.members[0].display;
        error er => test:assertFail(msg = er.message);
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
        error er => test:assertFail(msg = er.message);
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
        error er => test:assertFail(msg = er.message);
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
        error er => test:assertFail(msg = er.message);
    }
    test:assertTrue(message, msg = "isUserInGroup function failed");
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
        error er => test:assertFail(msg = er.message);
    }
    test:assertEquals(message, "deleted", msg = "deleteUser function failed");
}

@test:Config {
    dependsOn:["testCreateGroup", "testCreateUser", "testAddUserToGroup", "testIsUserInGroup",
               "testRemoveUserFromGroup"]
}
function testDeleteGroup () {
    string message;
    string groupName = "Captain";
    var response = scimEP -> deleteGroupByName(groupName);
    match response {
        string msg => message = msg;
        error er => test:assertFail(msg = er.message);
    }
    test:assertEquals(message, "deleted", msg = "deleteGroup function failed");
}

@test:Config
function testUpdateUser () {
    string message;
    User getUser = {};
    string userName = "tnm";
    var response = scimEP -> getUserByUsername(userName);
    match response {
        User usr => getUser = usr;
        error er => test:assertFail(msg = er.message);
    }

    Email email1 = {};
    email1.value = "iniesta@barca.com";
    email1.^"type" = "work";

    Email email2 = {};
    email2.value = "iniesta@spain.com";
    email2.^"type" = "home";
    getUser.emails = [email1, email2];

    getUser.nickName = "legend of spain";
    getUser.title = "hero";
    var res = scimEP -> updateUser(getUser);
    var response2 = scimEP -> getUserByUsername(userName);
    match response2 {
        User usr => message = usr.nickName;
        error er => test:assertFail(msg = er.message);
    }
    test:assertEquals(message, "legend of spain", msg = "updateUser function failed");
}

@test:Config {
    dependsOn:["testDeleteUser"]
}
function testGetListOfUsers () {
    int length = 0;
    var response = scimEP -> getListOfUsers();
    match response {
        User[] lst => length = lengthof lst;
        error er => test:assertFail(msg = er.message);
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
        Group[] lst => length = lengthof lst;
        error er => test:assertFail(msg = er.message);
    }
    test:assertEquals(length, 2, msg = "getListOfGroups function failed");
}