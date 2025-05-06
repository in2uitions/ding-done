import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/app_prefs.dart';

class CustomMultipleSelectionCheckBoxList extends StatefulWidget {
  const CustomMultipleSelectionCheckBoxList({
    super.key,
    // required this.list,
    required this.onChange,
    this.selectedValues,
    required this.index,
    required this.viewModel,
    this.errorText,
    this.validator,
  });

  // final List<dynamic> list;
  final Function(List<String>) onChange;
  final List<String>? selectedValues;
  final String index;
  final void Function({required String index, required List<String> value}) viewModel;
  final String? errorText;
  final FormFieldValidator<List<String>>? validator;

  @override
  State<CustomMultipleSelectionCheckBoxList> createState() =>
      _CustomMultipleSelectionCheckBoxListState();
}

class _CustomMultipleSelectionCheckBoxListState
    extends State<CustomMultipleSelectionCheckBoxList> {
  late List<String> _selectedValues;
  String _lang = 'en-US';

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.selectedValues ?? [];
    _loadLanguage();
    // Fetch services after first frame to have a valid context
  getData();
  }

  Future<void> _loadLanguage() async {
    final lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() => _lang = lang ?? 'en-US');
  }

  Future<void> getData() async {
    var list =await Provider.of<CategoriesViewModel>(context,
        listen: false)
        .getCategoriesAndServices();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      final servicesVM =
      Provider.of<ServicesViewModel>(context, listen: false);
      for (final item in list!) {
        final id = int.tryParse(item['id']?.toString() ?? '');
        if (id != null) {
          servicesVM.getServicesByCategoryID(id, null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServicesViewModel, CategoriesViewModel>(
      builder: (context, servicesVM, categoriesVM, _) {
        final listOfServices = servicesVM.listOfServices;
        // Guard if no services have loaded yet
        if (listOfServices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(context.appValues.appPadding.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listOfServices.length,
                itemBuilder: (ctx, catIndex) {
                  final servicesInCategory = listOfServices[catIndex];

                  // Category title
                  final catTranslations = servicesInCategory[0]["category"]["translations"] as List<dynamic>;
                  final cTitle = catTranslations.firstWhere(
                        (t) => t['languages_code'] == _lang,
                    orElse: () => catTranslations.first,
                  )['title'].toString();

                  return ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cTitle,
                          style: getPrimaryRegularStyle(
                            fontSize: 15,
                            color: context.resources.color.btnColorBlue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 1,
                          color: const Color(0xffededf6),
                        ),
                      ],
                    ),
                    children: [
                      for (int innerIndex = 0; innerIndex < servicesInCategory.length; innerIndex++)
                        Row(
                          children: [
                            Checkbox(
                              value: servicesVM.checkboxValues[catIndex][innerIndex],
                              activeColor: context.resources.color.btnColorBlue,
                              onChanged: (checked) {
                                setState(() {
                                  final svcId = servicesInCategory[innerIndex]["id"].toString();
                                  if (checked == true) {
                                    _selectedValues.add(svcId);
                                  } else {
                                    _selectedValues.remove(svcId);
                                  }
                                  widget.viewModel(
                                    index: widget.index,
                                    value: _selectedValues,
                                  );
                                  widget.onChange(_selectedValues);
                                });
                                servicesVM.setCheckbox(catIndex, innerIndex);
                              },
                            ),
                            SizedBox(
                              width: context.appValues.appSizePercent.w70,
                              child: Text(
                                // service translation
                                (servicesInCategory[innerIndex]["translations"] as List<dynamic>)
                                    .firstWhere(
                                      (t) => t['languages_code'] == _lang,
                                  orElse: () => servicesInCategory[innerIndex]["translations"][0],
                                )['title']
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryRegularStyle(
                                  fontSize: 14,
                                  color: context.resources.color.secondColorBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              if (widget.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.errorText!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
