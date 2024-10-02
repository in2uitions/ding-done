import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

class PaymentMethod extends StatefulWidget {
  var body,
      payment_method,
      paymentViewModel,
      jobsViewModel,
      payment_card,
      fromWhere,
      role;

  PaymentMethod(
      {super.key,
      required this.payment_method,
      required this.paymentViewModel,
      required this.jobsViewModel,
      required this.fromWhere,
      required this.role,
      this.payment_card});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
        child: Container(
          width: context.appValues.appSizePercent.w100,
          // height: context.appValues.appSizePercent.h33,
          // height: context.appValues.appSizePercent.h30,
          // decoration: BoxDecoration(
          //   color: context.resources.color.colorWhite,
          //   borderRadius: const BorderRadius.all(Radius.circular(20)),
          // ),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.appValues.appPadding.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.fromWhere != translate('jobs.completed')
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                            vertical: context.appValues.appPadding.p10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('paymentMethod.paymentMethod'),
                              style: getPrimaryBoldStyle(
                                  fontSize: 20,
                                  color: context.resources.color.btnColorBlue),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                PaymentMethodButtons(
                  fromWhere: widget.fromWhere,
                  jobsViewModel: widget.jobsViewModel,
                  payment_method: widget.payment_method,
                  payment_card: widget.payment_card,
                  role: widget.role,
                ),
                widget.fromWhere != translate('jobs.completed')
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: InkWell(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffF4F3FD),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p15,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/img/addmedia.svg'),
                                  const Gap(10),
                                  Text(
                                    translate('paymentMethod.addMethod'),
                                    style: getPrimaryBoldStyle(
                                      fontSize: 18,
                                      color: const Color(0xff4100E3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(_createRoute(ConfirmPaymentMethod(
                              payment_method: widget.payment_method,
                              paymentViewModel: widget.paymentViewModel,
                              role: widget.role,
                            )));
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
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
