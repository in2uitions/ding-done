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

  PaymentMethodButtons(
      {super.key,
      required this.payment_method,
      required this.jobsViewModel,
      required this.fromWhere,
      required this.role,
      this.tap_payments_card});

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
    // Call your ViewModel's delete method here
    await Provider.of<PaymentViewModel>(context, listen: false)
        .deletePaymentMethod(paymentMethodId);

  }

  @override
  void initState() {
    super.initState();

    debugPrint('payment card in init ${widget.tap_payments_card}');
    debugPrint('data ${data}');
    if (widget.tap_payments_card == null) {
      _active = "cash";
    } else {
      if (widget.role == Constants.supplierRoleId) {
        List<dynamic> filteredPaymentMethods = widget.payment_method
            .where((paymentMethod) =>
                paymentMethod['id'].toString() ==
                widget.tap_payments_card.toString())
            .toList();
        debugPrint('filteredPaymentMethods: $filteredPaymentMethods');

        if (filteredPaymentMethods.isNotEmpty) {
          _active = filteredPaymentMethods[0]["id"].toString();
          data = filteredPaymentMethods[0];
        } else {
          debugPrint('filteredPaymentMethods is empty');
        }
      } else {
        if(widget.payment_method.length==1){
          widget.tap_payments_card=widget.payment_method[0];
          setState(() {
            _active = widget.payment_method[0]["id"].toString();
            data = widget.payment_method[0];
          });
        }else{
          _active = widget.tap_payments_card["id"].toString();
          data = widget.tap_payments_card;
        }

      }
    }
    Provider.of<PaymentViewModel>(context, listen: false)
        .getPaymentMethodsTap();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Provider.of<PaymentViewModel>(context, listen: false)
    //         .getPaymentMethodsTap(),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         if (snapshot.hasData && snapshot.data != null) {
              return  Consumer<PaymentViewModel>(
                  builder: (context, paymentViewModel, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: paymentViewModel.paymentCards.length + 1,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle tap
                                },
                                child: Column(
                                  children: [
                                    // Removed by Rim to be added later on Cash on Delivery
                                    (widget.fromWhere == translate('jobs.completed') &&
                                                data != null) ||
                                            (widget.role ==
                                                    Constants.supplierRoleId &&
                                                data != null)
                                        ?
                                        // snapshot.data.isNotEmpty?
                                        ButtonConfirmPaymentMethod(
                                            action: active,
                                            tag: "${paymentViewModel.paymentCards![0]['id']}",
                                            active: true,
                                            text: "${paymentViewModel.paymentCards![0]['brand']}",
                                            image: 'assets/img/card-icon.svg',
                                            jobsViewModel: widget.jobsViewModel,
                                            data: paymentViewModel.paymentCards![0]['id'],
                                            last_digits: paymentViewModel.paymentCards![0]
                                                ['last_four'],
                                            payment_method: "Card",
                                            nickname:"${paymentViewModel.paymentCards![0]['name']}",
                                          )
                                        : paymentViewModel.paymentCards.isNotEmpty
                                            ? Container()
                                            : Text(
                                                translate(
                                                    'paymentMethod.noPaymentMethod'),
                                                style: getPrimaryRegularStyle(
                                                  fontSize: 18,
                                                  color: const Color(0xff38385E),
                                                ),
                                              ),
                                    //Removed by Rim to be added later on Cash on Delivery

                                    //     :
                                    // ButtonCahsOnDelevery(
                                    //   action: active,
                                    //   tag: "cash",
                                    //   active: _active == "cash" ? true : false,
                                    //   text: translate('paymentMethod.cashOnDelivery'),
                                    //   image: 'assets/img/cod-icon-new.svg',
                                    //   data: '',
                                    //   payment_method: 'Cash On Delivery',
                                    //   jobsViewModel: widget.jobsViewModel,
                                    //   last_digits: '',
                                    // ),
                                    SizedBox(height: context.appValues.appSize.s10),
                                  ],
                                ),
                              );
                            } else {
                              if (widget.role == Constants.customerRoleId) {
                                var card = paymentViewModel.paymentCards![index - 1];
                                return widget.fromWhere != translate('jobs.completed')
                                    ? Dismissible(
                                        key: Key(card['id'].toString()),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) async {
                                          deletePaymentMethod(
                                              card['id'].toString());

                                        },
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 20),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            debugPrint('card is $card');
                                            // Handle tap
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ButtonConfirmPaymentMethod(
                                                action: active,
                                                tag: "${card['id']}",
                                                active:paymentViewModel.paymentCards.length!=1? _active == "${card['id']}"
                                                    ? true
                                                    : false:true,
                                                text: '${card['brand']}',
                                                image: 'assets/img/card-icon.svg',
                                                jobsViewModel: widget.jobsViewModel,
                                                data: card['id'],
                                                last_digits: card['last_four'],
                                                payment_method: "Card",
                                                nickname:"${card['name']}",

                                              ),
                                              SizedBox(
                                                  height: context
                                                      .appValues.appSize.s10),
                                            ],
                                          ),
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
                }
              );
        //     } else {
        //       return const Center(child: Text('No payment methods available.'));
        //     }
        //   } else if (snapshot.connectionState == ConnectionState.waiting) {
        //     return const Center(child: CircularProgressIndicator());
        //   } else {
        //     return const Center(child: Text('Error loading payment methods.'));
        //   }
        // });
  }
}
