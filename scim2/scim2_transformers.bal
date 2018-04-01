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

package scim2;

//Here are all the transformers that transform required json to structs and vice versa

transformer <json sourceJsonObject, Group targetGroupStruct> convertJsonToGroup() {
    targetGroupStruct.displayName = sourceJsonObject.displayName.toString();
    targetGroupStruct.id = sourceJsonObject.id.toString();
    targetGroupStruct.members = sourceJsonObject.members != null ? toMembers(sourceJsonObject) : [];
    targetGroupStruct.meta = <Meta, convertJsonToMeta()>sourceJsonObject.meta;
}

transformer <json sourceJsonObject, Meta targetMetaStruct> convertJsonToMeta() {
    targetMetaStruct.created = sourceJsonObject.created != null ? sourceJsonObject.created.toString() : "";
    targetMetaStruct.location = sourceJsonObject.location != null ? sourceJsonObject.location.toString() : "";
    targetMetaStruct.lastModified = sourceJsonObject.lastModified != null ? sourceJsonObject.lastModified.toString() :
                                    "";
}

transformer <json sourceJsonObject, Member targetMemberStruct> convertJsonToMember() {
    targetMemberStruct.display = sourceJsonObject.display.toString();
    targetMemberStruct.value = sourceJsonObject.value.toString();
}

function toMembers (json s) returns Member[] {
    json[] jMembers =? <json[]>s.members;
    Member[] memlist;
    foreach i, node in jMembers {
        var mem =? <Member, convertJsonToMember()>node;
        memlist[i] = mem;
    }
    return memlist;
}

transformer <Group sourceGroupStruct, json targetJsonObject> convertGroupToJson() {
    targetJsonObject.displayName = sourceGroupStruct.displayName;
    targetJsonObject.id = sourceGroupStruct.id;
    json[] listMem = sourceGroupStruct.members != null ? toListMem(sourceGroupStruct) : [];
    targetJsonObject.members = listMem;
}

function toListMem (Group g) returns json[] {
    Member[] mem = g.members;
    json[] jlist;
    foreach i, node in mem {
        var jn = <json, convertMemberToJson()>node;
        jlist[i] = jn;
    }
    return jlist;
}

transformer <Member sourceMemberStruct, json targetJsonObject> convertMemberToJson() {
    targetJsonObject.display = sourceMemberStruct.display;
    targetJsonObject.value = sourceMemberStruct.value;
}

transformer <json sourceJsonObject, Group targetGroupStruct> convertReceivedPayloadToGroup() {
    targetGroupStruct = sourceJsonObject.Resources != null ? <Group, convertJsonToGroup()>sourceJsonObject.Resources[0]
                        : {};
}

transformer <json sourceJsonObject, Address targetAddressStruct> convertJsonToAddress() {
    targetAddressStruct.streetAddress = sourceJsonObject.streetAddress != null ?
                                        sourceJsonObject.streetAddress.toString() : "";
    targetAddressStruct.locality = sourceJsonObject.locality != null ? sourceJsonObject.locality.toString() : "";
    targetAddressStruct.postalCode = sourceJsonObject.postalCode != null ? sourceJsonObject.postalCode.toString() : "";
    targetAddressStruct.country = sourceJsonObject.country != null ? sourceJsonObject.country.toString() : "";
    targetAddressStruct.formatted = sourceJsonObject.formatted != null ? sourceJsonObject.formatted.toString() : "";
    targetAddressStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : "";
    targetAddressStruct.region = sourceJsonObject.region != null ? sourceJsonObject.region.toString() : "";
    targetAddressStruct.^"type" = sourceJsonObject.^"type" != null ? sourceJsonObject.^"type".toString() : "";
}

