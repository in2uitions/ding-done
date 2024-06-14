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

class UserAgreement extends StatefulWidget {
  var index;

  UserAgreement({super.key, required this.index});

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  bool? check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
        return SafeArea(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'USERS AGREEMENT',
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'CJ WEDO LTD TERMS AND CONDITIONS',
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.btnColorBlue,
                      fontSize: 20),
                ),
              ),
              // SizedBox(height: context.appValues.appSize.s25),
              Padding(
                padding: EdgeInsets.all(
                  context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BACKGROUND',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      'CJ WEDO LTD (“WeDo”) operates a website, mobile applications and associated administrative services (together the “Platform”) through which customers (“Users”) can book a Business for the provision of household services such as cleaning, gardening and handyman services (“Services”), by submitting a booking request. WeDo then matches the most suitable Business from its database of Businesses to the booking request. A Business is an independent service provider in the business of providing the Services and is not employed by WeDo or any of its affiliates.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      'These terms and conditions form a contract between WeDo and the Users for the use of the Platform (“Terms”).',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      'The User enters into two contractual relationships. The first contract being with WeDo, governing the access to and use of the Platform in accordance with the Terms. The second contract is between the User and a Business for the provision of the Services and with WeDo as a technology provider in respect of the Services (“Services Agreement”) as attached as Appendix A and as amended from time to time.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      'By accessing and/or using the Platform, you acknowledge that you have read, understood and agree to be bound by these Terms.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AND THE PARTIES HEREBY AGREE:',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 20),
                    ),
                    SizedBox(height: context.appValues.appSize.s15),
                    DefinitionAndInterpretation(),
                    SizedBox(height: context.appValues.appSize.s20),
                    TermsAndConditions(),
                    SizedBox(height: context.appValues.appSize.s20),
                    Acceptance(),
                    SizedBox(height: context.appValues.appSize.s20),
                    UserProfile(),
                    SizedBox(height: context.appValues.appSize.s20),
                    BookingSystem(),
                    SizedBox(height: context.appValues.appSize.s20),
                    PriceAndEstimates(),
                    SizedBox(height: context.appValues.appSize.s20),
                    Payment(),
                    SizedBox(height: context.appValues.appSize.s20),
                    ChangesAndCancellations(),
                    SizedBox(height: context.appValues.appSize.s20),
                    Services(),
                    SizedBox(height: context.appValues.appSize.s20),
                    Termination(),
                    SizedBox(height: context.appValues.appSize.s20),
                    DisputeResolutionPolicy(),
                    SizedBox(height: context.appValues.appSize.s20),
                    SecurityOfPayment(),
                    SizedBox(height: context.appValues.appSize.s20),
                    Privacy(),
                    SizedBox(height: context.appValues.appSize.s20),
                    IntellectualProperty(),
                    SizedBox(height: context.appValues.appSize.s20),
                    AcceptableUse(),
                    SizedBox(height: context.appValues.appSize.s20),
                    IndemnityAndLiability(),
                    SizedBox(height: context.appValues.appSize.s20),
                    WarrantiesAndRepresentations(),
                    SizedBox(height: context.appValues.appSize.s20),
                    GeneralProvisions(),
                    SizedBox(height: context.appValues.appSize.s10),
                    CheckboxListTile(
                      value: check,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: context.resources.color.btnColorBlue,
                      checkColor: context.resources.color.colorWhite,
                      onChanged: (bool? value) {
                        setState(() {
                          check = value;
                        });
                        //
                      },
                      title: Text(
                        "Agree to the agreement",
                        style: getPrimaryRegularStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: context.appValues.appSizePercent.w80,
                        height: context.appValues.appSizePercent.h5p5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await signupViewModel.validate(
                                    index: widget.index) &&
                                check!) {
                              await signupViewModel.signup();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(
                                        context, 'Sign Up Successfull'),
                              );
                              new Future.delayed(
                                  const Duration(seconds: 0),
                                  () => Navigator.of(context)
                                      .push(_createRoute(LoginScreen())));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context,
                                        'Error while trying to sign up. Please fill your data correctly'),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: context.resources.color.colorYellow,
                              ),
                            ),
                            backgroundColor:
                                context.resources.color.colorYellow,
                          ),
                          child: Text(
                            'Log In',
                            style: getPrimaryRegularStyle(
                              fontSize: 15,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                        ),
                      ),
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
