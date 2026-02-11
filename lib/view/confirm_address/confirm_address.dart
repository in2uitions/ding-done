import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_address/add_new_address_widget.dart';
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
  const ConfirmAddress({super.key, this.initialAddress});

  @override
  State<ConfirmAddress> createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress>
    with TickerProviderStateMixin {
  bool _didInit = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final jobsVM = Provider.of<JobsViewModel>(context, listen: false);

      if (widget.initialAddress != null) {
        final a = widget.initialAddress!;

        jobsVM.setInputValues(index: 'id', value: a['id']?.toString() ?? '');
        jobsVM.setInputValues(index: 'street_number', value: a['street_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'building_number', value: a['building_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'floor', value: a['floor']?.toString() ?? '');
        jobsVM.setInputValues(index: 'apartment_number', value: a['apartment_number']?.toString() ?? '');
        jobsVM.setInputValues(index: 'city', value: a['city']?.toString() ?? '');
        jobsVM.setInputValues(index: 'zone', value: a['zone']?.toString() ?? '');
        jobsVM.setInputValues(index: 'address_label', value: a['address_label']?.toString() ?? '');
        jobsVM.setInputValues(index: 'latitude', value: a['latitude']?.toString() ?? '');
        jobsVM.setInputValues(index: 'longitude', value: a['longitude']?.toString() ?? '');
      } else {
        jobsVM.setSaved(false);
      }

      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, JobsViewModel>(
      builder: (context, profileViewModel, jobsViewModel, _) {

        final hasLocation =
            jobsViewModel.getjobsBody['latitude'] != null &&
                jobsViewModel.getjobsBody['latitude'].toString().isNotEmpty &&
                jobsViewModel.getjobsBody['longitude'] != null &&
                jobsViewModel.getjobsBody['longitude'].toString().isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xffFEFEFE),
          body: Stack(
            children: [

              /// TOP HEADER (UNCHANGED)
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

              /// DRAGGABLE SHEET
              DraggableScrollableSheet(
                initialChildSize: 0.85,
                minChildSize: 0.85,
                maxChildSize: 0.85,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color(0xffFEFEFE),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [

                        const Gap(30),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
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

                        /// MAP ALWAYS VISIBLE
                        const AddNewAddressWidget(),

                        /// SMOOTH APPEARING SECTION
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: hasLocation
                              ? Column(
                            children: [

                              /// SAVE BUTTON
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.appValues.appPadding.p10,
                                  horizontal: context.appValues.appPadding.p25,
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
                                      if (!jobsViewModel.saved) {
                                        setState(() => isLoading = true);

                                        if (jobsViewModel.validate()) {
                                          if (await profileViewModel
                                              .patchProfileData(
                                              jobsViewModel.getjobsBody) ==
                                              true) {

                                            jobsViewModel.setSaved(true);

                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  simpleAlert(
                                                      context,
                                                      'button.success'.tr()),
                                            ).then((_) {
                                              Navigator.pop(context);
                                            });

                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  simpleAlert(
                                                      context,
                                                      'button.failure'.tr()),
                                            );
                                          }
                                        }

                                        setState(() => isLoading = false);
                                      }
                                    },
                                    child: Center(
                                      child: isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : jobsViewModel.saved
                                          ? Text(
                                        'button.saved'.tr(),
                                        style: getPrimaryBoldStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                          : Text(
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
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ALERT DIALOG
Widget simpleAlert(BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: SvgPicture.asset('assets/img/x.svg'),
            onTap: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(height: 10),
        message == 'button.success'.tr()
            ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: getPrimaryRegularStyle(
            fontSize: 17,
            color: const Color(0xff4100E3),
          ),
        ),
      ],
    ),
  );
}
