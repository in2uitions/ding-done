import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class UseOfPlatformSupplier extends StatefulWidget {
  const UseOfPlatformSupplier({super.key});

  @override
  State<UseOfPlatformSupplier> createState() => _UseOfPlatformSupplierState();
}

class _UseOfPlatformSupplierState extends State<UseOfPlatformSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '16. USE OF PLATFORM',
          style: getPrimaryRegularStyle(
              color: context.resources.color.secondColorBlue, fontSize: 18),
        ),
        SizedBox(height: context.appValues.appSize.s10),
        Padding(
          padding: EdgeInsets.only(
            left: context.appValues.appPadding.p15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '16.1. Business must not use, or cause this Platform to be used, in any way which:',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '(a) breaches this Agreement;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(b) infringes WeDo’s or any third party’s Intellectual Property Rights;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(c) is fraudulent, illegal or unlawful; or',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '(d) causes impairment of the availability or accessibility of the Platform.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                  ],
                ),
              ),
              Text(
                '16.2. Business must not use, or cause this Platform to be used, as a medium which stores, hosts, transmits sends or distributes any material which consists of spyware, computer viruses, worms, keystroke loggers, or any other malicious computer software.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '16.3. The use of this Platform is at the Business own risk. The Platform Content and everything from the Platform is provided on an “as is” and “as available” basis without warranty or condition of any kind.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '16.4. None of WeDo’s affiliates, directors, officers, employees, agents, contributors, third party content providers or licensors makes any express or implied representation or warranty about the Platform Content or website _________________.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                '16.5. The Platform and the Booking System are provided subject to limitations, delays, and other problems inherent in the use of the internet, mobile and electronic communications.  WeDo is not responsible for any delays, delivery failures, or losses or  damages suffered by Business, directly or indirectly, in using the Platform or the Booking System.',
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
