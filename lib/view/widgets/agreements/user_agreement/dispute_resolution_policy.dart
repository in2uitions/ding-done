import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class DisputeResolutionPolicy extends StatefulWidget {
  const DisputeResolutionPolicy({super.key});

  @override
  State<DisputeResolutionPolicy> createState() =>
      _DisputeResolutionPolicyState();
}

class _DisputeResolutionPolicyState extends State<DisputeResolutionPolicy> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '11.	DISPUTE RESOLUTION POLICY',
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
                    '1.	Most customer concerns can be resolved quickly and to the customer’s satisfaction by emailing customer support at __________________________. You agree to make the circumstances of any dispute known by notice in writing to this email address before taking any other action.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	If you are unhappy with quality of the service, please send us an email within 24 hours of the service taking place. You must include photo/s.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	In the unlikely event that WeDo is unable to resolve a complaint you may have (or if WeDo has not been able to resolve a dispute it has with you after attempting to do so), you agree to resolve any claim, cause of action or disputes you have with WeDo arising out of or in relation to these terms and conditions exclusively in the courts exercising jurisdiction in the Republic of Cyprus and you agree to submit to the personal jurisdiction of such courts for the purpose of litigating all such claims.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	WeDo welcomes any feedback, comments and complaints you may have in respect of the Services and the Businesses, however, you acknowledge the Business is the sole provider of the Services.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
