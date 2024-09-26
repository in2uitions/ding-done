import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
            translate('termsAndConditionsCustomer.termination'),
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
                    translate('termsAndConditionsCustomer.termination1'),
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
                          translate('termsAndConditionsCustomer.termination11'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.termination12'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.termination13'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.termination2'),
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
