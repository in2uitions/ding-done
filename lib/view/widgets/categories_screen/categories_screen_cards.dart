import 'package:dingdone/view/widgets/categories_screen/categories_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/app_prefs.dart';
import '../../../view_model/services_view_model/services_view_model.dart';

class CategoriesScreenCards extends StatefulWidget {
  CategoriesScreenCards({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.category,
    required this.cost,
  });
  String title, image;
  dynamic onTap;
  dynamic category;
  dynamic cost;

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
        cost: widget.cost,
        onTap: widget.onTap,
      );
      // });
    });
  }
}
