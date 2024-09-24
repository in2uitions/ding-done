import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/otp_verification/otp_verification.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFFFFFF),
      body: Consumer<LoginViewModel>(builder: (context, loginViewModel, error) {
        return SafeArea(
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
                SvgPicture.asset('assets/img/restpassscreen.svg'),
                const Gap(30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    translate('forgotPassword.title'),
                    style: getPrimaryBoldStyle(
                      color: const Color(0xff1F126B),
                      fontSize: 30,
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  translate('forgotPassword.msg'),
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
                        CustomTextField(
                          index: 'reset-email',
                          hintText: translate('formHints.email'),
                          keyboardType: TextInputType.emailAddress,
                          viewModel: loginViewModel.setInputValues,
                        ),
                        const Gap(30),
                        SizedBox(
                          height: 60,
                          width: context.appValues.appSizePercent.w100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4100E3),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              loginViewModel.sendResetEmail();
                              Navigator.of(context).push(
                                  _createRoute(const OTPVerificationScreen()));
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
                                    ))
                                : Text(
                                    translate('button.sendMyCode'),
                                    style: getPrimaryBoldStyle(
                                      color: context.resources.color.colorWhite,
                                      fontSize: 20,
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
