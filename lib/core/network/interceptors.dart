import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../configs/components/snack_bars.dart';
import '../../services/network/connectivity_service.dart';
import 'dio_client.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true));

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath');
    logger.d('Error type: ${err.error} \n'
        'Error message: ${err.message}');
    logger.d("TOKEN: ${storage.read('token')}");
    if (err.response?.statusCode == 401) {
      log("Not found");
    }
    // Check if it's a connectivity error
    else if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.error is Exception && err.error.toString().contains('SocketException')) {

      await _connectivityService.checkConnectivity();
    }
    else if (err.response != null) {
      SnackBarUtils.showErrorSnackBar(err.response?.data?['message'] ?? 'An error occurred');


    }
    else {
      SnackBarUtils.showErrorSnackBar(err.response?.data?['message'] ?? 'An error occurred');
    }

    handler.next(err);
  }



  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath');
    logger.d("TOKEN: ${storage.read('token')}");

    // Check for connectivity before making the request
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      // The connectivity service will show the snackbar
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection',
          type: DioExceptionType.connectionError,
        ),
        true,
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    logger.d('STATUSCODE: ${response.statusCode} \n '
        'STATUSMESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}');
    logger.d("TOKEN: ${storage.read('token')}");
    handler.next(response);
  }
}