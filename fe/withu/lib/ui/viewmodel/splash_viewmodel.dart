import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/model/token_dto.dart';
import '../../data/repository/login_repository.dart';

class SplashViewModel with ChangeNotifier {
  late final LoginRepository _loginRepository;

  KakaoLoginApi kakaoLoginApi;
  OAuthToken? _tokenInfo;
  OAuthToken? get tokenInfo => _tokenInfo;

  SplashViewModel(this.kakaoLoginApi) {
    _loginRepository = LoginRepository();
  }

  // 카카오 토큰 유효성 검사
  Future<OAuthToken?> kakaoRecentLogin() async {
    OAuthToken? info = await kakaoLoginApi.checkRecentLogin();
    if (info != null) {
      print('액세스 토큰 정보 전달됨');
      _tokenInfo = info;
      return info;
    }
    return null;
  }

  Future<TokenDto?> getJwtToken(String token, String type) async {
    return await _loginRepository.getJwtToken(token, type);
  }
}
