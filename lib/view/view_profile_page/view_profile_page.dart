import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/view_profile/about_profile.dart';
import 'package:dingdone/view/widgets/view_profile/reviews_and_ratings_profile.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF0F3F8),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(children: [
              Container(
                height: context.appValues.appSizePercent.h25,
                decoration: BoxDecoration(
                  color: context.resources.color.btnColorBlue,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
              ),
              Column(
                children: [
                  Transform.translate(
                    offset: Offset(-context.appValues.appSizePercent.w43,
                        context.appValues.appSizePercent.h8),
                    child: InkWell(
                      child: SvgPicture.asset(
                        'assets/img/back-white.svg',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p80,
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10),
                    child: Container(
                      height: context.appValues.appSizePercent.h25,
                      width: context.appValues.appSizePercent.w100,
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(context.appValues.appPadding.p15),
                        child: Stack(children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height:
                                        context.appValues.appSizePercent.h8),
                                Text(
                                  'Souheil Jabbour',
                                  style: getPrimaryRegularStyle(
                                      fontSize: 22,
                                      color:
                                          context.resources.color.btnColorBlue),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stars(
                                      rating: 5,
                                    ),
                                    Text(
                                      '93 reviews',
                                      style: getPrimaryRegularStyle(
                                          fontSize: 15,
                                          color: context
                                              .resources.color.secondColorBlue),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffC5CEE0),
                                    ),
                                    Text(
                                      'Larnaca, Cyprus',
                                      style: getPrimaryRegularStyle(
                                          fontSize: 15,
                                          color: context
                                              .resources.color.btnColorBlue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(
                                0, -context.appValues.appSizePercent.h10),
                            child: Center(
                              child: Container(
                                width: context.appValues.appSizePercent.w30,
                                // width: 115,
                                height: context.appValues.appSizePercent.h14,
                                // height: 115,

                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: context.resources.color
                                          .colorWhite, // Set the border color
                                      width: 4, // Set the border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        20), // Set the border radius
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  AboutProfile(),
                  ReviewsAndRatingsProfile(),
                ],
              ),
            ]),
          ],
        ));
  }
}
