import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_screen_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/categories_view_model/categories_view_model.dart';
import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../book_a_service/book_a_service.dart';
import '../my_address_book/my_address_book.dart';

class CategoriesScreen extends StatefulWidget {
  final CategoriesViewModel categoriesViewModel;
  final dynamic serviceViewModel;
  final int initialTabIndex;

  const CategoriesScreen({
    Key? key,
    required this.categoriesViewModel,
    required this.serviceViewModel,
    required this.initialTabIndex,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String lang = 'en-US';

  late Map<String, dynamic> selectedCategory;
  late List<dynamic> _allCategoryServices;
  late List<dynamic> filteredServices;

  bool _isSearching = false;
  late TextEditingController _searchController;

  // ✅ NEW: Prevent UI from reading selectedCategory before initialization
  bool _isReady = false;

  List<dynamic> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_filterServices);
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final stored = await AppPreferences().get(key: dblang, isModel: false);
    debugPrint('language $stored');
    if (stored != null) lang = stored;

    final allCats = widget.categoriesViewModel.categoriesList!;
    final parentTitle = widget.serviceViewModel.parentCategory?.toString().toLowerCase();

    debugPrint('parentTitle is $parentTitle');

    final filteredCats = allCats.where((service) {
      final transList = (service['class']['translations'] as List);
      final t = transList.firstWhere(
            (t) => t['languages_code'] == lang,
        orElse: () => null,
      );
      if (t == null) return false;
      return t['title'].toString().toLowerCase().contains(parentTitle!);
    }).toList();

    debugPrint('filteredCats is $filteredCats');

    // ✅ Ensure that filtered list is never empty (prevents crash)
    List<dynamic> finalCats = filteredCats.isNotEmpty ? filteredCats : allCats;

    // ✅ Ensure initialTabIndex never goes out of range
    int safeIndex = widget.initialTabIndex < finalCats.length
        ? widget.initialTabIndex
        : 0;

    selectedCategory = finalCats[safeIndex];

    _allCategoryServices =
        widget.categoriesViewModel.servicesList!.where((service) {
          final catTransList = service['category']['translations'] as List;
          final firstTrans = catTransList.first;
          return firstTrans['categories_id'].toString() ==
              selectedCategory['id'].toString();
        }).toList();

    filteredServices = List.from(_allCategoryServices);

    // ✅ Mark that initialization is complete
    _isReady = true;

    setState(() {});
  }

