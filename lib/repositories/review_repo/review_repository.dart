import 'package:padel_mobile/core/endpoitns.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/request_models/create_review_model.dart';
import 'package:padel_mobile/data/response_models/get_review_model.dart';
import 'package:padel_mobile/handler/logger.dart';


class ReviewRepository {
  final DioClient dioClient = DioClient();

  ///Get Review-----------------------------------------------------------------
  Future<GetReviewModel> getReview() async {
    try {
      final response = await dioClient.get(
        AppEndpoints.getReview,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Get-Review Data: ${response.data}",
          level: LogLevel.info,
        );
        return GetReviewModel.fromJson(response.data);
      } else {
        throw Exception("Get-Review failed: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Get-Review failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  ///Create Review--------------------------------------------------------------
  Future<CreateReviewModel> createReview({
    required Map<String, dynamic> data,
  }) async {
    CustomLogger.logMessage(
      msg: "Review Body: ${data}",
      level: LogLevel.info,
    );
    try {
      final response = await dioClient.post(
        AppEndpoints.createReview,
        data: data,
      );
      CustomLogger.logMessage(
        msg: "Review Body: ${response.data}",
        level: LogLevel.info,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Review created successfully: ${response.data}",
          level: LogLevel.info,
        );

        return CreateReviewModel.fromJson(response.data);
      } else {
        throw Exception("Review failed with status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Review failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
}