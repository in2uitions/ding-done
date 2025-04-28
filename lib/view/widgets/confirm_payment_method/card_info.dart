import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/cards_info_widget.dart';
import 'package:flutter/material.dart';

class CardInfo1 extends StatefulWidget {
  const CardInfo1({super.key});

  @override
  State<CardInfo1> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardInfoWidget(
            image: 'assets/img/logos_mastercard.svg',
          ),
          CardInfoWidget(
            image: 'assets/img/logos_visa.svg',
          ),
          CardInfoWidget(
            image: 'assets/img/logos_naps.svg',
          ),
          CardInfoWidget(
            image: 'assets/img/logos_himyan.svg',
          ),
        ],
      ),
    );
  }
}
