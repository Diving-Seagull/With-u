import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/data/repository/notice_repository.dart';

class NoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();
  List<Notice>? _noticeList;
  List<Notice> get noticeList => _noticeList ?? List.empty();
  Notice? pinnedNotice;

  Future<void> getTeamNotice(bool isNew) async {
    if(_noticeList == null || isNew == true) {
      _noticeList = await _repository.getTeamNotice() ?? List.empty();
      notifyListeners();
    }
  }

  Future<void> getPinnedNotice(bool isNew) async {
    if(pinnedNotice == null || isNew == true) {
      pinnedNotice = await _repository.getPinnedTeamNotice();
      if(pinnedNotice != null) {
        notifyListeners();
      }
    }
  }
}