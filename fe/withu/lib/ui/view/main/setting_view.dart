import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/memberlocation_request.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/viewmodel/main/setting_viewmodel.dart';

import '../../../data/model/member.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingView();
}

class _SettingView extends State<SettingView> {
  late SettingViewModel _viewModel;
  bool _shareLoc = false, _comment = false;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<SettingViewModel>(context);
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(
          context, '설정', () => Navigator.pop(context)),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _addLeaderFindMenu(context),
                      _addAlertMenu(),
                          _addAccountMenu()
                    ])),
                Text('Team Code | 000000')
              ],
            )),
      ),
    );
  }

  Widget _addAccountMenu() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('계정 관리'),
          SizedBox(height: 24),
          Text('로그아웃'),
          SizedBox(height: 24),
          Text('회원 탈퇴'),
        ],
      ),
    );
  }

  Widget _addAlertMenu() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('알림'),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('좋아요'),
              CupertinoSwitch(
                  value: _shareLoc,
                  onChanged: (value) {
                    setState(() {
                      _shareLoc = value;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('댓글'),
              CupertinoSwitch(
                  value: _comment,
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget _addLeaderFindMenu(BuildContext context) {
    if (_viewModel.member.role! == 'LEADER') {
      return Container(
        height: 100,
        padding: EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('팀장 찾기'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('위치 공유하기'),
                GestureDetector(
                  child: Image.asset('assets/images/icon_right.png',
                      width: 24, height: 24),
                  onTap: () {
                    setLeaderPosition(context);
                  },
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> setLeaderPosition(BuildContext context) async {
    // 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();
    var result = await _viewModel.updateMemberLocation(MemberLocationRequest(
        latitude: position.latitude,
        longitude: position.longitude,
        message: '${_viewModel.member.name} 팀장님이 위치를 공유했습니다!'));
    if (result != null) {
      CustomDialog.showYesDialog(
          context, '알림', '위치 공유가 완료되었습니다.', () => Navigator.pop(context));
    }
  }
}
