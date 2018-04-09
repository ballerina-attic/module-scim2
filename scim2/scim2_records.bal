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

import wso2/oauth2;

//All the Records that are used

@Description {value:"Represents a SCIM2 group"}
@Field {value:"displayName: Display Name of the Group"}
@Field {value:"id: The ID of the group"}
@Field {value:"members: The list of members that the group has"}
@Field {value:"meta: Meta data"}
public type Group {
    string displayName;
    string id;
    Member[] members;
    Meta meta;
};

@Description {value:"Represents a member in a group"}
@Field {value:"display: Display Name of the user"}
@Field {value:"value: ID of the user"}
public type Member {
    string display;
    string value;
};


@Description {value:"Represents a SCIM2 User"}
@Field {value:"userName: Username of the user"}
@Field {value:"id: The ID of the user"}
@Field {value:"password: Password of the user"}
@Field {value:"externalId: External ID of the user"}
@Field {value:"displayName: Display Name of the User"}
@Field {value:"nickName: Nick name of the user"}
@Field {value:"profileUrl: Profile URL of the user"}
@Field {value:"userType: The type of the user"}
@Field {value:"title: Title of the user"}
@Field {value:"prefferedLanguage: Preffered language of the user"}
@Field {value:"timezone: Timezone of the user"}
@Field {value:"active: Active or not"}
@Field {value:"locale: Location of the user"}
@Field {value:"schemas: The schemas enabled"}
@Field {value:"name: Name of the user"}
@Field {value:"meta: Meta data"}
@Field {value:"x509Certificates: x509Certificates of the user"}
@Field {value:"groups: List of groups that the user is assigned to"}
@Field {value:"addresses: Addresses of the user"}
@Field {value:"emails: Emails of the user"}
@Field {value:"phoneNumbers: Phone numbers of the user"}
@Field {value:"ims: List of IMS of the user"}
@Field {value:"photos: Photos of the user"}
@Field {value:"EnterpriseUser: Enterprise User extention fiels of the user"}
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

@Description {value:"Represents the address of a SCIM2 user"}
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

@Description {value:"Represents the Name of a SCIM2 user"}
public type Name {
    string formatted;
    string givenName;
    string familyName;
    string middleName;
    string honorificPrefix;
    string honorificSuffix;
};

@Description {value:"Meta data"}
public type Meta {
    string created;
    string location;
    string lastModified;
};

@Description {value:"Represents either a phone number, photo and IMS of a SCIM2 user"}
public type PhonePhotoIms {
    string value;
    string ^"type";
};

@Description {value:"Represents Email address of a SCIM2 user"}
public type Email {
    string value;
    string ^"type";
    string primary;
};

@Description {value:"Represents a x509Certificate"}
public type X509Certificate {
    string value;
};

@Description {value:"Represents fields related to Enterprise User Extention for a SCIM2 user"}
public type EnterpriseUserExtension {
    string employeeNumber;
    string costCenter;
    string organization;
    string division;
    string department;
    Manager manager;
};

@Description {value:"Represents Manager fields of Enterprise User Extention"}
public type Manager {
    string managerId;
    string displayName;
};