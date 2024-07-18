import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/assignment_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/background_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/business_conduct.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/definitions_and_interpretation.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/fees_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/general_provisions_supplier.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/indemnification_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/insurance_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/intellectual_property_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/other_business_activities_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/platform_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/privacy_supplier.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/relationship_of_parties_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/representations_and_warranties_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/termination_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/the_service_supp.dart';
import 'package:dingdone/view/widgets/agreements/supplier_agreement/use_of_platform_supplier.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SupplierAgreement extends StatefulWidget {
  var index;

  SupplierAgreement({super.key, required this.index});

  @override
  State<SupplierAgreement> createState() => _SupplierAgreementState();
}

class _SupplierAgreementState extends State<SupplierAgreement> {
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
                  'SERVICE PROVIDER AGREEMENT',
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
              Padding(
                padding: EdgeInsets.all(
                  context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackgroundSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    DefinitionsSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    RelationShipOfPartiesSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    PlatformSupp(),
                    SizedBox(height: context.appValues.appSize.s20),
                    TheServiceSupp(),
                    SizedBox(height: context.appValues.appSize.s20),
                    FeesSupp(),
                    SizedBox(height: context.appValues.appSize.s20),
                    BusinessConductSupp(),
                    SizedBox(height: context.appValues.appSize.s20),
                    RepresentationsAndWarrantiesSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    IndemnificationSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    InsuranceSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    TerminationSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    OtherBusinessActivitiesSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    AssignmentSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    PrivacySupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    IntelectualProperty(),
                    SizedBox(height: context.appValues.appSize.s20),
                    UseOfPlatformSupplier(),
                    SizedBox(height: context.appValues.appSize.s20),
                    GeneralProvisionSupplier(),
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
                        "Agree to the agreement",
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
                            'Sign Up',
                            style: getPrimaryRegularStyle(
                              fontSize: 15,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                    :Container(),
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
