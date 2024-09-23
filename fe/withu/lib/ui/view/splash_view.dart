import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/page/login_page.dart';
import 'dart:async';

import 'package:withu/ui/viewmodel/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<StatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel = Provider.of<SplashViewModel>(context, listen: false);
      Timer(Duration(seconds: 2), () {
        // Navigator.pop(context); //Splash 화면 제거
        checkAuth();
      });
    });
  }

  void checkAuth() {
     kakaoCheckAuth();
  }

  void kakaoCheckAuth() async{
    AccessTokenInfo? tokenInfo = await viewModel.kakaoRecentLogin();
    print(tokenInfo);
    if (tokenInfo != null) {
      print('토큰 정보 불러옴');
      moveMainScreen();
    } else {
      if (mounted) {
        moveLoginScreen();
      }
    }
  }

  void moveMainScreen(){

  }

  void moveLoginScreen(){
    Navigator.pop(context); //Splash 화면 제거
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        // child: Image.asset('assets/test.jpg'),
        child: Text("withu"),
      ),
    );
  }
}
