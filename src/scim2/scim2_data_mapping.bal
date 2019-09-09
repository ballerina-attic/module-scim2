//
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

function convertJsonToGroup(json sourceJsonObject) returns Group {
    Group targetGroupStruct = {};
    targetGroupStruct.displayName = sourceJsonObject.displayName.toString();
    targetGroupStruct.id = sourceJsonObject.id.toString();
    targetGroupStruct.members = sourceJsonObject.members != null ? toMembers(sourceJsonObject) : [];
    targetGroupStruct.meta = convertJsonToMeta(sourceJsonObject.meta);
    return targetGroupStruct;
}


function convertJsonToMeta(json|error sourceJsonObject) returns Meta {
    Meta targetMetaStruct = {};
    if (sourceJsonObject is json) {
        targetMetaStruct.created = sourceJsonObject.created != null ? sourceJsonObject.created.toString() : "";
        targetMetaStruct.location = sourceJsonObject.location != null ? sourceJsonObject.location.toString() : "";
        targetMetaStruct.lastModified = sourceJsonObject.lastModified != null ? sourceJsonObject.lastModified.toString() : "";
    }

    return targetMetaStruct;
}

function convertJsonToMember(json sourceJsonObject) returns Member {
    Member targetMemberStruct = {};
    targetMemberStruct.display = sourceJsonObject.display.toString();
    targetMemberStruct.value = sourceJsonObject.value.toString();
    return targetMemberStruct;
}

function toMembers(json s) returns Member[] {
    json[] jMembers = <json[]>s.members;
    Member[] memlist = [];
    int i = 0;
    foreach var node in jMembers {
        var mem = convertJsonToMember(node);
        memlist[i] = mem;
        i = i + 1;
    }
    return memlist;
}

function convertGroupToJson(Group sourceGroupStruct) returns json {
    json[] listMem = sourceGroupStruct.members.length() > 0 ? toListMem(sourceGroupStruct) : [];

    json targetJsonObject = {
        displayName: sourceGroupStruct.displayName,
        id: sourceGroupStruct.id,
        members: listMem
    };
    return targetJsonObject;
}

function toListMem(Group g) returns json[] {
    Member[] mem = g.members;
    json[] jlist = [];
    int i = 0;
    foreach var node in mem {
        var jn = convertMembertoJson(node);
        jlist[i] = jn;
        i = i + 1;
    }
    return jlist;
}

function convertMembertoJson(Member sourceMemberStruct) returns json {
    json targetJsonObject = {
        display: sourceMemberStruct.display,
        value: sourceMemberStruct.value
    };
    return targetJsonObject;
}

function convertReceivedPayloadToGroup(json sourceJsonObject) returns Group {
    Group targetGroupStruct = {};
    json[] resources = <json[]>sourceJsonObject.Resources;
    targetGroupStruct = sourceJsonObject.Resources != null ? convertJsonToGroup(resources[0])
    : {};
    return targetGroupStruct;
}

function convertJsonToAddress(json sourceJsonObject) returns Address {
    Address targetAddressStruct = {};
    targetAddressStruct.streetAddress = sourceJsonObject.streetAddress != null ?
    sourceJsonObject.streetAddress.toString() : "";
    targetAddressStruct.locality = sourceJsonObject.locality != null ? sourceJsonObject.locality.toString() : "";
    targetAddressStruct.postalCode = sourceJsonObject.postalCode != null ? sourceJsonObject.postalCode.toString() : "";
    targetAddressStruct.country = sourceJsonObject.country != null ? sourceJsonObject.country.toString() : "";
    targetAddressStruct.formatted = sourceJsonObject.formatted != null ? sourceJsonObject.formatted.toString() : "";
    targetAddressStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : "";
    targetAddressStruct.region = sourceJsonObject.region != null ? sourceJsonObject.region.toString() : "";
    targetAddressStruct.'type = sourceJsonObject.'type != null ?sourceJsonObject.'type.toString() : "";
    return targetAddressStruct;
}

