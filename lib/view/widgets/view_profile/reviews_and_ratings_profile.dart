import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/view_profile/rating_bar.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:flutter/material.dart';

class ReviewsAndRatingsProfile extends StatefulWidget {
  const ReviewsAndRatingsProfile({super.key});

  @override
  State<ReviewsAndRatingsProfile> createState() =>
      _ReviewsAndRatingsProfileState();
}

class _ReviewsAndRatingsProfileState extends State<ReviewsAndRatingsProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        height: context.appValues.appSizePercent.h85,
        width: context.appValues.appSizePercent.w100,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(
                top: context.appValues.appPadding.p15,
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Text(
              'Reviews and Ratings',
              style: getPrimaryRegularStyle(
                  fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          const Divider(
            height: 20,
            thickness: 2,
            color: Color(0xffEDF1F7),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                  right: context.appValues.appPadding.p15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stars(
                    rating: 5,
                    itemSize: 30,
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4.9",
                        style: getPrimaryRegularStyle(
                            fontSize: 22, color: Color(0xff222B45)),
                      ),
                      SizedBox(width: context.appValues.appSize.s20),
                      Text(
                        "93 reviews",
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      ),
                    ],
                  ),
                  SizedBox(height: context.appValues.appSize.s15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5',
                        style: getPrimaryRegularStyle(
                            fontSize: 15, color: Color(0xff222B45)),
                      ),
                      Stars(
                        itemCount: 1,
                        itemSize: 20,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      RatingBar(
                        width: context.appValues.appSizePercent.w45,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        '99%',
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      )
                    ],
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '4',
                        style: getPrimaryRegularStyle(
                            fontSize: 15, color: Color(0xff222B45)),
                      ),
                      Stars(
                        itemCount: 1,
                        itemSize: 20,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      RatingBar(
                        width: context.appValues.appSizePercent.w0,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        '0%',
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      )
                    ],
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '3',
                        style: getPrimaryRegularStyle(
                            fontSize: 15, color: Color(0xff222B45)),
                      ),
                      Stars(
                        itemCount: 1,
                        itemSize: 20,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      RatingBar(
                        width: context.appValues.appSizePercent.w2,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        '1%',
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      )
                    ],
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2',
                        style: getPrimaryRegularStyle(
                            fontSize: 15, color: Color(0xff222B45)),
                      ),
                      Stars(
                        itemCount: 1,
                        itemSize: 20,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      RatingBar(
                        width: context.appValues.appSizePercent.w0,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        '0%',
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      )
                    ],
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: getPrimaryRegularStyle(
                            fontSize: 15, color: Color(0xff222B45)),
                      ),
                      Stars(
                        itemCount: 1,
                        itemSize: 20,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      RatingBar(
                        width: context.appValues.appSizePercent.w0,
                      ),
                      SizedBox(width: context.appValues.appSize.s10),
                      Text(
                        '0%',
                        style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue),
                      )
                    ],
                  ),
                ],
              )),
          const Divider(
            height: 40,
            thickness: 2,
            color: Color(0xffEDF1F7),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w15p5,
                      // width: 115,
                      height: context.appValues.appSizePercent.h7p5,
                      // height: 115,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.jpg?s=612x612&w=0&k=20&c=QjebAlXBgee05B3rcLDAtOaMtmdLjtZ5Yg9IJoiy-VY=',
                            ),
                          )),
                    ),
                    // Image.network(
                    //   'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.jpg?s=612x612&w=0&k=20&c=QjebAlXBgee05B3rcLDAtOaMtmdLjtZ5Yg9IJoiy-VY=',
                    //   width: context.appValues.appSizePercent.w15p5,
                    //   // width: 61,
                    //   height: context.appValues.appSizePercent.h7p5,
                    //   // height: 61,
                    //   fit: BoxFit.cover,
                    // ),
                    SizedBox(width: context.appValues.appSize.s10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Georgie Johnston',
                          style: getPrimaryRegularStyle(
                              fontSize: 15, color: const Color(0xff222B45)),
                        ),
                        Text(
                          'Electrical wiring',
                          style: getPrimaryRegularStyle(
                              fontSize: 13,
                              color: context.resources.color.secondColorBlue),
                        ),
                        Stars(
                          itemSize: 20,
                          rating: 5,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'What a great concept and value. I have wasted weeks trying get in touch with such service.',
                    style: getPrimaryRegularStyle(
                        fontSize: 15, color: Color(0xff222B45)),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'May 02, 2023',
                    style: getPrimaryRegularStyle(
                        fontSize: 13,
                        color: context.resources.color.secondColorBlue),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 40,
            thickness: 2,
            color: Color(0xffEDF1F7),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: context.appValues.appPadding.p15,
                right: context.appValues.appPadding.p15),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w15p5,
                      // width: 115,
                      height: context.appValues.appSizePercent.h7p5,
                      // height: 115,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqoUZ5lfE2DAjZd-aMEJ7zbqnMBey5KMU5xKe77LdbxlJ91_hLU9QI-tQmmVP8qZEsVbY&usqp=CAU',
                            ),
                          )),
                    ),
                    // Image.network(
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqoUZ5lfE2DAjZd-aMEJ7zbqnMBey5KMU5xKe77LdbxlJ91_hLU9QI-tQmmVP8qZEsVbY&usqp=CAU',
                    //   width: context.appValues.appSizePercent.w15p5,
                    //   // width: 61,
                    //   height: context.appValues.appSizePercent.h7p5,
                    //   // height: 61,
                    //   fit: BoxFit.cover,
                    // ),
                    SizedBox(width: context.appValues.appSize.s10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Louise Davis',
                          style: getPrimaryRegularStyle(
                              fontSize: 15, color: const Color(0xff222B45)),
                        ),
                        Text(
                          'Leakage',
                          style: getPrimaryRegularStyle(
                              fontSize: 13,
                              color: context.resources.color.secondColorBlue),
                        ),
                        Stars(
                          itemSize: 20,
                          rating: 5,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Super easy to work with and get connected to a professional. My sink was fixed super fast',
                    style: getPrimaryRegularStyle(
                        fontSize: 15, color: Color(0xff222B45)),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'April 24, 2023',
                    style: getPrimaryRegularStyle(
                        fontSize: 13,
                        color: context.resources.color.secondColorBlue),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
