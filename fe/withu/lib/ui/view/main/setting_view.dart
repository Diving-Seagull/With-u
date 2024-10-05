import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/memberlocation_request.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/viewmodel/main/setting_viewmodel.dart';

import '../../../data/model/member.dart';

class SettingView extends StatelessWidget {
  late SettingViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<SettingViewModel>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
          middle: Text('Cupertino Style UI',
              style: TextStyle(color: Colors.black))),
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Column(
          children: [_addLeaderFindMenu(context)],
        ),
      ),
    );
  }

  Widget _addLeaderFindMenu(BuildContext context) {
    if (_viewModel.member.role! == 'LEADER') {
      return Container(
        height: 100,
        padding: EdgeInsets.only(top: 14),
        child: Column(
          children: [
            Text('팀장 찾기'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('위치 공유하기'),
                GestureDetector(
                  child: Image.asset('assets/images/icon_right.png', width: 24, height: 24),
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
    var result = await _viewModel.updateMemberLocation(MemberLocationRequest(latitude: position.latitude,
        longitude: position.longitude, message: '${_viewModel.member.name} 팀장님이 위치를 공유했습니다!'));
    if(result != null) {
      CustomDialog.showYesDialog(context, '알림', '위치 공유가 완료되었습니다.', () => Navigator.pop(context));
    }
  }
}