function convertAddressToJson(Address sourceAddressStruct) returns json {
    json targetJsonObject = {
        streetAddress: sourceAddressStruct.streetAddress != "" ? sourceAddressStruct.streetAddress : "",
        formatted: sourceAddressStruct.formatted != "" ? sourceAddressStruct.formatted : "",
        country: sourceAddressStruct.country != "" ? sourceAddressStruct.country : "",
        locality: sourceAddressStruct.locality != "" ? sourceAddressStruct.locality : "",
        postalCode: sourceAddressStruct.postalCode != "" ? sourceAddressStruct.postalCode : "",
        primary: sourceAddressStruct.primary != "" ? sourceAddressStruct.primary : "",
        region: sourceAddressStruct.region != "" ? sourceAddressStruct.region : "",
        'type: sourceAddressStruct.'type != "" ? sourceAddressStruct.'type : ""
    };
    return targetJsonObject;
}

function convertJsonToName(json|error sourceJsonObject) returns Name {
    Name targetNameStruct = {};
    if (sourceJsonObject is json) {
        targetNameStruct.givenName = sourceJsonObject.givenName != null ? sourceJsonObject.givenName.toString() : "";
        targetNameStruct.familyName = sourceJsonObject.familyName.toString();
        targetNameStruct.formatted = sourceJsonObject.formatted != null ? sourceJsonObject.formatted.toString() : "";
        targetNameStruct.honorificPrefix = sourceJsonObject.honorificPrefix != null ?
        sourceJsonObject.honorificPrefix.toString() : "";
        targetNameStruct.honorificSuffix = sourceJsonObject.honorificSuffix != null ?
        sourceJsonObject.honorificSuffix.toString() : "";
        targetNameStruct.middleName = sourceJsonObject.middleName != null ? sourceJsonObject.middleName.toString() : "";
    }
    return targetNameStruct;
}

function convertNameToJson(Name sourceNameStruct) returns json {
    json targetJsonObject = {
        givenName: sourceNameStruct.givenName != "" ? sourceNameStruct.givenName : "",
        familyName: sourceNameStruct.familyName != "" ? sourceNameStruct.familyName : "",
        formatted: sourceNameStruct.formatted != "" ? sourceNameStruct.formatted : "",
        middleName: sourceNameStruct.middleName != "" ? sourceNameStruct.middleName : "",
        honorificPrefix: sourceNameStruct.honorificPrefix != "" ? sourceNameStruct.honorificPrefix : "",
        honorificSuffix: sourceNameStruct.honorificSuffix != "" ? sourceNameStruct.honorificSuffix : ""
    };
    return targetJsonObject;
}

function convertJsonToEmail(json sourceJsonObject) returns Email {
    Email targetEmailStruct = {};
    targetEmailStruct.'type = sourceJsonObject.'type != null ?sourceJsonObject.'type.toString() : "";
    targetEmailStruct.value = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : " ";
    targetEmailStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : "";
    return targetEmailStruct;
}

function convertEmailToJson(Email sourceEmailStruct) returns json {
    json targetJsonObject = {
        'type: sourceEmailStruct.'type,
        value: sourceEmailStruct.value != "" ? sourceEmailStruct.value : "",
        primary: sourceEmailStruct.primary != "" ? sourceEmailStruct.primary : ""
    };
    return targetJsonObject;
}

function convertPhonePhotoImsToJson(PhonePhotoIms sourcePhonePhotoIms) returns json {
    json targetJsonObject = {
        value: sourcePhonePhotoIms.value != "" ? sourcePhonePhotoIms.value : "",
        'type: sourcePhonePhotoIms.'type != "" ? sourcePhonePhotoIms.'type : ""
    };
    return targetJsonObject;
}

