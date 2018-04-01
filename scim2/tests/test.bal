//import ballerina/test;
//import scim2;
//
//@test:Config
//function testCreateUser () {
//    endpoint scim2:Scim2Endpoint scimEP {
//        oauthClientConfig: {
//                               accessToken: "b5b7aa96-ad43-316f-a912-094d2622561",
//                               baseUrl: "https://localhost:9443",
//                               clientId: "QZdeB7jgs2ulcDM2a70YlWEAzcAa",
//                               clientSecret: "3V6V1_xLUmHNSGJ7_q7um6AvJMka",
//                               refreshToken: "c4ea1d20-342d-3440-803a-f6f932f09a79",
//                               refreshTokenEP: "https://localhost:9443",
//                               refreshTokenPath: "/oauth2/token",
//                               useUriParams: false,
//                               clientConfig: { targets:[{uri:"https://localhost:9443",
//                                                            secureSocket:{
//                                                                             trustStore:{
//                                                                                            filePath:"/home/tharindu/Documents/IS_HOME/repository/resources/security/truststore.p12",
//                                                                                            password:"wso2carbon"
//                                                                                        }
//                                                                         }
//                                                        }
//                                                       ]}
//                           }
//    };
//    string message;
//    //create user=======================================================================================================
//    scim2:User user = {};
//
//    scim2:PhonePhotoIms phone = {};
//    phone.^"type" = "work";
//    phone.value = "0777777777";
//    user.phoneNumbers = [phone];
//
//    scim2:Name name = {};
//    name.givenName = "Leo";
//    name.familyName = "Messi";
//    name.formatted = "Lionel Messi";
//    user.name = name;
//
//    scim2:Address address = {};
//    address.postalCode = "23433";
//    address.streetAddress = "no/2";
//    address.region = "Catalunia";
//    address.locality = "Barcelona";
//    address.country = "Spain";
//    address.formatted = "no/2,Barcelona/Catalunia/Spain";
//    address.primary = "true";
//    address.^"type" = "work";
//
//    user.addresses = [address];
//
//    user.userName = "leoMessi";
//    user.password = "greatest";
//
//    scim2:Email email1 = {};
//    email1.value = "messi@barca.com";
//    email1.^"type" = "work";
//
//    scim2:Email email2 = {};
//    email2.value = "messi@gg.com";
//    email2.^"type" = "home";
//
//    user.emails = [email1, email2];
//    var response1 = scimEP -> createUser(user);
//    match response1 {
//        string msg => message = msg;
//        error er => message = er.message;
//    }
//    test:assertEquals(message,"User Created",msg = "createUser function failed");
//}


