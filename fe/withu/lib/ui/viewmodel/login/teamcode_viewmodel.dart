import 'package:flutter/cupertino.dart';

import '../../../data/model/init_member.dart';
import '../../../data/model/member.dart';
import '../../../data/repository/member_repository.dart';

class TeamCodeViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();

  final InitMember initMember;
  TeamCodeViewModel(this.initMember);

  Future<Member?> initMemberInfo(String teamCode) async {
    print(teamCode);
    initMember.teamCode = teamCode;
    print(initMember);
    return await _repository.initMember(initMember);
  }
}