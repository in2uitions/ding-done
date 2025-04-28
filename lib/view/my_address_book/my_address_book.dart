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
                      style: getPrimarySemiBoldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        _createRoute(ConfirmAddress()),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            context.resources.color.colorWhite,
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
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: SvgPicture.asset(
                                                  'assets/img/locationbookservice.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              const Gap(10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    profileViewModel.getProfileBody[
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
                                                    style:
                                                        getPrimaryRegularStyle(
                                                      fontSize: 14,
                                                      color: context.resources
                                                          .color.btnColorBlue,
                                                    ),
                                                  ),
                                                  Text(
                                                    profileViewModel.getProfileBody[
                                                                'current_address'] !=
                                                            null
                                                        ? '${profileViewModel.getProfileBody["current_address"]["street_number"]} ${profileViewModel.getProfileBody["current_address"]["building_number"]}, ${profileViewModel.getProfileBody["current_address"]["apartment_number"]}, ${profileViewModel.getProfileBody["current_address"]["floor"]}'
                                                        : '',
                                                    style:
                                                        getPrimaryRegularStyle(
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xff71727A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
                      ),
                      // Save button pinned at bottom
                      Column(
                        children: [
                          Divider(
                            color: const Color(0xffE5E5E5),
                            thickness: 1.5,
                            height: context.appValues.appSizePercent.h2,
                          ),
                          SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            height: context.appValues.appSizePercent.h8,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4100E3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  translate('confirmAddress.addNewAddress'),
                                  style: getPrimarySemiBoldStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