//====================================================================================================================
//package tests;
//
//import scim2;
//import ballerina/io;
//
//public function main (string[] args) {
//
//    endpoint Scim2Endpoint scimEP {
//        oauthClientConfig: {
//                               accessToken: "b5b7aa96-ad43-316f-a912-094d2622561",
//                               baseUrl: "https://localhost:9443",
//                               clientId: "QZdeB7jgs2ulcDM2a70YlWEAzcAa",
//                               clientSecret: "3V6V1_xLUmHNSGJ7_q7um6AvJMka",
//                               refreshToken: "c4ea1d20-342d-3440-803a-f6f932f09a79",
//                               refreshTokenEP: "https://localhost:9443",
//                               refreshTokenPath: "/oauth2/token",
//                               useUriParams: false,
//                               clientConfig: { targets:[{uri:"https://localhost:9443",
//                                                            secureSocket:{
//                                                                             trustStore:{
//                                                                                            filePath:"/home/tharindu/Documents/IS_HOME/repository/resources/security/truststore.p12",
//                                                                                            password:"wso2carbon"
//                                                                                        }
//                                                                         }
//                                                        }
//                                                       ]}
//                           }
//    };
//
//
//
//    User getUser = {};
//    string userName = "iniesta";
//    io:println("");
//    io:println("======================================get user iniesta===============================================");
//    var response4 = scimEP -> getUserByUsername(userName);
//    match response4 {
//        User usr => {
//           // io:println(usr);
//            getUser = usr;
//        }
//        error er => io:println(er);
//    }
//
//    io:println("");
//    io:println("======================================update user===============================================");
//    var res = scimEP -> updateUser(getUser);
//    io:println(res);
//
//
//    //create user=======================================================================================================
//    User user = {};
//
//    PhonePhotoIms phone = {};
//    phone.^"type" = "work";
//    phone.value = "0777777777";
//    user.phoneNumbers = [phone];
//
//    Name name = {};
//    name.givenName = "Leo";
//    name.familyName = "Messi";
//    name.formatted = "Lionel Messi";
//    user.name = name;
//
//    Address address = {};
//    address.postalCode = "23433";
//    address.streetAddress = "no/2";
//    address.region = "Catalunia";
//    address.locality = "Barcelona";
//    address.country = "Spain";
//    address.formatted = "no/2,Barcelona/Catalunia/Spain";
//    address.primary = "true";
//    address.^"type" = "work";
//
//    user.addresses = [address];
//
//    user.userName = "leoMessi";
//    user.password = "greatest";
//
//    Email email1 = {};
//    email1.value = "messi@barca.com";
//    email1.^"type" = "work";
//
//    Email email2 = {};
//    email2.value = "messi@gg.com";
//    email2.^"type" = "home";
//
//    user.emails = [email1, email2];
//    io:println("");
//    io:println("=======================================creating user " +
//               user.userName + "========================================");
//    var response1 = scimEP -> createUser(user);
//    match response1 {
//        string message => io:println(message);
//        error er => io:println(er);
//    }
//
//    //create user iniesta
//    user.userName = "iniesta";
//    io:println("");
//    io:println("=======================================creating user " +
//               user.userName + "=========================================");
//    var response2 = scimEP -> createUser(user);
//    match response2 {
//        string message => io:println(message);
//        error er => io:println(er);
//    }
//
//    //create user tnm
//    user.userName = "tnm";
//    io:println("");
//    io:println("=======================================creating user " +
//               user.userName + "=============================================");
//    var response3 = scimEP -> createUser(user);
//    match response3 {
//        string message => io:println(message);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Get an user in the IS user store using getUserbyUserName action===================================================
//    scim2:User getUser = {};
//    string userName = "iniesta";
//    io:println("");
//    io:println("======================================get user iniesta===============================================");
//    var response4 = scimEP -> getUserByUsername(userName);
//    match response4 {
//        scim2:User usr => {
//            io:println(usr);
//            getUser = usr;
//        }
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Create a Group in the IS user store using createUser action=======================================================
//    scim2:Group gro = {};
//    gro.displayName = "Captain";
//
//    scim2:Member member = {};
//    member.display = getUser.userName;
//    member.value = getUser.id;
//    gro.members = [member];
//
//    io:println("");
//    io:println("==================================create group Captain with iniesta in it============================");
//    var response5 = scimEP -> createGroup(gro);
//    match response5 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//    //create group BOSS
//    gro.displayName = "BOSS";
//    io:println("==================================create group BOSS==================================================");
//    var response6 = scimEP -> createGroup(gro);
//    match response6 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Get a Group from the IS user store by it's name using getGroupByName aciton=======================================
//    io:println("");
//    string groupName = "Captain";
//    io:println("===================================get the Members of the Captain====================================");
//    var response7 = scimEP -> getGroupByName(groupName);
//    match response7 {
//        scim2:Group grp => io:println(grp.members);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Add an existing user to a existing group==========================================================================
//    userName = "leoMessi";
//
//    io:println("");
//    io:println("================================Adding user leoMessi to group Captain================================");
//    var response8 = scimEP -> addUserToGroup(userName, groupName);
//    match response8 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//
//    io:println("==================================members in Captain=================================================");
//    var response9 = scimEP -> getGroupByName(groupName);
//    match response9 {
//        scim2:Group grp => io:println(grp.members);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Remove an user from a given group=================================================================================
//    userName = "iniesta";
//    groupName = "Captain";
//
//    io:println("");
//    io:println("=============================Removing iniesta from Captain===========================================");
//    var response10 = scimEP -> removeUserFromGroup(userName, groupName);
//    match response10 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//
//    io:println("====================================members in Captain===============================================");
//    var response11 = scimEP -> getGroupByName(groupName);
//    match response11 {
//        scim2:Group grp => io:println(grp.members);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Check whether a user with certain user name is in a certain group=================================================
//    userName = "leoMessi";
//    groupName = "Captain";
//    io:println("");
//    io:println("============================Check if leoMessi is the Captain=========================================");
//    var response12 = scimEP -> isUserInGroup(userName, groupName);
//    match response12 {
//        boolean x => io:println(x);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Delete an user from the user store================================================================================
//    userName = "leoMessi";
//    io:println("");
//    io:println("=========================================delete leoMessi=============================================");
//    var response13 = scimEP -> deleteUserByUsername(userName);
//    match response13 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Delete a group====================================================================================================
//    groupName = "Captain";
//    io:println("");
//    io:println("==========================================deleting group Captain=====================================");
//    var response14 = scimEP -> deleteGroupByName(groupName);
//    match response14 {
//        string msg => io:println(msg);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Get the list of users in the user store===========================================================================
//    io:println("");
//    io:println("=======================================get the list of users=========================================");
//    var response15 = scimEP -> getListOfUsers();
//    match response15 {
//        scim2:User[] lst => io:println(lst);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//
//    //Get the list of groups============================================================================================
//    io:println("");
//    io:println("=======================================get the list of Groups========================================");
//    var response16 = scimEP -> getListOfGroups();
//    match response16 {
//        scim2:Group[] lst => io:println(lst);
//        error er => io:println(er);
//    }
//    //==================================================================================================================
//}
//
