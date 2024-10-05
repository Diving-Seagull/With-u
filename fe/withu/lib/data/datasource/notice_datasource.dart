import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/model/notice.dart';
import 'package:withu/data/model/notice_request.dart';

import '../api/rest_api_session.dart';
import '../model/token_dto.dart';

class NoticeDataSource {

  // final _uriPath = 'http://127.0.0.1:8080/api/notice';
  // final _uriPath = 'http://10.0.2.2:8080/api/notice';
  final _uriPath = 'http://172.20.10.9:8080/api/notice';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<List<Notice>?> getTeamNotice(String jwtToken) async {
    TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
    headers['Authorization'] = 'Bearer ${tokenDto.token}';
    try {
      http.Response response = await RestApiSession.getUrl(
          Uri.parse(_uriPath), headers);
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => Notice.fromJson(item)).toList();
      }
      else {
        print('getTeamNotice() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
    // }
  }

  Future<Notice?> getPinnedNotice(String jwtToken) async {
    TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
    headers['Authorization'] = 'Bearer ${tokenDto.token}';
    try {
      http.Response response = await RestApiSession.getUrl(
          Uri.parse('$_uriPath/pinned'), headers);
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        return Notice.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      else {
        print('getPinnedNotice() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
    // }
  }

  Future<Notice?> addTeamNotice(String jwtToken, NoticeRequest notice) async {
    TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
    headers['Authorization'] = 'Bearer ${tokenDto.token}';
    try {
      http.Response response = await RestApiSession.getPostUri(
          Uri.parse(_uriPath), headers, notice);
      final int statusCode = response.statusCode;

      if (statusCode >= 200) {
        return Notice.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      else {
        print('getTeamNotice() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
    // }
  }
}