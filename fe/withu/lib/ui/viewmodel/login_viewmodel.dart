import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/api/google_login.dart';
import '../../data/model/token_dto.dart';
import '../../data/repository/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  late final KakaoLoginApi kakaoLoginApi;
  late final GoogleLoginApi googleLoginApi;

  late final LoginRepository _loginRepository;

  LoginViewModel() {
    _loginRepository = LoginRepository();
    kakaoLoginApi = KakaoLoginApi();
    googleLoginApi = GoogleLoginApi();
  }

  // 카카오 로그인
  Future<TokenDto?> setKakaoLogin() async {
    OAuthToken? token = await kakaoLoginApi.signWithKakao();
    if(token != null) {
      print(token.accessToken);
      return await _loginRepository.getJwtToken(token.accessToken, "kakao");
    }
    return null;
  }

  // 구글 로그인
  Future<TokenDto?> setGoogleLogin() async {
    GoogleSignInAccount? account = await googleLoginApi.signinWithGoogle();
    if(account != null) {
      GoogleSignInAuthentication auth = await account.authentication;
      print(auth.accessToken);
      if(auth.accessToken != null) {
        return await _loginRepository.getJwtToken(auth.accessToken!, "google");
      }
    }
    return null;
  }
}
