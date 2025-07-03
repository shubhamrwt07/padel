import 'package:padel_mobile/data/request_models/authentication_models/sign_up_model.dart';

import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../handler/logger.dart';

class SignUpRepository {
  static final SignUpRepository _instance = SignUpRepository._internal();
  final DioClient dioClient = DioClient();

  factory SignUpRepository() {
    return _instance;
  }

  SignUpRepository._internal();

  Future<SignUpModel> createAccount({
    required Map<String, dynamic> body,
  }) async {
    try {
      CustomLogger.logMessage(
        msg: "Sign up BODY:-> $body",
        level: LogLevel.info,
      );
      final response = await dioClient.post(AppEndpoints.signUp, data: body);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Account created: ${response.data}",
          level: LogLevel.info,
        );
        return SignUpModel.fromJson(response.data);
      } else {
        throw Exception(
          "Sign up failed with status code: ${response.statusCode}",
        );
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Login failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
}
