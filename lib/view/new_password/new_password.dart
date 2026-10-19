// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/custom/custom_text_feild.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.resetToken});

  final String resetToken;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool isLoading = false;
  bool _emailReady = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_emailReady) return;
    _emailReady = true;
    final pending = context.read<LoginViewModel>().pendingResetEmail;
    if (pending.isNotEmpty) {
      _emailController.text = pending;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xffFFFFFF),
          body: SafeArea(
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
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const Gap(12),
                  Center(
                    child: SvgPicture.asset(
                      'assets/img/restpassscreen.svg',
                      width: 88,
                      height: 88,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Gap(16),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'forgotPassword.createNewPassword'.tr(),
                      style: getPrimaryBoldStyle(
                        color: const Color(0xff1F126B),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s15),
                  Text(
                    'forgotPassword.createNewPasswordMsg'.tr(),
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
                            'formHints.email'.tr(),
                            style: getPrimaryRegularStyle(
                              fontSize: 17,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                          const Gap(10),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'formHints.email'.tr(),
                              border: InputBorder.none,
                            ),
                          ),
                          const Gap(25),
                          Text(
                            'forgotPassword.smsCode'.tr(),
                            style: getPrimaryRegularStyle(
                              fontSize: 17,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                          const Gap(10),
                          TextField(
                            controller: _smsController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: 'forgotPassword.smsHint'.tr(),
                              counterText: '',
                              border: InputBorder.none,
                            ),
                          ),
                          const Gap(25),
                          Text(
                            'forgotPassword.newPass'.tr(),
                            style: getPrimaryRegularStyle(
                              fontSize: 17,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                          const Gap(10),
                          CustomTextField(
                            viewModel: profileViewModel.setInputValues,
                            index: 'new_password',
                            hintText: 'forgotPassword.newPass'.tr(),
                            validator: (val) =>
                            profileViewModel.verifyPassword[
                            context.resources.strings
                                .formKeys['password']!],
                            errorText: profileViewModel
                                .verifyPassword['new_password'],
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const Gap(25),
                          Text(
                            'forgotPassword.confirmPass'.tr(),
                            style: getPrimaryRegularStyle(
                              fontSize: 17,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                          const Gap(10),
                          CustomTextField(
                            index: 'confirm_new_password',
                            hintText:
                            'forgotPassword.confirmPass'.tr(),
                            viewModel: profileViewModel.setInputValues,
                            validator: (val) =>
                            profileViewModel.verifyPassword[
                            context.resources.strings
                                .formKeys['password']!],
                            errorText: profileViewModel
                                .verifyPassword['confirm_new_password'],
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const Gap(30),
                          SizedBox(
                            height: 60,
                            width:
                            context.appValues.appSizePercent.w100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xff4100E3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        context.appValues.appSize.s10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                setState(() => isLoading = true);

                                final email = _emailController.text.trim();
                                final sms = _smsController.text.trim();
                                final emailOk = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(email);

                                if (widget.resetToken.isEmpty || !emailOk) {
                                  _showError(
                                    context,
                                    'forgotPassword.resetEmailRequired'.tr(),
                                  );
                                } else if (!RegExp(r'^\d{6}$').hasMatch(sms)) {
                                  _showError(
                                    context,
                                    'forgotPassword.smsRequired'.tr(),
                                  );
                                } else if (profileViewModel.validate()) {
                                  final success =
                                      await profileViewModel.resetPassword(
                                    email: email,
                                    token: widget.resetToken,
                                    smsCode: sms,
                                  );

                                  if (!mounted) return;
                                  if (success == true) {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          _buildPopupDialogChangedPassword(
                                            context,
                                            'forgotPassword.passwordChanged'
                                                .tr(),
                                          ),
                                    );
                                  } else {
                                    _showError(
                                      context,
                                      profileViewModel.resetError.isNotEmpty
                                          ? profileViewModel.resetError
                                          : 'button.somethingWentWrong'.tr(),
                                    );
                                  }
                                } else {
                                  _showError(
                                    context,
                                    'button.somethingWentWrong'.tr(),
                                  );
                                }

                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              },
                              child: isLoading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1.5,
                                ),
                              )
                                  : Text(
                                'forgotPassword.confirm'.tr(),
                                style:
                                getPrimaryRegularStyle(
                                  color: context.resources
                                      .color.colorWhite,
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
      },
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => _buildPopupDialog(context, message),
    );
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => child,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween =
      Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.ease),
      );

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
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset('assets/img/x.svg'),
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

Widget _buildPopupDialogChangedPassword(
    BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: SvgPicture.asset('assets/img/x.svg'),
            onTap: () {
              Navigator.of(context)
                  .push(_createRoute(const LoginScreen()));
            },
          ),
        ),
        message ==
            'forgotPassword.passwordChanged'.tr()
            ? SvgPicture.asset(
            'assets/img/booking-confirmation-icon.svg')
            : SvgPicture.asset(
            'assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
            context.appValues.appPadding.p32,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 17,
              color:
              context.resources.color.btnColorBlue,
            ),
          ),
        ),
      ],
    ),
  );
}