transformer <Address sourceAddressStruct, json targetJsonObject> convertAddressToJson() {
    targetJsonObject.streetAddress = sourceAddressStruct.streetAddress != null ? sourceAddressStruct.streetAddress : "";
    targetJsonObject.formatted = sourceAddressStruct.formatted != null ? sourceAddressStruct.formatted : "";
    targetJsonObject.country = sourceAddressStruct.country != null ? sourceAddressStruct.country : "";
    targetJsonObject.locality = sourceAddressStruct.locality != null ? sourceAddressStruct.locality : "";
    targetJsonObject.postalCode = sourceAddressStruct.postalCode != null ? sourceAddressStruct.postalCode : "";
    targetJsonObject.primary = sourceAddressStruct.primary != null ? sourceAddressStruct.primary : "";
    targetJsonObject.region = sourceAddressStruct.region != null ? sourceAddressStruct.region : "";
    targetJsonObject.^"type" = sourceAddressStruct.^"type" != null ? sourceAddressStruct.^"type" : "";
}

transformer <json sourceJsonObject, Name targetNameStruct> convertJsonToName() {
    targetNameStruct.givenName = sourceJsonObject.givenName != null ? sourceJsonObject.givenName.toString() : "";
    targetNameStruct.familyName = sourceJsonObject.familyName.toString();
    targetNameStruct.formatted = sourceJsonObject.formatted != null ? sourceJsonObject.formatted.toString() : "";
    targetNameStruct.honorificPrefix = sourceJsonObject.honorificPrefix != null ?
                                       sourceJsonObject.honorificPrefix.toString() : "";
    targetNameStruct.honorificSuffix = sourceJsonObject.honorificSuffix != null ?
                                       sourceJsonObject.honorificSuffix.toString() : "";
    targetNameStruct.middleName = sourceJsonObject.middleName != null ? sourceJsonObject.middleName.toString() : "";
}

transformer <Name sourceNameStruct, json targetJsonObject> convertNameToJson() {
    targetJsonObject.givenName = sourceNameStruct.givenName != null ? sourceNameStruct.givenName : "";
    targetJsonObject.familyName = sourceNameStruct.familyName != null ? sourceNameStruct.familyName : "";
    targetJsonObject.formatted = sourceNameStruct.formatted != null ? sourceNameStruct.formatted : "";
    targetJsonObject.middleName = sourceNameStruct.middleName != null ? sourceNameStruct.middleName : "";
    targetJsonObject.honorificPrefix = sourceNameStruct.honorificPrefix != null ? sourceNameStruct.honorificPrefix : "";
    targetJsonObject.honorificSuffix = sourceNameStruct.honorificSuffix != null ? sourceNameStruct.honorificSuffix : "";
}

transformer <json sourceJsonObject, Email targetEmailStruct> convertJsonToEmail() {
    targetEmailStruct.^"type" = sourceJsonObject.^"type" != null ? sourceJsonObject.^"type".toString() : " ";
    targetEmailStruct.value = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : " ";
    targetEmailStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : " ";
}

transformer <Email sourceEmailStruct, json targetJsonObject> convertEmailToJson() {
    targetJsonObject.^"type" = sourceEmailStruct.^"type";
    targetJsonObject.value = sourceEmailStruct.value != null ? sourceEmailStruct.value : "";
    targetJsonObject.primary = sourceEmailStruct.primary != null ? sourceEmailStruct.primary : "";
}

transformer <PhonePhotoIms sourcePhonePhotoIms, json targetJsonObject> convertPhonePhotoImsToJson() {
    targetJsonObject.value = sourcePhonePhotoIms.value != null ? sourcePhonePhotoIms.value : "";
    targetJsonObject.^"type" = sourcePhonePhotoIms.^"type" != null ? sourcePhonePhotoIms.^"type" : "";
}

transformer <json sourceJsonObject, PhonePhotoIms targetPhonePhotoIms> convertJsonToPhoneNumbers() {
    targetPhonePhotoIms.value = sourceJsonObject.value.toString();
    targetPhonePhotoIms.^"type" = sourceJsonObject.^"type".toString();
}


