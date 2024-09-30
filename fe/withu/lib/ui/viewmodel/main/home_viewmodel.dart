import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/repository/member_repository.dart';

class HomeViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();

  Member? _member;
  Member?  get member => _member;

  Future<Member?> getMemberInfo() async {
    _member = await _repository.getMember();
    notifyListeners();
  }
}