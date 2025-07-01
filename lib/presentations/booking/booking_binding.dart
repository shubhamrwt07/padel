import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookingBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(BookingController());
  }
}