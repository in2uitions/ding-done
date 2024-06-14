import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/dispose_view_model/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
          vertical: context.appValues.appPadding.p10),
      child: Container(
        height: context.appValues.appSizePercent.h33,
        width: context.appValues.appSizePercent.w100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(
                  top: context.appValues.appPadding.p15,
                  left: context.appValues.appPadding.p15,
                  right: context.appValues.appPadding.p15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: context.resources.color.btnColorBlue),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/img/headphone.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        translate('profile.help'),
                        style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: context.resources.color.btnColorBlue),
                      ),
                    ],
                  ),
                  // SvgPicture.asset('assets/img/right-arrow.svg'),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p15),
            child: const Divider(
              height: 20,
              thickness: 2,
              color: Color(0xffEDF1F7),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: context.resources.color.btnColorBlue),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/img/lock.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        translate('profile.privacyPolicy'),
                        style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: context.resources.color.btnColorBlue),
                      ),
                    ],
                  ),
                  // SvgPicture.asset('assets/img/right-arrow.svg'),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p15),
            child: const Divider(
              height: 20,
              thickness: 2,
              color: Color(0xffEDF1F7),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: context.resources.color.btnColorBlue),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/img/info.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        translate('profile.termsOfUse'),
                        style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: context.resources.color.btnColorBlue),
                      ),
                    ],
                  ),
                  // SvgPicture.asset('assets/img/right-arrow.svg'),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p15),
            child: const Divider(
              height: 20,
              thickness: 2,
              color: Color(0xffEDF1F7),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: context.appValues.appPadding.p5,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: Color(0xffEDF1F7)),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/img/sign-out.svg',
                            color: const Color(0xff04043E),
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        translate('profile.logOut'),
                        style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: context.resources.color.btnColorBlue),
                      ),
                    ],
                  ),
                  // SvgPicture.asset('assets/img/right-arrow.svg'),
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
        ]),
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
