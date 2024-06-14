import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/profile/profile_component.dart';
import 'package:dingdone/view/widgets/profile/profile_second_component.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
      backgroundColor: const Color(0xffFEFEFE),
      // backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                    ),
                    child: Container(
                      width: context.appValues.appSizePercent.w38p5,
                      // width: 151,
                      height: context.appValues.appSizePercent.h18p8,
                      // height: 151,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff8E889E),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            profileViewModel.getProfileBody['user'] != null &&
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      profileViewModel.getProfileBody["user"] != null
                          ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                          : '',
                      style: getPrimaryRegularStyle(
                          fontSize: 32,
                          color: context.resources.color.btnColorBlue),
                    ),
                    Text(
                      profileViewModel.getProfileBody["user"] != null
                          ? '${profileViewModel.getProfileBody["user"]["email"]}'
                          : '',
                      style: getPrimaryRegularStyle(
                        fontSize: 24,
                        color: context.resources.color.btnColorBlue
                            .withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.appValues.appSizePercent.h4),
               ProfileComponent(
                            // payment_method: data.data,
                            role: profileViewModel.getProfileBody["user"] != null
                                ? profileViewModel.getProfileBody["user"]["role"]
                                : '',
                          ),

                SizedBox(height: context.appValues.appSizePercent.h2),
                const ProfileSeconComponent(),
              ],
            ),
          ],
        );
      }),
    );
  }
}
