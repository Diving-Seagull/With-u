import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/view/main/teammate_view.dart';
import 'package:withu/ui/viewmodel/main/teammate_viewmodel.dart';

class TeamMatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeammateViewModel>(
        create: (_) => TeammateViewModel(),
        child: TeamMateView());
  }
}