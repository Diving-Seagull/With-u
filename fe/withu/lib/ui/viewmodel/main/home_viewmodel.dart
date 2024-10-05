import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/data/repository/member_repository.dart';
import 'package:withu/data/repository/notice_repository.dart';

import '../../../data/model/notice.dart';

class HomeViewModel with ChangeNotifier {
  final MemberRepository _repository = MemberRepository();
  final NoticeRepository _noticeRepository = NoticeRepository();

  Member? _member;
  Member?  get member => _member;
  Notice? pinnedNotice;

  Future<Member?> getMemberInfo() async {
    _member = await _repository.getMember();
    notifyListeners();
  }

  Future<void> getPinnedNotice() async {
    if(pinnedNotice == null) {
      pinnedNotice = await _noticeRepository.getPinnedTeamNotice();
      if(pinnedNotice != null) {
        notifyListeners();
      }
    }
  }
}