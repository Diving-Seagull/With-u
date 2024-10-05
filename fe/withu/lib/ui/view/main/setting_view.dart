import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/member.dart';

class SettingView extends StatelessWidget {
  final Member member;

  SettingView(this.member);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          children: [_addLeaderFindMenu()],
        ),
      ),
    );
  }

  Widget _addLeaderFindMenu() {
    if (member.role! == 'LEADER') {
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
                  child: Image.asset('assets/images/icon_right.png'),
                  onTap: () {},
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Scaffold();
    }
  }
}
