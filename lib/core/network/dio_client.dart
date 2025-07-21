import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../handler/logger.dart';
import 'interceptors.dart';

final storage = GetStorage();

class DioClient {
  late final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': 'Bearer ${storage.read('token')}',
            'Content-Type': 'application/json; charset=UTF-8',
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
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      CustomLogger.logMessage(
        msg: "LOG FROM DIO CLIENT $e",
        level: LogLevel.error,
      );
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
      CustomLogger.logMessage(
        msg: "PUT request failed: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  // DELETE METHOD
  Future<Response> delete(
    String url, {
    required Map<String, dynamic> data,
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
      return response;
    } catch (e) {
      CustomLogger.logMessage(
        msg: "DELETE request failed: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  // MULTIPART FILE UPLOAD METHOD - FIXED
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

      // Create FormData with dynamic fields
      Map<String, dynamic> formDataMap = {};

      // Add data fields if provided
      if (dataFields != null) {
        formDataMap.addAll(dataFields);
      }

      // Add the file with the specified field name
      String fileName = file.path.split('/').last;
      formDataMap[fieldName] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );

      FormData formData = FormData.fromMap(formDataMap);

      CustomLogger.logMessage(
        msg:
            "Uploading File: $fileName with fields: ${dataFields?.keys.join(', ')}",
        level: LogLevel.info,
      );

      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${storage.read('token')}',
            // Remove Content-Type header - Dio will set it automatically for multipart
          },
        ),
        onSendProgress: onSendProgress,
      );

      CustomLogger.logMessage(
        msg: "Upload Successful: ${response.statusCode}",
        level: LogLevel.info,
      );
      return response;
    } catch (e) {
      CustomLogger.logMessage(msg: "Upload Error: $e", level: LogLevel.error);
      rethrow;
    }
  }

  // Alternative method for multiple files
  Future<Response> uploadMultipleFiles(
    String url, {
    required List<String> filePaths,
    required String fieldName,
    Map<String, dynamic>? dataFields,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {};

      // Add data fields if provided
      if (dataFields != null) {
        formDataMap.addAll(dataFields);
      }

      // Add multiple files
      List<MultipartFile> files = [];
      for (String filePath in filePaths) {
        final file = File(filePath);
        String fileName = file.path.split('/').last;
        files.add(await MultipartFile.fromFile(file.path, filename: fileName));
      }

      formDataMap[fieldName] = files;
      FormData formData = FormData.fromMap(formDataMap);

      CustomLogger.logMessage(
        msg: "Uploading ${filePaths.length} files",
        level: LogLevel.info,
      );

      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer ${storage.read('token')}'},
        ),
        onSendProgress: onSendProgress,
      );

      CustomLogger.logMessage(
        msg: "Multiple files upload successful: ${response.statusCode}",
        level: LogLevel.info,
      );
      return response;
    } catch (e) {
      CustomLogger.logMessage(
        msg: "Multiple files upload error: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }
  // Add this method to your DioClient class

// MULTIPART FILE UPLOAD METHOD WITH PUT SUPPORT
  Future<Response> uploadFileWithPut(
      String url, {
        Options? options,
        required String filePath,
        required String fieldName,
        Map<String, dynamic>? dataFields,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final file = File(filePath);

      // Create FormData with dynamic fields
      Map<String, dynamic> formDataMap = {};

      // Add data fields if provided
      if (dataFields != null) {
        formDataMap.addAll(dataFields);
      }

      // Add the file with the specified field name
      String fileName = file.path.split('/').last;
      formDataMap[fieldName] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );

      FormData formData = FormData.fromMap(formDataMap);

      CustomLogger.logMessage(
        msg: "Uploading File with PUT: $fileName with fields: ${dataFields?.keys.join(', ')}",
        level: LogLevel.info,
      );

      final Response response = await _dio.put(  // Using PUT instead of POST
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${storage.read('token')}',
            // Remove Content-Type header - Dio will set it automatically for multipart
          },
        ),
        onSendProgress: onSendProgress,
      );

      CustomLogger.logMessage(
        msg: "Upload with PUT Successful: ${response.statusCode}",
        level: LogLevel.info,
      );
      return response;
    } catch (e) {
      CustomLogger.logMessage(
        msg: "Upload with PUT Error: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}
