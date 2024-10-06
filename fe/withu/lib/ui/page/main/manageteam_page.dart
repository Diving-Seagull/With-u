import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/main/manageteam_viewmodel.dart';

import '../../view/main/manageteam_view.dart';

class ManageTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ManageTeamViewModel>(
        create: (_) => ManageTeamViewModel(),
        child: ManageTeamView());
  }

}