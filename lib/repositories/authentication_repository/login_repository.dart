import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/authentication_models/login_model.dart';
import '../../handler/logger.dart';

class LoginRepository {
  static final LoginRepository _instance = LoginRepository._internal();
  final DioClient dioClient = DioClient();

  factory LoginRepository() {
    return _instance;
  }

  LoginRepository._internal();


  Future<LoginModel> loginUser({required Map<String,dynamic> body}) async {


    try {
      CustomLogger.logMessage(
        msg: "LOGIN BODY:-> $body",
        level: LogLevel.info,
      );
      final response = await dioClient.post(AppEndpoints.login, data: body);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Login successful: ${response.data}",
          level: LogLevel.info,
        );
        return LoginModel.fromJson(response.data);
      } else {
        throw Exception("Login failed with status code: ${response.statusCode}");
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