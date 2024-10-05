import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:withu/data/model/tourplace.dart';

import '../api/rest_api_session.dart';
import '../model/token_dto.dart';

class TourDataSource {
  final _uriPath = 'http://172.20.10.9:8080/api/tourist-spots';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<List<TourPlace>?> getTouristSpots(String jwtToken, double lat, double lng) async {
    TokenDto tokenDto = TokenDto.fromJson(json.decode(jwtToken));
    headers['Authorization'] = 'Bearer ${tokenDto.token}';
    print('$_uriPath?latitude=$lat&longitude=$lng');
    try {
      http.Response response = await RestApiSession.getUrl(
          Uri.parse('$_uriPath?latitude=$lat&longitude=$lng'), headers);
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
        return result.map((item) => TourPlace.fromJson(item)).toList();
      }
      else {
        print('getTouristSpots() 에러 발생 $statusCode');
      }
    } on http.ClientException {
      print('인터넷 문제 발생');
    } on TimeoutException {
      print('$_uriPath TimeoutException');
    }
    return null;
  }
}