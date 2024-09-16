import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  About({
    super.key,
  });

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  late PackageInfo packageInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  Future<void> getPackageInfo() async {
    debugPrint('package info ');

    packageInfo = await PackageInfo.fromPlatform();
    debugPrint('package info $packageInfo');
    setState(() {
      isLoading = false; // Data loaded, stop loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
        return SafeArea(
          child: ListView(
            children: [
              SafeArea(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p20),
                    child: Row(
                      children: [
                        InkWell(
                          child: SvgPicture.asset('assets/img/back.svg'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  translate('formHints.about'),

                  style: getPrimaryRegularStyle(
                      color: context.resources.color.secondColorBlue,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.all(
                  context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : packageInfo != null // Ensure packageInfo is not null
                            ?
                                    Text(
                                      "${packageInfo!.appName} ${packageInfo!.version} (${packageInfo!.buildNumber})",
                                      style: getPrimaryRegularStyle(
                                          color: context.resources.color.btnColorBlue,
                                          fontSize: 15),)
                                    // Text(
                                    //     "Package Name: ${packageInfo!.packageName}"),

                            : Center(
                                child:
                                    Text('Failed to load package information'),
                              ),
                    SizedBox(height: context.appValues.appSize.s20),
                    Text(
                      'Developer Details',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.secondColorBlue,
                          fontSize: 18),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      'In2uitions LLC',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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
