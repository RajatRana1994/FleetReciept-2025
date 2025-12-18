import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  // ------------------ LAUNCH HELPERS ------------------
  Future<void> _openEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(uri);
  }

  Future<void> _openPhone(String phone) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(uri);
  }

  Future<void> _openURL(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ------------------ SUPPORT BOX WIDGET ------------------
  Widget supportBox({
    required IconData icon,
    required String method,
    required String detail,
    required String bestFor,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: Colors.blue),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    detail,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Best for: $bestFor",
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Avg Response: $time",
                    style: TextStyle(fontSize: 12, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ MAIN UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text("contact_support".tr),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text
            Text(
              "support_24_7".tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "support_description".tr,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            SizedBox(height: 25),

            // ------------------ EMAIL BOX ------------------
            supportBox(
              icon: Icons.email_outlined,
              method: "Email",
              detail: "Help@FleetReceipt.com",
              bestFor: "support_detailed_questions".tr,
              time: "support_email_response".tr,
              onTap: () => _openEmail("Help@FleetReceipt.com"),
            ),

            SizedBox(height: 20),

            // ------------------ PHONE / TEXT ------------------
            supportBox(
              icon: Icons.phone_in_talk_outlined,
              method: "support_phone_text".tr,
              detail: "(330) 826-1581",
              bestFor: "support_urgent_issues".tr,
              time: "support_phone_response".tr,
              onTap: () => _openPhone("3308261581"),
            ),

            SizedBox(height: 20),

            // ------------------ IN-APP CHAT ------------------
            supportBox(
              icon: Icons.chat_bubble_outline,
              method: "support_in_app_chat".tr,
              detail: "support_chat_hint".tr,
              bestFor: "support_while_using_app".tr,
              time: "support_chat_response".tr,
              onTap: () {}, // If you open chat screen, put navigation here
            ),

            SizedBox(height: 30),

            // ------------------ SUPPORT HOURS ------------------
            Text(
              "support_hours".tr,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "support_hours_phone".tr,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "support_hours_email".tr,
              style: TextStyle(fontSize: 14),
            ),

            SizedBox(height: 30),

            // ------------------ APP LINKS ------------------
            Text(
              "download_update_app".tr,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            GestureDetector(
              onTap: () => _openURL("https://apps.apple.com/us/app/fleetreceipt/id6755109333"),
              child: Text(
                "App Store (iOS)",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            SizedBox(height: 6),

            GestureDetector(
              onTap: () {}, // add Play Store link later
              child: Text(
                "Google Play (Android)",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}