transformer <json sourceJsonObject, X509Certificate targetCertificate> convertJsonToCertificate() {
    targetCertificate.value = sourceJsonObject.value.toString();
}
transformer <json sourceJsonObject, EnterpriseUserExtension targetEnterpriseUser> convertJsonToEnterpriseExtension() {
    targetEnterpriseUser.costCenter = sourceJsonObject.costCenter != null ?
                                      sourceJsonObject.costCenter.toString() : " ";
    targetEnterpriseUser.department = sourceJsonObject.department != null ?
                                      sourceJsonObject.department.toString() : " ";
    targetEnterpriseUser.division = sourceJsonObject.division != null ? sourceJsonObject.division.toString() : " ";
    targetEnterpriseUser.employeeNumber = sourceJsonObject.employeeNumber != null ?
                                          sourceJsonObject.employeeNumber.toString() : " ";
    targetEnterpriseUser.organization = sourceJsonObject.organization != null ?
                                        sourceJsonObject.organization.toString() : " ";
    targetEnterpriseUser.manager = sourceJsonObject.manager != null ?
                                   <Manager, convertJsonToManager()>sourceJsonObject.manager : {};
}
transformer <json sourceJsonObject, Manager targetManagerStruct> convertJsonToManager() {
    targetManagerStruct.displayName = sourceJsonObject.displayName != null ?
                                      sourceJsonObject.displayName.toString() : " ";
    targetManagerStruct.managerId = sourceJsonObject.managerId != null ? sourceJsonObject.managerId.toString() : " ";
}

transformer <X509Certificate sourceCertificate, json targetJsonObject> convertCertificateToJson() {
    targetJsonObject.value = sourceCertificate.value != null ? sourceCertificate.value : "";
}
transformer <EnterpriseUserExtension sourceEnterpriseUser, json targetJsonObject> convertEnterpriseExtensionToJson() {
    targetJsonObject.employeeNumber = sourceEnterpriseUser.employeeNumber != null ?
                                      sourceEnterpriseUser.employeeNumber : "";
    targetJsonObject.costCenter = sourceEnterpriseUser.costCenter != null ? sourceEnterpriseUser.costCenter : "";
    targetJsonObject.organization = sourceEnterpriseUser.organization != null ? sourceEnterpriseUser.organization : "";
    targetJsonObject.division = sourceEnterpriseUser.division != null ? sourceEnterpriseUser.division : "";
    targetJsonObject.department = sourceEnterpriseUser.department != null ? sourceEnterpriseUser.department : "";
    targetJsonObject.manager = sourceEnterpriseUser.manager != null ?
                               <json, convertManagerToJson()>sourceEnterpriseUser.manager : {};
}

transformer <Manager sourceManagerStruct, json targetJsonObject> convertManagerToJson() {
    targetJsonObject.managerId = sourceManagerStruct.managerId != null ? sourceManagerStruct.managerId : "";
    targetJsonObject.displayName = sourceManagerStruct.displayName != null ? sourceManagerStruct.displayName : "";
}

transformer <Group sourceGroupStruct, json targetJsonObject> convertGroupToJsonUserRelated() {
    targetJsonObject.display = sourceGroupStruct.displayName != null ? sourceGroupStruct.displayName : "";
    targetJsonObject.value = sourceGroupStruct.id != null ? sourceGroupStruct.id : "";
}

transformer <json sourceJsonObject, User targetUserStruct> convertReceivedPayloadToUser() {
    targetUserStruct = sourceJsonObject.Resources != null ?
                       <User, convertJsonToUser()>sourceJsonObject.Resources[0] : {};
}

transformer <json sourceJsonObject, Group targetGroupStruct> convertJsonToGroupRelatedToUser() {
    targetGroupStruct.displayName = sourceJsonObject.display != null ? sourceJsonObject.display.toString() : " ";
    targetGroupStruct.id = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : " ";
    targetGroupStruct.members = sourceJsonObject.members != null ? toMembers(sourceJsonObject) : [];
    targetGroupStruct.meta = sourceJsonObject.meta != null ? <Meta, convertJsonToMeta()>sourceJsonObject : {};
}


