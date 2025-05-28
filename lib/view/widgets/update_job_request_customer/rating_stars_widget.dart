import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RatingStarsWidget extends StatefulWidget {
  var stars;
  var userRole;

  RatingStarsWidget({super.key, required this.stars, required this.userRole});

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
      child: SizedBox(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Text(
                  translate('jobDetails.rating'),
                  style: getPrimaryRegularStyle(
                    fontSize: 14,
                    color: const Color(0xff180B3C),
                  ),
                ),
              ),
              widget.userRole == Constants.customerRoleId
                  ? Stars(
                      rating: double.parse(widget.stars.toString()),
                    )
                  : SizedBox(
                      height: 20,
                      child: Stack(
                        children: [
                          Stars(
                            rating: double.parse(widget.stars.toString()),
                          ),
                          InkWell()
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
