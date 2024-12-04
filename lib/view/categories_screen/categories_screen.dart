import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_screen_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../view_model/categories_view_model/categories_view_model.dart';
import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../../view_model/services_view_model/services_view_model.dart';
import '../book_a_service/book_a_service.dart';

class CategoriesScreen extends StatefulWidget {
  var categoriesViewModel;
  var initialTabIndex;
  var serviceViewModel;

  CategoriesScreen({
    super.key,
    required this.categoriesViewModel,
    required this.initialTabIndex,
    required this.serviceViewModel,
  });

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
      initialIndex: 0,
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
      return const CircularProgressIndicator(); // Placeholder loading indicator
    }

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: Stack(
        children: [
          Column(
            children: [
              // Header with back button and title
              Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p0),
                child: Stack(
                  children: [
                    // Background image
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/jobimage.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h15,
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
                              // Title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('home_screen.categories'),
                                    style: getPrimaryBoldStyle(
                                      color: context.resources.color.colorWhite,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                              // Back button
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
                  ],
                ),
              ),
            ],
          ),
          // DraggableScrollableSheet for content
          DraggableScrollableSheet(
            initialChildSize: 0.80,
            minChildSize: 0.80,
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
                child: Column(
                  children: [
                    const Gap(30),
                    // TabBar for categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        labelStyle: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: context.resources.color.btnColorBlue,
                        ),
                        unselectedLabelColor: const Color(0xffBEC2CE),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3,
                        isScrollable: true, // Allow the TabBar to scroll
                        tabs: widget.categoriesViewModel.categoriesList
                            .map<Widget>(
                                (category) => buildCategoryWidget(category))
                            .toList(),
                      ),
                    ),
                    // TabBarView for services in each category
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: widget.categoriesViewModel.categoriesList
                            .map<Widget>((category) {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount:
                                widget.categoriesViewModel.servicesList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> service = widget
                                  .categoriesViewModel.servicesList[index];
                              if (service["category"]["translations"][0]
                                          ['categories_id']
                                      .toString() ==
                                  category["id"].toString()) {
                                dynamic services;
                                for (Map<String, dynamic> translation
                                    in service["translations"]) {
                                  if (translation["languages_code"] == lang) {
                                    services = translation;
                                    break; // Break the loop once the translation is found
                                  }
                                }
                                return Consumer2<JobsViewModel,ProfileViewModel>(
                                    builder: (context, jobsViewModel,profileViewModel, _) {
                                    return CategoriesScreenCards(
                                      category: category,
                                      title:
                                          services != null ? services["title"].toString() : '',
                                      cost:
                                          '${service["country_rates"][0]["unit_rate"]} ${service["country_rates"][0]["country"]["currency"]}',
                                      image: service["image"] != null
                                          ? '${context.resources.image.networkImagePath2}${service["image"]}?width=600'
                                          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      onTap: () {
                                        _handleServiceSelection(service,jobsViewModel,profileViewModel);
                                      },
                                    );
                                  }
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCategoryWidget(Map<String, dynamic> category) {
    Map<String, dynamic>? categories;
    for (Map<String, dynamic> translation in category["translations"]) {
      if (translation["languages_code"] == lang) {
        categories = translation;
        break;
      }
    }
    return Tab(
      child: Text(
        categories != null ? categories!["title"].toString() : '',
        style: TextStyle(
          color: _tabController!.index == _tabController!.index
              ? context.resources.color.btnColorBlue
              : Colors.grey,
        ),
      ),
    );
  }

  void _handleServiceSelection(Map<String, dynamic> service,JobsViewModel jobsViewModel,ProfileViewModel profileViewModel) {
    // Logic to handle service selection and navigation to next screen
    if(lang==null){
      lang='en-US';
    }
    jobsViewModel.setInputValues(index: 'service', value: service['id']);
    jobsViewModel.setInputValues(
      index: 'job_address',
      value: profileViewModel.getProfileBody['current_address'],
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
      image: service["image"] != null
          ? '${context.resources.image.networkImagePath2}${service["image"]}?quality=60'
          : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
    )));
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
