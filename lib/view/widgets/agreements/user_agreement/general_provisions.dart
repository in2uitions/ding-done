import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class GeneralProvisions extends StatefulWidget {
  const GeneralProvisions({super.key});

  @override
  State<GeneralProvisions> createState() => _GeneralProvisionsState();
}

class _GeneralProvisionsState extends State<GeneralProvisions> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '18.	GENERAL PROVISIONS',
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
                    '1.	Any provision of, or the application of any provision of these Terms which is prohibited in any jurisdiction is, in that jurisdiction, ineffective only to the extent of that prohibition.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	Any provision of, or the application of any provision of these Terms which is void, illegal or unenforceable in any jurisdiction does not affect the validity, legality or enforceability of that provision in any other jurisdiction or of the remaining provisions in that or any other jurisdiction.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	If a clause is void, illegal or unenforceable, it may be severed without affecting the enforceability of the other provisions in these Terms.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '4.	These Terms shall be governed by and construed in accordance with the laws and regulations of the Republic of Cyprus and the Business agrees to submit to the jurisdiction of the Courts of the Republic of Cyprus. ',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}