import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class TerminationSupplier extends StatefulWidget {
  const TerminationSupplier({super.key});

  @override
  State<TerminationSupplier> createState() => _TerminationSupplierState();
}

class _TerminationSupplierState extends State<TerminationSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '11. TERMINATION',
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
                '11.1. This Agreement shall be effective as of the date it is executed by Business and, except as stated in clause 11.4 below, shall remain in effect unless and until terminated as set forth in this clause 11 (the “Term”). Business understands that WeDo may temporarily deactivate Business’s profile on Platform in the event that Business is inactive on the Platform for more than 90 consecutive days. In such circumstances, WeDo shall reactivate Business’s profile upon request from Business.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.2. The parties acknowledge that the term of this Agreement does not reflect an uninterrupted service arrangement, as this Agreement guarantees Business the right to choose when to make himself or herself available and each Booking referred and accepted is treated as a separate service arrangement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.3. Except as stated clause 11.4 below, WeDo and Business may terminate this Agreement, effective immediately upon written notice to the other party, in the event that other party materially breaches this Agreement. A material breach shall include, but not be limited to, the acts or omissions expressly defined in this Agreement as constituting a material breach, WeDo’s failure to timely remit Job Fees as described in these Terms, Business’s failure to complete a Booking he or she has booked on the Platform or if a Business cancels or reschedules two (2) or more Bookings he or she has booked on less than 2 hours’ notice prior to the applicable Booking start time within any twenty-eight (28) day period.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.4. In addition to the foregoing, WeDo and Business may terminate the Agreement for any reason upon fifteen (15) days’ written notice.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.5. Upon termination of this Agreement for any reason, Business shall complete any outstanding Bookings Business has booked.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.6. Upon termination of this Agreement, WeDo shall remain liable to pay to Business any due and payable outstanding earned Job Fees.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '11.7. Notwithstanding any other language in this Agreement, the terms and conditions of this clauses 11 and clauses 6, 7, 8, 9, 11.4, 11.5, 12, 13, 14, 15, 16 and 17 shall survive the expiration or termination of this Agreement.',
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
