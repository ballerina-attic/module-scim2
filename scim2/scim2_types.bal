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

# Represents a Group in SCIM2.
# + displayName - Display Name of the Group
# + id - The ID of the group
# + members - The list of members that the group has
# + meta - Meta data
public type Group record {|
    string displayName = "";
    string id = "";
    Member[] members = [];
    Meta meta = {};
|};

# Represents a Member in SCIM2-Group.
# + display - Display Name of the user
# + value - ID of the group
public type Member record {|
    string display = "";
    string value = "";
|};

# Represents a User in SCIM2.
# + userName - Username of the user
# + id - The ID of the user
# + password - Password of the user
# + externalId - External ID of the user
# + displayName - Display Name of the user
# + nickName - Nick name of the user
# + profileUrl - Profile URL of the user
# + userType - The type of the user
# + title - Title of the user
# + preferredLanguage - Preffered language of the user
# + timezone - Timezone of the user
# + active - Active or not
# + locale - Location of the user
# + schemas - The schemas enabled
# + name - Name of the user
# + meta - Meta data
# + x509Certificates - x509Certificates of the user
# + groups - List of groups that the user is assigned to
# + addresses - Addresses of the user
# + emails - Emails of the user
# + phoneNumbers - Phone numbers of the user
# + ims - List of IMS of the user
# + photos - Photos of the user
# + EnterpriseUser - Enterprise User extention fiels of the user
public type User record {|
    string userName = "";
    string id ="";
    string password = "";
    string externalId = "";
    string displayName = "";
    string nickName = "";
    string profileUrl = "";
    string userType = "";
    string title = "";
    string preferredLanguage = "";
    string timezone = "";
    string active = "";
    string locale = "";
    json[] schemas = [];
    Name name = {};
    Meta meta = {};
    X509Certificate[] x509Certificates = [];
    Group[] groups = [];
    Address[] addresses = [];
    Email[] emails = [];
    PhonePhotoIms[] phoneNumbers = [];
    PhonePhotoIms[] ims = [];
    PhonePhotoIms[] photos = [];
    EnterpriseUserExtension EnterpriseUser = {};
|};

# Represents a address in a SCIM2-user.
# + streetAddress - Street address
# + locality - Locality
# + postalCode - Postal code of the region
# + country - Country of recidence
# + formatted - Formatted address
# + primary - Whether the address is the primary one or not
# + region - Region
# + type - Type of the address
public type Address record {|
    string streetAddress = "";
    string locality = "";
    string postalCode = "";
    string country = "";
    string formatted = "";
    string primary = "";
    string region = "";
    string ^"type" = "";
|};

# Represents a Name in a SCIM2-User.
# + formatted - Full name
# + givenName - First name
# + familyName - Surname
# + middleName - Middle name
# + honorificPrefix - Title that conveys esteem or respect for position
# + honorificSuffix - Word or expression with connotations conveying esteem or respect when used, after a name
public type Name record {|
    string formatted = "";
    string givenName = "";
    string familyName = "";
    string middleName = "";
    string honorificPrefix = "";
    string honorificSuffix = "";
|};

# Represents meta data.
# + created - Date created
# + location - Location of the data
# + lastModified - Date of last modified
public type Meta record {|
    string created = "";
    string location = "";
    string lastModified = "";
|};

# Represents one of phone numbers, photos or IMS in SCIM2-User.
# + value - Content
# + type - Type
public type PhonePhotoIms record {|
    string value = "";
    string ^"type" = "";
|};

# Represents a email in a SCIM2-User.
# + value - Email address
# + type - Type of the email
# + primary - Whether it's primary or not
public type Email record {|
    string value = "";
    string ^"type" = "";
    string primary = "";
|};

# Represents a x509Certificate in SCIM2-User.
# + value - X509Certificate
public type X509Certificate record {|
    string value = "";
|};

# Represents fields related to Enterprise User Extention for a SCIM2-User.
# + employeeNumber - Number of the employee
# + costCenter - Employee cost center
# + organization - Organization of the employe
# + division - Division of the employe
# + department - Department of the employee
# + manager - Manager
public type EnterpriseUserExtension record {|
    string employeeNumber = "";
    string costCenter = "";
    string organization = "";
    string division = "";
    string department = "";
    Manager manager = {};
|};

# Represents Manager fields of Enterprise User Extention.
# + managerId - ID of the manager
# + displayName - Display name of the manager
public type Manager record {|
    string managerId = "";
    string displayName = "";
|};
