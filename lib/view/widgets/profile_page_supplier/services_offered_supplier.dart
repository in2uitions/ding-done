// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/services_offered/service.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ServicesOfferedSupplierProfile extends StatefulWidget {
  var profileViewModel;
  var data;
  var list;

  ServicesOfferedSupplierProfile(
      {super.key,
      required this.profileViewModel,
      required this.data,
      required this.list});

  @override
  State<ServicesOfferedSupplierProfile> createState() =>
      _ServicesOfferedSupplierProfileState();
}

class _ServicesOfferedSupplierProfileState
    extends State<ServicesOfferedSupplierProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesViewModel>(
        builder: (context, servicesViewModel, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p0,
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p10,
        ),
        child: Container(
          width: context.appValues.appSizePercent.w100,
          // height: context.appValues.appSizePercent.h55,
          // height: context.appValues.appSizePercent.h60,
          // height: 442,
          decoration: BoxDecoration(
            color: context.resources.color.colorWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p5,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/img/services_offered.svg'),
                    const Gap(10),
                    Text(
                      translate('profile.servicesOffered'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                color: Color(0xffEDF1F7),
              ),
              const Gap(30),
              ServiceOfferedWidget(
                  profileViewModel: widget.profileViewModel,
                  servicesViewModel: servicesViewModel,
                  data: widget.data,
                  list: widget.list
                  // list: categoriesViewModel.getCategories(),
                  ),

              // PlumbingServicesOfferedWidget(),
              // ElectricalServicesOfferedWidget(),
            ],
          ),
        ),
      );
    });
  }
}
