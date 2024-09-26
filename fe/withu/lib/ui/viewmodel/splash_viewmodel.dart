import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/google_login.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/model/token_dto.dart';
import '../../data/repository/login_repository.dart';

class SplashViewModel with ChangeNotifier {
  late final LoginRepository _loginRepository;
  late final GoogleLoginApi googleLoginApi;
  late final KakaoLoginApi kakaoLoginApi;

  OAuthToken? _tokenInfo;
  OAuthToken? get tokenInfo => _tokenInfo;

  SplashViewModel() {
    googleLoginApi = GoogleLoginApi();
    _loginRepository = LoginRepository();
    kakaoLoginApi = KakaoLoginApi();
  }

  // 카카오 토큰 유효성 검사
  Future<OAuthToken?> kakaoRecentLogin() async {
    OAuthToken? info = await kakaoLoginApi.checkRecentLogin();
    if (info != null) {
      print('액세스 토큰 정보 전달됨');
      _tokenInfo = info;
      return info;
    }
  }

  // 구글 토큰 유효성 검사
  Future<GoogleSignInAuthentication?> googleRecentLogin() async {
    GoogleSignInAccount? account = await googleLoginApi.checkRecentLogin();
    print('구글 기존 로그인 계정 정보 $account');
    if(account != null){
      GoogleSignInAuthentication auth = await account.authentication;
      return auth;
    }
    return null;
  }

  Future<TokenDto?> getJwtToken(String token, String type) async {
    return await _loginRepository.getRecentToken(token, type);
  }
}
