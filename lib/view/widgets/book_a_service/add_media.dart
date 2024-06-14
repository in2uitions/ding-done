import 'dart:convert';
import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AddMedia extends StatefulWidget {
  const AddMedia({super.key});

  @override
  State<AddMedia> createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  List<String> images = [];
  List<XFile> allImages = [];
  int currentIndex = 0;
  List<Map<String?, dynamic>>? uploadedImageIds = [];
  final ids = <Map<String?, dynamic>>[];

  Future<void> _pickImage(JobsViewModel jobsViewModel) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Delay the layout update by a short duration
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        images.add(pickedFile.path);
        allImages.add(XFile(pickedFile.path));
        currentIndex = images.length - 1;
      });
      uploadedImageIds = await uploadFiles([XFile(pickedFile.path)]);
      jobsViewModel.setInputValues(
          index: "uploaded_media", value: uploadedImageIds);

      debugPrint('${images}');
    }
  }

  void _navigateToImage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<String> getToken() async {
    try {
      String? token =
          await AppPreferences().get(key: userTokenKey, isModel: false);
      if (token != null || token != '') {
        return "Bearer $token";
      }
      return '';
    } catch (err) {
      return '';
    }
  }

  Future<List<Map<String?, dynamic>>> uploadFiles(List<XFile> files) async {
    dynamic filesType = {};
    final url = Uri.parse('https://cms.dingdone.app/files');
    final requests = <http.MultipartRequest>[];
    final futures = <Future<http.StreamedResponse>>[];
    String token = await getToken();
    // Create a MultipartRequest for each file
    debugPrint('token : $token');
    try {
      for (var i = 0; i < files.length; i++) {
        XFile file = files[i];

        // dynamic result;
        dynamic compressedFile;
        // String absolutePath = path.absolute(file.path);

        // String compressedFile1 = '${file.path.split('/').last}';
        String path =
            '${file.path.replaceAll('${file.path.split('/').last}', '')}file_picker/${file.path.split('/').last}';
        if (lookupMimeType(file.path).toString().startsWith('image')) {
          final result = await FlutterImageCompress.compressWithFile(
            File(file.path).absolute.path,
            // file.path,
            quality: 50,
          );
          compressedFile = File(file.path);
          await compressedFile.writeAsBytes(result ?? []);
        }

        final request = http.MultipartRequest('POST', url);
        final fileStream =
            http.ByteStream(Stream.castFrom(compressedFile.openRead()));
        final fileLength = await compressedFile.length();
        final multipartFile = http.MultipartFile(
          'file',
          fileStream,
          fileLength,
          filename: compressedFile.path.split('/').last,
        );
        filesType = {
          ...filesType,
          multipartFile.filename: lookupMimeType(compressedFile.path)
        };
        request.files.add(multipartFile);
        request.headers.addAll({'Authorization': 'Bearer $token'});
        requests.add(request);
      }

      // Send each request in parallel
      for (var i = 0; i < requests.length; i++) {
        futures.add(requests[i].send());
      }

      final responseList = await Future.wait(futures);
      for (var i = 0; i < responseList.length; i++) {
        final response = responseList[i];
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final responseJson = jsonDecode(responseBody);
          ids.add(
            {"directus_files_id": responseJson['data']['id'].toString()},
          );
          // ids.add({
          //            'image': responseJson['data']['id'].toString(),
          //            "type": filesType[responseJson['data']['filename_download']]
          //          });

          // widget.callback(null, ids);
          return ids;
        } else {
          throw Exception(
              'Failed to upload file ${i + 1}: ${response.statusCode}');
        }
      }
    } catch (error) {
      debugPrint('compress error ${error}');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p20,
      ),
      child: Container(
        width: context.appValues.appSizePercent.w100,
        // height: context.appValues.appSizePercent.h15,
        // height: context.appValues.appSizePercent.h30,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<JobsViewModel>(builder: (context, jobsViewModel, error) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.appValues.appPadding.p10,
                          ),
                          child: Text(
                            translate('bookService.addMedia'),
                            style: getPrimaryBoldStyle(
                                fontSize: 20,
                                color: context.resources.color.btnColorBlue),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: InkWell(
                            child: Container(
                              width: context.appValues.appSizePercent.w12,
                              height: context.appValues.appSizePercent.h6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xffF3D347),
                              ),
                              child: Icon(
                                Icons.add,
                                color: context.resources.color.colorWhite,
                                size: 25,
                              ),
                            ),
                            onTap: () async {
                              _pickImage(jobsViewModel);
                            },
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        if (images.isNotEmpty)
                          GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.velocity.pixelsPerSecond.dx > 0) {
                                // Swipe right
                                if (currentIndex > 0) {
                                  _navigateToImage(currentIndex - 1);
                                }
                              } else if (details.velocity.pixelsPerSecond.dx <
                                  0) {
                                // Swipe left
                                if (currentIndex < images.length - 1) {
                                  _navigateToImage(currentIndex + 1);
                                }
                              }
                            },
                            child: Image.file(
                              File(images[currentIndex]),
                              width: context.appValues.appSizePercent.w16p7,
                              height: context.appValues.appSizePercent.h8,
                              fit: BoxFit.cover,
                            ),
                          ),
                        images.isNotEmpty
                            ? Positioned(
                                top: 2,
                                right: 0,
                                child: currentIndex >= 0
                                    ? InkWell(
                                        child: Icon(
                                          Icons.delete,
                                          color: context
                                              .resources.color.secondColorBlue,
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            images.removeAt(currentIndex);
                                            allImages.removeAt(currentIndex);
                                            uploadedImageIds
                                                ?.removeAt(currentIndex);
                                            if (images.isNotEmpty) {
                                              currentIndex = 0;
                                            } else {
                                              currentIndex = -1;
                                            }
                                          });

                                          jobsViewModel.setInputValues(
                                            index: "uploaded_media",
                                            value: uploadedImageIds,
                                          );
                                        },
                                      )
                                    : Container(),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const Gap(15),
          ],
        ),
      ),
    );
  }
}