function convertJsonToPhoneNumbers(json sourceJsonObject) returns PhonePhotoIms {
    PhonePhotoIms targetPhonePhotoIms = {};
    targetPhonePhotoIms.value = sourceJsonObject.value.toString();
    targetPhonePhotoIms.'type =sourceJsonObject.'type.toString();
    return targetPhonePhotoIms;
}

function convertJsonToCertificate(json sourceJsonObject) returns X509Certificate {
    X509Certificate targetCertificate = {};
    targetCertificate.value = sourceJsonObject.value.toString();
    return targetCertificate;
}

function convertJsonToEnterpriseExtension(json|error sourceJsonObject) returns EnterpriseUserExtension {
    EnterpriseUserExtension targetEnterpriseUser = {};
    if (sourceJsonObject is json) {
        targetEnterpriseUser.costCenter = sourceJsonObject.costCenter != null ?
        sourceJsonObject.costCenter.toString() : "";
        targetEnterpriseUser.department = sourceJsonObject.department != null ?
        sourceJsonObject.department.toString() : "";
        targetEnterpriseUser.division = sourceJsonObject.division != null ? sourceJsonObject.division.toString() : "";
        targetEnterpriseUser.employeeNumber = sourceJsonObject.employeeNumber != null ?
        sourceJsonObject.employeeNumber.toString() : "";
        targetEnterpriseUser.organization = sourceJsonObject.organization != null ?
        sourceJsonObject.organization.toString() : "";
        targetEnterpriseUser.manager = sourceJsonObject.manager != null ?
        convertJsonToManager(sourceJsonObject.manager) : {};
    }
    return targetEnterpriseUser;
}

function convertJsonToManager(json|error sourceJsonObject) returns Manager {
    Manager targetManagerStruct = {};
    if (sourceJsonObject is json) {
        targetManagerStruct.displayName = sourceJsonObject.displayName != null ?
        sourceJsonObject.displayName.toString() : "";
        targetManagerStruct.managerId = sourceJsonObject.managerId != null ? sourceJsonObject.managerId.toString() : "";
    }
    return targetManagerStruct;
}

function convertCertificateToJson(X509Certificate sourceCertificate) returns json {
    json targetJsonObject = {
        value: sourceCertificate.value != "" ? sourceCertificate.value : ""
    };
    return targetJsonObject;
}

function convertEnterpriseExtensionToJson(EnterpriseUserExtension sourceEnterpriseUser) returns json {
    json targetJsonObject = {
        employeeNumber: sourceEnterpriseUser.employeeNumber != "" ? sourceEnterpriseUser.employeeNumber : "",
        costCenter: sourceEnterpriseUser.costCenter != "" ? sourceEnterpriseUser.costCenter : "",
        organization: sourceEnterpriseUser.organization != "" ? sourceEnterpriseUser.organization : "",
        division: sourceEnterpriseUser.division != "" ? sourceEnterpriseUser.division : "",
        department: sourceEnterpriseUser.department != "" ? sourceEnterpriseUser.department : "",
        manager: sourceEnterpriseUser.manager.length() > 0 ? convertManagerToJson(sourceEnterpriseUser.manager) : {}
    };
    return targetJsonObject;
}

function convertManagerToJson(Manager sourceManagerStruct) returns json {
    json targetJsonObject = {
        managerId: sourceManagerStruct.managerId != "" ? sourceManagerStruct.managerId : "",
        displayName: sourceManagerStruct.displayName != "" ? sourceManagerStruct.displayName : ""
    };
    return targetJsonObject;
}

function convertGroupToJsonUserRelated(Group sourceGroupStruct) returns json {
    json targetJsonObject = {
        display: sourceGroupStruct.displayName != "" ? sourceGroupStruct.displayName : "",
        value: sourceGroupStruct.id != "" ? sourceGroupStruct.id : ""
    };
    return targetJsonObject;
}

