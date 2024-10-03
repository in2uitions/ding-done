import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart'; // Optional for shimmer effect

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20, // Same padding as NotificationWidget
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Skeleton
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                      const Gap(7),
                      // Message Skeleton
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: context.appValues.appSizePercent.w75,
                          height: 15,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Time Skeleton
              //     Shimmer.fromColors(
              //       baseColor: Colors.grey[300]!,
              //       highlightColor: Colors.grey[100]!,
              //       child: Container(
              //         width: 50,
              //         height: 15,
              //         color: Colors.grey[300],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          const Divider(
            color: Color(0xffEAEAFF),
            height: 35,
          ),
        ],
      ),
    );
  }
}
