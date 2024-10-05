import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/team_datasource.dart';

import '../model/member.dart';

class TeamRepository {
  final TeamDataSource _dataSource = TeamDataSource();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Member>?> getTeamMember() async {
    String? jwtToken = await _storage.read(key: 'jwtToken') as String;
    return _dataSource.getTeamMember(jwtToken);
  }

  Future<int?> removeTeamMember(int id) async {
    String? jwtToken = await _storage.read(key: 'jwtToken') as String;
    return _dataSource.removeTeamMember(jwtToken, id);
  }
}