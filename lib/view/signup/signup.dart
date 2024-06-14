import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_dropdown.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
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
                  'Sign Up',
                  style: getPrimaryBoldStyle(
                      color: context.resources.color.btnColorBlue,
                      fontSize: 30),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s15),
              Text(
                'Please fill your information below',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.secondColorBlue,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.appValues.appSize.s90),
              Consumer<SignUpViewModel>(
                  builder: (context, signUpViewModel, error) {
                return Column(
                  children: [
                    // CustomDropDown(
                    //   value: signUpViewModel.signUpBody[
                    //           context.resources.strings.formKeys['role']] ??
                    //       null,
                    //   list: signUpViewModel.getRoleList,
                    //   onChange: (dynamic value) async {
                    //     signUpViewModel.setInputValues(
                    //         index: 'role', value: value.toString());
                    //     await signUpViewModel.getUserRoleFromId(signUpViewModel
                    //                 .signUpBody[
                    //             context.resources.strings.formKeys['role']] ??
                    //         null);
                    //     await signUpViewModel
                    //         .changeUserType(signUpViewModel.userRole);
                    //   },
                    //   hint: context.resources.strings.formHints['role']!,
                    //   index: context.resources.strings.formKeys['role']!,
                    //   errorText: signUpViewModel.signUpErrors[
                    //       context.resources.strings.formKeys['role']!],
                    //   validator: (val) => signUpViewModel.signUpErrors[
                    //       context.resources.strings.formKeys['role']!],
                    // ),
                    SizedBox(height: context.appValues.appSize.s15),
                    CustomTextField(
                      viewModel: signUpViewModel.setInputValues,
                      index: context.resources.strings.formKeys['first_name']!,
                      hintText:
                          context.resources.strings.formHints['first_name']!,
                      validator: (val) => signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['first_name']!],
                      errorText: signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['first_name']!],
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: context.appValues.appSize.s15),
                    CustomTextField(
                      viewModel: signUpViewModel.setInputValues,
                      index: context.resources.strings.formKeys['email']!,
                      hintText:
                          context.resources.strings.formHints['email_address']!,
                      validator: (val) => signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['email']!],
                      errorText: signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['email']!],
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: context.appValues.appSize.s15),
                    CustomTextField(
                      viewModel: signUpViewModel.setInputValues,
                      index: context.resources.strings.formKeys['password']!,
                      hintText:
                          context.resources.strings.formHints['password']!,
                      errorText: signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['password']!],
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: context.appValues.appSize.s15),
                    //phone_number
                    CustomPhoneFeild(
                      viewModel: signUpViewModel.setInputValues,
                      index:
                          context.resources.strings.formKeys['phone_number']!,
                      hintText:
                          context.resources.strings.formHints['phone_number']!,
                      // errorText: '',
                      // index: '',
                      // viewModel: null,
                      errorText: signUpViewModel.signUpErrors[
                          context.resources.strings.formKeys['phone_number']!],
                    ),
                    SizedBox(height: context.appValues.appSize.s15),
                    CustomDatePicker(
                      viewModel: signUpViewModel.setInputValues,
                      index: context.resources.strings.formKeys['dob']!,
                      hintText: context.resources.strings.formHints['dob']!,
                      // errorText: signUpViewModel.signUpErrors[
                      //     context.resources.strings.formKeys['password']!],
                      // hintText: 'Date of Birth',
                    ),
                    SizedBox(height: context.appValues.appSize.s40),
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
                          if (
                              // signUpViewModel.validate() &&
                              await signUpViewModel.signup()) {
                            Navigator.of(context)
                                .push(_createRoute(LoginScreen()));
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) =>
                            //       _buildPopupDialog(
                            //           context, 'Verification e-mail sent'),
                            // );
                          } else {
                            // print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogNo(
                                      context, "We couldn't sign u up."),
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
                            : Text("Sign Up",
                                style: getPrimaryRegularStyle(
                                    color: context.resources.color.colorWhite,
                                    fontSize: 15)),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: context.appValues.appSize.s75),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "You have an account?",
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 15),
                ),
                InkWell(
                  child: Text(
                    "Sign In",
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).push(_createRoute(SignUpScreen()));
                  },
                ),
              ]),
            ],
          ),
        ),
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

Widget _buildPopupDialogNo(BuildContext context, String text) {
  return AlertDialog(
    // title: const Text('Popup example'),
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
          text,
          style: getPrimaryRegularStyle(
              color: const Color(0xff3D3D3D), fontSize: 15),
        ),
        const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Icon(
              Icons.not_interested,
              color: Colors.red,
              size: 40,
            )
            // SvgPicture.asset('assets/img/checked.svg'),
            ),
      ],
    ),
  );
}
