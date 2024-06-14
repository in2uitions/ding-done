import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_search_bar.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesViewModel>(
        builder: (context, servicesViewModel, _) {
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
                          child: Column(
                            children: [
                              Padding(
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
                                    SizedBox(
                                        width: context.appValues.appSize.s10),
                                    Text(
                                      'Services',
                                      style: getPrimaryRegularStyle(
                                          // color: context.resources.color.colorYellow,
                                          color: context
                                              .resources.color.colorWhite,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                              Consumer<ServicesViewModel>(
                                  builder: (context, servicesViewModel, _) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      context.appValues.appPadding.p20,
                                      context.appValues.appPadding.p10,
                                      context.appValues.appPadding.p20,
                                      context.appValues.appPadding.p0),
                                  child: CustomSearchBar(
                                      index: 'search_services',
                                      hintText: "Search for services...",
                                      viewModel: servicesViewModel.filterData),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s20),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p20,
                      context.appValues.appPadding.p0,
                      context.appValues.appPadding.p20,
                      context.appValues.appPadding.p20),
                  child: Column(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          // Adjust this value to add vertical spacing
                          crossAxisSpacing: 8,
                          childAspectRatio: 159 /
                              74, // Adjust this value to add horizontal spacing
                        ),
                        itemCount: servicesViewModel.servicesList2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildServiceWidget(
                              servicesViewModel.servicesList2[index]);
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

  Widget buildServiceWidget(ServicesModel service) {
    return Consumer2<JobsViewModel, ProfileViewModel>(
        builder: (context, jobsViewModel, profileViewModel, _) {
      return InkWell(
        child: Container(
          width: 159,
          height: 74,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: context.resources.color.colorWhite,
          ),
          child: Padding(
            padding: EdgeInsets.all(context.appValues.appPadding.p10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${service.category["title"]}',
                    maxLines: 1,
                    style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.secondColorBlue),
                  ),
                  Text(
                    '${service.title}',
                    maxLines: 1,
                    style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.btnColorBlue),
                  ),
                ]),
          ),
        ),
        onTap: () {},
      );
    });
  }
}
