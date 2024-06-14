import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RatingStarsWidget extends StatefulWidget {
  var stars;

  RatingStarsWidget({super.key, required this.stars});

  @override
  State<RatingStarsWidget> createState() => _RatingStarsWidgetState();
}

class _RatingStarsWidgetState extends State<RatingStarsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        width: context.appValues.appSizePercent.w90,
        // height: context.appValues.appSizePercent.h10,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: Colors.white,
        // ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                  horizontal: context.appValues.appPadding.p10,
                ),
                child: Text(
                  translate('jobDetails.rating'),
                  style: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: const Color(0xff180C38),
                  ),
                ),
              ),
              Container(
                width: context.appValues.appSizePercent.w90,
                height: context.appValues.appSizePercent.h7,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p10,
                    ),
                    child: Stars(
                      rating: double.parse(widget.stars.toString()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
