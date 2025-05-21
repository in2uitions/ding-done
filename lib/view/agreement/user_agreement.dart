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
import 'package:flutter_translate/flutter_translate.dart';
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
             widget.index==null?
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
              ):Container(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  translate('termsAndConditionsCustomer.userAgreement'),
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  translate('termsAndConditionsCustomer.termsAndConditions'),
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
                      translate('termsAndConditionsCustomer.background'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.background1'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      translate('termsAndConditionsCustomer.background2'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      translate('termsAndConditionsCustomer.background3'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      translate('termsAndConditionsCustomer.background4'),
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
                    translate('termsAndConditionsCustomer.partiesAgree'),
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
                    widget.index!=null?
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
                        translate('termsAndConditionsCustomer.agree'),
                        style: getPrimaryRegularStyle(fontSize: 15),
                      ),
                    ):Container(),
                    SizedBox(height: context.appValues.appSize.s10),
                    widget.index!=null?
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
                              if(await signupViewModel.signup()==true){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                          context, 'Sign Up Successfull'),
                                );
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                          context, 'Sign Up Failed \n ${signupViewModel.errorMessage}'),
                                );
                              }
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
                            translate('login_screen.signUp'),
                            style: getPrimaryRegularStyle(
                              fontSize: 15,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                        ),
                      ),
                    ):Container(),
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
    backgroundColor: Colors.white,
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
        Center(
          child:InkWell(onTap: (){
            Navigator.of(context)
                .push(_createRoute(LoginScreen()));
          }, child: Text(
            'OK',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getPrimaryRegularStyle(
              fontSize: 20,
              color: const Color(0xff180D38),
            ),
          ),
          ),
        ),
      ],
    ),
  );
}
