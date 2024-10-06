import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main(){
   final String URL = "https://jsonplaceholder.typicode.com/";
   final request = Uri.parse(URL + "posts");

   Future<dynamic> fetch() async {
     final response = await http.get(request);
     print(jsonDecode(response.body));
   }

   test("API GET 테스트", () async {
     await fetch();
   });
}