package samples.scimclient;


import ballerina.io;
import src.scimclient;
import ballerina.config;

string truststoreLocation = "/home/tharindu/Documents/IS_HOME/repository/resources/security/truststore.p12";
string trustStorePassword = "wso2carbon";
string BaseUrl = "https://localhost:9443";
string AccessToken = "fbb03535-857c-3b29-831e-f881e385bd61";
string ClientId = "QtjGpXRMEdfwXM2Z62H9efpf56sa";
string ClientSecret = "c21GZApujqJOhYEsznxXEqJDG8Qa";
string RefreshToken = "95002c96-347c-3c37-8e8d-dd5191cfe321";
string RefreshTokenEndpoint = "https://localhost:9443";
string RefreshTokenPath = "/oauth2/token";


 public function main (string[] args) {

    string s = "kimsGroup";
    string u = "Omare333";
    scimclient: User g = {};
    g.userName = u;
    g.password = "fasfdefsds";
    scimclient: ScimConnector scimCon = {};
    scimCon.init(BaseUrl,AccessToken,ClientId,ClientSecret,RefreshToken,RefreshTokenEndpoint,RefreshTokenPath,
                 truststoreLocation,trustStorePassword);
    var response = scimCon.removeUserFromGroup(u,s);
    match response {
        string lis => io:println(lis);
        error er => io:println(er);
    }

    //create user=======================================================================================================
    //scimclient:User user = {};
    //
    //scimclient:PhonePhotoIms phone = {};
    //phone.^"type" = "work";
    //phone.value = "0777777777";
    //user.phoneNumbers = [phone];
    //
    //scimclient:Name name = {};
    //name.givenName = "Leo";
    //name.familyName = "Messi";
    //name.formatted = "Lionel Messi";
    //user.name = name;
    //
    //scimclient:Address address = {};
    //address.postalCode = "23433";
    //address.streetAddress = "no/2";
    //address.region = "Catalunia";
    //address.locality = "Barcelona";
    //address.country = "Spain";
    //address.formatted = "no/2,Barcelona/Catalunia/Spain";
    //address.primary = "true";
    //address.^"type" = "work";
    //
    //user.addresses = [address];
    //
    //user.userName = "leoMessi";
    //user.password = "greatest";
    //
    //scimclient:Email email1 = {};
    //email1.value = "messi@barca.com";
    //email1.^"type" = "work";
    //
    //scimclient:Email email2 = {};
    //email2.value = "messi@gg.com";
    //email2.^"type" = "home";
    //
    //user.emails = [email1, email2];
    //
    //error Error;
    //Error = scimCon.createUser(user);
    //io:println("=======================================creating user " + user.userName + "============================");
    //io:println(Error);
    //
    ////create user iniesta
    //user.userName = "iniesta";
    //io:println("=======================================creating user " + user.userName + "============================");
    //Error = scimCon.createUser(user);
    //io:println(Error);
    //
    ////create user tnm
    //user.userName = "tnm";
    //io:println("=======================================creating user " + user.userName + "============================");
    //Error = scimCon.createUser(user);
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Get an user in the IS user store using getUserbyUserName action===================================================
    //scimclient:User getUser = {};
    //string userName = "iniesta";
    //getUser, Error = scimCon.getUserByUsername(userName);
    //
    //io:println("");
    //io:println("=======================================get user iniesta===============================================");
    //io:println(getUser);
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Create a Group in the IS user store using createUser action=======================================================
    //scimclient:Group gro = {};
    //gro.displayName = "Captain";
    //
    //scimclient:Member member = {};
    //member.display = getUser.userName;
    //member.value = getUser.id;
    //gro.members = [member];
    //
    //Error = scimCon.createGroup(gro);
    //io:println("");
    //io:println("==================================create group Captain with iniesta in it============================");
    //io:println(Error);
    ////create group BOSS
    //gro.displayName = "BOSS";
    //io:println("==================================create group BOSS==================================================");
    //Error = scimCon.createGroup(gro);
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Get a Group from the IS user store by it's name using getGroupByName aciton=======================================
    //scimclient:Group getGroup = {};
    //getGroup, Error = scimCon.getGroupByName("Captain");
    //
    //io:println("");
    //io:println("===================================get the Members of the Captain====================================");
    //io:println(getGroup);
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Add an existing user to a existing group==========================================================================
    //userName = "leoMessi";
    //string groupName = "Captain";
    //Error = scimCon.addUserToGroup(userName, groupName);
    //
    //io:println("");
    //io:println("================================Adding user leoMessi to group Captain================================");
    //io:println(Error);
    //
    //getGroup, Error = scimCon.getGroupByName("Captain");
    //io:println("==================================members in Captain=================================================");
    //io:println(getGroup.members);
    ////==================================================================================================================
    //
    ////Remove an user from a given group=================================================================================
    //userName = "iniesta";
    //groupName = "Captain";
    //
    //Error = scimCon.removeUserFromGroup(userName, groupName);
    //io:println("");
    //io:println("=============================Removing iniesta from Captain===========================================");
    //io:println(Error);
    //
    //getGroup, Error = scimCon.getGroupByName("Captain");
    //io:println("====================================members in Captain===============================================");
    //io:println(getGroup.members);
    ////==================================================================================================================
    //
    ////Check whether a user with certain user name is in a certain group=================================================
    //userName = "leoMessi";
    //groupName = "Captain";
    //boolean x;
    //x, Error = scimCon.isUserInGroup(userName, groupName);
    //io:println("");
    //io:println("============================Check if leoMessi is the Captain=========================================");
    //io:println(x);
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Delete an user from the user store================================================================================
    //userName = "leoMessi";
    //Error = scimCon.deleteUserByUsername(userName);
    //io:println("");
    //io:println("=========================================delete leoMessi=============================================");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Delete a group====================================================================================================
    //groupName = "Captain";
    //Error = scimCon.deleteGroupByName(groupName);
    //io:println("");
    //io:println("==========================================deleting group Captain=====================================");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Get the list of users in the user store===========================================================================
    //scimclient:User[] userList;
    //userList, Error = scimCon.getListOfUsers();
    //io:println("");
    //io:println("=======================================get the list of users=========================================");
    //io:println(userList);
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////Get the list of groups============================================================================================
    //scimclient:Group[] groupList;
    //groupList, Error = scimCon.getListOfGroups();
    //io:println("");
    //io:println("=======================================get the list of Groups========================================");
    //io:println(groupList);
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    //
    ////add user to group using struct bound function=====================================================================
    //userName = "tnm";
    //user, Error = scimCon.getUserByUsername(userName);
    //groupName = "BOSS";
    //Error = user.addToGroup(groupName);
    //io:println("");
    //io:println("==================adding user " + userName + " to " + groupName + " using struct bind functions======");
    //io:print("error: ");
    //io:println(Error);
    //////================================================================================================================
    //
    ////remove an user from a group using strut bound function============================================================
    //user, Error = scimCon.getUserByUsername(userName);
    //Error = user.removeFromGroup(groupName);
    //io:println("");
    //io:println("============================remove a user by struct bound functions==================================");
    //io:print("error: ");
    //io:println(Error);
    ////==================================================================================================================
    //
    ////get the user that is currently authenticated======================================================================
    //user, Error = scimCon.getMe();
    //io:println("");
    //io:println("=========================================get the currently authenticated use=========================r");
    //io:println(user);
    ////==================================================================================================================
 }

