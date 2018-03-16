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

package src.scimclient;

//Here are all the transformers that transform required json to structs and vice versa

//==================================================JSON to struct transformers ========================================

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
                                        sourceJsonObject.x509Certificates.map(
                                                                         function (json nestedJsonInSource)
                                                                         (X509Certificate) {return
                                                                                            <X509Certificate,
                                                                                            convertJsonToCertificate()>
                                                                                            nestedJsonInSource;
                                                                         }) : [];
    targetUserStruct.schemas = sourceJsonObject.schemas != null ?
                               sourceJsonObject.schemas.map(
                                                       function (json nestedJsonInSource) (string) {
                                                           return nestedJsonInSource.toString();
                                                       }) : [];
    targetUserStruct.addresses = sourceJsonObject.addresses != null ?
                                 sourceJsonObject.addresses.map(
                                                           function (json nestedJsonInSource) (Address) {
                                                               return <Address,
                                                                      convertJsonToAddress()>nestedJsonInSource;
                                                           }) : [];
    targetUserStruct.phoneNumbers = sourceJsonObject.phoneNumbers != null ?
                                    sourceJsonObject.phoneNumbers.map(function (json nestedJsonInSource)
                                                                      (PhonePhotoIms) {return
                                                                                       <PhonePhotoIms,
                                                                                       convertJsonToPhoneNumbers()>
                                                                                       nestedJsonInSource;
                                                                      }) : [];
    targetUserStruct.photos = sourceJsonObject.photos != null ?
                              sourceJsonObject.photos.map(
                                                     function (json nestedJsonInSource) (PhonePhotoIms) {
                                                         return <PhonePhotoIms,
                                                                convertJsonToPhoneNumbers()>nestedJsonInSource;
                                                                                       }) : [];
    targetUserStruct.ims = sourceJsonObject.ims != null ? sourceJsonObject.ims.map(
                                                                              function (json nestedJsonInSource)
                                                                              (PhonePhotoIms) {
                                                                                  return <PhonePhotoIms,
                                                                                         convertJsonToPhoneNumbers()>
                                                                                         nestedJsonInSource;
                                                                              }) : [];
    targetUserStruct.emails = sourceJsonObject.emails != null ?
                              sourceJsonObject.emails.map(function (json nestedJsonInSource)
                                                          (Email) {
                                                              return <Email, convertJsonToEmail()>
                                                                     nestedJsonInSource;
                                                          }) : [];
    targetUserStruct.groups = sourceJsonObject.groups != null ?
                              sourceJsonObject.groups.map(
                                                     function (json nestedJsonInSource)
                                                     (Group) {
                                                         return <Group,
                                                                convertJsonToGroupRelatedToUser()>nestedJsonInSource;
                                                     }) : [];
    targetUserStruct.EnterpriseUser = sourceJsonObject.EnterpriseUser != null ?
                                      <EnterpriseUserExtension, convertJsonToEnterpriseExtension()>
                                                                                sourceJsonObject.EnterpriseUser : null;
}

transformer <json sourceJsonObject, EnterpriseUserExtension targetExtension> convertJsonToEnterpriseExtension() {
    targetExtension.costCenter = sourceJsonObject.costCenter != null ?
                                           sourceJsonObject.costCenter.toString() : "";
    targetExtension.department = sourceJsonObject.department != null ?
                                           sourceJsonObject.department.toString() : "";
    targetExtension.division = sourceJsonObject.division != null ?
                                         sourceJsonObject.division.toString() : "";
    targetExtension.employeeNumber = sourceJsonObject.employeeNumber != null ?
                                               sourceJsonObject.employeeNumber.toString() : "";
    targetExtension.organization = sourceJsonObject.organization != null ?
                                             sourceJsonObject.organization.toString() : "";
    targetExtension.manager = sourceJsonObject.manager != null ?
                                        <Manager, convertJsonToManager()>sourceJsonObject.manager : {};
}

transformer <json sourceJsonObject, Manager targetManagerStruct> convertJsonToManager() {
    targetManagerStruct.displayName = sourceJsonObject.displayName != null ?
                                      sourceJsonObject.displayName.toString() : "";
    targetManagerStruct.managerId = sourceJsonObject.managerId != null ?
                                    sourceJsonObject.managerId.toString() : "";
}

