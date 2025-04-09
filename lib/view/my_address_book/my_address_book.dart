import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MyaddressBook extends StatefulWidget {
  const MyaddressBook({super.key});

  @override
  State<MyaddressBook> createState() => _MyaddressBookState();
}

class _MyaddressBookState extends State<MyaddressBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top colored header area.
          Container(
            width: context.appValues.appSizePercent.w100,
            height: context.appValues.appSizePercent.h50,
            decoration: const BoxDecoration(
              color: Color(0xff4100E3),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      translate('drawer.myAddressBook'),
                      style: getPrimaryBoldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // DraggableScrollableSheet for the addresses list.
          Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.85,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Color(0xffFEFEFE),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 1, // Adjust if you have multiple addresses.
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(10),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  _createRoute(ConfirmAddress()),
                                );
                              },
                              child: Container(
                                width: context.appValues.appSizePercent.w100,
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorWhite,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: SvgPicture.asset(
                                            'assets/img/locationbookservice.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                        const Gap(10),
                                        // Column with title and detailed address.
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profileViewModel
                                                                  .getProfileBody[
                                                              'current_address'] !=
                                                          null &&
                                                      profileViewModel.getProfileBody[
                                                                  'current_address']
                                                              [
                                                              'address_label'] !=
                                                          null
                                                  ? profileViewModel
                                                              .getProfileBody[
                                                          'current_address']
                                                      ['address_label']
                                                  : translate(
                                                      'bookService.location'),
                                              style: getPrimaryBoldStyle(
                                                fontSize: 16,
                                                color: context.resources.color
                                                    .btnColorBlue,
                                              ),
                                            ),
                                            // Detailed address line.
                                            Text(
                                              profileViewModel.getProfileBody[
                                                          'current_address'] !=
                                                      null
                                                  ? '${profileViewModel.getProfileBody["current_address"]["street_number"]} ${profileViewModel.getProfileBody["current_address"]["building_number"]}, ${profileViewModel.getProfileBody["current_address"]["apartment_number"]}, ${profileViewModel.getProfileBody["current_address"]["floor"]}'
                                                  : '',
                                              style: getPrimaryRegularStyle(
                                                fontSize: 12,
                                                color: const Color(0xff71727A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Trailing arrow icon.
                                    const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 20,
                                      color: Color(0xff8F9098),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(15),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

// Custom route for screen transitions.
Route _createRoute(dynamic page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
