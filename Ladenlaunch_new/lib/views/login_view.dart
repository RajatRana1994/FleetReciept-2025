import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/generated/assets.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'dart:io';
import 'package:ladenlaunch/viewmodel/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar:  CustomAppBar(title: 'login'.tr, showBackButton: false, backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        child: Padding(
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
                controller: controller.emailLogin,
              ),
              const SizedBox(height: 10),

              AppTexts(
                textValue: 'password'.tr,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'enter_password'.tr,
                borderRadius: 20,
                borderWidth: 1,
                obscureText: true,
                borderColor: Colors.grey.shade400,
                focusedBorderColor: Colors.grey.shade400,
                backgroundColor: Colors.grey.shade100,
                controller: controller.passwordLogin,
              ),
              const SizedBox(height: 10),

              // Forget password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgetPasswordScreen);
                  },
                  child:  Text(
                    'forgot_password_question'.tr,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(
                title: 'login'.tr,
                onTap: () {
                  controller.validateLogin();
                },
              ),

              const SizedBox(height: 30),


// Social Login Text
              Center(
                child: Text(
                  "or_continue_with".tr,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),

// Social Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google
                  GestureDetector(
                    onTap: () {
                     controller.loginWithGoogle();
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        Assets.icGoogle,
                        height: 28,
                      ),
                    ),
                  ),

                  // Facebook
                  // GestureDetector(
                  //   onTap: () {
                  //     controller.loginWithFacebook();
                  //   },
                  //   child: CircleAvatar(
                  //     radius: 25,
                  //     backgroundColor: Colors.white,
                  //     child: Image.asset(
                  //       Assets.icFacebook,
                  //       height: 30,
                  //     ),
                  //   ),
                  // ),

                  // Apple (Show only on iOS)
                  if (Platform.isIOS)
                    GestureDetector(
                      onTap: () {
                        controller.loginWithApple();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.apple,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 30),


              // Signup option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("dont_have_account".tr),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.signupScreen);
                      // TODO: Navigate to Signup screen
                    },
                    child:  Text(
                      'sign_up'.tr,
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
      ),
    );
  }
}
