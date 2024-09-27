import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApiSession {


  //GET 통신 설정
  static getUrl(Uri uri, Map<String, String> headers) async {
    return await http.get(uri, headers: headers)
    .timeout(const Duration(seconds: 10));
  }

  //POST 통신 설정
  static getPostUri(Uri uri, Map<String, String> headers, dynamic data) async {
    return await http.post(uri, headers: headers, body: json.encode(data))
        .timeout(const Duration(seconds: 10)); //Timeout 설정
  }
}