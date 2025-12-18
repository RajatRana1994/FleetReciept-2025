import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/routes/app_routes.dart';

import 'package:ladenlaunch/viewmodel/auth_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: 'forgot_password'.tr,
        showBackButton: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              controller: controller.emailForgetPassword,
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),

            CustomButton(title: 'submit'.tr, onTap: () {
              controller.validateForgetPassword();
            },),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
