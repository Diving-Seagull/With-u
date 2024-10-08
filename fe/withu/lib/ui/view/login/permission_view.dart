import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:withu/ui/page/login/splash_page.dart';

class PermissionView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PermissionViewState();

}

class _PermissionViewState extends State<PermissionView> {

  Future<void> checkPermissionAndroid(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.bluetoothConnect,
      Permission.camera,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request();

    if (await Permission.location.isGranted != true) {
      openSetting();
      return;
    }
    if (await Permission.camera.isGranted != true) {
      openSetting();
      return;
    }
    if (await Permission.bluetoothScan.isGranted != true){
      openSetting();
      return;
    }
    if (await Permission.bluetoothAdvertise.isGranted != true){
      openSetting();
      return;
    }
    if (await Permission.bluetoothConnect.isGranted != true){
      openSetting();
      return;
    }

    if(context.mounted) {
      Navigator.pop(context);
      Navigator.push(
          context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SplashPage(),
          transitionDuration: Duration(seconds: 0)));
    }
  }

  Future<void> checkPermissioniOS(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.camera,
      Permission.bluetooth
    ].request();

    if (await Permission.location.isGranted != true) {
      openSetting();
      return;
    }
    if (await Permission.camera.isGranted != true) {
      openSetting();
      return;
    }
    if (await Permission.bluetooth.isGranted != true) {
      openSetting();
      return;
    }

    if(context.mounted) {
      Navigator.pop(context);
      Navigator.push(
          context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SplashPage(),
          transitionDuration: Duration(seconds: 0)));
    }
  }

  void openSetting(){
    openAppSettings();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(Platform.isAndroid) {
        await checkPermissionAndroid(context);
      }
      else {
        await checkPermissioniOS(context);
      }
    });
    return Scaffold();
  }
}
