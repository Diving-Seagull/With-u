import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/login/add_info_viewmodel.dart';

import '../../view/login/add_info_view.dart';

class AddInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<AddInfoViewModel>(
      create: (_) => AddInfoViewModel(),
      child: AddInfoView()
    );
  }
  
}
