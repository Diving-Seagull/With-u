import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/member_datasource.dart';
import 'package:withu/data/datasource/member_location_datasource.dart';
import 'package:withu/data/model/init_member.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/model/memberlocation.dart';
import 'package:withu/data/model/memberlocation_request.dart';

class MemberRepository {
  final MemberDataSource _dataSource = MemberDataSource();
  final MemberLocationDataSource _locationDataSource = MemberLocationDataSource();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Member? _member, _initMember;

  Future<Member?> getMember() async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    print(jwtToken);
    _member = await _dataSource.getMember(jwtToken);
    return _member;
  }

  Future<Member?> getMemberProfile(String email) async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    print(jwtToken);
    _member = await _dataSource.getMemberProfile(jwtToken, email);
    return _member;
  }

  Future<Member?> initMember(InitMember member) async {
    if(_initMember != null) {
      return _initMember;
    }
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    _initMember = await _dataSource.editMember(jwtToken, member);
    return _initMember;
  }

  Future<MemberLocation?> updateMemberLocation(MemberLocationRequest request) async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    return await _locationDataSource.editMemberLocation(jwtToken, request);
  }

  Future<MemberLocation?> getLeaderLocation() async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    return await _locationDataSource.getLeaderLocation(jwtToken);
  }
}