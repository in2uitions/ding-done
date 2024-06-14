import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dingdone/res/app_context_extension.dart';

class StarsDrag extends StatefulWidget {
  StarsDrag({
    super.key,
  });
  @override
  State<StarsDrag> createState() => _StarsDragState();
}

class _StarsDragState extends State<StarsDrag> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: false,
      initialRating: 0,
      minRating: 1,
      updateOnDrag: true,
      tapOnlyMode: false,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 25,
      itemPadding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p5),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color(0xfff7bb23),
      ),
      onRatingUpdate: (v) {},
    );
  }
}
