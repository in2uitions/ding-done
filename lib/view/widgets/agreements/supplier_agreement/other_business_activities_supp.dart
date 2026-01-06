import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class OtherBusinessActivitiesSupplier extends StatefulWidget {
  const OtherBusinessActivitiesSupplier({super.key});

  @override
  State<OtherBusinessActivitiesSupplier> createState() =>
      _OtherBusinessActivitiesSupplierState();
}

class _OtherBusinessActivitiesSupplierState
    extends State<OtherBusinessActivitiesSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'termsAndConditionsSupplier.otherBusinessActivities'.tr(),
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
                'termsAndConditionsSupplier.otherBusinessActivities1'.tr(),
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