  void _filterServices() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredServices = List.from(_allCategoryServices);
      } else {
        filteredServices = _allCategoryServices.where((service) {
          final trans = (service['translations'] as List).firstWhere(
                (t) => t['languages_code'] == lang,
            orElse: () => null,
          );
          if (trans == null) return false;
          return trans['title'].toString().toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  String get _currentCategoryTitle {
    final list = selectedCategory['translations'] as List<dynamic>;
    debugPrint('list is $list');
    final match = list.firstWhere(
          (t) => t['languages_code'] == lang,
      orElse: () => list.first,
    );
    return match['title']?.toString() ?? '';
  }

  String get _parentCategoryTitle {
    return widget.serviceViewModel.parentCategory?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {

    // ✅ Prevent UI from building early → avoids LateInitializationError
    if (!_isReady) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: Container(
        color: const Color(0xff4100E3),
        child: SafeArea(
          child: Stack(
            children: [

              // HEADER
              Container(
                width: double.infinity,
                height: context.appValues.appSizePercent.h50,
                color: const Color(0xff4100E3),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20,
                      vertical: context.appValues.appPadding.p10,
                    ),
                    child: _isSearching
                        ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffEAEAFF),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF6E6BE8)),
                          onPressed: () => setState(() {
                            _isSearching = false;
                            _searchController.clear();
                          }),
                        ),
                        hintText: "Search services...",
                        hintStyle: getPrimaryRegularStyle(
                          color: const Color(0xFF6E6BE8),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _isSearching = true),
                          child: const Icon(
                            Icons.search,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // TOTAL CONTENT
              DraggableScrollableSheet(
                initialChildSize: 0.90,
                minChildSize: 0.90,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffFEFEFE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [

                        const Gap(20),

                        // TITLES
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/img/categoriesIcon.svg'),
                              const Gap(4),
                              InkWell(
                                onTap: () { Navigator.of(context).pop(); },
                                child: Text(
                                  _parentCategoryTitle,
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff180D38),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Gap(4),
                              Padding(
                                padding: EdgeInsets.only(top: context.appValues.appPadding.p3),
                                child: const Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  size: 12,
                                  color: Color(0xff8F9098),
                                ),
                              ),
                              const Gap(4),
                              SizedBox(
                                width: context.appValues.appSizePercent.w40,
                                child: Text(
                                  _currentCategoryTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff4100E3),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SERVICES LIST
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = filteredServices[index];
                              dynamic trans;
                              for (var t in service['translations'] as List<dynamic>) {
                                if (t['languages_code'] == lang) {
                                  trans = t;
                                  break;
                                }
                              }
                              final title = trans?['title']?.toString() ?? '';
                              final rate = service['country_rates'][0];
                              final cost = '${rate['unit_rate']} ${rate['country']['currency']}';
                              final img = service['image'] != null
                                  ? "${context.resources.image.networkImagePath2}${service['image']}?quality=60"
                                  : null;

                              return Consumer2<JobsViewModel, ProfileViewModel>(
                                builder: (ctx, jobsVM, profVM, _) {
                                  return CategoriesScreenCards(
                                    category: selectedCategory,
                                    title: title,
                                    cost: cost,
                                    image: img ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    onTap: () async {
                                      debugPrint('handling categories selection');

                                      jobsVM.setInputValues(index: 'service', value: service['id']);

                                      final addr = await profVM.getProfileBody['current_address'];

                                      final token = await AppPreferences().get(key: userTokenKey, isModel: false);
                                      final user = await AppPreferences().get(key: userNameKey, isModel: false);

                                      // ADDRESS CHECK LOGIC
                                      if (addr != null) {
                                        jobsVM.setInputValues(index: 'job_address', value: addr);
                                        jobsVM.setInputValues(
                                          index: 'address',
                                          value: '${addr['street_number']} ${addr['building_number']}, ${addr['apartment_number']}, ${addr['floor']}',
                                        );
                                        jobsVM.setInputValues(index: 'latitude', value: addr['latitude']);
                                        jobsVM.setInputValues(index: 'longitude', value: addr['longitude']);
                                        jobsVM.setInputValues(index: 'payment_method', value: 'Card');
                                        jobsVM.setInputValues(
                                          index: 'number_of_units',
                                          value: service['country_rates'][0]['minimum_order'].toString(),
                                        );

                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) => BookAService(
                                              service: service,
                                              lang: lang,
                                              image: img,
                                            ),
                                          ),
                                        );
                                      } else if (user == null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => _buildPopupDialogLogin(
                                              context,
                                              translate('button.pleaseLogin')),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => _buildPopupDialogNo(
                                              context,
                                              translate('button.pleaseProvideAtLeastOneAddress')),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialogNo(BuildContext context, String message) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
            child: InkWell(
              onTap: () { Navigator.pop(context); },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ SvgPicture.asset('assets/img/x.svg') ],
              ),
            ),
          ),
          SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p32),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 1));
                Navigator.of(context).push(_createRoute(const MyaddressBook()));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xffFFD105),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(
                  context.appValues.appSizePercent.w30,
                  context.appValues.appSizePercent.h5,
                ),
              ),
              child: Text(
                translate('button.ok'),
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupDialogLogin(BuildContext context, String message) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
            child: InkWell(
              onTap: () { Navigator.pop(context); },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ SvgPicture.asset('assets/img/x.svg') ],
              ),
            ),
          ),
          SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p32),
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
            padding: EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p32),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 1));
                Navigator.of(context).push(_createRoute(const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xffFFD105),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(
                  context.appValues.appSizePercent.w30,
                  context.appValues.appSizePercent.h5,
                ),
              ),
              child: Text(
                translate('button.ok'),
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.btnColorBlue,
                ),
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
