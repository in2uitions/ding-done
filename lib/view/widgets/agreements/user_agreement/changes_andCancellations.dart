import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ChangesAndCancellations extends StatefulWidget {
  const ChangesAndCancellations({super.key});

  @override
  State<ChangesAndCancellations> createState() =>
      _ChangesAndCancellationsState();
}

class _ChangesAndCancellationsState extends State<ChangesAndCancellations> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('termsAndConditionsCustomer.changesAndCancellations'),
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
                    translate('termsAndConditionsCustomer.changesAndCancellations1'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.changesAndCancellations2'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.changesAndCancellations3'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.changesAndCancellations4'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.changesAndCancellations5'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
