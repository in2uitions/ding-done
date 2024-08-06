import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/button/button_cash_on_delevery.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/button/button_confirm_payment_method.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../view_model/payment_view_model/payment_view_model.dart';

class PaymentMethodButtons extends StatefulWidget {
  var body;
  var payment_method;
  var jobsViewModel;
  var payment_card;
  var fromWhere;
  var role;

  PaymentMethodButtons(
      {super.key,
      required this.payment_method,
      required this.jobsViewModel,
      required this.fromWhere,
      required this.role,
      this.payment_card});

  @override
  State<PaymentMethodButtons> createState() => _PaymentMethodButtonsState();
}

class _PaymentMethodButtonsState extends State<PaymentMethodButtons> {
  String? _active;
  var data;
  void active(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    super.initState();

    debugPrint('payment card in init ${widget.payment_card}');
    if (widget.payment_card == null) {
      _active = "cash";
    } else {
      if (widget.role == Constants.supplierRoleId) {
        List<dynamic> filteredPaymentMethods = widget.payment_method
            .where((paymentMethod) =>
                paymentMethod['id'].toString() ==
                widget.payment_card.toString())
            .toList();
        debugPrint('filteredPaymentMethods: $filteredPaymentMethods');

        if (filteredPaymentMethods.isNotEmpty) {
          _active = filteredPaymentMethods[0]["id"].toString();
          data = filteredPaymentMethods[0];
        } else {
          debugPrint('filteredPaymentMethods is empty');
        }
      } else {
        _active = widget.payment_card["id"].toString();
        data = widget.payment_card;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
        Provider.of<PaymentViewModel>(context, listen: false)
        .getPaymentMethods(),
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length + 1,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          // Handle tap
                        },
                        child: Column(
                          children: [
                            (widget.fromWhere == 'completed' && data != null) ||
                                (widget.role == Constants.supplierRoleId &&
                                    data != null)
                                ? ButtonConfirmPaymentMethod(
                              action: active,
                              tag: "${snapshot.data![0].id}",
                              active: true,
                              text: "${snapshot.data![0].brand}",
                              image: 'assets/img/card-icon.svg',
                              jobsViewModel: widget.jobsViewModel,
                              data: snapshot.data![0].id,
                              last_digits: snapshot.data![0].lastDigits,
                              payment_method: "Card",
                            )
                                : ButtonCahsOnDelevery(
                              action: active,
                              tag: "cash",
                              active: _active == "cash" ? true : false,
                              text: translate('paymentMethod.cashOnDelivery'),
                              image: 'assets/img/cod-icon-new.svg',
                              data: '',
                              payment_method: 'Cash On Delivery',
                              jobsViewModel: widget.jobsViewModel,
                              last_digits: '',
                            ),
                            SizedBox(height: context.appValues.appSize.s10),
                          ],
                        ),
                      );
                    } else {
                      if (widget.role == Constants.customerRoleId) {
                        var card = snapshot.data![index - 1];

                        return widget.fromWhere != 'completed'
                            ? GestureDetector(
                          onTap: () {
                            // Handle tap
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ButtonConfirmPaymentMethod(
                                action: active,
                                tag: "${card['id']}",
                                active: _active == "${card['id']}"
                                    ? true
                                    : false,
                                text: '${card['brand']}',
                                image: 'assets/img/card-icon.svg',
                                jobsViewModel: widget.jobsViewModel,
                                data: card['id'],
                                last_digits: card['last_digits'],
                                payment_method: "Card",
                              ),
                              SizedBox(height: context.appValues.appSize.s10),
                            ],
                          ),
                        )
                            : Container();
                      }
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No payment methods available.'));
        }
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Center(child: Text('Error loading payment methods.'));
      }
      }
    );
  }
}
