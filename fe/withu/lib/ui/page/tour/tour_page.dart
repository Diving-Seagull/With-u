import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/tour/tour_viewmodel.dart';

import '../../view/tour/tour_view.dart';

class TourPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<TourViewModel>(
        create: (_) => TourViewModel(),
        child: TourView());
  }

}
