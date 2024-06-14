import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  RatingBar({super.key, required this.width});
  double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.appValues.appSizePercent.w50,
          height: context.appValues.appSizePercent.h1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(context.appValues.appPadding.p10),
            ),
            color: Color(0xffF0F3F8),
          ),
        ),
        Container(
          width: width,
          height: context.appValues.appSizePercent.h1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(context.appValues.appPadding.p10),
            ),
            color: context.resources.color.colorYellow,
          ),
        ),
      ],
    );
  }
}
