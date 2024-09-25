import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApiSession {

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  //GET 통신 설정
  static getUrl(Uri uri) async {
    return await http.get(uri, headers: headers)
    .timeout(const Duration(seconds: 10));
  }

  //POST 통신 설정
  static getPostUri(Uri uri, dynamic data) async {
    return await http.post(uri, headers: headers, body: json.encode(data))
        .timeout(const Duration(seconds: 10)); //Timeout 설정
  }
}