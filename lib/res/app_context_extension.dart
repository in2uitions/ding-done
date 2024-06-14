import 'package:flutter/cupertino.dart';
import 'package:dingdone/res/Resources.dart';
import 'package:dingdone/res/app_values.dart';

extension AppContext on BuildContext {
  Resources get resources => Resources.of(this);
  AppValues get appValues => AppValues.of(this);
}
