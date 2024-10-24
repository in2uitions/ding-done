import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

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
                style: getPrimaryBoldStyle(
                  fontSize: 18,
                  color: const Color(0xff38385E),
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
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.appValues.appPadding.p0,
                        bottom: context.appValues.appPadding.p0,
                        right: context.appValues.appPadding.p10,
                      ),
                      child: Container(
                        width: context.appValues.appSizePercent.w100,
                        height: context.appValues.appSizePercent.h20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: widget.image != null && widget.image.isNotEmpty
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: widget.image.length,
                                    onPageChanged: _onPageChanged,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          // borderRadius: const BorderRadius.only(
                                          //   bottomLeft: Radius.circular(20),
                                          //   topLeft: Radius.circular(20),
                                          // ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              '${context.resources.image.networkImagePath2}/${widget.image[index]['directus_files_id']['id']}?width=500',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (_currentIndex > 0)
                                    Positioned(
                                      left: 10,
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        onPressed: () {
                                          _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    ),
                                  if (_currentIndex < widget.image.length - 1)
                                    Positioned(
                                      right: 10,
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_forward,
                                            color: Colors.white),
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // borderRadius: const BorderRadius.only(
                                  //   bottomLeft: Radius.circular(20),
                                  //   topLeft: Radius.circular(20),
                                  // ),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://cdn.pixabay.com/photo/2012/11/28/10/32/welding-67640_1280.jpg?width=500',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: context.appValues.appSizePercent.w40,
                      child: Text(
                        widget.description != null
                            ? '${widget.description}'
                            : 'No Job Description',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: getPrimaryRegularStyle(
                          fontSize: 12,
                          color: const Color(0xff78789D),
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