transformer <json sourceJsonObject, Address targetAddressStruct> convertJsonToAddress() {
    targetAddressStruct.streetAddress = sourceJsonObject.streetAddress != null ?
                                        sourceJsonObject.streetAddress.toString() : "";
    targetAddressStruct.formatted = sourceJsonObject.formatted != null ? sourceJsonObject.formatted.toString() : "";
    targetAddressStruct.country = sourceJsonObject.country != null ? sourceJsonObject.country.toString() : "";
    targetAddressStruct.locality = sourceJsonObject.locality != null ? sourceJsonObject.locality.toString() : "";
    targetAddressStruct.postalCode = sourceJsonObject.postalCode != null ? sourceJsonObject.postalCode.toString() : "";
    targetAddressStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : "false";
    targetAddressStruct.region = sourceJsonObject.region != null ? sourceJsonObject.region.toString() : "";
    targetAddressStruct.|type| = sourceJsonObject.|type| != null ? sourceJsonObject.|type|.toString() : "";
}

transformer <json sourceJsonObject, Meta targetMetaStruct> convertJsonToMeta() {
    targetMetaStruct.location = sourceJsonObject.location != null ? sourceJsonObject.location.toString() : "";
    targetMetaStruct.lastModified = sourceJsonObject.lastModified != null ?
                                    sourceJsonObject.lastModified.toString() : "";
    targetMetaStruct.created = sourceJsonObject.created != null ? sourceJsonObject.created.toString() : "";
}

transformer <json sourceJsonObject, PhonePhotoIms targetPhoneNumber> convertJsonToPhoneNumbers() {
    targetPhoneNumber.value = sourceJsonObject.value.toString();
    targetPhoneNumber.|type| = sourceJsonObject.|type|.toString();
}

transformer <json sourceJsonObject, Email targetEmailStruct> convertJsonToEmail() {
    targetEmailStruct.|type| = sourceJsonObject.|type| != null ? sourceJsonObject.|type|.toString() : "";
    targetEmailStruct.value = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : "";
    targetEmailStruct.primary = sourceJsonObject.primary != null ? sourceJsonObject.primary.toString() : "";
}

transformer <json sourceJsonObject, Group targetGroupStruct> convertJsonToGroupRelatedToUser() {
    targetGroupStruct.displayName = sourceJsonObject.display != null ? sourceJsonObject.display.toString() : "";
    targetGroupStruct.id = sourceJsonObject.value != null ? sourceJsonObject.value.toString() : "";
    targetGroupStruct.members = sourceJsonObject.members != null ?
                                sourceJsonObject.members.map(
                                                        function (json nestedJsonInSource) (Member) {
                                                            return <Member, convertJsonToMember()>nestedJsonInSource;
                                                        }) : [];
    targetGroupStruct.meta = sourceJsonObject.meta != null ? <Meta, convertJsonToMeta()>sourceJsonObject : {};
}

transformer <json sourceJsonObject, Group targetGroupStruct> convertJsonToGroup() {
    targetGroupStruct.displayName = sourceJsonObject.displayName != null ? sourceJsonObject.displayName.toString() : "";
    targetGroupStruct.id = sourceJsonObject.id != null ? sourceJsonObject.id.toString() : "";
    targetGroupStruct.meta = <Meta, convertJsonToMeta()>sourceJsonObject.meta;
    targetGroupStruct.members = sourceJsonObject.members != null ?
                                sourceJsonObject.members.map(
                                                        function (json j) (Member) {
                                                            return <Member, convertJsonToMember()>j;
                                                        }) : [];
}

transformer <json sourceJsonObject, Member targetMemberStruct> convertJsonToMember() {
    targetMemberStruct.value = sourceJsonObject.value.toString();
    targetMemberStruct.display = sourceJsonObject.display.toString();
}

transformer <json sourceJsonObject, X509Certificate targetXCertificate> convertJsonToCertificate() {
    targetXCertificate.value = sourceJsonObject.value.toString();
}

