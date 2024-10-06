import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/page/login/add_info_page.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/login/usertype_view.dart';
import 'package:withu/ui/view/main/home_view.dart';
import 'package:withu/ui/viewmodel/login/login_viewmodel.dart';

import '../../../data/model/token_dto.dart';
import '../../global/color_data.dart';

class LoginView extends StatelessWidget {
  late final LoginViewModel _viewModel;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _viewModel = Provider.of<LoginViewModel>(context); //ViewModel 가져오기
    return Scaffold( // AppBar 없애기
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
              child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome!", style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 15),
            Text("3초만에 시작해보세요!", style: TextStyle(
                fontSize: 14,
                color: ColorData.COLOR_DARKGRAY
            )),
            SizedBox(height: 60),
            _kakaoLoginBtn(context),
            _googleLoginBtn(context)
          ],
        ),
      ))),
    );
  }

  Widget _googleLoginBtn(BuildContext context) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorData.COLOR_GRAY)
          ),
          child: CupertinoButton(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        onPressed: () async {
          TokenDto? jwt = await _viewModel.setGoogleLogin();
          if(jwt != null) {
            print('구글 로그인 성공 ${jwt.token}');
            await _storage.write(key: 'jwtToken', value: jsonEncode(jwt));
            // 메인 화면 이동
            if(context.mounted) {
              // moveMainScreen(context);
              // moveAddInfoScreen(context);
              moveTypeScreen(context);
            }
          }
        }, child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: Image.asset('assets/images/google.png', width: 20, height: 20)),
          Flexible(flex: 3, child: Text('Google로 시작하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)))
        ],
      ),
      ))
  );

  Widget _kakaoLoginBtn(BuildContext context) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 58,
          child: CupertinoButton(
        color: Color(0xFFFDE500),
      onPressed: () async {
        TokenDto? jwt = await _viewModel.setKakaoLogin();
        if(jwt != null) {
          print('카카오 로그인 성공 ${jwt.token}');
          await _storage.write(key: 'jwtToken', value: jsonEncode(jwt));
          // 메인 화면 이동
          if(context.mounted){
            // moveMainScreen(context);
            moveTypeScreen(context);
          }
        }
      }, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: Image.asset('assets/images/kakao.png', width: 20, height: 20)),
          Flexible(flex: 3, child: Text('카카오로 시작하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)))
        ]
      ),
    ))
  );


  void moveTypeScreen(BuildContext context) {
    if(context.mounted){
      Navigator.pop(context); //Splash 화면 제거
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => UserTypeView()));
    }
  }
}
