import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

import '../cart/cart_controller.dart';

class BookingBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(BookingController());
   Get.lazyPut(() => CartController());

  }
}