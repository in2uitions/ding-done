// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/forgot_password/forgot_password.dart';
import 'package:dingdone/view/sign_up_as/country_selection.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild_login.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  Future<void> getCredentials() async {
    // email = await AppPreferences().get(key: userEmailKey, isModel: false);
    // password = await AppPreferences().get(key: userPasswordKey, isModel: false);
    setState(() async {
      email = await AppPreferences().get(key: userEmailKey, isModel: false);
      password =
          await AppPreferences().get(key: userPasswordKey, isModel: false);
    });
    debugPrint('email $email and password $password');
    setState(() {
      // Update the state with retrieved values
      _isChecked = email != null && password != null;
    });
  }

  bool isLoading = false;
  bool isLoadingGoogle = false;
  bool isLoadingApple = false;
  bool _isChecked = false;
  var email;
  var password;

  // @override
  // void initState() {
  //   super.initState();
  //   //Remove this method to stop OneSignal Debugging
  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  //
  //   OneSignal.shared.setAppId("f7fd77d5-793e-4884-8710-b2570d298cf0");
  //
  //   // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  //   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //     print("Accepted permission: $accepted");
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.resources.color.btnColorBlue,
      body: Stack(
        children: [
          Container(
            width: context.appValues.appSizePercent.w100,
            height: context.appValues.appSizePercent.h55,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF20136C),
                  Color(0xFF4100E3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: const Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                        onTap: () => _onActionSheetPress(context),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/img/logo-new.svg',
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.60,
              minChildSize: 0.60,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: context.appValues.appPadding.p20,
                                right: context.appValues.appPadding.p20,
                              ),
                              child: Column(
                                children: [
                                  Consumer3<LoginViewModel, CategoriesViewModel,
                                          JobsViewModel>(
                                      builder: (context,
                                          loginViewModel,
                                          categoriesViewModel,
                                          jobsViewModel,
                                          error) {
                                    return Column(
                                      children: [
                                        Text(
                                          translate(
                                              'login_screen.signInToYourAccount'),
                                          style: getPrimarySemiBoldStyle(
                                            fontSize: 16,
                                            color: const Color(0xff180B3C),
                                          ),
                                        ),
                                        const Gap(10),
                                        CustomTextFieldLogin(
                                          viewModel:
                                              loginViewModel.setInputValues,
                                          index: context.resources.strings
                                              .formKeys['email']!,
                                          // hintText: context
                                          //     .resources.strings.formHints['email_address']!,
                                          hintText:
                                              translate('formHints.email'),
                                          validator: (val) =>
                                              loginViewModel.loginErrors[context
                                                  .resources
                                                  .strings
                                                  .formKeys['email']!],
                                          errorText: loginViewModel.loginErrors[
                                              context.resources.strings
                                                  .formKeys['email']!],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          value: email ?? '',
                                        ),
                                        const Gap(15),
                                        CustomTextFieldLogin(
                                          viewModel:
                                              loginViewModel.setInputValues,
                                          index: context.resources.strings
                                              .formKeys['password']!,
                                          // hintText: context
                                          //     .resources.strings.formHints['password']!,
                                          hintText:
                                              translate('formHints.password'),
                                          errorText: loginViewModel.loginErrors[
                                              context.resources.strings
                                                  .formKeys['password']!],
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          value: password ?? '',
                                        ),
                                        const Gap(10),
                                        loginViewModel.errorMsg != null
                                            ? Text(
                                                loginViewModel.errorMsg,
                                                style: getPrimaryRegularStyle(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorText['red']),
                                              )
                                            : Container(),
                                        SizedBox(
                                            height:
                                                context.appValues.appSize.s10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: SizedBox(
                                                width: context.appValues
                                                    .appSizePercent.w45,
                                                child: CheckboxListTile(
                                                  title: Text(
                                                    translate(
                                                        'login_screen.rememberMe'),
                                                    style:
                                                        getPrimaryRegularStyle(
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xff71727A),
                                                    ),
                                                  ),
                                                  side: const BorderSide(
                                                    color: Color(0xff71727A),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  // Remove padding
                                                  activeColor:
                                                      const Color(0xff71727A),
                                                  checkColor: context.resources
                                                      .color.btnColorBlue,
                                                  dense: true,
                                                  // Make the tile more compact
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  // Checkbox before text
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: -4,
                                                          vertical: -4),
                                                  // Reduce space
                                                  value: _isChecked,
                                                  onChanged: (newValue) async {
                                                    setState(() {
                                                      _isChecked = newValue!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),

                                            // SizedBox(height: context.appValues.appSize.s15),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                child: Text(
                                                  translate(
                                                      'login_screen.forgotPassword'),
                                                  style: getPrimaryRegularStyle(
                                                    color:
                                                        const Color(0xff4100E3),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      _createRoute(
                                                          const ForgotPasswordScreen()));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(25),
                                        SizedBox(
                                          height: 48,
                                          width: context
                                              .appValues.appSizePercent.w100,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff4100E3),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              if (loginViewModel.validate()) {
                                                if (await loginViewModel
                                                    .login()) {
                                                  if (await loginViewModel
                                                      .isActiveUser()) {
                                                    if (loginViewModel
                                                        .isLoggedIn) {
                                                      await loginViewModel
                                                          .setCredentials();
                                                      await categoriesViewModel
                                                          .getCategoriesAndServices();
                                                      await jobsViewModel
                                                          .readJson();
                                                      Navigator.of(context)
                                                          .push(_createRoute(
                                                              BottomBar(
                                                        userRole: loginViewModel
                                                            .userRole,
                                                        currentTab: 0,
                                                      )));
                                                    } else {
                                                      const CircularProgressIndicator();
                                                    }
                                                  }
                                                }
                                              }
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: (isLoading)
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 1.5,
                                                    ))
                                                : Text(
                                                    translate(
                                                        'login_screen.signIn'),
                                                    style:
                                                        getPrimaryRegularStyle(
                                                      color: context.resources
                                                          .color.colorWhite,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  const Gap(15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate('login_screen.signUnMessage'),
                                        style: getPrimaryRegularStyle(
                                          color: const Color(0xff71727A),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Gap(5),
                                      InkWell(
                                        child: Text(
                                          translate('login_screen.signUpNow'),
                                          style: getPrimaryBoldStyle(
                                            color: const Color(0xff4100E3),
                                            fontSize: 12,
                                          ),
                                        ),
                                        onTap: () {
                                          // Navigator.of(context).push(_createRoute(SignUpScreen()));
                                          Navigator.of(context)
                                              // .push(_createRoute(SignUpOnBoardingScreen()));
                                              .push(_createRoute(
                                                  const CountrySelectionScreen()));
                                        },
                                      ),
                                    ],
                                  ),
                                  const Gap(15),
                                  const Divider(
                                    color: Color(0xffD4D6DD),
                                    thickness: 1,
                                  ),
                                  const Gap(10),
                                  Text(
                                    'Or continue with',
                                    style: getPrimaryRegularStyle(
                                      color: const Color(0xff71727A),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Gap(10),
                                  Consumer4<LoginViewModel, CategoriesViewModel,
                                          JobsViewModel, ProfileViewModel>(
                                      builder: (context,
                                          loginViewModel,
                                          categoriesViewModel,
                                          jobsViewModel,
                                          profileViewModel,
                                          error) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p25,
                                      ),
                                      child: SizedBox(
                                        height: 44,
                                        width: context
                                            .appValues.appSizePercent.w100,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            backgroundColor: context
                                                .resources.color.colorWhite,
                                            shape: const RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color(0xffC5C6CC),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoadingGoogle = true;
                                            });
                                            try {
                                              final GoogleSignIn _googleSignIn =
                                                  GoogleSignIn(
                                                scopes: ['email'],
                                              );
                                              // Sign out first to ensure fresh login
                                              await _googleSignIn.signOut();

                                              // Start Google Sign-In
                                              final GoogleSignInAccount?
                                                  googleUser =
                                                  await _googleSignIn.signIn();
                                              if (googleUser == null) {
                                                debugPrint(
                                                    "User canceled Google Sign-In");
                                                return;
                                              }

                                              // Get authentication details from Google
                                              final GoogleSignInAuthentication
                                                  googleAuth = await googleUser
                                                      .authentication;

                                              // Get the ID token (used for Directus authentication)
                                              final String? idToken =
                                                  googleAuth.idToken;
                                              final String? accessToken =
                                                  googleAuth.accessToken;

                                              debugPrint(
                                                  "Google ID Token: $idToken");
                                              debugPrint(
                                                  "access Token: $accessToken");
                                              //
                                              if (idToken == null) {
                                                debugPrint(
                                                    "Error: ID token is null.");
                                                return;
                                              }
                                              //
                                              // // Send the ID token to Directus for authentication
                                              final response = await http.post(
                                                Uri.parse(
                                                    'https://cms.dingdone.app/sso-login/google'),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json',
                                                  'Accept': 'application/json',
                                                },
                                                body: jsonEncode(
                                                    {'idToken': idToken}),
                                              );
                                              //
                                              //
                                              debugPrint(
                                                  'Directus Response Status: ${response.statusCode}');
                                              debugPrint(
                                                  'Directus Response Body: ${response.body}');
                                              //
                                              if (response.statusCode == 200) {
                                                final Map<String, dynamic>
                                                    responseData =
                                                    jsonDecode(response.body);
                                                debugPrint(
                                                    'response data is $responseData');
                                                // Assuming Directus returns a user token
                                                final String directusToken =
                                                    responseData[
                                                        'access_token'];
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                await AppPreferences().save(
                                                    key: userIdKey,
                                                    value: responseData['user'],
                                                    isModel: false);
                                                await prefs.setString(userIdKey,
                                                    '${responseData['user']}');
                                                await AppPreferences().save(
                                                    key: userRoleKey,
                                                    value:
                                                        '008f8da4-ae7c-42f2-a498-68d490fe4593',
                                                    isModel: false);
                                                await prefs.setString(
                                                    userRoleKey,
                                                    '008f8da4-ae7c-42f2-a498-68d490fe4593');

                                                await AppPreferences().save(
                                                    key: userTokenKey,
                                                    value: responseData[
                                                        'access_token'],
                                                    isModel: false);
                                                await prefs.setString(
                                                    userTokenKey,
                                                    '${responseData['access_token']}');

                                                await loginViewModel
                                                    .isActiveUser();
                                                await profileViewModel
                                                    .getProfiledata();

                                                debugPrint(
                                                    "Successfully signed in! Directus Token: $directusToken");

                                                await categoriesViewModel
                                                    .getCategoriesAndServices();
                                                await jobsViewModel.readJson();
                                                // if(profileViewModel.getProfileBody['first_name']!=null
                                                // && profileViewModel.getProfileBody['last_name']!=null
                                                // && profileViewModel.getProfileBody['phone_number']!=null
                                                // && profileViewModel.getProfileBody['email']!=null
                                                // && profileViewModel.getProfileBody['latitude']!=null
                                                // && profileViewModel.getProfileBody['longitude']!=null
                                                // && profileViewModel.getProfileBody['address']!=null
                                                // && profileViewModel.getProfileBody['city']!=null
                                                // && profileViewModel.getProfileBody['street_number']!=null
                                                // && profileViewModel.getProfileBody['building_number']!=null
                                                // && profileViewModel.getProfileBody['floor']!=null
                                                // && profileViewModel.getProfileBody['apartment_number']!=null
                                                // && profileViewModel.getProfileBody['zone']!=null
                                                // && profileViewModel.getProfileBody['address_label']!=null
                                                // && profileViewModel.profileBody['user']['avatar']!=null
                                                // ){
                                                Navigator.of(context).push(
                                                    _createRoute(BottomBar(
                                                  userRole:
                                                      Constants.customerRoleId,
                                                  currentTab: 0,
                                                )));
                                                // }else{
                                                //   Navigator.of(context).push(_createRoute(
                                                //       SignUpNew()));
                                                // }

                                                // TODO: Save token to local storage for future authenticated requests
                                              } else {
                                                debugPrint(
                                                    "Failed to sign in with Directus: ${response.body}");
                                              }
                                              // _handleGoogleSignIn();
                                              // var data =await launchUrl(Uri.parse('https://tuacms.in2apps.xyz/auth/login/google'));
                                              // debugPrint('dataaa $data');
                                              // if (!await launchUrl(Uri.parse('https://tuacms.in2apps.xyz/auth/login/google'))) {
                                              //   throw Exception('Could not launch url');
                                              // }
                                              // loginGoogle();
                                              // _launchGoogleSignIn();
                                            } catch (e) {
                                              debugPrint(
                                                  "Error signing in with Google: $e");
                                            }

                                            setState(() {
                                              isLoadingGoogle = false;
                                            });
                                          },
                                          child: (isLoadingGoogle)
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 1.5,
                                                  ))
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                        'assets/img/014-google.svg'),
                                                    SizedBox(
                                                        width: context.appValues
                                                            .appSize.s10),
                                                    Text(
                                                      translate(
                                                          'login_screen.connectWithGoogle'),
                                                      style:
                                                          getPrimaryRegularStyle(
                                                        color: context.resources
                                                            .color.btnColorBlue,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    );
                                  }),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //     horizontal: context.appValues.appPadding.p25,
                                  //   ),
                                  //   child: SizedBox(
                                  //     height: 56,
                                  //     width: context.appValues.appSizePercent.w100,
                                  //     child: ElevatedButton(
                                  //       style: ElevatedButton.styleFrom(
                                  //         backgroundColor: context.resources.color.colorWhite,
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(context.appValues.appSize.s10),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       onPressed: () {
                                  //         setState(() {
                                  //           isLoadingApple = true;
                                  //         });
                                  //         setState(() {
                                  //           isLoadingApple = false;
                                  //         });
                                  //       },
                                  //       child: (isLoadingApple)
                                  //           ? const SizedBox(
                                  //               width: 16,
                                  //               height: 16,
                                  //               child: CircularProgressIndicator(
                                  //                 color: Colors.white,
                                  //                 strokeWidth: 1.5,
                                  //               ))
                                  //           : Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [
                                  //                 SvgPicture.asset(
                                  //                   'assets/img/applelogo.svg',
                                  //                   width: 24,
                                  //                 ),
                                  //                 SizedBox(
                                  //                     width: context.appValues.appSize.s10),
                                  //                 Text(
                                  //                   translate(
                                  //                       'login_screen.connectWithApple'),
                                  //                   style: getPrimaryRegularStyle(
                                  //                     color: context
                                  //                         .resources.color.secondColorBlue,
                                  //                     fontSize: 22,
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(height: context.appValues.appSize.s15),

                                  const Gap(30),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                );
              }),
        ],
      ),
    );
  }

  void showDemoActionSheet(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String? value) {
      if (value != null) changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(15),
            _languageTile(
              ctx,
              label: translate('language.name.en-US'),
              value: 'en',
              dblangValue: 'en-US',
            ),
            _languageTile(
              ctx,
              label: translate('language.name.ar-SA'),
              value: 'ar',
              dblangValue: 'ar-SA',
            ),
            _languageTile(
              ctx,
              label: translate('language.name.el-GR'),
              value: 'el',
              dblangValue: 'el-GR',
            ),
            _languageTile(
              ctx,
              label: translate('language.name.ru-RU'),
              value: 'ru',
              dblangValue: 'ru-RU',
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p16),
              child: const Divider(
                color: Color(0xffD4D6DD),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.appValues.appPadding.p12,
                horizontal: context.appValues.appPadding.p16,
              ),
              child: InkWell(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  height: 44,
                  width: context.appValues.appSizePercent.w100,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: const Color(0xff4100E3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      translate('button.cancel'),
                      textAlign: TextAlign.center,
                      style: getPrimarySemiBoldStyle(
                        fontSize: 12,
                        color: const Color(0xff4100E3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(
    BuildContext ctx, {
    required String label,
    required String value,
    required String dblangValue,
  }) {
    return ListTile(
      title: Text(
        label,
        style: getPrimaryRegularStyle(
          fontSize: 14,
          color: const Color(0xff180B3C),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xff8F9098),
      ),
      onTap: () async {
        await AppPreferences()
            .save(key: language, value: value, isModel: false);
        await AppPreferences()
            .save(key: dblang, value: dblangValue, isModel: false);
        Navigator.pop(ctx);
        RestartWidget.restartApp(ctx);
      },
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
    backgroundColor: Colors.white,
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
