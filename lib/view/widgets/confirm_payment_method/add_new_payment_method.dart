import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_validation.dart';
import 'package:dingdone/view/widgets/custom/custom_dropdown.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class AddNewPaymentMethodWidget extends StatefulWidget {
  const AddNewPaymentMethodWidget({super.key});

  @override
  State<AddNewPaymentMethodWidget> createState() =>
      _AddNewPaymentMethodWidgetState();
}

class _AddNewPaymentMethodWidgetState extends State<AddNewPaymentMethodWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
      return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
        child: Column(
          children: [
            CustomTextField(
              index: 'brand',
              viewModel: paymentViewModel.setInputValues,
              hintText: translate('paymentMethod.cardName'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: context.appValues.appSize.s15),
            CustomTextField(
              index: 'card-number',
              viewModel: paymentViewModel.setInputValues,
              hintText: translate('paymentMethod.cardNumber'),
              validator: (val) => paymentViewModel.paymentError[''],
              errorText: paymentViewModel.paymentError['card-number'],
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: context.appValues.appSize.s15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.appValues.appSizePercent.w28,
                  child: CustomTextField(
                    index: 'expiry_year',
                    viewModel: paymentViewModel.setInputValues,
                    hintText: translate('paymentMethod.expiryYear'),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: context.appValues.appSizePercent.w28,
                  child: CustomTextField(
                    index: 'expiry_month',
                    viewModel: paymentViewModel.setInputValues,
                    hintText: translate('paymentMethod.expiryMonth'),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: context.appValues.appSizePercent.w28,
                  child: CustomTextField(
                    index: 'last_digits',
                    viewModel: paymentViewModel.setInputValues,
                    hintText: translate('paymentMethod.CVC'),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
