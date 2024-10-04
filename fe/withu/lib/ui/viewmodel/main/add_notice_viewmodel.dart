import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/notice_request.dart';
import 'package:withu/data/repository/notice_repository.dart';

import '../../../data/model/notice.dart';

class AddNoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();

  Future<Notice?> addNotice(NoticeRequest notice) async {
    return await _repository.addTeamNotice(notice);
  }
}
