import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Categoriescard extends StatefulWidget {
  Categoriescard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });
  String title, image;
  dynamic onTap;

  @override
  State<Categoriescard> createState() => _CategoriescardState();
}

class _CategoriescardState extends State<Categoriescard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p15,
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p5,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: context.appValues.appSizePercent.w100,
          height: context.appValues.appSizePercent.h12,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: context.appValues.appSizePercent.w25,
                height: context.appValues.appSizePercent.h100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              const Gap(30),
              Flexible(
                child: Text(
                  widget.title,
                  maxLines: 2, // Limit the number of lines to 1
                  overflow: TextOverflow.ellipsis,
                  style: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: context.resources.color.btnColorBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}