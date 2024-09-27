import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/extension/string_extension.dart';

import '../../../data/model/member.dart';
import '../../viewmodel/main/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  late HomeViewModel _homeViewModel;
  late double _deviceWidth, _deviceHeight;
  Member? _member;

  void init(BuildContext context) async {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    _member = await _homeViewModel.getMemberInfo();
    print(_member!.toJson());
    if(_member == null) {
      // 문제 발생 상황 -> 로그인 화면 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _topBar(),
                  _userInfoSection(),
                  _menuSection(),
                  _nowScheduleSection(),
                  _noticeSection(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 16.0, left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: _deviceWidth / 2,
              height: 50,
              child: Image.asset(
                'assets/images/logo_blue.png',
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              width: _deviceWidth / 2,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [Text('버튼1'), Text('버튼2')],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfoSection() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'data님,'.insertZwj(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            Text(
              'WYD 행사에 오신 것을 환영합니다.'.insertZwj(),
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.left,
            )
          ],
        ));
  }

  Widget _menuSection() {
    return Column(
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
                Flexible(flex: 1, child: _createMenuBtn('path', '멤버관리')),
                Flexible(flex: 1, child: _createMenuBtn('path', '인원확인')),
                Flexible(flex: 1, child: _createMenuBtn('path', '공지사항')),
                Flexible(flex: 1, child: _createMenuBtn('path', '관광지도'))
              ],
            ))
      ],
    );
  }

  Widget _createMenuBtn(String path, String name) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Column(
        children: [
          Container(
            height: (_deviceWidth / 4) - 20,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
          ),
          Padding(padding: EdgeInsets.only(top: 14), child: Text(name))
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        color: Colors.red,
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
                  margin: EdgeInsets.only(top: 0, bottom: 4, left: 0, right: 0),
                  child: Text('중요 공지!!',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                Text('description\ndescription',
                    style: TextStyle(fontSize: 12))
              ],
            ),
            Container(
              width: 90,
              height: 90,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
