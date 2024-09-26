import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
          translate('termsAndConditionsSupplier.fees'),
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
                translate('termsAndConditionsSupplier.fees1'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees2'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees3'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees4'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees5'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees6'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.fees7'),
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
