import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ladenlaunch/viewmodel/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController controller = Get.find<AuthController>();



  @override
  void initState() {
    super.initState();
    controller.setUpProfile(); // 👈 call your API here
  }
  void updateProfile() {
    Get.toNamed(AppRoutes.editProfileScreen);
    // TODO: Navigate to Update Profile screen
  }

  void changePassword() {
    Get.toNamed(AppRoutes.changePasswordScreen);
    // TODO: Navigate to Change Password screen
  }

  void viewSubscription() {
    Get.toNamed(AppRoutes.subscriptionScreen);
    // TODO: Navigate to Subscription screen
  }

  void changeLanguage() {
    Get.toNamed(AppRoutes.changeLanguageScreen);
  }

  void viewPrivacy() async {
    const url = "https://www.termsfeed.com/live/681008b1-ea12-4e60-8b5f-a79b21bd9a63";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  void logout() {
    Get.defaultDialog(
      title: 'logout'.tr,
      middleText: 'confirm_logout'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'logout'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.logoutApiCall();

      },
      onCancel: () {
        // Just close the dialog
        Get.back();
      },
    );
  }

  void deleteAccount() {
    Get.defaultDialog(
      title: 'delete_account'.tr,
      middleText: 'confirm_delete_account'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'delete_account'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteAccountApi();

      },
      onCancel: () {
        // Just close the dialog
        Get.back();
      },
    );
  }

  Widget buildButton(String title, VoidCallback onTap, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CustomButton(
        title: title,
        onTap: onTap,
        btnColor: Colors.white,
        btnTextColor: Colors.black,
        borderWidth: 1,
        borderColor: Colors.grey.shade300,
        leading: icon != null
            ? Icon(icon, color: Colors.black)
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        horizontalPadding: 16,
        height: 56,
        radius: 15,
        isLeftAlign: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar:  CustomAppBar(title: 'profile'.tr, showBackButton: false, backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 User Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(
                        controller.profileImageUrl.value.isNotEmpty
                            ? controller.profileImageUrl.value
                            : 'https://via.placeholder.com/150', // fallback image
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Username
              Text(
                controller.nameProfile.value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Email
              Text(
                controller.emailProfile.value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Buttons
              buildButton('update_profile'.tr, updateProfile, icon: Icons.edit),
              buildButton('change_password'.tr, changePassword, icon: Icons.lock),
              buildButton('view_subscription'.tr, viewSubscription, icon: Icons.subscriptions),

              buildButton(
                'change_language'.tr,
                changeLanguage,
                icon: Icons.language,
              ),
              buildButton('support'.tr, () {
                Get.toNamed(AppRoutes.supportScreen);
              }, icon: Icons.support_agent),
              buildButton('privacy_policy'.tr, viewPrivacy, icon: Icons.privacy_tip),
              buildButton('delete_account'.tr, deleteAccount, icon: Icons.delete),
              buildButton('logout'.tr, logout, icon: Icons.logout),


            ],
          );
        }),
      ),
    );
  }

}
