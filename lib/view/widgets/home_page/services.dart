import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/book_a_service/book_a_service.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/app_prefs.dart';

class ServicesWidget extends StatefulWidget {
  const ServicesWidget({super.key});
  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

String? lang;

class _ServicesWidgetState extends State<ServicesWidget> {
  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesViewModel>(
        builder: (context, servicesViewModel, _) {
      // servicesViewModel.getServices();
      return Padding(
        padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0),
        child: Column(
          children: [
            SizedBox(
              width: context.appValues.appSizePercent.w100,
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                //   mainAxisSpacing: 8,
                //   // Adjust this value to add vertical spacing
                //   crossAxisSpacing: 8,
                //   childAspectRatio:
                //       159 / 74, // Adjust this value to add horizontal spacing`
                // ),
                itemCount: servicesViewModel.servicesList2.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: context.appValues.appPadding.p20),
                    child: buildServiceWidget(
                        servicesViewModel.servicesList2[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),
            // Add space between the first and second row
          ],
        ),
      );
    });
  }

  Widget buildServiceWidget(ServicesModel service) {
    Map<String, dynamic>? services;
    Map<String, dynamic>? categories;
    if(lang==null){
      lang="en-US";
    }
    for (Map<String, dynamic> translation in service.translations) {
      if (translation["languages_code"]["code"] == lang) {
        services = translation;
        break; // Break the loop once the translation is found
      }
    }
    for (Map<String, dynamic> translations
        in service.category["translations"]) {
      if (translations["languages_code"]["code"] == lang) {
        categories = translations;
        break; // Break the loop once the translation is found
      }
    }

    return Consumer2<JobsViewModel, ProfileViewModel>(
        builder: (context, jobsViewModel, profileViewModel, _) {
      return Padding(
        padding: EdgeInsets.only(
          top: context.appValues.appPadding.p10,
          bottom: context.appValues.appPadding.p10,
        ),
        child: InkWell(
          child: Container(
            width: 233,
            height: 500,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: context.resources.color.colorWhite,
            ),
            child: Padding(
              padding: EdgeInsets.all(context.appValues.appPadding.p0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h14,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            service.image != null
                                ? '${context.resources.image.networkImagePath2}${service.image["filename_disk"]}'
                                : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg', // Specify the URL of your alternative image here
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.appValues.appPadding.p10,
                        horizontal: context.appValues.appPadding.p15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${services != null ? services["title"] : service.title}',
                            maxLines: 1,
                            style: getPrimaryBoldStyle(
                                fontSize: 18,
                                color: context.resources.color.btnColorBlue),
                          ),
                          Text(
                            '${categories?["title"]}',
                            maxLines: 1,
                            style: getPrimaryRegularStyle(
                              fontSize: 12,
                              color: const Color(0xffB4B4B4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          onTap: () {
            jobsViewModel.setInputValues(index: 'service', value: service.id);
            jobsViewModel.setInputValues(
              index: 'job_address',
              value: profileViewModel.getProfileBody['current_address'],
            );
            jobsViewModel.setInputValues(
              index: 'country',
              value: 'CYP',
            );
            jobsViewModel.setInputValues(
              index: 'address',
              value:
              '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
            );
            jobsViewModel.setInputValues(
                index: 'latitude',
                value: profileViewModel.getProfileBody['current_address']['latitude']);
            jobsViewModel.setInputValues(
                index: 'longitude',
                value: profileViewModel.getProfileBody['current_address']['longitude']);
            jobsViewModel.setInputValues(
                index: 'payment_method', value: 'Card');

            Navigator.of(context).push(_createRoute(BookAService(
              service: service,
              lang: lang,
              image: service.image != null
                  ? '${context.resources.image.networkImagePath2}${service.image["filename_disk"]}'
                  : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
            )));
          },
        ),
      );
    });
  }
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
