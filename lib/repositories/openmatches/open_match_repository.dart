import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/response_models/cart/cart_items_model.dart';
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

  /// Get all open matches
  Future<AllOpenMatchesModel> getAllOpenMatches() async {
    try {
      final response = await dioClient.get(AppEndpoints.getAllMatches);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Cart items fetched successful: ${response.data}",
          level: LogLevel.info,
        );
        return AllOpenMatchesModel.fromJson(response.data);
      } else if(response.statusCode == 404) {
        return AllOpenMatchesModel.fromJson(response.data);

      }else{
        throw Exception("Error");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Cart items failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

}
