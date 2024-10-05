import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/timetable_datasource.dart';

import '../model/schedule.dart';

class TimeTableRepository {
  final TimeTableDataSource _dataSource = TimeTableDataSource();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Schedule>> getSchedules(String date) async {
    List<Schedule> result = [];
    String? jwtToken = await _storage.read(key: 'jwtToken') as String;
    var morning = await _dataSource.getMorningSchedules(jwtToken, date);
    if(morning != null) {
      result.addAll(morning);
    }

    var afternoon = await _dataSource.getAfternoonSchedules(jwtToken, date);
    if(afternoon != null) {
      result.addAll(afternoon);
    }
    return result;
  }
}