transformer <json sourceJsonObject, Group targetGroupStruct> convertReceivedPayloadToGroup() {
    targetGroupStruct = sourceJsonObject.Resources != null ?
                        <Group, convertJsonToGroup()>sourceJsonObject.Resources[0] : null;
}

transformer <json sourceJsonObject, User targetUserStruct> convertReceivedPayloadToUser() {
    targetUserStruct = sourceJsonObject.Resources != null ?
                       <User, convertJsonToUser()>sourceJsonObject.Resources[0] : null;
}

//=========================================Struct to JSON transformers==================================================
transformer <Group sourceGroupStruct, json targetJsonObject> convertGroupToJsonUserRelated() {
    targetJsonObject.display = sourceGroupStruct.displayName;
    targetJsonObject.value = sourceGroupStruct.id;
}

transformer <Group sourceGroupStruct, json targetJsonObject> convertGroupToJson() {
    targetJsonObject.displayName = sourceGroupStruct.displayName != null ? sourceGroupStruct.displayName : "";
    targetJsonObject.id = sourceGroupStruct.id != null ? sourceGroupStruct.id : "";
    json[] listMembers = sourceGroupStruct.members != null ?
                         sourceGroupStruct.members.map(
                                                  function (Member nestedMemberStruct) (json) {
                                                      return <json, convertMemberToJson()>nestedMemberStruct;
                                                  }) : [];
    targetJsonObject.members = listMembers;
}

transformer <Member sourceMemberStruct, json targetJsonObject> convertMemberToJson() {
    targetJsonObject.value = sourceMemberStruct.value != null ? sourceMemberStruct.value : "";
    targetJsonObject.display = sourceMemberStruct.display != null ? sourceMemberStruct.display : "";
}

transformer <Name sourceNameStruct, json targetJsonObject> convertNameToJson() {
    targetJsonObject.givenName = sourceNameStruct.givenName;
    targetJsonObject.familyName = sourceNameStruct.familyName;
    targetJsonObject.formatted = sourceNameStruct.formatted;
    targetJsonObject.middleName = sourceNameStruct.middleName;
    targetJsonObject.honorificPrefix = sourceNameStruct.honorificPrefix;
    targetJsonObject.honorificSuffix = sourceNameStruct.honorificSuffix;
}

transformer <Address sourceAddressStruct, json targetJsonObject> convertAddressToJson() {
    targetJsonObject.streetAddress = sourceAddressStruct.streetAddress;
    targetJsonObject.formatted = sourceAddressStruct.formatted;
    targetJsonObject.country = sourceAddressStruct.country;
    targetJsonObject.locality = sourceAddressStruct.locality;
    targetJsonObject.postalCode = sourceAddressStruct.postalCode;
    targetJsonObject.primary = sourceAddressStruct.primary;
    targetJsonObject.region = sourceAddressStruct.region;
    targetJsonObject.|type| = sourceAddressStruct.|type|;
}

transformer <Email sourceEmailStruct, json targetJsonObject> convertEmailToJson() {
    targetJsonObject.|type| = sourceEmailStruct.|type|;
    targetJsonObject.value = sourceEmailStruct.value;
    targetJsonObject.primary = sourceEmailStruct.primary;
}

transformer <PhonePhotoIms sourcePhotoPhoneImsStruct, json targetJsonObject> convertPhonePhotoImsToJson() {
    targetJsonObject.value = sourcePhotoPhoneImsStruct.value;
    targetJsonObject.|type| = sourcePhotoPhoneImsStruct.|type|;
}

transformer <X509Certificate sourceXCertificate, json targetJsonObject> convertCertificateToJson() {
    targetJsonObject.value = sourceXCertificate.value;
}

transformer <EnterpriseUserExtension sourceExtension, json targetJsonObject> convertEnterpriseExtensionToJson() {
    targetJsonObject.employeeNumber = sourceExtension.employeeNumber != null ? sourceExtension.employeeNumber : "";
    targetJsonObject.costCenter = sourceExtension.costCenter != null ? sourceExtension.costCenter : "";
    targetJsonObject.organization = sourceExtension.organization != null ? sourceExtension.organization : "";
    targetJsonObject.division = sourceExtension.division != null ? sourceExtension.division : "";
    targetJsonObject.department = sourceExtension.department != null ? sourceExtension.department : "";
    targetJsonObject.manager = sourceExtension.manager != null ?
                               <json, convertManagerToJson()>sourceExtension.manager : {};
}

