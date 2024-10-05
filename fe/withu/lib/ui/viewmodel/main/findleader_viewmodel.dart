import 'package:flutter/cupertino.dart';

import '../../../data/model/member.dart';

class FindLeaderViewModel with ChangeNotifier {
  final Member member;

  FindLeaderViewModel(this.member);
}