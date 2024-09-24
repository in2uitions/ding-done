// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/new_password/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  String? _otp;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: context.appValues.appPadding.p10,
            right: context.appValues.appPadding.p10,
            top: context.appValues.appPadding.p10,
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: SvgPicture.asset('assets/img/back.svg'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Gap(20),
              SvgPicture.asset('assets/img/verifyotp.svg'),
              const Gap(30),
              Align(
                alignment: Alignment.center,
                child: Text(
                  translate('forgotPassword.verify'),
                  style: getPrimaryBoldStyle(
                    color: const Color(0xff1F126B),
                    fontSize: 30,
                  ),
                ),
              ),
              const Gap(15),
              Text(
                translate('forgotPassword.verificationMsg'),
                style: getPrimaryRegularStyle(
                  color: const Color(0xff78789D),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(50),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffEAEAFF),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.appValues.appPadding.p25,
                    horizontal: context.appValues.appPadding.p15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('formHints.email'),
                        style: getPrimaryRegularStyle(
                          fontSize: 17,
                          color: const Color(0xff1F1F39),
                        ),
                      ),
                      const Gap(10),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OtpInput(_fieldOne, true), // auto focus
                            OtpInput(_fieldTwo, false),
                            OtpInput(_fieldThree, false),
                            OtpInput(_fieldFour, false)
                          ],
                        ),
                      ),
                      const Gap(30),
                      SizedBox(
                        height: 58,
                        width: context.appValues.appSizePercent.w100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4100E3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(context.appValues.appSize.s10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            setState(() {
                              _otp = _fieldOne.text +
                                  _fieldTwo.text +
                                  _fieldThree.text +
                                  _fieldFour.text;
                            });
                            String? otp_number = await AppPreferences()
                                .get(key: otpNumber, isModel: false);
                            if (otp_number == _otp) {
                              Navigator.of(context).push(
                                  _createRoute(const NewPasswordScreen()));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(
                                        context, 'Wrong OTP number'),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: (isLoading)
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Text(
                                  translate('forgotPassword.confirm'),
                                  style: getPrimaryBoldStyle(
                                    color: context.resources.color.colorWhite,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.resources.color.colorWhite,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(context.appValues.appSize.s10),
              bottomRight: Radius.circular(context.appValues.appSize.s10),
            ),
            borderSide: const BorderSide(
              color: Color(0xffEAEAFF),
              width: 2.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(context.appValues.appSize.s10),
              bottomRight: Radius.circular(context.appValues.appSize.s10),
            ),
            borderSide: const BorderSide(
              color: Color(0xffEAEAFF),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(context.appValues.appSize.s10),
              bottomRight: Radius.circular(context.appValues.appSize.s10),
            ),
            borderSide: const BorderSide(
              color: Color(0xffEAEAFF),
              width: 2.0,
            ),
          ),
          counterText: '',
          hintStyle: getPrimaryBoldStyle(
            color: const Color(0xff38385E),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
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
