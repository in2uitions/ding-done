import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Categoriescard extends StatefulWidget {
  Categoriescard({
    super.key,
    required this.title,
    required this.image,
    required this.cost,
    required this.onTap,
  });
  String title, image;
  dynamic onTap;
  dynamic cost;

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
          // height: context.appValues.appSizePercent.h15,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffEAEAFF).withOpacity(0.35),
          ),
          child: Row(
            children: [
              Container(
                // width: context.appValues.appSizePercent.w35,
                width: 76,
                height: context.appValues.appSizePercent.h100,
                decoration: BoxDecoration(
                  color: const Color(0xffEAEAFF),
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
              const Gap(30),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2, // Limit the number of lines to 1
                      overflow: TextOverflow.ellipsis,
                      style: getPrimaryBoldStyle(
                        fontSize: 14,
                        color: context.resources.color.btnColorBlue,
                      ),
                    ),
                    Text(
                      'Cost: ${widget.cost}',
                      maxLines: 1, // Limit the number of lines to 1
                      overflow: TextOverflow.ellipsis,
                      style: getPrimaryRegularStyle(
                        fontSize: 10,
                        color: const Color(0xff6E6BE8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
