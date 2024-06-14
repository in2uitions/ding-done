import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class AssignmentSupplier extends StatefulWidget {
  const AssignmentSupplier({super.key});

  @override
  State<AssignmentSupplier> createState() => _AssignmentSupplierState();
}

class _AssignmentSupplierState extends State<AssignmentSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '13. ASSIGNMENT',
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
                'Business may not assign this Agreement, absent written authorisation by WeDo. WeDo may freely assign its rights and obligations under this Agreement at any time. This Agreement will inure to the benefit of, be binding on, and be enforceable against, each of the parties hereto and their respective successors and assigns.',
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
