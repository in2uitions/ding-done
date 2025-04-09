// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/dispose_view_model/app_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../agreement/user_agreement.dart';
import '../restart/restart_widget.dart';

class ProfileSeconComponent extends StatefulWidget {
  const ProfileSeconComponent({super.key});

  @override
  State<ProfileSeconComponent> createState() => _ProfileSeconComponentState();
}

class _ProfileSeconComponentState extends State<ProfileSeconComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: context.appValues.appPadding.p15,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           SvgPicture.asset(
          //             'assets/img/notifications.svg',
          //           ),
          //           const Gap(10),
          //           Text(
          //             translate('profile.notifications'),
          //             style: getPrimaryRegularStyle(
          //               fontSize: 20,
          //               color: const Color(0xff1F1F39),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: context.appValues.appPadding.p15,
          //     right: context.appValues.appPadding.p100,
          //   ),
          //   child: const Divider(
          //     height: 50,
          //     thickness: 2,
          //     color: Color(0xffEAEAFF),
          //   ),
          // ),
          // Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
          //   return InkWell(
          //     onTap: () {
          //       jobsViewModel.launchWhatsApp();
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: context.appValues.appPadding.p15,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Row(
          //             children: [
          //               SvgPicture.asset(
          //                 'assets/img/headphone.svg',
          //               ),
          //               const Gap(10),
          //               Text(
          //                 translate('profile.help'),
          //                 style: getPrimaryRegularStyle(
          //                   fontSize: 20,
          //                   color: const Color(0xff1F1F39),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: context.appValues.appPadding.p15,
          //     right: context.appValues.appPadding.p100,
          //   ),
          //   child: const Divider(
          //     height: 50,
          //     thickness: 2,
          //     color: Color(0xffEAEAFF),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //       top: context.appValues.appPadding.p5,
          //       left: context.appValues.appPadding.p15,
          //       right: context.appValues.appPadding.p15),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           SvgPicture.asset(
          //             'assets/img/policy.svg',
          //           ),
          //           const Gap(10),
          //           Text(
          //             translate('profile.privacyPolicy'),
          //             style: getPrimaryRegularStyle(
          //               fontSize: 20,
          //               color: const Color(0xff1F1F39),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: context.appValues.appPadding.p15,
          //     right: context.appValues.appPadding.p100,
          //   ),
          //   child: const Divider(
          //     height: 50,
          //     thickness: 2,
          //     color: Color(0xffEAEAFF),
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(_createRoute(UserAgreement(index: null)));
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: context.appValues.appPadding.p5,
          //       left: context.appValues.appPadding.p15,
          //       right: context.appValues.appPadding.p15,
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           children: [
          //             SvgPicture.asset(
          //               'assets/img/termofuse.svg',
          //             ),
          //             const Gap(10),
          //             Text(
          //               translate('profile.termsOfUse'),
          //               style: getPrimaryRegularStyle(
          //                 fontSize: 20,
          //                 color: const Color(0xff1F1F39),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: context.appValues.appPadding.p15,
          //     right: context.appValues.appPadding.p100,
          //   ),
          //   child: const Divider(
          //     height: 50,
          //     thickness: 2,
          //     color: Color(0xffEAEAFF),
          //   ),
          // ),
          // InkWell(
          //   onTap: () => _onActionSheetPress(context),
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: context.appValues.appPadding.p5,
          //       left: context.appValues.appPadding.p15,
          //       right: context.appValues.appPadding.p15,
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           children: [
          //             const Icon(
          //               Icons.language,
          //               size: 30,
          //               color: Colors.deepPurple,
          //             ),
          //             const Gap(10),
          //             Text(
          //               translate('drawer.chooseLanguage'),
          //               style: getPrimaryRegularStyle(
          //                 fontSize: 20,
          //                 color: const Color(0xff1F1F39),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: context.appValues.appPadding.p15,
          //     right: context.appValues.appPadding.p100,
          //   ),
          //   child: const Divider(
          //     height: 50,
          //     thickness: 2,
          //     color: Color(0xffEAEAFF),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(
                // top: context.appValues.appPadding.p5,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: InkWell(
              child: Container(
                width: 327,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.5,
                    color: const Color(0xff4100E3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/logout-new.svg',
                    ),
                    const Gap(10),
                    Text(
                      translate('profile.logOut'),
                      style: getPrimaryBoldStyle(
                        fontSize: 12,
                        color: const Color(0xff4100E3),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                String? lang =
                    await AppPreferences().get(key: language, isModel: false);
                AppPreferences().clear();
                AppProviders.disposeAllDisposableProviders(context);
                Navigator.of(context).push(_createRoute(const LoginScreen()));
                await AppPreferences()
                    .save(key: language, value: lang, isModel: false);
                if (lang == null) {
                  lang = "en";
                  await AppPreferences()
                      .save(key: language, value: "en", isModel: false);
                  await AppPreferences()
                      .save(key: dblang, value: 'en-US', isModel: false);
                }

                if (lang == 'en') {
                  await AppPreferences()
                      .save(key: dblang, value: 'en-US', isModel: false);
                }
                if (lang == 'ar') {
                  await AppPreferences()
                      .save(key: dblang, value: 'ar-SA', isModel: false);
                }
                if (lang == 'ru') {
                  await AppPreferences()
                      .save(key: dblang, value: 'ru-RU', isModel: false);
                }
                if (lang == 'el') {
                  await AppPreferences()
                      .save(key: dblang, value: 'el-GR', isModel: false);
                }
              },
            ),
          ),
        ],
      ),
      // ),
    );
  }
}

void _onActionSheetPress(BuildContext context) {
  showDemoActionSheet(
    context: context,
    child: CupertinoActionSheet(
      title: const Text('Title'),
      message: const Text('Message'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(translate('language.name.en-US')),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'en', isModel: false);
            Navigator.pop(context, 'en');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(translate('language.name.ar-SA')),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'ar', isModel: false);
            Navigator.pop(context, 'ar');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(translate('language.name.el-GR')),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'el', isModel: false);
            Navigator.pop(context, 'el');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(translate('language.name.ru-RU')),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'ru', isModel: false);
            Navigator.pop(context, 'ru');
            RestartWidget.restartApp(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    ),
  );
}

void showDemoActionSheet(
    {required BuildContext context, required Widget child}) {
  showCupertinoModalPopup<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then((String? value) {
    if (value != null) changeLocale(context, value);
  });
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
