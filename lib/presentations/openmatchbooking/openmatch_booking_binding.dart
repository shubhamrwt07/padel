import 'package:padel_mobile/presentations/splash/widgets/splash_exports.dart';

import 'openmatch_booking_controller.dart';

class OpenMatchBookingBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(OpenMatchBookingController());
  }

}