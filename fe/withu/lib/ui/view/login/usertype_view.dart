import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/view/login/add_info_view.dart';

import '../../global/color_data.dart';
import '../../page/login/add_info_page.dart';

class UserTypeView extends StatelessWidget {
  late double _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(context, '역할 선택', () => Navigator.pop(context)),
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome!", style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 15),
            Text("역할을 선택해주세요!", style: TextStyle(
              fontSize: 14,
              color: ColorData.COLOR_DARKGRAY
            )),
            SizedBox(height: 60),
            Container( width: _deviceWidth, height: 58, child:CupertinoButton(child: Text('팀장으로 시작하기', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
                borderRadius: BorderRadius.circular(15),
                color: ColorData.COLOR_SUBCOLOR1,
                onPressed: () {
                  setUserType(context, 'LEADER');
                })),
            Padding(padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10)),
            Container(width: _deviceWidth, height: 58, child: CupertinoButton(child: Text('팀원으로 시작하기', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16
            )),
                borderRadius: BorderRadius.circular(15),
                color: ColorData.COLOR_GRAY,
                onPressed: () {
                  setUserType(context, 'TEAMMATE');
                }))
          ],
        )),
      ),
    ));
  }

  void setUserType(BuildContext context, String type) {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => AddInfoPage(type)));
  }
}
