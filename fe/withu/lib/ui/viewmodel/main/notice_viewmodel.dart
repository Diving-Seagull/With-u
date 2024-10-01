import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/data/repository/notice_repository.dart';

class NoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();
  List<Notice>? _noticeList;
  List<Notice> get noticeList => _noticeList ?? List.empty();


  Future<void> getTeamNotice(int teamId) async {
     _noticeList ??= await _repository.getTeamNotice(teamId);
    notifyListeners();
  }
}