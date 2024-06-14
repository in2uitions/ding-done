// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../widgets/custom/custom_text_feild.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
      return Scaffold(
        backgroundColor: const Color(0xffF0F3F8),
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
                SizedBox(height: context.appValues.appSize.s20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    translate('forgotPassword.createNewPassword'),
                    style: getPrimaryBoldStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Text(
                  translate('forgotPassword.createNewPasswordMsg'),
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.appValues.appSize.s90),
                CustomTextField(
                  viewModel: profileViewModel.setInputValues,
                  index: 'new_password',
                  hintText: translate('forgotPassword.newPass'),
                  validator: (val) => profileViewModel.verifyPassword[
                      context.resources.strings.formKeys['password']!],
                  errorText: profileViewModel.verifyPassword['new_password'],
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: context.appValues.appSize.s10),
                CustomTextField(
                  index: 'confirm_new_password',
                  // hintText: "Confirm Password",
                  hintText: translate('forgotPassword.confirmPass'),
                  viewModel: profileViewModel.setInputValues,
                  validator: (val) => profileViewModel.verifyPassword[
                      context.resources.strings.formKeys['password']!],
                  errorText:
                      profileViewModel.verifyPassword['confirm_new_password'],
                  keyboardType: TextInputType.visiblePassword,
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (profileViewModel.validate()) {
                        if (await profileViewModel.patchPassword() == true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogChangedPassword(
                                    context,
                                    translate(
                                        'forgotPassword.passwordChanged')),
                          );
                          AppPreferences().remove(key: otpNumber);
                          AppPreferences().remove(key: userIdTochangePassword);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialog(
                              context, translate('button.somethingWentWrong')),
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
        ),
      );
    });
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

Widget _buildPopupDialogChangedPassword(BuildContext context, String message) {
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(_createRoute(LoginScreen()));
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
