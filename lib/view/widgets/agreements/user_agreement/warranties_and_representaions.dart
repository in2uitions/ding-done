import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class WarrantiesAndRepresentations extends StatefulWidget {
  const WarrantiesAndRepresentations({super.key});

  @override
  State<WarrantiesAndRepresentations> createState() =>
      _WarrantiesAndRepresentationsState();
}

class _WarrantiesAndRepresentationsState
    extends State<WarrantiesAndRepresentations> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '17.	WARRANTIES AND REPRESENTATIONS',
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
                    '1.	The use of this Platform is at your own risk. The Platform Content and everything from the Platform is provided to you on an “as is” and “as available” basis without warranty or representation of any kind.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	None of WeDo’s affiliates, directors, officers, employees, agents, contributors, third party content providers or licensors make any express or implied representation or warranty about the Platform Content or Platform.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
