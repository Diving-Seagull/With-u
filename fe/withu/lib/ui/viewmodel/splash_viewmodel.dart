import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/repository/UserRepository.dart';

class SplashViewModel with ChangeNotifier {
  KakaoLoginApi kakaoLoginApi;
  AccessTokenInfo? _tokenInfo;
  AccessTokenInfo? get tokenInfo => _tokenInfo;

  SplashViewModel({required this.kakaoLoginApi});

  // 카카오 토큰 유효성 검사
  Future<AccessTokenInfo?> kakaoRecentLogin() async {
    AccessTokenInfo? info = await kakaoLoginApi.checkRecentLogin();
    if (info != null) {
      print('액세스 토큰 정보 전달됨');
      _tokenInfo = info;
      return info;
    }
  }
}
