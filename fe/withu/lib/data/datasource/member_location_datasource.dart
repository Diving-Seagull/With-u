import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/model/memberlocation_request.dart';

import '../api/rest_api_session.dart';
import '../ip_address.dart';
import '../model/memberlocation.dart';
import '../model/token_dto.dart';

class MemberLocationDataSource {
  final _uriPath = 'http://${IpAddress.IP_PATH}:8080/api/member-location';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<MemberLocation?> editMemberLocation(String jwtToken, MemberLocationRequest request) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
      await RestApiSession.getPutUri(Uri.parse(_uriPath), headers, request);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        return MemberLocation.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('editMemberLocation() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }

  Future <MemberLocation?> getLeaderLocation(String jwtToken) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
      await RestApiSession.getUrl(Uri.parse(_uriPath), headers);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        return MemberLocation.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getLeaderLocation() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }

    return null;
  }
}