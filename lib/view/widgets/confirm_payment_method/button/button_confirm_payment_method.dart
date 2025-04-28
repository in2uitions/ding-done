

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/fonts/styles_manager.dart';

class ButtonConfirmPaymentMethod extends StatefulWidget {
  final ValueChanged<String> action;
  final String text, image, tag;
  final bool active;
  var data;
  var jobsViewModel;
  var payment_method;
  var last_digits;
  var nickname;

  ButtonConfirmPaymentMethod(
      {required this.action,
      required this.text,
      required this.active,
      required this.tag,
      required this.image,
      required this.data,
      required this.jobsViewModel,
      required this.last_digits,
      this.nickname,
      required this.payment_method});

  @override
  State<ButtonConfirmPaymentMethod> createState() => _ButtonConfirmPaymentMethodState();
}
class _ButtonConfirmPaymentMethodState extends State<ButtonConfirmPaymentMethod> {

  void handleTap() {
    widget.action(widget.tag);
    widget.jobsViewModel.setInputValues(index: 'tap_payments_card', value: widget.data);
    widget.jobsViewModel.setUpdatedJob(index: 'tap_payments_card', value: widget.data);
    widget.jobsViewModel.setInputValues(
        index: 'payment_method', value: widget.payment_method);
    widget.jobsViewModel.setUpdatedJob(index: 'payment_method', value: widget.payment_method);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.action(widget.tag);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugPrint('hello from the othe side ');
    //   widget.jobsViewModel.setInputValuesWithoutNotify(index: 'tap_payments_card', value: widget.data);
    //   widget.jobsViewModel.setUpdatedJobWithoutNotify(index: 'tap_payments_card', value: widget.data);
    //   widget.jobsViewModel.setInputValuesWithoutNotify(
    //       index: 'payment_method', value: widget.payment_method);
    //   widget.jobsViewModel.setUpdatedJobWithoutNotify(index: 'payment_method', value: widget.payment_method);
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.active ? const Color(0xff190C39) : const Color(0xffEBF0F9),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: ElevatedButton(
          onPressed: handleTap,
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent, // Use transparent background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.9,
              70,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(widget.image),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: getPrimaryRegularStyle(
                          fontSize: 18,
                          color: const Color(0xff190C39),
                        ),
                      ),
                      widget.nickname!=null && widget.nickname!='null'?
                      Text(
                        widget.nickname,
                        style: getPrimaryRegularStyle(
                          fontSize: 13,
                          color: const Color(0xff190C39),
                        ),
                      ):Container(),
                      Text(
                        widget.last_digits ?? '',
                        style: getPrimaryRegularStyle(
                          fontSize: 15,
                          color: const Color(0xff190C39),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff190C39),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
