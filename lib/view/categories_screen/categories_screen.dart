import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_card.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_screen_cards.dart';
import 'package:dingdone/view/widgets/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../models/roles_model.dart';
import '../../models/services_model.dart';
import '../../res/app_prefs.dart';
import '../../view_model/categories_view_model/categories_view_model.dart';
import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../../view_model/services_view_model/services_view_model.dart';
import '../book_a_service/book_a_service.dart';

class CategoriesScreen extends StatefulWidget {
  var categoriesViewModel;
  var initialTabIndex;
  var serviceViewModel;

  CategoriesScreen({super.key, required this.categoriesViewModel, required this.initialTabIndex, required this.serviceViewModel});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  TabController? _tabController; // Declare a TabController
  final bool isSelected = false;
  String? lang;


  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categoriesViewModel.categoriesList.length,
      vsync: this,
      initialIndex: 0, // Set initial tab index here
    );
    initializeLanguage();
  }
  void initializeLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    lang ??= 'en-US';
    setState(() {}); // Trigger a rebuild after initializing the language

  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (lang == null) {
      // Display a loading indicator or handle the case where lang is not initialized yet
      return CircularProgressIndicator(); // Placeholder loading indicator
    }

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p20),
                child: InkWell(
                  child: SvgPicture.asset('assets/img/back.svg'),
                  onTap: () {
                    widget.serviceViewModel.setParentCategoryExistence(false);

                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
            ),
            child: Text(
              translate('home_screen.categories'),
              style: getPrimaryRegularStyle(
                color: context.resources.color.btnColorBlue,
                fontSize: 32,
              ),
            ),
          ),
          // TabBar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: getPrimaryBoldStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
              unselectedLabelColor: const Color(0xffBEC2CE),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF3D347), // Yellow color
              ),

              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight:3,
              indicatorColor: context.resources.color
                  .colorYellow, // Set the color of the indicator
              tabs: widget.categoriesViewModel.categoriesList
                  .map<Widget>((category) =>
                      buildCategoryWidget(category, widget.categoriesViewModel))
                  .toList(),
            ),
          ),
          // TabBarView
          Expanded(
            child: Consumer<ServicesViewModel>(
                builder: (context, servicesViewModel, _) {
              return TabBarView(
                controller: _tabController,
                children: widget.categoriesViewModel.categoriesList
                    .map<Widget>((category) {
                  return ListView.builder(
                    itemCount: widget.categoriesViewModel.servicesList.length,
                    itemBuilder: (context, index) {
                      Map<String,dynamic> service =
                      widget.categoriesViewModel.servicesList[index];
                      if (service["category"]["translations"][0]['categories_id'].toString() ==
                          category["id"].toString()) {
                        dynamic services;
                        for (Map<String, dynamic> translation
                            in service["translations"]) {
                          if (translation["languages_code"] == lang) {
                            services = translation;
                            break; // Break the loop once the translation is found
                          }
                        }
                        return SizedBox(
                          height: 100, // Specify the height
                          width: double.infinity,
                          child: Consumer2<JobsViewModel, ProfileViewModel>(
                              builder: (context, jobsViewModel,
                                  profileViewModel, _) {
                            return CategoriesScreenCards(
                              category: category,
                              title: services != null ? services["title"] : '',
                              cost: '${service["country_rates"][0]["unit_rate"] } ${service["country_rates"][0]["country"]["curreny"]}',
                              image: service["image"] != null
                                  ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              onTap: () {
                                jobsViewModel.setInputValues(
                                    index: 'service', value: service["id"]);
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
                                      '${profileViewModel.getProfileBody['current_address']["street_name"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']["city"]}, ${profileViewModel.getProfileBody['current_address']["state"]}',
                                );
                                jobsViewModel.setInputValues(
                                    index: 'latitude',
                                    value: profileViewModel
                                        .getProfileBody['current_address']['latitude']);
                                jobsViewModel.setInputValues(
                                    index: 'longitude',
                                    value:
                                        profileViewModel.getProfileBody['current_address']['longitude']);
                                jobsViewModel.setInputValues(
                                    index: 'payment_method',
                                    value: 'Cash on Delivery');

                                Navigator.of(context)
                                    .push(_createRoute(BookAService(
                                  service: service,
                                  lang: lang,
                                  image: service["image"] != null
                                      ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                      : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
                                )));
                              },
                            );
                          }),
                        );
                      } else {
                        return SizedBox
                            .shrink(); // If category doesn't match, return an empty widget
                      }
                    },
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryWidget(
      Map<String, dynamic> category, CategoriesViewModel categoriesViewModel) {
    Map<String, dynamic>? categories;
    Map<String, dynamic>? parentServices;
    for (Map<String, dynamic> translation in category["translations"]) {
      if (translation["languages_code"] == lang) {
        categories = translation;
        break; // Break the loop once the translation is found
      }
    }
    for (Map<String, dynamic> translationParent
        in category["class"]["translations"]) {
      if (translationParent["languages_code"] == lang) {
        parentServices = translationParent;
        break; // Break the loop once the translation is found
      }
    }

    return Tab(
      child: Text(
        categories != null ? categories!["title"] : '',
        style: TextStyle(
          color: _tabController!.index == _tabController!.index
              ? context.resources.color.btnColorBlue
              : Colors.grey,
        ),
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

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
