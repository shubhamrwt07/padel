import 'package:get/get.dart';
import 'package:padel_mobile/presentations/support/support_controller.dart';


class SupportBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(SupportController());
  }
}