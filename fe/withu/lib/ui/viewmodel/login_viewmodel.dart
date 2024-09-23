import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../data/repository/UserRepository.dart';

class LoginViewModel with ChangeNotifier {
  User? _user;
  KakaoLoginApi kakaoLoginApi;

  User? get user => _user;

  late final UserRepository _userRepository;

  LoginViewModel({required this.kakaoLoginApi}) {
    _userRepository = UserRepository();
  }

  // 카카오 로그인
  void kakaoLogin() async {
    kakaoLoginApi.signWithKakao().then((user) {
      // 반환된 값이 NULL이 아니라면
      // 정보 전달
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    });
  }

  // 카카오 토큰 유효성 검사
  void kakaoRecentLogin() async {
    kakaoLoginApi.checkRecentLogin().then((token){
      if(token != null){
        print('액세스 토큰 정보 전달됨');
      }
    });
  }
}
