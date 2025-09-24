
import 'package:logger/logger.dart';

enum LogLevel { error, info, debug, warning, trace }
class CustomLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0, colors: false, printEmojis: true,lineLength: 500,noBoxingByDefault: true,));

  static void logMessage({required dynamic msg, required LogLevel level, dynamic error, StackTrace? st}) {
    switch (level) {
      case LogLevel.error:
        _logger.e(msg, error: error, stackTrace: st,time: DateTime.now());
        break;
      case LogLevel.info:
        _logger.i(msg,time: DateTime.now());
        break;
      case LogLevel.debug:
        _logger.d(msg,time: DateTime.now());
        break;
      case LogLevel.warning:
        _logger.w(msg,time: DateTime.now());
        break;
      case LogLevel.trace:
        _logger.t(msg, stackTrace: st, error: error,time: DateTime.now());
        break;
    }
  }
}
