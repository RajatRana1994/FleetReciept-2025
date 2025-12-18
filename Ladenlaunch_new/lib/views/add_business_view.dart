import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/viewmodel/business_controller.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBusinessView extends StatefulWidget {
  const AddBusinessView({super.key});

  @override
  State<AddBusinessView> createState() => _AddBusinessViewState();
}

class _AddBusinessViewState extends State<AddBusinessView> {
  final BusinessController controller = Get.find<BusinessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar:  CustomAppBar(title: 'add_business'.tr, backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            CustomTextField(
              hintText: 'label_name'.tr,
              controller: controller.nameAddBusiness,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
            ),

            const SizedBox(height: 20),

            // Email field
            CustomTextField(
              hintText: 'label_email'.tr,
              controller: controller.emailAddBusiness,
              keyboardType: TextInputType.emailAddress,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
            ),

            const SizedBox(height: 20),

            // Phone field
            CustomTextField(
              hintText: 'label_phone'.tr,
              controller: controller.phoneAddBusiness,
              keyboardType: TextInputType.phone,
              borderColor: Colors.grey.shade400,
              focusedBorderColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade100,
            ),

            const SizedBox(height: 30),

            CustomButton(title: 'add'.tr, onTap: () {
              controller.validateAddBusiness();
            },),

          ],
        ),
      ),
    );
  }
}

