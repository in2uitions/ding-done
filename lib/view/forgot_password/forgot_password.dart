import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/otp_verification/otp_verification.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/signup_view_model/signup_view_model.dart';
import '../widgets/custom/custom_phone_feild.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;
  String selectedMethod = 'email'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'forgotPassword.title'.tr(),
                    style: getPrimaryBoldStyle(
                      color: const Color(0xff1F126B),
                      fontSize: 30,
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  'forgotPassword.msg'.tr(),
                  style: getPrimaryRegularStyle(
                    color: const Color(0xff78789D),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(30),

                // Radio Buttons for Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: 'email',
                      groupValue: selectedMethod,
                      activeColor: const Color(0xff4100E3),
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                    Text(
                      'formHints.email'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 17,
                        color: const Color(0xff1F1F39),
                      ),
                    ),
                    const Gap(20),
                    Radio<String>(
                      value: 'sms',
                      groupValue: selectedMethod,
                      activeColor: const Color(0xff4100E3),
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                    Text(
                      'formHints.sms'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 17,
                        color: const Color(0xff1F1F39),
                      ),
                    ),
                  ],
                ),

                const Gap(20),

                // Toggle Fields Based on Selected Method
                if (selectedMethod == 'email') ...[
                  _buildEmailField(loginViewModel),
                ] else if (selectedMethod == 'sms') ...[
                  _buildPhoneField(loginViewModel),
                ],

                const Gap(30),

                // Submit Button
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (selectedMethod == 'email') {
                        await loginViewModel.sendResetEmail();
                      } else if (selectedMethod == 'sms') {
                        await loginViewModel.sendResetSMS();
                      }

                      Navigator.of(context).push(
                        _createRoute( OTPVerificationScreen(selectedMethod:selectedMethod)),
                      );

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
                      'button.sendMyCode'.tr(),
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
        );
      }),
    );
  }

  Widget _buildEmailField(LoginViewModel loginViewModel) {
    return Container(
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
              'formHints.email'.tr(),
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: const Color(0xff1F1F39),
              ),
            ),
            const Gap(10),
            CustomTextField(
              index: 'reset-email',
              hintText: 'formHints.email'.tr(),
              keyboardType: TextInputType.emailAddress,
              viewModel: loginViewModel.setInputValues,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField(LoginViewModel loginViewModel) {
    return Container(
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
              'formHints.phone'.tr(),
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: const Color(0xff1F1F39),
              ),
            ),
            const Gap(10),
            Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
                return CustomPhoneFeild(
                  index: 'reset-phone',
                  viewModel: loginViewModel.setInputValues,
                  validator: (val) => signupViewModel.signUpErrors[
                  context
                      .resources.strings.formKeys['phone_number']!],
                  errorText: signupViewModel.signUpErrors[context
                      .resources.strings.formKeys['phone_number']!],
                  hintText: 'formHints.phone'.tr(),

                );
              }
            ),

          ],
        ),
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
}
