import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/home_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

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