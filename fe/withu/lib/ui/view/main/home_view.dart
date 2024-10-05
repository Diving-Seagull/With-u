import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:withu/extension/string_extension.dart';
import 'package:withu/ui/page/main/manageteam_page.dart';
import 'package:withu/ui/page/notice/notice_page.dart';
import 'package:withu/ui/page/main/checkteam_page.dart';
import 'package:withu/ui/view/timetable/timetable_view.dart';
import 'package:withu/ui/viewmodel/timetable/timetable_viewmodel.dart';

import '../../../data/model/member.dart';
import '../../global/color_data.dart';
import '../../global/convert_uuid.dart';
import '../../global/device_info.dart';
import '../../page/main/findleader_page.dart';
import '../../page/tour/tour_page.dart';
import '../../viewmodel/main/home_viewmodel.dart';
import '../empty_view.dart';
import 'setting_view.dart';


class HomeView extends StatelessWidget {
  var _isChecked = false;
  late HomeViewModel _homeViewModel;

  void init() async {
    if (_homeViewModel.member == null) {
      await _homeViewModel.getMemberInfo();
      startAdvertisement();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isChecked) {
        _isChecked = true;
        init();
      }
    });
    return SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '시간표'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '테스트2')
            ]),
            tabBuilder: (context, index) {
              if(index == 0) {
                return _HomeView(_homeViewModel);
              }
              else if(index == 1) {
                return ChangeNotifierProvider(
                    create: (_) => TimeTableViewModel(),
                    child: TimeTableView(),
                );
              }
              else {
                return ThirdView();
              }
            }
        )
    );
  }

  // 팀원으로 로그인 시 Bluetooth Advertising 활성화
  void startAdvertisement() async {
    // print(await DeviceInfo.getDeviceInfo());
    if(_homeViewModel.member!.role == 'TEAMMATE') {
      try {
        // 현재 로그인한 디바이스 정보를 네이티브 코드에 전달
        await DeviceInfo.platform.invokeMethod('startAdvertising',
            {'deviceUuid': ConvertUuid.nameUUIDFromBytes(_homeViewModel.member!.deviceUuid!) });
      } on PlatformException catch (e) {
        print("Failed to start advertising: '${e.message}'.");
      }
    }
  }
}


class _HomeView extends StatelessWidget {
  late final HomeViewModel _homeViewModel;

  _HomeView(this._homeViewModel);

  late double _deviceWidth, _deviceHeight;

  Future<void> init() async {
    _homeViewModel.pinnedNotice = null;
    await _homeViewModel.getPinnedNotice();
  }

