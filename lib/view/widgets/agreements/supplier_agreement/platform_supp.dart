import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class PlatformSupp extends StatefulWidget {
  const PlatformSupp({super.key});

  @override
  State<PlatformSupp> createState() => _PlatformSuppState();
}

class _PlatformSuppState extends State<PlatformSupp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. PLATFORM',
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
                '4.1. From time to time, in their sole and complete discretion, Users will post Bookings on the Platform, setting out the nature of the Services required (the “Bookings”). Bookings posted will include a date, suburb where the Booking will take place and time frame (the “Scheduled Time”) in which Services are requested, and an estimate of time necessary to complete the work (the “Estimated Work Time”).',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '4.2. Scheduled Times will be displayed either as a specific time or as a range. The Estimated Work Time will be displayed either as a specific time or as a range.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '4.3. Business will then have the opportunity to review the Bookings and select those Bookings in Business’s area of expertise that meet Business’s preferred specifications as to Scheduled Time, date, suburb and fees.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '4.4. WeDo does not guarantee any minimum number of Bookings will be available to Service Provider at any point during the term of this Agreement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '4.5. Business is not obligated to review the Bookings posted or select any Bookings posted by any User at any time. Once a Business selects a Booking, WeDo will confirm in writing to the Business if it has been successful in booking the selected Booking, at which time the Booking is deemed booked by the Business. Once a Booking is booked, a contract is formed directly between the User and Business for Business to complete the Booking on the terms of the Services Agreement. Business agrees that Business’s name and phone number may be provided or made available to User by or on behalf of WeDo after the Booking is booked.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '4.6. It is possible that a Business may claim a Scheduled Time and/or Estimated Work Time and receive a Booking that has a shorter Scheduled Time and Estimated Work Time. Business acknowledges and agrees that it understands that claiming a Booking that has a Scheduled Time and Estimated Work Time may result in receipt of a Booking of less than the maximum time set out in the Estimated Work Time.',
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
