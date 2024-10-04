import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInfo {

  static const platform = MethodChannel('com.divingseagull.withu/advertise');

  static Future<Map<String, String>> getDeviceInfo() async {

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String device_id = '';	//기기 고유번호
    String device_type = '';	//기기 종류

    try {
      if (Platform.isAndroid) {	//안드로이드
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        device_id = androidInfo.androidId; // 안드로이드 기기 고유 번호
        device_type = androidInfo.model;
      } else if (Platform.isIOS) {	//ios
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        device_id = iosInfo.identifierForVendor; // iOS 기기 고유 번호
        device_type = iosInfo.model;
      }
    } on PlatformException {	//예외 발생
      device_id = '';
      device_type = '';
    }
    return {'device_type': device_type, 'device_id': device_id};
  }
}