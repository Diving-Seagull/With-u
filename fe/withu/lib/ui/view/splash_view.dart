import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/token_dto.dart';
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

  void checkAuth() async {
    // await kakaoCheckAuth();
    // await googleCheckAuth();
    moveLoginScreen();
  }

  // 카카오 토큰 검사
  Future<void> kakaoCheckAuth() async {
    OAuthToken? tokenInfo = await viewModel.kakaoRecentLogin();
    print(tokenInfo);

    if (tokenInfo != null) {
      print('카카오 토큰 정보 불러옴');

      //JWT 토큰 요청
      TokenDto? jwtToken =
          await viewModel.getJwtToken(tokenInfo.accessToken, "kakao");
      if (jwtToken != null) {
        print('카카오 자동 로그인 성공 ${jwtToken.token}');

        return;
      }
    }
    print('카카오 자동 로그인 실패');
  }

  // 구글 토큰 검사
  Future<void> googleCheckAuth() async {
    GoogleSignInAuthentication? auth = await viewModel.googleRecentLogin();
    if (auth != null) {
      TokenDto? jwtToken =
          await viewModel.getJwtToken(auth.accessToken!, "google");
      print(jwtToken);

      if (jwtToken != null) {
        print('구글 자동 로그인 성공 ${jwtToken.token}');
        return;
      }
    }
    print('구글 자동 로그인 실패');
    moveLoginScreen();
  }

  void moveLoginScreen() {
    if (mounted) {
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: Container(
          height: double.infinity, // 너비 꽉 채우기
          width: double.infinity, // 높이 꽉 채우기
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 28, 72, 161),
          ),
          child: Image.asset('assets/images/logo_white.png')),
    ));
  }
}
