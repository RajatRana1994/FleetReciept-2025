
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/constant/constants.dart';
import 'package:ladenlaunch/helpler_classes/common_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ladenlaunch/helpler_classes/util.dart';
import 'dart:io';

//import 'package:permission_handler/permission_handler.dart';

//import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:ladenlaunch/network/model/business_listing_model.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:ladenlaunch/network/user_preference.dart';
import 'package:ladenlaunch/network/apiClass/api_call.dart';
import 'package:ladenlaunch/helpler_classes/camera_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:pdf/pdf.dart';


class BusinessController extends GetxController
    implements CameraOnCompleteListener {
  final TextEditingController nameAddBusiness = TextEditingController();
  final TextEditingController emailAddBusiness = TextEditingController();
  final TextEditingController phoneAddBusiness = TextEditingController();

  /// Validates add business form fields and calls [commonModel] if valid.
  void validateAddBusiness() {
    if (nameAddBusiness.text.isEmpty) {
      Commontoast.showToast('error_enter_name'.tr);
    } else if (emailAddBusiness.text.isEmpty) {
      Commontoast.showToast('error_enter_email'.tr);
    } else if (!GetUtils.isEmail(emailAddBusiness.text)) {
      Commontoast.showToast('error_valid_email'.tr);
    } else if (phoneAddBusiness.text.isEmpty) {
      Commontoast.showToast('error_enter_phone_number'.tr);
    } else {
      addBusinessApi();
    }
  }

  /// Handles the API add business call
  void addBusinessApi() async {
    try {
      var response = await ApiCalls.addBusinessApi(
        name: nameAddBusiness.text!,
        email: emailAddBusiness.text!,
        phone: phoneAddBusiness.text!,
      );

      if (response != null) {
        if (response.code == 200) {
          // Clear inputs after successful add business
          nameAddBusiness.text = '';
          emailAddBusiness.text = '';
          phoneAddBusiness.text = '';
          Get.back();
          busineesListApi();
          Commontoast.showToast(response.message ?? '', isError: false);
        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  /// Handles the API  business list call
  var businessArray = <BusinessItem>[].obs;
  Future<void> busineesListApi() async {
    try {
      var response = await ApiCalls.businessListApi();

      if (response != null) {
        print(DbHelper.getUserToken());
        if (response.code == 200) {
          businessArray.assignAll(response.body);


        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  /// Handles the API  delete business list call

  void deleteBusinessCall({
    required String businessId,
    required int index,
  }) async {
    try {
      var response = await ApiCalls.deleteBusinessApi(id: businessId);

      if (response != null) {
        if (response.code == 200) {
          businessArray.removeAt(index);
          Commontoast.showToast(
            'business_deleted_success'.tr,
            isError: false,
          );
        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  final TextEditingController descriptionTextField = TextEditingController();
  final TextEditingController busineesTextField = TextEditingController();
  var businessId = "".obs;
  late CameraHelper cameraHelper;
  RxString imagePath = ''.obs;
  RxString documentPath = ''.obs;
  RxBool isProfileImage = true.obs;
  RxString image = "".obs;

  @override
  void onSuccessFile(String file, String fileType) {

    recentImages.insert(0, file);
    if (recentImages.length > 5) {
      recentImages.removeLast();
    }

    isProfileImage.value == true
        ? imagePath.value = file
        : documentPath.value = file;
  }

  static const _channel = MethodChannel("srgb_converter");

  Future<String> convertSRGBNative(String path) async {
    final newPath = await _channel.invokeMethod("convertToSRGB", path);
    return newPath;
  }
  // void openCameraOld({bool profileImage = true}) async {
  //   isProfileImage.value = profileImage;
  //
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 85,
  //     preferredCameraDevice: CameraDevice.rear,
  //   );
  //
  //   if (image == null) return;
  //
  //   String path = image.path;
  //   File file = File(path);
  //
  //   // Ensure file exists
  //   if (!await file.exists()) {
  //     debugPrint("⚠️ File does not exist: $path");
  //     return;
  //   }
  //
  //   // Give 100–200ms so iOS fully writes HEIC
  //   await Future.delayed(const Duration(milliseconds: 200));
  //
  //   String finalPath = path;
  //   String platformNewPath = path;
  //   try {
  //     // Attempt NATIVE iOS conversion (super fast + removes tint)
  //     if (Platform.isIOS) {
  //       final platformNewPath = await convertSRGBNative(path);
  //     }
  //
  //
  //     if (platformNewPath.isNotEmpty && File(platformNewPath).existsSync()) {
  //       finalPath = platformNewPath;
  //       debugPrint("✅ Using native iOS sRGB: $finalPath");
  //     } else {
  //       // fallback to Dart re-encode if native fails
  //       debugPrint("⚠️ Native SRGB failed, using Dart re-encode");
  //       final bytes = await file.readAsBytes();
  //       final decoded = img.decodeImage(bytes);
  //       if (decoded != null) {
  //         await file.writeAsBytes(
  //           img.encodeJpg(decoded, quality: 90),
  //         );
  //         finalPath = file.path;
  //       }
  //     }
  //   } catch (e) {
  //     // if native throw error → fallback
  //     debugPrint("⚠️ SRGB conversion error: $e");
  //     final bytes = await file.readAsBytes();
  //     final decoded = img.decodeImage(bytes);
  //     if (decoded != null) {
  //       await file.writeAsBytes(
  //         img.encodeJpg(decoded, quality: 90),
  //       );
  //       finalPath = file.path;
  //     }
  //   }
  //
  //   // return final valid image
  //   onSuccessFile(finalPath, "image");
  // }



  RxList<String> recentImages = <String>[].obs;

  void openCamera(BuildContext context, {bool profileImage = true}) async {
    if (recentImages.length == 5) {
      Commontoast.showToast('error_max_images_allowed'.tr);
      return;
    }
    isProfileImage.value = profileImage;

    final controller = DocumentScannerController();

    try {
      // Open full screen scanner
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            body: DocumentScanner(
              controller: controller,

              onSave: (Uint8List imageBytes) async {
                try {
                  // Generate file path
                  final dir = await getTemporaryDirectory();
                  final path = "${dir.path}/scan_${DateTime.now().millisecondsSinceEpoch}.jpg";

                  // Write JPG file
                  final file = File(path);
                  await file.writeAsBytes(imageBytes);

                  String finalPath = path;

                  // Optional iOS sRGB correction
                  if (Platform.isIOS) {
                    try {
                      final converted = await convertSRGBNative(path);
                      if (converted.isNotEmpty && File(converted).existsSync()) {
                        finalPath = converted;
                      }
                    } catch (_) {}
                  }

                  // Fallback re-encode
                  if (!File(finalPath).existsSync()) {
                    final decoded = img.decodeImage(imageBytes);
                    if (decoded != null) {
                      await File(path).writeAsBytes(img.encodeJpg(decoded, quality: 90));
                      finalPath = path;
                    }
                  }

                  // Return final image path
                  onSuccessFile(finalPath, "image");

                } catch (e) {
                  debugPrint("Save failed: $e");
                }

                Navigator.pop(ctx);
              },
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Document scanner failed: $e");
    }
  }


  // void openCamera({bool profileImage = true}) async {
  //   isProfileImage.value = profileImage;
  //
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 85,
  //     preferredCameraDevice: CameraDevice.rear,
  //   );
  //
  //   if (image != null) {
  //     final File file = File(image.path);
  //
  //     // ✅ Ensure the file is fully written before reading it
  //     await Future.delayed(const Duration(milliseconds: 300));
  //
  //     if (await file.exists()) {
  //       try {
  //         final bytes = await file.readAsBytes();
  //         final decodedImage = img.decodeImage(bytes);
  //
  //         if (decodedImage != null &&
  //             decodedImage.width > 0 &&
  //             decodedImage.height > 0) {
  //           // ✅ Re-encode properly to fix green tint
  //           await file.writeAsBytes(
  //             img.encodeJpg(decodedImage, quality: 90),
  //           );
  //           onSuccessFile(file.path, 'image');
  //         } else {
  //           // fallback: directly use original file (no processing)
  //           onSuccessFile(file.path, 'image');
  //         }
  //       } catch (e) {
  //         // fallback if decoding fails
  //         debugPrint("⚠️ Image decode error: $e");
  //         onSuccessFile(file.path, 'image');
  //       }
  //     }
  //   }
  // }
  
  // void openCamera({bool profileImage = true}) {
  //   isProfileImage.value = profileImage;
  //   cameraHelper.setCropping(CropAspectRatio(ratioX: 1, ratioY: 1));
  //   cameraHelper.openImagePicker();
  // }

  void setUpCamera() {
    cameraHelper = CameraHelper(this);
  }


  Future<String?> convertImageToPdf(String imagePath) async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Image(image),
          ),
        ),
      );

      final outputDir = await getTemporaryDirectory();
      final outputFile = File('${outputDir.path}/converted_image.pdf');
      await outputFile.writeAsBytes(await pdf.save());
      print('✅ PDF created at: ${outputFile.path}');
      return outputFile.path;
    } catch (e) {
      print('❌ Error converting image to PDF: $e');
      Commontoast.showToast('Failed to convert image to PDF');
      return null;
    }
  }


  /// Validates add business form fields and calls [commonModel] if valid.
  bool isProcessing = false;



  Future<String> convertImagesToPdf(List<String> imagePaths) async {
    final pdf = pw.Document();

    for (String path in imagePaths) {
      try {
        // Read raw bytes
        final bytes = File(path).readAsBytesSync();

        // Decode (JPG/HEIC/PNG)
        final decoded = img.decodeImage(bytes);
        if (decoded == null) continue;

        // Convert to PNG (fixes blue tint)
        final pngBytes = img.encodePng(decoded);

        final image = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      } catch (e) {
        print("PDF image failed: $e");
      }
    }

    // Save PDF
    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/images_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());
    return file.path;
  }


  // Future<String> convertImagesToPdf(List<String> imagePaths) async {
  //   final pdf = pw.Document();
  //
  //   for (String path in imagePaths) {
  //     final image = pw.MemoryImage(File(path).readAsBytesSync());
  //
  //     pdf.addPage(
  //       pw.Page(
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context context) {
  //           return pw.Center(
  //             child: pw.Image(image, fit: pw.BoxFit.contain),
  //           );
  //         },
  //       ),
  //     );
  //   }
  //
  //   final outputDir = await getTemporaryDirectory();
  //   final file = File("${outputDir.path}/images_${DateTime.now().millisecondsSinceEpoch}.pdf");
  //
  //   await file.writeAsBytes(await pdf.save());
  //   return file.path;
  // }


  void validateMailApi() async {
    if (isProcessing) return; // 🚫 prevent multiple triggers
    isProcessing = true;

    try {
      if (recentImages.isEmpty) {
        Commontoast.showToast('error_upload_image'.tr);
      } else if (businessId.value.isEmpty) {
        Commontoast.showToast('error_select_business'.tr);
      } else if (descriptionTextField.text.isEmpty) {
        Commontoast.showToast('error_enter_description'.tr);
      } else {
        // 🌀 Show loader
        Picker.showLoading();
        // Get.dialog(
        //   const Center(child: CircularProgressIndicator()),
        //   barrierDismissible: false,
        // );

        final bool subscribed = await SubscriptionService().isSubscribed();



        if (subscribed) {
          // ✅ User has an active subscription
          try {
            String? pdfFilePath;


            if (recentImages.isNotEmpty) {
              pdfFilePath = await convertImagesToPdf(recentImages);
            }

            // if (imagePath.value.isNotEmpty) {
            //   pdfFilePath = await convertImageToPdf(imagePath.value);
            // }

            var response = await ApiCalls.sendMailToBusinessApi(
              businessId: businessId.value,
              description: descriptionTextField.text,
              pdfFile: pdfFilePath ?? '',
            );

            if (response != null) {
              if (response.code == 200) {
                imagePath.value = '';
                businessId.value = '';
                descriptionTextField.text = '';
                busineesTextField.text = '';
                recentImages.value = [];
                Commontoast.showToast(response.message ?? '', isError: false);
              } else if (response.code == 401) {
                DbHelper.saveUser(null);
                DbHelper.saveUserToken('');
                Get.offAllNamed(AppRoutes.loginScreen);
              }
            }
          } catch (e) {
            Commontoast.showToast('$e');
          }
        } else {
          Picker.hideLoading();
          // ❌ No active subscription — show popup now that loader is closed
          Get.defaultDialog(
            title: "",
            titlePadding: EdgeInsets.zero,
            barrierDismissible: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            radius: 20,

            content: Column(
              children: [
                // Icon(Icons.lock, size: 60, color: Colors.orangeAccent),
                //
                // const SizedBox(height: 15),

                Text(
                  "subscription_required".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  "subscription_required_message".tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          if (Get.currentRoute != AppRoutes.subscriptionScreen) {
                            Get.toNamed(AppRoutes.subscriptionScreen);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Buy Now".tr,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Text(
                          "cancel".tr,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

        }
      }
    } finally {
      isProcessing = false; // ✅ reset flag
    }
  }



}


class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final String _productId = 'com.live.monthly';

  Future<bool> isSubscribed() async {
    // 1️⃣ Check store availability
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint('Store not available');
      return false;
    }

    // 2️⃣ Query product details (optional)
    final ProductDetailsResponse productResponse =
    await _iap.queryProductDetails({_productId});
    if (productResponse.error != null) {
      debugPrint('Product query error: ${productResponse.error}');
      return false;
    }

    // 3️⃣ Listen to purchase stream before restoring
    final Completer<bool> completer = Completer<bool>();
    final Set<String> restoredIds = {};

    final StreamSubscription<List<PurchaseDetails>> subscription =
    _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if ((purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) &&
            purchase.productID == _productId) {
          restoredIds.add(purchase.productID);
          if (!completer.isCompleted) {
            completer.complete(true); // Found active subscription
          }
        }
      }
    });

    // 4️⃣ Call restore purchases
    await _iap.restorePurchases();

    // 5️⃣ Timeout fallback
    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.complete(false); // No subscription found
      }
      subscription.cancel();
    });

    return completer.future;
  }
}
