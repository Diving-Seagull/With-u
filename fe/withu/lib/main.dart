import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/ui/page/splash_page.dart';
import 'firebase_options.dart';

void main() async{
  await dotenv.load(fileName: 'assets/config/.env'); // env 파일 로드
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized(); // 프레임워크 초기화 여부 확인 (비동기 작업 시 수행)
  String? kakaoNativeAppKey = dotenv.env['KAKAO_APP_KEY'];
  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}