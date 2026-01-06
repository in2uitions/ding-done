// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/custom/custom_text_feild.dart';
import '../../res/constants.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool isLoading = false;

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
                  const Gap(20),
                  SvgPicture.asset('assets/img/restpassscreen.svg'),
                  const Gap(30),
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

                                if (profileViewModel.validate()) {
                                  final success =
                                  await profileViewModel
                                      .patchPassword();

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

                                    AppPreferences()
                                        .remove(key: otpNumber);
                                    AppPreferences().remove(
                                        key:
                                        userIdTochangePassword);
                                  } else {
                                    _showError(context);
                                  }
                                } else {
                                  _showError(context);
                                }

                                setState(() => isLoading = false);
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

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _buildPopupDialog(
        context,
        'button.somethingWentWrong'.tr(),
      ),
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
