import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class PrivacySupplier extends StatefulWidget {
  const PrivacySupplier({super.key});

  @override
  State<PrivacySupplier> createState() => _PrivacySupplierState();
}

class _PrivacySupplierState extends State<PrivacySupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '14. PRIVACY',
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
                '14.1. Attached as Appendix B the Privacy Policy of  WeDo. ',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '14.2. Business must abide by all relevant Cypriot and European Union Laws and Regulations set out the Cypriot national law providing for the protection of natural persons with regard to the processing of personal data and for the free movement of such data (Law 125(I)/2018) and the European Union Act titled «Regulation (EE) 2016/679 of the European Parliament and of the Council of 27 April 2016 on the protection of natural persons with regard to the processing of personal data and on the free movement of such data, and repealing Directive 95/46/EC (General Data Protection Regulation). ',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
