import 'package:flutter/material.dart';
import 'package:dingdone/res/fonts/font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color? color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

// regular style
TextStyle getPrimaryRegularStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.regular, color);
}

// Bold style
TextStyle getPrimaryBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.bold, color);
}

// semi Bold style
TextStyle getPrimarySemiBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.semiBold, color);
}

// Bold style
TextStyle getSecondaryBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.secondaryFontFamily,
      FontWeightConstants.bold, color);
}
