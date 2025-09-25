import 'dart:developer';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/open matches/add_player_to_open_match_model.dart';
import '../../data/request_models/open matches/create_user_for_open_match_model.dart';
import '../../data/response_models/openmatch_model/all_open_matches.dart';
import '../../data/response_models/openmatch_model/open_match_model.dart';
import '../../handler/logger.dart';
class OpenMatchRepository {
  static final OpenMatchRepository _instance = OpenMatchRepository._internal();
  final DioClient dioClient = DioClient();

  factory OpenMatchRepository() {
    return _instance;
  }

  OpenMatchRepository._internal();

  /// Create a new match
  Future<OpenMatchModel> createMatch({
    required dynamic data,
  }) async {
    try {
      final response = await dioClient.post(
        AppEndpoints.createMatches,
        data: data,
      );
      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Match created successfully: ${response.data}",
          level: LogLevel.info,
        );

        return OpenMatchModel.fromJson(response.data);
      } else {
        throw Exception("Match creation failed. Status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Match creation failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  Future<AllOpenMatches> getMatchesByDateTime({
    required String matchDate,
    required String matchTime,
    required String cubId
  }) async {
    try {
      // Encode matchTime properly (space → %20)
      final encodedTime = Uri.encodeComponent(matchTime);

      final url =
          "${AppEndpoints.getOpenMatches}?clubId=$cubId&matchDate=$matchDate&matchTime=$encodedTime";

      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        return AllOpenMatches.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch matches. Status: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<OpenMatchDetailsModel> getParticularMatch(String clubId) async {
    log("mes 2");
    try {
      log(AppEndpoints.getParticularMatch);
      final response = await dioClient.get(AppEndpoints.getParticularMatch);
      log("mes 3 ${response.data} ");

      return  OpenMatchDetailsModel.fromJson(response.data);



    } catch (e, st) {
      log("mes 4 ");
      CustomLogger.logMessage(
        msg: "details error 2: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  ///Create User For Open Match Api--------------------------------------------------------
  Future<CreateUserForOpenMatchModel?> createUserForOpenMatch({
    required Map<String, dynamic> body,
  }) async {
    try {
      CustomLogger.logMessage(
        msg: "Create User For Open Match request body: $body",
        level: LogLevel.info,
      );

      final response = await dioClient.post(
        AppEndpoints.createUserForOpenMatch,
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Create User For Open Match Success: ${response.data}",
          level: LogLevel.info,
        );
        return CreateUserForOpenMatchModel.fromJson(response.data);
      } else {
        throw Exception("Create User For Open Match Failed with status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Create User For Open Match failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  ///Add Player For Open Match Api--------------------------------------------------------
  Future<AddPlayerToOpenMatchModel?> addPlayerForOpenMatch({
    required Map<String, dynamic> body,
  }) async {
    try {
      CustomLogger.logMessage(
        msg: "Add Player For Open Match request body: $body",
        level: LogLevel.info,
      );

      final response = await dioClient.put(
        AppEndpoints.addUserForOpenMatch,
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Add Player For Open Match Success: ${response.data}",
          level: LogLevel.info,
        );
        return AddPlayerToOpenMatchModel.fromJson(response.data);
      } else {
        throw Exception("Add Player For Open Match Failed with status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Add Player For Open Match failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

}
