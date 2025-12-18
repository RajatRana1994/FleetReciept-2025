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
import 'package:country_picker/country_picker.dart';
import 'package:ladenlaunch/viewmodel/auth_controller.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.setUpEditProfile();
    controller.detectSimCountry();
     // 👈 call your API here
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: 'edit_profile'.tr,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🧍 Profile Image Upload
            Center(
              child: Obx(() {
                final localImage = controller.imagePath.value;
                final serverImage = controller.serverProfileUrl.value;

                ImageProvider? imageProvider;

                if (localImage.isNotEmpty) {
                  imageProvider = FileImage(File(localImage));
                } else if (serverImage.isNotEmpty) {
                  imageProvider = NetworkImage(serverImage);
                }

                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: controller.openCamera,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),


            const SizedBox(height: 30),

            // 👤 Name
            AppTexts(
              textValue: 'label_name'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'enter_name'.tr,
              borderRadius: 20,
              borderWidth: 1,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              controller: controller.nameEditProfile,
            ),
            const SizedBox(height: 15),

            // 📱 Phone Number with Country Code
            AppTexts(
              textValue: 'phone_number'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        setState(() {
                          controller.countryCodeEditProfile.value = "${country.countryCode}";
                          controller.phoneCodeEditProfile.value = "${country.phoneCode}";
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      controller.phoneCodeEditProfile.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    hintText: 'enter_phone_number'.tr,
                    keyboardType: TextInputType.phone,
                    borderRadius: 20,
                    borderWidth: 1,
                    borderColor: Colors.grey.shade400,
                    focusedBorderColor: Colors.grey.shade400,
                    backgroundColor: Colors.grey.shade100,
                    controller: controller.phoneEditProfile,

                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 📧 Email
            AppTexts(
              textValue: 'label_email'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'enter_email'.tr,
              borderRadius: 20,
              borderWidth: 1,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              isReadOnly: true,
              controller: controller.emailEditProfile,
            ),
            const SizedBox(height: 25),

            // 🔘 Update Profile Button
            CustomButton(
              title: 'update_profile'.tr,
              onTap: () {
                controller.validateEditProfile();
              },
            ),
          ],
        ),
      ),
    );
  }


}
