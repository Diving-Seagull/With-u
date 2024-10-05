import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/memberlocation.dart';
import 'package:withu/data/model/memberlocation_request.dart';
import 'package:withu/data/repository/member_repository.dart';

import '../../../data/model/member.dart';

class SettingViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();
  final Member member;
  SettingViewModel(this.member);

  Future<MemberLocation?> updateMemberLocation(MemberLocationRequest request) async {
    return await _repository.updateMemberLocation(request);
  }
}