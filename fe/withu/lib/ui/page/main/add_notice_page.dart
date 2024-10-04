import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../view/login/add_info_view.dart';
import '../../view/main/add_notice_view.dart';
import '../../viewmodel/main/add_notice_viewmodel.dart';

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
