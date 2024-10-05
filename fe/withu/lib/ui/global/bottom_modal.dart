import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:withu/ui/global/color_data.dart';

class BottomModal {
  static void showBottomModal(BuildContext context, double width, Widget widget, Function onTap) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: width,
          height: 500, // 모달 높이 크기
          decoration: const BoxDecoration(
            color: Colors.white, // 모달 배경색
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), // 모달 좌상단 라운딩 처리
              topRight: Radius.circular(0), // 모달 우상단 라운딩 처리
            ),
          ),
          child: widget, // 모달 내부 디자인 영역
        );
      },
    );
  }

  static void showWarnModal(BuildContext context, double width, String text, String btnText, Function onTap) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: width,
          height: 200, // 모달 높이 크기
          decoration: const BoxDecoration(
            color: Colors.white, // 모달 배경색
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), // 모달 좌상단 라운딩 처리
              topRight: Radius.circular(0), // 모달 우상단 라운딩 처리
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon_warning.png', width: 36, height: 36),
              Text(text,
                  style: TextStyle(fontFamily:'Pretendard',
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Colors.black,
                      decoration: TextDecoration.none
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: CupertinoButton(
                      child: Text('닫기', style: TextStyle(color: Colors.black)),
                      color: ColorData.COLOR_LIGHTGRAY,
                      onPressed: () => Navigator.pop(context))),
                  Flexible(child: CupertinoButton(
                      child: Text(btnText, style: TextStyle(color: Colors.white)),
                      color: CupertinoDynamicColor.withBrightness(color: ColorData.COLOR_SUBCOLOR1, darkColor: ColorData.COLOR_SUBCOLOR1),
                      onPressed: onTap()))
                ],
              )
            ],
          ) // 모달 내부 디자인 영역
        );
      },
    );
  }
}