import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/sign_up_as/sign_up_as.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../widgets/custom/custom_dropdown.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFEFEFE),
      body: SafeArea(
        child:
            Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p150,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      // child: SvgPicture.asset('assets/img/back.svg'),
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: context.resources.color.colorBlack[50],
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: context.appValues.appSizePercent.w100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate('formHints.country'),
                      style: getSecondaryBoldStyle(
                        color: const Color(0xff190C39),
                        fontSize: 22,
                      ),
                    ),
                    const Gap(50),
                    Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      child: FutureBuilder(
                          future: Provider.of<SignUpViewModel>(context,
                                  listen: false)
                              .countries(),
                          builder: (context, AsyncSnapshot data) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: CustomDropDown(
                                value:
                                    signupViewModel.getSignUpBody["country"] ??
                                        '',
                                index: 'country',
                                viewModel: signupViewModel.setInputValues,
                                hintText: translate('formHints.country'),
                                validator: (val) =>
                                    signupViewModel.signUpErrors[context
                                        .resources
                                        .strings
                                        .formKeys['country']!],
                                errorText: signupViewModel.signUpErrors[context
                                    .resources.strings.formKeys['country']!],
                                keyboardType: TextInputType.text,
                                list: signupViewModel.getCountries,
                                onChange: (value) {
                                  signupViewModel.setInputValues(
                                      index: 'country', value: value);
                                },
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p0,
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p20,
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (signupViewModel.getSignUpBody['country'] !=
                              null) {
                            Navigator.of(context).push(
                              _createRoute(const SignUpAsScreen()),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      context, 'Please provide country'),
                            );
                          }
                        },
                        child: Container(
                          width: context.appValues.appSizePercent.w80,
                          height: context.appValues.appSizePercent.h6,
                          decoration: BoxDecoration(
                            color: const Color(0xff4100E3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              translate('login_screen.signUp'),
                              style: getPrimaryBoldStyle(
                                fontSize: 14,
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
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
      ],
    ),
  );
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
