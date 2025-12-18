import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'app_colors.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';

abstract class CameraOnCompleteListener {
  void onSuccessFile(String file, String fileType);
}

class CameraHelper {
  final picker = ImagePicker();
  BuildContext context = Get.context!;
  CropAspectRatio? cropAspectRatio;
  late CameraOnCompleteListener callback;

  CameraHelper(this.callback);

  void setCropping(CropAspectRatio cropAspectRatio) {
    this.cropAspectRatio = cropAspectRatio;
  }

  void openAttachmentDialog() async {
    if (await isStorageEnabled()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'docx',
          'xlsx',
          'pptx',
          'doc',
          'xls',
          'ppt',
          'txt'
        ],
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        debugPrint(file.path);
        callback.onSuccessFile(file.path, "document");
      } else {
        // user canceled the picker
      }
    }
  }

  Future<String> convertImageToSRGB(String path) async {
    final bytes = await File(path).readAsBytes();

    img.Image? image = img.decodeImage(bytes);
    if (image == null) return path;

    // This forces sRGB without resizing (much faster)
    final newBytes = img.encodeJpg(image, quality: 95);

    final newPath = path.toLowerCase().endsWith(".heic")
        ? path.replaceAll(".heic", ".jpg")
        : path.toLowerCase().endsWith(".heif")
        ? path.replaceAll(".heif", ".jpg")
        : path;

    final file = File(newPath);
    await file.writeAsBytes(newBytes);

    return newPath;
  }



  static const _channel = MethodChannel("srgb_converter");

  Future<String> convertSRGBNative(String path) async {
    final newPath = await _channel.invokeMethod("convertToSRGB", path);
    return newPath;
  }

  void openImagePicker({bool onlyCamera = false, bool onlyGallery = false}) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 55),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!onlyGallery)
                    GestureDetector(
                      onTap: () async {
                        if (await isCameraEnabled()) {
                          Navigator.pop(context);
                          cropAspectRatio != null
                              ? getImageWithoutCropping(ImageSource.camera)
                              : getImageWithoutCropping(ImageSource.camera);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.appColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Camera",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (!onlyGallery && !onlyCamera) const SizedBox(width: 60),
                  if (!onlyCamera)
                    GestureDetector(
                      onTap: () async {
                        if (await isStorageEnabled()) {
                          Navigator.pop(context);
                          cropAspectRatio != null
                              ? getImageWithoutCropping(ImageSource.gallery)
                              : getImageWithoutCropping(ImageSource.gallery);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.appColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.image_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Gallery",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    );
  }

  // void openImagePicker({bool onlyCamera = true,bool onlyGallery = true}) {
  //   showModalBottomSheet(
  //     context: context,
  //     useRootNavigator: false,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext bc) => GestureDetector(
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 55),
  //         padding: const EdgeInsets.symmetric(
  //           vertical: 15,
  //         ),
  //         decoration: const BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.all(Radius.circular(30))),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(height: 20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 GestureDetector(
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         height: 50,
  //                         width: 50,
  //                         decoration: const BoxDecoration(
  //                           color: AppColors.appColor,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(
  //                           Icons.camera_alt_rounded,
  //                           size: 25,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       const Text(
  //                         "Camera",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontFamily: 'Poppins',
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 12),
  //                       )
  //                     ],
  //                   ),
  //                   onTap: () async {
  //                     if (await isCameraEnabled()) {
  //                       Navigator.pop(context);
  //                       cropAspectRatio != null
  //                           ? getImageWithCropping(ImageSource.camera)
  //                           : getImageWithoutCropping(ImageSource.camera);
  //                     }
  //                   },
  //                 ),
  //                 const SizedBox(
  //                   width: 60,
  //                 ),
  //                 GestureDetector(
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         height: 50,
  //                         width: 50,
  //                         decoration: const BoxDecoration(
  //                           color: AppColors.appColor,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(
  //                           Icons.image_rounded,
  //                           size: 25,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       const Text(
  //                         "Gallery",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontFamily: 'Poppins',
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 12),
  //                       )
  //                     ],
  //                   ),
  //                   onTap: () async {
  //                     if (await isStorageEnabled()) {
  //                       Navigator.pop(context);
  //                       cropAspectRatio != null
  //                           ? getImageWithCropping(ImageSource.gallery)
  //                           : getImageWithoutCropping(ImageSource.gallery);
  //                     }
  //                   },
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 15),
  //             InkWell(
  //               child: const Padding(
  //                 padding: EdgeInsets.all(13.0),
  //                 child: Text(
  //                   "Cancel",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: 'Poppins',
  //                     fontSize: 14,
  //                     decoration: TextDecoration.underline,
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             )
  //           ],
  //         ),
  //       ),
  //       onTap: () {
  //         FocusScope.of(context).requestFocus(FocusScopeNode());
  //       },
  //     ),
  //   );
  // }

  Future<bool> openVideoPicker() async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.image_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    );
    return false;
  }

  void openImagePickerNew() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text("Choose Image"),
      isDismissible: true,
      actions: [
        BottomSheetAction(
            title: const Text(
              'Camera',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            onPressed: (context) async {
              if (await isCameraEnabled()) {
                Navigator.pop(context);
                cropAspectRatio != null
                    ? getImageWithoutCropping(ImageSource.camera)
                    : getImageWithoutCropping(ImageSource.camera);
              }
            }),
        BottomSheetAction(
          title: const Text(
            'Gallery',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          onPressed: (context) async {
            if (await isStorageEnabled()) {
              Navigator.pop(context);
              cropAspectRatio != null
                  ? getImageWithoutCropping(ImageSource.gallery)
                  : getImageWithoutCropping(ImageSource.gallery);
            }
          },
        ),
      ],
      cancelAction: CancelAction(
          title: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          onPressed: (BuildContext context) {
            Get.back();
          }),
    );
  }

  Future getImageWithCropping(ImageSource imageSource) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    CroppedFile? croppedFile;
    if (imageFile != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: cropAspectRatio!,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blueAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        ],
      );
    }
    if (croppedFile != null) {

      callback.onSuccessFile(croppedFile.path, "image");
    } else {
      print('No image selected.');
    }
  }

  Future getImageWithoutCropping(ImageSource imageSource) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile != null) {
      if (Platform.isIOS) {
        String fixedPath = await convertSRGBNative(imageFile.path);
        //  String fixedPath = await fastConvertToSRGB(imageFile.path);
        callback.onSuccessFile(fixedPath, "image");
      } else {
        callback.onSuccessFile(imageFile.path, "image");
      }
     // String fixedPath = await convertSRGBNative(imageFile.path);
    //  String fixedPath = await fastConvertToSRGB(imageFile.path);
    //  callback.onSuccessFile(fixedPath, "image");
    } else {
      print('No image selected.');
    }
  }

  Future<bool> isCameraEnabled() async {
    return true;
    // var status = await Permission.camera.request();
    // print("status: " + status.toString());
    // if (status == PermissionStatus.permanentlyDenied) {
    //   Utils.showSnackBar(
    //       "Camera permission permanently denied, we are redirecting to you setting screen to enable permission");
    //   Future.delayed(const Duration(seconds: 4), () {
    //     openAppSettings();
    //   });
    //   return false;
    // } else if (status == PermissionStatus.granted) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<bool> isStorageEnabled() async {
    return true;
    // var status;
    // if (Platform.isAndroid) {
    //   status = await Permission.storage.request();
    // } else {
    //   status = await Permission.photos.request();
    // }
    // print("status: " + status.toString());
    // if (Platform.isAndroid) {
    //   if (status == PermissionStatus.permanentlyDenied) {
    //     Utils.showSnackBar(
    //         "Storage permission permanently denied, we are redirecting to you setting screen to enable permission");
    //     Future.delayed(const Duration(seconds: 4), () {
    //       openAppSettings();
    //     });
    //     return false;
    //   } else if (status == PermissionStatus.granted)
    //     return true;
    //   else
    //     return false;
    // } else {
    //   if (status == PermissionStatus.permanentlyDenied) {
    //     Utils.showSnackBar(
    //         "Photos permission permanently denied, we are redirecting to you setting screen to enable permission");
    //     Future.delayed(const Duration(seconds: 4), () {
    //       openAppSettings();
    //     });
    //     return false;
    //   } else if (status == PermissionStatus.granted ||
    //       status == PermissionStatus.limited)
    //     return true;
    //   else
    //     return false;
    // }
  }
}
