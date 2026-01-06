import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/sign_up_as/sign_up_as.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/custom/custom_dropdown.dart';
import 'dart:ui' as ui;

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() =>
      _CountrySelectionScreenState();
}

class _CountrySelectionScreenState
    extends State<CountrySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: SafeArea(
        child: Consumer<SignUpViewModel>(
          builder: (context, signupViewModel, _) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p10,
                    context.appValues.appPadding.p10,
                    context.appValues.appPadding.p150,
                  ),
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Align(
                      alignment:
                      Alignment.centerLeft,
                      child: InkWell(
                        child: Icon(
                          Icons
                              .arrow_back_ios_new_sharp,
                          color: context.resources
                              .color.colorBlack[50],
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
                  width: context
                      .appValues.appSizePercent.w100,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Text(
                        'formHints.country'.tr(),
                        style: getSecondaryBoldStyle(
                          color:
                          const Color(0xff190C39),
                          fontSize: 22,
                        ),
                      ),
                      const Gap(50),
                      Padding(
                        padding: EdgeInsets.all(
                            context.appValues
                                .appPadding.p20),
                        child: FutureBuilder(
                          future: Provider.of<
                              SignUpViewModel>(
                              context,
                              listen: false)
                              .countries(),
                          builder:
                              (context, AsyncSnapshot data) {
                            return Padding(
                              padding:
                              const EdgeInsets.fromLTRB(
                                  20, 0, 20, 20),
                              child: CustomDropDown(
                                value: signupViewModel
                                    .getSignUpBody[
                                "country"],
                                index: 'country',
                                viewModel:
                                signupViewModel
                                    .setInputValues,
                                hintText:
                                'formHints.country'
                                    .tr(),
                                validator: (val) =>
                                signupViewModel
                                    .signUpErrors[
                                context
                                    .resources
                                    .strings
                                    .formKeys['country']!],
                                errorText: signupViewModel
                                    .signUpErrors[
                                context
                                    .resources
                                    .strings
                                    .formKeys['country']!],
                                keyboardType:
                                TextInputType.text,
                                list: signupViewModel
                                    .getCountries,
                                onChange: (value) {
                                  var selectedCountry =
                                  signupViewModel
                                      .getCountries
                                      .firstWhere(
                                        (country) =>
                                    country['code'] ==
                                        value,
                                    orElse: () =>
                                    '',
                                  )["iso_a2"];
                                  debugPrint(
                                      'country is $selectedCountry');
                                  signupViewModel
                                      .setInputValues(
                                    index: 'country',
                                    value: value,
                                  );
                                  signupViewModel
                                      .setInputValues(
                                    index: 'phone_code',
                                    value: selectedCountry
                                        .toString()
                                        .toUpperCase(),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues
                              .appPadding.p20,
                          context.appValues
                              .appPadding.p0,
                          context.appValues
                              .appPadding.p20,
                          context.appValues
                              .appPadding.p20,
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (signupViewModel
                                .getSignUpBody['country'] !=
                                null) {
                              Navigator.of(context)
                                  .push(
                                _createRoute(
                                    const SignUpAsScreen()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder:
                                    (BuildContext context) =>
                                    _buildPopupDialog(
                                      context,
                                      'Please provide country',
                                    ),
                              );
                            }
                          },
                          child: Container(
                            width: context.appValues
                                .appSizePercent.w80,
                            height: context.appValues
                                .appSizePercent.h6,
                            decoration: BoxDecoration(
                              color:
                              const Color(0xff4100E3),
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'login_screen.signUp'
                                    .tr(),
                                style:
                                getPrimaryBoldStyle(
                                  fontSize: 14,
                                  color: context
                                      .resources
                                      .color
                                      .colorWhite,
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
          },
        ),
      ),
    );
  }
}

Widget _buildPopupDialog(
    BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                    'assets/img/x.svg'),
              ],
            ),
          ),
        ),
        Text(
          message,
          style: getPrimaryRegularStyle(
            color: const Color(0xff3D3D3D),
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) =>
    classname,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween =
      Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
