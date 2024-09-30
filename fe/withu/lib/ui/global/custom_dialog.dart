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
}