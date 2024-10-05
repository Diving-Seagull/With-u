import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/schedule.dart';
import 'package:withu/data/repository/timetable_repository.dart';

class TimeTableViewModel with ChangeNotifier {
  final TimeTableRepository _repository = TimeTableRepository();
  List<Schedule> scheduleList = [];
  var scheduleFlag = false;

  Future<void> getSchedules(String date) async {
    print(date);
    if(scheduleFlag == false) {
      scheduleFlag = true;
      scheduleList = await _repository.getSchedules(date);
      if(scheduleList.isNotEmpty) {
        notifyListeners();
      }
    }
  }
}
