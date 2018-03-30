package tests;


import ballerina/io;
import scimclient;


public function main (string[] args) {

    endpoint scimclient:Scim2Endpoint scimEP {
        oauthClientConfig: {
                               accessToken: "b5b7aa96-ad43-316f-a912-094d2622561",
                               baseUrl: "https://localhost:9443",
                               clientId: "QZdeB7jgs2ulcDM2a70YlWEAzcAa",
                               clientSecret: "3V6V1_xLUmHNSGJ7_q7um6AvJMka",
                               refreshToken: "c4ea1d20-342d-3440-803a-f6f932f09a79",
                               refreshTokenEP: "https://localhost:9443",
                               refreshTokenPath: "/oauth2/token",
                               useUriParams: false,
                               clientConfig: { targets:[{uri:"https://localhost:9443",
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
    var response1 = scimEP -> createUser(user);
    match response1 {
        string message => io:println(message);
        error er => io:println(er);
    }

    //create user iniesta
    user.userName = "iniesta";
    io:println("");
    io:println("=======================================creating user " +
               user.userName + "=========================================");
    var response2 = scimEP -> createUser(user);
    match response2 {
        string message => io:println(message);
        error er => io:println(er);
    }

    //create user tnm
    user.userName = "tnm";
    io:println("");
    io:println("=======================================creating user " +
               user.userName + "=============================================");
    var response3 = scimEP -> createUser(user);
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
    var response4 = scimEP -> getUserByUsername(userName);
    match response4 {
        scimclient:User usr => {
            io:println(usr);
            getUser = usr;
        }
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
    var response5 = scimEP -> createGroup(gro);
    match response5 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //create group BOSS
    gro.displayName = "BOSS";
    io:println("==================================create group BOSS==================================================");
    var response6 = scimEP -> createGroup(gro);
    match response6 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get a Group from the IS user store by it's name using getGroupByName aciton=======================================
    io:println("");
    string groupName = "Captain";
    io:println("===================================get the Members of the Captain====================================");
    var response7 = scimEP -> getGroupByName(groupName);
    match response7 {
        scimclient:Group grp => io:println(grp.members);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Add an existing user to a existing group==========================================================================
    userName = "leoMessi";

    io:println("");
    io:println("================================Adding user leoMessi to group Captain================================");
    var response8 = scimEP -> addUserToGroup(userName, groupName);
    match response8 {
        string msg => io:println(msg);
        error er => io:println(er);
    }

    io:println("==================================members in Captain=================================================");
    var response9 = scimEP -> getGroupByName(groupName);
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
    var response10 = scimEP -> removeUserFromGroup(userName, groupName);
    match response10 {
        string msg => io:println(msg);
        error er => io:println(er);
    }

    io:println("====================================members in Captain===============================================");
    var response11 = scimEP -> getGroupByName(groupName);
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
    var response12 = scimEP -> isUserInGroup(userName, groupName);
    match response12 {
        boolean x => io:println(x);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Delete an user from the user store================================================================================
    userName = "leoMessi";
    io:println("");
    io:println("=========================================delete leoMessi=============================================");
    var response13 = scimEP -> deleteUserByUsername(userName);
    match response13 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Delete a group====================================================================================================
    groupName = "Captain";
    io:println("");
    io:println("==========================================deleting group Captain=====================================");
    var response14 = scimEP -> deleteGroupByName(groupName);
    match response14 {
        string msg => io:println(msg);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get the list of users in the user store===========================================================================
    io:println("");
    io:println("=======================================get the list of users=========================================");
    var response15 = scimEP -> getListOfUsers();
    match response15 {
        scimclient:User[] lst => io:println(lst);
        error er => io:println(er);
    }
    //==================================================================================================================

    //Get the list of groups============================================================================================
    io:println("");
    io:println("=======================================get the list of Groups========================================");
    var response16 = scimEP -> getListOfGroups();
    match response16 {
        scimclient:Group[] lst => io:println(lst);
        error er => io:println(er);
    }
    //==================================================================================================================
    //
    ////add user to group using struct bound function=====================================================================
    //userName = "tnm";
    //var response17 = scimEP -> getUserByUsername(userName);
    //match response17 {
    //    scimclient:User usr => user = usr;
    //    error er => io:println(er);
    //}
    //io:println("");
    //io:println("==================adding user " + userName + " to " + groupName +
    //           " using struct bind functions ============================");
    //groupName = "BOSS";
    //var response18 = user.addToGroup(groupName);
    //match response18 {
    //    string msg => io:println(msg);
    //    error er => io:println(er);
    //}
    ////================================================================================================================
    //
    ////remove an user from a group using strut bound function============================================================
    //io:println("");
    //io:println("============================remove a user by struct bound functions==================================");
    //var response19 = user.removeFromGroup(groupName);
    //match response19 {
    //    string msg => io:println(msg);
    //    error er => io:println(er);
    //}
    ////==================================================================================================================
    //
    ////get the user that is currently authenticated======================================================================
    //io:println("");
    //io:println("=========================================get the currently " +
    //           "authenticateduser=========================");
    //var response20 = scimCon.getMe();
    //match response20 {
    //    scimclient:User usr => io:println(usr);
    //    error er => io:println(er);
    //}
    ////==================================================================================================================
    //
    ////Test the Update functions=========================================================================================
    //scimclient:PhonePhotoIms phone2 = {};
    //phone2.^"type" = "work";
    //phone2.value = "0777777777";
    //user.phoneNumbers = [phone2];
    //
    //scimclient:Name name2 = {};
    //name2.givenName = "Tharindu";
    //name2.familyName = "Malawaraarachchi";
    //name2.formatted = "Tharindu Nuwan";
    //user.name = name2;
    //
    //scimclient:Address address2 = {};
    //address2.postalCode = "23433";
    //address2.streetAddress = "no/2";
    //address2.region = "Southern";
    //address2.locality = "Matara";
    //address2.country = "Sri Lanka";
    //address2.formatted = "Mehesha/Makandura East,Matara";
    //address2.primary = "true";
    //address2.^"type" = "work";
    //
    //user.addresses = [address2];
    //
    //user.userName = "tnm93";
    //user.password = "tharindunuwan";
    //
    //scimclient:Email email3 = {};
    //email3.value = "tharinduma@wso2.com";
    //email3.^"type" = "work";
    //
    //scimclient:Email email4 = {};
    //email4.value = "tharindunm93@gmail.com";
    //email4.^"type" = "home";
    //
    //user.emails = [email3, email4];
    //io:println("");
    //io:println("=======================================creating user " +
    //           user.userName + "========================================");
    //var response21 = scimCon.createUser(user);
    //match response21 {
    //    string message => io:println(message);
    //    error er => io:println(er);
    //}
    //
    ////update Nickname===================================================================================================
    //var response22 = scimCon.getUserByUsername("tnm93");
    //match response22 {
    //    scimclient:User usr => {
    //        io:println("");
    //        io:println("=========================================update the nickname of the "
    //                   + "user========================================");
    //        var response23 = usr.updateNickname("kotta");
    //        match response23 {
    //            string message => io:println(message);
    //            error er => io:println(er);
    //        }
    //
    //        io:println("");
    //        io:println("=========================================update the password of the "
    //                   + "user========================================");
    //        var response24 = usr.updatePassword("wso2carbon");
    //        match response24 {
    //            string message => io:println(message);
    //            error er => io:println(er);
    //        }
    //    }
    //    error er => {
    //        io:println("getting the user failed. Therefore testing updating functions failed");
    //        io:println(er);
    //    }
    //}
    ////==================================================================================================================
}

