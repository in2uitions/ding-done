import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/jobs_view_model/jobs_view_model.dart';

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
            // 1. Extract the list of addresses (or empty list if null)
            final List<dynamic> addresses =
                (profileViewModel.getProfileBody['address'] as List<dynamic>?) ?? [];

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.85,
              maxChildSize: 1,
              builder: (BuildContext context, ScrollController scrollController) {
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
                    // 2. Show one entry per address
                    itemCount: addresses.length,
                    itemBuilder: (BuildContext context, int index) {
                      // 3. Grab this address
                      final address = addresses[index] as Map<String, dynamic>;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(10),
                            Slidable(
                              key: Key(address['id'].toString()),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (_) async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Delete this address?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                            TextButton(onPressed: () => Navigator.pop(ctx, true),  child: const Text('Delete')),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true) {
                                        Provider.of<ProfileViewModel>(context, listen: false)
                                            .deleteAddress(index);
                                        setState(() {});
                                      }
                                    },
                                    backgroundColor: Colors.transparent,
                                    autoClose: true,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/img/bin.svg',
                                        width: 24,
                                        height: 24,
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    _createRoute(ConfirmAddress(initialAddress: address)),
                                  );
                                },
                                child: Container(
                                  width: context.appValues.appSizePercent.w100,
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorWhite,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: SvgPicture.asset(
                                              'assets/img/locationbookservice.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                          const Gap(10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address['address_label'] as String? ??
                                                    translate('bookService.location'),
                                                style: getPrimaryBoldStyle(
                                                  fontSize: 16,
                                                  color: context.resources.color.btnColorBlue,
                                                ),
                                              ),
                                              Text(
                                                '${address["street_number"] ?? ''} '
                                                    '${address["building_number"] ?? ''}, '
                                                    '${address["apartment_number"] ?? ''}, '
                                                    '${address["floor"] ?? ''}',
                                                style: getPrimaryRegularStyle(
                                                  fontSize: 12,
                                                  color: const Color(0xff71727A),
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

          }
          ),
          Positioned(
            bottom: 20,
            child: Column(
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
                  onPressed: () {
                    final jobsVM = Provider.of<JobsViewModel>(context, listen: false);

                    jobsVM.clearJobsBody(); // implement this in your ViewModel
                    Navigator.of(context).push(
                      _createRoute(ConfirmAddress()),
                    );
                  },
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
            ]
                  ),
          )
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
