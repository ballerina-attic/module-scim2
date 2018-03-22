package samples.scimclient;


import ballerina.io;
import src.scimclient;
import ballerina.config;

string truststoreLocation = "/home/tharindu/Documents/IS_HOME/repository/resources/security/truststore.p12";
string trustStorePassword = "wso2carbon";
string BaseUrl = "https://localhost:9443";
string AccessToken = "7992c4ba-4c4d-343e-846a-75f83719795b";
string ClientId = "QtjGpXRMEdfwXM2Z62H9efpf56sa";
string ClientSecret = "c21GZApujqJOhYEsznxXEqJDG8Qa";
string RefreshToken = "95002c96-347c-3c37-8e8d-dd5191cfe321";
string RefreshTokenEndpoint = "https://localhost:9443";
string RefreshTokenPath = "/oauth2/token";


public function main (string[] args) {

    scimclient:ScimConnector scimCon = {};
    scimCon.init(BaseUrl, AccessToken, ClientId, ClientSecret, RefreshToken, RefreshTokenEndpoint, RefreshTokenPath,
                 truststoreLocation, trustStorePassword);

    //create user=======================================================================================================
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
    io:println("");
    io:println("=======================================creating user " +
               user.userName + "========================================");
    var response1 = scimCon.createUser(user);
    match response1 {
        string message => io:println(message);
        error er => io:println(er);
    }

    //create user iniesta
    user.userName = "iniesta";
    io:println("");
    io:println("=======================================creating user " +
               user.userName + "=========================================");
    var response2 = scimCon.createUser(user);
    match response2 {
        string message => io:println(message);
        error er => io:println(er);
    }

    //create user tnm
    user.userName = "tnm";
    io:println("");
    io:println("=======================================creating user " +
               user.userName + "=============================================");
    var response3 = scimCon.createUser(user);
    match response3 {
        string message => io:println(message);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get an user in the IS user store using getUserbyUserName action===================================================
    scimclient:User getUser = {};
    string userName = "iniesta";
    io:println("");
    io:println("======================================get user iniesta===============================================");
    var response4 = scimCon.getUserByUsername(userName);
    match response4 {
        scimclient:User usr => io:println(usr);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Create a Group in the IS user store using createUser action=======================================================
    scimclient:Group gro = {};
    gro.displayName = "Captain";

    scimclient:Member member = {};
    member.display = getUser.userName;
    member.value = getUser.id;
    gro.members = [member];

    io:println("");
    io:println("==================================create group Captain with iniesta in it============================");
    var response5 = scimCon.createGroup(gro);
    match response5 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //create group BOSS
    gro.displayName = "BOSS";
    io:println("==================================create group BOSS==================================================");
    var response6 = scimCon.createGroup(gro);
    match response6 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get a Group from the IS user store by it's name using getGroupByName aciton=======================================
    io:println("");
    string groupName = "Captain";
    io:println("===================================get the Members of the Captain====================================");
    var response7 = scimCon.getGroupByName(groupName);
    match response7 {
        scimclient:Group grp => io:println(grp.members);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Add an existing user to a existing group==========================================================================
    userName = "leoMessi";

    io:println("");
    io:println("================================Adding user leoMessi to group Captain================================");
    var response8 = scimCon.addUserToGroup(userName, groupName);
    match response8 {
        string msg => io:println(msg);
        error er => io:println(er);
    }

    io:println("==================================members in Captain=================================================");
    var response9 = scimCon.getGroupByName(groupName);
    match response9 {
        scimclient:Group grp => io:println(grp.members);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Remove an user from a given group=================================================================================
    userName = "iniesta";
    groupName = "Captain";

    io:println("");
    io:println("=============================Removing iniesta from Captain===========================================");
    var response10 = scimCon.removeUserFromGroup(userName, groupName);
    match response10 {
        string msg => io:println(msg);
        error er => io:println(er);
    }

    io:println("====================================members in Captain===============================================");
    var response11 = scimCon.getGroupByName(groupName);
    match response11 {
        scimclient:Group grp => io:println(grp.members);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Check whether a user with certain user name is in a certain group=================================================
    userName = "leoMessi";
    groupName = "Captain";
    io:println("");
    io:println("============================Check if leoMessi is the Captain=========================================");
    var response12 = scimCon.isUserInGroup(userName, groupName);
    match response12 {
        boolean x => io:println(x);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Delete an user from the user store================================================================================
    userName = "leoMessi";
    io:println("");
    io:println("=========================================delete leoMessi=============================================");
    var response13 = scimCon.deleteUserByUsername(userName);
    match response13 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Delete a group====================================================================================================
    groupName = "Captain";
    io:println("");
    io:println("==========================================deleting group Captain=====================================");
    var response14 = scimCon.deleteGroupByName(groupName);
    match response14 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get the list of users in the user store===========================================================================
    io:println("");
    io:println("=======================================get the list of users=========================================");
    var response15 = scimCon.getListOfUsers();
    match response15 {
        scimclient:User[] lst => io:println(lst);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get the list of groups============================================================================================
    io:println("");
    io:println("=======================================get the list of Groups========================================");
    var response16 = scimCon.getListOfGroups();
    match response16 {
        scimclient:Group[] lst => io:println(lst);
        error er => io:println(er);
    }
    //==================================================================================================================

    //add user to group using struct bound function=====================================================================
    userName = "tnm";
    var response17 = scimCon.getUserByUsername(userName);
    match response17 {
        scimclient:User usr => user = usr;
        error er => io:println(er);
    }
    io:println("");
    io:println("==================adding user " + userName + " to " + groupName +
               " using struct bind functions ============================");
    groupName = "BOSS";
    var response18 = user.addToGroup(groupName);
    match response18 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //================================================================================================================

    //remove an user from a group using strut bound function============================================================
    io:println("");
    io:println("============================remove a user by struct bound functions==================================");
    var response19 = user.removeFromGroup(groupName);
    match response19 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //get the user that is currently authenticated======================================================================
    io:println("");
    io:println("=========================================get the currently " +
             "authenticateduser=========================");
    var response20 = scimCon.getMe();
    match response20 {
        scimclient:User usr => io:println(usr);
        error er => io:println(er);
    }
    //==================================================================================================================
}

