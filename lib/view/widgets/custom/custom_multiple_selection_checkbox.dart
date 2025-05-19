import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../res/app_prefs.dart';
import '../../../res/fonts/styles_manager.dart';
import '../../../view_model/categories_view_model/categories_view_model.dart';
import '../../../view_model/services_view_model/services_view_model.dart';

class CustomMultipleSelectionCheckBoxList extends StatefulWidget {
  const CustomMultipleSelectionCheckBoxList({
    Key? key,
    required this.onChange,
    this.selectedValues,
    required this.index,
    required this.viewModel,
    this.errorText,
    this.validator,
  }) : super(key: key);

  final Function(List<String>) onChange;
  final List<String>? selectedValues;
  final String index;
  final void Function({required String index, required List<String> value})
  viewModel;
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
    _selectedValues = widget.selectedValues != null
        ? List.from(widget.selectedValues!)
        : [];
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() => _lang = lang ?? 'en-US');
  }

  String _getTranslation(List<dynamic> translations) {
    final match = translations.firstWhere(
          (t) =>
      t['languages_code'] == _lang &&
          (t['title'] ?? '').toString().isNotEmpty,
      orElse: () => translations.first,
    );
    return (match['title'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServicesViewModel, CategoriesViewModel>(
      builder: (context, servicesVM, categoriesVM, _) {
        final topParents   = categoriesVM.parentCategoriesList ?? [];
        final subParents   = categoriesVM.categoriesList       ?? [];
        final allServices  = categoriesVM.servicesList         ?? [];

        if (topParents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(context.appValues.appPadding.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) For each top‐level parent category
              for (final top in topParents) ...[
                // Show its title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _getTranslation(top['translations'] as List<dynamic>),
                    style: getPrimaryBoldStyle(
                      fontSize: 16,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),

                // 2) Under that, show only the "parents" whose `class` equals top.id
                for (final parentCat in subParents.where((p) =>
                (p['class']['id'] as int) == (top['id'] as int))) ...[
                  ExpansionTile(
                    title: Text(
                      _getTranslation(parentCat['translations'] as List<dynamic>),
                      style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.secondColorBlue,
                      ),
                    ),
                    children: [
                      // 3) And for each of those, list exactly the same services
                      //    you were already filtering by parentCat.id
                      for (final svc in allServices.where((svc) {
                        final catTrans =
                        svc['category']['translations'] as List<dynamic>;
                        final t = catTrans.firstWhere(
                              (t) => t['languages_code'] == _lang,
                          orElse: () => catTrans.first,
                        );
                        return (t['categories_id'] as int) ==
                            (parentCat['id'] as int);
                      }))
                        _buildServiceRow(context, svc),
                    ],
                  ),
                ],
              ],

              if (widget.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceRow(BuildContext context, dynamic svc) {
    final svcId = svc['id'].toString();
    final svcTitle = _getTranslation(svc['translations'] as List<dynamic>);
    final isChecked = _selectedValues.contains(svcId);

    return Row(
      children: [
        Checkbox(
          value: isChecked,
          activeColor: context.resources.color.btnColorBlue,
          onChanged: (checked) {
            setState(() {
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
          },
        ),
        Expanded(
          child: Text(
            svcTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getPrimaryRegularStyle(
              fontSize: 14,
              color: context.resources.color.secondColorBlue,
            ),
          ),
        ),
      ],
    );
  }
}
