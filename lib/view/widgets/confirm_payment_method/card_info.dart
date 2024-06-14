import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/cards_info_widget.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({super.key});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p15),
      child: Wrap(
        children: [
          CardInfoWidget(
            image: 'assets/img/mastercard.png',
            name: 'Mastercard',
          ),
          CardInfoWidget(
            image: 'assets/img/visa.png',
            name: 'Visa Card',
          ),
          CardInfoWidget(
            image: 'assets/img/naps.png',
            name: 'Qatar ATM Cards',
          ),
          CardInfoWidget(
            image: 'assets/img/himyan.png',
            name: 'Himyan card',
          ),
          // CardInfoWidget(
          //   image: 'assets/img/cards_cash.png',
          //   name: 'Card & cash On delivery',
          // ),
        ],
      ),
    );
  }
}
