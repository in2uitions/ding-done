import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
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
            '10.	TERMINATION',
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
                    '1.	WeDo may at its discretion terminate your use of, or access to, the Platform at any time. If this happens we may notify you by email. If your use of the Platform is terminated:',
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
                          '1.	you are no longer authorised to access the Platform or use any other WeDo services with the email address you used to register with the Platform or any other email address you possess;',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '2.	you will continue to be subject to and bound by all restrictions imposed on you by the Terms; and',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '3.	all licences granted by you and all disclaimers by WeDo and limitations of WeDo’s liability set out in the Terms or elsewhere on the Platform will survive termination.',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	You may terminate this agreement by emailing WeDo at ___________________________ WeDo will disable your User Profile within fourteen (14) days of receipt of the email requesting termination of your User Profile.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	WeDo reserves the right to deduct any outstanding fees and charges owing to WeDo and/or the Business on your User Profile prior to disabling it.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
