import 'package:flutter/cupertino.dart';
import 'package:withu/data/repository/member_repository.dart';

import '../../../data/model/member.dart';

class CheckteamViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();
  List<Member>? _teamMemberList;
  List<Member> get teamMemberList => _teamMemberList ?? List.empty();

  Future<void> getTeamMember() async {
    if(_teamMemberList == null) {
      _teamMemberList = await _repository.getTeamMember();
      notifyListeners();
    }
  }
}