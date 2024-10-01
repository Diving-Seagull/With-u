import 'package:flutter/cupertino.dart';

import '../../../data/model/member.dart';
import '../../../data/repository/member_repository.dart';

class MainViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();

  Member? _member;
  Member?  get member => _member;

  Future<void> getMemberInfo() async {
    _member = await _repository.getMember();
    notifyListeners();
  }
}