import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../../../../res/fonts/styles_manager.dart';

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
    int selectedIndex = -1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(15),

                // Two items (or however many you need)
                ...List.generate(2, (i) {
                  final isSelected = i == selectedIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = i;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.appValues.appPadding.p12,
                        horizontal: context.appValues.appPadding.p20,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.circle_rounded
                                : Icons.circle_outlined,
                            color: isSelected
                                ? const Color(0xff4100E3)
                                : const Color(0xffC5C6CC),
                            size: 16,
                          ),
                          const Gap(10),
                          SvgPicture.asset(widget.image, width: 32, height: 32),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.nickname != null &&
                                  widget.nickname != 'null')
                                Text(
                                  widget.nickname!,
                                  style: getPrimaryRegularStyle(
                                    fontSize: 14,
                                    color: const Color(0xff190C39),
                                  ),
                                ),
                              Text(
                                "•••• ${widget.last_digits ?? ''}",
                                style: getPrimaryRegularStyle(
                                  fontSize: 12,
                                  color: const Color(0xff190C39),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

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
                          onTap: () => Navigator.pop(ctx),
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
                      SvgPicture.asset(widget.image, width: 32, height: 32),
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
