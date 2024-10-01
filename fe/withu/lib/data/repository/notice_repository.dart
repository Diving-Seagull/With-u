import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/notice_datasource.dart';
import 'package:withu/data/model/notice.dart';

class NoticeRepository {
  final NoticeDataSource _dataSource = NoticeDataSource();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<Notice>?> getTeamNotice() async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    return _dataSource.getTeamNotice(jwtToken);
  }
}