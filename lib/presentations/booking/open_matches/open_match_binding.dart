import '../../../presentations/booking/widgets/booking_exports.dart';
class OpenMatchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(OpenMatchesController());
  }
}