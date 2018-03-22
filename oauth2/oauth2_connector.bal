package oauth2;

import ballerina.io;
import ballerina.net.http;

public struct OAuth2Client {
    http:ClientEndpoint httpClient;
    OAuthConfig oAuthConfig;
}

public struct OAuthConfig {
    string accessToken;
    string refreshToken;
    string clientId;
    string clientSecret;
    string baseUrl;
    string refreshTokenEP;
    string refreshTokenPath;
}

string accessTokenValue;

public function <OAuth2Client oAuth2Client> init(string baseUrl, string accessToken, string refreshToken,
                         string clientId, string clientSecret, string refreshTokenEP, string refreshTokenPath,
                                                                    string trustStoreLocation, string trustStorePassword) {
    endpoint http:ClientEndpoint httpEP {
                                    targets:[{uri:baseUrl,
                                        secureSocket: {
                                            trustStore: {
                                                filePath: trustStoreLocation,
                                                password: trustStorePassword
                                            }
                                        }
                                        }]};

    OAuthConfig conf = {};
    conf.accessToken = accessToken;
    conf.refreshToken = refreshToken;
    conf.clientId = clientId;
    conf.clientSecret = clientSecret;
    conf.refreshTokenEP = refreshTokenEP;
    conf.refreshTokenPath = refreshTokenPath;

    oAuth2Client.httpClient = httpEP;
    oAuth2Client.oAuthConfig = conf;
}

public function <OAuth2Client oAuth2Client> get (string path, http:Request originalRequest)
                                                                        returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization","Bearer 1b5d3bef-f3f4-3cda-a48a-b9766d377e40");
    var response = httpClient -> get(path, originalRequest);
    http:Request request = {};
    return response;
}
public function <OAuth2Client oAuth2Client> post (string path, http:Request originalRequest)
                                                                        returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization","Bearer 1b5d3bef-f3f4-3cda-a48a-b9766d377e40");
    var response = httpClient -> post(path, originalRequest);
    return response;
}
public function <OAuth2Client oAuth2Client> patch (string path, http:Request originalRequest)
                                                                        returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization","Bearer 1b5d3bef-f3f4-3cda-a48a-b9766d377e40");
    var response = httpClient -> patch(path, originalRequest);
    return response;
}
//
//public function <OAuth2Client oAuth2Client> post (string path, http:Request originalRequest)
//                                                                        (http:Response, http:HttpConnectorError) {
//    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
//    var originalPayload, _ = originalRequest.getJsonPayload();
//    populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
//    response, e = httpClient -> post(path, originalRequest);
//    http:Request request = {};
//    request.setJsonPayload(originalPayload);
//    if (checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken, oAuth2Client.oAuthConfig.clientId,
//                            oAuth2Client.oAuthConfig.clientSecret, oAuth2Client.oAuthConfig.refreshToken,
//                            oAuth2Client.oAuthConfig.refreshTokenEP, oAuth2Client.oAuthConfig.refreshTokenPath)) {
//        response, e = httpClient -> post (path, request);
//    }
//    return response, e;
//}
//
//public function <OAuth2Client oAuth2Client> put (string path, http:Request originalRequest)
//                                                                        (http:Response, http:HttpConnectorError) {
//    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
//    var originalPayload, _ = originalRequest.getJsonPayload();
//    populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
//    response, e = httpClient -> put(path, originalRequest);
//    http:Request request = {};
//    request.setJsonPayload(originalPayload);
//    if (checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken, oAuth2Client.oAuthConfig.clientId,
//                            oAuth2Client.oAuthConfig.clientSecret, oAuth2Client.oAuthConfig.refreshToken,
//                            oAuth2Client.oAuthConfig.refreshTokenEP, oAuth2Client.oAuthConfig.refreshTokenPath)) {
//        response, e = httpClient -> put (path, request);
//    }
//    return response, e;
//}
//
//
//public function <OAuth2Client oAuth2Client> delete (string path, http:Request originalRequest)
//                                (http:Response, http:HttpConnectorError) {
//    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
//    populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
//    response, e = httpClient -> get(path, originalRequest);
//    http:Request request = {};
//    if (checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken, oAuth2Client.oAuthConfig.clientId,
//                            oAuth2Client.oAuthConfig.clientSecret, oAuth2Client.oAuthConfig.refreshToken,
//                            oAuth2Client.oAuthConfig.refreshTokenEP, oAuth2Client.oAuthConfig.refreshTokenPath)) {
//        response, e = httpClient -> delete (path, request);
//    }
//    return response, e;
//}
//
//public function <OAuth2Client oAuth2Client> patch (string path, http:Request originalRequest)
//                                                                        (http:Response, http:HttpConnectorError) {
//    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
//    var originalPayload, _ = originalRequest.getJsonPayload();
//    populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
//    response, e = httpClient -> patch(path, originalRequest);
//    http:Request request = {};
//    request.setJsonPayload(originalPayload);
//    if (checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken, oAuth2Client.oAuthConfig.clientId,
//                            oAuth2Client.oAuthConfig.clientSecret, oAuth2Client.oAuthConfig.refreshToken,
//                            oAuth2Client.oAuthConfig.refreshTokenEP, oAuth2Client.oAuthConfig.refreshTokenPath)) {
//        response, e = httpClient -> patch (path, request);
//    }
//    return response, e;
//}
//
//function populateAuthHeader (http:Request request, string accessToken) {
//    if (accessTokenValue == null || accessTokenValue == "") {
//        accessTokenValue = accessToken;
//    }
//    request.setHeader("Authorization", "Bearer " + accessTokenValue);
//}
//
//function checkAndRefreshToken(http:Request request, string accessToken, string clientId,
//                    string clientSecret, string refreshToken, string refreshTokenEP, string refreshTokenPath)
//returns boolean {
//    boolean isRefreshed;
//    // io:println(response.statusCode);
//    // io:println(refreshToken);
//
//    if ((response.statusCode == 401) && refreshToken != null) {
//        accessTokenValue = getAccessTokenFromRefreshToken(request, accessToken, clientId, clientSecret, refreshToken,
//                                                                                      refreshTokenEP, refreshTokenPath);
//        isRefreshed = true;
//    }
//
//    return isRefreshed;
//}
//
//function getAccessTokenFromRefreshToken (http:Request request, string accessToken, string clientId, string clientSecret,
//                                         string refreshToken, string refreshTokenEP, string refreshTokenPath)
//returns string {
//
//    endpoint http:ClientEndpoint refreshTokenHTTPEP {targets:[{uri:refreshTokenEP}]};
//    http:Request refreshTokenRequest = {};
//    http:Response refreshTokenResponse = {};
//    string accessTokenFromRefreshTokenReq;
//    json accessTokenFromRefreshTokenJSONResponse;
//
//    accessTokenFromRefreshTokenReq = refreshTokenPath + "?refresh_token=" + refreshToken
//                                     + "&grant_type=refresh_token&client_secret="
//                                     + clientSecret + "&client_id=" + clientId;
//    refreshTokenResponse, e = refreshTokenHTTPEP -> post(accessTokenFromRefreshTokenReq, refreshTokenRequest);
//    accessTokenFromRefreshTokenJSONResponse, _ = refreshTokenResponse.getJsonPayload();
//    accessToken = accessTokenFromRefreshTokenJSONResponse.access_token.toString();
//    request.setHeader("Authorization", "Bearer " + accessToken);
//
//    return accessToken;
//}