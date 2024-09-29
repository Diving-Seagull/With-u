import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/empty_view.dart';
import 'package:withu/ui/viewmodel/main/home_viewmodel.dart';

import '../../../data/model/member.dart';

class MainView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈')
        ]),
        tabBuilder: (context, index)  {
          switch(index){
            case 0:
              return HomePage();
            case 1:
              return SecondView();
            case 2:
              return ThirdView();
            default:
              return HomePage();
          }
        }
    );
  }
}