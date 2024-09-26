import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrivacySupplier extends StatefulWidget {
  const PrivacySupplier({super.key});

  @override
  State<PrivacySupplier> createState() => _PrivacySupplierState();
}

class _PrivacySupplierState extends State<PrivacySupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('termsAndConditionsSupplier.privacy'),
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
                translate('termsAndConditionsSupplier.privacy1'),
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
