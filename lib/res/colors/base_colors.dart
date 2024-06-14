import 'package:flutter/material.dart';

abstract class BaseColors {
  //theme color
  Map<int, Color> get colorPrimary;
  MaterialColor get colorAccent;
  //text color
  Map<String, Color> get colorText;
  //extra color
  Color get colorWhite;
  Color get colorYellow;
  Map<int, Color> get colorBlack;
  Color get btnColorBlue;
  Color get secondColorBlue;
  Color get colorTransparent;
}
