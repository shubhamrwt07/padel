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
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 20),
    ),
  ) {
    _dio.interceptors.addAll([
      LoggerInterceptor(),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json; charset=UTF-8';
          return handler.next(options);
        },
      ),
    ]);
  }

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
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
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
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // MULTIPART FILE UPLOAD METHOD
  Future<Response> uploadFile(
      String url, {
        required String filePath,
        required String fieldName,
        Map<String, dynamic>? dataFields,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final file = File(filePath);
      final token = storage.read('token');

      FormData formData = FormData.fromMap({
        if (dataFields != null) ...dataFields,
        fieldName: await MultipartFile.fromFile(file.path, filename: "image.png"),
      });

      CustomLogger.logMessage(
        msg: "Uploading File: $formData",
        level: LogLevel.info,
      );

      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: onSendProgress,
      );

      CustomLogger.logMessage(
        msg: "Upload Successful: ${response.data}",
        level: LogLevel.info,
      );

      return response;
    } catch (e) {
      CustomLogger.logMessage(
        msg: "Upload Error: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}