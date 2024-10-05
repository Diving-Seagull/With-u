import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/model/schedule.dart';
import 'package:withu/data/repository/member_repository.dart';
import 'package:withu/data/repository/notice_repository.dart';
import 'package:withu/data/repository/timetable_repository.dart';

import '../../../data/model/notice.dart';

class HomeViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();
  final NoticeRepository _noticeRepository = NoticeRepository();
  final TimeTableRepository _timeTableRepository = TimeTableRepository();

  Member? _member;
  Member?  get member => _member;
  Notice? pinnedNotice;

  Schedule? schedule;
  bool isPinChecked = false, isTodayChecked = false;

  Future<void> getMemberInfo() async {
    _member = await _repository.getMember();
    notifyListeners();
  }

  Future<void> getPinnedNotice() async {
    if(!isPinChecked) {
      pinnedNotice = await _noticeRepository.getPinnedTeamNotice();
      isPinChecked = true;
      notifyListeners();
    }
  }

  Future<void> getRecentSchedule() async {
    if(!isTodayChecked) {
      // var now = DateTime.now();
      var now = DateTime.parse('2024-10-30 11:10:00');
      var resultList = await _timeTableRepository.getSchedules(DateFormat('yyyy-MM-dd').format(now));

      schedule = resultList.where((data) => now.isAfter(data.startTime) && now.isBefore(data.endTime)).firstOrNull;

      if(schedule != null){
        notifyListeners();
      }
      isTodayChecked = true;
    }
  }
}