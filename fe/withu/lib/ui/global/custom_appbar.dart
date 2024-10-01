import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar {

  static PreferredSizeWidget getNavigationBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        height: 80,
        child: CupertinoNavigationBar(
          leading: Align(
            widthFactor: 1.0,
            alignment: Alignment.center,
            child: GestureDetector(child: Image.asset('assets/images/icon_left.png'), onTap: () {
              Navigator.pop(context);
            }),
          ),
          middle: Text(title),
          border: Border(bottom: BorderSide(color: Colors.transparent)), //그림자 제거
        ),
      ),
    );
  }
}