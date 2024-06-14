import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class BusinessConductSupp extends StatefulWidget {
  const BusinessConductSupp({super.key});

  @override
  State<BusinessConductSupp> createState() => _BusinessConductSuppState();
}

class _BusinessConductSuppState extends State<BusinessConductSupp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7. BUSINESS CONDUCT',
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
                '7.1. Without limiting any other provision of this Agreement, in connection with Business’s use of the Platform and provision of the Services, Business may not and agrees that it will not:',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  children: [
                    Text(
                      '(a) contact a User for any purpose other than in connection with a Booking;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(b) impersonate any person or entity, or falsify or otherwise misrepresent itself or its affiliation with any person or entity;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(c) use the Platform to find a User and then complete a Booking independent of the Platform in order to circumvent the obligation to pay the Booking Fee or any other fees related to WeDo’s provision of the Platform;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(d) accept direct payment from the User, or attempt to directly charge the user for any services in connection with a Booking;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(e) without the written consent of WeDo, directly contract to provide services to a User outside of the Platform (and thereby exclude WeDo). Where such a direct relationship is formed without the consent of the Company, the Business agrees to pay to the Company 25% of the Service Fees that would have applied to had those services been undertaken as Bookings.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