function convertReceivedPayloadToUser(json sourceJsonObject) returns User {
    User targetUserStruct = {};
    json[] resources = <json[]>sourceJsonObject.Resources;
    targetUserStruct = sourceJsonObject.Resources != null ? convertJsonToUser(resources[0]) : {};
    return targetUserStruct;
}

function convertJsonToGroupRelatedToUser(json sourceJsonObject) returns Group {
    Group targetGroupStruct = {};
    targetGroupStruct.displayName = sourceJsonObject.display != null ? sourceJsonObject.display.toString() : "";
    targetGroupStruct.id = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : "";
    targetGroupStruct.members = sourceJsonObject.members != null ? toMembers(sourceJsonObject) : [];
    targetGroupStruct.meta = sourceJsonObject.meta != null ? convertJsonToMeta(sourceJsonObject) : {};
    return targetGroupStruct;
}


function convertJsonToUser(json sourceJsonObject) returns User {
    User targetUserStruct = {};
    targetUserStruct.id = sourceJsonObject.id.toString();
    targetUserStruct.userName = sourceJsonObject.userName.toString();
    targetUserStruct.displayName = sourceJsonObject.displayName != null ? sourceJsonObject.displayName.toString() : "";
    targetUserStruct.name = sourceJsonObject.name != null ? convertJsonToName(sourceJsonObject.name) : {};
    targetUserStruct.active = sourceJsonObject.active != null ? sourceJsonObject.active.toString() : "";
    targetUserStruct.externalId = sourceJsonObject.externalId != null ? sourceJsonObject.externalId.toString() : "";
    targetUserStruct.nickName = sourceJsonObject.nickName != null ? sourceJsonObject.nickName.toString() : "";
    targetUserStruct.userType = sourceJsonObject.userType != null ? sourceJsonObject.userType.toString() : "";
    targetUserStruct.title = sourceJsonObject.title != null ? sourceJsonObject.title.toString() : "";
    targetUserStruct.timezone = sourceJsonObject.timezone != null ? sourceJsonObject.timezone.toString() : "";
    targetUserStruct.profileUrl = sourceJsonObject.profileUrl != null ? sourceJsonObject.profileUrl.toString() : "";
    targetUserStruct.preferredLanguage = sourceJsonObject.preferredLanguage != null ?
    sourceJsonObject.preferredLanguage.toString() : "";
    targetUserStruct.locale = sourceJsonObject.locale != null ? sourceJsonObject.locale.toString() : "";
    targetUserStruct.meta = convertJsonToMeta(sourceJsonObject.meta);
    targetUserStruct.x509Certificates = sourceJsonObject.x509Certificates != null ?
    toCertificates(sourceJsonObject) : [];
    targetUserStruct.schemas = sourceJsonObject.schemas != null ? toSchemas(sourceJsonObject) : [];
    targetUserStruct.addresses = sourceJsonObject.addresses != null ? toAddress(sourceJsonObject) : [];
    targetUserStruct.phoneNumbers = sourceJsonObject.phoneNumbers != null ? toPhoneNumbers(sourceJsonObject) : [];
    targetUserStruct.photos = sourceJsonObject.photos != null ? toPhotos(sourceJsonObject) : [];
    targetUserStruct.ims = sourceJsonObject.ims != null ? toIms(sourceJsonObject) : [];
    targetUserStruct.emails = sourceJsonObject.emails != null ? toEmails(sourceJsonObject) : [];
    targetUserStruct.groups = sourceJsonObject.groups != null ? toGroups(sourceJsonObject) : [];
    targetUserStruct.EnterpriseUser = sourceJsonObject.EnterpriseUser != null ?
    convertJsonToEnterpriseExtension(sourceJsonObject.EnterpriseUser) : {};
    return targetUserStruct;
}

function toCertificates(json s) returns X509Certificate[] {
    json[] jXcert = <json[]>s.x509Certificates;
    X509Certificate[] xCList = [];
    int i = 0;
    foreach var node in jXcert {
        var x = convertJsonToCertificate(node);
        xCList[i] = x;
        i = i + 1;
    }
    return xCList;
}

