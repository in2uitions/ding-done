import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class SecurityOfPayment extends StatefulWidget {
  const SecurityOfPayment({super.key});

  @override
  State<SecurityOfPayment> createState() => _SecurityOfPaymentState();
}

class _SecurityOfPaymentState extends State<SecurityOfPayment> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '12.	SECURITY OF PAYMENT',
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
                    '1.	WeDo has taken all practical steps from both a technical and systems perspective to ensure that all of your information is well protected. A secure payment gateway is used to process all transactions and credit card details. WeDo does not give any warranty or make any representation regarding the strength or effectiveness of the secure payment gateway and is not responsible for events arising from unauthorised access to your information.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
