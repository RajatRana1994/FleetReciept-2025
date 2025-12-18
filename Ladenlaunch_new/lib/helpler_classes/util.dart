import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:intl/intl.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';

class Picker {
  Picker._(); // Private constructor to prevent instantiation
  static Future<String> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appColor,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.white,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.black,
                ),
                overlayColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.black,
                ),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final formattedTime = DateFormat('hh:mm a').format(dateTime);
      return formattedTime;
    }
    return "";
  }

  static Future<Map<String, dynamic>> selectDate({String? dateFormat}) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              onPrimary: Colors.white,
              primary: AppColors.appColor,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
      context: Get.context!,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3501),
    );
    if (pickedDate != null) {
      Map<String, dynamic> map = {
        "field": DateFormat(
          dateFormat ?? 'yyyy-MM-dd',
        ).format(pickedDate).toString(),
        "backend": DateFormat('yyyy-MM-dd').format(pickedDate).toString(),
      };
      return map;
    }
    return {};
  }

  static void showLoading() {
    Get.context?.loaderOverlay.show();
  }

  /// Hide Loading
  static void hideLoading() {
    Get.context?.loaderOverlay.hide();
  }
  //

  static String timeAgo(String isoString) {
    final date = DateTime.parse(isoString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return 'Just Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return difference.inDays == 1
          ? '1 day ago'
          : '${difference.inDays} days ago';
    } else {
      return DateFormat('MMMM d').format(date); // Like "April 10"
    }
  }

//
}