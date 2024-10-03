import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('termsAndConditionsCustomer.privacy'),
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
                    translate('termsAndConditionsCustomer.privacy1'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.privacy2'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.privacy3'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  // SizedBox(height: context.appValues.appSize.s10),
                  // Text(
                  //   '4.	Both parties must abide by all relevant Cypriot and European Union Laws and Regulations set out the Cypriot national law providing for the protection of natural persons with regard to the processing of personal data and for the free movement of such data (Law 125(I)/2018) and the European Union Act titled «Regulation (EE) 2016/679 of the European Parliament and of the Council of 27 April 2016 on the protection of natural persons with regard to the processing of personal data and on the free movement of such data, and repealing Directive 95/46/EC (General Data Protection Regulation). ',
                  //   style: getPrimaryRegularStyle(
                  //       color: context.resources.color.btnColorBlue,
                  //       fontSize: 15),
                  // ),
                ],
              ))
        ]);
  }
}
