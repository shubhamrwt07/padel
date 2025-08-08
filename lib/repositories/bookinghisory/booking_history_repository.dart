import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/booking/boking_history_model.dart';
import '../../handler/logger.dart';

class BookingHistoryRepository {
  static final BookingHistoryRepository _instance = BookingHistoryRepository._internal();
  final DioClient dioClient = DioClient();

  factory BookingHistoryRepository() {
    return _instance;
  }

  BookingHistoryRepository._internal();

  Future<BookingHistoryModel> getBookingHistory({required String type}) async {
    try {
      print("Making API call for type: $type");
      print("Endpoint: ${AppEndpoints.bookingHistory}");

      final response = await dioClient.get(
        AppEndpoints.bookingHistory,
        queryParameters: {'type': type},
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Booking history fetched: ${response.data}",
          level: LogLevel.info,
        );

        final model = BookingHistoryModel.fromJson(response.data);
        print("Parsed model bookings count: ${model.bookings?.length ?? 0}");
        return model;
      } else {
        throw Exception("Failed to fetch booking history. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Repository error: $e");
      CustomLogger.logMessage(
        msg: "Error fetching booking history: $e",
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}
