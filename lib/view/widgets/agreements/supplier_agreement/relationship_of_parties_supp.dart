import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class RelationShipOfPartiesSupplier extends StatefulWidget {
  const RelationShipOfPartiesSupplier({super.key});

  @override
  State<RelationShipOfPartiesSupplier> createState() =>
      _RelationShipOfPartiesSupplierState();
}

class _RelationShipOfPartiesSupplierState
    extends State<RelationShipOfPartiesSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. RELATIONSHIP OF PARTIES',
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
                '3.1. The Business provides the Services directly to Users strictly as an independent business, and not as an employee, contractor, agent, joint venture, partner or franchisee of WeDo or any User for any purpose. Business acknowledges that WeDo does not provide the Services and does not employ the Business or any of its employees or affiliates in performing any of the Services.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '3.2. WeDo provides a website and a technology platform which is a referral tool service for Users and Businesses. Through the Booking System, WeDo facilitates the bookings and receipts of payments on behalf of the Business. By accepting a Booking, the Business irrevocably and unconditionally consents to WeDo collecting the Job Fee from the Users on its behalf.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '3.3. The Business is an independent contractor and has not been engaged by WeDo to perform services on WeDo’s behalf. The Business has entered into this Agreement for the purpose of obtaining referrals to third parties in exchange for which it pays WeDo a fee, as described in the terms of this Agreement. This Agreement shall not be construed to create any association, partnership, joint venture, employee or agency relationship between Business and WeDo or any User for any purpose.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '3.4. The Business is not an agent of WeDo and has no authority, express or otherwise implied, (and must not hold himself or herself out as having authority) to bind WeDo. The Business cannot, must not and will not enter into or make any agreements, arrangements, representations or warranties on WeDo’s behalf without WeDo’s prior written consent.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '3.5. Business is an independent supplier and acknowledges that it is not entitled to or otherwise eligible to participate in any benefit plans offered to WeDo’s employees, including, but not limited to, annual leave, sick leave, health insurance, workers compensation, profit sharing or any other fringe benefits or benefit plans offered by WeDo to its employees.',
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
