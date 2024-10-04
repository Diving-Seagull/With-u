import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../view/login/add_info_view.dart';
import '../../view/notice/add_notice_view.dart';
import '../../viewmodel/notice/add_notice_viewmodel.dart';

class AddNoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<AddNoticeViewModel>(
        create: (_) => AddNoticeViewModel(),
        child: AddNoticeView()
    );
  }

}
