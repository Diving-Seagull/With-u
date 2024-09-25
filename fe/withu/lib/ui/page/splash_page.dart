import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/view/splash_view.dart';

import '../../data/api/kakao_login.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
        create: (_) => SplashViewModel(),
        child: SplashView());
  }
}