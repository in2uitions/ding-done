import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
        builder: (context, categoriesViewModel, _) {
      return Scaffold(
        backgroundColor: const Color(0xffF0F3F8),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.resources.color.btnColorBlue,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(
                                context.appValues.appPadding.p20),
                            child: Row(
                              children: [
                                InkWell(
                                  child: SvgPicture.asset(
                                      'assets/img/back-white.svg'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(width: context.appValues.appSize.s10),
                                Text(
                                  'Categories',
                                  style: getPrimaryRegularStyle(
                                      // color: context.resources.color.colorYellow,
                                      color: context.resources.color.colorWhite,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p0,
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                  ),
                  child: Column(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing:
                              8, // Adjust this value to add vertical spacing
                          crossAxisSpacing:
                              8, // Adjust this value to add horizontal spacing
                        ),
                        itemCount: categoriesViewModel.categoriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildServiceWidget(
                              categoriesViewModel.categoriesList[index]);
                        },
                      ),
                      const SizedBox(height: 15),
                      // Add space between the first and second row
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget buildServiceWidget(DropdownRoleModel service) {
    return InkWell(
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: context.resources.color.colorYellow,
        ),
        child: _isLoading
            ? SkeletonListView()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    '${context.resources.image.networkImagePath}/${service.image}.svg',
                    // placeholderBuilder: (context) =>
                    //     CircularProgressIndicator(), // Optional
                  ),
                  // Image.network(
                  //     'http://dingdonecms.stems.me/uploads/27732e38-5815-4094-999c-01967044122e.svg',
                  //     scale: 1,
                  //   ),
                  //   Image.network('${context.resources.image.networkImagePath}/${service.image}.svg'),
                  Text(
                    service.title ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getPrimaryRegularStyle(
                        fontSize: 13,
                        color: context.resources.color.btnColorBlue),
                  ),
                ],
              ),
      ),
      onTap: () {
        // Add your onTap functionality here
      },
    );
  }
}
