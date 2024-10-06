import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:withu/data/api/image_convert.dart';
import 'package:withu/data/model/notice_image_request.dart';
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
    List<NoticeImageRequest> dataList = [];
    for(var data in pickedFiles!) {
      var encode = await ImageConvert.convertFileToBase64(data);
      dataList.add(NoticeImageRequest(base64Data: encode, contentType: 'image/jpeg'));
    }

    NoticeRequest request = NoticeRequest(title: title, content: content, pinned: pinned,
        images: dataList);
    return await _repository.addTeamNotice(request);
  }
}