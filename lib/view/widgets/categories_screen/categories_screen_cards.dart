import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/categories_screen/categories_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/services_model.dart';
import '../../../res/app_prefs.dart';
import '../../../res/fonts/styles_manager.dart';
import '../../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../../view_model/profile_view_model/profile_view_model.dart';
import '../../../view_model/services_view_model/services_view_model.dart';

class CategoriesScreenCards extends StatefulWidget {
  CategoriesScreenCards({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.category,
  });
  String title, image;
  dynamic onTap;
  dynamic category;

  @override
  State<CategoriesScreenCards> createState() => _CategoriesScreenCardsState();
}

class _CategoriesScreenCardsState extends State<CategoriesScreenCards> {
  String? lang;

  @override
  void initState() {
    super.initState();

    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesViewModel>(
        builder: (context, servicesViewModel, _) {
        // return ListView.builder(
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
              return Categoriescard(
                title: widget.title,
                image: widget.image,
                onTap: widget.onTap,
              );
            // });
      }
    );
  }
}