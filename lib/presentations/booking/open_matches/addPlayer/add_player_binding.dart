import '../../widgets/booking_exports.dart';
class AddPlayerBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(AddPlayerController());
  }

}