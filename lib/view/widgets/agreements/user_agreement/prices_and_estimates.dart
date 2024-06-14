import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class PriceAndEstimates extends StatefulWidget {
  const PriceAndEstimates({super.key});

  @override
  State<PriceAndEstimates> createState() => _PriceAndEstimatesState();
}

class _PriceAndEstimatesState extends State<PriceAndEstimates> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '6.	PRICES AND ESTIMATES',
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
                    '1.	You acknowledge and agree that the price quoted for your Booking is an estimate only (“Estimate”), and the actual price charged may vary depending on the type and scope of work/services needed.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '2.	After the Business has arrived at your home/premises, the Business will further assess the problem or work to be performed.  If the Business determines that the work required is greater than what was initially contemplated, the Business will advise you and generate a new estimate reflecting the increase in scope of the Services.  If you approve the revised estimate, the Business will complete the work.  If you do not approve, the Business will take reasonable efforts to complete some or all of the work specified on the original Estimate, the pricing for which you had previously agreed to, or, if the Business is unable to do so, the Booking shall be deemed cancelled.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    '3.	WeDo reserves the right to review and update pricing at ant time. Should any changes to pricing come into effect, WeDo will advise the customer a minimum 48 hours prior to the next service.',
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                ],
              ))
        ]);
  }
}
