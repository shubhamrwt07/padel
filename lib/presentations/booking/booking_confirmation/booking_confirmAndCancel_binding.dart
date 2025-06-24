import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/booking_confirmation/booking_confirmAndCancel_controller.dart';

class BookingConfirmAndCancelBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(BookingConfirmAndCancelController());
  }

}