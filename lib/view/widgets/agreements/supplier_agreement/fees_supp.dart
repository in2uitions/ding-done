import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class FeesSupp extends StatefulWidget {
  const FeesSupp({super.key});

  @override
  State<FeesSupp> createState() => _FeesSuppState();
}

class _FeesSuppState extends State<FeesSupp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '6. FEES',
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
                '6.1. User shall pay the Service Fee to WeDo for completed Bookings through the WeDo Platform at the rates quoted by WeDo at the time the Booking is posted on the Platform, which shall be based on the stated parameters of the Booking. Each Booking made available to Business on the Platform shall set out the Scheduled Time, Estimated Work Time, details about the Service requested, the Booking Rate, and the estimated fee the Business shall be entitled to upon completion of the Booking, as agreed with WeDo from time to time and as indicated in the email received by the Business confirming its acceptance of a Booking (the “Job Fee”).  The difference between the Service Fee and the Job Fee shall be the fee owed to WeDo for referring the Booking and facilitating the payment from User to Business (“Booking Fee”).',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.2. By accepting this Agreement, Business consents and authorises WeDo to withhold WeDo’s Booking Fee from the payment made to the Business for each Booking.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.3. WeDo reserves the right to determine final prevailing pricing that Users will be charged for the Services.  WeDo may, at its sole discretion, make promotional offers with different features and different rates to any Users. These promotional offers, unless made to Business, shall have no bearing on Business’s offer or contract.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.4. If a Booking booked by Business requires more time to complete than the Estimated Work Time, User and Business may, prior to Business providing any Services above and beyond the Estimated Work Time, negotiate an increase in Service Fees based on the estimated additional time needed to complete the Booking. Upon agreement to an increase in Service Fees, Business and User shall notify WeDo.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.5. When a Booking is complete, Business will submit to the User and WeDo confirmation that the Booking is complete. So long as Business has completed the steps necessary to set up a direct deposit account and provided those details to WeDo, WeDo shall then remit payment to the Service Pro for each Booking via direct debit, less WeDo’s Booking Fee, in accordance with WeDo’s billing schedule as advised to Business from time to time.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.6. Without limiting any other provision of this Agreement, WeDo may withhold and offset Job Fees by any amounts Business owes to WeDo or to a User in respect of any Services, including previous overpayments, refunds to Users, chargebacks, damages (including property damage) claimed by a User in respect of the Service Provider’s provision of a Service.  In the event that WeDo refunds or pays amounts to Users in excess of its payment to Business, Business will pay WeDo for such amounts within 30 days of WeDo’s request.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '6.7. Except as specifically set out in this Clause 6, WeDo will retain all revenues derived from or in connection with its services.',
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
