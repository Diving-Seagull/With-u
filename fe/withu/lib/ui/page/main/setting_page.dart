import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/main/setting_viewmodel.dart';

import '../../../data/model/member.dart';
import '../../view/main/setting_view.dart';

class SettingPage extends StatelessWidget {
  final Member member;

  const SettingPage(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
        create: (_) => SettingViewModel(member), child: SettingView());
  }
}
