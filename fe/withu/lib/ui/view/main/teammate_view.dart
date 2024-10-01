import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/member.dart';
import 'package:withu/ui/viewmodel/main/teammate_viewmodel.dart';

import '../../global/device_info.dart';

class TeamMateView extends StatelessWidget {

  late TeammateViewModel _viewModel;
  List<Member>? _memberList;
  late List<String> _deviceList;

  void init() async {
    if(_memberList == null) {
      _memberList = await _viewModel.getTeamMember();
      var data = await DeviceInfo.getDeviceInfo();
      print(data);
      _deviceList = _memberList!.map((data) => data.deviceUuid!).toList();
      startScanForTeamMembers();
    }
  }

  // 10초 간 스캔
  void startScanForTeamMembers() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('Device Data found: ${r.rssi.toString()}');
        // Manufacturer Data에서 팀 정보 추출
        String teamInfo = String.fromCharCodes(r.advertisementData.manufacturerData[0x004C] ?? []);
        print(teamInfo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<TeammateViewModel>(context);
    init();
    return Scaffold(
      body: Text('팀원찾기'),
    );
  }
}