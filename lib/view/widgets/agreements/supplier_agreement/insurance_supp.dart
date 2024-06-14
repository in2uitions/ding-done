import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class InsuranceSupplier extends StatefulWidget {
  const InsuranceSupplier({super.key});

  @override
  State<InsuranceSupplier> createState() => _InsuranceSupplierState();
}

class _InsuranceSupplierState extends State<InsuranceSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '10. INSURANCE',
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
                'It is the sole responsibility of the Business to maintain in full force and effect adequate workers’ compensation, liability, and other forms of insurance, in each case with insurers reasonably acceptable to WeDo, with policy limits sufficient to protect and indemnify WeDo and its affiliates, and each of their officers, directors, agents, employees, subsidiaries, partners, members, controlling persons, and successors and assigns, from any losses resulting from the conduct, acts, or omissions of Business or Business’s Personnel, assistants, agents, contractors, servants, or employees.',
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
