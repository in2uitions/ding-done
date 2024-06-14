import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class JobTypeButtons extends StatefulWidget {
  var service;
  var country_code;
  var servicesViewModel;
  String? job_type;

  JobTypeButtons(
      {super.key,
      required this.service,
      required this.country_code,
      required this.servicesViewModel,
      required this.job_type});

  @override
  State<JobTypeButtons> createState() => _JobTypeButtonsState();
}

class _JobTypeButtonsState extends State<JobTypeButtons> {
  String? selectedOption;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOption = widget.job_type.toString();
    debugPrint('selected option ${widget.job_type}');
    debugPrint(
        'service chosen is ${widget.service} and country ${widget.country_code}');
    //i need to add this later
    // widget.servicesViewModel.getCountryRate(widget.service,widget.country_code);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: context.appValues.appSizePercent.w100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Online Consultation',
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff190C39),
                    ),
                  ),
                  // Text(
                  //   widget.servicesViewModel.countryRatesList.isNotEmpty
                  //       ? '${widget.servicesViewModel.countryRatesList[0].consultation_rate}€'
                  //       : '',
                  //   style: getPrimaryRegularStyle(
                  //       fontSize: 11, color: const Color(0xff6e6e6e)),
                  // ),
                ],
              ),
              leading: Radio(
                activeColor: context.resources.color.btnColorBlue,
                value: 'consultation',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                  jobsViewModel.setInputValues(index: 'job_type', value: value);
                  jobsViewModel.launchWhatsApp();
                },
              ),
            ),
          ),
          const Gap(15),
          Container(
            width: context.appValues.appSizePercent.w100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Physical Inspection',
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff190C39),
                    ),
                  ),
                  // Text(
                  //   widget.servicesViewModel.countryRatesList.isNotEmpty
                  //       ? '${widget.servicesViewModel.countryRatesList[0].inspection_rate}€'
                  //       : '',
                  //   style: getPrimaryRegularStyle(
                  //       fontSize: 11, color: const Color(0xff6e6e6e)),
                  // ),
                ],
              ),
              leading: Radio(
                activeColor: context.resources.color.btnColorBlue,
                value: 'inspection',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                  jobsViewModel.setInputValues(index: 'job_type', value: value);
                  jobsViewModel.setUpdatedJob(index: 'job_type', value: value);
                },
              ),
            ),
          ),
          const Gap(15),
          Container(
            width: context.appValues.appSizePercent.w100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Execution',
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff190C39),
                    ),
                  ),
                  // Text(
                  //   widget.servicesViewModel.countryRatesList.isNotEmpty
                  //       ? '${widget.servicesViewModel.countryRatesList[0].unit_rate}€ ${widget.servicesViewModel.countryRatesList[0].unit_type}'
                  //       : '',
                  //   style: getPrimaryRegularStyle(
                  //       fontSize: 11, color: const Color(0xff6e6e6e)),
                  // ),
                ],
              ),
              leading: Radio(
                activeColor: const Color(0xffF3D347),
                value: 'work',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                  jobsViewModel.setInputValues(index: 'job_type', value: value);
                  jobsViewModel.setUpdatedJob(index: 'job_type', value: value);
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
