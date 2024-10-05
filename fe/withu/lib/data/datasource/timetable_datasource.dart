import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/rest_api_session.dart';
import '../ip_address.dart';
import '../model/schedule.dart';
import '../model/token_dto.dart';

class TimeTableDataSource {
  final _uriPath = 'http://${IpAddress.IP_PATH}:8080/api/schedules';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<List<Schedule>?> getMorningSchedules(String jwtToken, String date) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
      await RestApiSession.getUrl(Uri.parse('$_uriPath/morning?date=$date'), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => Schedule.fromJson(item)).toList();
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getMorningSchedules() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }

  Future<List<Schedule>?> getAfternoonSchedules(String jwtToken, String date) async {
    try {
      TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
      headers['Authorization'] = 'Bearer ${tokenDto.token}';
      http.Response response =
      await RestApiSession.getUrl(Uri.parse('$_uriPath/afternoon?date=$date'), headers);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => Schedule.fromJson(item)).toList();
      } else if (statusCode == 401) {
        print('JWT 인증 시간 초과');
      } else {
        print('getMorningSchedules() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }
}