//function getBaseUrl () returns string{
//    var baseUrl = config:getGlobalValue("BaseUrl");
//    match baseUrl {
//        string s => return s;
//    }
//    return "";
//}
//
//function getAccessToken () returns string {
//    var accessToken = config:getGlobalValue("AccessToken");
//    match accessToken {
//        string s => return s;
//        error e => return "";
//    }
//}
//
//function getClientId () returns string {
//    var clientId = config:getGlobalValue("ClientId");
//    match clientId {
//        string s => return s;
//        error e => return "";
//    }
//}
//
//function getClientSecret () returns string {
//    var clientSecret = config:getGlobalValue("ClientSecret");
//    match clientSecret {
//        string s => return s;
//        error e => return "";
//    }
//}
//
//function getRefreshToken () returns string {
//    var refreshToken = config:getGlobalValue("RefreshToken");
//    match refreshToken {
//        string s => return s;
//        error e => return "";
//    }
//}
//
//function getRefreshTokenEndpoint () returns string {
//    var refreshTokenEndpoint = config:getGlobalValue("RefreshTokenEndpoint");
//    match refreshTokenEndpoint {
//        string s => return s;
//        error e => return "";
//    }
//}
//
//function getRefreshTokenPath () returns string {
//    var refreshTokenPath = config:getGlobalValue("RefreshTokenPath");
//    match refreshTokenPath {
//        string s => return s;
//        error e => return "";
//    }
//}