import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'color_data.dart';

class CustomShadow {
  static const DROP_SHADOW = BoxShadow(color: ColorData.COLOR_SEMIGRAY, offset: Offset(2, 7), spreadRadius: 2, blurRadius: 5);
}