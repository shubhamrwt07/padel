import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../handler/logger.dart';
 import 'interceptors.dart';
final storage=GetStorage();
class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
    BaseOptions(
      headers: {
        'Authorization': 'Bearer ${storage.read('token')}',
        'Content-Type': 'application/json; charset=UTF-8'
      },
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.addAll([LoggerInterceptor()]);

  // GET METHOD
  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      CustomLogger.logMessage(msg: "URL => $url", level: LogLevel.debug);
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // POST METHOD
  Future<Response> post(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      CustomLogger.logMessage(
          msg: "LOG FROM DIO CLIENT $e", level: LogLevel.error);
      rethrow;
    }
  }

  // PUT METHOD
  Future<Response> put(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
      String url, {
        required Map<String, dynamic>  data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // MULTIPART FILE UPLOAD METHOD
  Future<Response> uploadFile(
      String url, {
        Options? options,

        required String filePath,
        required String fieldName,
        Map<String, dynamic>? dataFields,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final file = File(filePath);
      FormData formData = FormData.fromMap({
        "name": "John Doe",
        "email": "johndoe@example.com",
        "profile_picture": await MultipartFile.fromFile(file.path, filename: "image.png"),
      });


      CustomLogger.logMessage(msg: "Uploading File: $formData", level: LogLevel.info);




      final Response response = await _dio.post(

        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${storage.read('token')}',
            'Content-Type': 'application/json; charset=UTF-8'
          },
          contentType: 'multipart/form-data',

        ),
        onSendProgress: onSendProgress,
      );

      CustomLogger.logMessage(msg: "Upload Successful: ${response.data}", level: LogLevel.info);
      return response;
    } catch (e) {
      CustomLogger.logMessage(msg: "Upload Error: $e", level: LogLevel.error);
      rethrow;
    }
  }

}
