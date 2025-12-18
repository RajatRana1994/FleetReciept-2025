import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ladenlaunch/helpler_classes/common_toast.dart';
import 'dart:async';
import 'package:ladenlaunch/network/model/user_model.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:ladenlaunch/network/user_preference.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ladenlaunch/network/apiClass/api_call.dart';
import 'package:ladenlaunch/helpler_classes/camera_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'dart:ui';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController
    implements CameraOnCompleteListener {
  final TextEditingController emailLogin = TextEditingController();
  final TextEditingController passwordLogin = TextEditingController();

  /// Validates login form fields and calls [loginApi] if valid.
  void validateLogin() {
    if (emailLogin.text.isEmpty) {
      Commontoast.showToast('error_enter_email'.tr);
    } else if (!GetUtils.isEmail(emailLogin.text)) {
      Commontoast.showToast('error_valid_email'.tr);
    } else if (passwordLogin.text.isEmpty) {
      Commontoast.showToast('error_enter_password'.tr);
    } else {
      loginApi();
    }
  }

  /// Handles the API login call and stores user info on success.
  void loginApi() async {
    try {
      var response = await ApiCalls.loginApi(
        email: emailLogin.text!,
        password: passwordLogin.text!,
      );

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(response);
          DbHelper.saveUserToken(response.body?.token ?? '');

          // Clear inputs after successful login
          emailLogin.text = '';
          passwordLogin.text = '';

          // Navigate to main app
          Get.offAllNamed(AppRoutes.tabBarScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  final TextEditingController emailForgetPassword = TextEditingController();

  /// Validates forget password form fields and calls [forgetPasswordApi] if valid.
  void validateForgetPassword() {
    if (emailForgetPassword.text.isEmpty) {
      Commontoast.showToast('error_enter_email'.tr);
    } else if (!GetUtils.isEmail(emailForgetPassword.text)) {
      Commontoast.showToast('error_valid_email'.tr);
    } else {
      forgetPasswordApi();
    }
  }

  /// Handles the API forget password call .
  void forgetPasswordApi() async {
    try {
      var response = await ApiCalls.forgetPasswordApi(
        email: emailForgetPassword.text!,
      );

      if (response != null) {
        if (response.code == 200) {
          // Clear inputs after successful login
          emailForgetPassword.text = '';

          Commontoast.showToast(response.message ?? '', isError: false);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  /// Validates change password form fields and calls [forgetPasswordApi] if valid.
  void validateChangePassword() {
    if (oldPassword.text.isEmpty) {
      Commontoast.showToast('error_enter_old_password'.tr);
    } else if (newPassword.text.isEmpty) {
      Commontoast.showToast('error_enter_new_password'.tr);
    } else if (confirmPassword.text.isEmpty) {
      Commontoast.showToast('error_enter_confirm_password'.tr);
    } else if (confirmPassword.text != newPassword.text) {
      Commontoast.showToast('error_password_mismatch'.tr);
    } else {
      changePasswordApi();
    }
  }

  /// Handles the API change password api
  void changePasswordApi() async {
    try {
      var response = await ApiCalls.changePasswordApi(
        oldPassword: oldPassword.text!,
        newPassword: newPassword.text!,
      );

      if (response != null) {
        if (response.code == 200) {
          // Clear inputs after successful change password
          oldPassword.text = '';
          newPassword.text = '';
          confirmPassword.text = '';

          Commontoast.showToast(response.message ?? '', isError: false);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  /// Handles the lpogut api
  void logoutApiCall() async {
    try {
      var response = await ApiCalls.logoutApi();

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  /// Handles the lpogut api
  void deleteAccountApi() async {
    try {
      var response = await ApiCalls.deleteApi();

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  /// Handles the page api
  var privacyContent = ''.obs;
  void privacyApi() async {
    privacyContent.value = '';
    try {
      var response = await ApiCalls.pageApi(type: '3');

      if (response != null) {
        if (response.code == 200) {
          privacyContent.value = response.body?.content ?? '';
        } else if (response.code == 401) {
          DbHelper.saveUser(null);
          DbHelper.saveUserToken('');
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  final TextEditingController nameSignup = TextEditingController();
  final TextEditingController countryCodeSignup = TextEditingController();
  final TextEditingController phoneSignup = TextEditingController();
  final TextEditingController emailSignup = TextEditingController();
  final TextEditingController passwordSignup = TextEditingController();
  var countryCode = "US".obs;
  var phoneCode = "1".obs;
  late CameraHelper cameraHelper;
  RxString imagePath = ''.obs;
  RxString documentPath = ''.obs;
  RxBool isProfileImage = true.obs;
  RxString image = "".obs;

  @override
  void onSuccessFile(String file, String fileType) {
    isProfileImage.value == true
        ? imagePath.value = file
        : documentPath.value = file;
  }

  void openCamera({bool profileImage = true}) {
    isProfileImage.value = profileImage;
    cameraHelper.setCropping(CropAspectRatio(ratioX: 1, ratioY: 1));
    cameraHelper.openImagePicker();
  }

  // void detectCountryFromLocale(BuildContext context) {
  //
  //   String? iso = Localizations.localeOf(context).countryCode;
  //
  //   if (iso != null && iso.isNotEmpty) {
  //     final country = Country.parse(iso);
  //     print(iso);
  //     countryCode.value = iso;
  //     phoneCode.value = "${country.phoneCode}";
  //   }
  // }
  Future<void> detectSimCountry() async {
    try {
      String? iso;

      String country = PlatformDispatcher.instance.locale.countryCode ?? "US";

      final countr1y = Country.parse(country);
      print(iso);
      countryCode.value = country;
      phoneCode.value = "${countr1y.phoneCode}";

      if (phoneCodeEditProfile.value == '') {
        countryCodeEditProfile.value = country;
        phoneCodeEditProfile.value = "${countr1y.phoneCode}";
      }

    } catch (e) {
      print("SIM country detection error: $e");
    }
  }

  // Future<void> detectCountryFromIP() async {
  //   try {
  //     final response = await http.get(Uri.parse('https://ipapi.co/json/'));
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       String iso = (data["country"] ?? "US").toUpperCase();   // IN, US, AE...
  //       String phone = "+${data["country_calling_code"]?.replaceAll("+", "") ?? "1"}";
  //
  //       countryCode.value = iso;   // Example: IN
  //       phoneCode.value = phone;   // Example: +91
  //
  //       print("Detected by IP → Country: $iso, Phone: $phone");
  //     } else {
  //       print("IP lookup failed: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("IP detection error: $e");
  //   }
  // }

  void setUpCamera() {
    cameraHelper = CameraHelper(this);
  }

  /// Validates login form fields and calls [loginApi] if valid.
  void validateSignup() {
    // if (imagePath.value.isEmpty) {
    //   Commontoast.showToast('Please enter profile image');
    // } else
    if (nameSignup.text.isEmpty) {
      Commontoast.showToast('error_enter_name'.tr);
    } else if (phoneSignup.text.isEmpty) {
      Commontoast.showToast('error_enter_phone_number'.tr);
    } else if (emailSignup.text.isEmpty) {
      Commontoast.showToast('error_enter_email_address'.tr);
    } else if (!GetUtils.isEmail(emailSignup.text)) {
      Commontoast.showToast('error_valid_email'.tr);
    } else if (passwordSignup.text.isEmpty) {
      Commontoast.showToast('error_enter_password'.tr);
    } else {
      signUpApi();
    }
  }

  /// Handles the API login call and stores user info on success.
  void signUpApi() async {
    try {
      var response = await ApiCalls.signupApi(
        name: nameSignup.text,
        email: emailSignup.text,
        password: passwordSignup.text,
        countryCode: phoneCode.value,
        phone: phoneSignup.text,
        countryFlag: countryCode.value,
        image: imagePath.value,
      );

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(response);
          DbHelper.saveUserToken(response.body?.token ?? '');

          // Clear inputs after successful login
          nameSignup.text = '';
          emailSignup.text = '';
          passwordSignup.text = '';
          imagePath.value = '';

          // Navigate to main app
          Get.offAllNamed(AppRoutes.tabBarScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  var nameProfile = "".obs;
  var emailProfile = "".obs;
  var profileImageUrl = "".obs;
  var userObject = Rxn<UserModelBody>();
  void setUpProfile() {
    final user = DbHelper.getUser();
    userObject.value = user;
    nameProfile.value = user?.name ?? '';
    emailProfile.value = user?.email ?? '';
    profileImageUrl.value = user?.image ?? '';
    print(profileImageUrl.value);
  }

  final TextEditingController nameEditProfile = TextEditingController();
  final TextEditingController phoneEditProfile = TextEditingController();
  final TextEditingController emailEditProfile = TextEditingController();
  var countryCodeEditProfile = "IN".obs;
  var phoneCodeEditProfile = "91".obs;
  RxString serverProfileUrl = ''.obs;

  void setUpEditProfile() {
    cameraHelper = CameraHelper(this);
    final user = DbHelper.getUser();
    imagePath.value = '';
    userObject.value = user;
    nameEditProfile.text = user?.name ?? '';
    phoneEditProfile.text = user?.phone ?? '';
    emailEditProfile.text = user?.email ?? '';
    phoneCodeEditProfile.value = user?.countryCode ?? '';
    serverProfileUrl.value = user?.image ?? '';
    countryCodeEditProfile.value = user?.countryFlag ?? '';
  }

  /// Validates login form fields and calls [loginApi] if valid.
  void validateEditProfile() {
    if (nameEditProfile.text.isEmpty) {
      Commontoast.showToast('error_enter_name'.tr);
    } else if (phoneEditProfile.text.isEmpty) {
      Commontoast.showToast('error_enter_phone_number'.tr);
    } else {
      editProfileApi();
    }
  }

  /// Handles the API login call and stores user info on success.
  void editProfileApi() async {
    try {
      var response = await ApiCalls.editProfileApi(
        name: nameEditProfile.text!,
        countryCode: phoneCodeEditProfile.value,
        phone: phoneEditProfile.text!,
        countryFlag: countryCodeEditProfile.value,
        image: imagePath.value,
      );

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(response);
          Commontoast.showToast(response.message ?? '', isError: false);
          setUpProfile();
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  Future<void> loginWithApple() async {
    try {
      // Step 1: Generate secure nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Step 2: Request credentials from Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Extract data
      final String? email = appleCredential.email;
      final String? firstName = appleCredential.givenName;
      final String? lastName = appleCredential.familyName;

      final String appleUserId = appleCredential.userIdentifier!;
      final String identityToken = appleCredential.identityToken!;
      final String authorizationCode = appleCredential.authorizationCode;

      // Step 3: Prepare body for backend
      final body = {
        "name": "${firstName ?? ''} ${lastName ?? ''}".trim(),
        "email": email ?? "",
        "apple_id": appleUserId,
        "token": identityToken,
        "auth_code": authorizationCode,
      };

      print("APPLE LOGIN DATA → $body");
      socialLoginApi(
        "${firstName ?? ''} ${lastName ?? ''}".trim(),
        email ?? "",
        appleUserId,
        "3",
      );
    } catch (e) {
      print("Apple Login Error → $e");
      Get.snackbar("Error", "Apple login failed");
    }
  }

  void socialLoginApi(
    String name,
    String email,
    String socialId,
    String SocialType,
  ) async {
    try {
      var response = await ApiCalls.socailLoginApi(
        socialId: socialId,
        socialType: SocialType,
        email: email,
        name: name,
      );

      if (response != null) {
        if (response.code == 200) {
          DbHelper.saveUser(response);
          DbHelper.saveUserToken(response.body.token ?? '');

          // Clear inputs after successful login
          nameSignup.text = '';
          emailSignup.text = '';
          passwordSignup.text = '';
          imagePath.value = '';

          // Navigate to main app
          Get.offAllNamed(AppRoutes.tabBarScreen);
        }
      }
    } catch (e) {
      print('object');
      Commontoast.showToast('$e');
    }
  }

  void loginWithFacebook() async {
    final Map<String, dynamic>? fbUserMap = await FacebookAuthService.loginAndGetSocialId();

    print('objectsss');

    if (fbUserMap == null) {
      // Assuming Commontoast is a utility function you have
      Commontoast.showToast("Facebook login failed or was cancelled.");
      return;
    }
    final String socialId = fbUserMap['id'];
    // Use null-aware operators ?? '' just in case name or email are missing
    final String name = fbUserMap['name'] ?? '';
    final String email = fbUserMap['email'] ?? '';

    socialLoginApi(name, email, socialId, '1');
  }


  void loginWithGoogle() async {
    // This now correctly receives a Map<String, dynamic>?
    final Map<String, dynamic>? googleMap = await GoogleAuthService.loginAndGetSocialId();

    print('objectsss');

    if (googleMap == null) {
      // Assuming Commontoast is a utility function you have
      Commontoast.showToast("Google login failed or was cancelled.");
      return;
    }

    // Extract data from the received map
    // Use null-aware operator (?? '') in case the name or email from Google is null/missing
    final String socialId = googleMap['id'] ?? '';
    final String name = googleMap['name'] ?? '';
    final String email = googleMap['email'] ?? '';

    print('ID: $socialId, Name: $name, Email: $email');

    // Call your API function (assuming '2' is the social type for Google,
    // you used '1' for Facebook previously)
    socialLoginApi(name, email, socialId, '2');
  }

  // Utility: Generate nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = List.generate(
      length,
      (i) =>
          charset[DateTime.now().microsecondsSinceEpoch.remainder(
            charset.length,
          )],
    );
    return random.join();
  }

  // Utility: SHA256 for nonce
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}



class FacebookAuthService {
  // Login and get Facebook user ID
  static Future<Map<String, dynamic>?> loginAndGetSocialId() async {
    try {
      // ... (Keep the existing login/accessToken logic from the previous correct example) ...
      AccessToken? accessToken = await FacebookAuth.instance.accessToken;

      if (accessToken == null) {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['public_profile', 'email'],
        );
        if (result.status == LoginStatus.success) {
          accessToken = result.accessToken;
        } else {
          return null;
        }
      }

      if (accessToken != null) {
        // Requesting all needed fields: id, name, email
        final userData = await FacebookAuth.instance.getUserData(
          fields: "id,name,email",
        );

        // Print statements for debugging (optional)
        print('Facebook Social ID: ${userData['id']}');
        print('Facebook User Name: ${userData['name']}');
        print('Facebook User Email: ${userData['email']}');

        // Return the entire map of user data
        return userData;
      }

      return null;

    } catch (e) {
      print("Facebook login or data retrieval error: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    await FacebookAuth.instance.logOut();
  }
}

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Change the return type from Future<String?> to Future<Map<String, dynamic>?>
  static Future<Map<String, dynamic>?> loginAndGetSocialId() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print('Google login cancelled');
        return null;
      }

      // Google unique user ID
      final String socialId = account.id;

      print('Google Social ID: $socialId');
      print('Name: ${account.displayName}');
      print('Email: ${account.email}');
      print('Photo: ${account.photoUrl}');

      // Return a Map containing all the data points you need
      return {
        'id': account.id,
        'name': account.displayName, // This can sometimes be null
        'email': account.email,
        'photoUrl': account.photoUrl,
      };

    } catch (e) {
      print('Google login error: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}
