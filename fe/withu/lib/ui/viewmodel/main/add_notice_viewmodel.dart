import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:withu/data/model/notice_request.dart';
import 'package:withu/data/repository/notice_repository.dart';

import '../../../data/model/notice.dart';

class AddNoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();
  List<XFile>? pickedFiles;

  Future<Notice?> addNotice(NoticeRequest notice) async {
    return await _repository.addTeamNotice(notice);
  }
}
