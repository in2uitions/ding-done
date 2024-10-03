import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.onTap,
  });

  String title, message, time;
  dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Stack(
                    //   children: [
                    //     Container(
                    //       width: 76,
                    //       height: 76,
                    //       decoration: const BoxDecoration(
                    //         borderRadius: BorderRadius.only(
                    //           bottomLeft:
                    //               Radius.circular(50),
                    //           bottomRight:
                    //               Radius.circular(50),
                    //           topRight: Radius.circular(50),
                    //         ),
                    //         image: DecorationImage(
                    //             image: NetworkImage(
                    //               'https://t3.ftcdn.net/jpg/06/07/84/82/240_F_607848231_w5iFN4tMmtI2woJjMh7Q8mGvgARnzHgQ.jpg',
                    //             ),
                    //             fit: BoxFit.cover),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       top: 7,
                    //       left: 7,
                    //       child: Container(
                    //         width: 8,
                    //         height: 8,
                    //         decoration: BoxDecoration(
                    //           color:
                    //               const Color(0xff583EF2),
                    //           borderRadius:
                    //               BorderRadius.circular(50),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getPrimaryBoldStyle(
                            fontSize: 14,
                            color: const Color(0xff1F1F39),
                          ),

                        ),
                        const Gap(7),
                        SizedBox(
                          width: context.appValues.appSizePercent.w75,
                          child: Text(
                            message,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryRegularStyle(
                              fontSize: 14,
                              color: const Color(0xff78789D),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: getPrimaryBoldStyle(
                        fontSize: 14,
                        color: const Color(0xff78789D),
                      ),
                    ),
                    // const Gap(7),
                    // Container(
                    //   width: 25,
                    //   height: 26,
                    //   decoration: const BoxDecoration(
                    //     color: Color(0xff6E6BE8),
                    //     borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(50),
                    //       bottomLeft: Radius.circular(50),
                    //       bottomRight: Radius.circular(50),
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       '1',
                    //       style: getPrimaryBoldStyle(
                    //         fontSize: 11,
                    //         color: context.resources.color.colorWhite,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
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
