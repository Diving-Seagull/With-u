import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/model/token_dto.dart';
import '../../data/repository/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  KakaoLoginApi kakaoLoginApi;

  late final LoginRepository _loginRepository;

  LoginViewModel({required this.kakaoLoginApi}) {
    _loginRepository = LoginRepository();
  }

  // 카카오 로그인
  Future<TokenDto?> kakaoLogin() async {
    OAuthToken? token = await kakaoLoginApi.signWithKakao();
    if(token != null) {
      print(token.accessToken);
      return await _loginRepository.getJwtToken(token.accessToken, "kakao");
    }
  }
}
