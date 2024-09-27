import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/member_datasource.dart';
import 'package:withu/data/model/member.dart';

class MemberRepository {
  final MemberDataSource _dataSource = MemberDataSource();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Member? _member;

  Future<Member?> getMember() async {
    if(_member != null) {
      return _member;
    }
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    _member = await _dataSource.getMember(jwtToken);
    return _member;
  }
}