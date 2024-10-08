import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../data/model/member.dart';
import '../../view/notice/notice_view.dart';
import '../../viewmodel/notice/notice_viewmodel.dart';

class NoticePage extends StatelessWidget {

  final Member? _member;
  const NoticePage(this._member, {super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoticeViewModel>(
        create: (_) => NoticeViewModel(),
        child: NoticeView(_member));
  }
}