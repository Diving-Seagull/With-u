import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApiSession {

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static getUrl(Uri uri) async {
    return await http.get(uri, headers: headers);
  }

  static getPostUri(Uri uri, dynamic data) async {
    return await http.post(uri, headers: headers, body: json.encode(data));
  }
}