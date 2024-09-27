import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/repository/member_repository.dart';

class HomeViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();

  Future<Member?> getMemberInfo() async {
    return await _repository.getMember();
  }
}