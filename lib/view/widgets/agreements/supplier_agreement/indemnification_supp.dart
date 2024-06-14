import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class IndemnificationSupplier extends StatefulWidget {
  const IndemnificationSupplier({super.key});

  @override
  State<IndemnificationSupplier> createState() =>
      _IndemnificationSupplierState();
}

class _IndemnificationSupplierState extends State<IndemnificationSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '9. INDEMNIFICATION',
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
                ' 9.1. Business shall defend, indemnify and hold harmless WeDo and its affiliates and their officers, directors, employees, agents, successors, and assigns from and against all losses, damages, liabilities, deficiencies, actions, judgments, interest, awards, penalties, fines, costs, or expenses of whatever kind (including reasonable attorneys’ fees) arising out of or resulting from: (a) bodily injury, death of any person, theft or damage to real or tangible, personal property resulting from Business’s acts or omissions; and (b) Business’s breach of any representation, warranty, or obligation under this Agreement and the Service Agreement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '9.2. The Services that Business provides pursuant the Service Agreement and are Business’s sole and absolute responsibility. WeDo is not responsible or liable for the actions or inactions of a User or other third party in relation to the Services provided by Business. Business acknowledges, therefore, that by using the WeDo Platform, Business may be introduced to third parties that may be potentially dangerous, and that Business uses the WeDo Platform and enter into any transactions with Users at its own risk.',
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
