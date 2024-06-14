import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class TheServiceSupp extends StatefulWidget {
  const TheServiceSupp({super.key});

  @override
  State<TheServiceSupp> createState() => _TheServiceSuppState();
}

class _TheServiceSuppState extends State<TheServiceSupp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. THE SERVICES',
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
                '5.1. The Business agrees and acknowledges that any Services provided must be made in accordance with the terms and conditions contained in the Service Agreement. The Business also acknowledges that it is solely responsible for the Services provided and agree to indemnify and hold WeDo harmless against any claim, action, damage, loss, liability, cost, charge, expense or payment which WeDo may pay, suffer, incur or are liable for, in respect of the Services or any breach of the Service Agreement by the Business.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.2. Business shall be eligible to book Bookings through the WeDo Platform requesting any Services that Business is fully-licensed (to the extent required by applicable law) and qualified to provide as indicated by Business in the WeDo application form completed by Business (the “Application”). Business shall, upon request, provide proof to WeDo of valid Personnel police checks, and Business licences, permits and/or certifications before Business provides any such Services under this Agreement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.3. To ensure that the WeDo Platform remains a reliable source of referrals and to ensure all qualified Businesses are able to access available Bookings, once Business has been awarded the Booking, Business is contractually obligated to complete the Booking at the Scheduled Time specified by, and to the satisfaction of, the User. Cancellation by Business may result in a fee being charged to Business as advised in writing by WeDo from time to time. Business may reschedule a Booking without Business incurring a fee, provided the Booking is rescheduled more than 48 hours prior to the Scheduled Time. If User and Business agree to reschedule, Business agrees to notify WeDo as promptly as possible so that WeDo may make that Booking available to other Businesses. In the event that the User declines to reschedule, WeDo shall have the right to make the Booking available to other Businesses via the WeDo Platform.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.4. Business understands and agrees that Business’s failure to complete a Booking in accordance with User’s specifications after he or she has booked that Booking using the Platform constitutes a material breach of this Agreement and could result in a fee being charged to Business as advised by WeDo from time to time. Similarly, Business may be entitled to a fee in the event a User cancels or reschedules a Booking as advised by WeDo from time to time.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.5. By accepting this Agreement, Business authorises WeDo to withhold from the Business’s Job Fees the foregoing cancellation fees, and any other contractual penalty fees referenced in this Agreement or which are included in WeDo’s applicable policies and procedures as advised to Business from time to time.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.6. WeDo shall not control or have any right to control the manner or means by which Business performs the Services, including but not limited to the time and place Business performs the Services, the Bookings Business selects, the tools and materials used by Business to complete the Bookings, the helpers, assistants, subcontractors or other personnel (if any) (the “Personnel”) used by Business to assist in completing Bookings, or the manner in which Business completes the Bookings. WeDo will not and has no right to, under any circumstances, inspect Business’s work for quality purposes. Those provisions of the Agreement reserving ultimate authority in WeDo have been inserted solely to achieve compliance with applicable laws, regulations, and interpretations of these.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.7. Where approved in advance by the User, and except as otherwise provided in this Agreement, Business is not obligated to personally perform the Services. Business shall provide at his/her own discretion, selection, and expense any and all assistants, helpers, subcontractors or other personnel the Business deems necessary and appropriate to complete the Services. Business shall be solely responsible for the direction and control of any such Personnel.  Business agrees that any Personnel used shall maintain a professional appearance consistent with industry standards while performing Services.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '5.8.             Business assumes full and sole responsibility for the payment of all compensation, benefits and expenses of any Personnel, and for all required payroll tax, income tax withholdings, and Workers Compensation as to Business and all persons engaged by Business in the performance of the Services.',
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
