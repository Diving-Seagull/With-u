import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../view/login/splash_view.dart';
import '../../viewmodel/login/splash_viewmodel.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
        create: (_) => SplashViewModel(),
        child: SplashView());
  }
}