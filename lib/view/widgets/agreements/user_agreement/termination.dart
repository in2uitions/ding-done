import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Termination extends StatefulWidget {
  const Termination({super.key});

  @override
  State<Termination> createState() => _TerminationState();
}

class _TerminationState extends State<Termination> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           'termsAndConditionsCustomer.termination'.tr(),
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
                    'termsAndConditionsCustomer.termination1'.tr(),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.appValues.appPadding.p15,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'termsAndConditionsCustomer.termination11'.tr(),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                         'termsAndConditionsCustomer.termination12'.tr(),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          'termsAndConditionsCustomer.termination13'.tr(),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                   'termsAndConditionsCustomer.termination2'.tr(),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  // SizedBox(height: context.appValues.appSize.s10),
                  // Text(
                  //   '3.	WeDo reserves the right to deduct any outstanding fees and charges owing to WeDo and/or the Business on your User Profile prior to disabling it.',
                  //   style: getPrimaryRegularStyle(
                  //       color: context.resources.color.btnColorBlue,
                  //       fontSize: 15),
                  // ),
                ],
              ))
        ]);
  }
}
