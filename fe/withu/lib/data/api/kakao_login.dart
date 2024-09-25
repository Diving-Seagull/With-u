import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginApi {
  final UserApi api = UserApi.instance;

  signWithKakao() async {
    // 카카오톡 설치 여부 확인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        TokenManagerProvider.instance.manager.setToken(token);
        print('카카오톡으로 로그인 성공');
        return token;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          TokenManagerProvider.instance.manager.setToken(token);
          return token;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    }
    // 카카오톡이 설치되어 있지 않다면 카카오계정으로 로그인
    else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        TokenManagerProvider.instance.manager.setToken(token);
        return token;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  // 기존 로그인 정보 검사
  checkRecentLogin() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        return TokenManagerProvider.instance.manager.getToken();
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음');
    }
  }
}