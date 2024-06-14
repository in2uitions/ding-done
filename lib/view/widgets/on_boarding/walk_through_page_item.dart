import 'package:flutter/cupertino.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class WalkthroughPageItem extends StatelessWidget {
  final String imagepath, title, description;
  final color;
  WalkthroughPageItem({
    required this.imagepath,
    required this.title,
    required this.description,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/img/onboardingbg.png',
          width: context.appValues.appSizePercent.w100,
          height: context.appValues.appSizePercent.h50,
          fit: BoxFit.contain,
          scale: 3,
        ),
        // Image.network(
        //   imagepath,
        //   // width: 325,
        //   width: context.appValues.appSizePercent.w80,
        //   // height: 363,
        //   height: context.appValues.appSizePercent.h45,
        //   fit: BoxFit.contain,
        //   scale: 3,
        // ),
        SizedBox(height: context.appValues.appSize.s30),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p10,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: getPrimaryBoldStyle(fontSize: 30, color: color),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s10),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p10,
          ),
          child: Text(
            description,
            textAlign: TextAlign.start,
            style: getPrimaryRegularStyle(
              fontSize: 22,
              color: context.resources.color.colorWhite,
            ),
          ),
        ),
      ],
    );
  }
}
