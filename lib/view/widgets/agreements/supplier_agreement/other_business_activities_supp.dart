import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class OtherBusinessActivitiesSupplier extends StatefulWidget {
  const OtherBusinessActivitiesSupplier({super.key});

  @override
  State<OtherBusinessActivitiesSupplier> createState() =>
      _OtherBusinessActivitiesSupplierState();
}

class _OtherBusinessActivitiesSupplierState
    extends State<OtherBusinessActivitiesSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '12. OTHER BUSINESS ACTIVITIES',
          style: getPrimaryRegularStyle(
              color: context.resources.color.secondColorBlue, fontSize: 18),
        ),
        SizedBox(height: context.appValues.appSize.s10),
        Padding(
          padding: EdgeInsets.only(
            left: context.appValues.appPadding.p15,
          ),
          child: Column(
            children: [
              Text(
                'Business may be engaged or employed in any other business, trade, profession, or other activity, including providing Services to customers booked through means other than the WeDo Platform, with the exception of other web-based websites. Business shall not affirmatively solicit Users originally referred through the WeDo Platform to book Bookings through any means other than the WeDo Platform.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
