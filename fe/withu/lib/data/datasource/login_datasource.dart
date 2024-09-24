import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/api/rest_api_session.dart';
import 'package:withu/data/model/token_dto.dart';

class LoginDataSource {

  final uri_path = 'http://10.0.2.2:8080/api/auth';

  Future<TokenDto?> postTokenInfo(TokenDto accessToken, String type) async {
    String path = '$uri_path/$type';
    http.Response response = await RestApiSession.getPostUri(Uri.parse(path), accessToken.toJson());
    final int statusCode = response.statusCode;

    if(statusCode == 200){
      return TokenDto.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    else {
      print('에러 발생 $statusCode');
    }
  }
}