import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardInfoWidget extends StatefulWidget {
  CardInfoWidget({super.key, required this.image});
  String image;

  @override
  State<CardInfoWidget> createState() => _CardInfoWidgetState();
}

class _CardInfoWidgetState extends State<CardInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 69,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffD4D6DD),
          width: 1,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(widget.image),
      ),
    );
  }
}
