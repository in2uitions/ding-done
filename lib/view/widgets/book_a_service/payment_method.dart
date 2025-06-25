import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../view_model/profile_view_model/profile_view_model.dart';
import '../confirm_payment_method/button/button_confirm_payment_method.dart';

class PaymentMethod extends StatefulWidget {
  var body,
      payment_method,
      paymentViewModel,
      jobsViewModel,
      tap_payments_card,
      fromWhere,
      role;

  PaymentMethod(
      {super.key,
      required this.payment_method,
      required this.paymentViewModel,
      required this.jobsViewModel,
      required this.fromWhere,
      required this.role,
      this.tap_payments_card});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    // initialize from what was passed in, or null
    _selectedId = widget.tap_payments_card?.toString();
  }

  // helper to pick the right SVG asset
  String _assetForBrand(String brand) {
    switch (brand.toUpperCase()) {
      case 'MASTERCARD':
        return 'assets/img/logos_mastercard.svg';
      case 'VISA':
        return 'assets/img/logos_visa.svg';
      case 'NAPS':
        return 'assets/img/logos_naps.svg';
      case 'HIMYAN':
        return 'assets/img/logos_himyan.svg';
      default:
        return 'assets/img/card-icon.svg';
    }
  }

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
                              style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: context.resources.color.btnColorBlue),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Consumer<PaymentViewModel>(builder: (ctx, paymentVM, _) {
                  final cards = paymentVM.paymentCards ?? [];

                  // If no cards at all, show message
                  if (cards.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20),
                      child: Text(
                        translate('paymentMethod.noPaymentMethod'),
                        style: getPrimaryRegularStyle(
                          fontSize: 18,
                          color: const Color(0xff38385E),
                        ),
                      ),
                    );
                  }

                  // find the index of the previously selected card, or default to first
                  final idx = (_selectedId != null)
                      ? cards
                          .indexWhere((c) => c['id'].toString() == _selectedId)
                      : -1;
                  final selectedCard = (idx >= 0) ? cards[idx] : cards[0];
                  widget.jobsViewModel.setInputValues(
                    index: 'tap_payments_card',
                    value: selectedCard['id'],
                  );
                  // build a single ButtonConfirmPaymentMethod
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p0),
                    child: ButtonConfirmPaymentMethod(
                      // when the sheet calls widget.action, this runs:
                      action: (tag) {
                        // update local UI
                        setState(() => _selectedId = tag);
                        // mirror your old handleTap logic on the chosen card:
                        widget.jobsViewModel.setInputValues(
                          index: 'tap_payments_card',
                          value: selectedCard,
                        );
                        widget.jobsViewModel.setUpdatedJob(
                          index: 'tap_payments_card',
                          value: selectedCard,
                        );
                        widget.jobsViewModel.setInputValues(
                          index: 'payment_method',
                          value: 'Card',
                        );
                        widget.jobsViewModel.setUpdatedJob(
                          index: 'payment_method',
                          value: 'Card',
                        );
                      },
                      onDelete: (tag) async {
                        final ok = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this card?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            ) ==
                            true;
                        if (ok) {
                          await Provider.of<PaymentViewModel>(context,
                                  listen: false)
                              .deletePaymentMethod(tag);
                          setState(() {
                            // if we deleted the selected card, reset selection:
                            if (_selectedId == tag) _selectedId = null;
                          });
                        }
                      },
                      tag: selectedCard['id'].toString(),
                      text: selectedCard['brand'] ?? '',
                      image: _assetForBrand(selectedCard['brand'] as String),
                      data: selectedCard['id'],
                      jobsViewModel: widget.jobsViewModel,
                      last_digits: selectedCard['last_four'] ?? '',
                      payment_method: 'Card',
                      nickname: selectedCard['name'] ?? '',
                      active: true,
                    ),
                  );
                }),
                // PaymentMethodButtons(
                //   fromWhere: widget.fromWhere,
                //   jobsViewModel: widget.jobsViewModel,
                //   payment_method: widget.payment_method,
                //   tap_payments_card: widget.tap_payments_card,
                //   role: widget.role,
                // ),
                // widget.fromWhere != translate('jobs.completed')
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: context.appValues.appPadding.p20,
                //         ),
                //         child: InkWell(
                //           child: Container(
                //             decoration: const BoxDecoration(
                //               color: Color(0xffF4F3FD),
                //               borderRadius: BorderRadius.all(
                //                 Radius.circular(15),
                //               ),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: context.appValues.appPadding.p20,
                //                 vertical: context.appValues.appPadding.p15,
                //               ),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   SvgPicture.asset('assets/img/addmedia.svg'),
                //                   const Gap(10),
                //                   Text(
                //                     translate('paymentMethod.addMethod'),
                //                     style: getPrimaryBoldStyle(
                //                       fontSize: 18,
                //                       color: const Color(0xff4100E3),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //           onTap: () {
                //             Navigator.of(context).push(_createRoute(
                //                 Consumer2<ProfileViewModel, PaymentViewModel>(
                //                     builder: (context, profileViewModel,
                //                         paymentViewModel, _) {
                //               return ConfirmPaymentMethod(
                //                 payment_method: paymentViewModel
                //                     .getPaymentBody['tap_payments_card'],
                //                 paymentViewModel: widget.paymentViewModel,
                //                 role: widget.role,
                //                 profileViewModel: profileViewModel,
                //               );
                //             })));
                //           },
                //         ),
                //       )
                //     : Container(),
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
