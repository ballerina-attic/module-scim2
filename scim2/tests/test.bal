import ballerina/test;
import ballerina/io;
import ballerina/config;
import ballerina/log;

string testUrl = config:getAsString("ENDPOINT");
string accessToken = config:getAsString("ACCESS_TOKEN");
string clientId = config:getAsString("CLIENT_ID");
string clientSecret = config:getAsString("CLIENT_SECRET");
string refreshToken = config:getAsString("REFRESH_TOKEN");
string refreshUrl = config:getAsString("REFRESH_URL");
string keystore = config:getAsString("KEYSTORE");
string keystorePassword = config:getAsString("KEYSTORE_PASSWORD");

Scim2Configuration scim2Config = {
    baseUrl: testUrl,
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: accessToken,
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        },
        secureSocket: {
            trustStore: {
                path: keystore,
                password: keystorePassword
            }
        }
    }
};

Client scimEP = new(scim2Config);

@test:BeforeEach
function createFewUsersAndGroup() {
    User user1 = {};
    //create user iniesta
    user1.userName = "iniesta";
    user1.password = "iniesta123";
    var response1 = scimEP->createUser(user1);

    //create user tnm
    user1.userName = "tnm";
    user1.password = "tnm123";
    var response2 = scimEP->createUser(user1);

    //create Group BOSS
    Group gro = {};
    gro.displayName = "BOSS";
    var response3 = scimEP->createGroup(gro);
}

@test:Config
function testCreateUserSuccess() {
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
    var responseDelete = scimEP->deleteUserByUsername("leoMessei");
    var response = scimEP->createUser(user);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "User Created", msg = "createUser function failed");
}

@test:Config {
    dependsOn: ["testCreateUserSuccess"]
}
function testCreateUserFail() {
    string message;
    User user = {};
    string userName = "leoMessi";
    user.userName = userName;
    user.password = "greatestAllTime";
    var response = scimEP->createUser(user);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message,
            "Creating user:" + userName + " failed. User with the name: " + userName
            + " already exists in the system.",
        msg = "createUser function failed");
}

@test:Config
function testGetUserByUserNameSuccess() {
    string message = "";
    string userName = "iniesta";
    var response = scimEP->getUserByUsername(userName);
    if (response is User) {
        message = response.userName;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "iniesta", msg = "getUserByUserName function failed");
}

@test:Config
function testGetUserByUserNameFail() {
    string message;
    string userName = "dogDayAfternoon";
    var response = scimEP->getUserByUsername(userName);
    if (response is User) {
        message = response.userName;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "Resolving user:" + userName + " failed. No User with user name " + userName,
        msg = "getUserByUserName function failed");
}

@test:Config
function testCreateGroup() {
    string message = "";
    User getUser = {};
    string userName = "iniesta";
    var res = scimEP->getUserByUsername(userName);
    if (res is User) {
        getUser = res;
    } else {
        test:assertFail(msg = <string>res.detail().message);
    }

    Group gro = {};
    gro.displayName = "Captain";

    Member member = {};
    member.display = getUser.userName;
    member.value = getUser.id;
    gro.members = [member];

    var responseDelete = scimEP->deleteGroupByName("Captain");
    var response = scimEP->createGroup(gro);
    if (response is string) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "Group Created", msg = "createGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup"]
}
function testCreateGroupFail() {
    string message;
    Group gro = {};
    string groupName = "Captain";
    gro.displayName = groupName;

    var response = scimEP->createGroup(gro);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message,
            "Creating group:" + groupName + " failed. Group with name: PRIMARY/" + groupName
            + " already exists in the system.",
        msg = "createGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup"]
}
function testGetGroupByName() {
    string message = "";
    string groupName = "Captain";
    var response = scimEP->getGroupByName(groupName);
    if (response is Group) {
        message = response.members[0].display;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "iniesta", msg = "getGroupByName function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup"]
}
function testGetGroupByNameFail() {
    string message;
    string groupName = "Diamond";
    var response = scimEP->getGroupByName(groupName);
    if (response is Group) {
        message = response.members[0].display;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "Resolving group:" + groupName + " failed. No Group named " + groupName,
        msg = "getGroupByName function failed");
}

@test:Config {
    dependsOn: ["testGetGroupByName", "testCreateGroup", "testCreateUserSuccess"]
}
function testAddUserToGroup() {
    string message = "";
    string userName = "leoMessi";
    string groupName = "Captain";
    var response = scimEP->addUserToGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "User Added", msg = "addUserToGroup function Failed");
}

@test:Config {
    dependsOn: ["testGetGroupByName", "testCreateGroup", "testCreateUserSuccess"]
}
function testAddUserToGroupFailByUser() {
    string message;
    string userName = "leoMess";
    string groupName = "Captain";
    var response = scimEP->addUserToGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message,
     "Error occured while getting the user record which associate with the given userName :" + userName,
        msg = "addUserToGroup function Failed");
}

