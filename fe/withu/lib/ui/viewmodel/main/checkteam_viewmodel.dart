import 'package:flutter/cupertino.dart';
import 'package:withu/data/repository/member_repository.dart';

import '../../../data/model/member.dart';

class TeammateViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();

  Future<List<Member>?> getTeamMember() async {
    return await _repository.getTeamMember();
  }

}