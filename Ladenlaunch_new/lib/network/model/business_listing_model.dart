class BusinessListingModel {
  final bool success;
  final int code;
  final String message;
  final List<BusinessItem> body;

  BusinessListingModel({
    required this.success,
    required this.code,
    required this.message,
    required this.body,
  });

  factory BusinessListingModel.fromJson(Map<String, dynamic> json) {

    List<BusinessItem> parsedBody = [];

    if (json['body'] is List) {
      parsedBody = (json['body'] as List)
          .map((item) => BusinessItem.fromJson(item))
          .toList();
    }

    return BusinessListingModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      body: parsedBody,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'body': body.map((item) => item.toJson()).toList(),
    };
  }
}

class BusinessItem {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final int created;
  final String createdAt;

  BusinessItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.created,
    required this.createdAt,
  });

  factory BusinessItem.fromJson(Map<String, dynamic> json) {
    return BusinessItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      created: json['created'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'created': created,
      'createdAt': createdAt,
    };
  }
}
