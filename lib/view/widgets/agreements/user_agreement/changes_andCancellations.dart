import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class ChangesAndCancellations extends StatefulWidget {
  const ChangesAndCancellations({super.key});

  @override
  State<ChangesAndCancellations> createState() =>
      _ChangesAndCancellationsState();
}

class _ChangesAndCancellationsState extends State<ChangesAndCancellations> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '8.	CHANGES AND CANCELLATIONS',
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
                    '1.	You can cancel or amend a Booking free of charge, up to 24 hours before the Service is scheduled to begin.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	If you cancel or amend a Booking within 24 hours before the Service is scheduled to begin, you will have to pay cancellation costs equivalent to the value of the total booking fee.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	You cannot amend, extend or cancel a Booking during the performance of the Services.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	The Services Agreement shall expire once the Services under the Booking have been performed.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '5.	If the Business is unable to fulfil a confirmed Booking (in full or part), WeDo will attempt to find you a replacement Business. If we cannot find you an alternative Business, we will reschedule your Booking to a new time which suits you. If we cannot find a suitable time for you, you may cancel the Booking at no charge.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
