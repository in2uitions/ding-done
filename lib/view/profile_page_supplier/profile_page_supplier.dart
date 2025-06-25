import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/settings_screen/settings_screen.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/location_supplier_profile.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/services_offered_supplier.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:dingdone/view_model/dispose_view_model/app_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfilePageSupplier extends StatefulWidget {
  final dynamic data;
  final dynamic list;

  const ProfilePageSupplier({Key? key, required this.data, required this.list})
      : super(key: key);

  @override
  State<ProfilePageSupplier> createState() => _ProfilePageSupplierState();
}

class _ProfilePageSupplierState extends State<ProfilePageSupplier> {
  bool _isLoading = false;
  Future<void> _handleRefresh() async {
    try {

      await Provider.of<ProfileViewModel>(context, listen: false).readJson();

    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Consumer2<ProfileViewModel, LoginViewModel>(
        builder: (context, profileViewModel, loginViewModel, _) {
          return Stack(
            children: [
              Container(
                height: context.appValues.appSizePercent.h50,
                width: context.appValues.appSizePercent.w100,
                decoration: const BoxDecoration(
                  color: Color(0xff4100E3),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: context.appValues.appPadding.p10,
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top row with account title and settings icon
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                            vertical: context.appValues.appPadding.p10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate('profile.account'),
                                style: getPrimaryBoldStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(_createRoute(
                                      const SettingsScreen(),
                                    ));
                                  },
                                  child: SvgPicture.asset(
                                      'assets/img/settings.svg')),
                            ],
                          ),
                        ),
                        // Profile image
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.appValues.appPadding.p10,
                            bottom: context.appValues.appPadding.p15,
                          ),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: profileViewModel
                                                .getProfileBody['user'] !=
                                            null &&
                                        profileViewModel.getProfileBody['user']
                                                ['avatar'] !=
                                            null
                                    ? NetworkImage(
                                        profileViewModel.getProfileBody['user']
                                                    ['avatar']
                                                is Map<String, dynamic>
                                            ? '${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']['filename_disk']}'
                                            : '${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']}',
                                      )
                                    : const NetworkImage(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                              ),
                            ),
                          ),
                        ),
                        // Name and rating information
                        Column(
                          children: [
                            Text(
                              profileViewModel.getProfileBody["user"] != null
                                  ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                                  : '',
                              style: getPrimaryBoldStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(5),
                            // For supplier, we display rating with stars and review count
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stars(
                                  rating: 4, // Adjust rating as needed
                                  itemSize: 18,
                                ),
                                const Gap(5),
                                Text(
                                  '93 reviews',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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
              ),
              // DraggableScrollableSheet for the rest of supplier details
              DraggableScrollableSheet(
                initialChildSize: 0.60,
                minChildSize: 0.60,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Color(0xffFEFEFE),
                      ),
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          const Gap(30),
                          // Supplier location widget
                          const LoacationSupplierProfile(),
                          const Gap(20),
                          // Services offered widget (supplier specific)
                          ServicesOfferedSupplierProfile(
                            profileViewModel: profileViewModel,
                            data: widget.data,
                            list: widget.list,
                          ),
                          const Gap(30),
                          SizedBox(
                            height: context.appValues.appSizePercent.h6,
                            width: context.appValues.appSizePercent.w100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: context.appValues.appSizePercent.w90,
                                  height: context.appValues.appSizePercent.h100,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (await profileViewModel
                                              .patchProfileServices() ==
                                          true) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                simpleAlert(
                                                  context,
                                                  translate('button.success'),
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                simpleAlert(
                                                  context,
                                                  translate('button.failure'),
                                                ));
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff4100E3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            'Save',
                                            style: getPrimaryBoldStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Logout button
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p20,
                              vertical: context.appValues.appPadding.p15,
                            ),
                            child: InkWell(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xff4100E3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/img/logout-new.svg'),
                                    const Gap(10),
                                    Text(
                                      translate('drawer.logout'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 20,
                                        color: const Color(0xff4100E3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                AppPreferences().clear();
                                profileViewModel.clear();
                                AppProviders.disposeAllDisposableProviders(
                                    context);
                                Navigator.of(context)
                                    .push(_createRoute(const LoginScreen()));
                              },
                            ),
                          ),
                          const Gap(30),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// Reusable dialog for success/failure alerts
Widget simpleAlert(BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: SvgPicture.asset('assets/img/x.svg'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        message == translate('button.success')

        // service-popup-image.svg
            ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 17,
              color: context.resources.color.btnColorBlue,
            ),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s20),
      ],
    ),
  );
}

// Custom page route with slide transition
Route _createRoute(dynamic page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
