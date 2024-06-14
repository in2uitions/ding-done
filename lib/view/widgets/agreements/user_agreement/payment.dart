import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7.	PAYMENT',
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
                    '1.	At the time of making a Booking, your payment details will be transferred to WeDo’s secure payment gateway and WeDo will take payment for the Booking.  In relation to a recurring Booking, WeDo will take payment for your first scheduled Service at the time of making the Booking, and subsequent services will be charged in accordance with subclause 2 below.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	If you have made a recurring Booking, your payment for subsequent services will be pre-authorised up to 72 hours prior to commencement of each scheduled Service, and WeDo will take payment on the day of each scheduled Service. You must ensure that sufficient funds are available for debit at that time. Fees and charges relating to insufficient funds at time of debit may be passed onto you.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	If WeDo is unable to successfully obtain a pre-authorisation for any scheduled Service at any time within 24-hours of the scheduled commencement, WeDo reserves the right to cancel your Booking immediately upon written notice (email or SMS to suffice) and no Service will be provided to you.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	On receipt of the Service Fee, WeDo will hold the Service Fee on behalf of the Business until such time as it accounts to the Business, pays a refund to you (if you are entitled to a refund) or credits payment of our fees and charges. No interest will be payable by WeDo to you or the Business on amounts held by WeDo.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '5.	WeDo will issue you with a receipt for your payment of the Service Fee. You may request for a Tax Invoice and WeDo will provide you with a Tax Invoice for the Services rendered by the Business within a reasonable time of your request.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '6.	If the User is entitled to a refund in accordance with the Services Agreement, WeDo will process the refund as soon as practicable after the right to the refund arises.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
