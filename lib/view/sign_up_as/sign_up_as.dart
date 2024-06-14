import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/signup/signup_onboarding.dart';
import 'package:dingdone/view/signup/signup_supplier_onboarding.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class SignUpAsScreen extends StatefulWidget {
  const SignUpAsScreen({super.key});

  @override
  State<SignUpAsScreen> createState() => _SignUpAsScreenState();
}

class _SignUpAsScreenState extends State<SignUpAsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFEFEFE),
      body: SafeArea(
        child:
            Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p150,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: SvgPicture.asset('assets/img/back.svg'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: context.appValues.appSizePercent.w100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate('signUp.areYouA'),
                      style: getPrimaryBoldStyle(
                        color: const Color(0xff190C39),
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: context.appValues.appSizePercent.h3),
                    Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF3D347),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: context.resources.color.colorYellow),
                          ),
                        ),
                        onPressed: () {
                          signupViewModel.setInputValues(
                            index: 'role',
                            value: Constants.customerRoleId,
                          );
                          Navigator.of(context)
                              .push(_createRoute(SignUpOnBoardingScreen()));
                        },
                        child: Container(
                          width: context.appValues.appSizePercent.w75,
                          height: context.appValues.appSizePercent.h9,
                          child: Center(
                            child: Text(
                              translate('signUp.customer'),
                              style: getPrimaryBoldStyle(
                                fontSize: 24,
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Consumer<CategoriesViewModel>(
                      builder: (context, categoriesViewModel, _) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            context.appValues.appPadding.p20,
                            context.appValues.appPadding.p0,
                            context.appValues.appPadding.p20,
                            context.appValues.appPadding.p20,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  width: 3,
                                  color: Color(0xff58537A),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              signupViewModel.setInputValues(
                                index: 'role',
                                value: Constants.supplierRoleId,
                              );
                              await categoriesViewModel.getCategories();
                              Navigator.of(context).push(
                                _createRoute(SignUpSupplierOnBoardingScreen()),
                              );
                            },
                            child: Container(
                              width: context.appValues.appSizePercent.w75,
                              height: context.appValues.appSizePercent.h9,
                              child: Center(
                                child: Text(
                                  translate('signUp.supplier'),
                                  style: getPrimaryBoldStyle(
                                    fontSize: 24,
                                    color: const Color(0xff58537A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
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
