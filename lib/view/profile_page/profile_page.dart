import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/profile/profile_component.dart';
import 'package:dingdone/view/widgets/profile/profile_second_component.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      // backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffEAEAFF).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.appValues.appPadding.p10,
                ),
                child: Row(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p10,
                          bottom: context.appValues.appPadding.p15,
                          left: context.appValues.appPadding.p20,
                        ),
                        child: Container(
                          width: 102,
                          height: 102,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                profileViewModel.getProfileBody['user'] !=
                                            null &&
                                        profileViewModel.getProfileBody['user']
                                                ['avatar'] !=
                                            null
                                    ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                                    : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileViewModel.getProfileBody["user"] != null
                              ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                              : '',
                          style: getPrimaryRegularStyle(
                            fontSize: 25,
                            color: const Color(0xff1F126B),
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/img/email-home.svg'),
                            const Gap(5),
                            Text(
                              profileViewModel.getProfileBody["user"] != null
                                  ? '${profileViewModel.getProfileBody["user"]["email"]}'
                                  : '',
                              style: getPrimaryRegularStyle(
                                fontSize: 18,
                                color: const Color(0xff1F126B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            ProfileComponent(
              // payment_method: data.data,
              role: profileViewModel.getProfileBody["user"] != null
                  ? profileViewModel.getProfileBody["user"]["role"]
                  : '',
            ),

            // SizedBox(height: context.appValues.appSizePercent.h2),
            Padding(
              padding: EdgeInsets.only(
                left: context.appValues.appPadding.p35,
                right: context.appValues.appPadding.p115,
              ),
              child: const Divider(
                height: 50,
                thickness: 2,
                color: Color(0xffEAEAFF),
              ),
            ),
            const ProfileSeconComponent(),
          ],
        );
      }),
    );
  }
}
