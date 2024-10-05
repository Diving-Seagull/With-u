import 'package:flutter/cupertino.dart';
import 'package:withu/data/repository/team_repository.dart';

import '../../../data/model/member.dart';

class ManageTeamViewModel with ChangeNotifier {
  final TeamRepository _repository = TeamRepository();
  List<Member>? _memberList;
  List<Member> get memberList => _memberList ?? List.empty();

  Future<void> getTeamMember() async {
    if(_memberList == null) {
      _memberList = await _repository.getTeamMember();
      _memberList = _memberList?.where((value) => value.role == 'TEAMMATE').toList();
      notifyListeners();
    }
  }

  Future<int> removeTeamMember(int id) async {
    int? result = await _repository.removeTeamMember(id);
    if(result != null) {
      _memberList = null;
      return result;
    } else {
      return -1;
    }
  }
}