import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/token_dto.dart';
import 'package:withu/ui/page/login/login_page.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/main/home_view.dart';
import 'dart:async';

import 'package:withu/ui/viewmodel/login/splash_viewmodel.dart';

import '../../page/login/add_info_page.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<StatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel viewModel;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<SplashViewModel>(context, listen: false);
      Timer(Duration(seconds: 2), () {
        kakaoCheckAuth();
      });
    });
  }

  // 카카오 토큰 검사
  Future<void> kakaoCheckAuth() async {
    OAuthToken? tokenInfo = await viewModel.kakaoRecentLogin();
    if (tokenInfo != null) {
      print('카카오 토큰 정보 불러옴 ${tokenInfo.accessToken}');
      //JWT 토큰 요청
      TokenDto? jwtToken =
          await viewModel.getJwtToken(tokenInfo.accessToken, "kakao");

      if (jwtToken != null) {
        print('카카오 자동 로그인 성공 ${jwtToken.token}');
        await _storage.write(key: 'jwtToken', value: jsonEncode(jwtToken));
        // moveMainScreen();
        checkRegister();
        return;
      }
    }
    print('카카오 자동 로그인 실패');
    googleCheckAuth();
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
        await _storage.write(key: 'jwtToken', value: jsonEncode(jwtToken));
        // moveMainScreen();
        checkRegister();
        return;
      }
    }
    print('구글 자동 로그인 실패');
    moveLoginScreen();
  }

  void checkRegister() async {
    var member = await viewModel.getMember();
    if(member!.deviceUuid == null) {
      moveAddInfoScreen();
    }
    else {
      moveMainScreen();
    }
  }

  // 로그인 화면 이동
  void moveLoginScreen() {
    if (mounted) {
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => LoginPage()));
    }
  }

  // 유저 추가 정보 기입 화면 이동
  void moveAddInfoScreen() {
    if(mounted){
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AddInfoPage()));
    }
  }

  // 메인 화면 이동
  void moveMainScreen() {
    if (mounted) {
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => HomePage()));
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
