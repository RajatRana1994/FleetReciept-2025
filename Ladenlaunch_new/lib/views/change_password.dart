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
import 'package:ladenlaunch/viewmodel/auth_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthController controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: CustomAppBar(title: 'change_password'.tr, backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'old_password'.tr,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              controller: controller.oldPassword,
              obscureText: true,
              isFromPassword: true,
            ),

            const SizedBox(height: 20),

            // Email field
            CustomTextField(
              hintText: 'new_password'.tr,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              controller: controller.newPassword,
              obscureText: true,
              isFromPassword: true,
            ),

            const SizedBox(height: 20),

            // Phone field
            CustomTextField(
              hintText: 'confirm_password'.tr,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
              controller: controller.confirmPassword,
              isFromPassword: true,
              obscureText: true,
            ),

            const SizedBox(height: 30),

            CustomButton(title: 'submit'.tr, onTap: () {
              controller.validateChangePassword();
            },),
          ],
        ),
      ),
    );
  }
}
