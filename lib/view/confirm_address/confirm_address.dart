import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_address/add_new_address_widget.dart';
import 'package:dingdone/view/widgets/confirm_address/addresses_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';

class ConfirmAddress extends StatefulWidget {
  final Map<String, dynamic>? initialAddress;
  ConfirmAddress({super.key, this.initialAddress});

  @override
  State<ConfirmAddress> createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  bool _didInit = false;
  bool isLoading = false;

  Future<void> _handleRefresh() async {
    try {
      String? role =
          await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(ConfirmAddress()));
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final jobsVM = Provider.of<JobsViewModel>(context, listen: false);

      if (widget.initialAddress != null) {
        final a = widget.initialAddress!;
        // prefill every field you need:

        jobsVM.setInputValues(index: 'id', value: a['id']?.toString() ?? '');
        jobsVM.setInputValues(index: 'street_number', value: a['street_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'building_number', value: a['building_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'floor',           value: a['floor']?.toString()           ?? '');
        jobsVM.setInputValues(index: 'apartment_number', value: a['apartment_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'city',            value: a['city']?.toString()            ?? '');
        jobsVM.setInputValues(index: 'zone',            value: a['zone']?.toString()            ?? '');
        jobsVM.setInputValues(index: 'address_label',   value: a['address_label']?.toString()   ?? '');
        jobsVM.setInputValues(index: 'latitude',        value: a['latitude']?.toString()        ?? '');
        jobsVM.setInputValues(index: 'longitude',       value: a['longitude']?.toString()       ?? '');
      } else {
        // new address: clear any leftover values
        // jobsVM.clearJobsBody(); // implement this in your ViewModel
        jobsVM.setSaved(false);

      }

      _didInit = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, JobsViewModel>(
        builder: (context, profileViewModel, jobsViewModel, _) {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          // backgroundColor: const Color(0xffF0F3F8),
          backgroundColor: const Color(0xffFEFEFE),
          body: Stack(
            children: [
              Container(
                width: context.appValues.appSizePercent.w100,
                height: context.appValues.appSizePercent.h50,
                decoration: const BoxDecoration(
                  color: Color(0xff4100E3),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20,
                      vertical: context.appValues.appPadding.p10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'confirmAddress.confirmAddress'.tr(),
                          style: getPrimarySemiBoldStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.85,
                  minChildSize: 0.85,
                  maxChildSize: 1,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
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
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        context.appValues.appPadding.p20,
                                    vertical: context.appValues.appPadding.p10,
                                  ),
                                  child: Text(
                                   'profile.addresses'.tr(),
                                    style: getPrimaryRegularStyle(
                                      fontSize: 12,
                                      color: const Color(0xff2F3036),
                                    ),
                                  ),
                                ),
                                // const AddressesButtonsWidget(),
                                const AddNewAddressWidget(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.appValues.appPadding.p10,
                                    horizontal:
                                        context.appValues.appPadding.p25,
                                  ),
                                  child: Container(
                                    width: 327,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff4100E3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if(!jobsViewModel.saved){
                                          isLoading=true;

                                          if (jobsViewModel.validate()) {
                                            if(await profileViewModel
                                                .patchProfileData(
                                                jobsViewModel.getjobsBody)==true){
                                              jobsViewModel.setSaved(true);
                                              // jobsViewModel.saved=true;
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      simpleAlert(
                                                        context,
                                                        'button.success'.tr(),
                                                      ));
                                            }else{
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      simpleAlert(
                                                        context,
                                                        'button.failure'.tr(),
                                                      ));
                                            }
                                          }
                                          // jobsViewModel.clearJobsBody();

                                          isLoading=false;
                                        }

                                      },
                                      child: Center(
                                        child: isLoading?
                                        CircularProgressIndicator():
                                        jobsViewModel.saved?Text(
                                          'button.saved'.tr(),
                                          style: getPrimaryBoldStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ):Text(
                                          'button.save'.tr(),
                                          style: getPrimaryBoldStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
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
        ),
      );
    });
  }
}
Widget simpleAlert(BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
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
        message == 'button.success'.tr()

        // service-popup-image.svg
            ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
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
