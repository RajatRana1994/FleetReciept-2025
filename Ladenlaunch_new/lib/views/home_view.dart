import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ladenlaunch/viewmodel/business_controller.dart';
import 'package:ladenlaunch/network/user_preference.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BusinessController controller = Get.find<BusinessController>();

  @override
  void initState() {
    super.initState();
    controller.setUpCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.busineesListApi();
      if (controller.businessArray.isEmpty &&
          DbHelper.getUserToken() != "") {
        _showNoBusinessDialog();
      }
    });
  }

  void _showNoBusinessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:  Text('no_business_found'.tr),
        content:  Text('add_new_business'.tr),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.addBusinessScreen)?.then((_) {
                controller.busineesListApi();
              });
            },
            child:  Text('ok'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void showBusinessPicker() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    'select_business'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...controller.businessArray.map(
                        (b) => ListTile(
                      title: Text(b.name),
                      onTap: () {
                        setState(() {
                          controller.busineesTextField.text = b.name;
                          controller.businessId.value = b.id.toString();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: 'home'.tr,
        showBackButton: false,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            AppTexts(
              textValue: 'camera_max_photos'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // -------------------------
            // 📸 Main Image + Thumbnails
            // -------------------------
            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.openCamera(context),
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: controller.imagePath.value.isEmpty
                              ? const SizedBox() // Background empty when no image
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),

                        // 🔥 Camera Icon + Text — Always Visible
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: controller.imagePath.value.isEmpty
                                      ? Colors.grey
                                      : Colors.white, // visible over image
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'camera_tap_to_capture'.tr,
                                  style: TextStyle(
                                    color: controller.imagePath.value.isEmpty
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  const SizedBox(height: 12),

                  // ⭐ 3 Recent Captured Images
                  Obx(() {
                    if (controller.recentImages.isEmpty) return const SizedBox();
                    double screenWidth = MediaQuery.of(context).size.width - 60;

                    // 5 images → 4 gaps × 10px padding
                    double totalPadding = (4 * 10);
                    double imageSize = (screenWidth - totalPadding) / 5;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < controller.recentImages.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.imagePath.value = controller.recentImages[i];
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(controller.recentImages[i]),
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // ❌ Delete Icon
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.recentImages.removeAt(i); // remove image
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  })


                ],
              );
            }),

            const SizedBox(height: 25),

            AppTexts(
              textValue: 'select_business'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: showBusinessPicker,
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: 'business'.tr,
                  controller: controller.busineesTextField,
                  isReadOnly: true,
                  suffix: const Icon(Icons.arrow_drop_down),
                  borderColor: Colors.grey.shade400,
                  focusedBorderColor: Colors.blue,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ),

            const SizedBox(height: 25),

            AppTexts(
              textValue: 'description'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              hintText: 'enter_description_hint'.tr,
              borderRadius: 20,
              borderColor: Colors.grey.shade400,
              borderWidth: 1,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              maxLine: 5,
              controller: controller.descriptionTextField,
            ),

            const SizedBox(height: 30),

            CustomButton(
              title: 'send'.tr,
              onTap: () {
                controller.validateMailApi();
              },
            ),
          ],
        ),
      ),
    );
  }
}