transformer <json sourceJsonObject, User targetUserStruct> convertJsonToUser() {
    targetUserStruct.id = sourceJsonObject.id.toString();
    targetUserStruct.userName = sourceJsonObject.userName.toString();
    targetUserStruct.displayName = sourceJsonObject.displayName != null ? sourceJsonObject.displayName.toString() : "";
    targetUserStruct.name = sourceJsonObject.name != null ? <Name, convertJsonToName()>sourceJsonObject.name : {};
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
    targetUserStruct.meta = <Meta, convertJsonToMeta()>sourceJsonObject.meta;
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
                                      <EnterpriseUserExtension, convertJsonToEnterpriseExtension()>
                                      sourceJsonObject.EnterpriseUser : {};
}

function toCertificates (json s) returns X509Certificate[] {
    json[] jXcert =? <json[]>s.x509Certificates;
    X509Certificate[] xCList;
    foreach i, node in jXcert {
        var x =? <X509Certificate, convertJsonToCertificate()>node;
        xCList[i] = x;
    }
    return xCList;
}

function toSchemas (json s) returns json[] {
    json[] jSchemas =? <json[]>s.schemas;
    return jSchemas;
}

function toAddress (json s) returns Address[] {
    json[] jAddress =? <json[]>s.addresses;
    Address[] aAddress;
    foreach i, node in jAddress {
        var x =? <Address, convertJsonToAddress()>node;
        aAddress[i] = x;
    }
    return aAddress;
}

function toPhoneNumbers (json s) returns PhonePhotoIms[] {
    json[] jPhone =? <json[]>s.phoneNumbers;
    PhonePhotoIms[] pPhone;
    foreach i, node in jPhone {
        var x =? <PhonePhotoIms, convertJsonToPhoneNumbers()>node;
        pPhone[i] = x;
    }
    return pPhone;
}

function toPhotos (json s) returns PhonePhotoIms[] {
    json[] jPhoto =? <json[]>s.photos;
    PhonePhotoIms[] pPhoto;
    foreach i, node in jPhoto {
        var x =? <PhonePhotoIms, convertJsonToPhoneNumbers()>node;
        pPhoto[i] = x;
    }
    return pPhoto;
}

function toIms (json s) returns PhonePhotoIms[] {
    json[] jIms =? <json[]>s.ims;
    PhonePhotoIms[] pIms;
    foreach i, node in jIms {
        var x =? <PhonePhotoIms, convertJsonToPhoneNumbers()>node;
        pIms[i] = x;
    }
    return pIms;
}

function toEmails (json s) returns Email[] {
    json[] jEmail =? <json[]>s.emails;
    Email[] eEmail;
    foreach i, node in jEmail {
        var x =? <Email, convertJsonToEmail()>node;
        eEmail[i] = x;
    }
    return eEmail;
}


function toGroups (json s) returns Group[] {
    json[] jGroup =? <json[]>s.groups;
    Group[] gGroup;
    foreach i, node in jGroup {
        var x =? <Group, convertJsonToGroupRelatedToUser()>node;
        gGroup[i] = x;
    }
    return gGroup;
}

