import 'package:ladenlaunch/network/user_preference.dart';
import 'package:ladenlaunch/helpler_classes/common_toast.dart';
import '../web_Service.dart';
import 'package:ladenlaunch/constant/constants.dart';

import 'package:ladenlaunch/network/model/user_model.dart';
import 'package:ladenlaunch/network/model/business_listing_model.dart';

class ApiCalls {
  ApiCalls._();

  /// Logs in a user with [email] and [password].
  ///
  /// Returns a [UserModel] on success, or `null` on failure.
  static Future<UserModel?> loginApi({
    required String email,
    required String password,
  }) async {
    final body = {'email': email, 'password': password};

    print(body);
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.login,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = UserModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }


  /// Logs in a user with [email] and [password].
  ///
  /// Returns a [UserModel] on success, or `null` on failure.
  static Future<UserModel?> socailLoginApi({
    required String socialId,
    required String socialType,
    String? email,
    String? name,
  }) async {
    final Map<String, dynamic> body = {
      'socialId': socialId,
      'socialType': socialType,
    };

    // add only if not null & not empty
    if (email != null && email.trim().isNotEmpty) {
      body['email'] = email;
    }

    if (name != null && name.trim().isNotEmpty) {
      body['name'] = name;
    }

    print(body);
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.socialLogin,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = UserModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// Signup in a user with [email] and [password].
  ///
  /// Returns a [UserModel] on success, or `null` on failure.
  static Future<UserModel?> signupApi({
    required String name,
    required String email,
    required String password,
    required String countryCode,
    required String phone,
    required String countryFlag,
    String? image,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'countryCode': countryCode,
      'phone': phone,
      'countryFlag': countryFlag,
      if (image != null && image != '')
        'image': await ApiService.getMultipartImage(path: image),
    };

    print(body);
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.signUp,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = UserModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// User Logout Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> logoutApi() async {
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.logout,
      type: RequestType.put,
      body: null,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// User Delete Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> deleteApi() async {
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.deleteAccount,
      type: RequestType.delete,
      body: null,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// User Edit Profile Api.
  ///
  /// Returns a [UserModel] on success, or `null` on failure.
  static Future<UserModel?> editProfileApi({
    required String name,
    required String countryCode,
    required String phone,
    required String countryFlag,
    String? image,
  }) async {
    print('ssssss');
    print(image);



    final body = {
      'name': name,
      'countryCode': countryCode,
      'phone': phone,
      'countryFlag': countryFlag,
      if (image != null && image != '')

        'image': await ApiService.getMultipartImage(path: image),
    };

    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.editProfile,
      type: RequestType.put,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = UserModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// User Change Password Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> changePasswordApi({
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {'oldPassword': oldPassword, 'newPassword': newPassword};

    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.changePassword,
      type: RequestType.put,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// User Forget Password Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> forgetPasswordApi({required String email}) async {
    final body = {'email': email};

    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.forgotPassword,
      type: RequestType.put,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }



  /// Content Api.
  ///
  /// Returns a [PageModel] on success, or `null` on failure.
  static Future<PageModel?> pageApi({required String type}) async {
    var response = await ApiService.apiRequest(
      endPoint: type == '1'
          ? ApiConstants.aboutUs
          : type == '2'
          ? ApiConstants.termsAndConditions
          : ApiConstants.privacyPolicy,
      type: RequestType.get,
      body: null,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = PageModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// Business List Api.
  ///
  /// Returns a [BusinessListingModel] on success, or `null` on failure.
  static Future<BusinessListingModel?> businessListApi() async {
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.businessListing,
      type: RequestType.post,
      body: null,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = BusinessListingModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// Add Business Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> addBusinessApi({
    required String name,
    required String email,
    required String phone,
  }) async {
    final body = {'email': email, 'name': name, 'phone': phone};
    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.addBusiness,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// Delete Business Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> deleteBusinessApi({required String id}) async {
    final body = {'id': id};

    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.deleteMyBusiness,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }

  /// Send mail to Business Api.
  ///
  /// Returns a [CommonModel] on success, or `null` on failure.
  static Future<CommonModel?> sendMailToBusinessApi({
    required String businessId,
    required String description,
    required String pdfFile,
  }) async {
    final body = {
      'businessId': businessId,
      'description': description,
      if (pdfFile != null && pdfFile != '')
        'pdfFile': await ApiService.getMultipartImage(path: pdfFile),
    };

    var response = await ApiService.apiRequest(
      endPoint: ApiConstants.sendMailToBusiness,
      type: RequestType.post,
      body: body,
    );

    final statusCode = response.statusCode ?? 0;
    print('$statusCode');
    var apiData = CommonModel.fromJson(response.data);

    switch (statusCode) {
      case 200:
        return apiData;
      case 401:
        return apiData;
      default:
        print('apiData');
        Commontoast.showToast(apiData.message ?? 'An error occurred');
        return null;
    }
  }
}
