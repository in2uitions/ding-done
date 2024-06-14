import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class CardInfoWidget extends StatefulWidget {
  CardInfoWidget({super.key, required this.image, required this.name});
  String name, image;

  @override
  State<CardInfoWidget> createState() => _CardInfoWidgetState();
}

class _CardInfoWidgetState extends State<CardInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.appValues.appSizePercent.w22,
      child: Column(
        children: [
          Image.asset(widget.image),
          Text(
            widget.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getPrimaryBoldStyle(
                fontSize: 7, color: context.resources.color.btnColorBlue),
          ),
        ],
      ),
    );
  }
}
