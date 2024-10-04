import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomModal {
  static void showBottomModal(BuildContext context, double width, Widget widget, Function onTap) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 400,
          height: 300, // 모달 높이 크기
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
}