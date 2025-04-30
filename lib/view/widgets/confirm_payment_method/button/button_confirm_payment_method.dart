import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../res/fonts/styles_manager.dart';

class ButtonConfirmPaymentMethod extends StatefulWidget {
  final ValueChanged<String> action;
  final ValueChanged<String> onDelete;        // ← new
  final String text, image, tag;
  final bool active;
  final dynamic data;
  final dynamic jobsViewModel;
  final dynamic payment_method;
  final String? last_digits;
  final String? nickname;

  ButtonConfirmPaymentMethod({
    required this.action,
    required this.onDelete,                  // ← require it
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
  State<ButtonConfirmPaymentMethod> createState() => _ButtonConfirmPaymentMethodState();
}

class _ButtonConfirmPaymentMethodState extends State<ButtonConfirmPaymentMethod> {
  void handleTap() {
    widget.action(widget.tag);
    widget.jobsViewModel.setInputValues( index: 'tap_payments_card', value: widget.data );
    widget.jobsViewModel.setUpdatedJob( index: 'tap_payments_card', value: widget.data );
    widget.jobsViewModel.setInputValues( index: 'payment_method',  value: widget.payment_method );
    widget.jobsViewModel.setUpdatedJob( index: 'payment_method',  value: widget.payment_method );
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Delete this card?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Delete')),
        ],
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
              onPressed: handleTap,
              style: ElevatedButton.styleFrom(
                elevation: 0, shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          if (widget.nickname != null && widget.nickname != 'null')
                            Text(widget.nickname!,
                                style: getPrimaryRegularStyle(fontSize: 14, color: const Color(0xff190C39))),
                          Text("•••• ${widget.last_digits ?? ''}",
                              style: getPrimaryRegularStyle(fontSize: 12, color: const Color(0xff190C39))),
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
