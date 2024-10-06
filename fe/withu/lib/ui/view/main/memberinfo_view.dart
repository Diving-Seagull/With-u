import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:withu/ui/global/custom_appbar.dart';

import '../../../data/model/member.dart';
import '../../global/color_data.dart';

class MemberInfoView extends StatefulWidget {
  final Member? member;

  MemberInfoView(this.member);

  @override
  State<StatefulWidget> createState() => _MemberInfoView(member);
}

class _MemberInfoView extends State<MemberInfoView>
    with SingleTickerProviderStateMixin {
  final Member? member;

  _MemberInfoView(this.member);

  late double _deviceWidth, _deviceHeight;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar.getTitleBar(context, '프로필'),
        body: SafeArea(
            child: Column(
          children: [
            _profileSection(),
          ],
        )));
  }

  Widget _profileSection() {
    return Expanded(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(top: 24, left: 18, bottom: 18),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(member!.profile,
                          width: 80, height: 80, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(width: 28),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(member!.name), Text(member!.description!)],
                ),
              ])),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 3,
              child: Container(
                  width: _deviceWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorData.COLOR_DARKGRAY),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CupertinoButton(
                      child: Text('프로필 수정'),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {}))),
          Flexible(
              flex: 1,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorData.COLOR_DARKGRAY),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CupertinoButton(
                      child: Image.asset('assets/images/icon_share.png',
                          width: 14, height: 14),
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      onPressed: () {})))
        ],
      ),
      SizedBox(height: 28),
      Container(
        height: 40,
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '게시물'),
            Tab(text: '스크랩'),
          ],
          labelColor: ColorData.COLOR_SUBCOLOR1,
          unselectedLabelColor: ColorData.COLOR_GRAY,
        ),
      )
    ]));
  }
}
