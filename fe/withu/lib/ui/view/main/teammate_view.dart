import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/ui/global/convert_uuid.dart';
import 'package:withu/ui/viewmodel/main/teammate_viewmodel.dart';

import '../../global/custom_dialog.dart';
import '../../global/device_info.dart';

class TeamMateView extends StatelessWidget {

  late TeammateViewModel _viewModel;
  List<Member>? _memberList;
  late List<String> _deviceList;

  void init(BuildContext context) async {
    if(_memberList == null) {
      _memberList = await _viewModel.getTeamMember();
      var data = await DeviceInfo.getDeviceInfo();
      print(data);
      _deviceList = _memberList!.map((data) => data.deviceUuid!).toList();
      startScanForTeamMembers(context);
    }
  }

  // 10초 간 스캔
  void startScanForTeamMembers(BuildContext context) async {
    FlutterBluePlus.startScan(withServices: [Guid(ConvertUuid.nameUUIDFromBytes('51CEE9EF-2925-425C-8DC4-CCC24C3ED886'))], timeout: Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // print('Device Data found: ${r.rssi.toString()}');
        print('Device found: ${r.device.name} (${r.device.id})');
        print('Advertisement Data: ${r.advertisementData.serviceUuids}');
        // Manufacturer Data에서 팀 정보 추출
        // var deviceInfo = r.advertisementData.manufacturerData[0x004C] ?? [];
        // String hexString = deviceInfo.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        // print(String.fromCharCode(hexString.tora));
      }
    },
      onError: (e) {
        print('Error During scan: $e');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<TeammateViewModel>(context);
    init(context);
    return Scaffold(
      body: Text('팀원찾기'),
    );
  }
}