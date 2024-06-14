import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../../res/app_prefs.dart';
import '../../../res/fonts/styles_manager.dart';

class UploadOneImage extends StatefulWidget {
  UploadOneImage(
      {super.key,
      required this.widget,
      required this.callback,
      required this.isImage});

  Widget widget;
  dynamic callback;
  bool isImage;
  @override
  State<UploadOneImage> createState() => UploadOneImageState();
}

class UploadOneImageState extends State<UploadOneImage> {
  final ImagePicker _picker = ImagePicker();
  File? image;
  String? directoryPath;
  List<File> multipleImages = [];
  CroppedFile? _croppedFile;
  XFile? _pickedFile;

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
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

  Future<void> _cropImage() async {
    try {
      if (_pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 50,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Edit',
                toolbarColor: const Color(0xff112b78),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Edit',
            ),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            _croppedFile = croppedFile;
          });
        }
      }
    } catch (error) {
      debugPrint("error in cropping image ${error}");
    }
  }

  Future<List<Map<String, dynamic>>> uploadFiles(List<XFile> files) async {
    dynamic filesType = {};
    final url = Uri.parse('https://cms.dingdone.app/files');
    final requests = <http.MultipartRequest>[];
    final futures = <Future<http.StreamedResponse>>[];
    String token = await getToken();
    // Create a MultipartRequest for each file

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
      final ids = <Map<String, dynamic>>[];
      for (var i = 0; i < responseList.length; i++) {
        final response = responseList[i];
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final responseJson = jsonDecode(responseBody);

          ids.add({
            'image': responseJson['data']['id'].toString(),
            "type": filesType[responseJson['data']['filename_download']]
          });

          widget.callback(null, ids);
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
    return GestureDetector(
      onTap: () async {
        // List<XFile>? picked = await _picker.pickMultiImage();
        showDialog(
          context: context,
          builder: (BuildContext ctx) => _buildPopupDialog(ctx),
        );
      },
      child: widget.widget,
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset('assets/img/x.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff112b78)),
                child: Text(
                  'Open camera',
                  style:
                      getPrimaryRegularStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  late XFile? image;
                  image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 25,
                  );

                  setState(() {
                    _pickedFile = image;
                  });

                  await _cropImage();
                  if (_croppedFile != null) {
                    uploadFiles([XFile(_croppedFile!.path)].toList());
                    widget.callback([File(_croppedFile!.path)].toList(), null);
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff112b78)),
                child: Text(
                  'Open gallery',
                  style:
                      getPrimaryRegularStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();

                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: false,
                  );

                  if (result != null) {
                    List<PlatformFile> files = result.files;
                    Directory tempDir = await getTemporaryDirectory();
                    List<XFile> picked =
                        files.map((file) => XFile(file!.path!)).toList();
                    if (picked.length == 1 &&
                        !lookupMimeType(picked[0]!.path!)
                            .toString()
                            .startsWith('video')) {
                      setState(() {
                        _pickedFile = picked[0];
                      });

                      await _cropImage();
                      uploadFiles([XFile(_croppedFile!.path)].toList());
                      widget.callback(
                          [File(_croppedFile!.path)].toList(), null);
                    } else {
                      uploadFiles(picked);
                      widget.callback(picked, null);
                    }
                  } else {}
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
