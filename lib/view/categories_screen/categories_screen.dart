import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_screen_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/categories_view_model/categories_view_model.dart';
import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../book_a_service/book_a_service.dart';

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
  late List<dynamic>
      _allCategoryServices; // ← store the unfiltered, category-only list
  late List<dynamic> filteredServices;
  bool _isSearching = false;
  late TextEditingController _searchController;
  List<dynamic> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_filterServices);
    _loadLanguage();

    // *** NEW: build the SAME filtered list you used in the grid ***
    final allCats = widget.categoriesViewModel.categoriesList!;
    final parentTitle =
        widget.serviceViewModel.parentCategory?.toString().toLowerCase();
    final filteredCats = allCats.where((service) {
      // find that service['class'] translation in `lang`
      final transList = (service['class']['translations'] as List);
      final t = transList.firstWhere(
        (t) => t['languages_code'] == lang,
        orElse: () => null,
      );
      if (t == null) return false;
      return t['title'].toString().toLowerCase().contains(parentTitle!);
    }).toList();

    // pick the tapped one
    selectedCategory = filteredCats[widget.initialTabIndex];

    // now filter your services by that category.id
    _allCategoryServices =
        widget.categoriesViewModel.servicesList!.where((service) {
      // you could also just compare service['category']['id'], if you have it on the model
      final catTransList = service['category']['translations'] as List;
      final firstTrans = catTransList.first;
      return firstTrans['categories_id'].toString() ==
          selectedCategory['id'].toString();
    }).toList();

    // start with the full service list shown
    filteredServices = List.from(_allCategoryServices);
  }

  Future<void> _loadLanguage() async {
    final stored = await AppPreferences().get(key: dblang, isModel: false);
    if (stored != null) lang = stored;
    setState(() {});
  }

  void _filterServices() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        // no query → show everything in the category
        filteredServices = List.from(_allCategoryServices);
      } else {
        // only show those whose translated title contains q
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
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: Container(
        color: const Color(0xff4100E3),
        child: SafeArea(
          child: Stack(
            children: [
              // purple header
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
                                icon: const Icon(Icons.arrow_back,
                                    color: Color(0xFF6E6BE8)),
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
                                onTap: () =>
                                    setState(() => _isSearching = true),
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

              // white sheet
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
                        // category titles above cards
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/img/categoriesIcon.svg'),
                              const Gap(4),
                              Text(
                                _parentCategoryTitle,
                                style: getPrimaryRegularStyle(
                                  color: const Color(0xff180D38),
                                  fontSize: 12,
                                ),
                              ),
                              const Gap(4),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: context.appValues.appPadding.p3,
                                ),
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
                              const Gap(16),
                            ],
                          ),
                        ),
                        // list of cards
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p0,
                              vertical: 0,
                            ),
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = filteredServices[index];
                              dynamic trans;
                              for (var t
                                  in service['translations'] as List<dynamic>) {
                                if (t['languages_code'] == lang) {
                                  trans = t;
                                  break;
                                }
                              }
                              final title = trans?['title']?.toString() ?? '';
                              final rate = service['country_rates'][0];
                              final cost =
                                  '${rate['unit_rate']} ${rate['country']['currency']}';
                              final img = service['image'] != null
                                  ? "${context.resources.image.networkImagePath2}${service['image']}?quality=60"
                                  : null;

                              return Consumer2<JobsViewModel, ProfileViewModel>(
                                builder: (ctx, jobsVM, profVM, _) {
                                  return CategoriesScreenCards(
                                    category: selectedCategory,
                                    title: title,
                                    cost: cost,
                                    image: img ??
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    onTap: () {
                                      jobsVM.setInputValues(
                                          index: 'service',
                                          value: service['id']);
                                      final addr = profVM
                                          .getProfileBody['current_address'];
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
                                        PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) =>
                                              BookAService(
                                            service: service,
                                            lang: lang,
                                            image: img,
                                          ),
                                        ),
                                      );
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
}
