import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:withu/data/model/notice_request.dart';
import 'package:withu/data/repository/notice_repository.dart';

import '../../../data/model/notice.dart';

class AddNoticeViewModel with ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();
  List<XFile>? pickedFiles;

  void setPickedFiles(List<XFile> files) {
    pickedFiles = files;
    notifyListeners();
  }

  Future<Notice?> addNotice(String title, String content, bool pinned) async {
    NoticeRequest request = NoticeRequest(title: title, content: content, pinned: pinned,
        imageUrls: pickedFiles?.map((file) => file.path).toList() ?? List.empty());
    return await _repository.addTeamNotice(request);
  }
}