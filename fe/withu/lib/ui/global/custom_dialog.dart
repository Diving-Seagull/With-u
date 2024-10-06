import 'package:flutter/cupertino.dart';

class CustomDialog {
  static void showYesDialog(BuildContext context, String title, String message, Function() function) {
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: function)
        ],
      );
    });
  }

  static void showYesNoDialog(BuildContext context, String title, String message, Function() yesFunc, Function() noFunc) {
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: noFunc),
          CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: yesFunc)
        ],
      );
    });
  }
}