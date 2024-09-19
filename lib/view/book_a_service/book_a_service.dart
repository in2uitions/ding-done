// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/widgets/book_a_service/add_media.dart';
import 'package:dingdone/view/widgets/book_a_service/date_picker.dart';
import 'package:dingdone/view/widgets/book_a_service/payment_method.dart';
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

      for (Map<String, dynamic> translation in widget.service["translations"]) {
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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: context.appValues.appSizePercent.w100,
                        height: context.appValues.appSizePercent.h20,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.00, 1),
                            end: const Alignment(0, 0),
                            colors: [
                              const Color(0xffEECB0B).withOpacity(0),
                              const Color(0xffEECB0B).withOpacity(0.4),
                              const Color(0xffEECB0B).withOpacity(0.6),
                              const Color(0xffEECB0B).withOpacity(0.9),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: context.appValues.appPadding.p8,
                            left: context.appValues.appPadding.p20,
                            right: context.appValues.appPadding.p20,
                          ),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('bookService.bookService'),
                                      style: getPrimaryBoldStyle(
                                        color:
                                            context.resources.color.colorWhite,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: context.appValues.appPadding.p8,
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/img/back-new.svg'),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
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
                          ),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${categories!["title"]}',
                                  style: getPrimaryBoldStyle(
                                    fontSize: 18,
                                    color: context.resources.color.colorWhite,
                                  ),
                                ),
                                Text(
                                  '${services!["title"]}',
                                  style: getPrimaryBoldStyle(
                                    fontSize: 25,
                                    color: context.resources.color.colorWhite,
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
                initialChildSize: 0.55,
                minChildSize: 0.55,
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
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        context.appValues.appPadding.p20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p0,
                                        vertical:
                                            context.appValues.appPadding.p10,
                                      ),
                                      child: Text(
                                        translate('bookService.jobDescription'),
                                        style: getPrimaryBoldStyle(
                                          fontSize: 20,
                                          color: context
                                              .resources.color.btnColorBlue,
                                        ),
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
                                    horizontal:
                                        context.appValues.appPadding.p20),
                                child: Container(
                                  width: context.appValues.appSizePercent.w100,
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorWhite,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.appValues.appPadding.p20,
                                          vertical:
                                              context.appValues.appPadding.p10,
                                        ),
                                        child: Text(
                                          "Working Day",
                                          style: getPrimaryBoldStyle(
                                            fontSize: 20,
                                            color: const Color(0xff1F1F39),
                                          ),
                                        ),
                                      ),
                                      const DatePickerWidget(),
                                      SizedBox(
                                          height: context
                                              .appValues.appSizePercent.h3),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: context
                                                .appValues.appPadding.p20,
                                            vertical: context
                                                .appValues.appPadding.p10),
                                        child: Text(
                                          // translate('bookService.dateAndTime'),
                                          "Start Time",
                                          style: getPrimaryBoldStyle(
                                            fontSize: 20,
                                            color: const Color(0xff1F1F39),
                                          ),
                                        ),
                                      ),
                                      CustomTimePicker(
                                        index: 'time',
                                        viewModel: jobsViewModel.setInputValues,
                                      ),
                                      // const TimePickerWidget(),
                                      SizedBox(
                                          height: context
                                              .appValues.appSizePercent.h1),
                                    ],
                                  ),
                                ),
                              ),
                              // const ButtonsBookService(),
                              const Gap(20),
                              Padding(
                                padding: EdgeInsets.all(
                                    context.appValues.appPadding.p0),
                                child: Container(
                                  width: context.appValues.appSizePercent.w100,
                                  // height: context.appValues.appSizePercent.h,
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorWhite,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.appValues.appPadding.p40,
                                          vertical:
                                              context.appValues.appPadding.p0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              translate('bookService.location'),
                                              style: getPrimaryBoldStyle(
                                                fontSize: 20,
                                                color: context.resources.color
                                                    .btnColorBlue,
                                              ),
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
                                            horizontal: context
                                                .appValues.appPadding.p40),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  _createRoute(
                                                    // MapScreen(viewModel: jobsViewModel)));
                                                    ConfirmAddress(),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: SvgPicture.asset(
                                                      'assets/img/locationbookservice.svg',
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  Expanded(
                                                    child: Text(
                                                      '${profileViewModel.getProfileBody['current_address']["street_name"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']["city"]}, ${profileViewModel.getProfileBody['current_address']["state"]}',
                                                      style:
                                                          getPrimaryRegularStyle(
                                                        fontSize: 18,
                                                        color: const Color(
                                                            0xff190C39),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              color: Color(0xffEAEAFF),
                                              thickness: 2,
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(15),
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
                              const Gap(10),
                              Container(
                                height: context.appValues.appSizePercent.h10,
                                width: context.appValues.appSizePercent.w100,
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
                                      Row(
                                        children: [
                                          Text(
                                            servicesViewModel
                                                    .countryRatesList.isNotEmpty
                                                ? '${servicesViewModel.countryRatesList[0].unit_rate}€'
                                                : '',
                                            style: getPrimaryRegularStyle(
                                                color: context.resources.color
                                                    .colorYellow,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            servicesViewModel
                                                    .countryRatesList.isNotEmpty
                                                ? ' ${servicesViewModel.countryRatesList[0].unit_type}'
                                                : '',
                                            style: getPrimaryRegularStyle(
                                                color: context.resources.color
                                                    .secondColorBlue,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: context
                                            .appValues.appSizePercent.w55,
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
                                                    _buildPopupDialog(context),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        _buildPopupDialogNo(
                                                            context),
                                              );
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
                                            style: getPrimaryBoldStyle(
                                              fontSize: 18,
                                              color: context
                                                  .resources.color.colorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: context
                                            .appValues.appSizePercent.w30,
                                        height: context
                                            .appValues.appSizePercent.h100,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: Color(0xff4100E3),
                                                width: 3,
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
                                                'assets/img/chat.svg',
                                                color: const Color(0xff4100E3),
                                              ),
                                              // SizedBox(
                                              //   height: context.appValues.appSize.s5,
                                              // ),
                                              Text(
                                                translate('bookService.chat'),
                                                style: getPrimaryRegularStyle(
                                                  fontSize: 19,
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
