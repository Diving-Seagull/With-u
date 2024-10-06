import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/data/api/kakao_login.dart';

import '../../../data/api/google_login.dart';
import '../../../data/model/token_dto.dart';
import '../../../data/repository/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  final KakaoLoginApi _kakaoLoginApi = KakaoLoginApi();
  final GoogleLoginApi _googleLoginApi = GoogleLoginApi();
  final LoginRepository _loginRepository = LoginRepository();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // 카카오 로그인
  Future<TokenDto?> setKakaoLogin() async {
    OAuthToken? token = await _kakaoLoginApi.signWithKakao();
    if(token != null) {
      print('카카오 토큰 : ${token.accessToken}');
      String? fcmToken = await storage.read(key: 'fcmtoken');
      return await _loginRepository.getNewToken(token.accessToken, fcmToken, "kakao");
    }
    return null;
  }

  // 구글 로그인
  Future<TokenDto?> setGoogleLogin() async {
    GoogleSignInAccount? account = await _googleLoginApi.signinWithGoogle();
    if(account != null) {
      GoogleSignInAuthentication auth = await account.authentication;
      print(auth.accessToken);
      if(auth.accessToken != null) {
        String? fcmToken = await storage.read(key: 'fcmtoken');
        return await _loginRepository.getNewToken(auth.accessToken!, fcmToken, "google");
      }
    }
    return null;
  }
}
