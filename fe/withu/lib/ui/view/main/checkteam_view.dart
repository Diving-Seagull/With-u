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
import 'package:withu/ui/viewmodel/main/checkteam_viewmodel.dart';

import '../../global/color_data.dart';
import '../../global/custom_appbar.dart';
import '../../global/custom_dialog.dart';
import '../../global/device_info.dart';

class CheckTeamView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckTeamView();
}

class _CheckTeamView extends State<CheckTeamView> {
  late CheckteamViewModel _viewModel;
  late List<String> _deviceList;
  List<Member> noMemberList = [], memberList = [];
  final List<String> _searchList = [];
  late double _deviceWidth, _deviceHeight;
  String _searchBtnText = '인원 확인하기';

  void init(BuildContext context) async {
    await _viewModel.getTeamMember();
    noMemberList  = _viewModel.teamMemberList;
    _deviceList =
        _viewModel.teamMemberList.map((data) => data.deviceUuid!).toList();
  }

  // 10초 간 스캔
  void startScanForTeamMembers(BuildContext context) async {
    var flutterBlue = FlutterBluePlus.instance;
    FlutterBluePlus.startScan(
        withServices: _deviceList
            .map((data) => Guid(ConvertUuid.nameUUIDFromBytes(data)))
            .toList(),
        timeout: Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // print('Device Data found: ${r.rssi.toString()}');
        print('Device found: ${r.device.name} (${r.device.id})');
        print('Advertisement Data: ${r.advertisementData.serviceUuids}');

        if (!_searchList.contains(r.advertisementData.serviceUuids.first.str)) {
          _searchList.add(r.advertisementData.serviceUuids.first.str);
        }
        // Manufacturer Data에서 팀 정보 추출
        // var deviceInfo = r.advertisementData.manufacturerData[0x004C] ?? [];
        // String hexString = deviceInfo.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        // print(String.fromCharCode(hexString.tora));
      }
    }, onError: (e) {
      print('Error During scan: $e');
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      if(!isScanning) {
        // 스캔 종료
        checkScanResult();
      }
    });
  }

  void checkScanResult() {
    setState(() {
      _searchBtnText = '인원 확인하기';
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<CheckteamViewModel>(context);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init(context);
    });

    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(
          context, '', () => Navigator.pop(context)),
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Padding(
              padding: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              bottom: 10, left: 0, right: 0, top: 0),
                          height: 84,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('팀원찾기',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                          )),
                      _noCheckView(),
                      _checkedView()
                    ],
                  )),
                  CupertinoButton (
                      child: Text(_searchBtnText),
                      color: _searchBtnText == '인원 확인하기' ? ColorData.COLOR_SUBCOLOR1 : ColorData.COLOR_SEMIGRAY,
                      onPressed: () {
                        if(_searchBtnText == '인원 확인하기') {
                          setState(() {
                            _searchBtnText = '확인 중';
                          });
                          startScanForTeamMembers(context);
                        }
                      })
                ],
              ))),
    );
  }

  Widget _noCheckView() {
    return Column(children: [
      Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('미확인'),
            SizedBox(
                width: 90,
                height: 32,
                child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    child: Text('알림 보내기',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                    onPressed: () {}))
          ],
        ),
      ),
      SizedBox(height: (_deviceHeight - 400) / 2 , child: ListView.builder(
              itemCount: noMemberList.length, // 데이터의 총 개수
              itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    child: Row(
                      children: [
                        Image.network(noMemberList[index].profile,
                            width: 40, height: 40),
                        Text(noMemberList[index].name),
                      ],
                    ),
                  );
              }
            )
      )
    ]);
  }

  Widget _checkedView() {
    return Column(children: [
      Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('확인 완료'),
            SizedBox(
                width: 90,
                height: 32)
          ],
        ),
      ),
      SizedBox(height: (_deviceHeight - 400) / 2, child: ListView.builder(
          itemCount: memberList.length, // 데이터의 총 개수
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              child: Row(
                children: [
                  Image.network(memberList[index].profile,
                      width: 40, height: 40),
                  Text(memberList[index].name),
                ],
              ),
            );
          }
      )
      )
    ]);
  }
}