  @override
  Widget build(BuildContext context) {
    //build 후 콜백 호출
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: _topBar(context),
        body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _userInfoSection(),
                    _menuSection(context),
                    _nowScheduleSection(),
                    _noticeSection(),
                  ],
                ),
              ),
            )
        );
  }


  PreferredSize _topBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: _deviceWidth / 2,
              height: 60,
              child: Image.asset(
                'assets/images/logo_blue.png',
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              width: _deviceWidth / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text('알림'),
                  ),
                  GestureDetector(
                      child: Text('설정'),
                      onTap: () {
                        if(_homeViewModel.member != null) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SettingView(_homeViewModel.member!)));
                          }
                        }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    )
    );
  }

  Widget _userInfoSection() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: Container(
          width: _deviceWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_homeViewModel.member?.name}님,'.insertZwj(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
              Text(
                'WYD 행사에 오신 것을\n환영합니다.',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '윗유를 통해 행사에 참여해보세요!',
                style: TextStyle(fontSize: 14, color: ColorData.COLOR_SEMIGRAY),
                textAlign: TextAlign.left,
              )
            ],
          ),
        )
    );
  }

  Widget _menuSection(BuildContext context) {
    if(_homeViewModel.member != null) {
      if(_homeViewModel.member!.role == 'LEADER') {
        return _leaderMenuSection(context);
      }
      else {
        return _memberMenuSection(context);
      }
    }
    else {
      return Container();
    }
  }

  Widget _createMemberMenuBtn(String name, String path, int cnt) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Container(
        height: (_deviceWidth / cnt) - 20,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: EdgeInsets.only(top: 24, bottom: 5, left: 32, right: 32),
                child: Image.asset(path, width: 40, height: 40)),
            Padding(padding: EdgeInsets.only(top: 0), child: Text(name, style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),))
          ],
        ),
      )
    );
  }

  Widget _createMenuBtn(String name, int cnt) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Column(
        children: [
          Container(
            height: (_deviceWidth / cnt) - 20,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
          ),
          Padding(padding: EdgeInsets.only(top: 14), child: Text(name))
        ],
      ),
    );
  }

  Widget _memberMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, //Column의 크기를 자식들의 크기에 맞게 최소화
        children: [
          Flexible(
              flex: 1,
              child: const Text('바로가기 >',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
          Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 1,
                      child: GestureDetector(
                          child: _createMemberMenuBtn('팀장찾기', 'assets/images/icon_findleader.png', 3),
                          onTap: () {
                            if(_homeViewModel.member != null) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => FindLeaderPage(_homeViewModel.member!)))
                                  .then((_) async => await init());
                            }
                          })),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                        child: _createMemberMenuBtn('공지사항', 'assets/images/icon_notification.png', 3),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => TeamMatePage()))
                              .then((_) async => await init());
                        },
                      )),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                          child: _createMemberMenuBtn('공지사항', 'assets/images/icon_tourmap.png', 3),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        NoticePage(_homeViewModel.member)))
                                .then((_) async => await init());
                          }))
                ],
              ))
        ],
      ),
    );
  }

  Widget _leaderMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, //Column의 크기를 자식들의 크기에 맞게 최소화
        children: [
          Flexible(
              flex: 1,
              child: const Text('바로가기 >',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
          Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 1,
                      child: GestureDetector(
                          child: _createMenuBtn('멤버관리', 4),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ManageTeamPage()))
                                .then((_) async => await init());
                          })),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                        child: _createMenuBtn('인원확인', 4),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => TeamMatePage()))
                              .then((_) async => await init());
                        },
                      )),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                          child: _createMenuBtn('공지사항', 4),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        NoticePage(_homeViewModel.member)))
                                .then((_) async => await init());
                          })),
                  Flexible(flex: 1, child: GestureDetector(
                      child: _createMenuBtn('관광지도', 4),
                      onTap: (){
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => TourPage()))
                            .then((_) async => await init());
                      }))
                ],
              ))
        ],
      ),
    );
  }

  Widget _nowScheduleSection() {
    return Container(
        width: _deviceWidth,
        height: 38,
        margin: EdgeInsets.only(top: 30, left: 0, right: 0, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('지금은 미사 시간입니다', textAlign: TextAlign.start),
              Text('시간', textAlign: TextAlign.end)
            ],
          ),
        ));
  }

  Widget _noticeSection() {
    return Container(
      width: _deviceWidth,
      height: 144,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('공지사항',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Container(
                  width:  _deviceWidth - 200,
                  margin: EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 0),
                  child: Text(_homeViewModel.pinnedNotice == null ? '공지사항이 없습니다.' : _homeViewModel.pinnedNotice!.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                Container(
                    width:  _deviceWidth - 200,
                    child: Text(_homeViewModel.pinnedNotice == null ? '공지사항이 없습니다.' : _homeViewModel.pinnedNotice!.content,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12,
                      color: ColorData.COLOR_SEMIGRAY,
                    ),
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
            SizedBox(
              width: 90,
              height: 90,
              child: _homeViewModel.pinnedNotice == null ? SizedBox() :
                      (_homeViewModel.pinnedNotice!.images.isNotEmpty ?
                      Image.file(File(_homeViewModel.pinnedNotice!.images.first.imageUrl), fit: BoxFit.cover) :
                      SizedBox())
            )
          ],
        ),
      ),
    );
  }
}
