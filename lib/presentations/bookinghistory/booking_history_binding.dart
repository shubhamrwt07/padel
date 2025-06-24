import 'package:get/get.dart';
import 'booking_history_controller.dart';
class  BookingHistoryBinding implements Bindings{
  @override
  void dependencies() {
    Get.put( BookingHistoryController());
  }
}