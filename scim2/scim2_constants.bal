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

//These are the constants that are used

//String constants
@final string SCIM_AUTHORIZATION = "Authorization";
@final string SCIM_CONTENT_TYPE = "Content-Type";
@final string SCIM_FILTER_GROUP_BY_NAME = "filter=displayName+Eq+";
@final string SCIM_FILTER_USER_BY_USERNAME = "filter=userName+Eq+";
@final string SCIM_GROUP_END_POINT = "/scim2/Groups";
@final string SCIM_JSON = "application/json";
@final string SCIM_ME_ENDPOINT = "/scim2/Me";
@final string SCIM_TOTAL_RESULTS = "totalResults";
@final string SCIM_USER_END_POINT = "/scim2/Users";

//Integer constants
@final int HTTP_UNAUTHORIZED = 401;
@final int HTTP_CREATED = 201;
@final int HTTP_OK = 200;
@final int HTTP_NO_CONTENT = 204;


public json SCIM_GROUP_PATCH_ADD_BODY = {
                                            "schemas":["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
                                            "Operations":[{
                                                              "op":"add",
                                                              "value":{
                                                                          "members":[{
                                                                                         "display":"",
                                                                                         "$ref":"",
                                                                                         "value":""
                                                                                     }]
                                                                      }
                                                          }]
                                        };
public json SCIM_GROUP_PATCH_REMOVE_BODY = {
                                               "schemas":["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
                                               "Operations":[{
                                                                 "op":"remove",
                                                                 "path":""
                                                             }]
                                           };
public json SCIM_PATCH_ADD_BODY = {
                                      "schemas":["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
                                      "Operations":[{
                                                        "op":"add",
                                                        "value":{}
                                                    }]
                                  };