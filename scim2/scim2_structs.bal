// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import oauth2;

//All the Struct objects that are used

public type Group {
    string displayName;
    string id;
    Member[] members;
    Meta meta;
};

public type Member {
    string display;
    string value;
};


public type User {
    string userName;
    string id;
    string password;
    string externalId;
    string displayName;
    string nickName;
    string profileUrl;
    string userType;
    string title;
    string preferredLanguage;
    string timezone;
    string active;
    string locale;
    json[] schemas;
    Name name;
    Meta meta;
    X509Certificate[] x509Certificates;
    Group[] groups;
    Address[] addresses;
    Email[] emails;
    PhonePhotoIms[] phoneNumbers;
    PhonePhotoIms[] ims;
    PhonePhotoIms[] photos;
    EnterpriseUserExtension EnterpriseUser;
};

public type Address {
    string streetAddress;
    string locality;
    string postalCode;
    string country;
    string formatted;
    string primary;
    string region;
    string ^"type";
};

public type Name {
    string formatted;
    string givenName;
    string familyName;
    string middleName;
    string honorificPrefix;
    string honorificSuffix;
};

public type Meta {
    string created;
    string location;
    string lastModified;
};

public type PhonePhotoIms {
    string value;
    string ^"type";
};

public type Email {
    string value;
    string ^"type";
    string primary;
};

public type X509Certificate {
    string value;
};

public type EnterpriseUserExtension {
    string employeeNumber;
    string costCenter;
    string organization;
    string division;
    string department;
    Manager manager;
};

public type Manager {
    string managerId;
    string displayName;
};