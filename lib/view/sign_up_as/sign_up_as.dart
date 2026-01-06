import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/signup/signup_new.dart';
import 'package:dingdone/view/signup/signup_new_supplier.dart';
import 'package:dingdone/view/signup/signup_onboarding.dart';
import 'package:dingdone/view/signup/signup_supplier_onboarding.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class SignUpAsScreen extends StatefulWidget {
  const SignUpAsScreen({super.key});

  @override
  State<SignUpAsScreen> createState() => _SignUpAsScreenState();
}

class _SignUpAsScreenState extends State<SignUpAsScreen> {
  bool _isCustomerLoading = false;
  bool _isSupplierLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: SafeArea(
        child: Consumer<SignUpViewModel>(
          builder: (context, signupViewModel, _) {
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
                    textDirection: ui.TextDirection.ltr,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color:
                          context.resources.color.colorBlack[50],
                          size: 20,
                        ),
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
                        'Get started as a',
                        style: getPrimaryBoldStyle(
                          color:
                          context.resources.color.btnColorBlue,
                          fontSize: 18,
                        ),
                      ),
                      const Gap(10),

                      /// CUSTOMER BUTTON
                      Padding(
                        padding: EdgeInsets.all(
                          context.appValues.appPadding.p20,
                        ),
                        child: InkWell(
                          onTap: _isCustomerLoading
                              ? null
                              : () async {
                            setState(() =>
                            _isCustomerLoading = true);

                            signupViewModel.setInputValues(
                              index: 'role',
                              value:
                              Constants.customerRoleId,
                            );

                            await Navigator.of(context).push(
                              _createRoute(
                                  const SignUpNew()),
                            );

                            if (mounted) {
                              setState(() =>
                              _isCustomerLoading = false);
                            }
                          },
                          child: Container(
                            width: context
                                .appValues.appSizePercent.w80,
                            height: context
                                .appValues.appSizePercent.h6,
                            decoration: BoxDecoration(
                              color: const Color(0xff4100E3),
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: _isCustomerLoading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                  : Text(
                                'signUp.customer'.tr(),
                                style: getPrimaryBoldStyle(
                                  fontSize: 14,
                                  color: context.resources
                                      .color.colorWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// SUPPLIER BUTTON
                      Consumer<CategoriesViewModel>(
                        builder: (context,
                            categoriesViewModel, _) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              context.appValues.appPadding.p20,
                              context.appValues.appPadding.p0,
                              context.appValues.appPadding.p20,
                              context.appValues.appPadding.p20,
                            ),
                            child: InkWell(
                              onTap: _isSupplierLoading
                                  ? null
                                  : () async {
                                setState(() =>
                                _isSupplierLoading =
                                true);

                                signupViewModel.setInputValues(
                                  index: 'role',
                                  value: Constants
                                      .supplierRoleId,
                                );

                                await categoriesViewModel
                                    .getCategoriesAndServices();

                                await Navigator.of(context)
                                    .push(
                                  _createRoute(
                                      SignUpNewSupplier()),
                                );

                                if (mounted) {
                                  setState(() =>
                                  _isSupplierLoading =
                                  false);
                                }
                              },
                              child: Container(
                                width: context.appValues
                                    .appSizePercent.w80,
                                height: context.appValues
                                    .appSizePercent.h6,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFC500),
                                  borderRadius:
                                  BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: _isSupplierLoading
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<
                                          Color>(
                                        Color(
                                            0xff4100E3),
                                      ),
                                    ),
                                  )
                                      : Text(
                                    'signUp.supplier'.tr(),
                                    style:
                                    getPrimaryBoldStyle(
                                      fontSize: 14,
                                      color: context
                                          .resources
                                          .color
                                          .btnColorBlue,
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
          },
        ),
      ),
    );
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) =>
    classname,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween =
      Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
