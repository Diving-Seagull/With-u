import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../view/main/home_view.dart';
import '../../viewmodel/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
        child: HomeView());
  }
}