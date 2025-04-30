import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/button/button_confirm_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../res/fonts/styles_manager.dart';
import '../../../view_model/payment_view_model/payment_view_model.dart';

class PaymentMethodButtons extends StatefulWidget {
  var body;
  var payment_method;
  var jobsViewModel;
  var tap_payments_card;
  var fromWhere;
  var role;

  PaymentMethodButtons({
    super.key,
    required this.payment_method,
    required this.jobsViewModel,
    required this.fromWhere,
    required this.role,
    this.tap_payments_card,
  });

  @override
  State<PaymentMethodButtons> createState() => _PaymentMethodButtonsState();
}

class _PaymentMethodButtonsState extends State<PaymentMethodButtons> {
  String? _active;
  var data;

  void active(String btn) {
    setState(() => _active = btn);
  }

  Future<void> deletePaymentMethod(String paymentMethodId) async {
    await Provider.of<PaymentViewModel>(context, listen: false)
        .deletePaymentMethod(paymentMethodId);
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.tap_payments_card == null) {
      _active = "cash";
    } else if (widget.role == Constants.supplierRoleId) {
      final filtered = widget.payment_method.where((pm) =>
      pm['id'].toString() == widget.tap_payments_card.toString()).toList();
      if (filtered.isNotEmpty) {
        _active = filtered[0]['id'].toString();
        data = filtered[0];
      }
    } else if (widget.payment_method.length == 1) {
      data = widget.payment_method[0];
      _active = data['id'].toString();
    } else {
      data = widget.tap_payments_card;
      _active = data['id'].toString();
    }
    Provider.of<PaymentViewModel>(context, listen: false)
        .getPaymentMethodsTap();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(builder: (context, vm, _) {
      final cards = vm.paymentCards ?? [];
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: cards.length + 1,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  if ((widget.fromWhere == translate('jobs.completed') ||
                      widget.role == Constants.supplierRoleId) &&
                      cards.isNotEmpty) {
                    final pm = cards[0] as Map<String, dynamic>;
                    return Column(
                      children: [
                        ButtonConfirmPaymentMethod(
                          action: active,
                          tag: pm['id'].toString(),
                          active: true,
                          text: pm['brand'] ?? '',
                          image: pm['brand'].toString().toUpperCase() == 'MASTERCARD'
                              ? 'assets/img/logos_mastercard.svg'
                              : pm['brand'].toString().toUpperCase() == 'VISA'
                              ? 'assets/img/logos_visa.svg'
                              : pm['brand'].toString().toUpperCase() == 'NAPS'
                              ? 'assets/img/logos_naps.svg'
                              : pm['brand'].toString().toUpperCase() == 'HIMYAN'
                              ? 'assets/img/logos_himyan.svg'
                              : 'assets/img/card-icon.svg',
                          jobsViewModel: widget.jobsViewModel,
                          data: pm['id'],
                          last_digits: pm['last_four'] ?? '',
                          payment_method: 'Card',
                          nickname: pm['name'] ?? '',  onDelete: (tag) async {
                          final ok = await _showDeleteConfirmDialog(context);
                          if (ok) {
                            await deletePaymentMethod(tag);
                            setState((){}); // refresh the list
                          }
                        },
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                      ],
                    );
                  }
                  return cards.isEmpty
                      ? Text(
                    translate('paymentMethod.noPaymentMethod'),
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff38385E),
                    ),
                  )
                      : const SizedBox.shrink();
                }
                if (widget.role == Constants.customerRoleId) {
                  final card = cards[index - 1] as Map<String, dynamic>;
                  if (widget.fromWhere != translate('jobs.completed')) {
                    // return Dismissible(
                    //   key: Key(card['id'].toString()),
                    //   direction: DismissDirection.endToStart,
                    //   confirmDismiss: (_) async {
                    //     final confirm = await _showDeleteConfirmDialog(context);
                    //     if (confirm) {
                    //       await deletePaymentMethod(card['id'].toString());
                    //     }
                    //     return confirm;
                    //   },
                    //   background: Container(
                    //     color: Colors.red,
                    //     alignment: Alignment.centerRight,
                    //     padding: const EdgeInsets.only(right: 20),
                    //     child: const Icon(
                    //       Icons.delete,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   child:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonConfirmPaymentMethod(
                            action: active,
                            tag: card['id'].toString(),
                            active: cards.length == 1 ||
                                _active == card['id'].toString(),
                            text: card['brand'] ?? '',
                            image: card['brand'].toString().toUpperCase() ==
                                'MASTERCARD'
                                ? 'assets/img/logos_mastercard.svg'
                                : card['brand'].toString().toUpperCase() == 'VISA'
                                ? 'assets/img/logos_visa.svg'
                                : card['brand'].toString().toUpperCase() == 'NAPS'
                                ? 'assets/img/logos_naps.svg'
                                : card['brand'].toString().toUpperCase() == 'HIMYAN'
                                ? 'assets/img/logos_himyan.svg'
                                : 'assets/img/card-icon.svg',
                            jobsViewModel: widget.jobsViewModel,
                            data: card['id'],
                            last_digits: card['last_four'] ?? '',
                            payment_method: 'Card',
                            nickname: card['name'] ?? '',  onDelete: (tag) async {
                            final ok = await _showDeleteConfirmDialog(context);
                            if (ok) {
                              await deletePaymentMethod(tag);
                              setState((){}); // refresh the list
                            }
                          },
                          ),
                          SizedBox(height: context.appValues.appSize.s10),
                        ],
                      );
                    // );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      );
    });
  }
}
