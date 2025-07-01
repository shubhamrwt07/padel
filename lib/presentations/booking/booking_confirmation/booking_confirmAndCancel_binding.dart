import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookingConfirmAndCancelBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(BookingConfirmAndCancelController());
  }

}