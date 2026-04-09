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
    required this.selectedParentCategoryId,
    this.errorText,
    this.validator,
  }) : super(key: key);

  final Function(List<String>) onChange;
  final List<String>? selectedValues;
  final String index;
  final int selectedParentCategoryId;
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
    _selectedValues =
    widget.selectedValues != null ? List.from(widget.selectedValues!) : [];
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await AppPreferences().get(key: dblang, isModel: false);
    if (mounted) {
      setState(() => _lang = lang ?? 'en-US');
    }
  }

  String _getTranslation(List<dynamic> translations) {
    if (translations.isEmpty) return '';

    final currentLangMatch = translations.cast<Map<String, dynamic>>().where(
          (t) =>
      t['languages_code'] == _lang &&
          (t['title'] ?? '').toString().isNotEmpty,
    );

    if (currentLangMatch.isNotEmpty) {
      return (currentLangMatch.first['title'] ?? '').toString();
    }

    final englishMatch = translations.cast<Map<String, dynamic>>().where(
          (t) =>
      t['languages_code'] == 'en-US' &&
          (t['title'] ?? '').toString().isNotEmpty,
    );

    if (englishMatch.isNotEmpty) {
      return (englishMatch.first['title'] ?? '').toString();
    }

    return (translations.first['title'] ?? '').toString();
  }

  int? _extractServiceCategoryId(dynamic svc) {
    try {
      final catTrans = svc['category']['translations'] as List<dynamic>;

      final currentLangMatch = catTrans.cast<Map<String, dynamic>>().where(
            (t) => t['languages_code'] == _lang && t['categories_id'] != null,
      );

      if (currentLangMatch.isNotEmpty) {
        return currentLangMatch.first['categories_id'] as int;
      }

      final englishMatch = catTrans.cast<Map<String, dynamic>>().where(
            (t) => t['languages_code'] == 'en-US' && t['categories_id'] != null,
      );

      if (englishMatch.isNotEmpty) {
        return englishMatch.first['categories_id'] as int;
      }

      if (catTrans.isNotEmpty && catTrans.first['categories_id'] != null) {
        return catTrans.first['categories_id'] as int;
      }
    } catch (_) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServicesViewModel, CategoriesViewModel>(
      builder: (context, servicesVM, categoriesVM, _) {
        final subParents = categoriesVM.categoriesList ?? [];
        final allServices = categoriesVM.servicesList ?? [];

        final filteredSubParents = subParents.where((p) {
          final parentClass = p['class'];
          if (parentClass == null) return false;
          return (parentClass['id'] as int) == widget.selectedParentCategoryId;
        }).toList();

        if (filteredSubParents.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No subcategories found for this category.',
              style: getPrimaryRegularStyle(
                fontSize: 14,
                color: context.resources.color.secondColorBlue,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(context.appValues.appPadding.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final parentCat in filteredSubParents) ...[
                ExpansionTile(
                  title: Text(
                    _getTranslation(parentCat['translations'] as List<dynamic>),
                    style: getPrimaryRegularStyle(
                      fontSize: 15,
                      color: context.resources.color.secondColorBlue,
                    ),
                  ),
                  children: [
                    for (final svc in allServices.where((svc) {
                      final serviceCategoryId = _extractServiceCategoryId(svc);
                      return serviceCategoryId == (parentCat['id'] as int);
                    }))
                      _buildServiceRow(context, svc),
                  ],
                ),
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
                if (!_selectedValues.contains(svcId)) {
                  _selectedValues.add(svcId);
                }
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