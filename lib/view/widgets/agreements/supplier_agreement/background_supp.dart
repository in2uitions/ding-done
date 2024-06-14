import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class BackgroundSupplier extends StatefulWidget {
  const BackgroundSupplier({super.key});

  @override
  State<BackgroundSupplier> createState() => _BackgroundSupplierState();
}

class _BackgroundSupplierState extends State<BackgroundSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. BACKGROUND',
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
                'CJ WEDO LTD (“WeDo”) operates a website, mobile applications and associated administrative services (together the “Platform”) through which customers (“Users”) can book a Business for the provision of household services such as cleaning, gardening and handyman services (“Services”), by submitting a booking request. Businesses then review the available Bookings and select those that meet Business’s preferred specifications.  A Business is an independent service provider in the business of providing the Services and is not employed by WeDo or any of its affiliates.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                'These terms and conditions form a contract between WeDo and the Businesses (“Agreement”).',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '1.1. Business acknowledges that it is an independent service provider in the business of providing the Services and that it is not employed by WeDo or its affiliates.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '1.2. The Business enters into two contractual relationships. The first contract being with WeDo, governing the access to and use of the Platform in accordance with the terms and conditions of this Agreement. The second contract being with the Customer for the provision of the Services (“Services Agreement”) as set out in Appendix A and as amended from time to time.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '1.3. By accessing or using the Platform, the Business acknowledges that it has read, understood and agree to be bound by this Agreement and the Service Agreement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '1.4. By accepting a Booking Request and providing the Service, you have read, understood and agree to be bound by the terms of the Service Agreement.',
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
