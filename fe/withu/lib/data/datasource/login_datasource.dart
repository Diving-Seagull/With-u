import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/api/rest_api_session.dart';
import 'package:withu/data/model/token_dto.dart';

class LoginDataSource {

  final _uriPath = 'http://10.0.2.2:8080/api/auth';
  // final _uriPath = 'http://127.0.0.1:8080/api/auth';
  // final _uriPath = 'http://192.168.219.112:8080/api/auth';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<TokenDto?> postTokenInfo(TokenDto tokenDto, String type) async {
    String path = '$_uriPath/$type';
    try{
      http.Response response = await RestApiSession.getPostUri(Uri.parse(path), headers, tokenDto.toJson());

      final int statusCode = response.statusCode;

      if(statusCode == 200){
        return TokenDto.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      else {
        print('postTokenInfo() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$path TimeoutException');
    }
    return null;
  }
}