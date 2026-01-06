import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:padel_mobile/data/response_models/get_all_slot_prices_of_court_model.dart';
import 'package:padel_mobile/data/response_models/get_courts_by_duration_model.dart';
import 'package:padel_mobile/data/response_models/get_location_maps_model.dart';
import 'package:padel_mobile/data/response_models/get_register_club_model.dart';
import 'package:padel_mobile/handler/logger.dart';
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
        log("Response Data: ${response.data}");
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

  Future<GetAllActiveCourtsForSlotWiseModel> fetchAvailableCourtsSlotWise({
    required String registerClubId,       // club id
    required String day,
     String? date,
    String? duration
  }) async {
    String url = "${AppEndpoints.getAllActiveCourtsForSlotWise}register_club_id=$registerClubId&day=$day&date=$date&duration=$duration";

    try {
      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        debugPrint("Available Courts Responsedfr: ${response.data}");
        return GetAllActiveCourtsForSlotWiseModel.fromJson(response.data);
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

  ///Get Register Club Data-----------------------------------------------------
  Future<GetRegisterClubModel> getRegisterClub({required String clubId}) async {
    try {
      final url = "${AppEndpoints.getRegisterClub}clubId=$clubId";

      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        log("Response Register Club Data: ${response.data}");
        return GetRegisterClubModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load Register Club data - status code: ${response.statusCode}");
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

  ///Get Map Location-----------------------------------------------------------
  Future<GetLocationMapsModel> getLocationMaps({required String address}) async {
    try {
      final url = "${AppEndpoints.getLocationMaps}address=$address";

      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        log("Response Maps Location Data: ${response.data}");
        return GetLocationMapsModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load Maps Location data - status code: ${response.statusCode}");
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

  ///Get All Slot Prices Of Court------------------------------------------------
  Future<GetAllSlotPricesOfCourtModel> getAllSlotPricesOfCourt({required registerClubId,required duration,required day,required timePeriod}) async {
    try {
      final response = await dioClient.get("${AppEndpoints.getAllSlotPricesOfCourt}register_club_id=$registerClubId&duration=$duration&day=$day&timePeriod=$timePeriod",);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Get All Slot Prices Of Court Data: ${response.data}",
          level: LogLevel.info,
        );
        return GetAllSlotPricesOfCourtModel.fromJson(response.data);
      } else {
        throw Exception("Get All Slot Prices Of Court Data failed: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Get All Slot Prices Of Court Data failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  ///Get Courts By Duration Court------------------------------------------------
  Future<GetCourtsByDurationModel> getCourtsByDuration({
    required String duration,
    required String date,
    required String time
  }) async {
    try {
      final response = await dioClient.get("${AppEndpoints.getCourtsByDuration}duration=$duration&date=$date&time=$time",);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Get Courts By Durationt Data: ${response.data}",
          level: LogLevel.info,
        );
        return GetCourtsByDurationModel.fromJson(response.data);
      } else {
        throw Exception("Get Courts By Duration Data failed: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Get Courts By Duration Data failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
}
