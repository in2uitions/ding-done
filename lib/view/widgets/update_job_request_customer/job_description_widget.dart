import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../full_screen_image/full_screen_image.dart';

class JobDescriptionWidget extends StatefulWidget {
  var description;
  var image;

  JobDescriptionWidget(
      {super.key, required this.description, required this.image});

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('uploaded media ${widget.image[0]['directus_files_id']['id']}');
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
                  horizontal: context.appValues.appPadding.p0,
                  vertical: context.appValues.appPadding.p10),
              child: Text(
                translate('bookService.jobDescriptionByUser'),
                style: getPrimaryRegularStyle(
                  fontSize: 14,
                  color: const Color(0xff180B3C),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p0,
              ),
              child: Container(
                // width: context.appValues.appSizePercent.w100,
                // height: context.appValues.appSizePercent.h13,
                // decoration: BoxDecoration(
                //   boxShadow: [
                //     BoxShadow(
                //       color: const Color(0xff000000).withOpacity(0.1),
                //       spreadRadius: 1,
                //       blurRadius: 5,
                //       offset: const Offset(0, 3), // changes position of shadow
                //     ),
                //   ],
                //   color: context.resources.color.colorWhite,
                //   borderRadius: const BorderRadius.all(
                //     Radius.circular(20),
                //   ),
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.appValues.appSizePercent.w40,
                      child: Text(
                        widget.description != null
                            ? '${widget.description}'
                            : 'No Job Description',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: getPrimaryRegularStyle(
                          fontSize: 14,
                          color: const Color(0xff71727A),
                        ),
                      ),
                    ),
                    const Gap(10),
                    widget.image != null && widget.image.isNotEmpty?
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.appValues.appPadding.p0,
                        bottom: context.appValues.appPadding.p0,
                        right: context.appValues.appPadding.p10,
                      ),
                      child: Container(
                        // width: context.appValues.appSizePercent.w100,
                        // height: context.appValues.appSizePercent.h20,
                        width:2000,
                        height: 72,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        child:
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 200, // Adjust as needed
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.image.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final imageUrls = widget.image.map<String>((img) =>
                                  '${context.resources.image.networkImagePath2}/${img['directus_files_id']['id']}?width=1000',
                                  ).toList();

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImageViewer(
                                            imageUrls: imageUrls,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrls[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Optional: you can keep or remove arrows for custom scrolling
                          ],
                        )


                      ),
                    ):
                    Container(),
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
