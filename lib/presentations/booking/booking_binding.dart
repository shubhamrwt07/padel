import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/booking_controller.dart';

class BookingBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(BookingController());
  }
}