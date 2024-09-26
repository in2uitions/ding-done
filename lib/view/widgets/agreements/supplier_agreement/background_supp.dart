import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
          translate('termsAndConditionsSupplier.background'),
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
                translate('termsAndConditionsSupplier.background1'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.background2'),
              style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.background3'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.background4'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              // Text(
              //   '1.3. By accessing or using the Platform, the Business acknowledges that it has read, understood and agree to be bound by this Agreement and the Service Agreement.',
              //   style: getPrimaryRegularStyle(
              //       color: context.resources.color.btnColorBlue, fontSize: 15),
              // ),
              // SizedBox(height: context.appValues.appSize.s10),
              // Text(
              //   '1.4. By accepting a Booking Request and providing the Service, you have read, understood and agree to be bound by the terms of the Service Agreement.',
              //   style: getPrimaryRegularStyle(
              //       color: context.resources.color.btnColorBlue, fontSize: 15),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
