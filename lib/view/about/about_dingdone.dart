import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/acceptable_use.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/acceptance.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/booking_system.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/changes_andCancellations.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/definitions_and_interpretation.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/dispute_resolution_policy.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/general_provisions.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/indemnity_and_liability.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/intellectual_property.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/payment.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/prices_and_estimates.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/privacy.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/security_of_payment.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/services.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/termination.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/terms_and_conditions.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/user_profile.dart';
import 'package:dingdone/view/widgets/agreements/user_agreement/warranties_and_representaions.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {

  About({super.key,});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
        return SafeArea(

          child: ListView(
            children: [
             SafeArea(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding:
                    EdgeInsets.all(context.appValues.appPadding.p20),
                    child: Row(
                      children: [
                        InkWell(
                          child: SvgPicture.asset('assets/img/back.svg'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'About',
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),

              Padding(
                padding: EdgeInsets.all(
                  context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      'Ding Done 1.0.22(42)',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      'Developer Details',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      'In2uitions LLC',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      }),
    );
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget _buildPopupDialog(BuildContext context, String message) {
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset('assets/img/x.svg'),
              ],
            ),
          ),
        ),
        Text(
          message,
          style: getPrimaryRegularStyle(
              color: const Color(0xff3D3D3D), fontSize: 15),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: context.appValues.appPadding.p20),
        //   child: SvgPicture.asset('assets/img/cleaning.svg'),
        // ),
      ],
    ),
  );
}
