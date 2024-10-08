import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:withu/ui/global/color_data.dart';
import 'package:withu/ui/page/login/login_page.dart';
import 'package:withu/ui/view/login/permission_view.dart';
import 'package:withu/ui/view/login/usertype_view.dart';
import 'firebase_options.dart';

// 최상단에 위치해 있어야 함.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 상태에서 수신된 메시지 처리
  print("Handling a background message: ${message.messageId}");
  showFlutterNotification(message);
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final  AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

void main() async {
  // 프레임워크 초기화 여부 확인 (비동기 작업 시 수행)
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드로만 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // env 파일 로드
  await dotenv.load(fileName: 'assets/config/.env');

  String? naverMapKey = dotenv.env['NAVER_MAP_KEY'];

  //NaverMap 초기화
  await NaverMapSdk.instance.initialize(
    clientId: naverMapKey,
    onAuthFailed: (e) => print('네이버맵 인증오류 : $e')
  );

  //Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FCM 설정
  await fcmSetting();

  //Firebase 포그라운드 메시지 핸들러 등록
  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  // Firebase 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  String? kakaoNativeAppKey = dotenv.env['KAKAO_APP_KEY'];
  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);

  // await UserApi.instance.logout();
  // await GoogleSignIn().signOut();

  runApp(const MyApp());
}

Future<void> fcmSetting() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {

    var initialzationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettingsAndroid = const AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initialzationSettingsIOS);

    if(Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (notificationResponse) {
            // notification 클릭 이벤트
            print('notification 클릭 이벤트 발생!');
            // notification 데이터 불러오기
            // notificationResponse.payload
          }
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
    else if(Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // await _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     IOSFlutterLocalNotificationsPlugin>()
    //     ?.getActiveNotifications();
  }

  // 토큰 발급
  await addFcmToken();
}

Future<void> addFcmToken() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: "fcmtoken");
  print('saved : ${token}');
  // print('fcm $token');
  // if(token == null){
  //   var fcmToken = await FirebaseMessaging.instance.getToken();
  //   if(fcmToken != null){
  //     await storage.write(key: "fcmtoken", value: fcmToken);
  //     print('fcm 토큰 저장 완료 ${await storage.read(key: "fcmtoken")}');
  //   }
  // }
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  await storage.write(key: "fcmtoken", value: fcmToken);
  print('Firebase Token Saved : ${fcmToken}');
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (message.notification != null && android != null) {
    _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.systemGrey, // 원하는 색상으로 변경
      statusBarBrightness: Brightness.light, // 상태바의 아이콘 색상 (밝은 배경에 어두운 아이콘)
    ));



    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: CupertinoColors.white,
          focusColor: ColorData.COLOR_SUBCOLOR1
      ),
      home: PermissionView(),
    );
  }
}