import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/settings_screen/webview_page.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/dispose_view_model/app_view_model.dart';
import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../../res/constants.dart';
import '../login/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: context.appValues.appSizePercent.w100,
            height: context.appValues.appSizePercent.h50,
            decoration: const BoxDecoration(
              color: Color(0xff4100E3),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'settings.settings'.tr(),
                      style: getPrimarySemiBoldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // White draggable sheet
          Consumer<JobsViewModel>(
            builder: (context, jobsViewModel, _) {
              return DraggableScrollableSheet(
                initialChildSize: 0.85,
                minChildSize: 0.85,
                maxChildSize: 1,
                builder: (BuildContext context,
                    ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffFEFEFE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(30),

                              // App Settings section
                              Text(
                                'settings.appSettings'.tr(),
                                style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                              const Gap(20),

                              InkWell(
                                onTap: () => _onActionSheetPress(context),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/img/lang-settings.svg'),
                                        const Gap(10),
                                        Text(
                                          'settings.language'.tr(),
                                          style: getPrimaryRegularStyle(
                                            fontSize: 14,
                                            color: const Color(0xff180B3C),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 12,
                                      color: Color(0xff8F9098),
                                    ),
                                  ],
                                ),
                              ),

                              const Gap(20),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/img/bell-settings.svg'),
                                      const Gap(10),
                                      Text(
                                        'notifications.notifications'.tr(),
                                        style: getPrimaryRegularStyle(
                                          fontSize: 14,
                                          color: const Color(0xff180B3C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: _notificationsEnabled,
                                    activeColor: const Color(0xff4100E3),
                                    onChanged: (bool value) {
                                      setState(() {
                                        _notificationsEnabled = value;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              const Gap(20),
                              const Divider(
                                color: Color(0xffD4D6DD),
                                thickness: 1,
                                height: 1,
                              ),
                              const Gap(20),

                              Text(
                                'settings.general'.tr(),
                                style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                              const Gap(20),

                              // General items
                              _buildGeneralItem(
                                icon: 'assets/img/support-icon-new.svg',
                                label: 'drawer.support'.tr(),
                                onTap: () {
                                  jobsViewModel.launchWhatsApp();
                                },
                              ),
                              const Gap(30),

                              _buildGeneralItem(
                                icon: 'assets/img/about-icon.svg',
                                label: 'settings.about'.tr(),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url: 'https://www.dingdone.app/',
                                        title: 'settings.about'.tr(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Gap(30),

                              _buildGeneralItem(
                                icon: 'assets/img/privacy-icon.svg',
                                label: 'settings.privacyPolicy'.tr(),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url:
                                        'https://www.dingdone.app/privacy-policy',
                                        title: 'settings.privacyPolicy'.tr(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Gap(30),

                              _buildGeneralItem(
                                icon: 'assets/img/terms-icon.svg',
                                label: 'drawer.termsAndConditions'.tr(),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url:
                                        'https://www.dingdone.app/user-agreement',
                                        title: 'drawer.termsAndConditions'.tr(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Gap(30),

                              Consumer<ProfileViewModel>(
                                builder: (context, profileViewModel, _) {
                                  return _buildGeneralItem(
                                    icon: 'assets/img/bin.svg',
                                    label: 'drawer.deleteAccount'.tr(),
                                    onTap: () {
                                      _confirmAndDelete(profileViewModel);
                                    },
                                  );
                                },
                              ),

                              const Gap(40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(ProfileViewModel profileViewModel) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: SvgPicture.asset('assets/img/x.svg'),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/img/remove-card-confirmation-icon.svg'),
            SizedBox(height: context.appValues.appSize.s40),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p0,
              ),
              child: Text(
                'drawer.delete?'.tr(),
                textAlign: TextAlign.center,
                style: getPrimaryMediumStyle(
                  fontSize: 14,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
            ),
            const Gap(20),
            InkWell(
              onTap: () async {
                Navigator.pop(context, true);

                dynamic value = await profileViewModel.deleteProfile();
                if (value["status"].toString().toLowerCase() == 'ok') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        simpleAlert(context, 'button.success'.tr(),profileViewModel),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        simpleAlert(context, 'button.failure'.tr(),profileViewModel),
                  );
                }
              },
              child: Container(
                width: context.appValues.appSizePercent.w100,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Yes, I’m Done With It'
                        , // was hardcoded
                    style: getPrimarySemiBoldStyle(
                      fontSize: 12,
                      color: Colors.white,
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

  // Widget simpleAlert(BuildContext context, String message,ProfileViewModel profileViewModel) {
  //   final success = message == 'button.success'.tr();
  //
  //   return AlertDialog(
  //     backgroundColor: Colors.white,
  //     elevation: 15,
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               InkWell(
  //                 child: SvgPicture.asset('assets/img/x.svg'),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   if(message == 'button.success'.tr()){
  //                     Navigator.pop(context);
  //                     AppPreferences().clear();
  //                     profileViewModel.clear();
  //                     AppProviders.disposeAllDisposableProviders(
  //                         context);
  //                     Navigator.of(context)
  //                         .push(_createRoute(const LoginScreen()));
  //
  //                   }
  //
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         success
  //             ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
  //             : SvgPicture.asset('assets/img/failure.svg'),
  //         SizedBox(height: context.appValues.appSize.s40),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             message,
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ),
  //         success ? SizedBox(height: context.appValues.appSize.s20) : Container(),
  //         success
  //             ? Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             'profile.requestSent'.tr(), // was "Request Sent"
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         )
  //             : Container(),
  //         SizedBox(height: context.appValues.appSize.s20),
  //       ],
  //     ),
  //   );
  // }
  Widget simpleAlert(
      BuildContext context,
      String message,
      ProfileViewModel profileViewModel,
      ) {
    final success = message == 'button.success'.tr();

    return WillPopScope(
      onWillPop: () async => false, // 🚫 disable back button
      child: AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ❌ Close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: SvgPicture.asset('assets/img/x.svg'),
                  onTap: success
                      ? () => _logoutAndGoToLogin(context, profileViewModel)
                      : () => Navigator.pop(context),
                ),
              ],
            ),

            success
                ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
                : SvgPicture.asset('assets/img/failure.svg'),

            SizedBox(height: context.appValues.appSize.s30),

            Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 16,
                color: context.resources.color.btnColorBlue,
              ),
            ),

            if (success) ...[
              const Gap(10),
              Text(
                'Request Sent',
                textAlign: TextAlign.center,
                style: getPrimaryRegularStyle(
                  fontSize: 16,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
            ],

            const Gap(25),

            // ✅ OK BUTTON
            InkWell(
              onTap: success
                  ? () => _logoutAndGoToLogin(context, profileViewModel)
                  : () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'button.ok'.tr(),
                    style: getPrimarySemiBoldStyle(
                      fontSize: 13,
                      color: Colors.white,
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
  void _logoutAndGoToLogin(
      BuildContext context,
      ProfileViewModel profileViewModel,
      ) {
    Navigator.pop(context); // close dialog
    Navigator.pop(context); // close settings screen

    AppPreferences().clear();
    profileViewModel.clear();
    AppProviders.disposeAllDisposableProviders(context);

    Navigator.of(context).pushAndRemoveUntil(
      _createRoute(const LoginScreen()),
          (route) => false,
    );
  }

  Widget _buildGeneralItem({
    required String icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon),
              const Gap(10),
              Text(
                label,
                style: getPrimaryRegularStyle(
                  fontSize: 14,
                  color: const Color(0xff180B3C),
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 12,
            color: Color(0xff8F9098),
          ),
        ],
      ),
    );
  }

  // Kept your function signature; only replaced changeLocale with easy_localization.
  void showDemoActionSheet({required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String? value) async {
      if (value != null) {
        await context.setLocale(Locale(value)); // ✅ replacement for changeLocale
      }
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
              label: 'language.name.en-US'.tr(),
              value: 'en',
              dblangValue: 'en-US',
            ),
            _languageTile(
              ctx,
              label: 'language.name.ar-SA'.tr(),
              value: 'ar',
              dblangValue: 'ar-SA',
            ),
            _languageTile(
              ctx,
              label: 'language.name.el-GR'.tr(),
              value: 'el',
              dblangValue: 'el-GR',
            ),
            _languageTile(
              ctx,
              label: 'language.name.ru-RU'.tr(),
              value: 'ru',
              dblangValue: 'ru-RU',
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p16,
              ),
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
                      'button.cancel'.tr(),
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
        // ✅ keeping EXACT same AppPreferences.save calls/keys/values
        await AppPreferences()
            .save(key: language, value: value, isModel: false);
        await AppPreferences()
            .save(key: dblang, value: dblangValue, isModel: false);

        // ✅ also update easy_localization locale before restart
        await context.setLocale(Locale(value));

        Navigator.pop(ctx);
        RestartWidget.restartApp(ctx);
      },
    );
  }

  Route _createRoute(dynamic classname) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => classname,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
