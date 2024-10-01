import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/api/rest_api_session.dart';
import 'package:withu/data/model/init_member.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/model/token_dto.dart';

class MemberDataSource {
  // final _uriPath = 'http://127.0.0.1:8080/api/member';
  // final _uriPath = 'http://10.0.2.2:8080/api/member';
  final _uriPath = 'http://192.168.219.112:8080/api/member';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<Member?> getMember(String jwtToken) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
          await RestApiSession.getUrl(Uri.parse(_uriPath), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        Map<String, dynamic> result =
            json.decode(utf8.decode(response.bodyBytes));
        result.remove('id');
        result.remove('createdAt');
        result.remove('updatedAt');
        return Member.fromJson(result);
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getMember() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }

  Future<Member?> editMember(String jwtToken, InitMember member) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
          await RestApiSession.getPutUri(Uri.parse(_uriPath), headers, member);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        Map<String, dynamic> result =
            json.decode(utf8.decode(response.bodyBytes));
        result.remove('id');
        result.remove('createdAt');
        result.remove('updatedAt');
        return Member.fromJson(result);
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('editMember() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }

  Future<List<Member>?> getTeamMember(String jwtToken) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
          await RestApiSession.getUrl(Uri.parse('$_uriPath/team-members'), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => Member.fromJson(item)).toList();
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('editMember() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }
}
