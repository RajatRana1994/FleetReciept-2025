import 'package:ladenlaunch/network/user_preference.dart';

class UserModel {
  final bool success;
  final int code;
  final String message;
  final UserModelBody body;

  UserModel({
    required this.success,
    required this.code,
    required this.message,
    required this.body,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      body: UserModelBody.fromJson(json['body'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'code': code,
    'message': message,
    'body': body.toJson(),
  };
}

class UserModelBody {
  final int id;
  final int role;
  final int approvalStatus;
  final int status;
  final int languageType;
  final String email;
  final String password;
  final String countryFlag;
  final String countryCode;
  final String phone;
  final String countryCodePhone;
  final String forgotPasswordHash;
  final String emailVerificationHash;
  final String deleteAccountHash;
  final int hashExpiry;
  final int otp;
  final String deviceToken;
  final int deviceType;
  final int iat;
  final int created;
  final int updated;
  final String createdAt;
  final String updatedAt;
  final int detailId;
  final int adminId;
  final String name;
  final String latitude;
  final String longitude;
  final String location;
  final int userId;
  final String image;
  final String adminName;
  final String adminEmail;
  final String? token;

  UserModelBody({
    required this.id,
    required this.role,
    required this.approvalStatus,
    required this.status,
    required this.languageType,
    required this.email,
    required this.password,
    required this.countryFlag,
    required this.countryCode,
    required this.phone,
    required this.countryCodePhone,
    required this.forgotPasswordHash,
    required this.emailVerificationHash,
    required this.deleteAccountHash,
    required this.hashExpiry,
    required this.otp,
    required this.deviceToken,
    required this.deviceType,
    required this.iat,
    required this.created,
    required this.updated,
    required this.createdAt,
    required this.updatedAt,
    required this.detailId,
    required this.adminId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.userId,
    required this.image,
    required this.adminName,
    required this.adminEmail,
    this.token,
  });

  factory UserModelBody.fromJson(Map<String, dynamic> json) {
    return UserModelBody(
      id: json['id'] ?? 0,
      role: json['role'] ?? 0,
      approvalStatus: json['approvalStatus'] ?? 0,
      status: json['status'] ?? 0,
      languageType: json['languageType'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      countryFlag: json['countryFlag'] ?? '',
      countryCode: json['countryCode'] ?? '',
      phone: json['phone'] ?? '',
      countryCodePhone: json['countryCodePhone'] ?? '',
      forgotPasswordHash: json['forgotPasswordHash'] ?? '',
      emailVerificationHash: json['emailVerificationHash'] ?? '',
      deleteAccountHash: json['deleteAccountHash'] ?? '',
      hashExpiry: json['hashExpiry'] ?? 0,
      otp: json['otp'] ?? 0,
      deviceToken: json['deviceToken'] ?? '',
      deviceType: json['deviceType'] ?? 0,
      iat: json['iat'] ?? 0,
      created: json['created'] ?? 0,
      updated: json['updated'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      detailId: json['detailId'] ?? 0,
      adminId: json['adminId'] ?? 0,
      name: json['name'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      location: json['location'] ?? '',
      userId: json['userId'] ?? 0,
      image: json['image'] ?? '',
      adminName: json['adminName'] ?? '',
      adminEmail: json['adminEmail'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'approvalStatus': approvalStatus,
    'status': status,
    'languageType': languageType,
    'email': email,
    'password': password,
    'countryFlag': countryFlag,
    'countryCode': countryCode,
    'phone': phone,
    'countryCodePhone': countryCodePhone,
    'forgotPasswordHash': forgotPasswordHash,
    'emailVerificationHash': emailVerificationHash,
    'deleteAccountHash': deleteAccountHash,
    'hashExpiry': hashExpiry,
    'otp': otp,
    'deviceToken': deviceToken,
    'deviceType': deviceType,
    'iat': iat,
    'created': created,
    'updated': updated,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'detailId': detailId,
    'adminId': adminId,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'location': location,
    'userId': userId,
    'image': image,
    'adminName': adminName,
    'adminEmail': adminEmail,
    if (token != null) 'token': token,
  };
}


class CommonModel {
  String? message;
  int? code;

  CommonModel({this.message, this.code});

  factory CommonModel.fromJson(Map<String, dynamic> json) =>
      CommonModel(message: json["message"], code: json["code"]);
}



class PageModel {
  String? message;
  int? code;
  PageModelBody? body;

  PageModel({this.message, this.code, this.body});

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      code: json["code"],
      message: json["message"],
      body: json["body"] != null ? PageModelBody.fromJson(json["body"]) : null,
    );
  }
}

class PageModelBody {
  int? id;
  String? title;
  String? content;

  PageModelBody({
    this.id,
    this.title,
    this.content,
  });

  factory PageModelBody.fromJson(Map<String, dynamic> json) => PageModelBody(
    id: json["id"],
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
  };
}
