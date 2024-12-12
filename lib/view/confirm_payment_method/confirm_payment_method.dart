// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/add_new_payment_method.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/card_info.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class ConfirmPaymentMethod extends StatefulWidget {
  var payment_method;
  var role;

  var paymentViewModel;

  ConfirmPaymentMethod(
      {super.key,
      required this.payment_method,
      required this.paymentViewModel,
      required this.role});

  @override
  State<ConfirmPaymentMethod> createState() => _ConfirmPaymentMethodState();
}

class _ConfirmPaymentMethodState extends State<ConfirmPaymentMethod> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.paymentViewModel.setInputValues(
    //     index: 'nickname', value: '');
    // widget.paymentViewModel.setInputValues(
    //     index: 'card_number', value: '');
    // widget.paymentViewModel.setInputValues(
    //     index: 'expiry_month', value: '');
    // widget.paymentViewModel.setInputValues(
    //     index: 'expiry_year', value: '');
    // widget.paymentViewModel.setInputValues(
    //     index: 'last_digits', value: '');
  }
  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileViewModel, JobsViewModel, PaymentViewModel>(builder:
        (context, profileViewModel, jobsViewModel, paymentViewModel, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SafeArea(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                      ),
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: Text(
                    translate('paymentMethod.confirmPaymentMethod'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 32),
                  ),
                ),
                const Gap(30),
                const CardInfo1(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p20,
                    vertical: context.appValues.appPadding.p20,
                  ),
                  child: Text(
                    translate('paymentMethod.addPaymentMethod'),
                    style: getPrimaryRegularStyle(
                        fontSize: 28,
                        color: context.resources.color.btnColorBlue),
                  ),
                ),
                AddNewPaymentMethodWidget(
                    payment_method: widget.payment_method),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                  ),
                  child: Text(
                    translate('paymentMethod.paymentMethods'),
                    style: getPrimaryRegularStyle(
                        fontSize: 28,
                        color: context.resources.color.btnColorBlue),
                  ),
                ),
                PaymentMethodButtons(
                  payment_method: widget.payment_method,
                  jobsViewModel: jobsViewModel,
                  fromWhere: 'confirm_payment',
                  role: widget.role,
                ),
                const Gap(60),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: context.appValues.appSizePercent.h10,
                width: context.appValues.appSizePercent.w100,
                // decoration: BoxDecoration(
                //   borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       topRight: Radius.circular(20)),
                //   color: context.resources.color.btnColorBlue,
                // ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.appValues.appPadding.p10,
                    horizontal: context.appValues.appPadding.p15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.appValues.appSizePercent.w90,
                        height: context.appValues.appSizePercent.h100,
                        child: ElevatedButton(
                          onPressed: () async {
                            dynamic payments = await widget.paymentViewModel
                                .getPaymentMethods();
                            debugPrint('widget payment ${payments}');
                            var found = false;
                            if(payments.isNotEmpty){
                              for (var payment in payments) {
                                if (payment['card_number'] ==
                                    widget.paymentViewModel
                                        .getPaymentBody['card_number']) {
                                  found = true;
                                }
                              }
                            }

                            if (!found) {
                              await widget.paymentViewModel
                                  .createPaymentMethodTap();
                              await widget.paymentViewModel.getPaymentMethods();
                              Navigator.of(context).pop();
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => Navigator.of(context).push(
                                          _createRoute(ConfirmPaymentMethod(
                                        payment_method: widget.payment_method,
                                        paymentViewModel:
                                            widget.paymentViewModel,
                                        role: Constants.customerRoleId,
                                      ))));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      simpleAlert(
                                          context,
                                          translate('button.failure'),
                                          'Card Number is already chosen'));
                            }

                            },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff4100E3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            translate('paymentMethod.addPaymentMethod'),
                            style: getPrimaryRegularStyle(
                              fontSize: 18,
                              color: context.resources.color.colorWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

Widget simpleAlert(BuildContext context, String message, String message2) {
  return AlertDialog(
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: SvgPicture.asset('assets/img/x.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(seconds: 0),
                      () => Navigator.of(context).pop());
                },
              ),
            ],
          ),
        ),
        message == 'Success'
            ? SvgPicture.asset('assets/img/service-popup-image.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            message2,
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 17,
              color: context.resources.color.btnColorBlue,
            ),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s20),
      ],
    ),
  );
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
