import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class AcceptableUse extends StatefulWidget {
  const AcceptableUse({super.key});

  @override
  State<AcceptableUse> createState() => _AcceptableUseState();
}

class _AcceptableUseState extends State<AcceptableUse> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '15.	ACCEPTABLE USE',
            style: getPrimaryRegularStyle(
                color: context.resources.color.secondColorBlue, fontSize: 18),
          ),
          SizedBox(height: context.appValues.appSize.s10),
          Padding(
              padding: EdgeInsets.only(
                left: context.appValues.appPadding.p15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1.	You must not use, or cause this Platform to be used, in any way which:',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1.	breaches any of these Terms',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '2.	 infringes WeDo’s or any third party’s Intellectual Property Rights;',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '3.	is fraudulent, illegal or unlawful; or',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '4.	causes impairment of the availability or accessibility of the Platform.',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	You must not use, or cause this Platform to be used, as a medium which stores, hosts, transmits sends or distributes any material which consists of:',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1.	spyware;',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '2.	computer viruses;',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '3.	worms;',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '4.	keystroke loggers; or',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          '5.	any other malicious computer software.',
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]);
  }
}
