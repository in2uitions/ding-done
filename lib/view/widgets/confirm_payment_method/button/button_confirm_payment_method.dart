import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../res/fonts/styles_manager.dart';
import '../../../../view_model/payment_view_model/payment_view_model.dart';
import '../../../../view_model/profile_view_model/profile_view_model.dart';
import '../../../confirm_payment_method/confirm_payment_method.dart';

class ButtonConfirmPaymentMethod extends StatefulWidget {
  final ValueChanged<String> action;
  final ValueChanged<String> onDelete; // ← new
  final String text, image, tag;
  final bool active;
  final dynamic data;
  final dynamic jobsViewModel;
  final dynamic payment_method;
  final String? last_digits;
  final String? nickname;

  ButtonConfirmPaymentMethod({
    required this.action,
    required this.onDelete, // ← require it
    required this.text,
    required this.active,
    required this.tag,
    required this.image,
    required this.data,
    required this.jobsViewModel,
    required this.last_digits,
    this.nickname,
    required this.payment_method,
  });

  @override
  State<ButtonConfirmPaymentMethod> createState() =>
      _ButtonConfirmPaymentMethodState();
}

class _ButtonConfirmPaymentMethodState
    extends State<ButtonConfirmPaymentMethod> {
  void handleTap() {
    widget.action(widget.tag);
    widget.jobsViewModel
        .setInputValues(index: 'tap_payments_card', value: widget.data);
    widget.jobsViewModel
        .setUpdatedJob(index: 'tap_payments_card', value: widget.data);
    widget.jobsViewModel
        .setInputValues(index: 'payment_method', value: widget.payment_method);
    widget.jobsViewModel
        .setUpdatedJob(index: 'payment_method', value: widget.payment_method);
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
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    // grab the real list of cards
    final methods = paymentVM.paymentCards ?? <Map<String, dynamic>>[];

    int selectedIndex =
        methods.indexWhere((m) => m['id'].toString() == widget.tag);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(15),
                if (methods.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No payment methods available.',
                      style: getPrimaryRegularStyle(
                          fontSize: 14, color: const Color(0xff190C39)),
                    ),
                  ),
                // now this will iterate over your real cards
                ...methods.asMap().entries.map((entry) {
                  final i = entry.key;
                  final m = entry.value;
                  final isSelected = i == selectedIndex;
                  // pick SVG by brand...
                  String asset = _assetForBrand(m['brand'] as String);
                  return InkWell(
                    onTap: () => setState(() => selectedIndex = i),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.appValues.appPadding.p12,
                        horizontal: context.appValues.appPadding.p20,
                      ),
                      child: Row(children: [
                        Icon(
                            isSelected
                                ? Icons.circle_rounded
                                : Icons.circle_outlined,
                            color: isSelected
                                ? const Color(0xff4100E3)
                                : const Color(0xffC5C6CC),
                            size: 16),
                        const Gap(10),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            asset,
                            fit: BoxFit.contain,
                            // no width/height here, let the container constrain it
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((m['name'] as String?)?.isNotEmpty ?? false)
                              Text(m['name'],
                                  style: getPrimaryRegularStyle(
                                      fontSize: 14,
                                      color: const Color(0xff190C39))),
                            Text("•••• ${m['last_four'] ?? ''}",
                                style: getPrimaryRegularStyle(
                                    fontSize: 12,
                                    color: const Color(0xff190C39))),
                          ],
                        ),
                      ]),
                    ),
                  );
                }).toList(),
                const Gap(5),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: const Divider(color: Color(0xffD4D6DD)),
                ),
                // … your Add/Edit and Select buttons …

                const Gap(5),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: const Divider(color: Color(0xffD4D6DD)),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.appValues.appPadding.p12,
                    horizontal: context.appValues.appPadding.p20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            Navigator.of(context).push(_createRoute(
                                Consumer2<ProfileViewModel, PaymentViewModel>(
                                    builder: (context, profileViewModel,
                                        paymentViewModel, _) {
                              return ConfirmPaymentMethod(
                                payment_method: paymentViewModel
                                    .getPaymentBody['tap_payments_card'],
                                paymentViewModel: paymentViewModel,
                                role: Constants.customerRoleId,
                                profileViewModel: profileViewModel,
                              );
                            })))
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: context.resources.color.colorWhite,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                color: const Color(0xff4100E3),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Add / Edit Methods",
                                style: getPrimarySemiBoldStyle(
                                  fontSize: 12,
                                  color: const Color(0xff4100E3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // here you can read selectedIndex!
                            if (selectedIndex >= 0) {
                              final chosen = methods[selectedIndex] as Map<String,dynamic>;
                              // notify the parent callback
                              widget.action(chosen['id'].toString());
                              // update your jobsViewModel exactly like handleTap would
                              widget.jobsViewModel.setInputValues(
                                index: 'tap_payments_card',
                                value: chosen['id'],
                              );
                              widget.jobsViewModel.setUpdatedJob(
                                index: 'tap_payments_card',
                                value: chosen['id'],
                              );
                              widget.jobsViewModel.setInputValues(
                                index: 'payment_method',
                                value: widget.payment_method,
                              );
                              widget.jobsViewModel.setUpdatedJob(
                                index: 'payment_method',
                                value: widget.payment_method,
                              );
                            }
                            Navigator.pop(ctx);
                            },
                          child: Container(
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xff4100E3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                              child: Text(
                                "Select",
                                style: getPrimarySemiBoldStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
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
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 1));
                      Navigator.pop(context);
                      // Future.delayed(
                      //     const Duration(seconds: 0), () => Navigator.pop(context));
                    },
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/img/remove-card-confirmation-icon.svg'),
            SizedBox(height: context.appValues.appSize.s40),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p0,
              ),
              child: Text(
                // translate('bookService.serviceRequestConfirmed'),
                'Are you sure you want to remove this payment method?',
                textAlign: TextAlign.center,
                style: getPrimaryMediumStyle(
                  fontSize: 14,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
            ),
            const Gap(20),
            InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                width: context.appValues.appSizePercent.w100,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    // translate('confirmAddress.delete'),
                    "Yes, I’m Done With It",
                    style: getPrimarySemiBoldStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // const Gap(20),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      widget.onDelete(widget.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            width: context.appValues.appSizePercent.w100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: ElevatedButton(
              // onPressed: handleTap,
              onPressed: () {
                _onActionSheetPress(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // left side: card details
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          widget.image,
                          fit: BoxFit.contain,
                          // no width/height here, let the container constrain it
                        ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.nickname != null &&
                              widget.nickname != 'null')
                            Text(widget.nickname!,
                                style: getPrimaryRegularStyle(
                                    fontSize: 14,
                                    color: const Color(0xff190C39))),
                          Text("•••• ${widget.last_digits ?? ''}",
                              style: getPrimaryRegularStyle(
                                  fontSize: 12,
                                  color: const Color(0xff190C39))),
                        ],
                      ),
                    ],
                  ),
                  // right side: trash icon
                  GestureDetector(
                    onTap: _confirmAndDelete,
                    child: SvgPicture.asset(
                      'assets/img/bin.svg',
                      width: 24,
                      height: 24,
                      // color: Colors.red,    // or omit color if your SVG is already red
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Color(0xffE5E5E5), thickness: 1.5, height: 1),
        ),
      ],
    );
  }
}