@test:Config {
    dependsOn: ["testGetGroupByName", "testCreateGroup", "testCreateUserSuccess"]
}
function testAddUserToGroupFailByGroup() {
    string message;
    string userName = "leoMessi";
    string groupName = "leoMessi";
    var response = scimEP->addUserToGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message,
        "Error occured while adding the user record under the given groupname :"
            + groupName , msg = "addUserToGroup function Failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testGetGroupByName"]
}
function testRemoveUserFromGroup() {
    string message = "";
    string userName = "iniesta";
    string groupName = "Captain";
    var response = scimEP->removeUserFromGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "User Removed", msg = "removeUserFromGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testGetGroupByName"]
}
function testRemoveUserFromGroupFailByUser() {
    string message;
    string userName = "iniest";
    string groupName = "Captain";
    var response = scimEP->removeUserFromGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "Unable to get the given userName :" + userName, msg = "removeUserFromGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testGetGroupByName"]
}
function testRemoveUserFromGroupFailByGroup() {
    string message;
    string userName = "iniesta";
    string groupName = "Capitan";
    var response = scimEP->removeUserFromGroup(userName, groupName);
    if (response is string) {
        message = response;
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "Unable to get the given groupname : " + groupName, msg = "removeUserFromGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup"]
}
function testIsUserInGroup() {
    boolean message = false;
    string userName = "leoMessi";
    string groupName = "Captain";
    var response = scimEP->isUserInGroup(userName, groupName);
    if (response is boolean) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertTrue(message, msg = "isUserInGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup"]
}
function testIsUserInGroupFalse() {
    boolean message = false;
    string userName = "iniesta";
    string groupName = "Captain";
    var response = scimEP->isUserInGroup(userName, groupName);
    if (response is boolean) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertFalse(message, msg = "isUserInGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup"]
}
function testIsUserInGroupFailByUser() {
    string message = "";
    boolean flag;
    string userName = "iniesa";
    string groupName = "Captain";
    var responseDelete = scimEP->deleteUserByUsername(userName);
    var response = scimEP->isUserInGroup(userName, groupName);
    if (response is boolean) {
        test:assertFail(msg = "Flag returned when error expected");
    } else {
        message = <string>response.detail().message;
    }
    test:assertEquals(message, "Unable to get the given userName :" + userName, msg = "isUserInGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup"]
}
function testIsUserInGroupFalseNoGroup() {
    string message;
    boolean flag;
    string userName = "iniesta";
    string groupName = "Captan";
    var responseDelete = scimEP->deleteGroupByName(groupName);
    var response = scimEP->isUserInGroup(userName, groupName);
    if (response is boolean) {
        test:assertFalse(response, msg = "isUserInGroup function failed");
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup", "testRemoveUserFromGroup",
    "testIsUserInGroup", "testCreateUserFail", "testAddUserToGroupFailByGroup"]
}
function testDeleteUser() {
    string message = "";
    string userName = "leoMessi";
    var response = scimEP->deleteUserByUsername(userName);
    if (response is string) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "deleted", msg = "deleteUser function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup", "testRemoveUserFromGroup",
    "testIsUserInGroup", "testCreateUserFail", "testAddUserToGroupFailByGroup"]
}
function testDeleteUserFail() {
    string userName = "leoMess";
    var responseDelete = scimEP->deleteUserByUsername(userName);
    var response = scimEP->deleteUserByUsername(userName);
    if (response is string) {
        test:assertFail(msg = "Message returned when error expected");
    } else {
        test:assertEquals(<string>response.detail().message, "Unable to get the given userName : " +
        userName, msg = "deleteUser function failed");
    }
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup",
    "testRemoveUserFromGroup", "testIsUserInGroup", "testCreateGroupFail"]
}
function testDeleteGroup() {
    string message = "";
    string groupName = "Captain";
    var response = scimEP->deleteGroupByName(groupName);
    if (response is string) {
        message = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertEquals(message, "deleted", msg = "deleteGroup function failed");
}

@test:Config {
    dependsOn: ["testCreateGroup", "testCreateUserSuccess", "testAddUserToGroup",
    "testRemoveUserFromGroup", "testIsUserInGroup", "testCreateGroupFail"]
}
function testDeleteGroupFail() {
    string groupName = "Captan";
    var responseDelete = scimEP->deleteGroupByName(groupName);
    var response = scimEP->deleteGroupByName(groupName);
    if (response is string) {
        test:assertFail(msg = "Message returned when error expected");
    } else {
        test:assertEquals(<string>response.detail().message, "Unable to get the given groupname :" +
        groupName , msg = "deleteUser function failed");
    }
}

@test:Config {
    dependsOn: ["testDeleteUser"]
}
function testGetListOfUsers() {
    int length = 0;
    var response = scimEP->getListOfUsers();
    if (response is error) {
        test:assertFail(msg = <string>response.detail().message);
    } else {
        length = response.length();
    }
    test:assertEquals(length, 3, msg = "getListOfUsers function failed");
}

@test:Config {
    dependsOn: ["testDeleteGroup"]
}
function testGetListOfGroups() {
    int length = 0;
    var response = scimEP->getListOfGroups();
    if (response is error) {
        test:assertFail(msg = <string>response.detail().message);
    } else {
        length = response.length();
    }
    test:assertEquals(length, 2, msg = "getListOfGroups function failed");
}
