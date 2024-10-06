import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/memberlocation.dart';
import 'package:withu/data/repository/member_repository.dart';

import '../../../data/model/member.dart';

class FindLeaderViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();
  final Member member;
  MemberLocation? location;

  FindLeaderViewModel(this.member);

  Future<void> getLeaderLocation() async {
    if(location == null) {
      location = await _repository.getLeaderLocation();
      notifyListeners();
    }
  }
}