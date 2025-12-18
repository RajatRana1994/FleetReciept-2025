import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ladenlaunch/viewmodel/auth_controller.dart';


class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.setUpCamera(); // 👈 call your API here
    controller.detectSimCountry();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: 'sign_up'.tr,
        showBackButton: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🧍 Profile Image Upload
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: controller.imagePath.value != null
                          ? FileImage(File(controller.imagePath.value!))
                          : null,
                      child: controller.imagePath.value == ""
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            )
                          : null,
                    );
                  }),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        controller.openCamera();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              controller: controller.nameSignup,
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
                // Country code button
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        setState(() {
                          controller.countryCode.value =
                              "${country.countryCode}";
                          controller.phoneCode.value = "${country.phoneCode}";
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Obx(() {
                      return Text(
                        controller.phoneCode.value,
                        style: const TextStyle(fontSize: 16),
                      );
                    }),
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
                    controller: controller.phoneSignup,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

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
              controller: controller.emailSignup,
            ),
            const SizedBox(height: 15),

            // 🔒 Password
            AppTexts(
              textValue: 'password'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'enter_password'.tr,
              obscureText: true,
              borderRadius: 20,
              borderWidth: 1,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              controller: controller.passwordSignup,
            ),
            const SizedBox(height: 25),

            // 🔘 Signup Button
            CustomButton(
              title: 'sign_up'.tr,
              onTap: () {
                controller.validateSignup();
              },
            ),
            const SizedBox(height: 30),

            // 🔁 Login option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("already_have_account".tr),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child:  Text(
                    'login'.tr,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
