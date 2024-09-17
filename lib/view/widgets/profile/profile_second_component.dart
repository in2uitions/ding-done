// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/dispose_view_model/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../view_model/jobs_view_model/jobs_view_model.dart';

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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/img/notifications.svg',
                    ),
                    const Gap(10),
                    Text(
                      translate('profile.notifications'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff1F1F39),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.appValues.appPadding.p15,
              right: context.appValues.appPadding.p100,
            ),
            child: const Divider(
              height: 50,
              thickness: 2,
              color: Color(0xffEAEAFF),
            ),
          ),
          Consumer< JobsViewModel>(
              builder: (context, jobsViewModel, _) {

                return InkWell(
                onTap: (){
                  jobsViewModel.launchWhatsApp();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/img/headphone.svg',
                          ),
                          const Gap(10),
                          Text(
                            translate('profile.help'),
                            style: getPrimaryRegularStyle(
                              fontSize: 20,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.appValues.appPadding.p15,
              right: context.appValues.appPadding.p100,
            ),
            child: const Divider(
              height: 50,
              thickness: 2,
              color: Color(0xffEAEAFF),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: context.appValues.appPadding.p5,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/img/policy.svg',
                    ),
                    const Gap(10),
                    Text(
                      translate('profile.privacyPolicy'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff1F1F39),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.appValues.appPadding.p15,
              right: context.appValues.appPadding.p100,
            ),
            child: const Divider(
              height: 50,
              thickness: 2,
              color: Color(0xffEAEAFF),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: context.appValues.appPadding.p5,
              left: context.appValues.appPadding.p15,
              right: context.appValues.appPadding.p15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/img/termofuse.svg',
                    ),
                    const Gap(10),
                    Text(
                      translate('profile.termsOfUse'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff1F1F39),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.appValues.appPadding.p15,
              right: context.appValues.appPadding.p100,
            ),
            child: const Divider(
              height: 50,
              thickness: 2,
              color: Color(0xffEAEAFF),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                // top: context.appValues.appPadding.p5,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/img/logout-new.svg',
                      ),
                      const Gap(10),
                      Text(
                        translate('profile.logOut'),
                        style: getPrimaryRegularStyle(
                          fontSize: 20,
                          color: const Color(0xff78789D),
                        ),
                      ),
                    ],
                  ),
                ],
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
