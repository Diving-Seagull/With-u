import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/page/login/add_info_page.dart';
import 'package:withu/ui/view/main/main_view.dart';
import 'package:withu/ui/viewmodel/login/login_viewmodel.dart';

import '../../../data/model/token_dto.dart';

class LoginView extends StatelessWidget {
  late final LoginViewModel _viewModel;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _viewModel = Provider.of<LoginViewModel>(context); //ViewModel 가져오기
    return Scaffold( // AppBar 없애기
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _kakaoLoginBtn(context),
            _googleLoginBtn(context)
          ],
        ),
      ),
    );
  }

  Widget _googleLoginBtn(BuildContext context) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: CupertinoButton.filled(
        onPressed: () async {
          TokenDto? jwt = await _viewModel.setGoogleLogin();
          if(jwt != null) {
            print('구글 로그인 성공 ${jwt.token}');
            await _storage.write(key: 'jwtToken', value: jsonEncode(jwt));
            // 메인 화면 이동
            if(context.mounted) {
              // moveMainScreen(context);
              moveAddInfoScreen(context);
            }
          }
        }, child: Text('구글 로그인'),
      )
  );

  Widget _kakaoLoginBtn(BuildContext context) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: CupertinoButton.filled(
      onPressed: () async {
        TokenDto? jwt = await _viewModel.setKakaoLogin();
        if(jwt != null) {
          print('카카오 로그인 성공 $jwt');
          await _storage.write(key: 'jwtToken', value: jsonEncode(jwt));
          // 메인 화면 이동
          if(context.mounted){
            // moveMainScreen(context);
            moveAddInfoScreen(context);
          }
        }
      }, child: Text('카카오 로그인'),
    )
  );

  // 메인 화면 이동
  void moveMainScreen(BuildContext context) {
    if(context.mounted){
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => MainView()));
    }
  }

  // 유저 추가 정보 기입 화면 이동
  void moveAddInfoScreen(BuildContext context) {
    if(context.mounted){
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AddInfoPage()));
    }
  }
}