transformer <Manager sourceManagerStruct, json targetJsonObject> convertManagerToJson() {
    targetJsonObject.managerId = sourceManagerStruct.managerId != null ? sourceManagerStruct.managerId : "";
    targetJsonObject.displayName = sourceManagerStruct.displayName != null ? sourceManagerStruct.displayName : "";
}

transformer <User sourceUserStruct, json targetJson> convertUserToJson() {
    targetJson.userName = sourceUserStruct.userName;
    targetJson.id = sourceUserStruct.id;
    targetJson.password = sourceUserStruct.password;
    targetJson.externalId = sourceUserStruct.externalId;
    targetJson.displayName = sourceUserStruct.displayName;
    targetJson.nickName = sourceUserStruct.nickName;
    targetJson.profileUrl = sourceUserStruct.profileUrl;
    targetJson.userType = sourceUserStruct.userType;
    targetJson.title = sourceUserStruct.title;
    targetJson.preferredLanguage = sourceUserStruct.preferredLanguage;
    targetJson.timezone = sourceUserStruct.timezone;
    targetJson.active = sourceUserStruct.active;
    targetJson.locale = sourceUserStruct.locale;
    targetJson.schemas = sourceUserStruct.schemas != null ? sourceUserStruct.schemas : [];
    targetJson.name = sourceUserStruct.name != null ? <json, convertNameToJson()>sourceUserStruct.name : {};
    targetJson.meta = {};
    json[] listCertificates = sourceUserStruct.x509Certificates != null ?
                              sourceUserStruct.x509Certificates.map(
                                                               function (X509Certificate nestedXCertificate) (json) {
                                                                   return <json,
                                                                          convertCertificateToJson()>nestedXCertificate;
                                                               }) : [];
    targetJson.x509Certificates = listCertificates;
    json[] listGroups = sourceUserStruct.groups != null ?
                        sourceUserStruct.groups.map(
                                               function (Group nestedGroup) (json) {
                                                   return <json, convertGroupToJsonUserRelated()>nestedGroup;
                                               }) : [];
    targetJson.groups = listGroups;
    json[] listAddresses = sourceUserStruct.addresses != null ?
                           sourceUserStruct.addresses.map(
                                                     function (Address nestedAddress) (json) {
                                                         return <json, convertAddressToJson()>nestedAddress;
                                                     }) : [];
    targetJson.addresses = listAddresses;
    json[] listEmails = sourceUserStruct.emails != null ?
                        sourceUserStruct.emails.map(
                                               function (Email nestedEmail) (json) {
                                                   return <json, convertEmailToJson()>nestedEmail;
                                               }) : [];
    targetJson.emails = listEmails;
    json[] listNumbers = sourceUserStruct.phoneNumbers != null ?
                         sourceUserStruct.phoneNumbers.map(
                                                      function (PhonePhotoIms nestedPhoneNumbers) (json) {
                                                          return <json, convertPhonePhotoImsToJson()>nestedPhoneNumbers;
                                                      }) : [];
    targetJson.phoneNumbers = listNumbers;
    json[] listIms = sourceUserStruct.ims != null ?
                     sourceUserStruct.ims.map(
                                         function (PhonePhotoIms nestedIMS) (json) {
                                             return <json, convertPhonePhotoImsToJson()>nestedIMS;
                                         }) : [];
    targetJson.ims = listIms;
    json[] listPhotos = sourceUserStruct.photos != null ?
                        sourceUserStruct.photos.map(
                                               function (PhonePhotoIms nestedPhotos) (json) {
                                                   return <json, convertPhonePhotoImsToJson()>nestedPhotos;
                                               }) : [];
    targetJson.photos = listPhotos;

    targetJson.|urn:ietf:params:scim:schemas:extension:enterprise:2.0:User| = sourceUserStruct.EnterpriseUser !=
                                                                              null ?
                                                                              <json,
                                                                              convertEnterpriseExtensionToJson()>
                                                                              sourceUserStruct.EnterpriseUser : {};
}
