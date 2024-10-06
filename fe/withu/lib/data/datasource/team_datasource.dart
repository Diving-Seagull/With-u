import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/rest_api_session.dart';
import '../ip_address.dart';
import '../model/member.dart';
import '../model/token_dto.dart';

class TeamDataSource {
  final _uriPath = 'http://${IpAddress.IP_PATH}:8080/api/team';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<List<Member>?> getTeamMember(String jwtToken) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
      await RestApiSession.getUrl(Uri.parse('$_uriPath/members'), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        // print(json.decode(utf8.decode(response.bodyBytes)));
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => Member.fromJson(item)).toList();
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getTeamMember() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }

  Future<int?> removeTeamMember(String jwtToken, int id) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
          await RestApiSession.getDeleteUri(Uri.parse('$_uriPath/members/$id'), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 204) {
        return statusCode;
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getTeamMember() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }
}