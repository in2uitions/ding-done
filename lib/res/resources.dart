import 'package:dingdone/res/strings/arabic_strings.dart';
import 'package:dingdone/res/strings/greek_strings.dart';
import 'package:dingdone/res/strings/russian_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/res/assets/assets_manager.dart';
import 'package:dingdone/res/colors/app_colors.dart';
import 'package:dingdone/res/dimentions/app_dimension.dart';
import 'package:dingdone/res/strings/strings.dart';

import 'strings/english_strings.dart';

class Resources {
  final BuildContext _context;
  Map<String, dynamic> stringLanguage = {
    'en': EnglishStrings(),
    'ar': ArabicStrings(),
    'ru': RussianStrings(),
    'el': GreekStrings(),
  };
  Resources(this._context);

  Strings get strings {
    // It could be from the user preferences or even from the current locale
    Locale locale = Localizations.localeOf(_context);
    return stringLanguage[locale.languageCode];
  }

  AppColors get color {
    return AppColors();
  }

  ImageAssets get image {
    return ImageAssets();
  }

  AppDimension get dimension {
    return AppDimension();
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
