import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Commontoast {
  Commontoast._();
  static void showToast(String message,
      {bool isError = true, String title = 'Error', int durationTime = 2}) {
    Get.snackbar(
      isError == true ? title : 'Success',
      duration: Duration(seconds: durationTime),
      message,
      colorText: Colors.white,
      backgroundColor: isError ? Colors.red : Colors.green,
    );
  }
}
