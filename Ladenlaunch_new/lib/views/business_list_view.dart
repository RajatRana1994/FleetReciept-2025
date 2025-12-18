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

class BusinessListView extends StatefulWidget {
  const BusinessListView({super.key});

  @override
  State<BusinessListView> createState() => _BusinessListViewState();
}

class _BusinessListViewState extends State<BusinessListView> {
  final BusinessController controller = Get.find<BusinessController>();

  @override
  void initState() {
    super.initState();
    controller.busineesListApi(); // 👈 call your API here
  }

  void _confirmDeleteDialog(BuildContext context, int index) {
    Get.defaultDialog(
      title: 'delete_business'.tr,
      middleText: 'confirm_delete_business'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'delete'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteBusinessCall(
          businessId: controller.businessArray[index].id.toString(),
          index: index,
        );
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: 'business_list'.tr,
        showBackButton: false,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                var list = controller.businessArray;
                if (list.isEmpty) {
                  return  Center(child: Text('no_businesses_found'.tr));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.business, size: 30),
                        title: Text(
                          item.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('📧 ${item.email ?? ''}'),
                            Text('📞 ${item.phone ?? ''}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            _confirmDeleteDialog(context, index);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            CustomButton(
              title: 'add_new_business'.tr,
              onTap: () {
                Get.toNamed(AppRoutes.addBusinessScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
