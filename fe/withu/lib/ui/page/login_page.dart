import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/api/kakao_login.dart';
import 'package:withu/ui/view/login_view.dart';
import 'package:withu/ui/viewmodel/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (_) => LoginViewModel(
          kakaoLoginApi: KakaoLoginApi(),
        ),
        child: LoginView());
  }
}
