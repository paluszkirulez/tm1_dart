import 'dart:async';

import '../Utils/ByteConverter.dart';
import 'dart:io';
import 'dart:convert';

class RESTConnection {
  ///this class supposed to put together all utlis necesssary to make connection live
  ///and manage it thru its lifetime
  /// class is a singleton because no two connections will exist at the same time and might be initializied
  /// with login

  final Map<String, String> HEADERS = {
    'Connection': 'keep-alive',
    'Content-Type': 'application/json; odata.streaming=true; charset=utf-8',
    'Accept': 'application/json;odata.metadata=none,text/plain'
  };

  final String host;
  final int HTTPPortNumber;
  final String user;
  final String password;
  final bool decodeB64;
  final String namespace;
  final bool ssl;
  String schema;
  String sessionId;
  String verify;
  double timeout;
  String encodedPassword;
  Uri url;
  final bool CAMNameSpace;
  static RESTConnection restConnection;

  RESTConnection._privateConstructor(
      this.schema,
      this.host,
      this.HTTPPortNumber,
      this.user,
      this.password,
      this.decodeB64,
      this.namespace,
      this.ssl,
      this.CAMNameSpace) {
    if (decodeB64) {
      var passwordString = user + ':' + password;
      passwordString = (namespace.isNotEmpty)
          ? namespace + ':' + passwordString
          : passwordString;
      encodedPassword = Converter().convertToB64(passwordString);
      encodedPassword = (CAMNameSpace)
          ? "CAMNameSpace " + encodedPassword
          : "Basic " + encodedPassword;
    }

    this.url = Uri(scheme: schema, host: host, port: HTTPPortNumber);
  }

  static RESTConnection initialize(schema, host, HTTPPortNumber, user, password,
      decodeB64, namespace, ssl, CamNameSpace) {
    if (restConnection == null) {
      restConnection = RESTConnection._privateConstructor(
          schema,
          host,
          HTTPPortNumber,
          user,
          password,
          decodeB64,
          namespace,
          ssl,
          CamNameSpace);

      return restConnection;
    }
    return restConnection;
  }

  void _addHeaders(HttpClientRequest request) {
    for (String header in HEADERS.keys) {
      request.headers.add(header, HEADERS[header]);
    }
    request.headers.add(HttpHeaders.authorizationHeader, encodedPassword);
  }

  Uri _replaceUnwantedStrings(
      Uri tempUrl, Map<String, dynamic> parameters, String baseUrl) {
    var newParams = parameters.map(
        (key, value) => MapEntry(Uri.encodeFull(key), Uri.encodeFull(value)));

    tempUrl = url.replace(queryParameters: newParams).replace(path: baseUrl);
    tempUrl = Uri.parse(tempUrl.toString().replaceAll('%2520', '%20'));
    tempUrl = Uri.parse(tempUrl.toString().replaceAll('%257D', '%7d'));
    return tempUrl;
  }

  Future<HttpClientResponse> runGet(String baseURL,
      {Map<String, dynamic> parameters}) async {
    //TODO function should resooult with just response and additional function should decode it

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    Uri tempUrl = url.replace(path: baseURL);
    print(tempUrl);
    if (parameters != null) {
      tempUrl = _replaceUnwantedStrings(tempUrl, parameters, baseURL);
    }
    print(tempUrl);

    var request = await client.getUrl(tempUrl);
    _addHeaders(request);
    var response = await request.close();

    return response;
  }


  Future<HttpClientResponse> runPost(
      String baseURL, Map<String, dynamic> parameters, String body) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    Uri tempUrl = url.replace(path: baseURL);
    if (parameters != null && parameters.isNotEmpty) {
      tempUrl = _replaceUnwantedStrings(tempUrl, parameters, baseURL);
    }
    print(tempUrl);
    var request = await client.postUrl(tempUrl);
    _addHeaders(request);
    request.headers.contentLength = body.length;
    request.write(body);
    var response = await request.close();

    return response;
  }
}
