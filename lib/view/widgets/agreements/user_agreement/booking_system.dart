import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class BookingSystem extends StatefulWidget {
  const BookingSystem({super.key});

  @override
  State<BookingSystem> createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5.	BOOKING SYSTEM',
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
                    '1.	You may request a Booking via the Booking System. You will receive a Booking confirmation, a payment receipt and the Services Agreement that constitutes the contractual relationship between you, WeDo as a technology provider and a Business as a service provider that you are deemed to have entered into for the provision of the Services.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	WeDo will then make your contact details, location, requested time and the scope of the Service available to its Business network. An available Business will then confirm its acceptance of the Booking.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	You are able to request a preferred Business. WeDo will take your preference into account when facilitating the Service, however a specific Business cannot be guaranteed and will depend on the Business’s availability.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	When a Booking is confirmed by a Business, WeDo will notify you.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '5.	If the requested Business cannot fulfill your Booking, WeDo will arrange an alternative Business for the requested Booking time.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '6.	If the requested Booking cannot be facilitated, WeDo will arrange an alternative time for the Service with you and a Business.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '7.	You are not permitted to engage the Services of a Business other than through the Booking System on the Platform.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '8.	The Booking System is provided on the Platform to enable you to make legitimate Bookings and to make payments for those Bookings, and for no other purposes.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '9.	Any speculative, false or fraudulent Booking is prohibited. You agree that the Booking System will only be used to make legitimate Bookings for you or another person for whom you are legally authorised to act. You acknowledge that abuse of the Booking System may result in you being denied access to the Booking System.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '10.	WeDo has the right at any time to add, change or withdraw functions available on the Platform at its own discretion.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
