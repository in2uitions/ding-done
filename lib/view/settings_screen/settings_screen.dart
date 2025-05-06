import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/settings_screen/webview_page.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/jobs_view_model/jobs_view_model.dart';

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
                      translate('settings.settings'),
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
          Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
              return DraggableScrollableSheet(
                initialChildSize: 0.85,
                minChildSize: 0.85,
                maxChildSize: 1,
                builder: (BuildContext context, ScrollController scrollController) {
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
                                translate('settings.appSettings'),
                                style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                              const Gap(20),
                              InkWell(
                                onTap: () => _onActionSheetPress(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/img/lang-settings.svg'),
                                        const Gap(10),
                                        Text(
                                          translate('settings.language'),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/img/bell-settings.svg'),
                                      const Gap(10),
                                      Text(
                                        translate('notifications.notifications'),
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
                                translate('settings.general'),
                                style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                              const Gap(20),

                              // General items
                              _buildGeneralItem(
                                icon: 'assets/img/support-icon-new.svg',
                                label: translate('drawer.support'),
                                onTap: () {
                                  jobsViewModel.launchWhatsApp();
                                },
                              ),
                              const Gap(30),
                              _buildGeneralItem(
                                icon: 'assets/img/about-icon.svg',
                                label: translate('settings.about'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url: 'https://www.dingdone.app/',
                                        title: translate('settings.about'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Gap(30),
                              _buildGeneralItem(
                                icon: 'assets/img/privacy-icon.svg',
                                label: translate('settings.privacyPolicy'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url: 'https://www.dingdone.app/privacy-policy',
                                        title: translate('settings.privacyPolicy'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Gap(30),
                              _buildGeneralItem(
                                icon: 'assets/img/terms-icon.svg',
                                label: translate('drawer.termsAndConditions'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WebViewPage(
                                        url: 'https://www.dingdone.app/user-agreement',
                                        title: translate('drawer.termsAndConditions'),
                                      ),
                                    ),
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
            }
          ),
        ],
      ),
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
