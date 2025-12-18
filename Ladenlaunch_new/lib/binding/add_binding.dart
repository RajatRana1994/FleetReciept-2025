import 'package:ladenlaunch/viewmodel/auth_controller.dart';
import 'package:ladenlaunch/viewmodel/business_controller.dart';

import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments ?? {};
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}


class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments ?? {};
    Get.lazyPut<BusinessController>(() => BusinessController(), fenix: true);
  }
}