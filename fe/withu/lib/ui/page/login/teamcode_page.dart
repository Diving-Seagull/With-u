import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/init_member.dart';
import 'package:withu/ui/view/login/teamcode_view.dart';
import 'package:withu/ui/viewmodel/login/teamcode_viewmodel.dart';

class TeamCodePage extends StatelessWidget {
  final InitMember _initMember;
  TeamCodePage(this._initMember, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<TeamCodeViewModel>(
      create: (_) => TeamCodeViewModel(_initMember),
      child: TeamCodeView(),
    );
  }

}