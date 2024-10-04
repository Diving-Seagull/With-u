import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/view/main/checkteam_view.dart';
import 'package:withu/ui/viewmodel/main/checkteam_viewmodel.dart';

class TeamMatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckteamViewModel>(
        create: (_) => CheckteamViewModel(),
        child: CheckTeamView());
  }
}