transformer <User sourceUserStruct, json targetJson> convertUserToJson() {
    targetJson.userName = sourceUserStruct.userName != null ? sourceUserStruct.userName : "";
    targetJson.id = sourceUserStruct.id != null ? sourceUserStruct.id : "";
    targetJson.password = sourceUserStruct.password != null ? sourceUserStruct.password : "";
    targetJson.externalId = sourceUserStruct.externalId != null ? sourceUserStruct.externalId : "";
    targetJson.displayName = sourceUserStruct.displayName != null ? sourceUserStruct.displayName : "";
    targetJson.nickName = sourceUserStruct.nickName != null ? sourceUserStruct.nickName : "";
    targetJson.profileUrl = sourceUserStruct.profileUrl != null ? sourceUserStruct.profileUrl : "";
    targetJson.userType = sourceUserStruct.userType != null ? sourceUserStruct.userType : "";
    targetJson.title = sourceUserStruct.title != null ? sourceUserStruct.title : "";
    targetJson.preferredLanguage = sourceUserStruct.preferredLanguage != null ? sourceUserStruct.preferredLanguage : "";
    targetJson.timezone = sourceUserStruct.timezone != null ? sourceUserStruct.timezone : "";
    targetJson.active = sourceUserStruct.active != null ? sourceUserStruct.active : "";
    targetJson.locale = sourceUserStruct.locale != null ? sourceUserStruct.locale : "";
    targetJson.schemas = sourceUserStruct.schemas != null ? sourceUserStruct.schemas : [];
    targetJson.name = sourceUserStruct.name != null ? <json, convertNameToJson()>sourceUserStruct.name : {};
    targetJson.meta = {};
    json[] listCertificates = sourceUserStruct.x509Certificates != null ? toJsonCertificates(sourceUserStruct) : [];
    targetJson.x509Certificates = listCertificates;

    json[] listGroups = sourceUserStruct.groups != null ? toJsonGroups(sourceUserStruct) : [];
    targetJson.groups = listGroups;

    json[] listAddresses = sourceUserStruct.addresses != null ? toJsonAddress(sourceUserStruct) : [];
    targetJson.addresses = listAddresses;

    json[] listEmails = sourceUserStruct.emails != null ? toJsonEmails(sourceUserStruct) : [];
    targetJson.emails = listEmails;

    json[] listNumbers = sourceUserStruct.phoneNumbers != null ? toJsonPhoneNumbers(sourceUserStruct) : [];
    targetJson.phoneNumbers = listNumbers;

    json[] listIms = sourceUserStruct.ims != null ?
                     sourceUserStruct.ims.map(
                                         function (PhonePhotoIms nestedIMS) returns json {
                                             return <json, convertPhonePhotoImsToJson()>nestedIMS;
                                         }) : [];
    targetJson.ims = listIms;
    json[] listPhotos = sourceUserStruct.photos != null ?
                        sourceUserStruct.photos.map(
                                               function (PhonePhotoIms nestedPhotos) returns json {
                                                   return <json, convertPhonePhotoImsToJson()>nestedPhotos;
                                               }) : [];
    targetJson.photos = listPhotos;

    targetJson.^"urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = sourceUserStruct.EnterpriseUser !=
                                                                               null ?
                                                                               <json,
                                                                               convertEnterpriseExtensionToJson()>
                                                                               sourceUserStruct.EnterpriseUser : {};
}


function toJsonCertificates (User u) returns json[] {
    X509Certificate[] xClist = u.x509Certificates;
    json[] jClist;
    foreach i, node in xClist {
        json x = <json, convertCertificateToJson()>node;
        jClist[i] = x;
    }
    return jClist;
}

function toJsonGroups (User u) returns json[] {
    Group[] gGroup = u.groups;
    json[] jGroup;
    foreach i, node in gGroup {
        json x = <json, convertGroupToJsonUserRelated()>node;
        jGroup[i] = x;
    }
    return jGroup;
}

function toJsonAddress (User u) returns json[] {
    Address[] aAddress = u.addresses;
    json[] jAddress;
    foreach i, node in aAddress {
        json x = <json, convertAddressToJson()>node;
        jAddress[i] = x;
    }
    return jAddress;
}

function toJsonEmails (User u) returns json[] {
    Email[] eEmail = u.emails;
    json[] jEmail;
    foreach i, node in eEmail {
        json x = <json, convertEmailToJson()>node;
        jEmail[i] = x;
    }
    return jEmail;
}


function toJsonPhoneNumbers (User u) returns json[] {
    PhonePhotoIms[] pPhone = u.phoneNumbers;
    json[] jPhone;
    foreach i, node in pPhone {
        json x = <json, convertPhonePhotoImsToJson()>node;
        jPhone[i] = x;
    }
    return jPhone;
}

function toJsonPhotos (User u) returns json[] {
    PhonePhotoIms[] pPhoto = u.photos;
    json[] jPhoto;
    foreach i, node in pPhoto {
        json x = <json, convertPhonePhotoImsToJson()>node;
        jPhoto[i] = x;
    }
    return jPhoto;
}

function toJsonIms (User u) returns json[] {
    PhonePhotoIms[] iIms = u.ims;
    json[] jIms;
    foreach i, node in iIms {
        json x = <json, convertPhonePhotoImsToJson()>node;
        jIms[i] = x;
    }
    return jIms;
}

//=================================================================================================================