import 'dart:developer';
import 'package:dio/dio.dart';
import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/home_models/get_available_court.dart';
import '../../data/request_models/home_models/get_club_name_model.dart';
import '../../presentations/auth/forgot_password/widgets/forgot_password_exports.dart';

class HomeRepository {
  final DioClient dioClient = DioClient();

  Future<CourtsModel> fetchClubData({String limit = "10", required String page, String search = ""}) async {
     try {
      final url = "${AppEndpoints.getClub}$limit&page=$page&search=$search";

      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        debugPrint("Response Data: ${response.data}");
        return CourtsModel.fromJson(response.data);
      } else {
        ////
        throw
        Exception("Failed to load club data - status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("Dio Error: ${e.response?.statusMessage}");
        throw Exception("Server error: ${e.response?.statusCode}");
      } else {
        debugPrint("Dio Error: ${e.message}");
        throw Exception("Network error: ${e.message}");
      }
    }
  }
  Future<AvailableCourtModel> fetchAvailableCourtsById({
    required String id,
    required String time,
    required String date,
    required String day,
  }) async {
    final url = "${AppEndpoints.getActiveCourt}$id&day=$day";

    log("Fetching available courts by ID: $url");
    log("Time: $time, Date: $date, Day: $day");

    try {
      final response = await dioClient.get(
        url,

      );

      if (response.statusCode == 200) {
        debugPrint("Available Courts Response: ${response.data}");
        return AvailableCourtModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load available courts - status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("Dio Error: ${e.response?.data}");
        throw Exception("Server error: ${e.response?.statusMessage}");
      } else {
        debugPrint("Dio Network Error: ${e.message}");
        throw Exception("Network error: ${e.message}");
      }
    }
  }

}
