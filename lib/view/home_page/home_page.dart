import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/about/about_dingdone.dart';
import 'package:dingdone/view/categories/parent_categories.dart';
import 'package:dingdone/view/categories_screen/categories_screen.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/profile_page/profile_page.dart';
import 'package:dingdone/view/widgets/categories_screen/home_categories_widget.dart';
import 'package:dingdone/view/widgets/custom/custom_search_bar.dart';
import 'package:dingdone/view/widgets/home_page/categories.dart';
import 'package:dingdone/view/widgets/home_page/services.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../view_model/dispose_view_model/app_view_model.dart';
import '../agreement/user_agreement.dart';
import '../bottom_bar/bottom_bar.dart';
import '../edit_account/edit_account.dart';
import '../jobs_page/jobs_page.dart';
import '../login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
String? lang;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
    Provider.of<CategoriesViewModel>(context, listen: false).readJson();


  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    if(lang==null){
      setState(() {
        lang='en-US';
      });
    }
  }

  Future<void> _handleRefresh() async {
    try {
      String? role = await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.of(context).push(_createRoute(BottomBar(userRole: role)));
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'https://via.placeholder.com/800x400.png?text=Image+1',
    'https://via.placeholder.com/800x400.png?text=Image+2',
    'https://via.placeholder.com/800x400.png?text=Image+3',
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileViewModel, ServicesViewModel,CategoriesViewModel,JobsViewModel>(
        builder: (context, profileViewModel, servicesViewModel,categoriesViewModel,jobsViewModel, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xffFEFEFE),
          drawer:Drawer(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 75.0, 16.0, 8.0), // Adjust top and bottom padding
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        // Additional header content if needed
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'My Account',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      // Handle My Account tap

                      Navigator.of(context).push(_createRoute(
                          const EditAccount()));
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Order History',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobsPage(
                            userRole: Constants.customerRoleId,
                            lang: lang!,
                            initialActiveTab:'completedJobs',
                            initialIndex: 3,
                          ),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: Text(
                      'My Address Book',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      // Handle My Address Book tap
                      Navigator.of(context).push(_createRoute(
                          ConfirmAddress()));
                    },
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'App Settings',
                  //     style: getPrimaryBoldStyle(
                  //       fontSize: 18,
                  //       color: const Color(0xff180C38),
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     // Handle App Settings tap
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  ListTile(
                    title: Text(
                      'Support',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      // Handle Help! tap
                      // Navigator.pop(context);
                      jobsViewModel.launchWhatsApp();

                    },
                  ),
                  ListTile(
                    title: Text(
                      'About DingDone',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      // Handle About DingDone tap
                      Navigator.of(context)
                          .push(_createRoute(About()));
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Terms and Conditions',
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                    onTap: () {
                      // Handle Terms and Conditions tap
                      Navigator.of(context)
                          .push(_createRoute(UserAgreement(index: null)));
                    },
                  ),

                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: context.appValues.appPadding.p5,
                        left: context.appValues.appPadding.p15,
                        right: context.appValues.appPadding.p15),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    color: Color(0xffEDF1F7)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/img/sign-out.svg',
                                    color: const Color(0xff04043E),
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: context.appValues.appSize.s10),
                              Text(
                                translate('profile.logOut'),
                                style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: context.resources.color.btnColorBlue),
                              ),
                            ],
                          ),
                          // SvgPicture.asset('assets/img/right-arrow.svg'),
                        ],
                      ),
                      onTap: () async {
                        String? lang =
                        await AppPreferences().get(key: language, isModel: false);
                        AppPreferences().clear();
                        AppProviders.disposeAllDisposableProviders(context);
                        Navigator.of(context).push(_createRoute(const LoginScreen()));
                        await AppPreferences()
                            .save(key: language, value: lang, isModel: false);
                        if (lang == null) {
                          lang = "en";
                          await AppPreferences()
                              .save(key: language, value: "en", isModel: false);
                          await AppPreferences()
                              .save(key: dblang, value: 'en-US', isModel: false);
                        }

                        if (lang == 'en') {
                          await AppPreferences()
                              .save(key: dblang, value: 'en-US', isModel: false);
                        }
                        if (lang == 'ar') {
                          await AppPreferences()
                              .save(key: dblang, value: 'ar-SA', isModel: false);
                        }
                        if (lang == 'ru') {
                          await AppPreferences()
                              .save(key: dblang, value: 'ru-RU', isModel: false);
                        }
                        if (lang == 'el') {
                          await AppPreferences()
                              .save(key: dblang, value: 'el-GR', isModel: false);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/img/DingDone-LOGO.png', // Update the path to your DingDone logo
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xffFEFEFE),
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // IconButton(
                          //   icon: Icon(Icons.menu),
                          //   onPressed: () {
                          //     _scaffoldKey.currentState?.openDrawer();
                          //   },
                          // ),
                          // SizedBox(width: 8),
                          Text(
                            profileViewModel.getProfileBody["user"] != null
                                ? 'Hi ${profileViewModel.getProfileBody["user"]["first_name"]}!'
                                : '',
                            style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: context.appValues.appSizePercent.w10p5,
                        height: context.appValues.appSizePercent.h5p1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              profileViewModel.getProfileBody['user'] != null &&
                                  profileViewModel.getProfileBody['user']['avatar'] != null
                                  ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p15,
                        ),
                        child: CustomSearchBar(
                          index: 'search_services',
                          hintText: "Search for services...",
                          viewModel: servicesViewModel.searchData,
                        ),
                      ),
                      SizedBox(height: context.appValues.appSize.s15),
                      // HomeCategoriesWidget(servicesViewModel: servicesViewModel),
                      // SizedBox(height: context.appValues.appSize.s15),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              servicesViewModel.chosenParent?
                              translate('home_screen.servicesCategories'):
                              translate('home_screen.categories'),
                              style: getPrimaryRegularStyle(
                                fontSize: 28,
                                color: context.resources.color.btnColorBlue,
                              ),
                            ),
                            servicesViewModel.chosenParent?InkWell(
                              child: Text(
                                translate('home_screen.seeAll'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 18,
                                  color: const Color(0xff9E9BB8),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(_createRoute(
                                  CategoriesScreen(categoriesViewModel: categoriesViewModel,initialTabIndex: 0,serviceViewModel:servicesViewModel),
                                ));
                              },
                            ):Container(),
                          ],
                        ),
                      ),
                      servicesViewModel.chosenParent?
                      CategoriesWidget(servicesViewModel: servicesViewModel):
                      ParentCategoriesWidget(servicesViewModel: servicesViewModel),


                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // servicesViewModel.searchBody["search_services"] != null &&
                          //     servicesViewModel.searchBody["search_services"] != ''
                          //     ? servicesViewModel.searchBody["search_services"]
                          //     :
                          translate('home_screen.featuredServices'),
                          style: getPrimaryRegularStyle(
                            fontSize: 28,
                            color: context.resources.color.btnColorBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                SliverToBoxAdapter(
                  // child: const ServicesWidget(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0,left: 8.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 300.0,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                autoPlayAnimationDuration: const Duration(milliseconds: 700),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                              items: imgList
                                  .map((item) => Container(
                                color: context.resources.color.btnColorBlue,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      Text(
                                        'ADS - UPDATES CAROUSEL AREA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () => _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current == entry.key
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: const Text(
                                  'We are available Sat to Thur\nfrom 9 to 5, Fri from 2 to 5',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.abc),
                                        SizedBox(width: 10.0),
                                        Text(
                                          'CONTACT US',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
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
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void showDemoActionSheet({required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String? value) {
      if (value != null) changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text('Title'),
        message: Text('Message'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en-US')),
            onPressed: () async {
              await AppPreferences().save(key: language, value: 'en', isModel: false);
              Navigator.pop(context, 'en');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ar-SA')),
            onPressed: () async {
              await AppPreferences().save(key: language, value: 'ar', isModel: false);
              Navigator.pop(context, 'ar');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.el-GR')),
            onPressed: () async {
              await AppPreferences().save(key: language, value: 'el', isModel: false);
              Navigator.pop(context, 'el');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ru-RU')),
            onPressed: () async {
              await AppPreferences().save(key: language, value: 'ru', isModel: false);
              Navigator.pop(context, 'ru');
              RestartWidget.restartApp(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}