function toSchemas(json s) returns json[] {
    json[] jSchemas = <json[]>s.schemas;
    return jSchemas;
}

function toAddress(json s) returns Address[] {
    json[] jAddress = <json[]>s.addresses;
    Address[] aAddress = [];
    int i = 0;
    foreach var node in jAddress {
        var x = convertJsonToAddress(node);
        aAddress[i] = x;
        i = i + 1;
    }
    return aAddress;
}

function toPhoneNumbers(json s) returns PhonePhotoIms[] {
    json[] jPhone = <json[]>s.phoneNumbers;
    PhonePhotoIms[] pPhone = [];
    int i = 0;
    foreach var node in jPhone {
        var x = convertJsonToPhoneNumbers(node);
        pPhone[i] = x;
        i = i + 1;
    }
    return pPhone;
}

function toPhotos(json s) returns PhonePhotoIms[] {
    json[] jPhoto = <json[]>s.photos;
    PhonePhotoIms[] pPhoto = [];
    int i = 0;
    foreach var node in jPhoto {
        var x = convertJsonToPhoneNumbers(node);
        pPhoto[i] = x;
        i = i + 1;
    }
    return pPhoto;
}

function toIms(json s) returns PhonePhotoIms[] {
    json[] jIms = <json[]>s.ims;
    PhonePhotoIms[] pIms = [];
    int i = 0;
    foreach var node in jIms {
        var x = convertJsonToPhoneNumbers(node);
        pIms[i] = x;
        i = i + 1;
    }
    return pIms;
}

function toEmails(json s) returns Email[] {
    json[] jEmail = <json[]>s.emails;
    Email[] eEmail = [];
    int i = 0;
    foreach var node in jEmail {
        var x = convertJsonToEmail(node);
        eEmail[i] = x;
        i = i + 1;
    }
    return eEmail;
}

function toGroups(json s) returns Group[] {
    json[] jGroup = <json[]>s.groups;
    Group[] gGroup = [];
    int i = 0;
    foreach var node in jGroup {
        var x = convertJsonToGroupRelatedToUser(node);
        gGroup[i] = x;
        i = i + 1;
    }
    return gGroup;
}

function toJsonCertificates(User u) returns json[] {
    X509Certificate[] xClist = u.x509Certificates;
    json[] jClist = [];
    int i = 0;
    foreach var node in xClist {
        json x = convertCertificateToJson(node);
        jClist[i] = x;
        i = i + 1;
    }
    return jClist;
}

function toJsonGroups(User u) returns json[] {
    Group[] gGroup = u.groups;
    json[] jGroup = [];
    int i = 0;
    foreach var node in gGroup {
        json x = convertGroupToJsonUserRelated(node);
        jGroup[i] = x;
        i = i + 1;
    }
    return jGroup;
}

function toJsonAddress(User u) returns json[] {
    Address[] aAddress = u.addresses;
    json[] jAddress = [];
    int i = 0;
    foreach var node in aAddress {
        json x = convertAddressToJson(node);
        jAddress[i] = x;
        i = i + 1;
    }
    return jAddress;
}

function toJsonEmails(User u) returns json[] {
    Email[] eEmail = u.emails;
    json[] jEmail = [];
    int i = 0;
    foreach var node in eEmail {
        json x = convertEmailToJson(node);
        jEmail[i] = x;
        i = i + 1;
    }
    return jEmail;
}

function toJsonPhoneNumbers(User u) returns json[] {
    PhonePhotoIms[] pPhone = u.phoneNumbers;
    json[] jPhone = [];
    int i = 0;
    foreach var node in pPhone {
        json x = convertPhonePhotoImsToJson(node);
        jPhone[i] = x;
        i = i + 1;
    }
    return jPhone;
}

