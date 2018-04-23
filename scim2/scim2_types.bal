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

//All the Records that are used

documentation {Represents a Group in SCIM2
    F{{displayName}} - Display Name of the Group
    F{{id}} - The ID of the group
    F{{members}} - The list of members that the group has
    F{{meta}} - Meta data
}
public type Group {
    string displayName;
    string id;
    Member[] members;
    Meta meta;
};

documentation {Represents a Member in SCIM2-Group
    F{{display}} - Display Name of the user
    F{{value}} - ID of the group
}
public type Member {
    string display;
    string value;
};

documentation {Represents a User in SCIM2
    F{{userName}} - Username of the user
    F{{id}} - The ID of the user
    F{{password}} - Password of the user
    F{{externalId}} - External ID of the user
    F{{displayName}} - Display Name of the user
    F{{nickName}} - Nick name of the user"
    F{{profileUrl}} - Profile URL of the user
    F{{userType}} - The type of the user
    F{{title}} - Title of the user
    F{{preferredLanguage}} - Preffered language of the user
    F{{timezone}} - Timezone of the user
    F{{active}} - Active or not
    F{{locale}} - Location of the user
    F{{schemas}} - The schemas enabled
    F{{name}} - Name of the user
    F{{meta}} - Meta data
    F{{x509Certificates}} - x509Certificates of the user
    F{{groups}} - List of groups that the user is assigned to
    F{{addresses}} - Addresses of the user
    F{{emails}} - Emails of the user
    F{{phoneNumbers}} - Phone numbers of the user
    F{{ims}} - List of IMS of the user
    F{{photos}} - Photos of the user
    F{{EnterpriseUser}} - Enterprise User extention fiels of the user
}
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

documentation {Represents a address in a SCIM2-user
    F{{streetAddress}} - Street address
    F{{locality}} - Locality
    F{{postalCode}} - Postal code of the region
    F{{country}} - Country of recidence
    F{{formatted}} - Formatted address
    F{{primary}} - Whether the address is the primary one or not
    F{{region}} - Region
    F{{^"type"}} - Type of the address
}
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

documentation {Represents a Name in a SCIM2-User
    F{{formatted}} - Full name
    F{{givenName}} - First name
    F{{familyName}} - Surname
    F{{middleName}} - Middle name
    F{{honorificPrefix}} - Title that conveys esteem or respect for position
    F{{honorificSuffix}} - Word or expression with connotations conveying esteem or respect when used, after a name
}
public type Name {
    string formatted;
    string givenName;
    string familyName;
    string middleName;
    string honorificPrefix;
    string honorificSuffix;
};

documentation {Represents meta data
    F{{created}} - Date created
    F{{location}} - Location of the data
    F{{lastModified}} - Date of last modified
}
public type Meta {
    string created;
    string location;
    string lastModified;
};

documentation {Represents one of phone numbers, photos or IMS in SCIM2-User
    F{{value}} - Content
    F{{^"type"}} - Type
}
public type PhonePhotoIms {
    string value;
    string ^"type";
};

documentation {Represents a email in a SCIM2-User
    F{{value}} Email address
    F{{^"type"}} Type of the email
    F{{primary}} Whether it's primary or not
}
public type Email {
    string value;
    string ^"type";
    string primary;
};

documentation {Represents a x509Certificate in SCIM2-User
    F{{value}} - X509Certificate
}
public type X509Certificate {
    string value;
};

documentation {Represents fields related to Enterprise User Extention for a SCIM2-User
    F{{employeeNumber}} - Number of the employee
    F{{costCenter}} - Employee cost center
    F{{organization}} - Organization of the employe
    F{{division}} - Division of the employe
    F{{department}} - Department of the employee
    F{{manager}} - Manager
}
public type EnterpriseUserExtension {
    string employeeNumber;
    string costCenter;
    string organization;
    string division;
    string department;
    Manager manager;
};

documentation {Represents Manager fields of Enterprise User Extention
    F{{managerId}} - ID of the manager
    F{{displayName}} - Display name of the manager
}
public type Manager {
    string managerId;
    string displayName;
};