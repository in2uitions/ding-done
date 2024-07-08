// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/widgets/book_a_service/add_media.dart';
import 'package:dingdone/view/widgets/book_a_service/date_and_time_buttons.dart';
import 'package:dingdone/view/widgets/book_a_service/date_picker.dart';
import 'package:dingdone/view/widgets/book_a_service/job_type/job_type_buttons.dart';
import 'package:dingdone/view/widgets/book_a_service/payment_method.dart';
import 'package:dingdone/view/widgets/book_a_service/time_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:dingdone/view/widgets/custom/custom_time_picker.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BookAService extends StatefulWidget {
  BookAService(
      {super.key,
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
  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileViewModel, JobsViewModel, ServicesViewModel,
            PaymentViewModel>(
        builder: (context, profileViewModel, jobsViewModel, servicesViewModel,
            paymentViewModel, _) {
      Map<String, dynamic>? services;
      Map<String, dynamic>? categories;

      for (Map<String, dynamic> translation in widget.service.translations) {
        debugPrint('transss ${translation["languages_code"]["code"]}');
        if (translation["languages_code"]["code"] == widget.lang) {
          services = translation;
          break; // Break the loop once the translation is found
        }
      }
      for (Map<String, dynamic> translations
          in widget.service.category["translations"]) {
        if (translations["languages_code"]["code"] == widget.lang) {
          categories = translations;
          break; // Break the loop once the translation is found
        }
      }

      return Scaffold(
        backgroundColor: const Color(0xffFEFEFE),
        // backgroundColor: const Color(0xffF0F3F8),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  children: [
                    SafeArea(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding:
                              EdgeInsets.all(context.appValues.appPadding.p20),
                          child: Row(
                            children: [
                              InkWell(
                                child: SvgPicture.asset('assets/img/back.svg'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.appValues.appPadding.p20,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          translate('bookService.bookService'),
                          style: getPrimaryRegularStyle(
                            color: context.resources.color.btnColorBlue,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                    // SvgPicture.network(
                    //   '${context.resources.image.networkImagePath}/${widget.service.category["image"]["filename_disk"]}',
                    //   placeholderBuilder: (context) =>
                    //       const CircularProgressIndicator(),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p0),
                      child: Stack(
                        children: [
                          Container(
                            width: context.appValues.appSizePercent.w100,
                            height: context.appValues.appSizePercent.h31,
                            decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Color(0xffF3D347),
                              //     offset: Offset(5, 0),
                              //     blurRadius: 5,
                              //   ),
                              // ],
                              image: DecorationImage(
                                image: NetworkImage(
                                    // '${context.resources.image.networkImagePath2}${service.image["filename_disk"]}',
                                    widget.image
                                    // "https://www.armorplumbing.net/wp-content/uploads/2021/12/Cost-to-Repair-a-Plumbing-Leak-5.jpg",
                                    ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: Padding(
                            //   padding: EdgeInsets.only(
                            //     top: context.appValues.appPadding.p10,
                            //     left: context.appValues.appPadding.p20,
                            //   ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         '${categories!["title"]}',
                            //         style: getPrimaryBoldStyle(
                            //           fontSize: 20,
                            //           color: context.resources.color.colorWhite,
                            //         ),
                            //       ),
                            //       Text(
                            //         '${services!["title"]}',
                            //         style: getPrimaryBoldStyle(
                            //           fontSize: 30,
                            //           color: context.resources.color.colorWhite,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                          Container(
                            width: context.appValues.appSizePercent.w100,
                            height: context.appValues.appSizePercent.h15,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.00, 1),
                                end: const Alignment(0, 0),
                                colors: [
                                  // const Color(0x00D9D9D9),
                                  const Color(0xffF3D347).withOpacity(0),
                                  const Color(0xffF3D347).withOpacity(0.4),
                                  const Color(0xffF3D347).withOpacity(0.6),
                                  const Color(0xffF3D347).withOpacity(0.9),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: context.appValues.appPadding.p10,
                                left: context.appValues.appPadding.p20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${categories!["title"]}',
                                    style: getPrimaryBoldStyle(
                                      fontSize: 20,
                                      color: context.resources.color.colorWhite,
                                    ),
                                  ),
                                  Text(
                                    '${services!["title"]}',
                                    style: getPrimaryBoldStyle(
                                      fontSize: 30,
                                      color: context.resources.color.colorWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.appValues.appSize.s20),
                Padding(
                  padding: EdgeInsets.all(context.appValues.appPadding.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p0,
                            vertical: context.appValues.appPadding.p10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              translate('bookService.jobType'),
                              style: getPrimaryBoldStyle(
                                  fontSize: 20,
                                  color: context.resources.color.btnColorBlue),
                            ),
                          ],
                        ),
                      ),
                      JobTypeButtons(
                        service: widget.service,
                        country_code: profileViewModel.getProfileBody["address"][0]
                            ["country"],
                        servicesViewModel: servicesViewModel,
                        job_type: null,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p0,
                          vertical: context.appValues.appPadding.p10,
                        ),
                        child: Text(
                          translate('bookService.jobDescription'),
                          style: getPrimaryBoldStyle(
                              fontSize: 20,
                              color: context.resources.color.btnColorBlue),
                        ),
                      ),
                      CustomTextArea(
                        index: 'job_description',
                        viewModel: jobsViewModel.setInputValues,
                        keyboardType: TextInputType.text,
                        maxlines: 7,
                      ),
                    ],
                  ),
                ),

                const AddMedia(),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: Container(
                    width: context.appValues.appSizePercent.w100,
                    // height: context.appValues.appSizePercent.h20,
                    // height: context.appValues.appSizePercent.h30,
                    decoration: BoxDecoration(
                      color: context.resources.color.colorWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p20,
                              vertical: context.appValues.appPadding.p10),
                          child: Text(
                            // translate('bookService.dateAndTime'),
                            "Working Day",
                            style: getPrimaryBoldStyle(
                              fontSize: 20,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                        ),
                        // DateAndTimeButtons(),
                        const DatePickerWidget(),
                        SizedBox(height: context.appValues.appSizePercent.h3),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p20,
                              vertical: context.appValues.appPadding.p10),
                          child: Text(
                            // translate('bookService.dateAndTime'),
                            "Start Time",
                            style: getPrimaryBoldStyle(
                              fontSize: 20,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                        ),
                        CustomTimePicker(
                          index: 'time',
                          viewModel: jobsViewModel.setInputValues,),
                        // const TimePickerWidget(),
                        SizedBox(height: context.appValues.appSizePercent.h1),
                      ],
                    ),
                  ),
                ),
                // const ButtonsBookService(),
                const Gap(20),
                Padding(
                  padding: EdgeInsets.all(context.appValues.appPadding.p0),
                  child: Container(
                    width: context.appValues.appSizePercent.w100,
                    // height: context.appValues.appSizePercent.h,
                    decoration: BoxDecoration(
                      color: context.resources.color.colorWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p40,
                              vertical: context.appValues.appPadding.p0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate('bookService.location'),
                                style: getPrimaryBoldStyle(
                                    fontSize: 20,
                                    color:
                                        context.resources.color.btnColorBlue),
                              ),
                              // InkWell(
                              //   child: Text(
                              //     translate('profile.changeLocation'),
                              //     style: getPrimaryRegularStyle(
                              //       fontSize: 15,
                              //       color: context.resources.color.btnColorBlue,
                              //     ),
                              //   ),
                              //   onTap: () {
                              //     Navigator.of(context).push(_createRoute(
                              //         // MapScreen(viewModel: jobsViewModel)));
                              //         ConfirmAddress()));
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p40),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/img/location.svg'),
                              const Gap(10),
                              Expanded(
                                child: Text(
                                  '${profileViewModel.getProfileBody['current_address']["street_name"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']["city"]}, ${profileViewModel.getProfileBody['current_address']["state"]}',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 18,
                                    color: const Color(0xff190C39),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(15),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p40,
                              vertical: context.appValues.appPadding.p0),
                          child: InkWell(
                            child: SizedBox(
                              height: context.appValues.appSizePercent.h30,
                              child: profileViewModel
                                  .getProfileBody['current_address']!=null?
                              MapDisplay(
                                body: profileViewModel.getProfileBody,
                                longitude: profileViewModel
                                    .getProfileBody['current_address']!=null? profileViewModel
                                    .getProfileBody['current_address']["longitude"]:25.3,
                                latitude: profileViewModel
                                    .getProfileBody['current_address']!=null?profileViewModel
                                    .getProfileBody['current_address']["latitude"]:51.1,
                              ):Container(),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                _createRoute(
                                  // MapScreen(viewModel: jobsViewModel)));
                                  ConfirmAddress(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                PaymentMethod(
                  fromWhere: 'book a service',
                  jobsViewModel: jobsViewModel,
                  paymentViewModel: paymentViewModel,
                  payment_method: paymentViewModel.paymentList,
                  role: Constants.customerRoleId,
                ),
                SizedBox(height: context.appValues.appSize.s10),
                Container(
                  height: context.appValues.appSizePercent.h10,
                  width: context.appValues.appSizePercent.w100,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.appValues.appPadding.p10,
                        horizontal: context.appValues.appPadding.p15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              servicesViewModel.countryRatesList.isNotEmpty
                                  ? '${servicesViewModel.countryRatesList[0].unit_rate}€'
                                  : '',
                              style: getPrimaryRegularStyle(
                                  color: context.resources.color.colorYellow,
                                  fontSize: 20),
                            ),
                            Text(
                              servicesViewModel.countryRatesList.isNotEmpty
                                  ? ' ${servicesViewModel.countryRatesList[0].unit_type}'
                                  : '',
                              style: getPrimaryRegularStyle(
                                  color:
                                      context.resources.color.secondColorBlue,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: context.appValues.appSizePercent.w55,
                          height: context.appValues.appSizePercent.h100,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await jobsViewModel.requestService() ==
                                  true) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogNo(context),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF3D347),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              translate('bookService.requestService'),
                              style: getPrimaryBoldStyle(
                                fontSize: 18,
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.appValues.appSizePercent.w30,
                          height: context.appValues.appSizePercent.h100,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xff190C39),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset('assets/img/chat.svg'),
                                // SizedBox(
                                //   height: context.appValues.appSize.s5,
                                // ),
                                Text(
                                  translate('bookService.chat'),
                                  style: getPrimaryRegularStyle(
                                    fontSize: 19,
                                    color: const Color(0xff190C39),
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
                SizedBox(height: context.appValues.appSize.s20),
              ],
            ),
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //     height: context.appValues.appSizePercent.h10,
            //     width: context.appValues.appSizePercent.w100,
            //     color: Colors.transparent,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(
            //           vertical: context.appValues.appPadding.p10,
            //           horizontal: context.appValues.appPadding.p15),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             children: [
            //               Text(
            //                 servicesViewModel.countryRatesList.isNotEmpty
            //                     ? '${servicesViewModel.countryRatesList[0].unit_rate}€'
            //                     : '',
            //                 style: getPrimaryRegularStyle(
            //                     color: context.resources.color.colorYellow,
            //                     fontSize: 20),
            //               ),
            //               Text(
            //                 servicesViewModel.countryRatesList.isNotEmpty
            //                     ? ' ${servicesViewModel.countryRatesList[0].unit_type}'
            //                     : '',
            //                 style: getPrimaryRegularStyle(
            //                     color: context.resources.color.secondColorBlue,
            //                     fontSize: 10),
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             width: context.appValues.appSizePercent.w55,
            //             height: context.appValues.appSizePercent.h100,
            //             child: ElevatedButton(
            //               onPressed: () async {
            //                 if (await jobsViewModel.requestService() == true) {
            //                   showDialog(
            //                     context: context,
            //                     builder: (BuildContext context) =>
            //                         _buildPopupDialog(context),
            //                   );
            //                 } else {
            //                   showDialog(
            //                     context: context,
            //                     builder: (BuildContext context) =>
            //                         _buildPopupDialogNo(context),
            //                   );
            //                 }
            //               },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: const Color(0xffF3D347),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(12),
            //                 ),
            //               ),
            //               child: Text(
            //                 translate('bookService.requestService'),
            //                 style: getPrimaryBoldStyle(
            //                   fontSize: 18,
            //                   color: context.resources.color.colorWhite,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: context.appValues.appSizePercent.w30,
            //             height: context.appValues.appSizePercent.h100,
            //             child: ElevatedButton(
            //               onPressed: () {},
            //               style: ElevatedButton.styleFrom(
            //                 elevation: 0,
            //                 backgroundColor: Colors.transparent,
            //                 shape: RoundedRectangleBorder(
            //                   side: const BorderSide(
            //                     color: Color(0xff190C39),
            //                     width: 3,
            //                   ),
            //                   borderRadius: BorderRadius.circular(12),
            //                 ),
            //               ),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   SvgPicture.asset('assets/img/chat.svg'),
            //                   // SizedBox(
            //                   //   height: context.appValues.appSize.s5,
            //                   // ),
            //                   Text(
            //                     translate('bookService.chat'),
            //                     style: getPrimaryRegularStyle(
            //                       fontSize: 19,
            //                       color: const Color(0xff190C39),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
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
                  Future.delayed(
                      const Duration(seconds: 0), () => Navigator.pop(context));
                },
              ),
            ],
          ),
        ),
        SvgPicture.asset('assets/img/service-popup-image.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            translate('bookService.serviceRequestConfirmed'),
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
            translate('bookService.serviceRequestConfirmedMsg'),
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

Widget _buildPopupDialogNo(BuildContext context) {
  return AlertDialog(
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
            translate('button.somethingWentWrong'),
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
