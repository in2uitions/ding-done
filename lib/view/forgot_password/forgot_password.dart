import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/otp_verification/otp_verification.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
      backgroundColor: const Color(0xffF0F3F8),
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
                SizedBox(height: context.appValues.appSize.s20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    translate('forgotPassword.title'),
                    style: getPrimaryBoldStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Text(
                  translate('forgotPassword.msg'),
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.appValues.appSize.s90),
                CustomTextField(
                  index: 'reset-email',
                  hintText: translate('formHints.email'),
                  keyboardType: TextInputType.emailAddress,
                  viewModel: loginViewModel.setInputValues,
                ),
                SizedBox(height: context.appValues.appSize.s75),
                SizedBox(
                  height: 56,
                  width: context.appValues.appSizePercent.w100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.resources.color.btnColorBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.appValues.appSize.s10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      loginViewModel.sendResetEmail();
                      Navigator.of(context)
                          .push(_createRoute(OTPVerificationScreen()));
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
                        : Text(translate('button.send'),
                            style: getPrimaryRegularStyle(
                                color: context.resources.color.colorWhite,
                                fontSize: 15)),
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
