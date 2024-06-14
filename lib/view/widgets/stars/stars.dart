import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:provider/provider.dart';

class Stars extends StatefulWidget {
  var stars;

  Stars({super.key, this.rating = 3.0, this.itemSize = 25, this.itemCount = 5});
  double rating;
  double itemSize;
  int itemCount;
  @override
  State<Stars> createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<JobsViewModel, LoginViewModel>(
        builder: (context, jobsViewModel, loginViewModel, _) {
      return RatingBar.builder(
        initialRating: double.parse(widget.rating.toString()),
        minRating: 1,
        updateOnDrag: false,
        // tapOnlyMode: true,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: widget.itemCount,
        itemSize: widget.itemSize,
        itemPadding:
            EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p2),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: context.resources.color.colorYellow,
        ),
        unratedColor: const Color(0xffE6E6E6),
        onRatingUpdate: (rating) {
          loginViewModel.userRole == Constants.supplierRoleId
              ? ''
              : setState(() {
                  // Update the rating when the stars are clicked
                  widget.rating = rating;
                  jobsViewModel.setUpdatedJob(
                      index: 'rating_stars', value: rating);
                });
        },
      );
    });
  }
}
