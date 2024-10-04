import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/data/repository/notice_repository.dart';

class NoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();
  List<Notice>? _noticeList;
  List<Notice> get noticeList => _noticeList ?? List.empty();


  Future<void> getTeamNotice(bool isNew) async {
    if(_noticeList == null || isNew == true) {
      _noticeList = await _repository.getTeamNotice() ?? List.empty();
      notifyListeners();
    }
  }
}