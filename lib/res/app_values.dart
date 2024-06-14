import 'package:flutter/cupertino.dart';
import 'package:dingdone/res/values_manager.dart';

class AppValues {
  final BuildContext _context;

  AppValues(this._context);

  AppSize get appSize {
    return AppSize();
  }

  AppSizePercentage get appSizePercent {
    return AppSizePercentage(
        width: MediaQuery.of(_context).size.width,
        height: MediaQuery.of(_context).size.height);
  }

  AppMargin get appMargin {
    return AppMargin();
  }

  AppPadding get appPadding {
    return AppPadding();
  }

  AppRadius get appRadius {
    return AppRadius();
  }

  DurationConstant get durationsConst {
    return DurationConstant();
  }

  static AppValues of(BuildContext context) {
    return AppValues(context);
  }
}
