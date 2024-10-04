import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/notification_datasource.dart';
import 'package:withu/data/model/notification_request.dart';

class NotificationRepository {
  final NotificationDataSource _dataSource = NotificationDataSource();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> sendTeamNotice(int teamId, NotificationRequest request) async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    return _dataSource.sendTeamNotice(teamId, jwtToken, request);
  }
}