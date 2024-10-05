import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/init_member.dart';

import '../../../data/model/member.dart';
import '../../../data/repository/member_repository.dart';

class AddInfoViewModel with ChangeNotifier {
  String type;
  AddInfoViewModel(this.type);

  final MemberRepository _repository = MemberRepository();

  Member? _member;
  Member?  get member => _member;

  Future<void> getMemberInfo() async {
    _member = await _repository.getMember();
    if(_member != null) {
      notifyListeners();
    }
  }

  Future<Member?> initMemberInfo(InitMember member) async {
    return await _repository.initMember(member);
  }
}