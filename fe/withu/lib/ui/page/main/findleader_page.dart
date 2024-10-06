import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../data/model/member.dart';
import '../../view/main/findleader_view.dart';
import '../../viewmodel/main/findleader_viewmodel.dart';

class FindLeaderPage extends StatelessWidget {
  final Member member;
  FindLeaderPage(this.member);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FindLeaderViewModel>(
        create: (_) => FindLeaderViewModel(member),
        child: FindLeaderView());
  }
}