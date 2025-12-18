import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ladenlaunch/routes/app_routes.dart';

import '../generated/assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final Color textColor;
  final bool? backTap;
  final VoidCallback? callback;
  final List<Widget>? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.action,
    this.callback,
    this.backTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
        icon: Image.asset(Assets.backIcon, height: 30, width: 30),
        onPressed: () {
          if (backTap ?? false) {
            // Go to a specific root screen
            Get.offAllNamed(AppRoutes.loginScreen); // ✅ replace with your root
          } else if (callback != null) {
            callback!();
          } else {
            Get.back();
          }
        },
      )
          : null,
      title: Text(
        title,
        style:  TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            fontSize: 20,
            color: textColor
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}