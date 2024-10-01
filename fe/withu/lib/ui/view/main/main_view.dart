import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/empty_view.dart';
import 'package:withu/ui/viewmodel/main/main_viewmodel.dart';

import '../../../data/model/member.dart';
import '../../global/device_info.dart';

class MainView extends StatelessWidget {

  late MainViewModel _viewModel;

  void init(BuildContext context) async {
    if (_viewModel.member == null) {
      await _viewModel.getMemberInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<MainViewModel>(context);
    startAdvertisement();
    init(context);
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈')
        ]),
        tabBuilder: (context, index)  {
          switch(index){
            case 0:
              return HomePage(_viewModel.member);
            case 1:
              return SecondView();
            case 2:
              return ThirdView();
            default:
              return HomePage(_viewModel.member);
          }
        }
    );
  }

  // 팀원으로 로그인 시 Bluetooth Advertisement 활성화
  void startAdvertisement() async {
    try {
      // 현재 로그인한 디바이스 정보를 네이티브 코드에 전달
      await DeviceInfo.platform.invokeMethod('startAdvertising', {'deviceInfo': 'test' });
    } on PlatformException catch (e) {
      print("Failed to start advertising: '${e.message}'.");
    }
  }
}