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

TextStyle getPrimaryThinStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.thin, color);
}

TextStyle getPrimaryExtraLightStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.extraLight, color);
}

TextStyle getPrimaryLightStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.light, color);
}

// regular style
TextStyle getPrimaryRegularStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.regular, color);
}

TextStyle getPrimaryMediumStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.medium, color);
}

// semi Bold style
TextStyle getPrimarySemiBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.semiBold, color);
}

// Bold style
TextStyle getPrimaryBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.bold, color);
}

// Extra Bold style
TextStyle getPrimaryExtraBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.extraBold, color);
}

// Black style
TextStyle getPrimaryBlackStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.primaryFontFamily,
      FontWeightConstants.black, color);
}

// Bold style
TextStyle getSecondaryBoldStyle(
    {double fontSize = FontSizeConstants.s12, Color? color}) {
  return _getTextStyle(fontSize, FontConstants.secondaryFontFamily,
      FontWeightConstants.bold, color);
}
