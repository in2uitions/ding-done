import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/agreement/user_agreement.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/map_screen/map_screen.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class SignUpOnBoardingScreen extends StatefulWidget {
  var initialIndex;

  SignUpOnBoardingScreen({super.key, required this.initialIndex});

  @override
  State<SignUpOnBoardingScreen> createState() => _SignUpOnBoardingScreenState();
}

class _SignUpOnBoardingScreenState extends State<SignUpOnBoardingScreen> {
  late Material materialButton;
  late int index;
  dynamic image = {};

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = widget.initialIndex;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      // color: defaultSkipButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel2, _) {
        return Container(
          // width: 127,
          width: context.appValues.appSizePercent.w32,
          // height: 51,
          height: context.appValues.appSizePercent.h065,
          decoration: BoxDecoration(
            color: const Color(0xff57527A),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();

              if (signupViewModel2.validate(index: index) && setIndex != null) {
                index = index + 1;
                setIndex(index);
              }
            },
            child: Center(
              child: Text(
                translate('button.next'),
                style: getPrimaryBoldStyle(
                  fontSize: 21,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      // color: defaultProceedButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel1, _) {
        return Container(
          // width: 156,
          width: context.appValues.appSizePercent.w40,
          // height: 51,
          height: context.appValues.appSizePercent.h065,
          decoration: BoxDecoration(
            color: const Color(0xffF3D347),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              if (signupViewModel1.validate(index: index)) {
                Navigator.of(context)
                    .push(_createRoute(UserAgreement(index: index)));
              }
            },
            child: Center(
              child: Text(
                translate('button.complete'),
                style: getPrimaryBoldStyle(
                  fontSize: 21,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic imageWidget = image['image'] != null
        ? image['type'] == 'file'
            ? FileImage(image['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${image['image']}')
        : const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          );

    debugPrint('hello from the other side ');

    return MaterialApp(
      color: const Color(0xffFEFEFE),
      debugShowCheckedModeBanner: false,
      title: translate('login_screen.signUp'),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffFEFEFE),
          // Set the background color to transparent

          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p10,
              context.appValues.appPadding.p20,
            ),
            child: InkWell(
              child: SvgPicture.asset('assets/img/back.svg'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(_createRoute(const LoginScreen()));
              },
            ),
          ),
        ),
        body: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
          return Onboarding(
            pages: [
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 10, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('profile.personalInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value: signupViewModel.signUpBody['first_name']??'' ,
                          index: 'first_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.first_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context
                                  .resources.strings.formKeys['first_name']!],
                          errorText: signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['first_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value: signupViewModel.signUpBody['last_name']??'' ,
                          index: 'last_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.last_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          errorText: signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: CustomDatePicker(
                          value: signupViewModel.signUpBody['dob']??'' ,
                          index: 'dob',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.dob'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('profile.contactInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomPhoneFeild(
                          value: signupViewModel.signUpBody['phone_number']??'' ,
                          index: 'phone_number',
                          viewModel: signupViewModel.setInputValues,
                          validator: (val) => signupViewModel.signUpErrors[
                              context
                                  .resources.strings.formKeys['phone_number']!],
                          errorText: signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['phone_number']!],
                          hintText: translate('formHints.phone_number'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['email']??'' ,
                            index: 'email',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.email'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            keyboardType: TextInputType.emailAddress),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.securityInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['password']??'' ,
                            index: 'password',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.password'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context
                                    .resources.strings.formKeys['password']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['password']!],
                            keyboardType: TextInputType.visiblePassword),
                      ),
                      const SizedBox(height: 8.0),
                      // Adjust the height between the text and bullet points
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: Text(
                          translate('signUp.requirments'),
                          // '● Minimum 8 characters\n'
                          // '● An uppercase letter\n'
                          // '● A lowercase letter\n'
                          // '● A special character\n'
                          // '● A number',
                          style: const TextStyle(
                            color: Colors.black, // Set your desired color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.addressInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                            vertical: context.appValues.appPadding.p10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('bookService.location'),
                              style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: context.resources.color.secondColorBlue,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                translate('signUp.chooseLocation'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 15,
                                  color: context.resources.color.btnColorBlue,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(_createRoute(MapScreen(
                                  viewModel: signupViewModel,
                                  longitude: 25.3,
                                  latitude: 51.52,
                                )));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20),
                        child: SizedBox(
                            height: 300,
                            child: FutureBuilder(
                                future: Provider.of<SignUpViewModel>(context,
                                        listen: false)
                                    .getData(),
                                builder: (context, AsyncSnapshot data) {
                                  if (data.connectionState ==
                                      ConnectionState.done) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(_createRoute(MapScreen(
                                          viewModel: signupViewModel,
                                          longitude: 25.3,
                                          latitude: 51.52,
                                        )));
                                      },
                                      child: MapDisplay(
                                        body: signupViewModel.getSignUpBody,
                                        longitude:
                                            signupViewModel.getSignUpBody[
                                                        "longitude"] !=
                                                    null
                                                ? double.parse(signupViewModel
                                                    .getSignUpBody["longitude"])
                                                : 25.3,
                                        latitude: signupViewModel.getSignUpBody[
                                                    "latitude"] !=
                                                null
                                            ? double.parse(signupViewModel
                                                .getSignUpBody["latitude"])
                                            : 51.52,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                })),
                      ),
                      if (signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['longitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['longitude']]!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      if (signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['latitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['latitude']]!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['street_number'] ??
                                '',
                            index: 'street_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.street'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['street_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['street_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['building_number'] ??
                                '',
                            index: 'building_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.building'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['building_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['building_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.getSignUpBody['floor'] ?? '',
                            index: 'floor',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.floor'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['apartment_number'] ??
                                '',
                            index: 'apartment_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.apartment'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['apartment_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['apartment_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            index: 'city',
                            value: signupViewModel.getSignUpBody['city'] ?? '',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.city'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.getSignUpBody['zone'] ?? '',
                            index: 'zone',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.zone'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            keyboardType: TextInputType.text),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.completeProfile'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),

                      // AddMedia(),

                      CircleAvatar(
                        backgroundImage: imageWidget,
                        radius: 70,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: context.appValues.appSize.s20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff9E9AB7),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p10,
                        ),
                        child: UploadOneImage(
                          callback: (picked, save) async {
                            if (picked != null) {
                              setState(() {
                                image = {
                                  'type': 'file',
                                  'image': File(picked[0].path)
                                };
                              });
                            }
                            if (save != null) {
                              debugPrint('save 0 ${save[0]}');
                              signupViewModel.setInputValues(
                                  index: 'avatar', value: save[0]["image"]);
                            }
                          },
                          isImage: true,
                          widget: Text(
                            translate('signUp.uploadProfilePhoto'),
                            style: getPrimaryBoldStyle(
                              fontSize: 21,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            startPageIndex: widget.initialIndex,
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xffFEFEFE),
                  border: Border.all(
                    width: 0.0,
                    color: const Color(0xffFEFEFE),
                  ),
                ),
                child: ColoredBox(
                  color: const Color(0xffFEFEFE),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        index == pagesLength - 1
                            ? _signupButton
                            : _skipButton(setIndex: setIndex)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
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
