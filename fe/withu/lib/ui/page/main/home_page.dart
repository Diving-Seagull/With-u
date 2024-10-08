import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/main/home_viewmodel.dart';
import '../../view/main/home_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
        child: HomeView());
  }
}