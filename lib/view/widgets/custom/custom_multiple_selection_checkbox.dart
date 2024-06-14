import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/app_prefs.dart';

class CustomMultipleSelectionCheckBoxList extends StatefulWidget {
  const CustomMultipleSelectionCheckBoxList({
    super.key,
    required this.list,
    required this.onChange,
    this.selectedValues,
    required this.index,
    required this.viewModel,
    required this.servicesViewModel,
    this.errorText,
    this.validator,
  });

  final List<DropdownRoleModel> list;
  final Function(List<String>) onChange;
  final List<String>? selectedValues;
  final String index;
  final dynamic viewModel;
  final dynamic servicesViewModel;
  final String? errorText;
  final FormFieldValidator<List<String>>? validator;

  @override
  State<CustomMultipleSelectionCheckBoxList> createState() =>
      _CustomMultipleSelectionCheckBoxListState();
}

String? lang;

class _CustomMultipleSelectionCheckBoxListState
    extends State<CustomMultipleSelectionCheckBoxList> {
  List<String> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.selectedValues ?? [];

    widget.list.forEach((e) {
      widget.servicesViewModel.getServicesByCategoryID(int.parse(e.id!), null);
    });
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesViewModel>(
        builder: (context, servicesViewModel, _) {
          return Padding(
            padding: EdgeInsets.all(context.appValues.appPadding.p10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= servicesViewModel.listOfServices.length) {
                      return const SizedBox.shrink();
                    }

                    var categoryTitle;
                    Map<String, dynamic>? categories;

                    if (servicesViewModel.listOfServices[index].isNotEmpty) {
                      for (Map<String, dynamic> translation
                      in servicesViewModel.listOfServices[index][0]["category"]["translations"]) {
                        if (translation["languages_code"]["code"] == lang) {
                          categoryTitle = translation["title"];
                          categories = translation;
                          break; // Break the loop once the translation is found
                        }
                      }
                    }

                    var servicesInCategory = servicesViewModel.listOfServices[index];

                    return ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryTitle ?? '',
                            style: getPrimaryRegularStyle(
                              fontSize: 15,
                              color: context.resources.color.btnColorBlue,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 2, // Adjust the height of the "divider"
                            color: context.resources.color.btnColorBlue, // Set the color of the "divider"
                          ),
                        ],
                      ),
                      children: [
                        for (int innerIndex = 0;
                        innerIndex < servicesInCategory.length;
                        innerIndex++)
                          Builder(builder: (context) {
                            Map<String, dynamic>? services;

                            for (Map<String, dynamic> translation
                            in servicesInCategory[innerIndex]["translations"]) {
                              if (translation["languages_code"]["code"] == lang) {
                                services = translation;
                                break; // Break the loop once the translation is found
                              }
                            }
                            return Row(
                              children: [
                                Checkbox(
                                  value: servicesViewModel.checkboxValues[index]
                                  [innerIndex],
                                  activeColor: context.resources.color.btnColorBlue,
                                  onChanged: (bool? checked) {
                                    setState(() {
                                      if (checked == true) {
                                        _selectedValues.add(
                                            '${servicesInCategory[innerIndex]["id"]}');
                                        widget.viewModel(
                                            index: widget.index,
                                            value: _selectedValues);
                                      } else {
                                        _selectedValues.remove(
                                            '${servicesInCategory[innerIndex]["id"]}');
                                        widget.viewModel(
                                            index: widget.index,
                                            value: _selectedValues);
                                      }
                                      widget.onChange(_selectedValues);
                                    });
                                    servicesViewModel.setCheckbox(
                                        index, innerIndex);
                                  },
                                ),
                                SizedBox(
                                  width: context.appValues.appSizePercent.w70,
                                  child: Text(
                                    services != null
                                        ? services!["title"]
                                        : servicesInCategory[innerIndex]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getPrimaryRegularStyle(
                                      fontSize: 15,
                                      color:
                                      context.resources.color.secondColorBlue,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
