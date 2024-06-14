import 'package:flutter/material.dart';
import 'package:dingdone/res/colors/base_colors.dart';

class AppColors implements BaseColors {
  final Map<int, Color> _primary = {
    50: const Color.fromRGBO(22, 134, 206, 0.1),
    100: const Color.fromRGBO(22, 134, 206, 0.2),
    200: const Color.fromRGBO(22, 134, 206, 0.3),
    300: const Color.fromRGBO(22, 134, 206, 0.4),
    400: const Color.fromRGBO(22, 134, 206, 0.5),
    500: const Color.fromRGBO(22, 134, 206, 0.6),
    600: const Color.fromRGBO(22, 134, 206, 0.7),
    700: const Color.fromRGBO(22, 134, 206, 0.8),
    800: const Color.fromRGBO(22, 134, 206, 0.9),
    850: const Color.fromRGBO(22, 134, 206, 1.0),
    900: const Color(0xFFA1D3FC),
    950: const Color(0xff112b78),
  };
  final Map<int, Color> _black = {
    50: const Color.fromARGB(255, 0, 0, 0),
    100: const Color.fromARGB(255, 15, 15, 15),
    200: const Color.fromARGB(255, 41, 41, 41),
    300: const Color.fromARGB(255, 58, 58, 58),
    400: const Color.fromARGB(255, 61, 61, 61),
    500: const Color.fromARGB(255, 135, 135, 135),
    600: const Color.fromARGB(255, 163, 163, 163),
    700: const Color.fromARGB(255, 200, 200, 200),
    800: const Color.fromARGB(255, 204, 204, 204),
    900: const Color.fromARGB(255, 231, 231, 231),
  };

  final Map<String, Color> _textColor = {
    'red': const Color(0xFFEF5350),
    'blue': const Color(0xff112b78),
  };

  @override
  MaterialColor get colorAccent => Colors.amber;

  @override
  Map<int, Color> get colorPrimary => _primary;

  @override
  Map<String, Color> get colorText => _textColor;

  @override
  Color get colorWhite => const Color(0xffffffff);

  @override
  Color get colorYellow => const Color(0xffFFC500);

  @override
  Map<int, Color> get colorBlack => _black;

  @override
  Color get btnColorBlue => const Color(0xff180C38);
  @override
  Color get secondColorBlue => const Color(0xff919AB0);

  @override
  Color get colorTransparent => Colors.transparent;
}
