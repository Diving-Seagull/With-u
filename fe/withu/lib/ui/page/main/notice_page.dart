import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../view/main/notice_view.dart';
import '../../viewmodel/main/notice_viewmodel.dart';

class NoticePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoticeViewModel>(
        create: (_) => NoticeViewModel(),
        child: NoticeView());
  }
}