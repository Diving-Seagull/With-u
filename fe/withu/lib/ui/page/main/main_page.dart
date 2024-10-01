import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/main/main_viewmodel.dart';

import '../../view/main/main_view.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainViewModel>(
        create: (_) => MainViewModel(),
        child: MainView());
  }

}