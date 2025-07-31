import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

import 'americano_controller.dart';

class AmericanoBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(AmericanoController());
  }
}