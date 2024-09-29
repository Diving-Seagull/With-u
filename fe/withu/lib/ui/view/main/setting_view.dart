import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Cupertino Style UI', style: TextStyle(color: Colors.black))
    ),
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Column(
            children: const <Widget>[
              Text("ABC")
            ],
          ),
        ),
    );
  }
}
