package oauth2;

import ballerina/io;
import ballerina/net.http;

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

public function <OAuth2Client oAuth2Client> init (string baseUrl, string accessToken, string refreshToken,
                                                  string clientId, string clientSecret, string refreshTokenEP, string refreshTokenPath,
                                                  string trustStoreLocation, string trustStorePassword) {
    endpoint http:ClientEndpoint httpEP {
        targets:[{uri:baseUrl,
                     secureSocket:{
                                      trustStore:{
                                                     filePath:trustStoreLocation,
                                                     password:trustStorePassword
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
    originalRequest.setHeader("Authorization", "Bearer " + oAuth2Client.oAuthConfig.accessToken);
    var response = httpClient -> get(path, originalRequest);
    http:Request request = {};
    return response;
}
public function <OAuth2Client oAuth2Client> post (string path, http:Request originalRequest)
returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization", "Bearer " + oAuth2Client.oAuthConfig.accessToken);
    var response = httpClient -> post(path, originalRequest);
    return response;
}
public function <OAuth2Client oAuth2Client> patch (string path, http:Request originalRequest)
returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization", "Bearer " + oAuth2Client.oAuthConfig.accessToken);
    var response = httpClient -> patch(path, originalRequest);
    return response;
}
public function <OAuth2Client oAuth2Client> delete (string path, http:Request originalRequest)
returns http:Response|http:HttpConnectorError {
    endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    originalRequest.setHeader("Authorization", "Bearer " + oAuth2Client.oAuthConfig.accessToken);
    var response = httpClient -> delete(path, originalRequest);
    return response;
}
