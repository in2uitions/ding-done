import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class JobDescriptionWidget extends StatefulWidget {
  var description;
  var image;

  JobDescriptionWidget({super.key, required this.description,required this.image});

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('uploaded media ${widget.image}');
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
      child: SizedBox(
        width: context.appValues.appSizePercent.w100,
        // height: context.appValues.appSizePercent.h22,
        // height: context.appValues.appSizePercent.h30,
        // decoration: BoxDecoration(
        //   color: context.resources.color.colorWhite,
        //   borderRadius: const BorderRadius.all(
        //     Radius.circular(20),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10),
              child: Text(
                translate('bookService.jobDescription'),
                style: getPrimaryBoldStyle(
                  fontSize: 20,
                  color: const Color(0xff180C38),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p0,
              ),
              child: Container(
                width: context.appValues.appSizePercent.w100,
                height: context.appValues.appSizePercent.h13,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: context.resources.color.colorWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.appValues.appPadding.p0,
                        bottom: context.appValues.appPadding.p0,
                        right: context.appValues.appPadding.p10,
                      ),
                      child: Container(
                        width: context.appValues.appSizePercent.w25,
                        height: context.appValues.appSizePercent.h13,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://www.benjaminfranklinplumbing.com/images/blog/10-Reasons-Why-a-Professional-Plumber-Is-Better-Than-DIY-_-Katy-TX.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.appValues.appSizePercent.w55,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.appValues.appPadding.p10,
                        ),
                        child: Text(
                          '${widget.description}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: getPrimaryRegularStyle(
                            fontSize: 13,
                            color: const Color(0xff180C39),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
