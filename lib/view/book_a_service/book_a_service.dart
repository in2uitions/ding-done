// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/widgets/book_a_service/add_media.dart';
import 'package:dingdone/view/widgets/book_a_service/date_picker.dart';
import 'package:dingdone/view/widgets/book_a_service/payment_method.dart';
import 'package:dingdone/view/widgets/custom/custom_increment_number_request.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:dingdone/view/widgets/custom/custom_time_picker.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../my_address_book/my_address_book.dart';

class BookAService extends StatefulWidget {
  BookAService({super.key,
    required this.service,
    required this.lang,
    required this.image});

  dynamic service;
  dynamic lang;
  dynamic image;

  @override
  State<BookAService> createState() => _BookAServiceState();
}

class _BookAServiceState extends State<BookAService> {
  bool isLumpsum = false;
  var _matchingRate;

  String _getServiceRate(ProfileViewModel profileViewModel,
      JobsViewModel jobsViewModel) {
    // Extract the currency from job address
    String currency =
    profileViewModel.getProfileBody['current_address']["country"];
    // Find the rate from country_rates where currency matches
    var matchingRate = widget.service["country_rates"].firstWhere(
          (rate) => rate["country"]['code'] == currency,
      orElse: () => null, // If no match is found, return null
    );

    if (matchingRate != null) {
      _matchingRate = matchingRate;
      debugPrint('_matchingRate ${_matchingRate['unit_rate']}');
      debugPrint(
          'jobsViewModel.getjobsBodynumber_of_units ${jobsViewModel
              .getjobsBody['number_of_units']}');
      // Check the job type and return the appropriate rate
      if (matchingRate["unit_type"].toString().toLowerCase() == 'lumpsum') {
        isLumpsum = true;
      }
      if (profileViewModel.getProfileBody['current_address']['job_type'] ==
          'inspection') {
        return matchingRate['inspection_rate'] ?? 'No rate available';
      } else {
        return '${jobsViewModel.getjobsBody['number_of_units'] != null ? (int
            .parse(jobsViewModel.getjobsBody['number_of_units']) *
            int.parse(matchingRate['unit_rate'].toString())) : (int.parse(
            matchingRate['minimum_order'].toString()) * int.parse(
            matchingRate['unit_rate']
                .toString()))} ${matchingRate["country"]["currency"]}';
      }
    } else {
      return 'Rate not found'; // Fallback if no matching currency is found
    }
  }

  String _getUnitPrice(ProfileViewModel profileViewModel) {
    // Extract the currency from job address
    String currency =
    profileViewModel.getProfileBody['current_address']["country"];
    // Find the rate from country_rates where currency matches
    var matchingRate = widget.service["country_rates"].firstWhere(
          (rate) => rate["country"]['code'] == currency,
      orElse: () => null, // If no match is found, return null
    );

    if (matchingRate != null) {
      _matchingRate = matchingRate;
      debugPrint('_matchingRate ${_matchingRate['unit_rate']}');

      if (profileViewModel.getProfileBody['current_address']['job_type'] ==
          'inspection') {
        return matchingRate['inspection_rate'] ?? 'No rate available';
      } else {
        return '${int.parse(matchingRate['unit_rate']
            .toString())} ${matchingRate["country"]["currency"]}';
      }
    } else {
      return 'Rate not found'; // Fallback if no matching currency is found
    }
  }

  String _getType(ProfileViewModel profileViewModel) {
    // Extract the currency from job address
    String currency =
    profileViewModel.getProfileBody['current_address']["country"];
    // Find the rate from country_rates where currency matches
    var matchingRate = widget.service["country_rates"].firstWhere(
          (rate) => rate["country"]['code'] == currency,
      orElse: () => null, // If no match is found, return null
    );
    debugPrint('lang rate is ${widget.lang}');
    if (widget.lang == null) {
      widget.lang = "en-US";
    }
    if (matchingRate != null) {
      var matchingType;
      debugPrint('matching rate is ${matchingRate["unit_type"]}');
      for (Map<String, dynamic> translation in matchingRate["unit_type"]
      ["translations"]) {
        if (translation["languages_code"] == widget.lang) {
          matchingType = translation["name"];
          break; // Break the loop once the translation is found
        }
      }
      return '${matchingType}';
    } else {
      return 'Rate not found'; // Fallback if no matching currency is found
    }
  }

  void showDemoActionSheet(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String? value) {
      if (value != null) changeLocale(context, value);
    });
  }

  // void _onActionSheetPress(BuildContext context) {
  //   int selectedIndex = -1;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(32),
  //         topRight: Radius.circular(32),
  //       ),
  //     ),
  //     builder: (ctx) => StatefulBuilder(
  //       builder: (ctx, setState) {
  //         return SafeArea(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Gap(15),
  //
  //               // Two items (or however many you need)
  //               ...List.generate(2, (i) {
  //                 final isSelected = i == selectedIndex;
  //                 return Consumer<ProfileViewModel>(
  //                     builder: (context, profileViewModel, _) {
  //                   return InkWell(
  //                     onTap: () {
  //                       setState(() {
  //                         selectedIndex = i;
  //                       });
  //                     },
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: context.appValues.appPadding.p12,
  //                         horizontal: context.appValues.appPadding.p20,
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Icon(
  //                             isSelected
  //                                 ? Icons.circle_rounded
  //                                 : Icons.circle_outlined,
  //                             color: isSelected
  //                                 ? const Color(0xff4100E3)
  //                                 : const Color(0xffC5C6CC),
  //                             size: 16,
  //                           ),
  //                           const Gap(10),
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               // Location SVG icon
  //                               SvgPicture.asset(
  //                                 'assets/img/locationbookservice.svg',
  //                                 width: 20,
  //                                 height: 20,
  //                               ),
  //                               const Gap(10),
  //                               // Column with a title and the current location or hint
  //                               Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     translate('bookService.location'),
  //                                     style: getPrimaryRegularStyle(
  //                                       fontSize: 16,
  //                                       color: context
  //                                           .resources.color.btnColorBlue,
  //                                     ),
  //                                   ),
  //                                   Text(
  //                                     '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
  //                                     style: getPrimaryRegularStyle(
  //                                       fontSize: 12,
  //                                       color: const Color(0xff71727A),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 });
  //               }),
  //
  //               const Gap(5),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(
  //                     horizontal: context.appValues.appPadding.p20),
  //                 child: const Divider(color: Color(0xffD4D6DD)),
  //               ),
  //
  //               Padding(
  //                 padding: EdgeInsets.symmetric(
  //                   vertical: context.appValues.appPadding.p12,
  //                   horizontal: context.appValues.appPadding.p20,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: InkWell(
  //                         onTap: () => Navigator.pop(ctx),
  //                         child: Container(
  //                           height: 44,
  //                           decoration: BoxDecoration(
  //                             color: context.resources.color.colorWhite,
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(12)),
  //                             border: Border.all(
  //                               color: const Color(0xff4100E3),
  //                               width: 1.5,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "Add / Edit Methods",
  //                               style: getPrimarySemiBoldStyle(
  //                                 fontSize: 12,
  //                                 color: const Color(0xff4100E3),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const Gap(15),
  //                     Expanded(
  //                       child: InkWell(
  //                         onTap: () {
  //                           // here you can read selectedIndex!
  //                           Navigator.pop(ctx);
  //                         },
  //                         child: Container(
  //                           height: 44,
  //                           decoration: const BoxDecoration(
  //                             color: Color(0xff4100E3),
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(12)),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "Select",
  //                               style: getPrimarySemiBoldStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }


  void _onActionSheetPress(BuildContext context) {
    final addresses = (Provider
        .of<ProfileViewModel>(context, listen: false)
        .getProfileBody['address'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    int selectedIndex = addresses.indexWhere((addr) =>
    addr['id'] == Provider
        .of<ProfileViewModel>(context, listen: false)
        .getProfileBody['current_address']['id']);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (ctx) =>
          StatefulBuilder(
            builder: (ctx, setState) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(15),

                    // --- Loop over every address
                    ...List.generate(addresses.length, (i) {
                      final addr = addresses[i];
                      final isSelected = i == selectedIndex;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.appValues.appPadding.p12,
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() => selectedIndex = i);
                          },
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.circle_rounded
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? const Color(0xff4100E3)
                                    : const Color(0xffC5C6CC),
                                size: 16,
                              ),
                              const Gap(10),
                              SvgPicture.asset(
                                'assets/img/locationbookservice.svg',
                                width: 20,
                                height: 20,
                              ),
                              const Gap(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('bookService.location'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 16,
                                        color: context.resources.color
                                            .btnColorBlue,
                                      ),
                                    ),
                                    Text(
                                      '${addr["street_number"]} ${addr["building_number"]}, Apt ${addr["apartment_number"]}, Floor ${addr["floor"]}',
                                      style: getPrimaryRegularStyle(
                                        fontSize: 12,
                                        color: const Color(0xff71727A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Gap(5),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p20,
                      ),
                      child: const Divider(color: Color(0xffD4D6DD)),
                    ),

                    // --- Bottom buttons (unchanged)
                    Consumer2<JobsViewModel, ProfileViewModel>(
                        builder: (ctx, jobsVM, profVM, _) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.appValues.appPadding.p12,
                              horizontal: context.appValues.appPadding.p20,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      var addr =
                                      profVM.getProfileBody['current_address'];
                                      jobsVM.setInputValues(
                                          index: 'job_address', value: addr);
                                      jobsVM.setInputValues(
                                        index: 'address',
                                        value:
                                        '${addr['street_number']} ${addr['building_number']}, ${addr['apartment_number']}, ${addr['floor']}',
                                      );
                                      jobsVM.setInputValues(
                                          index: 'latitude',
                                          value: addr['latitude']);
                                      jobsVM.setInputValues(
                                          index: 'longitude',
                                          value: addr['longitude']);
                                      jobsVM.setInputValues(
                                          index: 'payment_method',
                                          value: 'Card');
                                      Navigator.of(context).push(
                                          _createRoute(const MyaddressBook()));
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: context.resources.color
                                            .colorWhite,
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                          color: const Color(0xff4100E3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Add / Edit Methods",
                                          style: getPrimarySemiBoldStyle(
                                            fontSize: 12,
                                            color: const Color(0xff4100E3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // 1) Update your ProfileViewModel
                                      Provider.of<ProfileViewModel>(
                                          context, listen: false)
                                          .setCurrentAddress(
                                          addresses[selectedIndex]);
                                      // 2) Close the sheet
                                      Navigator.pop(ctx);
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff4100E3),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Select",
                                          style: getPrimarySemiBoldStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPayment();

  }
getPayment() async{
  await Provider.of<PaymentViewModel>(context, listen: false)
      .getPaymentMethodsTap();
}
  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileViewModel,
        JobsViewModel,
        ServicesViewModel,
        PaymentViewModel>(
        builder: (context, profileViewModel, jobsViewModel, servicesViewModel,
            paymentViewModel, _) {
          Map<String, dynamic>? services;
          Map<String, dynamic>? categories;

          for (Map<String, dynamic> translation in widget
              .service["translations"]) {
            debugPrint('transss ${translation}');
            if (translation["languages_code"] == widget.lang) {
              services = translation;
              break; // Break the loop once the translation is found
            }
          }
          for (Map<String, dynamic> translations in widget.service["category"]
          ["translations"]) {
            if (translations["languages_code"] == widget.lang) {
              categories = translations;
              break; // Break the loop once the translation is found
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xffFEFEFE),
            body: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p0),
                      child: Stack(
                        children: [
                          Container(
                            width: context.appValues.appSizePercent.w100,
                            height: context.appValues.appSizePercent.h50,
                            decoration: const BoxDecoration(
                              color: Color(0xff4100E3),
                              // image: DecorationImage(
                              //   image: NetworkImage(widget.image),
                              //   fit: BoxFit.cover,
                              // ),
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
                                    const Gap(5),
                                    Text(
                                      translate('bookService.bookService'),
                                      style: getPrimarySemiBoldStyle(
                                        color: context.resources.color
                                            .colorWhite,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: SizedBox(
                                width: context.appValues.appSizePercent.w80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categories != null
                                          ? '${categories["title"]}'
                                          : '',
                                      style: getPrimaryBoldStyle(
                                        fontSize: 16,
                                        color: context.resources.color
                                            .btnColorBlue,
                                      ),
                                    ),
                                    Text(
                                      services != null
                                          ? '${services["title"]}'
                                          : '',
                                      style: getPrimaryBoldStyle(
                                        fontSize: 10,
                                        color: const Color(0xff6E6BE8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                    initialChildSize: 0.85,
                    minChildSize: 0.85,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffFEFEFE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: 1,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              // 1) Grab the **subcategory** translation:
                              Map<String, dynamic>? subCatTrans;
                              for (var t
                              in widget.service["translations"] as List) {
                                if (t["languages_code"] == widget.lang) {
                                  subCatTrans = t;
                                  break;
                                }
                              }

                              // 2) (Optional) Grab the **parent** category translation too:
                              Map<String, dynamic>? parentCatTrans;
                              for (var t in widget.service["category"]
                              ["translations"] as List) {
                                if (t["languages_code"] == widget.lang) {
                                  parentCatTrans = t;
                                  break;
                                }
                              }

                              return Column(
                                children: [
                                  const Gap(30),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        context.appValues.appPadding.p20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 76,
                                              height: 76,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffEAEAFF),
                                                borderRadius:
                                                BorderRadius.circular(16),
                                              ),
                                            ),
                                            const Gap(20),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: context
                                                      .appValues.appSizePercent
                                                      .w62,
                                                  child: Text(
                                                    subCatTrans != null
                                                        ? '${subCatTrans!["title"]}'
                                                        : '',
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style: getPrimarySemiBoldStyle(
                                                      fontSize: 16,
                                                      color: context.resources
                                                          .color
                                                          .btnColorBlue,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: context
                                                      .appValues.appSizePercent
                                                      .w62,
                                                  child: Text(
                                                    categories != null
                                                        ? '${parentCatTrans!['title']
                                                        .toString()
                                                        .toUpperCase()}'
                                                        : 'Leak',
                                                    maxLines: 3,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style: getPrimarySemiBoldStyle(
                                                      fontSize: 10,
                                                      color:
                                                      const Color(0xff6E6BE8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Gap(15),
                                        Text(
                                          '${subCatTrans!['description']}',
                                          style: getPrimaryRegularStyle(
                                            fontSize: 12,
                                            //
                                            color: const Color(0xff190C39),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(15),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        context.appValues.appPadding.p20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                            context.appValues.appPadding.p0,
                                            vertical:
                                            context.appValues.appPadding.p10,
                                          ),
                                          child: Text(
                                            translate(
                                                'bookService.jobDescription'),
                                            style: getPrimaryMediumStyle(
                                              fontSize: 16,
                                              color: context
                                                  .resources.color.btnColorBlue,
                                            ),
                                          ),
                                        ),
                                        CustomTextArea(
                                          index: 'job_description',
                                          hintText: translate(
                                              'bookService.jobDescription'),
                                          viewModel: jobsViewModel
                                              .setInputValues,
                                          keyboardType: TextInputType.text,
                                          maxlines: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const AddMedia(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.appValues.appPadding
                                          .p20,
                                    ),
                                    child: const Divider(
                                      color: Color(0xffD4D6DD),
                                      thickness: 1,
                                      height: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        context.appValues.appPadding.p20),
                                    child: Container(
                                      width: context.appValues.appSizePercent
                                          .w100,
                                      decoration: BoxDecoration(
                                        color: context.resources.color
                                            .colorWhite,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //     horizontal:
                                          //         context.appValues.appPadding.p20,
                                          //     vertical:
                                          //         context.appValues.appPadding.p10,
                                          //   ),
                                          //   child: Text(
                                          //     "Working Day",
                                          //     style: getPrimaryBoldStyle(
                                          //       fontSize: 16,
                                          //       color: const Color(0xff1F1F39),
                                          //     ),
                                          //   ),
                                          // ),
                                          const Gap(15),
                                          const DatePickerWidget(),

                                          const Gap(20),
                                          CustomTimePicker(
                                            index: 'time',
                                            viewModel: jobsViewModel
                                                .setInputValues,
                                          ),
                                          const Gap(20),
                                          InkWell(
                                            onTap: () {
                                              // Navigator.of(context).push(
                                              //   _createRoute(ConfirmAddress()),
                                              // );
                                              _onActionSheetPress(context);
                                            },
                                            child: Container(
                                              width: context
                                                  .appValues.appSizePercent
                                                  .w100,
                                              decoration: BoxDecoration(
                                                color: context
                                                    .resources.color.colorWhite,
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              // Adjust padding as needed
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context
                                                    .appValues.appPadding.p10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      // Location SVG icon
                                                      SvgPicture.asset(
                                                        'assets/img/locationbookservice.svg',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      const Gap(10),
                                                      // Column with a title and the current location or hint
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            translate(
                                                                'bookService.location'),
                                                            style:
                                                            getPrimaryRegularStyle(
                                                              fontSize: 16,
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .btnColorBlue,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${profileViewModel
                                                                .getProfileBody['current_address']["street_number"]} ${profileViewModel
                                                                .getProfileBody['current_address']["building_number"]}, ${profileViewModel
                                                                .getProfileBody['current_address']['apartment_number']}, ${profileViewModel
                                                                .getProfileBody['current_address']["floor"]}',
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
                                                  // Trailing arrow icon
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_sharp,
                                                    size: 20,
                                                    color: Color(0xff8F9098),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      color: Color(0xffD4D6DD),
                                      thickness: 1,
                                      height: 5,
                                    ),
                                  ),

                                  PaymentMethod(
                                    fromWhere: 'book a service',
                                    jobsViewModel: jobsViewModel,
                                    paymentViewModel: paymentViewModel,
                                    payment_method: paymentViewModel
                                        .paymentList,
                                    role: Constants.customerRoleId,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      color: Color(0xffD4D6DD),
                                      thickness: 1,
                                      height: 5,
                                    ),
                                  ),
                                  const Gap(20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.appValues.appPadding
                                          .p20,
                                      vertical: context.appValues.appPadding.p0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          translate('bookService.unitPrice'),
                                          style: getPrimaryRegularStyle(
                                            fontSize: 14,
                                            color: context
                                                .resources.color.btnColorBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20.0, left: 20.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(),
                                        child: Row(
                                          children: [
                                            Text(
                                              _getUnitPrice(profileViewModel),
                                              style: getPrimaryRegularStyle(
                                                  color: context.resources.color
                                                      .secondColorBlue,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '/${_getType(profileViewModel)}',
                                              style: getPrimaryRegularStyle(
                                                  color: context.resources.color
                                                      .secondColorBlue,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const Gap(10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.appValues.appPadding
                                          .p20,
                                      vertical: context.appValues.appPadding.p0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate('updateJob.jobSize'),
                                          style: getPrimaryRegularStyle(
                                            fontSize: 14,
                                            color: context
                                                .resources.color.btnColorBlue,
                                          ),
                                        ),
                                        Consumer<JobsViewModel>(
                                            builder: (context, jobsViewModel,
                                                _) {
                                              return CustomIncrementFieldRequest(
                                                index: 'number_of_units',
                                                editable: isLumpsum
                                                    ? false
                                                    : true,
                                                value: _matchingRate != null
                                                    ? '${_matchingRate['minimum_order']}'
                                                    : '0',
                                                // hintText: 'Job Type',
                                                viewModel: jobsViewModel
                                                    .setInputValues,
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       right: 40.0, left: 40.0),
                                  //   child: Consumer<JobsViewModel>(
                                  //       builder: (context, jobsViewModel, _) {
                                  //     return CustomIncrementFieldRequest(
                                  //       index: 'number_of_units',
                                  //       editable: isLumpsum ? false : true,
                                  //       value: _matchingRate != null
                                  //           ? '${_matchingRate['minimum_order']}'
                                  //           : '0',
                                  //       // hintText: 'Job Type',
                                  //       viewModel: jobsViewModel.setInputValues,
                                  //     );
                                  //   }),
                                  // ),
                                  const Gap(10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.appValues.appPadding
                                          .p20,
                                      vertical: context.appValues.appPadding.p0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          translate('home_screen.totalPrice'),
                                          style: getPrimaryRegularStyle(
                                            fontSize: 14,
                                            color: context
                                                .resources.color.btnColorBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.appValues.appPadding
                                          .p20,
                                      vertical: context.appValues.appPadding.p0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _getServiceRate(
                                              profileViewModel, jobsViewModel),
                                          style: getPrimarySemiBoldStyle(
                                            color: const Color(0xff4100E3),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      color: Color(0xffD4D6DD),
                                      thickness: 1,
                                      height: 5,
                                    ),
                                  ),
                                  const Gap(10),
                                  Container(
                                    height: context.appValues.appSizePercent.h8,
                                    width: context.appValues.appSizePercent
                                        .w100,
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                          context.appValues.appPadding.p10,
                                          horizontal:
                                          context.appValues.appPadding.p15),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: context
                                                .appValues.appSizePercent.w57,
                                            height: context
                                                .appValues.appSizePercent.h100,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (await jobsViewModel
                                                    .requestService() ==
                                                    true) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                    context) =>
                                                        _buildPopupDialog(
                                                            context),
                                                  );
                                                } else {
                                                  if (jobsViewModel.getjobsBody[
                                                  'tap_payments_card'] ==
                                                      null) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) =>
                                                          _buildPopupDialogNo(
                                                              context,
                                                              translate(
                                                                  'button.pleaseProvidePaymentCard')),
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) =>
                                                          _buildPopupDialogNo(
                                                              context,
                                                              translate(
                                                                  'button.somethingWentWrong')),
                                                    );
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                const Color(0xff4100E3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                translate(
                                                    'bookService.requestService'),
                                                style: getPrimarySemiBoldStyle(
                                                  fontSize: 12,
                                                  color: context
                                                      .resources.color
                                                      .colorWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context
                                                .appValues.appSizePercent.w31,
                                            height: context
                                                .appValues.appSizePercent.h100,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                jobsViewModel.launchWhatsApp();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Colors
                                                    .transparent,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color(0xff4100E3),
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/img/support-icon.svg',
                                                  ),
                                                  Text(
                                                    translate(
                                                        'bookService.chat'),
                                                    style: getPrimarySemiBoldStyle(
                                                      fontSize: 12,
                                                      color:
                                                      const Color(0xff4100E3),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }),
                      );
                    }),
              ],
            ),
          );
        });
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: SvgPicture.asset('assets/img/x.svg'),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 1));
                  Navigator.pop(context);
                  // Future.delayed(
                  //     const Duration(seconds: 0), () => Navigator.pop(context));
                },
              ),
            ],
          ),
        ),
        SvgPicture.asset('assets/img/booking-confirmation-icon.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            translate('bookService.serviceRequestConfirmed'),
            textAlign: TextAlign.center,
            style: getPrimarySemiBoldStyle(
              fontSize: 16,
              color: context.resources.color.btnColorBlue,
            ),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s20),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p20,
          ),
          child: Text(
            translate('bookService.serviceRequestConfirmedMsg'),
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 12,
              color: const Color(0xff71727A),
            ),
          ),
        ),
        const Gap(20),
      ],
    ),
  );
}

Widget _buildPopupDialogNo(BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
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
        SvgPicture.asset('assets/img/x.svg'),
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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            translate('button.tryAgainLater'),
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 15,
              color: context.resources.color.secondColorBlue,
            ),
          ),
        ),
      ],
    ),
  );
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
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