function toJsonPhotos(User u) returns json[] {
    PhonePhotoIms[] pPhoto = u.photos;
    json[] jPhoto = [];
    int i = 0;
    foreach var node in pPhoto {
        json x = convertPhonePhotoImsToJson(node);
        jPhoto[i] = x;
        i = i + 1;
    }
    return jPhoto;
}

function toJsonIms(User u) returns json[] {
    PhonePhotoIms[] iIms = u.ims;
    json[] jIms = [];
    int i = 0;
    foreach var node in iIms {
        json x = convertPhonePhotoImsToJson(node);
        jIms[i] = x;
        i = i + 1;
    }
    return jIms;
}

function convertUserToJson(User sourceUserStruct, string updateOrCreate) returns json {
    map<json> targetJson = {};
    targetJson["userName"] = sourceUserStruct.userName != "" ? sourceUserStruct.userName : "";
    targetJson["id"] = sourceUserStruct.id != "" ? sourceUserStruct.id : "";
    targetJson["externalId"] = sourceUserStruct.externalId != "" ? sourceUserStruct.externalId : "";
    targetJson["displayName"] = sourceUserStruct.displayName != "" ? sourceUserStruct.displayName : "";
    targetJson["nickName"] = sourceUserStruct.nickName != "" ? sourceUserStruct.nickName : "";
    targetJson["profileUrl"] = sourceUserStruct.profileUrl != "" ? sourceUserStruct.profileUrl : "";
    targetJson["userType"] = sourceUserStruct.userType != "" ? sourceUserStruct.userType : "";
    targetJson["title"] = sourceUserStruct.title != "" ? sourceUserStruct.title : "";
    targetJson["preferredLanguage"] = sourceUserStruct.preferredLanguage != "" ? sourceUserStruct.preferredLanguage : "";
    targetJson["timezone"] = sourceUserStruct.timezone != "" ? sourceUserStruct.timezone : "";
    targetJson["active"] = sourceUserStruct.active != "" ? sourceUserStruct.active : "";
    targetJson["locale"] = sourceUserStruct.locale != "" ? sourceUserStruct.locale : "";
    targetJson["schemas"] = sourceUserStruct.schemas.length() > 0 ? sourceUserStruct.schemas : [];
    targetJson["name"] = convertNameToJson(sourceUserStruct.name);
    targetJson["meta"] = {};
    json[] listCertificates = sourceUserStruct.x509Certificates.length() > 0 ? toJsonCertificates(sourceUserStruct) : [];
    targetJson["x509Certificates"] = listCertificates;

    json[] listGroups = sourceUserStruct.groups.length() > 0 ? toJsonGroups(sourceUserStruct) : [];
    targetJson["groups"] = listGroups;

    json[] listAddresses = sourceUserStruct.addresses.length() > 0 ? toJsonAddress(sourceUserStruct) : [];
    targetJson["addresses"] = listAddresses;

    json[] listEmails = sourceUserStruct.emails.length() > 0 ? toJsonEmails(sourceUserStruct) : [];
    targetJson["emails"] = listEmails;

    json[] listNumbers = sourceUserStruct.phoneNumbers.length() > 0 ? toJsonPhoneNumbers(sourceUserStruct) : [];
    targetJson["phoneNumbers"] = listNumbers;

    json[] listIms = sourceUserStruct.ims.length() > 0 ? toJsonPhotos(sourceUserStruct) : [];
    targetJson["ims"] = listIms;

    json[] listPhotos = sourceUserStruct.photos.length() > 0 ? toJsonIms(sourceUserStruct) : [];
    targetJson["photos"] = listPhotos;

    targetJson["urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"] = convertEnterpriseExtensionToJson
    (sourceUserStruct.EnterpriseUser);

    if (updateOrCreate.toLowerAscii() == "create") {
        targetJson["password"] = sourceUserStruct.password != "" ? sourceUserStruct.password : "";
    }


    return targetJson;
}
