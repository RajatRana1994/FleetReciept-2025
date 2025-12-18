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
import 'package:flutter_html/flutter_html.dart';

import 'package:ladenlaunch/viewmodel/auth_controller.dart';


class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  final AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.privacyApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: "privacy_policy".tr,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.privacyContent.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Html(
            data: controller.privacyContent.value,
            style: {
              "body": Style(
                fontSize: FontSize(10),
                color: Colors.black87,
                lineHeight: LineHeight(1.5),
              ),
              "h1": Style(
                fontSize: FontSize(12),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            },
          ),
        );
      }),
    );
  }
}

