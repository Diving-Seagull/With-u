import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/notification_request.dart';
import 'package:withu/data/repository/member_repository.dart';
import 'package:withu/data/repository/team_repository.dart';

import '../../../data/model/member.dart';
import '../../../data/repository/notification_repository.dart';

class CheckteamViewModel with ChangeNotifier {
  final TeamRepository _memberRepository = TeamRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<Member>? _teamMemberList;
  List<Member> get teamMemberList => _teamMemberList ?? List.empty();

  Future<void> getTeamMember() async {
    if(_teamMemberList == null) {
      _teamMemberList = await _memberRepository.getTeamMember();
      _teamMemberList = _teamMemberList?.where((value) => value.role == 'TEAMMATE').toList();
      if(teamMemberList.isNotEmpty){
          notifyListeners();
      }
    }
  }

  Future<String?> sendTeamNotice(int teamId, NotificationRequest request) async {
    return await _notificationRepository.sendTeamNotice(teamId, request);
  }
}