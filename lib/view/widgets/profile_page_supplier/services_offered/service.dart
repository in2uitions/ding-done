import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/app_prefs.dart';
import '../../../../view_model/jobs_view_model/jobs_view_model.dart';

class ServiceOfferedWidget extends StatefulWidget {
  final dynamic servicesViewModel;
  final List<dynamic> list;
  final dynamic profileViewModel;
  final dynamic data;

  const ServiceOfferedWidget({
    Key? key,
    required this.profileViewModel,
    required this.list,
    required this.data,
    required this.servicesViewModel,
  }) : super(key: key);

  @override
  State<ServiceOfferedWidget> createState() => _ServiceOfferedWidgetState();
}

class _ServiceOfferedWidgetState extends State<ServiceOfferedWidget> {
  String? lang;

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _getLanguage();
  }

  void _fetchServices() {
    if (!widget.servicesViewModel.servicesFetched) { // Check if services are not already fetched
      widget.servicesViewModel.setFetchedServices(true); // Set the flag to true after fetching services

      for (var e in widget.list) {
        widget.servicesViewModel.getServicesByCategoryID(int.parse(e.id!), widget.data["supplier_services"]);
      }
    }
  }

  Future<void> _getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(
        builder: (context, jobsViewModel, _) {
          return Padding(
            padding: EdgeInsets.all(context.appValues.appPadding.p10),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.servicesViewModel.listOfServices.length,
              itemBuilder: (BuildContext context, int index) {
                var servicesInCategory = widget.servicesViewModel.listOfServices[index];
                if (servicesInCategory.isEmpty) {
                  return const SizedBox.shrink();
                }

                var categoryTitle = servicesInCategory[0]["category"]["translations"]
                    .firstWhere(
                        (translation) => translation["languages_code"] == lang,
                    orElse: () => servicesInCategory[0]["category"]["translations"][0])
                ["title"]
                    .toString();

                return ExpansionTile(
                  title: Text(
                    categoryTitle,
                    style: getPrimaryRegularStyle(
                      fontSize: 15,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                  children: [
                    for (int innerIndex = 0; innerIndex < servicesInCategory.length; innerIndex++)
                      servicesInCategory[innerIndex]["status"]=='published'?
                      CheckboxListTile(
                        value: widget.servicesViewModel.checkboxValues[index][innerIndex],
                        activeColor: context.resources.color.btnColorBlue,
                        onChanged: (bool? value) async {
                          setState(() {
                            widget.servicesViewModel.setCheckbox(index, innerIndex);
                            int serviceId = servicesInCategory[innerIndex]["id"];
                            int supplierId = widget.data["id"];
                            if (value!) {
                              widget.servicesViewModel.addService(index, innerIndex, serviceId, supplierId);
                            } else {
                              widget.servicesViewModel.removeService(index, innerIndex, serviceId, supplierId);
                            }
                          });
                          await jobsViewModel.readJson();
                        },
                        title: Text(
                          servicesInCategory[innerIndex]["translations"]
                              .firstWhere(
                                  (translation) => translation["languages_code"]["code"] == lang,
                              orElse: () => servicesInCategory[innerIndex]["translations"][0])
                          ["title"]
                              .toString(),
                          style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.secondColorBlue,
                          ),
                        ),
                      ):Container(),
                  ],
                );
              },
            ),
          );
        }
    );
  }
}

