import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/model/notification_request.dart';

import '../api/rest_api_session.dart';
import '../model/token_dto.dart';

class NotificationDataSource {
  final _uriPath = 'http://172.20.10.9:8080/api/teams';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<String?> sendTeamNotice(
      int teamId, String jwtToken, NotificationRequest request) async {
    TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
    headers['Authorization'] = 'Bearer ${tokenDto.token}';
    try {
      http.Response response = await RestApiSession.getPostUri(
          Uri.parse('$_uriPath/$teamId/notifications/send-alert'),
          headers,
          request);
      final int statusCode = response.statusCode;
      if (statusCode >= 200) {
        return utf8.decode(response.bodyBytes);
      } else {
        print('sendTeamNotice() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }
}
