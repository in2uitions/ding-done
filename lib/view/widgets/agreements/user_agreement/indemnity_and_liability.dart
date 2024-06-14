import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class IndemnityAndLiability extends StatefulWidget {
  const IndemnityAndLiability({super.key});

  @override
  State<IndemnityAndLiability> createState() => _IndemnityAndLiabilityState();
}

class _IndemnityAndLiabilityState extends State<IndemnityAndLiability> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '16.	INDEMNITY AND LIABILITY',
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
                    '1.	General indemnity: You agree to indemnify WeDo, on demand, against any claim, action, damage, loss, liability, cost, charge, expense or payment which WeDo may pay, suffer, incur or are liable for, in relation to any act you do or cause to be done, in breach of these Terms.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	General limitation of liability: We will not be liable to you in contract, tort or equity in relation to any direct, indirect or consequential loss you incur in relation to the contents or use of or reliance on Platform Content or otherwise in connection with the Platform.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	Services Liability: To the full extent permitted by law, WeDo will not be responsible and will be excluded from all liability, for any loss or damage whatsoever (including personal injury, loss of life and damage to property) that you or another person may suffer in connection with a Business or the offer or supply of (or default in supplying) the Services.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	Information Accuracy: You acknowledge and agree that some of the Platform Content may be provided by way of blogs or comments made by other users of the Platform, and that WeDo does not accept any responsibility or make any representation for the accuracy of such information or your reliance on the same. The Platform Content is provided to you as general information only and is not intended to substitute or replace the advice of a duly qualified professional (where applicable).',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '5.	Acceptance: By using this Platform, you agree and accept that the indemnity and limitations of liability provided in this clause 16 are reasonable.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
