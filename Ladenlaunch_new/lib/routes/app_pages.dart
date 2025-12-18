import 'package:get/get.dart';
import 'package:ladenlaunch/routes/app_routes.dart';

import 'package:ladenlaunch/views/add_business_view.dart';
import 'package:ladenlaunch/views/business_list_view.dart';
import 'package:ladenlaunch/views/change_password.dart';
import 'package:ladenlaunch/views/forgot_password_view.dart';
import 'package:ladenlaunch/views/home_view.dart';
import 'package:ladenlaunch/views/login_view.dart';
import 'package:ladenlaunch/views/privacy.dart';
import 'package:ladenlaunch/views/profile_view.dart';
import 'package:ladenlaunch/views/signup_view.dart';
import 'package:ladenlaunch/views/subscription_view.dart';
import 'package:ladenlaunch/views/update_profile.dart';
import 'package:ladenlaunch/views/tabbar_view.dart';
import 'package:ladenlaunch/views/support_view.dart';
import 'package:ladenlaunch/views/changeLanguage_voew.dart';
import 'package:ladenlaunch/binding/add_binding.dart';

import 'package:ladenlaunch/viewmodel/auth_controller.dart';
import 'package:ladenlaunch/viewmodel/business_controller.dart';




class AppPages {
  static String initialRoute = AppRoutes.loginScreen;
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginView(),
        binding: AuthBinding()
    ),


    GetPage(
        name: AppRoutes.signupScreen,
        page: () => const SignupView(),
        binding: AuthBinding()
    ),

    GetPage(
        name: AppRoutes.privacyScreen,
        page: () => const Privacy(),
        binding: AuthBinding()
    ),

    GetPage(
        name: AppRoutes.forgetPasswordScreen,
        page: () => const ForgotPasswordView(),
        binding: AuthBinding()
    ),

    GetPage(
        name: AppRoutes.supportScreen,
        page: () => const SupportView(),
    ),

    GetPage(
        name: AppRoutes.homeScreen,
        page: () => const HomeView(),
        binding: BusinessBinding()
    ),

    GetPage(
      name: AppRoutes.businessListScreen,
      page: () => const BusinessListView(),
        binding: BusinessBinding()
    ),

    GetPage(
      name: AppRoutes.addBusinessScreen,
      page: () => const AddBusinessView(),
      binding: BusinessBinding()
    ),

    GetPage(
      name: AppRoutes.profileScreen,
      page: () => const ProfileView(),
        binding: AuthBinding()
    ),

    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => const UpdateProfile(),
        binding: AuthBinding()
    ),

    GetPage(
      name: AppRoutes.pageScreen,
      page: () => const Privacy(),
        binding: AuthBinding()
    ),

    GetPage(
        name: AppRoutes.changeLanguageScreen,
        page: () => const ChangeLanguageView(),
    ),

    GetPage(
      name: AppRoutes.subscriptionScreen,
      page: () => const SubscriptionView(),
    ),

    GetPage(
      name: AppRoutes.changePasswordScreen,
      page: () => const ChangePassword(),
        binding: AuthBinding()
    ),

    GetPage(
      name: AppRoutes.tabBarScreen,
      page: () => const Maintabbar(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
        Get.lazyPut<BusinessController>(() => BusinessController(), fenix: true);
      }),
    ),


  ];
}