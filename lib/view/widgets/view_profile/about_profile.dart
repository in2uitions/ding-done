import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class AboutProfile extends StatefulWidget {
  const AboutProfile({super.key});

  @override
  State<AboutProfile> createState() => _AboutProfileState();
}

class _AboutProfileState extends State<AboutProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        height: context.appValues.appSizePercent.h18p5,
        width: context.appValues.appSizePercent.w100,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(
                top: context.appValues.appPadding.p15,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Text(
              'About',
              style: getPrimaryRegularStyle(
                  fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          const Divider(
            height: 20,
            thickness: 2,
            color: Color(0xffEDF1F7),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Text(
              "I love what I do ! Love the outdoors I'm always willing to go the extra mile to satisfy our customer. I provide same day services.",
              style: getPrimaryRegularStyle(
                  fontSize: 15, color: context.resources.color.secondColorBlue),
            ),
          )
        ]),
      ),
    );
  }
}
