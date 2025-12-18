import 'package:ladenlaunch/network/user_preference.dart';
import 'package:ladenlaunch/constant/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:ladenlaunch/helpler_classes/util.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ladenlaunch/network/user_preference.dart';

class ApiService {
  ApiService._();
  //_dio
  static final Dio _dio = Dio();
  //_checkInternetConnection
  static Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  //getMultipartImage
  static Future<MultipartFile> getMultipartImage({required String path}) async {
    String fileName = path.split('/').last;
    String mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    return await MultipartFile.fromFile(path, filename: fileName);
  }

  //apiRequest
  static Future<ApiCustomResponse> apiRequest({
    required String endPoint,
    required RequestType type,
    Map<String, dynamic>? body,
    dynamic isUrlAppend,
  }) async {
    Picker.showLoading();

    try {
      bool isConnected = await _checkInternetConnection();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final headers = {
        'Accept': 'application/json',
        'securitykey': '__fleetreceipt_007__',
        'AUTHORIZATION': 'Bearer ${DbHelper.getUserToken() ?? ''}',
      };
      print(headers);
      var formData = FormData.fromMap(body ?? <String, dynamic>{});

      var url = '${ApiConstants.baseUrl}$endPoint';
      print(url);
      Response response;

      switch (type) {
        case RequestType.get:
          url = (isUrlAppend != null) ? '$url/$isUrlAppend' : url;
          url = (body != null)
              ? Uri.parse(url).replace(queryParameters: body).toString()
              : url;
          response = await _dio.get(url,
              options: Options(
                method: 'GET',
                headers: headers,
                sendTimeout: Duration(seconds: 60),
              ));
          break;
        case RequestType.post:
          final data = body ?? <String, dynamic>{};
          print(data);
          response = await _dio.post(
            url,
            data: formData,
            options: Options(method: 'POST', headers: headers,
              responseType: ResponseType.json,),
          );

          break;
        case RequestType.put:
          final data = body ?? <String, dynamic>{};
          response = await _dio.put(
            url,
            data: formData,
            options: Options(method: 'PUT', headers: headers, responseType: ResponseType.json,),
          );
          break;
        case RequestType.delete:
          url = (isUrlAppend != null) ? '$url/$isUrlAppend' : url;
          url = (body != null)
              ? Uri.parse(url).replace(queryParameters: body).toString()
              : url;
          response = await _dio.delete(
            url,
            options: Options(method: 'DELETE', headers: headers),
          );
          break;
      }

      Picker.hideLoading();
      return ApiCustomResponse(
        statusCode: response.statusCode,
        headers: Map<String, dynamic>.from(response.headers.map),
        data: response.data,
      );
    } catch (e) {
      Picker.hideLoading();
      if (e is DioException) {
        return ApiCustomResponse(
          statusCode: e.response?.statusCode,
          headers: e.response?.headers.map,
          data: e.response?.data ?? {'error': 'An error occurred'},
        );
      }
      return ApiCustomResponse(
        statusCode: null,
        headers: null,
        data: {'error': e.toString()},
      );
    }
  }


//
}

class ApiCustomResponse {
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final dynamic data;

  ApiCustomResponse({this.statusCode, this.headers, this.data});
}

//RequestType
enum RequestType { get, post, put, delete }

//RequestTypeExtension
extension RequestTypeExtension on RequestType {
  String get name {
    switch (this) {
      case RequestType.get:
        return 'GET';
      case RequestType.post:
        return 'POST';
      case RequestType.put:
        return 'PUT';
      case RequestType.delete:
        return 'DELETE';
    }
  }
}