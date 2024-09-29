import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/main/teammate_viewmodel.dart';

import '../../device_info.dart';

class TeamMateView extends StatelessWidget {

  late TeammateViewModel _viewModel;
  FlutterBlue flutterBlue = FlutterBlue.instance;

  void init() async {
    dynamic data = await DeviceInfo().getDeviceInfo();
    print(data);
    startScanForTeamMembers();
  }

  // 10초 간 스캔
  void startScanForTeamMembers() {
    flutterBlue.startScan(timeout: Duration(seconds: 10));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('Device Data found: ${r.device.name}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    _viewModel = Provider.of<TeammateViewModel>(context);
    return Scaffold(
      body: Text('팀원찾기'),
    );
  }
}