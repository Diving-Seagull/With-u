import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/login_viewmodel.dart';

import '../../data/model/token_dto.dart';

class LoginView extends StatelessWidget {
  late LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    viewModel = Provider.of<LoginViewModel>(context); //ViewModel 가져오기
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ), // AppBar 없애기
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
          TokenDto? jwt = await viewModel.setGoogleLogin();
          if(jwt != null) {
            print('구글 로그인 성공 $jwt');
          }
        }, child: Text('구글 로그인'),
      )
  );

  Widget _kakaoLoginBtn(BuildContext context) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: CupertinoButton.filled(
      onPressed: () async {
        TokenDto? jwt = await viewModel.setKakaoLogin();
        if(jwt != null) {
          print('카카오 로그인 성공 $jwt');
        }
      }, child: Text('카카오 로그인'),
    )
  );


}
